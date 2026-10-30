runLoader()
local root = find("SafeArea")
root.AbsoluteSize = Vector2.new(900, 800)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
find("Load").Activated:Fire()
find("TabStyle").Activated:Fire()
-- The heavy editor does not exist until it is explicitly opened.
assert(not root:FindFirstChild("DesignStudio"), "Studio is lazy")
find("OpenDesignStudio").Activated:Fire()
assert(find("DesignStudio").Visible, "Studio opens")
assert(find("DesignValue_Width").Text == "440 px", "width reflects runtime")
find("DesignChoice_Theme_Rose").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 247 / 153 / 189",
	"theme preview follows real accent"
)
assert(#warnings == 0, "Studio rendering should not throw")
find("DesignUndo").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 167 / 146 / 255",
	"undo restores accent"
)
find("DesignRedo").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 247 / 153 / 189",
	"redo restores change"
)
find("DesignToggle_CustomAccent").Activated:Fire()
find("DesignPlus_Red").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 172 / 146 / 255",
	"RGB controls update preview"
)
find("DesignSave1").Activated:Fire()
find("DesignChoice_Theme_Ice").Activated:Fire()
find("DesignLoad1").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 172 / 146 / 255",
	"memory design preserves custom RGB"
)
find("DesignAction_Export").Activated:Fire()
local exported = find("DesignEditor_Transfer").Text
find("DesignChoice_Theme_Mint").Activated:Fire()
find("DesignEditor_Transfer").Text = exported
find("DesignAction_Import").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 172 / 146 / 255",
	"validated import restores appearance"
)
jsonDocuments.bad = { Version = 1, Settings = { Width = 99999 } }
find("DesignEditor_Transfer").Text = "bad"
find("DesignAction_Import").Activated:Fire()
assert(
	string.find(find("DesignMessage").Text, "between", 1, true),
	"out-of-range import is rejected"
)
assert(find("DesignValue_Width").Text == "440 px", "invalid import is atomic")
-- Every import is validated before any setting is changed.
local stable = find("DesignPreviewRGB").Text
local function reject(token, document, expected)
	jsonDocuments[token] = document
	find("DesignEditor_Transfer").Text = token
	find("DesignAction_Import").Activated:Fire()
	assert(
		string.find(find("DesignMessage").Text, expected, 1, true),
		token .. " rejection"
	)
	assert(
		find("DesignPreviewRGB").Text == stable,
		"invalid import must not partially change accent"
	)
end
reject(
	"unknown",
	{ Version = 1, Settings = { Unknown = true } },
	"Unknown setting"
)
reject(
	"version",
	{ Version = 99, Settings = { Width = 440 } },
	"unsupported format"
)
reject(
	"topfield",
	{ Version = 1, Settings = { Width = 440 }, URL = "https://example.com" },
	"Unexpected design field"
)
reject(
	"wrongtype",
	{ Version = 1, Settings = { Width = "440" } },
	"finite number"
)
reject(
	"notfinite",
	{ Version = 1, Settings = { Scale = 0 / 0 } },
	"finite number"
)
reject(
	"infinite",
	{ Version = 1, Settings = { Scale = math.huge } },
	"finite number"
)
reject(
	"badchoice",
	{ Version = 1, Settings = { Font = "NotAFont" } },
	"Unsupported"
)
reject(
	"fraction",
	{ Version = 1, Settings = { CoordinatePrecision = 1.5 } },
	"whole number"
)
reject(
	"partial",
	{ Version = 1, Settings = { Red = 1, Width = 9999 } },
	"between"
)
find("DesignEditor_Transfer").Text = string.rep("x", 8193)
find("DesignAction_Import").Activated:Fire()
assert(
	string.find(find("DesignMessage").Text, "8192", 1, true),
	"import length cap"
)
-- Quick controls mirror into Studio and share its history after opening.
find("ThemeIce").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 129 / 200 / 255",
	"quick accent synchronizes Studio"
)
find("DesignUndo").Activated:Fire()
assert(find("DesignPreviewRGB").Text == stable, "quick accent can be undone")
find("ScaleSmall").Activated:Fire()
assert(
	find("DesignValue_Scale").Text == "0.85×",
	"quick scale synchronizes Studio"
)
find("DesignUndo").Activated:Fire()
assert(find("DesignValue_Scale").Text == "1×", "quick scale undo")
-- Hex input and palette math operate on channels, not executable strings.
find("DesignHexInput").Text = "#0f8"
find("DesignAction_ApplyHex").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 0 / 255 / 136",
	"three-digit hex expansion"
)
find("DesignHexInput").Text = "#oops"
find("DesignAction_ApplyHex").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 0 / 255 / 136",
	"invalid hex preserves accent"
)
find("DesignAction_ReadHex").Activated:Fire()
assert(find("DesignHexInput").Text == "#00FF88", "read hex")
find("DesignChoice_Theme_Violet").Activated:Fire()
find("DesignTint4").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text == "RGB 180 / 162 / 255",
	"tint interpolation"
)
find("DesignHue_Complement").Activated:Fire()
assert(
	find("DesignPreviewRGB").Text ~= "RGB 180 / 162 / 255",
	"HSV complement changes hue"
)
assert(
	string.find(find("DesignEditor_Contrast").Text, "4.5 reference", 1, true),
	"contrast diagnostics populate"
)
-- Per-page search is a bounded plain-string filter.
find("DesignTab_Layout").Activated:Fire()
find("DesignSearch").Text = "dashboard width"
find("DesignSearch"):GetPropertyChangedSignal("Text"):Fire()
assert(
	find("DesignRow_Width").Visible and not find("DesignRow_Height").Visible,
	"search filters rows"
)
find("DesignSearch").Text = "[.*"
find("DesignSearch"):GetPropertyChangedSignal("Text"):Fire()
assert(find("DesignEmpty_Layout").Visible, "search is not a Lua pattern")
find("DesignSearch").Text = ""
find("DesignSearch"):GetPropertyChangedSignal("Text"):Fire()
-- Motion priority, graph state, visibility and opacity remain functional.
find("DesignToggle_ReducedMotion").Activated:Fire()
find("DesignToggle_Glitch").Activated:Fire()
assert(
	string.find(find("DesignMessage").Text, "Turn reduced motion off", 1, true),
	"reduced motion rejects a conflicting glitch request"
)
find("DesignToggle_ReducedMotion").Activated:Fire()
find("DesignToggle_FPSGraph").Activated:Fire()
assert(find("FPSMeter").Size.Y == 48, "graph-off compacts meter")
find("DesignUndo").Activated:Fire()
assert(find("FPSMeter").Size.Y == 64, "undo restores graph layout")
find("DesignMinus_DockOpacity").Activated:Fire()
local expected = find("RestoreNullx11").BackgroundTransparency
find("RestoreNullx11").MouseLeave:Fire()
assert(
	find("RestoreNullx11").BackgroundTransparency == expected,
	"hover restore respects configured opacity"
)
find("DesignToggle_LargeTargets").Activated:Fire()
assert(find("DesignPlus_Width").Size.Y == 52, "large Studio controls")
find("DesignToggle_Hints").Activated:Fire()
assert(not find("DesignHint_Width").Visible, "descriptions can be hidden")
find("DesignChoice_Font_Arial").Activated:Fire()
assert(
	find("DesignTypeBody").Font == Enum.Font.Arial,
	"font changes rendered labels"
)
assert(find("Title").Font == Enum.Font.Code, "technical font is preserved")
-- The grip changes the actual main panel preferences and participates in history.
find("DesignToggle_Locked").Activated:Fire()
local lockedWidth = find("DesignValue_Width").Text
local lockedInput = {
	UserInputType = Enum.UserInputType.Touch,
	Position = Vector2.new(100, 100),
}
find("ResizeDashboard").InputBegan:Fire(lockedInput)
lockedInput.Position = Vector2.new(200, 200)
inputService.InputChanged:Fire(lockedInput)
inputService.InputEnded:Fire(lockedInput)
assert(
	find("DesignValue_Width").Text == lockedWidth,
	"window lock prevents resizing"
)
find("DesignToggle_Locked").Activated:Fire()
local grip = find("ResizeDashboard")
local resize = {
	UserInputType = Enum.UserInputType.Touch,
	Position = Vector2.new(100, 100),
}
grip.InputBegan:Fire(resize)
resize.Position = Vector2.new(140, 120)
inputService.InputChanged:Fire(resize)
inputService.InputEnded:Fire(resize)
assert(
	find("DesignValue_Width").Text == "480 px",
	"drag resizes actual dashboard width"
)
find("DesignUndo").Activated:Fire()
assert(
	find("DesignValue_Width").Text == "440 px",
	"completed resize can be undone"
)
find("DesignAction_ArrangeLeft").Activated:Fire()
assert(find("Panel").Position.X < root.AbsoluteSize.X / 2, "left arrangement")
-- Bounded history and typing-safe shortcuts.
for i = 1, 30 do
	find(if i % 2 == 0 then "DesignMinus_Width" else "DesignPlus_Width").Activated:Fire()
end
assert(find("DesignUndo").Text == "Undo 24", "history bound")
inputService.HeldKeys = { [Enum.KeyCode.LeftControl] = true }
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.Z }, false)
assert(find("DesignRedo").Text == "Redo 1", "Ctrl Z undoes a Studio edit")
inputService.FocusedTextBox = find("DesignSearch")
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.Y }, false)
assert(find("DesignRedo").Text == "Redo 1", "typing prevents Studio hotkeys")
inputService.FocusedTextBox = nil
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.Y }, false)
assert(find("DesignRedo").Text == "Redo 0", "Ctrl Y redoes")
inputService.HeldKeys = {}
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.Escape }, true)
assert(find("DesignStudio").Visible, "processed Escape is ignored")
inputService.InputBegan:Fire({ KeyCode = Enum.KeyCode.Escape }, false)
assert(not find("DesignStudio").Visible, "Escape hides Studio")
find("OpenDesignStudio").Activated:Fire()
-- Saved design deletion is confirmed and does not alter the live design.
local beforeDelete = find("DesignPreviewRGB").Text
find("DesignAction_DeleteSlot1").Activated:Fire()
find("DesignLoad1").Activated:Fire()
beforeDelete = find("DesignPreviewRGB").Text
find("DesignAction_DeleteSlot1").Activated:Fire()
find("DesignLoad1").Activated:Fire()
assert(
	string.find(find("DesignMessage").Text, "Save a design", 1, true),
	"design slot deletion"
)
assert(
	find("DesignPreviewRGB").Text == beforeDelete,
	"deleting saved design does not change active design"
)
-- A short landscape viewport still clamps the editor itself.
root.AbsoluteSize = Vector2.new(700, 320)
root:GetPropertyChangedSignal("AbsoluteSize"):Fire()
assert(
	find("DesignStudio").Size.X <= 676 and find("DesignStudio").Size.Y <= 296,
	"Studio safe-area clamping"
)
find("DesignClose").Activated:Fire()
assert(not find("DesignStudio").Visible, "Studio close only hides")
local count = #objects
find("OpenDesignStudio").Activated:Fire()
assert(#objects == count, "reopening reuses controls")
find("Close").Activated:Fire()
assert(find == find and root.Destroyed, "main close destroys Studio")
return "PASS: lazy Design Studio, 46 preferences, palettes/hex/contrast, search, typography, resize, motion, bounded history, profiles, mocked JSON validation, keyboard shortcuts, safe areas, and cleanup"
