-- GENERATED from src/ by tools/build.mjs. Edit the sources, then run npm run build.
-- Nullx11 - +1 loot to forge. See docs/SOURCE-PROVENANCE.md for authorship and restrictions.
local function createNullx11UI(scope)
	-- Nullx11 shared UI; adapted with user-reported developer permission.
	-- Original +1 Loot UI by xDTaraZ; see docs/SOURCE-PROVENANCE.md.
	-- Nullx11 UI · standalone build 2026-10-14
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local TextService = game:GetService("TextService")
	local CoreGui = game:GetService("CoreGui")
	local Stats = game:GetService("Stats")
	local Workspace = game:GetService("Workspace")

	local LocalPlayer = Players.LocalPlayer

	local Library = {
		Version = "1.0",
		Options = {},
		Toggles = {},
		Unloaded = false,
		Window = nil,
	}

	local Config = {
		GuiAttribute = "Nullx11UI_"
			.. tostring((scope and scope.Id) or "Workspace"),
		Root = "nullx11",
		AssetDir = "nullx11/assets",
		ConfigRoot = "nullx11/configs",
		DefaultAssets = {},
		Decorations = false,
		SeasonTheme = "Nullx11",
		FontDir = "nullx11/fonts",
		HttpTimeout = 8,
		FontTimeout = 20,
		PreloadTimeout = 5,
		ThaiFont = {
			Family = "Nullx11Kanit",
			Source = "https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/assets/fonts/Kanit-%s.ttf",
			Weights = {
				[400] = "Regular",
				[500] = "Medium",
				[600] = "SemiBold",
			},
		},
		-- Scale bonus for Thai glyphs to match Latin x-height
		ThaiSizeBonus = { Body = 2, Desc = 2, Display = 1, Strong = 1 },
		Text = {
			Title = 26,
			Header = 22,
			Group = 16,
			Label = 15,
			Desc = 14,
			Small = 14,
			Button = 16,
			Watermark = 14,
			Section = 14,
		},
		Window = {
			Width = 820,
			Height = 560,
			MinWidth = 520,
			MinHeight = 360,
			TouchMinWidth = 320,
			TouchMinHeight = 260,
			Topbar = 56,
			Sidebar = 196,
			SidebarCompact = 64,
			Header = 62,
			Ground = 24,
			UserCard = 58,
			CompactBreakpoint = 640,
			TwoColumnMin = 540,
			Margin = 24,
			TouchMargin = 10,
			Radius = 12,
			Stroke = 3,
			Shadow = 6,
		},
		Metrics = {
			Desktop = {
				Row = 32,
				Box = 32,
				Item = 30,
				Track = 10,
				Knob = 18,
				Switch = Vector2.new(42, 22),
				SwitchKnob = 16,
				Tab = 38,
				Check = 22,
				Icon = 18,
				Depth = 4,
				Radius = 8,
			},
			Touch = {
				Row = 38,
				Box = 36,
				Item = 36,
				Track = 12,
				Knob = 24,
				Switch = Vector2.new(50, 26),
				SwitchKnob = 20,
				Tab = 44,
				Check = 26,
				Icon = 20,
				Depth = 4,
				Radius = 8,
			},
		},
		Motion = {
			Speed = { Fast = 28, Normal = 20, Soft = 14, Slow = 10 },
			Damping = 0.72,
			BounceDamping = 0.46,
			SquashDamping = 0.44,
		},
		Selectable = {
			PadX = 10,
			Bar = 4,
			BarWidth = 4,
			Radius = 8,
			HoverAlpha = 0.35,
		},
		Button = { PadX = 14, IconGap = 6, Depth = 4, HoverLighten = 0.14 },
		Group = {
			Header = 36,
			PadX = 12,
			PadY = 10,
			Shadow = 4,
			Radius = 12,
			Stroke = 2,
		},
		Gap = { X = 8, Y = 6, Column = 12 },
		Page = { Pad = 14, ScrollBar = 6 },
		Dropdown = { MaxVisible = 7, SearchThreshold = 8, MinWidth = 170 },
		ColorPicker = { Field = 150, Hue = 14 },
		Notify = { Width = 300, TouchWidth = 260, Duration = 4, Gap = 8 },
		Tween = {
			Fast = 0.15,
			Normal = 0.2,
			Slide = 0.28,
			Pop = 0.32,
			Collapse = 0.24,
			Notify = 0.42,
		},
		Ease = {
			Out = { Enum.EasingStyle.Quint, Enum.EasingDirection.Out },
			Back = { Enum.EasingStyle.Back, Enum.EasingDirection.Out },
			In = { Enum.EasingStyle.Quad, Enum.EasingDirection.In },
			Sine = { Enum.EasingStyle.Sine, Enum.EasingDirection.InOut },
			Linear = { Enum.EasingStyle.Linear, Enum.EasingDirection.InOut },
			Bounce = { Enum.EasingStyle.Bounce, Enum.EasingDirection.Out },
		},
		Layer = {
			Window = 10,
			Watermark = 30,
			Float = 40,
			Overlay = 50,
			Modal = 52,
			Tooltip = 55,
			Notify = 60,
			Intro = 70,
		},
		LayoutPasses = 12,
		MeasureCacheLimit = 4000,
		DragThreshold = 6,
		ConfirmWindow = 2,
		TooltipDelay = 0.45,
		TitleWaveInterval = 3.6,
		ScaleRange = { Min = 0.7, Max = 1.4 },
		Particles = { Count = 10, MinTime = 7, MaxTime = 13 },
		MouseNames = {
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3",
		},
		TitleColors = { "Accent", "Coin", "Good", "Blue" },
	}

	local function rgb(hex)
		return Color3.fromRGB(
			tonumber(hex:sub(1, 2), 16),
			tonumber(hex:sub(3, 4), 16),
			tonumber(hex:sub(5, 6), 16)
		)
	end

	--@param spec Hex color palette table; Particle = { glyph, fallsDown, hex }
	local function Palette(spec)
		local palette = {}
		for token, value in pairs(spec) do
			if token == "Logo" then
				palette.Logo = value
			elseif token == "Particle" then
				local glyphs = type(value[1]) == "table" and value[1]
					or { value[1] }
				palette.ParticleGlyph, palette.ParticleGlyphs, palette.ParticleFall, palette.ParticleColor =
					glyphs[1], glyphs, value[2], rgb(value[3])
			elseif token == "Decor" then
				palette.Decor, palette.DecorGlyph, palette.DecorColor =
					value[1], value[2] or "✦", rgb(value[3] or "FFFFFF")
			elseif type(value) == "string" then
				palette[token] = rgb(value)
			else
				palette[token] = value
			end
		end
		return palette
	end

	local Themes = {
		Order = {
			"Overworld",
			"Halloween",
			"Light",
			"Dark",
			"Underground",
			"Castle",
			"Ghost House",
			"Star Road",
			"Desert",
			"Ice Land",
			"Jungle",
			"Sky World",
		},
		Overworld = Palette({
			Backdrop = "C4D6EC",
			BackdropAlt = "E2E9F2",
			Topbar = "7092CC",
			Sidebar = "96563E",
			SidebarAlt = "804834",
			SidebarText = "FCF2E6",
			SidebarMuted = "E2C4B0",
			TabActive = "FAF4E9",
			TabActiveText = "B84034",
			Panel = "FAF6EE",
			PanelHeader = "F1E7D4",
			Element = "FFFCF6",
			Hover = "EEE2CA",
			Outline = "3E384A",
			Shadow = "7880A0",
			Text = "3A3028",
			SubText = "76685A",
			Muted = "A09484",
			Track = "DED4C4",
			Cloud = "FFFFFF",
			CloudAlpha = 0.25,
			Accent = "D64C40",
			AccentDark = "A0342C",
			Grass = "74B45C",
			GrassDark = "4E8840",
			Brick = "A46042",
			BrickDark = "683A28",
			Decor = { "Clouds" },
			Particle = { "✦", false, "F6D878" },
		}),
		Halloween = Palette({
			Backdrop = "1A1226",
			BackdropAlt = "2A1838",
			Topbar = "2B1A3E",
			Sidebar = "3A2150",
			SidebarAlt = "2C1840",
			SidebarText = "FFF1E2",
			SidebarMuted = "C9A9D8",
			TabActive = "F28A2E",
			TabActiveText = "1E1024",
			Panel = "241830",
			PanelHeader = "301F40",
			Element = "2E2140",
			Hover = "3C2A52",
			Outline = "0B0610",
			Shadow = "0B0610",
			Text = "FFF1E2",
			SubText = "D7BFD9",
			Muted = "9C85A8",
			Track = "4A3460",
			Cloud = "B98CFF",
			CloudAlpha = 0.85,
			Accent = "F28A2E",
			AccentDark = "B85E14",
			Grass = "7A3FA8",
			GrassDark = "4E2470",
			Brick = "4A2E60",
			BrickDark = "1E1028",
			Decor = { "Halloween", "✦", "FFB347" },
			Glow = "F28A2E",
			Fog = "8E5CD0",
			Particle = { { "✦", "✦", "•", "✧" }, false, "FFB347" },
		}),
		Light = Palette({
			Backdrop = "F2EEE6",
			BackdropAlt = "FAF8F3",
			Topbar = "EDE4D4",
			TopbarText = "4A3F35",
			Sidebar = "EAE2D4",
			SidebarAlt = "DDD3C2",
			SidebarText = "4A3F35",
			SidebarMuted = "9B8E7E",
			TabActive = "D64C40",
			TabActiveText = "FFFFFF",
			Panel = "FFFFFF",
			PanelHeader = "F6F1E8",
			Element = "FBF9F5",
			Hover = "F0E8DA",
			Outline = "4A4458",
			Shadow = "CFC7BA",
			Text = "3A3028",
			SubText = "7C6E60",
			Muted = "ABA092",
			Track = "E6DED2",
			Cloud = "C8D8EC",
			CloudAlpha = 0,
			Accent = "D64C40",
			AccentDark = "A0342C",
			Grass = "8CC47A",
			GrassDark = "62A052",
			Brick = "D8B48E",
			BrickDark = "AE8A64",
			Decor = { "Clouds" },
			Particle = { "•", false, "D64C40" },
		}),
		Dark = Palette({
			Backdrop = "1E1F26",
			BackdropAlt = "25262F",
			Topbar = "17181E",
			Sidebar = "22232B",
			SidebarAlt = "1B1C22",
			SidebarText = "E8E6F0",
			SidebarMuted = "8D8A9C",
			TabActive = "D64C40",
			TabActiveText = "FFFFFF",
			Panel = "2A2B34",
			PanelHeader = "31323C",
			Element = "353743",
			Hover = "3E404D",
			Outline = "0E0E12",
			Shadow = "0E0E12",
			Text = "ECEAF4",
			SubText = "A9A6B8",
			Muted = "7B788C",
			Track = "454756",
			Cloud = "FFFFFF",
			CloudAlpha = 0.9,
			Accent = "E0584C",
			AccentDark = "A83A30",
			Grass = "5A5C6E",
			GrassDark = "3E3F4C",
			Brick = "2E2F39",
			BrickDark = "17181E",
			Decor = { "Stars", "✦", "F0C448" },
			Particle = { "✦", false, "F0C448" },
		}),
		Underground = Palette({
			Backdrop = "141A36",
			BackdropAlt = "1E2750",
			Topbar = "0E1330",
			Sidebar = "22327A",
			SidebarAlt = "1A2762",
			SidebarText = "ECF0FF",
			SidebarMuted = "98A8E0",
			TabActive = "F0C448",
			TabActiveText = "1E1B2E",
			Panel = "1F2749",
			PanelHeader = "27305A",
			Element = "2C3666",
			Hover = "36417A",
			Outline = "05060F",
			Shadow = "05060F",
			Text = "F2F4FF",
			SubText = "AEB6E2",
			Muted = "7C86B8",
			Track = "3C4780",
			Cloud = "96AAFF",
			CloudAlpha = 0.8,
			Accent = "5B8CF0",
			AccentDark = "3A62C0",
			Grass = "3A5BC8",
			GrassDark = "2A469E",
			Brick = "2F4AA8",
			BrickDark = "142058",
			Decor = { "Stars", "✦", "8FA8FF" },
			Particle = { "✦", false, "8FA8FF" },
		}),
		Castle = Palette({
			Backdrop = "1E1818",
			BackdropAlt = "33201C",
			Topbar = "150F0F",
			Sidebar = "4A4040",
			SidebarAlt = "3A3232",
			SidebarText = "FFF1E6",
			SidebarMuted = "C8B0A4",
			TabActive = "E8703A",
			TabActiveText = "FFFFFF",
			Panel = "2B2323",
			PanelHeader = "352B2B",
			Element = "3D3232",
			Hover = "4A3D3D",
			Outline = "0A0707",
			Shadow = "0A0707",
			Text = "FFF1E6",
			SubText = "D9BFB0",
			Muted = "9F8579",
			Track = "524242",
			Cloud = "FF8A50",
			CloudAlpha = 0.85,
			Accent = "E8703A",
			AccentDark = "B04A1E",
			Grass = "FF7A2E",
			GrassDark = "C8481A",
			Brick = "5A5050",
			BrickDark = "2A2222",
			Decor = { "Stars", "•", "FF8A3C" },
			Particle = { "•", false, "FF8A3C" },
		}),
		["Ghost House"] = Palette({
			Backdrop = "1C2226",
			BackdropAlt = "232B30",
			Topbar = "151A1E",
			Sidebar = "2C3A3A",
			SidebarAlt = "223030",
			SidebarText = "E6F2EE",
			SidebarMuted = "8FB0A8",
			TabActive = "B8E0D2",
			TabActiveText = "1C2126",
			Panel = "242C31",
			PanelHeader = "2B353B",
			Element = "303B42",
			Hover = "39454D",
			Outline = "0B0E10",
			Shadow = "0B0E10",
			Text = "EAF4F1",
			SubText = "A3BDB6",
			Muted = "71898A",
			Track = "3E4B52",
			Cloud = "CFF5E7",
			CloudAlpha = 0.85,
			Accent = "4FB89C",
			AccentDark = "348A72",
			Grass = "6B5040",
			GrassDark = "4A362A",
			Brick = "5A4334",
			BrickDark = "2E2219",
			Decor = { "Stars", "•", "B8F0DC" },
			Particle = { "•", false, "9FE8D0" },
		}),
		["Star Road"] = Palette({
			Backdrop = "1C1236",
			BackdropAlt = "2D1C54",
			Topbar = "130B28",
			Sidebar = "3B2475",
			SidebarAlt = "2D1A5C",
			SidebarText = "FFF7FF",
			SidebarMuted = "CDB9F2",
			TabActive = "F0C448",
			TabActiveText = "26144A",
			Panel = "251749",
			PanelHeader = "2E1D5A",
			Element = "34225F",
			Hover = "412A72",
			Outline = "07030F",
			Shadow = "07030F",
			Text = "FFF7FF",
			SubText = "CDB9F2",
			Muted = "9580C4",
			Track = "4A3480",
			Cloud = "FFE680",
			CloudAlpha = 0.8,
			Accent = "E85CA8",
			AccentDark = "B03C7E",
			Grass = "F0C448",
			GrassDark = "BA8C28",
			Brick = "5A38A8",
			BrickDark = "2A1858",
			Decor = { "Stars", "★", "FFD95A" },
			Particle = { "★", false, "FFD95A" },
		}),
		Desert = Palette({
			Backdrop = "E8DABD",
			BackdropAlt = "F4EBD8",
			Topbar = "C99A62",
			Sidebar = "B07E4E",
			SidebarAlt = "966A40",
			SidebarText = "FFF6E8",
			SidebarMuted = "EED4B2",
			TabActive = "FFF8EC",
			TabActiveText = "B0502C",
			Panel = "FFF9EE",
			PanelHeader = "F4E6CC",
			Element = "FFFCF6",
			Hover = "F0DFC0",
			Outline = "5A4632",
			Shadow = "C2A07A",
			Text = "4A3828",
			SubText = "86705A",
			Muted = "B09A80",
			Track = "E6D6BC",
			Cloud = "FFFFFF",
			CloudAlpha = 0.3,
			Accent = "C8643A",
			AccentDark = "964626",
			Grass = "EACB8C",
			GrassDark = "C9A866",
			Brick = "C08A5A",
			BrickDark = "8A5E38",
			Decor = { "Clouds" },
			Particle = { "•", false, "C9964E" },
		}),
		["Ice Land"] = Palette({
			Backdrop = "D8E8F4",
			BackdropAlt = "EDF4FA",
			Topbar = "86B0D2",
			Sidebar = "6A96BA",
			SidebarAlt = "5A82A4",
			SidebarText = "F4FAFF",
			SidebarMuted = "CFE3F2",
			TabActive = "F6FBFF",
			TabActiveText = "3A78A8",
			Panel = "F8FCFF",
			PanelHeader = "E6F0F8",
			Element = "FFFFFF",
			Hover = "DCEAF5",
			Outline = "3E4F63",
			Shadow = "A6BACE",
			Text = "2E3D4D",
			SubText = "62788E",
			Muted = "95A8BA",
			Track = "D4E1EC",
			Cloud = "FFFFFF",
			CloudAlpha = 0.2,
			Accent = "3A8AC8",
			AccentDark = "2A6698",
			Grass = "FFFFFF",
			GrassDark = "CFE3F2",
			Brick = "7FA8CC",
			BrickDark = "4F7699",
			Decor = { "Clouds" },
			Particle = { "*", true, "FFFFFF" },
		}),
		Jungle = Palette({
			Backdrop = "1F2E23",
			BackdropAlt = "293C2D",
			Topbar = "17231A",
			Sidebar = "2F4A33",
			SidebarAlt = "253B29",
			SidebarText = "EEF7EA",
			SidebarMuted = "A3C29C",
			TabActive = "F0C84A",
			TabActiveText = "1F2A1F",
			Panel = "26382A",
			PanelHeader = "2E4332",
			Element = "334A37",
			Hover = "3D5641",
			Outline = "0C120D",
			Shadow = "0C120D",
			Text = "EEF6EA",
			SubText = "AFC6A8",
			Muted = "7E957A",
			Track = "445C47",
			Cloud = "D8F5C8",
			CloudAlpha = 0.85,
			Accent = "E08A3A",
			AccentDark = "A86024",
			Grass = "5AAE4E",
			GrassDark = "3A7A34",
			Brick = "5A4A32",
			BrickDark = "30261A",
			Decor = { "Stars", "•", "D8F07A" },
			Particle = { "•", false, "D8F07A" },
		}),
		["Sky World"] = Palette({
			Backdrop = "E6EEFC",
			BackdropAlt = "F6F9FF",
			Topbar = "A4BEEA",
			Sidebar = "8AA4D6",
			SidebarAlt = "7A92C4",
			SidebarText = "FFFFFF",
			SidebarMuted = "E3EBFA",
			TabActive = "FFFFFF",
			TabActiveText = "4A6FB5",
			Panel = "FFFFFF",
			PanelHeader = "EEF3FC",
			Element = "FFFFFF",
			Hover = "E4ECFA",
			Outline = "46506A",
			Shadow = "B6C2DA",
			Text = "333C52",
			SubText = "6A7590",
			Muted = "9AA4BC",
			Track = "DCE3F0",
			Cloud = "FFFFFF",
			CloudAlpha = 0.1,
			Accent = "4A6FB5",
			AccentDark = "34528A",
			Grass = "FFFFFF",
			GrassDark = "DCE6F8",
			Brick = "C4D4F0",
			BrickDark = "98AED8",
			Decor = { "Clouds" },
			Particle = { "✦", false, "FFFFFF" },
		}),
		Shared = Palette({
			Accent = "D64C40",
			AccentDark = "A0342C",
			OnAccent = "FFFFFF",
			Danger = "D64C40",
			DangerDark = "A0342C",
			Blue = "468AC4",
			BlueDark = "326496",
			Good = "60AA62",
			GoodDark = "427E46",
			Coin = "F0C448",
			CoinDark = "BA8C28",
			Risky = "E28046",
			RiskyDark = "A8562C",
			Brick = "A46042",
			BrickDark = "683A28",
			Grass = "74B45C",
			GrassDark = "4E8840",
			Knob = "FFFFFF",
			Ink = "2E2838",
			White = "FFFFFF",
			Black = "000000",
		}),
	}

	-- Nullx11 is the default; all supplied +1 palettes and seasonal assets remain available.
	Themes.Nullx11 = table.clone(Themes.Dark)
	for token, value in
		pairs(Palette({
			Backdrop = "0C101C",
			BackdropAlt = "131D30",
			Topbar = "101829",
			Sidebar = "141B30",
			SidebarAlt = "101626",
			SidebarText = "F2F1F9",
			SidebarMuted = "B2BED3",
			TabActive = "A792FF",
			TabActiveText = "0C101C",
			Panel = "171D2E",
			PanelHeader = "202941",
			Element = "1C2840",
			Hover = "2D3955",
			Outline = "3C4B68",
			Shadow = "060913",
			Text = "F2F1F9",
			SubText = "BEC9DE",
			Muted = "9EADC5",
			Accent = "A792FF",
			AccentDark = "6D58AD",
			Grass = "283652",
			GrassDark = "162139",
			Brick = "23324F",
			BrickDark = "101829",
			Particle = { "*", false, "A792FF" },
		}))
	do
		Themes.Nullx11[token] = value
	end
	table.insert(Themes.Order, 1, "Nullx11")

	local State = {
		ReducedMotion = scope and scope.ReducedMotion == true,
		Gui = nil,
		Overlay = nil,
		Window = nil,
		Popup = nil,
		Drag = nil,
		Binding = nil,
		MenuKey = "LeftControl",
		ThemeName = "Overworld",
		Language = "EN",
		UserScale = 1,
		Touch = false,
		KeyPickers = {},
		Connections = {},
		Tasks = {},
		UnloadHooks = {},
		Fps = 60,
		StartTime = os.clock(),
	}

	local Util = {}
	local Anim = {}
	local Motion = {}
	local Fx = {}
	local Reactive = {}
	local Tailwind = {}
	local Draw = {}
	local Sprite = {}
	local Assets = { Overrides = {}, Cache = {} }
	local Fonts = { Texts = {}, Thai = nil }
	local Particles = { Pool = {}, Enabled = false }
	local Lang = {
		Bound = {},
		Listeners = setmetatable({}, { __mode = "k" }),
		InstanceListeners = {},
	}
	local Theme = {
		Colors = {},
		Bound = {},
		Renderers = setmetatable({}, { __mode = "k" }),
		InstanceRenderers = {},
	}
	local Layout = {
		Dirty = {},
		All = setmetatable({}, { __mode = "k" }),
		Measured = {},
		MeasuredCount = 0,
	}
	local Icons = {}
	local Creator = {}
	local Gui = { Stack = {} }
	local Popup = {}
	local Dialog = {}
	local Sheet = {}
	local Tooltip = {}
	local Notify = {}
	local Watermark = {}
	local Float = {}
	local Keybinds = {}
	local Configs = { Folder = Config.ConfigRoot .. "/default" }
	local Intro = {}
	local Widget = {}
	local Row = {}

	local Container = {}
	Container.__index = Container

	local Toggle = setmetatable({}, { __index = Widget })
	Toggle.__index = Toggle
	local Slider = setmetatable({}, { __index = Widget })
	Slider.__index = Slider
	local Dropdown = setmetatable({}, { __index = Widget })
	Dropdown.__index = Dropdown
	local Input = setmetatable({}, { __index = Widget })
	Input.__index = Input
	local Button = {}
	Button.__index = Button
	local KeyPicker = setmetatable({}, { __index = Widget })
	KeyPicker.__index = KeyPicker
	local ColorPicker = setmetatable({}, { __index = Widget })
	ColorPicker.__index = ColorPicker
	local Label = {}
	Label.__index = Label
	local Selectable = setmetatable({}, { __index = Widget })
	Selectable.__index = Selectable
	local ListBox = setmetatable({}, { __index = Widget })
	ListBox.__index = ListBox
	local Progress = setmetatable({}, { __index = Widget })
	Progress.__index = Progress
	local Stepper = setmetatable({}, { __index = Widget })
	Stepper.__index = Stepper
	local RangeSlider = setmetatable({}, { __index = Widget })
	RangeSlider.__index = RangeSlider
	local Segmented = setmetatable({}, { __index = Widget })
	Segmented.__index = Segmented
	local MultiChips = setmetatable({}, { __index = Widget })
	MultiChips.__index = MultiChips
	local StatWidget = setmetatable({}, { __index = Widget })
	StatWidget.__index = StatWidget
	local StatusWidget = setmetatable({}, { __index = Widget })
	StatusWidget.__index = StatusWidget
	local TableWidget = setmetatable({}, { __index = Widget })
	TableWidget.__index = TableWidget

	local Window = {}
	Window.__index = Window
	local Tab = {}
	Tab.__index = Tab
	local Groupbox = setmetatable({}, { __index = Container })
	Groupbox.__index = Groupbox

	Reactive.Stack = {}
	Reactive.BatchDepth = 0
	Reactive.Pending = {}
	Reactive.Disposers = {}

	function Reactive.Track(subscribers)
		local active = Reactive.Stack[#Reactive.Stack]
		if not active then
			return
		end
		subscribers[active] = true
		active.Deps[subscribers] = true
	end

	function Reactive.Trigger(subscribers)
		for effect in pairs(subscribers) do
			if Reactive.BatchDepth > 0 then
				Reactive.Pending[effect] = true
			else
				Reactive.RunEffect(effect)
			end
		end
	end

	function Reactive.CleanupEffect(effect)
		if effect.Cleanup then
			pcall(effect.Cleanup)
			effect.Cleanup = nil
		end
		for dep in pairs(effect.Deps) do
			dep[effect] = nil
		end
		table.clear(effect.Deps)
	end

	function Reactive.RunEffect(effect)
		if effect.Disposed or Library.Unloaded then
			return
		end
		Reactive.CleanupEffect(effect)
		table.insert(Reactive.Stack, effect)
		local ok, cleanup = pcall(effect.Runner)
		table.remove(Reactive.Stack)
		if ok and type(cleanup) == "function" then
			effect.Cleanup = cleanup
		end
	end

	function Reactive.Effect(runner)
		local effect =
			{ Runner = runner, Deps = {}, Disposed = false, Cleanup = nil }
		local function Dispose()
			if effect.Disposed then
				return
			end
			effect.Disposed = true
			Reactive.CleanupEffect(effect)
		end
		table.insert(Reactive.Disposers, Dispose)
		Reactive.RunEffect(effect)
		return Dispose
	end

	function Reactive.Batch(callback)
		Reactive.BatchDepth += 1
		pcall(callback)
		Reactive.BatchDepth -= 1
		if Reactive.BatchDepth > 0 then
			return
		end
		local queued = {}
		for effect in pairs(Reactive.Pending) do
			table.insert(queued, effect)
		end
		table.clear(Reactive.Pending)
		for _, effect in ipairs(queued) do
			Reactive.RunEffect(effect)
		end
	end

	local RefMethods = {}

	function RefMethods:Get()
		Reactive.Track(self._subs)
		return self._current
	end

	function RefMethods:Set(nextValue)
		if self._current == nextValue and type(nextValue) ~= "table" then
			return
		end
		local previous = self._current
		self._current = nextValue
		Reactive.Trigger(self._subs)
		for _, listener in ipairs(self._listeners) do
			pcall(listener, nextValue, previous)
		end
	end

	function RefMethods:Update(transform)
		self:Set(transform(self._current))
	end

	function RefMethods:Subscribe(listener, immediate)
		if Library.Unloaded then
			return function() end
		end
		table.insert(self._listeners, listener)
		if immediate then
			pcall(listener, self._current, nil)
		end
		local function Dispose()
			local index = table.find(self._listeners, listener)
			if index then
				table.remove(self._listeners, index)
			end
		end
		table.insert(Reactive.Disposers, Dispose)
		return Dispose
	end

	local RefMeta = {
		__index = function(self, key)
			if key == "Value" then
				Reactive.Track(self._subs)
				return self._current
			end
			return RefMethods[key]
		end,
		__newindex = function(self, key, nextValue)
			if key == "Value" then
				RefMethods.Set(self, nextValue)
				return
			end
			rawset(self, key, nextValue)
		end,
	}

	function Reactive.IsRef(candidate)
		return type(candidate) == "table"
			and rawget(candidate, "_isRef") == true
	end

	function Reactive.Ref(initial)
		return setmetatable({
			_isRef = true,
			_current = initial,
			_subs = {},
			_listeners = {},
		}, RefMeta)
	end

	function Reactive.Computed(getter)
		local derived = Reactive.Ref(nil)
		Reactive.Effect(function()
			local ok, evaluated = pcall(getter)
			if ok then
				derived:Set(evaluated)
			end
		end)
		return derived
	end

	function Reactive.Watch(source, callback, options)
		options = options or {}
		if type(source) == "string" and Library.Options[source] then
			source = Library.Options[source]
		end
		if type(source) == "table" and source.Ref then
			return source.Ref:Subscribe(callback, options.Immediate)
		end
		if Reactive.IsRef(source) then
			return source:Subscribe(callback, options.Immediate)
		end
		if type(source) == "function" then
			local computed = Reactive.Computed(source)
			return computed:Subscribe(callback, options.Immediate)
		end
		return function() end
	end

	local StoreProto = {}
	StoreProto.__index = StoreProto

	function StoreProto:Ref(key)
		local slot = self._refs[key]
		if not slot then
			slot = Reactive.Ref(nil)
			self._refs[key] = slot
		end
		return slot
	end

	function StoreProto:Get(key)
		return self:Ref(key):Get()
	end

	function StoreProto:Set(key, nextValue)
		self:Ref(key):Set(nextValue)
	end

	function StoreProto:Update(key, transform)
		local slot = self:Ref(key)
		slot:Set(transform(slot:Get()))
	end

	function StoreProto:Watch(key, callback, immediate)
		return self:Ref(key):Subscribe(callback, immediate)
	end

	function Reactive.Store(initialState)
		local store = setmetatable({ _refs = {}, State = {} }, StoreProto)
		for key, initial in pairs(initialState or {}) do
			store._refs[key] = Reactive.Ref(initial)
		end
		setmetatable(store.State, {
			__index = function(_, key)
				return store:Get(key)
			end,
			__newindex = function(_, key, nextValue)
				store:Set(key, nextValue)
			end,
		})
		return store
	end

	function Reactive.DisposeAll()
		for _, dispose in ipairs(Reactive.Disposers) do
			pcall(dispose)
		end
		table.clear(Reactive.Disposers)
		table.clear(Reactive.Pending)
		table.clear(Reactive.Stack)
	end

	function Util.Try(callback, ...)
		if type(callback) ~= "function" then
			return false
		end
		local ok, message = pcall(callback, ...)
		if not ok then
			warn("[Nullx11] " .. tostring(message))
		end
		return ok, message
	end

	function Util.Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(State.Connections, connection)
		return connection
	end

	function Util.Every(interval, callback)
		table.insert(
			State.Tasks,
			{ Interval = interval, Elapsed = 0, Run = callback }
		)
	end

	function Util.Metric(name)
		return Config.Metrics[State.Touch and "Touch" or "Desktop"][name]
	end

	function Util.TextSize(kind)
		return Config.Text[kind] + (State.Touch and 1 or 0)
	end

	function Util.IsPointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
	end

	function Util.IsMove(input)
		return input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
	end

	function Util.InputName(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			return input.KeyCode.Name
		end
		return Config.MouseNames[input.UserInputType]
	end

	function Util.KeyName(key)
		if typeof(key) == "EnumItem" then
			return key.Name
		end
		return type(key) == "string" and key or nil
	end

	function Util.Inside(guiObject, position)
		local origin, size = guiObject.AbsolutePosition, guiObject.AbsoluteSize
		return position.X >= origin.X
			and position.X <= origin.X + size.X
			and position.Y >= origin.Y
			and position.Y <= origin.Y + size.Y
	end

	function Util.GuiParent()
		if type(gethui) == "function" then
			local ok, hidden = pcall(gethui)
			if ok and typeof(hidden) == "Instance" then
				return hidden
			end
		end
		local ok = pcall(function()
			local probe = Instance.new("Folder")
			probe.Parent = CoreGui
			probe:Destroy()
		end)
		return ok and CoreGui
			or LocalPlayer:WaitForChild("PlayerGui", 10)
			or LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	---@return boolean finished, any ...  false if it errored or ran past the deadline
	function Util.Await(timeout, callback, ...)
		local box = { done = false }
		local args = table.pack(...)
		task.spawn(function()
			box.values =
				table.pack(pcall(callback, table.unpack(args, 1, args.n)))
			box.done = true
		end)
		local started = os.clock()
		while not box.done and os.clock() - started < timeout do
			task.wait(0.05)
		end
		if not box.done or not box.values[1] then
			return false
		end
		return true, table.unpack(box.values, 2, box.values.n)
	end

	local function FetchBody(url)
		local ok, body = pcall(game.HttpGet, game, url)
		if ok and type(body) == "string" then
			return body
		end
		local requester = (type(request) == "function" and request)
			or (type(http_request) == "function" and http_request)
			or (syn and syn.request)
		if not requester then
			return nil
		end
		local sent, response = pcall(requester, { Url = url, Method = "GET" })
		return sent and type(response) == "table" and response.Body or nil
	end

	---@return string?  nil on failure or after Config.HttpTimeout
	function Util.HttpGet(url)
		local finished, body = Util.Await(Config.HttpTimeout, FetchBody, url)
		return finished and type(body) == "string" and body or nil
	end

	---@return string?  nil if the executor can't serve the file
	function Util.CustomAsset(path)
		if type(getcustomasset) ~= "function" then
			return nil
		end
		local ok, asset = pcall(getcustomasset, path)
		return ok
				and type(asset) == "string"
				and asset:find("^rbxasset")
				and asset
			or nil
	end

	---isfile through SafeFile would read a stub's nil as "exists".
	function Util.Exists(path)
		if type(isfile) ~= "function" then
			return false
		end
		local ok, value = pcall(isfile, path)
		return ok and value == true
	end

	local function SafeFile(fn, ...)
		if type(fn) ~= "function" then
			return nil
		end
		local ok, value = pcall(fn, ...)
		if not ok then
			return nil
		end
		return value == nil and true or value
	end

	function Util.Clipboard(text)
		local setter = setclipboard
			or toclipboard
			or (syn and syn.write_clipboard)
		if type(setter) ~= "function" then
			return false
		end
		return (pcall(setter, text))
	end

	function Util.FileApi()
		return type(writefile) == "function"
			and type(readfile) == "function"
			and type(isfile) == "function"
	end

	function Util.EnsureFolder(path)
		if type(makefolder) ~= "function" or type(isfolder) ~= "function" then
			return
		end
		local built = ""
		for part in path:gmatch("[^/]+") do
			built = built == "" and part or built .. "/" .. part
			local okCheck, exists = pcall(isfolder, built)
			if
				not (okCheck and exists == true)
				and not pcall(makefolder, built)
			then
				return false
			end
		end
		return true
	end

	-- Keep UTF-8 characters (including Thai); strip only invalid path characters
	function Util.Sanitize(name)
		local clean = tostring(name)
			:gsub('[%c/\\:%*%?"<>|]', "")
			:gsub("^%s+", "")
			:gsub("%s+$", "")
		return clean ~= "" and clean or "config"
	end

	function Util.Round(value, decimals)
		local factor = 10 ^ (decimals or 0)
		return math.floor(value * factor + 0.5) / factor
	end

	function Util.ToSet(value)
		local set = {}
		if type(value) ~= "table" then
			return set
		end
		for key, entry in pairs(value) do
			if type(key) == "number" then
				set[entry] = true
			elseif entry then
				set[key] = true
			end
		end
		return set
	end

	function Util.PlayerNames()
		local names = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				table.insert(names, player.Name)
			end
		end
		table.sort(names)
		return names
	end

	function Util.Lighten(color, amount)
		return color:Lerp(Color3.new(1, 1, 1), amount)
	end

	function Util.Hex(color)
		return string.format(
			"#%02X%02X%02X",
			math.floor(color.R * 255 + 0.5),
			math.floor(color.G * 255 + 0.5),
			math.floor(color.B * 255 + 0.5)
		)
	end

	function Util.FromHex(text)
		local hex = tostring(text):gsub("#", "")
		if not hex:match("^%x%x%x%x%x%x$") then
			return nil
		end
		return Color3.fromRGB(
			tonumber(hex:sub(1, 2), 16),
			tonumber(hex:sub(3, 4), 16),
			tonumber(hex:sub(5, 6), 16)
		)
	end

	Anim.Loops = {}
	Anim.GroupState = {}
	Anim.NoopSignal = {
		Once = function(_, fn)
			if type(fn) == "function" then
				task.defer(fn)
			end
		end,
	}
	Anim.NoopTween = {
		Completed = Anim.NoopSignal,
		Cancel = function() end,
		Pause = function() end,
		Play = function() end,
	}

	function Anim.Info(duration, ease, repeatCount, reverses, delay)
		local style = Config.Ease[ease or "Out"]
		return TweenInfo.new(
			duration or Config.Tween.Normal,
			style[1],
			style[2],
			repeatCount or 0,
			reverses or false,
			delay or 0
		)
	end

	function Anim.Tween(
		inst,
		goal,
		duration,
		ease,
		repeatCount,
		reverses,
		delay
	)
		if
			State.ReducedMotion
			or (duration == 0 and (repeatCount or 0) == 0 and (delay or 0) == 0)
		then
			for prop, val in pairs(goal) do
				inst[prop] = val
			end
			return Anim.NoopTween
		end
		local tween = TweenService:Create(
			inst,
			Anim.Info(duration, ease, repeatCount, reverses, delay),
			goal
		)
		tween:Play()
		if repeatCount == -1 then
			inst.Destroying:Once(function()
				tween:Cancel()
			end)
		end
		return tween
	end

	-- Register a visibility-gated infinite tween under a named lifecycle group
	function Anim.Loop(group, inst, goal, duration, ease, reverses, delay)
		if State.ReducedMotion then
			return Anim.NoopTween
		end
		local tween = TweenService:Create(
			inst,
			Anim.Info(duration, ease, -1, reverses, delay),
			goal
		)
		local list = Anim.Loops[group]
		if not list then
			list = {}
			Anim.Loops[group] = list
		end
		local active = Anim.GroupState[group] ~= false
		local entry = { Tween = tween, Inst = inst, Playing = active }
		table.insert(list, entry)
		if active then
			tween:Play()
		end
		inst.Destroying:Once(function()
			tween:Cancel()
			entry.Dead = true
		end)
		return tween
	end

	function Anim.SetGroupActive(group, active)
		active = active == true and not State.ReducedMotion
		if Anim.GroupState[group] == active then
			return
		end
		Anim.GroupState[group] = active
		local list = Anim.Loops[group]
		if not list then
			return
		end
		for index = #list, 1, -1 do
			local entry = list[index]
			if entry.Dead or not entry.Inst or not entry.Inst.Parent then
				table.remove(list, index)
			elseif active and not entry.Playing then
				entry.Playing = true
				entry.Tween:Play()
			elseif not active and entry.Playing then
				entry.Playing = false
				entry.Tween:Pause()
			end
		end
	end

	function Anim.Pop(scale, from)
		scale.Scale = from or 0.85
		return Anim.Tween(scale, { Scale = 1 }, Config.Tween.Pop, "Back")
	end

	--@param rise Vertical bounce height in px (short vertical bounce)
	function Anim.Bump(frame, rise)
		if State.ReducedMotion then
			return
		end
		if frame:GetAttribute("Bumping") then
			return
		end
		frame:SetAttribute("Bumping", true)
		local base = frame.Position
		local tween = Anim.Tween(
			frame,
			{ Position = base - UDim2.fromOffset(0, rise or 6) },
			0.09,
			"Out",
			0,
			true
		)
		tween.Completed:Once(function()
			frame.Position = base
			frame:SetAttribute("Bumping", nil)
		end)
	end

	function Anim.Shake(frame)
		if State.ReducedMotion then
			return
		end
		local base = frame.Position
		task.spawn(function()
			for _, offset in ipairs({ -7, 6, -4, 3, 0 }) do
				if not frame.Parent then
					return
				end
				Anim.Tween(
					frame,
					{ Position = base + UDim2.fromOffset(offset, 0) },
					0.04,
					"Linear"
				)
				task.wait(0.04)
			end
			frame.Position = base
		end)
	end

	function Anim.Fade(root, alpha, duration)
		local targets = root:GetDescendants()
		table.insert(targets, root)
		for _, inst in ipairs(targets) do
			if inst:IsA("GuiObject") and inst.BackgroundTransparency < 1 then
				Anim.Tween(inst, { BackgroundTransparency = alpha }, duration)
			end
			if inst:IsA("TextLabel") or inst:IsA("TextButton") then
				Anim.Tween(inst, { TextTransparency = alpha }, duration)
			elseif inst:IsA("ImageLabel") then
				Anim.Tween(inst, { ImageTransparency = alpha }, duration)
			elseif inst:IsA("UIStroke") then
				Anim.Tween(inst, { Transparency = alpha }, duration)
			end
		end
	end

	--@param origin UDim2 spawn position inside parent
	function Anim.CoinPop(parent, origin, size)
		local coin = Sprite.New(parent, "coin", size or 20)
		coin.AnchorPoint = Vector2.new(0.5, 1)
		coin.Position = origin
		coin.ZIndex = 5
		local rise = Anim.Tween(
			coin,
			{ Position = origin - UDim2.fromOffset(0, 42) },
			0.35,
			"Out"
		)
		Anim.Tween(
			coin,
			{ Size = UDim2.fromOffset(2, coin.Size.Y.Offset) },
			0.12,
			"Sine",
			3,
			true
		)
		rise.Completed:Once(function()
			Anim.Fade(coin, 1, 0.18)
			task.delay(0.2, function()
				coin:Destroy()
			end)
		end)
	end

	function Theme.Apply(name)
		if name == "Order" or name == "Shared" or not Themes[name] then
			name = "Overworld"
		end
		local palette = Themes[name]
		State.ThemeName = name
		Theme.Colors.Logo, Theme.Colors.Glow, Theme.Colors.Fog, Theme.Colors.ParticleGlyphs =
			nil, nil, nil, nil
		Theme.Colors.TopbarText = Themes.Shared.White
		for token, color in pairs(Themes.Shared) do
			Theme.Colors[token] = color
		end
		for token, color in pairs(palette) do
			Theme.Colors[token] = color
		end
		for inst, map in pairs(Theme.Bound) do
			if inst.Parent then
				Theme.Paint(inst, map)
			else
				Theme.Bound[inst] = nil
			end
		end
		for owner, render in pairs(Theme.Renderers) do
			Util.Try(render)
		end
		for inst, render in pairs(Theme.InstanceRenderers) do
			if inst.Parent then
				Util.Try(render)
			else
				Theme.InstanceRenderers[inst] = nil
			end
		end
	end

	-- O(1) parent check to prune destroyed Instance keys from registries
	function Theme.Prune()
		for _, registry in ipairs({
			Theme.Bound,
			Theme.InstanceRenderers,
			Lang.Bound,
			Lang.InstanceListeners,
			Fonts.Texts,
		}) do
			for inst in pairs(registry) do
				if not inst.Parent then
					registry[inst] = nil
				end
			end
		end
	end

	function Theme.UnbindTree(root)
		if not root then
			return
		end
		local list = root:GetDescendants()
		table.insert(list, root)
		for _, inst in ipairs(list) do
			Theme.Bound[inst] = nil
			Theme.InstanceRenderers[inst] = nil
			Lang.Bound[inst] = nil
			Lang.InstanceListeners[inst] = nil
			Fonts.Texts[inst] = nil
		end
	end

	function Theme.Paint(inst, map)
		for property, token in pairs(map) do
			local color = Theme.Colors[token]
			if color ~= nil and inst[property] ~= color then
				inst[property] = color
			end
		end
	end

	function Theme.Bind(inst, map)
		local existing = Theme.Bound[inst]
		if existing then
			for property, token in pairs(map) do
				existing[property] = token
			end
		else
			Theme.Bound[inst] = map
		end
		Theme.Paint(inst, map)
		return inst
	end

	function Theme.OnRender(owner, render)
		local registry = typeof(owner) == "Instance" and Theme.InstanceRenderers
			or Theme.Renderers
		registry[owner] = render
		Util.Try(render)
	end

	Lang.Strings = {
		Search = { EN = "Search...", TH = "ค้นหา..." },
		Confirm = {
			EN = "Click again to confirm",
			TH = "กดอีกครั้งเพื่อยืนยัน",
		},
		None = { EN = "None", TH = "ไม่มี" },
		NoResults = {
			EN = "No matches",
			TH = "ไม่พบรายการ",
		},
		Settings = { EN = "Settings", TH = "ตั้งค่า" },
		SettingsDesc = {
			EN = "Interface, language and configs",
			TH = "หน้าตา ภาษา และคอนฟิก",
		},
		Interface = { EN = "Interface", TH = "หน้าตา" },
		Language = { EN = "Language", TH = "ภาษา" },
		ThemeName = { EN = "Theme", TH = "ธีม" },
		Scale = { EN = "UI scale", TH = "ขนาด UI" },
		MenuKey = {
			EN = "Menu key",
			TH = "ปุ่มเปิดเมนู",
		},
		Watermark = {
			EN = "Watermark",
			TH = "วอเตอร์มาร์ก",
		},
		WatermarkDesc = {
			EN = "Hub name, FPS, ping and play time",
			TH = "ชื่อฮับ FPS ปิง และเวลาที่เล่น",
		},
		FloatButton = {
			EN = "Mobile button",
			TH = "ปุ่มลอยมือถือ",
		},
		FloatDesc = {
			EN = "Floating block that opens the menu",
			TH = "กล่อง ? ลอยสำหรับเปิดปิดเมนู",
		},
		Configs = { EN = "Configs", TH = "คอนฟิก" },
		ConfigName = {
			EN = "Config name",
			TH = "ชื่อคอนฟิก",
		},
		SavedConfigs = {
			EN = "Saved configs",
			TH = "คอนฟิกที่บันทึกไว้",
		},
		Save = { EN = "Save", TH = "บันทึก" },
		Load = { EN = "Load", TH = "โหลด" },
		Delete = { EN = "Delete", TH = "ลบ" },
		Refresh = { EN = "Refresh", TH = "รีเฟรช" },
		SetAutoload = {
			EN = "Load on start",
			TH = "โหลดอัตโนมัติ",
		},
		Autoload = {
			EN = "Autoload: %s",
			TH = "โหลดอัตโนมัติ: %s",
		},
		PickConfig = {
			EN = "Type or select a config name first",
			TH = "พิมพ์หรือเลือกชื่อคอนฟิกก่อน",
		},
		NoFileApi = {
			EN = "This executor cannot save files",
			TH = "executor นี้บันทึกไฟล์ไม่ได้",
		},
		ConfigMissing = {
			EN = "Config not found",
			TH = "ไม่พบคอนฟิก",
		},
		ConfigBroken = {
			EN = "Config file is damaged",
			TH = "ไฟล์คอนฟิกเสีย",
		},
		About = { EN = "About", TH = "เกี่ยวกับ" },
		Unload = { EN = "Unload hub", TH = "ปิดสคริปต์" },
		Rejoin = {
			EN = "Rejoin",
			TH = "เข้าเซิร์ฟใหม่",
		},
		IntroSteps = {
			EN = {
				"Warming up the warp pipe...",
				"Collecting coins...",
				"Building the castle...",
				"Let's-a go!",
			},
			TH = {
				"กำลังอุ่นท่อวาร์ป...",
				"กำลังเก็บเหรียญ...",
				"กำลังสร้างปราสาท...",
				"ลุยกันเลย!",
			},
		},
		Ready = {
			EN = "Ready. Press %s to toggle the menu.",
			TH = "พร้อมแล้ว กด %s เพื่อเปิดปิดเมนู",
		},
		ReadyTouch = {
			EN = "Ready. Tap the ? block to toggle the menu.",
			TH = "พร้อมแล้ว แตะกล่อง ? เพื่อเปิดปิดเมนู",
		},
		Hidden = {
			EN = "Menu hidden. Press %s to open.",
			TH = "ซ่อนเมนูแล้ว กด %s เพื่อเปิด",
		},
		Session = { EN = "TIME", TH = "เวลา" },
		Empty = {
			EN = "Nothing here yet",
			TH = "ยังไม่มีรายการ",
		},
		Particles = {
			EN = "Ambient particles",
			TH = "ละอองตกแต่ง",
		},
		ParticlesDesc = {
			EN = "Floating sparkles behind the menu",
			TH = "ประกายลอยด้านหลังเมนู",
		},
		Device = { EN = "Device: %s", TH = "อุปกรณ์: %s" },
	}

	function Lang.HasThai(text)
		return text:find("\224[\184\185]") ~= nil
	end

	--@return string localized for active language from {EN,TH}, "English / Thai", or plain string
	function Lang.Resolve(spec)
		if type(spec) == "table" then
			return spec[State.Language] or spec.EN or spec.TH or ""
		end
		if type(spec) ~= "string" then
			return spec == nil and "" or tostring(spec)
		end
		local english, thai = spec:match("^(.-)%s+·%s+(.+)$")
		if english and Lang.HasThai(thai) then
			return State.Language == "TH" and thai or english
		end
		return spec
	end

	function Lang.Get(key, ...)
		local text = Lang.Resolve(Lang.Strings[key] or key)
		if select("#", ...) > 0 then
			return string.format(text, ...)
		end
		return text
	end

	function Lang.SearchText(spec)
		if type(spec) == "table" then
			return ((spec.EN or "") .. " " .. (spec.TH or "")):lower()
		end
		return tostring(spec or ""):lower()
	end

	--@param transform Optional text formatter (e.g., string.upper)
	function Lang.Bind(inst, spec, property, transform)
		local binding = {
			Spec = spec,
			Property = property or "Text",
			Transform = transform,
		}
		Lang.Bound[inst] = binding
		Lang.Apply(inst, binding)
	end

	function Lang.Apply(inst, binding)
		local text = Lang.Resolve(binding.Spec)
		inst[binding.Property] = binding.Transform and binding.Transform(text)
			or text
	end

	function Lang.OnChange(owner, callback)
		local registry = typeof(owner) == "Instance" and Lang.InstanceListeners
			or Lang.Listeners
		registry[owner] = callback
	end

	function Lang.Set(code)
		if code ~= "EN" and code ~= "TH" then
			return
		end
		State.Language = code
		if code == "TH" then
			Fonts.LoadThaiAsync()
		end
		Theme.Prune()
		for inst, binding in pairs(Lang.Bound) do
			Lang.Apply(inst, binding)
		end
		Fonts.ApplyAll()
		for _, registry in ipairs({ Lang.Listeners, Lang.InstanceListeners }) do
			for _, callback in pairs(registry) do
				Util.Try(callback, code)
			end
		end
		Layout.MarkAll()
	end

	Fonts.Latin = {
		Display = Enum.Font.LuckiestGuy,
		Body = Enum.Font.FredokaOne,
		Desc = Enum.Font.BuilderSansMedium,
		Strong = Enum.Font.BuilderSansBold,
		Logo = Enum.Font.Arcade,
		Glyph = Enum.Font.BuilderSansBold,
	}
	Fonts.ThaiWeights = {
		Display = Enum.FontWeight.SemiBold,
		Body = Enum.FontWeight.Medium,
		Desc = Enum.FontWeight.Regular,
		Strong = Enum.FontWeight.SemiBold,
	}
	Fonts.ThaiFallback = {
		Display = Enum.Font.BuilderSansBold,
		Body = Enum.Font.BuilderSansBold,
		Desc = Enum.Font.BuilderSansMedium,
		Strong = Enum.Font.BuilderSansBold,
	}
	Fonts.Faces = {}

	--@return Font face for role and active language (Kanit when Thai font loaded)
	function Fonts.Face(kind)
		local thai = State.Language == "TH" and Fonts.ThaiWeights[kind] ~= nil
		local key = (thai and (Fonts.Thai and "TH" or "THF") or "EN") .. kind
		local cached = Fonts.Faces[key]
		if cached then
			return cached
		end
		local face
		if thai and Fonts.Thai then
			face = Font.new(Fonts.Thai, Fonts.ThaiWeights[kind])
		elseif thai then
			face = Font.fromEnum(Fonts.ThaiFallback[kind])
		else
			face = Font.fromEnum(Fonts.Latin[kind] or Fonts.Latin.Body)
		end
		Fonts.Faces[key] = face
		return face
	end

	function Fonts.Size(kind, base)
		return math.max(
			14,
			base + (State.Language == "TH" and Config.ThaiSizeBonus[kind] or 0)
		)
	end

	function Fonts.Style(label, kind, base)
		Fonts.Texts[label] = { Kind = kind, Base = base }
		label.FontFace = Fonts.Face(kind)
		label.TextSize = Fonts.Size(kind, base)
	end

	function Fonts.ApplyAll()
		table.clear(Layout.Measured)
		Layout.MeasuredCount = 0
		for label, style in pairs(Fonts.Texts) do
			label.FontFace = Fonts.Face(style.Kind)
			label.TextSize = Fonts.Size(style.Kind, style.Base)
		end
	end

	function Fonts.FetchFace(weight, name)
		local path = Config.FontDir .. "/kanit-" .. weight .. ".ttf"
		local cached = Util.Exists(path) and SafeFile(readfile, path)
		if type(cached) ~= "string" or cached:sub(1, 4) ~= "\0\1\0\0" then
			local body =
				Util.HttpGet(string.format(Config.ThaiFont.Source, name))
			if type(body) ~= "string" or body:sub(1, 4) ~= "\0\1\0\0" then
				return nil
			end
			SafeFile(writefile, path, body)
			local check = SafeFile(readfile, path)
			if type(check) ~= "string" or #check ~= #body then
				Fonts.Disable("binary write")
				return nil
			end
		end
		local asset = Util.CustomAsset(path)
		if not asset then
			Fonts.Disable("getcustomasset ttf")
			return nil
		end
		return string.format(
			'{"name":"W%d","weight":%d,"style":"normal","assetId":"%s"}',
			weight,
			weight,
			asset
		)
	end

	function Fonts.Disable(reason)
		Fonts.Broken = true
		SafeFile(writefile, Config.FontDir .. "/disabled", tostring(reason))
		warn("[Nullx11] Thai font off: " .. tostring(reason))
	end

	function Fonts.LoadThai()
		if
			Fonts.Thai
			or Fonts.Broken
			or not Util.FileApi()
			or type(getcustomasset) ~= "function"
		then
			return Fonts.Thai ~= nil
		end
		if Util.Exists(Config.FontDir .. "/disabled") then
			Fonts.Broken = true
			return false
		end
		Util.EnsureFolder(Config.FontDir)
		local faces = {}
		for weight, name in pairs(Config.ThaiFont.Weights) do
			if Fonts.Broken or Library.Unloaded then
				return false
			end
			table.insert(faces, Fonts.FetchFace(weight, name))
		end
		if #faces == 0 then
			return false
		end
		local descriptor = Config.FontDir .. "/kanit.font"
		if Util.Exists(descriptor) then
			SafeFile(delfile, descriptor)
		end
		SafeFile(
			writefile,
			descriptor,
			'{"name":"'
				.. Config.ThaiFont.Family
				.. '","faces":['
				.. table.concat(faces, ",")
				.. "]}"
		)
		local family = Util.CustomAsset(descriptor)
		if not family then
			Fonts.Disable("getcustomasset family")
			return false
		end
		Fonts.Thai = family
		table.clear(Fonts.Faces)
		if State.Language == "TH" and State.Gui then
			Fonts.ApplyAll()
			Layout.MarkAll()
		end
		task.spawn(Fonts.Preload)
		return true
	end

	function Fonts.LoadThaiAsync()
		if Fonts.Thai or Fonts.Broken or Fonts.Loading then
			return
		end
		Fonts.Loading = true
		task.spawn(function()
			local finished = Util.Await(Config.FontTimeout, Fonts.LoadThai)
			Fonts.Loading = false
			if
				not finished
				and not Fonts.Thai
				and not Fonts.Broken
				and not Library.Unloaded
			then
				Fonts.Disable("timeout")
			end
		end)
	end

	function Fonts.Preload()
		local provider = game:GetService("ContentProvider")
		local probes = {}
		for _, weight in pairs(Fonts.ThaiWeights) do
			table.insert(
				probes,
				Draw.New(
					"TextLabel",
					{ Text = "ก", FontFace = Font.new(Fonts.Thai, weight) }
				)
			)
		end
		Util.Await(
			Config.PreloadTimeout,
			provider.PreloadAsync,
			provider,
			probes
		)
		for _, probe in ipairs(probes) do
			probe:Destroy()
		end
	end

	function Draw.New(className, props)
		local inst = Instance.new(className)
		local parent = props and props.Parent
		if props then
			for property, value in pairs(props) do
				if property ~= "Parent" then
					inst[property] = value
				end
			end
		end
		if inst:IsA("GuiObject") then
			inst.BorderSizePixel = 0
		end
		inst.Parent = parent
		return inst
	end

	function Draw.Corner(parent, radius)
		return Draw.New("UICorner", {
			CornerRadius = typeof(radius) == "UDim" and radius
				or UDim.new(0, radius or 8),
			Parent = parent,
		})
	end

	function Draw.Stroke(parent, token, thickness, border)
		local stroke = Draw.New("UIStroke", {
			Thickness = thickness or 2,
			ApplyStrokeMode = border and Enum.ApplyStrokeMode.Border
				or Enum.ApplyStrokeMode.Contextual,
			LineJoinMode = Enum.LineJoinMode.Round,
			Parent = parent,
		})
		Theme.Bind(stroke, { Color = token or "Outline" })
		return stroke
	end

	function Draw.Padding(parent, top, right, bottom, left)
		return Draw.New("UIPadding", {
			PaddingTop = UDim.new(0, top or 0),
			PaddingRight = UDim.new(0, right or top or 0),
			PaddingBottom = UDim.new(0, bottom or top or 0),
			PaddingLeft = UDim.new(0, left or right or top or 0),
			Parent = parent,
		})
	end

	function Draw.List(parent, gap, horizontal, alignX, alignY)
		return Draw.New("UIListLayout", {
			Padding = UDim.new(0, gap or 0),
			FillDirection = horizontal and Enum.FillDirection.Horizontal
				or Enum.FillDirection.Vertical,
			HorizontalAlignment = alignX or Enum.HorizontalAlignment.Left,
			VerticalAlignment = alignY or Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = parent,
		})
	end

	--@param spec Text string or {EN,TH} table bound to active language
	function Draw.Text(props, font, size, token, spec)
		props.BackgroundTransparency = 1
		props.Text = props.Text or ""
		props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
		props.RichText = props.RichText or false
		local className = props.ClassName or "TextLabel"
		props.ClassName = nil
		local label = Draw.New(className, props)
		Fonts.Style(label, font or "Body", size or Util.TextSize("Label"))
		Theme.Bind(label, { TextColor3 = token or "Text" })
		if spec ~= nil then
			Lang.Bind(label, spec)
		end
		return label
	end

	function Draw.Box(className, props, fill, stroke, radius, thickness)
		local box = Draw.New(className, props)
		if fill then
			Theme.Bind(box, { BackgroundColor3 = fill })
		elseif props.BackgroundTransparency == nil then
			box.BackgroundTransparency = 1
		end
		if radius then
			Draw.Corner(box, radius)
		end
		if stroke then
			Draw.Stroke(box, stroke, thickness or 2, true)
		end
		if box:IsA("GuiButton") then
			box.AutoButtonColor = false
			if box:IsA("TextButton") then
				box.Text = ""
			end
		end
		return box
	end

	--@return holder, face, shade, depth Raised block with shadow depth
	function Draw.Block(parent, faceToken, shadeToken, radius, depth)
		depth = depth or 4
		local holder =
			Draw.New("Frame", { BackgroundTransparency = 1, Parent = parent })
		local shade = Draw.Box("Frame", {
			Position = UDim2.fromOffset(0, depth),
			Size = UDim2.new(1, 0, 1, -depth),
			Parent = holder,
		}, shadeToken, "Outline", radius, 2)
		local face = Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, -depth), Parent = holder },
			faceToken,
			"Outline",
			radius,
			2
		)
		return holder, face, shade, depth
	end

	function Draw.Cloud(parent, width, token)
		local cloud = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(width, width * 0.5),
			Parent = parent,
		})
		local puffs =
			{ { 0, 0.35, 0.42 }, { 0.24, 0, 0.55 }, { 0.55, 0.18, 0.45 } }
		for _, puff in ipairs(puffs) do
			local ball = Draw.New("Frame", {
				Position = UDim2.fromScale(puff[1], puff[2]),
				Size = UDim2.fromScale(puff[3], puff[3] * 2),
				Parent = cloud,
			})
			Draw.Corner(ball, UDim.new(1, 0))
			Theme.Bind(ball, { BackgroundColor3 = token or "Cloud" })
			Theme.OnRender(ball, function()
				ball.BackgroundTransparency = Theme.Colors.CloudAlpha or 0
			end)
		end
		local base = Draw.New("Frame", {
			Position = UDim2.fromScale(0.08, 0.6),
			Size = UDim2.fromScale(0.86, 0.4),
			Parent = cloud,
		})
		Draw.Corner(base, UDim.new(1, 0))
		Theme.Bind(base, { BackgroundColor3 = token or "Cloud" })
		Theme.OnRender(base, function()
			base.BackgroundTransparency = Theme.Colors.CloudAlpha or 0
		end)
		return cloud
	end

	-- Static prism/circuit insignia: geometric geometry only, never an avatar,
	-- a copyrighted character image or a single-letter monogram.
	function Draw.Emblem(parent, size)
		return Draw.DrawnEmblem(parent, size)
	end

	function Draw.DrawnEmblem(parent, size)
		local emblem = Draw.Box("Frame", {
			Name = "Nullx11Prism",
			Size = UDim2.fromOffset(size, size),
			Parent = parent,
		}, "Panel", "Outline", 10, 2)
		Draw.New("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(34, 39, 65),
				Color3.fromRGB(14, 19, 34)
			),
			Rotation = 45,
			Parent = emblem,
		})
		local rim = Draw.New("Frame", {
			Name = "PrismRim",
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.09, 0.09),
			Size = UDim2.fromScale(0.82, 0.82),
			Parent = emblem,
		})
		Draw.Corner(rim, 8)
		local stroke = Draw.Stroke(rim, "Accent", 1)
		Draw.New("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(164, 143, 255),
				Color3.fromRGB(96, 220, 224)
			),
			Rotation = 45,
			Parent = stroke,
		})
		for _, shape in ipairs({
			{ 0.35, 0.29, 0.075, 0.34, 55 },
			{ 0.65, 0.29, 0.075, 0.34, -55 },
			{ 0.35, 0.71, 0.075, 0.34, -55 },
			{ 0.65, 0.71, 0.075, 0.34, 55 },
			{ 0.19, 0.50, 0.055, 0.31, 0 },
			{ 0.81, 0.50, 0.055, 0.31, 0 },
			{ 0.50, 0.50, 0.19, 0.19, 45 },
		}) do
			Draw.Box("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(shape[1], shape[2]),
				Size = UDim2.fromScale(shape[3], shape[4]),
				Rotation = shape[5],
				Parent = emblem,
			}, "Accent", nil, 1)
		end
		return emblem
	end

	function Draw.Bricks(parent, columns, token)
		local mortar = {}
		for row = 0, 1 do
			local shift = row == 0 and 0 or 0.5 / columns
			for column = 1, columns - 1 do
				local xScale = column / columns + shift
				if xScale > 0.02 and xScale < 0.98 then
					table.insert(
						mortar,
						Draw.New("Frame", {
							Position = UDim2.new(xScale, 0, row * 0.5, 0),
							Size = UDim2.new(0, 2, 0.5, 0),
							Parent = parent,
						})
					)
				end
			end
		end
		local seam = Draw.New("Frame", {
			Position = UDim2.new(0, 0, 0.5, -1),
			Size = UDim2.new(1, 0, 0, 2),
			Parent = parent,
		})
		table.insert(mortar, seam)
		for _, line in ipairs(mortar) do
			Theme.Bind(line, { BackgroundColor3 = token or "BrickDark" })
		end
	end

	function Assets.Configure(map)
		if type(map) ~= "table" then
			return
		end
		for name, source in pairs(map) do
			Assets.Overrides[tostring(name):lower()] = source
			Assets.Cache[tostring(name):lower()] = nil
		end
	end

	function Assets.Download(name, url)
		if type(getcustomasset) ~= "function" or not Util.FileApi() then
			return nil
		end
		local path = Config.AssetDir .. "/" .. Util.Sanitize(name) .. ".png"
		if not Util.Exists(path) then
			local body = Util.HttpGet(url)
			if type(body) ~= "string" or #body < 8 then
				return nil
			end
			Util.EnsureFolder(Config.AssetDir)
			SafeFile(writefile, path, body)
		end
		return Util.CustomAsset(path)
	end

	--@return Resolved asset content ID override, or nil for procedural sprites
	function Assets.Resolve(name)
		local key = tostring(name):lower()
		local cached = Assets.Cache[key]
		if cached ~= nil then
			return cached or nil
		end
		local source = Assets.Overrides[key]
		local content
		if type(source) == "number" then
			content = "rbxassetid://" .. source
		elseif type(source) == "string" and source:find("^rbxasset") then
			content = source
		elseif type(source) == "string" and source:match("^https?://") then
			content = Assets.Download(key, source)
		elseif type(source) == "string" and Util.Exists(source) then
			content = Util.CustomAsset(source)
		end
		Assets.Cache[key] = content or false
		return content
	end

	Sprite.Palette = {
		k = Color3.fromRGB(24, 20, 30),
		w = Color3.fromRGB(255, 255, 255),
		r = Color3.fromRGB(229, 37, 33),
		s = Color3.fromRGB(252, 216, 168),
		y = Color3.fromRGB(252, 208, 0),
		Y = Color3.fromRGB(196, 132, 0),
		q = Color3.fromRGB(248, 184, 0),
		Q = Color3.fromRGB(184, 104, 0),
		o = Color3.fromRGB(255, 140, 26),
		g = Color3.fromRGB(67, 176, 71),
		G = Color3.fromRGB(38, 116, 44),
		l = Color3.fromRGB(150, 226, 122),
		n = Color3.fromRGB(154, 160, 166),
		N = Color3.fromRGB(46, 46, 58),
		B = Color3.fromRGB(200, 86, 28),
		m = Color3.fromRGB(90, 42, 14),
		b = Color3.fromRGB(4, 156, 216),
		p = Color3.fromRGB(156, 92, 220),
		P = Color3.fromRGB(96, 44, 150),
	}

	Sprite.Art = {
		qblock = {
			"..kkkk..",
			".kppppk.",
			"kppwwppk",
			"kpwppwpk",
			"kpwppwpk",
			"kppwwppk",
			".kppppk.",
			"..kkkk..",
		},
		gear = {
			"...ww...",
			".wwwwww.",
			".ww..ww.",
			"ww.ww.ww",
			"ww.ww.ww",
			".ww..ww.",
			".wwwwww.",
			"...ww...",
		},
		star = {
			"...ww...",
			"..wppw..",
			".wppppw.",
			"wppwwppw",
			"wppwwppw",
			".wppppw.",
			"..wppw..",
			"...ww...",
		},
		heart = {
			"........",
			".ww..ww.",
			"wppwwppw",
			"wppppppw",
			".wppppw.",
			"..wppw..",
			"...ww...",
			"........",
		},
	}
	Sprite.Alias = {
		settings = "gear",
		["sliders-horizontal"] = "gear",
		zap = "star",
		check = "star",
		heart = "heart",
	}
	Sprite.Swaps = {}

	Sprite.Templates = {}

	function Sprite.Resolve(name)
		name = tostring(name or "qblock"):lower():gsub("^lucide%-", "")
		name = Sprite.Alias[name] or name
		if Sprite.Art[name] or Sprite.Swaps[name] then
			return name
		end
		return "qblock"
	end

	-- 2D overdraw-aware greedy rectangle meshing: base colors bridge across detail pixels painted on higher ZIndex layers
	function Sprite.Template(name)
		if Sprite.Templates[name] then
			return Sprite.Templates[name]
		end
		local swap = Sprite.Swaps[name]
		local rows = Sprite.Art[swap and swap.base or name] or Sprite.Art.qblock
		local recolor = swap and swap.swap or {}
		local height, width = #rows, #rows[1]
		local holder =
			Draw.New("Frame", { Name = "Sprite", BackgroundTransparency = 1 })
		local freq, colors = {}, {}
		for y = 1, height do
			local line = rows[y]
			for x = 1, width do
				local ch = line:sub(x, x)
				if ch ~= "." then
					if not freq[ch] then
						freq[ch] = 0
						table.insert(colors, ch)
					end
					freq[ch] += 1
				end
			end
		end
		table.sort(colors, function(a, b)
			if (a == "k") ~= (b == "k") then
				return a == "k"
			end
			if freq[a] ~= freq[b] then
				return freq[a] > freq[b]
			end
			return a < b
		end)
		local order = {}
		for idx, ch in ipairs(colors) do
			order[ch] = idx
		end
		local painted = {}
		for layerIdx, col in ipairs(colors) do
			local fill = Sprite.Palette[recolor[col] or col] or Sprite.Palette.k
			for y = 1, height do
				local line = rows[y]
				for x = 1, width do
					local cellIdx = (y - 1) * width + x
					if line:sub(x, x) == col and painted[cellIdx] ~= col then
						local stopX = x
						while stopX < width do
							local nextCh = line:sub(stopX + 1, stopX + 1)
							if
								nextCh == col
								or (order[nextCh] and order[nextCh] > layerIdx)
							then
								stopX += 1
							else
								break
							end
						end
						while stopX > x and line:sub(stopX, stopX) ~= col do
							stopX -= 1
						end
						local stopY = y
						while stopY < height do
							local nextLine = rows[stopY + 1]
							local okRow = true
							for cx = x, stopX do
								local nextCh = nextLine:sub(cx, cx)
								if
									nextCh ~= col
									and not (
										order[nextCh]
										and order[nextCh] > layerIdx
									)
								then
									okRow = false
									break
								end
							end
							if not okRow then
								break
							end
							stopY += 1
						end
						while stopY > y do
							local checkLine = rows[stopY]
							local hasCol = false
							for cx = x, stopX do
								if
									checkLine:sub(cx, cx) == col
									and painted[(stopY - 1) * width + cx]
										~= col
								then
									hasCol = true
									break
								end
							end
							if hasCol then
								break
							end
							stopY -= 1
						end
						for cy = y, stopY do
							local base = (cy - 1) * width
							for cx = x, stopX do
								painted[base + cx] = col
							end
						end
						Draw.New("Frame", {
							BackgroundColor3 = fill,
							Position = UDim2.fromScale(
								(x - 1) / width,
								(y - 1) / height
							),
							Size = UDim2.fromScale(
								(stopX - x + 1) / width,
								(stopY - y + 1) / height
							),
							ZIndex = layerIdx,
							Parent = holder,
						})
					end
				end
			end
		end
		Sprite.Templates[name] = holder
		return holder
	end

	--@param size Width in px (multiples of 12 align cleanly to the 12x12 grid)
	function Sprite.New(parent, name, size)
		local key = Sprite.Resolve(name)
		local image = Assets.Resolve(tostring(name):lower())
			or Assets.Resolve(key)
		local sprite
		if image then
			sprite = Draw.New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = image,
				ScaleType = Enum.ScaleType.Fit,
				ResampleMode = Enum.ResamplerMode.Pixelated,
			})
		else
			sprite = Sprite.Template(key):Clone()
		end
		sprite.Size = UDim2.fromOffset(size, size)
		sprite.Parent = parent
		return sprite
	end

	-- Nullx11 Native Sprite + Crisp Vector SVG Icon Engine (Zero Emoji)
	local ExtraSprites = {
		sword = {
			".........kkk",
			"........kwwk",
			".......kwwwk",
			"......kwwwk.",
			".....kwwwk..",
			".kk.kwwwk...",
			"kyykwwwk....",
			".kyyyyk.....",
			"..kyykll....",
			".kmmkyk.....",
			"kmmk.kk.....",
			"kkk.........",
		},
		crosshair = {
			"....kkkk....",
			"..kkrrrrkk..",
			".kr..kk..rk.",
			".kr..rr..rk.",
			"krr.krrk.rrk",
			"kkkkryyrkkkk",
			"kkkkryyrkkkk",
			"krr.krrk.rrk",
			".kr..rr..rk.",
			".kr..kk..rk.",
			"..kkrrrrkk..",
			"....kkkk....",
		},
		crown = {
			"............",
			".kk..kk..kk.",
			"kyykkyykkyyk",
			"kyyyyyyyyyyk",
			"kyrrybbyrryk",
			"kyyyyyyyyyyk",
			"kyyyyyyyyyyk",
			".kyyyyyyyyk.",
			".kYYYYYYYYk.",
			".kkkkkkkkkk.",
			"............",
			"............",
		},
		gem = {
			"............",
			"...kkkkkk...",
			"..kbbbbbbk..",
			".kbwwbbbbbk.",
			"kbwwbbbbbbbk",
			"kbbbbbbbbbbk",
			".kbbbbbbbbk.",
			"..kbbbbbbk..",
			"...kbbbbk...",
			"....kbbk....",
			".....kk.....",
			"............",
		},
		dice = {
			".kkkkkkkkkk.",
			"kwwwwwwwwwwk",
			"kwkkwwwwkkwk",
			"kwkkwwwwkkwk",
			"kwwwwwwwwwwk",
			"kwwwwkkwwwwk",
			"kwwwwkkwwwwk",
			"kwwwwwwwwwwk",
			"kwkkwwwwkkwk",
			"kwkkwwwwkkwk",
			"kwwwwwwwwwwk",
			".kkkkkkkkkk.",
		},
		paw = {
			"............",
			".kk..kk..kk.",
			"kmmkkmk.kmmk",
			"kmmkkmk.kmmk",
			".kk..kk..kk.",
			"...kkkkkk...",
			"..kmmmmmmk..",
			".kmmssssmmk.",
			".kmssssssmk.",
			".kmmmmmmmmk.",
			"..kkkkkkkk..",
			"............",
		},
		egg = {
			"....kkkk....",
			"...kwwwwk...",
			"..kwwggwwk..",
			".kwwggggwwk.",
			".kwwwwwwwwk.",
			"kwwggwwggwwk",
			"kwwggwwggwwk",
			"kwwwwwwwwwwk",
			".kwwwwwwwwk.",
			".kwwggggwwk.",
			"..kkwwwwkk..",
			"....kkkk....",
		},
		hammer = {
			"..kkkkkkkk..",
			".knnnnnnnnk.",
			".knwwnnnnnk.",
			".knnnnnnnnk.",
			"..kkkkmmkk..",
			".....kmmk...",
			".....kmmk...",
			".....kmmk...",
			".....kmmk...",
			".....kmmk...",
			".....kmmk...",
			".....kkkk...",
		},
		car = {
			"............",
			"...kkkkkk...",
			"..krrrrrrk..",
			".krrbbbbwwk.",
			"krrrrrrrrrrk",
			"krrrrrrrryyk",
			"kkkkkkkkkkkk",
			".knnkkkkknn.",
			".knwk..knwk.",
			"..kk....kk..",
			"............",
			"............",
		},
		chest = {
			".kkkkkkkkkk.",
			"kBBBBBBBBBBk",
			"kByyyyyyyyBk",
			"kBBBBBBBBBBk",
			"kkkkkyykkkkk",
			"kBBBkyykBBBk",
			"kBBBkyykBBBk",
			"kBBBBBBBBBBk",
			"kBmmmmmmmmBk",
			"kBBBBBBBBBBk",
			".kkkkkkkkkk.",
			"............",
		},
		lightning = {
			"......kkkk..",
			".....kyyyk..",
			"....kyyyk...",
			"...kyyyk....",
			"..kyyyyykkkk",
			".kyyyyyyyyyk",
			"....kkkkkyyk",
			"....kyyykyk.",
			"...kyyyk....",
			"..kyyyk.....",
			".kyyk.......",
			".kkk........",
		},
		magnet = {
			".kkkk..kkkk.",
			"krrrrk.krrrk",
			"krwwrk.krwrk",
			"knnnnk.knnnk",
			"knnnnk.knnnk",
			"krrrrk.krrrk",
			"krrrrkkrrrrk",
			".krrrrrrrrk.",
			".krrrrrrrrk.",
			"..kkkkkkkk..",
			"............",
			"............",
		},
		skull = {
			"...kkkkkk...",
			"..kwwwwwwk..",
			".kwwwwwwwwk.",
			"kwwkkwwkkwwk",
			"kwwkkwwkkwwk",
			"kwwwwwwwwwwk",
			".kwwwkkwwwk.",
			"..kwwwwwwk..",
			"..kwkwkwkwk.",
			"...kkkkkk...",
			"............",
			"............",
		},
		feather = {
			"........kkk.",
			"......kkwwwk",
			".....kwwwwwk",
			"....kwwbbwwk",
			"...kwwbbwwk.",
			"..kwwbbwwk..",
			"..kwbbwwk...",
			".kwwbwwk....",
			".kwbwwk.....",
			".kyyyk......",
			"kyyk........",
			"kkk.........",
		},
		trophy = {
			".kkkkkkkkkk.",
			"kyyyyyyyyyyk",
			"kykkyyyykkyk",
			"kykkywwykkyk",
			".kyyyyyyyyk.",
			"..kyyyyyyk..",
			"...kyyyyk...",
			"....kyyk....",
			"....kyyk....",
			"..kkyyyykk..",
			".kkkkkkkkkk.",
			"............",
		},
	}

	for spriteName, grid in pairs(ExtraSprites) do
		Sprite.Art[spriteName] = grid
	end

	local ExtraAliases = {
		main = "mushroom",
		home = "castle",
		general = "qblock",
		hub = "star",
		combat = "sword",
		sword = "sword",
		swords = "sword",
		weapon = "sword",
		knife = "sword",
		aimbot = "crosshair",
		aim = "crosshair",
		sniper = "crosshair",
		target = "crosshair",
		crosshair = "crosshair",
		gun = "crosshair",
		visuals = "boo",
		esp = "boo",
		eye = "boo",
		camera = "boo",
		radar = "crosshair",
		player = "feather",
		user = "oneup",
		users = "oneup",
		movement = "feather",
		speed = "lightning",
		zap = "lightning",
		bolt = "lightning",
		fly = "feather",
		jump = "feather",
		run = "lightning",
		shield = "shell",
		defense = "shell",
		god = "star",
		armor = "blueshell",
		safe = "shell",
		teleport = "pipe",
		warp = "pipe",
		compass = "pipe",
		map = "pipe",
		globe = "pipe",
		auto = "star",
		farm = "star",
		sparkles = "star",
		wand = "star",
		bot = "gear",
		coin = "coin",
		money = "coin",
		cash = "coin",
		shop = "coin",
		bag = "chest",
		cart = "chest",
		gem = "gem",
		diamond = "gem",
		crown = "crown",
		vip = "crown",
		rank = "trophy",
		trophy = "trophy",
		gift = "chest",
		crate = "chest",
		chest = "chest",
		box = "qblock",
		package = "qblock",
		airdrop = "chest",
		loot = "magnet",
		magnet = "magnet",
		collect = "magnet",
		pet = "paw",
		paw = "paw",
		animal = "paw",
		mount = "paw",
		egg = "egg",
		hatch = "egg",
		dice = "dice",
		roll = "dice",
		luck = "star",
		spin = "dice",
		hammer = "hammer",
		forge = "hammer",
		craft = "hammer",
		build = "brick",
		pickaxe = "hammer",
		car = "car",
		vehicle = "car",
		drive = "car",
		race = "flag",
		skull = "skull",
		kill = "skull",
		murder = "skull",
		danger = "bomb",
		bomb = "bomb",
		heart = "heart",
		health = "heart",
		heal = "oneup",
		key = "key",
		lock = "key",
		unlock = "key",
		flag = "flag",
		quest = "flag",
		play = "flag",
		settings = "gear",
		cog = "gear",
		sliders = "gear",
		config = "qblock",
		palette = "flower",
		theme = "flower",
		info = "qblock",
		bell = "coin",
		warning = "bomb",
		alert = "bomb",
		check = "star",
		save = "qblock",
		refresh = "pipe",
		trash = "bomb",
		search = "boo",
		terminal = "brick",
		code = "qblock",
		chart = "trophy",
		stats = "trophy",
	}

	for aliasKey, targetSprite in pairs(ExtraAliases) do
		Sprite.Alias[aliasKey] = targetSprite
	end

	Icons.Rules = {
		{
			"aimbot|silent|sniper|crosshair|shoot|gun|ยิง|ปืน|เล็ง",
			"crosshair",
		},
		{
			"combat|sword|weapon|knife|kill|murder|sheriff|hit|attack|fight|ต่อสู้|ฆ่า|อาวุธ|ดาบ",
			"sword",
		},
		{
			"visual|esp|chams|wallhack|highlight|tracer|fov|camera|see|มอง|แสง|เรดาร์",
			"boo",
		},
		{
			"teleport|warp|island|location|place|spawn|zone|map|วาร์ป|เกาะ|สถานที่|แมพ",
			"pipe",
		},
		{ "pet|animal|mount|ride|สัตว์|ขี่", "paw" },
		{ "egg|hatch|ไข่|สุ่มไข่", "egg" },
		{
			"dice|roll|spin|gacha|ลูกเต๋า|ทอย|สุ่ม",
			"dice",
		},
		{
			"forge|craft|upgrade|mine|dig|ตีบวก|หลอม|ขุด|อัพเกรด",
			"hammer",
		},
		{
			"build|pyramid|brick|สร้าง|พีระมิด",
			"brick",
		},
		{ "car|vehicle|drive|race|drift|รถ|ขับ|แข่ง", "car" },
		{
			"shop|buy|sell|merchant|market|store|trade|coin|cash|money|ร้าน|ซื้อ|ขาย|เงิน",
			"coin",
		},
		{ "loot|magnet|collect|grab|ดูด|เก็บ", "magnet" },
		{
			"airdrop|crate|chest|drop|gift|กล่อง|แอร์ดรอป",
			"chest",
		},
		{
			"speed|dash|bolt|zap|ความเร็ว|พุ่ง",
			"lightning",
		},
		{
			"player|movement|walk|jump|fly|noclip|stamina|ผู้เล่น|วิ่ง|กระโดด|บิน",
			"feather",
		},
		{
			"defense|shield|god|anti|safe|guard|bypass|ป้องกัน|อมตะ|กันแบน",
			"shell",
		},
		{ "rank|vip|king|boss|crown|ยศ", "crown" },
		{
			"stat|status|leaderboard|score|trophy|สถานะ|อันดับ|คะแนน",
			"trophy",
		},
		{ "quest|mission|flag|start|เควส|ภารกิจ", "flag" },
		{ "theme|color|palette|style|ธีม|สี", "flower" },
		{
			"setting|config|ui|menu|keybind|language|ตั้งค่า|เมนู|ภาษา",
			"gear",
		},
		{
			"auto|farm|grind|loop|bot|ออโต้|ฟาร์ม|บอท",
			"star",
		},
		{ "main|home|general|hub|หลัก|ทั่วไป", "mushroom" },
	}

	-- Crisp SVG-style geometric vector primitives for UI chrome (search, close, check, chevrons, plus, minus, grip)
	local function DrawVectorLine(parent, pos, size, rot, token)
		return Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = pos,
			Size = size,
			Rotation = rot or 0,
			Parent = parent,
		}, token or "Text", nil, UDim.new(1, 0))
	end

	local function DrawLCorner(parent, pos, size, rot, thickness, token)
		local pivot = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = pos,
			Size = size,
			Rotation = rot,
			Parent = parent,
		})
		Draw.Box("Frame", {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.new(0, thickness, 1, 0),
			Parent = pivot,
		}, token or "Text", nil, UDim.new(1, 0))
		Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, thickness),
			Parent = pivot,
		}, token or "Text", nil, UDim.new(1, 0))
		return pivot
	end

	Icons.Vectors = {
		search = function(box, token)
			local ring = Draw.New("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.42, 0.42),
				Size = UDim2.fromScale(0.54, 0.54),
				Parent = box,
			})
			Draw.Corner(ring, UDim.new(1, 0))
			Draw.Stroke(ring, token or "SubText", 2)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.73, 0.73),
				UDim2.new(0.32, 0, 0, 2),
				45,
				token or "SubText"
			)
		end,
		close = function(box, token)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.5, 0.5),
				UDim2.new(0.68, 0, 0, 2),
				45,
				token
			)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.5, 0.5),
				UDim2.new(0.68, 0, 0, 2),
				-45,
				token
			)
		end,
		check = function(box, token)
			local w = box.Size.X.Offset
			local thick = (w >= 16) and 3 or 2
			DrawLCorner(
				box,
				UDim2.fromScale(0.5, 0.44),
				UDim2.fromScale(0.62, 0.36),
				-45,
				thick,
				token or "Good"
			)
		end,
		plus = function(box, token)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.5, 0.5),
				UDim2.new(0.64, 0, 0, 2),
				0,
				token
			)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.5, 0.5),
				UDim2.new(0, 2, 0.64, 0),
				0,
				token
			)
		end,
		minus = function(box, token)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.5, 0.5),
				UDim2.new(0.64, 0, 0, 2),
				0,
				token
			)
		end,
		chevron_down = function(box, token)
			DrawLCorner(
				box,
				UDim2.fromScale(0.5, 0.42),
				UDim2.fromScale(0.42, 0.42),
				-45,
				2,
				token
			)
		end,
		chevron_up = function(box, token)
			DrawLCorner(
				box,
				UDim2.fromScale(0.5, 0.58),
				UDim2.fromScale(0.42, 0.42),
				135,
				2,
				token
			)
		end,
		chevron_right = function(box, token)
			DrawLCorner(
				box,
				UDim2.fromScale(0.42, 0.5),
				UDim2.fromScale(0.42, 0.42),
				-135,
				2,
				token
			)
		end,
		grip = function(box, token)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.62, 0.62),
				UDim2.new(0.66, 0, 0, 2),
				-45,
				token or "White"
			)
			DrawVectorLine(
				box,
				UDim2.fromScale(0.78, 0.78),
				UDim2.new(0.36, 0, 0, 2),
				-45,
				token or "White"
			)
		end,
	}

	-- Original neutral line assets, drawn at native resolution. No emoji, character
	-- imagery, remote image fetch, particle loop or per-frame redraw.
	local brandPaths = {
		coin = {
			{
				{ 0.3, 0.12 },
				{ 0.7, 0.12 },
				{ 0.88, 0.3 },
				{ 0.88, 0.7 },
				{ 0.7, 0.88 },
				{ 0.3, 0.88 },
				{ 0.12, 0.7 },
				{ 0.12, 0.3 },
				{ 0.3, 0.12 },
			},
			{
				{ 0.6, 0.3 },
				{ 0.4, 0.3 },
				{ 0.35, 0.5 },
				{ 0.65, 0.5 },
				{ 0.6, 0.7 },
				{
					0.4,
					0.7,
				},
			},
			{ { 0.5, 0.2 }, { 0.5, 0.8 } },
		},
		rhythm = {
			{ { 0.18, 0.65 }, { 0.18, 0.35 } },
			{ { 0.39, 0.85 }, { 0.39, 0.15 } },
			{ { 0.61, 0.72 }, { 0.61, 0.28 } },
			{ { 0.82, 0.58 }, { 0.82, 0.42 } },
		},
		anvil = {
			{
				{ 0.12, 0.3 },
				{ 0.88, 0.3 },
				{ 0.73, 0.5 },
				{ 0.53, 0.5 },
				{ 0.53, 0.7 },
				{ 0.72, 0.8 },
				{ 0.25, 0.8 },
				{ 0.42, 0.7 },
				{ 0.42, 0.5 },
				{ 0.22, 0.5 },
				{ 0.12, 0.3 },
			},
		},
		home = {
			{ { 0.15, 0.43 }, { 0.5, 0.14 }, { 0.85, 0.43 } },
			{ { 0.24, 0.42 }, { 0.24, 0.84 }, { 0.76, 0.84 }, { 0.76, 0.42 } },
			{ { 0.44, 0.84 }, { 0.44, 0.6 }, { 0.6, 0.6 }, { 0.6, 0.84 } },
		},
		code = {
			{ { 0.33, 0.25 }, { 0.1, 0.5 }, { 0.33, 0.75 } },
			{ { 0.67, 0.25 }, { 0.9, 0.5 }, { 0.67, 0.75 } },
			{ { 0.58, 0.15 }, { 0.42, 0.85 } },
		},
		layers = {
			{
				{ 0.12, 0.34 },
				{ 0.5, 0.14 },
				{ 0.88, 0.34 },
				{ 0.5, 0.54 },
				{
					0.12,
					0.34,
				},
			},
			{ { 0.12, 0.52 }, { 0.5, 0.72 }, { 0.88, 0.52 } },
			{ { 0.12, 0.7 }, { 0.5, 0.9 }, { 0.88, 0.7 } },
		},
		play = { { { 0.3, 0.2 }, { 0.8, 0.5 }, { 0.3, 0.8 }, { 0.3, 0.2 } } },
		settings = {
			{ { 0.2, 0.15 }, { 0.2, 0.85 } },
			{ { 0.5, 0.15 }, { 0.5, 0.85 } },
			{ { 0.8, 0.15 }, { 0.8, 0.85 } },
			{ { 0.1, 0.35 }, { 0.3, 0.35 } },
			{ { 0.4, 0.65 }, { 0.6, 0.65 } },
			{ { 0.7, 0.42 }, { 0.9, 0.42 } },
		},
		user = {
			{
				{ 0.35, 0.17 },
				{ 0.65, 0.17 },
				{ 0.72, 0.35 },
				{ 0.65, 0.5 },
				{ 0.35, 0.5 },
				{ 0.28, 0.35 },
				{ 0.35, 0.17 },
			},
			{
				{ 0.15, 0.85 },
				{ 0.22, 0.67 },
				{ 0.38, 0.6 },
				{ 0.62, 0.6 },
				{ 0.78, 0.67 },
				{ 0.85, 0.85 },
			},
		},
		eye = {
			{
				{ 0.1, 0.5 },
				{ 0.28, 0.3 },
				{ 0.5, 0.22 },
				{ 0.72, 0.3 },
				{ 0.9, 0.5 },
				{ 0.72, 0.7 },
				{ 0.5, 0.78 },
				{ 0.28, 0.7 },
				{ 0.1, 0.5 },
			},
			{
				{ 0.42, 0.4 },
				{ 0.58, 0.4 },
				{ 0.62, 0.5 },
				{ 0.58, 0.6 },
				{ 0.42, 0.6 },
				{ 0.38, 0.5 },
				{ 0.42, 0.4 },
			},
		},
		server = {
			{
				{ 0.2, 0.15 },
				{ 0.8, 0.15 },
				{ 0.8, 0.85 },
				{ 0.2, 0.85 },
				{
					0.2,
					0.15,
				},
			},
			{ { 0.2, 0.38 }, { 0.8, 0.38 } },
			{ { 0.2, 0.62 }, { 0.8, 0.62 } },
			{ { 0.3, 0.26 }, { 0.4, 0.26 } },
			{ { 0.3, 0.5 }, { 0.4, 0.5 } },
			{ { 0.3, 0.74 }, { 0.4, 0.74 } },
		},
		egg = {
			{
				{ 0.5, 0.1 },
				{ 0.3, 0.27 },
				{ 0.18, 0.55 },
				{ 0.22, 0.75 },
				{ 0.36, 0.87 },
				{ 0.64, 0.87 },
				{ 0.78, 0.75 },
				{ 0.82, 0.55 },
				{ 0.7, 0.27 },
				{ 0.5, 0.1 },
			},
			{ { 0.48, 0.35 }, { 0.4, 0.5 }, { 0.53, 0.58 }, { 0.45, 0.72 } },
		},
		brain = {
			{
				{ 0.49, 0.22 },
				{ 0.35, 0.14 },
				{ 0.2, 0.22 },
				{ 0.18, 0.37 },
				{ 0.1, 0.48 },
				{ 0.16, 0.62 },
				{ 0.18, 0.78 },
				{ 0.36, 0.86 },
				{ 0.49, 0.76 },
				{ 0.51, 0.22 },
				{ 0.65, 0.14 },
				{ 0.8, 0.22 },
				{ 0.82, 0.37 },
				{ 0.9, 0.48 },
				{ 0.84, 0.62 },
				{ 0.82, 0.78 },
				{ 0.64, 0.86 },
				{ 0.51, 0.76 },
			},
			{ { 0.22, 0.38 }, { 0.34, 0.44 }, { 0.28, 0.59 } },
			{ { 0.78, 0.38 }, { 0.66, 0.44 }, { 0.72, 0.59 } },
		},
		download = {
			{ { 0.5, 0.12 }, { 0.5, 0.64 } },
			{ { 0.3, 0.45 }, { 0.5, 0.65 }, { 0.7, 0.45 } },
			{ { 0.15, 0.65 }, { 0.15, 0.85 }, { 0.85, 0.85 }, { 0.85, 0.65 } },
		},
		bolt = {
			{
				{ 0.57, 0.1 },
				{ 0.2, 0.56 },
				{ 0.48, 0.56 },
				{ 0.41, 0.9 },
				{ 0.8, 0.4 },
				{ 0.53, 0.4 },
				{ 0.57, 0.1 },
			},
		},
		info = {
			{ { 0.5, 0.28 }, { 0.5, 0.3 } },
			{ { 0.5, 0.45 }, { 0.5, 0.76 } },
			{
				{ 0.18, 0.18 },
				{ 0.82, 0.18 },
				{ 0.82, 0.82 },
				{ 0.18, 0.82 },
				{
					0.18,
					0.18,
				},
			},
		},
	}
	for name, paths in pairs(brandPaths) do
		Icons.Vectors[name] = function(box, token)
			local size = box.Size.X.Offset
			for _, path in ipairs(paths) do
				for index = 2, #path do
					local a, b = path[index - 1], path[index]
					local dx, dy = (b[1] - a[1]) * size, (b[2] - a[2]) * size
					DrawVectorLine(
						box,
						UDim2.fromScale((a[1] + b[1]) / 2, (a[2] + b[2]) / 2),
						UDim2.fromOffset(
							math.sqrt(dx * dx + dy * dy),
							math.max(1.6, size / 12)
						),
						math.deg(math.atan2(dy, dx)),
						token or "Text"
					)
				end
			end
		end
	end
	for alias, target in pairs({
		house = "home",
		main = "home",
		workspace = "home",
		scripts = "code",
		terminal = "code",
		package = "layers",
		inventory = "layers",
		player = "user",
		players = "user",
		character = "user",
		visuals = "eye",
		esp = "eye",
		servers = "server",
		stealer = "brain",
		stealabrainrot = "brain",
		bot = "bolt",
		automation = "bolt",
		zap = "bolt",
		["sliders_horizontal"] = "settings",
		save = "download",
		upload = "download",
		globe = "server",
		teleport = "layers",
		map = "layers",
		helper = "settings",
		misc = "settings",
	}) do
		Icons.Vectors[alias] = Icons.Vectors[target]
	end

	for alias, target in pairs({
		castle = "home",
		pipe = "layers",
		qblock = "info",
		gear = "settings",
		star = "bolt",
		flower = "bolt",
		boo = "eye",
		mushroom = "home",

		shell = "layers",
		stealer = "brain",
		loot = "layers",
	}) do
		Icons.Vectors[alias] = Icons.Vectors[target]
	end

	function Icons.NormalizeKey(rawName)
		if type(rawName) ~= "string" then
			return ""
		end
		return rawName
			:lower()
			:gsub("^lucide:", "")
			:gsub("^lucide%-", "")
			:gsub("^icon:", "")
			:gsub("[%-%s]+", "_")
	end

	function Icons.FromTitle(titleSpec, defaultSprite)
		local text = Lang.SearchText(titleSpec)
		if text ~= "" then
			for _, rule in ipairs(Icons.Rules) do
				for word in rule[1]:gmatch("[^|]+") do
					if text:find(word, 1, true) then
						return rule[2]
					end
				end
			end
		end
		return defaultSprite or "qblock"
	end

	function Icons.Vector(parent, vectorName, size, colorToken)
		size = size or 16
		local key = Icons.NormalizeKey(vectorName)
		local builder = Icons.Vectors[key]
		local holder = Draw.New("Frame", {
			Name = "VectorIcon",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(size, size),
			Parent = parent,
		})
		if builder then
			builder(holder, colorToken or "Text")
		end
		return holder
	end

	function Icons.Create(parent, iconSpec, size, colorToken, fallbackTitle)
		size = size or Util.Metric("Icon")
		if
			type(iconSpec) == "number"
			or (
				type(iconSpec) == "string"
				and (iconSpec:find("^rbxassetid://") or iconSpec:match("^%d+$"))
			)
		then
			local assetId = type(iconSpec) == "number"
					and ("rbxassetid://" .. iconSpec)
				or (
					iconSpec:match("^%d+$")
						and ("rbxassetid://" .. iconSpec)
					or iconSpec
				)
			local img = Draw.New("ImageLabel", {
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = assetId,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(size, size),
				Parent = parent,
			})
			if colorToken then
				Theme.Bind(img, { ImageColor3 = colorToken })
			end
			return img
		end
		local key = Icons.NormalizeKey(iconSpec)
		if key == "" then
			key = Icons.NormalizeKey(
				Icons.FromTitle(fallbackTitle or iconSpec, "info")
			)
		end
		if Icons.Vectors[key] then
			return Icons.Vector(parent, key, size, colorToken)
		end
		local spriteName = (key ~= "" and Sprite.Resolve(key))
			or Icons.FromTitle(fallbackTitle or iconSpec, "qblock")
		local spriteSize = math.max(12, math.floor((size + 2) / 2) * 2)
		return Sprite.New(parent, spriteName, spriteSize)
	end

	function Icons.Badge(parent, iconSpec, size, colorToken, fallbackTitle)
		size = size or 24
		local box = Draw.Box("Frame", {
			Name = "IconBadge",
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 0.25,
			Parent = parent,
		}, "Element", "Outline", 6, 1.5)
		local inner = Icons.Create(
			box,
			iconSpec,
			math.max(12, size - 6),
			colorToken,
			fallbackTitle
		)
		inner.AnchorPoint = Vector2.new(0.5, 0.5)
		inner.Position = UDim2.fromScale(0.5, 0.5)
		return box, inner
	end

	Motion.Springs = {}
	Motion.ByInst = {}
	Motion.Free = {}
	Motion.Tickers = {}
	Motion.Sizes = { number = 1, Vector2 = 2, Color3 = 3, UDim2 = 4 }

	function Motion.Pack(kind, current, out)
		if kind == "number" then
			out[1] = current
		elseif kind == "UDim2" then
			out[1], out[2], out[3], out[4] =
				current.X.Scale,
				current.X.Offset,
				current.Y.Scale,
				current.Y.Offset
		elseif kind == "Vector2" then
			out[1], out[2] = current.X, current.Y
		else
			out[1], out[2], out[3] = current.R, current.G, current.B
		end
	end

	function Motion.Unpack(kind, components)
		if kind == "number" then
			return components[1]
		elseif kind == "UDim2" then
			return UDim2.new(
				components[1],
				components[2],
				components[3],
				components[4]
			)
		elseif kind == "Vector2" then
			return Vector2.new(components[1], components[2])
		end
		return Color3.new(
			math.clamp(components[1], 0, 1),
			math.clamp(components[2], 0, 1),
			math.clamp(components[3], 0, 1)
		)
	end

	function Motion.SpeedOf(speedKey)
		if type(speedKey) == "number" then
			return speedKey
		end
		local speeds = Config.Motion.Speed
		return speeds[speedKey or "Normal"] or speeds.Normal
	end

	function Motion.Get(inst, prop)
		local props = Motion.ByInst[inst]
		return props and props[prop]
	end

	function Motion.Create(inst, prop, kind)
		local spring = table.remove(Motion.Free)
			or { Pos = {}, Vel = {}, Goal = {} }
		spring.Inst, spring.Prop, spring.Kind, spring.Count =
			inst, prop, kind, Motion.Sizes[kind]
		Motion.Pack(kind, inst[prop], spring.Pos)
		for index = 1, spring.Count do
			spring.Vel[index] = 0
		end
		local props = Motion.ByInst[inst]
		if not props then
			props = {}
			Motion.ByInst[inst] = props
		end
		props[prop] = spring
		table.insert(Motion.Springs, spring)
		spring.Index = #Motion.Springs
		return spring
	end

	function Motion.Remove(spring, fireCallback)
		local springs = Motion.Springs
		local last = springs[#springs]
		if last then
			springs[spring.Index] = last
			last.Index = spring.Index
			springs[#springs] = nil
		end
		local props = Motion.ByInst[spring.Inst]
		if props then
			props[spring.Prop] = nil
			if next(props) == nil then
				Motion.ByInst[spring.Inst] = nil
			end
		end
		local onDone, inst = spring.OnDone, spring.Inst
		spring.Inst, spring.OnDone = nil, nil
		table.insert(Motion.Free, spring)
		if fireCallback and onDone then
			Util.Try(onDone, inst)
		end
	end

	function Motion.Wake()
		if Motion.Connection or Library.Unloaded then
			return
		end
		Motion.Connection = Util.Connect(RunService.RenderStepped, Motion.Step)
	end

	function Motion.Spring(inst, prop, target, speedKey, options)
		if State.ReducedMotion then
			Motion.Set(inst, prop, target)
			if options and options.OnDone then
				options.OnDone()
			end
			return
		end
		local kind = typeof(target)
		if not Motion.Sizes[kind] then
			inst[prop] = target
			return
		end
		local spring = Motion.Get(inst, prop) or Motion.Create(inst, prop, kind)
		Motion.Pack(kind, target, spring.Goal)
		spring.Speed = Motion.SpeedOf(speedKey)
		spring.Damping = options and options.Damping or Config.Motion.Damping
		spring.OnDone = options and options.OnDone
		Motion.Wake()
	end

	function Motion.Impulse(inst, prop, velocity, speedKey, damping)
		if State.ReducedMotion then
			return
		end
		local kind = typeof(inst[prop])
		if not Motion.Sizes[kind] then
			return
		end
		local spring = Motion.Get(inst, prop)
		if not spring then
			spring = Motion.Create(inst, prop, kind)
			Motion.Pack(kind, inst[prop], spring.Goal)
			spring.OnDone = nil
		end
		for index = 1, spring.Count do
			spring.Vel[index] += velocity[index] or 0
		end
		spring.Speed = Motion.SpeedOf(speedKey)
		spring.Damping = damping or Config.Motion.BounceDamping
		Motion.Wake()
	end

	function Motion.Set(inst, prop, target)
		local spring = Motion.Get(inst, prop)
		if spring then
			Motion.Remove(spring, false)
		end
		inst[prop] = target
	end

	function Motion.Advance(spring, step, substeps)
		local speed = spring.Speed
		local damp = 2 * spring.Damping * speed
		local stiffness = speed * speed
		local settled = true
		for _ = 1, substeps do
			for index = 1, spring.Count do
				local displacement = spring.Pos[index] - spring.Goal[index]
				local accel = -stiffness * displacement
					- damp * spring.Vel[index]
				spring.Vel[index] += accel * step
				spring.Pos[index] += spring.Vel[index] * step
			end
		end
		for index = 1, spring.Count do
			if
				math.abs(spring.Pos[index] - spring.Goal[index]) > 0.002
				or math.abs(spring.Vel[index]) > 0.01
			then
				settled = false
				break
			end
		end
		if settled then
			for index = 1, spring.Count do
				spring.Pos[index] = spring.Goal[index]
				spring.Vel[index] = 0
			end
		end
		return settled
	end

	function Motion.Step(deltaTime)
		local clamped = math.min(deltaTime, 0.05)
		local substeps = clamped > 0.018 and 2 or 1
		local step = clamped / substeps
		for index = #Motion.Springs, 1, -1 do
			local spring = Motion.Springs[index]
			if not spring.Inst or not spring.Inst.Parent then
				Motion.Remove(spring, false)
			else
				local settled = Motion.Advance(spring, step, substeps)
				pcall(function()
					spring.Inst[spring.Prop] =
						Motion.Unpack(spring.Kind, spring.Pos)
				end)
				if settled then
					Motion.Remove(spring, true)
				end
			end
		end
		Motion.StepTickers(clamped)
		if
			#Motion.Springs == 0
			and next(Motion.Tickers) == nil
			and Motion.Connection
		then
			Motion.Connection:Disconnect()
			Motion.Connection = nil
		end
	end

	function Motion.StepTickers(deltaTime)
		for owner, ticker in pairs(Motion.Tickers) do
			ticker.Elapsed += deltaTime
			local alpha = math.clamp(ticker.Elapsed / ticker.Duration, 0, 1)
			local eased = 1 - (1 - alpha) ^ 3
			local current = ticker.From + (ticker.To - ticker.From) * eased
			pcall(ticker.OnTick, current, alpha >= 1)
			if alpha >= 1 then
				Motion.Tickers[owner] = nil
			end
		end
	end

	function Fx.ScaleOf(frame)
		local scale = frame:FindFirstChild("FxScale")
		if not scale then
			scale = Draw.New("UIScale", { Name = "FxScale", Parent = frame })
		end
		return scale
	end

	function Fx.Squash(frame, impulseScale)
		local scale = Fx.ScaleOf(frame)
		Motion.Impulse(
			scale,
			"Scale",
			{ impulseScale or 2.4 },
			"Fast",
			Config.Motion.SquashDamping
		)
	end

	function Fx.Bump(frame, velocity)
		Motion.Impulse(
			frame,
			"Position",
			{ 0, 0, 0, -(velocity or 110) },
			"Fast",
			Config.Motion.BounceDamping
		)
	end

	function Fx.Ripple(parent, screenPos, token)
		if not parent or not parent.Parent then
			return
		end
		local pointer = screenPos or UserInputService:GetMouseLocation()
		local localPos = pointer - parent.AbsolutePosition
		local maxDim = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y)
			* 2.1
		local circle = Draw.Box("Frame", {
			Name = "Ripple",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(localPos.X, localPos.Y),
			Size = UDim2.fromOffset(4, 4),
			BackgroundTransparency = 0.55,
			ZIndex = 8,
			Parent = parent,
		}, token or "White", nil, UDim.new(1, 0))
		local tween = Anim.Tween(circle, {
			Size = UDim2.fromOffset(maxDim, maxDim),
			BackgroundTransparency = 1,
		}, 0.36, "Out")
		tween.Completed:Once(function()
			circle:Destroy()
		end)
	end

	function Fx.CountUp(owner, fromValue, toValue, duration, onTick)
		if State.ReducedMotion then
			pcall(onTick, toValue, true)
			return
		end
		if math.abs(toValue - fromValue) < 1e-4 then
			pcall(onTick, toValue, true)
			return
		end
		local existing = Motion.Tickers[owner]
		local startValue = existing
				and (existing.From + (existing.To - existing.From) * math.clamp(
					existing.Elapsed / existing.Duration,
					0,
					1
				))
			or fromValue
		Motion.Tickers[owner] = {
			From = startValue,
			To = toValue,
			Elapsed = 0,
			Duration = duration or 0.22,
			OnTick = onTick,
		}
		Motion.Wake()
	end

	function Fx.Shimmer(target, colorToken)
		if target:FindFirstChild("FxShimmer") then
			return
		end
		local gradient = Draw.New("UIGradient", {
			Name = "FxShimmer",
			Rotation = 25,
			Offset = Vector2.new(-1, 0),
			Parent = target,
		})
		Theme.OnRender(gradient, function()
			local base = Theme.Colors[colorToken or "Text"]
				or Color3.new(1, 1, 1)
			local highlight = Util.Lighten(base, 0.45)
			gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, base),
				ColorSequenceKeypoint.new(0.45, base),
				ColorSequenceKeypoint.new(0.5, highlight),
				ColorSequenceKeypoint.new(0.55, base),
				ColorSequenceKeypoint.new(1, base),
			})
		end)
		Anim.Tween(
			gradient,
			{ Offset = Vector2.new(1, 0) },
			2.6,
			"Sine",
			-1,
			false,
			0.8
		)
	end

	function Fx.Spotlight(card)
		return card
	end

	function Fx.StaggerRise(cards)
		for index, card in ipairs(cards) do
			if card and card.Parent then
				local scale = Fx.ScaleOf(card)
				scale.Scale = 0.96
				task.delay((index - 1) * 0.028, function()
					if card.Parent then
						Motion.Spring(
							scale,
							"Scale",
							1,
							"Normal",
							{ Damping = 0.62 }
						)
					end
				end)
			end
		end
	end

	Tailwind.Cache = {}

	Tailwind.TokenMap = {
		panel = "Panel",
		header = "PanelHeader",
		element = "Element",
		hover = "Hover",
		accent = "Accent",
		["accent-dark"] = "AccentDark",
		good = "Good",
		["good-dark"] = "GoodDark",
		danger = "Danger",
		["danger-dark"] = "DangerDark",
		coin = "Coin",
		["coin-dark"] = "CoinDark",
		blue = "Blue",
		["blue-dark"] = "BlueDark",
		risky = "Risky",
		track = "Track",
		outline = "Outline",
		shadow = "Shadow",
		text = "Text",
		sub = "SubText",
		muted = "Muted",
		white = "White",
		black = "Black",
		ink = "Ink",
		topbar = "Topbar",
		sidebar = "Sidebar",
		["sidebar-alt"] = "SidebarAlt",
	}

	Tailwind.RadiusMap = { none = 0, sm = 6, md = 8, lg = 10, xl = 12 }
	Tailwind.FontMap = {
		display = "Display",
		body = "Body",
		desc = "Desc",
		strong = "Strong",
		logo = "Logo",
		glyph = "Glyph",
	}
	Tailwind.SizeMap =
		{ xs = 12, sm = 13, base = 15, lg = 18, xl = 22, ["2xl"] = 26 }
	Tailwind.AlignXMap = {
		left = Enum.TextXAlignment.Left,
		center = Enum.TextXAlignment.Center,
		right = Enum.TextXAlignment.Right,
	}
	Tailwind.FlexXMap = {
		start = Enum.HorizontalAlignment.Left,
		center = Enum.HorizontalAlignment.Center,
		["end"] = Enum.HorizontalAlignment.Right,
	}
	Tailwind.FlexYMap = {
		start = Enum.VerticalAlignment.Top,
		center = Enum.VerticalAlignment.Center,
		["end"] = Enum.VerticalAlignment.Bottom,
	}

	function Tailwind.ParseToken(raw)
		return Tailwind.TokenMap[raw] or raw
	end

	function Tailwind.ApplyLayoutRule(inst, rule, state)
		if rule == "flex-row" or rule == "flex-col" then
			state.Flex = rule == "flex-row" and "row" or "col"
		elseif rule:sub(1, 6) == "items-" then
			state.Items = rule:sub(7)
		elseif rule:sub(1, 8) == "justify-" then
			state.Justify = rule:sub(9)
		elseif rule:sub(1, 4) == "gap-" then
			state.Gap = (tonumber(rule:sub(5)) or 2) * 4
		elseif rule == "w-full" then
			inst.Size = UDim2.new(1, 0, inst.Size.Y.Scale, inst.Size.Y.Offset)
		elseif rule == "h-full" then
			inst.Size = UDim2.new(inst.Size.X.Scale, inst.Size.X.Offset, 1, 0)
		elseif rule == "w-1/2" then
			inst.Size = UDim2.new(0.5, 0, inst.Size.Y.Scale, inst.Size.Y.Offset)
		elseif rule == "clip" then
			inst.ClipsDescendants = true
		elseif rule == "auto-x" then
			inst.AutomaticSize = Enum.AutomaticSize.X
		elseif rule == "auto-y" then
			inst.AutomaticSize = Enum.AutomaticSize.Y
		end
	end

	function Tailwind.ApplyBoxRule(inst, rule, state)
		local padAll = rule:match("^p%-(%d+)$")
		local padX = rule:match("^px%-(%d+)$")
		local padY = rule:match("^py%-(%d+)$")
		local widthPx = rule:match("^w%-%[(%d+)%]$") or rule:match("^w%-(%d+)$")
		local heightPx = rule:match("^h%-%[(%d+)%]$")
			or rule:match("^h%-(%d+)$")
		if padAll then
			local px = tonumber(padAll) * 4
			state.Pad = { px, px, px, px }
		elseif padX then
			local px = tonumber(padX) * 4
			state.Pad = state.Pad or { 0, 0, 0, 0 }
			state.Pad[2], state.Pad[4] = px, px
		elseif padY then
			local px = tonumber(padY) * 4
			state.Pad = state.Pad or { 0, 0, 0, 0 }
			state.Pad[1], state.Pad[3] = px, px
		elseif widthPx then
			inst.Size = UDim2.new(
				0,
				tonumber(widthPx),
				inst.Size.Y.Scale,
				inst.Size.Y.Offset
			)
		elseif heightPx then
			inst.Size = UDim2.new(
				inst.Size.X.Scale,
				inst.Size.X.Offset,
				0,
				tonumber(heightPx)
			)
		end
	end

	function Tailwind.ApplySurfaceRule(inst, rule, state)
		if rule == "rounded-full" then
			Draw.Corner(inst, UDim.new(1, 0))
		elseif rule:sub(1, 8) == "rounded-" then
			local key = rule:sub(9)
			Draw.Corner(inst, Tailwind.RadiusMap[key] or tonumber(key) or 8)
		elseif rule:sub(1, 11) == "bg-opacity-" then
			inst.BackgroundTransparency = 1
				- math.clamp((tonumber(rule:sub(12)) or 100) / 100, 0, 1)
		elseif rule:sub(1, 3) == "bg-" then
			inst.BackgroundTransparency = inst.BackgroundTransparency == 1 and 0
				or inst.BackgroundTransparency
			Theme.Bind(
				inst,
				{ BackgroundColor3 = Tailwind.ParseToken(rule:sub(4)) }
			)
		elseif rule == "border" or rule == "border-2" or rule == "border-3" then
			state.BorderWidth = tonumber(rule:match("%d+")) or 1
		elseif rule:sub(1, 7) == "border-" then
			state.BorderToken = Tailwind.ParseToken(rule:sub(8))
		elseif rule == "spotlight" then
			state.Spotlight = true
		end
	end

	function Tailwind.ApplyTextRule(inst, rule, state)
		if
			not inst:IsA("TextLabel")
			and not inst:IsA("TextButton")
			and not inst:IsA("TextBox")
		then
			return
		end
		if rule:sub(1, 5) == "font-" then
			state.Font = Tailwind.FontMap[rule:sub(6)] or "Body"
		elseif rule:sub(1, 5) == "text-" then
			local suffix = rule:sub(6)
			if Tailwind.SizeMap[suffix] then
				state.TextSize = Tailwind.SizeMap[suffix]
			elseif Tailwind.AlignXMap[suffix] then
				inst.TextXAlignment = Tailwind.AlignXMap[suffix]
			else
				Theme.Bind(inst, { TextColor3 = Tailwind.ParseToken(suffix) })
			end
		elseif rule == "truncate" then
			inst.TextTruncate = Enum.TextTruncate.AtEnd
		elseif rule == "wrap" then
			inst.TextWrapped = true
		elseif rule == "shimmer" then
			Fx.Shimmer(inst)
		end
	end

	function Tailwind.FinalizeState(inst, state)
		if state.Pad then
			Draw.Padding(
				inst,
				state.Pad[1],
				state.Pad[2],
				state.Pad[3],
				state.Pad[4]
			)
		end
		if state.Flex then
			local alignX = state.Flex == "row"
					and Tailwind.FlexXMap[state.Justify or "start"]
				or Tailwind.FlexXMap[state.Items or "start"]
			local alignY = state.Flex == "row"
					and Tailwind.FlexYMap[state.Items or "center"]
				or Tailwind.FlexYMap[state.Justify or "start"]
			local list = Draw.List(
				inst,
				state.Gap or 0,
				state.Flex == "row",
				alignX,
				alignY
			)
			if state.Justify == "between" then
				list.HorizontalFlex = state.Flex == "row"
						and Enum.UIFlexAlignment.SpaceBetween
					or Enum.UIFlexAlignment.None
			end
		end
		if state.BorderWidth or state.BorderToken then
			Draw.Stroke(
				inst,
				state.BorderToken or "Outline",
				state.BorderWidth or 2,
				true
			)
		end
		if state.Font or state.TextSize then
			Fonts.Style(
				inst,
				state.Font or "Body",
				state.TextSize or Util.TextSize("Label")
			)
		end
		if state.Spotlight then
			Fx.Spotlight(inst)
		end
	end

	function Tailwind.Apply(inst, classString)
		if type(classString) ~= "string" or classString == "" then
			return inst
		end
		local state = {}
		for rule in classString:gmatch("%S+") do
			Tailwind.ApplyLayoutRule(inst, rule, state)
			Tailwind.ApplyBoxRule(inst, rule, state)
			Tailwind.ApplySurfaceRule(inst, rule, state)
			Tailwind.ApplyTextRule(inst, rule, state)
		end
		Tailwind.FinalizeState(inst, state)
		return inst
	end

	function Tailwind.BindProp(inst, property, target)
		if property == "Class" or property == "class" then
			if Reactive.IsRef(target) or type(target) == "function" then
				Reactive.Effect(function()
					Tailwind.Apply(
						inst,
						Reactive.IsRef(target) and target.Value or target()
					)
				end)
			else
				Tailwind.Apply(inst, target)
			end
			return
		end
		if
			property == "Text"
			and (type(target) == "table" and not Reactive.IsRef(target))
		then
			Lang.Bind(inst, target)
			return
		end
		if Reactive.IsRef(target) or type(target) == "function" then
			Reactive.Effect(function()
				local resolved = Reactive.IsRef(target) and target.Value
					or target()
				if property == "Text" then
					Lang.Bind(inst, resolved)
				else
					inst[property] = resolved
				end
			end)
			return
		end
		if property == "Text" then
			Lang.Bind(inst, target)
		elseif property ~= "Parent" and property ~= "Children" then
			inst[property] = target
		end
	end

	function Tailwind.CreateElement(tag, props, children)
		props = props or {}
		local classMap = {
			Card = "Frame",
			Box = "Frame",
			Row = "Frame",
			Col = "Frame",
			Text = "TextLabel",
			Button = "TextButton",
			Input = "TextBox",
		}
		local robloxClass = classMap[tag] or tag
		local inst = Draw.New(
			robloxClass,
			{ BackgroundTransparency = robloxClass == "Frame" and 1 or 1 }
		)
		if tag == "Card" then
			Tailwind.Apply(
				inst,
				"bg-panel rounded-xl border-2 border-outline p-3 flex-col gap-2 spotlight"
			)
		elseif tag == "Text" then
			Fonts.Style(inst, "Body", Util.TextSize("Label"))
			Theme.Bind(inst, { TextColor3 = "Text" })
		end
		for property, value in pairs(props) do
			if
				type(property) == "string"
				and property:sub(1, 2) == "On"
				and type(value) == "function"
			then
				local signalName = property:sub(3)
				if signalName == "Click" and inst:IsA("GuiButton") then
					inst.Activated:Connect(value)
				elseif inst[signalName] then
					inst[signalName]:Connect(value)
				end
			else
				Tailwind.BindProp(inst, property, value)
			end
		end
		for index, child in ipairs(children or props.Children or {}) do
			if typeof(child) == "Instance" then
				child.LayoutOrder = index
				child.Parent = inst
			end
		end
		if props.Parent then
			inst.Parent = props.Parent
		end
		return inst
	end

	function Tailwind.Component(renderFn)
		return function(props, children)
			return renderFn(props or {}, children)
		end
	end

	function Tailwind.Show(whenSource, renderTrue, renderFalse)
		local holder = Draw.New("Frame", {
			Name = "ShowSlot",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
		})
		Reactive.Effect(function()
			for _, child in ipairs(holder:GetChildren()) do
				child:Destroy()
			end
			local active = Reactive.IsRef(whenSource) and whenSource.Value
				or (
					type(whenSource) == "function" and whenSource()
					or whenSource
				)
			local builder = active and renderTrue or renderFalse
			if builder then
				local built = builder()
				if typeof(built) == "Instance" then
					built.Parent = holder
				end
			end
		end)
		return holder
	end

	function Tailwind.For(listSource, renderEntry)
		local holder = Draw.New("Frame", {
			Name = "ForSlot",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
		})
		Draw.List(holder, 6, false)
		Reactive.Effect(function()
			for _, child in ipairs(holder:GetChildren()) do
				if not child:IsA("UIListLayout") then
					child:Destroy()
				end
			end
			local entries = Reactive.IsRef(listSource) and listSource.Value
				or (
					type(listSource) == "function" and listSource()
					or listSource
					or {}
				)
			for index, entry in ipairs(entries) do
				local node = renderEntry(entry, index)
				if typeof(node) == "Instance" then
					node.LayoutOrder = index
					node.Parent = holder
				end
			end
		end)
		return holder
	end

	-- ImGui-style cursor container: vertical flow by default, SameLine places items horizontally.
	-- Width spec: nil = fill remaining, 0<w<=1 = ratio, w>1 = px, w<0 = remaining minus |w| px.
	function Container.New(host, options)
		options = options or {}
		local self = setmetatable({
			Host = host,
			Items = {},
			Parent = nil,
			Depth = 0,
			PadX = options.PadX or 0,
			PadY = options.PadY or 0,
			GapX = options.GapX or Config.Gap.X,
			GapY = options.GapY or Config.Gap.Y,
			Width = 0,
			ContentHeight = 0,
			Scroll = host:IsA("ScrollingFrame"),
			OnHeight = options.OnHeight,
			IndentX = 0,
			PendingSameLine = nil,
			Window = options.Window,
			Tab = options.Tab,
		}, Container)
		if options.Parent then
			self:SetParent(options.Parent)
		end
		Layout.All[self] = true
		return self
	end

	function Container:SetParent(parent)
		self.Parent = parent
		self.Depth = parent and parent.Depth + 1 or 0
		self.Window = self.Window or (parent and parent.Window)
		self.Tab = self.Tab or (parent and parent.Tab)
	end

	function Container:MarkDirty()
		Layout.Dirty[self] = true
		Layout.Schedule()
	end

	function Container:SetWidth(width)
		width = math.max(0, math.floor(width))
		if width == self.Width then
			return
		end
		self.Width = width
		self:MarkDirty()
	end

	--@param spec { Width, Height = number|function(width), Child, ChildInset, OnLayout, After, Search }
	function Container:Add(frame, spec)
		spec = spec or {}
		local item = {
			Frame = frame,
			Width = spec.Width,
			Height = spec.Height or Util.Metric("Row"),
			Indent = self.IndentX,
			Child = spec.Child,
			ChildInset = spec.ChildInset,
			OnLayout = spec.OnLayout,
			AutoWidth = spec.AutoWidth,
			Fill = spec.Fill,
			Search = spec.Search,
			Hidden = false,
			Filtered = false,
		}
		if self.PendingSameLine then
			item.SameLine = true
			item.Gap = self.PendingSameLine.Gap
			self.PendingSameLine = nil
		end
		frame.Parent = self.Host
		self:Insert(item, spec.After)
		if spec.Child then
			spec.Child:SetParent(self)
		end
		self:MarkDirty()
		return item
	end

	function Container:Insert(item, after)
		for index, existing in ipairs(self.Items) do
			if existing == after then
				table.insert(self.Items, index + 1, item)
				return
			end
		end
		table.insert(self.Items, item)
	end

	function Container:Remove(item)
		local index = table.find(self.Items, item)
		if index then
			table.remove(self.Items, index)
		end
		if item.Child then
			item.Child:Destroy()
		end
		Theme.UnbindTree(item.Frame)
		item.Frame:Destroy()
		self:MarkDirty()
	end

	function Container:Clear()
		for index = #self.Items, 1, -1 do
			self:Remove(self.Items[index])
		end
	end

	function Container:Destroy()
		self.Destroyed = true
		Layout.All[self] = nil
		Layout.Dirty[self] = nil
	end

	function Container:SameLine(gap)
		self.PendingSameLine = { Gap = gap }
		return self
	end

	function Container:NewLine()
		self.PendingSameLine = nil
		return self:Spacing(0)
	end

	function Container:Spacing(height)
		local spacer =
			Draw.New("Frame", { Name = "Spacing", BackgroundTransparency = 1 })
		self:Add(spacer, { Height = height or Config.Gap.Y })
		return self
	end

	function Container:Indent(width)
		self.IndentX += width or 16
		return self
	end

	function Container:Unindent(width)
		self.IndentX = math.max(0, self.IndentX - (width or 16))
		return self
	end

	local function ResolveWidth(spec, available, used, gap)
		local remaining = math.max(0, available - used)
		if spec == nil or spec == 0 then
			return remaining
		end
		if spec < 0 then
			return math.max(0, remaining + spec)
		end
		if spec <= 1 then
			return math.min(
				remaining,
				math.floor((available + gap) * spec - gap + 0.5)
			)
		end
		return math.min(spec, remaining)
	end

	-- Auto-fit items inside a SameLine group when explicit width is omitted
	local function ItemWidth(item, joined, available, used, gap)
		if
			item.Width == nil
			and item.AutoWidth
			and not item.Fill
			and (joined or item.SameLine)
		then
			return math.min(item.AutoWidth(), math.max(0, available - used))
		end
		return ResolveWidth(item.Width, available, used, gap)
	end

	function Container:Place(entry, cursor, available, joined)
		if entry.SameLine and cursor.EndX then
			cursor.X = cursor.EndX + (entry.Gap or self.GapX)
		else
			if cursor.EndX then
				cursor.Y += cursor.LineHeight + self.GapY
			end
			cursor.LineIndent = entry.Indent or 0
			cursor.X = self.PadX + cursor.LineIndent
			cursor.LineHeight = 0
		end
		local lineIndent = cursor.LineIndent or 0
		local lineAvailable = math.max(0, available - lineIndent)
		local used = math.max(0, cursor.X - self.PadX - lineIndent)
		local width = ItemWidth(entry, joined, lineAvailable, used, self.GapX)
		local height = type(entry.Height) == "function" and entry.Height(width)
			or entry.Height
		if entry.LastX ~= cursor.X or entry.LastY ~= cursor.Y then
			entry.LastX, entry.LastY = cursor.X, cursor.Y
			entry.Frame.Position = UDim2.fromOffset(cursor.X, cursor.Y)
		end
		if entry.LastW ~= width or entry.LastH ~= height then
			entry.LastW, entry.LastH = width, height
			entry.Frame.Size = UDim2.fromOffset(width, height)
		end
		if entry.Child then
			entry.Child:SetWidth(width - (entry.ChildInset or 0))
		end
		if entry.OnLayout then
			entry.OnLayout(width, height)
		end
		cursor.EndX = cursor.X + width
		cursor.LineHeight = math.max(cursor.LineHeight, height)
	end

	function Container:Layout()
		Layout.Dirty[self] = nil
		if self.Destroyed or self.Width <= 0 then
			return
		end
		local available = math.max(0, self.Width - self.PadX * 2)
		local cursor =
			{ X = self.PadX, Y = self.PadY, LineHeight = 0, EndX = nil }
		local visible = {}
		for _, item in ipairs(self.Items) do
			local shown = not item.Hidden and not item.Filtered
			if item.LastShown ~= shown then
				item.LastShown = shown
				item.Frame.Visible = shown
			end
			if shown then
				table.insert(visible, item)
			end
		end
		for index, item in ipairs(visible) do
			local following = visible[index + 1]
			self:Place(
				item,
				cursor,
				available,
				following ~= nil and following.SameLine == true
			)
		end
		local height = cursor.EndX
				and (cursor.Y + cursor.LineHeight + self.PadY)
			or 0
		self:Commit(height)
	end

	function Container:Commit(height)
		if self.Scroll and self.LastCanvasHeight ~= height then
			self.LastCanvasHeight = height
			self.Host.CanvasSize = UDim2.fromOffset(0, height)
		end
		if height == self.ContentHeight then
			return
		end
		self.ContentHeight = height
		if self.OnHeight then
			Util.Try(self.OnHeight, height)
		end
		if self.Parent then
			self.Parent:MarkDirty()
		end
	end

	function Layout.Schedule()
		if Layout.Scheduled or Library.Unloaded then
			return
		end
		Layout.Scheduled = true
		RunService.RenderStepped:Once(Layout.Flush)
	end

	function Layout.Flush()
		Layout.Scheduled = false
		for _ = 1, Config.LayoutPasses do
			if next(Layout.Dirty) == nil then
				return
			end
			local batch = {}
			for container in pairs(Layout.Dirty) do
				table.insert(batch, container)
			end
			table.sort(batch, function(left, right)
				return left.Depth < right.Depth
			end)
			for _, container in ipairs(batch) do
				if Layout.Dirty[container] then
					container:Layout()
				end
			end
		end
		if next(Layout.Dirty) ~= nil then
			Layout.Schedule()
		end
	end

	function Layout.MarkAll()
		for container in pairs(Layout.All) do
			container:MarkDirty()
		end
	end

	--@return Vector2 Wrapped text bounds at given width
	function Layout.Measure(text, size, fontKind, width)
		width = math.max(1, math.floor(width))
		local key =
			table.concat({ text, size, fontKind, width, State.Language }, "\0")
		local cached = Layout.Measured[key]
		if cached then
			return cached
		end
		if Layout.MeasuredCount > Config.MeasureCacheLimit then
			table.clear(Layout.Measured)
			Layout.MeasuredCount = 0
		end
		local probe = Layout.Probe()
		probe.FontFace = Fonts.Face(fontKind)
		probe.TextSize = size
		probe.Size = UDim2.fromOffset(width, 100000)
		probe.Text = text
		local bounds = probe.TextBounds
		Layout.Measured[key] = bounds
		Layout.MeasuredCount += 1
		return bounds
	end

	-- Off-screen TextLabel probe (TextService:GetTextSize does not support custom FontFace)
	function Layout.Probe()
		local probe = Layout.ProbeLabel
		if probe and probe.Parent then
			return probe
		end
		probe = Draw.New("TextLabel", {
			Name = "Probe",
			BackgroundTransparency = 1,
			TextTransparency = 1,
			TextWrapped = true,
			Position = UDim2.fromOffset(-20000, -20000),
			Parent = State.Gui or Util.GuiParent(),
		})
		Layout.ProbeLabel = probe
		return probe
	end

	function Layout.ScrollFrame(props)
		props.BackgroundTransparency = 1
		props.ScrollBarThickness = Config.Page.ScrollBar
		props.VerticalScrollBarInset = Enum.ScrollBarInset.Always
		props.ScrollingDirection = Enum.ScrollingDirection.Y
		props.CanvasSize = UDim2.new()
		props.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		local frame = Draw.New("ScrollingFrame", props)
		Theme.Bind(frame, { ScrollBarImageColor3 = "Muted" })
		return frame
	end

	function Container:Columns(count, gap)
		count = math.max(1, math.floor(tonumber(count) or 2))
		gap = gap or self.GapX
		local cols = {}
		local colWidth = 1 / count
		for index = 1, count do
			if index > 1 then
				self:SameLine(gap)
			end
			local subFrame = Draw.New("Frame", {
				BackgroundTransparency = 1,
				Parent = self.Host,
			})
			local subContainer = Container.New(subFrame, {
				Parent = self,
				PadX = 0,
				PadY = 0,
				GapX = self.GapX,
				GapY = self.GapY,
			})
			local entry = self:Add(subFrame, {
				Width = colWidth,
				Height = 0,
				Child = subContainer,
			})
			subContainer.OnHeight = function(nextHeight)
				entry.Height = nextHeight
				self:MarkDirty()
			end
			cols[index] = subContainer
		end
		return table.unpack(cols)
	end

	function Container:Mount(element, spec)
		spec = spec or {}
		local frame = (type(element) == "table" and element.Frame) or element
		if not frame then
			return nil
		end
		frame.Parent = self.Host
		return self:Add(frame, {
			Width = spec.Width,
			Height = spec.Height or frame.Size.Y.Offset or Util.Metric("Row"),
			After = spec.After,
			Search = spec.Search,
			Fill = spec.Fill,
		})
	end

	function Container:EndChild()
		Gui.EndChild()
		return self.Parent or self
	end

	function Container:AddBadge(text, spec)
		spec = spec or {}
		spec.Text = text or spec.Text
		spec.Container = self
		return Gui.Badge(self, spec)
	end

	function Container:AddKbd(keys, spec)
		spec = spec or {}
		spec.Keys = keys or spec.Keys
		spec.Container = self
		return Gui.Kbd(self, spec)
	end

	function Container:AddMarquee(text, spec)
		spec = spec or {}
		spec.Text = text or spec.Text
		spec.Container = self
		return Gui.Marquee(self, spec)
	end

	function Container:tw(target, classes)
		return Tailwind.Apply(target, classes)
	end

	function Container:h(tag, props, children)
		local inst = Tailwind.CreateElement(tag, props, children)
		if inst then
			self:Mount(inst, props)
		end
		return inst
	end

	Gui.Press = { Active = false, Token = 0 }

	function Gui.Lookup(container, id)
		local registry = container and container.Ids
		return id ~= nil and registry and registry[id] or nil
	end

	function Gui.Remember(container, id, handle)
		if not container or id == nil then
			return
		end
		container.Ids = container.Ids or {}
		container.Ids[id] = handle
	end

	function Gui.Current()
		return Gui.Stack[#Gui.Stack]
	end

	function Gui.BeginChild(parent, id, options)
		if type(id) == "table" and options == nil then
			options, id = id, id.Id
		end
		local existing = Gui.Lookup(parent, id)
		if existing then
			table.insert(Gui.Stack, existing)
			return existing
		end
		options = options or {}
		local holder = Draw.New(
			"Frame",
			{ Name = tostring(id or "Child"), BackgroundTransparency = 1 }
		)
		local hasBorder = options.Border ~= false and options.Fill ~= false
		local fillToken = options.Fill or (hasBorder and "Element" or nil)
		local strokeToken = options.Stroke or (hasBorder and "Track" or nil)
		local radius = options.Radius or 10
		local surface = Draw.Box("Frame", {
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = options.Clip == true,
			Parent = holder,
		}, fillToken, strokeToken, radius, options.Thickness or 2)
		if hasBorder and not options.Fill then
			surface.BackgroundTransparency = 0.4
		end
		local useScroll = options.Scroll == true
			or options.Height ~= nil and options.Scroll ~= false
		local host = useScroll
				and Layout.ScrollFrame({
					Size = UDim2.fromScale(1, 1),
					Parent = surface,
				})
			or Draw.New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = surface,
			})
		local child = Container.New(host, {
			PadX = options.PadX or 8,
			PadY = options.PadY or 8,
			GapX = options.GapX,
			GapY = options.GapY,
			Parent = parent,
		})
		child.Frame, child.Surface = holder, surface
		local inset = useScroll and Config.Page.ScrollBar or 0
		if parent and parent.Add then
			child.Item = parent:Add(holder, {
				Width = options.Width,
				Height = options.Height or function()
					return child.ContentHeight
				end,
				Child = child,
				ChildInset = inset,
			})
		end
		Gui.Remember(parent, id, child)
		table.insert(Gui.Stack, child)
		return child
	end

	function Gui.EndChild()
		Gui.Stack[#Gui.Stack] = nil
		return Gui.Current()
	end

	function Gui.Badge(parent, spec, token, shiny)
		local textSpec = spec
		local container = type(parent) == "table" and parent.Add and parent
			or nil
		local host = (type(parent) == "userdata" and parent)
			or (container and container.Host)
			or nil
		if
			type(spec) == "table" and (spec.Text ~= nil or spec.Color ~= nil)
		then
			textSpec = spec.Text or ""
			token = spec.Color or token
			shiny = spec.Shiny
			container = spec.Container or container
		end
		token = token or "Danger"
		local shade = token .. "Dark"
		local pill = Draw.Box("Frame", {
			Name = "Badge",
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 18),
			Parent = host,
		}, token, Themes.Shared[shade] and shade or "Outline", 5, 1.5)
		Draw.Padding(pill, 0, 6, 0, 6)
		local label = Draw.Text({
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = pill,
		}, "Strong", 11, token == "Coin" and "Ink" or "OnAccent", textSpec)
		if shiny ~= false then
			Fx.Shimmer(label, token == "Coin" and "Ink" or "White")
		end
		local width = Layout.Measure(label.Text, 11, "Strong", 400).X + 14
		local badgeObj = {
			Frame = pill,
			Label = label,
			Width = width,
			SetText = function(_, nextText)
				Lang.Bind(label, nextText)
			end,
			SetColor = function(_, nextToken)
				Theme.Bind(pill, { BackgroundColor3 = nextToken })
			end,
		}
		if container then
			badgeObj.Item = container:Add(pill, { Width = width, Height = 20 })
		end
		return badgeObj, label
	end

	function Gui.Kbd(parent, keySpec)
		local container = type(parent) == "table" and parent.Add and parent
			or nil
		local host = (type(parent) == "userdata" and parent)
			or (container and container.Host)
			or nil
		local keyText = type(keySpec) == "table"
				and (keySpec.Keys or keySpec.Text or keySpec[1])
			or keySpec
		local holder, face = Draw.Block(host, "Element", "Track", 5, 2)
		holder.AutomaticSize = Enum.AutomaticSize.X
		holder.Size = UDim2.fromOffset(0, 20)
		face.AutomaticSize = Enum.AutomaticSize.X
		Draw.Padding(face, 0, 6, 0, 6)
		local shortText = Keybinds.Short
				and Keybinds.Short(tostring(keyText or ""))
			or tostring(keyText or "")
		local label = Draw.Text({
			Text = shortText,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = face,
		}, "Strong", 11, "SubText")
		local width = Layout.Measure(shortText, 11, "Strong", 400).X + 16
		if container then
			container:Add(holder, { Width = width, Height = 22 })
		end
		return holder, label
	end

	function Gui.Marquee(container, spec, speed)
		local textSpec = type(spec) == "table" and spec.Text or spec
		speed = (type(spec) == "table" and spec.Speed) or speed or 55
		local height = Util.Metric("Row") - 4
		local clip = Draw.Box(
			"Frame",
			{ Name = "Marquee", ClipsDescendants = true },
			"Element",
			"Outline",
			8,
			2
		)
		local track = Draw.Text({
			Position = UDim2.fromOffset(10, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			Parent = clip,
		}, "Body", Util.TextSize("Label"), "Text", textSpec)
		local entry = container:Add(clip, {
			Height = height,
			Search = Lang.SearchText(textSpec),
			OnLayout = function(width)
				local textW =
					Layout.Measure(track.Text, track.TextSize, "Body", 4000).X
				if textW > width - 20 then
					track.Position = UDim2.fromOffset(width, 0)
					local duration = math.max(4, (width + textW) / speed)
					Anim.Tween(
						track,
						{ Position = UDim2.fromOffset(-textW, 0) },
						duration,
						"Linear",
						-1,
						false
					)
				else
					track.Position = UDim2.fromOffset(10, 0)
				end
			end,
		})
		return {
			Frame = clip,
			Label = track,
			Item = entry,
			SetText = function(_, nextSpec)
				Lang.Bind(track, nextSpec)
				container:MarkDirty()
			end,
		}
	end

	Gui.ButtonStyles = {
		Default = { Face = "Element", Shade = "Track", Text = "Text" },
		Primary = { Face = "Blue", Shade = "BlueDark", Text = "White" },
		Success = { Face = "Good", Shade = "GoodDark", Text = "White" },
		Danger = { Face = "Danger", Shade = "DangerDark", Text = "White" },
		Warning = { Face = "Coin", Shade = "CoinDark", Text = "Ink" },
		Ghost = { Face = nil, Shade = nil, Text = "Text" },
	}

	function Gui.BuildButtonFace(options)
		local styleName = options.Style or "Default"
		local style = Gui.ButtonStyles[styleName] or Gui.ButtonStyles.Default
		local radius = options.Radius or Config.Metrics.Desktop.Radius
		if not style.Face then
			local holder = Draw.New(
				"Frame",
				{ Name = "GhostButton", BackgroundTransparency = 1 }
			)
			local face = Draw.Box("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = holder,
			}, "Hover", nil, radius)
			return holder, face, nil, 0, style
		end
		local depth = options.Depth or Config.Button.Depth
		local holder, face, shade =
			Draw.Block(nil, style.Face, style.Shade, radius, depth)
		face.ClipsDescendants = true
		return holder, face, shade, depth, style
	end

	function Gui.BuildButtonContent(face, options, style)
		local content = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			Parent = face,
		})
		Draw.List(
			content,
			Config.Button.IconGap,
			true,
			Enum.HorizontalAlignment.Center,
			Enum.VerticalAlignment.Center
		)
		Draw.Padding(content, 0, 8, 0, 8)
		if options.Icon then
			local icon = Icons.Create(
				content,
				options.Icon,
				Util.Metric("Icon"),
				style.Text,
				options.Text
			)
			icon.LayoutOrder = 1
		end
		local label = Draw.Text({
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = content,
		}, "Body", Util.TextSize("Button"), style.Text, options.Text or "")
		return label
	end

	function Gui.BindButtonInput(handle)
		local face, hit, style = handle.Face, handle.Hit, handle.Style
		hit.MouseEnter:Connect(function()
			if State.Touch or handle.Disabled then
				return
			end
			if not style.Face then
				Motion.Spring(face, "BackgroundTransparency", 0.35, "Fast")
			else
				local base = Theme.Colors[style.Face] or Color3.new(1, 1, 1)
				Motion.Spring(
					face,
					"BackgroundColor3",
					Util.Lighten(base, Config.Button.HoverLighten),
					"Fast"
				)
			end
		end)
		hit.MouseLeave:Connect(function()
			if not style.Face then
				Motion.Spring(face, "BackgroundTransparency", 1, "Fast")
			else
				Motion.Spring(
					face,
					"BackgroundColor3",
					Theme.Colors[style.Face] or Color3.new(1, 1, 1),
					"Fast"
				)
			end
			Motion.Spring(face, "Position", UDim2.new(), "Fast")
		end)
		hit.MouseButton1Down:Connect(function()
			if not handle.Disabled and handle.Depth > 0 then
				Motion.Spring(
					face,
					"Position",
					UDim2.fromOffset(0, handle.Depth - 1),
					"Fast"
				)
			end
		end)
		hit.MouseButton1Up:Connect(function()
			if handle.Depth > 0 then
				Motion.Spring(
					face,
					"Position",
					UDim2.new(),
					"Normal",
					{ Damping = 0.52 }
				)
			end
		end)
		hit.Activated:Connect(function(inputObject)
			if handle.Disabled then
				return
			end
			local pos = inputObject and inputObject.Position
				or UserInputService:GetMouseLocation()
			Fx.Ripple(face, Vector2.new(pos.X, pos.Y), style.Text)
			Fx.Squash(handle.Holder, 1.4)
			if handle.OnActivate then
				handle:OnActivate()
			end
		end)
	end

	function Gui.Button(container, options)
		options = options or {}
		local holder, face, shade, depth, style = Gui.BuildButtonFace(options)
		local label = Gui.BuildButtonContent(face, options, style)
		local hit = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 5,
			Parent = holder,
		})
		local handle = {
			Container = container,
			Holder = holder,
			Face = face,
			Shade = shade,
			Depth = depth,
			Style = style,
			Label = label,
			Hit = hit,
			Disabled = options.Disabled == true,
			OnActivate = options.OnActivate,
		}
		Gui.BindButtonInput(handle)
		local iconExtra = options.Icon
				and (Util.Metric("Icon") + Config.Button.IconGap)
			or 0
		if container and container.Add then
			handle.Item = container:Add(holder, {
				Width = options.Width,
				Height = (options.Height or Util.Metric("Box")) + depth,
				After = options.After,
				Search = Lang.SearchText(options.Text),
				AutoWidth = function()
					return Layout.Measure(
						label.Text,
						label.TextSize,
						"Body",
						1000
					).X + iconExtra + 32
				end,
			})
		end
		if options.Tooltip then
			Tooltip.Attach(holder, options.Tooltip)
		end
		return handle
	end
	local function BuildSelectableVisuals(row, spec, height)
		local token = spec.Color or "Accent"
		local bar = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(Config.Selectable.BarWidth, 0),
			Parent = row,
		}, token, nil, 2)
		local thumbSize = height - 8
		local thumb
		if spec.Image or spec.Icon then
			thumb = Draw.Thumb(
				row,
				spec.Image or spec.Icon,
				spec.Tint,
				thumbSize,
				UDim2.new(0, 10, 0.5, 0)
			)
		end
		return bar, thumb, thumbSize
	end

	function Gui.Selectable(parent, spec)
		spec = spec or {}
		local container = spec.Container
			or (type(parent) == "table" and parent.Add and parent or nil)
		local host = (type(parent) == "userdata" and parent)
			or (container and container.Host)
			or nil
		local height = spec.Height or Util.Metric("Item")
		local row = Draw.Box("TextButton", {
			Name = "Selectable",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(spec.Width or 1, 0, 0, height),
			Parent = host,
		}, "Hover", nil, Config.Selectable.Radius)
		local bar, thumb, thumbSize = BuildSelectableVisuals(row, spec, height)
		local hasMedia = thumb ~= nil
		local textOffset = hasMedia and (thumbSize + 18) or 12
		local label = Draw.Text(
			{
				Position = UDim2.fromOffset(textOffset, 0),
				Size = UDim2.new(
					1,
					-(textOffset + (spec.RightPadding or 26)),
					1,
					0
				),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = row,
			},
			"Body",
			Util.TextSize("Label"),
			"Text",
			spec.Text or spec.Label or "Item"
		)
		local mark = Icons.Vector(row, "check", 15, "OnAccent")
		mark.AnchorPoint = Vector2.new(1, 0.5)
		mark.Position = UDim2.new(1, -8, 0.5, 0)
		local markScale = Draw.New(
			"UIScale",
			{ Scale = spec.Selected and 1 or 0, Parent = mark }
		)
		local handle = {
			Frame = row,
			Button = row,
			Label = label,
			Thumb = thumb,
			Bar = bar,
			Mark = mark,
			MarkScale = markScale,
			Selected = spec.Selected == true,
			Hovered = false,
		}
		function handle.Render(instant)
			local isSel = handle.Selected
			local duration = instant and 0 or Config.Tween.Fast
			local fill = isSel and Theme.Colors.Accent or Theme.Colors.Hover
			local alpha = isSel and 0 or (handle.Hovered and 0.45 or 1)
			Anim.Tween(
				row,
				{ BackgroundColor3 = fill, BackgroundTransparency = alpha },
				duration
			)
			Anim.Tween(
				label,
				{ TextColor3 = Theme.Colors[isSel and "OnAccent" or "Text"] },
				duration
			)
			if instant then
				Motion.Set(markScale, "Scale", isSel and 1 or 0)
			else
				Motion.Spring(
					markScale,
					"Scale",
					isSel and 1 or 0,
					"Fast",
					{ Damping = 0.6 }
				)
			end
			Motion.Spring(
				bar,
				"Size",
				UDim2.fromOffset(
					Config.Selectable.BarWidth,
					isSel and (height - 8) or 0
				),
				"Fast"
			)
		end
		function handle.SetSelected(active, instant)
			handle.Selected = active == true
			handle.Render(instant)
		end
		if not State.Touch then
			row.MouseEnter:Connect(function()
				handle.Hovered = true
				handle.Render()
			end)
			row.MouseLeave:Connect(function()
				handle.Hovered = false
				handle.Render()
			end)
		end
		row.Activated:Connect(function()
			Fx.Ripple(row, nil, spec.Color or "White")
			if spec.Toggle ~= false then
				handle.SetSelected(not handle.Selected)
			end
			if type(spec.Callback) == "function" then
				Util.Try(spec.Callback, handle.Selected, handle)
			end
		end)
		Theme.OnRender(row, function()
			handle.Render(true)
		end)
		handle.Render(true)
		if container and container.Add then
			handle.Item = container:Add(row, {
				Width = spec.Width,
				Height = height,
				After = spec.After,
				Search = Lang.SearchText(spec.Text or spec.Label),
			})
		end
		return handle
	end

	function Widget.Normalize(idx, info)
		if type(idx) == "table" and info == nil then
			info = idx
			idx = info.Idx or info.Flag
		end
		return idx, info or {}
	end

	local function BindWidgetReactivity(option, spec)
		local boundRef = (spec.Bind and Reactive.IsRef(spec.Bind)) and spec.Bind
			or Reactive.Ref(option.Value)
		option.Ref = boundRef
		if
			spec.Bind
			and Reactive.IsRef(spec.Bind)
			and spec.Bind:Get() ~= nil
		then
			option.Value = spec.Bind:Get()
		end
		Reactive.Watch(boundRef, function(nextVal)
			if
				not option._syncingRef
				and option.SetValue
				and nextVal ~= option.Value
			then
				option:SetValue(nextVal)
			end
		end)
		if spec.Visible ~= nil then
			if Reactive.IsRef(spec.Visible) then
				Reactive.Effect(function()
					option:SetVisible(spec.Visible:Get() == true)
				end)
			elseif type(spec.Visible) == "boolean" then
				option:SetVisible(spec.Visible)
			end
		end
		if spec.Disabled ~= nil then
			if Reactive.IsRef(spec.Disabled) then
				Reactive.Effect(function()
					option:SetDisabled(spec.Disabled:Get() == true)
				end)
			elseif type(spec.Disabled) == "boolean" then
				option:SetDisabled(spec.Disabled)
			end
		end
		if spec.DependsOn then
			local depKey = type(spec.DependsOn) == "table" and spec.DependsOn[1]
				or spec.DependsOn
			local expected = type(spec.DependsOn) == "table"
					and spec.DependsOn[2]
				or true
			task.defer(function()
				local target = Library.Options[depKey]
					or Library.Toggles[depKey]
				if target and target.OnChanged then
					local function CheckDep(currentVal)
						option:SetVisible(currentVal == expected)
					end
					CheckDep(target.Value)
					target:OnChanged(CheckDep)
				end
			end)
		end
	end

	function Widget.Register(option, idx, spec)
		option.Idx = idx
		option.Callback = spec.Callback or spec.Func
		option.Changed = {}
		option.NoSave = spec.NoSave == true or idx == nil
		if idx ~= nil then
			Library.Options[idx] = option
		end
		if spec.Tooltip and option.Row then
			Tooltip.Attach(option.Row.Holder, spec.Tooltip)
		end
		if spec.Badge and option.SetBadge then
			option:SetBadge(spec.Badge, spec.BadgeColor)
		end
		BindWidgetReactivity(option, spec)
	end

	function Widget:OnChanged(callback)
		table.insert(self.Changed, callback)
		return self
	end

	---A guard returning false vetoes a value before Callback/OnChanged see it (Library.Compat.NeedCap uses this).
	function Widget:AddGuard(guard)
		self.Guards = self.Guards or {}
		table.insert(self.Guards, guard)
		return self
	end

	---@return boolean  false when a guard vetoed `value`
	function Widget:PassGuards(value)
		for _, guard in ipairs(self.Guards or {}) do
			local ok, allowed = pcall(guard, value)
			if ok and allowed == false then
				return false
			end
		end
		return true
	end

	function Widget:Fire()
		if self.Disabled then
			return
		end
		if not self:PassGuards(self.Value) then
			return
		end
		if self.Ref then
			self._syncingRef = true
			self.Ref:Set(self.Value)
			self._syncingRef = false
		end
		Util.Try(self.Callback, self.Value)
		for _, callback in ipairs(self.Changed) do
			Util.Try(callback, self.Value)
		end
	end

	function Widget:Serialize()
		return self.Value
	end

	function Widget:Deserialize(saved)
		self:SetValue(saved)
	end

	function Widget:SetVisible(visible)
		if not self.Item then
			return self
		end
		self.Item.Hidden = not visible
		self.Container:MarkDirty()
		return self
	end

	function Widget:SetDisabled(disabled)
		self.Disabled = disabled == true
		local holder = (self.Row and self.Row.Holder)
			or (self.Item and self.Item.Frame)
		if holder then
			if not self.DisableMask and self.Disabled then
				self.DisableMask = Draw.Box("TextButton", {
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 0.45,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 15,
					Parent = holder,
				}, "Panel", nil, 8)
			end
			if self.DisableMask then
				self.DisableMask.Visible = self.Disabled
			end
		end
		return self
	end

	function Widget:Flash(colorToken)
		local row = self.Row
		if not row or not row.Holder then
			return self
		end
		if not row.Hover then
			row.Hover = Draw.Box("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(-4, 0),
				Size = UDim2.new(1, 8, 1, 0),
				ZIndex = 1,
				Parent = row.Holder,
			}, "Hover", nil, 6)
		end
		local hover = row.Hover
		hover.BackgroundColor3 = Theme.Colors[colorToken or "Coin"]
			or Theme.Colors.Coin
		hover.BackgroundTransparency = 0.25
		Anim.Tween(hover, {
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.Colors.Hover,
		}, 0.55)
		return self
	end

	function Widget:SetBadge(text, colorToken)
		if not self.Row then
			return self
		end
		if not self.BadgePill then
			self.BadgePill = Gui.Badge(
				self.Row.Right,
				{ Text = text, Color = colorToken or "Coin" }
			)
			self.Row:AddRight(self.BadgePill.Frame, self.BadgePill.Width)
		else
			self.BadgePill:SetText(text)
			if colorToken then
				self.BadgePill:SetColor(colorToken)
			end
		end
		return self
	end

	function Widget:AddKeyPicker(idx, spec)
		KeyPicker.New(
			self.Row,
			idx,
			spec or {},
			self.Type == "Toggle" and self or nil
		)
		return self
	end

	function Widget:AddColorPicker(idx, spec)
		ColorPicker.New(self.Row, idx, spec or {})
		return self
	end

	function Row.LineHeight(kind)
		return Fonts.Size("Body", Util.TextSize(kind or "Label")) + 8
	end

	function Row.SearchText(info)
		local parts = {
			Lang.SearchText(info.Text or info.Title),
			Lang.SearchText(info.Description),
		}
		if type(info.Values) == "table" then
			for _, v in ipairs(info.Values) do
				table.insert(
					parts,
					Lang.SearchText(
						Dropdown
								and Dropdown.FormatValue
								and Dropdown.FormatValue(v)
							or v
					)
				)
			end
		end
		return table.concat(parts, " ")
	end

	--@return row Left text + right control slot, auto-sized to wrapped text height
	function Row.New(container, spec, options)
		options = options or {}
		local holder =
			Draw.New("Frame", { Name = "Row", BackgroundTransparency = 1 })
		local row = setmetatable({
			Holder = holder,
			Container = container,
			RightWidth = 0,
			RightCount = 0,
			TitleFont = options.TitleFont or "Body",
			IconOffset = 0,
		}, { __index = Row })
		if spec.Icon then
			row.Icon = Icons.Create(
				holder,
				spec.Icon,
				16,
				nil,
				spec.Text or spec.Title
			)
			row.Icon.AnchorPoint = Vector2.new(0, 0.5)
			row.Icon.ZIndex = 3
			row.IconOffset = 22
		end
		row.Title = Draw.Text(
			{
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				ZIndex = 3,
				Parent = holder,
			},
			row.TitleFont,
			options.TitleSize or Util.TextSize("Label"),
			options.TitleToken or "Text",
			spec.Text or spec.Title or ""
		)
		if spec.Description then
			row.Desc = Draw.Text({
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				ZIndex = 3,
				Parent = holder,
			}, "Desc", Util.TextSize("Desc"), "SubText", spec.Description)
		end
		row.Right = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			ZIndex = 4,
			Parent = holder,
		})
		Draw.List(
			row.Right,
			6,
			true,
			Enum.HorizontalAlignment.Right,
			Enum.VerticalAlignment.Center
		)
		if options.Clickable then
			row.Hit = Draw.New("TextButton", {
				Text = "",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
				Parent = holder,
			})
		end
		row.Item = container:Add(holder, {
			Height = function(width)
				return row:Measure(width)
			end,
			OnLayout = function(width, height)
				row:Arrange(width, height)
			end,
			Search = Row.SearchText(spec),
		})
		return row
	end

	function Row.BindHover() end

	function Row:Measure(width)
		local textWidth = math.max(
			20,
			width
				- self.IconOffset
				- self.RightWidth
				- (self.RightWidth > 0 and 10 or 0)
		)
		local titleHeight = Layout.Measure(
			self.Title.Text,
			self.Title.TextSize,
			self.TitleFont,
			textWidth
		).Y
		local descHeight = self.Desc
				and Layout.Measure(
					self.Desc.Text,
					self.Desc.TextSize,
					"Desc",
					textWidth
				).Y
			or 0
		self.TextWidth, self.TitleHeight, self.DescHeight =
			textWidth, titleHeight, descHeight
		local content = titleHeight + (self.Desc and descHeight + 2 or 0)
		return math.max(self.MinHeight or Util.Metric("Row"), content + 8)
	end

	function Row:Arrange(_, height)
		local content = self.TitleHeight
			+ (self.Desc and self.DescHeight + 2 or 0)
		local top = math.floor((height - content) / 2)
		if self.Icon then
			self.Icon.Position = UDim2.new(0, 0, 0.5, 0)
		end
		self.Title.Position = UDim2.fromOffset(self.IconOffset, top)
		self.Title.Size = UDim2.fromOffset(self.TextWidth, self.TitleHeight)
		if self.Desc then
			self.Desc.Position =
				UDim2.fromOffset(self.IconOffset, top + self.TitleHeight + 2)
			self.Desc.Size = UDim2.fromOffset(self.TextWidth, self.DescHeight)
		end
		self.Right.Size = UDim2.new(0, self.RightWidth, 1, 0)
	end

	function Row:AddRight(frame, width)
		self.RightCount += 1
		frame.LayoutOrder = -self.RightCount
		frame.Parent = self.Right
		frame:SetAttribute("RightWidth", width)
		self:RecalcRight()
	end

	function Row:RecalcRight()
		local total, count = 0, 0
		for _, child in ipairs(self.Right:GetChildren()) do
			local width = child:GetAttribute("RightWidth")
			if width then
				total += width
				count += 1
			end
		end
		self.RightWidth = total + math.max(0, count - 1) * 6
		self.Container:MarkDirty()
	end

	function Row:SetTitle(text)
		Lang.Bind(self.Title, text)
		self.Container:MarkDirty()
	end

	--@return stack Top label + full-width bottom control slot
	function Row.Stack(container, spec, controlHeight)
		local holder =
			Draw.New("Frame", { Name = "Stack", BackgroundTransparency = 1 })
		local stack = setmetatable({
			Holder = holder,
			Container = container,
			ControlHeight = controlHeight,
			IconOffset = 0,
		}, { __index = Row })
		if spec.Icon then
			stack.Icon = Icons.Create(
				holder,
				spec.Icon,
				16,
				nil,
				spec.Text or spec.Title
			)
			stack.IconOffset = 22
		end
		stack.Title = Draw.Text(
			{ TextTruncate = Enum.TextTruncate.AtEnd, Parent = holder },
			"Body",
			Util.TextSize("Label"),
			spec.Risky and "Risky" or "Text",
			spec.Text or spec.Title or ""
		)
		stack.Aside = Draw.Text({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = holder,
		}, "Body", Util.TextSize("Label"), "SubText")
		if spec.Description then
			stack.Desc = Draw.Text({
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = holder,
			}, "Desc", Util.TextSize("Desc"), "SubText", spec.Description)
		end
		stack.Control = Draw.New(
			"Frame",
			{ Name = "Control", BackgroundTransparency = 1, Parent = holder }
		)
		stack.Item = container:Add(holder, {
			Height = function(width)
				return stack:MeasureStack(width)
			end,
			OnLayout = function(width)
				stack:ArrangeStack(width)
			end,
			Search = Row.SearchText(spec),
		})
		return stack
	end

	function Row:MeasureStack(width)
		self.StackWidth = width
		local titled = self.Title.Text ~= ""
			or self.Aside.Text ~= ""
			or self.AsideWidth ~= nil
		self.LineHeight = titled and Row.LineHeight() or 0
		self.DescHeight = self.Desc
				and Layout.Measure(
					self.Desc.Text,
					self.Desc.TextSize,
					"Desc",
					width
				).Y
			or 0
		self.ControlTop = self.LineHeight
			+ (self.Desc and self.DescHeight + 2 or 0)
			+ 4
		return self.ControlTop + self.ControlHeight + 2
	end

	function Row:ArrangeStack(width)
		local asideWidth = self.AsideWidth
			or (
				self.Aside.Text ~= ""
					and (Layout.Measure(
						self.Aside.Text,
						self.Aside.TextSize,
						"Body",
						width
					).X + 8)
				or 0
			)
		if self.Icon then
			self.Icon.Position = UDim2.fromOffset(
				0,
				math.max(0, math.floor((self.LineHeight - 16) / 2))
			)
		end
		self.Title.Position = UDim2.fromOffset(self.IconOffset, 0)
		self.Title.Size = UDim2.fromOffset(
			math.max(10, width - self.IconOffset - asideWidth),
			self.LineHeight
		)
		self.Aside.Size = UDim2.fromOffset(asideWidth, self.LineHeight)
		if self.Desc then
			self.Desc.Position = UDim2.fromOffset(0, self.LineHeight)
			self.Desc.Size = UDim2.fromOffset(width, self.DescHeight)
		end
		self.Control.Position = UDim2.fromOffset(0, self.ControlTop)
		self.Control.Size = UDim2.new(1, 0, 0, self.ControlHeight)
		if self.OnArranged then
			self.OnArranged(width)
		end
	end

	function Container:AddToggle(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local toggle = setmetatable({
			Type = "Toggle",
			Value = info.Default == true,
			Style = info.Style or "Switch",
			Container = self,
		}, Toggle)
		toggle.Row = Row.New(
			self,
			info,
			{ Clickable = true, TitleToken = info.Risky and "Risky" or nil }
		)
		toggle.Item = toggle.Row.Item
		if toggle.Style == "Checkbox" then
			toggle:BuildCheckbox()
		else
			toggle:BuildSwitch()
		end
		toggle.Row.Hit.Activated:Connect(function()
			toggle:SetValue(not toggle.Value)
			if toggle.Value then
				Anim.CoinPop(
					toggle.Row.Holder,
					UDim2.new(1, -toggle.Track.Size.X.Offset / 2, 0, 6),
					18
				)
			end
		end)
		Widget.Register(toggle, idx, info)
		if idx ~= nil then
			Library.Toggles[idx] = toggle
		end
		Theme.OnRender(toggle, function()
			toggle:Render(true)
		end)
		return toggle
	end

	function Container:AddCheckbox(idx, info)
		idx, info = Widget.Normalize(idx, info)
		info.Style = "Checkbox"
		return self:AddToggle(idx, info)
	end

	function Toggle:BuildSwitch()
		local size, knobSize = Util.Metric("Switch"), Util.Metric("SwitchKnob")
		self.KnobSize = knobSize
		self.Track = Draw.Box(
			"Frame",
			{ Size = UDim2.fromOffset(size.X, size.Y) },
			"Track",
			"Outline",
			UDim.new(1, 0),
			2
		)
		self.Knob = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(knobSize, knobSize),
			Parent = self.Track,
		}, "Knob", "Outline", UDim.new(1, 0), 2)
		self.Mark = Icons.Vector(self.Knob, "check", knobSize - 2, "Good")
		self.Mark.AnchorPoint = Vector2.new(0.5, 0.5)
		self.Mark.Position = UDim2.fromScale(0.5, 0.5)
		self.MarkScale = Draw.New(
			"UIScale",
			{ Scale = self.Value and 1 or 0, Parent = self.Mark }
		)
		self.Row:AddRight(self.Track, size.X)
	end

	function Toggle:BuildCheckbox()
		local size = Util.Metric("Check")
		self.Track = Draw.Box(
			"Frame",
			{ Size = UDim2.fromOffset(size, size) },
			"Element",
			"Outline",
			6,
			2
		)
		self.Mark = Icons.Vector(self.Track, "check", size - 4, "Ink")
		self.Mark.AnchorPoint = Vector2.new(0.5, 0.5)
		self.Mark.Position = UDim2.fromScale(0.5, 0.5)
		self.MarkScale = Draw.New(
			"UIScale",
			{ Scale = self.Value and 1 or 0, Parent = self.Mark }
		)
		self.Row:AddRight(self.Track, size)
	end

	function Toggle:Render(instant)
		local on = self.Value
		local duration = instant and 0 or Config.Tween.Normal
		if self.Knob then
			local travel = self.Track.Size.X.Offset - self.KnobSize - 3
			local targetPos = UDim2.new(0, on and travel or 3, 0.5, 0)
			Anim.Tween(
				self.Track,
				{ BackgroundColor3 = Theme.Colors[on and "Good" or "Track"] },
				duration
			)
			if instant then
				Motion.Set(self.Knob, "Position", targetPos)
			else
				Motion.Spring(
					self.Knob,
					"Position",
					targetPos,
					"Fast",
					{ Damping = 0.58 }
				)
				Fx.Squash(self.Knob, 1.9)
			end
		else
			Anim.Tween(
				self.Track,
				{ BackgroundColor3 = Theme.Colors[on and "Coin" or "Element"] },
				duration
			)
		end
		if self.MarkScale then
			if instant then
				Motion.Set(self.MarkScale, "Scale", on and 1 or 0)
			else
				Motion.Spring(
					self.MarkScale,
					"Scale",
					on and 1 or 0,
					"Fast",
					{ Damping = 0.58 }
				)
			end
		end
	end

	function Toggle:SetValue(value)
		value = value == true
		if value == self.Value then
			return
		end
		self.Value = value
		self:Render(false)
		self:Fire()
	end

	function Container:AddSlider(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local knob = Util.Metric("Knob")
		local slider = setmetatable({
			Type = "Slider",
			Min = info.Min or 0,
			Max = info.Max or 100,
			Rounding = info.Rounding or 0,
			Prefix = info.Prefix or "",
			Suffix = info.Suffix or "",
			FinishedOnly = info.Finished == true,
			Container = self,
		}, Slider)
		slider.Value = Util.Round(
			math.clamp(
				tonumber(info.Default) or slider.Min,
				slider.Min,
				slider.Max
			),
			slider.Rounding
		)
		slider.Row = Row.Stack(self, info, knob + 4)
		slider.Item = slider.Row.Item
		slider:Build(knob)
		Widget.Register(slider, idx, info)
		slider:MeasureAside()
		slider:Render(false)
		Lang.OnChange(slider, function()
			slider:MeasureAside()
			slider:Render(false)
			slider.Container:MarkDirty()
		end)
		return slider
	end

	function Slider:Build(knob)
		local control = self.Row.Control
		local trackHeight = Util.Metric("Track")
		self.Track = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, knob / 2, 0.5, 0),
			Size = UDim2.new(1, -knob, 0, trackHeight),
			Parent = control,
		}, "Track", "Outline", UDim.new(1, 0), 2)
		self.Fill = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(0, 1), Parent = self.Track },
			"Accent",
			nil,
			UDim.new(1, 0)
		)
		self.Knob = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(knob, knob),
			Position = UDim2.fromScale(0, 0.5),
			ZIndex = 3,
			Parent = self.Track,
		}, "Coin", "Outline", UDim.new(1, 0), 2)
		local slit = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, 3, 0.5, 0),
			Parent = self.Knob,
		}, "CoinDark", nil, 2)
		slit.ZIndex = 4
		self.KnobScale = Draw.New("UIScale", { Parent = self.Knob })
		self:BuildValueBox()
		local hit = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 6),
			Position = UDim2.fromOffset(0, -3),
			ZIndex = 5,
			Parent = control,
		})
		hit.InputBegan:Connect(function(input)
			if Util.IsPointer(input) then
				self:BeginDrag(input)
			end
		end)
	end

	function Slider:MeasureAside()
		local widest = 0
		local mid = Util.Round((self.Min + self.Max) / 2, self.Rounding)
		for _, sample in ipairs({ self.Min, self.Max, mid }) do
			widest = math.max(
				widest,
				Layout.Measure(
					self:Format(sample),
					self.Row.Aside.TextSize,
					"Body",
					400
				).X
			)
		end
		self.Row.AsideWidth = widest + 14
	end

	function Slider:BuildValueBox()
		local aside = self.Row.Aside
		self.ValueBox = Draw.Text({
			ClassName = "TextBox",
			ClearTextOnFocus = false,
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = aside,
		}, "Body", Util.TextSize("Label"), "Accent")
		aside.TextTransparency = 1
		self.ValueBox.Focused:Connect(function()
			self.ValueBox.Text = tostring(self.Value)
		end)
		self.ValueBox.FocusLost:Connect(function()
			local typed = tonumber(self.ValueBox.Text)
			if typed then
				self:SetValue(typed)
			end
			self:Render(false)
		end)
	end

	function Slider:BeginDrag(input)
		Motion.Spring(self.KnobScale, "Scale", 1.24, "Fast", { Damping = 0.52 })
		self.Dragging = true
		self:SetFromX(input.Position.X)
		State.Drag = {
			Move = function(move)
				self:SetFromX(move.Position.X)
			end,
			Stop = function()
				Motion.Spring(
					self.KnobScale,
					"Scale",
					1,
					"Fast",
					{ Damping = 0.58 }
				)
				self.Dragging = false
				if self.PendingFire then
					self.PendingFire = false
					self:Fire()
				end
			end,
		}
	end

	function Slider:SetFromX(screenX)
		local left, width =
			self.Track.AbsolutePosition.X, self.Track.AbsoluteSize.X
		local fraction = width > 0
				and math.clamp((screenX - left) / width, 0, 1)
			or 0
		self:SetValue(self.Min + (self.Max - self.Min) * fraction)
	end

	function Slider:Format(targetVal)
		local num = Util.Round(
			targetVal ~= nil and targetVal or self.Value,
			self.Rounding
		)
		local formatted = self.Rounding > 0
				and string.format("%." .. self.Rounding .. "f", num)
			or tostring(math.floor(num + 0.5))
		local pre = Lang.Resolve(self.Prefix or "")
		local suf = Lang.Resolve(self.Suffix or "")
		return pre .. formatted .. suf
	end

	function Slider:Render(animated)
		local span = self.Max - self.Min
		local fraction = span > 0 and (self.Value - self.Min) / span or 0
		if animated then
			Motion.Spring(
				self.Fill,
				"Size",
				UDim2.fromScale(fraction, 1),
				"Fast"
			)
			Motion.Spring(
				self.Knob,
				"Position",
				UDim2.fromScale(fraction, 0.5),
				"Fast",
				{ Damping = 0.68 }
			)
		else
			Motion.Set(self.Fill, "Size", UDim2.fromScale(fraction, 1))
			Motion.Set(self.Knob, "Position", UDim2.fromScale(fraction, 0.5))
		end
		local text = self:Format(self.Value)
		self.Row.Aside.Text = text
		if not self.ValueBox:IsFocused() then
			self.ValueBox.Text = text
		end
	end

	function Slider:SetValue(value)
		value = tonumber(value)
		if not value then
			return
		end
		value = Util.Round(math.clamp(value, self.Min, self.Max), self.Rounding)
		if value == self.Value then
			return
		end
		self.Value = value
		self:Render(true)
		if self.FinishedOnly and self.Dragging then
			self.PendingFire = true
			return
		end
		self:Fire()
	end

	function Slider:SetRange(min, max)
		self.Min, self.Max = min, max
		local clamped = math.clamp(self.Value, min, max)
		local changed = clamped ~= self.Value
		self.Value = clamped
		self:MeasureAside()
		self:Render(false)
		self.Container:MarkDirty()
		if changed then
			self:Fire()
		end
	end

	function Slider:SetMax(max)
		self:SetRange(self.Min, max)
	end

	function Slider:SetMin(min)
		self:SetRange(min, self.Max)
	end

	--@return face Field button frame for dropdown/input
	function Draw.Field(parent, className)
		local field = Draw.Box(
			className or "TextButton",
			{ Size = UDim2.fromScale(1, 1), Parent = parent },
			"Element",
			"Outline",
			8,
			2
		)
		return field
	end

	function Container:AddDropdown(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local dropdown = setmetatable({
			Type = "Dropdown",
			Multi = info.Multi == true,
			AllowNull = info.AllowNull == true,
			Searchable = info.Searchable,
			Placeholder = info.Placeholder,
			SpecialType = info.SpecialType,
			Values = info.Values or {},
			Images = info.Images,
			Colors = info.Colors,
			Container = self,
		}, Dropdown)
		if dropdown.SpecialType == "Player" then
			dropdown.Values = Util.PlayerNames()
		end
		dropdown.Value = dropdown.Multi and {} or nil
		dropdown.Row = Row.Stack(self, info, Util.Metric("Box"))
		dropdown.Item = dropdown.Row.Item
		dropdown:Build()
		Widget.Register(dropdown, idx, info)
		dropdown:ApplyDefault(info.Default)
		dropdown:WatchPlayers()
		Lang.OnChange(dropdown, function()
			dropdown:Render()
		end)
		return dropdown
	end

	function Dropdown:Build()
		local field = Draw.Field(self.Row.Control)
		self.Field = field
		self.Display = Draw.Text({
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = field,
		}, "Body", Util.TextSize("Label"), "Text")
		self:EnsureThumb()
		local cap = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -4, 0.5, 0),
			Size = UDim2.new(0, 26, 1, -8),
			Parent = field,
		}, "Accent", "Outline", 6, 2)
		self.Chevron = Icons.Vector(cap, "chevron_down", 14, "White")
		self.Chevron.AnchorPoint = Vector2.new(0.5, 0.5)
		self.Chevron.Position = UDim2.fromScale(0.5, 0.5)
		field.MouseEnter:Connect(function()
			if not State.Touch then
				Anim.Tween(
					field,
					{ BackgroundColor3 = Theme.Colors.Hover },
					Config.Tween.Fast
				)
			end
		end)
		field.MouseLeave:Connect(function()
			Anim.Tween(
				field,
				{ BackgroundColor3 = Theme.Colors.Element },
				Config.Tween.Fast
			)
		end)
		field.Activated:Connect(function()
			self:Open()
		end)
	end

	function Dropdown:ApplyDefault(default)
		if self.Multi then
			self.Value = Util.ToSet(default)
		elseif type(default) == "number" then
			self.Value = self.Values[default]
		elseif default ~= nil then
			self.Value = default
		elseif not self.AllowNull then
			self.Value = self.Values[1]
		end
		self:Render()
	end

	function Dropdown:WatchPlayers()
		if self.SpecialType ~= "Player" then
			return
		end
		local function Refresh()
			self:SetValues(Util.PlayerNames())
		end
		Util.Connect(Players.PlayerAdded, Refresh)
		Util.Connect(Players.PlayerRemoving, function()
			task.defer(Refresh)
		end)
	end

	function Dropdown:IsSelected(value)
		if self.Multi then
			return self.Value[value] == true
		end
		return self.Value == value
	end

	function Dropdown:GetActiveValues()
		local active = {}
		if not self.Multi then
			return self.Value ~= nil and { self.Value } or active
		end
		for _, value in ipairs(self.Values) do
			if self.Value[value] then
				table.insert(active, value)
			end
		end
		return active
	end

	function Dropdown.FormatValue(entry)
		if type(entry) == "table" then
			if entry.EN or entry.TH then
				return Lang.Resolve(entry)
			end
			return Lang.Resolve(entry.Text or entry.Label or entry.Value or "")
		end
		return tostring(entry or "")
	end

	function Dropdown:Render()
		local active = self:GetActiveValues()
		local labels = {}
		for _, entry in ipairs(active) do
			table.insert(labels, Dropdown.FormatValue(entry))
		end
		local text = #labels > 0 and table.concat(labels, ", ")
			or Lang.Resolve(self.Placeholder or Lang.Strings.None)
		self.Display.Text = text
		Theme.Bind(
			self.Display,
			{ TextColor3 = #labels > 0 and "Text" or "Muted" }
		)
		if self.Thumb then
			self.Thumb.Image = self.Images[self.Value] or ""
			local tint = self.Colors and self.Colors[self.Value]
			if tint then
				self.ThumbStroke.Color = tint
			end
		end
	end

	--@param images table? value -> asset id
	--@param colors table? value -> Color3
	function Dropdown:SetImages(images, colors)
		self.Images = images
		self.Colors = colors
		self:EnsureThumb()
		self:Render()
	end

	function Dropdown:EnsureThumb()
		if self.Thumb or not self.Images or self.Multi then
			return
		end
		local size = Util.Metric("Box") - 10
		self.Thumb, self.ThumbStroke = Draw.Thumb(self.Field, nil, nil, size)
		self.Display.Position = UDim2.fromOffset(size + 12, 0)
		self.Display.Size = UDim2.new(1, -(size + 46), 1, 0)
	end

	function Dropdown:SetValue(value)
		if self.Multi then
			self.Value = Util.ToSet(value)
		else
			self.Value = value
		end
		self:Render()
		self:Fire()
	end

	function Dropdown:SetValues(values)
		self.Values = values or {}
		if
			not self.Multi
			and self.Value ~= nil
			and not table.find(self.Values, self.Value)
			and not self.AllowNull
		then
			self.Value = self.Values[1]
		end
		self:Render()
		if self.List then
			self.List.Rebuild(self.Values)
		end
	end

	function Dropdown:Serialize()
		if self.Multi then
			return self:GetActiveValues()
		end
		return self.Value
	end

	function Dropdown:Pick(value)
		if self.Multi then
			self.Value[value] = not self.Value[value] or nil
		elseif self.Value == value and self.AllowNull then
			self.Value = nil
		else
			self.Value = value
		end
		self:Render()
		self:Fire()
	end

	function Dropdown:Open()
		Anim.Tween(self.Chevron, { Rotation = 180 }, Config.Tween.Normal)
		self.List = Popup.List({
			Anchor = self.Field,
			Values = self.Values,
			Multi = self.Multi,
			Images = self.Images,
			Colors = self.Colors,
			Search = self.Searchable ~= false
				and (
					self.Searchable
					or #self.Values > Config.Dropdown.SearchThreshold
				),
			IsSelected = function(value)
				return self:IsSelected(value)
			end,
			OnPick = function(value)
				self:Pick(value)
				return not self.Multi
			end,
			OnClose = function()
				self.List = nil
				Anim.Tween(self.Chevron, { Rotation = 0 }, Config.Tween.Normal)
			end,
		})
	end

	function Container:AddInput(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local input = setmetatable({
			Type = "Input",
			Value = tostring(info.Default or ""),
			Numeric = info.Numeric,
			Finished = info.Finished,
			MaxLength = info.MaxLength,
			Container = self,
		}, Input)
		input.Row = Row.Stack(self, info, Util.Metric("Box"))
		input.Item = input.Row.Item
		local field = Draw.Field(input.Row.Control, "Frame")
		input.Box = Draw.Text({
			ClassName = "TextBox",
			Text = input.Value,
			ClearTextOnFocus = info.ClearTextOnFocus == true,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -20, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = field,
		}, "Body", Util.TextSize("Label"), "Text")
		Lang.Bind(input.Box, info.Placeholder or "", "PlaceholderText")
		Theme.Bind(input.Box, { PlaceholderColor3 = "Muted" })
		input:Bind(field)
		Widget.Register(input, idx, info)
		return input
	end

	function Input:Bind(field)
		local stroke = field:FindFirstChildOfClass("UIStroke")
		self.Box.Focused:Connect(function()
			Anim.Tween(stroke, { Color = Theme.Colors.Blue }, Config.Tween.Fast)
		end)
		self.Box:GetPropertyChangedSignal("Text"):Connect(function()
			local clean = self:Sanitize(self.Box.Text)
			if clean ~= self.Box.Text then
				self.Box.Text = clean
				return
			end
			if not self.Finished then
				self:Commit(clean)
			end
		end)
		self.Box.FocusLost:Connect(function()
			Anim.Tween(
				stroke,
				{ Color = Theme.Colors.Outline },
				Config.Tween.Fast
			)
			self:Commit(self.Box.Text)
		end)
	end

	function Input:Sanitize(text)
		if self.Numeric then
			text = text:gsub("[^%d%.%-]", "")
		end
		if self.MaxLength and #text > self.MaxLength then
			text = text:sub(1, self.MaxLength)
		end
		return text
	end

	function Input:Commit(text)
		if text == self.Value then
			return
		end
		self.Value = text
		self:Fire()
	end

	function Input:SetValue(text)
		text = self:Sanitize(tostring(text or ""))
		self.Box.Text = text
		self:Commit(text)
	end

	Button.Styles = {
		Default = { Face = "Element", Shade = "Track", Text = "Text" },
		Primary = { Face = "Blue", Shade = "BlueDark", Text = "White" },
		Success = { Face = "Good", Shade = "GoodDark", Text = "White" },
		Danger = { Face = "Danger", Shade = "DangerDark", Text = "White" },
		Warning = { Face = "Coin", Shade = "CoinDark", Text = "Ink" },
	}

	function Container:AddButton(info, callback)
		return Button.Create(self, info, callback)
	end

	function Button.Create(container, info, callback, after)
		if type(info) ~= "table" then
			info = { Text = info, Func = callback }
		end
		local style = Button.Styles[info.Style or "Default"]
			or Button.Styles.Default
		local button = setmetatable({
			Container = container,
			Info = info,
			Func = info.Func or info.Callback or callback,
			Style = style,
			Armed = false,
		}, Button)
		local holder, face, _, depth =
			Draw.Block(nil, style.Face, style.Shade, 10, 4)
		face.ClipsDescendants = true
		button.Holder, button.Face, button.Depth = holder, face, depth
		local content = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			Parent = face,
		})
		Draw.List(
			content,
			6,
			true,
			Enum.HorizontalAlignment.Center,
			Enum.VerticalAlignment.Center
		)
		Draw.Padding(content, 0, 8, 0, 8)
		local iconExtra = 0
		if info.Icon then
			local icon =
				Icons.Create(content, info.Icon, 16, style.Text, info.Text)
			icon.LayoutOrder = 1
			iconExtra = 22
		end
		button.Label = Draw.Text(
			{
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromScale(0, 1),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = content,
			},
			"Body",
			Util.TextSize("Button"),
			style.Text,
			info.Text or info.Title or ""
		)
		button.Hit = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 5,
			Parent = holder,
		})
		button:BindPress()
		button.Group = { button }
		button.Item = container:Add(holder, {
			Height = Util.Metric("Box") + depth,
			After = after,
			Search = Lang.SearchText(info.Text or info.Title),
			AutoWidth = function()
				return Layout.Measure(
					button.Label.Text,
					button.Label.TextSize,
					"Body",
					1000
				).X + iconExtra + 36
			end,
		})
		if info.Tooltip then
			Tooltip.Attach(holder, info.Tooltip)
		end
		return button
	end

	function Button:BindPress()
		local face, hit = self.Face, self.Hit
		local faceColor = function()
			return Theme.Colors[self.Style.Face]
		end
		hit.MouseEnter:Connect(function()
			if not State.Touch then
				Anim.Tween(
					face,
					{ BackgroundColor3 = Util.Lighten(faceColor(), 0.14) },
					Config.Tween.Fast
				)
			end
		end)
		hit.MouseLeave:Connect(function()
			Anim.Tween(
				face,
				{ BackgroundColor3 = faceColor() },
				Config.Tween.Fast
			)
			Motion.Spring(face, "Position", UDim2.new(), "Fast")
		end)
		hit.MouseButton1Down:Connect(function()
			Motion.Spring(
				face,
				"Position",
				UDim2.fromOffset(0, self.Depth - 1),
				"Fast"
			)
		end)
		hit.MouseButton1Up:Connect(function()
			Motion.Spring(
				face,
				"Position",
				UDim2.new(),
				"Fast",
				{ Damping = 0.56 }
			)
		end)
		hit.Activated:Connect(function()
			Fx.Ripple(face, nil, "White")
			self:Click()
		end)
	end

	function Button:Click()
		if self.Info.DoubleClick and not self.Armed then
			self.Armed = true
			local token = {}
			self.ArmToken = token
			Lang.Bind(self.Label, Lang.Strings.Confirm)
			Anim.Shake(self.Face)
			task.delay(Config.ConfirmWindow, function()
				if self.ArmToken == token then
					self:Disarm()
				end
			end)
			return
		end
		self:Disarm()
		Util.Try(self.Func)
	end

	function Button:Disarm()
		if not self.Armed then
			return
		end
		self.Armed = false
		Lang.Bind(self.Label, self.Info.Text or "")
	end

	function Button:AddButton(info, callback)
		local last = self.Group[#self.Group]
		self.Container:SameLine()
		local sibling = Button.Create(self.Container, info, callback, last.Item)
		sibling.Group = self.Group
		table.insert(self.Group, sibling)
		local count = #self.Group
		for index, member in ipairs(self.Group) do
			member.Item.Width = index < count and 1 / count or nil
			member.Item.Fill = true
		end
		self.Container:MarkDirty()
		return sibling
	end

	function Button:SetText(text)
		self.Info.Text = text
		Lang.Bind(self.Label, text)
	end

	function Button:SetVisible(visible)
		self.Item.Hidden = not visible
		self.Container:MarkDirty()
	end

	function Container:AddLabel(text, wrap)
		local info = type(text) == "table" and text.Text and text
			or { Text = text }
		local label = setmetatable(
			{ Type = "Label", Container = self, Wrap = wrap },
			Label
		)
		label.Row = Row.New(self, info, {
			TitleFont = "Desc",
			TitleSize = Util.TextSize("Label") - 1,
			TitleToken = "SubText",
		})
		label.Row.MinHeight = Row.LineHeight()
		label.Item = label.Row.Item
		return label
	end

	function Label:SetText(text)
		self.Row:SetTitle(text)
	end

	Label.SetVisible = Widget.SetVisible
	Label.AddColorPicker = Widget.AddColorPicker
	Label.AddKeyPicker = Widget.AddKeyPicker

	function Container:AddParagraph(info)
		local paragraph =
			setmetatable({ Type = "Label", Container = self }, Label)
		paragraph.Row = Row.New(self, {
			Text = info.Title,
			Description = info.Content or info.Description or " ",
		})
		paragraph.Item = paragraph.Row.Item
		function paragraph.SetContent(_, text)
			Lang.Bind(paragraph.Row.Desc, text)
			self:MarkDirty()
		end
		function paragraph.SetTitle(_, text)
			paragraph.Row:SetTitle(text)
		end
		return paragraph
	end

	function Container:AddDivider()
		local holder =
			Draw.New("Frame", { Name = "Divider", BackgroundTransparency = 1 })
		local line = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 0, 2),
		}, "Track", nil, 1)
		line.Parent = holder
		self:Add(holder, { Height = 10 })
		return self
	end

	Container.Separator = Container.AddDivider

	function Container:AddSeparatorText(text)
		local holder = Draw.New(
			"Frame",
			{ Name = "SeparatorText", BackgroundTransparency = 1 }
		)
		local caption = Draw.Text(
			{ TextXAlignment = Enum.TextXAlignment.Center, Parent = holder },
			"Body",
			Util.TextSize("Desc"),
			"Muted",
			text
		)
		local left = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Parent = holder,
		}, "Track", nil, 1)
		local right = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Parent = holder,
		}, "Track", nil, 1)
		self:Add(holder, {
			Height = Row.LineHeight("Desc"),
			OnLayout = function(width, height)
				local textWidth = Layout.Measure(
					caption.Text,
					caption.TextSize,
					"Body",
					width
				).X + 12
				left.Size = UDim2.fromOffset(12, 2)
				caption.Position = UDim2.fromOffset(14, 0)
				caption.Size = UDim2.fromOffset(textWidth, height)
				right.Size =
					UDim2.fromOffset(math.max(0, width - textWidth - 16), 2)
			end,
		})
		return self
	end

	--@return parts Selectable row primitive shared across lists, sidebar, and popups
	--@param image string? Optional icon asset id
	--@param tint Color3? Optional border tint (defaults to theme outline)
	function Draw.Thumb(parent, image, tint, size, position)
		local tile = Draw.Box("ImageLabel", {
			Name = "Thumb",
			Image = image or "",
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = position or UDim2.new(0, 4, 0.5, 0),
			Size = UDim2.fromOffset(size, size),
			Parent = parent,
		}, "Element", nil, 6)
		Draw.Padding(tile, 2)
		local stroke
		if tint then
			stroke = Draw.New("UIStroke", {
				Thickness = 2,
				Color = tint,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Round,
				Parent = tile,
			})
		else
			stroke = Draw.Stroke(tile, "Outline", 2, true)
		end
		return tile, stroke
	end

	function Selectable.Build(text, options)
		options = options or {}
		local textSpec = text
		local iconSpec = options.Icon
		if type(text) == "table" and not text.EN and not text.TH then
			textSpec = text.Text or text.Label or text.Value or ""
			iconSpec = iconSpec or text.Icon
		end
		local button = Draw.Box("TextButton", {
			Name = "Selectable",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, "Hover", nil, 8)
		local bar = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(3, 0),
			Parent = button,
		}, "Coin", nil, 2)
		local inset = 12
		if options.Image then
			local size = Util.Metric("Item") - 6
			Draw.Thumb(
				button,
				options.Image,
				options.Tint,
				size,
				UDim2.new(0, 8, 0.5, 0)
			)
			inset = size + 16
		elseif iconSpec then
			local icon = Icons.Create(button, iconSpec, 16, nil, textSpec)
			icon.AnchorPoint = Vector2.new(0, 0.5)
			icon.Position = UDim2.new(0, 10, 0.5, 0)
			inset = 32
		elseif options.Tint then
			Draw.Box("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				Size = UDim2.new(0, 4, 1, -10),
				BackgroundColor3 = options.Tint,
				Parent = button,
			}, nil, nil, 2)
			inset = 18
		end
		local label = Draw.Text({
			Position = UDim2.fromOffset(inset, 0),
			Size = UDim2.new(1, -(inset + 26), 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = button,
		}, "Body", Util.TextSize("Label"), "Text", textSpec)
		local mark = Icons.Vector(button, "check", 15, "OnAccent")
		mark.AnchorPoint = Vector2.new(1, 0.5)
		mark.Position = UDim2.new(1, -8, 0.5, 0)
		local markScale = Draw.New("UIScale", { Scale = 0, Parent = mark })
		local parts = {
			Button = button,
			Label = label,
			Mark = mark,
			MarkScale = markScale,
			Bar = bar,
			Selected = false,
			Hovered = false,
		}
		function parts.Render(instant)
			local duration = instant and 0 or Config.Tween.Fast
			local fill = parts.Selected and Theme.Colors.Accent
				or Theme.Colors.Hover
			local alpha = parts.Selected and 0 or (parts.Hovered and 0.45 or 1)
			Anim.Tween(
				button,
				{ BackgroundColor3 = fill, BackgroundTransparency = alpha },
				duration
			)
			Anim.Tween(label, {
				TextColor3 = Theme.Colors[parts.Selected and "OnAccent" or "Text"],
			}, duration)
			if instant then
				Motion.Set(markScale, "Scale", parts.Selected and 1 or 0)
			else
				Motion.Spring(
					markScale,
					"Scale",
					parts.Selected and 1 or 0,
					"Fast",
					{ Damping = 0.6 }
				)
			end
			local barHeight = parts.Selected and (Util.Metric("Item") - 10) or 0
			if instant then
				Motion.Set(bar, "Size", UDim2.fromOffset(3, barHeight))
			else
				Motion.Spring(
					bar,
					"Size",
					UDim2.fromOffset(3, barHeight),
					"Fast"
				)
			end
		end
		function parts.SetSelected(selected, instant)
			parts.Selected = selected
			parts.Render(instant)
		end
		if not State.Touch then
			button.MouseEnter:Connect(function()
				parts.Hovered = true
				parts.Render()
			end)
			button.MouseLeave:Connect(function()
				parts.Hovered = false
				parts.Render()
			end)
		end
		Theme.OnRender(button, function()
			parts.Render(true)
		end)
		return parts
	end

	function Container:AddSelectable(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local selectable = setmetatable({
			Type = "Selectable",
			Value = info.Default == true or info.Selected == true,
			Container = self,
		}, Selectable)
		selectable.Parts = Selectable.Build(info.Text or "", info)
		selectable.Item = self:Add(
			selectable.Parts.Button,
			{ Height = Util.Metric("Item"), Search = Row.SearchText(info) }
		)
		selectable.Parts.SetSelected(selectable.Value, true)
		selectable.Parts.Button.Activated:Connect(function()
			selectable:SetValue(not selectable.Value)
		end)
		Widget.Register(selectable, idx, info)
		return selectable
	end

	function Selectable:SetValue(value)
		value = value == true
		if value == self.Value then
			return
		end
		self.Value = value
		self.Parts.SetSelected(value)
		self:Fire()
	end

	function Container:AddListBox(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local rows = info.Height or 5
		local itemHeight = Util.Metric("Item")
		local listbox = setmetatable({
			Type = "Dropdown",
			Multi = info.Multi == true,
			AllowNull = info.AllowNull ~= false,
			Values = info.Values or {},
			Container = self,
			Entries = {},
		}, ListBox)
		listbox.Value = listbox.Multi and Util.ToSet(info.Default)
			or info.Default
		listbox.Row = Row.Stack(self, info, rows * (itemHeight + 2) + 10)
		listbox.Item = listbox.Row.Item
		local frame = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), Parent = listbox.Row.Control },
			"Element",
			"Outline",
			10,
			2
		)
		local scroll =
			Layout.ScrollFrame({ Size = UDim2.fromScale(1, 1), Parent = frame })
		listbox.List = Container.New(scroll, { PadX = 4, PadY = 4, GapY = 2 })
		listbox.List:SetParent(self)
		listbox.Row.OnArranged = function(width)
			listbox.List:SetWidth(width - Config.Page.ScrollBar - 4)
		end
		Widget.Register(listbox, idx, info)
		listbox:Rebuild()
		return listbox
	end

	function ListBox:Rebuild()
		self.List:Clear()
		table.clear(self.Entries)
		for _, value in ipairs(self.Values) do
			local parts = Selectable.Build(value, { Multi = self.Multi })
			parts.SetSelected(Dropdown.IsSelected(self, value), true)
			parts.Button.Activated:Connect(function()
				Dropdown.Pick(self, value)
			end)
			self.Entries[value] = parts
			self.List:Add(parts.Button, { Height = Util.Metric("Item") })
		end
		if #self.Values == 0 then
			self.List:AddLabel(Lang.Strings.Empty)
		end
	end

	function ListBox:Render()
		for value, parts in pairs(self.Entries) do
			parts.SetSelected(Dropdown.IsSelected(self, value))
		end
	end

	ListBox.IsSelected = Dropdown.IsSelected
	ListBox.GetActiveValues = Dropdown.GetActiveValues
	ListBox.Serialize = Dropdown.Serialize

	function ListBox:SetValue(value)
		self.Value = self.Multi and Util.ToSet(value) or value
		self:Render()
		self:Fire()
	end

	function ListBox:SetValues(values)
		self.Values = values or {}
		if
			not self.Multi
			and self.Value ~= nil
			and not table.find(self.Values, self.Value)
		then
			self.Value = nil
		end
		self:Rebuild()
	end

	function Container:AddProgressBar(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local progress = setmetatable({
			Type = "Progress",
			Value = 0,
			Max = info.Max or 1,
			Suffix = info.Suffix,
			Container = self,
		}, Progress)
		progress.Row = Row.Stack(self, info, 16)
		progress.Item = progress.Row.Item
		local bar = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), Parent = progress.Row.Control },
			"Track",
			"Outline",
			UDim.new(1, 0),
			2
		)
		progress.Fill = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(0, 1), Parent = bar },
			"Good",
			nil,
			UDim.new(1, 0)
		)
		local shine = Draw.Box("Frame", {
			Position = UDim2.new(0, 4, 0, 2),
			Size = UDim2.new(1, -8, 0, 3),
			BackgroundTransparency = 0.55,
			Parent = progress.Fill,
		}, "White", nil, UDim.new(1, 0))
		shine.ZIndex = 2
		progress:SetValue(info.Default or info.Value or 0)
		if idx ~= nil then
			Library.Options[idx] = progress
			progress.NoSave = true
		end
		return progress
	end

	function Progress:SetValue(value)
		self.Value = math.clamp(tonumber(value) or 0, 0, self.Max)
		local fraction = self.Max > 0 and self.Value / self.Max or 0
		Anim.Tween(
			self.Fill,
			{ Size = UDim2.fromScale(fraction, 1) },
			Config.Tween.Slide
		)
		local text = self.Suffix
				and (tostring(Util.Round(self.Value, 2)) .. self.Suffix)
			or (math.floor(fraction * 100 + 0.5) .. "%")
		local resized = #text ~= #self.Row.Aside.Text
		self.Row.Aside.Text = text
		if resized then
			self.Container:MarkDirty()
		end
	end

	function Progress:SetText(text)
		self.Row:SetTitle(text)
	end

	Progress.SetVisible = Widget.SetVisible

	--@param info { Height = px (nil = auto-fit content), Border = true }
	function Container:AddChild(id, info)
		if Gui and Gui.BeginChild then
			return Gui.BeginChild(self, id, info)
		end
		if type(id) == "table" and info == nil then
			info, id = id, nil
		end
		info = info or {}
		local holder = Draw.New(
			"Frame",
			{ Name = tostring(id or "Child"), BackgroundTransparency = 1 }
		)
		local frame = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), Parent = holder },
			info.Border ~= false and "Element" or nil,
			info.Border ~= false and "Track" or nil,
			10,
			2
		)
		if info.Border ~= false then
			frame.BackgroundTransparency = 0.4
		end
		local host = info.Height
				and Layout.ScrollFrame({
					Size = UDim2.fromScale(1, 1),
					Parent = frame,
				})
			or Draw.New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = frame,
			})
		local child = Container.New(host, { PadX = 8, PadY = 8 })
		local inset = info.Height and Config.Page.ScrollBar or 0
		self:Add(holder, {
			Height = function()
				return info.Height or child.ContentHeight
			end,
			Child = child,
			ChildInset = inset,
		})
		return child
	end

	Container.BeginChild = Container.AddChild

	function Container:AddKeybind(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local row = Row.New(self, info)
		local picker = KeyPicker.New(row, idx, info, nil)
		picker.Row, picker.Item, picker.Container = row, row.Item, self
		return picker
	end

	function Container:AddColorPicker(idx, info)
		idx, info = Widget.Normalize(idx, info)
		local row = Row.New(self, info)
		local picker = ColorPicker.New(row, idx, info)
		picker.Row, picker.Item, picker.Container = row, row.Item, self
		return picker
	end

	-- Extended Framework Widgets (WindUI + SpellUI + ReactBits)
	function Container:AddStepper(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local stepVal = spec.Step or 1
		local stepper = setmetatable({
			Type = "Stepper",
			Min = spec.Min or -1e9,
			Max = spec.Max or 1e9,
			Step = stepVal,
			Rounding = spec.Rounding
				or (math.floor(stepVal) ~= stepVal and 2 or 0),
			Container = self,
		}, Stepper)
		stepper.Value = Util.Round(
			math.clamp(
				tonumber(spec.Default) or math.max(0, stepper.Min),
				stepper.Min,
				stepper.Max
			),
			stepper.Rounding
		)
		stepper.Row = Row.New(self, spec)
		stepper.Item = stepper.Row.Item
		stepper:Build()
		Widget.Register(stepper, idx, spec)
		stepper:Render(true)
		return stepper
	end

	function Stepper:Build()
		local height = Util.Metric("Box") - 4
		local box = Draw.Box(
			"Frame",
			{ Size = UDim2.fromOffset(108, height) },
			"Element",
			"Outline",
			8,
			2
		)
		local minusBtn = Draw.Box("TextButton", {
			Position = UDim2.fromOffset(2, 2),
			Size = UDim2.fromOffset(height - 4, height - 4),
			Parent = box,
		}, "Hover", nil, 6)
		Icons.Vector(minusBtn, "minus", 14, "Text").Position =
			UDim2.fromScale(0.18, 0.18)
		local plusBtn = Draw.Box("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -2, 0, 2),
			Size = UDim2.fromOffset(height - 4, height - 4),
			Parent = box,
		}, "Accent", nil, 6)
		Icons.Vector(plusBtn, "plus", 14, "OnAccent").Position =
			UDim2.fromScale(0.18, 0.18)
		self.Readout = Draw.Text({
			Position = UDim2.fromOffset(height, 0),
			Size = UDim2.new(1, -height * 2, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = box,
		}, "Strong", Util.TextSize("Label"), "Text", tostring(self.Value))
		minusBtn.Activated:Connect(function()
			Fx.Squash(minusBtn, 1.8)
			self:SetValue(self.Value - self.Step)
		end)
		plusBtn.Activated:Connect(function()
			Fx.Squash(plusBtn, 1.8)
			self:SetValue(self.Value + self.Step)
		end)
		self.Row:AddRight(box, 108)
	end

	function Stepper:Render(instant)
		local formatted = self.Rounding > 0
				and string.format("%." .. self.Rounding .. "f", self.Value)
			or tostring(math.floor(self.Value + 0.5))
		if instant or not self.PrevValue then
			self.Readout.Text = formatted
		else
			Fx.CountUp(self, self.PrevValue, self.Value, 0.18, function(cur)
				local num = Util.Round(cur, self.Rounding)
				self.Readout.Text = self.Rounding > 0
						and string.format("%." .. self.Rounding .. "f", num)
					or tostring(math.floor(num + 0.5))
			end)
		end
		self.PrevValue = self.Value
	end

	function Stepper:SetValue(nextVal)
		local num = tonumber(nextVal)
		if not num then
			return
		end
		num = Util.Round(math.clamp(num, self.Min, self.Max), self.Rounding)
		if num == self.Value then
			return
		end
		self.Value = num
		self:Render(false)
		self:Fire()
	end

	function Container:AddRangeSlider(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local knobSize = Util.Metric("Knob")
		local minBound, maxBound = spec.Min or 0, spec.Max or 100
		local defTable = type(spec.Default) == "table" and spec.Default
			or { minBound, maxBound }
		local range = setmetatable({
			Type = "RangeSlider",
			Min = minBound,
			Max = maxBound,
			Rounding = spec.Rounding or 0,
			Suffix = spec.Suffix or "",
			Container = self,
		}, RangeSlider)
		local low = Util.Round(
			math.clamp(tonumber(defTable[1]) or minBound, minBound, maxBound),
			range.Rounding
		)
		local high = Util.Round(
			math.clamp(tonumber(defTable[2]) or maxBound, low, maxBound),
			range.Rounding
		)
		range.Value = { low, high }
		range.Row = Row.Stack(self, spec, knobSize + 4)
		range.Item = range.Row.Item
		range:Build(knobSize)
		Widget.Register(range, idx, spec)
		range:Render(false)
		return range
	end

	function RangeSlider:Build(knobSize)
		local control = self.Row.Control
		local trackHeight = Util.Metric("Track")
		self.Track = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, knobSize / 2, 0.5, 0),
			Size = UDim2.new(1, -knobSize, 0, trackHeight),
			Parent = control,
		}, "Track", "Outline", UDim.new(1, 0), 2)
		self.Fill = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), Parent = self.Track },
			"Accent",
			nil,
			UDim.new(1, 0)
		)
		self.KnobLow = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(knobSize, knobSize),
			Position = UDim2.fromScale(0, 0.5),
			ZIndex = 3,
			Parent = self.Track,
		}, "Coin", "Outline", UDim.new(1, 0), 2)
		self.KnobHigh = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(knobSize, knobSize),
			Position = UDim2.fromScale(1, 0.5),
			ZIndex = 4,
			Parent = self.Track,
		}, "Coin", "Outline", UDim.new(1, 0), 2)
		local hit = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 6),
			Position = UDim2.fromOffset(0, -3),
			ZIndex = 5,
			Parent = control,
		})
		hit.InputBegan:Connect(function(input)
			if Util.IsPointer(input) then
				self:BeginDrag(input)
			end
		end)
	end

	function RangeSlider:BeginDrag(input)
		local left, width =
			self.Track.AbsolutePosition.X,
			math.max(1, self.Track.AbsoluteSize.X)
		local frac = math.clamp((input.Position.X - left) / width, 0, 1)
		local pickedVal = self.Min + (self.Max - self.Min) * frac
		local pickHigh = math.abs(pickedVal - self.Value[2])
			< math.abs(pickedVal - self.Value[1])
		local activeKnob = pickHigh and self.KnobHigh or self.KnobLow
		Fx.Squash(activeKnob, 1.9)
		local function UpdateFromX(screenX)
			local ratio = math.clamp(
				(screenX - self.Track.AbsolutePosition.X)
					/ math.max(1, self.Track.AbsoluteSize.X),
				0,
				1
			)
			local raw = self.Min + (self.Max - self.Min) * ratio
			if pickHigh then
				self:SetValue({ self.Value[1], math.max(self.Value[1], raw) })
			else
				self:SetValue({ math.min(self.Value[2], raw), self.Value[2] })
			end
		end
		UpdateFromX(input.Position.X)
		State.Drag = {
			Move = function(move)
				UpdateFromX(move.Position.X)
			end,
			Stop = function()
				Fx.Squash(activeKnob, 1.4)
			end,
		}
	end

	function RangeSlider:Render(animated)
		local span = math.max(1e-6, self.Max - self.Min)
		local lowFrac = math.clamp((self.Value[1] - self.Min) / span, 0, 1)
		local highFrac =
			math.clamp((self.Value[2] - self.Min) / span, lowFrac, 1)
		if animated then
			Motion.Spring(
				self.Fill,
				"Position",
				UDim2.fromScale(lowFrac, 0),
				"Fast"
			)
			Motion.Spring(
				self.Fill,
				"Size",
				UDim2.fromScale(highFrac - lowFrac, 1),
				"Fast"
			)
			Motion.Spring(
				self.KnobLow,
				"Position",
				UDim2.fromScale(lowFrac, 0.5),
				"Fast"
			)
			Motion.Spring(
				self.KnobHigh,
				"Position",
				UDim2.fromScale(highFrac, 0.5),
				"Fast"
			)
		else
			Motion.Set(self.Fill, "Position", UDim2.fromScale(lowFrac, 0))
			Motion.Set(
				self.Fill,
				"Size",
				UDim2.fromScale(highFrac - lowFrac, 1)
			)
			Motion.Set(self.KnobLow, "Position", UDim2.fromScale(lowFrac, 0.5))
			Motion.Set(
				self.KnobHigh,
				"Position",
				UDim2.fromScale(highFrac, 0.5)
			)
		end
		local suf = Lang.Resolve(self.Suffix or "")
		self.Row.Aside.Text = tostring(self.Value[1])
			.. suf
			.. " – "
			.. tostring(self.Value[2])
			.. suf
	end

	function RangeSlider:SetValue(pair)
		if type(pair) ~= "table" then
			return
		end
		local low = Util.Round(
			math.clamp(tonumber(pair[1]) or self.Min, self.Min, self.Max),
			self.Rounding
		)
		local high = Util.Round(
			math.clamp(tonumber(pair[2]) or self.Max, low, self.Max),
			self.Rounding
		)
		if low == self.Value[1] and high == self.Value[2] then
			return
		end
		self.Value = { low, high }
		self:Render(true)
		self:Fire()
	end

	function Container:AddSegmented(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local optionsList = spec.Values or spec.Options or {}
		local seg = setmetatable({
			Type = "Segmented",
			Values = optionsList,
			Value = spec.Default or optionsList[1],
			Buttons = {},
			Container = self,
		}, Segmented)
		seg.Row = (spec.Text or spec.Title)
				and Row.Stack(self, spec, Util.Metric("Box"))
			or nil
		local host = seg.Row and seg.Row.Control
			or Draw.New("Frame", { BackgroundTransparency = 1 })
		if not seg.Row then
			seg.Item = self:Add(host, {
				Height = Util.Metric("Box"),
				Search = Lang.SearchText(spec.Text),
			})
		else
			seg.Item = seg.Row.Item
		end
		seg:Build(host)
		Widget.Register(seg, idx, spec)
		seg:Render(true)
		return seg
	end

	function Segmented:Build(host)
		local bar = Draw.Box(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), Parent = host },
			"Element",
			"Outline",
			8,
			2
		)
		Draw.Padding(bar, 3, 3, 3, 3)
		local count = math.max(1, #self.Values)
		self.Thumb = Draw.Box("Frame", {
			Size = UDim2.fromScale(1 / count, 1),
			ZIndex = 2,
			Parent = bar,
		}, "Accent", nil, 6)
		for index, optionVal in ipairs(self.Values) do
			local btn = Draw.Text(
				{
					ClassName = "TextButton",
					Position = UDim2.fromScale((index - 1) / count, 0),
					Size = UDim2.fromScale(1 / count, 1),
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 3,
					Parent = bar,
				},
				"Strong",
				Util.TextSize("Label") - 1,
				"Text",
				Dropdown.FormatValue(optionVal)
			)
			btn.AutoButtonColor = false
			btn.Activated:Connect(function()
				self:SetValue(optionVal)
			end)
			self.Buttons[index] = { Button = btn, Value = optionVal }
		end
	end

	function Segmented:Render(instant)
		local count = math.max(1, #self.Values)
		local activeIdx = 1
		for index, entry in ipairs(self.Buttons) do
			local isSel = entry.Value == self.Value
			if isSel then
				activeIdx = index
			end
			Theme.Bind(
				entry.Button,
				{ TextColor3 = isSel and "OnAccent" or "SubText" }
			)
		end
		local targetPos = UDim2.fromScale((activeIdx - 1) / count, 0)
		local targetSize = UDim2.fromScale(1 / count, 1)
		if instant then
			Motion.Set(self.Thumb, "Position", targetPos)
			Motion.Set(self.Thumb, "Size", targetSize)
		else
			Motion.Spring(
				self.Thumb,
				"Position",
				targetPos,
				"Fast",
				{ Damping = 0.68 }
			)
			Motion.Spring(self.Thumb, "Size", targetSize, "Fast")
		end
	end

	function Segmented:SetValue(nextVal)
		if nextVal == self.Value then
			return
		end
		self.Value = nextVal
		self:Render(false)
		self:Fire()
	end

	function Container:AddStat(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local card = Draw.Box(
			"Frame",
			{ Name = "StatCard" },
			"Element",
			"Outline",
			10,
			2
		)
		Fx.Spotlight(card)
		local badge = Icons.Badge(
			card,
			spec.Icon,
			30,
			spec.Color or "Accent",
			spec.Title or spec.Text
		)
		badge.AnchorPoint = Vector2.new(0, 0.5)
		badge.Position = UDim2.new(0, 10, 0.5, 0)
		local titleLabel = Draw.Text(
			{
				Position = UDim2.fromOffset(48, 6),
				Size = UDim2.new(1, -56, 0, 16),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = card,
			},
			"Desc",
			Util.TextSize("Desc"),
			"SubText",
			spec.Title or spec.Text or "Stat"
		)
		local valLabel = Draw.Text(
			{
				Position = UDim2.fromOffset(48, 22),
				Size = UDim2.new(1, -56, 0, 22),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = card,
			},
			"Display",
			Util.TextSize("Group") + 2,
			spec.Color or "Text",
			tostring(spec.Value or spec.Default or "0")
		)
		local stat = setmetatable({
			Type = "Stat",
			Frame = card,
			TitleLabel = titleLabel,
			ValueLabel = valLabel,
			Prefix = spec.Prefix or "",
			Suffix = spec.Suffix or "",
			Value = spec.Value or spec.Default or 0,
			Container = self,
		}, StatWidget)
		stat.Item = self:Add(
			card,
			{ Width = spec.Width, Height = 50, Search = Row.SearchText(spec) }
		)
		Widget.Register(stat, idx, spec)
		return stat
	end

	function StatWidget:SetValue(nextVal)
		local prevNum = tonumber(self.Value)
		local nextNum = tonumber(nextVal)
		self.Value = nextVal
		local pre = Lang.Resolve(self.Prefix or "")
		local suf = Lang.Resolve(self.Suffix or "")
		if prevNum and nextNum then
			Fx.CountUp(self, prevNum, nextNum, 0.25, function(cur)
				self.ValueLabel.Text = pre
					.. tostring(math.floor(cur + 0.5))
					.. suf
			end)
		else
			self.ValueLabel.Text = pre .. tostring(nextVal) .. suf
		end
	end

	function Container:AddStatus(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local row = Row.New(self, spec)
		local pill, label = Gui.Badge(
			row.Right,
			spec.Status or spec.Default or "Ready",
			spec.Color or "Good",
			true
		)
		row:AddRight(pill.Frame, pill.Width)
		local status = setmetatable({
			Type = "Status",
			Row = row,
			Item = row.Item,
			Badge = pill,
			Label = label,
			Value = spec.Status or spec.Default or "Ready",
			Container = self,
		}, StatusWidget)
		Widget.Register(status, idx, spec)
		return status
	end

	function StatusWidget:SetValue(nextText, colorToken)
		self.Value = nextText
		self.Badge:SetText(nextText)
		if colorToken then
			self.Badge:SetColor(colorToken)
		end
	end

	function Container:AddTable(idx, spec)
		idx, spec = Widget.Normalize(idx, spec)
		local headers = spec.Headers or spec.Columns or {}
		local rows = spec.Rows or {}
		local holder =
			Draw.Box("Frame", { Name = "Table" }, "Element", "Outline", 10, 2)
		local inner = Container.New(holder, { PadX = 8, PadY = 6, GapY = 4 })
		inner:SetParent(self)
		local tbl = setmetatable({
			Type = "Table",
			Headers = headers,
			Rows = rows,
			Inner = inner,
			Container = self,
		}, TableWidget)
		tbl.Item = self:Add(holder, {
			Height = function()
				return math.max(36, inner.ContentHeight)
			end,
			Child = inner,
			Search = Row.SearchText(spec),
		})
		tbl:Rebuild()
		return tbl
	end

	function TableWidget:Rebuild()
		self.Inner:Clear()
		local colCount = math.max(1, #self.Headers)
		if #self.Headers > 0 then
			local headRow = Draw.Box(
				"Frame",
				{ BackgroundTransparency = 0.35 },
				"PanelHeader",
				nil,
				6
			)
			for colIdx, hText in ipairs(self.Headers) do
				Draw.Text({
					Position = UDim2.new((colIdx - 1) / colCount, 6, 0, 0),
					Size = UDim2.new(1 / colCount, -8, 1, 0),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = headRow,
				}, "Strong", Util.TextSize("Desc"), "Accent", hText)
			end
			self.Inner:Add(headRow, { Height = 24 })
		end
		for _, cells in ipairs(self.Rows) do
			local line = Draw.New("Frame", { BackgroundTransparency = 1 })
			for colIdx = 1, colCount do
				Draw.Text(
					{
						Position = UDim2.new((colIdx - 1) / colCount, 6, 0, 0),
						Size = UDim2.new(1 / colCount, -8, 1, 0),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Parent = line,
					},
					"Body",
					Util.TextSize("Desc"),
					colIdx == 1 and "Text" or "SubText",
					tostring(cells[colIdx] or "")
				)
			end
			self.Inner:Add(line, { Height = 22 })
		end
		self.Container:MarkDirty()
	end

	function TableWidget:SetRows(nextRows)
		self.Rows = nextRows or {}
		self:Rebuild()
	end

	-- WindUI-style shorthand aliases on Container
	Container.Toggle = Container.AddToggle
	Container.Checkbox = Container.AddCheckbox
	Container.Slider = Container.AddSlider
	Container.Dropdown = Container.AddDropdown
	Container.Input = Container.AddInput
	Container.Button = Container.AddButton
	Container.Keybind = Container.AddKeybind
	Container.Colorpicker = Container.AddColorPicker
	Container.Label = Container.AddLabel
	Container.Paragraph = Container.AddParagraph
	Container.Divider = Container.AddDivider
	Container.Section = Container.AddSeparatorText
	Container.Stepper = Container.AddStepper
	Container.RangeSlider = Container.AddRangeSlider
	Container.Segmented = Container.AddSegmented
	Container.Stat = Container.AddStat
	Container.Status = Container.AddStatus
	Container.Table = Container.AddTable

	--@return card, face, scale Floating block card with drop shadow
	function Popup.Card(width, height)
		local shadow = Config.Group.Shadow
		local card = Draw.New("Frame", {
			Name = "Popup",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(width + shadow, height + shadow),
			ZIndex = 2,
		})
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(shadow, shadow),
			Size = UDim2.new(1, -shadow, 1, -shadow),
			Parent = card,
		}, "Shadow", nil, 12)
		local face = Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, -shadow, 1, -shadow), Parent = card },
			"Panel",
			"Outline",
			12,
			3
		)
		local scale = Draw.New("UIScale", { Parent = card })
		return card, face, scale
	end

	function Popup.Open(card, scale, anchor, onClose)
		Popup.Close()
		card.Parent = State.Overlay
		State.Overlay.Visible = true
		Popup.Place(card, anchor)
		scale.Scale = State.UserScale * 0.88
		Motion.Spring(
			scale,
			"Scale",
			State.UserScale,
			"Fast",
			{ Damping = 0.62 }
		)
		local lastPos = anchor and anchor.AbsolutePosition or Vector2.zero
		local tracker
		if anchor then
			tracker = Util.Connect(RunService.RenderStepped, function()
				if not State.Popup or State.Popup.Card ~= card then
					return
				end
				if
					not anchor.Parent
					or (
						State.Window
						and (not State.Window.Visible or State.Window.Minimized)
					)
				then
					Popup.Close()
					return
				end
				local curPos = anchor.AbsolutePosition
				if (curPos - lastPos).Magnitude > 0.5 then
					lastPos = curPos
					Popup.Place(card, anchor)
				end
			end)
		end
		State.Popup = {
			Card = card,
			Scale = scale,
			Anchor = anchor,
			Tracker = tracker,
			OnClose = onClose,
		}
	end

	function Popup.Place(card, anchor)
		if not anchor or not State.Gui then
			return
		end
		local viewport = State.Gui.AbsoluteSize
		local scaleFactor = math.max(0.5, State.UserScale or 1)
		local width = card.Size.X.Offset * scaleFactor
		local height = card.Size.Y.Offset * scaleFactor
		local origin = anchor.AbsolutePosition - State.Gui.AbsolutePosition
		local size = anchor.AbsoluteSize
		local x = math.clamp(origin.X, 8, math.max(8, viewport.X - width - 8))
		local y = origin.Y + size.Y + 6
		if y + height > viewport.Y - 8 then
			y = math.max(8, origin.Y - height - 6)
		end
		card.Position =
			UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
	end

	function Popup.Close()
		local popup = State.Popup
		if not popup then
			return
		end
		State.Popup = nil
		if popup.Tracker then
			popup.Tracker:Disconnect()
			popup.Tracker = nil
		end
		Util.Try(popup.OnClose)
		local shrink = Anim.Tween(
			popup.Scale,
			{ Scale = State.UserScale * 0.9 },
			0.1,
			"In"
		)
		shrink.Completed:Once(function()
			Theme.UnbindTree(popup.Card)
			popup.Card:Destroy()
			if not State.Popup then
				State.Overlay.Visible = false
			end
		end)
	end

	function Popup.SearchBox(parent, width)
		local field = Draw.Box("Frame", {
			Position = UDim2.fromOffset(6, 6),
			Size = UDim2.fromOffset(width, Util.Metric("Box")),
			Parent = parent,
		}, "Element", "Outline", 8, 2)
		local icon = Icons.Vector(field, "search", 14, "SubText")
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 8, 0.5, 0)
		local box = Draw.Text({
			ClassName = "TextBox",
			Text = "",
			ClearTextOnFocus = false,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -32, 1, 0),
			Parent = field,
		}, "Body", Util.TextSize("Label"), "Text")
		Lang.Bind(box, Lang.Strings.Search, "PlaceholderText")
		Theme.Bind(box, { PlaceholderColor3 = "Muted" })
		return box
	end

	--@param options { Anchor, Values, Multi, Search, IsSelected(value), OnPick(value) -> shouldClose, OnClose }
	function Popup.List(options)
		local itemHeight = Util.Metric("Item")
		local searchHeight = options.Search and (Util.Metric("Box") + 6) or 0
		local minWidth = options.Images
				and Config.Dropdown.MinWidth + itemHeight + 60
			or Config.Dropdown.MinWidth
		local viewportW = State.Gui and State.Gui.AbsoluteSize.X or 800
		local maxAllowedW = math.max(
			160,
			math.floor((viewportW - 24) / math.max(0.5, State.UserScale or 1))
		)
		local rawAnchorW = options.Anchor.AbsoluteSize.X
			/ math.max(0.5, State.UserScale or 1)
		local width = math.clamp(
			math.floor(math.max(minWidth, rawAnchorW)),
			140,
			maxAllowedW
		)
		local listHeight = math.max(
			1,
			math.min(#options.Values, Config.Dropdown.MaxVisible)
		) * (itemHeight + 2) + 6
		local card, face, scale =
			Popup.Card(width, listHeight + searchHeight + 12)
		local scroll = Layout.ScrollFrame({
			Position = UDim2.fromOffset(6, 6 + searchHeight),
			Size = UDim2.new(1, -12, 0, listHeight),
			Parent = face,
		})
		local list = Container.New(scroll, { PadX = 2, PadY = 2, GapY = 2 })
		list:SetWidth(width - 12 - Config.Page.ScrollBar)
		local entries = {}
		local function Refresh()
			for value, parts in pairs(entries) do
				parts.SetSelected(options.IsSelected(value))
			end
		end
		local function Build(values)
			list:Clear()
			table.clear(entries)
			for _, value in ipairs(values) do
				local labelText = Dropdown.FormatValue(value)
				local parts = Selectable.Build(value, {
					Multi = options.Multi,
					Image = options.Images and options.Images[value],
					Tint = options.Colors and options.Colors[value],
				})
				parts.SetSelected(options.IsSelected(value), true)
				parts.Button.Activated:Connect(function()
					local shouldClose = options.OnPick(value)
					Refresh()
					if shouldClose then
						Popup.Close()
					end
				end)
				entries[value] = parts
				list:Add(
					parts.Button,
					{ Height = itemHeight, Search = labelText:lower() }
				)
			end
			if #values == 0 then
				list:AddLabel(Lang.Strings.NoResults)
			end
		end
		if options.Search then
			local box = Popup.SearchBox(face, width - 12)
			box:GetPropertyChangedSignal("Text"):Connect(function()
				local query = box.Text:lower()
				local changed = false
				for _, entry in ipairs(list.Items) do
					local filtered = query ~= ""
						and entry.Search ~= nil
						and not entry.Search:find(query, 1, true)
					if entry.Filtered ~= filtered then
						entry.Filtered = filtered
						changed = true
					end
				end
				if changed then
					list:MarkDirty()
				end
			end)
		end
		Build(options.Values)
		Layout.Flush()
		Popup.Open(card, scale, options.Anchor, function()
			list:Destroy()
			Util.Try(options.OnClose)
		end)
		return { Rebuild = Build }
	end

	function Tooltip.Build()
		local frame = Draw.Box("Frame", {
			Name = "Tooltip",
			Visible = false,
			ZIndex = Config.Layer.Tooltip,
			Parent = State.Gui,
		}, "Panel", "Outline", 8, 2)
		Tooltip.Label = Draw.Text({
			TextWrapped = true,
			Position = UDim2.fromOffset(10, 6),
			Size = UDim2.new(1, -20, 1, -12),
			Parent = frame,
		}, "Desc", Util.TextSize("Desc") + 1, "Text")
		Tooltip.Scale = Draw.New("UIScale", { Parent = frame })
		Tooltip.Frame = frame
	end

	function Tooltip.Attach(gui, text)
		if State.Touch then
			return
		end
		gui.MouseEnter:Connect(function()
			local token = {}
			Tooltip.Token = token
			task.delay(Config.TooltipDelay, function()
				if Tooltip.Token == token then
					Tooltip.Show(text)
				end
			end)
		end)
		gui.MouseLeave:Connect(function()
			Tooltip.Token = nil
			Tooltip.Frame.Visible = false
		end)
	end

	function Tooltip.Show(text)
		if Library.Unloaded then
			return
		end
		local resolved = Lang.Resolve(text)
		local bounds =
			Layout.Measure(resolved, Tooltip.Label.TextSize, "Desc", 240)
		Tooltip.Label.Text = resolved
		Tooltip.Frame.Size = UDim2.fromOffset(bounds.X + 22, bounds.Y + 14)
		Tooltip.Follow(UserInputService:GetMouseLocation())
		Tooltip.Frame.Visible = true
		Anim.Pop(Tooltip.Scale, 0.8)
	end

	function Tooltip.Follow(position)
		if Tooltip.Frame and Tooltip.Frame.Visible then
			Tooltip.Frame.Position =
				UDim2.fromOffset(position.X + 14, position.Y + 16)
		end
	end

	function KeyPicker.New(row, idx, info, linked)
		local picker = setmetatable({
			Type = "KeyPicker",
			Value = Util.KeyName(info.Default) or "None",
			Mode = info.Mode or "Toggle",
			Linked = linked,
			Toggled = false,
			Held = false,
			Row = row,
			Item = row.Item,
			Container = row.Container,
			ChangedCallback = info.ChangedCallback,
		}, KeyPicker)
		local height = Util.Metric("Row") - 8
		picker.Button = Draw.Box(
			"TextButton",
			{ Size = UDim2.fromOffset(40, height) },
			"Element",
			"Outline",
			6,
			2
		)
		picker.Label = Draw.Text({
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = picker.Button,
		}, "Strong", Util.TextSize("Small") + 1, "Text")
		row:AddRight(picker.Button, 40)
		picker.Button.Activated:Connect(function()
			if picker.LongPressed then
				picker.LongPressed = false
				return
			end
			picker:Listen()
		end)
		picker.Button.MouseButton2Click:Connect(function()
			picker:OpenModeMenu()
		end)
		picker:BindLongPress()
		Widget.Register(picker, idx, info)
		table.insert(State.KeyPickers, picker)
		picker:Render()
		Lang.OnChange(picker, function()
			picker:Render()
		end)
		return picker
	end

	-- Long-press fallback on touch devices to open keybind mode menu
	function KeyPicker:BindLongPress()
		self.Button.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local token = {}
			self.PressToken = token
			task.delay(0.5, function()
				if self.PressToken == token then
					self.LongPressed = true
					self:OpenModeMenu()
				end
			end)
		end)
		self.Button.InputEnded:Connect(function()
			self.PressToken = nil
		end)
	end

	function KeyPicker:Render()
		local text = State.Binding == self and "..."
			or Keybinds.Short(self.Value)
		self.Label.Text = text
		local width = math.max(
			34,
			Layout.Measure(text, self.Label.TextSize, "Strong", 300).X + 18
		)
		if width ~= self.Button.Size.X.Offset then
			self.Button.Size =
				UDim2.fromOffset(width, self.Button.Size.Y.Offset)
			self.Button:SetAttribute("RightWidth", width)
			self.Row:RecalcRight()
		end
		Theme.Bind(
			self.Button,
			{ BackgroundColor3 = State.Binding == self and "Coin" or "Element" }
		)
	end

	function KeyPicker:Listen()
		local previous = State.Binding
		State.Binding = self
		if previous and previous ~= self then
			previous:Render()
		end
		self:Render()
	end

	function KeyPicker:SetKey(name)
		self.Value = name
		self:Render()
		Util.Try(self.ChangedCallback, name)
		for _, callback in ipairs(self.Changed) do
			Util.Try(callback, name)
		end
	end

	function KeyPicker:Press(down)
		if self.Mode == "Always" then
			return
		end
		if self.Mode == "Hold" then
			self.Held = down
			if self.Linked then
				self.Linked:SetValue(down)
			end
			Util.Try(self.Callback, down)
			return
		end
		if not down then
			return
		end
		self.Toggled = not self.Toggled
		if self.Linked then
			self.Linked:SetValue(not self.Linked.Value)
		end
		Util.Try(self.Callback, self:GetState())
	end

	function KeyPicker:GetState()
		if self.Mode == "Always" then
			return true
		end
		if self.Mode == "Hold" then
			return self.Held
		end
		return self.Linked and self.Linked.Value or self.Toggled
	end

	function KeyPicker:SetValue(value)
		if type(value) == "table" then
			self:SetMode(value.Mode or value[2] or self.Mode)
			value = value.Key or value[1]
		end
		self:SetKey(Util.KeyName(value) or "None")
	end

	function KeyPicker:Serialize()
		return { Key = self.Value, Mode = self.Mode }
	end

	function KeyPicker:Deserialize(saved)
		self:SetValue(saved)
	end

	-- Reset active state on mode change and sync linked toggle
	function KeyPicker:SetMode(mode)
		self.Mode = mode
		self.Held, self.Toggled = false, false
		if self.Linked and mode == "Always" then
			self.Linked:SetValue(true)
		elseif self.Linked and mode == "Hold" then
			self.Linked:SetValue(false)
		end
	end

	function KeyPicker:OpenModeMenu()
		Popup.List({
			Anchor = self.Button,
			Values = { "Toggle", "Hold", "Always" },
			IsSelected = function(mode)
				return self.Mode == mode
			end,
			OnPick = function(mode)
				self:SetMode(mode)
				return true
			end,
		})
	end

	Keybinds.ShortNames = {
		LeftControl = "LCtrl",
		RightControl = "RCtrl",
		LeftShift = "LShift",
		RightShift = "RShift",
		LeftAlt = "LAlt",
		RightAlt = "RAlt",
		Backquote = "`",
		Return = "Enter",
		Escape = "Esc",
		CapsLock = "Caps",
		PageUp = "PgUp",
		PageDown = "PgDn",
		Insert = "Ins",
	}

	function Keybinds.Short(name)
		return Keybinds.ShortNames[name] or name
	end

	function Keybinds.Capture(input)
		local picker = State.Binding
		if input.UserInputType == Enum.UserInputType.Touch then
			State.Binding = nil
			picker:Render()
			return
		end
		local name = Util.InputName(input)
		if not name then
			return
		end
		State.Binding = nil
		if name == "Escape" then
			picker:Render()
			return
		end
		if name == "Backspace" or name == "Delete" then
			name = "None"
		end
		picker:SetKey(name)
	end

	function Keybinds.Dispatch(name, down)
		for index = #State.KeyPickers, 1, -1 do
			local picker = State.KeyPickers[index]
			if not picker.Button.Parent then
				table.remove(State.KeyPickers, index)
			elseif picker.Value == name then
				picker:Press(down)
			end
		end
	end

	function ColorPicker.New(row, idx, info)
		local picker = setmetatable({
			Type = "ColorPicker",
			Value = info.Default or Color3.new(1, 1, 1),
			Row = row,
			Item = row.Item,
			Container = row.Container,
		}, ColorPicker)
		picker.Hue, picker.Sat, picker.Vib = picker.Value:ToHSV()
		picker.Swatch = Draw.Box(
			"TextButton",
			{ Size = UDim2.fromOffset(30, Util.Metric("Row") - 10) },
			nil,
			"Outline",
			6,
			2
		)
		picker.Swatch.BackgroundTransparency = 0
		row:AddRight(picker.Swatch, 30)
		picker.Swatch.Activated:Connect(function()
			picker:Open()
		end)
		Widget.Register(picker, idx, info)
		picker:Render()
		return picker
	end

	function ColorPicker:Render()
		self.Swatch.BackgroundColor3 = self.Value
		local view = self.View
		if not view then
			return
		end
		view.Field.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
		view.Cursor.Position = UDim2.fromScale(self.Sat, 1 - self.Vib)
		view.HueCursor.Position = UDim2.fromScale(0.5, self.Hue)
		view.Preview.BackgroundColor3 = self.Value
		if not view.Hex:IsFocused() then
			view.Hex.Text = Util.Hex(self.Value)
		end
	end

	function ColorPicker:Commit()
		self.Value = Color3.fromHSV(self.Hue, self.Sat, self.Vib)
		self:Render()
		self:Fire()
	end

	function ColorPicker:SetValueRGB(color)
		self.Value = color
		self.Hue, self.Sat, self.Vib = color:ToHSV()
		self:Render()
		self:Fire()
	end

	function ColorPicker:SetValue(value)
		local color = typeof(value) == "Color3" and value or Util.FromHex(value)
		if color then
			self:SetValueRGB(color)
		end
	end

	function ColorPicker:Serialize()
		return Util.Hex(self.Value)
	end

	function ColorPicker:Drag(target, handler)
		target.InputBegan:Connect(function(input)
			if not Util.IsPointer(input) then
				return
			end
			handler(input.Position)
			State.Drag = {
				Move = function(move)
					handler(move.Position)
				end,
			}
		end)
	end

	function ColorPicker:BuildField(face, size)
		local field = Draw.Box("TextButton", {
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 0,
			Parent = face,
		}, nil, "Outline", 6, 2)
		local white = Draw.Box("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = field,
		}, nil, nil, 6)
		white.BackgroundTransparency = 0
		Draw.New(
			"UIGradient",
			{ Transparency = NumberSequence.new(0, 1), Parent = white }
		)
		local black = Draw.Box("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Parent = field,
		}, nil, nil, 6)
		black.BackgroundTransparency = 0
		Draw.New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new(1, 0),
			Parent = black,
		})
		local cursor = Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(12, 12),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = field,
		})
		Draw.Corner(cursor, UDim.new(1, 0))
		Draw.New(
			"UIStroke",
			{ Color = Color3.new(1, 1, 1), Thickness = 2, Parent = cursor }
		)
		self:Drag(field, function(position)
			local origin, extent = field.AbsolutePosition, field.AbsoluteSize
			self.Sat = math.clamp((position.X - origin.X) / extent.X, 0, 1)
			self.Vib = 1 - math.clamp((position.Y - origin.Y) / extent.Y, 0, 1)
			self:Commit()
		end)
		return field, cursor
	end

	function ColorPicker:BuildHue(face, size)
		local bar = Draw.Box("TextButton", {
			Position = UDim2.fromOffset(size + 20, 10),
			Size = UDim2.fromOffset(Config.ColorPicker.Hue, size),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = face,
		}, nil, "Outline", 4, 2)
		bar.BackgroundTransparency = 0
		local keys = {}
		for step = 0, 6 do
			table.insert(
				keys,
				ColorSequenceKeypoint.new(
					step / 6,
					Color3.fromHSV(step / 6 % 1, 1, 1)
				)
			)
		end
		Draw.New(
			"UIGradient",
			{ Rotation = 90, Color = ColorSequence.new(keys), Parent = bar }
		)
		local cursor = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 6, 0, 4),
			ZIndex = 3,
			Parent = bar,
		}, "White", "Outline", 2, 1)
		self:Drag(bar, function(position)
			self.Hue = math.clamp(
				(position.Y - bar.AbsolutePosition.Y) / bar.AbsoluteSize.Y,
				0,
				0.999
			)
			self:Commit()
		end)
		return cursor
	end

	function ColorPicker:Open()
		local size = Config.ColorPicker.Field
		local boxHeight = Util.Metric("Box")
		local width = size + Config.ColorPicker.Hue + 30
		local card, face, scale = Popup.Card(width, size + boxHeight + 30)
		local field, cursor = self:BuildField(face, size)
		local hueCursor = self:BuildHue(face, size)
		local hexField = Draw.Box("Frame", {
			Position = UDim2.fromOffset(10, size + 20),
			Size = UDim2.new(1, -60, 0, boxHeight),
			Parent = face,
		}, "Element", "Outline", 8, 2)
		local hex = Draw.Text({
			ClassName = "TextBox",
			ClearTextOnFocus = false,
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = hexField,
		}, "Body", Util.TextSize("Label"), "Text")
		local preview = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, size + 20),
			Size = UDim2.fromOffset(40, boxHeight),
			BackgroundTransparency = 0,
			Parent = face,
		}, nil, "Outline", 8, 2)
		hex.FocusLost:Connect(function()
			local color = Util.FromHex(hex.Text)
			if color then
				self:SetValueRGB(color)
			else
				self:Render()
			end
		end)
		self.View = {
			Field = field,
			Cursor = cursor,
			HueCursor = hueCursor,
			Hex = hex,
			Preview = preview,
		}
		self:Render()
		Popup.Open(card, scale, self.Swatch, function()
			self.View = nil
		end)
	end

	function Dialog.Close()
		local cur = Dialog.Current
		if not cur then
			return
		end
		Dialog.Current = nil
		if cur.Container then
			cur.Container:Destroy()
		end
		local shrink =
			Anim.Tween(cur.Scale, { Scale = State.UserScale * 0.9 }, 0.14, "In")
		Anim.Tween(cur.Backdrop, { BackgroundTransparency = 1 }, 0.14)
		shrink.Completed:Once(function()
			Theme.UnbindTree(cur.Backdrop)
			cur.Backdrop:Destroy()
		end)
	end

	function Dialog.Show(spec)
		spec = spec or {}
		Dialog.Close()
		if not State.Gui then
			return nil
		end
		local backdrop = Draw.New("TextButton", {
			Name = "DialogBackdrop",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = Config.Layer.Modal,
			Parent = State.Gui,
		})
		Anim.Tween(
			backdrop,
			{ BackgroundTransparency = 0.45 },
			Config.Tween.Fast
		)
		local viewportW = State.Gui.AbsoluteSize.X
		local modalW = math.clamp(
			spec.Width or 340,
			260,
			math.max(
				260,
				math.floor(viewportW / math.max(0.5, State.UserScale or 1) - 32)
			)
		)
		local card, face, scale = Popup.Card(modalW, 160)
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.fromScale(0.5, 0.5)
		card.Parent = backdrop
		scale.Scale = State.UserScale * 0.86
		Motion.Spring(
			scale,
			"Scale",
			State.UserScale,
			"Fast",
			{ Damping = 0.62 }
		)
		local body = Container.New(face, { PadX = 14, PadY = 14, GapY = 8 })
		body:SetWidth(modalW)
		body.OnHeight = function(h)
			local shadow = Config.Group.Shadow
			card.Size =
				UDim2.fromOffset(modalW + shadow, math.max(120, h) + shadow)
		end
		body:AddParagraph({
			Title = spec.Title or "Confirm",
			Content = spec.Content or spec.Description or "",
			Icon = spec.Icon,
		})
		local buttons = spec.Buttons
			or {
				{ Title = spec.CancelText or "Cancel", Style = "Default" },
				{
					Title = spec.ConfirmText or "Confirm",
					Style = spec.Style or "Primary",
					Callback = spec.Callback or spec.OnConfirm,
				},
			}
		local firstBtn
		for index, btnSpec in ipairs(buttons) do
			local rawStyle = btnSpec.Style or btnSpec.Variant
			if rawStyle == "Secondary" then
				rawStyle = "Default"
			end
			local action = function()
				Dialog.Close()
				Util.Try(btnSpec.Callback or btnSpec.Func)
			end
			if not firstBtn then
				firstBtn = body:AddButton({
					Text = btnSpec.Title or btnSpec.Text or "OK",
					Style = rawStyle
						or (index == #buttons and "Primary" or "Default"),
					Icon = btnSpec.Icon,
				}, action)
			else
				firstBtn:AddButton({
					Text = btnSpec.Title or btnSpec.Text or "OK",
					Style = rawStyle
						or (index == #buttons and "Primary" or "Default"),
					Icon = btnSpec.Icon,
				}, action)
			end
		end
		Layout.Flush()
		Dialog.Current = {
			Backdrop = backdrop,
			Card = card,
			Scale = scale,
			Container = body,
		}
		return Dialog.Current
	end

	function Sheet.Close()
		local cur = Sheet.Current
		if not cur then
			return
		end
		Sheet.Current = nil
		if cur.Container then
			cur.Container:Destroy()
		end
		Anim.Tween(cur.Backdrop, { BackgroundTransparency = 1 }, 0.18)
		local slide = Anim.Tween(
			cur.Panel,
			{ Position = UDim2.new(1, 20, 0, 8) },
			0.2,
			"In"
		)
		slide.Completed:Once(function()
			Theme.UnbindTree(cur.Backdrop)
			cur.Backdrop:Destroy()
		end)
	end

	function Sheet.Show(spec)
		spec = spec or {}
		Sheet.Close()
		if not State.Gui then
			return nil
		end
		local backdrop = Draw.New("TextButton", {
			Name = "SheetBackdrop",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = Config.Layer.Modal,
			Parent = State.Gui,
		})
		backdrop.Activated:Connect(Sheet.Close)
		Anim.Tween(
			backdrop,
			{ BackgroundTransparency = 0.45 },
			Config.Tween.Fast
		)
		local sheetW = math.min(
			spec.Width or 320,
			math.max(240, State.Gui.AbsoluteSize.X - 40)
		)
		local panel = Draw.Box("TextButton", {
			Name = "SheetPanel",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, sheetW + 20, 0, 8),
			Size = UDim2.new(0, sheetW, 1, -16),
			Parent = backdrop,
		}, "Panel", "Outline", 12, 3)
		Motion.Spring(
			panel,
			"Position",
			UDim2.new(1, -8, 0, 8),
			"Normal",
			{ Damping = 0.72 }
		)
		local header = Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 42), Parent = panel },
			"PanelHeader",
			nil,
			12
		)
		Draw.Box("Frame", {
			Position = UDim2.new(0, 0, 1, -12),
			Size = UDim2.new(1, 0, 0, 12),
			Parent = header,
		}, "PanelHeader")
		Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 2,
			Parent = header,
		}, "Outline")
		Draw.Text({
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.new(1, -50, 1, -2),
			Parent = header,
		}, "Body", Util.TextSize("Group"), "Text", spec.Title or "Details")
		local closeBtn = Draw.Box("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, -1),
			Size = UDim2.fromOffset(26, 26),
			ZIndex = 3,
			Parent = header,
		}, "Element", "Outline", 6, 2)
		Icons.Vector(closeBtn, "close", 14, "Text").Position =
			UDim2.fromOffset(6, 6)
		closeBtn.Activated:Connect(Sheet.Close)
		local scroll = Layout.ScrollFrame({
			Position = UDim2.fromOffset(4, 46),
			Size = UDim2.new(1, -8, 1, -52),
			Parent = panel,
		})
		local body = Container.New(scroll, { PadX = 10, PadY = 10, GapY = 8 })
		body:SetWidth(sheetW - 8 - Config.Page.ScrollBar)
		local builder = spec.Build or spec.Render
		if type(builder) == "function" then
			Util.Try(builder, body)
		end
		Layout.Flush()
		Sheet.Current = {
			Backdrop = backdrop,
			Panel = panel,
			Container = body,
			Close = Sheet.Close,
		}
		return body
	end

	function Gui.ClearPrevious(parent)
		local env = type(getgenv) == "function" and getgenv() or nil
		if
			env
			and type(env[Config.GuiAttribute]) == "table"
			and env[Config.GuiAttribute] ~= Library
			and not env[Config.GuiAttribute].Unloaded
		then
			Util.Try(env[Config.GuiAttribute].Unload, env[Config.GuiAttribute])
		end
		if env then
			env[Config.GuiAttribute] = Library
		end
		for _, child in ipairs(parent:GetChildren()) do
			if child:GetAttribute(Config.GuiAttribute) then
				child:Destroy()
			end
		end
	end

	function Gui.Setup()
		if State.Gui then
			return
		end
		local parent = Util.GuiParent()
		Gui.ClearPrevious(parent)
		State.Gui = Draw.New("ScreenGui", {
			Name = Config.GuiAttribute,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 100,
			Parent = parent,
		})
		State.Gui:SetAttribute(Config.GuiAttribute, Library.Version)
		State.Overlay = Draw.New("Frame", {
			Name = "Overlay",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			ZIndex = Config.Layer.Overlay,
			Parent = State.Gui,
		})
		local catcher = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 1,
			Parent = State.Overlay,
		})
		catcher.MouseButton1Click:Connect(Popup.Close)
		catcher.MouseButton2Click:Connect(Popup.Close)
		Notify.Build()
		Tooltip.Build()
		Util.Connect(UserInputService.InputBegan, Gui.OnInputBegan)
		Util.Connect(UserInputService.InputChanged, Gui.OnInputChanged)
		Util.Connect(UserInputService.InputEnded, Gui.OnInputEnded)
		Util.Connect(RunService.Heartbeat, Gui.OnHeartbeat)
		Util.Every(20, Theme.Prune)
	end

	function Gui.OnInputBegan(input, processed)
		if Library.Opening then
			return
		end
		if State.Binding then
			Keybinds.Capture(input)
			return
		end
		if UserInputService:GetFocusedTextBox() then
			return
		end
		local name = Util.InputName(input)
		if not name then
			return
		end
		if name == State.MenuKey and State.Window and not processed then
			State.Window:Toggle()
		end
		-- Allow feature keybinds even when game binds the same key (processed = true)
		if
			input.UserInputType == Enum.UserInputType.Keyboard or not processed
		then
			Keybinds.Dispatch(name, true)
		end
	end

	function Gui.OnInputChanged(input)
		if State.Drag and Util.IsMove(input) then
			State.Drag.Move(input)
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			Tooltip.Follow(UserInputService:GetMouseLocation())
		end
	end

	function Gui.OnInputEnded(input)
		if Util.IsPointer(input) and State.Drag then
			local drag = State.Drag
			State.Drag = nil
			Util.Try(drag.Stop)
		end
		local name = Util.InputName(input)
		if name then
			Keybinds.Dispatch(name, false)
		end
	end

	function Gui.OnHeartbeat(deltaTime)
		if deltaTime > 0 then
			State.Fps = State.Fps * 0.92 + (1 / deltaTime) * 0.08
		end
		for _, job in ipairs(State.Tasks) do
			job.Elapsed += deltaTime
			if job.Elapsed >= job.Interval and not job.Busy then
				job.Elapsed = 0
				job.Busy = true
				task.spawn(function()
					Util.Try(job.Run)
					job.Busy = false
				end)
			end
		end
	end

	--@param handle Drag target, move(delta) drag callback, exclude ignored child button
	function Gui.Draggable(handle, move, exclude)
		handle.InputBegan:Connect(function(input)
			if not Util.IsPointer(input) then
				return
			end
			for _, zone in ipairs(exclude or {}) do
				if zone.Visible and Util.Inside(zone, input.Position) then
					return
				end
			end
			local start = input.Position
			local begin = move(nil)
			State.Drag = {
				Move = function(moved)
					move(begin, moved.Position - start)
				end,
			}
		end)
	end

	function Window.DetectTouch(forced)
		if forced == "Mobile" or forced == "Desktop" then
			State.Touch = forced == "Mobile"
			return
		end
		State.Touch = UserInputService.TouchEnabled
			and not UserInputService.KeyboardEnabled
	end

	function Window.New(options)
		Window.DetectTouch(options.Layout)
		local size = options.Size
			or Vector2.new(Config.Window.Width, Config.Window.Height)
		if typeof(size) == "UDim2" then
			size = Vector2.new(size.X.Offset, size.Y.Offset)
		end
		local self = setmetatable({
			Title = options.Title or "Nullx11",
			SubTitle = options.SubTitle or "Developed by NULL",
			Desired = size,
			Size = size,
			Tabs = {},
			TabOrder = 0,
			ActiveTab = nil,
			Visible = false,
			Minimized = false,
			Compact = false,
			Query = "",
		}, Window)
		State.Window = self
		State.MenuKey = Util.KeyName(
			options.MenuKey or options.ToggleKey or options.MinimizeKey
		) or "LeftControl"
		self:BuildFrame()
		self:BuildTopbar()
		self:BuildSidebar()
		self:BuildMain()
		self:BuildGround()
		self:FitViewport()
		Util.Connect(
			State.Gui:GetPropertyChangedSignal("AbsoluteSize"),
			function()
				self:FitViewport()
			end
		)
		Util.Every(Config.TitleWaveInterval, function()
			if self.Visible then
				self:WaveTitle()
			end
		end)
		return self
	end

	function Window:BuildFrame()
		local shadow = Config.Window.Shadow
		local radius = Config.Window.Radius
		self.Root = Draw.New("Frame", {
			Name = "Window",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			Visible = false,
			ZIndex = Config.Layer.Window,
			Parent = State.Gui,
		})
		self.UserScale = Draw.New("UIScale", { Parent = self.Root })
		self.Pop = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			Parent = self.Root,
		})
		self.PopScale = Draw.New("UIScale", { Parent = self.Pop })
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(shadow, shadow),
			Size = UDim2.new(1, -shadow, 1, -shadow),
			Parent = self.Pop,
		}, "Shadow", nil, radius)
		self.Body = Draw.Box("Frame", {
			Size = UDim2.new(1, -shadow, 1, -shadow),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			ClipsDescendants = true,
			Parent = self.Pop,
		}, nil, "Outline", radius, Config.Window.Stroke)
		local gradient =
			Draw.New("UIGradient", { Rotation = 90, Parent = self.Body })
		Theme.OnRender(gradient, function()
			gradient.Color = ColorSequence.new(
				Theme.Colors.Backdrop,
				Theme.Colors.BackdropAlt
			)
		end)
	end

	function Window:BuildTopbar()
		local height, radius = Config.Window.Topbar, Config.Window.Radius
		local topbar = Draw.Box("Frame", {
			Name = "Topbar",
			Size = UDim2.new(1, 0, 0, height),
			ClipsDescendants = true,
			ZIndex = 5,
			Parent = self.Body,
		}, "Topbar", nil, radius)
		self.TopbarFill = Draw.Box("Frame", {
			Position = UDim2.new(0, 0, 1, -radius),
			Size = UDim2.new(1, 0, 0, radius),
			Parent = topbar,
		}, "Topbar")
		self.TopbarLine = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 3),
			ZIndex = 3,
			Parent = topbar,
		}, "Outline")
		self.Topbar = topbar
		self:BuildDecor(topbar)
		local left = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 0),
			Size = UDim2.new(1, -200, 1, -3),
			ZIndex = 4,
			Parent = topbar,
		})
		Draw.List(
			left,
			10,
			true,
			Enum.HorizontalAlignment.Left,
			Enum.VerticalAlignment.Center
		)
		self.Emblem = Draw.Emblem(left, 40)
		self:BuildTitle(left)
		self.SubtitlePill = self:BuildPill(left, self.SubTitle)
		local right = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, 0),
			Size = UDim2.new(0, 180, 1, -3),
			ZIndex = 4,
			Parent = topbar,
		})
		Draw.List(
			right,
			8,
			true,
			Enum.HorizontalAlignment.Right,
			Enum.VerticalAlignment.Center
		)
		self:BuildLanguagePill(right)
		local _, minimizeFace = self:BuildTopButton(
			right,
			"Minimize",
			"Coin",
			"CoinDark",
			"Ink",
			function()
				self:SetMinimized(not self.Minimized)
			end
		)
		self.ExpandBar = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, 3, 0, 0),
			Parent = minimizeFace,
		}, "Ink", nil, 2)
		self:BuildTopButton(
			right,
			"Close",
			"Accent",
			"AccentDark",
			"White",
			function()
				self:SetVisible(false)
				if not State.Touch then
					Library:Notify(
						self.Title,
						Lang.Format("Hidden", Keybinds.Short(State.MenuKey)),
						3,
						"Info"
					)
				end
			end
		)
		Gui.Draggable(topbar, function(begin, delta)
			if not delta then
				return self.Root.Position
			end
			self.Root.Position = begin + UDim2.fromOffset(delta.X, delta.Y)
			self:ClampPosition()
			return begin
		end, { right })
	end

	-- Theme topbar decor: drifting clouds for day themes, twinkling stars/embers for night themes
	function Window:BuildDecor(topbar)
		self.Clouds, self.Stars = {}, {}
		if not Config.Decorations then
			return
		end
		for index, spot in ipairs({ { 0.44, 8, 42 }, { 0.6, 22, 30 } }) do
			local cloud = Draw.Cloud(topbar, spot[3])
			cloud.Position = UDim2.new(spot[1], 0, 0, spot[2])
			cloud.ZIndex = 2
			Anim.Loop(
				"DecorClouds",
				cloud,
				{ Position = UDim2.new(spot[1], 14, 0, spot[2] + 2) },
				4 + index,
				"Sine",
				true
			)
			table.insert(self.Clouds, cloud)
		end
		for index, spot in ipairs({
			{ 0.42, 10, 12 },
			{ 0.48, 30, 9 },
			{ 0.54, 14, 14 },
			{ 0.6, 32, 10 },
			{ 0.66, 8, 11 },
			{ 0.71, 26, 8 },
		}) do
			local star = Draw.Text({
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(spot[1], 0, 0, spot[2]),
				Size = UDim2.fromOffset(spot[3] + 4, spot[3] + 4),
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 2,
				Parent = topbar,
			}, "Glyph", spot[3], "DecorColor")
			star.TextTransparency = 0.15
			Anim.Loop(
				"DecorStars",
				star,
				{ TextTransparency = 0.8 },
				0.9 + index * 0.37,
				"Sine",
				true
			)
			table.insert(self.Stars, star)
		end
		self.Spooky = {}
		for index, spot in ipairs({
			{ 0.5, 10, 30, "pumpkin" },
			{ 0.55, 26, 20, "bat" },
			{ 0.6, 6, 30, "boo" },
			{ 0.645, 28, 18, "candy" },
			{ 0.69, 10, 30, "pumpkin" },
			{ 0.735, 20, 20, "bat" },
		}) do
			local item = Sprite.New(topbar, spot[4], spot[3])
			item.AnchorPoint = Vector2.new(0.5, 0)
			item.Position = UDim2.new(spot[1], 0, 0, spot[2])
			item.ZIndex = 2
			local swing = spot[4] == "bat" and 14 or 6
			Anim.Loop("DecorSpooky", item, {
				Position = UDim2.new(
					spot[1],
					0,
					0,
					spot[2] + (spot[4] == "bat" and 6 or 3)
				),
				Rotation = index % 2 == 0 and swing or -swing,
			}, 1.2 + index * 0.35, "Sine", true)
			table.insert(self.Spooky, item)
		end
		self:BuildSpookyBody()
		Theme.OnRender(self.Stars, function()
			self:RenderDecor()
		end)
	end

	-- Halloween window accents: orange glow border, purple bottom fog, hanging spider
	function Window:BuildSpookyBody()
		if not Config.Decorations then
			return
		end
		self.SpookyBody = {}
		local shadow, radius = Config.Window.Shadow, Config.Window.Radius
		local glow = Draw.New("Frame", {
			Name = "Glow",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(-3, -3),
			Size = UDim2.new(1, 6 - shadow, 1, 6 - shadow),
			ZIndex = 0,
			Parent = self.Pop,
		})
		Draw.Corner(glow, radius + 3)
		local glowStroke = Draw.New("UIStroke", {
			Thickness = 4,
			Transparency = 0.25,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = glow,
		})
		Theme.OnRender(glowStroke, function()
			glowStroke.Color = Theme.Colors.Glow or Theme.Colors.Accent
		end)
		Anim.Loop(
			"DecorSpookyGlow",
			glowStroke,
			{ Transparency = 0.75, Thickness = 2 },
			1.8,
			"Sine",
			true
		)
		self.SpookyGlow = glow
		table.insert(self.SpookyBody, glow)

		local fog = Draw.New("Frame", {
			Name = "Fog",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 70),
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = self.Body,
		})
		Draw.Corner(fog, radius)
		local fogShape = Draw.New("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(1, 0.72),
			}),
			Parent = fog,
		})
		Theme.OnRender(fog, function()
			fog.BackgroundColor3 = Theme.Colors.Fog or Theme.Colors.Accent
		end)
		Anim.Loop(
			"DecorSpookyBody",
			fogShape,
			{ Offset = Vector2.new(0, 0.12) },
			3.2,
			"Sine",
			true
		)
		self.SpookyFog = fog
		table.insert(self.SpookyBody, fog)

		local hanger = Draw.New("Frame", {
			Name = "Spider",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -16, 0, Config.Window.Topbar + 60),
			Size = UDim2.fromOffset(16, 16),
			ZIndex = 9,
			Parent = self.Body,
		})
		Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 0, 4),
			Size = UDim2.new(0, 1, 0, 300),
			BackgroundColor3 = Color3.fromRGB(200, 186, 222),
			BackgroundTransparency = 0.5,
			Parent = hanger,
		})
		local spider = Sprite.New(hanger, "spider", 16)
		Anim.Loop(
			"DecorSpookyBody",
			hanger,
			{ Position = UDim2.new(1, -16, 0, Config.Window.Topbar + 150) },
			3.4,
			"Sine",
			true
		)
		Anim.Loop(
			"DecorSpookyBody",
			spider,
			{ Rotation = 10 },
			0.9,
			"Sine",
			true
		)
		self.SpookySpider = hanger
		table.insert(self.SpookyBody, hanger)
	end

	function Window:RenderDecor()
		local wide = self.Size and self.Size.X >= 700
		local decor = Theme.Colors.Decor
		local shown = self.Visible ~= false
		local expanded = shown and not self.Minimized
		local showClouds = shown and wide and decor == "Clouds"
		local showStars = shown and wide and decor == "Stars"
		local showSpooky = shown and wide and decor == "Halloween"
		local showGlow = shown and decor == "Halloween"
		local showSpookyBody = expanded and decor == "Halloween"
		for _, cloud in ipairs(self.Clouds) do
			cloud.Visible = showClouds
		end
		for _, star in ipairs(self.Stars) do
			star.Text = Theme.Colors.DecorGlyph or "✦"
			star.Visible = showStars
		end
		for _, item in ipairs(self.Spooky or {}) do
			item.Visible = showSpooky
		end
		if self.SpookyGlow then
			self.SpookyGlow.Visible = showGlow
		end
		if self.SpookyFog then
			self.SpookyFog.Visible = showSpookyBody
		end
		if self.SpookySpider then
			self.SpookySpider.Visible = showSpookyBody
		end
		Anim.SetGroupActive("Emblem", shown)
		Anim.SetGroupActive("DecorClouds", showClouds)
		Anim.SetGroupActive("DecorStars", showStars)
		Anim.SetGroupActive("DecorSpooky", showSpooky)
		Anim.SetGroupActive("DecorSpookyGlow", showGlow)
		Anim.SetGroupActive("DecorSpookyBody", showSpookyBody)
	end

	function Window:BuildTitle(parent)
		local holder = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 34),
			LayoutOrder = 1,
			Parent = parent,
		})
		Draw.List(
			holder,
			1,
			true,
			Enum.HorizontalAlignment.Left,
			Enum.VerticalAlignment.Center
		)
		self.Letters = {}
		local size = State.Touch and 18 or Config.Text.Title
		local index = 0
		for char in self.Title:upper():gmatch(utf8.charpattern) do
			local bounds = Layout.Measure(char, size, "Logo", 200)
			local slot = Draw.New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					char == " " and size * 0.3 or bounds.X,
					size + 4
				),
				LayoutOrder = #self.Letters + 1,
				Parent = holder,
			})
			local letter = Draw.Text(
				{
					Text = char,
					Size = UDim2.fromScale(1, 1),
					TextXAlignment = Enum.TextXAlignment.Center,
					Parent = slot,
				},
				"Logo",
				size,
				Config.TitleColors[index % #Config.TitleColors + 1]
			)
			Draw.Stroke(letter, "Ink", 2)
			table.insert(self.Letters, letter)
			index += char == " " and 0 or 1
		end
		self.TitleHolder = holder
	end

	function Window:WaveTitle()
		if not State.TitleGlitch then
			return
		end
		if State.ReducedMotion then
			return
		end
		for index, letter in ipairs(self.Letters) do
			letter.Position = UDim2.new()
			local x = State.TitleGlitch and (index % 2 == 0 and 2 or -2) or 0
			Anim.Tween(letter, {
				Position = UDim2.fromOffset(x, State.TitleGlitch and -2 or -6),
			}, 0.14, "Out", 0, true, index * 0.018)
		end
	end

	function Window:BuildPill(parent, text)
		local pill = Draw.Box("Frame", {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 22),
			LayoutOrder = 2,
			Parent = parent,
		}, "Shadow", nil, UDim.new(1, 0))
		pill.BackgroundTransparency = 0.45
		Draw.Padding(pill, 0, 10, 0, 10)
		Draw.Text({
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			Parent = pill,
		}, "Body", Util.TextSize("Small"), "TopbarText", text)
		pill.Visible = text ~= ""
		return pill
	end

	function Window:BuildLanguagePill(parent)
		local pill = Draw.Box("Frame", {
			Size = UDim2.fromOffset(74, 28),
			LayoutOrder = 1,
			Parent = parent,
		}, "Shadow", "Outline", UDim.new(1, 0), 2)
		pill.BackgroundTransparency = 0.35
		local segments = {}
		for index, code in ipairs({ "EN", "TH" }) do
			local segment = Draw.Box("TextButton", {
				Position = UDim2.new((index - 1) * 0.5, 2, 0, 2),
				Size = UDim2.new(0.5, -4, 1, -4),
				Parent = pill,
			}, "Coin", nil, UDim.new(1, 0))
			local label = Draw.Text({
				Text = code,
				Size = UDim2.fromScale(1, 1),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = segment,
			}, "Body", 13, "White")
			segment.Activated:Connect(function()
				Library:SetLanguage(code)
			end)
			segments[code] = { Button = segment, Label = label }
		end
		local function Render()
			for code, segment in pairs(segments) do
				local active = State.Language == code
				Anim.Tween(
					segment.Button,
					{ BackgroundTransparency = active and 0 or 1 },
					Config.Tween.Fast
				)
				Theme.Bind(
					segment.Label,
					{ TextColor3 = active and "Ink" or "TopbarText" }
				)
			end
		end
		Lang.OnChange(pill, Render)
		Render()
	end

	-- Draw close icon with Frame lines for consistent cross-device rendering
	function Window:BuildTopButton(parent, kind, face, shade, ink, callback)
		local size = State.Touch and 36 or 30
		local holder, top = Draw.Block(parent, face, shade, 8, 3)
		holder.Size = UDim2.fromOffset(size, size + 1)
		holder.LayoutOrder = 2 + #parent:GetChildren()
		local strokes = kind == "Close" and { 45, -45 } or { 0 }
		for _, rotation in ipairs(strokes) do
			Draw.Box("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0.5, 0, 0, 3),
				Rotation = rotation,
				Parent = top,
			}, ink, nil, 2)
		end
		local hit = Draw.New("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			Parent = holder,
		})
		hit.MouseButton1Down:Connect(function()
			Anim.Tween(
				top,
				{ Position = UDim2.fromOffset(0, 2) },
				0.06,
				"Linear"
			)
		end)
		hit.MouseButton1Up:Connect(function()
			Anim.Tween(
				top,
				{ Position = UDim2.new() },
				Config.Tween.Normal,
				"Back"
			)
		end)
		hit.MouseLeave:Connect(function()
			Anim.Tween(top, { Position = UDim2.new() }, Config.Tween.Fast)
		end)
		hit.Activated:Connect(callback)
		return holder, top
	end

	function Window:BuildSidebar()
		local top = Config.Window.Topbar
		local sidebar = Draw.Box("Frame", {
			Name = "Sidebar",
			Position = UDim2.fromOffset(0, top),
			Parent = self.Body,
		}, "Sidebar")
		Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 3, 1, 0),
			ZIndex = 3,
			Parent = sidebar,
		}, "Outline")
		Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -3, 0, 0),
			Size = UDim2.new(0, 5, 1, 0),
			BackgroundTransparency = 0,
			Parent = sidebar,
		}, "SidebarAlt")
		self.Sidebar = sidebar
		local scroll = Layout.ScrollFrame({
			Position = UDim2.fromOffset(0, 8),
			Size = UDim2.new(1, -8, 1, -(Config.Window.UserCard + 8)),
			Parent = sidebar,
		})
		scroll.ScrollBarThickness = 3
		self.TabScroll = scroll
		self.TabList = Container.New(
			scroll,
			{ PadX = 8, PadY = 2, GapY = 4, Window = self }
		)
		self:BuildUserCard(sidebar)
	end

	function Window:BuildUserCard(sidebar)
		local card = Draw.New("Frame", {
			Name = "User",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, -8, 0, Config.Window.UserCard),
			Parent = sidebar,
		})
		self.UserCard = card
		Draw.Box("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundTransparency = 0.5,
			Parent = card,
		}, "SidebarAlt")
		local avatar = Draw.Box("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.fromOffset(36, 36),
			Parent = card,
		}, "PanelHeader", "Outline", UDim.new(1, 0), 2)
		task.spawn(function()
			local ok, image = pcall(
				Players.GetUserThumbnailAsync,
				Players,
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)
			if ok then
				avatar.Image = image
			end
		end)
		self.UserName = Draw.Text({
			Text = LocalPlayer.DisplayName,
			Position = UDim2.fromOffset(56, 11),
			Size = UDim2.new(1, -62, 0, 18),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = card,
		}, "Body", 14, "SidebarText")
		self.UserTag = Draw.Text({
			Text = "@" .. LocalPlayer.Name,
			Position = UDim2.fromOffset(56, 29),
			Size = UDim2.new(1, -62, 0, 16),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = card,
		}, "Desc", 12, "SidebarMuted")
		self.Avatar = avatar
	end

	function Window:BuildMain()
		local header = Config.Window.Header
		local main = Draw.New("Frame", {
			Name = "Main",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, Config.Window.Topbar),
			Parent = self.Body,
		})
		self.Main = main
		self.HeaderTitle = Draw.Text({
			Position = UDim2.fromOffset(16, 10),
			Size = UDim2.new(1, -230, 0, 26),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = main,
		}, "Display", Config.Text.Header, "Text")
		self.HeaderDesc = Draw.Text({
			Position = UDim2.fromOffset(16, 36),
			Size = UDim2.new(1, -230, 0, 16),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = main,
		}, "Desc", Util.TextSize("Desc") + 1, "SubText")
		local field = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -16, 0, header / 2),
			Size = UDim2.fromOffset(200, Util.Metric("Box")),
			Parent = main,
		}, "Element", "Outline", UDim.new(1, 0), 2)
		local icon = Icons.Vector(field, "search", 14, "SubText")
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 10, 0.5, 0)
		local clearBtn = Draw.Box("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			Visible = false,
			Parent = field,
		}, "Hover", nil, UDim.new(1, 0))
		Icons.Vector(clearBtn, "close", 10, "SubText").Position =
			UDim2.fromOffset(4, 4)
		self.SearchClear = clearBtn
		self.Search = Draw.Text({
			ClassName = "TextBox",
			Text = "",
			ClearTextOnFocus = false,
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(1, -52, 1, 0),
			Parent = field,
		}, "Body", Util.TextSize("Label"), "Text")
		Lang.Bind(self.Search, Lang.Strings.Search, "PlaceholderText")
		Theme.Bind(self.Search, { PlaceholderColor3 = "Muted" })
		self.SearchField = field
		clearBtn.Activated:Connect(function()
			self.Search.Text = ""
		end)
		self.Search:GetPropertyChangedSignal("Text"):Connect(function()
			self.Query = self.Search.Text:lower()
			clearBtn.Visible = self.Query ~= ""
			self:ApplyFilter()
		end)
		self.PageHost = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, header),
			Size = UDim2.new(1, 0, 1, -header),
			ClipsDescendants = true,
			ZIndex = 2,
			Parent = main,
		})
		local emptyBox = Draw.Box("Frame", {
			Name = "EmptySearch",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.45),
			Size = UDim2.fromOffset(200, 74),
			Visible = false,
			ZIndex = 5,
			Parent = self.PageHost,
		}, "Panel", "Outline", 10, 2)
		local booSprite = Sprite.New(emptyBox, "boo", 24)
		booSprite.AnchorPoint = Vector2.new(0.5, 0)
		booSprite.Position = UDim2.new(0.5, 0, 0, 10)
		Draw.Text({
			Position = UDim2.fromOffset(8, 40),
			Size = UDim2.new(1, -16, 0, 24),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = emptyBox,
		}, "Body", Util.TextSize("Label"), "Muted", Lang.Strings.NoResults)
		self.EmptyState = emptyBox
		Particles.Build(main)
	end

	function Window:BuildGround()
		local height, radius = Config.Window.Ground, Config.Window.Radius
		local ground = Draw.Box("Frame", {
			Name = "Ground",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, height),
			ClipsDescendants = true,
			ZIndex = 3,
			Parent = self.Body,
		}, "Brick", nil, radius)
		Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, radius), Parent = ground },
			"Brick"
		)
		local bricks = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(6, 6),
			Size = UDim2.new(1, -12, 1, -8),
			ClipsDescendants = true,
			Parent = ground,
		})
		Draw.Bricks(bricks, 28, "BrickDark")
		Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 6), Parent = ground },
			"Grass"
		)
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(0, 6),
			Size = UDim2.new(1, 0, 0, 2),
			Parent = ground,
		}, "GrassDark")
		Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 3), Parent = ground },
			"Outline"
		)
		self.Ground = ground
		local gripSize = State.Touch and 34 or 24
		local grip = Draw.New("TextButton", {
			Name = "Grip",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -2, 1, -2),
			Size = UDim2.fromOffset(gripSize, gripSize),
			ZIndex = 4,
			Parent = ground,
		})
		local gripIcon = Icons.Vector(grip, "grip", 14, "White")
		gripIcon.AnchorPoint = Vector2.new(1, 1)
		gripIcon.Position = UDim2.new(1, -2, 1, -2)
		self.Grip = grip
		Gui.Draggable(grip, function(begin, delta)
			if not delta then
				return { Size = self.Size, Position = self.Root.Position }
			end
			self:ResizeFrom(begin, Vector2.new(delta.X, delta.Y))
			return begin
		end)
	end

	function Window:ResizeFrom(begin, delta)
		if self.Minimized then
			return
		end
		self.Desired = begin.Size + delta / State.UserScale
		self:FitViewport()
		local grown = (self.Size.X - begin.Size.X) * State.UserScale
		self.Root.Position = begin.Position
			+ UDim2.fromOffset(math.floor(grown / 2), 0)
		self:ClampPosition()
	end

	function Window:MinSize()
		if State.Touch then
			return Config.Window.TouchMinWidth, Config.Window.TouchMinHeight
		end
		return Config.Window.MinWidth, Config.Window.MinHeight
	end

	function Window:ClampPosition()
		if not State.Gui or not self.Root then
			return
		end
		local viewport = State.Gui.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		local scaleFactor = math.max(0.5, State.UserScale or 1)
		local halfW = math.floor((self.Size.X * scaleFactor) / 2)
		local topH = math.floor(Config.Window.Topbar * scaleFactor)
		local pos = self.Root.Position
		local absX = viewport.X * pos.X.Scale + pos.X.Offset
		local absY = viewport.Y * pos.Y.Scale + pos.Y.Offset
		local minX = math.min(halfW + 6, viewport.X / 2)
		local maxX = math.max(minX, viewport.X - halfW - 6)
		local clampedX = math.clamp(absX, minX, maxX)
		local clampedY = math.clamp(absY, 6, math.max(6, viewport.Y - topH - 6))
		self.Root.Position = UDim2.new(
			pos.X.Scale,
			math.floor(clampedX - viewport.X * pos.X.Scale + 0.5),
			pos.Y.Scale,
			math.floor(clampedY - viewport.Y * pos.Y.Scale + 0.5)
		)
	end

	function Window:FitViewport()
		local viewport = State.Gui.AbsoluteSize
		if viewport.X <= 0 then
			return
		end
		local margin = (
			State.Touch and Config.Window.TouchMargin or Config.Window.Margin
		) * 2
		local baseMinW, baseMinH = self:MinSize()
		local scaleFactor = math.max(0.5, State.UserScale or 1)
		local availW = math.max(260, (viewport.X - margin) / scaleFactor)
		local availH = math.max(220, (viewport.Y - margin) / scaleFactor)
		local minWidth = math.min(baseMinW, availW)
		local minHeight = math.min(baseMinH, availH)
		self.Size = Vector2.new(
			math.floor(math.clamp(self.Desired.X, minWidth, availW)),
			math.floor(math.clamp(self.Desired.Y, minHeight, availH))
		)
		self:ApplyLayout()
		self:ClampPosition()
		if Float.Clamp then
			Float.Clamp()
		end
	end

	function Window:ApplyLayout()
		local width, height = self.Size.X, self.Size.Y
		local shadow = Config.Window.Shadow
		self.Compact = width < Config.Window.CompactBreakpoint
		local sidebar = self.Compact and Config.Window.SidebarCompact
			or Config.Window.Sidebar
		local bodyHeight = height - Config.Window.Topbar - Config.Window.Ground
		self.Root.Size = UDim2.fromOffset(
			width + shadow,
			(self.Minimized and Config.Window.Topbar or height) + shadow
		)
		if not self.Placed then
			self.Placed = true
			self.Root.Position = UDim2.new(
				0.5,
				0,
				0.5,
				-math.floor((height + shadow) * State.UserScale / 2)
			)
		end
		self.UserScale.Scale = State.UserScale
		self.Sidebar.Size = UDim2.fromOffset(sidebar, bodyHeight)
		self.Main.Position = UDim2.fromOffset(sidebar, Config.Window.Topbar)
		self.Main.Size = UDim2.fromOffset(width - sidebar, bodyHeight)
		self.TabList:SetWidth(sidebar - 8 - 3)
		local pageWidth = width - sidebar
		for _, tab in ipairs(self.Tabs) do
			tab.PendingWidth = pageWidth
			tab:ApplyCompact(self.Compact)
		end
		if self.ActiveTab then
			self.ActiveTab:ApplyWidth()
		end
		for _, section in ipairs(self.Sections or {}) do
			section.Hidden = self.Compact
		end
		self.TabList:MarkDirty()
		self:ApplyChrome(width, height)
	end

	-- Compact landscape mode: hide user card and tab subtitle to maximize content height
	function Window:ApplyShort(height)
		local short = height < 430
		local header = short and 46 or Config.Window.Header
		self.UserCard.Visible = not short
		self.TabScroll.Size =
			UDim2.new(1, -8, 1, -(short and 8 or Config.Window.UserCard + 8))
		self.HeaderDesc.Visible = not short
		self.HeaderTitle.Position = UDim2.fromOffset(16, short and 11 or 10)
		self.SearchField.Position = UDim2.new(1, -16, 0, header / 2)
		self.PageHost.Position = UDim2.fromOffset(0, header)
		self.PageHost.Size = UDim2.new(1, 0, 1, -header)
	end

	function Window:ApplyChrome(width, height)
		self:ApplyShort(height)
		local narrow = width < 460
		self.SubtitlePill.Visible = self.SubTitle ~= "" and width >= 700
		self:RenderDecor()
		self.Emblem.Visible = width >= 380
		self.TitleHolder.Visible = width >= 340
		local searchWidth = self.Compact and (narrow and 110 or 140) or 200
		self.SearchField.Size =
			UDim2.fromOffset(searchWidth, Util.Metric("Box"))
		self.HeaderTitle.Size = UDim2.new(1, -(searchWidth + 44), 0, 26)
		self.HeaderDesc.Size = UDim2.new(1, -(searchWidth + 44), 0, 16)
		self.UserName.Visible = not self.Compact
		self.UserTag.Visible = not self.Compact
		self.Avatar.Position = UDim2.new(0, self.Compact and 10 or 12, 0.5, 0)
	end

	function Window:AddTabSection(text)
		local label = Draw.Text(
			{ Name = "Section" },
			"Body",
			Config.Text.Section - 1,
			"SidebarMuted"
		)
		Lang.Bind(label, text, "Text", string.upper)
		Draw.Padding(label, 6, 0, 0, 6)
		local item = self.TabList:Add(label, { Height = 24 })
		self.Sections = self.Sections or {}
		table.insert(self.Sections, item)
		item.Hidden = self.Compact
		return item
	end

	function Window:AddTab(name, icon, description)
		if type(name) == "table" and not name.EN and not name.TH then
			icon = name.Icon or icon
			description = name.Description or name.Desc or description
			name = name.Title or name.Name or name.Text or "Tab"
		end
		local tab = Tab.New(self, name, icon, description)
		table.insert(self.Tabs, tab)
		self:ApplyLayout()
		if not self.ActiveTab then
			self:SelectTab(tab)
		end
		return tab
	end

	function Window:SelectTab(tab)
		if type(tab) == "string" then
			for _, candidate in ipairs(self.Tabs) do
				if
					Lang.Resolve(candidate.Name) == tab
					or candidate.Name == tab
				then
					tab = candidate
					break
				end
			end
		end
		if type(tab) ~= "table" or tab == self.ActiveTab then
			return
		end
		Popup.Close()
		local previous = self.ActiveTab
		self.ActiveTab = tab
		if previous then
			previous.Page.Visible = false
			previous:RenderButton()
		end
		tab:ApplyWidth()
		tab.Page.Visible = true
		tab.Page.Position = UDim2.fromOffset(0, 18)
		Anim.Tween(tab.Page, { Position = UDim2.new() }, Config.Tween.Slide)
		tab:RenderButton()
		-- Restore and navigation artwork stays still; animate the content, not the icon.
		Lang.Bind(self.HeaderTitle, tab.Name)
		Lang.Bind(self.HeaderDesc, tab.Description or "")
		local titleY = self.HeaderDesc.Visible and 10 or 11
		self.HeaderTitle.Position = UDim2.fromOffset(28, titleY)
		Anim.Tween(
			self.HeaderTitle,
			{ Position = UDim2.fromOffset(16, titleY) },
			Config.Tween.Slide,
			"Out"
		)
		if (tab.FilteredQuery or "") ~= self.Query then
			self:ApplyFilter()
		elseif self.EmptyState then
			self.EmptyState.Visible = false
		end
		local cards = {}
		for _, box in ipairs(tab.Groupboxes) do
			if not box.Item.Filtered and not box.Item.Hidden then
				table.insert(cards, box.Card)
			end
		end
		Fx.StaggerRise(cards)
	end

	function Window:ApplyFilter()
		if self.ActiveTab and self.ActiveTab.ApplyLibraryFilter then
			if self.EmptyState then
				self.EmptyState.Visible = false
			end
			self.ActiveTab.ApplyLibraryFilter(self.Query)
			return
		end
		local tab = self.ActiveTab
		if not tab then
			return
		end
		local query = self.Query
		tab.FilteredQuery = query
		local visibleCount = 0
		local columnChanged = false
		for _, box in ipairs(tab.Groupboxes) do
			local titleMatch = query == ""
				or box.SearchTitle:find(query, 1, true) ~= nil
			local anyMatch = false
			local boxChanged = false
			for _, entry in ipairs(box.Items) do
				local filtered = not titleMatch
					and (
						entry.Search == nil
						or not entry.Search:find(query, 1, true)
					)
				if entry.Filtered ~= filtered then
					entry.Filtered = filtered
					boxChanged = true
				end
				anyMatch = anyMatch or (entry.Search ~= nil and not filtered)
			end
			local boxFiltered = not titleMatch and not anyMatch
			if box.Item.Filtered ~= boxFiltered then
				box.Item.Filtered = boxFiltered
				columnChanged = true
			end
			if not boxFiltered and not box.Item.Hidden then
				visibleCount += 1
			end
			if boxChanged then
				box:MarkDirty()
				box.Column:MarkDirty()
				columnChanged = true
			end
		end
		if columnChanged then
			tab:ApplyColumns()
		end
		if self.EmptyState then
			self.EmptyState.Visible = query ~= "" and visibleCount == 0
		end
	end

	function Window:SetVisible(visible)
		if visible == self.Visible then
			return
		end
		self.Visible = visible
		if visible then
			Util.Try(self.OnShow)
		end
		Popup.Close()
		if not visible then
			Dialog.Close()
			Sheet.Close()
		end
		Tooltip.Token = nil
		Tooltip.Frame.Visible = false
		Float.Render()
		self:RenderDecor()
		if visible then
			self.Root.Visible = true
			local destination = self.RestPosition or self.Root.Position
			if Float.Button and Float.Button.Visible then
				local dock = Float.Button.AbsolutePosition
					+ Float.Button.AbsoluteSize / 2
				self.Root.Position = UDim2.fromOffset(dock.X, dock.Y)
			end
			self.PopScale.Scale = 0.04
			Anim.Tween(
				self.Root,
				{ Position = destination },
				Config.Tween.Pop,
				"Back"
			)
			Anim.Tween(self.PopScale, { Scale = 1 }, Config.Tween.Pop, "Back")
			self:WaveTitle()
			Particles.Resume()
			return
		end
		if State.Touch and Float.Button and not Float.Button.Visible then
			Float.SetVisible(true)
		end
		self.RestPosition = self.Root.Position
		if Float.Button and Float.Button.Visible then
			local dock = Float.Button.AbsolutePosition
				+ Float.Button.AbsoluteSize / 2
			Anim.Tween(
				self.Root,
				{ Position = UDim2.fromOffset(dock.X, dock.Y) },
				0.2,
				"In"
			)
		end
		local shrink = Anim.Tween(self.PopScale, { Scale = 0.04 }, 0.2, "In")
		shrink.Completed:Once(function()
			if not self.Visible then
				self.Root.Visible = false
			end
		end)
	end

	function Window:Toggle()
		if not self.Ready then
			return
		end
		self:SetVisible(not self.Visible)
	end

	function Window:SetContentVisible(visible)
		self.Sidebar.Visible, self.Main.Visible, self.Ground.Visible =
			visible, visible, visible
	end

	function Window:SetMinimized(minimized)
		minimized = minimized == true
		if self.Minimized == minimized then
			return
		end
		self.Minimized = minimized
		Popup.Close()
		Dialog.Close()
		Sheet.Close()
		self:RenderDecor()
		if not minimized then
			self:SetContentVisible(true)
			self.TopbarFill.Visible, self.TopbarLine.Visible = true, true
		end
		Anim.Tween(
			self.TopbarFill,
			{ BackgroundTransparency = minimized and 1 or 0 },
			Config.Tween.Fast
		)
		Anim.Tween(
			self.TopbarLine,
			{ BackgroundTransparency = minimized and 1 or 0 },
			Config.Tween.Fast
		)
		Anim.Tween(
			self.ExpandBar,
			{ Size = UDim2.new(0, 3, minimized and 0.5 or 0, 0) },
			Config.Tween.Normal,
			"Back"
		)
		local shadow = Config.Window.Shadow
		local height = minimized and Config.Window.Topbar or self.Size.Y
		local tween = Anim.Tween(
			self.Root,
			{ Size = UDim2.fromOffset(self.Size.X + shadow, height + shadow) },
			0.34,
			"Out"
		)
		tween.Completed:Once(function()
			if self.Minimized ~= minimized then
				return
			end
			if minimized then
				self:SetContentVisible(false)
				self.TopbarFill.Visible, self.TopbarLine.Visible = false, false
			else
				Particles.Resume()
			end
		end)
	end

	function Window:SetScale(scale)
		State.UserScale = math.clamp(
			tonumber(scale) or 1,
			Config.ScaleRange.Min,
			Config.ScaleRange.Max
		)
		self:FitViewport()
	end

	function Tab.New(window, name, icon, description)
		local resolvedIcon = (icon and icon ~= "") and icon
			or Icons.FromTitle(name, "qblock")
		local tab = setmetatable({
			Window = window,
			Name = name,
			Icon = resolvedIcon,
			Description = description,
			Groupboxes = {},
		}, Tab)
		tab:BuildButton()
		tab:BuildPage()
		return tab
	end

	function Tab:BuildButton()
		local height = Util.Metric("Tab")
		local holder = Draw.New("TextButton", {
			Name = "Tab",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
		})
		local shade = Draw.Box("Frame", {
			Position = UDim2.fromOffset(0, 3),
			Size = UDim2.new(1, 0, 1, -3),
			BackgroundTransparency = 1,
			Parent = holder,
		}, "Shadow", nil, 10)
		local face = Draw.Box("Frame", {
			Size = UDim2.new(1, 0, 1, -3),
			BackgroundTransparency = 1,
			Parent = holder,
		}, "TabActive", nil, 10)
		local stroke = Draw.Stroke(face, "Outline", 2, true)
		stroke.Transparency = 1
		self.IconSlot = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.fromOffset(24, 24),
			Parent = face,
		})
		Icons.Create(self.IconSlot, self.Icon, 24, nil, self.Name)
		self.Label = Draw.Text({
			Position = UDim2.fromOffset(40, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = face,
		}, "Body", Util.TextSize("Label") + 1, "SidebarText", self.Name)
		self.Button, self.Face, self.Shade, self.Stroke =
			holder, face, shade, stroke
		holder.MouseEnter:Connect(function()
			self.Hovered = not State.Touch
			self:RenderButton()
		end)
		holder.MouseLeave:Connect(function()
			self.Hovered = false
			self:RenderButton()
		end)
		holder.Activated:Connect(function()
			self.Window:SelectTab(self)
		end)
		self.Window.TabList:Add(holder, { Height = height })
		Theme.OnRender(self, function()
			self:RenderButton(true)
		end)
		if self.Description then
			Tooltip.Attach(holder, self.Description)
		end
	end

	function Tab:RenderButton(instant)
		local active = self.Window.ActiveTab == self
		local duration = instant and 0 or Config.Tween.Normal
		local faceAlpha = active and 0 or (self.Hovered and 0.8 or 1)
		Anim.Tween(self.Face, { BackgroundTransparency = faceAlpha }, duration)
		Anim.Tween(
			self.Shade,
			{ BackgroundTransparency = active and 0 or 1 },
			duration
		)
		Anim.Tween(self.Stroke, { Transparency = active and 0 or 1 }, duration)
		Theme.Bind(
			self.Label,
			{ TextColor3 = active and "TabActiveText" or "SidebarText" }
		)
	end

	function Tab:Select()
		self.Window:SelectTab(self)
	end

	-- Defer layout calculation for inactive tabs until selected
	function Tab:ApplyWidth()
		local width = self.PendingWidth
		if not width then
			return
		end
		self.PendingWidth = nil
		self.Root:SetWidth(width - Config.Page.ScrollBar)
		self:ApplyColumns(width)
	end

	function Tab:ApplyCompact(compact)
		self.Label.Visible = not compact
		self.IconSlot.AnchorPoint = Vector2.new(compact and 0.5 or 0, 0.5)
		self.IconSlot.Position = compact and UDim2.fromScale(0.5, 0.5)
			or UDim2.new(0, 8, 0.5, 0)
	end

	function Tab:BuildPage()
		local page = Layout.ScrollFrame({
			Name = "Page",
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			Parent = self.Window.PageHost,
		})
		local gap = Config.Gap.Column
		self.Page = page
		self.Root = Container.New(page, {
			PadX = Config.Page.Pad,
			PadY = 6,
			GapX = gap,
			GapY = gap,
			Window = self.Window,
			Tab = self,
		})
		local leftHost =
			Draw.New("Frame", { Name = "Left", BackgroundTransparency = 1 })
		local rightHost =
			Draw.New("Frame", { Name = "Right", BackgroundTransparency = 1 })
		self.Left = Container.New(leftHost, { GapY = gap })
		self.Right = Container.New(rightHost, { GapY = gap })
		self.LeftItem = self.Root:Add(leftHost, {
			Width = 0.5,
			Height = function()
				return self.Left.ContentHeight
			end,
			Child = self.Left,
		})
		self.Root:SameLine()
		self.RightItem = self.Root:Add(rightHost, {
			Height = function()
				return self.Right.ContentHeight
			end,
			Child = self.Right,
		})
	end

	function Tab.ColumnHasVisible(column)
		for _, entry in ipairs(column.Items) do
			if not entry.Hidden and not entry.Filtered then
				return true
			end
		end
		return false
	end

	function Tab:ApplyColumns(pageWidth)
		self.PageWidth = pageWidth or self.PageWidth or 0
		local hasLeft = Tab.ColumnHasVisible(self.Left)
		local hasRight = Tab.ColumnHasVisible(self.Right)
		local single = self.PageWidth < Config.Window.TwoColumnMin
			or not hasLeft
			or not hasRight
		self.LeftItem.Hidden = not hasLeft
		self.RightItem.Hidden = not hasRight
		self.LeftItem.Width = (not single) and 0.5 or nil
		self.RightItem.SameLine = not single
		self.Root:MarkDirty()
	end

	function Tab:AddGroupbox(info, side)
		if type(info) ~= "table" or info.EN then
			info = { Name = info, Side = side }
		else
			info.Name = info.Name or info.Title or info.Text or ""
		end
		local column = info.Side == "Right" and self.Right or self.Left
		local shadow, header, radius =
			Config.Group.Shadow, Config.Group.Header, Config.Group.Radius
		local collapsed = info.Collapsed == true
		local initOpen = collapsed and 0 or 1
		local holder =
			Draw.New("Frame", { Name = "Groupbox", BackgroundTransparency = 1 })
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(shadow, shadow),
			Size = UDim2.new(1, -shadow, 1, -shadow),
			Parent = holder,
		}, "Shadow", nil, radius)
		local card = Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, -shadow, 1, -shadow), Parent = holder },
			"Panel",
			"Outline",
			radius,
			Config.Group.Stroke
		)
		local body = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, header),
			Size = UDim2.new(1, 0, 1, -header),
			ClipsDescendants = true,
			Visible = not collapsed,
			Parent = card,
		})
		local box = Container.New(body, {
			PadX = Config.Group.PadX,
			PadY = Config.Group.PadY,
			Window = self.Window,
			Tab = self,
		})
		setmetatable(box, Groupbox)
		box.Column, box.Card, box.Body, box.Collapsed, box.SearchTitle =
			column, card, body, collapsed, Lang.SearchText(info.Name)
		box.Open = Draw.New("NumberValue", { Value = initOpen })
		box:BuildHeader(card, info)
		box.Item = column:Add(holder, {
			Height = function()
				return header
					+ math.floor(box.ContentHeight * box.Open.Value)
					+ shadow
			end,
			Child = box,
			ChildInset = shadow,
		})
		box.Open.Changed:Connect(function(v)
			local show = v > 0.02
			box.Body.Visible = show
			if box.HeaderPatch then
				box.HeaderPatch.Visible = show
				box.HeaderPatch.BackgroundTransparency =
					math.clamp(1 - v * 1.4, 0, 1)
			end
			if box.HeaderDivider then
				box.HeaderDivider.Visible = show
				box.HeaderDivider.BackgroundTransparency =
					math.clamp(1 - v * 1.4, 0, 1)
			end
			column:MarkDirty()
		end)
		table.insert(self.Groupboxes, box)
		self:ApplyColumns()
		return box
	end

	function Tab:AddLeftGroupbox(name, icon, badge)
		return self:AddGroupbox({
			Name = name,
			Side = "Left",
			Icon = icon,
			Badge = badge,
		})
	end

	function Tab:AddRightGroupbox(name, icon, badge)
		return self:AddGroupbox({
			Name = name,
			Side = "Right",
			Icon = icon,
			Badge = badge,
		})
	end

	function Tab:EnsureGroup()
		if not self.DefaultGroup then
			self.DefaultGroup = self:AddLeftGroupbox(self.Name)
		end
		return self.DefaultGroup
	end

	Window.Tab = Window.AddTab
	Window.Section = Window.AddTabSection
	function Window:Dialog(spec)
		return Dialog.Show(spec)
	end
	function Window:Sheet(spec)
		return Sheet.Show(spec)
	end

	Tab.Section = Tab.AddGroupbox
	for _, method in ipairs({
		"AddToggle",
		"AddCheckbox",
		"AddSlider",
		"AddDropdown",
		"AddInput",
		"AddButton",
		"AddKeybind",
		"AddColorPicker",
		"AddLabel",
		"AddParagraph",
		"AddStepper",
		"AddRangeSlider",
		"AddSegmented",
		"AddStat",
		"AddStatus",
		"AddTable",
		"Toggle",
		"Checkbox",
		"Slider",
		"Dropdown",
		"Input",
		"Button",
		"Keybind",
		"Colorpicker",
		"Label",
		"Paragraph",
	}) do
		Tab[method] = function(tabSelf, ...)
			local grp = tabSelf:EnsureGroup()
			return grp[method](grp, ...)
		end
	end

	function Groupbox:BuildHeader(card, info)
		local height, radius = Config.Group.Header, Config.Group.Radius
		local collapsed = info.Collapsed == true
		local bar = Draw.Box("TextButton", {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, height),
			Parent = card,
		}, "PanelHeader", nil, radius)
		self.HeaderPatch = Draw.Box("Frame", {
			Position = UDim2.new(0, 0, 1, -radius),
			Size = UDim2.new(1, 0, 0, radius),
			Visible = not collapsed,
			BackgroundTransparency = collapsed and 1 or 0,
			Parent = bar,
		}, "PanelHeader")
		self.HeaderDivider = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 2,
			Visible = not collapsed,
			BackgroundTransparency = collapsed and 1 or 0,
			Parent = bar,
		}, "Outline")
		local iconSpec = (info.Icon and info.Icon ~= "") and info.Icon
			or Icons.FromTitle(info.Name, "qblock")
		local icon = Icons.Create(bar, iconSpec, 20, nil, info.Name)
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 10, 0.5, -1)
		local offset = 36
		local badgeWidth = 0
		if info.Badge then
			badgeWidth = #tostring(info.Badge) * 8 + 16
			local pill = Draw.Box("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -34, 0.5, -1),
				Size = UDim2.fromOffset(badgeWidth, 18),
				Parent = bar,
			}, "Danger", "DangerDark", 4, 2)
			Draw.Text({
				Size = UDim2.fromScale(1, 1),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = pill,
			}, "Body", 12, "OnAccent", tostring(info.Badge))
			badgeWidth += 6
		end
		Draw.Text({
			Position = UDim2.fromOffset(offset, 0),
			Size = UDim2.new(1, -(offset + 34 + badgeWidth), 1, -2),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = bar,
		}, "Body", Util.TextSize("Group"), "Text", info.Name or "")
		self.Chevron = Icons.Vector(bar, "chevron_down", 14, "Muted")
		self.Chevron.AnchorPoint = Vector2.new(1, 0.5)
		self.Chevron.Position = UDim2.new(1, -12, 0.5, 0)
		self.Chevron.Rotation = collapsed and -90 or 0
		bar.Activated:Connect(function()
			self:SetCollapsed(not self.Collapsed)
		end)
	end

	function Groupbox:SetCollapsed(collapsed)
		collapsed = collapsed == true
		if self.Collapsed == collapsed then
			return
		end
		self.Collapsed = collapsed
		if collapsed then
			Popup.Close()
		end
		Anim.Tween(
			self.Open,
			{ Value = collapsed and 0 or 1 },
			Config.Tween.Collapse
		)
		Anim.Tween(
			self.Chevron,
			{ Rotation = collapsed and -90 or 0 },
			Config.Tween.Collapse
		)
	end

	function Float.Clamp()
		local button = Float.Button
		if not button or not State.Gui then
			return
		end
		local viewport = State.Gui.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		local pos = button.Position
		local absX = viewport.X * pos.X.Scale + pos.X.Offset
		local absY = viewport.Y * pos.Y.Scale + pos.Y.Offset
		local size = Float.Size or 48
		local clampedX = math.clamp(absX, 6, math.max(6, viewport.X - size - 6))
		local clampedY = math.clamp(absY, 6, math.max(6, viewport.Y - size - 6))
		button.Position = UDim2.fromOffset(
			math.floor(clampedX + 0.5),
			math.floor(clampedY + 0.5)
		)
	end

	function Float.Build()
		local size = State.Touch and 56 or 48
		local button = Draw.New("TextButton", {
			Name = "Float",
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Position = UDim2.new(
				0,
				(scope and scope.Id ~= "Workspace") and 84 or 18,
				0.45,
				0
			),
			Size = UDim2.fromOffset(size, size),
			ZIndex = Config.Layer.Float,
			Visible = true,
			Parent = State.Gui,
		})
		local shadow = Draw.Box("Frame", {
			Position = UDim2.fromOffset(4, 4),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0.55,
			Parent = button,
		}, "Shadow", nil, 4)
		shadow.ZIndex = 1
		local slot = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			Parent = button,
		})
		Float.Button, Float.Slot, Float.Size = button, slot, size

		Float.Render()
		local moved = false
		Gui.Draggable(button, function(begin, delta)
			if not delta then
				moved = false
				return button.Position
			end
			moved = moved or delta.Magnitude > Config.DragThreshold
			if moved then
				button.Position = begin + UDim2.fromOffset(delta.X, delta.Y)
				Float.Clamp()
			end
			return begin
		end)
		button.Activated:Connect(function()
			if moved or not State.Window then
				return
			end
			State.Window:Toggle()
		end)
	end

	function Float.Render()
		if not Float.Slot then
			return
		end
		if not Float.Sprite then
			Float.Sprite = Draw.DrawnEmblem(Float.Slot, Float.Size)
			Float.Sprite.Name = "Block"
		end
	end

	function Float.SetVisible(visible)
		if Float.Button then
			Float.Button.Visible = visible
			if visible then
				Float.Clamp()
			end
		end
	end

	function Watermark.Build(title)
		local frame = Draw.Box("Frame", {
			Name = "Watermark",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 10),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 30),
			ZIndex = Config.Layer.Watermark,
			Parent = State.Gui,
		}, "Shadow", "Outline", 10, 2)
		frame.BackgroundTransparency = 0.25
		Draw.Padding(frame, 0, 12, 0, 8)
		Draw.List(
			frame,
			10,
			true,
			Enum.HorizontalAlignment.Left,
			Enum.VerticalAlignment.Center
		)
		local slot = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(18, 18),
			LayoutOrder = 1,
			Parent = frame,
		})
		local coin = Sprite.New(slot, "coin", 18)
		coin.AnchorPoint = Vector2.new(0.5, 0)
		coin.Position = UDim2.fromScale(0.5, 0)
		Anim.Loop(
			"Watermark",
			coin,
			{ Size = UDim2.fromOffset(3, 18) },
			0.45,
			"Sine",
			true
		)
		local name = Draw.Text({
			Text = title:upper(),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 20),
			LayoutOrder = 2,
			Parent = frame,
		}, "Logo", Config.Text.Watermark + 1, "Coin")
		Draw.Stroke(name, "Ink", 1.5)
		Watermark.Stats = {}
		for index, key in ipairs({ "Fps", "Ping", "Time" }) do
			Watermark.Stats[key] = Draw.Text({
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.fromOffset(0, 20),
				LayoutOrder = 2 + index,
				Parent = frame,
			}, "Body", Config.Text.Watermark, "White")
		end
		Watermark.Frame = frame
		Gui.Draggable(frame, function(begin, delta)
			if not delta then
				return frame.Position
			end
			frame.Position = begin + UDim2.fromOffset(delta.X, delta.Y)
			return begin
		end)
		Watermark.Update()
		Util.Every(0.5, Watermark.Update)
	end

	function Watermark.Update()
		if not Watermark.Frame or not Watermark.Frame.Visible then
			return
		end
		local ok, ping = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		local elapsed = math.floor(os.clock() - State.StartTime)
		Watermark.Stats.Fps.Text =
			string.format("FPS %d", math.floor(State.Fps + 0.5))
		Watermark.Stats.Ping.Text = ok
				and string.format("PING %dms", math.floor(ping + 0.5))
			or "PING --"
		Watermark.Stats.Time.Text = string.format(
			"%s %02d:%02d",
			Lang.Get("Session"),
			math.floor(elapsed / 60) % 100,
			elapsed % 60
		)
	end

	function Watermark.SetVisible(visible)
		if Watermark.Frame then
			Watermark.Frame.Visible = visible
			Anim.SetGroupActive("Watermark", visible)
			Watermark.Update()
		end
	end

	-- Ambient particle pool: reuses labels with a single tween per cycle; pauses when hidden
	function Particles.Build(parent)
		local layer = Draw.New("Frame", {
			Name = "Particles",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			ZIndex = 1,
			Parent = parent,
		})
		Particles.Layer = layer
		for _ = 1, Config.Particles.Count do
			local label = Draw.Text({
				AnchorPoint = Vector2.new(0.5, 0.5),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTransparency = 1,
				Parent = layer,
			}, "Glyph", 12, "ParticleColor")
			table.insert(Particles.Pool, { Label = label, Busy = false })
		end
		Theme.OnRender(Particles, Particles.Restyle)
	end

	function Particles.Restyle()
		for _, entry in ipairs(Particles.Pool) do
			entry.Label.Text = Particles.Glyph()
		end
	end

	function Particles.Glyph()
		local glyphs = Theme.Colors.ParticleGlyphs
		if glyphs and #glyphs > 1 then
			return glyphs[math.random(#glyphs)]
		end
		return Theme.Colors.ParticleGlyph or "✦"
	end

	function Particles.Active()
		local window = State.Window
		return Particles.Enabled
			and window ~= nil
			and window.Visible
			and not window.Minimized
	end

	function Particles.Launch(entry, delay)
		if not Particles.Active() or not entry.Label.Parent then
			entry.Busy = false
			return
		end
		entry.Busy = true
		local label = entry.Label
		label.Text = Particles.Glyph()
		local fall = Theme.Colors.ParticleFall == true
		local size = math.random(9, 16)
		local x = math.random()
		label.Size = UDim2.fromOffset(size + 4, size + 4)
		label.TextSize = size
		label.Rotation = 0
		label.TextTransparency = 0.35 + math.random() * 0.4
		label.Position = UDim2.new(x, 0, fall and -0.06 or 1.06, 0)
		local goal = {
			Position = UDim2.new(
				x + (math.random() - 0.5) * 0.15,
				0,
				fall and 1.06 or -0.06,
				0
			),
			Rotation = math.random(-120, 120),
		}
		local duration = Config.Particles.MinTime
			+ math.random()
				* (Config.Particles.MaxTime - Config.Particles.MinTime)
		local tween =
			Anim.Tween(label, goal, duration, "Linear", 0, false, delay or 0)
		tween.Completed:Once(function()
			Particles.Launch(entry)
		end)
	end

	function Particles.Resume()
		for index, entry in ipairs(Particles.Pool) do
			if not entry.Busy then
				Particles.Launch(entry, (index - 1) * 0.9)
			end
		end
	end

	function Particles.SetEnabled(enabled)
		Particles.Enabled = enabled and not State.ReducedMotion
		if Particles.Layer then
			Particles.Layer.Visible = enabled
		end
		if enabled then
			Particles.Resume()
		end
	end

	Notify.Icons = {
		Info = "qblock",
		Success = "star",
		Warning = "bomb",
		Error = "bomb",
		Coin = "coin",
		Power = "mushroom",
	}

	function Notify.Build()
		local width = State.Touch and Config.Notify.TouchWidth
			or Config.Notify.Width
		State.NotifyHost = Draw.New("Frame", {
			Name = "Notifications",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -14, 1, -14),
			Size = UDim2.new(0, width + 8, 1, -28),
			ZIndex = Config.Layer.Notify,
			Parent = State.Gui,
		})
		Draw.List(
			State.NotifyHost,
			Config.Notify.Gap,
			false,
			Enum.HorizontalAlignment.Right,
			Enum.VerticalAlignment.Bottom
		)
	end

	function Notify.Push(title, content, duration, kind)
		local width = State.NotifyHost.Size.X.Offset - 8
		local text = Lang.Resolve(content or "")
		local textHeight = Layout.Measure(
			text,
			Fonts.Size("Desc", Util.TextSize("Desc") + 1),
			"Desc",
			width - 68
		).Y
		local height = math.max(58, textHeight + 44)
		local holder = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(width + 8, height + 4),
			ClipsDescendants = false,
			Parent = State.NotifyHost,
		})
		local card = Draw.New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(width + 60, 0),
			Size = UDim2.fromOffset(width, height),
			Parent = holder,
		})
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(4, 4),
			Size = UDim2.fromScale(1, 1),
			Parent = card,
		}, "Shadow", nil, 12)
		local face = Draw.Box("Frame", {
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			Parent = card,
		}, "Panel", "Outline", 12, 2)
		local icon =
			Sprite.New(face, Notify.Icons[kind or "Coin"] or "coin", 36)
		icon.Position = UDim2.fromOffset(12, 11)
		Draw.Text({
			Position = UDim2.fromOffset(58, 9),
			Size = UDim2.new(1, -68, 0, 18),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = face,
		}, "Body", Util.TextSize("Group"), "Text", title or "Nullx11")
		Draw.Text({
			Text = text,
			TextWrapped = true,
			TextYAlignment = Enum.TextYAlignment.Top,
			Position = UDim2.fromOffset(58, 29),
			Size = UDim2.new(1, -68, 0, textHeight),
			Parent = face,
		}, "Desc", Util.TextSize("Desc") + 1, "SubText")
		local timer = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 4),
			Parent = face,
		}, "Accent")
		duration = duration or Config.Notify.Duration
		Anim.Tween(
			card,
			{ Position = UDim2.fromOffset(0, 0) },
			Config.Tween.Notify,
			"Back"
		)
		Anim.Tween(timer, { Size = UDim2.new(0, 0, 0, 4) }, duration, "Linear")
		Anim.Bump(icon, 6)
		local closed = false
		local function Dismiss()
			if closed then
				return
			end
			closed = true
			local slide = Anim.Tween(
				card,
				{ Position = UDim2.fromOffset(width + 60, 0) },
				0.22,
				"In"
			)
			slide.Completed:Once(function()
				local collapse = Anim.Tween(
					holder,
					{ Size = UDim2.fromOffset(width + 8, 0) },
					0.16
				)
				collapse.Completed:Once(function()
					holder:Destroy()
				end)
			end)
		end
		card.Activated:Connect(Dismiss)
		task.delay(duration, Dismiss)
	end

	-- Stage loader screen: mini level progress bar synced to font loading and window build
	Intro.Width, Intro.Height, Intro.Ground = 600, 320, 44
	Intro.MinStep = 0.22
	Intro.StepTimeout = 15

	--@param settings { Title, SubTitle, Steps = { { Label, Run } }, OnDone }
	function Intro.Play(settings)
		local screen = Draw.New("Frame", {
			Name = "Loader",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = Config.Layer.Intro,
			Parent = State.Gui,
		})
		local ok = Util.Try(Intro.Show, settings, screen)
		screen:Destroy()
		if Library.Unloaded then
			return
		end
		if not ok and not settings.Ran then
			Intro.RunSteps(settings, nil)
		end
		Util.Try(settings.OnDone)
	end

	function Intro.Show(settings, screen)
		Anim.Tween(screen, { BackgroundTransparency = 0.35 }, 0.3)
		local card, scene, scale = Intro.BuildCard(screen)
		Intro.BuildScenery(scene)
		local block = Sprite.New(scene, "qblock", 48)
		block.AnchorPoint = Vector2.new(0.5, 0)
		block.Position = UDim2.new(0.5, 0, 0, -70)
		local letters = Intro.Letters(scene, settings.Title)
		local pill = Intro.Pill(scene, settings.SubTitle)
		local track = Intro.Track(scene)
		Anim.Tween(scale, { Scale = State.UserScale }, 0.45, "Back")
		Anim.Tween(
			block,
			{ Position = UDim2.new(0.5, 0, 0, 22) },
			0.4,
			"Bounce"
		)
		task.wait(0.42)
		Intro.HitBlock(scene, block)
		Intro.DropLetters(letters, pill)
		Intro.RunSteps(settings, track)
		if Library.Unloaded then
			return
		end
		Intro.Finale(scene, track)
		task.wait(0.3)
		Anim.Tween(scale, { Scale = State.UserScale * 1.06 }, 0.2, "In")
		card.Visible = false
		Anim.Tween(screen, { BackgroundTransparency = 1 }, 0.2)
		task.wait(0.2)
	end

	function Intro.BuildCard(screen)
		local width, height = Intro.Width, Intro.Height
		local pad, shadow = 4, 6
		local card = Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(
				width + pad + shadow,
				height + pad + shadow
			),
			BackgroundTransparency = 1,
			Parent = screen,
		})
		local scale = Draw.New(
			"UIScale",
			{ Scale = State.UserScale * 0.6, Parent = card }
		)
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(pad + shadow, pad + shadow),
			Size = UDim2.fromOffset(width, height),
			Parent = card,
		}, "Shadow", nil, 18)
		local scene = Draw.Box("Frame", {
			Position = UDim2.fromOffset(pad, pad),
			Size = UDim2.fromOffset(width, height),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			ClipsDescendants = true,
			Parent = card,
		}, nil, nil, 18)
		local gradient = Draw.New("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new(
				Theme.Colors.Topbar,
				Theme.Colors.Backdrop
			),
			Parent = scene,
		})
		gradient.Enabled = true
		local border = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(pad, pad),
			Size = UDim2.fromOffset(width, height),
			ZIndex = 20,
			Parent = card,
		})
		Draw.Corner(border, 18)
		Draw.Stroke(border, "Outline", 3, true)
		return card, scene, scale
	end

	function Intro.BuildScenery(scene)
		local ground = Intro.Ground
		local sky = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -ground),
			ClipsDescendants = true,
			ZIndex = 1,
			Parent = scene,
		})
		for _, hill in ipairs({
			{ 0.14, 150, "GrassDark" },
			{ 0.3, 90, "Grass" },
			{ 0.8, 120, "GrassDark" },
		}) do
			local mound = Draw.Box("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(hill[1], 0, 1, 0),
				Size = UDim2.fromOffset(hill[2], hill[2]),
				BackgroundTransparency = 0.35,
				Parent = sky,
			}, hill[3], nil, UDim.new(1, 0))
			mound.ZIndex = 1
		end
		for index, spot in ipairs({
			{ 0.12, 30, 64 },
			{ 0.62, 18, 50 },
			{ 0.84, 64, 40 },
		}) do
			local cloud = Draw.Cloud(sky, spot[3])
			cloud.Position = UDim2.new(spot[1], 0, 0, spot[2])
			cloud.ZIndex = 1
			Anim.Tween(
				cloud,
				{ Position = UDim2.new(spot[1], 36, 0, spot[2]) },
				5 + index,
				"Sine",
				-1,
				true
			)
		end
		local floor = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, ground),
			ClipsDescendants = true,
			ZIndex = 3,
			Parent = scene,
		}, "Brick", nil, 18)
		Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 18), ZIndex = 3, Parent = floor },
			"Brick"
		)
		local bricks = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(6, 10),
			Size = UDim2.new(1, -12, 1, -14),
			ClipsDescendants = true,
			ZIndex = 3,
			Parent = floor,
		})
		Draw.Bricks(bricks, 18, "BrickDark")
		for _, line in ipairs(bricks:GetChildren()) do
			line.ZIndex = 3
		end
		Draw.Box(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 8), ZIndex = 4, Parent = floor },
			"Grass"
		)
		Draw.Box("Frame", {
			Position = UDim2.fromOffset(0, 8),
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 4,
			Parent = floor,
		}, "GrassDark")
	end

	function Intro.Letters(scene, title)
		local row = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 92),
			Size = UDim2.fromOffset(Intro.Width, 54),
			ZIndex = 5,
			Parent = scene,
		})
		Draw.List(
			row,
			2,
			true,
			Enum.HorizontalAlignment.Center,
			Enum.VerticalAlignment.Center
		)
		local letters = {}
		local size, colorIndex = 46, 0
		for char in tostring(title):upper():gmatch(utf8.charpattern) do
			local bounds = Layout.Measure(char, size, "Logo", 300)
			local slot = Draw.New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(
					char == " " and 14 or bounds.X,
					size + 8
				),
				LayoutOrder = #letters + 1,
				ZIndex = 5,
				Parent = row,
			})
			local letter = Draw.Text(
				{
					Text = char,
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(0, -140),
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 5,
					Parent = slot,
				},
				"Logo",
				size,
				Config.TitleColors[colorIndex % #Config.TitleColors + 1]
			)
			Draw.Stroke(letter, "Ink", 3)
			table.insert(letters, letter)
			colorIndex += char == " " and 0 or 1
		end
		return letters
	end

	function Intro.Pill(scene, text)
		local pill = Draw.Box("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 156),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 26),
			BackgroundTransparency = 1,
			ZIndex = 5,
			Parent = scene,
		}, "Shadow", nil, UDim.new(1, 0))
		Draw.Padding(pill, 0, 14, 0, 14)
		local label = Draw.Text({
			Text = "WORLD 1-1"
				.. ((text and text ~= "") and ("  ·  " .. text) or ""),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			TextTransparency = 1,
			ZIndex = 6,
			Parent = pill,
		}, "Body", 14, "White")
		return { Frame = pill, Label = label }
	end

	function Intro.Track(scene)
		local ground = Intro.Ground
		local status = Draw.Text({
			Position = UDim2.new(0, 22, 1, -(ground + 58)),
			Size = UDim2.new(1, -120, 0, 20),
			ZIndex = 6,
			Parent = scene,
		}, "Body", 15, "White")
		Draw.Stroke(status, "Ink", 1.5)
		local percent = Draw.Text({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -22, 1, -(ground + 60)),
			Size = UDim2.fromOffset(80, 22),
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = "0%",
			ZIndex = 6,
			Parent = scene,
		}, "Logo", 20, "Coin")
		Draw.Stroke(percent, "Ink", 2)
		local flag = Sprite.New(scene, "flag", 36)
		flag.AnchorPoint = Vector2.new(1, 1)
		flag.Position = UDim2.new(1, -18, 1, -ground)
		flag.ZIndex = 5
		local runner = Draw.New("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 18, 1, -ground),
			Size = UDim2.fromOffset(28, 28),
			ZIndex = 6,
			Parent = scene,
		})
		local body = Sprite.New(runner, "mushroom", 24)
		body.Position = UDim2.fromOffset(2, 4)
		Anim.Tween(
			body,
			{ Position = UDim2.fromOffset(2, 0) },
			0.16,
			"Sine",
			-1,
			true
		)
		local progress = Draw.New("NumberValue", { Value = 0 })
		progress.Changed:Connect(function(value)
			percent.Text = math.floor(value * 100 + 0.5) .. "%"
			runner.Position =
				UDim2.new(0, 18 + (Intro.Width - 100) * value, 1, -ground)
		end)
		return {
			Status = status,
			Progress = progress,
			Flag = flag,
			Runner = runner,
		}
	end

	function Intro.HitBlock(scene, block)
		Anim.Bump(block, 14)
		Anim.CoinPop(scene, UDim2.new(0.5, 0, 0, 22), 30)
		task.delay(0.1, function()
			local used = Sprite.New(scene, "used", 48)
			used.AnchorPoint, used.Position, used.ZIndex =
				block.AnchorPoint, UDim2.new(0.5, 0, 0, 22), block.ZIndex
			block:Destroy()
		end)
	end

	function Intro.DropLetters(letters, pill)
		for index, letter in ipairs(letters) do
			Anim.Tween(
				letter,
				{ Position = UDim2.new() },
				0.55,
				"Bounce",
				0,
				false,
				index * 0.05
			)
		end
		Anim.Tween(
			pill.Frame,
			{ BackgroundTransparency = 0.45 },
			0.3,
			"Out",
			0,
			false,
			0.4
		)
		Anim.Tween(
			pill.Label,
			{ TextTransparency = 0 },
			0.3,
			"Out",
			0,
			false,
			0.4
		)
	end

	---@param track table?  nil = run the remaining steps without drawing
	function Intro.RunSteps(settings, track)
		local steps = settings.Steps
		for index, step in ipairs(steps) do
			if Library.Unloaded then
				return
			end
			if step.Started then
				continue
			end
			step.Started = true
			if track then
				track.Status.Text = Lang.Resolve(step.Label)
			end
			local started = os.clock()
			if step.Run then
				Util.Await(Intro.StepTimeout, step.Run)
			end
			if not track then
				continue
			end
			Anim.Tween(track.Progress, { Value = index / #steps }, 0.2, "Out")
			local remaining = Intro.MinStep - (os.clock() - started)
			if remaining > 0 then
				task.wait(remaining)
			end
		end
		settings.Ran = true
	end

	function Intro.Finale(scene, track)
		Anim.Bump(track.Flag, 10)
		local origin = UDim2.new(1, -36, 1, -(Intro.Ground + 30))
		for index = 1, 8 do
			local angle = math.rad(index * 45)
			local star = Sprite.New(scene, "star", 18)
			star.AnchorPoint = Vector2.new(0.5, 0.5)
			star.Position = origin
			star.ZIndex = 7
			local fly = Anim.Tween(star, {
				Position = origin + UDim2.fromOffset(
					math.cos(angle) * 70,
					math.sin(angle) * 70
				),
				Rotation = 180,
			}, 0.5, "Out")
			fly.Completed:Once(function()
				star:Destroy()
			end)
		end
	end

	-- Pure GuiObject ESP engine (no Drawing API dependency); scripts supply a target Provider
	local Visuals = {
		Settings = {
			Enabled = false,
			Preview = false,
			Box = true,
			BoxStyle = "Full",
			BoxFill = false,
			Name = true,
			Health = true,
			HealthText = false,
			Distance = true,
			Tracer = false,
			TracerOrigin = "Bottom",
			HeadDot = false,
			Chams = false,
			Arrows = false,
			Radar = false,
			RadarRange = 250,
			RadarSize = 180,
			TeamCheck = true,
			MaxDistance = 2000,
			TextSize = 13,
			EnemyColor = Color3.fromRGB(232, 88, 76),
			FriendColor = Color3.fromRGB(96, 196, 120),
		},
		Entries = {},
		Targets = {},
		Provider = nil,
		LastScan = 0,
		ScanInterval = 0.2,
		Preview = {},
	}

	function Visuals.DefaultProvider()
		local targets = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player == LocalPlayer then
				continue
			end
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				targets[#targets + 1] = {
					Model = char,
					Name = player.DisplayName,
					Health = hum.Health,
					MaxHealth = hum.MaxHealth,
					Friendly = player.Team ~= nil
						and player.Team == LocalPlayer.Team,
				}
			end
		end
		return targets
	end

	function Visuals.EnsureGui()
		if Visuals.Gui and Visuals.Gui.Parent then
			return Visuals.Gui
		end
		Visuals.Gui = Draw.New("ScreenGui", {
			Name = "MarioVisuals",
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = 5,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = Util.GuiParent(),
		})
		return Visuals.Gui
	end

	function Visuals.Line(parent, color)
		return Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color,
			Visible = false,
			Parent = parent,
		})
	end

	function Visuals.Label(parent, alignY)
		local label = Draw.New("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, alignY),
			Size = UDim2.fromOffset(200, 16),
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0.35,
			Visible = false,
			Parent = parent,
		})
		return label
	end

	--@return table Reusable GUI elements for a single ESP target
	function Visuals.BuildEntry(parent)
		local entry = {}
		entry.Box = Draw.New(
			"Frame",
			{ BackgroundTransparency = 1, Visible = false, Parent = parent }
		)
		entry.BoxStroke =
			Draw.New("UIStroke", { Thickness = 1.5, Parent = entry.Box })
		entry.BoxOutline = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(-1, -1),
			Size = UDim2.new(1, 2, 1, 2),
			Parent = entry.Box,
		})
		Draw.New("UIStroke", {
			Thickness = 1,
			Color = Color3.new(0, 0, 0),
			Transparency = 0.3,
			Parent = entry.BoxOutline,
		})
		entry.Corners = {}
		for index = 1, 8 do
			entry.Corners[index] = Draw.New(
				"Frame",
				{ BorderSizePixel = 0, Visible = false, Parent = parent }
			)
		end
		entry.HealthBack = Draw.New("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.35,
			Visible = false,
			Parent = parent,
		})
		entry.HealthFill = Draw.New("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Parent = entry.HealthBack,
		})
		entry.HealthText = Visuals.Label(parent, 0.5)
		entry.Name = Visuals.Label(parent, 1)
		entry.Distance = Visuals.Label(parent, 0)
		entry.Tracer = Visuals.Line(parent, Color3.new(1, 1, 1))
		entry.Dot = Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(6, 6),
			Visible = false,
			Parent = parent,
		})
		Draw.Corner(entry.Dot, 3)
		entry.Arrow = Visuals.Label(parent, 0.5)
		entry.Arrow.Text = "▲"
		entry.Arrow.Size = UDim2.fromOffset(20, 20)
		return entry
	end

	function Visuals.HideEntry(entry)
		entry.Box.Visible = false
		for _, corner in ipairs(entry.Corners) do
			corner.Visible = false
		end
		entry.HealthBack.Visible, entry.HealthText.Visible = false, false
		entry.Name.Visible, entry.Distance.Visible = false, false
		entry.Tracer.Visible, entry.Dot.Visible, entry.Arrow.Visible =
			false, false, false
		if entry.Highlight then
			entry.Highlight.Enabled = false
		end
	end

	function Visuals.DestroyEntry(entry)
		for _, key in ipairs({
			"Box",
			"HealthBack",
			"HealthText",
			"Name",
			"Distance",
			"Tracer",
			"Dot",
			"Arrow",
			"Highlight",
		}) do
			if entry[key] then
				entry[key]:Destroy()
			end
		end
		for _, corner in ipairs(entry.Corners) do
			corner:Destroy()
		end
	end

	function Visuals.SetLine(line, from, to, thickness)
		local delta = to - from
		line.Position =
			UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
		line.Size = UDim2.fromOffset(delta.Magnitude, thickness)
		line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		line.Visible = true
	end

	-- Position 2D box, bars, and labels from bounding rect (shared by live ESP and preview)
	function Visuals.Layout(entry, x, y, w, h, info, color, origin)
		local settings = Visuals.Settings
		local full = settings.Box and settings.BoxStyle ~= "Corner"
		entry.Box.Visible = full
		if full then
			entry.Box.Position, entry.Box.Size =
				UDim2.fromOffset(x, y), UDim2.fromOffset(w, h)
			entry.BoxStroke.Color = color
			entry.Box.BackgroundTransparency = settings.BoxFill and 0.82 or 1
			entry.Box.BackgroundColor3 = color
		end

		local corner = settings.Box and settings.BoxStyle == "Corner"
		local cw, ch = math.max(w / 4, 3), math.max(h / 5, 3)
		local spots = {
			{ x, y, cw, 2 },
			{ x, y, 2, ch },
			{ x + w - cw, y, cw, 2 },
			{ x + w - 2, y, 2, ch },
			{ x, y + h - 2, cw, 2 },
			{ x, y + h - ch, 2, ch },
			{ x + w - cw, y + h - 2, cw, 2 },
			{ x + w - 2, y + h - ch, 2, ch },
		}
		for index, piece in ipairs(entry.Corners) do
			piece.Visible = corner
			if corner then
				local spot = spots[index]
				piece.Position, piece.Size, piece.BackgroundColor3 =
					UDim2.fromOffset(spot[1], spot[2]),
					UDim2.fromOffset(spot[3], spot[4]),
					color
			end
		end

		local ratio = math.clamp(
			(info.Health or 0) / math.max(info.MaxHealth or 100, 1),
			0,
			1
		)
		entry.HealthBack.Visible = settings.Health
		if settings.Health then
			entry.HealthBack.Position, entry.HealthBack.Size =
				UDim2.fromOffset(x - 6, y), UDim2.fromOffset(3, h)
			entry.HealthFill.Size = UDim2.fromScale(1, ratio)
			entry.HealthFill.BackgroundColor3 = Color3.fromRGB(232, 88, 76)
				:Lerp(Color3.fromRGB(96, 214, 110), ratio)
		end
		entry.HealthText.Visible = settings.HealthText
		if settings.HealthText then
			local hpInt = math.floor(info.Health or 0)
			if entry.LastHp ~= hpInt then
				entry.LastHp = hpInt
				entry.HealthText.Text = tostring(hpInt)
			end
			entry.HealthText.TextSize = settings.TextSize - 2
			entry.HealthText.Position =
				UDim2.fromOffset(x - 20, y + h * (1 - ratio))
		end

		entry.Name.Visible = settings.Name
		if settings.Name then
			local nameStr = info.Name or ""
			if entry.LastName ~= nameStr then
				entry.LastName = nameStr
				entry.Name.Text = nameStr
			end
			entry.Name.TextSize, entry.Name.TextColor3 =
				settings.TextSize, color
			entry.Name.Position = UDim2.fromOffset(x + w / 2, y - 2)
		end
		entry.Distance.Visible = settings.Distance and info.Distance ~= nil
		if entry.Distance.Visible then
			local distInt = math.floor(info.Distance)
			if entry.LastDist ~= distInt then
				entry.LastDist = distInt
				entry.Distance.Text = distInt .. "m"
			end
			entry.Distance.TextSize = settings.TextSize - 1
			entry.Distance.Position = UDim2.fromOffset(x + w / 2, y + h + 2)
		end

		entry.Dot.Visible = settings.HeadDot
		if settings.HeadDot then
			entry.Dot.Position, entry.Dot.BackgroundColor3 =
				UDim2.fromOffset(x + w / 2, y + h * 0.1), color
		end

		if settings.Tracer and origin then
			entry.Tracer.BackgroundColor3 = color
			Visuals.SetLine(
				entry.Tracer,
				origin,
				Vector2.new(x + w / 2, y + h),
				1.5
			)
		else
			entry.Tracer.Visible = false
		end
	end

	function Visuals.TracerOrigin(viewport)
		local mode = Visuals.Settings.TracerOrigin
		if mode == "Center" then
			return viewport / 2
		end
		if mode == "Mouse" then
			return UserInputService:GetMouseLocation()
		end
		return Vector2.new(viewport.X / 2, viewport.Y)
	end

	function Visuals.Chams(entry, model, color, on)
		if not on then
			if entry.Highlight then
				entry.Highlight.Enabled = false
			end
			return
		end
		if not entry.Highlight then
			entry.Highlight = Draw.New("Highlight", {
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
				FillTransparency = 0.55,
				OutlineTransparency = 0,
				Parent = Visuals.EnsureGui(),
			})
		end
		entry.Highlight.Adornee = model
		entry.Highlight.FillColor, entry.Highlight.OutlineColor = color, color
		entry.Highlight.Enabled = true
	end

	function Visuals.Arrow(entry, screen, viewport, color)
		local center = viewport / 2
		local dir = Vector2.new(screen.X, screen.Y) - center
		if screen.Z < 0 then
			dir = -dir
		end
		if dir.Magnitude < 1 then
			return
		end
		local unit = dir.Unit
		local radius = math.min(viewport.X, viewport.Y) / 2 - 40
		local pos = center + unit * radius
		entry.Arrow.Position = UDim2.fromOffset(pos.X, pos.Y)
		entry.Arrow.Rotation = math.deg(math.atan2(unit.Y, unit.X)) + 90
		entry.Arrow.TextColor3 = color
		entry.Arrow.TextSize = 18
		entry.Arrow.Visible = true
	end

	function Visuals.Scan()
		local now = os.clock()
		if now - Visuals.LastScan < Visuals.ScanInterval then
			return
		end
		Visuals.LastScan = now
		local ok, list = pcall(Visuals.Provider or Visuals.DefaultProvider)
		Visuals.Targets = ok and type(list) == "table" and list or {}
	end

	function Visuals.Render()
		local settings = Visuals.Settings
		if not settings.Enabled then
			return
		end
		Visuals.Scan()
		local cam = Workspace.CurrentCamera
		if not cam then
			return
		end
		local gui = Visuals.EnsureGui()
		local viewport = cam.ViewportSize
		local origin = Visuals.TracerOrigin(viewport)
		local camPos = cam.CFrame.Position
		local seen = {}

		for _, info in ipairs(Visuals.Targets) do
			local model = info.Model
			if typeof(model) ~= "Instance" or not model.Parent then
				continue
			end
			if settings.TeamCheck and info.Friendly then
				continue
			end
			local root = info.Root
				or model:FindFirstChild("HumanoidRootPart")
				or model.PrimaryPart
			if not root then
				continue
			end
			local distance = (root.Position - camPos).Magnitude
			if distance > settings.MaxDistance then
				continue
			end

			seen[model] = true
			local entry = Visuals.Entries[model]
			if not entry then
				entry = Visuals.BuildEntry(gui)
				Visuals.Entries[model] = entry
			end
			local color = info.Color
				or (
					info.Friendly and settings.FriendColor
					or settings.EnemyColor
				)
			Visuals.Chams(
				entry,
				info.Adornee or model,
				color,
				settings.Chams and (info.Adornee ~= false)
			)

			local top, onTop =
				cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
			local bottom, onBottom =
				cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
			if not (onTop and onBottom) then
				Visuals.HideEntry(entry)
				if settings.Chams and entry.Highlight then
					entry.Highlight.Enabled = true
				end
				if settings.Arrows then
					Visuals.Arrow(
						entry,
						cam:WorldToViewportPoint(root.Position),
						viewport,
						color
					)
				end
				continue
			end
			entry.Arrow.Visible = false
			local h = math.max(bottom.Y - top.Y, 4)
			local w = h * 0.55
			info.Distance = distance
			Visuals.Layout(
				entry,
				top.X - w / 2,
				top.Y,
				w,
				h,
				info,
				color,
				origin
			)
		end

		for model, entry in pairs(Visuals.Entries) do
			if not seen[model] then
				if model.Parent then
					Visuals.HideEntry(entry)
				else
					Visuals.DestroyEntry(entry)
					Visuals.Entries[model] = nil
				end
			end
		end
	end

	function Visuals.ClearAll()
		for model, entry in pairs(Visuals.Entries) do
			Visuals.DestroyEntry(entry)
			Visuals.Entries[model] = nil
		end
	end

	function Visuals:SetProvider(provider)
		self.Provider = provider
		self.LastScan = 0
	end

	function Visuals:Set(key, value)
		self.Settings[key] = value
		if key == "Enabled" and not value then
			Visuals.ClearAll()
		elseif key == "Preview" then
			Visuals.PreviewSetVisible(value)
		end
		Visuals.PreviewRender()
	end

	function Visuals:Get(key)
		return self.Settings[key]
	end

	function Visuals:SetEnabled(on)
		self:Set("Enabled", on == true)
	end

	function Visuals:SetPreview(on)
		self:Set("Preview", on == true)
	end

	-- Right-side ESP preview card: clones local character into ViewportFrame with live ESP overlay
	function Visuals.PreviewBuild()
		local window = State.Window
		if not window or Visuals.Preview.Frame then
			return
		end
		local panel = Draw.Box("Frame", {
			Name = "EspPreview",
			Position = UDim2.new(1, 6, 0, 0),
			Size = UDim2.new(0, 230, 1, -Config.Window.Shadow),
			BackgroundTransparency = 0,
			Visible = false,
			ClipsDescendants = true,
			Parent = window.Root,
		}, "Backdrop", "Outline", Config.Window.Radius, Config.Window.Stroke)
		local title = Draw.Text(
			{
				Position = UDim2.fromOffset(12, 8),
				Size = UDim2.new(1, -24, 0, 22),
			},
			"Display",
			Util.TextSize("Group"),
			"Text",
			{ EN = "ESP Preview", TH = "ตัวอย่าง ESP" }
		)
		title.Parent = panel
		local view = Draw.New("ViewportFrame", {
			Position = UDim2.fromOffset(10, 38),
			Size = UDim2.new(1, -20, 1, -48),
			BackgroundColor3 = Color3.fromRGB(18, 18, 24),
			BackgroundTransparency = 0.15,
			Ambient = Color3.fromRGB(180, 180, 190),
			LightColor = Color3.new(1, 1, 1),
			Parent = panel,
		})
		Draw.Corner(view, 8)
		local cam = Draw.New("Camera", { FieldOfView = 40, Parent = view })
		view.CurrentCamera = cam
		local overlay = Draw.New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 3,
			Parent = view,
		})
		Visuals.Preview = {
			Frame = panel,
			View = view,
			Camera = cam,
			Overlay = overlay,
			Entry = Visuals.BuildEntry(overlay),
			Angle = 0,
		}
		Util.Connect(
			view:GetPropertyChangedSignal("AbsoluteSize"),
			Visuals.PreviewRender
		)
		Util.Connect(
			window.Root:GetPropertyChangedSignal("Size"),
			Visuals.PreviewRender
		)
	end

	function Visuals.PreviewModel()
		local preview = Visuals.Preview
		if preview.Model and preview.Model.Parent then
			return preview.Model
		end
		local char = LocalPlayer.Character
		if not char then
			return nil
		end
		local archivable = char.Archivable
		char.Archivable = true
		local ok, clone = pcall(char.Clone, char)
		char.Archivable = archivable
		if not ok or not clone then
			return nil
		end
		for _, item in ipairs(clone:GetDescendants()) do
			if
				item:IsA("LuaSourceContainer")
				or item:IsA("Sound")
				or item:IsA("ForceField")
			then
				item:Destroy()
			elseif item:IsA("BasePart") then
				item.Anchored = true
				item:SetAttribute("MarioColor", item.Color)
			end
		end
		clone:PivotTo(CFrame.new())
		clone.Parent = preview.View
		local box, size = clone:GetBoundingBox()
		preview.Model, preview.Size, preview.Center = clone, size, box.Position
		return clone
	end

	function Visuals.PreviewChams(model, color, on)
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") and part.Transparency < 1 then
				local base = part:GetAttribute("MarioColor")
				if base then
					part.Color = on and color or base
					part.Material = on and Enum.Material.ForceField
						or Enum.Material.SmoothPlastic
				end
			end
		end
	end

	function Visuals.PreviewWanted()
		local window = State.Window
		return Visuals.Settings.Preview
			and window ~= nil
			and window.Visible
			and not window.Minimized
			and (
				Visuals.PreviewTab == nil
				or window.ActiveTab == Visuals.PreviewTab
			)
	end

	-- Slide out from behind the window on open; retract on close
	function Visuals.PreviewShow(on)
		local preview = Visuals.Preview
		if not preview.Frame or preview.Shown == on then
			return
		end
		preview.Shown = on
		local open, tucked = UDim2.new(1, 6, 0, 0), UDim2.new(1, -236, 0, 0)
		if on then
			preview.Frame.Position = tucked
			preview.Frame.Visible = true
			preview.Pulse = 0
			Anim.Tween(
				preview.Frame,
				{ Position = open },
				Config.Tween.Pop,
				"Back"
			)
			Anim.Bump(preview.View, 8)
			Visuals.PreviewRender()
			return
		end
		local slide = Anim.Tween(
			preview.Frame,
			{ Position = tucked },
			Config.Tween.Fast,
			"In"
		)
		slide.Completed:Once(function()
			if not preview.Shown then
				preview.Frame.Visible = false
			end
		end)
	end

	function Visuals.PreviewRender()
		local preview = Visuals.Preview
		local window = State.Window
		if not (preview.Frame and window and preview.Shown) then
			return
		end
		preview.Frame.Size = UDim2.fromOffset(230, window.Size.Y)
		local model = Visuals.PreviewModel()
		if model then
			local root = Visuals.PreviewRoot()
			local center = (root and root.Position or Vector3.zero)
				- Vector3.new(0, 0.25, 0)
			local fit = 6.5
				/ 0.55
				/ (2 * math.tan(math.rad(preview.Camera.FieldOfView) / 2))
			preview.Camera.CFrame =
				CFrame.lookAt(center + Vector3.new(0, 0, fit), center)
			local settings = Visuals.Settings
			Visuals.PreviewChams(
				model,
				settings.EnemyColor,
				settings.Enabled and settings.Chams
			)
		end
		Visuals.PreviewDraw()
	end

	-- Avatar preview uses observed local health and actual preview-camera distance; no fabricated target statistics.
	function Visuals.PreviewRoot()
		local model = Visuals.Preview.Model
		return model
			and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
	end

	--@return Vector2 ViewportFrame screen projection
	function Visuals.PreviewProject(pos, size)
		local cam = Visuals.Preview.Camera
		local rel = cam.CFrame:PointToObjectSpace(pos)
		local depth = math.max(-rel.Z, 0.01)
		local half = math.tan(math.rad(cam.FieldOfView) / 2)
		return Vector2.new(
			(0.5 + rel.X / depth / (2 * half * size.X / size.Y)) * size.X,
			(0.5 - rel.Y / depth / (2 * half)) * size.Y
		)
	end

	function Visuals.PreviewDraw()
		local preview = Visuals.Preview
		local size = preview.View.AbsoluteSize
		local root = Visuals.PreviewRoot()
		if
			size.X <= 0
			or size.Y <= 0
			or not root
			or not Visuals.Settings.Enabled
		then
			Visuals.HideEntry(preview.Entry)
			return
		end
		local character = LocalPlayer.Character
		local humanoid = character
			and character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			Visuals.HideEntry(preview.Entry)
			return
		end
		local top =
			Visuals.PreviewProject(root.Position + Vector3.new(0, 3, 0), size)
		local bottom =
			Visuals.PreviewProject(root.Position - Vector3.new(0, 3.5, 0), size)
		local h = math.max(bottom.Y - top.Y, 4)
		local w = h * 0.55
		local x, y = top.X - w / 2, top.Y
		local info = {
			Name = LocalPlayer.DisplayName .. " / avatar preview",
			Health = humanoid.Health,
			MaxHealth = humanoid.MaxHealth,
			Distance = (preview.Camera.CFrame.Position - root.Position).Magnitude,
		}
		Visuals.Layout(
			preview.Entry,
			x,
			y,
			w,
			h,
			info,
			Visuals.Settings.EnemyColor,
			Vector2.new(size.X / 2, size.Y)
		)
	end

	function Visuals.PreviewSetVisible()
		Visuals.PreviewBuild()
		Visuals.PreviewShow(Visuals.PreviewWanted())
	end

	function Visuals.PreviewStep(deltaTime)
		local preview = Visuals.Preview
		if not preview.Frame then
			return
		end
		local wanted = Visuals.PreviewWanted()
		if wanted ~= (preview.Shown == true) then
			Visuals.PreviewShow(wanted)
		end
		if not preview.Shown then
			return
		end
		preview.Pulse = (preview.Pulse or 0) + deltaTime
		Visuals.PreviewDraw()
		if preview.Model then
			preview.Angle = (preview.Angle + deltaTime * 0.6) % (math.pi * 2)
			preview.Model:PivotTo(CFrame.Angles(0, preview.Angle, 0))
		end
	end

	-- Circular radar minimap centered on local player, rotated by camera heading
	Visuals.Radar = { Dots = {} }

	function Visuals.RadarBuild()
		local radar = Visuals.Radar
		if radar.Frame and radar.Frame.Parent then
			return radar
		end
		local gui = Visuals.EnsureGui()
		local frame = Draw.New("Frame", {
			Name = "Radar",
			Position = UDim2.fromOffset(24, 180),
			BackgroundColor3 = Color3.fromRGB(16, 16, 22),
			BackgroundTransparency = 0.25,
			Visible = false,
			Parent = gui,
		})
		Draw.New(
			"UICorner",
			{ CornerRadius = UDim.new(0.5, 0), Parent = frame }
		)
		Draw.New("UIStroke", {
			Thickness = 2,
			Color = Color3.fromRGB(232, 160, 76),
			Transparency = 0.2,
			Parent = frame,
		})
		for _, horizontal in ipairs({ true, false }) do
			Draw.New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = horizontal and UDim2.new(1, -12, 0, 1)
					or UDim2.new(0, 1, 1, -12),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.8,
				Parent = frame,
			})
		end
		local ring = Draw.New("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Parent = frame,
		})
		Draw.New("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = ring })
		Draw.New("UIStroke", {
			Thickness = 1,
			Color = Color3.new(1, 1, 1),
			Transparency = 0.75,
			Parent = ring,
		})
		local me = Draw.New("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1,
			Text = "▲",
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = 3,
			Parent = frame,
		})
		radar.Frame, radar.Me = frame, me
		Gui.Draggable(frame, function(begin, delta)
			if not begin then
				return frame.Position
			end
			frame.Position = begin + UDim2.fromOffset(delta.X, delta.Y)
		end)
		return radar
	end

	function Visuals.RadarDot(index)
		local radar = Visuals.Radar
		local dot = radar.Dots[index]
		if not dot then
			dot = Draw.New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(7, 7),
				ZIndex = 2,
				Parent = radar.Frame,
			})
			Draw.New(
				"UICorner",
				{ CornerRadius = UDim.new(0.5, 0), Parent = dot }
			)
			radar.Dots[index] = dot
		end
		return dot
	end

	function Visuals.RadarRender()
		local settings = Visuals.Settings
		local radar = Visuals.Radar
		if not settings.Radar then
			if radar.Frame then
				radar.Frame.Visible = false
			end
			return
		end
		Visuals.RadarBuild()
		Visuals.Scan()
		local cam = Workspace.CurrentCamera
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local size = settings.RadarSize
		radar.Frame.Size = UDim2.fromOffset(size, size)
		radar.Frame.Visible = cam ~= nil and root ~= nil
		if not radar.Frame.Visible then
			return
		end

		local look = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
		look = look.Magnitude > 0 and look.Unit or Vector3.new(0, 0, -1)
		local right = Vector3.new(-look.Z, 0, look.X)
		local radius = size / 2 - 6
		local used = 0
		for _, info in ipairs(Visuals.Targets) do
			local model = info.Model
			local part = info.Root
				or (
					typeof(model) == "Instance"
					and (
						model:FindFirstChild("HumanoidRootPart")
						or model.PrimaryPart
					)
				)
			if not part or (settings.TeamCheck and info.Friendly) then
				continue
			end
			local rel = part.Position - root.Position
			local offset = Vector2.new(rel:Dot(right), -rel:Dot(look))
				/ settings.RadarRange
				* radius
			local outside = offset.Magnitude > radius
			if outside then
				offset = offset.Unit * radius
			end
			used += 1
			local dot = Visuals.RadarDot(used)
			dot.Position = UDim2.new(0.5, offset.X, 0.5, offset.Y)
			dot.BackgroundColor3 = info.Color
				or (
					info.Friendly and settings.FriendColor
					or settings.EnemyColor
				)
			dot.BackgroundTransparency = outside and 0.55 or 0
			dot.Visible = true
		end
		for index = used + 1, #radar.Dots do
			radar.Dots[index].Visible = false
		end
	end

	function Visuals.Start()
		if Visuals.Started then
			return
		end
		Visuals.Started = true
		Util.Connect(RunService.RenderStepped, function(deltaTime)
			Visuals.Render()
			Visuals.RadarRender()
			Visuals.PreviewStep(deltaTime)
		end)
		table.insert(State.UnloadHooks, function()
			Visuals.ClearAll()
			if Visuals.Gui then
				Visuals.Gui:Destroy()
				Visuals.Gui = nil
			end
		end)
	end

	-- Build complete Visuals tab in one call and return tab for custom groupboxes
	function Window:AddVisualsTab(options)
		options = options or {}
		Visuals.Start()
		if options.Provider then
			Visuals:SetProvider(options.Provider)
		end
		local T = function(en, th)
			return { EN = en, TH = th }
		end
		local function Bind(key)
			return function(value)
				Visuals:Set(key, value)
			end
		end
		local tab = self:AddTab(
			options.Name or T("Visuals", "การมองเห็น"),
			options.Icon or "eye",
			options.Description or T("Player ESP", "ESP ผู้เล่น")
		)
		Visuals.PreviewTab = tab
		Visuals:SetPreview(options.Preview == true)

		local main = tab:AddLeftGroupbox(T("ESP", "ESP"), "eye")
		main:AddToggle("MarioEsp", {
			Text = T("Enable ESP", "เปิด ESP"),
			Callback = Bind("Enabled"),
		})
		main:AddToggle("MarioEspTeam", {
			Text = T("Team check", "เช็คทีม"),
			Default = true,
			Callback = Bind("TeamCheck"),
		})
		main:AddSlider("MarioEspRange", {
			Text = T("Max distance", "ระยะสูงสุด"),
			Min = 50,
			Max = 5000,
			Default = 2000,
			Suffix = "m",
			Callback = Bind("MaxDistance"),
		})
		main:AddSlider("MarioEspText", {
			Text = T("Text size", "ขนาดตัวอักษร"),
			Min = 9,
			Max = 20,
			Default = 13,
			Callback = Bind("TextSize"),
		})

		local look = tab:AddRightGroupbox(
			T("Elements", "องค์ประกอบ"),
			"star"
		)
		look:AddToggle("MarioEspBox", {
			Text = T("Box", "กล่อง"),
			Default = true,
			Callback = Bind("Box"),
		})
		look:AddDropdown("MarioEspBoxStyle", {
			Text = T("Box style", "แบบกล่อง"),
			Values = { "Full", "Corner" },
			Default = "Full",
			Callback = Bind("BoxStyle"),
		})
		look:AddToggle("MarioEspFill", {
			Text = T("Box fill", "ถมสีกล่อง"),
			Callback = Bind("BoxFill"),
		})
		look:AddToggle("MarioEspName", {
			Text = T("Name", "ชื่อ"),
			Default = true,
			Callback = Bind("Name"),
		})
		look:AddToggle("MarioEspHealth", {
			Text = T("Health bar", "แถบเลือด"),
			Default = true,
			Callback = Bind("Health"),
		})
		look:AddToggle("MarioEspHealthText", {
			Text = T("Health number", "ตัวเลขเลือด"),
			Callback = Bind("HealthText"),
		})
		look:AddToggle("MarioEspDistance", {
			Text = T("Distance", "ระยะ"),
			Default = true,
			Callback = Bind("Distance"),
		})
		look:AddToggle("MarioEspDot", {
			Text = T("Head dot", "จุดหัว"),
			Callback = Bind("HeadDot"),
		})
		look:AddToggle("MarioEspTracer", {
			Text = T("Tracers", "เส้นนำสายตา"),
			Callback = Bind("Tracer"),
		})
		look:AddDropdown("MarioEspTracerFrom", {
			Text = T("Tracer from", "เส้นเริ่มจาก"),
			Values = { "Bottom", "Center", "Mouse" },
			Default = "Bottom",
			Callback = Bind("TracerOrigin"),
		})
		look:AddToggle("MarioEspChams", {
			Text = T(
				"Chams",
				"เรืองแสงทะลุกำแพง"
			),
			Callback = Bind("Chams"),
		})
		look:AddToggle("MarioEspArrows", {
			Text = T("Off-screen arrows", "ลูกศรนอกจอ"),
			Callback = Bind("Arrows"),
		})

		local colors = tab:AddLeftGroupbox(T("Colors", "สี"), "flower")
		colors
			:AddLabel(T("Enemy", "ศัตรู"))
			:AddColorPicker("MarioEspEnemyColor", {
				Default = Visuals.Settings.EnemyColor,
				Callback = Bind("EnemyColor"),
			})
		colors
			:AddLabel(T("Friendly", "พวกเดียวกัน"))
			:AddColorPicker("MarioEspFriendColor", {
				Default = Visuals.Settings.FriendColor,
				Callback = Bind("FriendColor"),
			})

		local radar =
			tab:AddLeftGroupbox(T("Radar", "เรดาร์"), "target")
		radar:AddToggle("MarioRadar", {
			Text = T("Radar", "เรดาร์"),
			Description = T(
				"Minimap of nearby players, drag to move",
				"มินิแมพผู้เล่นรอบตัว ลากย้ายได้"
			),
			Callback = Bind("Radar"),
		})
		radar:AddSlider("MarioRadarRange", {
			Text = T("Radar range", "ระยะเรดาร์"),
			Min = 50,
			Max = 1000,
			Default = 250,
			Suffix = "m",
			Callback = Bind("RadarRange"),
		})
		radar:AddSlider("MarioRadarSize", {
			Text = T("Radar size", "ขนาดเรดาร์"),
			Min = 100,
			Max = 320,
			Default = 180,
			Suffix = "px",
			Callback = Bind("RadarSize"),
		})
		return tab
	end

	Library.Visuals = Visuals
	---Executor compatibility: behavioral capability probes, hook wrappers that refuse fake stubs, identity-safe require/call.
	---Every probe runs the API on a throwaway fixture; Xeno-style executors ship stubs that pass type() but do nothing or return the wrong thing.
	local Compat = {
		Probes = {},
		Restores = {},
		Deferred = setmetatable({}, { __mode = "k" }),
		CallTimeout = 8,
	}
	Library.Compat = Compat

	Compat.Api = {
		HookFunction = hookfunction or replaceclosure,
		HookMetamethod = hookmetamethod,
		RestoreFunction = restorefunction,
		IsFunctionHooked = isfunctionhooked,
		GetNamecallMethod = getnamecallmethod,
		CheckCaller = checkcaller,
		NewCClosure = newcclosure,
		GetConnections = getconnections or get_signal_cons,
		GetGc = getgc,
		GetUpvalue = getupvalue or (debug and debug.getupvalue),
		FireSignal = firesignal,
		FirePrompt = fireproximityprompt,
		FireTouch = firetouchinterest,
		SetIdentity = setthreadidentity
			or setidentity
			or (syn and syn.set_thread_identity),
		GetIdentity = getthreadidentity
			or getidentity
			or (syn and syn.get_thread_identity),
		QueueOnTeleport = queue_on_teleport
			or queueonteleport
			or (syn and syn.queue_on_teleport),
		Request = request or http_request or (syn and syn.request),
	}

	---Probes run inline (this __index cannot yield), so a probe that yields counts as unsupported.
	Compat.Caps = setmetatable({}, {
		__index = function(caps, name)
			local probe = Compat.Probes[name]
			if not probe then
				return nil
			end
			local thread = coroutine.create(probe)
			local ok, works = coroutine.resume(thread)
			local has = ok
				and coroutine.status(thread) == "dead"
				and works == true
			if coroutine.status(thread) == "suspended" then
				pcall(coroutine.close, thread)
			end
			rawset(caps, name, has)
			return has
		end,
	})

	function Compat.Probes.HookFunction()
		local hook = Compat.Api.HookFunction
		if not hook then
			return false
		end
		local function Target()
			return "plain"
		end
		local original = hook(Target, function()
			return "hooked"
		end)
		local works = Target() == "hooked"
			and type(original) == "function"
			and original() == "plain"
		if type(original) == "function" then
			pcall(hook, Target, original)
		end
		return works
	end

	function Compat.Probes.Namecall()
		local api = Compat.Api
		if not (api.HookMetamethod and api.GetNamecallMethod) then
			return false
		end
		local proxy = newproxy(true)
		getmetatable(proxy).__index = function()
			return "plain"
		end
		local original = api.HookMetamethod(proxy, "__index", function()
			return "hooked"
		end)
		return type(original) == "function"
			and proxy.probe == "hooked"
			and original(proxy, "probe") == "plain"
	end

	function Compat.Probes.Hook()
		return Compat.Caps.HookFunction and Compat.Caps.Namecall
	end

	function Compat.Probes.CheckCaller()
		return Compat.Api.CheckCaller ~= nil
			and Compat.Api.CheckCaller() == true
	end

	function Compat.Probes.Connections()
		if not Compat.Api.GetConnections then
			return false
		end
		local event = Instance.new("BindableEvent")
		local hits = 0
		local function Handler()
			hits += 1
		end
		local conn = event.Event:Connect(Handler)
		local mine
		for _, entry in ipairs(Compat.Api.GetConnections(event.Event)) do
			if entry.Function == Handler then
				mine = entry
			end
		end
		if mine then
			pcall(mine.Fire, mine)
		end
		conn:Disconnect()
		event:Destroy()
		return hits == 1
	end

	function Compat.Probes.Gc()
		if not Compat.Api.GetGc then
			return false
		end
		local function Marker()
			return "gc"
		end
		for _, value in ipairs(Compat.Api.GetGc(false)) do
			if value == Marker then
				return true
			end
		end
		return false
	end

	function Compat.Probes.Upvalues()
		if not Compat.Api.GetUpvalue then
			return false
		end
		local marker = {}
		local function Holder()
			return marker
		end
		return Compat.Api.GetUpvalue(Holder, 1) == marker
	end

	---ESP sets these on Text objects every frame; a shim that only knows Line would throw per entry.
	function Compat.Probes.Drawing()
		if type(Drawing) ~= "table" and type(Drawing) ~= "userdata" then
			return false
		end
		local label = Drawing.new("Text")
		local box = Drawing.new("Square")
		local ok = pcall(function()
			label.Text, label.Size, label.Center, label.Outline =
				"probe", 13, true, true
			label.Position, label.ZIndex, label.Visible =
				Vector2.new(-100, -100), 2, false
			label.Font = Drawing.Fonts and Drawing.Fonts.Plex or 2
			box.Filled, box.Thickness, box.Visible = false, 1, false
		end)
		for _, object in ipairs({ label, box }) do
			pcall(object.Remove or object.Destroy, object)
		end
		return ok
	end

	function Compat.Probes.Signals()
		if not Compat.Api.FireSignal then
			return false
		end
		local event = Instance.new("BindableEvent")
		local got
		local conn = event.Event:Connect(function(value)
			got = value
		end)
		pcall(Compat.Api.FireSignal, event.Event, 7)
		conn:Disconnect()
		event:Destroy()
		return got == 7
	end

	function Compat.Probes.Identity()
		local api = Compat.Api
		if not (api.SetIdentity and api.GetIdentity) then
			return false
		end
		local before = api.GetIdentity()
		local target = before == 2 and 8 or 2
		api.SetIdentity(target)
		local after = api.GetIdentity()
		api.SetIdentity(before)
		return after == target
	end

	function Compat.Probes.FileSystem()
		if not Util.FileApi() then
			return false
		end
		local stamp = tostring(os.clock())
		local wrote = pcall(writefile, "nullx11_probe.txt", stamp)
		local ok, read = pcall(readfile, "nullx11_probe.txt")
		return wrote and ok and read == stamp
	end

	function Compat.Probes.Hui()
		if type(gethui) ~= "function" then
			return false
		end
		local ok, hidden = pcall(gethui)
		return ok and typeof(hidden) == "Instance"
	end

	function Compat.Probes.Http()
		return Compat.Api.Request ~= nil
	end

	function Compat.Probes.Queue()
		return Compat.Api.QueueOnTeleport ~= nil
	end

	function Compat.Probes.Clipboard()
		return type(setclipboard or toclipboard) == "function"
	end

	function Compat.Probes.Prompt()
		return Compat.Api.FirePrompt ~= nil
	end

	function Compat.Probes.Touch()
		return Compat.Api.FireTouch ~= nil
	end

	---Potassium-only packet library; presence only, Compat.RaknetLive() proves packets really pass (RakNet must be switched on in Potassium settings).
	function Compat.Probes.Raknet()
		return type(raknet) == "table"
			and type(raknet.add_send_hook) == "function"
			and type(raknet.remove_send_hook) == "function"
			and type(raknet.send) == "function"
	end

	---@param caps string|string[]
	---@return boolean, string?  false + the first missing cap
	function Compat.Has(caps)
		for _, name in ipairs(type(caps) == "table" and caps or { caps }) do
			if not Compat.Caps[name] then
				return false, name
			end
		end
		return true
	end

	---Blocks a hook-only feature before its callback ever sees `true`: notice, then flips it back off.
	---@param option table|string  widget or its idx
	---@param caps string|string[]  every cap the feature needs
	function Compat.NeedCap(option, caps)
		option = type(option) == "string" and Library.Options[option] or option
		if type(option) ~= "table" or type(option.AddGuard) ~= "function" then
			return
		end
		option:AddGuard(function(value)
			if value ~= true or Compat.Has(caps) then
				return true
			end
			local feature = option.Info
					and option.Info.Text
					and Lang.Resolve(option.Info.Text)
				or option.Idx
			Library:Notify(
				"Nullx11",
				Library:T(
					tostring(feature) .. " is not supported on this executor",
					tostring(feature)
						.. " ใช้กับ executor นี้ไม่ได้"
				),
				4,
				"Warn"
			)
			task.defer(option.SetValue, option, false)
			return false
		end)
	end

	---V1 has no disabled state: vetoes turning `option` on and tells the player why (missing game module, unsupported executor).
	---@param reason any  text spec, e.g. Library:T("Not available on this executor", "Unsupported executor")
	function Compat.Block(option, reason)
		option = type(option) == "string" and Library.Options[option] or option
		if type(option) ~= "table" or type(option.AddGuard) ~= "function" then
			return
		end
		option.Blocked = reason
		option:AddGuard(function(value)
			if value ~= true then
				return true
			end
			local feature = option.Info
					and option.Info.Text
					and Lang.Resolve(option.Info.Text)
				or option.Idx
			Library:Notify(
				"Nullx11",
				tostring(feature)
					.. ": "
					.. tostring(Lang.Resolve(reason) or reason),
				4,
				"Warn"
			)
			task.defer(option.SetValue, option, false)
			return false
		end)
	end

	---Requires a game module; identity-3 executors get "Cannot require a non-RobloxScript module", so it retries from an identity-2 thread when the executor can really switch.
	---@return boolean ok, any module or the error
	function Compat.Require(module)
		local ok, loaded = pcall(require, module)
		if ok or not Compat.Caps.Identity then
			return ok, loaded
		end
		local finished, okAgain, again = Util.Await(
			Compat.CallTimeout,
			function()
				Compat.Api.SetIdentity(2)
				return pcall(require, module)
			end
		)
		if finished and okAgain then
			return true, again
		end
		return false, loaded
	end

	---Calls a game function inline; one that throws "non-RobloxScript" (it requires lazily inside) is rerun from a deferred identity-2 thread and remembered per function.
	---The deferred thread keeps the caller untainted.
	function Compat.Call(fn, ...)
		if not Compat.Deferred[fn] then
			local result = table.pack(pcall(fn, ...))
			if result[1] then
				return table.unpack(result, 2, result.n)
			end
			if
				not Compat.Caps.Identity
				or not tostring(result[2]):find("non-RobloxScript", 1, true)
			then
				error(result[2], 0)
			end
			Compat.Deferred[fn] = true
		end
		local args = table.pack(...)
		local box
		task.defer(function()
			Compat.Api.SetIdentity(2)
			box = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
		end)
		local deadline = os.clock() + Compat.CallTimeout
		while not box and os.clock() < deadline do
			task.wait()
		end
		if not box then
			error("game call timed out", 0)
		end
		if not box[1] then
			error(box[2], 0)
		end
		return table.unpack(box, 2, box.n)
	end

	local function Wrap(handler)
		local okWrap, wrapped = pcall(Compat.Api.NewCClosure or error, handler)
		return okWrap and type(wrapped) == "function" and wrapped or handler
	end

	---Undoes a hook: the executor's restorefunction first, else `rehook`.
	function Compat.Unhook(target, rehook)
		local api = Compat.Api
		if
			target
			and api.RestoreFunction
			and pcall(api.RestoreFunction, target)
		then
			if not api.IsFunctionHooked then
				return
			end
			local ok, still = pcall(api.IsFunctionHooked, target)
			if ok and not still then
				return
			end
		end
		rehook()
	end

	local function Track(putBack)
		table.insert(Compat.Restores, putBack)
		return function()
			local index = table.find(Compat.Restores, putBack)
			if not index then
				return
			end
			table.remove(Compat.Restores, index)
			Util.Try(putBack)
		end
	end

	---Hooks one metamethod only when Caps.Namecall proved hookmetamethod returns the real original.
	---@return function?  original, nil when refused
	---@return function?  restore
	function Compat.HookMeta(object, method, handler)
		if not Compat.Caps.Namecall then
			return nil
		end
		local api = Compat.Api
		local ok, original =
			pcall(api.HookMetamethod, object, method, Wrap(handler))
		if not ok or type(original) ~= "function" then
			return nil
		end
		return original,
			Track(function()
				api.HookMetamethod(object, method, original)
			end)
	end

	---Hooks one function only when Caps.HookFunction proved hookfunction works.
	---@return function?  original, nil when refused
	---@return function?  restore
	function Compat.HookFunction(target, handler)
		if not Compat.Caps.HookFunction then
			return nil
		end
		local api = Compat.Api
		local ok, original = pcall(api.HookFunction, target, Wrap(handler))
		if not ok or type(original) ~= "function" then
			return nil
		end
		return original,
			Track(function()
				Compat.Unhook(target, function()
					pcall(api.HookFunction, target, original)
				end)
			end)
	end

	function Compat.RestoreAll()
		for index = #Compat.Restores, 1, -1 do
			Util.Try(Compat.Restores[index])
		end
		table.clear(Compat.Restores)
	end

	---Yields up to `timeout` seconds watching for one outgoing packet; without RakNet enabled in Potassium the hooks never fire.
	---@return boolean
	function Compat.RaknetLive(timeout)
		if not Compat.Caps.Raknet then
			return false
		end
		local seen = false
		local function Watch()
			seen = true
		end
		if not pcall(raknet.add_send_hook, Watch) then
			return false
		end
		local deadline = os.clock() + (timeout or 2)
		while not seen and os.clock() < deadline do
			task.wait(0.1)
		end
		pcall(raknet.remove_send_hook, Watch)
		return seen
	end

	---Runs every probe deferred so the first toggle press does not pay for one.
	function Compat.Warm()
		for name in pairs(Compat.Probes) do
			task.defer(function()
				local _ = Compat.Caps[name]
			end)
		end
	end

	--@return {EN,TH} Formatted bilingual string from Lang.Strings
	function Lang.Format(key, ...)
		local spec = Lang.Strings[key] or { EN = key, TH = key }
		local args = table.pack(...)
		return {
			EN = string.format(spec.EN, table.unpack(args, 1, args.n)),
			TH = string.format(
				spec.TH or spec.EN,
				table.unpack(args, 1, args.n)
			),
		}
	end

	function Configs.SetFolder(name)
		Configs.Folder = Config.ConfigRoot .. "/" .. Util.Sanitize(name)
		if Util.FileApi() then
			Util.EnsureFolder(Configs.Folder)
		end
	end

	function Configs.Path(name)
		return Configs.Folder .. "/" .. Util.Sanitize(name) .. ".json"
	end

	function Configs.Save(name)
		if not Util.FileApi() then
			return false, Lang.Get("NoFileApi")
		end
		local snapshot = {}
		for idx, option in pairs(Library.Options) do
			if not option.NoSave and option.Serialize then
				snapshot[idx] =
					{ Type = option.Type, Value = option:Serialize() }
			end
		end
		return (
			pcall(
				writefile,
				Configs.Path(name),
				HttpService:JSONEncode(snapshot)
			)
		)
	end

	function Configs.Load(name)
		local path = Configs.Path(name)
		if not Util.FileApi() or not Util.Exists(path) then
			return false, Lang.Get("ConfigMissing")
		end
		local read, raw = pcall(readfile, path)
		local ok, snapshot =
			pcall(HttpService.JSONDecode, HttpService, read and raw or "")
		if not ok or type(snapshot) ~= "table" then
			return false, Lang.Get("ConfigBroken")
		end
		for idx, saved in pairs(snapshot) do
			local option = Library.Options[idx]
			if
				type(saved) == "table"
				and option
				and not option.NoSave
				and option.Type == saved.Type
			then
				Util.Try(option.Deserialize, option, saved.Value)
			end
		end
		return true
	end

	function Configs.Delete(name)
		local path = Configs.Path(name)
		if
			type(delfile) ~= "function"
			or not Util.FileApi()
			or not Util.Exists(path)
		then
			return false, Lang.Get("ConfigMissing")
		end
		return (pcall(delfile, path))
	end

	function Configs.List()
		if type(listfiles) ~= "function" or not Util.FileApi() then
			return {}
		end
		local ok, files = pcall(listfiles, Configs.Folder)
		local names = {}
		for _, path in ipairs(ok and files or {}) do
			local name = path:match("([^/\\]+)%.json$")
			if name then
				table.insert(names, name)
			end
		end
		table.sort(names)
		return names
	end

	function Configs.SetAutoload(name)
		if not Util.FileApi() then
			return false, Lang.Get("NoFileApi")
		end
		return (pcall(writefile, Configs.Folder .. "/autoload.txt", name))
	end

	function Configs.GetAutoload()
		local path = Configs.Folder .. "/autoload.txt"
		if not Util.FileApi() or not Util.Exists(path) then
			return nil
		end
		local ok, name = pcall(readfile, path)
		return ok and type(name) == "string" and name ~= "" and name or nil
	end

	function Configs.BuildSection(group)
		local nameInput = group:AddInput("MarioConfigName", {
			Text = Lang.Strings.ConfigName,
			Placeholder = "default",
			NoSave = true,
		})
		local list = group:AddListBox("MarioConfigList", {
			Text = Lang.Strings.SavedConfigs,
			Values = Configs.List(),
			Height = 4,
			NoSave = true,
		})
		group:AddLabel("Manual profiles / no automatic startup execution")
		local function Selected()
			local typed = nameInput.Value:gsub("^%s+", ""):gsub("%s+$", "")
			return typed ~= "" and typed or list.Value
		end
		local function Run(actionKey, handler)
			local name = Selected()
			if not name then
				Library:Notify(
					Lang.Strings.Configs,
					Lang.Strings.PickConfig,
					3,
					"Warning"
				)
				return
			end
			local ok, reason = handler(name)
			local action = Lang.Strings[actionKey]
			local message = ok
					and {
						EN = action.EN .. ": " .. name,
						TH = action.TH .. ": " .. name,
					}
				or {
					EN = action.EN .. " failed: " .. tostring(reason),
					TH = action.TH
						.. " ไม่สำเร็จ: "
						.. tostring(reason),
				}
			Library:Notify(
				Lang.Strings.Configs,
				message,
				3,
				ok and "Success" or "Error"
			)
			list:SetValues(Configs.List())
		end
		group
			:AddButton({
				Text = Lang.Strings.Save,
				Style = "Primary",
				Func = function()
					Run("Save", Configs.Save)
				end,
			})
			:AddButton({
				Text = Lang.Strings.Load,
				Style = "Success",
				Func = function()
					Run("Load", Configs.Load)
				end,
			})
		group
			:AddButton({
				Text = Lang.Strings.Delete,
				Style = "Danger",
				DoubleClick = true,
				Func = function()
					Run("Delete", Configs.Delete)
				end,
			})
			:AddButton({
				Text = Lang.Strings.Refresh,
				Func = function()
					list:SetValues(Configs.List())
				end,
			})
	end

	function Window:AddSettingsTab()
		local tab = self:AddTab(
			Lang.Strings.Settings,
			"gear",
			Lang.Strings.SettingsDesc
		)
		local interface =
			tab:AddLeftGroupbox(Lang.Strings.Interface, "mushroom")
		interface:AddDropdown("MarioLanguage", {
			Text = Lang.Strings.Language,
			Values = { "English", "ไทย" },
			Default = State.Language == "TH" and "ไทย" or "English",
			Callback = function(value)
				Library:SetLanguage(value == "ไทย" and "TH" or "EN")
			end,
		})
		interface:AddDropdown("MarioTheme", {
			Text = Lang.Strings.ThemeName,
			Values = Themes.Order,
			Default = State.ThemeName,
			Callback = function(name)
				Library:SetTheme(name)
			end,
		})
		interface:AddSlider("MarioScale", {
			Text = Lang.Strings.Scale,
			Min = Config.ScaleRange.Min * 100,
			Max = Config.ScaleRange.Max * 100,
			Default = State.UserScale * 100,
			Suffix = "%",
			Finished = true,
			Callback = function(value)
				self:SetScale(value / 100)
			end,
		})
		interface:AddKeybind("MarioMenuKey", {
			Text = Lang.Strings.MenuKey,
			Default = State.MenuKey,
			Mode = "Always",
			ChangedCallback = function(name)
				State.MenuKey = name
			end,
		})
		interface:AddToggle("MarioWatermark", {
			Text = Lang.Strings.Watermark,
			Description = Lang.Strings.WatermarkDesc,
			Default = Watermark.Frame ~= nil and Watermark.Frame.Visible,
			Callback = Watermark.SetVisible,
		})
		interface:AddToggle("MarioParticles", {
			Text = Lang.Strings.Particles,
			Description = Lang.Strings.ParticlesDesc,
			Default = Particles.Enabled,
			Callback = Particles.SetEnabled,
		})
		interface:AddToggle("MarioFloat", {
			Text = Lang.Strings.FloatButton,
			Description = Lang.Strings.FloatDesc,
			Default = Float.Button ~= nil and Float.Button.Visible,
			Callback = Float.SetVisible,
		})
		local about = tab:AddLeftGroupbox(Lang.Strings.About, "star")
		about:AddLabel(
			string.format(
				"%s v%s - %s",
				self.Title,
				Library.Version,
				self.SubTitle ~= "" and self.SubTitle or tostring(game.PlaceId)
			)
		)
		about:AddLabel(Lang.Format("Device", State.Touch and "Mobile" or "PC"))
		about
			:AddButton({
				Text = Lang.Strings.Rejoin,
				Func = function()
					game:GetService("TeleportService"):TeleportToPlaceInstance(
						game.PlaceId,
						game.JobId,
						LocalPlayer
					)
				end,
			})
			:AddButton({
				Text = Lang.Strings.Unload,
				Style = "Danger",
				DoubleClick = true,
				Func = function()
					Library:Unload()
				end,
			})
		Configs.BuildSection(
			tab:AddRightGroupbox(Lang.Strings.Configs, "qblock")
		)
		return tab
	end

	local makeScriptLibraryModel = (function()
		-- Pure browsing policy for the native workspace game-card browser.
		local model = {}
		function model.Category(entry)
			return entry.Category or "Community"
		end
		function model.Badge(entry, place, universe)
			if entry.Universal then
				return "UNIVERSAL / NATIVE"
			end
			if entry.GameUniverseId then
				return entry.GameUniverseId == universe and "UNIVERSE MATCH"
					or "OTHER UNIVERSE"
			end
			if not entry.GamePlaceId then
				return "MODULE CHECK ON LAUNCH"
			end
			return entry.GamePlaceId == place and "PLACE MATCH" or "OTHER PLACE"
		end
		function model.Match(
			entry,
			query,
			category,
			onlyPlace,
			place,
			universe,
			collection
		)
			if
				collection
				and collection ~= "All collections"
				and (entry.Collection or "Nullx11 originals") ~= collection
			then
				return false
			end
			if
				category
				and category ~= "All games"
				and model.Category(entry) ~= category
			then
				return false
			end
			if
				onlyPlace
				and not (
					entry.Universal
					or (entry.GamePlaceId and entry.GamePlaceId == place)
					or (
						entry.GameUniverseId
						and entry.GameUniverseId == universe
					)
				)
			then
				return false
			end
			local haystack = string.lower(table.concat({
				entry.Name or "",
				entry.Description or "",
				entry.Author or "",
				entry.Collection or "",
				entry.File or "",
				model.Category(entry),
			}, " "))
			for word in string.lower(query or ""):gmatch("%S+") do
				if not haystack:find(word, 1, true) then
					return false
				end
			end
			return true
		end
		function model.Categories(entries)
			local seen, list = {}, {}
			for _, entry in ipairs(entries) do
				local category = model.Category(entry)
				if not seen[category] then
					seen[category] = true
					table.insert(list, category)
				end
			end
			table.sort(list)
			table.insert(list, 1, "All games")
			return list
		end
		function model.Resolve(entries, id)
			for _, entry in ipairs(entries) do
				if entry.Id == id then
					return entry
				end
			end
			return nil
		end
		return model
	end)()
	-- A real native browser, not a screenshot or a second upstream UI.
	-- Cards are reused on search; refresh removes obsolete instances/subscriptions.
	function Library:CreateScriptBrowser(tab, options)
		local model = makeScriptLibraryModel
		local browser = {
			Query = "",
			GlobalQuery = "",
			Category = "All games",
			Collection = "All collections",
			OnlyPlace = false,
			Cards = {},
			Matches = {},
		}
		local controls =
			tab:AddLeftGroupbox("Scripts / curated library", "layers")
		local summary = controls:AddLabel("Loading library", true)
		local grid = Draw.New(
			"Frame",
			{ Name = "ScriptCardGrid", BackgroundTransparency = 1 }
		)
		local empty = Draw.Text({
			Name = "ScriptsEmptyState",
			Text = "No games match. Clear search or choose All games.",
			TextWrapped = true,
			Size = UDim2.new(1, -24, 0, 70),
			Position = UDim2.fromOffset(12, 12),
			Parent = grid,
		}, "Body", 16, "SubText")
		local function copy(parent, name, text, y, height, size, token)
			return Draw.Text({
				Name = name,
				Text = text,
				Position = UDim2.fromOffset(16, y),
				Size = UDim2.new(1, -32, 0, height),
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = parent,
			}, "Body", size, token)
		end
		local function latest()
			return options.Entries()
		end
		local function layout(width)
			local columns = width >= 610 and 2 or 1
			local cardWidth =
				math.max(0, (width - (columns - 1) * 12) / columns)
			for index, card in ipairs(browser.Matches) do
				card.Frame.Position = UDim2.fromOffset(
					(index - 1) % columns * (cardWidth + 12),
					math.floor((index - 1) / columns) * 260
				)
				card.Frame.Size = UDim2.fromOffset(cardWidth, 248)
			end
		end
		local gridItem = tab.Left:Add(grid, {
			Height = function(width)
				local count = #browser.Matches
				return count == 0 and 90
					or math.ceil(count / (width >= 610 and 2 or 1))
							* 260
						- 12
			end,
			OnLayout = layout,
		})
		function browser:Filter()
			table.clear(self.Matches)
			local total = 0
			for _, entry in ipairs(latest()) do
				total += 1
				local card = self.Cards[entry.Id]
				if card then
					local show = model.Match(
						entry,
						self.Query .. " " .. self.GlobalQuery,
						self.Category,
						self.OnlyPlace,
						game.PlaceId,
						game.GameId,
						self.Collection
					)
					card.Frame.Visible = show
					if show then
						table.insert(self.Matches, card)
					end
				end
			end
			empty.Visible = #self.Matches == 0
			summary:SetText(
				string.format(
					"%d of %d games / Nullx11 by NULL",
					#self.Matches,
					total
				)
			)
			tab.Left:MarkDirty()
			tab:ApplyColumns()
		end
		local category
		function browser:Refresh()
			local present = {}
			for _, entry in ipairs(latest()) do
				present[entry.Id] = true
				local card = self.Cards[entry.Id]
				if not card then
					local frame = Draw.Box(
						"Frame",
						{ Name = "ScriptCard_" .. entry.Id, Parent = grid },
						"Panel",
						"Outline",
						14,
						1
					)
					local accent = Draw.Box("Frame", {
						Size = UDim2.new(1, -32, 0, 3),
						Position = UDim2.fromOffset(16, 0),
						Parent = frame,
					}, "Accent", nil, 2)
					local icon = Icons.Create(
						frame,
						entry.Icon or "code",
						30,
						"Accent",
						entry.Name
					)
					icon.Position = UDim2.fromOffset(16, 18)
					local genre = copy(
						frame,
						"Category",
						model.Category(entry):upper(),
						19,
						20,
						14,
						"Muted"
					)
					genre.Position = UDim2.fromOffset(58, 23)
					genre.Size = UDim2.new(1, -74, 0, 20)
					local title =
						copy(frame, "GameName", entry.Name, 59, 46, 19, "Text")
					local description = copy(
						frame,
						"GameDescription",
						entry.Description,
						112,
						57,
						14,
						"SubText"
					)
					local badge = copy(
						frame,
						"Compatibility",
						model.Badge(entry, game.PlaceId, game.GameId),
						177,
						18,
						12,
						"Muted"
					)
					local button = Draw.Box("TextButton", {
						Name = "OpenScript_" .. entry.Id,
						Position = UDim2.fromOffset(14, 204),
						Size = UDim2.new(1, -28, 0, 32),
						Parent = frame,
					}, "Element", "Outline", 8, 1)
					copy(
						button,
						"OpenLabel",
						"View details & launch",
						6,
						20,
						14,
						"Text"
					)
					local id = entry.Id
					local connection = button.Activated:Connect(function()
						local selected = model.Resolve(latest(), id)
						if not selected then
							self:Refresh()
							return
						end
						options.Open(selected)
					end)
					card = {
						Frame = frame,
						Title = title,
						Description = description,
						Genre = genre,
						Badge = badge,
						Connection = connection,
						Accent = accent,
					}
					self.Cards[entry.Id] = card
				end
				card.Title.Text = entry.Name
				card.Description.Text = entry.Description
				card.Genre.Text = model.Category(entry):upper()
				card.Badge.Text = model.Badge(entry, game.PlaceId, game.GameId)
			end
			local removed = {}
			for id, card in pairs(self.Cards) do
				if not present[id] then
					table.insert(removed, id)
					card.Connection:Disconnect()
					Theme.UnbindTree(card.Frame)
					card.Frame:Destroy()
				end
			end
			for _, id in ipairs(removed) do
				self.Cards[id] = nil
			end
			if category then
				local values = model.Categories(latest())
				category:SetValues(values)
				if not table.find(values, self.Category) then
					self.Category = "All games"
					category:SetValue("All games")
				end
			end
			self:Filter()
		end
		controls:AddInput("ScriptLibrarySearch", {
			Text = "Search library",
			Placeholder = "Game, feature or creator",
			Finished = false,
			Default = "",
			NoSave = true,
			Callback = function(value)
				browser.Query = value
				browser:Filter()
			end,
		})
		category = controls:AddDropdown("ScriptLibraryCategory", {
			Text = "Category",
			Values = model.Categories(latest()),
			Default = "All games",
			NoSave = true,
			Callback = function(value)
				browser.Category = value
				browser:Filter()
			end,
		})
		controls:AddDropdown("ScriptLibraryCollection", {
			Text = "Source collection",
			Values = {
				"All collections",
				"Nullx11 originals",
				"YARHM",
				"Chaos",
				"NULL Studio",
			},
			Default = "All collections",
			NoSave = true,
			Callback = function(value)
				browser.Collection = value
				browser:Filter()
			end,
		})
		controls:AddToggle("ScriptLibraryPlace", {
			Text = "Known compatible game or Universal",
			Default = false,
			NoSave = true,
			Callback = function(value)
				browser.OnlyPlace = value
				browser:Filter()
			end,
		})
		controls:AddButton({
			Text = "Refresh repository manifest",
			Func = options.Refresh,
		})
		local help = tab:AddLeftGroupbox("Read before launching", "info")
		help:AddParagraph({
			Title = "Browse first. Launch deliberately.",
			Content = "Cards open the existing details and confirmation window. Nothing auto-runs or joins a game. A place match is not proof of server compatibility; module-gated games are checked by their bundle before startup.",
		})
		help:AddParagraph({
			Title = "Independent workspaces",
			Content = "Executed game windows survive loader unload. Stop features or unload each game's own workspace to clean up its jobs, overlays and owned changes.",
		})
		help:AddParagraph({
			Title = "NULL ownership and source notices",
			Content = "Owner: NULL. Native Nullx11 editions use one shared interface. Required source notices and restrictions are retained in the repository; optional promotional credits are not shown here.",
		})
		tab.ApplyLibraryFilter = function(query)
			browser.GlobalQuery = query or ""
			browser:Filter()
		end
		self:OnUnload(function()
			for _, card in pairs(browser.Cards) do
				card.Connection:Disconnect()
			end
			table.clear(browser.Cards)
			table.clear(browser.Matches)
		end)
		browser:Refresh()
		return browser
	end
	local makeExecutionState = (function()
		-- Observable, monotonic execution stages. No time-based/fabricated percentages.
		return function(render)
			local model = {
				PhaseIndex = 1,
				Completed = 0,
				Status = "running",
				Detail = "Requesting repository source. Cancel prevents startup; the executor network request may still finish.",
				Started = false,
				Hidden = false,
			}
			function model:Phase(index, detail)
				if self.Status ~= "running" then
					return false
				end
				assert(
					index >= self.PhaseIndex and index <= 4 and index % 1 == 0,
					"Invalid execution stage"
				)
				self.PhaseIndex, self.Completed = index, index - 1
				self.Detail = tostring(detail or "")
				self.Started = index == 4
				render(self)
				return true
			end
			function model:Finish()
				if self.Status ~= "running" then
					return
				end
				self.Completed, self.Status = 4, "complete"
				self.Detail =
					"The client chunk returned. Check the game window for compatibility and feature status."
				render(self)
			end
			function model:Fail(reason)
				if self.Status ~= "running" then
					return
				end
				self.Status, self.Detail =
					"failed", string.sub(tostring(reason), 1, 700)
				render(self)
			end
			function model:Dismiss()
				self.Hidden = true
				if self.Status == "running" and not self.Started then
					self.Status = "cancelled"
				end
				render(self)
			end
			function model:CanContinue()
				return self.Status == "running"
			end
			render(model)
			return model
		end
	end)()
	-- Injected into the shared UI factory: responsive, event-driven execution sheet.
	function Library:BeginExecution(title)
		if self.Unloaded then
			return nil
		end
		if self.Execution then
			self.Execution:Close()
		end
		-- Separate ScreenGui: a newly-created game UI must not cover initialization.
		local executionGui = Draw.New("ScreenGui", {
			Name = "Nullx11ExecutionOverlay",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = math.max(1000, State.Gui.DisplayOrder + 1),
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			Parent = State.Gui.Parent,
		})
		local shade = Draw.New("TextButton", {
			Name = "ExecutionLoading",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.36,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 72,
			Parent = executionGui,
		})
		local card = Draw.Box("Frame", {
			Name = "ExecutionCard",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -32, 1, -32),
			Visible = true,
			ZIndex = 73,
			Parent = shade,
		}, "Panel", "Outline", 20, 1)
		Draw.New(
			"UISizeConstraint",
			{ MaxSize = Vector2.new(520, 420), Parent = card }
		)
		local scroll = Draw.New("ScrollingFrame", {
			Name = "ExecutionContent",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.fromOffset(0, 402),
			ScrollBarThickness = 3,
			Parent = card,
		})
		local emblem = Draw.Emblem(scroll, 48)
		emblem.Position = UDim2.fromOffset(24, 22)
		local function text(name, value, x, y, height, size, token)
			return Draw.Text({
				Name = name,
				Text = value,
				Position = UDim2.fromOffset(x, y),
				Size = UDim2.new(1, -x - 24, 0, height),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = scroll,
			}, "Body", size, token or "Text")
		end
		text("Developer", "NULLX11 / NULL", 86, 22, 18, 14, "Muted")
		text("ScriptName", title, 86, 44, 26, 19)
		local status =
			text("ExecutionStatus", "Preparing execution", 24, 90, 26, 18)
		local detail = text("ExecutionDetail", "", 24, 120, 62, 14, "SubText")
		detail.TextWrapped, detail.TextTruncate = true, Enum.TextTruncate.None
		local track = Draw.Box("Frame", {
			Name = "ExecutionTrack",
			Position = UDim2.fromOffset(24, 198),
			Size = UDim2.new(1, -48, 0, 5),
			Parent = scroll,
		}, "Track", nil, 3)
		local fill = Draw.Box("Frame", {
			Name = "ExecutionProgress",
			Size = UDim2.fromScale(0, 1),
			Parent = track,
		}, "Accent", nil, 3)
		Draw.New("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(164, 143, 255),
				Color3.fromRGB(96, 220, 224)
			),
			Parent = fill,
		})
		local labels, marks = {}, {}
		for index, name in ipairs({
			"Download",
			"Validate source",
			"Compile Luau",
			"Initialize script",
		}) do
			marks[index] = Draw.Box("Frame", {
				Position = UDim2.fromOffset(26, 221 + (index - 1) * 27),
				Size = UDim2.fromOffset(7, 7),
				Parent = scroll,
			}, "Muted", nil, 4)
			labels[index] = text(
				"ExecutionStage" .. index,
				name,
				44,
				214 + (index - 1) * 27,
				22,
				14,
				"SubText"
			)
		end
		local close = Draw.Box("TextButton", {
			Name = "ExecutionDismiss",
			Text = "Cancel download",
			AutoButtonColor = false,
			Position = UDim2.fromOffset(24, 342),
			Size = UDim2.new(1, -48, 0, 40),
			Parent = scroll,
		}, "Element", "Outline", 10, 1)
		close.Font, close.TextSize = Enum.Font.GothamMedium, 14
		Theme.Bind(close, { TextColor3 = "Text" })
		local job = { Closed = false }
		local function render(model)
			if job.Closed or not shade.Parent then
				return
			end
			local names = {
				"Downloading source",
				"Validating response",
				"Compiling Luau",
				"Initializing script",
			}
			status.Text = model.Status == "failed" and "Execution failed"
				or model.Status == "complete" and "Client initialization returned"
				or names[model.PhaseIndex]
			detail.Text = model.Detail
			close.Text = model.Status ~= "running" and "Close"
				or model.Started and "Hide / keep script running"
				or "Cancel execution"
			Anim.Tween(
				fill,
				{ Size = UDim2.fromScale(model.Completed / 4, 1) },
				0.22,
				"Out"
			)
			for index, label in ipairs(labels) do
				label.Text = (
					index <= model.Completed and "Done / "
					or index == model.PhaseIndex and "Current / "
					or "Next / "
				)
					.. ({
						"Download",
						"Validate source",
						"Compile Luau",
						"Initialize script",
					})[index]
				Theme.Bind(marks[index], {
					BackgroundColor3 = index <= model.Completed and "Accent"
						or "Muted",
				})
			end
		end
		job.Model = makeExecutionState(render)
		function job:Phase(index, message)
			return self.Model:Phase(index, message)
		end
		function job:CanContinue()
			return not self.Closed and self.Model:CanContinue()
		end
		function job:Close()
			if self.Closed then
				return
			end
			self.Model:Dismiss()
			self.Closed = true
			Theme.UnbindTree(executionGui)
			executionGui:Destroy()
			if Library.Execution == self then
				Library.Execution = nil
			end
		end
		function job:Finish(ready)
			self.Model:Finish()
			if ready then
				self:Close()
				return
			end
			task.delay(1.2, function()
				if not self.Closed then
					self:Close()
				end
			end)
		end
		function job:Fail(reason)
			self.Model:Fail(reason)
		end
		close.Activated:Connect(function()
			job:Close()
		end)
		Library.Execution = job
		if not Library.ExecutionCleanupInstalled then
			Library.ExecutionCleanupInstalled = true
			Library:OnUnload(function()
				if Library.Execution then
					Library.Execution:Close()
				end
			end)
		end
		local scale = Draw.New("UIScale", { Scale = 0.96, Parent = card })
		pcall(Anim.Tween, scale, { Scale = 1 }, 0.22, "Out")
		scale.Scale = 1
		return job
	end

	-- The existing gravity-well intro is hosted in this GUI, above its own window.
	-- Hide/restore the actual native window and static dock, not the classic panel.
	function Library:GetOverlayHost()
		return State.Gui
	end

	function Library:SetOpening(opening)
		if self.Unloaded or not self.Window then
			return nil
		end
		if opening then
			if not self.Opening then
				self.Opening = {
					WindowVisible = self.Window.Visible,
					FloatVisible = Float.Button and Float.Button.Visible,
					DisplayOrder = State.Gui.DisplayOrder,
				}
				self.Window:SetVisible(false)
				State.Gui.DisplayOrder = math.max(
					1000,
					(tonumber(State.Gui.DisplayOrder) or 100) + 1
				)
				Float.SetVisible(false)
			end
			return State.Gui
		end
		local previous = self.Opening
		self.Opening = nil
		if previous then
			State.Gui.DisplayOrder = previous.DisplayOrder
			self.Window:SetVisible(previous.WindowVisible)
			Float.SetVisible(previous.FloatVisible == true)
		end
		return State.Gui
	end

	function Library:CreateWindow(options)
		options = options or {}
		local language = options.Language
		if language == "Auto" then
			language = tostring(LocalPlayer.LocaleId):sub(1, 2) == "th" and "TH"
				or "EN"
		end
		State.Language = language == "TH" and "TH" or "EN"
		State.UserScale = math.clamp(
			options.Scale or 1,
			Config.ScaleRange.Min,
			Config.ScaleRange.Max
		)
		Theme.Apply(options.Theme or Config.SeasonTheme or "Overworld")
		Assets.Configure(Config.DefaultAssets)
		Assets.Configure(options.Assets)
		Window.DetectTouch(options.Layout)
		Gui.Setup()
		Library:OnUnload(Compat.RestoreAll)
		-- Compatibility diagnostics run only on explicit request, never at startup.
		if State.Language == "TH" then
			Fonts.LoadThaiAsync()
		end
		local window = Window.New(options)
		self.Window = window
		Float.Build()
		Watermark.Build(options.WatermarkTitle or window.Title)
		Watermark.SetVisible(options.Watermark ~= false)
		Configs.SetFolder(
			options.ConfigFolder or options.Folder or window.Title
		)
		local function Build()
			if Library.Unloaded then
				return
			end
			local built, failure = Util.Try(options.OnUnlocked)
			if not built and type(options.OnUnlocked) == "function" then
				window.BuildFailed = true
				local tab = window:AddTab(
					"Interface error",
					"info",
					"Initialization did not finish"
				)
				tab:AddLeftGroupbox("Build failed"):AddParagraph({
					Title = "Runtime incompatibility",
					Content = tostring(failure),
				})
				window:SelectTab(tab)
			end
			Layout.Flush()
		end
		local function Reveal()
			if Library.Unloaded then
				return
			end
			window.Ready = true
			window:SetVisible(true)
			if window.BuildFailed then
				Library:Notify(
					window.Title,
					"Interface build failed. See the Interface error tab.",
					8,
					"Warning"
				)
				return
			end
			Library:Notify(
				window.Title,
				Lang.Format(
					State.Touch and "ReadyTouch" or "Ready",
					Keybinds.Short(State.MenuKey)
				),
				5,
				"Power"
			)
		end
		local function Open()
			if Library.Unloaded then
				return
			end
			if options.Intro == false then
				Build()
				Reveal()
				return
			end
			local built = false
			task.spawn(function()
				Build()
				built = true
			end)
			local function WaitBuilt()
				while not built and not Library.Unloaded do
					task.wait()
				end
			end
			local steps = Lang.Strings.IntroSteps
			task.spawn(Intro.Play, {
				Title = window.Title,
				SubTitle = window.SubTitle,
				Steps = {
					{ Label = { EN = steps.EN[1], TH = steps.TH[1] } },
					{ Label = { EN = steps.EN[2], TH = steps.TH[2] } },
					{
						Label = { EN = steps.EN[3], TH = steps.TH[3] },
						Run = WaitBuilt,
					},
					{ Label = { EN = steps.EN[4], TH = steps.TH[4] } },
				},
				OnDone = Reveal,
			})
		end
		Open()
		return window
	end

	function Library:SetLanguage(code)
		if code ~= "EN" and code ~= "TH" then
			return
		end
		Lang.Set(code)
		local option = self.Options.MarioLanguage
		if option then
			option.Value = code == "TH" and "ไทย" or "English"
			option:Render()
		end
	end

	function Library:GetLanguage()
		return State.Language
	end

	function Library:T(english, thai)
		return { EN = english, TH = thai or english }
	end

	function Library:SetTheme(name)
		Theme.Apply(name)
		local option = self.Options.MarioTheme
		if option and option.Value ~= State.ThemeName then
			option.Value = State.ThemeName
			option:Render()
		end
	end

	function Library:SetAssets(map)
		Assets.Configure(map)
	end

	function Library:Notify(info, content, duration, kind)
		if type(info) == "table" and not info.EN then
			info, content, duration, kind =
				info.Title,
				info.Content or info.Description,
				info.Duration,
				info.Type or info.Icon
		end
		if self.Unloaded or not State.NotifyHost then
			return
		end
		Notify.Push(Lang.Resolve(info), content, duration, kind)
	end

	function Library:SetReducedMotion(enabled)
		State.ReducedMotion = enabled == true
		if enabled then
			State.TitleGlitch = false
			Particles.SetEnabled(false)
			for index = #Motion.Springs, 1, -1 do
				local spring = Motion.Springs[index]
				spring.Inst[spring.Prop] =
					Motion.Unpack(spring.Kind, spring.Goal)
				Motion.Remove(spring, true)
			end
		end
		for group in pairs(Anim.Loops) do
			Anim.SetGroupActive(group, not enabled)
		end
	end

	function Library:GetGuiParent()
		assert(State.Gui and State.Gui.Parent, "Nullx11 GUI is not initialized")
		return State.Gui.Parent
	end

	function Library:GetFPS()
		return math.floor(State.Fps + 0.5)
	end

	function Library:SetTitleGlitch(enabled)
		State.TitleGlitch = enabled == true
	end

	function Library:SetMenuKey(key)
		State.MenuKey = Util.KeyName(key) or State.MenuKey
	end

	function Library:Toggle()
		if self.Window then
			self.Window:Toggle()
		end
	end

	function Library:Every(interval, callback)
		Util.Every(interval, callback)
	end

	function Library:SaveConfig(name)
		return Configs.Save(name)
	end

	function Library:LoadConfig(name)
		return Configs.Load(name)
	end

	function Library:LoadAutoloadConfig()
		local name = Configs.GetAutoload()
		if not name then
			return
		end
		local ok, reason = Configs.Load(name)
		local message = ok
				and {
					EN = "Autoloaded: " .. name,
					TH = "โหลดอัตโนมัติ: " .. name,
				}
			or {
				EN = "Autoload failed: " .. tostring(reason),
				TH = "โหลดอัตโนมัติไม่สำเร็จ: "
					.. tostring(reason),
			}
		self:Notify(
			Lang.Strings.Configs,
			message,
			3,
			ok and "Success" or "Error"
		)
	end

	function Library:OnUnload(callback)
		table.insert(State.UnloadHooks, callback)
	end

	function Library:Unload()
		if self.Unloaded then
			return
		end
		self.Unloaded = true
		for _, callback in ipairs(State.UnloadHooks) do
			Util.Try(callback)
		end
		if Reactive and Reactive.DisposeAll then
			Reactive.DisposeAll()
		end
		if Motion then
			if Motion.Connection then
				Motion.Connection:Disconnect()
				Motion.Connection = nil
			end
			if Motion.Springs then
				table.clear(Motion.Springs)
			end
			if Motion.Tickers then
				table.clear(Motion.Tickers)
			end
		end
		for _, list in pairs(Anim.Loops or {}) do
			for _, entry in ipairs(list) do
				if entry.Tween then
					pcall(entry.Tween.Cancel, entry.Tween)
				end
			end
		end
		table.clear(Anim.Loops)
		table.clear(Anim.GroupState)
		for _, connection in ipairs(State.Connections) do
			connection:Disconnect()
		end
		table.clear(State.Connections)
		table.clear(State.KeyPickers)
		table.clear(State.Tasks)
		table.clear(Layout.Dirty)
		table.clear(Layout.All)
		table.clear(Layout.Measured)
		Layout.MeasuredCount = 0
		table.clear(Theme.Bound)
		table.clear(Theme.Renderers)
		table.clear(Theme.InstanceRenderers)
		table.clear(Lang.Bound)
		table.clear(Lang.Listeners)
		table.clear(Lang.InstanceListeners)
		table.clear(Fonts.Texts)
		State.Drag, State.Binding, State.Popup, State.Window, State.NotifyHost =
			nil, nil, nil, nil, nil
		if State.Gui then
			State.Gui:Destroy()
			State.Gui = nil
		end
	end

	Library.Configs = Configs
	Library.Compat = Compat
	Library.Themes = Themes.Order
	Library.Ref = Reactive.Ref
	Library.Computed = Reactive.Computed
	Library.Effect = Reactive.Effect
	Library.Watch = Reactive.Watch
	Library.Batch = Reactive.Batch
	Library.Store = Reactive.Store
	Library.IsRef = Reactive.IsRef
	Library.tw = Tailwind.Apply
	Library.h = Tailwind.CreateElement
	Library.Component = function(self, name, renderFn)
		if type(self) == "string" then
			return Tailwind.Component(self, name)
		end
		return Tailwind.Component(name, renderFn)
	end
	Library.Show = Tailwind.Show
	Library.For = Tailwind.For
	Library.Icons = Icons
	Library.Icon = function(self, parent, name, size, color)
		if typeof(self) == "Instance" then
			return Icons.Create(self, parent, name, size)
		end
		return Icons.Create(parent, name, size, color)
	end
	Library.Gui = Gui
	Library.Motion = Motion
	Library.Fx = Fx
	Library.Dialog = function(self, spec)
		return Dialog.Show(
			type(self) == "table" and self ~= Library and self or spec
		)
	end
	Library.CloseDialog = Dialog.Close
	Library.Sheet = function(self, spec)
		return Sheet.Show(
			type(self) == "table" and self ~= Library and self or spec
		)
	end
	Library.CloseSheet = Sheet.Close
	Library.Window = Library.CreateWindow

	return Library
end
local makeAdapter = (function()
	-- Compatibility bridge for the two supplied Gen2 controllers.
	-- Every control is a real shared-UI control; no Sirius download or placeholder UI.
	return function(library, title, folder)
		local adapter = {}
		local sequence = 0
		local function id(spec)
			sequence += 1
			return tostring(spec.flag or ("Control_" .. sequence))
		end
		local function handle(native, spec)
			local element = { Native = native, value = spec.value }
			function element:Set(value)
				if
					type(value) == "table"
					and (value.Title or value.Desc or value.Text)
				then
					if value.Title and native.SetTitle then
						native:SetTitle(value.Title)
					end
					if native.SetContent then
						native:SetContent(value.Desc or value.Text or "")
					end
					return
				end
				self.value = value
				if native.SetValue then
					native:SetValue(value)
				elseif native.SetText then
					native:SetText(tostring(value))
				end
			end
			function element:SetTitle(value)
				if native.SetTitle then
					native:SetTitle(value)
				elseif native.Row then
					native.Row:SetTitle(value)
				elseif native.SetText then
					native:SetText(value)
				end
			end
			function element:SetDesc(value)
				if native.SetContent then
					native:SetContent(value)
				elseif native.Row and native.Row.Desc then
					native.Row.Desc.Text = tostring(value)
					native.Container:MarkDirty()
				end
			end
			function element:Refresh(values)
				assert(native.SetValues, "This control is not a dropdown")
				native:SetValues(values)
			end
			element.Select = element.Set
			return element
		end
		function adapter:CreateWindow(_spec)
			local window = {}
			local native = library:CreateWindow({
				Title = "Nullx11",
				SubTitle = title .. " / NULL",
				ConfigFolder = folder,
				Theme = "Nullx11",
				MenuKey = Enum.KeyCode.LeftControl,
				Intro = false,
				Watermark = false,
			})
			window.Native = native
			window.settings = {}
			function window:CreateTab(spec)
				local tab = {
					Native = native:AddTab(
						spec.name or "Tab",
						spec.icon,
						spec.description or ""
					),
				}
				function tab:CreateSection(info)
					self.Group =
						self.Native:AddLeftGroupbox(info.name or "Controls")
					return self.Group
				end
				function tab:Container()
					if not self.Group then
						self.Group =
							self.Native:AddLeftGroupbox(spec.name or "Controls")
					end
					return self.Group
				end
				function tab:CreateToggle(info)
					return handle(
						self:Container():AddToggle(id(info), {
							Text = info.name,
							Description = info.description,
							Icon = info.icon,
							Default = info.value == true,
							Callback = info.callback,
						}),
						info
					)
				end
				function tab:CreateSlider(info)
					local step = tonumber(info.increment) or 1
					local decimals =
						math.clamp(math.ceil(-math.log10(step)), 0, 6)
					return handle(
						self:Container():AddSlider(id(info), {
							Text = info.name,
							Description = info.description,
							Icon = info.icon,
							Min = info.range[1],
							Max = info.range[2],
							Default = info.value,
							Rounding = decimals,
							Callback = info.callback,
						}),
						info
					)
				end
				function tab:CreateDropdown(info)
					return handle(
						self:Container():AddDropdown(id(info), {
							Text = info.name,
							Description = info.description,
							Icon = info.icon,
							Values = info.options or {},
							Multi = info.multi == true,
							Default = info.value,
							Callback = info.callback,
						}),
						info
					)
				end
				function tab:CreateInput(info)
					return handle(
						self:Container():AddInput(id(info), {
							Text = info.name,
							Description = info.description,
							Icon = info.icon,
							Default = info.value or "",
							Placeholder = info.placeholder,
							Finished = true,
							Callback = info.callback,
						}),
						info
					)
				end
				function tab:CreateButton(info)
					return handle(
						self:Container():AddButton({
							Text = info.name,
							Func = info.callback,
						}),
						info
					)
				end
				function tab:CreateText(info)
					return handle(
						self:Container():AddParagraph({
							Title = info.name or "Status",
							Content = info.text or info.description or "",
						}),
						info
					)
				end
				function tab:CreateDivider()
					return self:Container():AddDivider()
				end
				function tab:Select()
					native:SelectTab(self.Native)
				end
				return tab
			end
			function window:SelectTab(index)
				local tab = native.Tabs[index]
				if tab then
					native:SelectTab(tab)
				end
			end
			function window:Notify(info)
				library:Notify(
					info.Title or info.title or title,
					info.content or info.Content or "",
					info.duration or info.Duration or 4
				)
			end
			function window:ChangeTheme(theme)
				library:SetTheme(type(theme) == "string" and theme or "Nullx11")
			end
			function window:SetTransparency(value)
				local number = type(value) == "boolean" and (value and 0.2 or 0)
					or tonumber(value)
				if number then
					native.Body.BackgroundTransparency =
						math.clamp(number, 0, 0.8)
				end
			end
			function window:SetToggleKey(key)
				library:SetMenuKey(key)
			end
			function window:Unload()
				library:Unload()
			end
			function window:OnDestroy(callback)
				library:OnUnload(callback)
			end
			local manager = {}
			function manager:DeleteConfig(name)
				return library.Configs.Delete(name)
			end
			function manager:AllConfigs()
				return library.Configs.List()
			end
			function manager:CreateConfig(name)
				local config = { Controls = {} }
				function config:Register(key, element)
					assert(
						type(key) == "string" and element.Native,
						"Invalid configuration control"
					)
					self.Controls[key] = element.Native
				end
				function config:Save()
					local ok, reason = library:SaveConfig(name)
					assert(ok, reason or "Configuration save failed")
				end
				function config:Load()
					local ok, reason = library:LoadConfig(name)
					assert(ok, reason or "Configuration load failed")
				end
				function config:Delete()
					local ok, reason = library.Configs.Delete(name)
					assert(ok, reason or "Configuration delete failed")
				end
				return config
			end
			window.ConfigManager = manager
			return window
		end
		return adapter
	end
end)()
local makeSession = (function()
	-- One selected game session. Bundles include this module, not the loader.
	return function(key, library)
		local context = {
			Alive = true,
			Library = library,
			Connections = {},
			Sent = 0,
			NextSend = 0,
		}
		local env = type(getgenv) == "function" and getgenv() or _G
		env.Nullx11GameSessions = env.Nullx11GameSessions or {}
		local previous = env.Nullx11GameSessions[key]
		if previous and type(previous.Unload) == "function" then
			pcall(previous.Unload)
		end
		local session = { Library = library }
		function session.Unload()
			if not context.Alive then
				return
			end
			context.Alive = false
			for _, connection in ipairs(context.Connections) do
				pcall(connection.Disconnect, connection)
			end
			table.clear(context.Connections)
			library:Unload()
			if env.Nullx11GameSessions[key] == session then
				env.Nullx11GameSessions[key] = nil
			end
		end
		function context.Connect(signal, callback)
			local connection = signal:Connect(function(...)
				if context.Alive then
					callback(...)
				end
			end)
			table.insert(context.Connections, connection)
			return connection
		end
		-- The forge source used enormous worker bursts. Serialize its explicit remote
		-- requests to at most eight a second; waiting work is cancelled on unload.
		-- A budget is not a claim that the server accepts any action.
		function context.Send(remote, method, ...)
			local function allowed()
				return context.Alive
					or context.CleanupThread
						== (coroutine.running() or context)
			end
			while allowed() and os.clock() < context.NextSend do
				task.wait(math.min(0.125, context.NextSend - os.clock()))
			end
			assert(allowed(), "Nullx11 game session stopped")
			context.NextSend = os.clock() + 0.125
			context.Sent += 1
			return remote[method](remote, ...)
		end
		-- Revalidate feature/generation after pacing waits, before sending anything.
		function context.SendWhen(predicate, remote, method, ...)
			while
				context.Alive
				and predicate()
				and os.clock() < context.NextSend
			do
				task.wait(math.min(0.125, context.NextSend - os.clock()))
			end
			if not context.Alive or not predicate() then
				return nil, "cancelled"
			end
			context.NextSend = os.clock() + 0.125
			context.Sent += 1
			return remote[method](remote, ...)
		end
		function context.RegisterCleanup(callback)
			library:OnUnload(function()
				context.CleanupThread = coroutine.running() or context
				local ok, reason = pcall(callback)
				context.CleanupThread = nil
				if not ok then
					warn("[Nullx11 cleanup] " .. tostring(reason))
				end
			end)
		end
		library:OnUnload(function()
			context.Alive = false
			for _, connection in ipairs(context.Connections) do
				pcall(connection.Disconnect, connection)
			end
			table.clear(context.Connections)
			if env.Nullx11GameSessions[key] == session then
				env.Nullx11GameSessions[key] = nil
			end
		end)
		env.Nullx11GameSessions[key] = session
		return context
	end
end)()

local wrongPlace = (function()
	-- Compatibility notice only. Never teleports, queues code or starts a controller.
	return function(library, entry, _url)
		library:CreateWindow({
			Title = "Nullx11",
			SubTitle = entry.Name .. " / NULL",
			Theme = "Nullx11",
			Intro = false,
			Watermark = false,
			ConfigFolder = "Nullx11 Launch " .. entry.Id,
			OnUnlocked = function()
				local tab = library.Window:AddTab(
					"Compatibility",
					"info",
					"Join the game manually"
				)
				local group = tab:AddLeftGroupbox("Unsupported game")
				group:AddParagraph({
					Title = "Cannot start here",
					Content = "Required game/place compatibility was not detected. Join the intended game manually and execute again. No teleport or automatic execution was requested.",
				})
				group:AddParagraph({
					Title = "Credits",
					Content = entry.Author or "Developed by NULL",
				})
				group:AddButton({
					Text = "Close",
					Func = function()
						library:Unload()
					end,
				})
			end,
		})
	end
end)()
local function runGame(context)
	-- Nullx11 port; +1 controller adapted from xDTaraZ with user-reported permission.
	local getgenv = type(getgenv) == "function" and getgenv
		or function()
			return _G
		end
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	if game.PlaceId ~= 118805555015549 then
		warn("[Nullx11] +1 Loot to Forge skipped: wrong place")
		return
	end

	local Nullx11Banner = {
		Print = print,
		Started = os.clock(),
		Last = os.clock(),
		Done = 0,
		Total = 4,
	}

	do
		local ok, renv = pcall(getrenv)
		if ok and type(renv) == "table" and type(renv.print) == "function" then
			Nullx11Banner.Print = renv.print
		end
	end

	function Nullx11Banner.Show()
		local ok, executor = pcall(identifyexecutor)
		if not ok or type(executor) ~= "string" then
			executor = "Unknown"
		end
		local rule = string.rep("=", 54)
		Nullx11Banner.Print(table.concat({
			"",
			[[
                                                                     @%@
                                                                    @*-#@
                                          @@@@@@@@@@@@@          @@#+.:-*%@@      @@
                                   @@@@@%##***********##%@@@@@   @*--:-==+*@@@@#*+==+*%@@
                              @@@@#+=+==---==++++++++++++**+++#@@@@@%==+@@@@#:.......:::=%@@
                          @@%#+---::-=++++++++++************+***++#%@%+@@@#:..-+*****+-:::+%@
                      @@@#=-::.:-==++++++++++*************************#@@+::=*-:.:+-::-+:.:=#@
                    @@%-:...:-===+++++**#################****************%%*+::::+*++::-+..:=#@
                 @@%*-:...:--==++*########**+==--===+**#######************+#%+::-*==-:::=-::=+@@
               @@%+=-::---===+*###%#+-:...................:=+#####***********#@+++==----==:-+*@@
             @@%++=-======+*###%+:............................::+####**********#@*+=----=---**@@
            @%=++=++++++*####=:...................................:+###**********%@==--==--+**@@
          @@*+++++++++*###*:........................................:-*##**********%*==+--=**@@@
         @%+++++++++*##%+:............................................::*##*********%%+--=##%@+%@
       @@#+++++++++###*:.....-+==+*#-......................:**+**#+:....:=###********%%+*##%@*:+@@
      @@*++++++++*###:......-+:.:-=*#*-..................:+*--+**#%*:.....:+##********#@#%%+:.:--+#@
     @@+++++++++*##+:......-*::-=++++*##:...............=#=-++****#%*:.....:-##********#@@@%+=-++#@@
    @@+=-=+++++*##+.......:*-:==++++++*##+............-*+-=+*******#%+:.....:-##********#@  @#=#@@
    @*=:.=++++*##-.......:*=:=++++++++*+*##=........:**==+**********##=:.....::*#********%@  @#@
   @#+-.-++*+*##=........*+-++++++*********##-....:+*==+*************#%-:.....:-**********%@
  @@++-=++***##+........*+-++++++***********#%*::=#+-+****************#%-:.....:=**********@@
 @@*++=++***###........+*-+++++***************###+-=+*****************###-:.....:+*********%@
 @%++=+*****#%:.......=*-++++*******************==+********************#%*-:....:-#********#@@
@@**+++****##+.......=*=+++*********************************************#%+::....:+*********@@
@%**++*****##-......=#=++**********#%#********************%%*************#%+:....:-#********%@
@%**++*****#*:.....-*=++**********#%%%#*****************#%%%**************#%=:....-********##@@
@#**++*****#*:....:*++************%%%%%%#*************#%%%%%#**************##-:...-+*******#*@@
@#**+******#+:...:#++************#%%%@@%%##*********#%%%%%@%#**************#%#-:..:+*+*****#*@@
@#**+******#+:..:#+=************#%%%%%*%%%##*******%%%%%%#%%##**************#%#::.-+*+*****#*@@
@#*********#+:.:+*=*************%%%%%+==*%%###***#%%%%%#++*%##***************#%*::-+*+*****#*@@
@%*#*******#*:.+*=*************%%%%%*=----*%###%%%%%%#+====*###**************##%+--*++****###@@
@%*#********#-:####***********#%%%%#=-::.::=###%%%%#+==--:::####************#%%%#==*+*****###@@
@@##********#+:#%%%%#********#%%%%%=--:....::=%%%%+==--::..:-%###********#%%%%%%#=#++*****##%@
@@###********#-=#%%%%%%##****%%%%%*=-:.......::-==---::.....:+###*****##%%%%%%%#++#++****###@@
 @%###*******##::=+%%%%%%%##%%%%%#=-:...........:::::........:####*#%%%%%%%%%*+=+*+=*****##%@
 @@###********#+:.:-=*%%%%%%%%%%%+--:.........................=###%%%%%%%%*+====*=.=****###@@
  @@###********#+:..::-=*%%%%%%%*=-:..:::-------------::::...::*#%%%%%%*+==---=*+-=+***###%@
   @%###*******#%#*+-..::-=#%@@%#**++==----------------===+++**#%@@@#+===---+*#*++****####@@
    @%###**#%#=::-=+##*##+-:...:::-=+**---*###*=--++++=--=++++=--:::-=+#%**#-:..:=#%##%##@@
    @@%#%#+:...:-=++=:..::=*####+#=:..=@#%:....%@*....*%%#...:--=*##+------=+=:::::-=#%%@@
     @@%*=--::::-*::::::-%=...:%@#:...:@@#.....%@+....=@@=.........:*#=-----=+=:::-==++%@@
  @@%+--+==--:::-#=-::::-%+....+%%-....%@#....:@@+....+@@:...:%%....-@*---==+*+:::-=+++*=+#@@
 @%-:-==*+==-:::-+*--:::-*#:...........*@#....:@@+....+@%..........-%%+---==+*=::-=+++#*=-:-*@@
 @@#+===+*+==-::-=*=--::-=%-......:....+@%:....:-....:#@*....=+:...-%#=--==+**-:--=++#*+=-=*%@
   @@#*=++#+=-:::-+*------#+....+@%....-@@#:.......::*@@+....+#=.:::=%+-===+#+-:-=++***++*%@@
     @@#+++*==-::-=*=-----+%:...-@@-::-=@%%@#+=--==*%@%%=:::::::::::#%+===+**----=++#**#%@@
     @@*-=+*+=-::-=*+=----=%#+*#%@%@@@@@#+-=*%%@@@%#*==*@@%%%##*+*#@@*====+#+-:-=++***++%@
    @@*--=+++===++*#*=------#%%#+=-----===============----==+*#%%%#+=-===+*#*+++=++**+==*@@
    @%=:-==+***%%@@@#=-=====++*##%%%@@@@@@@@@@%%@@@@@@@@@%%%##**++=======+*@@@@%#*+#+=--=#@
    @*:---==+*###%@@@#*#%%@%%%%%%######*****++++++++***######%%%%%%%%%%#*#%@@@####**+=---+@@
   @@+--=**#%@@@@@  @@@%%%%%%%#*******************************####%%%%%%@@@  @@@@@%#**=--+%@
    @@%%@@@@@          @@@@%%%%%%###**********************####%%%%%%%@@@          @@@@@%%%@@
      @@                  @@@@@%%%%%%%%%###############%%%%%%%%%@@@@@                  @@@
                               @@@@@@%%%%%%%%%%%%%%%%%%%%%%@@@@@
                                    @@@@@@@@@@@@@@@@@@@@@@@
]],
			[[
  __  __    _    ____  ___ ___    _   _ _   _ ____
 |  \/  |  / \  |  _ \|_ _/ _ \  | | | | | | | __ )
 | |\/| | / _ \ | |_) || | | | | | |_| | | | |  _ \
 | |  | |/ ___ \|  _ < | | |_| | |  _  | |_| | |_) |
 |_|  |_/_/   \_\_| \_\___\___/  |_| |_|\___/|____/
]],
			rule,
			"   LOOT TO FORGE  //  by Nullx11Forge",
			"   executor: "
				.. executor
				.. "   //   player: "
				.. game:GetService("Players").LocalPlayer.Name,
			rule,
		}, "\n"))
	end

	---@param label string
	function Nullx11Banner.Step(label)
		local now = os.clock()
		Nullx11Banner.Done =
			math.min(Nullx11Banner.Done + 1, Nullx11Banner.Total)
		local filled =
			math.floor(Nullx11Banner.Done / Nullx11Banner.Total * 20 + 0.5)
		Nullx11Banner.Print(
			string.format(
				"[Nullx11 - +1 loot to forge] [%s] %3d%%  %-24s +%dms",
				string.rep("#", filled) .. string.rep(".", 20 - filled),
				math.floor(Nullx11Banner.Done / Nullx11Banner.Total * 100),
				label,
				math.floor((now - Nullx11Banner.Last) * 1000)
			)
		)
		Nullx11Banner.Last = now
	end

	function Nullx11Banner.Ready()
		local rule = string.rep("=", 54)
		Nullx11Banner.Print(table.concat({
			rule,
			string.format(
				"   >> READY in %dms",
				math.floor((os.clock() - Nullx11Banner.Started) * 1000)
			),
			rule,
		}, "\n"))
	end

	pcall(Nullx11Banner.Show)
	pcall(Nullx11Banner.Step, "Core")

	local function LPH_JIT(fn)
		return fn
	end
	local LPH_JIT_MAX, LPH_NO_VIRTUALIZE = LPH_JIT, LPH_JIT

	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local UserInputService = game:GetService("UserInputService")
	local VirtualUser = game:GetService("VirtualUser")
	local RunService = game:GetService("RunService")
	local GuiService = game:GetService("GuiService")
	local TeleportService = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local StarterGui = game:GetService("StarterGui")

	local LocalPlayer = Players.LocalPlayer

	local Nullx11Forge = setmetatable({}, {
		__newindex = function(self, key, value)
			rawset(
				self,
				key,
				type(value) == "function" and LPH_JIT(value) or value
			)
		end,
	})

	Nullx11Forge.Config = {
		SaveFolder = "Nullx11 Forge",
		UpdateLog = {
			{
				"2026-10-14",
				"Autonomous Egg2 Hatching & Auto-Incubate Watchdog\nAccurate Server Timer Sync & Zero-Crash Status UI\nTargeted Legendary Honor Hunt & Auto Egg Trimming\nFull Combat Aura, God Ore Spawning & Rebirth Farm",
			},
			{
				"2026-10-13",
				"Map-Wide Insane Kill Aura (SuperLoot + All Mobs + World Boss)\nInstant God Ore Spawner & Stage 27 Tier 48 farm\nFast Tower Season Coins and shop automation\nDeadlock-free cached profile & enhanced scheduler",
			},
		},
		ExecuteAfterHop = false,
		ReloadSource = [[
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 118805555015549 then return end
local body = game:HttpGet("https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/Nullx11-Forge.luau", true)
assert(type(body) == "string" and #body <= 2097152, "Invalid selected game bundle")
local run, reason = loadstring(body, "Nullx11Forge")
assert(run, reason)
run()]],
		LoadTimeout = 30,
		RemoteTimeout = 10,
		RequireTimeout = 3,
		MaxFailures = 5,
		FailWindow = 10,
		AlertTries = 20,
		AlertDelay = 0.5,
		TickDelay = 0.15,
		StatusInterval = 1.5,
		PumpInterval = 0.2,
		OwnedOresLabel = "Owned ores",
		AcquireRounds = 5,
		StoneWorkers = 2,
		StoneCallsPerWorker = 3,
		EggFarmWorkers = 2,
		EggFarmCalls = 3,
		TurboFarmWorkers = 2,
		TurboFarmCalls = 3,
		TurboBurstCount = 24,
		PetInterval = 0.5,
		PetDeployInterval = 15,
		TowerWorkers = 2,
		CoinFarmTimeout = 600,
		TowerCallsPerWorker = 3,
		GearForgeTries = 15,
		GearEnhanceTries = 2,
		GearEnhanceWorkers = 2,
		SlotEnhanceRounds = 200,
		ClickInterval = 0.12,
		ForgeTargets = {
			{ name = "Great Weapon", forgeType = "Weapon", ores = 13 },
			{ name = "Katana", forgeType = "Weapon", ores = 4 },
			{ name = "Armor", forgeType = "Armor", ores = 11 },
			{ name = "Hat", forgeType = "Armor", ores = 4 },
		},
		GearSlots = {
			{ slot = "Weapon", forgeType = "Weapon", ores = 13 },
			{ slot = "Armor", forgeType = "Armor", ores = 11 },
			{ slot = "Hat", forgeType = "Armor", ores = 4 },
		},
		GearTypes = { "Weapon", "Armor", "Hat" },
		EnchantPriority = {
			"Poison_3",
			"Thunder_3",
			"Ice_3",
			"Fire_3",
			"Poison_2",
			"Thunder_2",
			"Ice_2",
			"Fire_2",
		},
		RuneMinTier = 2,
		EnchantRefill = 50,
		ForgeCountMax = 30,
		PlanSlice = 0.004,
		HuntBatch = 40,
		HuntWorkers = 4,
		HuntMaxForges = 4000,
		HuntTargetHits = 3,
		IndexInterval = 60,
		IndexLevelClaims = 50,
		ClaimIdScan = 20,
		LookKinds = {
			"Ore",
			"EnchStone",
			"Weapon",
			"Armor",
			"Material",
			"Class",
			"Pet",
			"Egg",
			"Food",
		},
		TokenShopInterval = 60,
		ClaimInterval = 30,
		SeasonInterval = 60,
		BossCards = 8,
		BossAttackIds = { Katana = "K_ATK_1", Great = "G_ATK_1" },
		BossHitsPerTick = 30,
		BossHitGap = 0.02,
		BossJoinSettle = 1,
		BossClaimDelay = 3.5,
		BossStandHeight = 3,
		BossStandBack = 8,
		BossReach = 25,
		UpgradeInterval = 5,
		EquipInterval = 3,
		SellInterval = 1,
		RebirthInterval = 2,
		BossInterval = 1,
		BossHopInterval = 5,
		BossHopAfter = 8,
		BossLootTimeout = 30,
		BossHopFlag = "bosshop.txt",
		BossHopResume = 180,
		BossHopServers = "bossservers.json",
		HopListTtl = 120,
		HopBackoffStart = 5,
		HopBackoffMax = 60,
		HopGiveUp = 8,
		HopStall = 30,
		HopGap = 15,
		TrainRejoinDelay = 0.3,
		TrainWatchdog = 3,
		TrainAcceptWait = 1.5,
		TrainExitTries = 3,
		TrainSettle = 0.5,
		WarnCooldown = 30,
		WarnMemory = 64,
		KillAuraInterval = 0.12,
		KillDamage = 1e30,
		RaceRollDelay = 0.15,
		RaceResultWait = 2,
		RaceProtectRarity = "Mythic",
		RaceSlots = { "Equipped", "Slot 1", "Slot 2", "Slot 3" },
		RejoinDelay = 5,
		CodeReplyWait = 1.5,
		Codes = { "100000CCU", "50000CCU", "30000CCU", "20000CCU" },
		Needs = {
			AutoBattle = {
				"Utils.CommunicationUtils",
				"CTRL.EnemyCTRL",
				"Config.Stage.Helper",
			},
			AutoCheckIn = {
				"LocalData.PlanKData",
				"Remote.PlanKing_Server.TryClaimRE",
				"Config.PlanK.Config",
			},
			AutoTokenShop = {
				"Config.TokenShop.Config",
				"Remote.TokenShop_Server.OpenGoodsRE",
				"Remote.TokenShop_Server.ExchangeGoodsRF",
			},
			KillAura = { "Utils.CommunicationUtils" },
			CollectOre = {
				"Remote.Stage_Server.StageFinishedRF",
				"Remote.Stage_Server.GetOreRF",
				"Remote.Stage_Server.ClaimedAllOreRE",
				"Config.Stage.Helper",
				"Config.Ore.Config",
			},
			SuperLootAura = {
				"Remote.SuperLoot_Server.KillSuperLootRE",
				"Remote.SuperLoot_Server.RefreshSuperLootRE",
				"Remote.Stage_Server.GetOreRF",
			},
			AutoWorldBoss = {
				"Remote.WorldBoss_Server.IntoWorldBossFightRE",
				"Remote.WorldBoss_Server.ExitWorldBossFightRE",
				"Remote.WorldBoss_Server.BossDeadRE",
				"Remote.Attack_Server.UseAnyATKRE",
				"Remote.Attack_Server.AttackEnemyServiceRE",
			},
			AutoIndex = {
				"Remote.Forge_Server.ForgeRF",
				"Remote.Index_Server.TryClaimIndexExpRF",
				"Utils.ForgeUtils",
				"Config.Weapon.Config",
				"Config.Armor.Config",
			},
			MaxGear = {
				"Utils.BalanceUtils",
				"Remote.Forge_Server.ForgeRF",
				"Remote.Backpack_Server.EnhantEquipmentRF",
				"Remote.Backpack_Server.EnchantRE",
				"Config.Enhant.Config",
				"Config.EnchStone.Show",
			},
			AutoEquip = {
				"Utils.BalanceUtils",
				"Remote.Backpack_Server.TryEquipItemRE",
				"Config.Weapon.Helper",
				"Config.Armor.Helper",
			},
			AutoForge = {
				"Remote.Forge_Server.ForgeRF",
				"Remote.Backpack_Server.TrySellItemRE",
				"Config.Ore.Config",
			},
			AutoSell = {
				"Remote.Backpack_Server.TrySellItemRE",
				"Config.Weapon.Config",
				"Config.Armor.Config",
			},
			AutoTrain = {
				"Remote.Train_Server.IntoAutoTrainRE",
				"Remote.Train_Server.ExitAutoTrainRE",
				"Config.TrainArea.Config",
			},
			AutoRebirth = {
				"Remote.Rebirth_Server.TryRebirthRE",
				"Config.Rebirth.Helper",
			},
			AutoUpgrade = {
				"Remote.Upgrade_Server.UpgradeOnceRE",
				"Config.Upgrade.Config",
			},
			AutoTower = {
				"Remote.Dungeon_Server.TryIntoDungeonRF",
				"Remote.Dungeon_Server.StartRoundRE",
				"Remote.Dungeon_Server.CompleteRoundRF",
				"Config.Dungeon.Config.LootTab",
			},
			RaceBuyRolls = {
				"Config.Season.GoodsConfig",
				"Remote.Season_Server.ExchangeGoodsRE",
				"LocalData.ClassData",
			},
			AutoSeason = {
				"Remote.Season_Server.TryClaimDailyTicRE",
				"Remote.Season_Server.ExchangeGoodsRE",
				"Remote.Season_Server.LuckRE",
				"Config.Season.GoodsConfig",
			},
			AutoClaim = {
				"Remote.Offline_Server.TryClaimOfflineRewardRE",
				"Remote.Online_Server.TryClaimRE",
			},
			AutoRace = {
				"Remote.Class_Server.LuckOnceRE",
				"Config.Class.Config",
			},
			AutoBestRace = {
				"Remote.Class_Server.ChangeEquipedIndexRE",
				"Config.Class.Config",
			},
			AutoHatchEgg = {
				"Remote.Pet_Server.TryHatchEggRE",
				"Remote.Pet_Server.TryOpenEggRE",
				"Config.Egg.Config",
			},
			AutoEquipPet = {
				"Remote.Pet_Server.IsEquipPetRE",
				"Utils.BalanceUtils",
				"Config.Pet.Config",
			},
			AutoFeedPet = {
				"Remote.Pet_Server.FeedPetRE",
				"Config.Pet.Helper",
				"Config.Food.Config",
			},
			AutoDeployPet = {
				"Remote.Pet_Server.IsDeployPetRE",
				"Remote.Pet_Server.ClaimAllDeployRewardRE",
				"Config.Pet.Config",
			},
			AutoSellPet = {
				"Remote.Pet_Server.DeleteRE",
				"Config.Pet.Config",
				"Config.Egg.Config",
			},
			KeepOre = { "Remote.Stage_Server.LostAllOreRF" },
		},
		KaitunToggles = {
			"MaxGear",
			"AutoEquip",
			"AutoForge",
			"AutoSell",
			"AutoTrain",
			"AutoRebirth",
			"AutoUpgrade",
			"AutoClaim",
			"AutoCheckIn",
			"AutoSeason",
			"KillAura",
			"SuperLootAura",
			"AutoWorldBoss",
			"AutoTower",
			"GodMode",
			"AutoBestRace",
			"AutoHatchEgg",
			"AutoEquipPet",
			"AutoFeedPet",
			"AutoDeployPet",
		},
	}

	local Config = Nullx11Forge.Config
	local Remote = ReplicatedStorage:WaitForChild("Remote", Config.LoadTimeout)
	local GameConfig =
		ReplicatedStorage:WaitForChild("Config", Config.LoadTimeout)

	Nullx11Forge.State = {
		Alive = true,
		Busy = false,
		Rolling = false,
		SavedSpot = nil,
		Rejoining = false,
		Lock = nil,
		LockOwner = nil,
		LockTime = 0,
		Profile = nil,
		ProfileTime = 0,
		ProfileCacheTtl = 0.35,
		Failures = {},
		Halted = {},
		InTower = false,
		Entering = false,
		GearForged = false,
		TrainArea = nil,
		TrainPending = nil,
		TrainEntering = false,
		TrainGen = 0,
		TrainFiredAt = 0,
		TrainRebirth = nil,
		BossReturn = nil,
		TrainLevel = nil,
		TrainNilSince = nil,
		Warned = {},
		WarnedCount = 0,
		LastRun = {},
		RemoteCache = {},
		JobRunning = {},
		WorkerBatches = {},
		ChildThreads = {},
		JobGroups = {},
		JobStats = {},
		ScheduleCursor = 0,
		LootPending = {},
		LootQueue = {},
		LootSeen = {},
		GearNote = nil,
		IndexNote = nil,
		TowerLoot = 0,
		OreLabels = {},
		GearLabels = {},
		SpawnLabels = {},
		BossHopping = false,
		HopFails = 0,
		HopBackoff = nil,
		HopBlockedUntil = 0,
		HopQueued = false,
		BossDone = nil,
		MissingLabels = {},
		OreStage = {},
		Plans = {},
		Runes = nil,
		Conns = {},
		AuraCursor = 0,
		Opt = {
			MaxGear = false,
			AutoEquip = false,
			EnhanceTarget = 20,
			GearForge = true,
			GearEnchant = true,
			GearEnhance = true,
			EnchantPriority = {},
			EnhanceSlot = "Weapon",
			ForgeSellJunk = false,
			ForgePerTick = 1,
			BossCards = true,
			SeasonSpin = true,
			SeasonSpinBatch = 10,
			SeasonGoods = { ["4"] = true, ["5"] = true, ["7"] = true },
			AutoBestRace = false,
			GodMode = false,
			KeepOre = false,
			CollectOre = false,
			Stage = "Stage_27",
			CollectRarities = {},
			KillAura = false,
			AutoBattle = false,
			AutoCheckIn = false,
			TokenReveal = true,
			TokenTargets = {},
			TokenSkipOwned = true,
			AuraMapWide = true,
			AuraRange = 0,
			AuraBatch = 60,
			AuraBurst = 1,
			AuraInterval = 0.12,
			AuraDamage = 1e30,
			AuraCritical = true,
			AuraSuper = true,
			AuraTarget = "All",
			AutoCollectDrops = true,
			JobTimeout = 60,
			WorkerLimit = 2,
			ParallelJobs = 2,
			SuperLootAura = false,
			AutoWorldBoss = false,
			BossHop = false,
			BossWaitMinutes = 2.5,
			AutoForge = false,
			ForgeTarget = "Great Weapon",
			ForgeOre = nil,
			ForgeRarities = {},
			KeepPerOre = 0,
			BestOreFirst = false,
			AutoSell = false,
			SellTypes = { Weapon = true, Armor = true, Hat = true },
			SellRarities = {},
			KeepPerItem = 1,
			AutoIndex = false,
			IndexTypes = { Weapon = true, Armor = true, Hat = true },
			MissingItem = nil,
			AutoTrain = false,
			AutoClick = false,
			AutoRebirth = false,
			AutoUpgrade = false,
			Upgrades = {},
			AutoClaim = false,
			AutoSeason = false,
			AutoTokenShop = false,
			AutoTower = false,
			AutoRace = false,
			RaceTargets = {},
			RaceMinLevel = nil,
			RaceStar = 0,
			RaceSlot = "Equipped",
			RaceLock = false,
			RaceProtect = false,
			RaceBuyRolls = true,
			RaceAnim = false,
			AutoHatchEgg = false,
			TargetPet = nil,
			TargetPetCopies = 1,
			AutoChaseTargetPet = false,
			AutoLockTargetPet = true,
			HatchBestFirst = true,
			SkipEggAnim = true,
			AutoEquipPet = false,
			AutoFeedPet = false,
			AutoDeployPet = false,
			AutoSellPet = false,
			DeletePetRarities = { Common = true, UnCommon = true, Rare = true },
			KeepBestPets = 6,
			AutoDeleteEggs = false,
			KeepPerEgg = 10,
			EggFarmRounds = 10,
			CoinTarget = 50000,
			SpawnItem = nil,
			SpawnAmount = 1000,
			TurboSpawn = false,
			TurboBurst = 24,
			PotionAmount = 1000,
			SpawnGear = nil,
			GearCopies = 1,
			SpeedOn = false,
			WalkSpeed = 60,
			InfJump = false,
			AutoRejoin = false,
			AntiIdle = false,
			LowGraphics = false,
		},
	}

	local State = Nullx11Forge.State

	Nullx11Forge.GameLib =
		{ Loaded = {}, Failed = {}, Apis = {}, Deferred = {} }

	---@param module Instance
	---@return boolean, any
	function Nullx11Forge.GameLib.RequireAsGame(module)
		local done, ok, loaded = false, false, nil
		local thread = Nullx11Forge.Util.Child(function()
			pcall(setthreadidentity, 2)
			local read, identity = pcall(getthreadidentity)
			if read and identity == 2 then
				ok, loaded = pcall(require, module)
			end
			done = true
		end)
		local deadline = os.clock() + Config.RequireTimeout
		while not done and os.clock() < deadline do
			task.wait()
		end
		if not done then
			pcall(task.cancel, thread)
			return false, "module require timed out"
		end
		return ok, loaded
	end

	---@param module Instance
	---@return table?
	function Nullx11Forge.GameLib.Require(module)
		local cached = Nullx11Forge.GameLib.Loaded[module]
		if cached ~= nil or Nullx11Forge.GameLib.Failed[module] then
			return cached
		end

		local result
		local thread = Nullx11Forge.Util.Child(function()
			result = table.pack(pcall(require, module))
		end)
		local deadline = os.clock() + Config.RequireTimeout
		while not result and os.clock() < deadline do
			task.wait()
		end
		if not result then
			pcall(task.cancel, thread)
			result = { false, "module require timed out" }
		end
		local ok, loaded = result[1], result[2]
		if not ok then
			local firstErr = loaded
			ok, loaded = Nullx11Forge.GameLib.RequireAsGame(module)
			if not ok then
				Nullx11Forge.GameLib.Failed[module] = tostring(firstErr)
				warn("[Nullx11 Forge] require", module:GetFullName(), firstErr)
				return nil
			end
		end
		Nullx11Forge.GameLib.Loaded[module] = loaded
		return loaded
	end

	---@param fn function
	---@return boolean, any ...
	function Nullx11Forge.GameLib.CallAsGame(fn, ...)
		local args = table.pack(...)
		local box
		local thread = Nullx11Forge.Util.Child(function()
			pcall(setthreadidentity, 2)
			box = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
		end)
		local deadline = os.clock() + Config.RequireTimeout
		while not box and os.clock() < deadline do
			task.wait()
		end
		if not box then
			pcall(task.cancel, thread)
			return false, "game call timed out"
		end
		return table.unpack(box, 1, box.n)
	end

	---@param fn function
	---@return any ...
	function Nullx11Forge.GameLib.Call(fn, ...)
		if not Nullx11Forge.GameLib.Deferred[fn] then
			local result = table.pack(pcall(fn, ...))
			if
				result[1]
				or not tostring(result[2]):find("non-RobloxScript", 1, true)
			then
				if not result[1] then
					error(result[2], 0)
				end
				return table.unpack(result, 2, result.n)
			end
			Nullx11Forge.GameLib.Deferred[fn] = true
		end
		local result = table.pack(Nullx11Forge.GameLib.CallAsGame(fn, ...))
		if not result[1] then
			error(result[2], 0)
		end
		return table.unpack(result, 2, result.n)
	end

	---@param module Instance
	---@return table
	function Nullx11Forge.GameLib.Api(module)
		local api = Nullx11Forge.GameLib.Apis[module]
		if api then
			return api
		end
		local loaded = Nullx11Forge.GameLib.Need(module)
		api = setmetatable({}, {
			__index = function(self, key)
				local value = loaded[key]
				if type(value) ~= "function" then
					return value
				end
				local wrapped = function(...)
					return Nullx11Forge.GameLib.Call(value, ...)
				end
				rawset(self, key, wrapped)
				return wrapped
			end,
		})
		Nullx11Forge.GameLib.Apis[module] = api
		return api
	end

	---@param module Instance
	---@return table
	function Nullx11Forge.GameLib.Need(module)
		local loaded = Nullx11Forge.GameLib.Require(module)
		if loaded == nil then
			error(
				("game data %s.%s can't be read on this executor"):format(
					module.Parent.Name,
					module.Name
				),
				0
			)
		end
		return loaded
	end

	---@param path string
	---@return Instance?
	function Nullx11Forge.GameLib.Find(path)
		local node = ReplicatedStorage
		for part in path:gmatch("[^%.]+") do
			node = node and node:FindFirstChild(part)
		end
		if node then
			return node
		end
		local folder, name = path:match("^Remote%.([^%.]+)%.([^%.]+)$")
		return folder and Nullx11Forge.Util.FindRemote(folder, name)
	end

	---@return table
	function Nullx11Forge.GameLib.Missing()
		local missing = {}
		for idx, paths in pairs(Config.Needs) do
			for _, path in ipairs(paths) do
				if not Nullx11Forge.GameLib.Find(path) then
					missing[idx] = missing[idx] or {}
					table.insert(missing[idx], path)
				end
			end
		end
		return missing
	end

	for _, name in ipairs({
		"Util",
		"Data",
		"Stage",
		"Ore",
		"Spawn",
		"Potion",
		"Forge",
		"Sell",
		"Gear",
		"Index",
		"Level",
		"Upgrade",
		"Tower",
		"Boss",
		"Season",
		"Claim",
		"TokenShop",
		"Look",
		"SuperLoot",
		"Combat",
		"Guard",
		"Race",
		"Pet",
		"Movement",
		"Session",
		"Scheduler",
	}) do
		Nullx11Forge[name] = {}
	end

	---@param folder string
	---@param name string
	---@return Instance?
	function Nullx11Forge.Util.FindRemote(folder, name)
		if not Remote then
			return nil
		end
		local key = folder .. "." .. name
		local cached = State.RemoteCache[key]
		if cached and cached:IsDescendantOf(Remote) then
			return cached
		end
		State.RemoteCache[key] = nil

		local directFolder = Remote:FindFirstChild(folder .. "_Server")
			or Remote:FindFirstChild(folder)
		if directFolder then
			local remote = directFolder:FindFirstChild(name)
			if
				remote
				and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction"))
			then
				State.RemoteCache[key] = remote
				return remote
			end
		end

		for _, descendant in ipairs(Remote:GetDescendants()) do
			if
				descendant.Name == name
				and (
					descendant:IsA("RemoteEvent")
					or descendant:IsA("RemoteFunction")
				)
			then
				local parentName = descendant.Parent and descendant.Parent.Name
					or ""
				if parentName:find("^" .. folder) then
					State.RemoteCache[key] = descendant
					return descendant
				end
			end
		end

		for _, descendant in ipairs(Remote:GetDescendants()) do
			if
				descendant.Name == name
				and (
					descendant:IsA("RemoteEvent")
					or descendant:IsA("RemoteFunction")
				)
			then
				State.RemoteCache[key] = descendant
				return descendant
			end
		end

		return nil
	end

	---@param folder string
	---@param name string
	---@return Instance
	function Nullx11Forge.Util.Remote(folder, name)
		local remote = Nullx11Forge.Util.FindRemote(folder, name)
		if remote then
			return remote
		end

		local holder = Remote
			and (
				Remote:FindFirstChild(folder .. "_Server")
				or Remote:WaitForChild(folder, Config.RemoteTimeout)
			)
		remote = holder and holder:WaitForChild(name, Config.RemoteTimeout)
			or Nullx11Forge.Util.FindRemote(folder, name)
		if not remote then
			error(("remote %s.%s not found"):format(folder, name), 0)
		end
		return remote
	end

	---@param url string
	---@return string?, string?
	function Nullx11Forge.Util.HttpGet(url)
		local ok, body = pcall(function()
			return game:HttpGet(url)
		end)
		if ok and type(body) == "string" then
			return body
		end

		local send = request
			or http_request
			or (syn and syn.request)
			or (http and http.request)
		if not send then
			return nil, tostring(body)
		end
		local sent, response = pcall(send, { Url = url, Method = "GET" })
		if not sent then
			return nil, tostring(response)
		end
		if
			type(response) ~= "table"
			or response.StatusCode ~= 200
			or type(response.Body) ~= "string"
		then
			return nil,
				"HTTP " .. tostring(
					type(response) == "table" and response.StatusCode
				)
		end
		return response.Body
	end

	---@param text string
	---@param detail string?
	function Nullx11Forge.Util.Alert(text, detail)
		warn("[Nullx11 Forge] menu:", text, detail or "")
		task.spawn(function()
			for _ = 1, Config.AlertTries do
				local shown =
					pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
						Title = "Nullx11 - +1 loot to forge",
						Text = text,
						Duration = 10,
					})
				if shown then
					return
				end
				task.wait(Config.AlertDelay)
			end
		end)
	end

	---@return table?
	function Nullx11Forge.Util.LoadLibrary()
		return context.Library
	end

	---@param key string
	---@param err any
	function Nullx11Forge.Util.WarnJob(key, err)
		local stamp = key .. tostring(err):match("[^\n]*")
		local now = os.clock()
		if
			now - (State.Warned[stamp] or -Config.WarnCooldown)
			< Config.WarnCooldown
		then
			return
		end

		if not State.Warned[stamp] then
			State.WarnedCount += 1
			if State.WarnedCount > Config.WarnMemory then
				table.clear(State.Warned)
				State.WarnedCount = 1
			end
		end
		State.Warned[stamp] = now
		warn("[Nullx11 Forge]", key, err)
	end

	---@param fn function
	---@return boolean, any
	function Nullx11Forge.Util.Try(fn, ...)
		local ok, err = pcall(fn, ...)
		if not ok then
			warn("[Nullx11 Forge]", err)
		end
		return ok, err
	end

	---@param id string|number
	---@return number
	function Nullx11Forge.Util.Tier(id)
		return tonumber(tostring(id):match("%d+")) or 0
	end

	---@param number number
	---@return string
	function Nullx11Forge.Util.Abbreviate(number)
		local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }
		local index = 1
		while number >= 1000 and index < #units do
			number /= 1000
			index += 1
		end
		return (index == 1 and "%d%s" or "%.2f%s"):format(number, units[index])
	end

	---@param configTable table
	---@return any
	function Nullx11Forge.Util.HighestKey(configTable)
		local bestKey, bestTier = nil, -1
		for key in pairs(configTable) do
			local tier = Nullx11Forge.Util.Tier(key)
			if tier > bestTier then
				bestKey, bestTier = key, tier
			end
		end
		return bestKey
	end

	---@param fn function
	---@return thread
	function Nullx11Forge.Util.Child(fn)
		local owner = coroutine.running()
		local children = State.ChildThreads[owner]
		if not children then
			children = {}
			State.ChildThreads[owner] = children
		end
		local thread
		thread = task.defer(function()
			fn()
			children[thread] = nil
			if next(children) == nil then
				State.ChildThreads[owner] = nil
			end
		end)
		children[thread] = true
		return thread
	end

	---@param thread thread
	function Nullx11Forge.Util.CancelTree(thread)
		if not thread then
			return
		end
		for child in pairs(State.ChildThreads[thread] or {}) do
			Nullx11Forge.Util.CancelTree(child)
		end
		State.ChildThreads[thread] = nil
		for _, worker in ipairs(State.WorkerBatches[thread] or {}) do
			Nullx11Forge.Util.CancelTree(worker)
		end
		State.WorkerBatches[thread] = nil
		if State.LockOwner == thread then
			State.Lock = nil
			State.LockOwner = nil
			State.LockTime = 0
		end
		for uuid, owner in pairs(State.LootPending) do
			if owner == thread then
				State.LootPending[uuid] = nil
				State.LootSeen[uuid] = nil
			end
		end
		if coroutine.status(thread) ~= "dead" then
			pcall(task.cancel, thread)
		end
	end

	---@param workers number
	---@param job function
	---@return boolean
	function Nullx11Forge.Util.WaitAll(workers, job)
		workers = math.max(0, math.floor(workers))
		local nextJob, pending, firstError = 0, workers, nil
		local threads = {}
		local owner = coroutine.running()
		State.WorkerBatches[owner] = threads
		for _ = 1, math.min(workers, math.clamp(State.Opt.WorkerLimit, 1, 32)) do
			table.insert(
				threads,
				task.defer(function()
					while State.Alive and nextJob < workers do
						nextJob += 1
						local ok, err = pcall(job)
						if not ok then
							firstError = firstError or err
						end
						pending -= 1
					end
				end)
			)
		end
		local deadline = os.clock() + Config.RemoteTimeout * 2
		while State.Alive and pending > 0 and os.clock() < deadline do
			task.wait(0.05)
		end
		for _, thread in ipairs(threads) do
			if coroutine.status(thread) ~= "dead" then
				pcall(task.cancel, thread)
			end
		end
		State.WorkerBatches[owner] = nil
		if State.Alive and pending > 0 then
			error("worker batch timed out", 0)
		end
		if firstError then
			error(firstError, 0)
		end
		return pending == 0
	end

	---@return string[]
	function Nullx11Forge.Util.RarityNames()
		local helper = Nullx11Forge.GameLib.Api(GameConfig.Rarity.Helper)
		local names = {}
		for level = 1, 20 do
			local name = helper.GetRarityByLevel(level)
			if not name then
				break
			end
			table.insert(names, name)
		end
		return names
	end

	---@param list table
	---@return table
	function Nullx11Forge.Util.AllSet(list)
		local set = {}
		for _, name in ipairs(list) do
			set[name] = true
		end
		return set
	end

	---@param name string
	---@param fn function
	---@return boolean, any ...
	function Nullx11Forge.Util.Exclusive(name, fn, ...)
		local now = os.clock()
		if State.Lock and State.LockTime and (now - State.LockTime > 12) then
			State.Lock = nil
			State.LockOwner = nil
		end
		if State.Lock then
			return false
		end
		local owner = coroutine.running()
		for key, thread in pairs(State.JobRunning) do
			if thread ~= owner and not Nullx11Forge.Scheduler.Groups[key] then
				return false
			end
		end
		State.Lock = name
		State.LockOwner = owner
		State.LockTime = now
		local result = table.pack(pcall(fn, ...))
		if State.LockOwner == owner then
			State.Lock = nil
			State.LockOwner = nil
			State.LockTime = 0
		end
		if not result[1] then
			error(result[2], 0)
		end
		return true, table.unpack(result, 2, result.n)
	end

	---@param force boolean?
	---@return table
	function Nullx11Forge.Data.Get(force)
		local now = os.clock()
		if
			not force
			and State.Profile
			and (now - State.ProfileTime < State.ProfileCacheTtl)
		then
			return State.Profile
		end
		local remote = Nullx11Forge.Util.Remote("Profile", "GetTotalDataRF")
		local ok, profile = pcall(context.Send, remote, "InvokeServer")
		if not ok or type(profile) ~= "table" then
			if State.Profile then
				return State.Profile
			end
			error("profile unavailable; retry after loading", 0)
		end
		State.Profile = profile
		State.ProfileTime = now
		return State.Profile
	end

	---@param profile table
	---@param itemId string
	---@return number
	function Nullx11Forge.Data.Count(profile, itemId)
		local total = 0
		for _, entry in pairs(profile.Backpack.have) do
			if entry.ID == itemId then
				total += entry.Number or 1
			end
		end
		return total
	end

	---@param profile table
	---@param itemId string
	---@return string?
	function Nullx11Forge.Data.Uuid(profile, itemId)
		for uuid, entry in pairs(profile.Backpack.have) do
			if entry.ID == itemId and (entry.Number or 0) >= 1 then
				return uuid
			end
		end
		return nil
	end

	---@return table
	function Nullx11Forge.Data.Snapshot()
		local seen = {}
		for uuid in pairs(Nullx11Forge.Data.Get().Backpack.have) do
			seen[uuid] = true
		end
		return seen
	end

	---@param before table
	---@return table
	function Nullx11Forge.Data.NewGear(before)
		local fresh = {}
		for uuid, entry in pairs(Nullx11Forge.Data.Get(true).Backpack.have) do
			if
				not before[uuid]
				and (
					entry.Type == "Weapon"
					or entry.Type == "Armor"
					or entry.Type == "Hat"
				)
			then
				fresh[uuid] = entry
			end
		end
		return fresh
	end

	---@param oreId string
	---@return string?
	function Nullx11Forge.Ore.Rarity(oreId)
		local oreConfig =
			Nullx11Forge.GameLib.Need(GameConfig.Ore.Config)[oreId]
		return oreConfig
			and Nullx11Forge.GameLib
				.Api(GameConfig.Rarity.Helper)
				.GetRarityByLevel(oreConfig.Rarity)
	end

	---@param profile table
	---@return table[]
	function Nullx11Forge.Ore.Owned(profile)
		local ores = {}
		for uuid, entry in pairs(profile.Backpack.have) do
			if entry.Type == "Ore" and (entry.Number or 0) >= 1 then
				table.insert(ores, {
					uuid = uuid,
					id = entry.ID,
					tier = Nullx11Forge.Util.Tier(entry.ID),
					number = math.floor(entry.Number),
					rarity = Nullx11Forge.Ore.Rarity(entry.ID),
				})
			end
		end
		table.sort(ores, function(a, b)
			return a.tier > b.tier
		end)
		return ores
	end

	---@return string[]
	function Nullx11Forge.Ore.Ids()
		local ids = {}
		for oreId in pairs(Nullx11Forge.GameLib.Need(GameConfig.Ore.Config)) do
			table.insert(ids, oreId)
		end
		table.sort(ids, function(a, b)
			return Nullx11Forge.Util.Tier(a) > Nullx11Forge.Util.Tier(b)
		end)
		return ids
	end

	---@param itemId string
	---@return string?, string?
	function Nullx11Forge.Look.Item(itemId)
		for _, kind in ipairs(Config.LookKinds) do
			local folder = GameConfig:FindFirstChild(kind)
			local show = folder
				and folder:FindFirstChild("Show")
				and Nullx11Forge.GameLib.Require(folder.Show)
			local entry = show and show[itemId]
			if not entry then
				continue
			end
			local config = folder:FindFirstChild("Config")
				and Nullx11Forge.GameLib.Require(folder.Config)
			local info = config and config[itemId]
			return entry.Image, info and info.Rarity
		end
		return nil, nil
	end

	---@param rarity any
	---@return Color3?
	function Nullx11Forge.Look.Color(rarity)
		if rarity == nil then
			return nil
		end
		State.RarityColors = State.RarityColors or {}
		local cached = State.RarityColors[rarity]
		if cached ~= nil then
			return cached or nil
		end

		local helper = Nullx11Forge.GameLib.Api(GameConfig.Rarity.Helper)
		local name = rarity
		if type(rarity) == "number" then
			local ok, byLevel = pcall(helper.GetRarityByLevel, rarity)
			name = ok and byLevel or rarity
		end
		local probe = Instance.new("TextLabel")
		pcall(helper.SetUIQiu, probe, name)
		local gradient = probe:FindFirstChildWhichIsA("UIGradient")
		local color = gradient and gradient.Color.Keypoints[1].Value
		probe:Destroy()
		State.RarityColors[rarity] = color or false
		return color
	end

	---@param labels string[]
	---@param idOf function
	---@return table, table
	function Nullx11Forge.Look.Maps(labels, idOf)
		local images, colors = {}, {}
		for _, label in ipairs(labels) do
			local itemId = idOf(label)
			if not itemId then
				continue
			end
			local image, rarity = Nullx11Forge.Look.Item(itemId)
			images[label] = image
			colors[label] = Nullx11Forge.Look.Color(rarity)
		end
		return images, colors
	end

	---@return string[]
	function Nullx11Forge.Ore.Choices()
		local oreShow = Nullx11Forge.GameLib.Need(GameConfig.Ore.Show)
		local labels, idByLabel = {}, {}
		for _, oreId in ipairs(Nullx11Forge.Ore.Ids()) do
			local label = ("%s (%s)"):format(
				oreShow[oreId] and oreShow[oreId].DisplayName or oreId,
				Nullx11Forge.Ore.Rarity(oreId) or "?"
			)
			if idByLabel[label] then
				label = ("%s #%d"):format(label, Nullx11Forge.Util.Tier(oreId))
			end
			idByLabel[label] = oreId
			table.insert(labels, label)
		end
		State.OreLabels = idByLabel
		return labels
	end

	---@return string[]
	function Nullx11Forge.Ore.ForgeChoices()
		local labels = Nullx11Forge.Ore.Choices()
		table.insert(labels, 1, Config.OwnedOresLabel)
		return labels
	end

	---@param value any
	---@return number
	function Nullx11Forge.Spawn.Amount(value)
		value = tonumber(value)
		if not value or value ~= value or value <= 0 or value == math.huge then
			error("Enter a finite positive amount", 0)
		end
		return math.clamp(math.floor(value), 1, 1000000000)
	end

	---@param uuid string
	---@param amount number
	function Nullx11Forge.Ore.Add(uuid, amount)
		context.Send(
			Nullx11Forge.Util.Remote("Backpack", "TrySellItemRE"),
			"FireServer",
			uuid,
			-Nullx11Forge.Spawn.Amount(amount)
		)
	end

	---@return string[]
	function Nullx11Forge.Spawn.Choices()
		local labels, ids = {}, {}
		local oreShow = Nullx11Forge.GameLib.Need(GameConfig.Ore.Show)
		for _, id in ipairs(Nullx11Forge.Ore.Ids()) do
			local label = "Ore • "
				.. (oreShow[id] and oreShow[id].DisplayName or id)
				.. " ["
				.. id
				.. "]"
			labels[#labels + 1] = label
			ids[label] = { id = id, kind = "Ore" }
		end

		local eggFolder = GameConfig:FindFirstChild("Egg")
		local eggShow = eggFolder
			and eggFolder:FindFirstChild("Show")
			and Nullx11Forge.GameLib.Require(eggFolder.Show)
		local eggCfg = eggFolder
			and eggFolder:FindFirstChild("Config")
			and Nullx11Forge.GameLib.Require(eggFolder.Config)
		if eggShow or eggCfg then
			local eggIds = {}
			local allEggKeys = {}
			if eggShow then
				for id in pairs(eggShow) do
					allEggKeys[id] = true
				end
			end
			if eggCfg then
				for id in pairs(eggCfg) do
					allEggKeys[id] = true
				end
			end
			for id in pairs(allEggKeys) do
				eggIds[#eggIds + 1] = id
			end
			table.sort(eggIds, function(a, b)
				return Nullx11Forge.Util.Tier(a) > Nullx11Forge.Util.Tier(b)
			end)
			for _, id in ipairs(eggIds) do
				local name = eggShow
						and eggShow[id]
						and (eggShow[id].DisplayName or eggShow[id].Name)
					or id
				local label = "Egg • " .. name .. " [" .. id .. "]"
				labels[#labels + 1] = label
				ids[label] = { id = id, kind = "Egg" }
			end
		end

		local foodFolder = GameConfig:FindFirstChild("Food")
		local foodShow = foodFolder
			and foodFolder:FindFirstChild("Show")
			and Nullx11Forge.GameLib.Require(foodFolder.Show)
		local foodCfg = foodFolder
			and foodFolder:FindFirstChild("Config")
			and Nullx11Forge.GameLib.Require(foodFolder.Config)
		if foodShow or foodCfg then
			local foodIds = {}
			local allFoodKeys = {}
			if foodShow then
				for id in pairs(foodShow) do
					allFoodKeys[id] = true
				end
			end
			if foodCfg then
				for id in pairs(foodCfg) do
					allFoodKeys[id] = true
				end
			end
			for id in pairs(allFoodKeys) do
				foodIds[#foodIds + 1] = id
			end
			table.sort(foodIds, function(a, b)
				return Nullx11Forge.Util.Tier(a) > Nullx11Forge.Util.Tier(b)
			end)
			for _, id in ipairs(foodIds) do
				local name = foodShow
						and foodShow[id]
						and (foodShow[id].DisplayName or foodShow[id].Name)
					or id
				local label = "Fruit • " .. name .. " [" .. id .. "]"
				labels[#labels + 1] = label
				ids[label] = { id = id, kind = "Food" }
			end
		end

		local seen = {}
		local runeShow = Nullx11Forge.GameLib.Need(GameConfig.EnchStone.Show)
		for _, entry in pairs(Nullx11Forge.Data.Get().Backpack.have) do
			if entry.Type == "EnchStone" and not seen[entry.ID] then
				local id = entry.ID
				local label = "Rune • "
					.. (runeShow[id] and runeShow[id].DisplayName or id)
					.. " ["
					.. id
					.. "]"
				labels[#labels + 1] = label
				ids[label] = { id = id, kind = "EnchStone" }
				seen[id] = true
			end
		end
		State.SpawnLabels = ids
		return labels
	end

	---@param id string
	---@param kind string
	---@param amount number
	---@return boolean, number, string?
	function Nullx11Forge.Spawn.Give(id, kind, amount)
		amount = Nullx11Forge.Spawn.Amount(amount)
		if kind == "Egg" or kind == "Food" then
			local farmed = Nullx11Forge.Stage.FarmTurbo(id, kind, amount)
			return farmed > 0,
				farmed,
				farmed > 0 and "turbo farmed into inventory"
					or "bag full or drop not rolled yet"
		end
		if kind == "Ore" then
			local farmed = Nullx11Forge.Stage.FarmTurbo(id, "Ore", amount)
			if farmed > 0 then
				return true, farmed, "turbo farmed into inventory"
			end
		end
		if kind == "Pet" then
			local hatched, msg = Nullx11Forge.Pet.FarmAndHatchTarget(id, amount)
			return hatched > 0,
				hatched,
				msg
					or (
						hatched > 0 and ("hatched target pet x" .. hatched)
						or "incubating target eggs"
					)
		end
		local profile = Nullx11Forge.Data.Get()
		local uuid = Nullx11Forge.Data.Uuid(profile, id)
		if not uuid and kind == "Ore" then
			uuid = Nullx11Forge.Ore.Ensure(id, 0)
			profile = Nullx11Forge.Data.Get(true)
		end
		if not uuid then
			return false, 0, "need an owned copy first"
		end
		local before = Nullx11Forge.Data.Count(profile, id)
		Nullx11Forge.Ore.Add(uuid, amount)
		for _ = 1, 4 do
			if not State.Alive then
				return false, 0, "cancelled"
			end
			task.wait(0.2)
			local delta = Nullx11Forge.Data.Count(
				Nullx11Forge.Data.Get(true),
				id
			) - before
			if delta > 0 then
				return true, delta
			end
		end
		return false, 0, "no increase confirmed"
	end

	function Nullx11Forge.Spawn.TurboStep()
		local picked = State.SpawnLabels[State.Opt.SpawnItem]
		if picked then
			Nullx11Forge.Spawn.Give(
				picked.id,
				picked.kind,
				State.Opt.SpawnAmount or 1000
			)
		else
			Nullx11Forge.Stage.FarmEggsAndFood(15)
			Nullx11Forge.Stage.FarmMaxOres(15)
		end
	end

	---@param profile table
	---@return string[]
	function Nullx11Forge.Potion.Owned(profile)
		local ids = {}
		local config = Nullx11Forge.GameLib.Need(GameConfig.Potion.Config)
		for id, count in pairs(profile.Potion or {}) do
			if config[id] and type(count) == "number" and count > 0 then
				ids[#ids + 1] = id
			end
		end
		table.sort(ids)
		return ids
	end

	---@param amount number
	---@return number
	function Nullx11Forge.Potion.Extend(amount)
		amount = math.min(1000000, Nullx11Forge.Spawn.Amount(amount))
		local config = Nullx11Forge.GameLib.Need(GameConfig.Potion.Config)
		local changed = 0
		local profile = Nullx11Forge.Data.Get()
		for _, id in ipairs(Nullx11Forge.Potion.Owned(profile)) do
			if not State.Alive then
				break
			end
			local q = Nullx11Forge.Data.Get()
			local buffId = config[id].BuffID
			local before = (q.Buff or {})[buffId] or 0
			local count = math.min(amount, math.floor(q.Potion[id] or 0))
			if count > 0 then
				context.Send(
					Nullx11Forge.Util.Remote("Potion", "TryUsePotionRE"),
					"FireServer",
					id,
					count
				)
				task.wait(0.3)
				if
					((Nullx11Forge.Data.Get(true).Buff or {})[buffId] or 0)
					> before
				then
					changed += 1
				end
			end
		end
		return changed
	end

	---@param oreId string
	---@param need number
	---@return string?
	function Nullx11Forge.Ore.Ensure(oreId, need)
		local profile = Nullx11Forge.Data.Get()
		local uuid = Nullx11Forge.Data.Uuid(profile, oreId)
		if uuid and Nullx11Forge.Data.Count(profile, oreId) >= need then
			return uuid
		end

		Nullx11Forge.Stage.FarmOreTarget(
			oreId,
			math.max(1, need - Nullx11Forge.Data.Count(profile, oreId))
		)
		profile = Nullx11Forge.Data.Get(true)
		return Nullx11Forge.Data.Uuid(profile, oreId)
	end

	---@param minimum number
	---@return table?
	function Nullx11Forge.Ore.Top(minimum)
		local top = Nullx11Forge.Ore.Owned(Nullx11Forge.Data.Get())[1]
		if not top or top.number < minimum then
			Nullx11Forge.Stage.FarmMaxOres(3)
			top = Nullx11Forge.Ore.Owned(Nullx11Forge.Data.Get(true))[1]
		end
		return top and top.number >= minimum and top or nil
	end

	---@return number
	function Nullx11Forge.TokenShop.BuyAll()
		local goodsConfig =
			Nullx11Forge.GameLib.Need(GameConfig.TokenShop.Config)
		local exchange =
			Nullx11Forge.Util.Remote("TokenShop", "ExchangeGoodsRF")
		local profile = Nullx11Forge.Data.Get()
		if State.Opt.TokenReveal then
			local reveal = Nullx11Forge.Util.Remote("TokenShop", "OpenGoodsRE")
			local opened = false
			for slot, good in
				pairs(profile.TokenShop and profile.TokenShop.Goods or {})
			do
				if State.Alive and not good.Open and not good.Exchanged then
					context.Send(reveal, "FireServer", tostring(slot))
					opened = true
				end
			end
			if opened then
				task.wait(0.2)
				profile = Nullx11Forge.Data.Get(true)
			end
		end
		local bought = 0
		for slot, good in
			pairs(profile.TokenShop and profile.TokenShop.Goods or {})
		do
			if not State.Alive then
				break
			end
			local entry = goodsConfig[tonumber(slot)]
				or goodsConfig[tostring(slot)]
			if good.Exchanged or not entry then
				continue
			end
			if State.Opt.TokenSkipOwned and good.IsHave then
				continue
			end
			if
				next(State.Opt.TokenTargets)
				and not State.Opt.TokenTargets[tostring(slot)]
			then
				continue
			end

			if
				(profile.Token and profile.Token.value or 0)
				< (entry.Token or 0)
			then
				continue
			end
			if not good.Open then
				continue
			end
			local success =
				context.Send(exchange, "InvokeServer", tostring(slot))
			profile = Nullx11Forge.Data.Get(true)
			local updated = profile.TokenShop
				and profile.TokenShop.Goods
				and profile.TokenShop.Goods[slot]
			if success == true or (updated and updated.Exchanged) then
				bought += 1
			end
		end
		return bought
	end

	---@return string[], table
	function Nullx11Forge.TokenShop.Choices()
		local choices, ids = {}, {}
		for id, entry in
			pairs(Nullx11Forge.GameLib.Need(GameConfig.TokenShop.Config))
		do
			local label = ("%s (%d Token)"):format(
				entry.DisplayName or entry.MonID or tostring(id),
				entry.Token or 0
			)
			table.insert(choices, label)
			ids[label] = tostring(id)
		end
		table.sort(choices)
		return choices, ids
	end

	---@return number
	function Nullx11Forge.Claim.CheckIn()
		local plan =
			Nullx11Forge.GameLib.Api(ReplicatedStorage.LocalData.PlanKData)
		local data = plan.GetData()
		local claimed = 0
		for day, entry in pairs(data.sign or {}) do
			if not State.Alive then
				break
			end
			if type(entry) == "table" and entry.Sign and not entry.Claim then
				if plan.TryClaim(tostring(day)) == true then
					claimed += 1
				end
			end
		end
		return claimed
	end

	function Nullx11Forge.Stage.BattleStep()
		local fight = LocalPlayer:GetAttribute("IntoFight")
		if fight and fight ~= "Stage" then
			return
		end
		if not LocalPlayer.Character or LocalPlayer:GetAttribute("Dead") then
			return
		end
		if not fight then
			local stageId = State.Opt.Stage or Nullx11Forge.Stage.Best()
			if not stageId then
				return
			end
			local manager = LocalPlayer.PlayerScripts:FindFirstChild("Manager")
			local stageManager = manager
				and manager:FindFirstChild("StageManager")
			local module = stageManager
				and stageManager:FindFirstChild("StageUtils")
			if not module then
				error("StageUtils unavailable while loading", 0)
			end
			Nullx11Forge.GameLib.Api(module).StartFight(stageId)
		end
		if State.Alive and State.Opt.AutoBattle then
			Nullx11Forge.Combat.KillAll()
		end
	end

	---@param slot string
	---@return boolean
	function Nullx11Forge.Gear.SwitchForm(slot)
		local profile = Nullx11Forge.Data.Get()
		local uuid = profile.Backpack.equiped[slot]
		local item = uuid and profile.Backpack.have[uuid]
		if not item then
			return false
		end
		local config = slot == "Weapon" and GameConfig.Weapon.Show
			or GameConfig.Armor.Show
		local show = Nullx11Forge.GameLib.Need(config)[item.ID]
		if not show or not show.Mutant then
			return false
		end
		local wanted = (item.Mutant or show.Mutant) == "A" and "B" or "A"
		Nullx11Forge.GameLib
			.Api(ReplicatedStorage.LocalData.BackpackData)
			.ChangeEquipmentMutant(uuid, wanted)
		local deadline = os.clock() + 2
		repeat
			task.wait(0.1)
			local current = Nullx11Forge.GameLib
				.Api(ReplicatedStorage.LocalData.BackpackData)
				.GetItemData(uuid)
			if current and current.Mutant == wanted then
				return true
			end
		until not State.Alive or os.clock() >= deadline
		return false
	end

	---@return string[]
	function Nullx11Forge.Stage.List()
		local stages = {}
		for stageId in
			pairs(
				Nullx11Forge.GameLib
					.Api(GameConfig.Stage.Helper)
					.GetStageEnemyConfig()
			)
		do
			table.insert(stages, stageId)
		end
		table.sort(stages, function(a, b)
			return Nullx11Forge.Util.Tier(a) > Nullx11Forge.Util.Tier(b)
		end)
		return stages
	end

	---@return string
	function Nullx11Forge.Stage.Best()
		return Nullx11Forge.Stage.List()[1] or "Stage_27"
	end

	---@param stageId string
	---@param rarities table?
	function Nullx11Forge.Stage.Collect(stageId, rarities)
		local drops = context.Send(
			Nullx11Forge.Util.Remote("Stage", "StageFinishedRF"),
			"InvokeServer",
			stageId
		)
		if type(drops) ~= "table" then
			return
		end
		local getOre = Nullx11Forge.Util.Remote("Stage", "GetOreRF")
		local getStone = Nullx11Forge.Util.Remote("Stage", "GetEnhantStoneRE")
		for uuid, drop in pairs(drops) do
			if type(drop) == "table" then
				if drop.Type == "Material" then
					context.Send(getStone, "FireServer", uuid)
				else
					context.Send(getOre, "InvokeServer", uuid, true)
				end
			elseif not rarities or rarities[Nullx11Forge.Ore.Rarity(drop)] then
				context.Send(getOre, "InvokeServer", uuid, true)
			end
		end
		context.Send(
			Nullx11Forge.Util.Remote("Stage", "ClaimedAllOreRE"),
			"FireServer"
		)
		Nullx11Forge.Data.Get(true)
	end

	---@param stageId string
	function Nullx11Forge.Stage.FarmStones(stageId)
		stageId = stageId or Nullx11Forge.Stage.Best()
		local finished = Nullx11Forge.Util.Remote("Stage", "StageFinishedRF")
		local pickStone = Nullx11Forge.Util.Remote("Stage", "GetEnhantStoneRE")
		local getOre = Nullx11Forge.Util.Remote("Stage", "GetOreRF")
		Nullx11Forge.Util.WaitAll(Config.StoneWorkers, function()
			for _ = 1, Config.StoneCallsPerWorker do
				local drops = context.Send(finished, "InvokeServer", stageId)
				for uuid, drop in pairs(type(drops) == "table" and drops or {}) do
					if type(drop) == "table" then
						if drop.Type == "Material" then
							context.Send(pickStone, "FireServer", uuid)
						else
							context.Send(getOre, "InvokeServer", uuid, true)
						end
					end
				end
			end
		end)
		Nullx11Forge.Data.Get(true)
	end

	---@param targetOreId string
	---@param needed number
	---@return number
	function Nullx11Forge.Stage.FarmOreTarget(targetOreId, needed)
		return Nullx11Forge.Stage.FarmTurbo(targetOreId, "Ore", needed)
	end

	---@param targetId string
	---@param kind string
	---@param needed number
	---@return number
	---@param targetId string?
	---@param kind string
	---@param needed number
	---@return number
	function Nullx11Forge.Stage.FarmTurbo(targetId, kind, needed)
		needed = math.clamp(math.floor(needed or 1), 1, 1000000)
		local stageId = targetId and State.OreStage[targetId]
		if not stageId then
			if kind == "Egg" or (targetId and targetId:find("^Egg")) then
				stageId = (targetId == "Egg1" and "Stage_10") or "Stage_25"
			elseif
				targetId
				and (
					targetId == "Food_5"
					or targetId == "Food_6"
					or targetId:find("^Food_10")
				)
			then
				stageId = "Stage_27"
			else
				stageId = Nullx11Forge.Stage.Best()
			end
		end

		local finished = Nullx11Forge.Util.Remote("Stage", "StageFinishedRF")
		local getOre = Nullx11Forge.Util.Remote("Stage", "GetOreRF")
		local pickStone = Nullx11Forge.Util.Remote("Stage", "GetEnhantStoneRE")
		local claimAll = Nullx11Forge.Util.Remote("Stage", "ClaimedAllOreRE")
		local got = 0

		local workers = math.clamp(Config.TurboFarmWorkers or 24, 8, 32)
		local roundsPerWorker =
			math.clamp(math.ceil(needed / (workers * 2)), 1, 100)

		if kind == "Egg" then
			Nullx11Forge.Pet.TrimEggs(targetId)
		end

		Nullx11Forge.Util.WaitAll(workers, function()
			for _ = 1, roundsPerWorker do
				if not State.Alive or got >= needed then
					break
				end
				local drops = context.Send(finished, "InvokeServer", stageId)
				if type(drops) == "table" then
					local batchClaims = {}
					for uuid, drop in pairs(drops) do
						if type(drop) == "table" then
							if drop.ID then
								State.OreStage[drop.ID] = stageId
							end
							if drop.Type == "Material" then
								context.Send(pickStone, "FireServer", uuid)
							elseif
								not targetId
								or drop.ID == targetId
								or kind == "All"
								or drop.Type == kind
							then
								batchClaims[#batchClaims + 1] = uuid
							end
						elseif type(drop) == "string" then
							State.OreStage[drop] = stageId
							if
								not targetId
								or drop == targetId
								or kind == "Ore"
								or kind == "All"
							then
								batchClaims[#batchClaims + 1] = uuid
							end
						end
					end
					for _, dropUuid in ipairs(batchClaims) do
						task.spawn(function()
							if
								context.Send(
									getOre,
									"InvokeServer",
									dropUuid,
									true
								)
							then
								got += 1
							end
						end)
					end
				end
			end
		end)

		context.Send(claimAll, "FireServer")
		Nullx11Forge.Data.Get(true)
		return got
	end

	---@param targetId string
	---@param kind string
	---@param needed number
	---@return number
	function Nullx11Forge.Stage.FarmDropTarget(targetId, kind, needed)
		return Nullx11Forge.Stage.FarmTurbo(targetId, kind, needed)
	end

	---@param rounds number?
	---@return number, number
	function Nullx11Forge.Stage.FarmEggsAndFood(rounds)
		rounds = math.clamp(rounds or Config.EggFarmCalls, 1, 100)
		local stageId = "Stage_25"
		local finished = Nullx11Forge.Util.Remote("Stage", "StageFinishedRF")
		local getOre = Nullx11Forge.Util.Remote("Stage", "GetOreRF")
		local pickStone = Nullx11Forge.Util.Remote("Stage", "GetEnhantStoneRE")
		local claimAll = Nullx11Forge.Util.Remote("Stage", "ClaimedAllOreRE")
		local eggs, foods = 0, 0
		Nullx11Forge.Pet.TrimEggs("Egg2")
		Nullx11Forge.Util.WaitAll(Config.TurboFarmWorkers or 24, function()
			for _ = 1, rounds do
				if not State.Alive then
					break
				end
				local drops = context.Send(finished, "InvokeServer", stageId)
				if type(drops) == "table" then
					for uuid, drop in pairs(drops) do
						if type(drop) == "table" then
							if drop.Type == "Material" then
								context.Send(pickStone, "FireServer", uuid)
							elseif drop.Type == "Egg" then
								task.spawn(function()
									if
										context.Send(
											getOre,
											"InvokeServer",
											uuid,
											true
										)
									then
										eggs += 1
									end
								end)
							elseif drop.Type == "Food" then
								task.spawn(function()
									if
										context.Send(
											getOre,
											"InvokeServer",
											uuid,
											true
										)
									then
										foods += 1
									end
								end)
							end
						end
					end
				end
			end
		end)
		context.Send(claimAll, "FireServer")
		Nullx11Forge.Data.Get(true)
		if State.Opt.AutoDeleteEggs then
			Nullx11Forge.Pet.TrimEggs()
		end
		return eggs, foods
	end

	---@param rounds number?
	---@return number
	function Nullx11Forge.Stage.FarmMaxOres(rounds)
		rounds = math.clamp(rounds or 20, 1, 100)
		local stageId = State.Opt.Stage
			or Nullx11Forge.Stage.Best()
			or "Stage_27"
		local finished = Nullx11Forge.Util.Remote("Stage", "StageFinishedRF")
		local getOre = Nullx11Forge.Util.Remote("Stage", "GetOreRF")
		local pickStone = Nullx11Forge.Util.Remote("Stage", "GetEnhantStoneRE")
		local claimAll = Nullx11Forge.Util.Remote("Stage", "ClaimedAllOreRE")
		local total = 0
		Nullx11Forge.Util.WaitAll(Config.TurboFarmWorkers or 24, function()
			for _ = 1, rounds do
				if not State.Alive then
					break
				end
				local drops = context.Send(finished, "InvokeServer", stageId)
				if type(drops) == "table" then
					for uuid, drop in pairs(drops) do
						if
							type(drop) == "table"
							and drop.Type == "Material"
						then
							context.Send(pickStone, "FireServer", uuid)
						else
							task.spawn(function()
								if
									context.Send(
										getOre,
										"InvokeServer",
										uuid,
										true
									)
								then
									total += 1
								end
							end)
						end
					end
				end
			end
		end)
		context.Send(claimAll, "FireServer")
		Nullx11Forge.Data.Get(true)
		return total
	end

	function Nullx11Forge.Stage.ExitFight()
		pcall(function()
			Nullx11Forge.GameLib
				.Api(LocalPlayer.PlayerScripts.Manager.StageManager.StageUtils)
				.ExitFight(true)
		end)
	end

	---@return table
	function Nullx11Forge.Forge.Target()
		for _, target in ipairs(Config.ForgeTargets) do
			if target.name == State.Opt.ForgeTarget then
				return target
			end
		end
		return Config.ForgeTargets[1]
	end

	---@param forgeType string
	---@param oreList table
	---@return any
	function Nullx11Forge.Forge.Run(forgeType, oreList)
		local res = context.Send(
			Nullx11Forge.Util.Remote("Forge", "ForgeRF"),
			"InvokeServer",
			{ ConfigType = forgeType, UUIDList = oreList }
		)
		Nullx11Forge.Data.Get(true)
		return res
	end

	---@param profile table
	---@param count number
	---@return table?
	function Nullx11Forge.Forge.PickOwned(profile, count)
		local opt = State.Opt
		local candidates = {}
		for _, ore in ipairs(Nullx11Forge.Ore.Owned(profile)) do
			local spare = ore.number - opt.KeepPerOre
			if opt.ForgeRarities[ore.rarity] and spare > 0 then
				ore.spare = spare
				table.insert(candidates, ore)
			end
		end
		if not opt.BestOreFirst then
			table.sort(candidates, function(a, b)
				return a.tier < b.tier
			end)
		end

		local pick, need = {}, count
		for _, ore in ipairs(candidates) do
			if need <= 0 then
				break
			end
			local take = math.min(need, ore.spare)
			pick[ore.uuid] = take
			need -= take
		end
		return need <= 0 and pick or nil
	end

	---@param count number
	---@return table?
	function Nullx11Forge.Forge.Pick(count)
		local oreId = State.OreLabels[State.Opt.ForgeOre]
		if not oreId then
			return Nullx11Forge.Forge.PickOwned(Nullx11Forge.Data.Get(), count)
		end
		local uuid =
			Nullx11Forge.Ore.Ensure(oreId, count * State.Opt.ForgePerTick)
		return uuid and { [uuid] = count }
	end

	---@return boolean
	function Nullx11Forge.Forge.Once()
		local target = Nullx11Forge.Forge.Target()
		local pick = Nullx11Forge.Forge.Pick(target.ores)
		return pick ~= nil
			and Nullx11Forge.Forge.Run(target.forgeType, pick) ~= nil
	end

	function Nullx11Forge.Forge.Burst()
		local target = Nullx11Forge.Forge.Target()
		local perTick = State.Opt.ForgePerTick
		local pick = Nullx11Forge.Forge.Pick(target.ores * perTick)
		if not pick then
			return
		end
		local uuid = next(pick)
		if next(pick, uuid) == nil then
			for _ = 1, perTick do
				Nullx11Forge.Forge.Run(
					target.forgeType,
					{ [uuid] = target.ores }
				)
			end
			return
		end
		for _ = 1, perTick do
			if not Nullx11Forge.Forge.Once() then
				break
			end
		end
	end

	function Nullx11Forge.Forge.Step()
		if not State.Opt.ForgeSellJunk then
			return Nullx11Forge.Forge.Burst()
		end
		local before = Nullx11Forge.Data.Snapshot()
		Nullx11Forge.Forge.Burst()
		local fresh = Nullx11Forge.Data.NewGear(before)
		local profile = State.Profile
		local keep = {}
		for uuid, entry in pairs(fresh) do
			local worn = profile.Backpack.equiped[entry.Type]
			local wornEntry = worn and profile.Backpack.have[worn]
			if
				not wornEntry
				or Nullx11Forge.Gear.Score(entry, true)
					> Nullx11Forge.Gear.Score(wornEntry, true)
			then
				keep[uuid] = true
			end
		end
		Nullx11Forge.Sell.Fresh(fresh, keep)
	end

	---@param entry table
	---@return string?
	function Nullx11Forge.Sell.Rarity(entry)
		local folder = entry.Type == "Weapon" and "Weapon" or "Armor"
		local itemConfig =
			Nullx11Forge.GameLib.Need(GameConfig[folder].Config)[entry.ID]
		return itemConfig and itemConfig.Rarity
	end

	---@param profile table
	---@return table
	function Nullx11Forge.Sell.Anchors(profile)
		local anchors, bestPower = {}, {}
		for uuid, entry in pairs(profile.Backpack.have) do
			if
				not (
					entry.Type == "Weapon"
					or entry.Type == "Armor"
					or entry.Type == "Hat"
				)
			then
				continue
			end
			local helper = Nullx11Forge.GameLib.Api(
				entry.Type == "Weapon" and GameConfig.Weapon.Helper
					or GameConfig.Armor.Helper
			)
			local ok, percent = pcall(helper.CheckIsBestPercent, entry.ID)
			if not ok or percent then
				continue
			end
			local powerOk, power = pcall(helper.GetMainAffix, entry.ID)
			if
				powerOk
				and type(power) == "number"
				and power > (bestPower[entry.Type] or 0)
			then
				bestPower[entry.Type] = power
				anchors[entry.Type] = uuid
			end
		end
		local keep = {}
		for _, uuid in pairs(anchors) do
			keep[uuid] = true
		end
		local backpack = Nullx11Forge.GameLib.Require(
			ReplicatedStorage.LocalData.BackpackData
		)
		if
			type(backpack) == "table"
			and type(backpack.IsLocked) == "function"
		then
			for uuid in pairs(profile.Backpack.have) do
				local ok, locked = pcall(backpack.IsLocked, uuid)
				if ok and locked then
					keep[uuid] = true
				end
			end
		end
		return keep
	end

	---@param profile table
	function Nullx11Forge.Sell.Run(profile)
		local opt = State.Opt
		local equipped = Nullx11Forge.Sell.Anchors(profile)
		for _, uuid in pairs(profile.Backpack.equiped) do
			equipped[uuid] = true
		end

		local byId = {}
		for uuid, entry in pairs(profile.Backpack.have) do
			if opt.SellTypes[entry.Type] and not equipped[uuid] then
				byId[entry.ID] = byId[entry.ID] or {}
				table.insert(byId[entry.ID], { uuid = uuid, entry = entry })
			end
		end

		local sell = Nullx11Forge.Util.Remote("Backpack", "TrySellItemRE")
		for _, items in pairs(byId) do
			table.sort(items, function(a, b)
				return (a.entry.Level or 0) > (b.entry.Level or 0)
			end)
			for index, gear in ipairs(items) do
				if
					index > opt.KeepPerItem
					and opt.SellRarities[Nullx11Forge.Sell.Rarity(gear.entry)]
				then
					context.Send(sell, "FireServer", gear.uuid, 1)
				end
			end
		end
		Nullx11Forge.Data.Get(true)
	end

	---@param fresh table
	---@param keep table?
	function Nullx11Forge.Sell.Fresh(fresh, keep)
		local equipped = Nullx11Forge.Sell.Anchors(State.Profile)
		for _, uuid in pairs(State.Profile.Backpack.equiped) do
			equipped[uuid] = true
		end
		local sell = Nullx11Forge.Util.Remote("Backpack", "TrySellItemRE")
		for uuid in pairs(fresh) do
			if not equipped[uuid] and not (keep and keep[uuid]) then
				context.Send(sell, "FireServer", uuid, 1)
			end
		end
		Nullx11Forge.Data.Get(true)
	end

	---@param entry table
	---@param atTarget boolean?
	---@return number
	function Nullx11Forge.Gear.Score(entry, atTarget)
		local balance =
			Nullx11Forge.GameLib.Api(ReplicatedStorage.Utils.BalanceUtils)
		local backpack = Nullx11Forge.Data.Get().Backpack
		local potential = table.clone(entry)
		if atTarget then
			potential.Level =
				math.max(entry.Level or 0, State.Opt.EnhanceTarget)
		end
		local value = entry.Type == "Weapon" and balance.GetWeaponTrainValue
			or balance.GetArmorValue
		local ok, power = pcall(value, LocalPlayer, potential, backpack)
		if not ok or type(power) ~= "number" then
			return 0
		end
		return power
			* (
				1
				+ (entry.Level or 0) * 1e-6
				+ #(entry.EnchanceList or {}) * 1e-9
			)
	end

	---@param profile table
	---@param slot string
	---@param atTarget boolean?
	---@return string?, number
	function Nullx11Forge.Gear.BestOwned(profile, slot, atTarget)
		local bestUuid, bestScore = nil, -1
		for uuid, entry in pairs(profile.Backpack.have) do
			if entry.Type == slot then
				local score = Nullx11Forge.Gear.Score(entry, atTarget)
				if score > bestScore then
					bestUuid, bestScore = uuid, score
				end
			end
		end
		return bestUuid, bestScore
	end

	---@return number
	function Nullx11Forge.Gear.EquipBest()
		local profile = Nullx11Forge.Data.Get()
		local equip = Nullx11Forge.Util.Remote("Backpack", "TryEquipItemRE")
		local changed = 0
		local atTarget = State.Opt.MaxGear and State.Opt.GearEnhance
		for _, slot in ipairs(Config.GearTypes) do
			local best, bestScore =
				Nullx11Forge.Gear.BestOwned(profile, slot, atTarget)
			local current = profile.Backpack.equiped[slot]
			local currentEntry = current and profile.Backpack.have[current]
			if
				best
				and best ~= current
				and bestScore
					> (currentEntry and Nullx11Forge.Gear.Score(
						currentEntry,
						atTarget
					) or -1)
			then
				context.Send(equip, "FireServer", best, slot)
				changed += 1
			end
		end
		if changed > 0 then
			Nullx11Forge.Data.Get(true)
		end
		return changed
	end

	function Nullx11Forge.Gear.ForgeBest()
		local before = Nullx11Forge.Data.Snapshot()
		for _, spec in ipairs(Config.GearSlots) do
			local top = Nullx11Forge.Ore.Top(spec.ores * Config.GearForgeTries)
			if top then
				for _ = 1, Config.GearForgeTries do
					Nullx11Forge.Forge.Run(
						spec.forgeType,
						{ [top.uuid] = spec.ores }
					)
				end
			end
			local best = Nullx11Forge.Gear.BestOwned(
				Nullx11Forge.Data.Get(),
				spec.slot,
				true
			)
			if best then
				context.Send(
					Nullx11Forge.Util.Remote("Backpack", "TryEquipItemRE"),
					"FireServer",
					best,
					spec.slot
				)
			end
		end
		task.wait(0.5)
		Nullx11Forge.Sell.Fresh(Nullx11Forge.Data.NewGear(before))
	end

	---@param profile table
	---@param level number
	---@return string?
	function Nullx11Forge.Gear.MissingForEnhance(profile, level)
		local cost =
			Nullx11Forge.GameLib.Need(GameConfig.Enhant.Config)[level + 1]
		if not cost then
			return nil
		end
		if
			Nullx11Forge.Data.Count(profile, "EnhantStone_2")
			< (cost.EnhantStone_2 or 0)
		then
			return "EnhantStone_2"
		end
		if
			Nullx11Forge.Data.Count(profile, "EnhantStone_1")
			< (cost.EnhantStone_1 or 0)
		then
			return "EnhantStone_1"
		end
		if profile.Eco.coin < (cost.NeedCoin or 0) then
			return "Coin"
		end
		return nil
	end

	---@param missing string
	function Nullx11Forge.Gear.Gather(missing)
		State.GearNote = missing
		if missing == "Coin" then
			Nullx11Forge.Forge.Step()
			Nullx11Forge.Sell.Run(Nullx11Forge.Data.Get())
		elseif missing == "EnhantStone_1" then
			Nullx11Forge.Stage.FarmStones(Nullx11Forge.Stage.Best())
		elseif not Nullx11Forge.Tower.FarmStep() then
			State.GearNote = "NoTicket"
		end
	end

	---@return string[]
	function Nullx11Forge.Gear.RuneOrder()
		if State.Runes then
			return State.Runes
		end
		local show = Nullx11Forge.GameLib.Find("Config.EnchStone.Show")
		local stones = show and Nullx11Forge.GameLib.Require(show)
		if not stones then
			return Config.EnchantPriority
		end

		local known = {}
		for index, stoneId in ipairs(Config.EnchantPriority) do
			known[stoneId] = index
		end
		local runes = {}
		for stoneId in pairs(stones) do
			if Nullx11Forge.Util.Tier(stoneId) >= Config.RuneMinTier then
				runes[#runes + 1] = stoneId
			end
		end
		table.sort(runes, function(a, b)
			local ta, tb = Nullx11Forge.Util.Tier(a), Nullx11Forge.Util.Tier(b)
			if ta ~= tb then
				return ta > tb
			end
			local ka, kb = known[a] or math.huge, known[b] or math.huge
			if ka ~= kb then
				return ka < kb
			end
			return a < b
		end)
		State.Runes = runes
		return runes
	end

	---@return string[]
	function Nullx11Forge.Gear.Priority()
		return #State.Opt.EnchantPriority > 0 and State.Opt.EnchantPriority
			or Nullx11Forge.Gear.RuneOrder()
	end

	---@param profile table
	---@param uuid string
	function Nullx11Forge.Gear.Enchant(profile, uuid)
		local entry = profile.Backpack.have[uuid]
		local used = {}
		for slot = 1, entry.EnchanceNum or 0 do
			local current = entry.EnchanceList and entry.EnchanceList[slot]
			local currentId = current and current.ID
			local wanted
			for _, stoneId in ipairs(Nullx11Forge.Gear.Priority()) do
				if
					not used[stoneId]
					and (
						stoneId == currentId
						or Nullx11Forge.Data.Count(profile, stoneId) > 0
					)
				then
					wanted = stoneId
					break
				end
			end
			if wanted then
				used[wanted] = true
				if wanted ~= currentId then
					if currentId then
						context.Send(
							Nullx11Forge.Util.Remote("Backpack", "UnEnchantRE"),
							"FireServer",
							uuid,
							slot
						)
						task.wait(0.04)
					end
					context.Send(
						Nullx11Forge.Util.Remote("Backpack", "EnchantRE"),
						"FireServer",
						uuid,
						Nullx11Forge.Data.Uuid(profile, wanted),
						slot
					)
					task.wait(0.04)
				end
			end
		end
	end

	---@param profile table
	---@return boolean
	function Nullx11Forge.Gear.Enhance(profile)
		local target = math.min(
			State.Opt.EnhanceTarget,
			Nullx11Forge.Util.Tier(
				Nullx11Forge.Util.HighestKey(
					Nullx11Forge.GameLib.Need(GameConfig.Enhant.Config)
				)
			)
		)
		local enhance =
			Nullx11Forge.Util.Remote("Backpack", "EnhantEquipmentRF")
		for _, spec in ipairs(Config.GearSlots) do
			local uuid = profile.Backpack.equiped[spec.slot]
			local entry = uuid and profile.Backpack.have[uuid]
			if entry and (entry.Level or 0) < target then
				local missing = Nullx11Forge.Gear.MissingForEnhance(
					profile,
					entry.Level or 0
				)
				if missing then
					Nullx11Forge.Gear.Gather(missing)
					return false
				end
				State.GearNote = "Enhancing"
				local useProtect = Nullx11Forge.Data.Count(
					profile,
					"EnhantProtect"
				) > 0 and (entry.Level or 0) >= Nullx11Forge.GameLib
					.Api(GameConfig.Enhant.Helper)
					.GetFailLevel()
				Nullx11Forge.Util.WaitAll(Config.GearEnhanceWorkers, function()
					for _ = 1, Config.GearEnhanceTries do
						if
							not context.Send(
								enhance,
								"InvokeServer",
								uuid,
								{ UseProtect = useProtect }
							)
						then
							return
						end
					end
				end)
				Nullx11Forge.Data.Get(true)
				return false
			end
		end
		return true
	end

	function Nullx11Forge.Gear.MaxStep()
		local opt = State.Opt
		if opt.GearForge and not State.GearForged then
			Nullx11Forge.Gear.ForgeBest()
			State.GearForged = true
		end
		if opt.GearEnchant then
			local profile = Nullx11Forge.Data.Get()
			for _, spec in ipairs(Config.GearSlots) do
				local uuid = profile.Backpack.equiped[spec.slot]
				if uuid then
					Nullx11Forge.Gear.Enchant(profile, uuid)
				end
			end
		end
		if
			not opt.GearEnhance
			or Nullx11Forge.Gear.Enhance(Nullx11Forge.Data.Get())
		then
			State.GearNote = "Done"
		end
	end

	---@param slot string
	---@param target number
	---@return number?
	function Nullx11Forge.Gear.EnhanceSlot(slot, target)
		local enhance =
			Nullx11Forge.Util.Remote("Backpack", "EnhantEquipmentRF")
		local failLevel =
			Nullx11Forge.GameLib.Api(GameConfig.Enhant.Helper).GetFailLevel()
		local level = 0
		for _ = 1, Config.SlotEnhanceRounds do
			local profile = Nullx11Forge.Data.Get()
			local uuid = profile.Backpack.equiped[slot]
			local entry = uuid and profile.Backpack.have[uuid]
			if not entry then
				return nil
			end
			level = entry.Level or 0
			if level >= target then
				return level
			end
			local missing = Nullx11Forge.Gear.MissingForEnhance(profile, level)
			if missing == "EnhantStone_1" then
				Nullx11Forge.Stage.FarmStones(Nullx11Forge.Stage.Best())
			elseif missing then
				return level
			else
				context.Send(enhance, "InvokeServer", uuid, {
					UseProtect = level >= failLevel
						and Nullx11Forge.Data.Count(
								profile,
								"EnhantProtect"
							)
							> 0,
				})
			end
		end
		Nullx11Forge.Data.Get(true)
		return level
	end

	---@param profile table
	---@return string
	function Nullx11Forge.Gear.EquippedNames(profile)
		local names = {}
		for _, spec in ipairs(Config.GearSlots) do
			local uuid = profile.Backpack.equiped[spec.slot]
			local entry = uuid and profile.Backpack.have[uuid]
			if entry then
				local shows = Nullx11Forge.GameLib.Require(
					GameConfig[entry.Type == "Weapon" and "Weapon" or "Armor"].Show
				)
				local show = shows and shows[entry.ID]
				table.insert(
					names,
					("%s +%d"):format(
						show and show.DisplayName or entry.ID,
						entry.Level or 0
					)
				)
			end
		end
		return table.concat(names, " · ")
	end

	---@return table[]
	function Nullx11Forge.Index.GearCatalog()
		local gear = {}
		local armorHelper = Nullx11Forge.GameLib.Api(GameConfig.Armor.Helper)
		for weaponId, weapon in
			pairs(Nullx11Forge.GameLib.Need(GameConfig.Weapon.Config))
		do
			table.insert(gear, {
				id = weaponId,
				slot = "Weapon",
				forgeType = "Weapon",
				forgeable = weapon.TLevel ~= nil,
			})
		end
		for armorId, armor in
			pairs(Nullx11Forge.GameLib.Need(GameConfig.Armor.Config))
		do
			table.insert(gear, {
				id = armorId,
				slot = armorHelper.GetBigType(armorId) or "Armor",
				forgeType = "Armor",
				forgeable = armor.TLevel ~= nil,
			})
		end
		return gear
	end

	---@return table[]
	function Nullx11Forge.Index.Missing()
		local unlocked = Nullx11Forge.Data.Get().Index.unlocked
		local missing = {}
		for _, gear in ipairs(Nullx11Forge.Index.GearCatalog()) do
			if
				State.Opt.IndexTypes[gear.slot]
				and not unlocked[gear.slot .. "-" .. gear.id]
			then
				table.insert(missing, gear)
			end
		end
		table.sort(missing, function(a, b)
			if a.forgeable ~= b.forgeable then
				return a.forgeable
			end
			return a.id < b.id
		end)
		return missing
	end

	---@param gear table
	---@return number, string?, number?
	function Nullx11Forge.Index.Plan(gear)
		local cached = State.Plans[gear.id]
		if cached then
			return cached[1], cached[2], cached[3]
		end

		local forgeUtils =
			Nullx11Forge.GameLib.Api(ReplicatedStorage.Utils.ForgeUtils)
		local helper = Nullx11Forge.GameLib.Api(
			gear.forgeType == "Weapon" and GameConfig.Weapon.Helper
				or GameConfig.Armor.Helper
		)
		local bestChance, bestOre, bestCount = 0, nil, nil
		local sliceStart = os.clock()
		for count = 1, Config.ForgeCountMax do
			local split = helper.GetForgePercentByNumber(count)
			if not split then
				continue
			end
			for _, oreId in ipairs(Nullx11Forge.Ore.Ids()) do
				if os.clock() - sliceStart > Config.PlanSlice then
					task.wait()
					sliceStart = os.clock()
				end
				local list = { [oreId] = count }
				local ok, chance = pcall(function()
					local low, high = forgeUtils.GetForgeOreResult(list)
					local power = forgeUtils.GetOreAvgPower(list)
					local total = 0
					for subType, share in pairs(split) do
						if share > 0 then
							total += share * (forgeUtils.GetEquPercent(
								gear.forgeType,
								count,
								low,
								high,
								power,
								subType
							)[gear.id] or 0)
						end
					end
					return total
				end)
				if ok and chance > bestChance then
					bestChance, bestOre, bestCount = chance, oreId, count
				end
			end
		end
		State.Plans[gear.id] = { bestChance, bestOre, bestCount }
		return bestChance, bestOre, bestCount
	end

	---@param gear table
	---@return string
	function Nullx11Forge.Index.Label(gear)
		local show =
			Nullx11Forge.GameLib.Need(GameConfig[gear.forgeType].Show)[gear.id]
		local name = ("%s [%s]"):format(
			show and show.DisplayName or gear.id,
			gear.slot
		)
		if not gear.forgeable then
			return name .. " - event"
		end
		local chance = Nullx11Forge.Index.Plan(gear)
		return chance > 0 and ("%s - %.2f%%"):format(name, chance * 100)
			or name .. " - no recipe"
	end

	---@return string[]
	function Nullx11Forge.Index.Choices()
		local labels, byLabel = {}, {}
		for _, gear in ipairs(Nullx11Forge.Index.Missing()) do
			local label = Nullx11Forge.Index.Label(gear)
			byLabel[label] = gear
			table.insert(labels, label)
		end
		State.MissingLabels = byLabel
		return labels
	end

	---@param gear table
	---@param copies number?
	---@return boolean
	function Nullx11Forge.Index.Hunt(gear, copies)
		local chance, oreId, count = Nullx11Forge.Index.Plan(gear)
		if chance <= 0 then
			return false
		end
		local budget = math.min(
			Config.HuntMaxForges * (copies or 1),
			math.ceil(Config.HuntTargetHits * (copies or 1) / chance)
		)
		local key = gear.slot .. "-" .. gear.id
		local forged, got = 0, 0
		while forged < budget and State.Alive do
			local uuid =
				Nullx11Forge.Ore.Ensure(oreId, count * Config.HuntBatch)
			if not uuid then
				return false
			end
			local before = Nullx11Forge.Data.Snapshot()
			local perWorker = math.ceil(Config.HuntBatch / Config.HuntWorkers)
			Nullx11Forge.Util.WaitAll(Config.HuntWorkers, function()
				for _ = 1, perWorker do
					Nullx11Forge.Forge.Run(gear.forgeType, { [uuid] = count })
				end
			end)
			forged += perWorker * Config.HuntWorkers
			State.IndexNote = ("%s %d/%d"):format(gear.id, forged, budget)
			local fresh = Nullx11Forge.Data.NewGear(before)
			local keep = {}
			for freshUuid, entry in pairs(fresh) do
				if entry.ID == gear.id and (not copies or got < copies) then
					keep[freshUuid] = true
					got += 1
				end
			end
			Nullx11Forge.Sell.Fresh(fresh, keep)
			if copies then
				State.IndexNote = ("%s %d/%d"):format(gear.id, got, copies)
				if got >= copies then
					return true
				end
			elseif State.Profile.Index.unlocked[key] or next(keep) then
				return true
			end
		end
		return false
	end

	---@param slot string
	---@return string[]
	function Nullx11Forge.Spawn.GearChoices(slot)
		local labels, byLabel, list = {}, {}, {}
		for _, gear in ipairs(Nullx11Forge.Index.GearCatalog()) do
			if not gear.forgeable or gear.slot ~= slot then
				continue
			end
			local helper = Nullx11Forge.GameLib.Api(
				gear.forgeType == "Weapon" and GameConfig.Weapon.Helper
					or GameConfig.Armor.Helper
			)
			local ok, power = pcall(helper.GetMainAffix, gear.id)
			table.insert(list, { gear, ok and tonumber(power) or 0 })
		end
		table.sort(list, function(a, b)
			return a[2] > b[2]
		end)
		for _, pair in ipairs(list) do
			local label = Nullx11Forge.Index.Label(pair[1])
			byLabel[label] = pair[1]
			table.insert(labels, label)
		end
		State.GearLabels = byLabel
		return labels
	end

	---@return number
	function Nullx11Forge.Spawn.BestSet()
		local made = 0
		for _, slot in ipairs(Config.GearTypes) do
			local best, bestPower = nil, -1
			for _, gear in ipairs(Nullx11Forge.Index.GearCatalog()) do
				if not gear.forgeable or gear.slot ~= slot then
					continue
				end
				local helper = Nullx11Forge.GameLib.Api(
					gear.forgeType == "Weapon" and GameConfig.Weapon.Helper
						or GameConfig.Armor.Helper
				)
				local ok, power = pcall(helper.GetMainAffix, gear.id)
				power = ok and tonumber(power) or 0
				if power > bestPower then
					best, bestPower = gear, power
				end
			end
			if best and Nullx11Forge.Index.Hunt(best, 1) then
				made += 1
			end
		end
		task.wait(0.5)
		Nullx11Forge.Gear.EquipBest()
		return made
	end

	---@return number
	function Nullx11Forge.Spawn.FullGodSet()
		local made = Nullx11Forge.Spawn.BestSet()
		Nullx11Forge.Stage.FarmStones(Nullx11Forge.Stage.Best())
		local profile = Nullx11Forge.Data.Get(true)
		Nullx11Forge.Gear.EquipBest()
		profile = Nullx11Forge.Data.Get(true)
		for _ = 1, 10 do
			if not State.Alive or Nullx11Forge.Gear.Enhance(profile) then
				break
			end
			profile = Nullx11Forge.Data.Get(true)
			task.wait(0.2)
		end
		for _, spec in ipairs(Config.GearSlots) do
			local uuid = profile.Backpack.equiped[spec.slot]
			if uuid then
				Nullx11Forge.Gear.Enchant(profile, uuid)
				context.Send(
					Nullx11Forge.Util.Remote("Backpack", "SetLockRE"),
					"FireServer",
					uuid,
					true
				)
			end
		end
		return made
	end

	---@return number, number
	function Nullx11Forge.Index.HuntAll()
		local found, tried = 0, 0
		for _, gear in ipairs(Nullx11Forge.Index.Missing()) do
			if not State.Opt.AutoIndex and State.Lock ~= "Index" then
				break
			end
			if gear.forgeable and Nullx11Forge.Index.Plan(gear) > 0 then
				tried += 1
				if Nullx11Forge.Index.Hunt(gear) then
					found += 1
				end
			end
		end
		Nullx11Forge.Index.ClaimAll()
		if tried > 0 then
			State.IndexNote = ("Found %d/%d"):format(found, tried)
		end
		return found, tried
	end

	function Nullx11Forge.Index.CollectOres()
		for _, stageId in ipairs(Nullx11Forge.Stage.List()) do
			Nullx11Forge.Stage.Collect(stageId, nil)
		end
		Nullx11Forge.Index.ClaimAll()
	end

	function Nullx11Forge.Index.ClaimAll()
		local index = Nullx11Forge.Data.Get().Index
		local claimExp = Nullx11Forge.Util.Remote("Index", "TryClaimIndexExpRF")
		for key in pairs(index.unlocked) do
			local itemType, itemId = key:match("^(.-)%-(.+)$")
			if itemType and not index.claimed[key] then
				context.Send(claimExp, "InvokeServer", itemType, itemId)
			end
		end
		local claimLevel =
			Nullx11Forge.Util.Remote("Index", "TryClaimLevelRewardRF")
		for _ = 1, Config.IndexLevelClaims do
			if not context.Send(claimLevel, "InvokeServer") then
				break
			end
		end
	end

	---@return number, number
	function Nullx11Forge.Index.Progress()
		local index = Nullx11Forge.Data.Get().Index
		local unlocked = 0
		for _ in pairs(index.unlocked) do
			unlocked += 1
		end
		return unlocked, index.level
	end

	---@param gen number
	---@return number?
	function Nullx11Forge.Level.FindBestArea(gen)
		local areas = Nullx11Forge.GameLib.Need(GameConfig.TrainArea.Config)
		local ids = {}
		for areaId in pairs(areas) do
			table.insert(ids, tonumber(areaId))
		end
		table.sort(ids, function(a, b)
			return areas[a].Basic > areas[b].Basic
		end)

		local function Live()
			return State.Opt.AutoTrain and State.TrainGen == gen
		end

		local into = Nullx11Forge.Util.Remote("Train", "IntoAutoTrainRE")
		for _, areaId in ipairs(ids) do
			if not Live() then
				return nil
			end
			State.TrainPending = areaId
			context.Send(into, "FireServer", areaId)
			local deadline = os.clock() + Config.TrainAcceptWait
			while
				Live()
				and os.clock() < deadline
				and LocalPlayer:GetAttribute("AutoTrainAreaID") ~= areaId
			do
				task.wait(0.1)
			end
			if LocalPlayer:GetAttribute("AutoTrainAreaID") == areaId then
				State.TrainPending = nil
				return areaId
			end
		end
		State.TrainPending = nil
		return nil
	end

	function Nullx11Forge.Level.Enter()
		if not State.Opt.AutoTrain or State.TrainEntering then
			return
		end
		if State.TrainArea then
			if os.clock() - State.TrainFiredAt < Config.TrainAcceptWait then
				return
			end
			State.TrainFiredAt = os.clock()
			context.Send(
				Nullx11Forge.Util.Remote("Train", "IntoAutoTrainRE"),
				"FireServer",
				State.TrainArea
			)
			return
		end

		local gen = State.TrainGen
		State.TrainEntering = true
		local ok, areaId = pcall(Nullx11Forge.Level.FindBestArea, gen)
		State.TrainEntering = false
		if not ok then
			error(areaId, 0)
		end
		if State.TrainGen == gen and areaId then
			State.TrainArea = areaId
			State.TrainFiredAt = os.clock()
		end
	end

	function Nullx11Forge.Level.Leave()
		local exit = Nullx11Forge.Util.Remote("Train", "ExitAutoTrainRE")
		for _ = 1, Config.TrainExitTries do
			local areaId = LocalPlayer:GetAttribute("AutoTrainAreaID")
				or State.TrainPending
				or State.TrainArea
			if not areaId then
				return
			end
			context.Send(exit, "FireServer", areaId)
			if not State.Alive then
				State.TrainPending = nil
				return
			end

			task.wait(Config.TrainSettle)
			if State.Opt.AutoTrain then
				return
			end
			if not LocalPlayer:GetAttribute("AutoTrainAreaID") then
				State.TrainPending = nil
				return
			end
		end
	end

	---@param enabled boolean
	function Nullx11Forge.Level.SetTraining(enabled)
		State.TrainGen += 1
		if enabled then
			Nullx11Forge.Level.Enter()
		else
			Nullx11Forge.Level.Leave()
		end
	end

	function Nullx11Forge.Level.Bind()
		table.insert(
			State.Conns,
			LocalPlayer:GetAttributeChangedSignal("AutoTrainAreaID")
				:Connect(function()
					if
						not State.Opt.AutoTrain
						or LocalPlayer:GetAttribute("AutoTrainAreaID")
					then
						return
					end
					task.delay(Config.TrainRejoinDelay, function()
						if
							State.Opt.AutoTrain
							and not LocalPlayer:GetAttribute("AutoTrainAreaID")
						then
							Nullx11Forge.Util.Try(Nullx11Forge.Level.Enter)
						end
					end)
				end)
		)
	end

	---@param profile table
	function Nullx11Forge.Level.UsePotions(profile)
		local potionConfig = Nullx11Forge.GameLib.Need(GameConfig.Potion.Config)
		local now = workspace:GetAttribute("ServerTime") or os.time()
		local buffs = profile.Buff or {}
		for potionName, count in pairs(profile.Potion or {}) do
			local buffId = potionConfig[potionName]
				and potionConfig[potionName].BuffID
			local active = buffId
				and type(buffs[buffId]) == "number"
				and buffs[buffId] > now
			if type(count) == "number" and count > 0 and not active then
				context.Send(
					Nullx11Forge.Util.Remote("Potion", "TryUsePotionRE"),
					"FireServer",
					potionName,
					1
				)
			end
		end
	end

	function Nullx11Forge.Level.TrainStep()
		local profile = Nullx11Forge.Data.Get()
		Nullx11Forge.Level.UsePotions(profile)
		if
			profile.Eco.rebirth ~= State.TrainRebirth
			or profile.Eco.level ~= State.TrainLevel
		then
			State.TrainRebirth = profile.Eco.rebirth
			State.TrainLevel = profile.Eco.level
			State.TrainArea = nil
		end

		if LocalPlayer:GetAttribute("AutoTrainAreaID") then
			State.TrainNilSince = nil
			return
		end
		State.TrainNilSince = State.TrainNilSince or os.clock()
		if os.clock() - State.TrainNilSince < Config.TrainWatchdog then
			return
		end
		Nullx11Forge.Level.Enter()
	end

	function Nullx11Forge.Level.Rebirth()
		context.Send(
			Nullx11Forge.Util.Remote("Rebirth", "TryRebirthRE"),
			"FireServer"
		)
		Nullx11Forge.Data.Get(true)
	end

	function Nullx11Forge.Level.RebirthStep()
		local profile = Nullx11Forge.Data.Get()
		local ok, needLevel = pcall(
			Nullx11Forge.GameLib.Api(GameConfig.Rebirth.Helper).GetNeedLevel,
			profile.Eco.rebirth + 1
		)
		if ok and needLevel and profile.Eco.level >= needLevel then
			Nullx11Forge.Level.Rebirth()
		end
	end

	function Nullx11Forge.Level.ClickOnce()
		Nullx11Forge.GameLib.Api(ReplicatedStorage.CTRL.TrainCTRL).TrainOnce()
	end

	function Nullx11Forge.Level.StartClicking()
		if State.ClickLoop then
			return
		end
		State.ClickLoop = task.defer(function()
			while State.Alive and State.Opt.AutoClick do
				Nullx11Forge.Scheduler.Run(
					"AutoClick",
					Nullx11Forge.Level.ClickOnce
				)
				task.wait(Config.ClickInterval)
			end
			State.ClickLoop = nil
		end)
	end

	---@return string[]
	function Nullx11Forge.Upgrade.Names()
		local names = {}
		for name in pairs(Nullx11Forge.GameLib.Need(GameConfig.Upgrade.Config)) do
			table.insert(names, name)
		end
		table.sort(names)
		return names
	end

	function Nullx11Forge.Upgrade.BuySelected()
		local buy = Nullx11Forge.Util.Remote("Upgrade", "UpgradeOnceRE")
		for name, selected in pairs(State.Opt.Upgrades) do
			if selected then
				context.Send(buy, "FireServer", name)
			end
		end
		Nullx11Forge.Data.Get(true)
	end

	---@return number
	function Nullx11Forge.Tower.LastRound()
		return #Nullx11Forge.GameLib.Need(GameConfig.Dungeon.Config.LootTab)
	end

	---@return boolean
	function Nullx11Forge.Tower.Enter()
		local deadline = os.clock() + 5
		while State.Entering and os.clock() < deadline do
			task.wait(0.1)
		end
		if State.InTower then
			return true
		end
		State.Entering = true
		local ok, entered = pcall(function()
			return context.Send(
				Nullx11Forge.Util.Remote("Dungeon", "TryIntoDungeonRF"),
				"InvokeServer",
				1
			)
		end)
		State.Entering = false
		State.InTower = ok and entered and true or false
		return State.InTower
	end

	function Nullx11Forge.Tower.Exit()
		if not State.InTower then
			return
		end
		State.InTower = false
		context.Send(
			Nullx11Forge.Util.Remote("Dungeon", "ExitDungeonRE"),
			"FireServer"
		)
	end

	---@return boolean
	function Nullx11Forge.Tower.FarmStep()
		if not Nullx11Forge.Tower.Enter() then
			return false
		end
		local round = Nullx11Forge.Tower.LastRound()
		local start = Nullx11Forge.Util.Remote("Dungeon", "StartRoundRE")
		local complete = Nullx11Forge.Util.Remote("Dungeon", "CompleteRoundRF")
		context.Send(start, "FireServer", round)
		Nullx11Forge.Util.WaitAll(Config.TowerWorkers, function()
			for _ = 1, Config.TowerCallsPerWorker do
				if context.Send(complete, "InvokeServer", round) then
					State.TowerLoot += 1
				end
			end
		end)
		Nullx11Forge.Data.Get(true)
		return true
	end

	---@param target number
	---@return number
	function Nullx11Forge.Tower.FarmCoins(target)
		target = math.clamp(target or 10000, 100, 1000000)
		local start = (Nullx11Forge.Season.Current() or {}).SeasonCoin or 0
		if not Nullx11Forge.Tower.Enter() then
			return 0
		end
		local round = Nullx11Forge.Tower.LastRound()
		local startRE = Nullx11Forge.Util.Remote("Dungeon", "StartRoundRE")
		local completeRF =
			Nullx11Forge.Util.Remote("Dungeon", "CompleteRoundRF")
		local deadline = os.clock() + Config.CoinFarmTimeout
		local gained = 0
		while State.Alive and gained < target and os.clock() < deadline do
			context.Send(startRE, "FireServer", round)
			for _ = 1, 15 do
				if not State.Alive then
					break
				end
				local res = context.Send(completeRF, "InvokeServer", round)
				if res then
					State.TowerLoot += 1
				end
			end
			Nullx11Forge.Data.Get(true)
			gained = ((Nullx11Forge.Season.Current() or {}).SeasonCoin or 0)
				- start
			task.wait(0.05)
		end
		Nullx11Forge.Tower.Exit()
		return math.max(0, gained)
	end

	---@return string?
	function Nullx11Forge.Boss.AttackId()
		local weapon = LocalPlayer:GetAttribute("WeaponType")
		return Config.BossAttackIds[weapon] or "G_ATK_1"
	end

	function Nullx11Forge.Boss.Join()
		context.Send(
			Nullx11Forge.Util.Remote("WorldBoss", "IntoWorldBossFightRE"),
			"FireServer"
		)
		local char = LocalPlayer.Character
		if char and not State.BossReturn then
			State.BossReturn = char:GetPivot()
		end
	end

	---@param boss Model
	function Nullx11Forge.Boss.StandNear(boss)
		local char = LocalPlayer.Character
		if not char then
			return
		end
		local pos = boss:GetPivot().Position
		if (char:GetPivot().Position - pos).Magnitude > Config.BossReach then
			char:PivotTo(
				CFrame.new(
					pos
						+ Vector3.new(
							0,
							Config.BossStandHeight,
							Config.BossStandBack
						),
					pos
				)
			)
		end
	end

	function Nullx11Forge.Boss.Step()
		local bossName = workspace:GetAttribute("CurrentWorldBoss")
		if not bossName then
			return
		end
		local attackId = Nullx11Forge.Boss.AttackId()
		if not attackId then
			return
		end
		if LocalPlayer:GetAttribute("IntoFight") ~= "WorldBoss" then
			Nullx11Forge.Boss.Join()
			task.wait(Config.BossJoinSettle)
		end

		local folder = workspace:FindFirstChild("EnemyFolder_Server")
		local boss = folder and folder:FindFirstChild(bossName)
		if not boss or boss:GetAttribute("Dead") then
			return
		end
		Nullx11Forge.Boss.StandNear(boss)
		local announce = Nullx11Forge.Util.Remote("Attack", "UseAnyATKRE")
		local attack =
			Nullx11Forge.Util.Remote("Attack", "AttackEnemyServiceRE")
		for _ = 1, Config.BossHitsPerTick do
			if
				not (State.Alive and State.Opt.AutoWorldBoss and boss.Parent)
				or boss:GetAttribute("Dead")
			then
				return
			end
			local timestamp = workspace:GetServerTimeNow()
			context.Send(announce, "FireServer", attackId, timestamp)
			context.Send(
				attack,
				"FireServer",
				{ bossName },
				{ Phase = 1, SkillID = attackId, Attacker = LocalPlayer },
				timestamp
			)
			task.wait(Config.BossHitGap)
		end
	end

	function Nullx11Forge.Boss.ClaimCards()
		local claim =
			Nullx11Forge.Util.Remote("WorldBoss", "TryClaimBossRewardRE")
		for card = 1, Config.BossCards do
			task.spawn(context.Send, claim, "FireServer", tostring(card))
		end
	end

	function Nullx11Forge.Boss.Leave()
		context.Send(
			Nullx11Forge.Util.Remote("WorldBoss", "ExitWorldBossFightRE"),
			"FireServer"
		)
		LocalPlayer:SetAttribute("IntoFight", nil)
		local char = LocalPlayer.Character
		if State.BossReturn and char then
			char:PivotTo(State.BossReturn)
		end
		State.BossReturn = nil
	end

	function Nullx11Forge.Boss.Bind()
		table.insert(
			State.Conns,
			Nullx11Forge.Util
				.Remote("WorldBoss", "BossDeadRE").OnClientEvent
				:Connect(function()
					if not State.Opt.AutoWorldBoss then
						return
					end
					State.BossLooting = os.clock()
					task.delay(Config.BossClaimDelay, function()
						if State.Opt.BossCards then
							Nullx11Forge.Util.Try(Nullx11Forge.Boss.ClaimCards)
						end
						task.wait(Config.BossHopAfter)
						Nullx11Forge.Util.Try(Nullx11Forge.Boss.Leave)
						State.BossDone = os.clock()
						State.BossLooting = nil
					end)
				end)
		)
		table.insert(
			State.Conns,
			Nullx11Forge.Util
				.Remote("WorldBoss", "BossEscapeRE").OnClientEvent
				:Connect(function()
					if State.Opt.AutoWorldBoss then
						Nullx11Forge.Util.Try(Nullx11Forge.Boss.Leave)
					end
				end)
		)
	end

	---@return table?
	function Nullx11Forge.Season.Current()
		local seasons = Nullx11Forge.Data.Get().Season or {}
		if seasons.Season1 then
			return seasons.Season1
		end
		local bestKey = Nullx11Forge.Util.HighestKey(seasons)
		return bestKey and seasons[bestKey] or seasons[next(seasons)]
	end

	---@return string[], table
	function Nullx11Forge.Season.Goods()
		local goods = Nullx11Forge.GameLib.Need(GameConfig.Season.GoodsConfig)
		local ids = {}
		for goodId in pairs(goods) do
			table.insert(ids, goodId)
		end
		table.sort(ids, function(a, b)
			return tonumber(a) < tonumber(b)
		end)
		local labels, byLabel = {}, {}
		for _, goodId in ipairs(ids) do
			local good = goods[goodId]
			local label = ("%s x%d (%d coin)"):format(
				good.ID,
				good.Number,
				good.NeedSeasonCoin
			)
			byLabel[label] = goodId
			table.insert(labels, label)
		end
		return labels, byLabel
	end

	---@return number
	function Nullx11Forge.Season.BuyExclusive()
		local goods = Nullx11Forge.GameLib.Need(GameConfig.Season.GoodsConfig)
		local exchange = Nullx11Forge.Util.Remote("Season", "ExchangeGoodsRE")
		local bought = 0
		for goodId, good in pairs(goods) do
			if not State.Alive then
				break
			end
			if
				good.Type ~= "Weapon"
				and good.Type ~= "Armor"
				and good.Type ~= "Hat"
			then
				continue
			end
			local season = Nullx11Forge.Season.Current()
			local before = season and ((season.Goods or {})[goodId] or 0) or 0
			if not season or before >= (good.Store or 1) then
				continue
			end
			local short = good.NeedSeasonCoin - (season.SeasonCoin or 0)
			if short > 0 then
				Nullx11Forge.Tower.FarmCoins(short)
				season = Nullx11Forge.Season.Current()
			end
			if not season or (season.SeasonCoin or 0) < good.NeedSeasonCoin then
				continue
			end
			context.Send(exchange, "FireServer", goodId)
			task.wait(0.3)
			local updated = Nullx11Forge.Season.Current()
			if updated and ((updated.Goods or {})[goodId] or 0) > before then
				bought += 1
			end
		end
		Nullx11Forge.Data.Get(true)
		return bought
	end

	function Nullx11Forge.Season.BuyGoods()
		local goods = Nullx11Forge.GameLib.Need(GameConfig.Season.GoodsConfig)
		local exchange = Nullx11Forge.Util.Remote("Season", "ExchangeGoodsRE")
		for goodId, wanted in pairs(State.Opt.SeasonGoods) do
			local good = goods[goodId]
			if not (wanted and good) then
				continue
			end
			for _ = 1, good.Store or 1 do
				if not State.Alive then
					return
				end
				local season = Nullx11Forge.Season.Current()
				local count = season and ((season.Goods or {})[goodId] or 0)
					or 0
				if
					not season
					or count >= (good.Store or 1)
					or (season.SeasonCoin or 0) < good.NeedSeasonCoin
				then
					break
				end
				context.Send(exchange, "FireServer", goodId)
				task.wait(0.2)
				local updated = Nullx11Forge.Season.Current()
				if
					not updated
					or ((updated.Goods or {})[goodId] or 0) <= count
				then
					break
				end
			end
		end
		Nullx11Forge.Data.Get(true)
	end

	function Nullx11Forge.Season.Step()
		context.Send(
			Nullx11Forge.Util.Remote("Season", "TryClaimDailyTicRE"),
			"FireServer"
		)
		context.Send(
			Nullx11Forge.Util.Remote("Season", "TryClaimAllRewardRE"),
			"FireServer"
		)
		task.wait(0.3)
		Nullx11Forge.Season.BuyGoods()
		local season = Nullx11Forge.Season.Current()
		if not (season and State.Opt.SeasonSpin) then
			return
		end
		local luck = Nullx11Forge.Util.Remote("Season", "LuckRE")
		for _ = 1, math.min(
			season.SeasonTicket or 0,
			math.clamp(State.Opt.SeasonSpinBatch, 1, 50)
		) do
			if
				not State.Alive
				or not State.Opt.AutoSeason
				or not State.Opt.SeasonSpin
			then
				break
			end
			context.Send(luck, "FireServer", 1)
			task.wait(0.3)
		end
	end

	function Nullx11Forge.Claim.All()
		context.Send(
			Nullx11Forge.Util.Remote("Offline", "TryClaimOfflineRewardRE"),
			"FireServer"
		)
		context.Send(
			Nullx11Forge.Util.Remote("Dungeon", "TryClaimDailyDunTicRE"),
			"FireServer"
		)
		context.Send(
			Nullx11Forge.Util.Remote("Season", "TryClaimDailyTicRE"),
			"FireServer"
		)
		context.Send(
			Nullx11Forge.Util.Remote("Season", "TryClaimAllRewardRE"),
			"FireServer"
		)
		context.Send(
			Nullx11Forge.Util.Remote("Player", "TryJoinGroupRE"),
			"FireServer"
		)
		Nullx11Forge.Util.Try(Nullx11Forge.Claim.CheckIn)
		Nullx11Forge.Util.Try(Nullx11Forge.Index.ClaimAll)

		local claimQuest =
			Nullx11Forge.Util.Remote("EnhantEvent", "TryClaimQuestRE")
		local claimUpdate =
			Nullx11Forge.Util.Remote("UpdateLog", "TryClaimUPDRewardRE")
		for id = 1, Config.ClaimIdScan do
			context.Send(claimQuest, "FireServer", id)
			context.Send(claimUpdate, "FireServer", id)
		end

		local ok, rewards = pcall(
			Nullx11Forge.GameLib.Api(GameConfig.Online.Helper).GetOnlineRewardConfig
		)
		for rewardName in
			pairs(ok and type(rewards) == "table" and rewards or {})
		do
			context.Send(
				Nullx11Forge.Util.Remote("Online", "TryClaimRE"),
				"FireServer",
				rewardName
			)
		end
		Nullx11Forge.Data.Get(true)
	end

	---@param code string
	---@return string
	function Nullx11Forge.Claim.Code(code)
		local message
		local hasListener, messageEvent =
			pcall(Nullx11Forge.Util.Remote, "Message", "MessageRE")
		local conn = hasListener
			and messageEvent.OnClientEvent:Connect(function(text)
				message = message or tostring(text)
			end)
		local ok, err = pcall(function()
			return context.Send(
				Nullx11Forge.Util.Remote("Code", "TryUseCodeRF"),
				"InvokeServer",
				code
			)
		end)
		local deadline = os.clock() + Config.CodeReplyWait
		while conn and not message and os.clock() < deadline do
			task.wait(0.05)
		end
		if conn then
			conn:Disconnect()
		end
		if not ok then
			return "failed: " .. tostring(err)
		end
		return message or "no reply"
	end

	---@return string
	function Nullx11Forge.Claim.AllCodes()
		local results = {}
		for _, code in ipairs(Config.Codes) do
			table.insert(
				results,
				("%s: %s"):format(code, Nullx11Forge.Claim.Code(code))
			)
		end
		return table.concat(results, "\n")
	end

	---@param uuid string
	---@return boolean
	function Nullx11Forge.SuperLoot.Kill(uuid)
		if type(uuid) ~= "string" or State.LootPending[uuid] then
			return false
		end
		local folder = workspace:FindFirstChild("EnemyFolder")
			or workspace:FindFirstChild("EnemyFolder_Server")
		local enemy = folder and folder:FindFirstChild(uuid)
		local hp = enemy and enemy:FindFirstChild("HPValue")
		if not hp or type(hp.Value) ~= "number" then
			return false
		end

		State.LootPending[uuid] = coroutine.running()
		local ok, claimed = pcall(function()
			local hit = Nullx11Forge.GameLib
				.Api(ReplicatedStorage.Utils.CommunicationUtils)
				.TryGetBindableEvent("Attack", "EnemyHitBE")
			if not hit or not hit:IsA("BindableEvent") then
				error("EnemyHitBE unavailable", 0)
			end
			local attackId = Nullx11Forge.Boss.AttackId() or "G_ATK_1"
			local info = {
				SkillID = attackId,
				IsCrit = State.Opt.AuraCritical,
				Damage = State.Opt.AuraDamage,
			}
			local rounds = math.min(3, math.max(1, math.ceil(hp.Value)))
			for _ = 1, rounds do
				if not State.Alive then
					return false
				end
				context.Send(hit, "Fire", uuid, State.Opt.AuraDamage, info)
			end
			task.wait(0.1)
			local superKill =
				Nullx11Forge.Util.FindRemote("SuperLoot", "KillSuperLootRE")
			if superKill then
				context.Send(superKill, "FireServer", uuid)
			end
			task.wait(0.15)
			local getOre = Nullx11Forge.Util.FindRemote("Stage", "GetOreRF")
			if getOre then
				context.Send(getOre, "InvokeServer", uuid)
			end
			local claimAll =
				Nullx11Forge.Util.FindRemote("Stage", "ClaimedAllOreRE")
			if claimAll then
				context.Send(claimAll, "FireServer")
			end
			return true
		end)
		State.LootPending[uuid] = nil
		if not ok then
			error(claimed, 0)
		end
		return claimed
	end

	function Nullx11Forge.SuperLoot.KillExisting()
		local folders = {
			workspace:FindFirstChild("EnemyFolder"),
			workspace:FindFirstChild("EnemyFolder_Server"),
		}
		for _, folder in ipairs(folders) do
			if not folder then
				continue
			end
			for _, enemy in ipairs(folder:GetChildren()) do
				local enemyId = enemy:GetAttribute("EnemyID")
				if type(enemyId) == "string" and enemyId:find("^Super") then
					Nullx11Forge.SuperLoot.Queue(enemy.Name)
				end
			end
		end
	end

	---@param uuid string
	function Nullx11Forge.SuperLoot.Queue(uuid)
		if
			not State.Alive
			or type(uuid) ~= "string"
			or State.LootSeen[uuid]
		then
			return
		end
		if #State.LootQueue >= 256 then
			return
		end
		State.LootSeen[uuid] = true
		table.insert(State.LootQueue, uuid)
	end

	function Nullx11Forge.SuperLoot.Step()
		local uuid = table.remove(State.LootQueue, 1)
		if not uuid then
			return
		end
		Nullx11Forge.SuperLoot.Kill(uuid)
	end

	function Nullx11Forge.SuperLoot.Bind()
		table.insert(
			State.Conns,
			Nullx11Forge.Util
				.Remote("SuperLoot", "RefreshSuperLootRE").OnClientEvent
				:Connect(function(_, uuid)
					if State.Opt.SuperLootAura then
						Nullx11Forge.SuperLoot.Queue(uuid)
					end
				end)
		)
		local folder = workspace:FindFirstChild("EnemyFolder")
		if folder then
			table.insert(
				State.Conns,
				folder.ChildRemoved:Connect(function(enemy)
					State.LootSeen[enemy.Name] = nil
					State.LootPending[enemy.Name] = nil
				end)
			)
		end
	end

	---@return number
	function Nullx11Forge.Combat.KillAll()
		local hit = Nullx11Forge.GameLib
			.Api(ReplicatedStorage.Utils.CommunicationUtils)
			.TryGetBindableEvent("Attack", "EnemyHitBE")
		if not hit or not hit:IsA("BindableEvent") then
			error("EnemyHitBE unavailable", 0)
		end

		local damage = State.Opt.AuraDamage
		local weaponType = LocalPlayer:GetAttribute("WeaponType")
		local attackId = Config.BossAttackIds[weaponType] or "K_ATK_1"
		local hitInfo = {
			SkillID = attackId,
			IsCrit = State.Opt.AuraCritical,
			Damage = damage,
		}

		local char = LocalPlayer.Character
		local origin = char and char:GetPivot().Position
		local mapWide = State.Opt.AuraMapWide or (State.Opt.AuraRange == 0)
		local range = State.Opt.AuraRange
		local burst = math.clamp(State.Opt.AuraBurst or 1, 1, 3)
		local targetFilter = State.Opt.AuraTarget or "All"

		local killed = 0
		local announce = Nullx11Forge.Util.FindRemote("Attack", "UseAnyATKRE")
		local attackService =
			Nullx11Forge.Util.FindRemote("Attack", "AttackEnemyServiceRE")
		local killEnemy = Nullx11Forge.Util.FindRemote("Attack", "KillEnemyRE")
		local killSuper =
			Nullx11Forge.Util.FindRemote("SuperLoot", "KillSuperLootRE")
		local getOre = Nullx11Forge.Util.FindRemote("Stage", "GetOreRF")
		local pickStone =
			Nullx11Forge.Util.FindRemote("Stage", "GetEnhantStoneRE")

		local folders = {
			workspace:FindFirstChild("EnemyFolder"),
			workspace:FindFirstChild("EnemyFolder_Server"),
		}
		for _, folder in ipairs(folders) do
			if not folder then
				continue
			end
			local children = folder:GetChildren()
			for _, enemy in ipairs(children) do
				if
					not State.Alive
					or not (State.Opt.KillAura or State.Opt.AutoBattle)
				then
					return killed
				end
				local enemyId = tostring(enemy:GetAttribute("EnemyID") or "")
				local isSuper = enemyId:find("^Super") ~= nil
				local isBoss = folder.Name == "EnemyFolder_Server"

				if targetFilter == "Normal" and (isSuper or isBoss) then
					continue
				end
				if targetFilter == "Super" and not isSuper then
					continue
				end
				if targetFilter == "Boss" and not isBoss then
					continue
				end

				local hp = enemy:FindFirstChild("HPValue")
				if hp and type(hp.Value) == "number" and hp.Value <= 0 then
					continue
				end
				if enemy:GetAttribute("Dead") == true then
					continue
				end

				if not mapWide and origin and enemy:IsA("Model") then
					if
						(enemy:GetPivot().Position - origin).Magnitude > range
					then
						continue
					end
				end

				local name = enemy.Name
				local hitRounds = isSuper
						and math.min(
							burst,
							math.max(1, math.ceil(hp and hp.Value or 10))
						)
					or 1
				for _ = 1, hitRounds do
					context.Send(hit, "Fire", name, damage, hitInfo)
				end

				if announce and attackService then
					local now = workspace:GetServerTimeNow()
					pcall(context.Send, announce, "FireServer", attackId, now)
					pcall(context.Send, attackService, "FireServer", { name }, {
						Phase = 1,
						SkillID = attackId,
						Attacker = LocalPlayer,
					}, now)
				end

				if isSuper then
					if killSuper then
						pcall(context.Send, killSuper, "FireServer", name)
					end
					if getOre then
						pcall(context.Send, getOre, "InvokeServer", name)
					end
				else
					if killEnemy then
						pcall(context.Send, killEnemy, "FireServer", name)
					end
				end

				killed += 1
				if killed >= State.Opt.AuraBatch then
					break
				end
			end
			if killed >= State.Opt.AuraBatch then
				break
			end
		end

		if State.Opt.AutoCollectDrops then
			local claimAll =
				Nullx11Forge.Util.FindRemote("Stage", "ClaimedAllOreRE")
			if claimAll then
				pcall(context.Send, claimAll, "FireServer")
			end
		end

		return killed
	end

	function Nullx11Forge.Combat.Start()
		if State.AuraLoop then
			return
		end
		State.AuraLoop = task.defer(function()
			while State.Alive and State.Opt.KillAura do
				Nullx11Forge.Scheduler.Run(
					"KillAura",
					Nullx11Forge.Combat.KillAll
				)
				task.wait(State.Opt.AuraInterval)
			end
			State.AuraLoop = nil
		end)
	end

	---@return boolean
	function Nullx11Forge.Guard.HookDamage()
		if State.RestoreDamage then
			return true
		end
		local hpCtrl =
			Nullx11Forge.GameLib.Require(ReplicatedStorage.CTRL.HPCTRL)
		local damageOnce = hpCtrl and hpCtrl.DamageOnce
		if type(damageOnce) ~= "function" then
			return false
		end

		hpCtrl.DamageOnce = function(target, damage)
			if target == LocalPlayer and State.Opt.GodMode then
				return false
			end
			return damageOnce(target, damage)
		end
		State.RestoreDamage = function()
			hpCtrl.DamageOnce = damageOnce
			State.RestoreDamage = nil
		end
		return true
	end

	---@return boolean
	function Nullx11Forge.Guard.HookOreLoss()
		if State.RestoreNamecall then
			return true
		end
		local compat = Nullx11Forge.Compat
		if not (compat and compat.Caps.Namecall) then
			return false
		end
		local found, lostOre =
			pcall(Nullx11Forge.Util.Remote, "Stage", "LostAllOreRF")
		if not found then
			warn("[Nullx11 Forge] keep ore:", lostOre)
			return false
		end

		local original, restore
		original, restore = compat.HookMeta(
			game,
			"__namecall",
			function(self, ...)
				if
					self == lostOre
					and State.Opt.KeepOre
					and getnamecallmethod() == "InvokeServer"
				then
					return {}
				end
				return original(self, ...)
			end
		)
		if not original then
			return false
		end

		State.RestoreNamecall = function()
			State.RestoreNamecall = nil
			restore()
		end
		return true
	end

	function Nullx11Forge.Guard.UnhookOreLoss()
		if State.RestoreNamecall then
			State.RestoreNamecall()
		end
	end

	function Nullx11Forge.Guard.Stop()
		if State.RestoreDamage then
			State.RestoreDamage()
		end
		Nullx11Forge.Guard.UnhookOreLoss()
	end

	---@return string[], table
	function Nullx11Forge.Race.Choices()
		local classConfig = Nullx11Forge.GameLib.Need(GameConfig.Class.Config)
		local show = Nullx11Forge.GameLib.Need(GameConfig.Class.Show)
		local ids = {}
		for classId in pairs(classConfig) do
			table.insert(ids, classId)
		end
		table.sort(ids, function(a, b)
			return classConfig[a].Weight < classConfig[b].Weight
		end)

		local labels, idByLabel = {}, {}
		for _, classId in ipairs(ids) do
			local label = ("%s (%s)"):format(
				show[classId] and show[classId].DisplayName or classId,
				classConfig[classId].Rarity
			)
			idByLabel[label] = classId
			table.insert(labels, label)
		end
		return labels, idByLabel
	end

	---@return boolean
	function Nullx11Forge.Race.EquipBest()
		local classData = Nullx11Forge.Data.Get().Class
		local classConfig = Nullx11Forge.GameLib.Need(GameConfig.Class.Config)
		local bestSlot, bestWeight = nil, math.huge
		for slot, classId in pairs(classData.have) do
			local weight = classConfig[classId] and classConfig[classId].Weight
				or math.huge
			if weight < bestWeight then
				bestSlot, bestWeight = slot, weight
			end
		end
		if
			not bestSlot
			or tostring(bestSlot) == tostring(classData.equiped)
		then
			return false
		end
		context.Send(
			Nullx11Forge.Util.Remote("Class", "ChangeEquipedIndexRE"),
			"FireServer",
			tostring(bestSlot)
		)
		Nullx11Forge.Data.Get(true)
		return true
	end

	---@param rarity any
	---@return number
	function Nullx11Forge.Race.RarityLevel(rarity)
		local ok, level = pcall(
			Nullx11Forge.GameLib.Api(GameConfig.Rarity.Helper).GetRarityLevel,
			rarity
		)
		return ok and tonumber(level) or 0
	end

	---@param classId string
	---@return number
	function Nullx11Forge.Race.Level(classId)
		local info = classId
			and Nullx11Forge.GameLib.Need(GameConfig.Class.Config)[classId]
		return info and Nullx11Forge.Race.RarityLevel(info.Rarity) or 0
	end

	---@return string[], table
	function Nullx11Forge.Race.RarityChoices()
		local seen, levels = {}, {}
		for _, info in pairs(Nullx11Forge.GameLib.Need(GameConfig.Class.Config)) do
			if seen[info.Rarity] then
				continue
			end
			seen[info.Rarity] = true
			table.insert(
				levels,
				{ info.Rarity, Nullx11Forge.Race.RarityLevel(info.Rarity) }
			)
		end
		table.sort(levels, function(a, b)
			return a[2] < b[2]
		end)
		local labels, byLabel = { "Off" }, {}
		for _, pair in ipairs(levels) do
			local label = pair[1] .. "+"
			table.insert(labels, label)
			byLabel[label] = pair[2]
		end
		return labels, byLabel
	end

	---@param classId string
	---@return number
	function Nullx11Forge.Race.Stars(classId)
		local record = Nullx11Forge.GameLib
			.Need(ReplicatedStorage.LocalData.ClassData)
			.GetData().recored
		local entry = record and record[classId]
		return entry and tonumber(entry.Level) or 0
	end

	---@param classId string
	---@return boolean
	function Nullx11Forge.Race.IsGoal(classId)
		if not classId then
			return false
		end
		local wanted = State.Opt.RaceTargets[classId]
			or (
				State.Opt.RaceMinLevel ~= nil
				and Nullx11Forge.Race.Level(classId)
					>= State.Opt.RaceMinLevel
			)
		return wanted
			and Nullx11Forge.Race.Stars(classId)
				>= (State.Opt.RaceStar or 0)
	end

	---@param classData table
	---@return string?, string?
	function Nullx11Forge.Race.PickSlot(classData)
		local slot = State.Opt.RaceSlot == "Equipped"
				and tostring(classData.equiped)
			or State.Opt.RaceSlot:match("%d+")
		if not (slot and classData.have[slot]) then
			return nil, "that slot is not unlocked"
		end
		if classData.lock and classData.lock[slot] then
			return nil, "that slot is locked"
		end
		return slot
	end

	---@param muted boolean
	function Nullx11Forge.Race.MuteAnim(muted)
		if not Nullx11Forge.Compat.Caps.Connections then
			return
		end
		local event =
			Nullx11Forge.Util.Remote("Class", "ShowLuckResultRE").OnClientEvent
		for _, conn in ipairs(getconnections(event)) do
			if muted then
				conn:Disable()
			else
				conn:Enable()
			end
		end
	end

	---@param classStore table
	---@return boolean
	function Nullx11Forge.Race.EnsureRolls(classStore)
		if (classStore.GetData().luckTimes or 0) > 0 then
			return true
		end
		if not State.Opt.RaceBuyRolls then
			return false
		end
		local config = Nullx11Forge.GameLib.Need(GameConfig.Season.GoodsConfig)
		local season = Nullx11Forge.Season.Current()
		for id, good in pairs(config) do
			if
				good.ID == "ClassRoll"
				and season
				and (season.SeasonCoin or 0) >= good.NeedSeasonCoin
				and ((season.Goods or {})[id] or 0) < (good.Store or 1)
			then
				context.Send(
					Nullx11Forge.Util.Remote("Season", "ExchangeGoodsRE"),
					"FireServer",
					id
				)
				local deadline = os.clock() + Config.RaceResultWait * 2
				repeat
					task.wait(0.1)
				until not State.Alive
					or (classStore.GetData().luckTimes or 0) > 0
					or os.clock() >= deadline
				return (classStore.GetData().luckTimes or 0) > 0
			end
		end
		return false
	end

	---@return string, string?
	function Nullx11Forge.Race.RollUntil()
		local classStore =
			Nullx11Forge.GameLib.Need(ReplicatedStorage.LocalData.ClassData)
		local roll = Nullx11Forge.Util.Remote("Class", "LuckOnceRE")
		local protectLevel =
			Nullx11Forge.Race.RarityLevel(Config.RaceProtectRarity)
		State.RaceRolls = 0
		while State.Alive and State.Opt.AutoRace do
			local classData = classStore.GetData()
			local slot, why = Nullx11Forge.Race.PickSlot(classData)
			if not slot then
				return "blocked", why
			end

			local current = classData.have[slot]
			if Nullx11Forge.Race.IsGoal(current) then
				if State.Opt.RaceLock then
					context.Send(
						Nullx11Forge.Util.Remote("Class", "SetIndexLockRE"),
						"FireServer",
						slot
					)
				end
				return "got", current
			end
			if
				State.Opt.RaceProtect
				and Nullx11Forge.Race.Level(current) >= protectLevel
			then
				return "blocked", "this slot holds a Mythic+ race"
			end
			if not Nullx11Forge.Race.EnsureRolls(classStore) then
				return "empty"
			end

			context.Send(roll, "FireServer", slot)
			State.RaceRolls += 1
			local deadline = os.clock() + Config.RaceResultWait
			repeat
				task.wait()
			until classStore.GetData().have[slot] ~= current
				or os.clock() > deadline
			task.wait(Config.RaceRollDelay)
		end
		return "stopped"
	end

	---@param refresh boolean?
	---@return table
	function Nullx11Forge.Pet.Store(refresh)
		local profile = Nullx11Forge.Data.Get(refresh)
		return profile and profile.Pet or {}
	end

	---@param petId string
	---@return string?
	function Nullx11Forge.Pet.Rarity(petId)
		local cfg = Nullx11Forge.GameLib.Need(GameConfig.Pet.Config)[petId]
		return cfg and cfg.Rarity
	end

	---@param entry table
	---@return number
	function Nullx11Forge.Pet.Score(entry)
		if type(entry) ~= "table" or entry.Type ~= "Pet" then
			return -1
		end
		local cfg = Nullx11Forge.GameLib.Need(GameConfig.Pet.Config)[entry.ID]
		if not cfg then
			return 0
		end
		local rarityLv = Nullx11Forge.Race.RarityLevel(cfg.Rarity)
		local boostSum = 0
		local ok, boosts = pcall(
			Nullx11Forge.GameLib.Api(ReplicatedStorage.Utils.BalanceUtils).GetPetBoosts,
			entry
		)
		if ok and type(boosts) == "table" then
			for _, val in pairs(boosts) do
				if type(val) == "number" then
					boostSum += val
				end
			end
		end
		local skills = type(entry.ExtraSkill) == "table" and #entry.ExtraSkill
			or 0
		return rarityLv * 10000
			+ boostSum * 1000
			+ (entry.Level or 1) * 10
			+ skills * 500
			+ Nullx11Forge.Util.Tier(entry.ID)
	end

	function Nullx11Forge.Pet.ResetVFX()
		pcall(function()
			local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local openGui = gui and gui:FindFirstChild("OpenEggGui")
			if openGui and openGui.Enabled then
				local vfx = ReplicatedStorage:FindFirstChild("GuiUtils")
					and ReplicatedStorage.GuiUtils:FindFirstChild("PetGUI")
					and ReplicatedStorage.GuiUtils.PetGUI:FindFirstChild(
						"OpenEggVFX"
					)
				if vfx then
					Nullx11Forge.GameLib.Api(vfx).Reset()
				end
			end
		end)
	end

	---@param muted boolean
	function Nullx11Forge.Pet.MuteAnim(muted)
		if Nullx11Forge.Compat and Nullx11Forge.Compat.Caps.Connections then
			local remote = Nullx11Forge.Util.FindRemote("Pet", "ShowLuckResult")
			if remote and remote:IsA("RemoteEvent") then
				for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
					if muted then
						conn:Disable()
					else
						conn:Enable()
					end
				end
			end
		end
		if muted then
			Nullx11Forge.Pet.ResetVFX()
		end
	end

	function Nullx11Forge.Pet.Bind()
		local remote = Nullx11Forge.Util.FindRemote("Pet", "ShowLuckResult")
		if remote and remote:IsA("RemoteEvent") then
			table.insert(
				State.Conns,
				remote.OnClientEvent:Connect(function()
					if State.Opt.SkipEggAnim then
						task.defer(Nullx11Forge.Pet.ResetVFX)
						task.delay(0.15, Nullx11Forge.Pet.ResetVFX)
					end
				end)
			)
		end
	end

	---@param petStore table?
	---@return number, number
	function Nullx11Forge.Pet.Counts(petStore)
		petStore = petStore or Nullx11Forge.Pet.Store()
		local pets, eggs = 0, 0
		for _, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" then
				pets += 1
			elseif entry.Type == "Egg" and not entry.HatchReadyTick then
				eggs += 1
			end
		end
		return pets, eggs
	end

	---@param preferEggId string?
	---@return number
	function Nullx11Forge.Pet.TrimEggs(preferEggId)
		local petStore = Nullx11Forge.Pet.Store()
		local byId, totalEggs = {}, 0
		for uuid, entry in pairs(petStore.have or {}) do
			if entry.Type == "Egg" and not entry.HatchReadyTick then
				byId[entry.ID] = byId[entry.ID] or {}
				table.insert(byId[entry.ID], uuid)
				totalEggs += 1
			end
		end
		local deleteRE = Nullx11Forge.Util.Remote("Pet", "DeleteRE")
		local deleted = 0
		local keepLimit = math.max(1, State.Opt.KeepPerEgg or 10)
		local maxEggs = petStore.maxEggNum or 25
		for eggId, list in pairs(byId) do
			local limit = keepLimit
			if
				preferEggId
				and eggId ~= preferEggId
				and totalEggs >= maxEggs - 3
			then
				limit = math.min(limit, math.max(2, math.floor(maxEggs / 4)))
			end
			for i = limit + 1, #list do
				context.Send(deleteRE, "FireServer", list[i])
				deleted += 1
				totalEggs -= 1
			end
		end
		if deleted > 0 then
			Nullx11Forge.Data.Get(true)
		end
		return deleted
	end

	---@return number, number
	function Nullx11Forge.Pet.CleanBag()
		local petStore = Nullx11Forge.Pet.Store()
		local protected = {}
		for _, uuid in pairs(petStore.equiped or {}) do
			protected[uuid] = true
		end
		local allPets = {}
		for uuid, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" then
				if entry.DeployStartTick then
					protected[uuid] = true
				end
				table.insert(allPets, {
					uuid = uuid,
					entry = entry,
					score = Nullx11Forge.Pet.Score(entry),
				})
			end
		end
		table.sort(allPets, function(a, b)
			return a.score > b.score
		end)
		for i = 1, math.min(#allPets, math.max(1, State.Opt.KeepBestPets or 6)) do
			protected[allPets[i].uuid] = true
		end
		local deleteRE = Nullx11Forge.Util.Remote("Pet", "DeleteRE")
		local deletedPets = 0
		for _, item in ipairs(allPets) do
			local rarity = Nullx11Forge.Pet.Rarity(item.entry.ID)
			if
				not protected[item.uuid] and State.Opt.DeletePetRarities[rarity]
			then
				context.Send(deleteRE, "FireServer", item.uuid)
				deletedPets += 1
			end
		end
		local deletedEggs = State.Opt.AutoDeleteEggs
				and Nullx11Forge.Pet.TrimEggs()
			or 0
		if deletedPets > 0 then
			Nullx11Forge.Data.Get(true)
		end
		return deletedPets, deletedEggs
	end

	---@return number, number
	function Nullx11Forge.Pet.HatchStep()
		Nullx11Forge.Pet.MuteAnim(true)
		local petStore = Nullx11Forge.Pet.Store()
		local now = (
			workspace.GetServerTimeNow and workspace:GetServerTimeNow()
		) or (workspace:GetAttribute("ServerTime") or os.time())
		local petCount = Nullx11Forge.Pet.Counts(petStore)
		local maxPet = petStore.maxPetNum or 25

		if petCount >= maxPet - 2 or State.Opt.AutoSellPet then
			Nullx11Forge.Pet.CleanBag()
			petStore = Nullx11Forge.Pet.Store(true)
			petCount = Nullx11Forge.Pet.Counts(petStore)
		end

		local openRE = Nullx11Forge.Util.Remote("Pet", "TryOpenEggRE")
		local hatchRE = Nullx11Forge.Util.Remote("Pet", "TryHatchEggRE")
		local opened = 0

		-- Open eggs in incubator whose server timer is ready
		for _, uuid in pairs(petStore.hatched or {}) do
			local entry = petStore.have and petStore.have[uuid]
			if
				entry
				and (entry.HatchReadyTick or 0) <= now
				and petCount + opened < maxPet
			then
				context.Send(openRE, "FireServer", uuid)
				opened += 1
			end
		end

		if opened > 0 then
			Nullx11Forge.Pet.ResetVFX()
			petStore = Nullx11Forge.Pet.Store(true)
			petCount = Nullx11Forge.Pet.Counts(petStore)
		end

		-- Incubate candidates up to free slots
		local usedSlots = 0
		for _ in pairs(petStore.hatched or {}) do
			usedSlots += 1
		end
		local maxHatch = petStore.maxHatchNum or 3
		local freeSlots = math.max(0, maxHatch - usedSlots)
		local hatched = 0

		if freeSlots > 0 then
			local targetEggId = "Egg2"
			if
				State.Opt.TargetPet
				and State.PetTargetLabels
				and State.PetTargetLabels[State.Opt.TargetPet]
			then
				local pId = State.PetTargetLabels[State.Opt.TargetPet]
				local eggCfg = Nullx11Forge.GameLib.Need(GameConfig.Egg.Config)
				for eggId, data in pairs(eggCfg or {}) do
					if data.PetList then
						for _, item in ipairs(data.PetList) do
							local subId = type(item) == "table"
									and (item.ID or item[1])
								or item
							if subId == pId then
								targetEggId = eggId
								break
							end
						end
					end
				end
			end

			local candidates = {}
			for uuid, entry in pairs(petStore.have or {}) do
				if entry.Type == "Egg" and not entry.HatchReadyTick then
					table.insert(candidates, {
						uuid = uuid,
						id = entry.ID,
						isTarget = (entry.ID == targetEggId),
						tier = Nullx11Forge.Util.Tier(entry.ID),
					})
				end
			end
			table.sort(candidates, function(a, b)
				if a.isTarget ~= b.isTarget then
					return a.isTarget
				end
				if State.Opt.HatchBestFirst then
					return a.tier > b.tier
				end
				return a.tier < b.tier
			end)

			for i = 1, math.min(freeSlots, #candidates) do
				context.Send(hatchRE, "FireServer", candidates[i].uuid)
				hatched += 1
			end
		end

		if hatched > 0 or opened > 0 then
			Nullx11Forge.Data.Get(true)
			Nullx11Forge.Pet.ResetVFX()
		end

		if State.Opt.AutoDeleteEggs then
			Nullx11Forge.Pet.TrimEggs()
		end
		return opened, hatched
	end

	---@return number, number
	function Nullx11Forge.Pet.InstantHatchAll()
		Nullx11Forge.Pet.MuteAnim(true)
		local petStore = Nullx11Forge.Pet.Store(true)
		local openRE = Nullx11Forge.Util.Remote("Pet", "TryOpenEggRE")
		local hatchRE = Nullx11Forge.Util.Remote("Pet", "TryHatchEggRE")
		local now = (
			workspace.GetServerTimeNow and workspace:GetServerTimeNow()
		) or (workspace:GetAttribute("ServerTime") or os.time())
		local maxPet = petStore.maxPetNum or 25

		Nullx11Forge.Pet.CleanBag()
		petStore = Nullx11Forge.Pet.Store(true)

		local opened, hatched = 0, 0
		-- 1. Open all ready eggs
		for _, uuid in pairs(petStore.hatched or {}) do
			local entry = petStore.have and petStore.have[uuid]
			if entry and (entry.HatchReadyTick or 0) <= now then
				context.Send(openRE, "FireServer", uuid)
				opened += 1
			end
		end

		if opened > 0 then
			Nullx11Forge.Pet.ResetVFX()
			petStore = Nullx11Forge.Pet.Store(true)
		end

		-- 2. Incubate unhatched eggs into free slots
		local usedSlots = 0
		for _ in pairs(petStore.hatched or {}) do
			usedSlots += 1
		end
		local maxHatch = petStore.maxHatchNum or 3
		local freeSlots = math.max(0, maxHatch - usedSlots)

		if freeSlots > 0 then
			local candidates = {}
			for uuid, entry in pairs(petStore.have or {}) do
				if entry.Type == "Egg" and not entry.HatchReadyTick then
					table.insert(
						candidates,
						{ uuid = uuid, tier = Nullx11Forge.Util.Tier(entry.ID) }
					)
				end
			end
			table.sort(candidates, function(a, b)
				return a.tier > b.tier
			end)
			for i = 1, math.min(freeSlots, #candidates) do
				context.Send(hatchRE, "FireServer", candidates[i].uuid)
				hatched += 1
			end
		end

		Nullx11Forge.Pet.ResetVFX()
		Nullx11Forge.Data.Get(true)
		if State.Opt.AutoEquipPet then
			Nullx11Forge.Pet.EquipBest()
		end
		if State.Opt.AutoFeedPet then
			Nullx11Forge.Pet.FeedBest()
		end
		return opened, hatched
	end

	---@return string[]
	function Nullx11Forge.Pet.Choices()
		local labels, ids = {}, {}
		local petFolder = GameConfig:FindFirstChild("Pet")
		local petShow = petFolder
			and petFolder:FindFirstChild("Show")
			and Nullx11Forge.GameLib.Require(petFolder.Show)
		local petCfg = petFolder
			and petFolder:FindFirstChild("Config")
			and Nullx11Forge.GameLib.Require(petFolder.Config)
		if petShow or petCfg then
			local petIds = {}
			local allPetKeys = {}
			if petShow then
				for id in pairs(petShow) do
					allPetKeys[id] = true
				end
			end
			if petCfg then
				for id in pairs(petCfg) do
					allPetKeys[id] = true
				end
			end
			for id in pairs(allPetKeys) do
				petIds[#petIds + 1] = id
			end
			table.sort(petIds, function(a, b)
				local rA = petCfg and petCfg[a] and petCfg[a].Rarity or ""
				local rB = petCfg and petCfg[b] and petCfg[b].Rarity or ""
				local lvA = Nullx11Forge.Race.RarityLevel(rA)
				local lvB = Nullx11Forge.Race.RarityLevel(rB)
				if lvA ~= lvB then
					return lvA > lvB
				end
				return Nullx11Forge.Util.Tier(a) > Nullx11Forge.Util.Tier(b)
			end)
			for _, id in ipairs(petIds) do
				local name = petShow
						and petShow[id]
						and (petShow[id].DisplayName or petShow[id].Name)
					or (petCfg and petCfg[id] and petCfg[id].Name)
					or id
				local rarity = petCfg and petCfg[id] and petCfg[id].Rarity
					or "Pet"
				local label = "[" .. rarity .. "] " .. name .. " (" .. id .. ")"
				labels[#labels + 1] = label
				ids[label] = id
			end
		end
		State.PetTargetLabels = ids
		return labels
	end

	---@return number
	function Nullx11Forge.Pet.LockAllGodPets()
		local petStore = Nullx11Forge.Pet.Store(true)
		local lockRE = Nullx11Forge.Util.Remote("Backpack", "SetLockRE")
		local locked = 0
		for uuid, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" and not entry.Lock then
				local rarity = Nullx11Forge.Pet.Rarity(entry.ID)
				local rarityLv = Nullx11Forge.Race.RarityLevel(rarity)
				if
					rarityLv >= 4 or table.find(petStore.equiped or {}, uuid)
				then
					context.Send(lockRE, "FireServer", uuid, true)
					locked += 1
				end
			end
		end
		return locked
	end

	---@param targetPetId string
	---@param neededCount number?
	---@return number, string
	function Nullx11Forge.Pet.FarmAndHatchTarget(targetPetId, neededCount)
		neededCount = math.max(1, math.floor(neededCount or 1))
		local eggCfg = Nullx11Forge.GameLib.Need(GameConfig.Egg.Config)
		local targetEggId = "Egg2"
		for eggId, data in pairs(eggCfg or {}) do
			if data.PetList then
				for _, item in ipairs(data.PetList) do
					local pId = type(item) == "table" and (item.ID or item[1])
						or item
					if pId == targetPetId then
						targetEggId = eggId
						break
					end
				end
			end
		end

		-- Ensure target eggs in bag
		local store = Nullx11Forge.Pet.Store(true)
		local targetEggCount = 0
		for _, entry in pairs(store.have or {}) do
			if
				entry.Type == "Egg"
				and entry.ID == targetEggId
				and not entry.HatchReadyTick
			then
				targetEggCount += 1
			end
		end

		if targetEggCount < 5 then
			Nullx11Forge.Pet.TrimEggs(targetEggId)
			Nullx11Forge.Stage.FarmTurbo(targetEggId, "Egg", 15)
			store = Nullx11Forge.Pet.Store(true)
		end

		-- Open finished eggs and incubate target eggs
		local opened, hatched = Nullx11Forge.Pet.HatchStep()

		store = Nullx11Forge.Pet.Store(true)
		local now = (
			workspace.GetServerTimeNow and workspace:GetServerTimeNow()
		) or (workspace:GetAttribute("ServerTime") or os.time())
		local minDiff = math.huge
		for _, u in pairs(store.hatched or {}) do
			local it = store.have and store.have[u]
			if it and it.HatchReadyTick then
				local diff = math.max(0, it.HatchReadyTick - now)
				if diff < minDiff then
					minDiff = diff
				end
			end
		end

		local newlyGained = 0
		for uuid, entry in pairs(store.have or {}) do
			if entry.Type == "Pet" and entry.ID == targetPetId then
				newlyGained += 1
				if State.Opt.AutoLockTargetPet and not entry.Lock then
					context.Send(
						Nullx11Forge.Util.Remote("Backpack", "SetLockRE"),
						"FireServer",
						uuid,
						true
					)
				end
			end
		end

		if newlyGained > 0 then
			Nullx11Forge.Pet.EquipBest()
			Nullx11Forge.Pet.FeedAllMax()
			return newlyGained, ("Acquired %s!"):format(targetPetId)
		end

		if minDiff < math.huge then
			return 0, ("Incubating %s (%ds left)"):format(targetEggId, minDiff)
		end
		return 0, "No eggs incubating"
	end

	function Nullx11Forge.Pet.ChaseStep()
		if not State.Opt.AutoChaseTargetPet then
			return
		end
		local picked = State.PetTargetLabels
			and State.PetTargetLabels[State.Opt.TargetPet]
		if not picked then
			return
		end
		local gained = Nullx11Forge.Pet.FarmAndHatchTarget(
			picked,
			State.Opt.TargetPetCopies or 1
		)
		if gained >= (State.Opt.TargetPetCopies or 1) then
			State.Opt.AutoChaseTargetPet = false
			if
				Library
				and Library.Options
				and Library.Options.AutoChaseTargetPet
			then
				Library.Options.AutoChaseTargetPet:SetValue(false)
			end
		end
	end

	function Nullx11Forge.Pet.InfiniteLoopStep()
		local petStore = Nullx11Forge.Pet.Store(true)
		local pets, eggs = Nullx11Forge.Pet.Counts(petStore)
		local maxEggs = petStore.maxEggNum or 25
		if eggs < maxEggs - 5 then
			Nullx11Forge.Stage.FarmEggsAndFood(20)
		end
		Nullx11Forge.Pet.HatchStep()
		Nullx11Forge.Pet.EquipBest()
		Nullx11Forge.Pet.FeedBest()
		Nullx11Forge.Pet.DeployStep()
	end

	---@return number
	function Nullx11Forge.Pet.EquipBest()
		local petStore = Nullx11Forge.Pet.Store()
		local owned = {}
		for uuid, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" then
				table.insert(
					owned,
					{ uuid = uuid, score = Nullx11Forge.Pet.Score(entry) }
				)
			end
		end
		if #owned == 0 then
			return 0
		end
		table.sort(owned, function(a, b)
			return a.score > b.score
		end)

		local maxEquip = petStore.maxEquipNum or 1
		local wanted, wantedList = {}, {}
		for i = 1, math.min(maxEquip, #owned) do
			wanted[owned[i].uuid] = owned[i].score
			table.insert(wantedList, owned[i])
		end

		local currentSet = {}
		for _, uuid in pairs(petStore.equiped or {}) do
			currentSet[uuid] = true
		end

		local equipRE = Nullx11Forge.Util.Remote("Pet", "IsEquipPetRE")
		local changed = 0
		for uuid in pairs(currentSet) do
			if not wanted[uuid] then
				local entry = petStore.have and petStore.have[uuid]
				local curScore = entry and Nullx11Forge.Pet.Score(entry) or -1
				local bestReplacement = wantedList[1]
				if bestReplacement and bestReplacement.score > curScore then
					context.Send(equipRE, "FireServer", uuid, false)
					currentSet[uuid] = nil
				end
			end
		end
		for _, item in ipairs(wantedList) do
			if not currentSet[item.uuid] then
				context.Send(equipRE, "FireServer", item.uuid, true)
				changed += 1
			end
		end
		if changed > 0 then
			Nullx11Forge.Data.Get(true)
		end
		return changed
	end

	---@return number
	function Nullx11Forge.Pet.FeedBest()
		local profile = Nullx11Forge.Data.Get()
		local petStore = profile.Pet or {}
		local foodCfg = Nullx11Forge.GameLib.Need(GameConfig.Food.Config)
		local petHelper = Nullx11Forge.GameLib.Api(GameConfig.Pet.Helper)
		local foods = {}
		for uuid, entry in pairs(profile.Backpack.have or {}) do
			local count = math.floor(entry.Number or 0)
			local info = entry.Type == "Food" and foodCfg[entry.ID]
			if info and count >= 1 and (info.Exp or 0) > 0 then
				table.insert(
					foods,
					{ uuid = uuid, count = count, exp = info.Exp }
				)
			end
		end
		if #foods == 0 then
			return 0
		end
		table.sort(foods, function(a, b)
			return a.exp > b.exp
		end)

		local equippedSet = {}
		for _, uuid in pairs(petStore.equiped or {}) do
			equippedSet[uuid] = true
		end
		local targets = {}
		for uuid, entry in pairs(petStore.have or {}) do
			if
				entry.Type == "Pet"
				and not petHelper.CheckLevelIsMax(entry.Level or 1, entry.ID)
			then
				local priority = (equippedSet[uuid] and 1e9 or 0)
					+ (entry.DeployStartTick and 1e8 or 0)
					+ Nullx11Forge.Pet.Score(entry)
				table.insert(
					targets,
					{ uuid = uuid, entry = entry, priority = priority }
				)
			end
		end
		if #targets == 0 then
			return 0
		end
		table.sort(targets, function(a, b)
			return a.priority > b.priority
		end)

		local target = targets[1]
		local maxLv = petHelper.GetMaxLevel(target.entry.ID) or 20
		local needExp = -(target.entry.Exp or 0)
		for lv = (target.entry.Level or 1) + 1, maxLv do
			needExp += (petHelper.GetNeedExp(lv) or 0)
		end
		if needExp <= 0 then
			return 0
		end

		local feedMap, usedAny = {}, false
		for _, food in ipairs(foods) do
			if needExp <= 0 then
				break
			end
			local use =
				math.min(food.count, math.max(1, math.ceil(needExp / food.exp)))
			if use > 0 then
				feedMap[food.uuid] = use
				needExp -= use * food.exp
				usedAny = true
			end
		end
		if not usedAny then
			return 0
		end
		context.Send(
			Nullx11Forge.Util.Remote("Pet", "FeedPetRE"),
			"FireServer",
			target.uuid,
			feedMap
		)
		Nullx11Forge.Data.Get(true)
		return 1
	end

	---@return number
	function Nullx11Forge.Pet.FeedAllMax()
		local totalFed = 0
		for _ = 1, 15 do
			local fed = Nullx11Forge.Pet.FeedBest()
			if fed <= 0 then
				break
			end
			totalFed += fed
			task.wait(0.05)
		end
		return totalFed
	end

	---@return number
	function Nullx11Forge.Pet.DeployStep()
		local petStore = Nullx11Forge.Pet.Store()
		if
			type(petStore.deployRewardList) == "table"
			and next(petStore.deployRewardList) ~= nil
		then
			context.Send(
				Nullx11Forge.Util.Remote("Pet", "ClaimAllDeployRewardRE"),
				"FireServer"
			)
		end
		local deployedCount = 0
		local candidates = {}
		for uuid, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" then
				if entry.DeployStartTick then
					deployedCount += 1
				else
					table.insert(
						candidates,
						{ uuid = uuid, score = Nullx11Forge.Pet.Score(entry) }
					)
				end
			end
		end
		local freeSlots = (petStore.maxDeployNum or 2) - deployedCount
		if freeSlots <= 0 or #candidates == 0 then
			return 0
		end
		table.sort(candidates, function(a, b)
			return a.score > b.score
		end)
		local deployRE = Nullx11Forge.Util.Remote("Pet", "IsDeployPetRE")
		local deployed = 0
		for i = 1, math.min(freeSlots, #candidates) do
			context.Send(deployRE, "FireServer", candidates[i].uuid, true)
			deployed += 1
		end
		if deployed > 0 then
			Nullx11Forge.Data.Get(true)
		end
		return deployed
	end

	---@param profile table?
	---@return string
	function Nullx11Forge.Pet.StatusText(profile)
		local prof = profile or Nullx11Forge.Data.Get() or {}
		local petStore = prof.Pet or {}
		local pets, eggs = Nullx11Forge.Pet.Counts(petStore)
		local hatched = 0
		for _ in pairs(petStore.hatched or {}) do
			hatched += 1
		end
		local deployed = 0
		for _, entry in pairs(petStore.have or {}) do
			if entry.Type == "Pet" and entry.DeployStartTick then
				deployed += 1
			end
		end
		local equippedNames = {}
		local petShow = GameConfig:FindFirstChild("Pet")
			and GameConfig.Pet:FindFirstChild("Show")
			and Nullx11Forge.GameLib.Require(GameConfig.Pet.Show)
		for _, uuid in pairs(petStore.equiped or {}) do
			local entry = petStore.have and petStore.have[uuid]
			if entry then
				local name = petShow
						and petShow[entry.ID]
						and petShow[entry.ID].DisplayName
					or entry.ID
					or "Pet"
				table.insert(
					equippedNames,
					("%s Lv.%d"):format(
						tostring(name),
						tonumber(entry.Level) or 1
					)
				)
			end
		end
		local eqText = #equippedNames > 0 and table.concat(equippedNames, ", ")
			or "None"
		local now = (
			workspace.GetServerTimeNow and workspace:GetServerTimeNow()
		) or (workspace:GetAttribute("ServerTime") or os.time())
		local hatchTimers = {}
		for _, uuid in pairs(petStore.hatched or {}) do
			local entry = petStore.have and petStore.have[uuid]
			if entry and entry.HatchReadyTick then
				local diff = math.max(0, math.floor(entry.HatchReadyTick - now))
				table.insert(hatchTimers, diff .. "s")
			end
		end
		local hatchDetail = #hatchTimers > 0
				and (" (" .. table.concat(hatchTimers, ", ") .. ")")
			or ""
		return string.format(
			"Pet: %s\nBags: %d/%d Pets · %d/%d Eggs | Hatch: %d/%d%s | Deploy: %d/%d",
			tostring(eqText),
			tonumber(pets) or 0,
			tonumber(petStore.maxPetNum) or 25,
			tonumber(eggs) or 0,
			tonumber(petStore.maxEggNum) or 25,
			tonumber(hatched) or 0,
			tonumber(petStore.maxHatchNum) or 3,
			tostring(hatchDetail or ""),
			tonumber(deployed) or 0,
			tonumber(petStore.maxDeployNum) or 2
		)
	end

	---@return Humanoid?
	function Nullx11Forge.Movement.Humanoid()
		return LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end

	function Nullx11Forge.Movement.Apply()
		local hum = Nullx11Forge.Movement.Humanoid()
		if not hum then
			return
		end
		hum.WalkSpeed = State.Opt.SpeedOn and State.Opt.WalkSpeed
			or (LocalPlayer:GetAttribute("OriWalkSpeed") or 22)
	end

	function Nullx11Forge.Movement.Bind()
		table.insert(
			State.Conns,
			UserInputService.JumpRequest:Connect(function()
				local hum = Nullx11Forge.Movement.Humanoid()
				if State.Opt.InfJump and hum then
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		)
		table.insert(
			State.Conns,
			LocalPlayer.CharacterAdded:Connect(function()
				task.wait(1)
				if State.Alive and State.Opt.SpeedOn then
					Nullx11Forge.Movement.Apply()
				end
			end)
		)
	end

	---@param enabled boolean
	function Nullx11Forge.Session.SetLowGraphics(enabled)
		RunService:Set3dRenderingEnabled(not enabled)
	end

	-- Queue consent is independent of choosing a server-hop/rejoin action.
	function Nullx11Forge.Session.PrepareArrival()
		if not State.Alive or not context.Alive then
			return false
		end
		local env = getgenv()
		env.Nullx11SelectedGameQueues = env.Nullx11SelectedGameQueues or {}
		local queued = env.Nullx11SelectedGameQueues
		local pending = State.HopQueued or queued.forge
		if not Config.ExecuteAfterHop then
			assert(
				not pending,
				"Earlier game code may remain queued. Clear your executor queue before teleport-only."
			)
			return true
		end
		local queue = queue_on_teleport
			or queueonteleport
			or (type(syn) == "table" and syn.queue_on_teleport)
		assert(
			type(queue) == "function",
			"Queue unavailable. Turn off execute-after-hop for teleport only."
		)
		if not pending then
			local ok, reason = pcall(queue, Config.ReloadSource)
			assert(ok, "Queue failed; teleport cancelled: " .. tostring(reason))
			State.HopQueued = true
			queued.forge = true
		end
		return true
	end

	function Nullx11Forge.Session.Rejoin()
		if not Nullx11Forge.Session.PrepareArrival() then
			return
		end
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end

	---@return boolean
	function Nullx11Forge.Session.HopSmallest()
		if not State.Alive or not context.Alive then
			return false
		end
		local body = Nullx11Forge.Util.HttpGet(
			("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(
				game.PlaceId
			)
		)
		local ok, list = pcall(HttpService.JSONDecode, HttpService, body or "")
		local best
		for _, server in
			ipairs(
				ok
						and type(list) == "table"
						and type(list.data) == "table"
						and list.data
					or {}
			)
		do
			if
				server.id == game.JobId
				or server.playing >= server.maxPlayers
			then
				continue
			end
			if not best or server.playing < best.playing then
				best = server
			end
		end
		if not best then
			return false
		end
		if not Nullx11Forge.Session.PrepareArrival() then
			return false
		end
		TeleportService:TeleportToPlaceInstance(
			game.PlaceId,
			best.id,
			LocalPlayer
		)
		return true
	end

	---@return boolean
	function Nullx11Forge.Session.SavePosition()
		local root = LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		State.SavedSpot = root and root.CFrame
		return State.SavedSpot ~= nil
	end

	---@return boolean
	function Nullx11Forge.Session.ReturnPosition()
		local root = LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not (root and State.SavedSpot) then
			return false
		end
		root.CFrame = State.SavedSpot
		return true
	end

	---@param enabled boolean
	function Nullx11Forge.Boss.HopFlag(enabled)
		local flag = Config.SaveFolder .. "/" .. Config.BossHopFlag
		pcall(function()
			if enabled then
				if not isfolder(Config.SaveFolder) then
					makefolder(Config.SaveFolder)
				end
				writefile(flag, tostring(os.time()))
			elseif isfile(flag) then
				delfile(flag)
			end
		end)
	end

	---@return number?
	function Nullx11Forge.Boss.SinceLastHop()
		local ok, stamp =
			pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopFlag)
		if not ok or not tonumber(stamp) then
			return nil
		end
		return os.time() - tonumber(stamp)
	end

	---@return boolean
	function Nullx11Forge.Boss.HopWanted()
		local since = Nullx11Forge.Boss.SinceLastHop()
		return since ~= nil and since < Config.BossHopResume
	end

	---@return string[], number
	function Nullx11Forge.Boss.LoadServers()
		local ok, text =
			pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopServers)
		if not ok then
			return {}, 0
		end
		local decoded
		ok, decoded = pcall(HttpService.JSONDecode, HttpService, text)
		if
			not ok
			or type(decoded) ~= "table"
			or type(decoded.ids) ~= "table"
		then
			return {}, 0
		end
		local fetchedAt = tonumber(decoded.at) or 0
		if os.time() - fetchedAt > Config.HopListTtl then
			return {}, 0
		end
		return decoded.ids, fetchedAt
	end

	---@param ids string[]
	---@param fetchedAt number
	function Nullx11Forge.Boss.SaveServers(ids, fetchedAt)
		pcall(function()
			if not isfolder(Config.SaveFolder) then
				makefolder(Config.SaveFolder)
			end
			writefile(
				Config.SaveFolder .. "/" .. Config.BossHopServers,
				HttpService:JSONEncode({ at = fetchedAt, ids = ids })
			)
		end)
	end

	---@return string[]
	function Nullx11Forge.Boss.FetchServers()
		if os.clock() < State.HopBlockedUntil then
			return {}
		end
		local body = Nullx11Forge.Util.HttpGet(
			("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(
				game.PlaceId
			)
		)
		local ok, list = pcall(HttpService.JSONDecode, HttpService, body or "")
		local ids = {}
		for _, server in
			ipairs(
				ok
						and type(list) == "table"
						and type(list.data) == "table"
						and list.data
					or {}
			)
		do
			if
				server.id ~= game.JobId
				and server.playing < server.maxPlayers
			then
				table.insert(ids, server.id)
			end
		end
		if #ids > 0 then
			State.HopFails, State.HopBackoff = 0, nil
			return ids
		end
		State.HopFails += 1
		State.HopBackoff = math.min(
			(State.HopBackoff or Config.HopBackoffStart / 2) * 2,
			Config.HopBackoffMax
		)
		State.HopBlockedUntil = os.clock() + State.HopBackoff
		warn(
			"[Nullx11 Forge] server list refused, retry in",
			State.HopBackoff,
			"s, fail",
			State.HopFails
		)
		return {}
	end

	---@return string?
	function Nullx11Forge.Boss.PickServer()
		local ids, fetchedAt = Nullx11Forge.Boss.LoadServers()
		if #ids == 0 then
			ids, fetchedAt = Nullx11Forge.Boss.FetchServers(), os.time()
		end
		while #ids > 0 do
			local serverId = table.remove(ids, math.random(#ids))
			if serverId ~= game.JobId then
				Nullx11Forge.Boss.SaveServers(ids, fetchedAt)
				return serverId
			end
		end
		Nullx11Forge.Boss.SaveServers(ids, fetchedAt)
		return nil
	end

	function Nullx11Forge.Boss.Hop()
		if not State.Alive or not context.Alive then
			return
		end
		local serverId = Nullx11Forge.Boss.PickServer()
		if not serverId then
			return
		end
		State.BossHopping = os.clock()
		Nullx11Forge.Boss.HopFlag(true)
		if not Nullx11Forge.Session.PrepareArrival() then
			return
		end
		TeleportService:TeleportToPlaceInstance(
			game.PlaceId,
			serverId,
			LocalPlayer
		)
	end

	---@return boolean
	function Nullx11Forge.Boss.WorthStaying()
		if
			State.BossLooting
			and os.clock() - State.BossLooting < Config.BossLootTimeout
		then
			return true
		end
		local boss = workspace:GetAttribute("CurrentWorldBoss")
		if boss and not State.BossDone then
			return true
		end
		if State.BossDone then
			return os.clock() - State.BossDone < Config.BossHopAfter
		end
		local nextTick, serverTime =
			workspace:GetAttribute("NextWorldBossTick"),
			workspace:GetAttribute("ServerTime")
		if not nextTick or not serverTime then
			return true
		end
		return nextTick - serverTime <= State.Opt.BossWaitMinutes * 60
	end

	function Nullx11Forge.Boss.HopGiveUp()
		State.Opt.BossHop = false
		Nullx11Forge.Boss.HopFlag(false)
		table.insert(
			State.Halted,
			{ "BossHop", "no server list from Roblox, try again later" }
		)
	end

	function Nullx11Forge.Boss.HopStep()
		if State.BossHopping then
			if os.clock() - State.BossHopping < Config.HopStall then
				return
			end
			State.BossHopping = false
		end
		if Nullx11Forge.Boss.WorthStaying() then
			return
		end
		if
			(Nullx11Forge.Boss.SinceLastHop() or Config.HopGap) < Config.HopGap
		then
			return
		end
		if State.HopFails >= Config.HopGiveUp then
			Nullx11Forge.Boss.HopGiveUp()
			return
		end
		Nullx11Forge.Boss.Hop()
	end

	function Nullx11Forge.Session.Bind()
		table.insert(
			State.Conns,
			TeleportService.TeleportInitFailed:Connect(function()
				if not State.BossHopping then
					return
				end
				State.BossHopping = false
				task.delay(1, Nullx11Forge.Util.Try, Nullx11Forge.Boss.HopStep)
			end)
		)
		table.insert(
			State.Conns,
			LocalPlayer.Idled:Connect(function()
				if not State.Alive or not State.Opt.AntiIdle then
					return
				end
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		)
		table.insert(
			State.Conns,
			GuiService.ErrorMessageChanged:Connect(function(msg)
				if
					State.Opt.AutoRejoin
					and msg ~= ""
					and not State.Rejoining
				then
					State.Rejoining = true
					task.delay(Config.RejoinDelay, Nullx11Forge.Session.Rejoin)
				end
			end)
		)
	end

	Nullx11Forge.Scheduler.Jobs = {
		{
			key = "SuperLootAura",
			every = Config.KillAuraInterval,
			run = function()
				Nullx11Forge.SuperLoot.Step()
			end,
		},
		{
			key = "AutoBattle",
			every = Config.KillAuraInterval,
			run = function()
				Nullx11Forge.Stage.BattleStep()
			end,
		},
		{
			key = "AutoCheckIn",
			every = Config.ClaimInterval,
			run = function()
				Nullx11Forge.Claim.CheckIn()
			end,
		},
		{
			key = "MaxGear",
			every = 0,
			run = function()
				Nullx11Forge.Gear.MaxStep()
			end,
		},
		{
			key = "CollectOre",
			every = 0,
			run = function()
				Nullx11Forge.Stage.Collect(
					State.Opt.Stage or Nullx11Forge.Stage.Best(),
					State.Opt.CollectRarities
				)
			end,
		},
		{
			key = "AutoForge",
			every = 0,
			run = function()
				Nullx11Forge.Forge.Step()
			end,
		},
		{
			key = "AutoEquip",
			every = Config.EquipInterval,
			run = function()
				Nullx11Forge.Gear.EquipBest()
			end,
		},
		{
			key = "AutoSell",
			every = Config.SellInterval,
			run = function()
				Nullx11Forge.Sell.Run(Nullx11Forge.Data.Get())
			end,
		},
		{
			key = "AutoTrain",
			every = 1,
			run = function()
				Nullx11Forge.Level.TrainStep()
			end,
		},
		{
			key = "AutoRebirth",
			every = Config.RebirthInterval,
			run = function()
				Nullx11Forge.Level.RebirthStep()
			end,
		},
		{
			key = "AutoUpgrade",
			every = Config.UpgradeInterval,
			run = function()
				Nullx11Forge.Upgrade.BuySelected()
			end,
		},
		{
			key = "AutoTower",
			every = 0,
			run = function()
				Nullx11Forge.Tower.FarmStep()
			end,
		},
		{
			key = "AutoWorldBoss",
			every = Config.BossInterval,
			run = function()
				Nullx11Forge.Boss.Step()
			end,
		},
		{
			key = "BossHop",
			every = Config.BossHopInterval,
			run = function()
				Nullx11Forge.Boss.HopStep()
			end,
		},
		{
			key = "AutoClaim",
			every = Config.ClaimInterval,
			run = function()
				Nullx11Forge.Claim.All()
			end,
		},
		{
			key = "AutoSeason",
			every = Config.SeasonInterval,
			run = function()
				Nullx11Forge.Season.Step()
			end,
		},
		{
			key = "AutoTokenShop",
			every = Config.TokenShopInterval,
			run = function()
				Nullx11Forge.TokenShop.BuyAll()
			end,
		},
		{
			key = "AutoBestRace",
			every = 10,
			run = function()
				Nullx11Forge.Race.EquipBest()
			end,
		},
		{
			key = "TurboSpawn",
			every = 0,
			run = function()
				Nullx11Forge.Spawn.TurboStep()
			end,
		},
		{
			key = "AutoChaseTargetPet",
			every = 1,
			run = function()
				Nullx11Forge.Pet.ChaseStep()
			end,
		},
		{
			key = "AutoHatchEgg",
			every = 1,
			run = function()
				Nullx11Forge.Pet.HatchStep()
			end,
		},
		{
			key = "AutoEquipPet",
			every = Config.PetInterval,
			run = function()
				Nullx11Forge.Pet.EquipBest()
			end,
		},
		{
			key = "AutoFeedPet",
			every = Config.PetInterval,
			run = function()
				Nullx11Forge.Pet.FeedBest()
			end,
		},
		{
			key = "AutoDeployPet",
			every = Config.PetDeployInterval,
			run = function()
				Nullx11Forge.Pet.DeployStep()
			end,
		},
		{
			key = "AutoSellPet",
			every = Config.SellInterval,
			run = function()
				Nullx11Forge.Pet.CleanBag()
			end,
		},
		{
			key = "AutoIndex",
			every = Config.IndexInterval,
			run = function()
				Nullx11Forge.Util.Exclusive("Index", Nullx11Forge.Index.HuntAll)
			end,
		},
	}

	---@param key string
	---@param fn function
	function Nullx11Forge.Scheduler.Run(key, fn)
		if not State.Alive or State.JobRunning[key] then
			return
		end
		local result
		local thread = task.defer(function()
			result = table.pack(pcall(fn))
		end)
		State.JobRunning[key] = thread
		local deadline = os.clock() + State.Opt.JobTimeout
		local toggleJob = type(State.Opt[key]) == "boolean"
		while
			State.Alive
			and (not toggleJob or State.Opt[key])
			and not result
			and os.clock() < deadline
		do
			task.wait(0.05)
		end
		if not result then
			Nullx11Forge.Util.CancelTree(thread)
			result = { false, "job timed out" }
		end
		State.JobRunning[key] = nil
		if not State.Alive or (toggleJob and not State.Opt[key]) then
			return
		end
		local ok, err = result[1], result[2]
		State.JobStats[key] = {
			ok = ok,
			at = os.clock(),
			error = not ok and tostring(err) or nil,
		}
		local failures = State.Failures
		if ok then
			failures[key] = nil
			return
		end

		local streak = failures[key]
		if not streak then
			streak = { count = 0, since = os.clock() }
			failures[key] = streak
			Nullx11Forge.Util.WarnJob(key, err)
		end
		streak.count += 1
		if
			streak.count < Config.MaxFailures
			or os.clock() - streak.since < Config.FailWindow
		then
			return
		end

		failures[key] = nil
		State.Opt[key] = false
		local reason = tostring(err):match("[^\n]*")
		warn("[Nullx11 Forge]", key, "stopped:", reason)
		table.insert(State.Halted, { key, reason })
	end

	Nullx11Forge.Scheduler.Groups = {
		SuperLootAura = "combat",
		KillAura = "combat",
		AutoBattle = "combat",
		AutoWorldBoss = "combat",
		AutoTrain = "train",
		AutoClick = "train",
		AutoRebirth = "train",
		AutoHatchEgg = "pet",
		AutoEquipPet = "pet",
		AutoFeedPet = "pet",
		AutoDeployPet = "pet",
		AutoSellPet = "pet",
		BossHop = "travel",
	}

	function Nullx11Forge.Scheduler.Step()
		if not State.Alive then
			return
		end
		local now = os.clock()
		if State.Lock and State.LockTime and (now - State.LockTime > 12) then
			State.Lock = nil
			State.LockOwner = nil
			State.LockTime = 0
		end
		if State.Lock then
			return
		end

		local active = 0
		for _ in pairs(State.JobGroups) do
			active += 1
		end
		local jobs = Nullx11Forge.Scheduler.Jobs
		local cursor = State.ScheduleCursor or 0
		State.ScheduleCursor = cursor % #jobs + 1
		for offset = 1, #jobs do
			if active >= math.clamp(State.Opt.ParallelJobs, 1, 8) then
				break
			end
			local index = (cursor + offset - 1) % #jobs + 1
			local job = jobs[index]
			local group = Nullx11Forge.Scheduler.Groups[job.key] or "inventory"
			if
				not State.Opt[job.key]
				or State.JobRunning[job.key]
				or State.JobGroups[group]
			then
				continue
			end
			if now - (State.LastRun[job.key] or 0) < job.every then
				continue
			end
			State.LastRun[job.key] = now
			active += 1
			local monitor
			monitor = task.defer(function()
				local ok, err =
					pcall(Nullx11Forge.Scheduler.Run, job.key, job.run)
				if State.JobGroups[group] == monitor then
					State.JobGroups[group] = nil
				end
				if not ok and State.Alive then
					Nullx11Forge.Util.WarnJob(job.key, err)
				end
			end)
			State.JobGroups[group] = monitor
		end
	end

	function Nullx11Forge.Scheduler.Start()
		task.spawn(function()
			while State.Alive do
				if not State.Busy then
					State.Busy = true
					Nullx11Forge.Util.Try(Nullx11Forge.Scheduler.Step)
					State.Busy = false
				end
				task.wait(Config.TickDelay)
			end
		end)
	end

	function Nullx11Forge.Scheduler.Boot()
		for _, bind in ipairs({
			Nullx11Forge.Movement.Bind,
			Nullx11Forge.Level.Bind,
			Nullx11Forge.SuperLoot.Bind,
			Nullx11Forge.Boss.Bind,
			Nullx11Forge.Pet.Bind,
			Nullx11Forge.Session.Bind,
		}) do
			Nullx11Forge.Util.Try(bind)
		end
		Nullx11Forge.Scheduler.Start()
	end

	function Nullx11Forge.Scheduler.Stop()
		State.Alive = false
		for _, threads in pairs(State.WorkerBatches) do
			for _, thread in ipairs(threads) do
				pcall(task.cancel, thread)
			end
		end
		for _, thread in pairs(State.JobRunning) do
			pcall(task.cancel, thread)
		end
		for _, monitor in pairs(State.JobGroups) do
			Nullx11Forge.Util.CancelTree(monitor)
		end
		for owner in pairs(State.ChildThreads) do
			Nullx11Forge.Util.CancelTree(owner)
		end
		table.clear(State.JobGroups)
		table.clear(State.ChildThreads)
		State.Lock = nil
		State.LockOwner = nil
		State.LockTime = 0
		table.clear(State.WorkerBatches)
		table.clear(State.JobRunning)
		table.clear(State.LootQueue)
		table.clear(State.LootSeen)
		table.clear(State.LootPending)
		for _, conn in ipairs(State.Conns) do
			conn:Disconnect()
		end
		table.clear(State.Conns)
		if State.Opt.AutoTrain then
			State.Opt.AutoTrain = false
			Nullx11Forge.Util.Try(Nullx11Forge.Level.SetTraining, false)
		end
		if State.Opt.SpeedOn then
			State.Opt.SpeedOn = false
			Nullx11Forge.Movement.Apply()
		end
		if State.Opt.LowGraphics then
			Nullx11Forge.Session.SetLowGraphics(false)
		end
		Nullx11Forge.Util.Try(Nullx11Forge.Pet.MuteAnim, false)
		Nullx11Forge.Util.Try(Nullx11Forge.Tower.Exit)
		if LocalPlayer:GetAttribute("IntoFight") == "WorldBoss" then
			Nullx11Forge.Util.Try(Nullx11Forge.Boss.Leave)
		end
		Nullx11Forge.Guard.Stop()
	end

	local function BuildInterface()
		local Library = Nullx11Forge.Util.LoadLibrary()
		if not Library then
			return
		end
		Nullx11Forge.Compat = Library.Compat
			or { Caps = {}, Block = function() end, NeedCap = function() end }
		local Options = Library.Options
		pcall(Nullx11Banner.Step, "UI library")
		local T = function(en, th)
			return Library:T(en, th)
		end
		local opt = State.Opt
		local featureNames = {}
		local uiQueue = {}
		local statusLabel, gearLabel, taskLabel

		---@param fn function
		---@return table, table
		local function Source(fn)
			local ok, first, second = pcall(fn)
			if not ok then
				warn("[Nullx11 Forge] menu data:", first)
				return {}, {}
			end
			return first or {}, second or {}
		end

		local rarityNames = Source(Nullx11Forge.Util.RarityNames)

		local function Later(fn, ...)
			local args = table.pack(...)
			table.insert(uiQueue, function()
				fn(table.unpack(args, 1, args.n))
			end)
		end

		local function Notify(text, kind, seconds)
			Later(
				Library.Notify,
				Library,
				"Loot To Forge",
				text,
				seconds or 4,
				kind or "Info"
			)
		end

		local function TurnOff(key)
			local toggle = Options[key]
			if toggle and toggle.Value then
				toggle:SetValue(false)
			end
		end

		---@param idx string
		---@param values table
		---@param pickFirst boolean?
		local function SetList(idx, values, pickFirst)
			local dropdown = Options[idx]
			if not dropdown then
				return
			end
			dropdown:SetValues(values)
			if pickFirst and values[1] then
				dropdown:SetValue(values[1])
			elseif dropdown.Value ~= opt[idx] then
				dropdown:SetValue(dropdown.Value)
			end
		end

		---@param option any
		---@param module Instance
		local function NeedModule(option, module)
			if Nullx11Forge.GameLib.Require(module) then
				return
			end
			Nullx11Forge.Compat.Block(
				option,
				T(
					"Not available on this executor",
					"ใช้กับ executor นี้ไม่ได้"
				)
			)
		end

		local function BlockMissing()
			for idx, paths in pairs(Nullx11Forge.GameLib.Missing()) do
				warn(
					"[Nullx11 Forge]",
					idx,
					"blocked, missing:",
					table.concat(paths, ", ")
				)
				if Options[idx] then
					Nullx11Forge.Compat.Block(
						Options[idx],
						T(
							"Not available after a game update",
							"ใช้ไม่ได้หลังเกมอัปเดต"
						)
					)
				end
			end
		end

		local function Pump()
			for _, halt in ipairs(State.Halted) do
				TurnOff(halt[1])
				Notify(
					("%s stopped: %s"):format(
						featureNames[halt[1]] or halt[1],
						halt[2]
					),
					"Warning"
				)
			end
			table.clear(State.Halted)

			local jobs = uiQueue
			uiQueue = {}
			for _, job in ipairs(jobs) do
				Nullx11Forge.Util.Try(job)
			end
		end

		local actionId = 0
		local function Action(action)
			actionId += 1
			local key = "Action:" .. actionId
			return function()
				if not State.Alive or State.JobRunning[key] then
					return
				end
				task.defer(Nullx11Forge.Scheduler.Run, key, action)
			end
		end

		---@param name string
		---@param action function
		---@param done function?
		local function LongAction(name, action, done)
			return Action(function()
				if State.Lock then
					return Notify("Busy: " .. State.Lock, "Warning")
				end
				Notify(name .. "...")
				local acquired, outcome =
					Nullx11Forge.Util.Exclusive(name, action)
				if not acquired then
					return Notify(
						"An inventory task is still running; retry when it finishes",
						"Warning"
					)
				end
				if done then
					Notify(
						done(outcome),
						(outcome == false or outcome == nil or outcome == 0)
								and "Warning"
							or "Success"
					)
				end
			end)
		end

		local function Toggle(group, key, text, description, onChange)
			featureNames[key] = text.EN
			return group:AddToggle(key, {
				Text = text,
				Description = description,
				Default = opt[key],
				Callback = function(value)
					opt[key] = value
					if onChange then
						onChange(value)
					end
				end,
			})
		end

		local Feature = Toggle

		local function HotkeyFeature(group, key, text, description, onChange)
			return Toggle(group, key, text, description, onChange):AddKeyPicker(
				key .. "Key",
				{ Default = "None", Mode = "Toggle" }
			)
		end

		local function Check(group, key, text)
			return group:AddCheckbox(key, {
				Text = text,
				Default = opt[key],
				Callback = function(value)
					opt[key] = value
				end,
			})
		end

		local function MultiSelect(group, key, text, description, values)
			opt[key] = Nullx11Forge.Util.AllSet(values)
			return group:AddDropdown(key, {
				Text = text,
				Description = description,
				Values = values,
				Multi = true,
				Default = values,
				Searchable = #values > 8,
				Callback = function(selected)
					opt[key] = selected
				end,
			})
		end

		---@param group any
		---@param key string
		---@param text table
		---@param description table?
		---@param source function
		---@param noSave boolean?
		local function Pick(group, key, text, description, source, noSave)
			local values = Source(source)
			opt[key] = values[1]
			return group:AddDropdown(key, {
				Text = text,
				Description = description,
				Values = values,
				Default = 1,
				Searchable = #values > 8,
				NoSave = noSave,
				Callback = function(value)
					opt[key] = value
				end,
			})
		end

		local function NumberInput(group, key, text, description, minimum)
			return group:AddInput(key, {
				Text = text,
				Description = description,
				Default = tostring(opt[key]),
				Numeric = true,
				Finished = true,
				Callback = function(value)
					opt[key] = math.max(
						minimum or 0,
						math.floor(tonumber(value) or opt[key])
					)
				end,
			})
		end

		---@param idx string
		---@param idOf function
		local function Decorate(idx, idOf)
			task.defer(function()
				local dropdown = Options[idx]
				if not (dropdown and dropdown.SetImages) then
					return
				end
				local ok, images, colors =
					pcall(Nullx11Forge.Look.Maps, dropdown.Values, idOf)
				if not ok then
					return warn("[Nullx11 Forge] item images:", images)
				end
				Later(function()
					if Options[idx] then
						Options[idx]:SetImages(images, colors)
					end
				end)
			end)
		end

		local function OreId(label)
			return State.OreLabels and State.OreLabels[label]
		end

		local function RefreshButton(idx, list)
			return {
				Text = T("Refresh", "รีเฟรช"),
				Func = function()
					task.defer(function()
						Later(SetList, idx, (Source(list)))
						if State.Decorators and State.Decorators[idx] then
							Later(Decorate, idx, State.Decorators[idx])
						end
					end)
				end,
			}
		end

		local function BuildMain(tab)
			local statusBox =
				tab:AddLeftGroupbox(T("Status", "สถานะ"))
			statusLabel = statusBox:AddLabel("Loading...")
			gearLabel = statusBox:AddLabel("Equipped: -")
			taskLabel = statusBox:AddLabel("Working on: Idle")

			local kaitunBox =
				tab:AddLeftGroupbox(T("Kaitun", "ไก่ตัน"))
			kaitunBox:AddToggle("Kaitun", {
				Text = T(
					"Kaitun (All-in-one)",
					"ไก่ตัน (ทำทุกอย่าง)"
				),
				Description = T(
					"Best gear, money, level, rewards and bosses all at once",
					"ของดีสุด เงิน เลเวล รางวัล และบอส ทำพร้อมกันทั้งหมด"
				),
				NoSave = true,
				Callback = function(value)
					for _, key in ipairs(Config.KaitunToggles) do
						if Options[key] then
							Options[key]:SetValue(value)
						end
					end
				end,
			})

			local logBox = tab:AddRightGroupbox(
				T("Update Log", "อัปเดตล่าสุด"),
				"bell"
			)
			for i = 1, math.min(2, #Config.UpdateLog) do
				local entry = Config.UpdateLog[i]
				logBox:AddParagraph({ Title = entry[1], Content = entry[2] })
			end

			local rewardBox =
				tab:AddLeftGroupbox(T("Rewards", "รางวัล"))
			Feature(
				rewardBox,
				"AutoClaim",
				T(
					"Auto Claim",
					"รับรางวัลอัตโนมัติ"
				),
				T(
					"Claims every free reward, including index",
					"รับรางวัลฟรีทุกอย่าง รวมสมุดสะสม"
				)
			)
			rewardBox:AddButton({
				Text = T("Claim Now", "รับเดี๋ยวนี้"),
				Style = "Success",
				Func = Action(Nullx11Forge.Claim.All),
			})
			Feature(
				rewardBox,
				"AutoCheckIn",
				T(
					"Auto 30-Day Check-In",
					"รับเช็กอิน 30 วันอัตโนมัติ"
				),
				T(
					"Claims every signed day that still has an unclaimed reward",
					"รับรางวัลทุกวันที่เช็กอินแล้วและยังไม่ได้รับ"
				)
			)
			rewardBox:AddButton({
				Text = T(
					"Claim Check-In Now",
					"รับรางวัลเช็กอินเดี๋ยวนี้"
				),
				Func = LongAction(
					"Check-In",
					Nullx11Forge.Claim.CheckIn,
					function(count)
						return ("Claimed %d check-in rewards"):format(
							count or 0
						)
					end
				),
			})
			rewardBox:AddButton({
				Text = T(
					"Redeem All Codes",
					"ใช้โค้ดทั้งหมด"
				),
				Style = "Primary",
				Func = Action(function()
					Notify(Nullx11Forge.Claim.AllCodes(), "Success", 6)
				end),
			})
		end

		local function BuildGear(tab)
			local formBox = tab:AddRightGroupbox(
				T("Dual Form", "อุปกรณ์สองร่าง")
			)
			formBox:AddLabel(
				T(
					"Switch equipped dual-form gear between A and B",
					"สลับ A/B ของอุปกรณ์สองร่างที่ใส่อยู่"
				)
			)
			for _, slot in ipairs(Config.GearTypes) do
				formBox:AddButton({
					Text = T(
						"Switch " .. slot .. " Form",
						"สลับร่าง " .. slot
					),
					Func = Action(function()
						local changed = Nullx11Forge.Gear.SwitchForm(slot)
						Notify(
							changed and "Form switched"
								or "Equip dual-form gear in this slot first",
							changed and "Success" or "Info"
						)
					end),
				})
			end

			local gearBox = tab:AddLeftGroupbox(
				T("Max Gear", "อุปกรณ์สูงสุด")
			)
			Feature(
				gearBox,
				"MaxGear",
				T("Max Gear", "อุปกรณ์สูงสุด"),
				T(
					"Best gear and runes, enhanced to your target. Finds anything missing by itself",
					"ของดีสุด รูนดีสุด ตีบวกถึงเป้า ขาดอะไรหาเองหมด"
				),
				function()
					State.GearForged = false
				end
			)
			Check(
				gearBox,
				"GearForge",
				T(
					"Forge gear automatically",
					"หลอมของอัตโนมัติ"
				)
			)
			Check(
				gearBox,
				"GearEnchant",
				T(
					"Equip runes automatically",
					"ใส่รูนอัตโนมัติ"
				)
			)
			Check(
				gearBox,
				"GearEnhance",
				T(
					"Enhance automatically",
					"ตีบวกอัตโนมัติ"
				)
			)
			gearBox:AddSlider("EnhanceTarget", {
				Text = T("Enhance Target", "ตีบวกถึง"),
				Description = T(
					"Above +10 the success rate gets very low and can take a long time",
					"เกิน +10 โอกาสสำเร็จต่ำมาก อาจใช้เวลานาน"
				),
				Min = 5,
				Max = 20,
				Default = opt.EnhanceTarget,
				Rounding = 0,
				Prefix = "+",
				Callback = function(value)
					opt.EnhanceTarget = value
				end,
			})
			local runes = Nullx11Forge.Gear.RuneOrder()
			opt.EnchantPriority = table.clone(runes)
			gearBox:AddDropdown("EnchantPriority", {
				Text = T("Runes To Use", "รูนที่ใช้"),
				Description = T(
					"Stronger runes go in first",
					"รูนที่แรงกว่าใส่ก่อน"
				),
				Values = runes,
				Multi = true,
				Default = runes,
				Searchable = #runes > 8,
				Callback = function(selected)
					local order = {}
					for _, stoneId in ipairs(runes) do
						if selected[stoneId] then
							order[#order + 1] = stoneId
						end
					end
					if #order == 0 then
						Notify("No rune selected, using all runes", "Warning")
					end
					opt.EnchantPriority = order
				end,
			})

			local equipBox =
				tab:AddRightGroupbox(T("Equip", "ใส่ของ"))
			Feature(
				equipBox,
				"AutoEquip",
				T("Auto Equip", "ใส่ของอัตโนมัติ"),
				T(
					"Always wears your strongest weapon, armor and hat, counting enhance level",
					"ใส่อาวุธ เกราะ และหมวกที่แรงที่สุดเสมอ นับระดับตีบวกด้วย"
				)
			)
			equipBox:AddButton({
				Text = T(
					"Equip Now",
					"ใส่ของเดี๋ยวนี้"
				),
				Func = function()
					task.defer(function()
						local changed = Nullx11Forge.Gear.EquipBest()
						Notify(
							changed > 0
									and ("Equipped %d better item(s)"):format(
										changed
									)
								or "Already wearing your best gear"
						)
					end)
				end,
			})

			equipBox:AddDivider()
			equipBox:AddDropdown("EnhanceSlot", {
				Text = T(
					"Enhance Slot",
					"ช่องที่ตีบวก"
				),
				Values = Config.GearTypes,
				Default = opt.EnhanceSlot,
				Callback = function(value)
					opt.EnhanceSlot = value or opt.EnhanceSlot
				end,
			})
			equipBox:AddButton({
				Text = T(
					"Enhance To Target",
					"ตีบวกถึงเป้า"
				),
				Style = "Primary",
				Func = LongAction("Enhance", function()
					return Nullx11Forge.Gear.EnhanceSlot(
						opt.EnhanceSlot,
						opt.EnhanceTarget
					)
				end, function(level)
					return level
							and ("%s is +%d"):format(opt.EnhanceSlot, level)
						or "Nothing equipped there"
				end),
			})
		end

		local function BuildFarm(tab)
			local stageBox = tab:AddLeftGroupbox(T("Stage", "ด่าน"))
			Pick(
				stageBox,
				"Stage",
				T("Stage", "ด่าน"),
				T(
					"Any stage, no unlock needed",
					"เลือกด่านไหนก็ได้ ไม่ต้องปลดล็อก"
				),
				Nullx11Forge.Stage.List
			)
			Feature(
				stageBox,
				"AutoBattle",
				T(
					"Auto Battle",
					"เข้าด่านและฆ่าอัตโนมัติ"
				),
				T(
					"Enters the selected stage and clears normal enemies and stage bosses",
					"เข้าด่านที่เลือกและฆ่ามอนสเตอร์กับบอสด่านทั้งหมด"
				)
			)
			Feature(
				stageBox,
				"CollectOre",
				T(
					"Auto Collect Ore",
					"เก็บแร่อัตโนมัติ"
				),
				T(
					"Clears the stage and collects its ores nonstop",
					"เคลียร์ด่านแล้วเก็บแร่ไม่หยุด"
				)
			)
			MultiSelect(
				stageBox,
				"CollectRarities",
				T("Ore Rarity Filter", "กรอง rarity แร่"),
				T(
					"Only collect these rarities",
					"เก็บเฉพาะ rarity ที่เลือก"
				),
				rarityNames
			)

			local combatBox = tab:AddLeftGroupbox(
				T("Combat", "ต่อสู้"),
				nil,
				"OP"
			)
			local killAura = Feature(
				combatBox,
				"KillAura",
				T("Kill Aura", "ฆ่ารอบตัว"),
				T(
					"Clears all enemies across the whole map instantly",
					"ฆ่าศัตรูทั้งแมพทันที ยิงทะลุกำแพง ไม่จำกัดระยะ"
				),
				function(value)
					if value then
						Nullx11Forge.Combat.Start()
					end
				end
			)
			NeedModule(killAura, ReplicatedStorage.Utils.CommunicationUtils)
			Check(
				combatBox,
				"AuraMapWide",
				T(
					"Map-Wide / Infinite Range",
					"โจมตีทั้งแมพ / ไม่จำกัดระยะ"
				)
			)
			combatBox:AddDropdown("AuraTarget", {
				Text = T(
					"Target Filter",
					"ประเภทเป้าหมาย"
				),
				Values = { "All", "Normal", "Super", "Boss" },
				Default = 1,
				Callback = function(value)
					opt.AuraTarget = value
				end,
			})
			NumberInput(
				combatBox,
				"AuraBatch",
				T(
					"Targets Per Sweep",
					"เป้าหมายต่อรอบ"
				),
				T(
					"Number of enemies processed per tick",
					"จำนวนศัตรูที่ประมวลผลต่อรอบ"
				),
				1
			)
			combatBox:AddSlider("AuraBurst", {
				Text = T(
					"Attack Burst (Hits/Tick)",
					"จำนวนฮิตต่อรอบ"
				),
				Min = 1,
				Max = 50,
				Default = opt.AuraBurst,
				Rounding = 0,
				Callback = function(value)
					opt.AuraBurst = tonumber(value) or 10
				end,
			})
			combatBox:AddSlider("AuraInterval", {
				Text = T(
					"Attack Interval",
					"ช่วงเวลาโจมตี"
				),
				Min = 0.05,
				Max = 1,
				Default = opt.AuraInterval,
				Rounding = 2,
				Suffix = " s",
				Callback = function(value)
					opt.AuraInterval =
						math.clamp(tonumber(value) or 0.12, 0.05, 1)
				end,
			})
			Check(
				combatBox,
				"AuraCritical",
				T("Critical Hits", "โจมตีคริติคอล")
			)
			Check(
				combatBox,
				"AutoCollectDrops",
				T(
					"Auto Collect Drops",
					"เก็บของดรอปอัตโนมัติ"
				)
			)
			Check(
				combatBox,
				"AuraSuper",
				T("Include Ore Bosses", "รวมบอสแร่")
			)
			Feature(
				combatBox,
				"SuperLootAura",
				T("Kill Ore Boss", "ฆ่าบอสแร่"),
				T(
					"Handles ore bosses instantly and collects confirmed drops",
					"จัดการบอสแร่ทันที และรับของที่ยืนยันแล้ว"
				),
				function(value)
					if value then
						Nullx11Forge.SuperLoot.KillExisting()
					else
						for _, uuid in ipairs(State.LootQueue) do
							State.LootSeen[uuid] = nil
						end
						table.clear(State.LootQueue)
					end
				end
			)
			combatBox:AddButton({
				Text = T(
					"Exit Fight Now",
					"ออกจากการต่อสู้เดี๋ยวนี้"
				),
				Style = "Warning",
				Func = Action(Nullx11Forge.Stage.ExitFight),
			})

			local bossBox =
				tab:AddRightGroupbox(T("World Boss", "บอสโลก"))
			Feature(
				bossBox,
				"AutoWorldBoss",
				T(
					"Auto World Boss",
					"บอสโลกอัตโนมัติ"
				),
				T(
					"Joins every world boss and kills it",
					"เข้าบอสโลกทุกรอบแล้วฆ่า"
				),
				function(value)
					if
						not value
						and LocalPlayer:GetAttribute("IntoFight")
							== "WorldBoss"
					then
						task.spawn(
							Nullx11Forge.Util.Try,
							Nullx11Forge.Boss.Leave
						)
					end
				end
			)
			Check(
				bossBox,
				"BossCards",
				T(
					"Auto Take Reward Card",
					"เปิดการ์ดรางวัลอัตโนมัติ"
				)
			)
			Feature(
				bossBox,
				"BossHop",
				T(
					"Boss Server Hop",
					"ย้ายเซิร์ฟหาบอส"
				),
				T(
					"Hops to servers where the boss is up or about to spawn, kills it, then moves on",
					"ย้ายไปเซิร์ฟที่บอสเกิดอยู่หรือใกล้เกิด ฆ่าแล้วย้ายต่อ"
				),
				function(value)
					Nullx11Forge.Boss.HopFlag(value)
					if
						value
						and Options.AutoWorldBoss
						and not Options.AutoWorldBoss.Value
					then
						Options.AutoWorldBoss:SetValue(true)
					end
				end
			)
			bossBox:AddSlider("BossWaitMinutes", {
				Text = T(
					"Wait If Boss Within",
					"รอถ้าบอสจะเกิดภายใน"
				),
				Description = T(
					"Stays on a server when the boss spawns this soon",
					"อยู่เซิร์ฟเดิมถ้าบอสจะเกิดภายในเวลานี้"
				),
				Min = 0.5,
				Max = 10,
				Default = opt.BossWaitMinutes,
				Rounding = 1,
				Suffix = " min",
				Callback = function(value)
					opt.BossWaitMinutes = tonumber(value) or opt.BossWaitMinutes
				end,
			})

			local indexBox =
				tab:AddRightGroupbox(T("Index", "สมุดสะสม"))
			MultiSelect(
				indexBox,
				"IndexTypes",
				T(
					"Index Types",
					"ประเภทที่จะเก็บ"
				),
				nil,
				Config.GearTypes
			)
			Pick(
				indexBox,
				"MissingItem",
				T("Missing Item", "ของที่ยังไม่มี"),
				T(
					"Chance shown is per forge with the best ore",
					"เปอร์เซ็นต์ = โอกาสต่อการหลอมหนึ่งครั้งด้วยแร่ที่ดีที่สุด"
				),
				function()
					return { "..." }
				end,
				true
			)
			task.defer(function()
				local ok, labels = pcall(Nullx11Forge.Index.Choices)
				if ok then
					Later(SetList, "MissingItem", labels, true)
				else
					warn("[Nullx11 Forge] index list:", labels)
				end
			end)
			indexBox
				:AddButton({
					Text = T("Get Selected", "หาชิ้นนี้"),
					Style = "Primary",
					Func = LongAction("Index", function()
						local gear = State.MissingLabels[opt.MissingItem]
						return gear and Nullx11Forge.Index.Hunt(gear)
					end, function(got)
						Later(
							SetList,
							"MissingItem",
							(Source(Nullx11Forge.Index.Choices))
						)
						return got and "Got it!"
							or "Not found this time, press again"
					end),
				})
				:AddButton(
					RefreshButton("MissingItem", Nullx11Forge.Index.Choices)
				)
			Feature(
				indexBox,
				"AutoIndex",
				T(
					"Auto Complete Index",
					"เก็บสมุดสะสมอัตโนมัติ"
				),
				T(
					"Forges every missing weapon, armor and hat, then claims rewards",
					"หลอมอาวุธ เกราะ หมวกที่ยังไม่มีทุกชิ้น แล้วรับรางวัล"
				),
				nil,
				true
			)
			indexBox
				:AddButton({
					Text = T(
						"Collect All Ores",
						"เก็บแร่ทุกชนิด"
					),
					Func = LongAction(
						"Ores",
						Nullx11Forge.Index.CollectOres,
						function()
							local count, level = Nullx11Forge.Index.Progress()
							return ("Index %d, level %d"):format(count, level)
						end
					),
				})
				:AddButton({
					Text = T("Claim Rewards", "รับรางวัล"),
					Style = "Success",
					Func = Action(Nullx11Forge.Index.ClaimAll),
				})
		end

		local function BuildForge(tab)
			local forgeBox = tab:AddLeftGroupbox(T("Forge", "หลอม"))
			local targetNames = {}
			for _, target in ipairs(Config.ForgeTargets) do
				targetNames[#targetNames + 1] = target.name
			end
			forgeBox:AddDropdown("ForgeTarget", {
				Text = T(
					"Target Gear",
					"อุปกรณ์ที่จะหลอม"
				),
				Values = targetNames,
				Default = 1,
				Callback = function(value)
					opt.ForgeTarget = value or opt.ForgeTarget
				end,
			})
			Pick(
				forgeBox,
				"ForgeOre",
				T("Ore To Use", "แร่ที่ใช้หลอม"),
				T(
					"Uses owned ore and farms missing stock",
					"ใช้แร่ที่มีและฟาร์มส่วนที่ขาด"
				),
				Nullx11Forge.Ore.ForgeChoices,
				nil
			)
			Decorate("ForgeOre", OreId)
			Feature(
				forgeBox,
				"AutoForge",
				T("Auto Forge", "หลอมอัตโนมัติ"),
				T(
					"Forges the target gear nonstop",
					"หลอมอุปกรณ์ที่เลือกไม่หยุด"
				)
			)
			forgeBox:AddButton({
				Text = T(
					"Forge Now",
					"หลอมเดี๋ยวนี้"
				),
				Style = "Primary",
				Func = Action(Nullx11Forge.Forge.Step),
			})
			forgeBox:AddSlider("ForgePerTick", {
				Text = T("Forges Per Round", "หลอมต่อรอบ"),
				Min = 1,
				Max = 50,
				Default = opt.ForgePerTick,
				Rounding = 0,
				Callback = function(value)
					opt.ForgePerTick = value
				end,
			})
			Check(
				forgeBox,
				"ForgeSellJunk",
				T(
					"Sell worse gear right away",
					"ขายของที่แย่กว่าที่ใส่ทันที"
				)
			)

			local oreUseBox = tab:AddRightGroupbox(
				T("Ore Usage", "การใช้แร่")
			)
			oreUseBox:AddLabel(
				T(
					"Used when Ore To Use is Owned ores",
					"ใช้ตอนแร่ที่ใช้หลอม = Owned ores"
				)
			)
			Toggle(
				oreUseBox,
				"BestOreFirst",
				T(
					"Spend High Tier Ore First",
					"ใช้แร่ระดับสูงก่อน"
				),
				T(
					"Off = spend the weakest ore first",
					"ปิด = ใช้แร่ที่อ่อนที่สุดก่อน"
				)
			)
			MultiSelect(
				oreUseBox,
				"ForgeRarities",
				T(
					"Forge Ore Rarity",
					"rarity แร่ที่ใช้หลอม"
				),
				T(
					"Only these ore rarities are used for forging",
					"ใช้แร่เฉพาะ rarity ที่เลือกในการหลอม"
				),
				rarityNames
			)
			NumberInput(
				oreUseBox,
				"KeepPerOre",
				T(
					"Keep Per Ore",
					"เก็บแร่ไว้ชนิดละ"
				),
				T(
					"Never forge below this amount of each ore",
					"ไม่หลอมจนแร่แต่ละชนิดต่ำกว่าจำนวนนี้"
				)
			)
		end

		local function BuildSell(tab)
			local sellBox = tab:AddLeftGroupbox(
				T("Auto Sell", "ขายอัตโนมัติ")
			)
			Feature(
				sellBox,
				"AutoSell",
				T("Auto Sell", "ขายอัตโนมัติ"),
				T(
					"Sells gear that matches your filters. Equipped gear is never sold",
					"ขายอุปกรณ์ที่ตรงตัวกรอง ของที่ใส่อยู่จะไม่ขาย"
				)
			)
			sellBox:AddButton({
				Text = T(
					"Sell All Now",
					"ขายทั้งหมดเดี๋ยวนี้"
				),
				Style = "Primary",
				Func = Action(function()
					Nullx11Forge.Sell.Run(Nullx11Forge.Data.Get())
					Notify("Sold", "Coin")
				end),
			})

			local filterBox =
				tab:AddRightGroupbox(T("Filters", "ตัวกรอง"))
			MultiSelect(
				filterBox,
				"SellTypes",
				T(
					"Sell Item Types",
					"ประเภทที่จะขาย"
				),
				nil,
				Config.GearTypes
			)
			MultiSelect(
				filterBox,
				"SellRarities",
				T(
					"Sell Rarity Filter",
					"กรอง rarity ที่จะขาย"
				),
				T(
					"Only sell these rarities",
					"ขายเฉพาะ rarity ที่เลือก"
				),
				rarityNames
			)
			NumberInput(
				filterBox,
				"KeepPerItem",
				T("Keep Per Item", "เก็บไว้ชิ้นละ"),
				T(
					"Keeps this many of each item, highest enhance first",
					"เก็บแต่ละไอเทมไว้ตามจำนวนนี้ เลือกตัวตีบวกสูงสุดก่อน"
				)
			)
		end

		local function BuildProgress(tab)
			local trainBox = tab:AddLeftGroupbox(T("Training", "ฝึก"))
			Feature(
				trainBox,
				"AutoTrain",
				T("Auto Train", "ฝึกอัตโนมัติ"),
				T(
					"Trains at the best area nonstop and drinks your potions",
					"ฝึกโซนดีสุดไม่หยุด ใช้ยาให้เอง"
				),
				function(value)
					task.spawn(
						Nullx11Forge.Util.Try,
						Nullx11Forge.Level.SetTraining,
						value
					)
				end
			)
			local autoClick = Feature(
				trainBox,
				"AutoClick",
				T("Auto Click", "คลิกอัตโนมัติ"),
				T(
					"Clicks to train as fast as the game allows",
					"คลิกฝึกเร็วสุดเท่าที่เกมยอม"
				),
				function(value)
					if value then
						Nullx11Forge.Level.StartClicking()
					end
				end
			)
			NeedModule(autoClick, ReplicatedStorage.CTRL.TrainCTRL)
			Feature(
				trainBox,
				"AutoRebirth",
				T(
					"Auto Rebirth",
					"รีเบิร์ธอัตโนมัติ"
				),
				T(
					"Rebirths as soon as your level is high enough",
					"รีเบิร์ธทันทีเมื่อเลเวลถึง"
				)
			)
			trainBox:AddButton({
				Text = T(
					"Rebirth Now",
					"รีเบิร์ธเดี๋ยวนี้"
				),
				Func = Action(Nullx11Forge.Level.Rebirth),
			})

			local upgradeBox =
				tab:AddRightGroupbox(T("Upgrades", "อัปเกรด"))
			MultiSelect(
				upgradeBox,
				"Upgrades",
				T(
					"Upgrades To Buy",
					"อัปเกรดที่จะซื้อ"
				),
				nil,
				(Source(Nullx11Forge.Upgrade.Names))
			)
			Feature(
				upgradeBox,
				"AutoUpgrade",
				T(
					"Auto Buy Upgrades",
					"ซื้ออัปเกรดอัตโนมัติ"
				),
				T(
					"Buys the selected upgrades whenever possible",
					"ซื้ออัปเกรดที่เลือกทุกครั้งที่ซื้อได้"
				)
			)
			upgradeBox:AddButton({
				Text = T(
					"Buy Upgrade Now",
					"ซื้ออัปเกรดเดี๋ยวนี้"
				),
				Func = Action(Nullx11Forge.Upgrade.BuySelected),
			})
		end

		local function BuildTower(tab)
			local towerBox = tab:AddLeftGroupbox(T("Tower", "หอคอย"))
			Feature(
				towerBox,
				"AutoTower",
				T(
					"Auto Farm Tower",
					"ฟาร์มหอคอยอัตโนมัติ"
				),
				T(
					"Top floor loot nonstop on one ticket: rare stones and season coins",
					"ของชั้นบนสุดไม่หยุดด้วยตั๋วใบเดียว ได้หินหายากและเหรียญซีซั่น"
				),
				function(value)
					task.defer(function()
						if not value then
							return Nullx11Forge.Util.Try(
								Nullx11Forge.Tower.Exit
							)
						end
						if not Nullx11Forge.Tower.Enter() then
							Notify("No tower ticket", "Warning")
						end
					end)
				end
			)
			towerBox:AddButton({
				Text = T(
					"Exit Tower Now",
					"ออกจากหอคอยเดี๋ยวนี้"
				),
				Style = "Warning",
				Func = function()
					Options.AutoTower:SetValue(false)
					task.spawn(Nullx11Forge.Util.Try, Nullx11Forge.Tower.Exit)
				end,
			})

			local seasonBox =
				tab:AddRightGroupbox(T("Season", "ซีซั่น"))
			local goodLabels, goodIds = Source(Nullx11Forge.Season.Goods)
			local goodDefault = {}
			for label, goodId in pairs(goodIds) do
				if opt.SeasonGoods[goodId] then
					table.insert(goodDefault, label)
				end
			end
			Feature(
				seasonBox,
				"AutoSeason",
				T(
					"Auto Season",
					"ซีซั่นอัตโนมัติ"
				),
				T(
					"Daily ticket, pass rewards, spins and shop",
					"ตั๋วรายวัน รางวัลพาส สุ่ม และร้าน"
				)
			)
			seasonBox:AddButton({
				Text = T(
					"Season Now",
					"ซีซั่นเดี๋ยวนี้"
				),
				Func = Action(Nullx11Forge.Season.Step),
			})
			Check(
				seasonBox,
				"SeasonSpin",
				T(
					"Auto Spin Tickets",
					"สุ่มตั๋วอัตโนมัติ"
				)
			)
			NumberInput(
				seasonBox,
				"SeasonSpinBatch",
				T("Spins Per Cycle", "สุ่มต่อรอบ"),
				T(
					"1–50; remaining tickets continue next cycle",
					"1–50 ตั๋วที่เหลือสุ่มรอบถัดไป"
				),
				1
			)
			seasonBox:AddDropdown("SeasonGoods", {
				Text = T(
					"Shop Items To Buy",
					"ของในร้านที่จะซื้อ"
				),
				Values = goodLabels,
				Multi = true,
				Default = goodDefault,
				Searchable = #goodLabels > 8,
				Callback = function(selected)
					local wanted = {}
					for label, on in pairs(selected) do
						if on and goodIds[label] then
							wanted[goodIds[label]] = true
						end
					end
					opt.SeasonGoods = wanted
				end,
			})
		end

		local function BuildSpawn(tab)
			local spawnBox = tab:AddLeftGroupbox(
				T(
					"Ore & Loot Spawner",
					"เสกแร่และไอเทม"
				),
				nil,
				"OP"
			)
			Feature(
				spawnBox,
				"TurboSpawn",
				T(
					"Continuous Insane Turbo Spawner",
					"เสกของรัวแบบไม่จำกัดต่อเนื่อง"
				),
				T(
					"Continuously streams selected or top tier loot directly into your backpack",
					"ฟาร์มเสกไอเทมที่เลือกหรือไอเทมระดับเทพเข้ากระเป๋าต่อเนื่องแบบไม่หยุด"
				)
			)
			Pick(
				spawnBox,
				"SpawnItem",
				T(
					"Ore / Item / Pet",
					"แร่ / ไอเทม / สัตว์เลี้ยง"
				),
				T(
					"Every ore, egg, fruit, rune and pet; farmed into inventory",
					"แร่ ไข่ ผลไม้ รูน และสัตว์เลี้ยงทั้งหมด ดึงเข้ากระเป๋าทันที"
				),
				Nullx11Forge.Spawn.Choices,
				true
			)
			Decorate("SpawnItem", function(label)
				local entry = State.SpawnLabels[label]
				return entry and entry.id
			end)
			NumberInput(
				spawnBox,
				"SpawnAmount",
				T("Amount", "จำนวน"),
				T(
					"Target amount to acquire (up to 1,000,000)",
					"จำนวนที่ต้องการได้ (สูงสุด 1,000,000)"
				),
				1
			)
			spawnBox
				:AddButton({
					Text = T(
						"Spawn Selected Item (Turbo)",
						"เสกไอเทมที่เลือก (เทอร์โบ)"
					),
					Style = "Primary",
					Func = Action(function()
						local picked = State.SpawnLabels[opt.SpawnItem]
						if not picked then
							return Notify("Pick an item first", "Warning")
						end
						local acquired, outcome, reason =
							Nullx11Forge.Spawn.Give(
								picked.id,
								picked.kind,
								opt.SpawnAmount
							)
						Notify(
							acquired
									and ("Obtained %s"):format(
										Nullx11Forge.Util.Abbreviate(outcome)
									)
								or (reason or "Done"),
							acquired and "Success" or "Warning"
						)
					end),
				})
				:AddButton(
					RefreshButton("SpawnItem", Nullx11Forge.Spawn.Choices)
				)

			spawnBox:AddButton({
				Text = T(
					"INSANE Farm Tier 40-48 God Ores",
					"เสกแร่เทพ Tier 40-48 แบบรัวคลั่ง"
				),
				Style = "Success",
				Func = LongAction("Max Ores", function()
					return Nullx11Forge.Stage.FarmMaxOres(50)
				end, function(count)
					return ("Acquired %d god tier ores directly!"):format(
						count or 0
					)
				end),
			})

			spawnBox:AddButton({
				Text = T(
					"INSANE Farm Pet Eggs & Fruits (Burst)",
					"เสกไข่สัตว์เลี้ยงและผลไม้แบบรัวคลั่ง"
				),
				Style = "Success",
				Func = LongAction("Eggs & Fruits", function()
					local eggs, foods = Nullx11Forge.Stage.FarmEggsAndFood(50)
					return { eggs = eggs, foods = foods }
				end, function(res)
					if type(res) ~= "table" then
						return "No drops"
					end
					return ("+%d eggs · +%d fruits"):format(
						res.eggs or 0,
						res.foods or 0
					)
				end),
			})

			spawnBox:AddButton({
				Text = T(
					"INSANE Farm Enhance Stones",
					"เสกหินตีบวกทั้งหมดแบบรัวคลั่ง"
				),
				Style = "Primary",
				Func = LongAction("Stones", function()
					local before = Nullx11Forge.Data.Count(
						Nullx11Forge.Data.Get(),
						"EnhantStone_1"
					)
					Nullx11Forge.Stage.FarmStones(Nullx11Forge.Stage.Best())
					task.wait(0.3)
					return Nullx11Forge.Data.Count(
						Nullx11Forge.Data.Get(true),
						"EnhantStone_1"
					) - before
				end, function(gained)
					return ("+%d enhance stones"):format(gained or 0)
				end),
			})

			spawnBox:AddButton({
				Text = T(
					"INSANE Stream All Drops (Burst)",
					"เสกและดึงดรอปทุกชนิดเข้ากระเป๋าแบบรัว"
				),
				Style = "Success",
				Func = LongAction("Stream Drops", function()
					local eggs, foods = Nullx11Forge.Stage.FarmEggsAndFood(50)
					local ores = Nullx11Forge.Stage.FarmMaxOres(50)
					return { eggs = eggs, foods = foods, ores = ores }
				end, function(res)
					return ("+%d god ores · +%d eggs · +%d fruits"):format(
						res.ores or 0,
						res.eggs or 0,
						res.foods or 0
					)
				end),
			})

			local coinBox = tab:AddRightGroupbox(
				T(
					"Season Coins & Tower",
					"เหรียญซีซั่นและหอคอย"
				),
				nil,
				"OP"
			)
			NumberInput(
				coinBox,
				"CoinTarget",
				T(
					"Coins Target",
					"จำนวนเหรียญเป้าหมาย"
				),
				nil,
				100
			)
			coinBox:AddButton({
				Text = T(
					"Farm 50,000 Season Coins",
					"ฟาร์ม 50,000 เหรียญซีซั่นทันที"
				),
				Style = "Primary",
				Func = LongAction("Tower Coins", function()
					return Nullx11Forge.Tower.FarmCoins(opt.CoinTarget or 50000)
				end, function(gained)
					return ("+%s season coins"):format(
						Nullx11Forge.Util.Abbreviate(gained or 0)
					)
				end),
			})

			coinBox:AddButton({
				Text = T(
					"Farm Rare Enhance Stones (Tier 2)",
					"ฟาร์มหินตีบวกหายาก (Tier 2)"
				),
				Func = LongAction("Tower Stones", function()
					local before = Nullx11Forge.Data.Count(
						Nullx11Forge.Data.Get(),
						"EnhantStone_2"
					)
					Nullx11Forge.Tower.FarmStep()
					task.wait(0.3)
					return Nullx11Forge.Data.Count(
						Nullx11Forge.Data.Get(true),
						"EnhantStone_2"
					) - before
				end, function(gained)
					return ("+%d rare stones"):format(gained or 0)
				end),
			})

			local potionBox =
				tab:AddRightGroupbox(T("Potions", "ยา"), nil, "OP")
			NumberInput(
				potionBox,
				"PotionAmount",
				T("Potion Amount", "จำนวนยา"),
				T(
					"Amount to consume for extending active buffs",
					"จำนวนยาที่จะใช้เพื่อต่อเวลาบัฟ"
				),
				1
			)
			potionBox:AddButton({
				Text = T(
					"Extend All Buff Times",
					"เพิ่มเวลาบัฟยาทุกชนิด"
				),
				Style = "Primary",
				Func = LongAction("Potion Time", function()
					return Nullx11Forge.Potion.Extend(opt.PotionAmount)
				end, function(changed)
					return ("Extended %d potion buffs"):format(changed or 0)
				end),
			})

			local gearBox = tab:AddLeftGroupbox(
				T(
					"Target Gear",
					"หลอมอาวุธและชุดเป้าหมาย"
				),
				nil,
				"OP"
			)
			local function LoadGearList(slot)
				task.defer(function()
					local ok, labels =
						pcall(Nullx11Forge.Spawn.GearChoices, slot)
					if ok then
						Later(SetList, "SpawnGear", labels, true)
						Later(Decorate, "SpawnGear", function(label)
							local gear = State.GearLabels
								and State.GearLabels[label]
							return gear and gear.id
						end)
					else
						warn("[Nullx11 Forge] gear list:", labels)
					end
				end)
			end
			opt.GearSlot = Config.GearTypes[1]
			gearBox:AddDropdown("GearSlot", {
				Text = T("Type", "ประเภท"),
				Values = Config.GearTypes,
				Default = 1,
				NoSave = true,
				Callback = function(value)
					opt.GearSlot = value
					LoadGearList(value)
				end,
			})
			opt.SpawnGear = nil
			gearBox:AddDropdown("SpawnGear", {
				Text = T("Gear", "อุปกรณ์"),
				Description = T(
					"Strongest first. Exclusive gear is shop only",
					"แรงสุดอยู่บน ของ Exclusive มีแค่ในร้าน"
				),
				Values = { "..." },
				Default = 1,
				Searchable = true,
				NoSave = true,
				Callback = function(value)
					opt.SpawnGear = value
				end,
			})
			LoadGearList(opt.GearSlot)
			NumberInput(
				gearBox,
				"GearCopies",
				T("Copies", "จำนวนชิ้น"),
				nil,
				1
			)
			gearBox:AddButton({
				Text = T(
					"Forge Target Gear",
					"หลอมอุปกรณ์เป้าหมาย"
				),
				Style = "Primary",
				Func = LongAction("Index", function()
					local gear = State.GearLabels[opt.SpawnGear]
					return gear
						and Nullx11Forge.Index.Hunt(
							gear,
							math.max(1, math.floor(opt.GearCopies))
						)
				end, function(got)
					return got and "Target forged!"
						or "Not all copies this time, press again"
				end),
			})
			gearBox:AddButton({
				Text = T(
					"Forge Set",
					"หลอมเซ็ตอุปกรณ์"
				),
				Func = LongAction(
					"Index",
					Nullx11Forge.Spawn.BestSet,
					function(made)
						return ("Forged and equipped %d/3 pieces"):format(
							made or 0
						)
					end
				),
			})
			gearBox:AddButton({
				Text = T(
					"1-Click Forge & Max Full God Set",
					"หลอมและอัปเกรดเซ็ตเทพเต็มสูบ 1-คลิก"
				),
				Style = "Success",
				Func = LongAction(
					"God Set",
					Nullx11Forge.Spawn.FullGodSet,
					function(made)
						return ("Forged, equipped, enhanced +20, and enchanted %d god pieces!"):format(
							made or 0
						)
					end
				),
			})
			gearBox:AddButton({
				Text = T(
					"Buy Exclusive Gear",
					"ซื้อของ Exclusive"
				),
				Func = LongAction(
					"Tower",
					Nullx11Forge.Season.BuyExclusive,
					function(bought)
						return (bought or 0) > 0
								and ("Bought %d exclusive pieces"):format(
									bought
								)
							or "Already bought this refresh"
					end
				),
			})

			local tokenBox = tab:AddRightGroupbox(
				T("Token Shop", "ร้าน Token"),
				nil,
				"OP"
			)
			Feature(
				tokenBox,
				"AutoTokenShop",
				T(
					"Auto Mystery Shop",
					"ร้านลึกลับอัตโนมัติ"
				),
				T(
					"Reveals cards and buys selected goods using owned tokens",
					"เปิดการ์ดและซื้อของที่เลือกด้วย Token ที่มี"
				)
			)
			Check(
				tokenBox,
				"TokenReveal",
				T(
					"Auto Reveal Cards",
					"เปิดการ์ดอัตโนมัติ"
				)
			)
			Check(
				tokenBox,
				"TokenSkipOwned",
				T(
					"Skip Owned Goods",
					"ข้ามของที่มีแล้ว"
				)
			)
			local tokenLabels, tokenIds = Source(Nullx11Forge.TokenShop.Choices)
			tokenBox:AddDropdown("TokenTargets", {
				Text = T(
					"Buy These Goods (Empty = All)",
					"ของที่จะซื้อ (ว่าง = ทั้งหมด)"
				),
				Values = tokenLabels,
				Multi = true,
				Default = {},
				Searchable = true,
				Callback = function(selected)
					local ids = {}
					for label, on in pairs(selected) do
						if on and tokenIds[label] then
							ids[tokenIds[label]] = true
						end
					end
					opt.TokenTargets = ids
				end,
			})
			tokenBox:AddButton({
				Text = T(
					"Buy All Now",
					"ซื้อทั้งหมดเดี๋ยวนี้"
				),
				Func = LongAction(
					"Token Shop",
					Nullx11Forge.TokenShop.BuyAll,
					function(bought)
						return (bought or 0) > 0
								and ("Bought %d items"):format(bought)
							or "No purchase: check tokens, ownership and selected goods"
					end
				),
			})
		end

		local function BuildPet(tab)
			local hatchBox = tab:AddLeftGroupbox(
				T(
					"Egg Hatchery & Farm",
					"ฟักไข่และฟาร์มไข่"
				),
				nil,
				"OP"
			)
			Feature(
				hatchBox,
				"AutoHatchEgg",
				T(
					"Auto Hatch When Ready",
					"เปิดไข่อัตโนมัติเมื่อครบเวลา"
				),
				T(
					"Watches incubator and opens ready eggs the exact second timer hits 0, then incubates next",
					"ตรวจตู้ฟักตลอดเวลาและเปิดไข่ทันทีที่เวลาครบ 0 วิ แล้วใส่ฟองใหม่ต่อเนื่อง"
				)
			)
			Check(
				hatchBox,
				"HatchBestFirst",
				T(
					"Hatch Rare Eggs First",
					"ฟักไข่หายากก่อน (Egg2 > Egg1)"
				)
			)
			Toggle(
				hatchBox,
				"SkipEggAnim",
				T(
					"Skip Egg Cutscene",
					"ข้ามฉากเปิดไข่"
				),
				T(
					"Hides the egg opening cutscene so farming never pauses",
					"ปิดฉากแอนิเมชันเปิดไข่เพื่อไม่ให้ขัดจังหวะฟาร์ม"
				),
				function(value)
					Nullx11Forge.Util.Try(Nullx11Forge.Pet.MuteAnim, value)
				end
			)
			hatchBox:AddButton({
				Text = T(
					"Open Ready Eggs Now",
					"เปิดไข่ที่พร้อมเดี๋ยวนี้"
				),
				Style = "Primary",
				Func = Action(function()
					local opened, hatched = Nullx11Forge.Pet.HatchStep()
					Notify(
						opened > 0 and ("Opened %d ready eggs!"):format(opened)
							or "No eggs ready yet (timer still counting down)",
						opened > 0 and "Success" or "Info"
					)
				end),
			})
			hatchBox:AddButton({
				Text = T(
					"Farm & Fill Crown Eggs (Egg2)",
					"ฟาร์มและเติมไข่ Egg2 เต็มตู้"
				),
				Style = "Success",
				Func = LongAction("Egg2 Farm", function()
					Nullx11Forge.Pet.TrimEggs("Egg2")
					Nullx11Forge.Stage.FarmTurbo("Egg2", "Egg", 15)
					local opened, hatched = Nullx11Forge.Pet.HatchStep()
					return hatched
				end, function(hatched)
					return ("Incubated %d new eggs!"):format(hatched or 0)
				end),
			})
			hatchBox:AddButton({
				Text = T(
					"Refill 20 Eggs & Fruits Burst",
					"เติมไข่และผลไม้ 20 ชิ้น (เต็มกระเป๋า)"
				),
				Style = "Primary",
				Func = LongAction("Pet Farm", function()
					local eggs, foods = Nullx11Forge.Stage.FarmEggsAndFood(20)
					return { eggs = eggs, foods = foods }
				end, function(res)
					if type(res) ~= "table" then
						return "No drops"
					end
					return ("+%d eggs · +%d fruits"):format(
						res.eggs or 0,
						res.foods or 0
					)
				end),
			})

			local cleanBox = tab:AddLeftGroupbox(
				T(
					"Pet Bag Cleanup",
					"จัดการกระเป๋าสัตว์เลี้ยง"
				)
			)
			Feature(
				cleanBox,
				"AutoSellPet",
				T(
					"Auto Clean Pet & Egg Bag",
					"เคลียร์กระเป๋าสัตว์เลี้ยงและไข่อัตโนมัติ"
				),
				T(
					"Deletes low-rarity pets while protecting equipped and top pets",
					"ลบสัตว์เลี้ยงระดับต่ำโดยล็อกตัวที่ใส่และตัวเก่งสุดไว้"
				)
			)
			local defaultDelete = { "Common", "Uncommon", "Rare", "Epic" }
			opt.DeletePetRarities = Nullx11Forge.Util.AllSet(defaultDelete)
			cleanBox:AddDropdown("DeletePetRarities", {
				Text = T(
					"Delete Pet Rarities",
					"ลบสัตว์เลี้ยงระดับ"
				),
				Description = T(
					"Only delete unequipped pets of these rarities",
					"ลบเฉพาะสัตว์เลี้ยงที่ไม่ได้ใส่ในระดับที่เลือก"
				),
				Values = rarityNames,
				Multi = true,
				Default = defaultDelete,
				Callback = function(selected)
					opt.DeletePetRarities = selected
				end,
			})
			NumberInput(
				cleanBox,
				"KeepBestPets",
				T(
					"Keep Top Pets",
					"เก็บสัตว์เลี้ยงตัวหลักไว้"
				),
				T(
					"Always keeps at least this many highest-scoring pets",
					"เก็บสัตว์เลี้ยงที่คะแนนสูงสุดไว้อย่างน้อยจำนวนนี้"
				),
				1
			)
			Check(
				cleanBox,
				"AutoDeleteEggs",
				T(
					"Trim Excess Unhatched Eggs",
					"ลบไข่ส่วนเกินอัตโนมัติ"
				)
			)
			NumberInput(
				cleanBox,
				"KeepPerEgg",
				T(
					"Keep Per Egg Type",
					"เก็บไข่ไว้ชนิดละ"
				),
				T(
					"Deletes unhatched eggs above this count per type",
					"ลบไข่ที่ยังไม่ได้ฟักที่เกินจำนวนนี้ต่อชนิด"
				),
				1
			)
			cleanBox:AddButton({
				Text = T(
					"Clean Pet & Egg Bag Now",
					"เคลียร์กระเป๋าเดี๋ยวนี้"
				),
				Func = Action(function()
					local delPets, delEggs = Nullx11Forge.Pet.CleanBag()
					Notify(
						("Removed %d pets · %d eggs"):format(
							delPets or 0,
							delEggs or 0
						),
						"Info"
					)
				end),
			})

			local petBox = tab:AddRightGroupbox(
				T(
					"Pet Loadout & Feeding",
					"ใส่สัตว์เลี้ยงและให้อาหาร"
				),
				nil,
				"OP"
			)
			Feature(
				petBox,
				"AutoEquipPet",
				T(
					"Auto Equip Pets",
					"ใส่สัตว์เลี้ยงอัตโนมัติ"
				),
				T(
					"Always equips your highest-scoring pets for maximum stat boosts",
					"ใส่สัตว์เลี้ยงที่คะแนนสูงสุดเสมอเพื่อรับบัฟสูงสุด"
				)
			)
			petBox:AddButton({
				Text = T(
					"Equip Best Pets Now",
					"ใส่สัตว์เลี้ยงเทพเดี๋ยวนี้"
				),
				Style = "Primary",
				Func = Action(function()
					local changed = Nullx11Forge.Pet.EquipBest()
					Notify(
						changed > 0 and ("Equipped %d pet(s)"):format(changed)
							or "Already equipping top pet(s)",
						"Info"
					)
				end),
			})
			petBox:AddDivider()
			Feature(
				petBox,
				"AutoFeedPet",
				T(
					"Auto Feed Fruits",
					"ให้อาหารผลไม้อัตโนมัติ"
				),
				T(
					"Feeds owned fruits to your top pets until they reach max level",
					"ป้อนผลไม้ที่มีให้สัตว์เลี้ยงตัวหลักจนเลเวลตัน"
				)
			)
			petBox:AddButton({
				Text = T(
					"Feed Pet Once",
					"ป้อนผลไม้หนึ่งครั้ง"
				),
				Func = Action(function()
					local fed = Nullx11Forge.Pet.FeedBest()
					Notify(
						fed > 0 and "Fed highest-priority pet!"
							or "No pet needs EXP or no fruit owned",
						fed > 0 and "Success" or "Info"
					)
				end),
			})
			petBox:AddButton({
				Text = T(
					"Feed All Pets to Max Level Now",
					"ป้อนผลไม้ให้อิ่มจนเวลตันทุกตัวทันที"
				),
				Style = "Success",
				Func = Action(function()
					local totalFed = Nullx11Forge.Pet.FeedAllMax()
					Notify(
						totalFed > 0
								and ("Fed pets %d times to max level!"):format(
									totalFed
								)
							or "Pets already max level or out of fruits",
						totalFed > 0 and "Success" or "Info"
					)
				end),
			})

			local deployBox = tab:AddRightGroupbox(
				T(
					"Pet Expedition",
					"ส่งสัตว์เลี้ยงสำรวจ"
				)
			)
			Feature(
				deployBox,
				"AutoDeployPet",
				T(
					"Auto Deploy & Claim Rewards",
					"ส่งสำรวจและรับรางวัลอัตโนมัติ"
				),
				T(
					"Deploys best available pets on expeditions and claims all loot",
					"ส่งสัตว์เลี้ยงสำรวจและรับของรางวัลทั้งหมดอัตโนมัติ"
				)
			)
			deployBox:AddButton({
				Text = T(
					"Deploy & Claim Now",
					"ส่งสำรวจและรับรางวัลเดี๋ยวนี้"
				),
				Style = "Success",
				Func = Action(function()
					context.Send(
						Nullx11Forge.Util.Remote(
							"Pet",
							"ClaimAllDeployRewardRE"
						),
						"FireServer"
					)
					local deployed = Nullx11Forge.Pet.DeployStep()
					Notify(
						("Claimed rewards · Deployed %d pet(s)"):format(
							deployed or 0
						),
						"Success"
					)
				end),
			})

			local targetBox = tab:AddRightGroupbox(
				T(
					"Target Pet Hunt & Auto-Hatch",
					"ล่าสัตว์เลี้ยงตามสั่ง"
				),
				nil,
				"OP"
			)
			Pick(
				targetBox,
				"TargetPet",
				T(
					"Target Pet",
					"สัตว์เลี้ยงที่ต้องการ"
				),
				T(
					"Select any pet to hunt: farms its parent egg and auto-hatches",
					"เลือกสัตว์เลี้ยงตัวที่ต้องการ ระบบจะฟาร์มไข่ตรงใบและฟักเมื่อครบเวลา"
				),
				Nullx11Forge.Pet.Choices,
				true
			)
			Decorate("TargetPet", function(label)
				return State.PetTargetLabels and State.PetTargetLabels[label]
			end)
			NumberInput(
				targetBox,
				"TargetPetCopies",
				T(
					"Target Copies",
					"จำนวนที่ต้องการได้"
				),
				T(
					"Number of target pets to acquire",
					"จำนวนตัวที่ต้องการเสกล่า"
				),
				1
			)
			Feature(
				targetBox,
				"AutoChaseTargetPet",
				T(
					"Auto Chase Target Pet",
					"ล่าสัตว์เลี้ยงตัวนี้อัตโนมัติ"
				),
				T(
					"Automatically farms required eggs, incubates, opens on 0s, max-feeds, and locks",
					"ฟาร์มไข่ตรงใบ ใส่ตู้ฟัก เปิดทันทีที่ครบเวลา อัปเวลตันและล็อคตัวอัตโนมัติ"
				)
			)
			Check(
				targetBox,
				"AutoLockTargetPet",
				T(
					"Auto Lock Target Pet",
					"ล็อคสัตว์เลี้ยงที่ได้อัตโนมัติ"
				)
			)
			targetBox
				:AddButton({
					Text = T(
						"Farm & Incubate Target Egg Now",
						"ฟาร์มและใส่ไข่เป้าหมายเข้าตู้เดี๋ยวนี้"
					),
					Style = "Primary",
					Func = LongAction("Pet Hunt", function()
						local picked = State.PetTargetLabels
							and State.PetTargetLabels[opt.TargetPet]
						if not picked then
							return nil
						end
						local gained, msg = Nullx11Forge.Pet.FarmAndHatchTarget(
							picked,
							opt.TargetPetCopies or 1
						)
						return msg
							or (
								gained > 0
									and ("Acquired %d!"):format(gained)
								or "Incubating"
							)
					end, function(msg)
						return tostring(msg or "Done")
					end),
				})
				:AddButton(RefreshButton("TargetPet", Nullx11Forge.Pet.Choices))
			targetBox:AddButton({
				Text = T(
					"Lock All High-Tier Pets",
					"ล็อคสัตว์เลี้ยงระดับแรร์ทั้งหมด"
				),
				Style = "Success",
				Func = Action(function()
					local locked = Nullx11Forge.Pet.LockAllGodPets()
					Notify(
						("Locked %d high-tier pets"):format(locked or 0),
						"Success"
					)
				end),
			})
		end

		local function BuildPlayer(tab)
			local raceBox = tab:AddLeftGroupbox(T("Race", "เผ่า"))
			local raceLabels, raceIds = Source(Nullx11Forge.Race.Choices)
			raceBox:AddDropdown("RaceTargets", {
				Text = T(
					"Target Races",
					"เผ่าที่ต้องการ"
				),
				Values = raceLabels,
				Multi = true,
				Default = {},
				Searchable = #raceLabels > 8,
				Callback = function(selected)
					local ids = {}
					for label, on in pairs(selected) do
						if on and raceIds[label] then
							ids[raceIds[label]] = true
						end
					end
					opt.RaceTargets = ids
				end,
			})
			Decorate("RaceTargets", function(label)
				return raceIds[label]
			end)
			local rarityLabels, rarityLevels =
				Source(Nullx11Forge.Race.RarityChoices)
			raceBox:AddDropdown("RaceMinRarity", {
				Text = T(
					"Or Any Race Of",
					"หรือเผ่าระดับ"
				),
				Values = rarityLabels,
				Default = 1,
				Callback = function(value)
					opt.RaceMinLevel = rarityLevels[value]
				end,
			})
			local starByLabel =
				{ ["Any"] = 0, ["2 Stars+"] = 2, ["3 Stars"] = 3 }
			raceBox:AddDropdown("RaceStar", {
				Text = T(
					"Target Stars",
					"ดาวที่ต้องการ"
				),
				Values = { "Any", "2 Stars+", "3 Stars" },
				Default = 1,
				Callback = function(value)
					opt.RaceStar = starByLabel[value] or 0
				end,
			})
			raceBox:AddDropdown("RaceSlot", {
				Text = T("Roll Slot", "ช่องที่สุ่ม"),
				Values = Config.RaceSlots,
				Default = 1,
				Callback = function(value)
					opt.RaceSlot = value
				end,
			})
			Feature(
				raceBox,
				"AutoRace",
				T(
					"Auto Roll Race",
					"สุ่มเผ่าอัตโนมัติ"
				),
				T(
					"Rolls in the background until a chosen race shows up",
					"สุ่มเบื้องหลังจนกว่าจะได้เผ่าที่เลือก"
				),
				function(value)
					if not value or State.Rolling then
						return
					end
					if not next(opt.RaceTargets) and not opt.RaceMinLevel then
						Notify("Pick a target race first", "Warning")
						return Later(TurnOff, "AutoRace")
					end
					State.Rolling = true
					task.defer(function()
						if not opt.RaceAnim then
							Nullx11Forge.Util.Try(
								Nullx11Forge.Race.MuteAnim,
								true
							)
						end
						local ok, outcome, detail =
							pcall(Nullx11Forge.Race.RollUntil)
						Nullx11Forge.Util.Try(Nullx11Forge.Race.MuteAnim, false)
						State.Rolling = false
						local used = State.RaceRolls or 0
						if not ok then
							warn("[Nullx11 Forge] race roll:", outcome)
						elseif outcome == "got" then
							Notify(
								("Got %s after %d rolls!"):format(
									tostring(detail),
									used
								),
								"Success",
								8
							)
						elseif outcome == "empty" then
							Notify(
								"Out of race rolls. Enable Buy Rolls When Empty or collect season rewards",
								"Warning"
							)
						elseif outcome == "blocked" then
							Notify(
								"Can't roll: " .. tostring(detail),
								"Warning"
							)
						end
						Later(TurnOff, "AutoRace")
					end)
				end
			)
			Check(
				raceBox,
				"RaceBuyRolls",
				T(
					"Buy Rolls When Empty",
					"ซื้อ roll เมื่อหมด"
				)
			)
			Check(
				raceBox,
				"RaceLock",
				T(
					"Lock Slot When Found",
					"ได้แล้วล็อกช่อง"
				)
			)
			Check(
				raceBox,
				"RaceProtect",
				T(
					"Never Replace Mythic+",
					"ไม่สุ่มทับเผ่า Mythic ขึ้นไป"
				)
			)
			Check(
				raceBox,
				"RaceAnim",
				T("Show Roll Animation", "แสดงฉากสุ่ม")
			)
			Feature(
				raceBox,
				"AutoBestRace",
				T(
					"Auto Equip Rare Race",
					"ใส่อัตโนมัติตามความหายาก"
				),
				T(
					"Switches to your rarest race",
					"สลับไปใช้เผ่าที่หายากที่สุด"
				)
			)
			raceBox:AddButton({
				Text = T(
					"Switch Now",
					"สลับเดี๋ยวนี้"
				),
				Func = Action(function()
					Notify(
						Nullx11Forge.Race.EquipBest() and "Switched race slot"
							or "Already on your rarest race"
					)
				end),
			})

			local moveBox = tab:AddRightGroupbox(
				T("Movement", "การเคลื่อนที่")
			)
			HotkeyFeature(
				moveBox,
				"SpeedOn",
				T("Speed", "ความเร็ว"),
				nil,
				Nullx11Forge.Movement.Apply
			)
			moveBox:AddSlider("WalkSpeed", {
				Text = T("Walk Speed", "ความเร็วเดิน"),
				Min = 16,
				Max = 250,
				Default = opt.WalkSpeed,
				Rounding = 0,
				Callback = function(value)
					opt.WalkSpeed = value
					Nullx11Forge.Movement.Apply()
				end,
			})
			HotkeyFeature(
				moveBox,
				"InfJump",
				T("Infinite Jump", "กระโดดไม่จำกัด")
			)

			local guardBox = tab:AddRightGroupbox(
				T("Survival", "เอาตัวรอด")
			)
			local godMode = Feature(
				guardBox,
				"GodMode",
				T("Invincible", "อมตะ"),
				T(
					"Monsters and bosses can't kill you",
					"มอนสเตอร์และบอสฆ่าไม่ตาย"
				),
				function(value)
					if not value then
						if State.RestoreDamage then
							State.RestoreDamage()
						end
					elseif not Nullx11Forge.Guard.HookDamage() then
						Notify(
							"Invincible is not available on this executor",
							"Warning"
						)
						task.defer(TurnOff, "GodMode")
					end
				end
			)
			NeedModule(godMode, ReplicatedStorage.CTRL.HPCTRL)
			local keepOre = Feature(
				guardBox,
				"KeepOre",
				T(
					"Keep Ore On Death",
					"ตายแล้วแร่ไม่หาย"
				),
				nil,
				function(value)
					if not value then
						Nullx11Forge.Guard.UnhookOreLoss()
					elseif not Nullx11Forge.Guard.HookOreLoss() then
						Notify(
							"Keep Ore On Death is not supported on this executor",
							"Warning"
						)
						task.defer(TurnOff, "KeepOre")
					end
				end
			)
			Nullx11Forge.Compat.NeedCap(keepOre, "Namecall")
		end

		local function BuildSettings(window)
			local settingsTab = window:AddSettingsTab()
			local runtimeBox = settingsTab:AddLeftGroupbox(
				T("Performance", "ประสิทธิภาพ")
			)
			NumberInput(
				runtimeBox,
				"ParallelJobs",
				T(
					"Concurrent Tasks",
					"จำนวนงานพร้อมกัน"
				),
				T(
					"1–8; inventory changes run in order",
					"1–8 งาน การแก้กระเป๋าทำตามลำดับ"
				),
				1
			)
			NumberInput(
				runtimeBox,
				"WorkerLimit",
				T(
					"Workers Per Task",
					"จำนวน worker ต่องาน"
				),
				T(
					"1–32; lower this for slow connections",
					"1–32 ลดเมื่อเน็ตช้า"
				),
				1
			)
			NumberInput(
				runtimeBox,
				"JobTimeout",
				T(
					"Task Timeout (seconds)",
					"เวลารองานสูงสุด (วินาที)"
				),
				nil,
				5
			)
			runtimeBox:AddButton({
				Text = T(
					"Retry Stopped Features",
					"ลองฟีเจอร์ที่หยุดอีกครั้ง"
				),
				Func = function()
					table.clear(Nullx11Forge.GameLib.Failed)
					table.clear(State.RemoteCache)
					for key, info in pairs(State.JobStats) do
						if not info.ok and Options[key] then
							State.Failures[key] = nil
							State.LastRun[key] = nil
							Options[key]:SetValue(true)
						end
					end
					Notify("Retry requested", "Info")
				end,
			})
			local sessionBox =
				settingsTab:AddRightGroupbox(T("Session", "เซสชัน"))
			Toggle(
				sessionBox,
				"AntiIdle",
				T("Anti Idle", "กันหลุด"),
				T(
					"Opt-in local idle input",
					"เปิดใช้เมื่อเลือกเท่านั้น"
				)
			)
			Toggle(
				sessionBox,
				"AutoRejoin",
				T(
					"Auto Rejoin",
					"เข้าเกมใหม่อัตโนมัติ"
				),
				T(
					"Rejoins the game by itself after a disconnect",
					"หลุดแล้วเข้าเกมใหม่เอง"
				)
			)
			Toggle(
				sessionBox,
				"LowGraphics",
				T("FPS Boost", "เพิ่ม FPS"),
				T(
					"Turns off 3D rendering to save CPU and GPU",
					"ปิดการแสดงผล 3D ประหยัด CPU/GPU"
				),
				Nullx11Forge.Session.SetLowGraphics
			)
			sessionBox:AddButton({
				Text = T(
					"Rejoin Now",
					"เข้าเกมใหม่เดี๋ยวนี้"
				),
				Func = Action(Nullx11Forge.Session.Rejoin),
			})
			sessionBox:AddButton({
				Text = T(
					"Hop To Emptiest Server",
					"ย้ายไปเซิร์ฟคนน้อยสุด"
				),
				Func = Action(function()
					if not Nullx11Forge.Session.HopSmallest() then
						Notify("Server list unavailable, try again", "Warning")
					end
				end),
			})

			local spotBox = settingsTab:AddRightGroupbox(
				T("Position", "ตำแหน่ง")
			)
			spotBox
				:AddButton({
					Text = T(
						"Save Position",
						"บันทึกตำแหน่ง"
					),
					Func = Action(function()
						Notify(
							Nullx11Forge.Session.SavePosition()
									and "Position saved"
								or "No character",
							"Info"
						)
					end),
				})
				:AddButton({
					Text = T(
						"Go Back",
						"กลับไปจุดที่บันทึก"
					),
					Func = Action(function()
						if not Nullx11Forge.Session.ReturnPosition() then
							Notify("Save a position first", "Warning")
						end
					end),
				})
		end

		local noteText = {
			EnhantStone_1 = "farming enhance stones",
			EnhantStone_2 = "farming rare enhance stones",
			Coin = "farming coins",
			Enhancing = "enhancing",
			NoTicket = "need a tower ticket",
			Done = "all at target",
		}

		local function TaskText()
			if State.Lock == "Index" then
				return "Index " .. (State.IndexNote or "planning")
			end
			if State.Lock then
				return State.Lock
			end
			if opt.MaxGear then
				return "Max Gear, " .. (noteText[State.GearNote] or "starting")
			end
			return "Idle"
		end

		local function UpdateStatus()
			local ok, profile = pcall(Nullx11Forge.Data.Get)
			if not (ok and profile and statusLabel) then
				return
			end
			local eco = profile.Eco or {}
			local line = ("Level %d · Rebirth %d · Coins %s"):format(
				tonumber(eco.level) or 1,
				tonumber(eco.rebirth) or 0,
				Nullx11Forge.Util.Abbreviate(eco.coin or 0)
			)
			if (State.TowerLoot or 0) > 0 then
				line ..= ("\nTower loot x%d"):format(State.TowerLoot)
			end
			Later(statusLabel.SetText, statusLabel, line)
			local gearLine = "Equipped: "
				.. tostring(Nullx11Forge.Gear.EquippedNames(profile) or "None")
			local petLine = tostring(Nullx11Forge.Pet.StatusText(profile) or "")
			Later(gearLabel.SetText, gearLabel, gearLine .. "\n" .. petLine)
			Later(
				taskLabel.SetText,
				taskLabel,
				"Working on: " .. tostring(TaskText() or "Idle")
			)
		end

		local function BuildTabs()
			local Window = Library.Window
			local sessionTab = Window:AddTab(
				"Session",
				"settings",
				"Selected-game continuation"
			)
			local sessionGroup = sessionTab:AddLeftGroupbox("Teleport consent")
			sessionGroup:AddToggle("ExecuteSelectedAfterHop", {
				Text = "Execute this game script after server hop",
				Description = "Off by default. Queues only Nullx11 - +1 loot to forge, never the loader.",
				Default = false,
				NoSave = true,
				Callback = function(value)
					Config.ExecuteAfterHop = value == true
				end,
			})
			sessionGroup:AddLabel(
				"Explicit remote calls are limited to eight per second. Stop/unload cancels waiting work."
			)
			Window:AddTabSection(T("Farm", "ฟาร์ม"))
			local MainTab = Window:AddTab(
				T("Main", "หลัก"),
				"house",
				T(
					"Status, all-in-one mode and rewards",
					"สถานะ โหมดทำทุกอย่าง และรางวัล"
				)
			)
			local GearTab = Window:AddTab(
				T("Gear", "อุปกรณ์"),
				"sword",
				T(
					"Best gear, equip and enhance",
					"อุปกรณ์ที่ดีสุด ใส่ของ และตีบวก"
				)
			)
			local PetTab = Window:AddTab(
				T(
					"Pets & Eggs",
					"สัตว์เลี้ยงและไข่"
				),
				"heart",
				T(
					"Hatch eggs, equip, feed, deploy and clean pet bag",
					"ฟักไข่ ใส่ ให้อาหาร ส่งสำรวจ และเคลียร์กระเป๋าสัตว์เลี้ยง"
				)
			)
			local FarmTab = Window:AddTab(
				T("Combat & Farm", "ต่อสู้และฟาร์ม"),
				"swords",
				T(
					"Stages, monsters, bosses and index",
					"ด่าน มอนสเตอร์ บอส และสมุดสะสม"
				)
			)
			local ForgeTab = Window:AddTab(
				T("Forge", "หลอม"),
				"zap",
				T(
					"Forge gear from any ore",
					"หลอมอุปกรณ์จากแร่ไหนก็ได้"
				)
			)
			local SellTab = Window:AddTab(
				T("Sell", "ขาย"),
				"upload",
				T(
					"Sell gear by type and rarity",
					"ขายอุปกรณ์ตามประเภทและ rarity"
				)
			)
			Window:AddTabSection(
				T("Progress", "ความคืบหน้า")
			)
			local ProgressTab = Window:AddTab(
				T(
					"Upgrade & Rebirth",
					"อัปเกรดและรีเบิร์ธ"
				),
				"sliders-horizontal",
				T(
					"Training, rebirth and upgrades",
					"ฝึก รีเบิร์ธ และอัปเกรด"
				)
			)
			local TowerTab = Window:AddTab(
				T("Tower", "หอคอย"),
				"shield",
				T(
					"Tower loot and season pass",
					"ของจากหอคอย และซีซั่นพาส"
				)
			)
			local SpawnTab = Window:AddTab(
				T("Spawn Items", "เสกของ"),
				"target",
				T(
					"Target forging, shops, potions and tower coins",
					"หลอมเป้าหมาย ร้าน ยา และเหรียญหอคอย"
				)
			)
			Window:AddTabSection(T("Other", "อื่นๆ"))
			local PlayerTab = Window:AddTab(
				T("Player", "ผู้เล่น"),
				"user",
				T(
					"Race, movement and survival",
					"เผ่า การเคลื่อนที่ และเอาตัวรอด"
				)
			)

			local sections = {
				{ BuildMain, MainTab },
				{ BuildGear, GearTab },
				{ BuildPet, PetTab },
				{ BuildFarm, FarmTab },
				{ BuildForge, ForgeTab },
				{ BuildSell, SellTab },
				{ BuildProgress, ProgressTab },
				{ BuildTower, TowerTab },
				{ BuildSpawn, SpawnTab },
				{ BuildPlayer, PlayerTab },
				{ BuildSettings, Window },
			}
			for _, section in ipairs(sections) do
				Nullx11Forge.Util.Try(section[1], section[2])
			end
			Nullx11Forge.Util.Try(BlockMissing)

			Library:Every(Config.PumpInterval, Pump)
			task.spawn(function()
				while State.Alive do
					UpdateStatus()
					task.wait(Config.StatusInterval)
				end
			end)
		end

		local function Unload()
			Library:Unload()
		end
		context.RegisterCleanup(Nullx11Forge.Scheduler.Stop)
		Library:OnUnload(function()
			if getgenv().Nullx11ForgeUnload == Unload then
				getgenv().Nullx11ForgeUnload = nil
			end
		end)
		getgenv().Nullx11ForgeUnload = Unload

		Library:CreateWindow({
			Title = "Nullx11",
			SubTitle = "Nullx11 - +1 loot to forge / NULL",
			Intro = false,
			Watermark = false,
			MenuKey = Enum.KeyCode.LeftControl,
			ConfigFolder = Config.SaveFolder,
			Language = "Auto",
			Theme = "Nullx11",
			OnUnlocked = function()
				BuildTabs()
				Nullx11Forge.Util.Try(Nullx11Forge.Scheduler.Boot)
				Notify("Loaded", "Success")
				-- Profiles never enable automation implicitly at launch.
			end,
		})
	end

	if getgenv().Nullx11ForgeUnload then
		pcall(getgenv().Nullx11ForgeUnload)
	end

	pcall(Nullx11Banner.Step, "Systems")
	BuildInterface()
	pcall(Nullx11Banner.Step, "Interface")
	pcall(Nullx11Banner.Ready)
	return Nullx11Forge
end
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local entry = {
	Id = "forge",
	Name = "Nullx11 - +1 loot to forge",
	Description = "Forge, gear, pets, stages, tower, rewards and session tools on the full shared +1 UI. Bounded workers; automation starts off.",
	File = "Nullx11-Forge.luau",
	GamePlaceId = 118805555015549,
	Author = "Owner: NULL. Nullx11 edition; source notices and restrictions retained in docs/SOURCE-PROVENANCE.md.",
	Category = "Simulator",
	Icon = "anvil",
}
local environment = type(getgenv) == "function" and getgenv() or _G
local library = createNullx11UI({
	Id = "Forge",
	ReducedMotion = environment.Nullx11ReducedMotion == true,
})
if game.PlaceId ~= entry.GamePlaceId then
	wrongPlace(
		library,
		entry,
		"https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/Nullx11-Forge.luau"
	)
	return
end
local context = makeSession(entry.Id, library)
context.Adapter = makeAdapter(library, entry.Name, "Nullx11 " .. "Forge")

local ok, result = xpcall(function()
	return runGame(context)
end, debug.traceback)
if not ok then
	library:Unload()
	warn("[" .. entry.Name .. "] " .. tostring(result))
	local notice = createNullx11UI({ Id = "ForgeError" })
	makeSession(entry.Id .. "Error", notice)
	notice:CreateWindow({
		Title = "Nullx11",
		SubTitle = entry.Name,
		Intro = false,
		Watermark = false,
		OnUnlocked = function()
			local tab = notice.Window:AddTab(
				"Runtime error",
				"info",
				"No replacement gameplay was started"
			)
			local group = tab:AddLeftGroupbox("Controller could not start")
			group:AddParagraph({
				Title = "Game/runtime incompatibility",
				Content = tostring(result),
			})
			group:AddButton({
				Text = "Close",
				Func = function()
					notice:Unload()
				end,
			})
		end,
	})
end
