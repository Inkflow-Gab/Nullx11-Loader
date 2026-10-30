-- Minimal deterministic API mock, NOT a Roblox emulator.

local function signal()
 local listeners = {}
 return {
  Connect = function(self, fn)
   local c = {Connected = true}
   function c:Disconnect() self.Connected = false end
   table.insert(listeners, {c, fn})
   return c
  end,
  Fire = function(self, ...)
   for _, entry in ipairs(listeners) do if entry[1].Connected then entry[2](...) end end
  end,
 }
end
local vector = {}
vector.__index = function(v, key)
 if key == "Magnitude" then return math.sqrt(v.X*v.X+v.Y*v.Y) end
 return vector[key]
end
vector.__add = function(a,b) return setmetatable({X=a.X+b.X,Y=a.Y+b.Y},vector) end
vector.__sub = function(a,b) return setmetatable({X=a.X-b.X,Y=a.Y-b.Y},vector) end
vector.__mul = function(a,b) return setmetatable({X=a.X*b,Y=a.Y*b},vector) end
vector.__div = function(a,b) return setmetatable({X=a.X/b,Y=a.Y/b},vector) end
local Vector2 = {new=function(x,y) return setmetatable({X=x,Y=y},vector) end}
local udim = {}
udim.__add = function(a,b) return setmetatable({X=a.X+b.X,Y=a.Y+b.Y},udim) end
local UDim2 = {
 new=function(xs,x,ys,y) return setmetatable({X=x,Y=y},udim) end,
 fromOffset=function(x,y) return setmetatable({X=x,Y=y},udim) end,
 fromScale=function(x,y) return setmetatable({X=x,Y=y},udim) end,
}
local UDim = {new=function(...) return {...} end}
local color = {}
function color:Lerp(other, alpha) return self end
local ColorSequence = {new=function(...) return {...} end}
local Color3 = {fromRGB=function(...) return setmetatable({}, {__index=color}) end, new=function(...) return {} end}
local Enum = setmetatable({}, {__index=function(t,k)
 local value=setmetatable({}, {__index=function(t2,k2) rawset(t2,k2,k.."."..k2) return k.."."..k2 end})
 rawset(t,k,value) return value
end})
local Vector3 = {zero = {X=0,Y=0,Z=0}}
local clock = 10
local os = {clock = function() return clock end}
local objects = {}
local events = {RenderStepped=true, MouseButton1Down=true, MouseButton1Up=true, InputBegan=true, InputChanged=true, InputEnded=true, WindowFocusReleased=true,
 MouseEnter=true, MouseLeave=true, SelectionGained=true, SelectionLost=true, Activated=true, Destroying=true}
local methods = {}
function methods:FindFirstChild(name)
 for i=#objects,1,-1 do
  local o=objects[i]
  if o.Parent==self and o.Name==name and not o.Destroyed then return o end
 end
end
function methods:WaitForChild(name) return assert(self:FindFirstChild(name), name) end
function methods:IsA(name)
 local guiClasses={Frame=true,TextLabel=true,TextButton=true,ScrollingFrame=true}
 return self.ClassName==name or (name=="BasePart" and self.ClassName=="Part") or (name=="GuiObject" and guiClasses[self.ClassName]==true)
end
function methods:GetFocusedTextBox() return self.FocusedTextBox end
function methods:GetDescendants()
 local descendants={}
 for _,object in ipairs(objects) do
  local parent=object.Parent
  while parent do
   if parent==self then table.insert(descendants,object) break end
   parent=parent.Parent
  end
 end
 return descendants
end
function methods:FindFirstChildOfClass(name)
 for _,o in ipairs(objects) do if o.Parent==self and o.ClassName==name and not o.Destroyed then return o end end
end
function methods:GetPivot() return self.Pivot end
function methods:PivotTo(pivot) self.Pivot=pivot self.MoveCount=(self.MoveCount or 0)+1 end
function methods:GetPropertyChangedSignal(name)
 self.Signals[name]=self.Signals[name] or signal()
 return self.Signals[name]
end
function methods:Destroy()
 if self.Destroyed then return end
 self.Destroying:Fire()
 self.Destroyed=true
 for _,o in ipairs(objects) do if o.Parent==self then o:Destroy() end end
end
local Instance = {new=function(class)
 local o={ClassName=class,Name=class,Signals={},ZIndex=1,Visible=true,AbsolutePosition=Vector2.new(0,0)}
 setmetatable(o,{__index=function(t,k)
  if k=="AbsoluteSize" then
   if t.Name=="SafeArea" then return Vector2.new(0,0) end
   local size=rawget(t,"Size")
   if not size then return Vector2.new(0,0) end
   local scale=1
   for _,child in ipairs(objects) do
    if child.Parent==t and child.ClassName=="UIScale" then scale=child.Scale end
   end
   return Vector2.new(size.X,size.Y)*scale
  end
  if methods[k] then return methods[k] end
  if events[k] then local s=signal() rawset(t,k,s) return s end
 end})
 table.insert(objects,o)
 return o
end}
local TweenInfo = {new=function(...) return {...} end}
local tweenService={Create=function(self, object, info, properties)
 return {Play=function() for k,v in pairs(properties) do object[k]=v end end, Cancel=function() end}
end}
local inputService = Instance.new("UserInputService")
local runService = Instance.new("RunService")
local playerGui=Instance.new("PlayerGui")
playerGui.Name="PlayerGui"
local player=Instance.new("Player")
playerGui.Parent=player
local services={Players={LocalPlayer=player},TweenService=tweenService,UserInputService=inputService,RunService=runService}
local game={GetService=function(self,name) return assert(services[name],name) end,IsLoaded=function() return true end}
local task={delay=function(t,fn) fn() end, wait=function() end}
local warnings={}
local warn=function(message) table.insert(warnings,message) end
local require=function(module) return module.Export end
local script=Instance.new("LocalScript")
local function find(name)
 for i=#objects,1,-1 do
  if objects[i].Name==name and not objects[i].Destroyed then return objects[i] end
 end
 error("Missing "..name)
end

local typeof=function(object)
 if type(object)=="table" and object.ClassName then return "Instance" end
 return type(object)
end
local function advance(dt)
 clock+=dt
 runService.RenderStepped:Fire(dt)
end
