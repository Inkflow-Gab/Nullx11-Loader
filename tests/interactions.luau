-- Runs after the client source, in a shared mock environment.
runLoader()
local root=find("SafeArea")
root.AbsoluteSize=Vector2.new(390,700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
local panel=find("Panel")
assert(panel.Size.X==366, "portrait panel width")
assert(panel.Position.X==195, "portrait panel center")
find("Load").Activated:Fire()
assert(find("Tools").Visible and not find("Load").Visible, "load opens built-in tools")

find("Teleport tools").Activated:Fire()
assert(find("TeleportPanel").Visible, "teleport toggle opens sub-GUI")
find("TeleportToPosition").Activated:Fire()
assert(find("TeleportStatus").Text=="Save a position first.", "empty teleport guard")
find("SavePosition").Activated:Fire()
assert(find("TeleportStatus").Text=="Wait for your character to spawn.", "spawn guard")
local character=Instance.new("Model")
character.Parent=game
character.Pivot={Position={X=10,Y=20,Z=30}}
local humanoid=Instance.new("Humanoid") humanoid.Parent=character humanoid.Health=100
local part=Instance.new("Part") part.Parent=character part.Name="HumanoidRootPart"
player.Character=character
find("SavePosition").Activated:Fire()
assert(find("Coordinates").Text=="X 10.0   Y 20.0   Z 30.0", "saved coordinates")
local original=character.Pivot
character.Pivot={Position={X=50,Y=60,Z=70}}
humanoid.SeatPart=Instance.new("Part")
find("TeleportToPosition").Activated:Fire()
assert(not character.MoveCount, "seated teleport is blocked")
humanoid.SeatPart=nil
find("TeleportToPosition").Activated:Fire()
assert(character.Pivot==original and character.MoveCount==1, "return to saved pivot")
assert(part.AssemblyLinearVelocity==Vector3.zero and part.AssemblyAngularVelocity==Vector3.zero, "clear momentum")
find("TeleportToPosition").Activated:Fire()
assert(character.MoveCount==1, "teleport rate limit")
find("HideTeleport").Activated:Fire()
assert(not find("TeleportPanel").Visible, "hide sub-GUI")
assert(find("Teleport tools"):FindFirstChild("ToggleState").Text=="OFF", "hide synchronizes toggle")
find("Teleport tools").Activated:Fire()
assert(find("TeleportPanel").Visible, "one tap reopens sub-GUI")
assert(find("Coordinates").Text~="No position saved", "hide preserves bookmark")
-- Same-session respawn uses the new character, not a stale root part.
local respawn=Instance.new("Model") respawn.Parent=game
local newHumanoid=Instance.new("Humanoid") newHumanoid.Parent=respawn newHumanoid.Health=100
local newPart=Instance.new("Part") newPart.Parent=respawn newPart.Name="HumanoidRootPart"
player.Character=respawn
advance(1)
find("TeleportToPosition").Activated:Fire()
assert(respawn.Pivot==original, "bookmark survives character respawn")
find("ClearPosition").Activated:Fire()
advance(1)
find("TeleportToPosition").Activated:Fire()
assert(find("Coordinates").Text=="No position saved", "clear bookmark")
assert(respawn.MoveCount==1, "cleared bookmark cannot teleport")

-- Independent slots, navigation, HUD, theme, accessibility, and recovery actions.
find("Slot2").Activated:Fire()
respawn.Pivot={Position={X=100,Y=200,Z=300}}
find("SavePosition").Activated:Fire()
find("Slot3").Activated:Fire()
assert(find("Coordinates").Text=="No position saved", "third slot starts empty")
respawn.Pivot={Position={X=400,Y=500,Z=600}}
find("SavePosition").Activated:Fire()
find("Slot2").Activated:Fire()
assert(find("Coordinates").Text=="X 100.0   Y 200.0   Z 300.0", "slots retain separate pivots")
find("Position HUD").Activated:Fire()
advance(0.6)
assert(find("CoordinateHUD").Visible, "coordinate HUD toggled on")
assert(find("LiveCoordinates").Text=="X 400.0  Y 500.0  Z 600.0", "HUD samples live character, not bookmark")
find("TabSession").Activated:Fire()
assert(find("SessionPage").Visible and not find("Tools").Visible, "session navigation")
advance(0.6)
assert(string.find(find("SessionStats").Text,"2 of 3 bookmarks",1,true), "session bookmark count")
find("ClearBookmarks").Activated:Fire()
assert(find("Coordinates").Text~="No position saved", "clear all needs confirmation")
find("ClearBookmarks").Activated:Fire()
assert(find("Coordinates").Text=="No position saved", "confirmed clear all")
find("HideUtilities").Activated:Fire()
assert(not find("CoordinateHUD").Visible and not find("TeleportPanel").Visible, "hide utilities synchronizes panels")
find("ResetLayout").Activated:Fire()
assert(panel.Position.X==195 and panel.Position.Y==350, "recenter main panel")
find("TabStyle").Activated:Fire()
assert(find("StylePage").Visible and not find("SessionPage").Visible, "style navigation")
local oldSlotAccent=find("Slot2").BackgroundColor3
find("ThemeMint").Activated:Fire()
assert(find("Slot2").BackgroundColor3~=oldSlotAccent, "theme recolors selected bookmark")
find("Reduced motion").Activated:Fire()
for i=1,240 do advance(1/60) end
assert(find("GlitchLayer").TextTransparency==1, "reduced motion suppresses glitch")
find("Reduced motion").Activated:Fire()
if find("Glitch title"):FindFirstChild("ToggleState").Text=="OFF" then find("Glitch title").Activated:Fire() end
find("ScaleLarge").Activated:Fire()
local mainScale=panel:FindFirstChildOfClass("UIScale")
assert(mainScale.Scale==1.1, "large interface scale")
find("ScaleDefault").Activated:Fire()
assert(mainScale.Scale==1, "default interface scale")
find("Lock windows").Activated:Fire()
local before=panel.Position
local pinTouch={UserInputType=Enum.UserInputType.Touch,Position=Vector2.new(100,100)}
find("DragHandle").InputBegan:Fire(pinTouch)
pinTouch.Position=Vector2.new(1000,1000)
inputService.InputChanged:Fire(pinTouch)
inputService.InputEnded:Fire(pinTouch)
assert(panel.Position==before, "pinned main window ignores drag")
find("Lock windows").Activated:Fire()
-- Desktop hotkey ignores text entry and processed input.
inputService.FocusedTextBox={}
inputService.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},false)
assert(panel.Visible, "typing cannot toggle dashboard")
inputService.FocusedTextBox=nil
inputService.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},true)
assert(panel.Visible, "processed key ignored")
inputService.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},false)
assert(not panel.Visible and find("RestoreNullx11").Visible, "hotkey hides dashboard, dock remains")
inputService.InputBegan:Fire({KeyCode=Enum.KeyCode.RightShift},false)
assert(panel.Visible, "hotkey restores dashboard")
find("TabTools").Activated:Fire()
assert(find("Tools").Visible and not find("StylePage").Visible, "return to tools")

find("FPS meter").Activated:Fire()
assert(find("FPSMeter").Visible, "FPS toggle")
for i=1,60 do advance(1/60) end
assert(find("FPSValue").Text=="60 FPS", "FPS from actual frame samples")
find("FPS meter").Activated:Fire()
assert(not find("FPSMeter").Visible, "hide FPS")
-- Deterministic glitch window, then clean reset when turned off.
find("Glitch title").Activated:Fire() -- off
find("Glitch title").Activated:Fire() -- on, resets phase
for i=1,217 do advance(1/60) end
assert(find("GlitchLayer").TextTransparency<1, "glitch burst animates")
find("Glitch title").Activated:Fire()
assert(find("Title").Text=="Nullx11" and find("GlitchLayer").TextTransparency==1, "glitch toggle resets text")

find("Minimize").Activated:Fire()
assert(not panel.Visible and find("RestoreNullx11").Visible, "minimize")
local miniTouch={UserInputType=Enum.UserInputType.Touch,Position=Vector2.new(40,200)}
find("RestoreNullx11").InputBegan:Fire(miniTouch)
miniTouch.Position=Vector2.new(100,250)
inputService.InputChanged:Fire(miniTouch)
inputService.InputEnded:Fire(miniTouch)
find("RestoreNullx11").Activated:Fire()
assert(not panel.Visible, "dragging restore icon must not reopen panel")
advance(0.31)
find("RestoreNullx11").Activated:Fire()
assert(panel.Visible, "tap restores after drag debounce")
-- Touch drag: floating FPS stays within the safe-area bounds.
find("FPS meter").Activated:Fire()
local touch={UserInputType=Enum.UserInputType.Touch,Position=Vector2.new(100,100)}
find("FPSMeter").InputBegan:Fire(touch)
touch.Position=Vector2.new(2000,2000)
inputService.InputChanged:Fire(touch)
inputService.InputEnded:Fire(touch)
assert(find("FPSMeter").Position.X<=root.AbsoluteSize.X-66, "floating horizontal clamp")
assert(find("FPSMeter").Position.Y<=root.AbsoluteSize.Y-24, "floating vertical clamp")
root.AbsoluteSize=Vector2.new(700,320)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(panel.Position.Y>=156 and panel.Position.Y<=164, "landscape resize stays within safe bounds")
local fpsValue=find("FPSValue")
find("Close").Activated:Fire()
assert(root.Destroyed, "close destroys all utility panels")
local lastText=fpsValue.Text
for i=1,60 do advance(1/20) end
assert(fpsValue.Text==lastText, "close disconnects render updates")

-- Optional Studio App: failure, retry, successful single execution.
local app=Instance.new("ModuleScript") app.Name="App" app.Parent=script
local calls=0
app.Export=function(context)
 calls+=1
 if calls==1 then error("expected test failure") end
 context.SetProgress(0.5,"Halfway")
 assert(not context.IsCancelled())
 context.SetProgress(1,"Done")
end
runLoader()
local button=find("Load")
button.Activated:Fire()
assert(button.Text=="Try again  →" and #warnings==1, "error state and logging")
button.Activated:Fire()
assert(find("Tools").Visible and calls==2, "retry completes")
button.Activated:Fire()
assert(calls==2, "only initialize once")
local old=find("Nullx11Loader")
-- External-runtime path: no script global and no child ModuleScript required.
script=nil
runLoader()
assert(old.Destroyed, "rerun closes previous instance")
find("Load").Activated:Fire()
assert(find("Tools").Visible, "standalone execution without script instance")
assert(find("Coordinates").Text=="No position saved", "new run resets bookmark")
-- Polished controls: real switch positions, Unicode-safe names, distance and history.
root=find("SafeArea")
root.AbsoluteSize=Vector2.new(390,700)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Teleport tools").Activated:Fire()
local thumb=find("Teleport tools"):FindFirstChild("SwitchTrack"):FindFirstChild("SwitchThumb")
assert(thumb.Position.X==23, "enabled switch moves to right")
local name=find("BookmarkName")
name.Text="  Base\nCamp  "
name.FocusLost:Fire()
assert(name.Text=="Base Camp", "bookmark name trims whitespace and controls")
find("Slot2").Activated:Fire()
name.Text=string.rep("ñ",30)
name.FocusLost:Fire()
assert(utf8.len(name.Text)==24, "names are capped at 24 Unicode codepoints")
find("Slot1").Activated:Fire()
assert(name.Text=="Base Camp", "names are independent per slot")
player.Character.Pivot={Position={X=0,Y=0,Z=0}}
find("SavePosition").Activated:Fire()
assert(find("BookmarkDistance").Text=="0 studs away", "save updates distance immediately")
player.Character.Pivot={Position={X=3,Y=4,Z=0}}
advance(0.6)
assert(find("BookmarkDistance").Text=="5 studs away", "distance uses live Euclidean position")
find("ClearPosition").Activated:Fire()
assert(find("BookmarkDistance").Text=="Save a spot to measure distance", "clear resets distance")
name.Text="   "
name.FocusLost:Fire()
assert(name.Text=="Spot 1", "blank name has safe default")
find("Teleport tools").Activated:Fire()
assert(thumb.Position.X==3, "disabled switch moves left")
find("FPS meter").Activated:Fire()
local allocated=#objects
for i=1,60 do advance(1/60) end
assert(find("FPSHistory1").Visible and find("FPSHistory1").Size.Y==6, "graph maps 60 FPS into bounded height")
for i=1,150 do advance(0.05) end
assert(find("FPSHistory12").Visible, "history has a fixed twelve-sample capacity")
assert(#objects==allocated, "telemetry allocates no new GUI instances")
find("FPS meter").Activated:Fire()
assert(not find("FPSHistory1").Visible, "disable resets graph")
find("TabStyle").Activated:Fire()
find("Snap dock").Activated:Fire()
assert(find("RestoreNullx11").Position.X==38, "snap respects dock half-width plus safe margin")
local dockTouch={UserInputType=Enum.UserInputType.Touch,Position=Vector2.new(100,100)}
find("RestoreNullx11").InputBegan:Fire(dockTouch)
dockTouch.Position=Vector2.new(1000,200)
inputService.InputChanged:Fire(dockTouch)
inputService.InputEnded:Fire(dockTouch)
assert(find("RestoreNullx11").Position.X==352, "drag release snaps to right edge")
find("RestoreNullx11").Activated:Fire()
assert(find("Panel").Visible, "snap drag does not activate dock")
root.AbsoluteSize=Vector2.new(700,320)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(find("RestoreNullx11").Position.X==662, "snap recalculates on rotation")
find("ThemeMint").Activated:Fire()
local snapTrack=find("Snap dock"):FindFirstChild("SwitchTrack")
assert(snapTrack.BackgroundColor3==find("Slot1").BackgroundColor3, "theme refreshes active switch accents")
find("Close").Activated:Fire()
return "PASS: mocked animated switches, Unicode bookmark names, live distance, bounded FPS graph, edge snapping, dashboard tabs, themes, scale, locking, hotkey, HUD, bookmark slots, confirmations, recovery, teleport guards, FPS/glitch, mobile drag, cleanup, retry, standalone execution"
