import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import { LuauState } from 'luau-web';

const read = (path) => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');
const state = await LuauState.createAsync();
try {
  const source = read('Nullx11.client.luau');
  state.loadstring(source, 'Nullx11.client.luau', true);
  const logicSource = source.replace('StartupAnimation = true', 'StartupAnimation = false');
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
  const introChecks = state.loadstring(
    read('tests/roblox-mock.luau') + '\nlocal function runLoader()\n' + source
      + '\nend\nlocal function runReducedLoader()\n'
      + source.replace('ReducedMotion = false', 'ReducedMotion = true')
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
