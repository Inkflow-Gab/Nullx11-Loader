--!strict
-- GENERATED from src/ by tools/build.mjs. Edit the sources, then run npm run build.

-- Nullx11 • Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- Built-in session tools; optional ModuleScript child "App". See README.md.

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
		coin = "layers",
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
			SubTitle = options.SubTitle or "Developed by Gab",
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
		Anim.Tween(card, { GroupTransparency = 1 }, 0.2)
		Anim.Tween(screen, { BackgroundTransparency = 1 }, 0.2)
		task.wait(0.2)
	end

	function Intro.BuildCard(screen)
		local width, height = Intro.Width, Intro.Height
		local pad, shadow = 4, 6
		local card = Draw.New("CanvasGroup", {
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
		local shade = Draw.New("TextButton", {
			Name = "ExecutionLoading",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.36,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 72,
			Parent = State.Gui,
		})
		local card = Draw.Box("CanvasGroup", {
			Name = "ExecutionCard",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -32, 1, -32),
			GroupTransparency = 1,
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
		text("Developer", "NULLX11 / GAB", 86, 22, 18, 14, "Muted")
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
			shade:Destroy()
			if Library.Execution == self then
				Library.Execution = nil
			end
		end
		function job:Finish()
			self.Model:Finish()
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
		Anim.Tween(card, { GroupTransparency = 0 }, 0.22, "Out")
		return job
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

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CONFIG = {
	Name = "Nullx11",
	Subtitle = "Developed by Gab.",
	Accent = Color3.fromRGB(167, 146, 255),
	ReducedMotion = false,
	StartupAnimation = true,
	EnhancedWorkspace = true,
	ScriptBaseURL = "https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/",
}

-- External runtimes may not provide the LocalScript instance.
local appContainer = if typeof(script) == "Instance" then script else nil
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- Re-running the script closes its previous instance and its connections.
local previous = playerGui:FindFirstChild("Nullx11Loader")
if previous then
	previous:Destroy()
end

local colors = {
	Panel = Color3.fromRGB(12, 16, 28),
	Surface = Color3.fromRGB(23, 29, 46),
	Border = Color3.fromRGB(60, 75, 104),
	Text = Color3.fromRGB(242, 241, 249),
	Muted = Color3.fromRGB(178, 190, 211),
	Error = Color3.fromRGB(255, 151, 160),
	Success = Color3.fromRGB(143, 221, 182),
}

-- Runtime appearance bridge. The optional Design Studio updates only UI state.
local appearance = {
	Width = 440,
	Height = 520,
	Duration = 1,
	Easing = Enum.EasingStyle.Quint,
	GlitchInterval = 3.6,
	GlitchDuration = 0.14,
	GlitchOffset = 2,
	FPSInterval = 0.5,
	TelemetryInterval = 0.5,
	FPSGraph = true,
	FPSHeight = 64,
	HUDWidth = 224,
	CoordinateFormat = "X %.1f  Y %.1f  Z %.1f",
	ToggleKey = Enum.KeyCode.RightShift,
	DockOpacity = 100,
}
local studioBridge: { [string]: any } = {}
local playerToolsBridge: { [string]: any } = {}
local dashboardOpen = false
local interfaceScale = 1
local windowsPinned = false
local snapDockToEdge = false
local alive = true
local connections: { RBXScriptConnection } = {}
local themeRefreshers: { () -> () } = {}
local activeTweens: { [Instance]: { [string]: Tween } } = {}
local function connect(
	signal: RBXScriptSignal,
	callback: any
): RBXScriptConnection
	local connection = signal:Connect(callback)
	table.insert(connections, connection)
	return connection
end

local function create(
	className: string,
	properties: { [string]: any },
	parent: Instance?
): any
	if properties.TextSize then
		properties.TextSize = math.max(14, properties.TextSize)
	end
	local object = Instance.new(className)
	for key, value in pairs(properties) do
		(object :: any)[key] = value
	end
	object.Parent = parent
	return object
end

local function corner(parent: Instance, radius: number)
	create("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function tween(
	object: Instance,
	properties: { [string]: any },
	duration: number?,
	easing: Enum.EasingStyle?
)
	if not alive then
		return
	end
	-- Cancel overlapping animations so rapid taps never fight previous tweens.
	local running = activeTweens[object]
	if not running then
		running = {}
		activeTweens[object] = running
	end
	for property in pairs(properties) do
		local prior = running[property]
		if prior then
			prior:Cancel()
		end
	end
	local animation = TweenService:Create(
		object,
		TweenInfo.new(
			if CONFIG.ReducedMotion
				then 0
				else (duration or 0.18) * appearance.Duration,
			easing or appearance.Easing,
			Enum.EasingDirection.Out
		),
		properties
	)
	for property in pairs(properties) do
		running[property] = animation
	end
	animation:Play()
end

local gui = create("ScreenGui", {
	Name = "Nullx11Loader",
	ResetOnSpawn = false,
	IgnoreGuiInset = false,
	ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,
}, playerGui)

-- This frame uses the device's safe area, not the entire screen/notch region.
local root = create("Frame", {
	Name = "SafeArea",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
}, gui)

local card = create("Frame", {
	Name = "Panel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(440, 360),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
}, root)
corner(card, 20)
create("UIGradient", {
	Color = ColorSequence.new(colors.Panel, Color3.fromRGB(26, 26, 37)),
	Rotation = 115,
}, card)
create(
	"UIStroke",
	{ Color = colors.Border, Transparency = 0.2, Thickness = 1 },
	card
)
local responsiveScale = create("UIScale", { Scale = 1 }, card)

local function label(
	parent: Instance,
	text: string,
	size: number,
	color: Color3
): TextLabel
	return create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = size,
		TextColor3 = color,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, parent)
end

local header = create("Frame", {
	Name = "DragHandle",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -112, 0, 78),
	Position = UDim2.fromOffset(0, 0),
	Active = true,
}, card)
local mark = create("Frame", {
	Position = UDim2.fromOffset(24, 26),
	Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
}, header)
corner(mark, 9)
create("UIGradient", {
	Name = "BrandGradient",
	Color = ColorSequence.new(CONFIG.Accent, Color3.fromRGB(112, 113, 221)),
	Rotation = 45,
}, mark)
-- Original geometric N mark, drawn from UI primitives (no uploaded asset).
local function drawIcon(
	parent: Instance,
	ink: Color3,
	position: UDim2,
	size: number
)
	local icon = create("Frame", {
		Name = "Nullx11Icon",
		BackgroundTransparency = 1,
		Position = position,
		Size = UDim2.fromOffset(size, size),
	}, parent)
	for strokeIndex, geometry in ipairs({
		{ 0.35, 0.28, 0.1, 0.42, 55 },
		{ 0.65, 0.28, 0.1, 0.42, -55 },
		{ 0.35, 0.72, 0.1, 0.42, -55 },
		{ 0.65, 0.72, 0.1, 0.42, 55 },
		{ 0.18, 0.50, 0.08, 0.36, 0 },
		{ 0.82, 0.50, 0.08, 0.36, 0 },
		{ 0.50, 0.50, 0.21, 0.21, 45 },
	}) do
		local line = create("Frame", {
			Name = "BrandStroke" .. strokeIndex,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(geometry[1], geometry[2]),
			Size = UDim2.fromScale(geometry[3], geometry[4]),
			Rotation = geometry[5],
			BackgroundColor3 = ink,
			BorderSizePixel = 0,
		}, icon)
		corner(line, 2)
	end
	return icon
end
drawIcon(mark, colors.Panel, UDim2.fromOffset(3, 3), 24)
local title = label(header, CONFIG.Name, 21, colors.Text)
title.Name = "Title"
title.Font = Enum.Font.Code
title.Position = UDim2.fromOffset(65, 26)
title.Size = UDim2.new(1, -65, 0, 30)
local edition = label(header, "DEVELOPED BY GAB", 8, colors.Muted)
edition.Font = Enum.Font.Code
edition.Position = UDim2.fromOffset(65, 55)
edition.Size = UDim2.new(1, -65, 0, 13)

local function iconButton(
	text: string,
	x: number,
	description: string
): TextButton
	local button = create("TextButton", {
		Name = description,
		Text = text,
		TextSize = 22,
		Font = Enum.Font.Gotham,
		TextColor3 = colors.Muted,
		AutoButtonColor = false,
		BackgroundColor3 = colors.Surface,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, x, 0, 19),
		Size = UDim2.fromOffset(44, 44),
	}, card)
	corner(button, 12)
	connect(button.MouseEnter, function()
		tween(button, { BackgroundTransparency = 0 })
	end)
	connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = 1 })
	end)
	connect(button.SelectionGained, function()
		tween(button, { BackgroundTransparency = 0 })
	end)
	connect(button.SelectionLost, function()
		tween(button, { BackgroundTransparency = 1 })
	end)
	return button
end
local minimize = iconButton("−", -108, "Minimize")
local close = iconButton("×", -60, "Close")

create("Frame", {
	BackgroundColor3 = colors.Border,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(24, 81),
	Size = UDim2.new(1, -48, 0, 1),
}, card)
local eyebrow = label(card, "LESS NOISE. MORE PLAY.", 10, CONFIG.Accent)
eyebrow.Font = Enum.Font.GothamBold
eyebrow.Position = UDim2.fromOffset(24, 102)
eyebrow.Size = UDim2.new(1, -48, 0, 18)
local welcome = label(card, "Make yourself at home.", 23, colors.Text)
welcome.Font = Enum.Font.GothamBold
welcome.Position = UDim2.fromOffset(24, 128)
welcome.Size = UDim2.new(1, -48, 0, 32)
welcome.TextScaled = true
create("UITextSizeConstraint", { MinTextSize = 16, MaxTextSize = 23 }, welcome)
local subtitle = label(card, CONFIG.Subtitle, 13, colors.Muted)
subtitle.Position = UDim2.fromOffset(24, 167)
subtitle.Size = UDim2.new(1, -48, 0, 24)
subtitle.TextWrapped = true

local launch = create("TextButton", {
	Name = "Load",
	Position = UDim2.fromOffset(24, 212),
	Size = UDim2.new(1, -48, 0, 50),
	BackgroundColor3 = CONFIG.Accent,
	Text = "Load  →",
	TextColor3 = colors.Panel,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	BorderSizePixel = 0,
}, card)
corner(launch, 12)
local progressTrack = create("Frame", {
	Position = UDim2.fromOffset(24, 280),
	Size = UDim2.new(1, -48, 0, 3),
	BackgroundColor3 = colors.Surface,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, card)
corner(progressTrack, 2)
local progressFill = create("Frame", {
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
}, progressTrack)
corner(progressFill, 2)
local status = label(card, "Ready when you are", 12, colors.Muted)
status.Position = UDim2.fromOffset(24, 297)
status.Size = UDim2.new(1, -48, 0, 22)
status.TextTruncate = Enum.TextTruncate.AtEnd
local footer = label(card, "NULLX11  /  CLIENT", 9, colors.Muted)
footer.Position = UDim2.fromOffset(24, 330)
footer.Size = UDim2.new(1, -48, 0, 14)

local mini = create("TextButton", {
	Name = "RestoreNullx11",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(60, 60),
	BackgroundColor3 = colors.Panel,
	TextColor3 = CONFIG.Accent,
	Text = "",
	TextSize = 15,
	Font = Enum.Font.Code,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = true,
}, root)
corner(mini, 19)
create(
	"UIGradient",
	{ Color = ColorSequence.new(colors.Surface, colors.Panel), Rotation = 110 },
	mini
)
drawIcon(mini, Color3.fromRGB(150, 238, 226), UDim2.fromOffset(15, 12), 30)
local dockCaption = label(mini, "11 /", 8, colors.Muted)
dockCaption.Name = "DockCaption"
dockCaption.TextSize = 14
dockCaption.Font = Enum.Font.Code
dockCaption.Position = UDim2.fromOffset(0, 43)
dockCaption.Size = UDim2.new(1, 0, 0, 16)
dockCaption.TextXAlignment = Enum.TextXAlignment.Center
local dockDot = create("Frame", {
	Name = "DockStatus",
	Position = UDim2.new(1, -11, 0, 7),
	Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = colors.Success,
	BorderSizePixel = 0,
}, mini)
corner(dockDot, 4)
create("UIStroke", { Color = CONFIG.Accent, Transparency = 0.45 }, mini)

-- Real TweenService window transport. One cancellable token per window.
local portal: { [string]: any } = { Jobs = {} }
do
	local halo = create("Frame", {
		Name = "DockPortalHalo",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(54, 54),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, mini)
	corner(halo, 100)
	local haloStroke = create("UIStroke", {
		Color = Color3.fromRGB(115, 235, 224),
		Thickness = 1.5,
		Transparency = 0.65,
	}, halo)
	local rim = create("Frame", {
		Name = "DockCrystalRim",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.77, 0.77),
		BackgroundTransparency = 1,
		Rotation = 45,
		BorderSizePixel = 0,
	}, mini)
	corner(rim, 12)
	create(
		"UIStroke",
		{ Color = CONFIG.Accent, Transparency = 0.65, Thickness = 1 },
		rim
	)
	for index = 1, 4 do
		local tick = create("Frame", {
			Name = "DockRune" .. index,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(
				if index % 2 == 0 then 0.87 else 0.13,
				if index <= 2 then 0.17 else 0.83
			),
			Size = UDim2.fromOffset(3, 3),
			Rotation = 45,
			BackgroundColor3 = Color3.fromRGB(115, 235, 224),
			BorderSizePixel = 0,
		}, mini)
		corner(tick, 1)
	end
	function portal.CancelTweens(target: GuiObject)
		for _, object in ipairs({
			target,
			target:FindFirstChildOfClass("UIScale"),
		}) do
			for property, animation in pairs(activeTweens[object] or {}) do
				if
					property == "Position"
					or property == "Rotation"
					or property == "Scale"
				then
					animation:Cancel()
				end
			end
		end
	end
	function portal.Play(target: GuiObject, show: boolean, done: (() -> ())?)
		local previousJob = portal.Jobs[target]
		if not previousJob and target.Visible == show then
			if done then
				done()
			end
			return
		end
		local scale = target:FindFirstChildOfClass("UIScale")
			or create("UIScale", { Name = "PortalScale", Scale = 1 }, target)
		local pose = if previousJob
			then previousJob.Pose
			else {
				Position = target.Position,
				Scale = scale.Scale,
				Rotation = target.Rotation or 0,
			}
		local job = { Pose = pose, Show = show, Done = done }
		portal.Jobs[target] = job
		local function finish()
			if not alive or portal.Jobs[target] ~= job then
				return
			end
			portal.Jobs[target] = nil
			portal.CancelTweens(target)
			target.Visible = show
			target.Position = pose.Position
			target.Rotation = pose.Rotation
			scale.Scale = pose.Scale
			if done then
				done()
			end
		end
		if CONFIG.ReducedMotion then
			finish()
			return
		end
		target.Visible = true
		if show and not previousJob then
			target.Position = mini.Position
			target.Rotation = -16
			scale.Scale = pose.Scale * 0.08
		end
		local duration = 0.42
		tween(
			target,
			{
				Position = if show then pose.Position else mini.Position,
				Rotation = if show then pose.Rotation else 18,
			},
			duration,
			if show then Enum.EasingStyle.Back else Enum.EasingStyle.Quint
		)
		tween(
			scale,
			{ Scale = pose.Scale * (if show then 1 else 0.06) },
			duration,
			if show then Enum.EasingStyle.Back else Enum.EasingStyle.Quint
		)
		-- The restore icon is intentionally static, including while windows move.
		task.delay(duration * appearance.Duration, finish)
	end
	function portal.Settle()
		for target, job in pairs(portal.Jobs) do
			portal.Jobs[target] = nil
			portal.CancelTweens(target)
			target.Visible = job.Show
			target.Position = job.Pose.Position
			target.Rotation = job.Pose.Rotation
			local scale = target:FindFirstChildOfClass("UIScale")
			if scale then
				scale.Scale = job.Pose.Scale
			end
			if job.Done then
				job.Done()
			end
		end
	end
end

local expanded = true
local transitioning = false
local panelCenter: Vector2? = nil
local miniCenter: Vector2? = nil
local function clampCenter(position: Vector2, size: Vector2): Vector2
	local viewport = root.AbsoluteSize
	local margin = 8
	local half = size / 2
	local minX = math.min(half.X + margin, viewport.X / 2)
	local minY = math.min(half.Y + margin, viewport.Y / 2)
	return Vector2.new(
		math.clamp(position.X, minX, math.max(minX, viewport.X - minX)),
		math.clamp(position.Y, minY, math.max(minY, viewport.Y - minY))
	)
end
-- Snap only the dock to the nearest horizontal edge; preserve its vertical position.
local function snapDock(animated: boolean)
	local viewport = root.AbsoluteSize
	if not miniCenter or viewport.X <= 0 or viewport.Y <= 0 then
		return
	end
	miniCenter = clampCenter(
		Vector2.new(
			if miniCenter.X < viewport.X / 2 then 0 else viewport.X,
			miniCenter.Y
		),
		mini.AbsoluteSize
	)
	local destination = UDim2.fromOffset(miniCenter.X, miniCenter.Y)
	if animated then
		tween(mini, { Position = destination }, 0.22)
	else
		mini.Position = destination
	end
end
local extraCenters: { [GuiObject]: Vector2 } = {}
local layoutExtras: (() -> ())? = nil
local function layout()
	local viewport = root.AbsoluteSize
	if viewport.X <= 0 or viewport.Y <= 0 then
		return
	end
	for _, target in ipairs({ card, mini }) do
		local animations = activeTweens[target]
		if animations and animations.Position and not portal.Jobs[target] then
			animations.Position:Cancel()
		end
	end
	local height = if dashboardOpen
		then math.min(
			appearance.Height,
			math.max(240, (viewport.Y - 24) / interfaceScale)
		)
		else 360
	local scale =
		math.min(interfaceScale, math.max(0.1, (viewport.Y - 24) / height))
	if not portal.Jobs[card] then
		responsiveScale.Scale = scale
	end
	local width =
		math.min(appearance.Width, math.max(1, (viewport.X - 24) / scale))
	card.Size = UDim2.fromOffset(width, height)
	panelCenter = clampCenter(
		panelCenter or viewport / 2,
		Vector2.new(width, height) * scale
	)
	miniCenter = clampCenter(
		miniCenter
			or Vector2.new(
				if viewport.X > viewport.Y then viewport.X - 48 else 48,
				viewport.Y - 46
			),
		mini.AbsoluteSize
	)
	if not portal.Jobs[card] then
		card.Position = UDim2.fromOffset(panelCenter.X, panelCenter.Y)
	end
	mini.Position = UDim2.fromOffset(miniCenter.X, miniCenter.Y)
	if snapDockToEdge then
		snapDock(false)
	end
	if layoutExtras then
		layoutExtras()
	end
end
connect(root:GetPropertyChangedSignal("AbsoluteSize"), function()
	portal.Settle()
	if alive then
		layout()
	end
end)
layout()

-- One input path for touch and mouse; no per-frame polling or mouse-only dragging.
local drag: {
	input: InputObject,
	start: Vector2,
	center: Vector2,
	target: GuiObject,
	moved: boolean,
}? =
	nil
local suppressRestoreUntil = 0
local function draggable(handle: GuiObject, target: GuiObject)
	connect(handle.InputBegan, function(input: InputObject)
		if
			drag
			or portal.Jobs[target]
			or transitioning
			or (windowsPinned and target ~= mini)
		then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		local animations = activeTweens[target]
		if animations and animations.Position then
			animations.Position:Cancel()
		end
		drag = {
			input = input,
			start = Vector2.new(input.Position.X, input.Position.Y),
			center = target.AbsolutePosition
				- root.AbsolutePosition
				+ target.AbsoluteSize / 2,
			target = target,
			moved = false,
		}
	end)
end
draggable(header, card)
draggable(mini, mini)
connect(UserInputService.InputChanged, function(input: InputObject)
	local current = drag
	if not current then
		return
	end
	if
		input ~= current.input
		and not (
			current.input.UserInputType == Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseMovement
		)
	then
		return
	end
	local delta = Vector2.new(input.Position.X, input.Position.Y)
		- current.start
	if delta.Magnitude > 6 then
		current.moved = true
	end
	if not current.moved then
		return
	end
	if current.target == mini then
		suppressRestoreUntil = os.clock() + 0.3
	end
	local center =
		clampCenter(current.center + delta, current.target.AbsoluteSize)
	current.target.Position = UDim2.fromOffset(center.X, center.Y)
	if current.target == card then
		panelCenter = center
	elseif current.target == mini then
		miniCenter = center
	else
		extraCenters[current.target] = center
	end
end)
connect(UserInputService.InputEnded, function(input: InputObject)
	if drag and input == drag.input then
		if drag.target == mini and drag.moved then
			suppressRestoreUntil = os.clock() + 0.3
			if snapDockToEdge then
				snapDock(true)
			end
		end
		drag = nil
	end
end)
connect(UserInputService.WindowFocusReleased, function()
	drag = nil
end)

local function setExpanded(value: boolean)
	if value == expanded then
		return
	end
	transitioning = true
	drag = nil
	expanded = value
	mini.Visible = true
	dockDot.BackgroundColor3 = if value then colors.Success else CONFIG.Accent
	layout()
	portal.Play(card, value, function()
		transitioning = false
	end)
end

connect(minimize.Activated, function()
	setExpanded(false)
end)
connect(mini.Activated, function()
	if os.clock() >= suppressRestoreUntil then
		setExpanded(not expanded)
	end
end)
connect(close.Activated, function()
	if portal.Closing then
		return
	end
	portal.Closing = true
	if playerToolsBridge.Stop then
		playerToolsBridge.Stop()
	end
	if card.Visible then
		for _, window in ipairs(root:GetChildren()) do
			if
				window ~= card
				and window ~= mini
				and window:IsA("GuiObject")
				and window.Visible
			then
				portal.Play(window, false)
			end
		end
	end
	portal.Play(card, false, function()
		if alive then
			gui:Destroy()
		end
	end)
end)
connect(mini.MouseButton1Down, function()
	tween(mini, {
		BackgroundTransparency = math.min(
			1,
			1 - appearance.DockOpacity / 100 + 0.15
		),
	}, 0.1)
end)
connect(mini.MouseButton1Up, function()
	tween(
		mini,
		{ BackgroundTransparency = 1 - appearance.DockOpacity / 100 },
		0.1
	)
end)
connect(mini.MouseLeave, function()
	tween(
		mini,
		{ BackgroundTransparency = 1 - appearance.DockOpacity / 100 },
		0.1
	)
end)

-- Built-in tools: toggles live in the main panel; each utility floats separately.
local tools = create("ScrollingFrame", {
	Name = "Tools",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(24, 152),
	Size = UDim2.new(1, -48, 1, -234),
	CanvasSize = UDim2.fromOffset(0, 232),
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
	Visible = false,
}, card)
local function toggleRow(
	name: string,
	hint: string,
	y: number,
	initial: boolean,
	changed: (boolean) -> (),
	parent: Instance?
): (boolean) -> ()
	local enabled = initial
	local row = create("TextButton", {
		Name = name,
		Text = "",
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, y),
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
	}, parent or tools)
	corner(row, 10)
	local heading = label(row, name, 16, colors.Text)
	heading.Position = UDim2.fromOffset(12, 6)
	heading.Size = UDim2.new(1, -104, 0, 20)
	heading.Font = Enum.Font.GothamMedium
	local description = label(row, hint, 10, colors.Muted)
	description.Position = UDim2.fromOffset(12, 30)
	description.Size = UDim2.new(1, -104, 0, 22)
	description.TextTruncate = Enum.TextTruncate.AtEnd
	local indicator = label(row, "", 9, CONFIG.Accent)
	indicator.Name = "ToggleState"
	indicator.Font = Enum.Font.Code
	indicator.Position = UDim2.new(1, -91, 0, 0)
	indicator.Size = UDim2.fromOffset(30, 50)
	indicator.TextXAlignment = Enum.TextXAlignment.Center
	local track = create("Frame", {
		Name = "SwitchTrack",
		Position = UDim2.new(1, -56, 0, 13),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = colors.Border,
		BorderSizePixel = 0,
	}, row)
	corner(track, 12)
	local thumb = create("Frame", {
		Name = "SwitchThumb",
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = colors.Muted,
		BorderSizePixel = 0,
	}, track)
	corner(thumb, 9)
	local function paint()
		tween(track, {
			BackgroundColor3 = if enabled then CONFIG.Accent else colors.Border,
		})
		tween(thumb, {
			Position = UDim2.fromOffset(if enabled then 23 else 3, 3),
			BackgroundColor3 = if enabled then colors.Panel else colors.Muted,
		})
		indicator.Text = if enabled then "ON" else "OFF"
		indicator.TextColor3 = if enabled then CONFIG.Accent else colors.Muted
	end
	paint()
	table.insert(themeRefreshers, paint)
	local function setEnabled(value: boolean)
		enabled = value
		paint()
		changed(enabled)
	end
	connect(row.Activated, function()
		setEnabled(not enabled)
	end)
	return setEnabled
end

local teleportPanel = create("Frame", {
	Name = "TeleportPanel",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(320, 362),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Visible = false,
}, root)
corner(teleportPanel, 16)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, teleportPanel)
local teleportScale = create("UIScale", { Scale = 1 }, teleportPanel)
local teleportHeader = create("Frame", {
	Name = "TeleportDragHandle",
	BackgroundTransparency = 1,
	Active = true,
	Size = UDim2.new(1, -60, 0, 56),
}, teleportPanel)
drawIcon(teleportHeader, CONFIG.Accent, UDim2.fromOffset(16, 17), 22)
local teleportTitle = label(teleportHeader, "POSITION", 13, colors.Text)
teleportTitle.Font = Enum.Font.Code
teleportTitle.Position = UDim2.fromOffset(48, 0)
teleportTitle.Size = UDim2.new(1, -48, 1, 0)
local teleportHide = create("TextButton", {
	Name = "HideTeleport",
	Text = "−",
	TextSize = 22,
	TextColor3 = colors.Muted,
	Font = Enum.Font.Code,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -52, 0, 6),
	Size = UDim2.fromOffset(44, 44),
}, teleportPanel)
-- Hiding keeps the bookmark; the main toggle can reopen this utility.
local setTeleportEnabled: ((boolean) -> ())? = nil
connect(teleportHide.Activated, function()
	if setTeleportEnabled then
		setTeleportEnabled(false)
	end
end)
local coordinates = label(teleportPanel, "No position saved", 12, colors.Muted)
coordinates.Name = "Coordinates"
coordinates.Font = Enum.Font.Code
coordinates.Position = UDim2.fromOffset(16, 151)
coordinates.Size = UDim2.new(1, -32, 0, 28)
coordinates.TextScaled = true
create(
	"UITextSizeConstraint",
	{ MinTextSize = 9, MaxTextSize = 12 },
	coordinates
)
local teleportStatus =
	label(teleportPanel, "Save a spot, then return to it.", 11, colors.Muted)
teleportStatus.Name = "TeleportStatus"
teleportStatus.Position = UDim2.fromOffset(16, 313)
teleportStatus.Size = UDim2.new(1, -32, 0, 38)
teleportStatus.TextWrapped = true
local function utilityButton(
	name: string,
	text: string,
	position: UDim2,
	size: UDim2,
	primary: boolean
): TextButton
	local button = create("TextButton", {
		Name = name,
		Text = text,
		Position = position,
		Size = size,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		AutoButtonColor = false,
		TextColor3 = if primary then colors.Panel else colors.Text,
		BackgroundColor3 = if primary then CONFIG.Accent else colors.Surface,
		BorderSizePixel = 0,
	}, teleportPanel)
	corner(button, 10)
	connect(button.MouseButton1Down, function()
		tween(button, { BackgroundTransparency = 0.25 }, 0.1)
	end)
	connect(button.MouseButton1Up, function()
		tween(button, { BackgroundTransparency = 0 }, 0.1)
	end)
	connect(button.MouseLeave, function()
		tween(button, { BackgroundTransparency = 0 }, 0.1)
	end)
	return button
end
local savePosition = utilityButton(
	"SavePosition",
	"Save position",
	UDim2.fromOffset(16, 206),
	UDim2.new(0.5, -20, 0, 46),
	false
)
local clearPosition = utilityButton(
	"ClearPosition",
	"Clear",
	UDim2.new(0.5, 4, 0, 206),
	UDim2.new(0.5, -20, 0, 46),
	false
)
local goPosition = utilityButton(
	"TeleportToPosition",
	"Teleport to saved spot  →",
	UDim2.fromOffset(16, 260),
	UDim2.new(1, -32, 0, 46),
	true
)
local savedPivot: CFrame? = nil
local savedPivots: { [number]: CFrame } = {}
local selectedSlot = 1
local slotButtons: { TextButton } = {}
local bookmarkNames = { "Spot 1", "Spot 2", "Spot 3" }
local nameInput = create("TextBox", {
	Name = "BookmarkName",
	Text = bookmarkNames[1],
	PlaceholderText = "Name this spot",
	ClearTextOnFocus = false,
	MultiLine = false,
	TextSize = 13,
	Font = Enum.Font.GothamMedium,
	TextColor3 = colors.Text,
	PlaceholderColor3 = colors.Muted,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundColor3 = colors.Surface,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(16, 105),
	Size = UDim2.new(1, -32, 0, 40),
}, teleportPanel)
corner(nameInput, 10)
create(
	"UIPadding",
	{ PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) },
	nameInput
)
local distanceText =
	label(teleportPanel, "Save a spot to measure distance", 10, colors.Muted)
distanceText.Name = "BookmarkDistance"
distanceText.Font = Enum.Font.Code
distanceText.Position = UDim2.fromOffset(16, 179)
distanceText.Size = UDim2.new(1, -32, 0, 18)
local updateDistance: (() -> ())? = nil
local function commitBookmarkName()
	if not alive then
		return
	end
	-- Bound user text by Unicode codepoints, not bytes; never evaluate or persist it.
	local value = string.gsub(nameInput.Text, "%c", " ")
	value = string.match(value, "^%s*(.-)%s*$") or ""
	local length = utf8.len(value)
	if not length or length == 0 then
		value = "Spot " .. selectedSlot
	elseif length > 24 then
		local boundary = utf8.offset(value, 25)
		if boundary then
			value = string.sub(value, 1, boundary - 1)
		end
	end
	bookmarkNames[selectedSlot] = value
	nameInput.Text = value
end
connect(nameInput.FocusLost, commitBookmarkName)
local function refreshSlots()
	for i, button in ipairs(slotButtons) do
		button.Text = string.format(
			"%02d  %s",
			i,
			if savedPivots[i] then "SAVED" else "EMPTY"
		)
		button.TextColor3 = if i == selectedSlot
			then colors.Panel
			else colors.Muted
		button.BackgroundColor3 = if i == selectedSlot
			then CONFIG.Accent
			else colors.Surface
	end
end
local function refreshCoordinates()
	if savedPivot then
		local position = savedPivot.Position
		coordinates.Text = string.format(
			"X %.1f   Y %.1f   Z %.1f",
			position.X,
			position.Y,
			position.Z
		)
	else
		coordinates.Text = "No position saved"
	end
end
for i = 1, 3 do
	local index = i
	local button = utilityButton(
		"Slot" .. i,
		"",
		UDim2.new((i - 1) / 3, 16 - (i - 1) * 8, 0, 58),
		UDim2.new(1 / 3, -16, 0, 38),
		false
	)
	button.Font = Enum.Font.Code
	button.TextSize = 10
	table.insert(slotButtons, button)
	connect(button.Activated, function()
		commitBookmarkName()
		selectedSlot = index
		nameInput.Text = bookmarkNames[index]
		savedPivot = savedPivots[index]
		refreshSlots()
		refreshCoordinates()
		if updateDistance then
			updateDistance()
		end
		teleportStatus.Text = "Selected " .. bookmarkNames[index] .. "."
		teleportStatus.TextColor3 = colors.Muted
	end)
end
refreshSlots()
local teleporting = false
local lastTeleport = -math.huge
local function characterReady(): Model?
	local character = player.Character
	if not character or not character.Parent then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if
		not humanoid
		or humanoid.Health <= 0
		or not character:FindFirstChild("HumanoidRootPart")
	then
		return nil
	end
	return character
end
updateDistance = function()
	local character = characterReady()
	if not savedPivot then
		distanceText.Text = "Save a spot to measure distance"
	elseif not character then
		distanceText.Text = "Distance available after spawning"
	else
		local current = character:GetPivot().Position
		local saved = savedPivot.Position
		local x, y, z =
			current.X - saved.X, current.Y - saved.Y, current.Z - saved.Z
		distanceText.Text =
			string.format("%.0f studs away", math.sqrt(x * x + y * y + z * z))
	end
end
local function reportPosition(message: string, failed: boolean?)
	teleportStatus.Text = message
	teleportStatus.TextColor3 = if failed then colors.Error else colors.Muted
end
connect(savePosition.Activated, function()
	local character = characterReady()
	if not character then
		reportPosition("Wait for your character to spawn.", true)
		return
	end
	commitBookmarkName()
	savedPivot = character:GetPivot()
	savedPivots[selectedSlot] = savedPivot
	refreshSlots()
	refreshCoordinates()
	if updateDistance then
		updateDistance()
	end
	reportPosition(bookmarkNames[selectedSlot] .. " saved for this session.")
end)
connect(clearPosition.Activated, function()
	savedPivot = nil
	savedPivots[selectedSlot] = nil
	refreshSlots()
	coordinates.Text = "No position saved"
	if updateDistance then
		updateDistance()
	end
	reportPosition("Bookmark cleared.")
end)
connect(goPosition.Activated, function()
	if teleporting or os.clock() - lastTeleport < 0.8 then
		return
	end
	local destination = savedPivot
	if not destination then
		reportPosition("Save a position first.", true)
		return
	end
	local character = characterReady()
	if not character then
		reportPosition("Wait for your character to spawn.", true)
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.SeatPart then
		reportPosition("Leave your seat before teleporting.", true)
		return
	end
	teleporting = true
	lastTeleport = os.clock()
	local ok = pcall(function()
		-- Local character movement, not a server permission or anticheat bypass.
		character:PivotTo(destination)
		local part = character:FindFirstChild("HumanoidRootPart")
			or character.PrimaryPart
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
		if part and part:IsA("BasePart") then
			part.AssemblyLinearVelocity = Vector3.zero
			part.AssemblyAngularVelocity = Vector3.zero
		end
	end)
	teleporting = false
	reportPosition(
		if ok
			then "Returned to saved spot (local movement)."
			else "Could not move your character.",
		not ok
	)
end)

local fpsPanel = create("Frame", {
	Name = "FPSMeter",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(132, appearance.FPSHeight),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
}, root)
corner(fpsPanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, fpsPanel)
for i = 1, 3 do
	local bar = create("Frame", {
		Position = UDim2.fromOffset(14 + (i - 1) * 5, 32 - i * 5),
		Size = UDim2.fromOffset(3, i * 5),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
	}, fpsPanel)
	corner(bar, 1)
end
local fpsScale = create("UIScale", { Scale = 1 }, fpsPanel)
local fpsText = label(fpsPanel, "— FPS", 14, colors.Text)
fpsText.Name = "FPSValue"
fpsText.Font = Enum.Font.Code
fpsText.Position = UDim2.fromOffset(38, 0)
fpsText.Size = UDim2.new(1, -44, 0, 36)
local fpsHistory: { number } = {}
local fpsBars: { Frame } = {}
for i = 1, 12 do
	local bar = create("Frame", {
		Name = "FPSHistory" .. i,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromOffset(14 + (i - 1) * 9, 54),
		Size = UDim2.fromOffset(6, 2),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Visible = false,
	}, fpsPanel)
	corner(bar, 2)
	table.insert(fpsBars, bar)
end

local coordinatePanel = create("Frame", {
	Name = "CoordinateHUD",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(appearance.HUDWidth, 48),
	BackgroundColor3 = colors.Panel,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
}, root)
corner(coordinatePanel, 12)
create("UIStroke", { Color = colors.Border, Thickness = 1 }, coordinatePanel)
local coordinateScale = create("UIScale", { Scale = 1 }, coordinatePanel)
local coordinateText =
	label(coordinatePanel, "Waiting for character…", 11, colors.Text)
coordinateText.Name = "LiveCoordinates"
coordinateText.Font = Enum.Font.Code
coordinateText.Position = UDim2.fromOffset(12, 0)
coordinateText.Size = UDim2.new(1, -24, 1, 0)
local hudEnabled = false
local updateSession: ((number) -> ())? = nil
local sessionTime, telemetryTime = 0, 0

layoutExtras = function()
	local viewport = root.AbsoluteSize
	local scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / 320),
		math.max(0.1, (viewport.Y - 24) / 362)
	)
	teleportScale.Scale = scale
	fpsScale.Scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / 132),
		math.max(0.1, (viewport.Y - 24) / appearance.FPSHeight)
	)
	coordinateScale.Scale = math.min(
		interfaceScale,
		math.max(0.1, (viewport.X - 24) / appearance.HUDWidth),
		math.max(0.1, (viewport.Y - 24) / 48)
	)
	for _, floating in ipairs({ teleportPanel, fpsPanel, coordinatePanel }) do
		local size = if floating == teleportPanel
			then Vector2.new(320, 362) * scale
			elseif floating == fpsPanel then Vector2.new(
				132,
				appearance.FPSHeight
			) * fpsScale.Scale
			else Vector2.new(appearance.HUDWidth, 48) * coordinateScale.Scale
		local preferred = if floating == teleportPanel
			then Vector2.new(
				math.min(viewport.X - 170, viewport.X / 2 + 210),
				viewport.Y / 2
			)
			elseif floating == fpsPanel then Vector2.new(
				viewport.X - 82,
				40
			)
			else Vector2.new(viewport.X - 128, 96)
		local center = clampCenter(extraCenters[floating] or preferred, size)
		extraCenters[floating] = center
		floating.Position = UDim2.fromOffset(center.X, center.Y)
	end
end
layout()
draggable(teleportHeader, teleportPanel)
draggable(fpsPanel, fpsPanel)
draggable(coordinatePanel, coordinatePanel)

local glitchEnabled = not CONFIG.ReducedMotion
local fpsEnabled = false
local fpsFrames, fpsElapsed = 0, 0
local glitchClock, glitchRemaining = 0, 0
local ghosts: { TextLabel } = {}
for _, tint in ipairs({
	Color3.fromRGB(109, 225, 242),
	Color3.fromRGB(245, 120, 189),
}) do
	local ghost = label(header, CONFIG.Name, 19, tint)
	ghost.Name = "GlitchLayer"
	ghost.TextSize = title.TextSize
	ghost.Font = Enum.Font.Code
	ghost.Position = title.Position
	ghost.Size = title.Size
	ghost.TextTransparency = 1
	ghost.ZIndex = title.ZIndex + 1
	table.insert(ghosts, ghost)
end
local function resetTitle()
	title.Text = CONFIG.Name
	for _, ghost in ipairs(ghosts) do
		ghost.TextTransparency = 1
	end
end
setTeleportEnabled = toggleRow(
	"Teleport tools",
	"Three bookmarks · save & return",
	0,
	false,
	function(enabled)
		layout()
		portal.Play(teleportPanel, enabled)
	end
)
local setFPSEnabled = toggleRow(
	"FPS meter",
	"Floating · drag to reposition",
	58,
	false,
	function(enabled)
		fpsEnabled = enabled

		fpsFrames, fpsElapsed = 0, 0
		fpsText.Text = "— FPS"
		table.clear(fpsHistory)
		for _, bar in ipairs(fpsBars) do
			bar.Visible = false
		end
		layout()
		portal.Play(fpsPanel, enabled)
	end
)
local setGlitchEnabled = toggleRow(
	"Glitch title",
	"Subtle RGB split · monospace",
	116,
	glitchEnabled,
	function(enabled)
		glitchEnabled = enabled
		glitchClock, glitchRemaining = 0, 0
		resetTitle()
		if studioBridge.Sync then
			studioBridge.Sync()
		end
	end
)
local setHUDEnabled = toggleRow(
	"Position HUD",
	"Live coordinates · draggable",
	174,
	false,
	function(enabled)
		hudEnabled = enabled
		layout()
		portal.Play(coordinatePanel, enabled)
	end
)
-- One render connection; telemetry is sampled twice a second, not every frame.
connect(RunService.RenderStepped, function(dt: number)
	sessionTime += dt
	telemetryTime += dt
	if telemetryTime >= appearance.TelemetryInterval then
		telemetryTime = 0
		if teleportPanel.Visible and updateDistance then
			updateDistance()
		end
		if hudEnabled then
			local character = characterReady()
			if character then
				local position = character:GetPivot().Position
				coordinateText.Text = string.format(
					appearance.CoordinateFormat,
					position.X,
					position.Y,
					position.Z
				)
			else
				coordinateText.Text = "Waiting for character…"
			end
		end
		if updateSession then
			updateSession(sessionTime)
		end
	end
	if fpsEnabled then
		fpsFrames += 1
		fpsElapsed += dt
		if fpsElapsed >= appearance.FPSInterval then
			local fps = math.floor(fpsFrames / fpsElapsed + 0.5)
			table.insert(fpsHistory, fps)
			if #fpsHistory > 12 then
				table.remove(fpsHistory, 1)
			end
			for i, bar in ipairs(fpsBars) do
				local sample = fpsHistory[i]
				bar.Visible = appearance.FPSGraph and sample ~= nil
				if sample then
					bar.Size = UDim2.fromOffset(
						6,
						math.clamp(sample / 120, 0.1, 1) * 12
					)
					bar.BackgroundColor3 = if sample < 30
						then colors.Error
						else CONFIG.Accent
				end
			end
			fpsText.Text = string.format("%d FPS", fps)
			fpsText.TextColor3 = if fps < 30
				then colors.Error
				elseif fps < 50 then CONFIG.Accent
				else colors.Success
			fpsFrames, fpsElapsed = 0, 0
		end
	end
	if not glitchEnabled or CONFIG.ReducedMotion or not card.Visible then
		if glitchRemaining > 0 then
			resetTitle()
		end
		glitchRemaining = 0
		return
	end
	glitchClock += dt
	if glitchClock >= appearance.GlitchInterval then
		glitchClock = 0
		glitchRemaining = appearance.GlitchDuration
	end
	if glitchRemaining > 0 then
		glitchRemaining = math.max(0, glitchRemaining - dt)
		if glitchRemaining == 0 then
			resetTitle()
			return
		end
		local shift = if math.floor(glitchRemaining * 60) % 2 == 0
			then appearance.GlitchOffset
			else -appearance.GlitchOffset
		for i, ghost in ipairs(ghosts) do
			ghost.TextTransparency = 0.55
			ghost.Position = title.Position
				+ UDim2.fromOffset(if i == 1 then shift else -shift, 0)
		end
		if #CONFIG.Name > 0 then
			local index = math.random(1, #CONFIG.Name)
			title.Text = string.sub(CONFIG.Name, 1, index - 1)
				.. "_"
				.. string.sub(CONFIG.Name, index + 1)
		end
	end
end)
local showDashboard: (() -> ())? = nil
local function showTools()
	dashboardOpen = true
	if studioBridge.ResizeGrip then
		studioBridge.ResizeGrip.Visible = true
	end
	if showDashboard then
		showDashboard()
	end
	progressTrack.Position = UDim2.new(0, 24, 1, -72)
	status.Position = UDim2.new(0, 24, 1, -56)
	footer.Position = UDim2.new(0, 24, 1, -26)
	layout()
	welcome.Visible = false
	subtitle.Visible = false
	eyebrow.Visible = false
	launch.Visible = false
	tools.Visible = true
	footer.Text = "NULLX11  /  PERSONAL WORKSPACE"
end

-- Keep secondary pages in a local scope; callbacks retain only their own state.
do
	local tabs = create("Frame", {
		Name = "Navigation",
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(24, 94),
		Size = UDim2.new(1, -48, 0, 44),
		Visible = false,
	}, card)
	corner(tabs, 12)
	local function page(name: string, contentHeight: number)
		return create("ScrollingFrame", {
			Name = name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = tools.Position,
			Size = tools.Size,
			Visible = false,
			CanvasSize = UDim2.fromOffset(0, contentHeight),
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, card)
	end
	local stylePage = page("StylePage", 650)
	local sessionPage = page("SessionPage", 370)
	local pages = { tools, stylePage, sessionPage }
	local tabButtons: { TextButton } = {}
	local function selectPage(index: number)
		for i, view in ipairs(pages) do
			view.Visible = i == index
			tween(tabButtons[i], {
				BackgroundTransparency = if i == index then 0 else 1,
				TextColor3 = if i == index then colors.Text else colors.Muted,
			})
		end
	end
	for i, name in ipairs({ "Tools", "Style", "Session" }) do
		local index = i
		local button = create("TextButton", {
			Name = "Tab" .. name,
			Text = name,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			Position = UDim2.new((i - 1) / 3, 4, 0, 4),
			Size = UDim2.new(1 / 3, -8, 1, -8),
			TextColor3 = colors.Muted,
			BackgroundColor3 = Color3.fromRGB(43, 43, 58),
			BorderSizePixel = 0,
			AutoButtonColor = false,
		}, tabs)
		corner(button, 9)
		table.insert(tabButtons, button)
		connect(button.Activated, function()
			selectPage(index)
		end)
	end
	showDashboard = function()
		tabs.Visible = true
		selectPage(1)
	end
	local function section(parent: Instance, text: string, y: number)
		local heading = label(parent, text, 10, colors.Muted)
		heading.Font = Enum.Font.Code
		heading.Position = UDim2.fromOffset(0, y)
		heading.Size = UDim2.new(1, 0, 0, 20)
	end
	local function action(
		parent: Instance,
		name: string,
		text: string,
		position: UDim2,
		size: UDim2,
		callback: () -> ()
	)
		local button = create("TextButton", {
			Name = name,
			Text = text,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			Position = position,
			Size = size,
			BorderSizePixel = 0,
			AutoButtonColor = false,
		}, parent)
		corner(button, 10)
		connect(button.Activated, callback)
		connect(button.MouseEnter, function()
			tween(button, { BackgroundTransparency = 0.2 })
		end)
		connect(button.MouseLeave, function()
			tween(button, { BackgroundTransparency = 0 })
		end)
		return button
	end
	local function applyTheme(accent: Color3, name: string)
		local previousAccent = CONFIG.Accent
		CONFIG.Accent = accent
		-- Recolor only objects using the old accent, never unrelated status colors.
		for _, object in ipairs(gui:GetDescendants()) do
			if object:IsA("GuiObject") then
				if object.BackgroundColor3 == previousAccent then
					object.BackgroundColor3 = accent
				end
				if
					(object:IsA("TextLabel") or object:IsA("TextButton"))
					and string.sub(object.Name, 1, 5) ~= "Theme"
					and object.TextColor3 == previousAccent
				then
					object.TextColor3 = accent
				end
				if
					object:IsA("ScrollingFrame")
					and object.ScrollBarImageColor3 == previousAccent
				then
					object.ScrollBarImageColor3 = accent
				end
			elseif
				object:IsA("UIStroke") and object.Color == previousAccent
			then
				object.Color = accent
			elseif
				object:IsA("UIGradient") and object.Name == "BrandGradient"
			then
				object.Color =
					ColorSequence.new(accent, Color3.fromRGB(112, 113, 221))
			end
		end
		for _, refresh in ipairs(themeRefreshers) do
			refresh()
		end
		refreshSlots()
		status.Text = name .. " accent selected."
		if studioBridge.Sync then
			studioBridge.Sync()
		end
	end
	studioBridge.Accent = applyTheme
	section(stylePage, "01 / ACCENT", 0)
	for i, theme in ipairs({
		{ Name = "Violet", Color = Color3.fromRGB(167, 146, 255) },
		{ Name = "Mint", Color = Color3.fromRGB(126, 222, 185) },
		{ Name = "Ice", Color = Color3.fromRGB(129, 200, 255) },
	}) do
		local choice = theme
		local button = action(
			stylePage,
			"Theme" .. theme.Name,
			theme.Name,
			UDim2.new((i - 1) / 3, 0, 0, 27),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				applyTheme(choice.Color, choice.Name)
			end
		)
		button.TextColor3 = theme.Color
	end
	studioBridge.Motion = toggleRow(
		"Reduced motion",
		"Disable transitions and title glitch",
		86,
		CONFIG.ReducedMotion,
		function(enabled)
			CONFIG.ReducedMotion = enabled
			if playerToolsBridge.ReducedMotion then
				playerToolsBridge.ReducedMotion(enabled)
			end
			if enabled then
				setGlitchEnabled(false)
				resetTitle()
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	studioBridge.Lock = toggleRow(
		"Lock windows",
		"Dock stays movable for easy recovery",
		144,
		false,
		function(enabled)
			windowsPinned = enabled
			if enabled then
				drag = nil
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	studioBridge.Snap = toggleRow(
		"Snap dock",
		"Snap to nearest side after dragging",
		202,
		false,
		function(enabled)
			snapDockToEdge = enabled
			if enabled then
				snapDock(true)
			end
			if studioBridge.Sync then
				studioBridge.Sync()
			end
		end,
		stylePage
	)
	section(stylePage, "02 / INTERFACE SIZE", 269)
	for i, size in ipairs({
		{ "Small", 0.85 },
		{ "Default", 1 },
		{ "Large", 1.1 },
	}) do
		local factor = size[2] :: number
		action(
			stylePage,
			"Scale" .. size[1],
			size[1] :: string,
			UDim2.new((i - 1) / 3, 0, 0, 297),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				interfaceScale = factor
				layout()
				status.Text = "Interface size updated."
				if studioBridge.Sync then
					studioBridge.Sync()
				end
			end
		)
	end
	local motionHint = label(
		stylePage,
		"Preferences last for this run. No files are written.",
		10,
		colors.Muted
	)
	motionHint.Position = UDim2.fromOffset(0, 352)
	motionHint.Size = UDim2.new(1, -4, 0, 28)
	motionHint.TextWrapped = true

	action(
		stylePage,
		"OpenDesignStudio",
		"Open Design Studio  →",
		UDim2.fromOffset(0, 401),
		UDim2.new(1, -4, 0, 48),
		function()
			if studioBridge.Open then
				studioBridge.Open()
			end
		end
	)
	section(stylePage, "03 / DISPLAY TYPE", 464)
	for index, name in ipairs({ "Gotham", "Pixel", "Medieval" }) do
		local fontName = name
		action(
			stylePage,
			"QuickFont_" .. name,
			if name == "Gotham" then "Modern" else name,
			UDim2.new((index - 1) / 3, 0, 0, 492),
			UDim2.new(1 / 3, -6, 0, 44),
			function()
				if studioBridge.Font then
					studioBridge.Font(fontName)
				end
			end
		)
	end

	section(stylePage, "04 / SIGNATURE LOOKS", 554)
	for index, name in ipairs({ "Pixel", "Citadel" }) do
		local look = name
		action(
			stylePage,
			"QuickLook_" .. look,
			if look == "Pixel" then "Aurora / Pixel" else "Citadel / Gothic",
			UDim2.new((index - 1) / 2, 0, 0, 582),
			UDim2.new(0.5, -6, 0, 48),
			function()
				if studioBridge.Look then
					studioBridge.Look(look)
				end
			end
		)
	end

	section(sessionPage, "LOCAL SESSION", 0)
	local identity =
		label(sessionPage, "@" .. (player.Name or "Player"), 16, colors.Text)
	identity.Font = Enum.Font.GothamBold
	identity.Position = UDim2.fromOffset(0, 28)
	identity.Size = UDim2.new(1, 0, 0, 26)
	local sessionStats =
		label(sessionPage, "00:00  /  0 of 3 bookmarks", 12, CONFIG.Accent)
	sessionStats.Name = "SessionStats"
	sessionStats.Font = Enum.Font.Code
	sessionStats.Position = UDim2.fromOffset(0, 64)
	sessionStats.Size = UDim2.new(1, 0, 0, 26)
	updateSession = function(elapsed: number)
		if not sessionPage.Visible then
			return
		end
		local count = 0
		for _ in pairs(savedPivots) do
			count += 1
		end
		local seconds = math.floor(elapsed)
		sessionStats.Text = string.format(
			"%02d:%02d  /  %d of 3 bookmarks",
			math.floor(seconds / 60),
			seconds % 60,
			count
		)
	end
	action(
		sessionPage,
		"ResetLayout",
		"Recenter all windows",
		UDim2.fromOffset(0, 108),
		UDim2.new(1, -4, 0, 46),
		function()
			panelCenter = nil
			miniCenter = nil
			table.clear(extraCenters)
			drag = nil
			layout()
			status.Text = "Window positions reset."
		end
	)
	action(
		sessionPage,
		"HideUtilities",
		"Hide floating utilities",
		UDim2.fromOffset(0, 164),
		UDim2.new(1, -4, 0, 46),
		function()
			if setTeleportEnabled then
				setTeleportEnabled(false)
			end
			setFPSEnabled(false)
			setHUDEnabled(false)
			if playerToolsBridge.HideWindows then
				playerToolsBridge.HideWindows()
			end
			status.Text = "Floating utilities hidden; player tools off."
		end
	)
	local clearDeadline = 0
	local clearAll: TextButton? = nil
	clearAll = action(
		sessionPage,
		"ClearBookmarks",
		"Clear all bookmarks",
		UDim2.fromOffset(0, 220),
		UDim2.new(1, -4, 0, 46),
		function()
			local button = clearAll
			if not button then
				return
			end
			if clearDeadline == 0 or os.clock() > clearDeadline then
				clearDeadline = os.clock() + 3
				button.Text = "Tap again within 3s to clear"
				return
			end
			clearDeadline = 0
			table.clear(savedPivots)
			savedPivot = nil
			refreshCoordinates()
			refreshSlots()
			if updateDistance then
				updateDistance()
			end
			button.Text = "Clear all bookmarks"
			status.Text = "All bookmarks cleared."
		end
	)
	local hint = label(
		sessionPage,
		"RIGHT SHIFT toggles the dashboard.\nDrag the dock to move it; tap to show or hide.\nTeleports are local and can be reset by the server.",
		11,
		colors.Muted
	)
	hint.Position = UDim2.fromOffset(0, 282)
	hint.Size = UDim2.new(1, -4, 0, 74)
	hint.TextWrapped = true
	connect(
		UserInputService.InputBegan,
		function(input: InputObject, processed: boolean)
			if processed or UserInputService:GetFocusedTextBox() then
				return
			end
			if
				input.KeyCode == appearance.ToggleKey
				and not playerToolsBridge.PrimaryActive
			then
				setExpanded(not expanded)
			end
		end
	)
end

-- The resize grip uses the same safe-area layout as orientation changes.
do
	local resizeInput: InputObject? = nil
	local origin = Vector2.new(0, 0)
	local startSize = Vector2.new(440, 520)
	local grip = create("TextButton", {
		Name = "ResizeDashboard",
		Text = "↘",
		TextSize = 19,
		Font = Enum.Font.Code,
		TextColor3 = colors.Muted,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -44, 1, -44),
		Size = UDim2.fromOffset(44, 44),
		Visible = false,
	}, card)
	studioBridge.ResizeGrip = grip
	connect(grip.InputBegan, function(input: InputObject)
		if windowsPinned or transitioning then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.Touch
			and input.UserInputType ~= Enum.UserInputType.MouseButton1
		then
			return
		end
		resizeInput = input
		origin = Vector2.new(input.Position.X, input.Position.Y)
		startSize = Vector2.new(appearance.Width, appearance.Height)
		drag = nil
	end)
	connect(UserInputService.InputChanged, function(input: InputObject)
		if not resizeInput or windowsPinned then
			return
		end
		local matchesMouse = resizeInput.UserInputType
				== Enum.UserInputType.MouseButton1
			and input.UserInputType == Enum.UserInputType.MouseMovement
		if input ~= resizeInput and not matchesMouse then
			return
		end
		local delta = (Vector2.new(input.Position.X, input.Position.Y) - origin)
			/ responsiveScale.Scale
		appearance.Width = math.clamp(startSize.X + delta.X, 280, 720)
		appearance.Height = math.clamp(startSize.Y + delta.Y, 320, 720)
		layout()
	end)
	connect(UserInputService.InputEnded, function(input: InputObject)
		if input ~= resizeInput then
			return
		end
		resizeInput = nil
		if studioBridge.Resized then
			studioBridge.Resized(appearance.Width, appearance.Height)
		end
	end)
	connect(UserInputService.WindowFocusReleased, function()
		resizeInput = nil
	end)
end

-- Lazy, self-contained Design Studio. No assets, files, or network calls.
do
	local studio: { [string]: any } = {}
	studio.SchemaVersion = 1
	studio.HistoryLimit = 24
	studio.InputLimit = 8192
	studio.Themes = {
		{
			Name = "Violet",
			Description = "The original Nullx11 signature.",
			RGB = {
				167,
				146,
				255,
			},
		},
		{
			Name = "Mint",
			Description = "A calm green accent for dark surfaces.",
			RGB = {
				126,
				222,
				185,
			},
		},
		{
			Name = "Ice",
			Description = "Crisp blue with a cool technical feel.",
			RGB = {
				129,
				200,
				255,
			},
		},
		{
			Name = "Rose",
			Description = "Soft pink for a warmer workspace.",
			RGB = {
				247,
				153,
				189,
			},
		},
		{
			Name = "Amber",
			Description = "A warm, readable golden highlight.",
			RGB = {
				246,
				194,
				107,
			},
		},
		{
			Name = "Coral",
			Description = "An energetic peach-red accent.",
			RGB = {
				246,
				153,
				130,
			},
		},
		{
			Name = "Lavender",
			Description = "A lighter, understated purple.",
			RGB = {
				197,
				173,
				246,
			},
		},
		{
			Name = "Cyan",
			Description = "Bright aqua for a clean instrument panel.",
			RGB = {
				108,
				221,
				225,
			},
		},
		{
			Name = "Lime",
			Description = "A soft botanical green, not neon.",
			RGB = {
				186,
				219,
				128,
			},
		},
		{
			Name = "Pearl",
			Description = "A near-neutral monochrome accent.",
			RGB = {
				218,
				220,
				234,
			},
		},
		{
			Name = "Orchid",
			Description = "Pink-purple for a more expressive look.",
			RGB = {
				222,
				155,
				237,
			},
		},
		{
			Name = "Sky",
			Description = "A soft blue-violet alternative.",
			RGB = {
				160,
				183,
				249,
			},
		},
	}
	studio.Schema = {
		{
			Key = "Theme",
			Page = "Color",
			Kind = "choice",
			Title = "Accent library",
			Hint = "Select a preset; custom RGB takes priority when enabled.",
			Default = "Violet",
			Options = {
				"Violet",
				"Mint",
				"Ice",
				"Rose",
				"Amber",
				"Coral",
				"Lavender",
				"Cyan",
				"Lime",
				"Pearl",
				"Orchid",
				"Sky",
			},
		},
		{
			Key = "CustomAccent",
			Page = "Color",
			Kind = "toggle",
			Title = "Use custom RGB",
			Hint = "Use the three channel controls below instead of a preset.",
			Default = false,
		},
		{
			Key = "Red",
			Page = "Color",
			Kind = "number",
			Title = "Red channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 167,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "Green",
			Page = "Color",
			Kind = "number",
			Title = "Green channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 146,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "Blue",
			Page = "Color",
			Kind = "number",
			Title = "Blue channel",
			Hint = "Each channel is clamped to the standard 0–255 RGB range.",
			Default = 255,
			Minimum = 0,
			Maximum = 255,
			Step = 5,
			Unit = "",
		},
		{
			Key = "PanelOpacity",
			Page = "Color",
			Kind = "number",
			Title = "Window opacity",
			Hint = "Backgrounds only; text and controls stay readable.",
			Default = 100,
			Minimum = 65,
			Maximum = 100,
			Step = 5,
			Unit = "%",
		},
		{
			Key = "DockOpacity",
			Page = "Color",
			Kind = "number",
			Title = "Dock opacity",
			Hint = "Tune the floating launcher independently of other windows.",
			Default = 100,
			Minimum = 60,
			Maximum = 100,
			Step = 5,
			Unit = "%",
		},
		{
			Key = "CornerScale",
			Page = "Color",
			Kind = "number",
			Title = "Corner roundness",
			Hint = "Scale existing corners without changing layout dimensions.",
			Default = 1,
			Minimum = 0,
			Maximum = 1.5,
			Step = 0.1,
			Unit = "×",
		},
		{
			Key = "BorderWeight",
			Page = "Color",
			Kind = "number",
			Title = "Border weight",
			Hint = "Zero hides outlines; other values scale their baseline thickness.",
			Default = 1,
			Minimum = 0,
			Maximum = 2.5,
			Step = 0.25,
			Unit = "×",
		},
		{
			Key = "Gradients",
			Page = "Color",
			Kind = "toggle",
			Title = "Surface gradients",
			Hint = "Switch decorative UI gradients on or off.",
			Default = true,
		},
		{
			Key = "HighContrast",
			Page = "Type",
			Kind = "toggle",
			Title = "Brighter secondary text",
			Hint = "Increase muted-text contrast against the dark background.",
			Default = false,
		},
		{
			Key = "Font",
			Page = "Type",
			Kind = "choice",
			Title = "Body typeface",
			Hint = "Choose a built-in Roblox font; no external assets are fetched.",
			Default = "Gotham",
			Options = {
				"Gotham",
				"SourceSans",
				"Arial",
				"Code",
				"Pixel",
				"Medieval",
			},
		},
		{
			Key = "TextScale",
			Page = "Type",
			Kind = "number",
			Title = "Text size",
			Hint = "Scale baseline text sizes with sensible readability limits.",
			Default = 1,
			Minimum = 0.9,
			Maximum = 1.25,
			Step = 0.05,
			Unit = "×",
		},
		{
			Key = "PreserveMono",
			Page = "Type",
			Kind = "toggle",
			Title = "Keep technical text monospace",
			Hint = "Preserve Code-font titles, coordinates, and FPS labels.",
			Default = true,
		},
		{
			Key = "HeaderTag",
			Page = "Type",
			Kind = "toggle",
			Title = "Header edition label",
			Hint = "Show the small CLIENT / WORKSPACE label beneath the title.",
			Default = true,
		},
		{
			Key = "Footer",
			Page = "Type",
			Kind = "toggle",
			Title = "Workspace footer",
			Hint = "Show the small identity label at the bottom of the dashboard.",
			Default = true,
		},
		{
			Key = "Status",
			Page = "Type",
			Kind = "toggle",
			Title = "Loading and status strip",
			Hint = "Show status messages and the progress line on the dashboard.",
			Default = true,
		},
		{
			Key = "Hints",
			Page = "Type",
			Kind = "toggle",
			Title = "Setting descriptions",
			Hint = "Show explanatory text beneath Design Studio setting titles.",
			Default = true,
		},
		{
			Key = "FocusOutlines",
			Page = "Type",
			Kind = "toggle",
			Title = "Keyboard focus outline",
			Hint = "Highlight selected Studio buttons for keyboard and gamepad navigation.",
			Default = true,
		},
		{
			Key = "LargeTargets",
			Page = "Type",
			Kind = "toggle",
			Title = "Larger Studio controls",
			Hint = "Increase Studio button height from 44 to 52 pixels.",
			Default = false,
		},
		{
			Key = "Scale",
			Page = "Layout",
			Kind = "number",
			Title = "Interface scale",
			Hint = "Safe-area clamping still limits the effective on-screen size.",
			Default = 1,
			Minimum = 0.75,
			Maximum = 1.2,
			Step = 0.05,
			Unit = "×",
		},
		{
			Key = "Width",
			Page = "Layout",
			Kind = "number",
			Title = "Preferred dashboard width",
			Hint = "The resize grip changes the same setting. Small screens still clamp it.",
			Default = 440,
			Minimum = 280,
			Maximum = 720,
			Step = 20,
			Unit = " px",
		},
		{
			Key = "Height",
			Page = "Layout",
			Kind = "number",
			Title = "Preferred dashboard height",
			Hint = "Scrollable pages remain usable when the viewport is shorter.",
			Default = 520,
			Minimum = 320,
			Maximum = 720,
			Step = 20,
			Unit = " px",
		},
		{
			Key = "DockSize",
			Page = "Layout",
			Kind = "number",
			Title = "Floating dock size",
			Hint = "Keep the launcher at least 48 pixels wide for touch.",
			Default = 60,
			Minimum = 48,
			Maximum = 80,
			Step = 4,
			Unit = " px",
		},
		{
			Key = "DockShape",
			Page = "Layout",
			Kind = "choice",
			Title = "Dock silhouette",
			Hint = "Change only the launcher corner shape.",
			Default = "Squircle",
			Options = {
				"Square",
				"Squircle",
				"Round",
			},
		},
		{
			Key = "IconStyle",
			Page = "Layout",
			Kind = "choice",
			Title = "Monogram treatment",
			Hint = "Cut includes the signature slash; Split emphasizes twin pillars.",
			Default = "Cut",
			Options = {
				"Cut",
				"Plain",
				"Split",
			},
		},
		{
			Key = "DockCaption",
			Page = "Layout",
			Kind = "toggle",
			Title = "Dock micro-label",
			Hint = "Show the small 11 / caption below the icon.",
			Default = true,
		},
		{
			Key = "DockDot",
			Page = "Layout",
			Kind = "toggle",
			Title = "Dock status dot",
			Hint = "Keep the small dashboard-open indicator visible.",
			Default = true,
		},
		{
			Key = "Snap",
			Page = "Layout",
			Kind = "toggle",
			Title = "Snap dock to a side",
			Hint = "Snap to the nearest left/right safe-area edge after a drag.",
			Default = false,
		},
		{
			Key = "Locked",
			Page = "Layout",
			Kind = "toggle",
			Title = "Lock window dragging",
			Hint = "Lock panels and the resize grip; the recovery dock stays movable.",
			Default = false,
		},
		{
			Key = "Hotkey",
			Page = "Layout",
			Kind = "choice",
			Title = "Dashboard shortcut",
			Hint = "Ignored while typing or after Roblox processes the key.",
			Default = "RightShift",
			Options = {
				"RightShift",
				"LeftAlt",
				"F4",
				"Home",
			},
		},
		{
			Key = "HUDWidth",
			Page = "Layout",
			Kind = "number",
			Title = "Coordinate HUD width",
			Hint = "Give long coordinates more horizontal space.",
			Default = 224,
			Minimum = 200,
			Maximum = 360,
			Step = 16,
			Unit = " px",
		},
		{
			Key = "CoordinatePrecision",
			Page = "Layout",
			Kind = "number",
			Title = "Coordinate decimals",
			Hint = "Choose how many decimal places the live HUD displays.",
			Default = 1,
			Minimum = 0,
			Maximum = 2,
			Step = 1,
			Unit = "",
		},
		{
			Key = "StudioWidth",
			Page = "Layout",
			Kind = "number",
			Title = "Design Studio width",
			Hint = "A preference, not a forced size; it always fits the safe area.",
			Default = 620,
			Minimum = 320,
			Maximum = 900,
			Step = 40,
			Unit = " px",
		},
		{
			Key = "StudioHeight",
			Page = "Layout",
			Kind = "number",
			Title = "Design Studio height",
			Hint = "The setting pages scroll independently of the window.",
			Default = 600,
			Minimum = 320,
			Maximum = 800,
			Step = 40,
			Unit = " px",
		},
		{
			Key = "RestorePage",
			Page = "Layout",
			Kind = "toggle",
			Title = "Remember Studio category",
			Hint = "Reopen the last category during this run.",
			Default = true,
		},
		{
			Key = "ReducedMotion",
			Page = "Motion",
			Kind = "toggle",
			Title = "Reduced motion",
			Hint = "Disable tween duration and turn off the glitch title.",
			Default = false,
		},
		{
			Key = "Glitch",
			Page = "Motion",
			Kind = "toggle",
			Title = "Glitch title",
			Hint = "Short RGB-split bursts; requires reduced motion to be off.",
			Default = true,
		},
		{
			Key = "MotionSpeed",
			Page = "Motion",
			Kind = "number",
			Title = "Transition duration",
			Hint = "A multiplier, not an artificial loading delay.",
			Default = 1,
			Minimum = 0.5,
			Maximum = 1.75,
			Step = 0.25,
			Unit = "×",
		},
		{
			Key = "Easing",
			Page = "Motion",
			Kind = "choice",
			Title = "Transition easing",
			Hint = "All transitions keep the same outward easing direction.",
			Default = "Quint",
			Options = {
				"Quint",
				"Quad",
				"Cubic",
				"Sine",
				"Linear",
			},
		},
		{
			Key = "GlitchInterval",
			Page = "Motion",
			Kind = "number",
			Title = "Time between glitches",
			Hint = "Longer intervals keep the title quieter.",
			Default = 3.6,
			Minimum = 2,
			Maximum = 10,
			Step = 0.4,
			Unit = " s",
		},
		{
			Key = "GlitchDuration",
			Page = "Motion",
			Kind = "number",
			Title = "Glitch burst length",
			Hint = "Bounded short bursts rather than a constant animation.",
			Default = 0.14,
			Minimum = 0.06,
			Maximum = 0.22,
			Step = 0.02,
			Unit = " s",
		},
		{
			Key = "GlitchOffset",
			Page = "Motion",
			Kind = "number",
			Title = "RGB split distance",
			Hint = "Horizontal displacement of the two colored text layers.",
			Default = 2,
			Minimum = 1,
			Maximum = 4,
			Step = 1,
			Unit = " px",
		},
		{
			Key = "FPSGraph",
			Page = "Motion",
			Kind = "toggle",
			Title = "FPS history bars",
			Hint = "Keep the FPS number while optionally hiding its graph.",
			Default = true,
		},
		{
			Key = "FPSInterval",
			Page = "Motion",
			Kind = "number",
			Title = "FPS sample window",
			Hint = "A smaller interval refreshes faster but gives a noisier reading.",
			Default = 0.5,
			Minimum = 0.25,
			Maximum = 1,
			Step = 0.25,
			Unit = " s",
		},
		{
			Key = "TelemetryInterval",
			Page = "Motion",
			Kind = "number",
			Title = "Coordinate sample window",
			Hint = "Controls live-coordinate, distance, and session-label refreshes.",
			Default = 0.5,
			Minimum = 0.25,
			Maximum = 1,
			Step = 0.25,
			Unit = " s",
		},
	}
	studio.Presets = {
		{
			Name = "Signature",
			Description = "Original violet with balanced dimensions.",
			Values = {
				Theme = "Violet",
				CustomAccent = false,
				Font = "Gotham",
				TextScale = 1,
				Scale = 1,
				CornerScale = 1,
				Gradients = true,
				ReducedMotion = false,
				Glitch = true,
			},
		},
		{
			Name = "Quiet",
			Description = "Less motion and less decoration.",
			Values = {
				Theme = "Pearl",
				CustomAccent = false,
				Gradients = false,
				ReducedMotion = true,
				Glitch = false,
				DockCaption = false,
				HeaderTag = false,
				BorderWeight = 0.75,
			},
		},
		{
			Name = "Touch",
			Description = "Larger touch controls and readable text.",
			Values = {
				Theme = "Mint",
				CustomAccent = false,
				LargeTargets = true,
				TextScale = 1.1,
				DockSize = 72,
				StudioWidth = 480,
				Width = 400,
				Snap = true,
			},
		},
		{
			Name = "Terminal",
			Description = "Monospace text with sharp, restrained surfaces.",
			Values = {
				Theme = "Lime",
				CustomAccent = false,
				Font = "Code",
				CornerScale = 0.2,
				Gradients = false,
				Glitch = false,
				BorderWeight = 0.75,
			},
		},
		{
			Name = "Contrast",
			Description = "Brighter labels, clear outlines, and no motion.",
			Values = {
				Theme = "Ice",
				CustomAccent = false,
				HighContrast = true,
				TextScale = 1.1,
				BorderWeight = 1.5,
				ReducedMotion = true,
				Glitch = false,
				LargeTargets = true,
			},
		},
		{
			Name = "Compact",
			Description = "A smaller workspace that leaves room for the game.",
			Values = {
				Theme = "Sky",
				CustomAccent = false,
				Scale = 0.85,
				Width = 360,
				Height = 440,
				DockSize = 48,
				HeaderTag = false,
				Footer = false,
			},
		},
		{
			Name = "Soft",
			Description = "Rounded surfaces with gentle transitions.",
			Values = {
				Theme = "Rose",
				CustomAccent = false,
				CornerScale = 1.4,
				BorderWeight = 0.5,
				Easing = "Sine",
				MotionSpeed = 1.25,
				Glitch = false,
			},
		},
		{
			Name = "Instrument",
			Description = "Frequent instrument refreshes and a wider HUD.",
			Values = {
				Theme = "Cyan",
				CustomAccent = false,
				FPSGraph = true,
				FPSInterval = 0.25,
				TelemetryInterval = 0.25,
				HUDWidth = 280,
				CoordinatePrecision = 2,
				Glitch = false,
			},
		},
		{
			Name = "Pixel",
			Description = "Aurora cyan, crisp pixel headings, readable modern body.",
			Values = {
				Theme = "Cyan",
				CustomAccent = false,
				Font = "Pixel",
				HighContrast = true,
				CornerScale = 0.6,
				BorderWeight = 1.25,
				TextScale = 1.1,
				Gradients = true,
			},
		},
		{
			Name = "Citadel",
			Description = "Amber-lit gothic headings over obsidian surfaces.",
			Values = {
				Theme = "Amber",
				CustomAccent = false,
				Font = "Medieval",
				HighContrast = true,
				CornerScale = 0.7,
				BorderWeight = 1.25,
				TextScale = 1.1,
				Gradients = true,
			},
		},
	}

	studio.ByKey = {}
	studio.Defaults = {}
	studio.Settings = {}
	studio.UndoStack = {}
	studio.RedoStack = {}
	studio.Saved = {}
	studio.Rows = {}
	studio.Pages = {}
	studio.Refreshers = {}
	studio.StyleCache = {}
	studio.FocusStrokes = {}
	studio.Built = false
	studio.ActivePage = "Color"
	studio.Query = ""
	studio.Applying = false
	studio.Fonts = {
		Gotham = Enum.Font.Gotham,
		SourceSans = Enum.Font.SourceSans,
		Arial = Enum.Font.Arial,
		Code = Enum.Font.Code,
		Pixel = Enum.Font.Arcade,
		Medieval = Enum.Font.GrenzeGotisch,
	}
	studio.Easings = {
		Quint = Enum.EasingStyle.Quint,
		Quad = Enum.EasingStyle.Quad,
		Cubic = Enum.EasingStyle.Cubic,
		Sine = Enum.EasingStyle.Sine,
		Linear = Enum.EasingStyle.Linear,
	}
	studio.Keys = {
		RightShift = Enum.KeyCode.RightShift,
		LeftAlt = Enum.KeyCode.LeftAlt,
		F4 = Enum.KeyCode.F4,
		Home = Enum.KeyCode.Home,
	}
	for _, field in ipairs(studio.Schema) do
		studio.ByKey[field.Key] = field
		studio.Defaults[field.Key] = field.Default
		studio.Settings[field.Key] = field.Default
	end

	function studio.Copy(values: { [string]: any }): { [string]: any }
		local result = {}
		for key, value in pairs(values) do
			result[key] = value
		end
		return result
	end

	function studio.Same(
		left: { [string]: any },
		right: { [string]: any }
	): boolean
		for _, field in ipairs(studio.Schema) do
			if left[field.Key] ~= right[field.Key] then
				return false
			end
		end
		return true
	end

	function studio.Theme(name: string): any
		for _, theme in ipairs(studio.Themes) do
			if theme.Name == name then
				return theme
			end
		end
		return studio.Themes[1]
	end

	function studio.Accent(values: { [string]: any }): Color3
		if values.CustomAccent then
			return Color3.fromRGB(values.Red, values.Green, values.Blue)
		end
		local theme = studio.Theme(values.Theme)
		return Color3.fromRGB(theme.RGB[1], theme.RGB[2], theme.RGB[3])
	end

	function studio.SameColor(left: Color3, right: Color3): boolean
		local tolerance = 1 / 510
		return math.abs(left.R - right.R) < tolerance
			and math.abs(left.G - right.G) < tolerance
			and math.abs(left.B - right.B) < tolerance
	end

	function studio.Message(text: string, failed: boolean?)
		if not alive then
			return
		end
		if studio.MessageLabel then
			studio.MessageLabel.Text = text
			studio.MessageLabel.TextColor3 = if failed
				then colors.Error
				else colors.Muted
		end
	end

	function studio.Validate(patch: any): (boolean, any)
		if type(patch) ~= "table" then
			return false, "Settings must be an object."
		end
		local clean = {}
		local count = 0
		for key, value in pairs(patch) do
			if type(key) ~= "string" then
				return false, "Setting names must be strings."
			end
			local field = studio.ByKey[key]
			if not field then
				return false, "Unknown setting: " .. key
			end
			if field.Kind == "toggle" then
				if type(value) ~= "boolean" then
					return false, field.Title .. " must be true or false."
				end
			elseif field.Kind == "number" then
				if
					type(value) ~= "number"
					or value ~= value
					or math.abs(value) == math.huge
				then
					return false, field.Title .. " needs a finite number."
				end
				if value < field.Minimum or value > field.Maximum then
					return false,
						string.format(
							"%s must be between %s and %s.",
							field.Title,
							field.Minimum,
							field.Maximum
						)
				end
				-- Pixel counts, channels, and precision must remain integral.
				if field.Step >= 1 and value % 1 ~= 0 then
					return false, field.Title .. " needs a whole number."
				end
			elseif field.Kind == "choice" then
				local recognized = false
				for _, option in ipairs(field.Options) do
					if value == option then
						recognized = true
						break
					end
				end
				if not recognized then
					return false, "Unsupported " .. field.Title .. " value."
				end
			end
			clean[key] = value
			count += 1
		end
		if count == 0 then
			return false, "There are no settings to apply."
		end
		return true, clean
	end

	function studio.CaptureStyles()
		for _, object in ipairs(gui:GetDescendants()) do
			if studio.StyleCache[object] then
				continue
			end
			local baseline = {}
			if
				object:IsA("TextLabel")
				or object:IsA("TextButton")
				or object:IsA("TextBox")
			then
				baseline.TextSize = object.TextSize
				baseline.Font = object.Font
			elseif object:IsA("UICorner") then
				baseline.Radius = object.CornerRadius.Offset
			elseif object:IsA("UIStroke") then
				baseline.Thickness = object.Thickness
			elseif object:IsA("UIGradient") then
				baseline.Enabled = object.Enabled
			else
				continue
			end
			studio.StyleCache[object] = baseline
		end
	end

	function studio.ReadRuntime()
		local values = studio.Settings
		values.Scale = interfaceScale
		values.Width = math.floor(appearance.Width + 0.5)
		values.Height = math.floor(appearance.Height + 0.5)
		values.Locked = windowsPinned
		values.Snap = snapDockToEdge
		values.ReducedMotion = CONFIG.ReducedMotion
		values.Glitch = glitchEnabled and not CONFIG.ReducedMotion
		if not studio.SameColor(studio.Accent(values), CONFIG.Accent) then
			values.Red = math.floor(CONFIG.Accent.R * 255 + 0.5)
			values.Green = math.floor(CONFIG.Accent.G * 255 + 0.5)
			values.Blue = math.floor(CONFIG.Accent.B * 255 + 0.5)
			values.CustomAccent = true
			for _, theme in ipairs(studio.Themes) do
				local color =
					Color3.fromRGB(theme.RGB[1], theme.RGB[2], theme.RGB[3])
				if studio.SameColor(color, CONFIG.Accent) then
					values.Theme = theme.Name
					values.CustomAccent = false
					break
				end
			end
		end
	end

	function studio.RecolorMuted(brighter: boolean)
		local old = colors.Muted
		local target = if brighter
			then Color3.fromRGB(195, 197, 214)
			else Color3.fromRGB(178, 190, 211)
		if studio.SameColor(old, target) then
			return
		end
		colors.Muted = target
		for _, object in ipairs(gui:GetDescendants()) do
			if
				object:IsA("TextLabel")
				or object:IsA("TextButton")
				or object:IsA("TextBox")
			then
				if object.TextColor3 == old then
					object.TextColor3 = target
				end
				if
					object:IsA("TextBox")
					and object.PlaceholderColor3 == old
				then
					object.PlaceholderColor3 = target
				end
			end
		end
	end

	function studio.Render(values: { [string]: any })
		if not alive then
			return
		end
		local accent = studio.Accent(values)
		if
			not studio.SameColor(accent, CONFIG.Accent) and studioBridge.Accent
		then
			studioBridge.Accent(
				accent,
				if values.CustomAccent then "Custom RGB" else values.Theme
			)
		end
		studio.RecolorMuted(values.HighContrast)
		for object, baseline in pairs(studio.StyleCache) do
			if object.Parent == nil then
				continue
			end
			if baseline.TextSize then
				object.TextSize =
					math.clamp(baseline.TextSize * values.TextScale, 14, 40)
				if values.Font == "Pixel" or values.Font == "Medieval" then
					object.Font = if baseline.TextSize >= 18
						then studio.Fonts[values.Font]
						else Enum.Font.Gotham
				elseif
					values.PreserveMono and baseline.Font == Enum.Font.Code
				then
					object.Font = Enum.Font.Code
				elseif
					values.Font == "Gotham"
					and baseline.Font ~= Enum.Font.Code
				then
					object.Font = baseline.Font
				else
					object.Font = studio.Fonts[values.Font]
				end
			elseif baseline.Radius then
				object.CornerRadius = UDim.new(
					0,
					math.clamp(baseline.Radius * values.CornerScale, 0, 36)
				)
			elseif baseline.Thickness then
				if object.Name == "StudioFocus" then
					object.Thickness = baseline.Thickness
					if not values.FocusOutlines then
						object.Transparency = 1
					end
				else
					object.Thickness = baseline.Thickness * values.BorderWeight
				end
			elseif baseline.Enabled ~= nil then
				object.Enabled = values.Gradients and baseline.Enabled
			end
		end
		for _, window in ipairs({
			card,
			teleportPanel,
			fpsPanel,
			coordinatePanel,
			studio.Window,
		}) do
			window.BackgroundTransparency = 1 - values.PanelOpacity / 100
		end
		appearance.DockOpacity = values.DockOpacity
		if playerToolsBridge.Style then
			playerToolsBridge.Style(values)
		end
		mini.BackgroundTransparency = 1 - values.DockOpacity / 100
		mini.Size = UDim2.fromOffset(values.DockSize, values.DockSize)
		local dockCorner = mini:FindFirstChildOfClass("UICorner")
		if dockCorner then
			local radius = if values.DockShape == "Round"
				then values.DockSize / 2
				elseif values.DockShape == "Square" then 7
				else values.DockSize * 0.32
			dockCorner.CornerRadius = UDim.new(0, radius)
		end
		for _, icon in ipairs(gui:GetDescendants()) do
			if icon:IsA("Frame") and icon.Name == "Nullx11Icon" then
				if icon.Parent == mini then
					icon.Position = UDim2.fromOffset(
						(values.DockSize - 30) / 2,
						(values.DockSize - 30) / 2 - 3
					)
				end
				for _, stroke in ipairs(icon:GetChildren()) do
					if
						stroke:IsA("GuiObject")
						and stroke.Name == "SignatureCut"
					then
						stroke.Visible = values.IconStyle == "Cut"
					elseif
						stroke:IsA("GuiObject")
						and stroke.Name == "BrandStroke2"
					then
						stroke.Visible = values.IconStyle ~= "Split"
					end
				end
			end
		end
		dockCaption.Position = UDim2.new(0, 0, 1, -17)
		dockCaption.Visible = values.DockCaption
		dockDot.Visible = values.DockDot
		edition.Visible = values.HeaderTag
		footer.Visible = values.Footer
		status.Visible = values.Status
		progressTrack.Visible = values.Status
		interfaceScale = values.Scale
		appearance.Width = values.Width
		appearance.Height = values.Height
		appearance.Duration = values.MotionSpeed
		appearance.Easing = studio.Easings[values.Easing]
		appearance.ToggleKey = studio.Keys[values.Hotkey]
		appearance.GlitchInterval = values.GlitchInterval
		appearance.GlitchDuration = values.GlitchDuration
		appearance.GlitchOffset = values.GlitchOffset
		appearance.FPSInterval = values.FPSInterval
		appearance.TelemetryInterval = values.TelemetryInterval
		appearance.FPSGraph = values.FPSGraph
		appearance.FPSHeight = if values.FPSGraph then 64 else 48
		appearance.HUDWidth = values.HUDWidth
		local decimals = tostring(values.CoordinatePrecision)
		appearance.CoordinateFormat = "X %."
			.. decimals
			.. "f  Y %."
			.. decimals
			.. "f  Z %."
			.. decimals
			.. "f"
		fpsPanel.Size = UDim2.fromOffset(132, appearance.FPSHeight)
		coordinatePanel.Size = UDim2.fromOffset(appearance.HUDWidth, 48)
		for i, bar in ipairs(fpsBars) do
			bar.Visible = values.FPSGraph
				and fpsEnabled
				and fpsHistory[i] ~= nil
		end
		if
			CONFIG.ReducedMotion ~= values.ReducedMotion and studioBridge.Motion
		then
			studioBridge.Motion(values.ReducedMotion)
		end
		if glitchEnabled ~= values.Glitch then
			setGlitchEnabled(values.Glitch)
		end
		if windowsPinned ~= values.Locked and studioBridge.Lock then
			studioBridge.Lock(values.Locked)
		end
		if snapDockToEdge ~= values.Snap and studioBridge.Snap then
			studioBridge.Snap(values.Snap)
		end
		if studio.Settings.ReducedMotion then
			resetTitle()
		end
		layout()
		if studio.Relayout then
			studio.Relayout()
		end
		for _, refresh in ipairs(studio.Refreshers) do
			refresh()
		end
		studio.Filter()
	end

	function studio.Apply(patch: any, reason: string): boolean
		if not alive or studio.Applying then
			return false
		end
		local valid, clean = studio.Validate(patch)
		if not valid then
			studio.Message(clean, true)
			return false
		end
		local previous = studio.Copy(studio.Settings)
		local nextValues = studio.Copy(previous)
		for key, value in pairs(clean) do
			nextValues[key] = value
		end
		if clean.Theme ~= nil and clean.CustomAccent == nil then
			nextValues.CustomAccent = false
		end
		if nextValues.ReducedMotion then
			if clean.Glitch == true then
				studio.Message(
					"Turn reduced motion off before enabling the glitch title.",
					true
				)
				return false
			end
			nextValues.Glitch = false
		end
		if studio.Same(previous, nextValues) then
			studio.Message("Already using those values.")
			return true
		end
		studio.Applying = true
		studio.Settings = nextValues
		local ok, issue = pcall(studio.Render, nextValues)
		if not ok then
			studio.Settings = previous
			pcall(studio.Render, previous)
			studio.Applying = false
			studio.Message(
				"Could not apply this change; previous settings restored.",
				true
			)
			warn("[Nullx11] Design Studio: " .. tostring(issue))
			return false
		end
		table.insert(studio.UndoStack, {
			Name = reason,
			Values = previous,
		})
		if #studio.UndoStack > studio.HistoryLimit then
			table.remove(studio.UndoStack, 1)
		end
		table.clear(studio.RedoStack)
		studio.Applying = false
		studio.UpdateHistoryButtons()
		studio.Message(reason)
		return true
	end

	function studio.TravelHistory(backward: boolean)
		if studio.Applying then
			return
		end
		local source = if backward then studio.UndoStack else studio.RedoStack
		local target = if backward then studio.RedoStack else studio.UndoStack
		if #source == 0 then
			studio.Message(
				if backward then "Nothing to undo." else "Nothing to redo."
			)
			return
		end
		local entry = source[#source]
		local previous = studio.Copy(studio.Settings)
		studio.Settings = studio.Copy(entry.Values)
		studio.Applying = true
		local ok, issue = pcall(studio.Render, studio.Settings)
		if not ok then
			studio.Settings = previous
			pcall(studio.Render, previous)
			studio.Applying = false
			studio.Message("History change could not be applied.", true)
			warn("[Nullx11] History: " .. tostring(issue))
			return
		end
		table.remove(source)
		table.insert(target, {
			Name = entry.Name,
			Values = previous,
		})
		studio.Applying = false
		studio.UpdateHistoryButtons()
		studio.Message(
			(if backward then "Undid: " else "Redid: ") .. entry.Name
		)
	end

	function studio.Export(): string?
		local service = game:GetService("HttpService")
		local ok, encoded = pcall(function()
			return service:JSONEncode({
				Version = studio.SchemaVersion,
				Settings = studio.Copy(studio.Settings),
			})
		end)
		if not ok then
			studio.Message("Could not encode this design.", true)
			return nil
		end
		return encoded
	end

	function studio.Import(source: string): boolean
		if #source == 0 or #source > studio.InputLimit then
			studio.Message("Paste a design between 1 and 8192 bytes.", true)
			return false
		end
		local service = game:GetService("HttpService")
		local ok, decoded = pcall(function()
			return service:JSONDecode(source)
		end)
		if not ok or type(decoded) ~= "table" then
			studio.Message("That is not a valid design JSON object.", true)
			return false
		end
		for key in pairs(decoded) do
			if key ~= "Version" and key ~= "Settings" then
				studio.Message(
					"Unexpected design field: " .. tostring(key),
					true
				)
				return false
			end
		end
		if decoded.Version ~= studio.SchemaVersion then
			studio.Message(
				"This design uses an unsupported format version.",
				true
			)
			return false
		end
		return studio.Apply(decoded.Settings, "Imported design settings.")
	end

	function studio.Focusable(button: GuiObject)
		local outline = create("UIStroke", {
			Name = "StudioFocus",
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = CONFIG.Accent,
			Thickness = 1.5,
			Transparency = 1,
		}, button)
		studio.FocusStrokes[button] = outline
		connect(button.SelectionGained, function()
			if studio.Settings.FocusOutlines then
				outline.Color = CONFIG.Accent
				tween(outline, {
					Transparency = 0,
				})
			end
		end)
		connect(button.SelectionLost, function()
			tween(outline, {
				Transparency = 1,
			})
		end)
		if button:IsA("TextBox") then
			connect(button.Focused, function()
				if studio.Settings.FocusOutlines then
					outline.Color = CONFIG.Accent
					outline.Transparency = 0
				end
			end)
			connect(button.FocusLost, function()
				outline.Transparency = 1
			end)
		end
	end

	function studio.Button(
		parent: Instance,
		name: string,
		text: string,
		position: UDim2,
		size: UDim2,
		callback: () -> ()
	): TextButton
		local button = create("TextButton", {
			Name = name,
			Text = text,
			TextSize = 12,
			TextWrapped = true,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = position,
			Size = size,
		}, parent)
		corner(button, 9)
		studio.Focusable(button)
		connect(button.Activated, function()
			if alive then
				callback()
			end
		end)
		connect(button.MouseEnter, function()
			tween(button, {
				BackgroundTransparency = 0.2,
			})
		end)
		connect(button.MouseLeave, function()
			tween(button, {
				BackgroundTransparency = 0,
			})
		end)
		return button
	end

	function studio.Text(
		parent: Instance,
		name: string,
		text: string,
		size: number,
		position: UDim2,
		bounds: UDim2
	): TextLabel
		local textLabel = label(parent, text, size, colors.Text)
		textLabel.Name = name
		textLabel.Position = position
		textLabel.Size = bounds
		textLabel.TextWrapped = true
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		return textLabel
	end

	function studio.Input(
		parent: Instance,
		name: string,
		placeholder: string,
		position: UDim2,
		size: UDim2
	): TextBox
		local box = create("TextBox", {
			Name = name,
			Text = "",
			PlaceholderText = placeholder,
			TextColor3 = colors.Text,
			PlaceholderColor3 = colors.Muted,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			ClearTextOnFocus = false,
			MultiLine = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = position,
			Size = size,
		}, parent)
		corner(box, 9)
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}, box)
		studio.Focusable(box)
		return box
	end

	function studio.Row(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		controlRows: number
	): any
		local page = studio.Pages[pageName]
		local row = create("Frame", {
			Name = "DesignRow_" .. key,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -4, 0, 120),
		}, page.Body)
		local heading = studio.Text(
			row,
			"DesignTitle_" .. key,
			titleText,
			13,
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 22)
		)
		heading.Font = Enum.Font.GothamMedium
		local hint = studio.Text(
			row,
			"DesignHint_" .. key,
			hintText,
			10,
			UDim2.fromOffset(0, 24),
			UDim2.new(1, 0, 0, 36)
		)
		hint.TextColor3 = colors.Muted
		local holder = create("Frame", {
			Name = "DesignControls_" .. key,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 64),
			Size = UDim2.new(1, 0, 0, controlRows * 50),
		}, row)
		local metadata = {
			Key = key,
			Page = pageName,
			Search = string.lower(titleText .. " " .. hintText .. " " .. key),
			Frame = row,
			Heading = heading,
			Hint = hint,
			Holder = holder,
			ControlRows = controlRows,
			Controls = {},
			Paragraph = false,
		}
		table.insert(studio.Rows, metadata)
		return metadata
	end

	function studio.Control(
		metadata: any,
		object: GuiObject,
		rowIndex: number,
		columnIndex: number,
		columns: number
	)
		table.insert(metadata.Controls, {
			Object = object,
			Row = rowIndex,
			Column = columnIndex,
			Columns = columns,
		})
	end

	function studio.Format(field: any, value: number): string
		local shown = string.format("%.2f", value)
		shown = string.gsub(shown, "0+$", "")
		shown = string.gsub(shown, "%.$", "")
		return shown .. (field.Unit or "")
	end

	function studio.NumberField(field: any)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, 1)
		local down = studio.Button(
			metadata.Holder,
			"DesignMinus_" .. field.Key,
			"−",
			UDim2.fromOffset(0, 0),
			UDim2.fromOffset(44, 44),
			function()
				local value = math.max(
					field.Minimum,
					studio.Settings[field.Key] - field.Step
				)
				value = math.floor(value * 1000 + 0.5) / 1000
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. " decreased."
				)
			end
		)
		local valueText = studio.Text(
			metadata.Holder,
			"DesignValue_" .. field.Key,
			"",
			14,
			UDim2.fromOffset(52, 12),
			UDim2.new(1, -104, 0, 24)
		)
		valueText.Font = Enum.Font.Code
		valueText.TextXAlignment = Enum.TextXAlignment.Center
		local up = studio.Button(
			metadata.Holder,
			"DesignPlus_" .. field.Key,
			"+",
			UDim2.new(1, -44, 0, 0),
			UDim2.fromOffset(44, 44),
			function()
				local value = math.min(
					field.Maximum,
					studio.Settings[field.Key] + field.Step
				)
				value = math.floor(value * 1000 + 0.5) / 1000
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. " increased."
				)
			end
		)
		metadata.Stepper = {
			Down = down,
			Up = up,
			Value = valueText,
		}
		table.insert(studio.Refreshers, function()
			local value = studio.Settings[field.Key]
			valueText.Text = studio.Format(field, value)
			down.TextColor3 = if value <= field.Minimum
				then colors.Muted
				else colors.Text
			up.TextColor3 = if value >= field.Maximum
				then colors.Muted
				else colors.Text
		end)
	end

	function studio.ChoiceField(field: any)
		local columns = math.min(3, #field.Options)
		local rows = math.ceil(#field.Options / columns)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, rows)
		local buttons = {}
		for index, option in ipairs(field.Options) do
			local value = option
			local button = studio.Button(
				metadata.Holder,
				"DesignChoice_" .. field.Key .. "_" .. value,
				value,
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					studio.Apply(
						{ [field.Key] = value },
						field.Title .. ": " .. value
					)
				end
			)
			studio.Control(
				metadata,
				button,
				math.floor((index - 1) / columns),
				(index - 1) % columns,
				columns
			)
			buttons[value] = button
		end
		table.insert(studio.Refreshers, function()
			for value, button in pairs(buttons) do
				local selected = studio.Settings[field.Key] == value
				button.BackgroundColor3 = if selected
					then CONFIG.Accent
					else colors.Surface
				button.TextColor3 = if selected
					then colors.Panel
					else colors.Text
				if field.Key == "Theme" and studio.Settings.CustomAccent then
					button.BackgroundColor3 = colors.Surface
					button.TextColor3 = colors.Text
				end
			end
		end)
	end

	function studio.ToggleField(field: any)
		local metadata =
			studio.Row(field.Page, field.Key, field.Title, field.Hint, 1)
		local button = studio.Button(
			metadata.Holder,
			"DesignToggle_" .. field.Key,
			"",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 44),
			function()
				local value = not studio.Settings[field.Key]
				studio.Apply(
					{ [field.Key] = value },
					field.Title .. (if value then " enabled." else " disabled.")
				)
			end
		)
		studio.Control(metadata, button, 0, 0, 1)
		table.insert(studio.Refreshers, function()
			local enabled = studio.Settings[field.Key]
			button.Text = if enabled
				then "ON  /  tap to disable"
				else "OFF  /  tap to enable"
			button.TextColor3 = if enabled then CONFIG.Accent else colors.Muted
		end)
	end

	function studio.Paragraph(
		pageName: string,
		key: string,
		titleText: string,
		bodyText: string,
		height: number
	)
		local metadata = studio.Row(pageName, key, titleText, bodyText, 0)
		metadata.Paragraph = true
		metadata.ParagraphHeight = height
		metadata.Hint.Size = UDim2.new(1, 0, 0, height - 30)
		metadata.Hint.TextSize = 12
		metadata.Hint.TextColor3 = colors.Muted
		metadata.Holder.Visible = false
	end

	function studio.Action(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		caption: string,
		callback: () -> ()
	): TextButton
		local metadata = studio.Row(pageName, key, titleText, hintText, 1)
		local button = studio.Button(
			metadata.Holder,
			"DesignAction_" .. key,
			caption,
			UDim2.fromOffset(0, 0),
			UDim2.new(1, 0, 0, 44),
			callback
		)
		studio.Control(metadata, button, 0, 0, 1)
		return button
	end

	function studio.Filter()
		if not studio.Built then
			return
		end
		local query = string.lower(studio.Query)
		for name, page in pairs(studio.Pages) do
			local cursor = 0
			local matches = 0
			for _, metadata in ipairs(studio.Rows) do
				if metadata.Page ~= name then
					continue
				end
				local show = query == ""
					or string.find(metadata.Search, query, 1, true) ~= nil
				metadata.Frame.Visible = show
				if not show then
					continue
				end
				local controlHeight = if studio.Settings.LargeTargets
					then 52
					else 44
				local hintSpace = if studio.Settings.Hints then 64 else 30
				local height = hintSpace
					+ metadata.ControlRows * (controlHeight + 6)
					+ 14
				metadata.Hint.Visible = studio.Settings.Hints
					or metadata.Paragraph
				if metadata.Paragraph then
					height = metadata.ParagraphHeight + 16
				end
				metadata.Frame.Position = UDim2.fromOffset(0, cursor)
				metadata.Frame.Size = UDim2.new(1, -4, 0, height)
				metadata.Holder.Position = UDim2.fromOffset(0, hintSpace)
				metadata.Holder.Size = UDim2.new(
					1,
					0,
					0,
					metadata.ControlRows * (controlHeight + 6)
				)
				for _, control in ipairs(metadata.Controls) do
					control.Object.Position = UDim2.new(
						control.Column / control.Columns,
						0,
						0,
						control.Row * (controlHeight + 6)
					)
					control.Object.Size =
						UDim2.new(1 / control.Columns, -6, 0, controlHeight)
				end
				if metadata.Stepper then
					metadata.Stepper.Down.Size =
						UDim2.fromOffset(controlHeight, controlHeight)
					metadata.Stepper.Up.Position =
						UDim2.new(1, -controlHeight, 0, 0)
					metadata.Stepper.Up.Size =
						UDim2.fromOffset(controlHeight, controlHeight)
					metadata.Stepper.Value.Position =
						UDim2.fromOffset(controlHeight + 6, 12)
					metadata.Stepper.Value.Size =
						UDim2.new(1, -2 * (controlHeight + 6), 0, 26)
				end
				cursor += height
				matches += 1
			end
			page.Body.CanvasSize = UDim2.fromOffset(0, cursor + 8)
			page.Empty.Visible = matches == 0
			page.Count = matches
		end
	end

	function studio.Select(pageName: string)
		if not studio.Pages[pageName] then
			return
		end
		studio.ActivePage = pageName
		for name, page in pairs(studio.Pages) do
			local selected = name == pageName
			page.Body.Visible = selected
			page.Button.BackgroundColor3 = if selected
				then CONFIG.Accent
				else colors.Surface
			page.Button.TextColor3 = if selected
				then colors.Panel
				else colors.Muted
		end
		studio.Filter()
		if studio.UpdateMap then
			studio.UpdateMap()
		end
	end

	function studio.UpdateHistoryButtons()
		if not studio.UndoButton then
			return
		end
		studio.UndoButton.Text = "Undo " .. #studio.UndoStack
		studio.RedoButton.Text = "Redo " .. #studio.RedoStack
		studio.UndoButton.TextColor3 = if #studio.UndoStack > 0
			then colors.Text
			else colors.Muted
		studio.RedoButton.TextColor3 = if #studio.RedoStack > 0
			then colors.Text
			else colors.Muted
		if studio.RefreshDiagnostics then
			studio.RefreshDiagnostics()
		end
	end

	function studio.BuildWindow()
		studio.Window = create("Frame", {
			Name = "DesignStudio",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(620, 600),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(studio.Window, 18)
		create("UIStroke", {
			Name = "StudioBorder",
			Color = colors.Border,
			Thickness = 1,
		}, studio.Window)
		create("UIGradient", {
			Color = ColorSequence.new(colors.Panel, Color3.fromRGB(28, 27, 39)),
			Rotation = 120,
		}, studio.Window)
		local handle = create("Frame", {
			Name = "DesignDragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, -64, 0, 66),
		}, studio.Window)
		drawIcon(handle, CONFIG.Accent, UDim2.fromOffset(18, 20), 26)
		local titleLabel = studio.Text(
			handle,
			"DesignHeading",
			"Design Studio",
			18,
			UDim2.fromOffset(56, 17),
			UDim2.new(1, -56, 0, 26)
		)
		titleLabel.Font = Enum.Font.GothamBold
		local subtitleLabel = studio.Text(
			handle,
			"DesignSubheading",
			"NULLX11 / MAKE IT YOURS",
			9,
			UDim2.fromOffset(56, 45),
			UDim2.new(1, -56, 0, 16)
		)
		subtitleLabel.TextColor3 = colors.Muted
		subtitleLabel.Font = Enum.Font.Code
		studio.Button(
			studio.Window,
			"DesignClose",
			"×",
			UDim2.new(1, -58, 0, 12),
			UDim2.fromOffset(44, 44),
			function()
				portal.Play(studio.Window, false)
			end
		)
		local navigation = create("ScrollingFrame", {
			Name = "DesignNavigation",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(18, 74),
			Size = UDim2.new(1, -36, 0, 46),
			CanvasSize = UDim2.fromOffset(606, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, studio.Window)
		for index, name in ipairs({
			"Color",
			"Type",
			"Layout",
			"Motion",
			"Profiles",
			"Help",
		}) do
			local pageName = name
			local button = studio.Button(
				navigation,
				"DesignTab_" .. pageName,
				pageName,
				UDim2.fromOffset((index - 1) * 102, 0),
				UDim2.fromOffset(96, 42),
				function()
					studio.Select(pageName)
				end
			)
			local body = create("ScrollingFrame", {
				Name = "DesignPage_" .. pageName,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(18, 184),
				Size = UDim2.new(1, -36, 1, -266),
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = CONFIG.Accent,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Visible = false,
			}, studio.Window)
			local empty = studio.Text(
				body,
				"DesignEmpty_" .. pageName,
				"No settings match. Try a shorter search.",
				12,
				UDim2.fromOffset(0, 8),
				UDim2.new(1, -8, 0, 48)
			)
			empty.TextColor3 = colors.Muted
			empty.Visible = false
			studio.Pages[pageName] = {
				Button = button,
				Body = body,
				Empty = empty,
				Count = 0,
			}
		end
		studio.Search = studio.Input(
			studio.Window,
			"DesignSearch",
			"Search this category…",
			UDim2.fromOffset(18, 130),
			UDim2.new(1, -36, 0, 42)
		)
		connect(studio.Search:GetPropertyChangedSignal("Text"), function()
			-- Bounded plain substring matching: user input is never a Lua pattern.
			studio.Query = string.sub(studio.Search.Text, 1, 80)
			studio.Filter()
		end)
		create("Frame", {
			BackgroundColor3 = colors.Border,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 18, 1, -72),
			Size = UDim2.new(1, -36, 0, 1),
		}, studio.Window)
		studio.MessageLabel = studio.Text(
			studio.Window,
			"DesignMessage",
			"Changes stay in memory until you export them.",
			10,
			UDim2.new(0, 18, 1, -62),
			UDim2.new(1, -210, 0, 50)
		)
		studio.MessageLabel.TextColor3 = colors.Muted
		studio.UndoButton = studio.Button(
			studio.Window,
			"DesignUndo",
			"Undo 0",
			UDim2.new(1, -184, 1, -58),
			UDim2.fromOffset(78, 44),
			function()
				studio.TravelHistory(true)
			end
		)
		studio.RedoButton = studio.Button(
			studio.Window,
			"DesignRedo",
			"Redo 0",
			UDim2.new(1, -98, 1, -58),
			UDim2.fromOffset(78, 44),
			function()
				studio.TravelHistory(false)
			end
		)
		local previousExtras = layoutExtras
		studio.Relayout = function()
			local viewport = root.AbsoluteSize
			if viewport.X <= 0 or viewport.Y <= 0 then
				return
			end
			local width = math.min(
				studio.Settings.StudioWidth,
				math.max(1, viewport.X - 24)
			)
			local height = math.min(
				studio.Settings.StudioHeight,
				math.max(1, viewport.Y - 24)
			)
			studio.Window.Size = UDim2.fromOffset(width, height)
			local center = clampCenter(
				extraCenters[studio.Window] or viewport / 2,
				Vector2.new(width, height)
			)
			extraCenters[studio.Window] = center
			studio.Window.Position = UDim2.fromOffset(center.X, center.Y)
		end
		layoutExtras = function()
			if previousExtras then
				previousExtras()
			end
			studio.Relayout()
		end
		draggable(handle, studio.Window)
	end

	function studio.Editor(
		pageName: string,
		key: string,
		titleText: string,
		hintText: string,
		rows: number,
		editable: boolean
	): TextBox
		local metadata = studio.Row(pageName, key, titleText, hintText, rows)
		local scroller = create("ScrollingFrame", {
			Name = "DesignEditorScroll_" .. key,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, metadata.Holder)
		local box = studio.Input(
			scroller,
			"DesignEditor_" .. key,
			if editable then "Paste or type here…" else "Nothing to show yet.",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, -6, 1, -6)
		)
		box.AutomaticSize = Enum.AutomaticSize.Y
		box.Size = UDim2.new(1, -8, 0, math.max(44, rows * 50 - 6))
		box.MultiLine = true
		box.TextEditable = editable
		box.TextWrapped = true
		box.TextYAlignment = Enum.TextYAlignment.Top
		box.TextSize = 11
		box.Font = Enum.Font.Code
		create("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		}, box)
		return box
	end

	function studio.Differences(
		left: { [string]: any },
		right: { [string]: any }
	): string
		local differences = {}
		for _, field in ipairs(studio.Schema) do
			local from = left[field.Key]
			local to = right[field.Key]
			if from ~= to then
				table.insert(
					differences,
					string.format(
						"%s: %s → %s",
						field.Title,
						tostring(from),
						tostring(to)
					)
				)
			end
		end
		if #differences == 0 then
			return "No differences."
		end
		return table.concat(differences, "\n")
	end

	function studio.BuildInspector()
		local summary = studio.Editor(
			"Profiles",
			"Inspector",
			"Current design summary",
			"Read-only values. No player identity, locations, or game data are exported.",
			4,
			false
		)
		table.insert(studio.Refreshers, function()
			local lines = {}
			for _, field in ipairs(studio.Schema) do
				table.insert(
					lines,
					field.Title .. ": " .. tostring(studio.Settings[field.Key])
				)
			end
			summary.Text = table.concat(lines, "\n")
		end)
		local history = studio.Editor(
			"Profiles",
			"History",
			"Recent changes",
			"Undo history is capped at 24 snapshots; a new change clears redo.",
			3,
			false
		)
		studio.HistoryEditor = history
		studio.Action(
			"Profiles",
			"RefreshHistory",
			"Review undo history",
			"The newest reversible change is listed first.",
			"Refresh change list",
			function()
				local entries = {}
				for index = #studio.UndoStack, 1, -1 do
					table.insert(entries, studio.UndoStack[index].Name)
				end
				history.Text = if #entries > 0
					then table.concat(entries, "\n")
					else "No Studio changes recorded."
			end
		)
	end

	function studio.BuildColorPreview()
		local metadata = studio.Row(
			"Color",
			"Preview",
			"Live accent preview",
			"Changes below affect your existing windows, not a separate mockup.",
			2
		)
		local sample = create("Frame", {
			Name = "DesignPreview",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
		}, metadata.Holder)
		corner(sample, 12)
		local tile = create("Frame", {
			Name = "DesignSwatch",
			BackgroundColor3 = CONFIG.Accent,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 14),
			Size = UDim2.fromOffset(46, 46),
		}, sample)
		corner(tile, 13)
		drawIcon(tile, colors.Panel, UDim2.fromOffset(8, 8), 30)
		local name = studio.Text(
			sample,
			"DesignPreviewName",
			CONFIG.Name,
			18,
			UDim2.fromOffset(74, 14),
			UDim2.new(1, -88, 0, 26)
		)
		name.Font = Enum.Font.Code
		local channels = studio.Text(
			sample,
			"DesignPreviewRGB",
			"",
			11,
			UDim2.fromOffset(74, 47),
			UDim2.new(1, -88, 0, 38)
		)
		channels.TextColor3 = colors.Muted
		channels.Font = Enum.Font.Code
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			tile.BackgroundColor3 = accent
			channels.Text = string.format(
				"RGB %d / %d / %d",
				math.floor(accent.R * 255 + 0.5),
				math.floor(accent.G * 255 + 0.5),
				math.floor(accent.B * 255 + 0.5)
			)
		end)
	end

	function studio.BuildPresetLibrary()
		studio.Paragraph(
			"Profiles",
			"PresetIntro",
			"Start with a design recipe",
			"Recipes change only the listed style preferences. Your bookmarks, running tools, and window positions are not deleted. Undo restores the previous settings.",
			124
		)
		for _, preset in ipairs(studio.Presets) do
			local recipe = preset
			studio.Action(
				"Profiles",
				"Preset_" .. recipe.Name,
				recipe.Name,
				recipe.Description,
				"Apply " .. recipe.Name,
				function()
					studio.Apply(
						recipe.Values,
						recipe.Name .. " recipe applied."
					)
				end
			)
		end
	end

	function studio.CleanName(source: string, fallback: string): string
		local value = string.gsub(source, "%c", " ")
		value = string.match(value, "^%s*(.-)%s*$") or ""
		local length = utf8.len(value)
		if not length or length == 0 then
			return fallback
		end
		if length > 24 then
			local boundary = utf8.offset(value, 25)
			if boundary then
				value = string.sub(value, 1, boundary - 1)
			end
		end
		return value
	end

	function studio.SaveSlot(index: number, name: string)
		studio.Saved[index] = {
			Name = studio.CleanName(name, "Design " .. index),
			Values = studio.Copy(studio.Settings),
		}
		studio.Message(name .. " saved in memory.")
	end

	function studio.LoadSlot(index: number)
		local entry = studio.Saved[index]
		if not entry then
			studio.Message("Save a design in this slot first.", true)
			return
		end
		studio.Apply(entry.Values, "Loaded " .. entry.Name .. ".")
	end

	function studio.BuildMemorySlots()
		studio.Paragraph(
			"Profiles",
			"MemoryIntro",
			"Three local design slots",
			"These hold appearance settings, not teleport positions. Slots stay available while the loader is running and are cleared when it closes. Export JSON if you want to keep a design outside this run.",
			144
		)
		for index = 1, 3 do
			local slotIndex = index
			local metadata = studio.Row(
				"Profiles",
				"SlotName" .. index,
				"Design slot " .. index,
				"Give this in-memory design a short name before saving.",
				1
			)
			local name = studio.Input(
				metadata.Holder,
				"DesignSlotName" .. index,
				"Design name",
				UDim2.fromOffset(0, 0),
				UDim2.new(1, -6, 0, 44)
			)
			name.Text = "Design " .. index
			studio.Control(metadata, name, 0, 0, 1)
			connect(name.FocusLost, function()
				name.Text = studio.CleanName(name.Text, "Design " .. slotIndex)
			end)
			local actions = studio.Row(
				"Profiles",
				"SlotActions" .. index,
				"Save, load, or compare slot " .. index,
				"Compare shows differences without applying them.",
				1
			)
			local save = studio.Button(
				actions.Holder,
				"DesignSave" .. index,
				"Save",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local caption =
						studio.CleanName(name.Text, "Design " .. slotIndex)
					studio.SaveSlot(slotIndex, caption)
				end
			)
			studio.Control(actions, save, 0, 0, 3)
			local load = studio.Button(
				actions.Holder,
				"DesignLoad" .. index,
				"Load",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					studio.LoadSlot(slotIndex)
				end
			)
			studio.Control(actions, load, 0, 1, 3)
			local compare = studio.Button(
				actions.Holder,
				"DesignCompare" .. index,
				"Compare",
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local entry = studio.Saved[slotIndex]
					if not entry then
						studio.Message("This design slot is empty.", true)
						return
					end
					studio.Comparison.Text =
						studio.Differences(studio.Settings, entry.Values)
					studio.Message(
						"Comparison generated; scroll to the comparison panel."
					)
				end
			)
			studio.Control(actions, compare, 0, 2, 3)
		end
		studio.Comparison = studio.Editor(
			"Profiles",
			"Comparison",
			"Design comparison",
			"Current values are on the left; saved values are on the right.",
			4,
			false
		)
	end

	function studio.BuildTransfer()
		studio.Transfer = studio.Editor(
			"Profiles",
			"Transfer",
			"Design JSON",
			"Select/copy the text manually. Import accepts settings only, never code or remote URLs.",
			5,
			true
		)
		studio.Action(
			"Profiles",
			"Export",
			"Export current design",
			"Writes a versioned settings object into the text field above. Nothing is written to disk or clipboard automatically.",
			"Generate JSON",
			function()
				local encoded = studio.Export()
				if encoded then
					studio.Transfer.Text = encoded
					studio.Message(
						"Design generated. Select the JSON text to copy it."
					)
				end
			end
		)
		studio.Action(
			"Profiles",
			"Import",
			"Import design JSON",
			"All fields are checked before a change is applied. Unknown settings, bad versions, and out-of-range values are rejected.",
			"Validate and import",
			function()
				studio.Import(studio.Transfer.Text)
			end
		)
		studio.Action(
			"Profiles",
			"CompareDefaults",
			"Compare against defaults",
			"Review what you changed without resetting anything.",
			"Show default differences",
			function()
				studio.Comparison.Text =
					studio.Differences(studio.Defaults, studio.Settings)
				studio.Message("Default comparison generated.")
			end
		)
		local resetUntil = 0
		local resetButton: TextButton? = nil
		resetButton = studio.Action(
			"Profiles",
			"ResetAll",
			"Reset all appearance settings",
			"Tap twice within three seconds. Bookmarks and saved design slots are not deleted. This reset can be undone.",
			"Reset appearance",
			function()
				if not resetButton then
					return
				end
				if resetUntil == 0 or os.clock() > resetUntil then
					resetUntil = os.clock() + 3
					resetButton.Text = "Tap again within 3 seconds"
					studio.Message(
						"Confirm reset, or wait three seconds to cancel."
					)
					return
				end
				resetUntil = 0
				resetButton.Text = "Reset appearance"
				studio.Apply(studio.Defaults, "Appearance reset to defaults.")
			end
		)
	end

	function studio.Arrange(mode: string)
		local viewport = root.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		local center = viewport / 2
		if mode == "Left" then
			panelCenter = Vector2.new(card.AbsoluteSize.X / 2 + 12, center.Y)
		elseif mode == "Right" then
			panelCenter =
				Vector2.new(viewport.X - card.AbsoluteSize.X / 2 - 12, center.Y)
		elseif mode == "Stack" then
			extraCenters[fpsPanel] = Vector2.new(viewport.X - 90, 48)
			extraCenters[coordinatePanel] = Vector2.new(viewport.X - 140, 120)
			extraCenters[teleportPanel] = Vector2.new(viewport.X - 180, 340)
		else
			panelCenter = nil
			miniCenter = nil
			table.clear(extraCenters)
		end
		drag = nil
		layout()
		studio.Message(
			"Window arrangement updated; small screens may overlap panels."
		)
	end

	function studio.BuildArrangements()
		studio.Action(
			"Layout",
			"ArrangeLeft",
			"Dashboard on the left",
			"Keep the main panel toward the left safe-area edge.",
			"Align dashboard left",
			function()
				studio.Arrange("Left")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeRight",
			"Dashboard on the right",
			"Keep the main panel toward the right safe-area edge.",
			"Align dashboard right",
			function()
				studio.Arrange("Right")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeStack",
			"Utility stack",
			"Place FPS, coordinates, and bookmarks down the right side. This does not enable disabled utilities.",
			"Stack floating utilities",
			function()
				studio.Arrange("Stack")
			end
		)
		studio.Action(
			"Layout",
			"ArrangeReset",
			"Recover window positions",
			"Recenter panels and restore the default dock position without altering their dimensions.",
			"Recover all windows",
			function()
				studio.Arrange("Reset")
			end
		)
	end

	function studio.Luminance(color: Color3): number
		local function linear(channel: number): number
			if channel <= 0.04045 then
				return channel / 12.92
			end
			return ((channel + 0.055) / 1.055) ^ 2.4
		end
		return 0.2126 * linear(color.R)
			+ 0.7152 * linear(color.G)
			+ 0.0722 * linear(color.B)
	end

	function studio.Contrast(first: Color3, second: Color3): number
		local a = studio.Luminance(first)
		local b = studio.Luminance(second)
		return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05)
	end

	function studio.HSV(color: Color3): (number, number, number)
		local maximum = math.max(color.R, color.G, color.B)
		local minimum = math.min(color.R, color.G, color.B)
		local delta = maximum - minimum
		local saturation = if maximum == 0 then 0 else delta / maximum
		local hue = 0
		if delta > 0 then
			if maximum == color.R then
				hue = ((color.G - color.B) / delta) % 6
			elseif maximum == color.G then
				hue = (color.B - color.R) / delta + 2
			else
				hue = (color.R - color.G) / delta + 4
			end
			hue = (hue / 6) % 1
		end
		return hue, saturation, maximum
	end

	function studio.FromHSV(
		hue: number,
		saturation: number,
		value: number
	): Color3
		hue = hue % 1
		saturation = math.clamp(saturation, 0, 1)
		value = math.clamp(value, 0, 1)
		local sector = math.floor(hue * 6)
		local fraction = hue * 6 - sector
		local low = value * (1 - saturation)
		local falling = value * (1 - fraction * saturation)
		local rising = value * (1 - (1 - fraction) * saturation)
		local red, green, blue
		if sector == 0 then
			red, green, blue = value, rising, low
		elseif sector == 1 then
			red, green, blue = falling, value, low
		elseif sector == 2 then
			red, green, blue = low, value, rising
		elseif sector == 3 then
			red, green, blue = low, falling, value
		elseif sector == 4 then
			red, green, blue = rising, low, value
		else
			red, green, blue = value, low, falling
		end
		return Color3.new(red, green, blue)
	end

	function studio.UseColor(color: Color3, reason: string)
		studio.Apply({
			CustomAccent = true,
			Red = math.floor(color.R * 255 + 0.5),
			Green = math.floor(color.G * 255 + 0.5),
			Blue = math.floor(color.B * 255 + 0.5),
		}, reason)
	end

	function studio.BuildColorTools()
		local metadata = studio.Row(
			"Color",
			"Tints",
			"Tint and shade ladder",
			"Choose a related custom accent. The middle swatch is the current accent.",
			2
		)
		local tintButtons = {}
		local strengths = { -0.3, -0.15, 0, 0.15, 0.3 }
		for index, amount in ipairs(strengths) do
			local strength = amount
			local button = studio.Button(
				metadata.Holder,
				"DesignTint" .. index,
				if amount == 0
					then "Current"
					else string.format("%+d%%", amount * 100),
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local accent = studio.Accent(studio.Settings)
					local target = if strength < 0
						then Color3.new(0, 0, 0)
						else Color3.new(1, 1, 1)
					studio.UseColor(
						accent:Lerp(target, math.abs(strength)),
						"Related accent selected."
					)
				end
			)
			studio.Control(
				metadata,
				button,
				math.floor((index - 1) / 3),
				(index - 1) % 3,
				3
			)
			tintButtons[index] = button
		end
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			for index, amount in ipairs(strengths) do
				local target = if amount < 0
					then Color3.new(0, 0, 0)
					else Color3.new(1, 1, 1)
				local mixed = accent:Lerp(target, math.abs(amount))
				tintButtons[index].BackgroundColor3 = mixed
				tintButtons[index].TextColor3 = if studio.Contrast(
						mixed,
						colors.Panel
					) >= 4.5
					then colors.Panel
					else colors.Text
			end
		end)
		local harmony = studio.Row(
			"Color",
			"Harmony",
			"Hue adjustments",
			"Rotate the current hue while retaining saturation and brightness.",
			1
		)
		for index, adjustment in ipairs({
			{
				Name = "WarmTurn",
				Caption = "−30°",
				Delta = -1 / 12,
			},
			{
				Name = "Complement",
				Caption = "+180°",
				Delta = 0.5,
			},
			{
				Name = "CoolTurn",
				Caption = "+30°",
				Delta = 1 / 12,
			},
		}) do
			local change = adjustment
			local button = studio.Button(
				harmony.Holder,
				"DesignHue_" .. change.Name,
				change.Caption,
				UDim2.fromOffset(0, 0),
				UDim2.fromOffset(44, 44),
				function()
					local hue, saturation, value =
						studio.HSV(studio.Accent(studio.Settings))
					studio.UseColor(
						studio.FromHSV(hue + change.Delta, saturation, value),
						"Accent hue rotated."
					)
				end
			)
			studio.Control(harmony, button, 0, index - 1, 3)
		end
		studio.Action(
			"Color",
			"SoftenAccent",
			"Soften the current accent",
			"Reduce saturation by ten percent without changing hue or brightness.",
			"Reduce saturation",
			function()
				local hue, saturation, value =
					studio.HSV(studio.Accent(studio.Settings))
				studio.UseColor(
					studio.FromHSV(hue, saturation - 0.1, value),
					"Accent softened."
				)
			end
		)
	end

	function studio.BuildContrastReadout()
		local box = studio.Editor(
			"Color",
			"Contrast",
			"Contrast reference",
			"Calculated against opaque base colors. Transparent backgrounds and gameplay can change actual contrast.",
			4,
			false
		)
		table.insert(studio.Refreshers, function()
			local accent = studio.Accent(studio.Settings)
			local readings = {
				{
					Name = "Accent / panel",
					First = accent,
					Second = colors.Panel,
				},
				{
					Name = "Accent / surface",
					First = accent,
					Second = colors.Surface,
				},
				{
					Name = "Primary text / panel",
					First = colors.Text,
					Second = colors.Panel,
				},
				{
					Name = "Secondary text / panel",
					First = colors.Muted,
					Second = colors.Panel,
				},
			}
			local lines = {}
			for _, reading in ipairs(readings) do
				local ratio = studio.Contrast(reading.First, reading.Second)
				local note = if ratio >= 4.5
					then ">= 4.5 reference"
					else "below 4.5 reference"
				table.insert(
					lines,
					string.format("%s: %.2f:1 (%s)", reading.Name, ratio, note)
				)
			end
			table.insert(
				lines,
				"Reference only; not an accessibility certification."
			)
			box.Text = table.concat(lines, "\n")
		end)
	end

	function studio.BuildTypographyPreview()
		local metadata = studio.Row(
			"Type",
			"TypographyPreview",
			"Reading preview",
			"Font and text scale apply to these real labels as well as your workspace.",
			4
		)
		local surface = create("Frame", {
			Name = "DesignTypePreview",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, -6),
		}, metadata.Holder)
		corner(surface, 12)
		local heading = studio.Text(
			surface,
			"DesignTypeHeading",
			"Aa Bb Cc 123",
			22,
			UDim2.fromOffset(14, 14),
			UDim2.new(1, -28, 0, 40)
		)
		heading.Font = Enum.Font.GothamBold
		studio.Text(
			surface,
			"DesignTypeBody",
			"A quiet interface should remain easy to read while the game is moving behind it.",
			13,
			UDim2.fromOffset(14, 62),
			UDim2.new(1, -28, 0, 64)
		)
		local technical = studio.Text(
			surface,
			"DesignTypeCode",
			"X 128.4  Y 32.0  Z -64.2\n60 FPS / LOCAL SESSION",
			12,
			UDim2.fromOffset(14, 138),
			UDim2.new(1, -28, 0, 54)
		)
		technical.Font = Enum.Font.Code
		technical.TextColor3 = CONFIG.Accent
	end

	function studio.BuildDiagnostics()
		local diagnostics = studio.Editor(
			"Help",
			"Diagnostics",
			"Interface diagnostics",
			"A local snapshot of UI dimensions and settings, not an executor or server capability test.",
			4,
			false
		)
		studio.RefreshDiagnostics = function()
			if not studio.Window then
				return
			end
			local viewport = root.AbsoluteSize
			local changed = 0
			for _, field in ipairs(studio.Schema) do
				if studio.Settings[field.Key] ~= studio.Defaults[field.Key] then
					changed += 1
				end
			end
			diagnostics.Text = table.concat({
				string.format(
					"Safe area: %.0f x %.0f px",
					viewport.X,
					viewport.Y
				),
				string.format(
					"Dashboard: %.0f x %.0f px",
					card.AbsoluteSize.X,
					card.AbsoluteSize.Y
				),
				string.format(
					"Studio: %.0f x %.0f px",
					studio.Window.AbsoluteSize.X,
					studio.Window.AbsoluteSize.Y
				),
				string.format(
					"Changed settings: %d / %d",
					changed,
					#studio.Schema
				),
				string.format(
					"Undo: %d / %d",
					#studio.UndoStack,
					studio.HistoryLimit
				),
				string.format("GUI descendants: %d", #gui:GetDescendants()),
				"No filesystem or clipboard permissions are requested.",
			}, "\n")
		end
		table.insert(studio.Refreshers, studio.RefreshDiagnostics)
		studio.Action(
			"Help",
			"RefreshDiagnostics",
			"Refresh diagnostic snapshot",
			"Useful after rotating the device or moving panels. No network requests are made.",
			"Refresh local UI information",
			function()
				studio.RefreshDiagnostics()
				studio.Message("Local UI snapshot refreshed.")
			end
		)
	end

	function studio.BuildMotionRecipes()
		local recipes = {
			{
				Name = "Instant",
				Description = "No animated transitions or title glitches.",
				Values = {
					ReducedMotion = true,
					Glitch = false,
				},
			},
			{
				Name = "Snappy",
				Description = "Short cubic transitions without title distortion.",
				Values = {
					ReducedMotion = false,
					Glitch = false,
					MotionSpeed = 0.5,
					Easing = "Cubic",
				},
			},
			{
				Name = "Gentle",
				Description = "Longer sine easing and a calm, undistorted title.",
				Values = {
					ReducedMotion = false,
					Glitch = false,
					MotionSpeed = 1.5,
					Easing = "Sine",
				},
			},
			{
				Name = "Signature",
				Description = "The original short RGB split with quint easing.",
				Values = {
					ReducedMotion = false,
					Glitch = true,
					MotionSpeed = 1,
					Easing = "Quint",
					GlitchInterval = 3.6,
					GlitchDuration = 0.14,
					GlitchOffset = 2,
				},
			},
			{
				Name = "Occasional",
				Description = "An infrequent, small split for a quieter title.",
				Values = {
					ReducedMotion = false,
					Glitch = true,
					MotionSpeed = 1,
					Easing = "Quad",
					GlitchInterval = 8,
					GlitchDuration = 0.08,
					GlitchOffset = 1,
				},
			},
		}
		for _, recipe in ipairs(recipes) do
			local preset = recipe
			studio.Action(
				"Motion",
				"Motion_" .. preset.Name,
				preset.Name .. " motion",
				preset.Description,
				"Use " .. preset.Name,
				function()
					studio.Apply(
						preset.Values,
						preset.Name .. " motion applied."
					)
				end
			)
		end
	end

	function studio.BuildHexInput()
		local metadata = studio.Row(
			"Color",
			"HexInput",
			"Hexadecimal accent",
			"Accepts RGB or RRGGBB, with or without a leading #. Apply explicitly after editing.",
			1
		)
		local box = studio.Input(
			metadata.Holder,
			"DesignHexInput",
			"#A792FF",
			UDim2.fromOffset(0, 0),
			UDim2.new(1, -6, 0, 44)
		)
		box.Font = Enum.Font.Code
		studio.Control(metadata, box, 0, 0, 1)
		studio.Action(
			"Color",
			"ApplyHex",
			"Apply hex accent",
			"A malformed color leaves your existing design unchanged.",
			"Validate and use hex",
			function()
				local value = string.match(box.Text, "^%s*(.-)%s*$") or ""
				value = string.gsub(value, "^#", "")
				if not string.match(value, "^[%da-fA-F]+$") then
					studio.Message(
						"Use hexadecimal digits only, such as #A792FF.",
						true
					)
					return
				end
				if #value == 3 then
					value = string.sub(value, 1, 1)
						.. string.sub(value, 1, 1)
						.. string.sub(value, 2, 2)
						.. string.sub(value, 2, 2)
						.. string.sub(value, 3, 3)
						.. string.sub(value, 3, 3)
				elseif #value ~= 6 then
					studio.Message("Use exactly three or six hex digits.", true)
					return
				end
				local red = tonumber(string.sub(value, 1, 2), 16)
				local green = tonumber(string.sub(value, 3, 4), 16)
				local blue = tonumber(string.sub(value, 5, 6), 16)
				if not red or not green or not blue then
					studio.Message("Could not read that color.", true)
					return
				end
				studio.UseColor(
					Color3.fromRGB(red, green, blue),
					"Hex accent applied."
				)
			end
		)
		studio.Action(
			"Color",
			"ReadHex",
			"Read current accent as hex",
			"Writes the current accent into the input without changing any settings.",
			"Read accent",
			function()
				local color = studio.Accent(studio.Settings)
				box.Text = string.format(
					"#%02X%02X%02X",
					math.floor(color.R * 255 + 0.5),
					math.floor(color.G * 255 + 0.5),
					math.floor(color.B * 255 + 0.5)
				)
				studio.Message("Current accent copied into the hex input.")
			end
		)
	end

	function studio.BuildLayoutMap()
		local metadata = studio.Row(
			"Layout",
			"WindowMap",
			"Live window map",
			"A normalized safe-area diagram. Dim rectangles represent hidden panels. This preview does not capture the game screen.",
			5
		)
		local map = create("Frame", {
			Name = "DesignWindowMap",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.new(1, -6, 1, -6),
			ClipsDescendants = true,
		}, metadata.Holder)
		corner(map, 12)
		local safe = create("Frame", {
			Name = "DesignMapBounds",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(8, 8),
			Size = UDim2.new(1, -16, 1, -16),
		}, map)
		create("UIStroke", {
			Color = colors.Border,
			Thickness = 1,
		}, safe)
		local rectangles = {}
		for _, item in ipairs({
			{
				Name = "Dashboard",
				Target = card,
				Caption = "UI",
			},
			{
				Name = "Bookmarks",
				Target = teleportPanel,
				Caption = "SPOT",
			},
			{
				Name = "FPS",
				Target = fpsPanel,
				Caption = "FPS",
			},
			{
				Name = "Coordinates",
				Target = coordinatePanel,
				Caption = "XYZ",
			},
			{
				Name = "Dock",
				Target = mini,
				Caption = "N",
			},
		}) do
			local rectangle = create("Frame", {
				Name = "DesignMap_" .. item.Name,
				BackgroundColor3 = CONFIG.Accent,
				BackgroundTransparency = 0.4,
				BorderSizePixel = 0,
			}, safe)
			corner(rectangle, 3)
			local caption = studio.Text(
				rectangle,
				"DesignMapCaption_" .. item.Name,
				item.Caption,
				8,
				UDim2.fromScale(0, 0),
				UDim2.fromScale(1, 1)
			)
			caption.TextColor3 = colors.Panel
			caption.TextXAlignment = Enum.TextXAlignment.Center
			caption.TextYAlignment = Enum.TextYAlignment.Center
			table.insert(rectangles, {
				Target = item.Target,
				Rectangle = rectangle,
			})
		end
		studio.UpdateMap = function()
			if
				not studio.Window
				or not studio.Window.Visible
				or studio.ActivePage ~= "Layout"
			then
				return
			end
			local viewport = root.AbsoluteSize
			if viewport.X <= 0 or viewport.Y <= 0 then
				return
			end
			for _, entry in ipairs(rectangles) do
				local target = entry.Target
				local position = target.AbsolutePosition - root.AbsolutePosition
				local size = target.AbsoluteSize
				entry.Rectangle.Position = UDim2.fromScale(
					position.X / viewport.X,
					position.Y / viewport.Y
				)
				entry.Rectangle.Size =
					UDim2.fromScale(size.X / viewport.X, size.Y / viewport.Y)
				entry.Rectangle.BackgroundColor3 = CONFIG.Accent
				entry.Rectangle.BackgroundTransparency = if target.Visible
					then 0.35
					else 0.82
			end
		end
		for _, entry in ipairs(rectangles) do
			connect(
				entry.Target:GetPropertyChangedSignal("AbsolutePosition"),
				studio.UpdateMap
			)
			connect(
				entry.Target:GetPropertyChangedSignal("AbsoluteSize"),
				studio.UpdateMap
			)
			connect(
				entry.Target:GetPropertyChangedSignal("Visible"),
				studio.UpdateMap
			)
		end
		table.insert(studio.Refreshers, studio.UpdateMap)
	end

	function studio.BuildSlotManagement()
		studio.Paragraph(
			"Profiles",
			"SlotManagement",
			"Manage saved designs",
			"Deleting a design slot does not change your active appearance. The design-slot contents are separate from undo history and teleport bookmarks.",
			132
		)
		for index = 1, 3 do
			local slotIndex = index
			local deadline = 0
			local button: TextButton? = nil
			button = studio.Action(
				"Profiles",
				"DeleteSlot" .. index,
				"Delete design slot " .. index,
				"Confirm with a second tap within three seconds. This deletion cannot be undone.",
				"Delete slot " .. index,
				function()
					if not button then
						return
					end
					if not studio.Saved[slotIndex] then
						studio.Message("This design slot is already empty.")
						return
					end
					if deadline == 0 or os.clock() > deadline then
						deadline = os.clock() + 3
						button.Text = "Tap again within 3 seconds"
						return
					end
					deadline = 0
					studio.Saved[slotIndex] = nil
					button.Text = "Delete slot " .. slotIndex
					studio.Message(
						"Saved design slot " .. slotIndex .. " deleted."
					)
				end
			)
		end
	end

	function studio.BuildKeyboardShortcuts()
		studio.Paragraph(
			"Help",
			"StudioShortcuts",
			"Studio keyboard shortcuts",
			"When Studio is visible and no text field is focused: Ctrl+Z undoes, Ctrl+Y redoes, and Escape hides Studio. Processed input is ignored. The dashboard shortcut remains separate.",
			148
		)
		connect(
			UserInputService.InputBegan,
			function(input: InputObject, processed: boolean)
				if
					processed
					or not studio.Window
					or not studio.Window.Visible
				then
					return
				end
				if UserInputService:GetFocusedTextBox() then
					return
				end
				if input.KeyCode == Enum.KeyCode.Escape then
					portal.Play(studio.Window, false)
					return
				end
				local control = UserInputService:IsKeyDown(
					Enum.KeyCode.LeftControl
				) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
				if not control then
					return
				end
				if input.KeyCode == Enum.KeyCode.Z then
					studio.TravelHistory(true)
				elseif input.KeyCode == Enum.KeyCode.Y then
					studio.TravelHistory(false)
				end
			end
		)
	end

	studio.Guide = {
		{
			Key = "Welcome",
			Title = "A workspace, not a framework dependency",
			Body = "Design Studio edits the GUI already running in your PlayerGui. It uses Roblox UI primitives and built-in fonts. There are no hidden asset downloads, keys, or third-party UI libraries.",
			Height = 148,
		},
		{
			Key = "Navigation",
			Title = "Categories and search",
			Body = "Drag the header to move this window. Swipe the category strip horizontally on narrow phones. Search filters the current category by plain text; characters such as brackets and dots are not interpreted as patterns.",
			Height = 156,
		},
		{
			Key = "SafeAreas",
			Title = "Why a preferred size may look different",
			Body = "Width, height, and scale are preferences. The safe-area layout limits their effective size so controls stay reachable. Phone notches, top bars, orientation, and short landscape screens can reduce the available space.",
			Height = 156,
		},
		{
			Key = "Resize",
			Title = "Resize the main dashboard",
			Body = "After Load, drag the diagonal grip at the bottom-right of the dashboard with a mouse or finger. Window locking disables the grip. Preferred width and height update together; Studio can undo a completed resize after it has been opened.",
			Height = 164,
		},
		{
			Key = "Colors",
			Title = "Preset accents and custom RGB",
			Body = "Choose an accent preset or enable custom RGB. Channels remain in the standard 0–255 range. Selecting a named accent turns custom RGB off but keeps its stored channel values for later use.",
			Height = 148,
		},
		{
			Key = "Opacity",
			Title = "Readable transparency",
			Body = "Window opacity affects backgrounds, not text. Controls keep their own surfaces so labels remain legible against gameplay. The launcher has a separate opacity preference. Increasing transparency can reduce contrast in bright scenes.",
			Height = 156,
		},
		{
			Key = "Typography",
			Title = "Fonts and text scaling",
			Body = "Body fonts are built into Roblox. Keep technical text monospace to preserve the visual rhythm of coordinates and FPS. Large text may wrap; if a narrow label feels cramped, use a wider panel or reduce text scale.",
			Height = 156,
		},
		{
			Key = "Accessibility",
			Title = "Readability without relying on color",
			Body = "Brighter secondary text increases muted-label contrast. Focus outlines highlight selected Studio controls. The main switches keep ON/OFF labels, bookmark slots show EMPTY/SAVED, and large targets increase Studio button height.",
			Height = 164,
		},
		{
			Key = "Motion",
			Title = "Reduced motion has priority",
			Body = "Enabling reduced motion turns the glitch title off and makes future tweens immediate. Turn reduced motion off before enabling glitches again. Transition duration changes animations only; it never adds a loading delay.",
			Height = 156,
		},
		{
			Key = "Profiles",
			Title = "Recipes versus saved design slots",
			Body = "Recipes modify a specific subset of settings. A saved design slot stores the complete current appearance. Design slots are independent of teleport bookmarks and last only for the current running loader.",
			Height = 148,
		},
		{
			Key = "Undo",
			Title = "Bounded undo and redo",
			Body = "Studio retains at most 24 appearance snapshots. Undo restores one snapshot; redo reapplies it. A new successful Studio edit clears redo. Window dragging and utility activation are not appearance history entries.",
			Height = 156,
		},
		{
			Key = "Import",
			Title = "Settings data, never executable code",
			Body = "Import accepts a versioned JSON object up to 8192 bytes. Only known settings with valid types, choices, and ranges are accepted. It does not call loadstring, fetch URLs, execute functions, or import locations.",
			Height = 164,
		},
		{
			Key = "Persistence",
			Title = "What survives closing a window",
			Body = "Closing Studio hides its window and preserves its controls, history, and design slots for this run. Closing the main loader destroys everything. Copy exported JSON manually if you want to keep a design for a later run.",
			Height = 156,
		},
		{
			Key = "Performance",
			Title = "Update frequency and cost",
			Body = "FPS samples count real rendered frames. Smaller sample windows react faster but fluctuate more. Coordinate sampling also updates distance and the session label. No GUI objects are created by the frame-sampling callbacks.",
			Height = 156,
		},
		{
			Key = "Recovery",
			Title = "Recovering a busy layout",
			Body = "The dock remains draggable when windows are locked. Use the Session page or Layout recovery action to recenter windows. On small screens, arrangements may overlap; drag, hide, or close a utility to free space.",
			Height = 156,
		},
		{
			Key = "Runtime",
			Title = "Executor and Studio limits",
			Body = "The full script can run as a normal Studio LocalScript without an executor. External runtime compatibility depends on that runtime and the experience. Visuals, real touch input, and server acceptance of movement still require device testing.",
			Height = 164,
		},
	}

	function studio.BuildHelp()
		for _, guide in ipairs(studio.Guide) do
			studio.Paragraph(
				"Help",
				"Guide_" .. guide.Key,
				guide.Title,
				guide.Body,
				guide.Height
			)
		end
	end

	function studio.BuildCategoryResets()
		for _, pageName in ipairs({ "Color", "Type", "Layout", "Motion" }) do
			local category = pageName
			studio.Action(
				category,
				"ResetCategory_" .. category,
				"Reset " .. category .. " preferences",
				"Reset only this category. The change can be undone.",
				"Reset " .. category,
				function()
					local patch = {}
					for _, field in ipairs(studio.Schema) do
						if field.Page == category then
							patch[field.Key] = field.Default
						end
					end
					studio.Apply(patch, category .. " preferences reset.")
				end
			)
		end
	end

	function studio.Build()
		if studio.Built then
			return
		end
		studio.ReadRuntime()
		studio.BuildWindow()
		studio.BuildColorPreview()
		studio.BuildColorTools()
		studio.BuildHexInput()
		studio.BuildContrastReadout()
		studio.BuildTypographyPreview()
		for _, field in ipairs(studio.Schema) do
			if field.Kind == "number" then
				studio.NumberField(field)
			elseif field.Kind == "choice" then
				studio.ChoiceField(field)
			elseif field.Kind == "toggle" then
				studio.ToggleField(field)
			end
		end
		studio.BuildLayoutMap()
		studio.BuildArrangements()
		studio.BuildMotionRecipes()
		studio.BuildPresetLibrary()
		studio.BuildMemorySlots()
		studio.BuildTransfer()
		studio.BuildInspector()
		studio.BuildHelp()
		studio.BuildDiagnostics()
		studio.BuildSlotManagement()
		studio.BuildKeyboardShortcuts()
		studio.BuildCategoryResets()
		studio.Built = true
		studio.CaptureStyles()
		studio.Render(studio.Settings)
		studio.UpdateHistoryButtons()
		studio.Select("Color")
	end

	-- Mirror quick controls after the editor exists, without recursive updates.
	studioBridge.Sync = function()
		if not studio.Built or studio.Applying or studio.Synchronizing then
			return
		end
		studio.Synchronizing = true
		if CONFIG.ReducedMotion and glitchEnabled then
			setGlitchEnabled(false)
		end
		local previous = studio.Copy(studio.Settings)
		studio.ReadRuntime()
		local nextValues = studio.Copy(studio.Settings)
		studio.Settings = previous
		studio.Synchronizing = false
		if not studio.Same(previous, nextValues) then
			studio.Apply(nextValues, "Quick style controls updated.")
		end
	end

	function studio.Open()
		if not alive then
			return
		end
		studio.Build()
		studio.ReadRuntime()
		studio.Render(studio.Settings)
		studio.Relayout()
		portal.Play(studio.Window, true)
		studio.Select(
			if studio.Settings.RestorePage then studio.ActivePage else "Color"
		)
		studio.Message("Design Studio ready. Changes stay local to this run.")
	end

	studioBridge.Look = function(name: string)
		for _, preset in ipairs(studio.Presets) do
			if preset.Name == name then
				studio.Build()
				studio.Apply(preset.Values, name .. " signature look applied.")
				return
			end
		end
	end
	studioBridge.Font = function(name: string)
		if studio.Fonts[name] then
			studio.Build()
			studio.Apply(
				{ Font = name },
				name .. " type style applied. Body text stays readable."
			)
		end
	end
	studioBridge.ForgetUI = function(target: Instance)
		studio.StyleCache[target] = nil
		for _, object in ipairs(target:GetDescendants()) do
			studio.StyleCache[object] = nil
		end
	end
	studioBridge.RegisterUI = function()
		if studio.Built and alive then
			studio.CaptureStyles()
			studio.Render(studio.Settings)
		end
	end
	studioBridge.Open = studio.Open
	studioBridge.Resized = function(width: number, height: number)
		if not studio.Built then
			return
		end
		studio.Apply({
			Width = math.floor(width + 0.5),
			Height = math.floor(height + 0.5),
		}, "Dashboard resized.")
	end
	studioBridge.Destroy = function()
		studio.Built = false
		studio.Window = nil
		table.clear(studio.StyleCache)
		table.clear(studio.Refreshers)
		table.clear(studio.FocusStrokes)
		table.clear(studio.Pages)
		table.clear(studio.Rows)
		table.clear(studio.UndoStack)
		table.clear(studio.RedoStack)
		table.clear(studio.Saved)
	end
end

-- Local player tools. No remote events, automatic firing, or server modifications.
do
	local toolsState: { [string]: any } = {
		Visuals = false,
		Chams = true,
		Boxes = true,
		Lines = false,
		Names = true,
		Health = true,
		Distance = true,
		ThroughWalls = false,
		VisualTeamCheck = true,
		VisualDistance = 1000,
		VisualColor = "Violet",
		VisualRate = 30,
		Aim = false,
		Activation = "Auto",
		ScriptedCamera = false,
		Circle = false,
		Radius = 140,
		Strength = 50,
		AimDistance = 1000,
		AimTeamCheck = true,
		AimPart = "Head",
		CircleColor = "Violet",
		TouchPad = true,
	}
	local engine: { [string]: any } = {
		Workspace = game:GetService("Workspace"),
		Records = {},
		Highlights = {},
		Windows = {},
		Setters = {},
		Bound = false,
		BindName = "Nullx11_PlayerTools",
		VisualClock = 0,
		MouseHeld = false,
		TouchInput = nil,
		MaxOverlays = 32,
		MaxHighlights = 24,
		MaxVisualRays = 48,
		Palette = {
			Violet = Color3.fromRGB(167, 146, 255),
			Mint = Color3.fromRGB(126, 222, 185),
			Cyan = Color3.fromRGB(108, 221, 225),
			Red = Color3.fromRGB(255, 133, 145),
			White = Color3.fromRGB(242, 241, 249),
		},
	}

	function engine.Status(windowName: string, message: string)
		local window = engine.Windows[windowName]
		if window and window.Status.Text ~= message then
			window.Status.Text = message
		end
	end

	function engine.Hide(record: any)
		if record.Box then
			record.Box.Visible = false
			record.Line.Visible = false
			record.NameLabel.Visible = false
			record.HealthBar.Visible = false
		end
		if record.Highlight then
			record.Highlight.Enabled = false
		end
	end

	function engine.Remove(other: Player)
		local record = engine.Records[other]
		if not record then
			return
		end
		if record.Container then
			record.Container:Destroy()
		end
		if record.Highlight then
			record.Highlight.Enabled = false
			record.Highlight.Adornee = nil
		end
		engine.Records[other] = nil
	end

	function engine.EnsureOverlay()
		if engine.Overlay then
			return
		end
		engine.Overlay = create("ScreenGui", {
			Name = "Nullx11PlayerOverlay",
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ScreenInsets = Enum.ScreenInsets.None,
			DisplayOrder = 90,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, playerGui)
		engine.HighlightFolder = create(
			"Folder",
			{ Name = "Nullx11HighlightPool" },
			engine.Workspace
		)
		engine.Circle = create("Frame", {
			Name = "AimFOVCircle",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
		}, engine.Overlay)
		create("UICorner", { CornerRadius = UDim.new(1, 0) }, engine.Circle)
		engine.CircleStroke = create("UIStroke", {
			Color = engine.Palette.Violet,
			Thickness = 1.5,
			Transparency = 0.15,
		}, engine.Circle)
	end

	function engine.EnsureRecord(record: any)
		if record.Container then
			return
		end
		engine.EnsureOverlay()
		record.Container = create("Frame", {
			Name = "PlayerOverlay_" .. tostring(record.Player.UserId),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, engine.Overlay)
		record.Box = create("Frame", {
			Name = "PlayerBox",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.BoxStroke = create("UIStroke", {
			Color = engine.Palette.Violet,
			Thickness = 1.25,
		}, record.Box)
		record.Line = create("Frame", {
			Name = "PlayerTracer",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.NameLabel = label(record.Container, "", 12, colors.Text)
		record.NameLabel.Name = "PlayerTag"
		record.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
		record.NameLabel.TextStrokeTransparency = 0.35
		record.NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		record.NameLabel.Visible = false
		record.HealthBar = create("Frame", {
			Name = "PlayerHealth",
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Visible = false,
		}, record.Container)
		record.HealthFill = create("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			BackgroundColor3 = colors.Success,
			BorderSizePixel = 0,
		}, record.HealthBar)
	end

	function engine.Finite(value: number): boolean
		return value == value and math.abs(value) < math.huge
	end

	function engine.PositionValid(position: Vector3): boolean
		return engine.Finite(position.X)
			and engine.Finite(position.Y)
			and engine.Finite(position.Z)
	end

	function engine.Character(other: Player, teamCheck: boolean): any
		if other == player then
			return nil
		end
		if
			teamCheck
			and not player.Neutral
			and not other.Neutral
			and player.Team ~= nil
			and player.Team == other.Team
		then
			return nil
		end
		local character = other.Character
		if not character or not character.Parent then
			return nil
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local part = character:FindFirstChild("HumanoidRootPart")
			or character.PrimaryPart
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
		if
			not humanoid
			or humanoid.Health <= 0
			or not part
			or not part:IsA("BasePart")
		then
			return nil
		end
		if
			not engine.Finite(humanoid.Health)
			or not engine.Finite(humanoid.MaxHealth)
			or not engine.PositionValid(part.Position)
		then
			return nil
		end
		return { Model = character, Humanoid = humanoid, Root = part }
	end

	function engine.Visible(
		camera: Camera,
		model: Model,
		position: Vector3
	): boolean
		if not engine.RayParams then
			engine.RayParams = RaycastParams.new()
			engine.RayParams.FilterType = Enum.RaycastFilterType.Exclude
			engine.RayParams.IgnoreWater = true
		end
		engine.RayParams.FilterDescendantsInstances = if player.Character
			then { player.Character, camera }
			else { camera }
		local origin = camera.CFrame.Position
		local result = engine.Workspace:Raycast(
			origin,
			position - origin,
			engine.RayParams
		)
		return result == nil or result.Instance:IsDescendantOf(model)
	end

	function engine.Bounds(camera: Camera, model: Model): any
		local ok, transform, size = pcall(model.GetBoundingBox, model)
		if not ok or not engine.PositionValid(size) then
			return nil
		end
		local minimumX, minimumY = math.huge, math.huge
		local maximumX, maximumY = -math.huge, -math.huge
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local point = transform:PointToWorldSpace(
						Vector3.new(
							size.X * x / 2,
							size.Y * y / 2,
							size.Z * z / 2
						)
					)
					local projected = camera:WorldToViewportPoint(point)
					-- Never stretch a box across the camera's near plane.
					if
						not engine.PositionValid(projected)
						or projected.Z <= 0.1
					then
						return nil
					end
					minimumX = math.min(minimumX, projected.X)
					minimumY = math.min(minimumY, projected.Y)
					maximumX = math.max(maximumX, projected.X)
					maximumY = math.max(maximumY, projected.Y)
				end
			end
		end
		local viewport = camera.ViewportSize
		minimumX = math.clamp(minimumX, 0, viewport.X)
		minimumY = math.clamp(minimumY, 0, viewport.Y)
		maximumX = math.clamp(maximumX, 0, viewport.X)
		maximumY = math.clamp(maximumY, 0, viewport.Y)
		if maximumX - minimumX < 2 or maximumY - minimumY < 2 then
			return nil
		end
		return {
			X = minimumX,
			Y = minimumY,
			Width = maximumX - minimumX,
			Height = maximumY - minimumY,
		}
	end

	function engine.Draw(
		record: any,
		info: any,
		camera: Camera,
		distance: number,
		index: number
	)
		local ink = engine.Palette[toolsState.VisualColor]
		local box = engine.Bounds(camera, info.Model)
		if not box then
			engine.Hide(record)
			return false
		end
		engine.EnsureRecord(record)
		record.Box.Position = UDim2.fromOffset(box.X, box.Y)
		record.Box.Size = UDim2.fromOffset(box.Width, box.Height)
		record.Box.Visible = toolsState.Boxes
		record.BoxStroke.Color = ink
		local rootPosition = camera:WorldToViewportPoint(info.Root.Position)
		local start =
			Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 8)
		local finish = Vector2.new(rootPosition.X, rootPosition.Y)
		local delta = finish - start
		record.Line.Position =
			UDim2.fromOffset((start.X + finish.X) / 2, (start.Y + finish.Y) / 2)
		record.Line.Size = UDim2.fromOffset(delta.Magnitude, 1.5)
		record.Line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
		record.Line.BackgroundColor3 = ink
		record.Line.Visible = toolsState.Lines
		local caption = if toolsState.Names
			then record.Player.DisplayName
			else ""
		if toolsState.Distance then
			caption ..= string.format("  %.0f st", distance)
		end
		record.NameLabel.Text = caption
		record.NameLabel.Position =
			UDim2.fromOffset(box.X - 40, math.max(0, box.Y - 20))
		record.NameLabel.Size = UDim2.fromOffset(box.Width + 80, 18)
		record.NameLabel.TextColor3 = ink
		record.NameLabel.Visible = toolsState.Names or toolsState.Distance
		record.HealthBar.Position =
			UDim2.fromOffset(math.max(0, box.X - 6), box.Y)
		record.HealthBar.Size = UDim2.fromOffset(3, box.Height)
		record.HealthBar.Visible = toolsState.Health
		local fraction = math.clamp(
			info.Humanoid.Health / math.max(1, info.Humanoid.MaxHealth),
			0,
			1
		)
		record.HealthFill.Size = UDim2.fromScale(1, fraction)
		record.HealthFill.BackgroundColor3 = if fraction < 0.3
			then colors.Error
			else colors.Success
		if toolsState.Chams and index <= engine.MaxHighlights then
			if not engine.Highlights[index] then
				engine.Highlights[index] = create(
					"Highlight",
					{ Name = "Nullx11Chams" .. index },
					engine.HighlightFolder
				)
			end
			record.Highlight = engine.Highlights[index]
			record.Highlight.Adornee = info.Model
			record.Highlight.FillColor = ink
			record.Highlight.OutlineColor = ink
			record.Highlight.FillTransparency = 0.65
			record.Highlight.OutlineTransparency = 0.1
			record.Highlight.DepthMode = if toolsState.ThroughWalls
				then Enum.HighlightDepthMode.AlwaysOnTop
				else Enum.HighlightDepthMode.Occluded
			record.Highlight.Enabled = true
		end
		return true
	end

	function engine.ClearHighlights()
		for _, highlight in pairs(engine.Highlights) do
			highlight.Enabled = false
			highlight:Destroy()
		end
		table.clear(engine.Highlights)
		for _, record in pairs(engine.Records) do
			record.Highlight = nil
		end
	end

	function engine.UpdateVisuals(camera: Camera)
		local candidates = {}
		for _, highlight in pairs(engine.Highlights) do
			highlight.Enabled = false
			highlight.Adornee = nil
		end
		for _, record in pairs(engine.Records) do
			engine.Hide(record)
			record.Highlight = nil
			local info =
				engine.Character(record.Player, toolsState.VisualTeamCheck)
			if not info then
				continue
			end
			local distance = (info.Root.Position - camera.CFrame.Position).Magnitude
			local projected, onScreen =
				camera:WorldToViewportPoint(info.Root.Position)
			if
				distance <= toolsState.VisualDistance
				and onScreen
				and projected.Z > 0
			then
				table.insert(
					candidates,
					{ Record = record, Info = info, Distance = distance }
				)
			end
		end
		table.sort(candidates, function(a, b)
			return a.Distance < b.Distance
		end)
		local shown = 0
		local tested = 0
		for _, entry in ipairs(candidates) do
			if shown >= engine.MaxOverlays then
				break
			end
			if not toolsState.ThroughWalls then
				if tested >= engine.MaxVisualRays then
					break
				end
				tested += 1
			end
			if
				not toolsState.ThroughWalls
				and not engine.Visible(
					camera,
					entry.Info.Model,
					entry.Info.Root.Position
				)
			then
				continue
			end
			if
				engine.Draw(
					entry.Record,
					entry.Info,
					camera,
					entry.Distance,
					shown + 1
				)
			then
				shown += 1
			end
		end
		engine.Status(
			"Visuals",
			string.format(
				"Visuals ON / %d players / %d Hz",
				shown,
				toolsState.VisualRate
			)
		)
	end

	function engine.SelectTarget(camera: Camera): any
		local center = camera.ViewportSize / 2
		local candidates = {}
		local scan =
			{ Players = 0, Filtered = 0, Range = 0, FOV = 0, Blocked = 0 }
		engine.LastScan = scan
		for _, record in pairs(engine.Records) do
			scan.Players += 1
			local info =
				engine.Character(record.Player, toolsState.AimTeamCheck)
			if not info then
				scan.Filtered += 1
				continue
			end
			local part = if toolsState.AimPart == "Head"
				then info.Model:FindFirstChild("Head")
				else info.Root
			if not part or not part:IsA("BasePart") then
				part = info.Root
			end
			if not engine.PositionValid(part.Position) then
				continue
			end
			local distance = (part.Position - camera.CFrame.Position).Magnitude
			if distance < 0.01 or distance > toolsState.AimDistance then
				scan.Range += 1
				continue
			end
			local projected, onScreen =
				camera:WorldToViewportPoint(part.Position)
			if not onScreen or projected.Z <= 0 then
				scan.FOV += 1
				continue
			end
			local score = (Vector2.new(projected.X, projected.Y) - center).Magnitude
			if score > toolsState.Radius then
				scan.FOV += 1
			end
			if score <= toolsState.Radius then
				table.insert(candidates, {
					Score = score,
					Part = part,
					Model = info.Model,
					Player = record.Player,
				})
			end
		end
		table.sort(candidates, function(a, b)
			return a.Score < b.Score
		end)
		-- Bound expensive ray tests even on large servers.
		for index = 1, math.min(8, #candidates) do
			local candidate = candidates[index]
			if
				engine.Visible(camera, candidate.Model, candidate.Part.Position)
			then
				return candidate
			end
			scan.Blocked += 1
		end
		return nil
	end

	function engine.Step(dt: number)
		local camera = engine.Workspace.CurrentCamera
		if
			not camera
			or camera.ViewportSize.X <= 0
			or camera.ViewportSize.Y <= 0
			or not engine.PositionValid(camera.CFrame.Position)
		then
			for _, record in pairs(engine.Records) do
				engine.Hide(record)
			end
			if engine.Circle then
				engine.Circle.Visible = false
			end
			engine.Status("Aim", "Waiting for a camera.")
			return
		end
		if toolsState.Circle then
			engine.EnsureOverlay()
			engine.Circle.Position = UDim2.fromOffset(
				camera.ViewportSize.X / 2,
				camera.ViewportSize.Y / 2
			)
			engine.Circle.Size =
				UDim2.fromOffset(toolsState.Radius * 2, toolsState.Radius * 2)
			engine.CircleStroke.Color = engine.Palette[toolsState.CircleColor]
			engine.Circle.Visible = true
		end
		engine.UpdateAim(camera, dt)
		if toolsState.Visuals then
			engine.VisualClock += dt
			if engine.VisualClock >= 1 / toolsState.VisualRate then
				engine.VisualClock = 0
				engine.UpdateVisuals(camera)
			end
		end
	end

	function engine.UpdateAim(camera: Camera, dt: number)
		if not toolsState.Aim then
			return
		end
		if UserInputService:GetFocusedTextBox() then
			engine.Status("Aim", "Paused while typing.")
			return
		end
		if
			toolsState.Activation == "Hold"
			and not engine.MouseHeld
			and not engine.TouchInput
		then
			engine.Status(
				"Aim",
				"Hold RMB / touch AIM. Move panels off-center."
			)
			return
		end
		if
			camera.CameraType == Enum.CameraType.Scriptable
			and not toolsState.ScriptedCamera
		then
			engine.Status(
				"Aim",
				"Scripted camera / enable camera override if intended."
			)
			return
		end
		local character = player.Character
		local humanoid = if character
			then character:FindFirstChildOfClass("Humanoid")
			else nil
		local rootPart = if character
			then character:FindFirstChild("HumanoidRootPart")
				or character.PrimaryPart
				or character:FindFirstChild("UpperTorso")
				or character:FindFirstChild("Torso")
			else nil
		if
			not character
			or not character.Parent
			or not humanoid
			or humanoid.Health <= 0
			or not engine.Finite(humanoid.Health)
			or not rootPart
			or not rootPart:IsA("BasePart")
		then
			engine.Status("Aim", "Wait for your character to spawn.")
			return
		end
		local target = engine.SelectTarget(camera)
		if not target then
			local scan = engine.LastScan or {}
			engine.Status(
				"Aim",
				string.format(
					"No target / %d players / %d team or rig / %d FOV / %d blocked",
					scan.Players or 0,
					scan.Filtered or 0,
					scan.FOV or 0,
					scan.Blocked or 0
				)
			)
			return
		end
		local alpha = if toolsState.Strength >= 100
			then 1
			else 1 - math.exp(
				-(2 + toolsState.Strength * 0.7) * math.min(dt, 0.1)
			)
		local desired =
			CFrame.lookAt(camera.CFrame.Position, target.Part.Position)
		camera.CFrame = camera.CFrame:Lerp(desired, alpha)
		engine.Status(
			"Aim",
			"Tracking "
				.. target.Player.DisplayName
				.. " / "
				.. toolsState.Strength
				.. "%"
		)
	end

	function engine.SafeStep(dt: number)
		local ok, reason = pcall(engine.Step, dt)
		if not ok then
			engine.DisableAll()
			engine.Status(
				"Aim",
				"Runtime error / " .. string.sub(tostring(reason), 1, 110)
			)
			engine.Status("Visuals", "Runtime error / see console.")
			warn("[Nullx11 player tools] " .. tostring(reason))
		end
	end
	function engine.Schedule()
		local needed = toolsState.Visuals or toolsState.Aim or toolsState.Circle
		if needed and not engine.Bound then
			local ok, reason = pcall(function()
				RunService:BindToRenderStep(
					engine.BindName,
					Enum.RenderPriority.Last.Value - 1,
					engine.SafeStep
				)
			end)
			if ok then
				engine.Backend = "late camera binding"
			else
				engine.Fallback =
					RunService.RenderStepped:Connect(engine.SafeStep)
				engine.Backend = "RenderStepped fallback"
				warn(
					"[Nullx11] Camera binding failed; using RenderStepped: "
						.. tostring(reason)
				)
			end
			engine.Bound = true
		elseif not needed and engine.Bound then
			if engine.Fallback then
				engine.Fallback:Disconnect()
				engine.Fallback = nil
			else
				RunService:UnbindFromRenderStep(engine.BindName)
			end
			engine.Bound = false
			engine.Backend = "renderer idle"
		end

		if not toolsState.Visuals then
			engine.ClearHighlights()
			for _, record in pairs(engine.Records) do
				engine.Hide(record)
			end
			engine.Status("Visuals", "Visuals OFF / enable to draw players.")
		end
		if not toolsState.Chams then
			engine.ClearHighlights()
		end
		if not toolsState.Circle and engine.Circle then
			engine.Circle.Visible = false
		end
		if not toolsState.Aim then
			engine.MouseHeld = false
			engine.TouchInput = nil
			engine.Status(
				"Aim",
				if toolsState.Circle
					then "FOV preview on / move panels away from center."
					else "Aim OFF / camera untouched."
			)
		end
		if not toolsState.TouchPad then
			engine.TouchInput = nil
		end
		if engine.TouchPad then
			local hold = engine.TouchPad:FindFirstChild("HoldMobileAim")
			if hold then
				hold.Text = if toolsState.Activation == "Auto"
					then "STOP AUTO"
					else "HOLD AIM"
			end
			engine.TouchPad.Visible = toolsState.Aim and toolsState.TouchPad
		end
	end

	function engine.DisableAll()
		for _, key in ipairs({ "Visuals", "Aim", "Circle" }) do
			toolsState[key] = false
			if engine.Setters[key] then
				engine.Setters[key](false)
			end
		end
		engine.MouseHeld = false
		engine.TouchInput = nil
		engine.Schedule()
	end

	function engine.Window(name: string): any
		local window = { Kind = name }
		window.Panel = create("Frame", {
			Name = name .. "Window",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(390, 540),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(window.Panel, 16)
		create(
			"UIStroke",
			{ Color = colors.Border, Thickness = 1 },
			window.Panel
		)
		local handle = create("Frame", {
			Name = name .. "DragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, -64, 0, 64),
		}, window.Panel)
		drawIcon(handle, CONFIG.Accent, UDim2.fromOffset(18, 20), 26)
		local heading = label(
			handle,
			string.upper(name)
				.. (if name == "Scripts" then " / LIBRARY" else " / LOCAL"),
			18,
			colors.Text
		)
		heading.Font = Enum.Font.Code
		heading.Position = UDim2.fromOffset(56, 20)
		heading.Size = UDim2.new(1, -56, 0, 28)
		local hide = create("TextButton", {
			Name = "Hide" .. name,
			Text = "−",
			TextSize = 22,
			Font = Enum.Font.Code,
			TextColor3 = colors.Muted,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -56, 0, 12),
			Size = UDim2.fromOffset(44, 44),
		}, window.Panel)
		connect(hide.Activated, function()
			engine.WindowSetters[name](false)
		end)
		window.Body = create("ScrollingFrame", {
			Name = name .. "Controls",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(16, 72),
			Size = UDim2.new(1, -32, 1, -128),
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = CONFIG.Accent,
		}, window.Panel)
		window.Status = label(window.Panel, name .. " OFF", 10, colors.Muted)
		window.Status.Name = name .. "Status"
		window.Status.Position = UDim2.new(0, 16, 1, -44)
		window.Status.Size = UDim2.new(1, -32, 0, 32)
		window.Status.TextWrapped = true
		window.Cursor = 0
		engine.Windows[name] = window
		draggable(handle, window.Panel)
		return window
	end

	function engine.Toggle(
		window: any,
		key: string,
		title: string,
		hint: string
	)
		engine.Setters[key] = toggleRow(
			title,
			hint,
			window.Cursor,
			toolsState[key],
			function(value)
				toolsState[key] = value
				if key == "Aim" and value and engine.Setters.Circle then
					engine.Setters.Circle(true)
				end
				engine.Schedule()
			end,
			window.Body
		)
		window.Cursor += 58
	end

	function engine.Button(
		window: any,
		name: string,
		caption: string,
		callback: () -> ()
	)
		local button = create("TextButton", {
			Name = name,
			Text = caption,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = UDim2.fromOffset(0, window.Cursor),
			Size = UDim2.new(1, -4, 0, 44),
		}, window.Body)
		corner(button, 10)
		connect(button.Activated, callback)
		window.Cursor += 52
		return button
	end

	function engine.Number(
		window: any,
		key: string,
		title: string,
		minimum: number,
		maximum: number,
		step: number
	)
		local heading = label(window.Body, title, 11, colors.Muted)
		heading.Position = UDim2.fromOffset(0, window.Cursor)
		heading.Size = UDim2.new(1, -4, 0, 22)
		local box = create("TextBox", {
			Name = "Value" .. key,
			Text = tostring(toolsState[key]),
			ClearTextOnFocus = false,
			MultiLine = false,
			Font = Enum.Font.Code,
			TextSize = 14,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, window.Cursor + 24),
			Size = UDim2.new(1, -116, 0, 44),
		}, window.Body)
		corner(box, 9)
		engine.NumberRefresh = engine.NumberRefresh or {}
		engine.NumberRefresh[key] = function()
			box.Text = tostring(toolsState[key])
		end
		connect(box.FocusLost, function()
			local value = tonumber(box.Text)
			if
				not value
				or value ~= value
				or value % 1 ~= 0
				or value < minimum
				or value > maximum
			then
				engine.Status(
					window.Kind,
					string.format(
						"Enter a whole number from %d to %d.",
						minimum,
						maximum
					)
				)
			else
				toolsState[key] = value
				engine.Schedule()
			end
			engine.NumberRefresh[key]()
		end)
		for _, direction in ipairs({ -1, 1 }) do
			local change = direction
			local button = create("TextButton", {
				Name = (if change < 0 then "Decrease" else "Cycle") .. key,
				Text = if change < 0 then "−" else "+",
				TextSize = 20,
				Font = Enum.Font.Code,
				TextColor3 = colors.Text,
				BackgroundColor3 = colors.Surface,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Position = UDim2.new(
					1,
					if change < 0 then -104 else -48,
					0,
					window.Cursor + 24
				),
				Size = UDim2.fromOffset(44, 44),
			}, window.Body)
			corner(button, 9)
			connect(button.Activated, function()
				toolsState[key] = math.clamp(
					toolsState[key] + change * step,
					minimum,
					maximum
				)
				engine.NumberRefresh[key]()
			end)
		end
		window.Cursor += 80
	end

	function engine.Color(window: any, key: string, title: string)
		local names = { "Violet", "Mint", "Cyan", "Red", "White" }
		local button: TextButton? = nil
		button = engine.Button(
			window,
			"Cycle" .. key,
			title .. ": " .. toolsState[key],
			function()
				local current = table.find(names, toolsState[key]) or 1
				toolsState[key] = names[current % #names + 1]
				if button then
					button.Text = title .. ": " .. toolsState[key]
					button.TextColor3 = engine.Palette[toolsState[key]]
				end
			end
		)
	end

	function engine.RuntimeReport()
		local camera = engine.Workspace.CurrentCamera
		local char = player.Character
		local humanoid = if char
			then char:FindFirstChildOfClass("Humanoid")
			else nil
		local rootPart = if char
			then char:FindFirstChild("HumanoidRootPart")
				or char.PrimaryPart
				or char:FindFirstChild("UpperTorso")
				or char:FindFirstChild("Torso")
			else nil
		local ready = char
			and char.Parent
			and humanoid
			and humanoid.Health > 0
			and rootPart
			and rootPart:IsA("BasePart")
		local others = math.max(0, #Players:GetPlayers() - 1)
		local message = string.format(
			"LIVE / %d other players / local avatar %s / camera %s / %s / %s mode",
			others,
			if ready then "ready" else "not ready",
			if camera then tostring(camera.CameraType) else "missing",
			engine.Backend or "renderer idle",
			toolsState.Activation
		)
		if others == 0 then
			message ..= ". Other players are required; NPCs are not targets."
		end
		for _, name in ipairs({ "Aim", "Visuals" }) do
			local window = engine.Windows[name]
			if window and window.Diagnostics then
				window.Diagnostics.Text = message
			end
		end
		engine.Status("Aim", message)
		engine.Status("Visuals", message)
		warn("[Nullx11 live runtime report] " .. message)
	end
	function engine.Diagnostics(window: any, id: string)
		engine.Button(
			window,
			id,
			"Check live Roblox state",
			engine.RuntimeReport
		)
		window.Diagnostics = label(
			window.Body,
			"Live checks use the current Roblox services, not simulated targets. Tap Check to inspect avatar, camera, player count, and renderer.",
			14,
			colors.Muted
		)
		window.Diagnostics.Name = window.Kind .. "RuntimeDetails"
		window.Diagnostics.Position = UDim2.fromOffset(4, window.Cursor)
		window.Diagnostics.Size = UDim2.new(1, -12, 0, 132)
		window.Diagnostics.TextWrapped = true
		window.Cursor += 144
	end

	function engine.BuildVisuals()
		if engine.Windows.Visuals then
			return
		end
		local window = engine.Window("Visuals")
		engine.Button(
			window,
			"VisualsDisableAll",
			"Disable visuals, aim, and circle",
			engine.DisableAll
		)
		engine.Toggle(
			window,
			"Visuals",
			"Enable visuals",
			"Off by default / nearest 32 on-screen players"
		)
		engine.Toggle(
			window,
			"Chams",
			"Player chams",
			"Local highlights / at most 24 active"
		)
		engine.Toggle(
			window,
			"Boxes",
			"Player boxes",
			"Projected character bounding boxes"
		)
		engine.Toggle(
			window,
			"Lines",
			"Tracer lines",
			"Bottom-center to player root"
		)
		engine.Toggle(
			window,
			"Names",
			"Player names",
			"Display names above the box"
		)
		engine.Toggle(window, "Health", "Health bars", "Living characters only")
		engine.Toggle(
			window,
			"Distance",
			"Player distance",
			"Camera distance in studs"
		)
		engine.Toggle(
			window,
			"ThroughWalls",
			"Through walls",
			"Off: require a clear line of sight"
		)
		engine.Toggle(
			window,
			"VisualTeamCheck",
			"Visual team filter",
			"Skip non-neutral teammates"
		)
		engine.Number(
			window,
			"VisualDistance",
			"Visual range (studs)",
			250,
			3000,
			250
		)
		engine.Number(window, "VisualRate", "Overlay rate (Hz)", 15, 60, 15)
		engine.Color(window, "VisualColor", "Overlay color")
		engine.Diagnostics(window, "CheckVisualsRuntime")
		window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end

	function engine.BuildAim()
		if engine.Windows.Aim then
			return
		end
		local window = engine.Window("Aim")
		engine.Button(
			window,
			"AimDisableAll",
			"Disable visuals, aim, and circle",
			engine.DisableAll
		)
		engine.Toggle(
			window,
			"Aim",
			"Enable aim assist",
			"Auto tracks immediately / Hold mode is optional"
		)
		engine.Toggle(
			window,
			"Circle",
			"Show FOV circle",
			"Pixels around the center of the viewport"
		)
		local activation: TextButton? = nil
		activation = engine.Button(
			window,
			"CycleAimActivation",
			"Activation: Auto / enabled = tracking",
			function()
				toolsState.Activation = if toolsState.Activation == "Auto"
					then "Hold"
					else "Auto"
				engine.MouseHeld = false
				engine.TouchInput = nil
				if activation then
					activation.Text = if toolsState.Activation == "Auto"
						then "Activation: Auto / enabled = tracking"
						else "Activation: Hold RMB / AIM pad"
				end
				engine.Schedule()
			end
		)
		engine.Button(
			window,
			"EnterAimView",
			"Play view / fold panels into dock",
			function()
				for _, name in ipairs({
					"Aim",
					"Visuals",
					"Scripts",
					"GameScript",
				}) do
					engine.WindowSetters[name](false)
				end
				setExpanded(false)
			end
		)
		engine.Toggle(
			window,
			"ScriptedCamera",
			"Scripted camera override",
			"Optional / can conflict with game cutscenes"
		)
		engine.Number(window, "Strength", "Aim strength", 1, 100, 1)
		engine.Number(window, "Radius", "FOV radius (px)", 50, 400, 25)
		engine.Number(
			window,
			"AimDistance",
			"Aim range (studs)",
			250,
			3000,
			250
		)
		engine.Toggle(
			window,
			"AimTeamCheck",
			"Aim team filter",
			"Skip non-neutral teammates"
		)
		engine.Toggle(
			window,
			"TouchPad",
			"Mobile aim pad",
			"Separate draggable touch-hold control"
		)
		local part: TextButton? = nil
		part = engine.Button(
			window,
			"CycleAimPart",
			"Target part: " .. toolsState.AimPart,
			function()
				toolsState.AimPart = if toolsState.AimPart == "Head"
					then "Root"
					else "Head"
				if part then
					part.Text = "Target part: " .. toolsState.AimPart
				end
			end
		)
		engine.Color(window, "CircleColor", "FOV circle color")
		engine.Button(
			window,
			"AimStrength100",
			"Set strength to 100 (snap)",
			function()
				toolsState.Strength = 100
				engine.NumberRefresh.Strength()
			end
		)
		engine.Diagnostics(window, "CheckAimRuntime")
		window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
		engine.TouchPad = create("Frame", {
			Name = "MobileAimPad",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(116, 104),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			Visible = false,
		}, root)
		corner(engine.TouchPad, 14)
		local handle = create("Frame", {
			Name = "AimPadDragHandle",
			BackgroundTransparency = 1,
			Active = true,
			Size = UDim2.new(1, 0, 0, 44),
		}, engine.TouchPad)
		local caption = label(handle, "DRAG / AIM", 9, colors.Muted)
		caption.Size = UDim2.fromScale(1, 1)
		caption.TextXAlignment = Enum.TextXAlignment.Center
		local hold = create("TextButton", {
			Name = "HoldMobileAim",
			Text = "HOLD AIM",
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			TextColor3 = colors.Panel,
			BackgroundColor3 = CONFIG.Accent,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -16, 0, 48),
			Position = UDim2.fromOffset(8, 48),
		}, engine.TouchPad)
		corner(hold, 10)
		connect(hold.InputBegan, function(input: InputObject)
			if
				toolsState.Aim
				and (
					input.UserInputType == Enum.UserInputType.Touch
					or input.UserInputType
						== Enum.UserInputType.MouseButton1
				)
			then
				engine.TouchInput = input
			end
		end)
		connect(hold.Activated, function()
			if toolsState.Activation == "Auto" and engine.Setters.Aim then
				engine.Setters.Aim(false)
			end
		end)
		draggable(handle, engine.TouchPad)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end

	engine.WindowSetters = {}
	engine.WindowSetters.Visuals = toggleRow(
		"Visuals window",
		"Chams / boxes / tracer lines",
		232,
		false,
		function(show)
			if show then
				engine.BuildVisuals()
			end
			layout()
			if engine.Windows.Visuals then
				portal.Play(engine.Windows.Visuals.Panel, show)
			end
		end
	)
	engine.WindowSetters.Aim = toggleRow(
		"Aim window",
		"FOV / strength / touch hold",
		290,
		false,
		function(show)
			if show then
				engine.BuildAim()
			end
			layout()
			if engine.Windows.Aim then
				portal.Play(engine.Windows.Aim.Panel, show)
			end
		end
	)
	-- Repository game bundles are seeded at build time; Refresh can replace them.
	local catalog: { [string]: any } =
		{ Entries = {}, Loaded = false, Busy = false, Rows = {}, Confirm = nil }
	catalog.RowConnections = {}
	function catalog.Message(message: string, failed: boolean?)
		if catalog.GameWindow and catalog.GameWindow.Panel.Visible then
			engine.Status("GameScript", message)
		end
		engine.Status("Scripts", message)
		if catalog.Window then
			catalog.Window.Status.TextColor3 = if failed
				then colors.Error
				else colors.Muted
		end
	end
	function catalog.Validate(document: any): { any }
		assert(
			type(document) == "table" and document.Version == 1,
			"Unsupported manifest version"
		)
		local entries = document.Scripts
		assert(
			type(entries) == "table" and #entries <= 64,
			"Manifest needs at most 64 scripts"
		)
		for key in pairs(entries) do
			assert(
				type(key) == "number"
					and key % 1 == 0
					and key >= 1
					and key <= #entries,
				"Scripts must be an array"
			)
		end
		local clean, seen = {}, {}
		for _, entry in ipairs(entries) do
			assert(type(entry) == "table", "Invalid script entry")
			assert(
				type(entry.Id) == "string"
					and #entry.Id > 0
					and #entry.Id <= 48
					and not seen[entry.Id],
				"Script IDs must be unique"
			)
			assert(
				type(entry.Name) == "string"
					and #entry.Name > 0
					and #entry.Name <= 80,
				"Invalid script name"
			)
			assert(
				type(entry.Description) == "string"
					and #entry.Description <= 240,
				"Invalid description"
			)
			if entry.GamePlaceId ~= nil then
				assert(
					type(entry.GamePlaceId) == "number"
						and entry.GamePlaceId > 0
						and entry.GamePlaceId <= 9007199254740991
						and entry.GamePlaceId % 1 == 0,
					"Invalid game place ID"
				)
			end
			if entry.Author ~= nil then
				assert(
					type(entry.Author) == "string" and #entry.Author <= 160,
					"Invalid source credit"
				)
			end
			local file = entry.File
			assert(
				type(file) == "string"
					and #file <= 160
					and string.match(file, "^[%w_/%-%.]+%.luau$")
					and string.sub(file, 1, 1) ~= "/"
					and not string.find(file, "..", 1, true),
				"Use a relative .luau path inside scripts/"
			)
			local places = {}
			if entry.PlaceIds ~= nil then
				assert(
					type(entry.PlaceIds) == "table" and #entry.PlaceIds <= 100,
					"Invalid PlaceIds array"
				)
				for key, id in pairs(entry.PlaceIds) do
					assert(
						type(key) == "number"
							and key % 1 == 0
							and key >= 1
							and key <= #entry.PlaceIds,
						"Invalid PlaceIds array"
					)
					assert(
						type(id) == "number"
							and id > 0
							and id < math.huge
							and id % 1 == 0,
						"Invalid place ID"
					)
					table.insert(places, id)
				end
			end
			seen[entry.Id] = true
			table.insert(clean, {
				Id = entry.Id,
				Name = entry.Name,
				Description = entry.Description,
				File = file,
				GamePlaceId = entry.GamePlaceId,
				Author = entry.Author,
				PlaceIds = places,
			})
		end
		return clean
	end
	if CONFIG.EnhancedWorkspace then
		catalog.Entries = catalog.Validate({
			Version = 1,
			Scripts = {
				{
					Id = "rosu",
					Name = "Nullx11 - Rosu Mania",
					Description = "Note tracking, configurable hit/hold timing, input release and gameplay rescan. Autoplay starts off.",
					File = "Nullx11-Rosu.luau",
					GamePlaceId = 9051087354,
					Author = "Developed by Gab; Nullx11 adaptation; original Yvetzal / Wyrizon / Infernum. Not for resale.",
				},
				{
					Id = "huss",
					Name = "Nullx11 - hussvalley",
					Description = "Runner routing, catcher assistance, progression tools and live status. Automation starts off; configurable per feature.",
					File = "Nullx11-Huss.luau",
					GamePlaceId = 107535308163741,
					Author = "Developed by Gab; Nullx11 adaptation; original Wyrizon and Yvetzal Team.",
				},
				{
					Id = "forge",
					Name = "Nullx11 - +1 loot to forge",
					Description = "Forge, gear, pets, stages, tower, rewards and session tools on the full shared +1 UI. Bounded workers; automation starts off.",
					File = "Nullx11-Forge.luau",
					GamePlaceId = 118805555015549,
					Author = "Developed by Gab; Nullx11 adaptation; original xDTaraZ controller and UI.",
				},
				{
					Id = "egg",
					Name = "Nullx11 - Steal An Egg",
					Description = "Egg farming, inventory, event, navigation and character tools from the supplied source. All jobs start off. Game-module compatibility is checked before startup.",
					File = "Nullx11-StealAnEgg.luau",
					Author = "Developed by Gab; adapted from Henrik / xyzhenrik (Silence). Original provenance retained.",
				},
				{
					Id = "stealabrainrot",
					Name = "stealabrainrot",
					Description = "Supplied Chilli controller adapted to Nullx11 controls: stealer, helper, player, ESP and server tools. Automation starts off; required game modules are checked first.",
					File = "Nullx11-StealABrainrot.luau",
					Author = "Developed by Gab; adapted from user-supplied recovered Chilli source; original attribution retained.",
				},
			},
		})
		catalog.Loaded = true
	end
	function catalog.GameMessage(message: string)
		engine.Status("GameScript", message)
		engine.Status("Scripts", message)
	end
	function catalog.OpenGame(entry: any)
		if catalog.Busy then
			return
		end
		catalog.Selected = entry
		catalog.Confirm = nil
		if not engine.Windows.GameScript then
			local window = engine.Window("GameScript")
			catalog.GameWindow = window
			local function detail(
				name: string,
				height: number,
				size: number,
				color: Color3
			)
				local text = label(window.Body, "", size, color)
				text.Name = name
				text.Position = UDim2.fromOffset(4, window.Cursor)
				text.Size = UDim2.new(1, -12, 0, height)
				text.TextWrapped = true
				window.Cursor += height + 12
				return text
			end
			catalog.GameTitle = detail("GameScriptTitle", 52, 21, colors.Text)
			catalog.GameDetails =
				detail("GameScriptDetails", 100, 14, colors.Muted)
			catalog.GameCredit =
				detail("GameScriptCredit", 50, 14, colors.Muted)
			catalog.ExecuteButton = engine.Button(
				window,
				"GameExecute",
				"Execute game script",
				function()
					local selected = catalog.Selected
					if not selected then
						return
					end
					if
						selected.GamePlaceId
						and game.PlaceId ~= selected.GamePlaceId
					then
						catalog.GameMessage(
							"Unsupported place. Join the game manually; no teleport was requested."
						)
						return
					end
					catalog.Run(selected, catalog.ExecuteButton)
				end
			)
			window.Body.CanvasSize = UDim2.fromOffset(0, window.Cursor)
			if studioBridge.RegisterUI then
				studioBridge.RegisterUI()
			end
		end
		catalog.GameTitle.Text = entry.Name
		catalog.GameDetails.Text = entry.Description
			.. "\n\n"
			.. (
				if not entry.GamePlaceId
					then "Game modules are checked before startup."
					elseif
						game.PlaceId == entry.GamePlaceId
					then "Target game detected. Confirm execution below."
					else "Unsupported place. Join the game manually to use this script."
			)
		catalog.GameCredit.Text = "Source credits: "
			.. (
				entry.Author
				or "See the reviewed script source; original attribution must be retained."
			)
		catalog.ExecuteButton.Text = "Execute game script"
		catalog.GameMessage(
			"No game teleport prompts or queued auto-execution. Executed scripts survive loader unload."
		)
		layout()
		portal.Play(catalog.GameWindow.Panel, true)
	end
	engine.WindowSetters.GameScript = function(show: boolean)
		if catalog.GameWindow then
			layout()
			portal.Play(catalog.GameWindow.Panel, show)
		end
	end
	function catalog.Run(entry: any, button: TextButton)
		if catalog.Busy then
			return
		end
		if entry.GamePlaceId and game.PlaceId ~= entry.GamePlaceId then
			catalog.Message(
				"Unsupported place. Join the game manually; no code was downloaded.",
				true
			)
			return
		end
		if
			not catalog.Confirm
			or catalog.Confirm.Id ~= entry.Id
			or os.clock() > catalog.Confirm.Deadline
		then
			local confirmation = { Id = entry.Id, Deadline = os.clock() + 5 }
			catalog.Confirm = confirmation
			button.Text = "Confirm run / " .. entry.Name
			catalog.Message(
				"Runs remote code from scripts/"
					.. entry.File
					.. ". Tap again within 5s only if trusted."
			)
			task.delay(5, function()
				if
					alive
					and button.Parent
					and catalog.Confirm == confirmation
					and os.clock() >= confirmation.Deadline
				then
					catalog.Confirm = nil
					button.Text = if entry.GamePlaceId
						then "Execute game script"
						else "Run / " .. entry.Name
				end
			end)
			return
		end
		catalog.Confirm = nil
		catalog.Busy = true
		button.Text = "Downloading…"
		catalog.Message("Fetching scripts/" .. entry.File)
		local progress = playerToolsBridge.BeginExecution
			and playerToolsBridge.BeginExecution(entry.Name)
		task.spawn(function()
			local ok, reason = pcall(function()
				assert(
					type(loadstring) == "function",
					"Client loadstring unavailable; run reviewed scripts as Studio LocalScripts instead"
				)
				local source =
					game:HttpGet(CONFIG.ScriptBaseURL .. entry.File, true)
				if progress then
					if not progress:CanContinue() then
						return
					end
					progress:Phase(
						2,
						"HTTP response received / "
							.. tostring(
								type(source) == "string" and #source or 0
							)
							.. " bytes"
					)
				end
				assert(
					type(source) == "string"
						and #source > 0
						and #source <= 2097152,
					"Script is empty or exceeds 2 MiB"
				)
				if not alive then
					return
				end
				if progress then
					progress:Phase(
						3,
						"Compiling the selected source locally; no game feature is enabled by the loader."
					)
				end
				-- Let the stage render once; this is not a timed/fake progress animation.
				if progress then
					task.wait()
				end
				if not alive or (progress and not progress:CanContinue()) then
					return
				end
				local execute, compileError =
					loadstring(source, "Nullx11Library/" .. entry.File)
				assert(execute, compileError or "Script compilation failed")
				if not alive then
					return
				end
				if progress then
					if not progress:CanContinue() then
						return
					end
					progress:Phase(
						4,
						"Opening the selected game UI. Hiding this screen will not stop an initialized script."
					)
				end
				button.Text = "Running…"
				execute()
			end)
			catalog.Busy = false
			if progress then
				if not ok then
					progress:Fail(reason)
				elseif progress:CanContinue() then
					progress:Finish()
				end
			end
			if not alive or not button.Parent then
				return
			end
			button.Text = if entry.GamePlaceId
				then "Execute game script"
				else "Run / " .. entry.Name
			if
				progress
				and progress.Model
				and progress.Model.Status == "cancelled"
			then
				catalog.Message(
					"Cancelled before initialization. The selected script was not started."
				)
			elseif ok then
				catalog.Message(
					"Client call returned: "
						.. entry.Name
						.. ". External scripts manage their own cleanup."
				)
			else
				catalog.Message(
					"Run failed: " .. string.sub(tostring(reason), 1, 105),
					true
				)
				warn("[Nullx11 Scripts] " .. tostring(reason))
			end
		end)
	end
	function catalog.Render()
		if not catalog.Window then
			return
		end
		for _, connection in ipairs(catalog.RowConnections) do
			connection:Disconnect()
		end
		table.clear(catalog.RowConnections)
		for _, row in ipairs(catalog.Rows) do
			if studioBridge.ForgetUI then
				studioBridge.ForgetUI(row)
			end
			row:Destroy()
		end
		table.clear(catalog.Rows)
		catalog.Confirm = nil
		local window = catalog.Window
		local query = string.lower(catalog.Search.Text)
		local cursor = 116
		local count = 0
		for _, entry in ipairs(catalog.Entries) do
			local matchesPlace = entry.GamePlaceId ~= nil
				or #entry.PlaceIds == 0
			for _, id in ipairs(entry.PlaceIds) do
				if id == game.PlaceId then
					matchesPlace = true
					break
				end
			end
			if
				not matchesPlace
				or not string.find(
					string.lower(
						entry.Name
							.. " "
							.. entry.Description
							.. " "
							.. entry.File
					),
					query,
					1,
					true
				)
			then
				continue
			end
			local row = create("Frame", {
				Name = "ScriptEntry_" .. entry.Id,
				BackgroundColor3 = colors.Surface,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, cursor),
				Size = UDim2.new(1, -4, 0, 156),
			}, window.Body)
			corner(row, 12)
			table.insert(catalog.Rows, row)
			local heading = label(row, entry.Name, 18, colors.Text)
			heading.Position = UDim2.fromOffset(12, 8)
			heading.Size = UDim2.new(1, -24, 0, 24)
			heading.TextTruncate = Enum.TextTruncate.AtEnd
			local description = label(row, entry.Description, 14, colors.Muted)
			description.Position = UDim2.fromOffset(12, 36)
			description.Size = UDim2.new(1, -24, 0, 40)
			description.TextWrapped = true
			local path = label(row, "scripts/" .. entry.File, 14, CONFIG.Accent)
			path.Position = UDim2.fromOffset(12, 78)
			path.Size = UDim2.new(1, -24, 0, 22)
			path.TextTruncate = Enum.TextTruncate.AtEnd
			local run = create("TextButton", {
				Name = "RunScript_" .. entry.Id,
				Text = if entry.GamePlaceId
					then "Open game window"
					else "Run / " .. entry.Name,
				TextSize = 15,
				Font = Enum.Font.GothamMedium,
				TextColor3 = colors.Panel,
				BackgroundColor3 = CONFIG.Accent,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(10, 104),
				Size = UDim2.new(1, -20, 0, 44),
			}, row)
			corner(run, 9)
			table.insert(
				catalog.RowConnections,
				run.Activated:Connect(function()
					if entry.GamePlaceId then
						catalog.OpenGame(entry)
					else
						catalog.Run(entry, run)
					end
				end)
			)
			cursor += 166
			count += 1
		end
		if count == 0 then
			local empty = label(
				window.Body,
				if not catalog.Loaded
					then "Library not loaded. Refresh to read the GitHub scripts/ manifest."
					elseif
						#catalog.Entries == 0
					then "No scripts published yet.\nAdd reviewed .luau files and manifest entries to the GitHub scripts/ folder, then Refresh."
					else "No scripts match this search / place.",
				15,
				colors.Muted
			)
			empty.Name = "ScriptsEmptyState"
			empty.Position = UDim2.fromOffset(8, cursor)
			empty.Size = UDim2.new(1, -20, 0, 118)
			empty.TextWrapped = true
			table.insert(catalog.Rows, empty)
			cursor += 126
		end
		window.Body.CanvasSize = UDim2.fromOffset(0, cursor)
		if studioBridge.RegisterUI then
			studioBridge.RegisterUI()
		end
	end
	function catalog.Refresh()
		if catalog.Busy then
			return
		end
		catalog.Busy = true
		catalog.Message("Fetching the GitHub manifest…")
		task.spawn(function()
			local ok, result = pcall(function()
				local source =
					game:HttpGet(CONFIG.ScriptBaseURL .. "manifest.json", true)
				assert(
					type(source) == "string" and #source <= 131072,
					"Manifest exceeds 128 KiB"
				)
				return catalog.Validate(
					game:GetService("HttpService"):JSONDecode(source)
				)
			end)
			catalog.Busy = false
			if progress then
				if not ok then
					progress:Fail(reason)
				elseif progress:CanContinue() then
					progress:Finish()
				end
			end
			if not alive then
				return
			end
			if ok then
				-- A refresh invalidates old detail/confirmation state, including removed entries.
				catalog.Selected = nil
				catalog.Confirm = nil
				if catalog.GameWindow then
					portal.Play(catalog.GameWindow.Panel, false)
				end
				catalog.Entries = result
				catalog.Loaded = true
				catalog.Render()
				catalog.Message(
					string.format(
						"GitHub manifest loaded / %d published scripts.",
						#result
					)
				)
			else
				catalog.Message(
					"Refresh failed: " .. string.sub(tostring(result), 1, 100),
					true
				)
				warn("[Nullx11 Scripts] " .. tostring(result))
			end
		end)
	end
	function engine.BuildScripts()
		if engine.Windows.Scripts then
			return
		end
		local window = engine.Window("Scripts")
		catalog.Window = window
		engine.Button(
			window,
			"RefreshScripts",
			"Refresh from GitHub",
			catalog.Refresh
		)
		catalog.Search = create("TextBox", {
			Name = "ScriptsSearch",
			Text = "",
			PlaceholderText = "Search published scripts…",
			ClearTextOnFocus = false,
			MultiLine = false,
			Font = Enum.Font.Gotham,
			TextSize = 16,
			TextColor3 = colors.Text,
			PlaceholderColor3 = colors.Muted,
			BackgroundColor3 = colors.Surface,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 58),
			Size = UDim2.new(1, -4, 0, 44),
		}, window.Body)
		corner(catalog.Search, 10)
		connect(catalog.Search:GetPropertyChangedSignal("Text"), catalog.Render)
		catalog.Render()
		catalog.Message(
			if catalog.Loaded
				then "Bundled entries ready. Refresh to read the latest GitHub library."
				else "No network request yet. Refresh to read the GitHub library."
		)
	end
	-- Navigation is an action, not an ON/OFF feature switch.
	engine.WindowSetters.Scripts = function(show: boolean)
		if show then
			engine.BuildScripts()
		end
		layout()
		if engine.Windows.Scripts then
			portal.Play(engine.Windows.Scripts.Panel, show)
		end
	end
	local scriptsButton = create("TextButton", {
		Name = "Scripts window",
		Text = "Open Scripts library",
		TextSize = 16,
		Font = Enum.Font.GothamMedium,
		TextColor3 = colors.Text,
		BackgroundColor3 = colors.Surface,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, 348),
		Size = UDim2.new(1, 0, 0, 50),
	}, tools)
	corner(scriptsButton, 10)
	-- Original folder mark built from UI primitives; no emoji or copied asset.
	local folder = create("Frame", {
		Name = "ScriptsFolderAsset",
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 20),
		Size = UDim2.fromOffset(22, 16),
	}, scriptsButton)
	corner(folder, 3)
	create("Frame", {
		Name = "FolderTab",
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(1, -5),
		Size = UDim2.fromOffset(10, 7),
	}, folder)
	connect(scriptsButton.Activated, function()
		engine.WindowSetters.Scripts(true)
	end)

	tools.CanvasSize = UDim2.fromOffset(0, 406)
	local previousLayout = layoutExtras
	layoutExtras = function()
		if previousLayout then
			previousLayout()
		end
		local viewport = root.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then
			return
		end
		for _, window in pairs(engine.Windows) do
			local size = Vector2.new(
				math.min(390, viewport.X - 24),
				math.min(540, viewport.Y - 24)
			)
			window.Panel.Size = UDim2.fromOffset(size.X, size.Y)
			local center =
				clampCenter(extraCenters[window.Panel] or viewport / 2, size)
			extraCenters[window.Panel] = center
			if not portal.Jobs[window.Panel] then
				window.Panel.Position = UDim2.fromOffset(center.X, center.Y)
			end
		end
		if engine.TouchPad then
			local center = clampCenter(
				extraCenters[engine.TouchPad]
					or Vector2.new(viewport.X - 72, viewport.Y - 110),
				Vector2.new(116, 104)
			)
			extraCenters[engine.TouchPad] = center
			engine.TouchPad.Position = UDim2.fromOffset(center.X, center.Y)
		end
		engine.Schedule()
	end
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			engine.Records[other] = { Player = other }
		end
	end
	connect(Players.PlayerAdded, function(other: Player)
		if other ~= player then
			engine.Records[other] = { Player = other }
		end
	end)
	connect(Players.PlayerRemoving, engine.Remove)
	connect(
		UserInputService.InputBegan,
		function(input: InputObject, processed: boolean)
			if processed or UserInputService:GetFocusedTextBox() then
				return
			end
			if input.KeyCode == Enum.KeyCode.End then
				engine.DisableAll()
				return
			end
			if
				input.UserInputType == Enum.UserInputType.MouseButton2
				and toolsState.Aim
			then
				local ok, hits = pcall(function()
					return playerGui:GetGuiObjectsAtPosition(
						input.Position.X,
						input.Position.Y
					)
				end)
				if ok then
					for _, object in ipairs(hits) do
						if object ~= root and object:IsDescendantOf(gui) then
							return
						end
					end
				end

				engine.MouseHeld = true
			end
		end
	)
	connect(UserInputService.InputEnded, function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			engine.MouseHeld = false
		end
		if input == engine.TouchInput then
			engine.TouchInput = nil
		end
	end)
	connect(UserInputService.WindowFocusReleased, function()
		engine.MouseHeld = false
		engine.TouchInput = nil
	end)
	playerToolsBridge.FoldWindows = function()
		engine.WindowSetters.Visuals(false)
		engine.WindowSetters.Aim(false)
		engine.WindowSetters.Scripts(false)
		engine.WindowSetters.GameScript(false)
	end
	playerToolsBridge.Catalog = catalog
	playerToolsBridge.OpenVisuals = function()
		engine.WindowSetters.Visuals(true)
	end
	playerToolsBridge.OpenAim = function()
		engine.WindowSetters.Aim(true)
	end
	playerToolsBridge.OpenScripts = function()
		engine.WindowSetters.Scripts(true)
	end
	playerToolsBridge.Stop = engine.DisableAll
	playerToolsBridge.HideWindows = function()
		engine.DisableAll()
		engine.WindowSetters.Visuals(false)
		engine.WindowSetters.Aim(false)
		engine.WindowSetters.Scripts(false)
		engine.WindowSetters.GameScript(false)
	end
	playerToolsBridge.Style = function(values: { [string]: any })
		for _, window in pairs(engine.Windows) do
			window.Panel.BackgroundTransparency = 1 - values.PanelOpacity / 100
		end
		if engine.TouchPad then
			engine.TouchPad.BackgroundTransparency = 1
				- values.PanelOpacity / 100
		end
	end
	playerToolsBridge.Destroy = function()
		for _, connection in ipairs(catalog.RowConnections) do
			connection:Disconnect()
		end
		table.clear(catalog.RowConnections)
		if engine.Fallback then
			engine.Fallback:Disconnect()
			engine.Fallback = nil
		elseif engine.Bound then
			RunService:UnbindFromRenderStep(engine.BindName)
		end
		for other in pairs(engine.Records) do
			engine.Remove(other)
		end
		engine.ClearHighlights()
		if engine.HighlightFolder then
			engine.HighlightFolder:Destroy()
		end
		if engine.Overlay then
			engine.Overlay:Destroy()
		end
		engine.MouseHeld = false
		engine.TouchInput = nil
	end
end

local busy = false
local loaded = false
local function buttonColor(hovered: boolean)
	if busy or loaded then
		return
	end
	tween(launch, {
		BackgroundColor3 = if hovered
			then CONFIG.Accent:Lerp(Color3.new(1, 1, 1), 0.16)
			else CONFIG.Accent,
	})
end
connect(launch.MouseEnter, function()
	buttonColor(true)
end)
connect(launch.MouseLeave, function()
	buttonColor(false)
end)
connect(launch.SelectionGained, function()
	buttonColor(true)
end)
connect(launch.SelectionLost, function()
	buttonColor(false)
end)

connect(launch.Activated, function()
	if busy or loaded or not alive then
		return
	end
	busy = true
	launch.Text = "Loading…"
	launch.Selectable = false
	status.TextColor3 = colors.Muted
	progressFill.BackgroundColor3 = CONFIG.Accent
	tween(launch, { BackgroundColor3 = CONFIG.Accent })
	tween(progressFill, { Size = UDim2.fromScale(0, 1) }, 0)

	-- No downloaded code, artificial loading delays, or simulated network checks.
	local ok, result = pcall(function(): boolean
		status.Text = "Waiting for the game…"
		while not game:IsLoaded() do
			if not alive then
				return false
			end
			task.wait(0.1)
		end
		if not alive then
			return false
		end
		tween(progressFill, { Size = UDim2.fromScale(0.2, 1) })
		local app = if appContainer
			then appContainer:FindFirstChild("App")
			else nil
		if not app then
			return false
		end
		assert(app:IsA("ModuleScript"), "App must be a ModuleScript")
		status.Text = "Starting your app…"
		local initialize = require(app)
		assert(type(initialize) == "function", "App must return a function")
		if not alive then
			return false
		end
		initialize({
			Player = player,
			-- Report real work completed: 0 to 1, not an estimated timer.
			SetProgress = function(fraction: number, message: string?)
				if not alive then
					return
				end
				assert(
					type(fraction) == "number" and fraction == fraction,
					"Progress must be a number"
				)
				tween(progressFill, {
					Size = UDim2.fromScale(
						0.2 + math.clamp(fraction, 0, 1) * 0.8,
						1
					),
				})
				if message then
					status.Text = message
				end
			end,
			IsCancelled = function(): boolean
				return not alive
			end,
		})
		return true
	end)
	if not alive then
		return
	end
	busy = false
	launch.Selectable = true
	if ok then
		loaded = true
		launch.Text = "Ready  ✓"
		status.Text = if result
			then "App and tools ready."
			else "Tools ready. Make yourself at home."
		showTools()
		status.TextColor3 = colors.Success
		tween(
			progressFill,
			{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = colors.Success }
		)
	else
		launch.Text = "Try again  →"
		status.Text = "Could not start. See Output for details."
		status.TextColor3 = colors.Error
		tween(
			progressFill,
			{ Size = UDim2.fromScale(0, 1), BackgroundColor3 = colors.Error }
		)
		warn("[Nullx11] App failed: " .. tostring(result))
	end
end)

connect(gui.Destroying, function()
	alive = false
	table.clear(portal.Jobs)
	if playerToolsBridge.Destroy then
		playerToolsBridge.Destroy()
	end
	if studioBridge.Destroy then
		studioBridge.Destroy()
	end
	drag = nil
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	table.clear(connections)
	table.clear(themeRefreshers)
	for _, animations in pairs(activeTweens) do
		for _, animation in pairs(animations) do
			animation:Cancel()
		end
	end
	table.clear(activeTweens)
end)

-- Native-UI gravity well: concentric lenses, orbital dust, implosion, shockwave.
do
	if
		CONFIG.StartupAnimation
		and not CONFIG.ReducedMotion
		and not CONFIG.EnhancedWorkspace
	then
		card.Visible = false
		mini.Visible = false
		local intro = create("Frame", {
			Name = "StartupWhirlpool",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(8, 12, 24),
			BackgroundTransparency = 0.03,
			BorderSizePixel = 0,
			ZIndex = 50,
			Active = true,
			ClipsDescendants = true,
		}, root)
		create("UIGradient", {
			Color = ColorSequence.new(
				Color3.fromRGB(14, 18, 38),
				Color3.fromRGB(7, 19, 28)
			),
			Rotation = 38,
		}, intro)
		local lenses = {}
		for index = 1, 3 do
			local lens = create("Frame", {
				Name = "GravityLens" .. index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Rotation = -24 + index * 17,
			}, intro)
			corner(lens, 1000)
			local outline = create("UIStroke", {
				Color = if index == 2
					then Color3.fromRGB(120, 238, 226)
					else CONFIG.Accent,
				Thickness = if index == 2 then 2 else 1,
				Transparency = 0.4 + index * 0.1,
			}, lens)
			table.insert(lenses, { Frame = lens, Stroke = outline })
		end
		local particles = {}
		for index = 1, 48 do
			local particle = create("Frame", {
				Name = "WhirlpoolParticle" .. index,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(2 + index % 3, 8 + index % 5 * 3),
				BackgroundColor3 = if index % 3 == 0
					then Color3.fromRGB(128, 240, 228)
					elseif index % 7 == 0 then Color3.fromRGB(
						255,
						218,
						157
					)
					else CONFIG.Accent,
				BorderSizePixel = 0,
			}, intro)
			corner(particle, 3)
			table.insert(particles, particle)
		end
		local center = create("Frame", {
			Name = "WhirlpoolCenter",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(80, 80),
			BackgroundColor3 = colors.Panel,
			BorderSizePixel = 0,
			ZIndex = 3,
		}, intro)
		corner(center, 24)
		local coreStroke = create(
			"UIStroke",
			{ Color = CONFIG.Accent, Thickness = 2, Transparency = 0.1 },
			center
		)
		local insignia = drawIcon(
			center,
			Color3.fromRGB(164, 244, 233),
			UDim2.fromScale(0.2, 0.2),
			48
		)
		insignia.Size = UDim2.fromScale(0.6, 0.6)
		local wordmark = label(intro, "NULLX11", 27, colors.Text)
		wordmark.Name = "StartupWordmark"
		wordmark.Font = Enum.Font.Arcade
		wordmark.ZIndex = 5
		wordmark.AnchorPoint = Vector2.new(0.5, 0.5)
		wordmark.Size = UDim2.fromOffset(320, 40)
		wordmark.TextXAlignment = Enum.TextXAlignment.Center
		local caption =
			label(intro, "GRAVITY CORE / OPENING WORKSPACE", 14, colors.Muted)
		caption.Name = "StartupCaption"
		caption.ZIndex = 5
		caption.AnchorPoint = Vector2.new(0.5, 0.5)
		caption.Size = UDim2.new(1, -32, 0, 30)
		caption.TextXAlignment = Enum.TextXAlignment.Center
		local skip = create("TextButton", {
			Name = "SkipStartup",
			Text = "Skip animation  →",
			Font = Enum.Font.GothamMedium,
			TextSize = 16,
			TextColor3 = colors.Text,
			BackgroundColor3 = colors.Surface,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -18),
			Size = UDim2.fromOffset(190, 46),
			ZIndex = 6,
		}, intro)
		corner(skip, 13)
		local elapsed, rotation = 0, 0
		local finished = false
		local animation: RBXScriptConnection? = nil
		local function finish(immediate: boolean?)
			if finished or not alive then
				return
			end
			finished = true
			if animation then
				animation:Disconnect()
			end
			intro:Destroy()
			mini.Visible = true
			layout()
			if immediate then
				card.Visible = expanded
			elseif expanded then
				portal.Play(card, true)
			end
		end
		connect(skip.Activated, function()
			finish(true)
		end)
		animation = connect(RunService.RenderStepped, function(dt: number)
			if finished or not alive then
				return
			end
			local viewport = root.AbsoluteSize
			local short = viewport.Y > 0 and viewport.Y < 420
			wordmark.Position = if short
				then UDim2.new(0.5, 0, 0, 30)
				else UDim2.new(0.5, 0, 0.5, 126)
			caption.Position = if short
				then UDim2.new(0.5, 0, 0, 62)
				else UDim2.new(0.5, 0, 0.5, 166)
			rotation += math.min(dt, 0.1) * 3.2
			if game:IsLoaded() then
				elapsed += dt
				caption.Text = "GRAVITY CORE / OPENING WORKSPACE"
			else
				caption.Text = "Waiting for the game / Skip is available"
			end
			local pull = math.clamp(elapsed / 1.25, 0, 1)
			local burst = math.clamp((elapsed - 1.25) / 0.7, 0, 1)
			local collapsing = elapsed < 1.25
			local baseRadius =
				math.clamp(math.min(viewport.X, viewport.Y) * 0.48, 90, 220)
			for index, lens in ipairs(lenses) do
				local diameter = if collapsing
					then (baseRadius * 2 + index * 26) * (1 - pull ^ 2) + 10
					else 10 + burst * (baseRadius * 3 + index * 80)
				lens.Frame.Size =
					UDim2.fromOffset(diameter, diameter * (0.42 + index * 0.12))
				lens.Frame.Rotation = -24
					+ index * 17
					+ math.deg(rotation)
						* 0.1
						* (if index % 2 == 0 then -1 else 1)
				lens.Stroke.Transparency = if collapsing
					then 0.35 + index * 0.12
					else math.clamp(0.25 + burst * 0.75, 0, 1)
			end
			local core = if collapsing
				then 80 * (1 - pull) ^ 0.7 + 5
				else 5 + burst * 100
			center.Size = UDim2.fromOffset(core, core)
			center.Rotation = if collapsing
				then -pull * 100
				else -100 + burst * 145
			center.BackgroundTransparency = if collapsing then 0.05 else burst
			coreStroke.Transparency = if collapsing then 0.1 else burst
			wordmark.TextTransparency = math.clamp((pull - 0.65) / 0.35, 0, 1)
			for index, particle in ipairs(particles) do
				local angle = index * 2.399963
					+ rotation * (0.75 + index % 3 * 0.2)
					+ pull * 8
				local radius = if collapsing
					then (baseRadius + index % 5 * 12) * (1 - pull) ^ 1.6
					else burst * (baseRadius * 1.4 + index % 5 * 28)
				particle.Position = UDim2.new(
					0.5,
					math.cos(angle) * radius,
					0.5,
					math.sin(angle) * radius * 0.65
				)
				particle.Rotation = math.deg(angle) + 90
				particle.BackgroundTransparency = if collapsing
					then 0.15 + pull * 0.2
					else burst
			end
			intro.BackgroundTransparency = if collapsing
				then 0.03
				else 0.03 + burst * 0.97
			if elapsed >= 1.95 then
				finish()
			end
		end)
	end
end

-- Primary Nullx11 workspace. Uses the supplied +1 UI as its actual renderer.
-- Existing player tools and Design Studio remain live, not recreated as demos.
do
	if CONFIG.EnhancedWorkspace then
		local library
		local ok, reason = pcall(function()
			library = createNullx11UI({
				Id = "Workspace",
				ReducedMotion = CONFIG.ReducedMotion,
			})
			local window
			local function secondary(action)
				if window then
					window:SetVisible(false)
				end
				action()
			end
			local function build()
				window = library.Window
				window.OnShow = function()
					expanded = false
					card.Visible = false
					mini.Visible = false
					if playerToolsBridge.FoldWindows then
						playerToolsBridge.FoldWindows()
					end
				end
				local home = window:AddTab(
					"Workspace",
					"home",
					"Your session, without the clutter"
				)
				local welcomeGroup =
					home:AddLeftGroupbox("Nullx11 / session", "star")
				welcomeGroup:AddParagraph({
					Title = "Nullx11 / Developed by Gab",
					Content = "Shared +1 interface, native player tools and five separate game workspaces. Nothing plays or farms until you enable it.",
				})
				local live = welcomeGroup:AddLabel("Reading current session...")
				library:Every(1, function()
					if not alive or not window.Visible then
						return
					end
					live:SetText(
						string.format(
							"%s / %d FPS / %d players / place %s",
							player.DisplayName,
							library:GetFPS(),
							#Players:GetPlayers(),
							tostring(game.PlaceId)
						)
					)
				end)
				local actions =
					home:AddRightGroupbox("Open a window", "settings")
				actions:AddButton({
					Text = "Open Scripts library",
					Func = function()
						secondary(playerToolsBridge.OpenScripts)
					end,
				})
				actions:AddButton({
					Text = "Open Visuals / ESP",
					Func = function()
						secondary(playerToolsBridge.OpenVisuals)
					end,
				})
				actions:AddButton({
					Text = "Open Aim / FOV",
					Func = function()
						secondary(playerToolsBridge.OpenAim)
					end,
				})
				actions:AddButton({
					Text = "Open Design Studio",
					Func = function()
						secondary(studioBridge.Open)
					end,
				})
				actions:AddButton({
					Text = "Open classic launcher / App hook",
					Func = function()
						secondary(function()
							setExpanded(true)
							mini.Visible = true
						end)
					end,
				})
				actions:AddButton({
					Text = "Stop aim and visuals",
					Style = "Danger",
					Func = playerToolsBridge.Stop,
				})

				local scriptsTab = window:AddTab(
					"Scripts",
					"code",
					"Open a game workspace; no ON/OFF navigation"
				)
				local catalog = playerToolsBridge.Catalog
				for _, entry in ipairs(catalog.Entries) do
					local group = scriptsTab:AddLeftGroupbox(entry.Name, "play")
					group:AddParagraph({
						Title = entry.GamePlaceId and ("Place " .. tostring(
							entry.GamePlaceId
						)) or "Game-module compatibility check",
						Content = entry.Description,
					})
					group:AddLabel(entry.Author)
					group:AddButton({
						Text = "Open game launch window",
						Func = function()
							-- Resolve again: a refreshed manifest can remove or replace an entry.
							local selected
							for _, current in ipairs(catalog.Entries) do
								if current.Id == entry.Id then
									selected = current
									break
								end
							end
							if not selected then
								library:Notify(
									"Scripts",
									"This entry changed. Open the refreshed Scripts library.",
									5,
									"Warning"
								)
								return
							end
							secondary(function()
								catalog.OpenGame(selected)
							end)
						end,
					})
				end
				local more = scriptsTab:AddRightGroupbox(
					"Repository library",
					"settings"
				)
				more:AddParagraph({
					Title = "Separate game windows",
					Content = "No teleport questions or automatic game joins. Unsupported games show a compatibility message. Executed game windows keep running when this loader is unloaded.",
				})
				more:AddButton({
					Text = "Browse / refresh GitHub library",
					Func = function()
						secondary(playerToolsBridge.OpenScripts)
					end,
				})
				more:AddParagraph({
					Title = "Runtime requirements",
					Content = "Game execution needs client loadstring and HTTP. Delta capabilities vary by build. If unavailable, a visible error replaces execution; no simulated gameplay is substituted.",
				})

				local toolsTab = window:AddTab(
					"Session tools",
					"teleport",
					"Bookmarks, coordinates and performance"
				)
				local toolsGroup =
					toolsTab:AddLeftGroupbox("Floating tools", "settings")
				toolsGroup:AddButton({
					Text = "Open teleport / save-return",
					Func = function()
						secondary(function()
							setTeleportEnabled(true)
						end)
					end,
				})
				toolsGroup:AddToggle("WorkspaceReducedMotion", {
					Text = "Reduced motion",
					Default = CONFIG.ReducedMotion,
					NoSave = true,
					Callback = function(value)
						studioBridge.Motion(value)
					end,
				})
				toolsGroup:AddToggle("WorkspaceFPS", {
					Text = "Floating FPS meter",
					Default = false,
					NoSave = true,
					Callback = setFPSEnabled,
				})
				toolsGroup:AddToggle("WorkspaceCoordinates", {
					Text = "Floating position HUD",
					Default = false,
					NoSave = true,
					Callback = setHUDEnabled,
				})
				toolsGroup:AddToggle("WorkspaceGlitch", {
					Text = "Animated glitch title",
					Default = glitchEnabled,
					NoSave = true,
					Callback = function(value)
						setGlitchEnabled(value)
						library:SetTitleGlitch(value)
					end,
				})
				local safety =
					toolsTab:AddRightGroupbox("Session control", "shield")
				safety:AddButton({
					Text = "Unload launched game scripts",
					Style = "Danger",
					DoubleClick = true,
					Func = function()
						local env = type(getgenv) == "function" and getgenv()
							or _G
						local sessions = env.Nullx11GameSessions
						if type(sessions) == "table" then
							local snapshot = table.clone(sessions)
							for _, session in pairs(snapshot) do
								pcall(session.Unload)
							end
						end
						library:Notify(
							"Session",
							"Stopped registered game sessions by your explicit request.",
							6,
							"Info"
						)
					end,
				})
				safety:AddParagraph({
					Title = "Cleanup and consent",
					Content = "Unload closes only this loader and its native tools. Executed game scripts keep their own windows and controls. Use their Unload action, or the separate confirmed stop button above, to stop them.",
				})
				window:AddSettingsTab()
				library:SetTitleGlitch(glitchEnabled)
			end
			playerToolsBridge.ReducedMotion = function(value)
				library:SetReducedMotion(value)
				library:SetTitleGlitch(not value and glitchEnabled)
				if value and library.Options.WorkspaceGlitch then
					library.Options.WorkspaceGlitch:SetValue(false)
				end
				local env = type(getgenv) == "function" and getgenv() or _G
				env.Nullx11ReducedMotion = value == true
			end
			library:CreateWindow({
				Title = "Nullx11",
				SubTitle = "Developed by Gab",
				Theme = "Nullx11",
				MenuKey = appearance.ToggleKey,
				ConfigFolder = "Nullx11 Workspace",
				Intro = false,
				Watermark = false,
				OnUnlocked = build,
			})
			playerToolsBridge.BeginExecution = function(title)
				return library:BeginExecution(title)
			end
			-- The shared interface is the entry point; the older UI is an advanced
			-- compatibility surface, available deliberately through Workspace.
			playerToolsBridge.PrimaryActive = true
			expanded = false
			card.Visible = false
			mini.Visible = false
			library:OnUnload(function()
				if alive then
					gui:Destroy()
				end
			end)
			connect(gui.Destroying, function()
				-- Games have independent ownership/lifetimes. Never stop them here.
				library:Unload()
			end)
		end)
		if not ok then
			playerToolsBridge.PrimaryActive = false
			if library then
				pcall(library.Unload, library)
			end
			expanded = true
			card.Visible = true
			mini.Visible = true
			status.Text =
				"Shared UI could not start; classic controls remain available."
			warn("[Nullx11 workspace] " .. tostring(reason))
		end
	end
end
