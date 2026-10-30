import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import { LuauState } from 'luau-web';

const read = (path) => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');
const state = await LuauState.createAsync();
try {
  const source = read('Nullx11.client.luau');
  state.loadstring(source, 'Nullx11.client.luau', true);
  const logicSource = source.replace('StartupAnimation = true', 'StartupAnimation = false').replace('EnhancedWorkspace = true', 'EnhancedWorkspace = false');
  state.loadstring(read('bootstrap.luau'), 'bootstrap.luau', true);
  console.log('PASS: client and bootstrap Luau compilation');
  console.log(`Main client: ${source.trimEnd().split('\n').length} lines`);
  state.loadstring(read('diagnostics/RobloxRuntimeCheck.client.luau'), 'native-runtime-diagnostic', true);
  const manifest = JSON.parse(read('scripts/manifest.json'));
  assert.equal(manifest.Version, 1);
  assert.ok(Array.isArray(manifest.Scripts) && manifest.Scripts.length <= 64);
  const ids = new Set();
  for (const entry of manifest.Scripts) {
    assert.ok(typeof entry.Id === 'string' && entry.Id.length > 0 && !ids.has(entry.Id));
    ids.add(entry.Id);
    assert.ok(typeof entry.File === 'string' && /^[\w/.-]+\.luau$/.test(entry.File)
      && !entry.File.startsWith('/') && !entry.File.includes('..'));
    state.loadstring(read(`scripts/${entry.File}`), `library/${entry.File}`, true);
  }
  console.log('PASS: repository manifest JSON and published-script compilation; native Roblox diagnostic compiles (not executed here)');
  const module = (name, path) => `local ${name}=(function()\n${read(path)}\nend)()`;
  const portContracts = read('tests/game-port-contracts.luau')
    .replace('-- @PORT_MODULES', module('makeAdapter', 'src/ui/Gen2Adapter.luau') + '\n' + module('makeSession', 'src/games/Context.luau'))
    .replace('-- @LAUNCH_MODULE', module('wrongPlace', 'src/games/BundleLauncher.luau'))
    .replace('-- @WIND_MODULE', module('makeWindAdapter', 'src/ui/WindAdapter.luau'))
    .replace('-- @WORKSPACE_TEARDOWN', read('src/ui/Workspace.luau').match(/connect\(gui\.Destroying, function\(\)[\s\S]*?\n\s*end\)/)[0]);
  const portResults = await state.loadstring(portContracts, 'game-port-contracts', true)();
  console.log(portResults[0]);
  const coreChecks = read('tests/roblox-mock.luau') + '\n' + read('tests/player-tools-mock.luau') + '\n'
    + read('tests/shared-ui-core.luau').replace('-- @SHARED_UI', `local function createNullx11UI(scope)\n${read('src/ui/Nullx11UI.luau')}\nend`);
  console.log(...await state.loadstring(coreChecks, 'shared-ui-core-contracts', true)());
  assert.ok(source.trimEnd().split('\n').length > 15000, 'meaningful main script exceeds requested minimum');
  assert.equal((source.match(/local function createNullx11UI\(scope\)/g) || []).length, 1, 'one shared UI factory, no repeated padding');
  assert.equal(manifest.Scripts.length, 4);
  assert.deepEqual(manifest.Scripts.filter(e => e.GamePlaceId).map(e => e.GamePlaceId), [9051087354, 107535308163741, 118805555015549]);
  for (const entry of manifest.Scripts) {
    const bundle = read(`scripts/${entry.File}`);
    assert.ok(!/sirius\.menu|rscripts\.net\/api|Roblox-Scripts[^"\n]*(ui|loader)\.lua/.test(bundle), 'no telemetry or upstream UI/loader execution');
    assert.ok(!bundle.includes('Nullx11.client.luau'), 'selected game bundle must never load the main client');
    assert.ok(bundle.includes(entry.Id === 'egg' ? 'if not compatible() then' : 'if game.PlaceId ~= entry.GamePlaceId then'), 'compatibility gate before controller startup');
    assert.ok(!read('src/games/BundleLauncher.luau').includes('TeleportService'));
    assert.ok(!bundle.includes('silencedevs/SilenceScripts'), 'no remote WindUI');
    assert.ok(Buffer.byteLength(bundle, 'utf8') < 2097152, 'bundle fits reviewed source size budget');
  }
  const huss = read('src/games/Huss.luau');
  for (const setting of ['RunnerEnabled','CatcherChase','AutoGems','AutoRevive','AutoTackle','AutoMelee']) {
    assert.ok(huss.includes(`${setting} = false`), `${setting} starts off`);
    assert.ok(huss.includes(`Value = Settings.${setting}`), `${setting} control reflects actual state`);
  }
  const forge = read('src/games/Forge.luau');
  const arrival = forge.slice(forge.indexOf('function Nullx11Forge.Session.PrepareArrival()'), forge.indexOf('function Nullx11Forge.Session.Rejoin()'));
  const arrivalTest = read('tests/forge-teleport.luau').replace('-- @FORGE_ARRIVAL', arrival);
  console.log(...await state.loadstring(arrivalTest, 'forge-arrival-contracts', true)());
  assert.ok(forge.includes('SuperLootAura = false') && forge.includes('ExecuteAfterHop = false'));
  assert.ok(!/:FireServer\(|:InvokeServer\(|\.FireServer,|\.InvokeServer,/.test(forge), 'explicit forge remote calls use cancellation-aware budget');
  assert.ok(!read('src/ui/Nullx11UI.luau').includes('logo_halloween'));
  const floatBuild = read('src/ui/Nullx11UI.luau').split('function Float.Build()')[1].split('function Float.Render()')[0];
  assert.ok(!/Anim\.(Loop|Bump|CoinPop)/.test(floatBuild), 'restore icon is not animated');
  assert.ok(read('src/ui/Nullx11UI.luau').includes('Nullx11Prism'));
  const egg = read('src/games/StealAnEgg.luau');
  assert.ok(!egg.includes('SetAutoLoad') && egg.includes('context.RegisterCleanup'));
  assert.ok(egg.includes('runtime:Destroy()\n\terror('), 'failed module startup cleans up');
  const between = (text, start, end) => text.slice(text.indexOf(start), text.indexOf(end, text.indexOf(start)));
  const helpers = between(egg, 'function utils.remember(', 'function utils.mark(')
    + between(egg, 'function utils.esp()', 'function utils.eggHolders()')
    + between(egg, 'function utils.applyCharacter()', 'function utils.antiTrap()');
  const eggChecks = read('tests/egg-idle.luau')
    .replace('-- @EGG_HELPERS', helpers)
    .replace('-- @EGG_COMPATIBLE', between(read('scripts/Nullx11-StealAnEgg.luau'), 'local function compatible()', 'if not compatible() then'));
  console.log(...await state.loadstring(eggChecks, 'egg-idle-contracts', true)());
  assert.ok(read('assets/fonts/OFL.txt').includes('SIL OPEN FONT LICENSE'));
  console.log('PASS: four actual controllers, place/module gates, source/default-state/budget/size, static icon and font license checks');
  const run = state.loadstring(
    read('tests/roblox-mock.luau') + '\nlocal function runLoader()\n' + logicSource
      + '\nend\n' + read('tests/interactions.luau'),
    'interaction-smoke', true,
  );
  console.log(...await run());
  const studioChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\nlocal function runLoader()\n' + logicSource
      + '\nend\n' + read('tests/studio.luau'),
    'studio-smoke', true,
  );
  console.log(...await studioChecks());
  const playerChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\n' + read('tests/player-tools-mock.luau')
      + '\nlocal function runLoader()\n' + logicSource
      + '\nend\n' + read('tests/player-tools.luau'),
    'player-tools-smoke', true,
  );
  console.log(...await playerChecks());
  const polishChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\n' + read('tests/player-tools-mock.luau')
      + '\nlocal loadstring\nlocal function runLoader()\n' + logicSource
      + '\nend\n' + read('tests/polish.luau'),
    'polish-smoke', true,
  );
  console.log(...await polishChecks());
  const gameChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\nlocal sessionEnvironment = {}\nlocal getgenv = function() return sessionEnvironment end\nlocal loadstring, queue_on_teleport\nlocal function runLoader()\n' + logicSource
      + '\nend\n' + read('tests/game-launcher.luau'),
    'game-launcher-smoke', true,
  );
  const gameResults = await gameChecks();
  console.log(gameResults[0]);
  const introChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\nlocal function runLoader()\n' + source.replace('EnhancedWorkspace = true', 'EnhancedWorkspace = false')
      + '\nend\nlocal function runReducedLoader()\n'
      + source.replace('ReducedMotion = false', 'ReducedMotion = true').replace('EnhancedWorkspace = true', 'EnhancedWorkspace = false')
      + '\nend\n' + read('tests/intro.luau'),
    'intro-smoke', true,
  );
  console.log(...await introChecks());
  const bootstrapChecks = state.loadstring(
    'local function runBootstrap(loadstring, game, warn)\n' + read('bootstrap.luau')
      + '\nend\n' + read('tests/bootstrap-checks.luau'),
    'bootstrap-smoke', true,
  );
  console.log(...await bootstrapChecks());
} finally {
  state.destroy();
}
