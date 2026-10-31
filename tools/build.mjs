import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { resolve } from 'node:path';

const root = resolve(import.meta.dirname, '..');
const read = (file) => readFileSync(resolve(root, file), 'utf8').trimEnd();
const check = process.argv.includes('--check');
const ui = read('src/ui/Nullx11UI.luau')
  .replace('-- @NULLX11_SCRIPT_BROWSER', `local makeScriptLibraryModel=(function()\n${read('src/ui/ScriptLibraryModel.luau')}\nend)()\n${read('src/ui/ScriptBrowser.luau')}`)
  .replace('-- @NULLX11_BRAND_ICONS', read('src/ui/BrandIcons.luau'))
  .replace('-- @NULLX11_EXECUTION_VIEW', `local makeExecutionState = (function()\n${read('src/ui/ExecutionState.luau')}\nend)()\n${read('src/ui/ExecutionView.luau')}`);
const adapter = read('src/ui/Gen2Adapter.luau');
const chilli = read('src/ui/ChilliAdapter.luau');
const ownedRuntime = read('src/games/OwnedRuntime.luau');
const wind = read('src/ui/WindAdapter.luau');
const session = read('src/games/Context.luau');
const launcher = read('src/games/BundleLauncher.luau');
const catalog = JSON.parse(read('src/games/catalog.json'));
const quote = (s) => JSON.stringify(s);
function lua(value) {
  if (typeof value === 'string') return quote(value);
  if (typeof value === 'number') return String(value);
  if (Array.isArray(value)) return `{${value.map(lua).join(',')}}`;
  return `{${Object.entries(value).map(([k,v]) => `${k}=${lua(v)}`).join(',')}}`;
}
const factory = `local function createNullx11UI(scope)\n${ui}\nend`;
const module = (name, source) => `local ${name} = (function()\n${source}\nend)()`;
function formatted(source) {
  let content = source + '\n';
  // StyLua can require a second pass after embedding an already-formatted module
  // at a deeper indentation. Generate a stable fixed point, not a stale artifact.
  for (let pass = 0; pass < 5; pass++) {
    const result = spawnSync(resolve(root, 'node_modules/.bin/stylua'), ['--syntax', 'Luau', '-'], {
      cwd: root, input: content, encoding: 'utf8', maxBuffer: 16 * 1024 * 1024,
    });
    if (result.status !== 0) throw new Error(result.stderr || 'StyLua build formatting failed');
    if (result.stdout === content) return content;
    content = result.stdout;
  }
  throw new Error('Generated formatting failed to converge');
}

function output(file, source) {
  const content = file.endsWith('.luau') ? formatted(source) : source;
  if (check) {
    if (readFileSync(resolve(root,file),'utf8') !== content) throw new Error(`Generated file is stale: ${file}; run npm run build`);
  } else writeFileSync(resolve(root,file),content);
}
const banner = '-- GENERATED from src/ by tools/build.mjs. Edit the sources, then run npm run build.\n';
let main = read('src/loader.luau')
  .replace('-- @NULLX11_UI_FACTORY', factory)
  .replace('-- @NULLX11_CATALOG', `if CONFIG.EnhancedWorkspace then\ncatalog.Entries=catalog.Validate(${lua(catalog)})\ncatalog.Loaded=true\nend`)
  .replace('-- @NULLX11_WORKSPACE', read('src/ui/Workspace.luau'));
output('Nullx11.client.luau', main.replace('--!strict', `--!strict\n${banner}`));
for (const entry of catalog.Scripts) {
  const name = ({rosu:'Rosu',huss:'Huss',forge:'Forge',egg:'StealAnEgg',stealabrainrot:'StealABrainrot',ttk:'TTKTesting',money:'MoneyPerClick',eggchili:'StealAnEggChili'})[entry.Id];
  if (!name) {
    // Other reviewed repository scripts can participate without being generated.
    if (!/^[\w/.-]+\.luau$/.test(entry.File) || entry.File.includes('..') || entry.File.startsWith('/')) throw new Error('Invalid external script path');
    read(`scripts/${entry.File}`);
    continue;
  }
  const controller = read(`src/games/${name}.luau`);
  const source = `${banner}-- ${entry.Name}. See docs/SOURCE-PROVENANCE.md for authorship and restrictions.
${factory}
${module('makeAdapter', adapter)}
${module('makeSession', session)}
${entry.Id === 'egg' ? module('makeWindAdapter', wind) : ''}
${entry.Id === 'stealabrainrot' ? module('makeOwnedRuntime', ownedRuntime) + '\n' + module('makeChilliAdapter', chilli) : ''}
${entry.Id === 'ttk' ? module('makePatches', read('src/games/OwnedPatches.luau')) : ''}
${entry.Id === 'money' ? module('makeMoneyData', 'return function()\n'+read('src/games/MoneyData.luau')+'\nend') : ''}
${entry.Id === 'eggchili' ? module('chiliPolicy', read('src/games/ChiliEggPolicy.luau')) : ''}
${module('wrongPlace', launcher)}
local function runGame(context)
${controller}
end
if not game:IsLoaded() then game.Loaded:Wait() end
local entry=${lua(entry)}
local environment=type(getgenv)=="function" and getgenv() or _G
local library=createNullx11UI({Id=${quote(name)},ReducedMotion=environment.Nullx11ReducedMotion==true})
${entry.Id === 'eggchili' ? `local function compatible()
local storage=game:GetService("ReplicatedStorage")
for _,path in ipairs({"Client.EggState","Shared.Save","Data.Assets"}) do
local node=storage
for part in path:gmatch("[^.]+") do node=node and node:FindFirstChild(part) end
if not node or not node:IsA("ModuleScript") then return false end
end
local packages=storage:FindFirstChild("Packages")
return packages and packages:FindFirstChild("Networking")~=nil
end
if not compatible() then` : entry.Id === 'ttk' ? `local function compatible()
local controllers=game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
for _,name in ipairs({"Client","Controllers"}) do controllers=controllers and controllers:FindFirstChild(name) end
for _,name in ipairs({"GunController","CameraController"}) do
local node=controllers and controllers:FindFirstChild(name)
if not node or not node:IsA("ModuleScript") then return false end
end
return workspace:FindFirstChild("MercPlayers")~=nil
end
if not compatible() then` : entry.Id === 'money' ? `local function compatible()
local storage=game:GetService("ReplicatedStorage")
for _,spec in ipairs({{"Remotes.ClickToEarn","RemoteEvent"},{"RebirthRemote","RemoteEvent"},{"EvolveRemote","RemoteEvent"},{"Events.CanOpenEgg","RemoteFunction"}}) do
local node=storage
for part in spec[1]:gmatch("[^.]+") do node=node and node:FindFirstChild(part) end
if not node or not node:IsA(spec[2]) then return false end
end
return true
end
if not compatible() then` : entry.Id === 'stealabrainrot' ? `local function compatible()
local storage=game:GetService("ReplicatedStorage")
local datas=storage:FindFirstChild("Datas")
local packages=storage:FindFirstChild("Packages")
local animals=datas and datas:FindFirstChild("Animals")
local mouse=packages and packages:FindFirstChild("PlayerMouse")
return animals and animals:IsA("ModuleScript") and mouse and mouse:IsA("ModuleScript") and workspace:FindFirstChild("Plots")~=nil
end
if not compatible() then` : entry.Id === 'egg' ? `local function compatible()
local storage=game:GetService("ReplicatedStorage")
for _,path in ipairs({"Shared.Remotes","Shared.Save","Client.EggState","Client.PlotState","Client.AssetRoster","Data.Assets","Data.Rarity"}) do
local node=storage
for part in path:gmatch("[^.]+") do node=node and node:FindFirstChild(part) end
if not node or not node:IsA("ModuleScript") then return false end
end
return true
end
if not compatible() then` : 'if game.PlaceId~=entry.GamePlaceId then'}
wrongPlace(library,entry,${quote('https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/' + entry.File)})
return
end
local context=makeSession(entry.Id,library)
context.Adapter=makeAdapter(library,entry.Name,"Nullx11 "..${quote(name)})
${entry.Id === 'egg' ? 'context.WindAdapter=makeWindAdapter(library,context.Adapter)' : ''}
${entry.Id === 'stealabrainrot' ? 'context.Runtime=makeOwnedRuntime(context)\ncontext.ChilliAdapter=makeChilliAdapter(library,context.Runtime)' : ''}
${entry.Id === 'ttk' ? 'context.Patches=makePatches()' : ''}
${entry.Id === 'money' ? 'context.MoneyData=makeMoneyData()' : ''}
${entry.Id === 'eggchili' ? 'context.ChiliPolicy=chiliPolicy' : ''}
local ok,result=xpcall(function() return runGame(context) end,debug.traceback)
if not ok then
library:Unload()
warn("["..entry.Name.."] "..tostring(result))
local notice=createNullx11UI({Id=${quote(name + 'Error')}})
makeSession(entry.Id.."Error",notice)
notice:CreateWindow({Title="Nullx11",SubTitle=entry.Name,Intro=false,Watermark=false,OnUnlocked=function()
local tab=notice.Window:AddTab("Runtime error","info","No replacement gameplay was started")
local group=tab:AddLeftGroupbox("Controller could not start")
group:AddParagraph({Title="Game/runtime incompatibility",Content=tostring(result)})
group:AddButton({Text="Close",Func=function() notice:Unload() end})
end})
end
`;
  output(`scripts/${entry.File}`,source);
}
output('scripts/manifest.json',JSON.stringify(catalog,null,2)+'\n');
const lines=read('Nullx11.client.luau').split('\n').length;
if (lines <= 15000) throw new Error(`Main script must exceed 15,000 meaningful lines; got ${lines}`);
console.log(`${check?'Verified':'Built'} shared UI, ${catalog.Scripts.length} selected-game bundles and ${lines}-line main client.`);
