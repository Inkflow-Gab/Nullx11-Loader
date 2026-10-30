import { readFileSync } from 'node:fs';
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
