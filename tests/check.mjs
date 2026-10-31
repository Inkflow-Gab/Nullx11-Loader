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
  const brainrotChecks = read('tests/game-port-contracts.luau').split('-- Insert the actual modules')[0]
    + read('tests/brainrot-contracts.luau')
      .replace('-- @CHILLI_MODULE', module('makeChilliAdapter', 'src/ui/ChilliAdapter.luau'))
      .replace('-- @OWNED_RUNTIME', module('makeOwnedRuntime', 'src/games/OwnedRuntime.luau'))
      .replace('-- @EXECUTION_STATE', module('makeExecutionState', 'src/ui/ExecutionState.luau'));
  console.log(...await state.loadstring(brainrotChecks, 'brainrot-module-contracts', true)());
  const coreChecks = read('tests/roblox-mock.luau') + '\n' + read('tests/player-tools-mock.luau') + '\n'
    + read('tests/shared-ui-core.luau').replace('-- @SHARED_UI', `local function createNullx11UI(scope)\n${read('src/ui/Nullx11UI.luau')}\nend`);
  console.log(...await state.loadstring(coreChecks, 'shared-ui-core-contracts', true)());
  assert.ok(source.trimEnd().split('\n').length > 15000, 'meaningful main script exceeds requested minimum');
  assert.equal((source.match(/local function createNullx11UI\(scope\)/g) || []).length, 1, 'one shared UI factory, no repeated padding');
  assert.equal(manifest.Scripts.length, 7);
  assert.deepEqual(manifest.Scripts.filter(e => e.GamePlaceId).map(e => e.GamePlaceId), [9051087354, 107535308163741, 118805555015549]);
  for (const entry of manifest.Scripts) {
    const bundle = read(`scripts/${entry.File}`);
    assert.ok(!/sirius\.menu|rscripts\.net\/api|Roblox-Scripts[^"\n]*(ui|loader)\.lua/.test(bundle), 'no telemetry or upstream UI/loader execution');
    assert.ok(!bundle.includes('Nullx11.client.luau'), 'selected game bundle must never load the main client');
    assert.ok(bundle.includes(['egg', 'stealabrainrot', 'ttk', 'money'].includes(entry.Id) ? 'if not compatible() then' : 'if game.PlaceId ~= entry.GamePlaceId then'), 'compatibility gate before controller startup');
    assert.ok(!read('src/games/BundleLauncher.luau').includes('TeleportService'));
    assert.ok(!bundle.includes('silencedevs/SilenceScripts'), 'no remote WindUI');
    assert.ok(Buffer.byteLength(bundle, 'utf8') < 2097152, 'bundle fits reviewed source size budget');
  }
  const brainrot = read('src/games/StealABrainrot.luau');
  assert.ok(!/tienkhanh1|webhooks|request_|loadstring|queue_on_teleport|queueonteleport|ChilliLibrary\/configs|Default = true|BlockTools/.test(brainrot), 'no exfiltration, upstream loader, auto-enable defaults or startup tool-block bypass');
  assert.equal((brainrot.match(/:Connect\(/g) || []).length, 200);
  assert.equal((brainrot.match(/runtime.Track\(/g) || []).length, 200, 'every source subscription is owned');
  assert.equal((brainrot.match(/runtime.Cleanup\(/g) || []).length, 9, 'restore callbacks do not depend on deferred event timing');
  assert.ok(read('src/ui/BrandIcons.luau').includes('brain ='));
  assert.ok(!/Anim.Loop|RenderStepped/.test(read('src/ui/ExecutionView.luau')), 'loading screen has no idle frame loop');
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
  const browserChecks=read('tests/roblox-mock.luau')+'\n'+read('tests/script-browser.luau')
    .replace('-- @BROWSER_MODEL', 'makeScriptLibraryModel=(function()\n'+read('src/ui/ScriptLibraryModel.luau')+'\nend)()')
    .replace('-- @BROWSER_VIEW',read('src/ui/ScriptBrowser.luau'));
  console.log(...await state.loadstring(browserChecks,'script-browser',true)());
  const ttkSource=read('src/games/TTKTesting.luau');
  assert.ok(!/hookfunction|newcclosure|SessionTelemetry|HttpGet|loadstring|WaitForChild|task\.spawn/.test(ttkSource), 'TTK has no telemetry hijack, remote UI or startup discovery worker');
  assert.equal((ttkSource.match(/context\.Connect\(/g)||[]).length,6,'all TTK source subscriptions are session-owned');
  const moneySource=read('src/games/MoneyPerClick.luau');
  assert.equal((moneySource.match(/task\.spawn\(/g)||[]).length,2,'at most one route worker and one dispatcher');
  assert.ok(!/HttpGet|loadstring|WaitForChild|while true/.test(moneySource),'no upstream UI, indefinite dependency wait or immortal worker');
  const newPorts = read('tests/game-port-contracts.luau').split('-- Insert the actual modules')[0]
    + read('tests/new-game-ports.luau')
      .replace('-- @MODULES', [module('makeAdapter','src/ui/Gen2Adapter.luau'), module('makeSession','src/games/Context.luau'), module('makePatches','src/games/OwnedPatches.luau'), module('makeMoneyData','src/games/MoneyData.luau').replace('local makeMoneyData=', 'local moneyData=' ) + '\nlocal function makeMoneyData() return moneyData end', between(read('scripts/Nullx11-TTKTesting.luau'),'local function compatible()', 'if not compatible() then').replace('function compatible()', 'function ttkCompatible()'), between(read('scripts/Nullx11-MoneyPerClick.luau'),'local function compatible()', 'if not compatible() then').replace('function compatible()', 'function moneyCompatible()')].join('\n'))
      .replace('-- @TTK',read('src/games/TTKTesting.luau'))
      .replace('-- @MONEY',read('src/games/MoneyPerClick.luau'));
  console.log(...await state.loadstring(newPorts,'new-game-ports',true)());
  assert.ok(read('assets/fonts/OFL.txt').includes('SIL OPEN FONT LICENSE'));
  console.log('PASS: seven actual controllers, place/module gates, source/default-state/budget/size, static icon and font license checks');
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
  const executionFlow = read('tests/roblox-mock.luau')
    + '\nlocal executionFactory, loadstring\n' + module('makeExecutionState', 'src/ui/ExecutionState.luau')
    + '\nlocal function runLoader()\n' + logicSource.replace('local progress = playerToolsBridge.BeginExecution\n\t\t\tand playerToolsBridge.BeginExecution(entry.Name)', 'local progress = executionFactory(entry.Name)')
    + '\nend\n' + read('tests/execution-flow.luau');
  assert.ok(executionFlow.includes('local progress = executionFactory(entry.Name)'), 'execution test uses actual catalog path');
  console.log(...await state.loadstring(executionFlow, 'execution-integration', true)());
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
