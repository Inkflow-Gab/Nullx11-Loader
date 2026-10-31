-- GENERATED from src/ by tools/build.mjs. Edit the sources, then run npm run build.
-- stealabrainrot. See docs/SOURCE-PROVENANCE.md for authorship and restrictions.
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
				SubTitle = title .. " / Gab",
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

local makeOwnedRuntime = (function()
	-- Owns only the selected controller's work; never registered with loader cleanup.
	-- Source callbacks, tasks, render bindings and newly-created Instances are scoped here.
	return function(context)
		local realTask, realInstance = task, Instance
		local runtime = {
			Alive = true,
			Ready = false,
			Connections = {},
			Threads = {},
			Pending = {},
			Instances = setmetatable({}, { __mode = "k" }),
			Cleanups = {},
			Restores = {},
			RenderNames = {},
		}
		local function allowed()
			return runtime.Alive
				or (
					runtime.CleanupThread ~= nil
					and runtime.CleanupThread
						== (coroutine.running() or runtime)
				)
		end
		function runtime.Guard(callback)
			assert(type(callback) == "function", "Invalid controller callback")
			return function(...)
				if
					not allowed()
					or (not runtime.Ready and not runtime.CleanupThread)
				then
					return
				end
				local thread = coroutine.running()
				local wasTracked = thread and runtime.Threads[thread]
				if thread then
					runtime.Threads[thread] = true
				end
				local result = table.pack(pcall(callback, ...))
				if thread and not wasTracked then
					runtime.Threads[thread] = nil
				end
				if not result[1] then
					if runtime.Alive then
						warn("[Nullx11 stealabrainrot] " .. tostring(result[2]))
					end
					return
				end
				return table.unpack(result, 2, result.n)
			end
		end
		function runtime.Track(connection)
			if not runtime.Alive then
				connection:Disconnect()
				return connection
			end
			-- Prune disconnected source listeners; do not retain every historical ESP listener.
			for tracked in pairs(runtime.Connections) do
				if not tracked.Connected then
					runtime.Connections[tracked] = nil
				end
			end
			runtime.Connections[connection] = true
			return connection
		end
		local function launch(mode, delay, callback, ...)
			if not allowed() then
				return nil
			end
			local args = table.pack(...)
			local thread = coroutine.create(function()
				local ok, reason =
					pcall(callback, table.unpack(args, 1, args.n))
				runtime.Threads[coroutine.running()] = nil
				if not ok and runtime.Alive then
					warn("[Nullx11 stealabrainrot worker] " .. tostring(reason))
				end
			end)
			runtime.Threads[thread] = true
			local function start()
				if not runtime.Alive or coroutine.status(thread) == "dead" then
					runtime.Threads[thread] = nil
					return
				end
				if mode == "delay" then
					realTask.delay(delay, thread)
				elseif mode == "defer" then
					realTask.defer(thread)
				else
					realTask.spawn(thread)
				end
			end
			if runtime.Ready then
				start()
			else
				table.insert(runtime.Pending, start)
			end
			return thread
		end
		runtime.Task = setmetatable({
			spawn = function(callback, ...)
				return launch("spawn", 0, callback, ...)
			end,
			defer = function(callback, ...)
				return launch("defer", 0, callback, ...)
			end,
			delay = function(delay, callback, ...)
				return launch("delay", delay, callback, ...)
			end,
			wait = function(delay)
				assert(allowed(), "Game session stopped")
				local elapsed = realTask.wait(delay)
				assert(allowed(), "Game session stopped")
				return elapsed
			end,
			cancel = function(thread)
				runtime.Threads[thread] = nil
				return realTask.cancel(thread)
			end,
		}, { __index = realTask })
		runtime.Instance = {
			new = function(class, parent)
				assert(allowed(), "Game session stopped")
				local instance = realInstance.new(class, parent)
				runtime.Instances[instance] = true
				return instance
			end,
		}
		function runtime.BindRender(service, name, priority, callback)
			runtime.RenderNames[name] = service
			service:BindToRenderStep(name, priority, runtime.Guard(callback))
		end
		function runtime.Start()
			runtime.Ready = true
			local pending = runtime.Pending
			runtime.Pending = {}
			for _, start in ipairs(pending) do
				start()
			end
		end
		function runtime.Cleanup(callback)
			table.insert(runtime.Restores, callback)
			return runtime.Guard(callback)
		end
		function runtime.AddCleanup(callback)
			table.insert(runtime.Cleanups, callback)
		end
		function runtime.Destroy()
			if not runtime.Alive then
				return
			end
			runtime.Alive = false
			runtime.CleanupThread = coroutine.running() or runtime
			-- Disable controls and run the source's restoration hooks before disconnecting.
			for i = #runtime.Cleanups, 1, -1 do
				pcall(runtime.Cleanups[i])
			end
			for i = #runtime.Restores, 1, -1 do
				pcall(runtime.Restores[i])
			end
			for instance in pairs(runtime.Instances) do
				if
					instance:IsA("BindableEvent")
					and instance.Name == "Cleanup"
				then
					pcall(function()
						instance:Fire()
					end)
				end
			end
			for name, service in pairs(runtime.RenderNames) do
				pcall(function()
					service:UnbindFromRenderStep(name)
				end)
			end
			for connection in pairs(runtime.Connections) do
				pcall(function()
					connection:Disconnect()
				end)
			end
			for thread in pairs(runtime.Threads) do
				if thread ~= coroutine.running() then
					pcall(realTask.cancel, thread)
				end
			end
			for instance in pairs(runtime.Instances) do
				pcall(function()
					instance:Destroy()
				end)
			end
			table.clear(runtime.Pending)
			table.clear(runtime.Connections)
			table.clear(runtime.Threads)
			table.clear(runtime.Instances)
			runtime.CleanupThread = nil
		end
		context.RegisterCleanup(runtime.Destroy)
		return runtime
	end
end)()
local makeChilliAdapter = (function()
	-- API bridge for the supplied recovered controller, rendered ONLY by Nullx11.
	-- Chilli's downloaded UI, quick-bar bootstrap, profile autoload and telemetry are not used.
	return function(library, runtime)
		local adapter = {}
		local controls, states, sequence = {}, {}, 0
		local window
		adapter.Notify = function(title, content, duration)
			library:Notify(title, content, duration or 5)
		end
		function adapter:CreateWindow(_spec)
			local native = library:CreateWindow({
				Title = "Nullx11",
				SubTitle = "stealabrainrot / Gab",
				Theme = "Nullx11",
				Intro = false,
				Watermark = false,
				MenuKey = Enum.KeyCode.LeftControl,
				ConfigFolder = "Nullx11 stealabrainrot",
			})
			window = { Native = native, _destroyed = false }
			function window:Open()
				native:SetVisible(true)
			end
			function window:GetDefaultTab()
				return self.DefaultTab
			end
			function window:CreateState(spec)
				local state = library.Ref(spec.Default)
				states[spec.Name] = state
				return state
			end
			function window:GetState(name)
				return states[name]
			end
			function window:CreateTab(spec)
				local title = type(spec) == "table" and spec.Name or spec
				local icons = {
					Stealer = "brain",
					Helper = "settings",
					Player = "user",
					ESP = "eye",
					Misc = "settings",
					Server = "server",
					["Source limitations"] = "info",
				}
				local tabNative = native:AddTab(
					title,
					icons[title],
					"stealabrainrot / Nullx11"
				)
				local tab = { Native = tabNative }
				if not self.DefaultTab then
					self.DefaultTab = tab
				end
				function tab:CreateSection(spec)
					local group = tabNative:AddLeftGroupbox(spec.Name)
					local section = {}
					local function build(kind, info)
						sequence += 1
						local key = "Brainrot_" .. sequence
						local element = {
							Spec = info,
							Kind = kind,
							Value = kind == "Toggle" and false or info.Default,
						}
						if kind == "Toggle" then
							element.Value = false
						end
						local function callback(value)
							element.Value = value
							if info.Callback then
								runtime.Guard(info.Callback)(value)
							end
						end
						local spec = {
							Text = info.Name,
							Description = info.Note,
							Default = element.Value,
							Callback = callback,
						}
						local control
						if kind == "Toggle" then
							control = group:AddToggle(key, spec)
						elseif kind == "Slider" then
							spec.Min, spec.Max = info.Min, info.Max
							spec.Rounding = info.AllowDecimals
									and math.clamp(
										math.ceil(
											-math.log10(info.Increment or 0.1)
										),
										0,
										6
									)
								or 0
							control = group:AddSlider(key, spec)
						elseif
							kind == "Dropdown" or kind == "MultiDropdown"
						then
							spec.Values, spec.Multi =
								info.Options or {}, kind == "MultiDropdown"
							control = group:AddDropdown(key, spec)
						elseif kind == "Input" then
							spec.Placeholder, spec.Finished =
								info.Placeholder, true
							control = group:AddInput(key, spec)
						elseif kind == "Button" then
							spec.Func = runtime.Guard(info.Callback)
							-- Purchasing/unlocking and kicking/resetting are still explicit user actions.
							spec.DoubleClick = info.Name:find(
								"Unlock Floor",
								1,
								true
							) ~= nil or info.Name == "Kick" or info.Name == "Fast Reset"
							control = group:AddButton(spec)
						else
							control = group:AddParagraph({
								Title = info.Name,
								Content = info.Text or info.Note or "",
							})
						end
						element.Native = control
						function element:Get()
							return control.Value ~= nil and control.Value
								or self.Value
						end
						function element:Set(value, fire)
							local saved = control.Callback
							if fire == false then
								control.Callback = nil
							end
							if control.SetValue then
								control:SetValue(value)
							else
								control:SetContent(tostring(value))
							end
							control.Callback = saved
							self.Value = value
						end
						function element:SetRange(min, max, fire)
							local callback = control.Callback
							if fire == false then
								control.Callback = nil
							end
							control:SetRange(min, max)
							control.Callback = callback
						end
						function element:SetOptions(values, value, fire)
							control:SetValues(values)
							if value ~= nil then
								self:Set(value, fire)
							end
						end
						function element:GetUnit()
							return self.Unit
						end
						local unit = info.Unit
						if type(unit) == "table" then
							element.Unit = unit.Default
							element.UnitNative =
								group:AddDropdown(key .. "_Unit", {
									Text = info.Name .. " / unit",
									Values = unit.Options,
									Default = unit.Default,
									Callback = function(value)
										element.Unit = value
										if unit.Callback then
											runtime.Guard(unit.Callback)(value)
										end
									end,
								})
						end
						local parent = info.ShowWhen or info.SubOf
						if
							parent
							and parent.Native
							and parent.Native.Ref
							and control.SetVisible
						then
							library.Watch(parent.Native.Ref, function(value)
								control:SetVisible(value == true)
								if element.UnitNative then
									element.UnitNative:SetVisible(value == true)
								end
							end, { Immediate = true })
							control:SetVisible(parent:Get() == true)
						end
						table.insert(controls, element)
						return element
					end
					for _, kind in ipairs({
						"Toggle",
						"Slider",
						"Dropdown",
						"MultiDropdown",
						"Input",
						"Button",
						"Text",
					}) do
						section["Create" .. kind] = function(_, info)
							return build(kind, info)
						end
					end
					return section
				end
				return tab
			end
			library:OnUnload(function()
				window._destroyed = true
			end)
			return window
		end
		function adapter:Finalize(_spec)
			-- All source locals exist now. Synchronize OFF states before any worker runs.
			for _, element in ipairs(controls) do
				if element.Kind == "Toggle" and element.Spec.Callback then
					local ok, reason = pcall(element.Spec.Callback, false)
					if not ok then
						warn(
							"[Nullx11 init / "
								.. element.Spec.Name
								.. "] "
								.. tostring(reason)
						)
					end
				end
			end
			runtime.Ready = true
			runtime.AddCleanup(function()
				for i = #controls, 1, -1 do
					local element = controls[i]
					if element.Kind == "Toggle" and element.Spec.Callback then
						pcall(element.Spec.Callback, false)
					end
				end
			end)
			for _, element in ipairs(controls) do
				-- Do not set the device's FPS cap merely by opening a window.
				if
					element.Kind ~= "Toggle"
					and element.Kind ~= "Button"
					and element.Kind ~= "Text"
					and element.Spec.Name ~= "FPS Cap"
					and element.Spec.Callback
				then
					local ok, reason =
						pcall(element.Spec.Callback, element:Get())
					if not ok then
						warn(
							"[Nullx11 default / "
								.. element.Spec.Name
								.. "] "
								.. tostring(reason)
						)
					end
				end
			end
			local tab = window.Native:AddTab(
				"Nullx11",
				"settings",
				"Session / provenance / manual configuration"
			)
			local group = tab:AddLeftGroupbox("stealabrainrot / Gab")
			group:AddParagraph({
				Title = "Supplied recovered source",
				Content = "Adapted from the supplied Chilli controller. Live game compatibility is unverified. AP/TP/Priority were absent in the source; no working replacements are claimed. Automation and overlays start OFF.",
			})
			group:AddButton({
				Text = "Unload this game script",
				DoubleClick = true,
				Func = function()
					library:Unload()
				end,
			})
			window.Native:AddSettingsTab()
			window.Native:SelectTab(window.DefaultTab.Native)
			runtime.Start()
		end
		return adapter
	end
end)()
local wrongPlace = (function()
	-- Compatibility notice only. Never teleports, queues code or starts a controller.
	return function(library, entry, _url)
		library:CreateWindow({
			Title = "Nullx11",
			SubTitle = entry.Name .. " / Gab",
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
					Content = entry.Author or "Developed by Gab",
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
	-- stealabrainrot / Nullx11 adaptation by Gab.
	-- Source: user-supplied StealB.deobfuscated.lua.txt (recovered Chilli controller).
	-- Telemetry/config exfiltration, remote UI and original arrival loader removed.
	-- See docs/BRAINROT-REVIEW.md for incomplete-source and validation limitations.
	local runtime = context.Runtime
	local task, Instance = runtime.Task, runtime.Instance
	local _G = {} -- source-internal flags, isolated from other scripts and the loader
	local originalCap
	local nativeSetCap = setfpscap
	local capChanged = false
	local setfpscap = type(nativeSetCap) == "function"
			and function(value)
				if not capChanged and type(getfpscap) == "function" then
					local ok, cap = pcall(getfpscap)
					if ok and type(cap) == "number" then
						originalCap = cap
					end
				end
				capChanged = true
				return nativeSetCap(value)
			end
		or nil
	runtime.AddCleanup(function()
		if capChanged and originalCap then
			pcall(nativeSetCap, originalCap)
		end
	end)

	-- dsc.gg/oxyenv

	local chilliGithubFastManualDefaultsRu, v, v2, defaultTab, esp, Misc, Server, v3, Players, RunService
	local Workspace, Lighting, CoreGui, HttpService, ReplicatedStorage, UserInputService, TeleportService, TextService, Stats, localPlayer
	local v4, fn, obj, tbl, v5, flag, fn2, tbl2, fn3, v6
	local v7, v8

	do
		local v9, ContextActionService, v10, v11

		do
			local Helper, ProximityPromptService, TweenService, v12, str, n, flag2, flag3, flag4, n2
			local flag5, n3, flag6, n4, RagdollController, UserInputService2, connection, flag7, n5, n6
			local prompt, tbl3, n7, folder, bindableEvent, fn4, fn5, fn6, fn7, fn8
			local fn9, prompt2, fn10, fn11, fn12, str2, fn13, fn14, screenGui, fn15
			local fn16, fn17, fn18, fn19, screenGui2, frame, textLabel, textLabel2, frame2

			do
				-- Rerun ownership is handled by the independent Nullx11 game context.
				chilliGithubFastManualDefaultsRu =
					{ Status = "loading", StartedAt = os.clock() }
				_G.__Nullx11BrainrotGithubFastManualDefaultsRun =
					chilliGithubFastManualDefaultsRu

				v = context.ChilliAdapter
				v2 = v:CreateWindow({ Name = "Nullx11", DefaultTab = "Main" })
				chilliGithubFastManualDefaultsRu.Window = v2
				defaultTab = v2:GetDefaultTab()
				local v13

				do
					local Stealer = v2:CreateTab("Stealer")
					Helper = v2:CreateTab("Helper")
					v9 = v2:CreateTab({
						Name = "Player",
						SectionsExpanded = false,
					})
					esp = v2:CreateTab("ESP")
					Misc = v2:CreateTab("Misc")
					Server = v2:CreateTab("Server")
					v3 = v2:CreateTab("Source limitations")
					Players = game:GetService("Players")
					RunService = game:GetService("RunService")
					Workspace = game:GetService("Workspace")
					Lighting = game:GetService("Lighting")
					CoreGui = context.Library:GetGuiParent()
					HttpService = game:GetService("HttpService")
					ReplicatedStorage = game:GetService("ReplicatedStorage")
					UserInputService = game:GetService("UserInputService")
					ContextActionService =
						game:GetService("ContextActionService")
					TeleportService = game:GetService("TeleportService")
					ProximityPromptService =
						game:GetService("ProximityPromptService")
					TextService = game:GetService("TextService")
					TweenService = game:GetService("TweenService")
					Stats = game:GetService("Stats")
					localPlayer = Players.LocalPlayer
					local str3 =
						"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
					v4 = Random.new()

					fn = function()
						local v14 = table.create(64)
						local str4 = HttpService:GenerateGUID(false)
							:gsub("-", "")

						for i_ = 1, #str4 do
							v14[#v14 + 1] = str4:sub(i_, i_)
						end

						for i_ = 1, 32 do
							local v15 = v4:NextInteger(1, #str3)
							v14[#v14 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(
								v15,
								v15
							)
						end

						for i_ = #v14, 2, -1 do
							local v15 = v4:NextInteger(1, i_)
							local v16 = v14[i_]
							v14[i_] = v14[v15]
							v14[v15] = v16
						end

						return table.concat(v14)
					end

					obj = setmetatable({}, { __mode = "k" })
					tbl = {}
					v12 = Stealer:CreateSection({
						Name = "Auto Steal Brainrot",
						Expanded = true,
					})
					v13 = Stealer:CreateSection({
						Name = "Auto Kick",
						Expanded = true,
					})
				end

				do
					local flag8 = false
					local flag9 = true
					local flag10 = false
					local n8 = 0
					local n9 = 1000000
					local v14 = nil
					local n10 = -math.huge
					local tbl4 = {}
					local obj2 = setmetatable({}, { __mode = "k" })
					local tbl5 = {}

					pcall(function()
						local Animals = require(ReplicatedStorage.Datas.Animals)

						if type(Animals) == "table" then
							tbl5 = Animals
						end
					end)

					local function fn21(arg)
						local match, v15 = tostring(arg or "")
							:gsub("[%$,/s]", "")
							:gsub("%s+", "")
							:match("^([%d%.]+)([KkMmBbTt]?)$")
						if not match then
							return nil
						end
						local num = tonumber(match)
						if not num then
							return nil
						end
						return num
							* (
								({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(
									v15
								)] or 1
							)
					end

					local function fn22(arg)
						local v15 = tbl5[tostring(arg or "")]
						return type(v15) == "table" and tonumber(v15.Generation)
							or 0
					end

					local function fn23()
						local tbl6 = {}
						local debris = Workspace:FindFirstChild("Debris")
						if not debris then
							return tbl6
						end

						for _, child in ipairs(debris:GetChildren()) do
							if
								child:IsA("BasePart")
								and child.Name == "FastOverheadTemplate"
							then
								local animalOverhead =
									child:FindFirstChild("AnimalOverhead")
								local displayName = animalOverhead
									and animalOverhead:FindFirstChild(
										"DisplayName"
									)
								animalOverhead = animalOverhead
									and animalOverhead:FindFirstChild(
										"Generation"
									)

								if
									displayName
									and animalOverhead
									and displayName:IsA("TextLabel")
									and animalOverhead:IsA("TextLabel")
								then
									local v15 = fn21(animalOverhead.Text)

									if v15 then
										local str3 = tostring(displayName.Text)
										tbl6[str3] = tbl6[str3] or {}
										tbl6[str3][#tbl6[str3] + 1] = {
											Position = child.Position,
											Generation = v15,
										}
									end
								end
							end
						end

						return tbl6
					end

					local function fn24(arg, arg2, arg3)
						local generation = fn22(arg)
						if not arg2 then
							return generation
						end
						local v15, v16, v17 =
							ipairs((arg3 or fn23())[tostring(arg or "")] or {})
						local n11 = 14

						for _, v18 in v15, v16, v17 do
							local magnitude = (v18.Position - arg2).Magnitude

							if magnitude < n11 then
								generation = v18.Generation
								n11 = magnitude
							end
						end

						return generation
					end

					local function fn25()
						local v15 = Workspace:FindFirstChild(localPlayer.Name)
						if not v15 or not v15:IsA("Model") then
							return nil
						end
						return v15:FindFirstChild("HumanoidRootPart")
							or v15:FindFirstChild("__HITBOX")
					end

					local chilliAutoKickOnStealRuntime = CoreGui:FindFirstChild(
						"__Nullx11BrainrotAutoKickOnStealRuntime"
					)

					if chilliAutoKickOnStealRuntime then
						local cleanup =
							chilliAutoKickOnStealRuntime:FindFirstChild(
								"Cleanup"
							)

						if cleanup and cleanup:IsA("BindableEvent") then
							pcall(function()
								cleanup:Fire()
							end)
						end

						pcall(function()
							chilliAutoKickOnStealRuntime:Destroy()
						end)
					end

					local folder2 = Instance.new("Folder")
					folder2.Name = "__Nullx11BrainrotAutoKickOnStealRuntime"
					folder2.Archivable = false
					folder2.Parent = CoreGui
					local bindableEvent2 = Instance.new("BindableEvent")
					bindableEvent2.Name = "Cleanup"
					bindableEvent2.Parent = folder2

					local function fn26()
						for _, v15 in ipairs(tbl4) do
							if v15.Connected then
								v15:Disconnect()
							end
						end

						table.clear(tbl4)
						table.clear(obj2)
					end

					local fn27 = nil

					fn27 = function(arg, arg2, arg3)
						local kind = typeof(arg)

						if kind == "string" then
							local v15 = string.lower(arg)
							if
								string.find(v15, "you stole", 1, true)
								or string.find(
									v15,
									"successfully stole",
									1,
									true
								)
							then
								return arg
							end
							return nil
						end

						if kind ~= "table" or arg3 >= 3 or arg2[arg] then
							return nil
						end
						arg2[arg] = true

						for k, v15 in pairs(arg) do
							local v16 = fn27(k, arg2, arg3 + 1)
								or fn27(v15, arg2, arg3 + 1)
							if v16 then
								return v16
							end
						end

						return nil
					end

					local function fn28(...)
						if not flag8 then
							return
						end
						local v15 = table.pack(...)
						local tbl6 = {}

						for i_ = 1, v15.n do
							local v16 = fn27(v15[i_], tbl6, 0)

							if v16 then
								local v17 =
									string.match(v16, ">([^<>]-)</font>")
								local v18 = fn25()
								if fn24(v17, v18 and v18.Position) < n9 then
									return
								end
								local flag11 = v17 and v17 ~= ""
								local str3 = "\nAUTO KICK ACTIVATED"

								if flag11 then
									str3 = "\nAUTO KICK ACTIVATED"
										.. "\nYou stole: "
										.. v17
								end

								flag8 = false
								localPlayer:Kick(str3)
								return
							end
						end
					end

					local function fn29(descendant)
						if
							not flag8
							or not descendant:IsA("RemoteEvent")
							or obj2[descendant]
						then
							return
						end
						obj2[descendant] = true
						tbl4[#tbl4 + 1] = runtime.Track(
							descendant.OnClientEvent:Connect(
								runtime.Guard(fn28)
							)
						)
					end

					local function fn30()
						flag8 = false
						fn26()
					end

					local function fn31()
						fn30()
						flag8 = true
						local packages =
							ReplicatedStorage:FindFirstChild("Packages")
						packages = packages and packages:FindFirstChild("Net")
						if not packages then
							flag8 = false
							return
						end

						for _, descendant in ipairs(packages:GetDescendants()) do
							fn29(descendant)
						end

						fn29(packages)
						tbl4[#tbl4 + 1] = runtime.Track(
							packages.DescendantAdded:Connect(
								runtime.Guard(fn29)
							)
						)
					end

					local function fn32()
						flag9 = false
						flag10 = false
						n8 += 1
						fn30()
					end

					runtime.Track(
						bindableEvent2.Event:Connect(runtime.Cleanup(fn32))
					)
					runtime.Track(
						folder2.Destroying:Connect(runtime.Guard(fn32))
					)

					v13:CreateToggle({
						Name = "Auto Kick on Steal",
						Default = false,
						Callback = function(arg)
							if arg then
								fn31()
							else
								fn30()
							end
						end,
					})

					local tbl6 = {
						["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
						["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
						["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
					}

					local v15 = nil
					local n11 = 1
					local str3 = "M/s"

					local function fn33(arg, arg2)
						if arg ~= nil then
							n11 = math.floor(tonumber(arg) or n11)
						end

						if arg2 ~= nil then
							str3 = tostring(arg2)
						elseif v15 and v15.GetUnit then
							local unit = v15:GetUnit()

							if unit and unit ~= "" then
								str3 = tostring(unit)
							end
						end

						n9 = n11 * (tbl6[str3] or tbl6["M/s"]).Mult
						v14 = nil
						n10 = -math.huge
					end

					local function fn34(arg)
						str3 = tostring(arg)
						local ms = tbl6[str3] or tbl6["M/s"]

						if v15 and v15.SetRange then
							v15:SetRange(ms.Min, ms.Max)
							local min = v15:Get() or ms.Min
							local min2 = ms.Min
							local max = ms.Max
							local n12 =
								math.clamp(math.floor(min + 0.5), min2, max)

							if n12 ~= min then
								v15:Set(n12)
							else
								fn33(n12, str3)
							end
						else
							fn33(nil, str3)
						end
					end

					v15 = v13:CreateSlider({
						Name = "Auto Kick Min Value",
						Note = "Only kicks for Brainrots at or above this generation value.",
						Min = 0,
						Max = 1000,
						Default = 10,
						AllowDecimals = false,
						Increment = 1,
						Unit = {
							Default = "M/s",
							Selector = true,
							Options = { "K/s", "M/s", "B/s" },
							ColorEnabled = true,
							Colors = {
								Number = Color3.fromRGB(255, 255, 255),
								Suffix = Color3.fromRGB(58, 255, 55),
							},
							Callback = function(arg)
								fn34(arg)
							end,
						},
						Quick = false,
						Callback = function(arg)
							fn33(arg, nil)
						end,
					})
				end

				str = "Steal"
				local n8
				n8 = 2
				n = 0.25
				flag2 = true
				flag3 = false
				flag4 = false
				n2 = 1000000
				flag5 = false
				n3 = 20
				flag6 = false
				n4 = 0
				RagdollController = nil

				pcall(function()
					RagdollController = require(
						game:GetService("ReplicatedStorage").Controllers.RagdollController
					)
				end)

				UserInputService2 = game:GetService("UserInputService")

				connection = runtime.Track(
					UserInputService2.InputBegan:Connect(
						runtime.Guard(function(input, gameProcessed)
							if
								not gameProcessed
								and input.KeyCode == Enum.KeyCode.Backspace
							then
								n4 = os.clock()
							end
						end)
					)
				)

				flag7 = false
				n5 = 0
				local n9
				n9 = 0
				n6 = -math.huge
				prompt = nil
				tbl3 = {}
				n7 = -math.huge
				local fn21

				do
					local tbl4 = {}
					local chilliAutoGetRuntime = CoreGui:FindFirstChild(
						"__Nullx11BrainrotAutoGetRuntime"
					)

					if chilliAutoGetRuntime then
						local cleanup =
							chilliAutoGetRuntime:FindFirstChild("Cleanup")

						if cleanup and cleanup:IsA("BindableEvent") then
							pcall(function()
								cleanup:Fire()
							end)
						end

						pcall(function()
							chilliAutoGetRuntime:Destroy()
						end)
					end

					folder = Instance.new("Folder")
					folder.Name = "__Nullx11BrainrotAutoGetRuntime"
					folder.Archivable = false
					folder.Parent = CoreGui
					bindableEvent = Instance.new("BindableEvent")
					bindableEvent.Name = "Cleanup"
					bindableEvent.Parent = folder

					fn4 = function(arg)
						tbl4[#tbl4 + 1] = arg
						return arg
					end

					local n10 = 10
					local obj2 = setmetatable({}, { __mode = "k" })

					fn21 = function(arg, arg2)
						if not arg or not arg.Parent or not arg.Visible then
							return false
						end
						local absolutePosition = arg.AbsolutePosition
						local absoluteSize = arg.AbsoluteSize
						return arg2.X >= absolutePosition.X
							and arg2.X <= absolutePosition.X + absoluteSize.X
							and arg2.Y >= absolutePosition.Y
							and arg2.Y
								<= absolutePosition.Y + absoluteSize.Y
					end

					fn4(
						runtime.Track(
							UserInputService2.InputChanged:Connect(
								runtime.Guard(function(input)
									local v14 = obj2[input]
									if not v14 then
										return
									end
									local vector2 = Vector2.new(
										input.Position.X,
										input.Position.Y
									)
									v14.Position = vector2

									if
										(vector2 - v14.Start).Magnitude > n10
									then
										v14.Cancelled = true
									end
								end)
							)
						)
					)

					fn4(
						runtime.Track(
							UserInputService2.InputEnded:Connect(
								runtime.Guard(function(input)
									local v14 = obj2[input]
									if not v14 then
										return
									end
									local vector2 = Vector2.new(
										input.Position.X,
										input.Position.Y
									)
									v14.Position = vector2

									if
										(vector2 - v14.Start).Magnitude
											> n10
										or not fn21(v14.Button, vector2)
									then
										v14.Cancelled = true
									end

									task.delay(0.2, function()
										if obj2[input] == v14 then
											obj2[input] = nil
										end
									end)
								end)
							)
						)
					)

					fn5 = function(arg, arg2)
						fn4(
							runtime.Track(
								arg.InputBegan:Connect(
									runtime.Guard(function(input)
										if
											input.UserInputType
												~= Enum.UserInputType.Touch
											or input.UserInputState
												~= Enum.UserInputState.Begin
										then
											return
										end
										local vector2 = Vector2.new(
											input.Position.X,
											input.Position.Y
										)

										if fn21(arg, vector2) then
											obj2[input] = {
												Button = arg,
												Start = vector2,
												Position = vector2,
												Cancelled = false,
											}
										end
									end)
								)
							)
						)

						return fn4(
							runtime.Track(
								arg.Activated:Connect(
									runtime.Guard(function(inputObject)
										if
											inputObject
											and inputObject.UserInputType
												== Enum.UserInputType.Touch
										then
											local v14 = obj2[inputObject]
											if
												not v14
												or v14.Button ~= arg
												or v14.Cancelled
												or not fn21(arg, v14.Position)
											then
												return
											end
										end

										arg2()
									end)
								)
							)
						)
					end

					fn6 = function()
						for _, v14 in ipairs(tbl4) do
							if v14.Connected then
								v14:Disconnect()
							end
						end

						table.clear(tbl4)
					end
				end

				local v14, v15, fn22, fn23, fn24

				do
					local v16 = nil
					v14 = nil
					v15 = nil
					local datas = ReplicatedStorage:FindFirstChild("Datas")

					if datas then
						local animals = datas:FindFirstChild("Animals")

						if animals and animals:IsA("ModuleScript") then
							local ok, result = pcall(require, animals)

							if ok and type(result) == "table" then
								v16 = result
							end
						end

						local mutations = datas:FindFirstChild("Mutations")

						if mutations and mutations:IsA("ModuleScript") then
							local ok, result = pcall(require, mutations)

							if ok and type(result) == "table" then
								v14 = result
							end
						end

						local traits = datas:FindFirstChild("Traits")

						if traits and traits:IsA("ModuleScript") then
							local ok, result = pcall(require, traits)

							if ok and type(result) == "table" then
								v15 = result
							end
						end
					end

					fn22 = function(arg)
						return string.lower(tostring(arg or ""))
					end

					fn23 = function(arg)
						arg = arg and arg.Parent

						while arg and arg ~= Workspace do
							if arg:IsA("BasePart") and arg.Name == "Spawn" then
								return arg
							end
							arg = arg.Parent
						end

						return nil
					end

					fn24 = function(arg)
						if not v16 or not arg or arg == "" then
							return 0
						end
						local v17 = v16[arg]
						if type(v17) ~= "table" then
							return 0
						end
						return tonumber(v17.Generation) or 0
					end
				end

				local brainrotNameTiers
				brainrotNameTiers = {}
				local tbl4
				tbl4 = { Limit = 1000000 }

				do
					local colorSequence = ColorSequence.new
					local tbl5 = {}
					local v16 = ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(255, 231, 158)
					)
					local v17 = ColorSequenceKeypoint.new(
						0.4,
						Color3.fromRGB(255, 196, 66)
					)
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl5[1] = v16
					tbl5[2] = v17

					do
						local values = table.pack(new(1, color(214, 142, 12)))
						table.move(values, 1, values.n, 3, tbl5)
					end

					tbl4.Text = colorSequence(tbl5)
				end

				do
					local colorSequence = ColorSequence.new
					local tbl5 = {}
					local v16 =
						ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
					local v17 = ColorSequenceKeypoint.new(
						0.55,
						Color3.fromRGB(62, 38, 0)
					)
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl5[1] = v16
					tbl5[2] = v17

					do
						local values = table.pack(new(1, color(20, 12, 0)))
						table.move(values, 1, values.n, 3, tbl5)
					end

					tbl4.Stroke = colorSequence(tbl5)
				end

				local tbl5
				tbl5 = { Limit = 10000000 }

				do
					local colorSequence = ColorSequence.new
					local tbl6 = {}
					local v16 = ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(255, 198, 132)
					)
					local v17 = ColorSequenceKeypoint.new(
						0.4,
						Color3.fromRGB(255, 146, 40)
					)
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl6[1] = v16
					tbl6[2] = v17

					do
						local values = table.pack(new(1, color(206, 92, 0)))
						table.move(values, 1, values.n, 3, tbl6)
					end

					tbl5.Text = colorSequence(tbl6)
				end

				do
					local colorSequence = ColorSequence.new
					local tbl6 = {}
					local v16 =
						ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
					local v17 = ColorSequenceKeypoint.new(
						0.55,
						Color3.fromRGB(56, 27, 0)
					)
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl6[1] = v16
					tbl6[2] = v17

					do
						local values = table.pack(new(1, color(18, 8, 0)))
						table.move(values, 1, values.n, 3, tbl6)
					end

					tbl5.Stroke = colorSequence(tbl6)
				end

				do
					local tbl6 = { Limit = 100000000 }
					local colorSequence = ColorSequence.new
					local tbl7 = {}
					local v16 = ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(255, 168, 140)
					)
					local v17 = ColorSequenceKeypoint.new(
						0.4,
						Color3.fromRGB(255, 82, 38)
					)
					local new = ColorSequenceKeypoint.new
					local color = Color3.fromRGB
					tbl7[1] = v16
					tbl7[2] = v17

					do
						local values = table.pack(new(1, color(196, 42, 0)))
						table.move(values, 1, values.n, 3, tbl7)
					end

					tbl6.Text = colorSequence(tbl7)
					local colorSequence2 = ColorSequence.new
					local tbl8 = {}
					local v18 =
						ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
					local v19 = ColorSequenceKeypoint.new(
						0.55,
						Color3.fromRGB(56, 13, 0)
					)
					local new2 = ColorSequenceKeypoint.new
					local color2 = Color3.fromRGB
					tbl8[1] = v18
					tbl8[2] = v19

					do
						local values = table.pack(new2(1, color2(18, 4, 0)))
						table.move(values, 1, values.n, 3, tbl8)
					end

					tbl6.Stroke = colorSequence2(tbl8)
					local tbl9 = { Limit = math.huge }
					local colorSequence3 = ColorSequence.new
					local tbl10 = {}
					local v20 = ColorSequenceKeypoint.new(
						0,
						Color3.fromRGB(255, 105, 105)
					)
					local v21 = ColorSequenceKeypoint.new(
						0.4,
						Color3.fromRGB(255, 28, 40)
					)
					local new3 = ColorSequenceKeypoint.new
					local color3 = Color3.fromRGB
					tbl10[1] = v20
					tbl10[2] = v21

					do
						local values = table.pack(new3(1, color3(184, 0, 18)))
						table.move(values, 1, values.n, 3, tbl10)
					end

					tbl9.Text = colorSequence3(tbl10)
					local colorSequence4 = ColorSequence.new
					local tbl11 = {}
					local v22 =
						ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
					local v23 = ColorSequenceKeypoint.new(
						0.55,
						Color3.fromRGB(61, 0, 9)
					)
					local new4 = ColorSequenceKeypoint.new
					local color4 = Color3.fromRGB
					tbl11[1] = v22
					tbl11[2] = v23

					do
						local values = table.pack(new4(1, color4(18, 0, 3)))
						table.move(values, 1, values.n, 3, tbl11)
					end

					tbl9.Stroke = colorSequence4(tbl11)
					brainrotNameTiers[1] = tbl4
					brainrotNameTiers[2] = tbl5
					brainrotNameTiers[3] = tbl6
					brainrotNameTiers[4] = tbl9
				end

				chilliGithubFastManualDefaultsRu.BrainrotNameTiers =
					brainrotNameTiers

				chilliGithubFastManualDefaultsRu.BrainrotNameTier = function(
					arg
				)
					local n10 = tonumber(arg) or 0

					for _, brainrotNameTier in
						ipairs(
							chilliGithubFastManualDefaultsRu.BrainrotNameTiers
						)
					do
						if n10 < brainrotNameTier.Limit then
							return brainrotNameTier
						end
					end

					return chilliGithubFastManualDefaultsRu.BrainrotNameTiers[#chilliGithubFastManualDefaultsRu.BrainrotNameTiers]
				end

				chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle = function(
					parent
				)
					parent.TextColor3 = Color3.fromRGB(255, 255, 255)
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Color = Color3.fromRGB(255, 255, 255)
					uiStroke.Thickness = 1.15
					uiStroke.Transparency = 0.08
					uiStroke.Parent = parent
					local uiGradient = Instance.new("UIGradient")
					uiGradient.Rotation = 90
					uiGradient.Parent = uiStroke
					local uiGradient2 = Instance.new("UIGradient")
					uiGradient2.Rotation = 90
					uiGradient2.Parent = parent
					return {
						Label = parent,
						Outline = uiStroke,
						Text = uiGradient2,
						Stroke = uiGradient,
					}
				end

				chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle = function(
					arg,
					arg2
				)
					if not arg then
						return
					end

					if tonumber(arg2) == nil then
						arg.Label.TextColor3 = Color3.fromRGB(238, 238, 242)
						arg.Outline.Color = Color3.fromRGB(0, 0, 0)
						arg.Outline.Transparency = 0.28
						arg.Text.Enabled = false
						arg.Stroke.Enabled = false
						return
					end

					local v16 =
						chilliGithubFastManualDefaultsRu.BrainrotNameTier(arg2)
					arg.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
					arg.Outline.Transparency = 0.08
					arg.Text.Enabled = true
					arg.Stroke.Enabled = true
					arg.Text.Color = v16.Text
					arg.Stroke.Color = v16.Stroke
				end

				do
					local n10 = 0.5
					local obj2 = setmetatable({}, { __mode = "k" })

					local function fn25(arg)
						local v16 = fn23(arg)
						if not v16 then
							return false
						end

						if fn22(v16.Name) == "lucky block" then
							return true
						end

						for _, descendant in ipairs(v16:GetDescendants()) do
							if
								descendant:IsA("TextLabel")
								and fn22(descendant.Name) == "stolen"
								and descendant.Visible
								and fn22(descendant.Text) == "fusing"
							then
								return true
							end
						end

						return false
					end

					fn7 = function(arg)
						local now = os.clock()
						local v16 = obj2[arg]
						if v16 and now < v16.ExpiresAt then
							return v16.Value
						end
						local v17 = fn25(arg)

						if v16 then
							v16.Value = v17
							v16.ExpiresAt = now + n10
						else
							obj2[arg] = { Value = v17, ExpiresAt = now + n10 }
						end

						return v17
					end
				end

				fn8 = function(arg)
					local n10 = tonumber(arg) or 0
					if n10 >= 1e9 then
						return string.format("%.2fB/s", n10 / 1e9)
					end

					if n10 >= 1000000 then
						return string.format("%.2fM/s", n10 / 1000000)
					end

					if n10 >= 1000 then
						return string.format("%.1fK/s", n10 / 1000)
					end
					return string.format("%d/s", math.floor(n10))
				end

				do
					local function fn25(arg)
						if not arg or arg == "" then
							return nil
						end
						local match, v16 = arg:gsub("[%$,/s]", "")
							:gsub("%s+", "")
							:match("^([%d%.]+)([KkMmBbTt]?)$")

						if match then
							local n10 = tonumber(match) or 0
							local str3 = v16:upper()

							if str3 == "K" then
								n10 *= 1000
							elseif str3 == "M" then
								n10 *= 1000000
							elseif str3 == "B" then
								n10 *= 1e9
							elseif str3 == "T" then
								n10 *= 1e12
							end

							return n10
						end

						return nil
					end

					local function fn26(arg, arg2, arg3, arg4)
						local v16 = fn24(arg3)
						arg = arg and arg.Position
						if not arg then
							return v16
						end
						local v17 = arg4 and arg4[arg3]
						local overhead = nil

						if v17 then
							local v18, v19, v20 = ipairs(arg4[arg3])
							local n10 = 14
							overhead = nil

							for _, v21 in v18, v19, v20 do
								local magnitude = (v21.Position - arg).Magnitude

								if magnitude < n10 then
									overhead = v21.Overhead
									n10 = magnitude
								end
							end
						end

						local v18 = nil

						if arg2 then
							local v19, v20, v21 = ipairs(arg2:GetChildren())
							local n10 = 14
							v18 = nil

							for _, v22 in v19, v20, v21 do
								if v22:IsA("Model") and v22.Name == arg3 then
									local rootPart = v22:FindFirstChild(
										"RootPart"
									) or v22.PrimaryPart or v22:FindFirstChildWhichIsA(
										"BasePart"
									)

									if rootPart then
										local magnitude = (
											rootPart.Position - arg
										).Magnitude

										if magnitude < n10 then
											n10 = magnitude
											v18 = v22
										end
									end
								end
							end
						end

						local text

						if
							overhead
							and overhead:FindFirstChild("Mutation")
							and overhead.Mutation.Visible
							and overhead.Mutation.Text ~= ""
						then
							text = overhead.Mutation.Text
						else
							text = nil

							if v18 then
								local attribute = v18:GetAttribute("Mutation")
									or v18:GetAttribute("__mutation")
								local flag8 = attribute
									and tostring(attribute) ~= ""
								text = nil

								if flag8 then
									text = tostring(attribute)
								end
							end
						end

						local tbl6 = {}
						local tbl7 = {}

						if v18 then
							for _, child in ipairs(v18:GetChildren()) do
								local match = child.Name:match("^_Trait%.(.+)$")

								if match and not tbl7[match] then
									tbl7[match] = true
									table.insert(tbl6, match)
								end
							end

							local attribute = v18:GetAttribute("Trait")
								or v18:GetAttribute("Traits")

							if attribute then
								local str3 = tostring(attribute)

								if not tbl7[str3] then
									tbl7[str3] = true
									table.insert(tbl6, str3)
								end
							end
						end

						local v19 = text and v14 and v14[text]
						local n10 = 1

						if v19 then
							n10 = 1 + (tonumber(v14[text].Modifier) or 0)
						end

						local flag8 = false

						if v15 then
							for _, v20 in ipairs(tbl6) do
								local v21 = v15[v20] or v15[v20:gsub("_", " ")]

								if v21 then
									if
										v20 == "Sleepy"
										or v21.Name == "Sleepy"
									then
										flag8 = true
									else
										n10 += tonumber(v21.MultiplierModifier) or 0
									end
								end
							end
						end

						local v20 = math.round(v16 * n10 * (flag8 and 0.5 or 1))
						local v21 = fn25(
							overhead
								and overhead:FindFirstChild("Generation")
								and overhead.Generation.Text
						)
						if v21 and v21 > v20 then
							return v21
						end
						return v20 > 0 and v20 or v21 or v16
					end

					fn9 = function(arg)
						local now = os.clock()
						if not arg and now - n7 < n8 then
							return
						end
						n7 = now
						local tbl6 = {}
						local plots = Workspace:FindFirstChild("Plots")
						if not plots then
							tbl3 = tbl6
							return
						end
						local debris = Workspace:FindFirstChild("Debris")
						local tbl7 = {}

						if debris then
							for _, child in ipairs(debris:GetChildren()) do
								if
									child.Name == "FastOverheadTemplate"
									and child:IsA("BasePart")
								then
									local animalOverhead =
										child:FindFirstChild("AnimalOverhead")
									local displayName = animalOverhead
										and animalOverhead:FindFirstChild(
											"DisplayName"
										)

									if
										displayName
										and displayName:IsA("TextLabel")
										and displayName.Text ~= ""
									then
										local text = displayName.Text
										tbl7[text] = tbl7[text] or {}
										table.insert(tbl7[text], {
											Position = child.Position,
											Overhead = animalOverhead,
										})
									end
								end
							end
						end

						for _, child in ipairs(plots:GetChildren()) do
							local animalPodiums =
								child:FindFirstChild("AnimalPodiums")

							if animalPodiums then
								for _, child2 in
									ipairs(animalPodiums:GetChildren())
								do
									local base = child2:FindFirstChild("Base")
									base = base and base:FindFirstChild("Spawn")

									if base and base:IsA("BasePart") then
										local promptAttachment =
											base:FindFirstChild(
												"PromptAttachment"
											)
										local v16 = ipairs
										promptAttachment = promptAttachment
											or base
										local v17 = nil

										for _, descendant in
											v16(
												promptAttachment:GetDescendants()
											)
										do
											if
												descendant:IsA(
													"ProximityPrompt"
												)
												and tostring(
														descendant.ActionText
													)
													== str
											then
												v17 = descendant
												break
											else
												v17 = nil
											end
										end

										if v17 then
											local str3 =
												tostring(v17.ObjectText or "")

											tbl6[#tbl6 + 1] = {
												Prompt = v17,
												Plot = child,
												Spawn = base,
												Name = str3,
												Generation = fn26(
													base,
													child,
													str3,
													tbl7
												),
											}
										end
									end
								end
							end
						end

						tbl3 = tbl6
					end
				end

				local n10
				n10 = 0.03
				local n11
				n11 = -math.huge
				local v16
				v16 = nil
				local v17
				v17 = nil
				local v18
				v18 = nil
				local v19
				v19 = nil
				local v20
				v20 = nil
				local v21
				v21 = nil
				local fn25

				fn25 = function(arg, arg2, distance, generation)
					local tbl6 = {
						Prompt = arg.Prompt,
						Plot = arg.Plot,
						Position = arg2,
					}
					local name = arg.Name
					local name2

					if name then
						name2 = name
					else
						name2 = tostring(arg.Prompt.ObjectText or "")
					end

					tbl6.Name = name2
					tbl6.Generation = generation
					tbl6.Distance = distance
					return tbl6
				end

				prompt2 = nil

				fn10 = function(arg)
					if not arg then
						return nil
					end

					for _, v22 in ipairs(tbl3) do
						if v22.Prompt == arg then
							return v22
						end
					end

					return nil
				end

				fn11 = function(arg)
					if not (prompt2 and prompt2.Parent and arg) then
						return nil
					end
					local v22 = fn10(prompt2)
					if not v22 then
						return nil
					end
					local position = v22.Spawn.Position
					return fn25(
						v22,
						position,
						(arg.Position - position).Magnitude,
						v22.Generation or 0
					)
				end

				fn12 = function(arg, arg2, arg3, arg4)
					if flag4 then
						arg2 = arg4 or arg2
						if arg2 and arg2.Distance <= n3 then
							return arg2
						end
						return nil
					end

					local v22 = fn11(arg)
					if v22 then
						return v22
					end
					return arg3
				end

				str2 = "Default (Nullx11)"
				fn13 = nil
				fn14 = nil
				screenGui = Instance.new("ScreenGui")
				screenGui.Name = "Nullx11BrainrotTargetGui"
				screenGui.ResetOnSpawn = false
				screenGui.IgnoreGuiInset = true
				screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				screenGui.Enabled = false

				pcall(function()
					screenGui.Parent = type(gethui) == "function" and gethui()
						or CoreGui
				end)

				do
					local frame3 = Instance.new("Frame")
					frame3.Name = "TargetCard"
					frame3.AnchorPoint = Vector2.new(0.5, 0)
					frame3.Position = UDim2.new(0.5, 0, 0, 72)
					frame3.Size = UDim2.fromOffset(270, 48)
					frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
					frame3.BackgroundTransparency = 0.15
					frame3.BorderSizePixel = 0
					frame3.Parent = screenGui
					Instance.new("UICorner", frame3).CornerRadius =
						UDim.new(0, 10)
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Color = Color3.fromRGB(58, 255, 55)
					uiStroke.Thickness = 1.2
					uiStroke.Transparency = 0.3
					uiStroke.Parent = frame3
					local textLabel3 = Instance.new("TextLabel")
					textLabel3.BackgroundTransparency = 1
					textLabel3.Position = UDim2.fromOffset(12, 5)
					textLabel3.Size = UDim2.new(1, -24, 0, 14)
					textLabel3.Font = Enum.Font.GothamBold
					textLabel3.TextSize = 11
					textLabel3.TextColor3 = Color3.fromRGB(58, 255, 55)
					textLabel3.TextXAlignment = Enum.TextXAlignment.Left
					textLabel3.Text =
						"AUTO STEAL (MAC LIB) - MỤC TIÊU GẦN NHẤT"
					textLabel3.Parent = frame3
					local textLabel4 = Instance.new("TextLabel")
					textLabel4.BackgroundTransparency = 1
					textLabel4.Position = UDim2.fromOffset(12, 22)
					textLabel4.Size = UDim2.new(1, -24, 0, 20)
					textLabel4.Font = Enum.Font.GothamBlack
					textLabel4.TextSize = 13
					textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel4.TextXAlignment = Enum.TextXAlignment.Left
					textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
					textLabel4.Text =
						"Đang quét tìm brainrot gần nhất..."
					textLabel4.Parent = frame3
					local flag8 = false
					local v22 = nil
					local vector2 = Vector2.new(0, 0)
					local position = nil

					fn4(
						runtime.Track(
							frame3.InputBegan:Connect(
								runtime.Guard(function(input)
									local v23 = flag8
									local flag9

									if flag8 then
										flag9 = v23
									else
										flag9 = input.UserInputState
											~= Enum.UserInputState.Begin
									end

									if flag9 then
										return
									end
									local flag10 = input.UserInputType
										== Enum.UserInputType.Touch
									if
										not (
											input.UserInputType
											== Enum.UserInputType.MouseButton1
										) and not flag10
									then
										return
									end
									local vector22 = Vector2.new(
										input.Position.X,
										input.Position.Y
									)
									if not fn21(frame3, vector22) then
										return
									end
									flag8 = true
									v22 = flag10 and input or nil
									vector2 = vector22
									position = frame3.Position
								end)
							)
						)
					)

					fn4(
						runtime.Track(
							UserInputService2.InputChanged:Connect(
								runtime.Guard(function(input)
									if not flag8 or not position then
										return
									end

									if
										v22 and input == v22
										or not v22
											and input.UserInputType == Enum.UserInputType.MouseMovement
									then
										local n12 = Vector2.new(
											input.Position.X,
											input.Position.Y
										) - vector2
										frame3.Position = UDim2.new(
											position.X.Scale,
											position.X.Offset + n12.X,
											position.Y.Scale,
											position.Y.Offset + n12.Y
										)
									end
								end)
							)
						)
					)

					fn4(
						runtime.Track(
							UserInputService2.InputEnded:Connect(
								runtime.Guard(function(input)
									if not flag8 then
										return
									end

									if
										v22 and input == v22
										or not v22
											and input.UserInputType == Enum.UserInputType.MouseButton1
									then
										flag8 = false
										v22 = nil
										position = nil
									end
								end)
							)
						)
					)

					fn15 = function(arg)
						if not screenGui.Parent then
							return
						end

						if not (str2 and string.find(str2, "Mac")) then
							screenGui.Enabled = false
							return
						end
						screenGui.Enabled = true

						if arg and arg.Name then
							local str3 = arg.Distance
									and string.format("%.1fm", arg.Distance)
								or ""
							local str4 = arg.Generation
									and arg.Generation > 0
									and " | " .. fn8(arg.Generation)
								or ""
							textLabel4.Text = string.format(
								"%s (%s)%s",
								tostring(arg.Name),
								str3,
								str4
							)
						else
							textLabel4.Text =
								"Đang quét tìm brainrot gần nhất..."
						end
					end
				end

				fn16 = function(arg)
					fn15(arg)
				end

				do
					local function fn26(arg)
						local match, v22 =
							tostring(arg or ""):match("%$?([%d%.]+)%s*([KMB]?)")
						if not match then
							return 0
						end
						local n12 = tonumber(match) or 0

						if v22 == "K" then
							n12 *= 1000
						elseif v22 == "M" then
							n12 *= 1000000
						elseif v22 == "B" then
							n12 *= 1e9
						end

						return n12
					end

					local function fn27()
						local name = localPlayer.Name
						local displayName = localPlayer.DisplayName
						local plots = Workspace:FindFirstChild("Plots")
						if not plots then
							return nil
						end

						for _, child in ipairs(plots:GetChildren()) do
							local plotSign = child:FindFirstChild("PlotSign")

							if plotSign then
								local surfaceGui =
									plotSign:FindFirstChild("SurfaceGui")

								if surfaceGui then
									local frame3 =
										surfaceGui:FindFirstChild("Frame")

									if frame3 then
										local textLabel3 =
											frame3:FindFirstChildOfClass(
												"TextLabel"
											)

										if
											textLabel3
											and type(textLabel3.Text)
												== "string"
										then
											local text = textLabel3.Text
											if
												string.find(
													text,
													displayName,
													1,
													true
												)
												or string.find(
													text,
													name,
													1,
													true
												)
											then
												return child
											end
											continue
										end

										continue
									end
								end
							end
						end

						return nil
					end

					local function fn28(arg)
						if not (arg and arg:IsA("Model")) then
							return nil
						end

						for _, descendant in ipairs(arg:GetDescendants()) do
							if descendant:IsA("TextLabel") then
								local v22 = string.lower(descendant.Name)
								if
									v22 == "generation"
									or v22 == "gen"
									or v22:find("generation")
									or v22:find("gen")
								then
									return descendant
								end
							end
						end

						return nil
					end

					fn17 = function(arg)
						if not arg then
							return nil, nil, 0
						end
						local position = arg.Position
						local v22 = nil
						local v23 = nil
						local n12 = -math.huge
						local huge = math.huge
						local n13 = 0

						local function fn29(arg2, arg3, arg4, arg5)
							if not (arg2 and arg2.Parent) then
								return
							end

							if tostring(arg2.ActionText) ~= str then
								return
							end

							if fn7(arg2) then
								return
							end

							if not arg4 then
								arg4 = tostring(arg2.ObjectText or "")
							end

							if type(arg5) ~= "number" then
								local flag8 = type(arg5) == "string"
									and arg5 ~= ""
								local n14 = 0

								if flag8 then
									arg5 = fn26(arg5)
								else
									arg5 = n14
								end
							end

							if arg5 == 0 then
								arg5 = fn24(arg4)
							end

							if n2 and n2 > 1000 and arg5 > 0 and arg5 < n2 then
								return
							end
							n13 += 1
							local magnitude = (position - arg3).Magnitude

							if magnitude <= n3 then
								local tbl6 = {
									Prompt = arg2,
									Spawn = { Position = arg3 },
									Position = arg3,
									Name = arg4,
									Generation = arg5,
									Distance = magnitude,
								}

								if not v22 or arg5 > n12 then
									v22 = tbl6
									n12 = arg5
								end

								if not v23 or magnitude < huge then
									v23 = tbl6
									huge = magnitude
								end
							end
						end

						local plots = Workspace:FindFirstChild("Plots")
						local n14 = 0

						if n9 then
							n14 = os.clock() < n9
						end

						if plots and not n14 then
							local v24 = fn27()

							for _, child in ipairs(plots:GetChildren()) do
								if child ~= v24 then
									local animalPodiums =
										child:FindFirstChild("AnimalPodiums")

									if animalPodiums then
										for _, child2 in
											ipairs(animalPodiums:GetChildren())
										do
											local base =
												child2:FindFirstChild("Base")
											local spawn = base
												and base:FindFirstChild("Spawn")

											if
												spawn and spawn:IsA("BasePart")
											then
												local promptAttachment = spawn:FindFirstChild(
													"PromptAttachment"
												) or spawn
												local v25 = nil

												for _, descendant in
													ipairs(
														promptAttachment:GetDescendants()
													)
												do
													if
														descendant:IsA(
															"ProximityPrompt"
														)
														and tostring(
																descendant.ActionText
															)
															== str
													then
														v25 = descendant
														break
													else
														v25 = nil
													end
												end

												if v25 then
													local str3 = tostring(
														v25.ObjectText or ""
													)
													local attachment =
														spawn:FindFirstChild(
															"Attachment"
														)
													attachment = attachment
														and attachment:FindFirstChild(
															"AnimalOverhead"
														)
													local str4 = ""

													if attachment then
														local generation =
															attachment:FindFirstChild(
																"Generation"
															)

														if
															generation
															and generation:IsA(
																"TextLabel"
															)
														then
															str4 =
																generation.Text
														end
													end

													if
														str4 == ""
														and str3 ~= ""
													then
														local v26 = child:FindFirstChild(
															str3
														) or child:FindFirstChild(
															str3,
															true
														)

														if
															v26
															and v26:IsA("Model")
														then
															local v27 =
																fn28(v26)

															if v27 then
																str4 = v27.Text
															end
														end
													end

													fn29(
														v25,
														spawn.Position,
														str3,
														str4,
														child.Name,
														tostring(i)
													)
												end
											end
										end
									end
								end
							end
						end

						local debris = Workspace:FindFirstChild("Debris")

						if debris then
							for _, child in ipairs(debris:GetChildren()) do
								local v24 = string.lower(child.Name or "")

								if
									v24 ~= "lucky block"
									and v24 ~= "camera"
									and not child:IsA("Camera")
								then
									local v25 = nil

									for _, descendant in
										ipairs(child:GetDescendants())
									do
										if
											descendant:IsA("ProximityPrompt")
											and tostring(
													descendant.ActionText
												)
												== str
										then
											v25 = descendant
											break
										else
											v25 = nil
										end
									end

									if v25 then
										local position2 = child:IsA("BasePart")
												and child.Position
											or child:IsA("Model") and child.PrimaryPart and child.PrimaryPart.Position
											or v25.Parent
												and v25.Parent:IsA("BasePart")
												and v25.Parent.Position

										if position2 then
											local str3 = ""

											if child:IsA("Model") then
												local v26 = fn28(child)

												if v26 then
													str3 = v26.Text
												end
											end

											fn29(
												v25,
												position2,
												tostring(
													v25.ObjectText or child.Name
												),
												str3,
												nil,
												nil
											)
										end
									end
								end
							end
						end

						for _, player in ipairs(Players:GetPlayers()) do
							if player.Character then
								local humanoidRootPart =
									player.Character:FindFirstChild(
										"HumanoidRootPart"
									)

								if humanoidRootPart then
									for _, descendant in
										ipairs(
											player.Character:GetDescendants()
										)
									do
										if
											descendant:IsA("ProximityPrompt")
											and tostring(
													descendant.ActionText
												)
												== str
										then
											fn29(
												descendant,
												humanoidRootPart.Position,
												tostring(
													descendant.ObjectText
														or "Carried Brainrot"
												),
												"",
												nil,
												nil
											)
										end
									end
								end
							end
						end

						return v22, v23, n13
					end
				end

				fn18 = function(arg)
					if not arg then
						return nil, nil, nil, nil, 0
					end
					local now = os.clock()
					local position = arg.Position
					if
						now - n11 < n10
						and v16
						and (position - v16).Magnitude < 0.5
					then
						return v17, v18, v19, v20, v21
					end
					fn9(false)
					local n12 = 0
					local v22 = nil
					local v23 = nil
					local v24 = nil
					local v25 = nil
					local v26 = nil
					local v27 = nil
					local v28 = nil
					local v29 = nil

					for _, v30 in ipairs(tbl3) do
						local prompt3 = v30.Prompt

						if
							prompt3.Parent
							and prompt3.Enabled
							and tostring(prompt3.ActionText) == str
							and not fn7(prompt3)
						then
							local generation = v30.Generation or 0
							local v31 = flag4
							local flag8

							if flag4 then
								flag8 = v31
							else
								flag8 = generation >= n2
							end

							if flag8 then
								n12 += 1
								local position2 = v30.Spawn.Position
								local magnitude = (position - position2).Magnitude

								if not v22 or generation > v23 then
									v22 = fn25(
										v30,
										position2,
										magnitude,
										generation
									)
									v23 = generation
								end

								if not v24 or magnitude < v25 then
									v24 = fn25(
										v30,
										position2,
										magnitude,
										generation
									)
									v25 = magnitude
								end

								if magnitude <= n3 then
									if not v26 or generation > v27 then
										v26 = fn25(
											v30,
											position2,
											magnitude,
											generation
										)
										v27 = generation
									end

									if not v28 or magnitude < v29 then
										v28 = fn25(
											v30,
											position2,
											magnitude,
											generation
										)
										v29 = magnitude
									end
								end
							end
						end
					end

					n11 = now
					v16 = position
					v17 = v26
					v18 = v28
					v19 = v22
					v20 = v24
					v21 = n12
					return v26, v28, v22, v24, n12
				end

				fn19 = function(arg)
					if
						not arg
						or not arg:IsA("ProximityPrompt")
						or not arg.Parent
						or type(getconnections) ~= "function"
					then
						return nil
					end
					local tbl6 = {}
					local tbl7 = {}

					if
						not pcall(function()
							for _, v22 in
								pairs(getconnections(arg.PromptButtonHoldBegan))
							do
								if v22 and v22.Function then
									tbl6[#tbl6 + 1] = v22.Function
								end
							end

							for _, v22 in pairs(getconnections(arg.Triggered)) do
								if v22 and v22.Function then
									tbl7[#tbl7 + 1] = v22.Function
								end
							end
						end) or #tbl7 == 0
					then
						return nil
					end

					return tbl6, tbl7
				end

				do
					local v22 = CoreGui

					pcall(function()
						if type(gethui) == "function" then
							local hui = gethui()

							if typeof(hui) == "Instance" then
								v22 = hui
							end
						end
					end)

					local chilliAutoGetBarGui =
						v22:FindFirstChild("Nullx11BrainrotAutoGetBarGui")

					if chilliAutoGetBarGui then
						pcall(function()
							chilliAutoGetBarGui:Destroy()
						end)
					end

					screenGui2 = Instance.new("ScreenGui")
					screenGui2.Name = "Nullx11BrainrotAutoGetBarGui"
					screenGui2.ResetOnSpawn = false
					screenGui2.IgnoreGuiInset = true
					screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					screenGui2.Enabled = false
					screenGui2.Parent = v22
				end

				local color
				color = Color3.fromRGB(58, 255, 55)
				local color2
				color2 = Color3.fromRGB(20, 109, 0)
				local createUIGradient

				do
					local gothamBold = Enum.Font.GothamBold

					pcall(function()
						gothamBold = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.ExtraBold,
							Enum.FontStyle.Normal
						)
					end)

					local function fn26(arg)
						if typeof(gothamBold) == "Font" then
							arg.FontFace = gothamBold
						else
							arg.Font = Enum.Font.GothamBold
						end
					end

					createUIGradient = function(parent, arg, arg2)
						local uiGradient = Instance.new("UIGradient")
						local new = ColorSequenceKeypoint.new
						uiGradient.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, arg),
							new(1, arg2),
						})
						uiGradient.Rotation = 90
						uiGradient.Parent = parent
						return uiGradient
					end

					frame = Instance.new("Frame")
					frame.Name = "Holder"
					frame.AnchorPoint = Vector2.new(0.5, 0)
					frame.Position = UDim2.new(0.5, 0, 0, 10)
					frame.Size = UDim2.fromOffset(248, 46)
					frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
					frame.BackgroundTransparency = 0.28
					frame.BorderSizePixel = 0
					frame.Parent = screenGui2
					Instance.new("UICorner", frame).CornerRadius =
						UDim.new(0, 16)
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Color = Color3.fromRGB(255, 255, 255)
					uiStroke.Thickness = 1
					uiStroke.Transparency = 0.93
					uiStroke.Parent = frame
					local n12 = 0.125
					local n13 = 248
					local n14 = 1
					local uiScale = Instance.new("UIScale")
					uiScale.Parent = frame

					local function fn27()
						local currentCamera = Workspace.CurrentCamera
						local viewportSize = currentCamera
								and currentCamera.ViewportSize
							or Vector2.new(1280, 720)

						if viewportSize.X < 1 then
							viewportSize = Vector2.new(1280, 720)
						end

						uiScale.Scale = math.clamp(
							viewportSize.X * n12 * n14 / n13,
							0.6,
							1.4
						)
					end

					fn27()
					local currentCamera = Workspace.CurrentCamera

					if currentCamera then
						fn4(
							runtime.Track(
								currentCamera
									:GetPropertyChangedSignal("ViewportSize")
									:Connect(runtime.Guard(fn27))
							)
						)
					end

					fn4(
						runtime.Track(
							Workspace:GetPropertyChangedSignal("CurrentCamera")
								:Connect(runtime.Guard(fn27))
						)
					)
					textLabel = Instance.new("TextLabel")
					textLabel.BackgroundTransparency = 1
					textLabel.Position = UDim2.fromOffset(14, 8)
					textLabel.Size = UDim2.new(1, -104, 0, 15)
					textLabel.TextSize = 13
					textLabel.TextScaled = true
					textLabel.TextXAlignment = Enum.TextXAlignment.Left
					textLabel.TextTruncate = Enum.TextTruncate.None
					textLabel.TextColor3 = Color3.fromRGB(238, 238, 242)
					textLabel.Text = ""
					fn26(textLabel)
					textLabel.Parent = frame
					local uiTextSizeConstraint =
						Instance.new("UITextSizeConstraint")
					uiTextSizeConstraint.MinTextSize = 8
					uiTextSizeConstraint.MaxTextSize = 13
					uiTextSizeConstraint.Parent = textLabel
					chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle =
						chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(
							textLabel
						)
					textLabel2 = Instance.new("TextLabel")
					textLabel2.BackgroundTransparency = 1
					textLabel2.AnchorPoint = Vector2.new(1, 0)
					textLabel2.Position = UDim2.new(1, -14, 0, 8)
					textLabel2.Size = UDim2.fromOffset(88, 15)
					textLabel2.TextSize = 13
					textLabel2.TextXAlignment = Enum.TextXAlignment.Right
					textLabel2.TextColor3 = color
					textLabel2.Text = ""
					fn26(textLabel2)
				end

				textLabel2.Parent = frame
				local frame3 = Instance.new("Frame")
				frame3.Position = UDim2.fromOffset(14, 30)
				frame3.Size = UDim2.new(1, -28, 0, 6)
				frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame3.BackgroundTransparency = 0.88
				frame3.BorderSizePixel = 0
				frame3.Parent = frame
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
				frame2 = Instance.new("Frame")
				frame2.Size = UDim2.new(0, 0, 1, 0)
				frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame2.BorderSizePixel = 0
				frame2.Parent = frame3
				Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
				createUIGradient(frame2, color, color2)
			end

			local frame3, visible, flag8, n8, n9, n10, n11, fn20, fn21, v13
			local fn22, fn23, fn24

			do
				local frame4 = Instance.new("Frame")
				frame4.Position = UDim2.fromOffset(14, 41)
				frame4.Size = UDim2.new(1, -28, 0, 4)
				frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame4.BackgroundTransparency = 0.9
				frame4.BorderSizePixel = 0
				frame4.Visible = false
				frame4.Parent = frame
				Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
				frame3 = Instance.new("Frame")
				frame3.Size = UDim2.new(0, 0, 1, 0)
				frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame3.BackgroundTransparency = 0.55
				frame3.BorderSizePixel = 0
				frame3.Parent = frame4
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
				visible = false
				flag8 = false
				n8 = 0
				n9 = 1
				n10 = 0
				n11 = 0

				fn20 = function()
					flag8 = false
				end

				fn21 = function(arg)
					if not flag5 or not screenGui2.Parent then
						flag8 = false
						return
					end
					n9 = math.max(tonumber(arg) or 1, 0.01)
					n8 = os.clock()
					flag8 = true
				end

				local n12 = 0.22
				local n13 = 10
				local color = Color3.fromRGB(255, 255, 255)
				v13 = nil
				local v14 = nil
				local radius = 0

				fn22 = function()
					if connection then
						connection:Disconnect()
						connection = nil
					end

					if v14 then
						pcall(function()
							v14:Destroy()
						end)

						v14 = nil
					end

					if v13 then
						pcall(function()
							v13:Destroy()
						end)

						v13 = nil
					end

					radius = 0
				end

				local function fn25()
					if v13 and v13.Parent and v14 then
						return
					end
					fn22()
					local part = Instance.new("Part")
					part.Name = fn()
					part.Anchored = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.CastShadow = false
					part.Massless = true
					part.Size = Vector3.one
					part.Transparency = 1
					part.Parent = Workspace
					local cylinderHandleAdornment =
						Instance.new("CylinderHandleAdornment")
					cylinderHandleAdornment.Name = fn()
					cylinderHandleAdornment.Adornee = part
					cylinderHandleAdornment.AlwaysOnTop = true
					cylinderHandleAdornment.Color3 = color
					cylinderHandleAdornment.Height = 0.05
					cylinderHandleAdornment.InnerRadius = 0
					cylinderHandleAdornment.Radius = 0
					cylinderHandleAdornment.Transparency = 0.25
					cylinderHandleAdornment.ZIndex = 1
					cylinderHandleAdornment.Parent = part
					v13 = part
					v14 = cylinderHandleAdornment
				end

				fn23 = function(arg)
					local character_ = localPlayer.Character
					character_ = character_
						and character_:FindFirstChild("HumanoidRootPart")

					if not visible or not character_ then
						if v13 then
							fn22()
						end

						return
					end

					fn25()
					local n14 = math.max(tonumber(n3) or 20, 1)
					local n15 = math.min(arg or 0.016, 0.1)

					if radius <= 0 then
						radius = n14
					else
						radius += (n14 - radius) * (1 - math.exp(-n15 * n13))
					end

					v13.CFrame = CFrame.new(
						character_.Position - Vector3.new(0, 2.9, 0)
					) * CFrame.Angles(-1.5707963267948966, 0, 0)
					v14.Radius = radius
					v14.InnerRadius = math.max(radius - n12, 0)
				end

				fn24 = function(arg)
					visible = arg == true
					frame4.Visible = visible
					frame.Size = UDim2.fromOffset(248, visible and 55 or 46)

					if not visible then
						n11 = 0
						frame3.Size = UDim2.new(0, 0, 1, 0)
						fn22()
					end
				end
			end

			local fn25

			fn25 = function(arg, arg2, arg3)
				if textLabel.Parent then
					textLabel.Text = tostring(arg or "")
					chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(
						chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle,
						arg3
					)
				end

				if textLabel2.Parent then
					textLabel2.Text = tostring(arg2 or "")
				end
			end

			do
				local flag9 = false
				local v14 = nil
				local vector2 = Vector2.new(0, 0)
				local position = nil

				fn4(
					runtime.Track(
						frame.InputBegan:Connect(runtime.Guard(function(input)
							if
								flag9
								or input.UserInputState
									~= Enum.UserInputState.Begin
							then
								return
							end
							local flag10 = input.UserInputType
								== Enum.UserInputType.Touch
							if
								not (
									input.UserInputType
									== Enum.UserInputType.MouseButton1
								) and not flag10
							then
								return
							end
							local vector22 =
								Vector2.new(input.Position.X, input.Position.Y)
							local absolutePosition = frame.AbsolutePosition
							local absoluteSize = frame.AbsoluteSize
							if
								vector22.X < absolutePosition.X
								or vector22.X > absolutePosition.X + absoluteSize.X
								or vector22.Y < absolutePosition.Y
								or vector22.Y
									> absolutePosition.Y + absoluteSize.Y
							then
								return
							end
							flag9 = true
							v14 = flag10 and input or nil
							vector2 = vector22
							position = frame.Position
						end))
					)
				)

				fn4(
					runtime.Track(
						UserInputService2.InputChanged:Connect(
							runtime.Guard(function(input)
								if not flag9 then
									return
								end

								if
									not (
										v14 and input == v14
										or not v14
											and input.UserInputType == Enum.UserInputType.MouseMovement
									) or not position
								then
									return
								end
								local n12 = Vector2.new(
									input.Position.X,
									input.Position.Y
								) - vector2
								frame.Position = UDim2.new(
									position.X.Scale,
									position.X.Offset + n12.X,
									position.Y.Scale,
									position.Y.Offset + n12.Y
								)
							end)
						)
					)
				)

				fn4(
					runtime.Track(
						UserInputService2.InputEnded:Connect(
							runtime.Guard(function(input)
								if not flag9 then
									return
								end
								local flag10 = v14 and input == v14
								local flag11

								if flag10 then
									flag11 = flag10
								else
									flag11 = not v14
										and input.UserInputType
											== Enum.UserInputType.MouseButton1
								end

								if flag11 then
									flag9 = false
									v14 = nil
									position = nil
								end
							end)
						)
					)
				)
			end

			local fn26

			fn26 = function()
				if screenGui2.Parent then
					screenGui2.Enabled = flag3 and flag5
				end

				if not flag3 or not flag5 then
					fn20()
					fn25("", "")
				end
			end

			do
				local n12 = 1
				local n13 = 0.25
				local n14 = -math.huge
				local n15 = -math.huge

				local function fn27()
					if not flag3 then
						return
					end
					local now = os.clock()
					if now - n14 < n12 then
						return
					end
					n14 = now

					task.spawn(function()
						fn14()
						task.wait(0.05)
						fn13()
					end)
				end

				local function fn28(arg)
					local now = os.clock()
					if now - n15 < n13 then
						return
					end
					n15 = now

					for _, v14 in ipairs(arg) do
						pcall(v14)
					end
				end

				local function fn29(arg)
					if
						not (arg and arg.Parent)
						or type(getconnections) ~= "function"
					then
						return
					end

					pcall(function()
						for _, v14 in
							pairs(getconnections(arg.PromptButtonHoldEnded))
						do
							if v14 and v14.Function then
								pcall(v14.Function)
							end
						end
					end)
				end

				local function fn30(arg, arg2, arg3, arg4, arg5)
					local prompt3 = type(arg) == "table" and arg.Prompt or arg
					local plotName = type(arg) == "table" and arg.PlotName
						or nil
					local slotName = type(arg) == "table" and arg.SlotName
						or nil
					if not prompt3 then
						return false, "no prompt"
					end

					if str2 == "Fix 1 (Wait Before Fire)" then
						task.wait(0.1)
					end

					local n16 = os.clock() - n6
					local n17 = 0

					if str2 == "Fix 2 (Longer Settle)" then
						n17 = 1.5
					end

					if n16 < n17 then
						task.wait(n17 - n16)
					end

					if not flag2 or not flag3 or arg2 ~= n5 then
						return false, "stopped"
					end
					local v14, v15 = fn19(prompt3)
					if not v14 or not v15 then
						return false, "no handlers"
					end
					local n18 = 1.3

					if flag6 then
						flag6 = false
						n18 = 2
					end

					if arg4 then
						pcall(arg4, n18)
					end

					if str2 == "Xen Hub Source v11" then
						if plotName and slotName then
							local function fn31()
								pcall(function()
									local reB096e1ca9c3a453b8b60268b235083 =
										game:GetService("ReplicatedStorage").Packages.Net["RE/b096e1ca-9c3a-453b-8b60-268b235083b9"]
									reB096e1ca9c3a453b8b60268b235083:FireServer(
										Workspace:GetServerTimeNow() + 53,
										"5c0bd012-dfb2-4bac-8f1a-e41f136e4744"
									)
									reB096e1ca9c3a453b8b60268b235083:FireServer(
										Workspace:GetServerTimeNow() + 53,
										"6be28b5b-dbc3-4aab-aa0c-6ebcfa191f22"
									)
								end)
							end

							local function fn32(arg6, arg7)
								pcall(function()
									game:GetService("ReplicatedStorage").Packages.Net["RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3"]
										:FireServer(
											Workspace:GetServerTimeNow() + 67,
											"c262398d-68e3-4499-8bea-99766bf11686",
											arg6,
											tonumber(arg7) or arg7
										)
									local v16
									v16:FireServer(
										Workspace:GetServerTimeNow() + 67,
										"579e6c26-5a80-407d-9488-0f84752e8f1f",
										arg6,
										tonumber(arg7) or arg7
									)
								end)
							end

							fn31()
							task.wait(1.3)
							fn32(plotName, slotName)
							return true, "fired xen hub source"
						end

						for _, v16 in ipairs(v14) do
							pcall(v16)
						end

						task.wait(1.3)

						for _, v16 in ipairs(v15) do
							pcall(v16)
						end

						return true, "fired fallback"
					end

					if
						str2
						and string.find(str2, "v20")
						and localPlayer:GetAttribute("Stealing") == true
					then
						return false, "v20_radar"
					end

					if str2 and string.find(str2, "v21") then
						local now = os.clock()

						while
							not prompt3.Enabled
							and prompt3.Parent
							and os.clock() - now < 0.6
						do
							task.wait(0.02)
						end
					end

					if
						os.clock() - n6 < 1.5
						and str2
						and (
							string.find(str2, "Smart Window")
							or string.find(str2, "v19")
							or string.find(str2, "v19")
						)
					then
						for _, v16 in ipairs(v14) do
							pcall(v16)
						end

						task.wait(n18)

						for _, v16 in ipairs(v15) do
							pcall(v16)
						end

						n6 = os.clock()
						return true, "fired (v14 protected window)"
					end

					local flag9 = str2 and string.find(str2, "v23")

					if flag9 then
						local v16 = globalCacheLockUntil
						flag9 = os.clock() < v16
					end

					if
						(isDebris or flag9)
						and str2
						and string.find(str2, "v22")
					then
						for _, v16 in ipairs(v14) do
							pcall(v16)
						end

						task.wait(n18)

						for _, v16 in ipairs(v15) do
							pcall(v16)
						end

						fn29(prompt3)
						n6 = os.clock()
						return true, "fired (v22 debris cache hold)"
					end

					if str2 == "Fix 4 (FireProximityPrompt)" then
						if fireproximityprompt then
							fireproximityprompt(prompt3, 0)
							fireproximityprompt(prompt3, 1)
						end
					end

					for _, v16 in ipairs(v14) do
						pcall(v16)
					end

					local str3 = tostring(prompt3.ObjectText)
					local now = os.clock()

					while os.clock() - now < n18 do
						task.wait(0.05)
						if not flag2 or not flag3 or arg2 ~= n5 then
							fn29(prompt3)
							return false, "stopped"
						end

						if
							not arg5
							and localPlayer:GetAttribute("Stealing") == true
						then
							for _, v16 in ipairs(v15) do
								pcall(v16)
							end

							fn29(prompt3)
							return false, "carrying"
						end

						if tostring(prompt3.ObjectText) ~= str3 then
							fn28(v15)
							fn27()
							fn29(prompt3)
							return false, "brainrot changed"
						end

						if
							not prompt3.Parent
							or not prompt3.Enabled
							or not arg3()
						then
							fn28(v15)
							fn27()
							fn29(prompt3)
							return false, "retargeted"
						end
					end

					local v16

					if
						str2 == "Default (Nullx11)"
						or str2 == "Fix 3 (Re-fetch Triggers)"
					then
						local v17
						v17, v16 = fn19(prompt3)
						v16 = v16 or v15
					else
						v16 = v15
					end

					for _, v17 in ipairs(v16) do
						pcall(v17)
					end

					fn29(prompt3)
					n6 = os.clock()
					return true, "fired"
				end

				local function fn31(arg, arg2, arg3)
					if not flag2 or not flag3 or arg2 ~= n5 then
						return false
					end

					if
						arg3
						and localPlayer:GetAttribute("Stealing") ~= true
					then
						return false
					end
					local character_ = localPlayer.Character
					local humanoidRootPart = character_
						and character_:FindFirstChild("HumanoidRootPart")
					if not humanoidRootPart then
						return false
					end

					if flag4 then
						local prompt3 = arg.Prompt
						if
							not prompt3
							or not prompt3.Parent
							or not prompt3.Enabled
							or tostring(prompt3.ActionText) ~= str
							or fn7(prompt3)
						then
							return false
						end
						local position = arg.Position
						return not position
							or (humanoidRootPart.Position - position).Magnitude
								<= n3
					end

					if prompt2 and prompt2.Parent then
						return arg.Prompt == prompt2
					end
					local v14

					if
						str2
						and (
							string.find(str2, "Mac Lib")
							or string.find(str2, "Original")
						)
					then
						local v15
						v15, v14 = fn17(humanoidRootPart)
					else
						local v15
						v15, v14 = fn18(humanoidRootPart)
					end

					if not v14 then
						return false
					end

					if v14.Prompt == arg.Prompt then
						return true
					end
					return v14.Distance
						>= (humanoidRootPart.Position - arg.Position).Magnitude
							- n
				end

				local function fn32(arg)
					local v14 = prompt
					local parent = prompt

					if v14 then
						parent = v14.Parent
					end

					if parent then
						local now = os.clock()

						while
							flag2
							and flag3
							and arg == n5
							and os.clock() - now < 1
						do
							if
								v14.Enabled
								and tostring(v14.ActionText) == str
							then
								return
							end
							task.wait(0.05)
						end
					else
						task.wait(0.2)
					end
				end

				local function fn33(arg)
					local flag9 = false

					while true do
						if flag2 and flag3 and arg == n5 then
							local flag10 = localPlayer:GetAttribute("Stealing")
								== true

							if not flag9 then
								if str2 and string.find(str2, "v19") then
									task.wait()
								else
									task.wait(0.1)
								end
							end

							local flag11 = not flag2 or not flag3 or arg ~= n5
							flag9 = false

							if not flag11 then
								if
									not (str2 and string.find(str2, "v20"))
									and localPlayer:GetAttribute("Stealing")
										== true
								then
									flag7 = true
									fn20()

									if flag5 then
										fn25(
											"GET READY - carrying brainrot",
											""
										)
									end

									while
										flag2
										and flag3
										and arg == n5
										and localPlayer:GetAttribute(
												"Stealing"
											)
											== true
									do
										if
											str2 and string.find(str2, "v19")
										then
											task.wait()
										else
											task.wait(0.05)
										end
									end

									if
										not (str2 and string.find(str2, "v19"))
									then
										fn32(arg)
									end

									flag7 = false

									if str2 and string.find(str2, "v19") then
										flag9 = true
									end
								else
									if
										not (str2 and string.find(str2, "v20"))
									then
										fn16(nil)
									end

									flag7 = false
									local character_ = localPlayer.Character
									character_ = character_
										and character_:FindFirstChild(
											"HumanoidRootPart"
										)

									if not character_ then
										fn20()
									else
										local v14, v15, v16

										if flag4 then
											v14, v15, v16 = fn18(character_)
										else
											v14, v15 = fn17(character_)
											v16 = nil
										end

										local v17 =
											fn12(character_, v14, v15, v16)
										fn15(v17)

										if not v17 then
											fn20()
										else
											prompt = v17.Prompt

											if
												not fn30(v17, arg, function()
													return fn31(v17, arg, false)
												end, fn21, false)
											then
												fn20()
											end
										end
									end
								end

								continue
							end
						end

						break
					end
				end

				fn13 = function()
					n5 += 1
					flag3 = true
					flag7 = false
					n7 = -math.huge
					fn26()
					task.spawn(fn33, n5)
				end
			end

			fn14 = function()
				flag3 = false
				flag7 = false
				n5 += 1
				fn20()
				fn16(nil)
				fn26()
			end

			local n12 = 0

			fn4(
				runtime.Track(
					localPlayer
						:GetAttributeChangedSignal("Stealing")
						:Connect(runtime.Guard(function()
							if localPlayer:GetAttribute("Stealing") == true then
								n6 = os.clock()
								n12 += 1
								local v14 = n12

								task.spawn(function()
									task.wait(1.5)

									if
										flag3
										and localPlayer:GetAttribute("Stealing") == true
										and n12 == v14
									then
										fn14()
										task.wait(0.05)
										fn13()
									end
								end)
							else
								n12 += 1

								if not (os.clock() - n4 < 0.5) then
									local flag9 = false

									if RagdollController then
										local ok, result = pcall(function()
											return RagdollController.IsInRagdoll()
										end)

										if ok and result == true then
											flag9 = true
										end
									end

									if not flag9 then
										local character_ = localPlayer.Character
										character_ = character_
											and character_:FindFirstChildOfClass(
												"Humanoid"
											)

										if character_ then
											local state = character_:GetState()

											if
												state
													== Enum.HumanoidStateType.Physics
												or state == Enum.HumanoidStateType.FallingDown
												or state
													== Enum.HumanoidStateType.Ragdoll
											then
												flag9 = true
											end
										end
									end

									local flag10

									if not flag9 then
										local character_ = localPlayer.Character

										if
											character_
											and character_:FindFirstChildOfClass(
												"BallSocketConstraint",
												true
											)
										then
											flag10 = true
										else
											flag10 = flag9
										end
									else
										flag10 = flag9
									end

									if flag10 then
										flag6 = true
									end
								end
							end
						end))
				)
			)

			fn4(
				runtime.Track(
					Workspace.ChildAdded:Connect(runtime.Guard(function(child)
						if child.Name == "Plots" then
							n7 = -math.huge
						end
					end))
				)
			)

			local plots = Workspace:FindFirstChild("Plots")

			if plots then
				fn4(
					runtime.Track(
						plots.ChildAdded:Connect(runtime.Guard(function()
							n7 = -math.huge
						end))
					)
				)

				fn4(
					runtime.Track(
						plots.ChildRemoved:Connect(runtime.Guard(function()
							n7 = -math.huge
						end))
					)
				)
			end

			local v14

			v14 = v12:CreateToggle({
				Name = "Auto Steal",
				Default = false,
				Callback = function(arg)
					str2 = "Auto Get Default"

					if arg then
						fn13()
					else
						fn14()
					end
				end,
			})

			local fn27

			fn27 = function()
				if v14 and v14.Get and v14:Get() ~= true then
					v14:Set(true, true)
				end
			end

			v12:CreateToggle({
				Name = "Steal Best Brainrot Only",
				Default = false,
				Quick = false,
				SubOf = v14,
				Callback = function(arg)
					flag4 = arg == true
				end,
			})

			do
				local tbl4 = {
					["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
					["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
					["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
				}

				local createSlider = nil
				local n13 = 1
				local str3 = "M/s"

				local function fn28(arg, arg2)
					if arg ~= nil then
						n13 = math.floor(tonumber(arg) or n13)
					end

					if arg2 ~= nil then
						str3 = tostring(arg2)
					elseif createSlider and createSlider.GetUnit then
						local unit = createSlider:GetUnit()

						if unit and unit ~= "" then
							str3 = tostring(unit)
						end
					end

					n2 = n13 * (tbl4[str3] or tbl4["M/s"]).Mult
					n7 = -math.huge
				end

				local function fn29(arg)
					str3 = arg
					local ms = tbl4[arg] or tbl4["M/s"]

					if createSlider and createSlider.SetRange then
						createSlider:SetRange(ms.Min, ms.Max)
						local min = createSlider:Get() or ms.Min
						local min2 = ms.Min
						local max = ms.Max
						local n14 = math.clamp(math.floor(min + 0.5), min2, max)

						if n14 ~= min then
							createSlider:Set(n14)
						else
							fn28(n14, arg)
						end
					else
						fn28(nil, arg)
					end
				end

				createSlider = v12.CreateSlider

				createSlider = createSlider(v12, {
					Name = "Auto Steal Min Value",
					Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
					Min = 0,
					Max = 1000,
					Default = 0,
					AllowDecimals = false,
					Increment = 1,
					Unit = {
						Default = "M/s",
						Selector = true,
						Options = { "K/s", "M/s", "B/s" },
						ColorEnabled = true,
						Colors = {
							Number = Color3.fromRGB(255, 255, 255),
							Suffix = Color3.fromRGB(58, 255, 55),
						},
						Callback = function(arg)
							fn29(arg)
						end,
					},
					Quick = false,
					SubOf = v14,
					Callback = function(arg)
						fn28(arg, nil)
					end,
				})
			end

			v12:CreateSlider({
				Name = "Auto Steal Distance",
				Min = 10,
				Max = 200,
				Default = 58,
				AllowDecimals = false,
				Increment = 1,
				Unit = " studs",
				Quick = false,
				SubOf = v14,
				Callback = function(arg)
					n3 = math.clamp(tonumber(arg) or 20, 10, 200)
				end,
			})

			local fn28

			do
				local color = Color3.fromRGB(170, 255, 0)
				local color2 = Color3.fromRGB(240, 255, 210)
				local flag9 = false
				local attachment = nil
				local attachment2 = nil
				local beam = nil
				local v15 = nil
				local v16 = nil
				local n13 = -math.huge

				fn28 = function()
					pcall(function()
						if beam then
							beam:Destroy()
						end
					end)

					pcall(function()
						if attachment then
							attachment:Destroy()
						end
					end)

					pcall(function()
						if attachment2 then
							attachment2:Destroy()
						end
					end)

					beam = nil
					attachment = nil
					attachment2 = nil
					v15 = nil
					v16 = nil
				end

				local function fn29()
					local v17 = Workspace:FindFirstChild(localPlayer.Name)
					if not v17 or not v17:IsA("Model") then
						return nil
					end
					local humanoidRootPart =
						v17:FindFirstChild("HumanoidRootPart")
					if
						humanoidRootPart
						and humanoidRootPart:IsA("BasePart")
						and humanoidRootPart.Parent == v17
					then
						return humanoidRootPart
					end
					local hitbox = v17:FindFirstChild("__HITBOX")
						or v17:FindFirstChild("__hitbox")
						or v17:FindFirstChild("Hitbox")
						or v17:FindFirstChild("HitBox")
					if hitbox and hitbox:IsA("BasePart") then
						return hitbox
					end
					return nil
				end

				local function fn30(parent, parent2)
					fn28()
					if not (parent and parent2) then
						return
					end
					attachment = Instance.new("Attachment")
					attachment.Name = fn()
					attachment.Position = Vector3.new(0, 0.6, 0)
					attachment.Parent = parent
					attachment2 = Instance.new("Attachment")
					attachment2.Name = fn()
					attachment2.Position = Vector3.new(0, 2.6, 0)
					attachment2.Parent = parent2
					beam = Instance.new("Beam")
					beam.Name = fn()
					beam.Archivable = false
					beam.Attachment0 = attachment
					beam.Attachment1 = attachment2
					beam.Color = ColorSequence.new(color, color2)
					beam.CurveSize0 = 0
					beam.CurveSize1 = 0
					beam.FaceCamera = true
					beam.LightEmission = 1
					beam.Segments = 4
					beam.Texture = "rbxassetid://446111271"
					beam.TextureLength = 3
					beam.TextureMode = Enum.TextureMode.Wrap
					beam.TextureSpeed = 3
					local v17 = beam
					local numberSequence = NumberSequence.new
					local tbl4 = {}
					local v18 = NumberSequenceKeypoint.new(0, 0)
					local v19 = NumberSequenceKeypoint.new(0.85, 0)
					tbl4[1] = v18
					tbl4[2] = v19

					do
						local values =
							table.pack(NumberSequenceKeypoint.new(1, 0.25))
						table.move(values, 1, values.n, 3, tbl4)
					end

					v17.Transparency = numberSequence(tbl4)
					beam.Width0 = 0.34
					beam.Width1 = 0.7
					beam.ZOffset = 0.1
					obj[beam] = true
					beam.Parent = attachment
					v15 = parent
					v16 = parent2
				end

				local function fn31()
					if not (flag9 and flag3) then
						if beam then
							fn28()
						end

						return
					end

					local now = os.clock()
					if now - n13 < 0.1 then
						return
					end
					n13 = now
					local character_ = localPlayer.Character
					local humanoidRootPart = character_
						and character_:FindFirstChild("HumanoidRootPart")
					local v17 = fn29(character_)
					if not (humanoidRootPart and v17) then
						fn28()
						return
					end
					local v18, v19, v20 = fn18(humanoidRootPart)
					local v21 = fn12(humanoidRootPart, v18, v19, v20)
					local spawn = v21 and fn10(v21.Prompt) or nil
					spawn = spawn and spawn.Spawn or nil
					if not spawn then
						fn28()
						return
					end
					local flag10 = v15 ~= v17 or v16 ~= spawn

					if not flag10 then
						flag10 = not (attachment and attachment.Parent)
					end

					if flag10 then
						fn30(v17, spawn)
					end
				end

				fn4(
					runtime.Track(
						RunService.Heartbeat:Connect(runtime.Guard(function()
							if flag2 then
								fn31()
							end
						end))
					)
				)

				v12:CreateToggle({
					Name = "Target Beam",
					Note = "Draws a straight amber line to the Brainrot Auto Steal is targeting.",
					Default = false,
					Quick = false,
					SubOf = v14,
					Callback = function(arg)
						flag9 = arg == true

						if not flag9 then
							fn28()
						end
					end,
				})
			end

			local n13
			n13 = 140
			local n14
			n14 = 5
			local n15
			n15 = 0.5
			local color
			color = Color3.fromRGB(58, 255, 55)
			local n16
			n16 = 214
			local n17
			n17 = 40
			local n18
			n18 = 44
			local screenGui3
			screenGui3 = nil
			local v15
			v15 = nil
			local v16
			v16 = nil
			local tbl4
			tbl4 = {}
			local v17
			v17 = nil
			local v18
			v18 = nil
			local flag9, n19, n20, v19, flag10, n21, str3, fn29

			do
				local v20 = nil
				local v21 = nil
				local v22 = nil
				flag9 = false
				n19 = 5
				n20 = 1
				v19 = nil
				flag10 = false
				n21 = -math.huge
				local v23 = nil
				local n22 = -math.huge
				str3 = ""
				local gothamBold = Enum.Font.GothamBold

				pcall(function()
					gothamBold = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.ExtraBold,
						Enum.FontStyle.Normal
					)
				end)

				local function fn30(arg)
					if typeof(gothamBold) == "Font" then
						arg.FontFace = gothamBold
					else
						arg.Font = Enum.Font.GothamBold
					end
				end

				local v24 = v2:CreateState({
					Name = "Base Target Panel Position",
					Default = {
						XOffset = 0,
						XScale = 0.78183454275131226,
						YScale = 0.022769367322325706,
						YOffset = 0,
					},
				})

				local function fn31()
					local v25 = v24:Get()
					if
						type(v25) == "table"
						and type(v25.XOffset) == "number"
						and type(v25.YOffset) == "number"
					then
						return UDim2.new(
							tonumber(v25.XScale) or 1,
							v25.XOffset,
							tonumber(v25.YScale) or 0.5,
							v25.YOffset
						)
					end
					return UDim2.new(1, -18, 0.5, 0)
				end

				local function fn32(arg)
					v24:Set({
						XScale = arg.X.Scale,
						XOffset = arg.X.Offset,
						YScale = arg.Y.Scale,
						YOffset = arg.Y.Offset,
					})
				end

				local tweenInfo = TweenInfo.new(
					0.28,
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				)
				local n23 = 0
				local v25 = nil

				local function fn33()
					if not v15 then
						return
					end
					local visible2 = n23 == 0 and not flag9

					if v20 then
						v20.Visible = visible2
						v20.Text = v25 and "no brainrot left in this base"
							or "no base nearby"
					end

					local n24 = flag9 and 0 or n23
					local n25

					if n24 > 0 then
						n25 = (n17 + 4) * n24 + 4
					else
						n25 = 0

						if visible2 then
							n25 = 26
						end
					end

					local n26 = n18 + n25
					if v21 == n26 then
						return
					end
					v21 = n26

					if v18 then
						if n25 > 0 then
							v18.Visible = true
						end

						TweenService:Create(
							v18,
							tweenInfo,
							{ Size = UDim2.new(1, -20, 0, math.max(n25, 1)) }
						):Play()
					end

					local tween = TweenService:Create(
						v15,
						tweenInfo,
						{ Size = UDim2.fromOffset(214, n26) }
					)

					if n25 <= 0 and v18 then
						runtime.Track(
							tween.Completed:Connect(runtime.Guard(function()
								if v18 and v21 == n26 then
									v18.Visible = false
								end
							end))
						)
					end

					tween:Play()
				end

				fn29 = function()
					table.clear(tbl4)
					v15 = nil
					v16 = nil
					v17 = nil
					v18 = nil
					v20 = nil
					v21 = nil
					v22 = nil
					v19 = nil
					str3 = ""

					if screenGui3 then
						pcall(function()
							screenGui3:Destroy()
						end)

						screenGui3 = nil
					end
				end

				local function fn34(arg, arg2)
					local debris = Workspace:FindFirstChild("Debris")
					if not debris or arg2 == "" then
						return nil
					end
					local v26 = nil
					local v27 = nil

					for _, child in ipairs(debris:GetChildren()) do
						if
							child.Name == "FastOverheadTemplate"
							and child:IsA("BasePart")
						then
							local animalOverhead =
								child:FindFirstChild("AnimalOverhead")
							local displayName = animalOverhead
								and animalOverhead:FindFirstChild("DisplayName")

							if
								displayName
								and displayName:IsA("TextLabel")
								and displayName.Text == arg2
							then
								local magnitude = (
									child.Position - arg.Position
								).Magnitude

								if not v26 or magnitude < v26 then
									v26 = magnitude
									v27 = animalOverhead
								end
							end
						end
					end

					if v27 and v26 and v26 <= 14 then
						return v27
					end
					return nil
				end

				local function fn35(arg, arg2, arg3)
					if not (arg and arg2) or arg3 == "" then
						return nil
					end
					local v26 = nil
					local v27 = nil

					for _, child in ipairs(arg:GetChildren()) do
						if child:IsA("Model") and child.Name == arg3 then
							local ok, result = pcall(function()
								return child:GetPivot()
							end)

							if ok then
								local magnitude = (
									result.Position - arg2.Position
								).Magnitude

								if not v26 or magnitude < v26 then
									v27 = child
									v26 = magnitude
								end
							end
						end
					end

					if v27 and v26 and v26 <= 14 then
						return v27
					end
					return nil
				end

				local str4 = ""

				local function fn36(arg, painted)
					if arg.Painted == painted then
						return
					end
					arg.Painted = painted
					local v26 = ipairs
					local tweens = arg.Tweens or {}

					for _, tween in v26(tweens) do
						pcall(function()
							tween:Cancel()
						end)
					end

					local tweens2 = {}
					local tween = TweenService:Create(
						arg.Accent,
						tweenInfo,
						{ Size = UDim2.new(0, painted and 3 or 0, 1, -12) }
					)
					local tween2 = TweenService:Create(arg.Stroke, tweenInfo, {
						Color = painted and color
							or Color3.fromRGB(255, 255, 255),
						Transparency = painted and 0.1 or 0.86,
					})
					local v27 = TweenService
					local create = v27.Create
					local row = arg.Row
					local tbl5 =
						{ BackgroundTransparency = painted and 0.12 or 0.4 }
					local v28 = table.pack(create(v27, row, tweenInfo, tbl5))
					tweens2[1] = tween
					tweens2[2] = tween2

					do
						local values = table.pack(table.unpack(v28, 1, v28.n))
						table.move(values, 1, values.n, 3, tweens2)
					end

					arg.Tweens = tweens2

					for _, tween3 in ipairs(arg.Tweens) do
						tween3:Play()
					end
				end

				local function fn37()
					for _, v26 in ipairs(tbl4) do
						fn36(v26, prompt2 ~= nil and v26.Prompt == prompt2)
					end
				end

				local function fn38(layoutOrder)
					local textButton = Instance.new("TextButton")
					textButton.AutoButtonColor = false
					textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
					textButton.BackgroundTransparency = 0.3
					textButton.BorderSizePixel = 0
					textButton.LayoutOrder = layoutOrder
					textButton.Size = UDim2.new(1, 0, 0, 40)
					textButton.Text = ""
					textButton.Parent = v16
					Instance.new("UICorner", textButton).CornerRadius =
						UDim.new(0, 9)
					local frame4 = Instance.new("Frame")
					frame4.AnchorPoint = Vector2.new(0, 0.5)
					frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					frame4.BorderSizePixel = 0
					frame4.Position = UDim2.new(0, 0, 0.5, 0)
					frame4.Size = UDim2.new(0, 0, 1, -12)
					frame4.ZIndex = 4
					frame4.Parent = textButton
					Instance.new("UICorner", frame4).CornerRadius =
						UDim.new(1, 0)
					local uiGradient = Instance.new("UIGradient")
					local new = ColorSequenceKeypoint.new
					local color2 = Color3.fromRGB
					uiGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(
							0,
							Color3.fromRGB(58, 255, 55)
						),
						new(1, color2(20, 109, 0)),
					})
					uiGradient.Rotation = 90
					uiGradient.Parent = frame4
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Thickness = 1.3
					uiStroke.Parent = textButton
					local viewportFrame = Instance.new("ViewportFrame")
					viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
					viewportFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
					viewportFrame.BackgroundTransparency = 0.25
					viewportFrame.BorderSizePixel = 0
					viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
					viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
					viewportFrame.Position = UDim2.fromOffset(4, 3)
					viewportFrame.Size = UDim2.fromOffset(n17 - 6, n17 - 6)
					viewportFrame.Parent = textButton
					Instance.new("UICorner", viewportFrame).CornerRadius =
						UDim.new(0, 8)
					local camera = Instance.new("Camera")
					camera.Parent = viewportFrame
					viewportFrame.CurrentCamera = camera
					local frame5 = Instance.new("Frame")
					frame5.AnchorPoint = Vector2.new(1, 1)
					frame5.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
					frame5.BackgroundTransparency = 0.15
					frame5.BorderSizePixel = 0
					frame5.Position = UDim2.fromOffset(n17 - 3, n17 - 3)
					frame5.Size = UDim2.fromOffset(24, 13)
					frame5.ZIndex = 4
					frame5.Parent = textButton
					Instance.new("UICorner", frame5).CornerRadius =
						UDim.new(0, 5)
					local textLabel3 = Instance.new("TextLabel")
					textLabel3.BackgroundTransparency = 1
					textLabel3.Size = UDim2.fromScale(1, 1)
					textLabel3.Text = ""
					textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel3.TextScaled = true
					textLabel3.ZIndex = 5
					fn30(textLabel3)
					textLabel3.Parent = frame5
					local uiStroke2 = Instance.new("UIStroke")
					uiStroke2.Color = Color3.fromRGB(0, 0, 0)
					uiStroke2.Thickness = 1.4
					uiStroke2.Transparency = 0.25
					uiStroke2.Parent = textLabel3
					local textLabel4 = Instance.new("TextLabel")
					textLabel4.BackgroundTransparency = 1
					textLabel4.Position = UDim2.fromOffset(n17 + 2, 5)
					textLabel4.Size = UDim2.new(1, -n17 - 10, 0, 13)
					textLabel4.Text = ""
					textLabel4.TextColor3 = Color3.fromRGB(238, 238, 242)
					textLabel4.TextScaled = true
					textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
					textLabel4.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel4)
					textLabel4.Parent = textButton
					local v26 =
						chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(
							textLabel4
						)
					local textLabel5 = Instance.new("TextLabel")
					textLabel5.BackgroundTransparency = 1
					textLabel5.Position = UDim2.fromOffset(n17 + 2, 20)
					textLabel5.Size = UDim2.fromOffset(62, 11)
					textLabel5.Text = ""
					textLabel5.TextColor3 = Color3.fromRGB(115, 255, 0)
					textLabel5.TextScaled = true
					textLabel5.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel5)
					textLabel5.Parent = textButton
					local textLabel6 = Instance.new("TextLabel")
					textLabel6.BackgroundTransparency = 1
					textLabel6.Position = UDim2.fromOffset(n17 + 66, 20)
					textLabel6.RichText = true
					textLabel6.Size = UDim2.fromOffset(62, 11)
					textLabel6.Text = ""
					textLabel6.TextScaled = true
					textLabel6.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel6)
					textLabel6.Parent = textButton
					local frame6 = Instance.new("Frame")
					frame6.AnchorPoint = Vector2.new(1, 0)
					frame6.BackgroundTransparency = 1
					frame6.Position = UDim2.new(1, -7, 0, 19)
					frame6.Size = UDim2.fromOffset(44, 12)
					frame6.Parent = textButton
					local uiListLayout = Instance.new("UIListLayout")
					uiListLayout.FillDirection = Enum.FillDirection.Horizontal
					uiListLayout.HorizontalAlignment =
						Enum.HorizontalAlignment.Right
					uiListLayout.Padding = UDim.new(0, 2)
					uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uiListLayout.VerticalAlignment =
						Enum.VerticalAlignment.Center
					uiListLayout.Parent = frame6

					local tbl5 = {
						Row = textButton,
						Accent = frame4,
						Stroke = uiStroke,
						Viewport = viewportFrame,
						Camera = camera,
						Rank = textLabel3,
						NameLabel = textLabel4,
						NameStyle = v26,
						ValueLabel = textLabel5,
						MutationLabel = textLabel6,
						TraitHolder = frame6,
						Prompt = nil,
						RowKey = nil,
						ModelKey = nil,
						Clone = nil,
						Track = nil,
						SourceTrack = nil,
						Painted = nil,
						Tweens = nil,
					}

					fn5(textButton, function()
						if not tbl5.Prompt then
							return
						end

						if prompt2 == tbl5.Prompt then
							prompt2 = nil
							str4 = ""
						else
							prompt2 = tbl5.Prompt
							str4 = tbl5.NameLabel.Text
							fn27()
						end

						str3 = ""
						fn37()
					end)

					return tbl5
				end

				local function fn39()
					if screenGui3 and screenGui3.Parent then
						return
					end
					screenGui3 = Instance.new("ScreenGui")
					screenGui3.Name = "Nullx11BrainrotAutoGetTargetPanel"
					screenGui3.DisplayOrder = 5
					screenGui3.IgnoreGuiInset = true
					screenGui3.ResetOnSpawn = false
					screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					local parent = CoreGui

					if type(gethui) == "function" then
						local ok
						ok, parent = pcall(gethui)
						ok = ok and typeof(parent) == "Instance"
						local v26 = CoreGui

						if not ok then
							parent = v26
						end
					end

					screenGui3.Parent = parent
					local frame4 = Instance.new("Frame")
					frame4.Active = true
					frame4.AnchorPoint = Vector2.new(1, 0)
					frame4.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
					frame4.BackgroundTransparency = 0.18
					frame4.BorderSizePixel = 0
					frame4.Position = fn31()
					frame4.Size = UDim2.fromOffset(214, 44)
					frame4.ClipsDescendants = true
					frame4.Parent = screenGui3
					Instance.new("UICorner", frame4).CornerRadius =
						UDim.new(0, 14)
					v15 = frame4
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Color = Color3.fromRGB(255, 255, 255)
					uiStroke.Thickness = 1
					uiStroke.Transparency = 0.9
					uiStroke.Parent = frame4
					local uiScale = Instance.new("UIScale")
					uiScale.Parent = frame4

					local function fn40()
						local currentCamera = Workspace.CurrentCamera
						local viewportSize = currentCamera
								and currentCamera.ViewportSize
							or Vector2.new(1280, 720)

						if viewportSize.X < 1 then
							viewportSize = Vector2.new(1280, 720)
						end

						uiScale.Scale = math.clamp(
							viewportSize.X * 0.15 / n16,
							0.7,
							1.3
						) * n20
					end

					v19 = fn40
					fn40()
					local currentCamera = Workspace.CurrentCamera

					if currentCamera then
						fn4(
							runtime.Track(
								currentCamera
									:GetPropertyChangedSignal("ViewportSize")
									:Connect(runtime.Guard(fn40))
							)
						)
					end

					local textButton = Instance.new("TextButton")
					textButton.Name = "Handle"
					textButton.Active = true
					textButton.AutoButtonColor = false
					textButton.BackgroundTransparency = 1
					textButton.BorderSizePixel = 0
					textButton.Position = UDim2.fromOffset(0, 0)
					textButton.Size = UDim2.new(1, 0, 0, 44)
					textButton.Text = ""
					textButton.ZIndex = 2
					textButton.Parent = frame4
					local fn41 = nil
					local flag11 = false
					local flag12 = nil
					local flag13 = false
					local vector2 = Vector2.new(0, 0)
					local vector22 = Vector2.new(0, 0)

					runtime.Track(
						textButton.InputBegan:Connect(
							runtime.Guard(function(input)
								if
									flag11
									or input.UserInputState
										~= Enum.UserInputState.Begin
								then
									return
								end

								if
									input.UserInputType
										~= Enum.UserInputType.MouseButton1
									and input.UserInputType
										~= Enum.UserInputType.Touch
								then
									return
								end
								local vector23 = Vector2.new(
									input.Position.X,
									input.Position.Y
								)
								local absolutePosition =
									textButton.AbsolutePosition
								local absoluteSize = textButton.AbsoluteSize
								if
									vector23.X < absolutePosition.X
									or vector23.X > absolutePosition.X + absoluteSize.X
									or vector23.Y < absolutePosition.Y
									or vector23.Y
										> absolutePosition.Y + absoluteSize.Y
								then
									return
								end

								for _, child in ipairs(textButton:GetChildren()) do
									if
										child:IsA("GuiButton") and child.Visible
									then
										local absolutePosition2 =
											child.AbsolutePosition
										local absoluteSize2 = child.AbsoluteSize
										if
											vector23.X
												>= absolutePosition2.X
											and vector23.X <= absolutePosition2.X + absoluteSize2.X
											and vector23.Y >= absolutePosition2.Y
											and vector23.Y
												<= absolutePosition2.Y + absoluteSize2.Y
										then
											return
										end
									end
								end

								local absoluteSize2 = screenGui3.AbsoluteSize
								if
									absoluteSize2.X <= 0
									or absoluteSize2.Y <= 0
								then
									return
								end
								flag11 = true
								flag13 = false
								flag12 = input.UserInputType
											== Enum.UserInputType.Touch
										and input
									or nil
								vector2 = Vector2.new(
									input.Position.X,
									input.Position.Y
								)
								vector22 = Vector2.new(
									frame4.Position.X.Scale
										+ frame4.Position.X.Offset
											/ absoluteSize2.X,
									frame4.Position.Y.Scale
										+ frame4.Position.Y.Offset
											/ absoluteSize2.Y
								)
							end)
						)
					)

					fn4(
						runtime.Track(
							UserInputService2.InputChanged:Connect(
								runtime.Guard(function(input)
									if not flag11 then
										return
									end

									if
										not (
											flag12 and input == flag12
											or not flag12
												and input.UserInputType == Enum.UserInputType.MouseMovement
										) or not v15
									then
										return
									end
									local absoluteSize = screenGui3.AbsoluteSize
									if
										absoluteSize.X <= 0
										or absoluteSize.Y <= 0
									then
										return
									end
									local n24 = Vector2.new(
										input.Position.X,
										input.Position.Y
									) - vector2
									if not flag13 and n24.Magnitude < 6 then
										return
									end
									flag13 = true
									frame4.Position = UDim2.fromScale(
										math.clamp(
											vector22.X + n24.X / absoluteSize.X,
											math.min(
												math.max(
													frame4.AbsoluteSize.X
														/ absoluteSize.X,
													0
												),
												0.998
											),
											0.998
										),
										math.clamp(
											vector22.Y + n24.Y / absoluteSize.Y,
											0,
											0.98
										)
									)
								end)
							)
						)
					)

					fn4(
						runtime.Track(
							UserInputService2.InputEnded:Connect(
								runtime.Guard(function(input)
									if not flag11 then
										return
									end

									if
										input.UserInputType
											== Enum.UserInputType.MouseButton1
										or input == flag12
									then
										flag11 = false
										flag12 = nil

										if flag13 then
											fn32(frame4.Position)
										elseif fn41 then
											fn41()
										end
									end
								end)
							)
						)
					)

					local textLabel3 = Instance.new("TextLabel")
					textLabel3.BackgroundTransparency = 1
					textLabel3.Position = UDim2.fromOffset(32, 8)
					textLabel3.Size = UDim2.fromOffset(n16 - 102, 14)
					textLabel3.Text = "Base Targets"
					textLabel3.TextColor3 = Color3.fromRGB(240, 240, 244)
					textLabel3.TextScaled = true
					textLabel3.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel3)
					textLabel3.Parent = textButton
					local textLabel4 = Instance.new("TextLabel")
					textLabel4.BackgroundTransparency = 1
					textLabel4.Position = UDim2.fromOffset(32, 23)
					textLabel4.Size = UDim2.fromOffset(n16 - 102, 10)
					textLabel4.Text = "walk into a base"
					textLabel4.TextColor3 = Color3.fromRGB(140, 140, 150)
					textLabel4.TextScaled = true
					textLabel4.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel4)
					textLabel4.Parent = textButton
					v17 = textLabel4
					local textButton2 = Instance.new("TextButton")
					textButton2.AnchorPoint = Vector2.new(0, 0.5)
					textButton2.AutoButtonColor = false
					textButton2.BackgroundTransparency = 1
					textButton2.BorderSizePixel = 0
					textButton2.Position =
						UDim2.new(0, 8, 0, math.floor(n18 * 0.5))
					textButton2.Size = UDim2.fromOffset(20, 20)
					textButton2.Text = ""
					textButton2.ZIndex = 6
					textButton2.Parent = textButton
					local frame5 = Instance.new("Frame")
					frame5.AnchorPoint = Vector2.new(0.5, 0.5)
					frame5.BackgroundTransparency = 1
					frame5.BorderSizePixel = 0
					frame5.Position = UDim2.fromScale(0.5, 0.5)
					frame5.Size = UDim2.fromScale(0.62, 0.62)
					frame5.Parent = textButton2
					local uiAspectRatioConstraint =
						Instance.new("UIAspectRatioConstraint")
					uiAspectRatioConstraint.AspectRatio = 1
					uiAspectRatioConstraint.AspectType =
						Enum.AspectType.FitWithinMaxSize
					uiAspectRatioConstraint.DominantAxis =
						Enum.DominantAxis.Height
					uiAspectRatioConstraint.Parent = frame5

					for _, v26 in ipairs({ { 0.335355, 45 }, { 0.664645, -45 } }) do
						local frame6 = Instance.new("Frame")
						frame6.AnchorPoint = Vector2.new(0.5, 0.5)
						frame6.BackgroundColor3 = Color3.fromRGB(58, 255, 55)
						frame6.BorderSizePixel = 0
						frame6.Position = UDim2.fromScale(v26[1], 0.535355)
						frame6.Rotation = v26[2]
						frame6.Size = UDim2.fromScale(0.6657, 0.2)
						frame6.Parent = frame5
					end

					v22 = frame5
					frame5.Rotation = flag9 and 180 or 0

					fn41 = function()
						flag9 = not flag9
						TweenService:Create(
							frame5,
							tweenInfo,
							{ Rotation = flag9 and 180 or 0 }
						):Play()
						fn33()
					end

					fn5(textButton2, fn41)
					local textButton3 = Instance.new("TextButton")
					textButton3.AnchorPoint = Vector2.new(1, 0)
					textButton3.AutoButtonColor = false
					textButton3.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
					textButton3.BackgroundTransparency = 0.2
					textButton3.BorderSizePixel = 0
					textButton3.Position = UDim2.new(1, -10, 0, 8)
					textButton3.Size = UDim2.fromOffset(58, 20)
					textButton3.Text = ""
					textButton3.Parent = textButton
					Instance.new("UICorner", textButton3).CornerRadius =
						UDim.new(1, 0)
					local uiStroke2 = Instance.new("UIStroke")
					uiStroke2.Color = Color3.fromRGB(255, 255, 255)
					uiStroke2.Thickness = 1.2
					uiStroke2.Transparency = 0.78
					uiStroke2.Parent = textButton3
					local textLabel5 = Instance.new("TextLabel")
					textLabel5.BackgroundTransparency = 1
					textLabel5.Position = UDim2.fromOffset(9, 5)
					textLabel5.Size = UDim2.fromOffset(9, 10)
					textLabel5.Text = "X"
					textLabel5.TextColor3 = Color3.fromRGB(226, 226, 232)
					textLabel5.TextScaled = true
					fn30(textLabel5)
					textLabel5.Parent = textButton3
					local textLabel6 = Instance.new("TextLabel")
					textLabel6.BackgroundTransparency = 1
					textLabel6.Position = UDim2.fromOffset(21, 5)
					textLabel6.Size = UDim2.fromOffset(30, 10)
					textLabel6.Text = "Clear"
					textLabel6.TextColor3 = Color3.fromRGB(226, 226, 232)
					textLabel6.TextScaled = true
					textLabel6.TextXAlignment = Enum.TextXAlignment.Left
					fn30(textLabel6)
					textLabel6.Parent = textButton3

					local function fn42(arg)
						local color2 = arg and Color3.fromRGB(255, 150, 150)
							or Color3.fromRGB(226, 226, 232)
						TweenService:Create(
							textButton3,
							tweenInfo,
							{ BackgroundTransparency = arg and 0.05 or 0.2 }
						):Play()

						TweenService
							:Create(uiStroke2, tweenInfo, {
								Color = arg and Color3.fromRGB(255, 120, 120)
									or Color3.fromRGB(255, 255, 255),
								Transparency = arg and 0.25 or 0.78,
							})
							:Play()

						TweenService
							:Create(
								textLabel5,
								tweenInfo,
								{ TextColor3 = color2 }
							)
							:Play()
						TweenService
							:Create(
								textLabel6,
								tweenInfo,
								{ TextColor3 = color2 }
							)
							:Play()
					end

					runtime.Track(
						textButton3.MouseEnter:Connect(runtime.Guard(function()
							fn42(true)
						end))
					)

					runtime.Track(
						textButton3.MouseLeave:Connect(runtime.Guard(function()
							fn42(false)
						end))
					)

					fn5(textButton3, function()
						prompt2 = nil
						str4 = ""
						str3 = ""
						fn37()
					end)

					local frame6 = Instance.new("Frame")
					frame6.BackgroundTransparency = 1
					frame6.Position = UDim2.fromOffset(10, 40)
					frame6.Size = UDim2.new(1, -20, 0, (n17 + 4) * (n14 + 1))
					frame6.Parent = frame4
					local uiListLayout = Instance.new("UIListLayout")
					uiListLayout.FillDirection = Enum.FillDirection.Vertical
					uiListLayout.Padding = UDim.new(0, 4)
					uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uiListLayout.Parent = frame6
					v16 = frame6
					v18 = frame6
					local textLabel7 = Instance.new("TextLabel")
					textLabel7.BackgroundTransparency = 1
					textLabel7.LayoutOrder = 99
					textLabel7.Size = UDim2.new(1, 0, 0, 22)
					textLabel7.Text = ""
					textLabel7.TextColor3 = Color3.fromRGB(140, 140, 150)
					textLabel7.TextScaled = true
					textLabel7.Visible = false
					fn30(textLabel7)
					textLabel7.Parent = frame6
					v20 = textLabel7
					table.clear(tbl4)

					for i_ = 1, n14 + 1 do
						tbl4[i_] = fn38(i_)
					end
				end

				local function fn40(arg, arg2, arg3, arg4, arg5)
					local modelKey = tostring(arg5) .. "|" .. arg4
					if
						arg.ModelKey == modelKey
						and arg.Clone
						and arg.Clone.Parent
					then
						return
					end

					for _, child in ipairs(arg.Viewport:GetChildren()) do
						if not child:IsA("Camera") then
							child:Destroy()
						end
					end

					arg.Clone = nil
					arg.Track = nil
					arg.SourceTrack = nil
					if arg4 == "" then
						arg.ModelKey = modelKey
						return
					end
					local v26 = fn35(arg2, arg3, arg4)
					if not v26 then
						arg.ModelKey = nil
						return
					end
					arg.ModelKey = modelKey

					local ok, clone = pcall(function()
						return v26:Clone()
					end)

					if not ok or not clone then
						arg.ModelKey = nil
						return
					end

					for _, descendant in ipairs(clone:GetDescendants()) do
						if
							descendant:IsA("ParticleEmitter")
							or descendant:IsA("Beam")
							or descendant:IsA("Trail")
							or descendant:IsA("Light")
							or descendant:IsA("Sound")
							or descendant:IsA("Script")
							or descendant:IsA("LocalScript")
						then
							descendant:Destroy()
						end
					end

					local worldModel = Instance.new("WorldModel")
					worldModel.Parent = arg.Viewport
					clone.Parent = worldModel

					pcall(function()
						clone:PivotTo(CFrame.new())
					end)

					local ok2, result, result2 = pcall(function()
						return clone:GetBoundingBox()
					end)

					local v27 = ok2 and result2
					local n24 = 4

					if v27 then
						n24 = math.max(result2.X, result2.Y, result2.Z)
					end

					local n25 = math.max(n24 * 1.05, 3)
					ok2 = ok2 and result.Position or Vector3.zero
					arg.Camera.CFrame = CFrame.lookAt(
						ok2 + Vector3.new(n25 * 0.28, n25 * 0.08, -n25),
						ok2,
						Vector3.new(0, 1, 0)
					)
					arg.Clone = clone
					local humanoid = v26:FindFirstChildWhichIsA("Humanoid")
						or v26:FindFirstChildWhichIsA("AnimationController")
					humanoid = humanoid
						and humanoid:FindFirstChildOfClass("Animator")
					local humanoid2 = clone:FindFirstChildWhichIsA("Humanoid")
						or clone:FindFirstChildWhichIsA("AnimationController")
					humanoid2 = humanoid2
						and humanoid2:FindFirstChildOfClass("Animator")
					if not (humanoid and humanoid2) then
						return
					end
					local playingAnimationTracks =
						humanoid:GetPlayingAnimationTracks()
					playingAnimationTracks = playingAnimationTracks
						and playingAnimationTracks[1]
					if
						not playingAnimationTracks
						or not playingAnimationTracks.Animation
					then
						return
					end
					local animation = Instance.new("Animation")
					animation.AnimationId =
						playingAnimationTracks.Animation.AnimationId

					local ok3, track = pcall(function()
						return humanoid2:LoadAnimation(animation)
					end)

					if ok3 and track then
						pcall(function()
							track.Looped = true
							track:Play(0)
							track.TimePosition =
								playingAnimationTracks.TimePosition
							track:AdjustSpeed(playingAnimationTracks.Speed)
						end)

						arg.Track = track
						arg.SourceTrack = playingAnimationTracks
					end
				end

				local function fn41()
					for _, v26 in ipairs(tbl4) do
						local track = v26.Track
						local sourceTrack = v26.SourceTrack

						if track and sourceTrack and v26.Row.Visible then
							if
								not pcall(function()
									if not track.IsPlaying then
										track:Play(0)
									end

									if
										math.abs(
											track.TimePosition
												- sourceTrack.TimePosition
										) > 0.2
									then
										track.TimePosition =
											sourceTrack.TimePosition
									end
								end)
							then
								v26.Track = nil
								v26.SourceTrack = nil
							end
						end
					end
				end

				local function fn42(arg, arg2)
					for _, child in ipairs(arg.TraitHolder:GetChildren()) do
						if child:IsA("ImageLabel") then
							child:Destroy()
						end
					end

					arg2 = arg2 and arg2:FindFirstChild("Traits")
					if not arg2 then
						return
					end
					local layoutOrder = 0

					for _, child in ipairs(arg2:GetChildren()) do
						if
							child:IsA("ImageLabel")
							and child.Visible
							and child.Image ~= ""
							and layoutOrder < 3
						then
							layoutOrder += 1
							local imageLabel = Instance.new("ImageLabel")
							imageLabel.BackgroundTransparency = 1
							imageLabel.Image = child.Image
							imageLabel.LayoutOrder = layoutOrder
							imageLabel.Size = UDim2.fromOffset(12, 12)
							imageLabel.Parent = arg.TraitHolder
						end
					end
				end

				local function fn43()
					if not flag10 then
						if screenGui3 then
							fn29()
						end

						return
					end

					local now = os.clock()
					if now - n21 < n15 then
						return
					end
					n21 = now
					local character_ = localPlayer.Character
					character_ = character_
						and character_:FindFirstChild("HumanoidRootPart")
					if not character_ then
						fn29()
						return
					end
					fn39()
					fn9(false)
					local v26 = nil
					local plot = nil

					for _, v27 in ipairs(tbl3) do
						if v27.Prompt.Parent then
							local magnitude = (
								character_.Position - v27.Spawn.Position
							).Magnitude

							if
								magnitude <= n13
								and (not v26 or magnitude < v26)
							then
								plot = v27.Plot
								v26 = magnitude
							end
						end
					end

					if plot then
						v23 = plot
						n22 = now
					elseif v23 and v23.Parent and now - n22 < 3 then
						plot = v23
					end

					local tbl5 = {}

					if plot then
						for _, v27 in ipairs(tbl3) do
							local prompt3 = v27.Prompt
							local parent = v27.Plot == plot and prompt3.Parent

							if parent then
								parent = tostring(prompt3.ObjectText or "")
									~= ""
							end

							if parent then
								tbl5[#tbl5 + 1] = {
									Podium = v27,
									Distance = (
										character_.Position - v27.Spawn.Position
									).Magnitude,
									Generation = v27.Generation or 0,
								}
							end
						end
					end

					local v27 = nil

					for _, v28 in ipairs(tbl5) do
						if not v27 or v28.Distance < v27.Distance then
							v27 = v28
						end
					end

					table.sort(tbl5, function(arg, arg2)
						return arg.Generation > arg2.Generation
					end)

					local tbl6 = {}

					if v27 then
						tbl6[#tbl6 + 1] = { Data = v27, Rank = 0 }
					end

					for i_ = 1, math.min(n19, #tbl5) do
						tbl6[#tbl6 + 1] = { Data = tbl5[i_], Rank = i_ }
					end

					local str5 = tostring(prompt2)

					for _, v28 in ipairs(tbl6) do
						str5 ..= "|" .. tostring(v28.Data.Podium.Prompt) .. ":" .. tostring(
							v28.Rank
						)
					end

					local flag11 = str5 ~= str3
					str3 = str5

					if v17 then
						v17.Text = plot
								and string.format("%d brainrot here", #tbl5)
							or "walk into a base"
					end

					n23 = #tbl6
					v25 = plot
					fn33()
					if flag9 then
						return
					end

					for i_, v28 in ipairs(tbl4) do
						local v29 = tbl6[i_]

						if not v29 then
							v28.Row.Visible = false
							v28.Prompt = nil
							v28.RowKey = nil
							v28.Clone = nil
							v28.Track = nil
							v28.SourceTrack = nil
						else
							local podium = v29.Data.Podium
							local text =
								tostring(podium.Prompt.ObjectText or "")
							v28.Row.Visible = true
							v28.Prompt = podium.Prompt
							v28.RowKey = tostring(podium.Prompt)
								.. ":"
								.. tostring(v29.Rank)

							if v29.Rank == 0 then
								v28.Rank.Text = "NEAR"
								v28.Rank.TextColor3 =
									Color3.fromRGB(125, 205, 255)
							else
								v28.Rank.Text = "#" .. v29.Rank
								v28.Rank.TextColor3 =
									Color3.fromRGB(255, 214, 84)
							end

							v28.NameLabel.Text = text
							chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(
								v28.NameStyle,
								v29.Data.Generation
							)
							v28.ValueLabel.Text = fn8(v29.Data.Generation)

							if flag11 then
								local v30 = fn34(podium.Spawn, text)
								local mutation = v30
									and v30:FindFirstChild("Mutation")

								if
									mutation
									and mutation:IsA("TextLabel")
									and mutation.Visible
									and tostring(mutation.Text) ~= ""
								then
									v28.MutationLabel.Text = mutation.Text
									v28.MutationLabel.TextColor3 =
										mutation.TextColor3
									v28.MutationLabel.RichText =
										mutation.RichText
								else
									v28.MutationLabel.Text = ""
								end

								fn42(v28, v30)
							end

							fn40(
								v28,
								podium.Plot,
								podium.Spawn,
								text,
								podium.Prompt
							)
						end
					end

					fn37()
				end

				fn4(
					runtime.Track(
						RunService.Heartbeat:Connect(runtime.Guard(function()
							if flag2 then
								fn43()
							end
						end))
					)
				)

				local n24 = 0

				fn4(
					runtime.Track(
						RunService.Heartbeat:Connect(runtime.Guard(function()
							if not (flag2 and flag10 and screenGui3) then
								return
							end
							local now = os.clock()
							if now < n24 then
								return
							end
							n24 = now + 0.25
							fn41()
						end))
					)
				)

				v12:CreateToggle({
					Name = "Show Auto Steal Bar",
					Note = "Shows the current Auto Steal target and hold progress.",
					Default = false,
					Quick = false,
					SubOf = v14,
					Callback = function(arg)
						flag5 = arg == true
						fn26()
					end,
				})

				v12:CreateToggle({
					Name = "Show Distance Meter",
					Note = "Adds a live distance row to the bar, measured against Auto Steal Distance.",
					Default = false,
					Quick = false,
					SubOf = v14,
					Callback = function(arg)
						fn24(arg == true)
					end,
				})

				v12:CreateSlider({
					Name = "Base Panel Size",
					Note = "Scales the Base Target Panel.",
					Min = 60,
					Max = 160,
					Default = 85,
					AllowDecimals = false,
					Increment = 1,
					Unit = "%",
					Quick = false,
					Callback = function(arg)
						n20 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)

						if v19 then
							v19()
						end
					end,
				})

				local v26 = v12:CreateToggle({
					Name = "Base Target Panel",
					Note = "Lists the nearest and highest Brainrots in this base; pick one to take it first.",
					Default = false,
					Quick = false,
					Callback = function(arg)
						flag10 = arg == true

						if not flag10 then
							fn29()
						end
					end,
				})

				v12:CreateDropdown({
					Name = "Base Target Count",
					Options = { "1", "2", "3", "4", "5" },
					Default = "3",
					Quick = false,
					SubOf = v26,
					Callback = function(arg)
						local n25 =
							math.clamp(math.floor(tonumber(arg) or 5), 1, 5)
						if n19 == n25 then
							return
						end
						n19 = n25
						str3 = ""
						n21 = -math.huge

						if flag10 then
							fn43()
						end
					end,
				})

				v12:CreateButton({
					Name = "Pick Nearest Target",
					ButtonText = "Pick",
					Note = "Targets the closest Brainrot; bind a key to it for one-press picking.",
					Quick = false,
					SubOf = v26,
					Callback = function()
						local character_ = localPlayer.Character
						character_ = character_
							and character_:FindFirstChild("HumanoidRootPart")
						if not character_ then
							return
						end
						fn9(false)
						local v27 = nil
						local v28 = nil

						for _, v29 in ipairs(tbl3) do
							local prompt3 = v29.Prompt
							local parent = prompt3.Parent

							if parent then
								parent = tostring(prompt3.ObjectText or "")
									~= ""
							end

							if parent then
								local magnitude = (
									character_.Position - v29.Spawn.Position
								).Magnitude

								if not v27 or magnitude < v27 then
									v27 = magnitude
									v28 = v29
								end
							end
						end

						if not v28 then
							return
						end
						prompt2 = v28.Prompt
						str4 = tostring(v28.Prompt.ObjectText or "")
						fn27()
						str3 = ""
						fn37()
					end,
				})

				v12:CreateButton({
					Name = "Clear Picked Target",
					ButtonText = "Clear",
					Note = "Drops the picked Brainrot and returns to Nearest or Highest.",
					Quick = false,
					SubOf = v26,
					Callback = function()
						prompt2 = nil
						str4 = ""
						str3 = ""
						fn37()
					end,
				})
			end

			do
				local n22 = 0.05
				local n23 = 22
				local n24 = 9
				local v20 = nil
				local n25 = -math.huge
				local n26 = 0
				local flag11 = false
				local v21 = nil

				fn4(
					runtime.Track(
						RunService.RenderStepped:Connect(
							runtime.Guard(function(deltaTime)
								if flag2 and flag3 then
									fn23(deltaTime)
								elseif v13 then
									fn22()
								end

								if not flag2 or not flag3 or not flag5 then
									v20 = nil
									return
								end
								local now = os.clock()

								if now - n25 >= n22 then
									n25 = now
									local str4, str5, generation

									if
										flag7
										or localPlayer:GetAttribute(
												"Stealing"
											)
											== true
									then
										n26 = 0
										str4 = "GET READY - carrying brainrot"
										str5 = ""
										generation = nil
									else
										local character_ = localPlayer.Character
										character_ = character_
											and character_:FindFirstChild(
												"HumanoidRootPart"
											)

										if character_ then
											local v22, v23

											if flag4 then
												local v24, v25, v26
												v24, v25, v22, v26, v23 =
													fn18(character_)
											else
												local v24, v25, v26, v27
												v24, v25, v26, v27, v23 =
													fn18(character_)
												v22 = fn11(character_)
													or v25
													or v27
											end

											if v22 then
												str4 = v22.Name
												str5 = fn8(v22.Generation)
												generation = v22.Generation
												local n27 = math.max(
													tonumber(n3) or 20,
													1
												)
												n26 = 1
													- math.clamp(
														v22.Distance / n27,
														0,
														1
													)

												if visible then
													str4 = string.format(
														"%s   %.0f/%d",
														v22.Name,
														v22.Distance,
														n27
													)
												end

												local n28 = 10

												pcall(function()
													n28 =
														v22.Prompt.MaxActivationDistance
												end)

												flag11 = v22.Distance <= n28
											else
												str4 = v23 == 0
														and "no steal prompts"
													or ""
												n26 = 0
												flag11 = false
												str5 = ""
												generation = nil
											end
										else
											n26 = 0
											flag11 = false
											str4 = ""
											str5 = ""
											generation = nil
										end
									end

									local str6 = tostring(str4)
										.. "\0"
										.. tostring(str5)

									if str6 ~= v20 then
										v20 = str6
										fn25(str4, str5, generation)
									end
								end

								if
									flag8
									and localPlayer:GetAttribute("Stealing")
										== true
								then
									flag8 = false
								end

								local n27 = 0

								if flag8 then
									n27 = math.clamp((now - n8) / n9, 0, 1)
								end

								local n28 = math.min(deltaTime or 0.016, 0.1)
								n10 += (n27 - n10) * (1 - math.exp(-n28 * n23))

								if n27 <= 0 and n10 < 0.002 then
									n10 = 0
								end

								frame2.Size = UDim2.new(n10, 0, 1, 0)

								if visible then
									n11 += (n26 - n11) * (1 - math.exp(
										-n28 * n24
									))
									frame3.Size = UDim2.new(n11, 0, 1, 0)

									if flag11 ~= v21 then
										v21 = flag11
										frame3.BackgroundTransparency = flag11
												and 0.35
											or 0.62
									end
								end
							end)
						)
					)
				)
			end

			local function fn30()
				if not flag2 then
					return
				end
				flag2 = false
				flag3 = false
				flag7 = false
				n5 += 1
				fn20()
				fn6()
				fn22()
				fn29()
				fn28()

				if screenGui2 then
					pcall(function()
						screenGui2:Destroy()
					end)
				end

				if screenGui then
					pcall(function()
						screenGui:Destroy()
					end)
				end
			end

			runtime.Track(bindableEvent.Event:Connect(runtime.Cleanup(fn30)))
			runtime.Track(folder.Destroying:Connect(runtime.Guard(fn30)))

			do
				local flag11 = true
				local flag12 = false
				local n22 = 0
				local connection2 = nil
				local chilliDropBrainrotRuntime = CoreGui:FindFirstChild(
					"__Nullx11BrainrotDropBrainrotRuntime"
				)

				if chilliDropBrainrotRuntime then
					local cleanup =
						chilliDropBrainrotRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliDropBrainrotRuntime:Destroy()
					end)
				end

				local folder2 = Instance.new("Folder")
				folder2.Name = "__Nullx11BrainrotDropBrainrotRuntime"
				folder2.Archivable = false
				folder2.Parent = CoreGui
				local bindableEvent2 = Instance.new("BindableEvent")
				bindableEvent2.Name = "Cleanup"
				bindableEvent2.Parent = folder2

				local function fn31(arg)
					localPlayer:SetAttribute(
						"ChilliDropBrainrotActive",
						arg == true
					)
				end

				local function fn32(arg, arg2)
					return flag11
						and arg == n22
						and localPlayer.Character == arg2
				end

				local function fn33()
					if
						flag12
						or localPlayer:GetAttribute("Stealing") ~= true
					then
						return
					end
					local character_ = localPlayer.Character
					local humanoid = character_
						and character_:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = character_
						and character_:FindFirstChild("HumanoidRootPart")
					if not humanoid or not humanoidRootPart then
						return
					end
					n22 += 1
					local v20 = n22
					flag12 = true
					fn31(true)

					task.spawn(function()
						local cFrame = humanoidRootPart.CFrame
						local assemblyLinearVelocity =
							humanoidRootPart.AssemblyLinearVelocity
						local health = humanoid.Health
						local breakJointsOnDeath = humanoid.BreakJointsOnDeath
						local requiresNeck = humanoid.RequiresNeck
						local flag13 = true

						pcall(function()
							flag13 = humanoid:GetStateEnabled(
								Enum.HumanoidStateType.Dead
							)
							humanoid.BreakJointsOnDeath = false
							humanoid.RequiresNeck = false
							humanoid:SetStateEnabled(
								Enum.HumanoidStateType.Dead,
								false
							)
						end)

						local connection3 = runtime.Track(
							humanoid.HealthChanged:Connect(
								runtime.Guard(function(health2)
									if
										fn32(v20, character_)
										and health2 <= 0
									then
										pcall(function()
											humanoid.Health = math.max(
												humanoid.MaxHealth,
												health,
												1
											)
										end)
									end
								end)
							)
						)

						pcall(function()
							local now = os.clock()

							while
								fn32(v20, character_)
								and humanoidRootPart.Parent
								and humanoid.Parent
								and os.clock() - now < 0.35
							do
								if humanoid.Health <= 0 then
									humanoid.Health =
										math.max(humanoid.MaxHealth, health, 1)
								end

								humanoidRootPart.AssemblyLinearVelocity =
									Vector3.new(0, 1000, 0)
								humanoidRootPart.CFrame = cFrame
								task.wait()
							end

							if
								fn32(v20, character_)
								and humanoidRootPart.Parent
							then
								humanoidRootPart.CFrame = cFrame
								humanoidRootPart.AssemblyLinearVelocity =
									assemblyLinearVelocity
							end

							local now2 = os.clock()

							while
								fn32(v20, character_)
								and humanoid.Parent
								and localPlayer:GetAttribute("Stealing") == true
								and os.clock() - now2 < 1.5
							do
								if humanoid.Health <= 0 then
									humanoid.Health =
										math.max(humanoid.MaxHealth, health, 1)
								end

								task.wait()
							end
						end)

						if connection3 then
							connection3:Disconnect()
						end

						if
							localPlayer.Character == character_
							and humanoid.Parent
						then
							pcall(function()
								humanoid.BreakJointsOnDeath = breakJointsOnDeath
								humanoid.RequiresNeck = requiresNeck
								humanoid:SetStateEnabled(
									Enum.HumanoidStateType.Dead,
									flag13
								)

								if health > 0 and humanoid.Health <= 0 then
									humanoid.Health = health
								end
							end)
						end

						if v20 == n22 then
							flag12 = false

							if flag11 then
								fn31(false)
							end
						end
					end)
				end

				local function fn34()
					if not flag11 then
						return
					end
					flag11 = false
					n22 += 1
					flag12 = false
					fn31(false)

					if connection2 then
						connection2:Disconnect()
						connection2 = nil
					end
				end

				fn31(false)

				connection2 = runtime.Track(
					localPlayer.CharacterAdded:Connect(runtime.Guard(function()
						n22 += 1
						flag12 = false
						fn31(false)
					end))
				)

				runtime.Track(
					bindableEvent2.Event:Connect(runtime.Cleanup(fn34))
				)
				runtime.Track(folder2.Destroying:Connect(runtime.Guard(fn34)))
				v12:CreateButton({
					Name = "Drop Brainrot",
					ButtonText = "Drop",
					Callback = fn33,
				})
			end

			v10 = Helper:CreateSection({ Name = "Helper", Expanded = true })
			v11 = Helper:CreateSection({ Name = "Aimbot", Expanded = true })
			v5 = Helper:CreateSection({
				Name = "Movement & Combat",
				Expanded = true,
			})
			local v20
			v20 =
				Helper:CreateSection({ Name = "Unlock Base", Expanded = true })
			local flag11
			flag11 = false
			local folder2

			do
				local v21 = CoreGui

				pcall(function()
					if type(gethui) == "function" then
						local hui = gethui()

						if typeof(hui) == "Instance" then
							v21 = hui
						end
					end
				end)

				local chilliUnlockBaseRuntime =
					v21:FindFirstChild("__Nullx11BrainrotUnlockBaseRuntime")

				if chilliUnlockBaseRuntime then
					local cleanup =
						chilliUnlockBaseRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliUnlockBaseRuntime:Destroy()
					end)
				end

				folder2 = Instance.new("Folder")
				folder2.Name = "__Nullx11BrainrotUnlockBaseRuntime"
				folder2.Archivable = false
				folder2.Parent = v21
			end

			do
				local bindableEvent2 = Instance.new("BindableEvent")
				bindableEvent2.Name = "Cleanup"
				bindableEvent2.Parent = folder2

				local function fn31()
					local character_ = localPlayer.Character
					if not character_ then
						return nil
					end
					return character_:FindFirstChild("HumanoidRootPart")
						or character_:FindFirstChild("UpperTorso")
				end

				local function fn32()
					return Workspace:FindFirstChild("Plots")
				end

				local function fn33(arg, arg2)
					local n22 = arg.X - arg2.X
					local n23 = arg.Z - arg2.Z
					return math.sqrt(n22 * n22 + n23 * n23)
				end

				local function fn34(arg, arg2)
					local animalPodiums = arg:FindFirstChild("AnimalPodiums")
					local huge = math.huge

					if animalPodiums then
						for _, child in ipairs(animalPodiums:GetChildren()) do
							local base = child:FindFirstChild("Base")
							base = base and base:FindFirstChild("Spawn")

							if base and base:IsA("BasePart") then
								huge = math.min(huge, fn33(arg2, base.Position))
							end
						end
					end

					if huge == math.huge then
						local ok, result = pcall(function()
							return arg:GetPivot()
						end)

						if ok then
							huge = fn33(arg2, result.Position)
						end
					end

					return huge
				end

				local function fn35()
					local v21 = fn31()
					local v22 = fn32()
					if not v21 or not v22 then
						return nil
					end
					local huge = math.huge
					local v23 = nil

					for _, child in ipairs(v22:GetChildren()) do
						local v24 = fn34(child, v21.Position)

						if v24 < huge then
							huge = v24
							v23 = child
						end
					end

					return v23
				end

				local function fn36(arg)
					local v21 = fn32()

					while arg and arg ~= Workspace do
						if arg.Parent == v21 then
							return arg
						end
						arg = arg.Parent
					end

					return nil
				end

				local function fn37(arg)
					arg = arg and arg:FindFirstChild("AnimalPodiums")
					local tbl5 = {}
					if not arg then
						return tbl5
					end

					for _, child in ipairs(arg:GetChildren()) do
						local base = child:FindFirstChild("Base")
						base = base and base:FindFirstChild("Spawn")

						if base and base:IsA("BasePart") then
							local y = base.Position.Y
							local flag12 = false

							for _, v21 in ipairs(tbl5) do
								if math.abs(v21 - y) < 1 then
									flag12 = true
									break
								end
							end

							if not flag12 then
								tbl5[#tbl5 + 1] = y
							end
						end
					end

					table.sort(tbl5)
					return tbl5
				end

				local function fn38(arg, arg2)
					local animalPodiums = arg2
						and arg2:FindFirstChild("AnimalPodiums")

					while arg and arg ~= arg2 do
						if arg.Parent == animalPodiums then
							local base = arg:FindFirstChild("Base")
							base = base and base:FindFirstChild("Spawn")
							if base and base:IsA("BasePart") then
								return base.Position.Y
							end
							return nil
						end

						arg = arg.Parent
					end

					return nil
				end

				local function fn39(arg, arg2)
					local v21 = fn37(arg2)
					local v22 = fn38(arg, arg2)

					if v22 and #v21 > 0 then
						local huge = math.huge
						local n22 = 1

						for i_, v23 in ipairs(v21) do
							local n23 = math.abs(v22 - v23)

							if n23 < huge then
								huge = n23
								n22 = i_
							end
						end

						return math.clamp(n22, 1, 3)
					end

					local v23 = fn31()
					if not v23 or #v21 == 0 then
						return 1
					end
					local y = v21[1]

					local ok, result = pcall(function()
						return arg2:GetPivot()
					end)

					if ok then
						y = result.Position.Y
					end

					local n22 = v21[1] - y
					local n23 = 1

					for i_ = 2, math.min(#v21, 3) do
						if v21[i_] - n22 <= v23.Position.Y then
							n23 = i_
						end
					end

					return n23
				end

				local function fn40(arg)
					arg = arg and arg:FindFirstChild("Unlock")
					local tbl5 = {}
					if not arg then
						return tbl5
					end

					for _, child in ipairs(arg:GetChildren()) do
						local position

						if child:IsA("Model") then
							local ok, result = pcall(function()
								return child:GetPivot()
							end)

							position = nil

							if ok then
								position = result.Position
							end
						else
							position = nil

							if child:IsA("BasePart") then
								position = child.Position
							end
						end

						if position then
							tbl5[#tbl5 + 1] =
								{ Instance = child, Y = position.Y }
						end
					end

					table.sort(tbl5, function(arg2, arg3)
						return arg2.Y < arg3.Y
					end)

					return tbl5
				end

				local function fn41(arg, arg2)
					local v21 = fireproximityprompt
					if type(v21) ~= "function" then
						return false
					end
					local v22 = fn40(arg)[arg2]
					if not v22 then
						return false
					end
					local flag12 = false

					for _, descendant in ipairs(v22.Instance:GetDescendants()) do
						if descendant:IsA("ProximityPrompt") then
							flag12 = pcall(v21, descendant) or flag12
						end
					end

					return flag12
				end

				local function fn42(arg)
					local v21 = fn35()

					if v21 then
						fn41(v21, arg)
					end
				end

				local function fn43(arg)
					if not arg or not arg:IsA("ProximityPrompt") then
						return false
					end
					return string.find(
						string.lower(tostring(arg.ActionText or "")),
						"steal",
						1,
						true
					) ~= nil
				end

				local connection2 = runtime.Track(
					ProximityPromptService.PromptButtonHoldBegan:Connect(
						runtime.Guard(function(prompt3, player)
							if
								not flag11
								or player and player ~= localPlayer
								or not fn43(prompt3)
							then
								return
							end
							local v21 = fn36(prompt3) or fn35()
							if not v21 then
								return
							end
							local v22 = fn39(prompt3, v21)
							task.defer(fn41, v21, v22)
						end)
					)
				)

				local function fn44(arg)
					arg._quickBarDefault = 4
					return arg
				end

				fn44(v20:CreateToggle({
					Name = "Auto Unlock Base",
					Note = "Unlocks the current floor when you start stealing. Requires Robux.",
					Default = false,
					Pin = true,
					QuickBar = 4,
					Callback = function(arg)
						flag11 = arg == true
					end,
				}))

				fn44(v20:CreateButton({
					Name = "Unlock Floor 3",
					ButtonText = "Unlock",
					Note = "Unlocks Floor 3 of the nearest base. Requires Robux.",
					Pin = true,
					QuickBar = 4,
					Callback = function()
						fn42(3)
					end,
				}))

				fn44(v20:CreateButton({
					Name = "Unlock Floor 2",
					ButtonText = "Unlock",
					Note = "Unlocks Floor 2 of the nearest base. Requires Robux.",
					Pin = true,
					QuickBar = 4,
					Callback = function()
						fn42(2)
					end,
				}))

				fn44(v20:CreateButton({
					Name = "Unlock Floor 1",
					ButtonText = "Unlock",
					Note = "Unlocks Floor 1 of the nearest base. Requires Robux.",
					Pin = true,
					QuickBar = 4,
					Callback = function()
						fn42(1)
					end,
				}))

				local function fn45()
					flag11 = false

					if connection2 then
						connection2:Disconnect()
						connection2 = nil
					end
				end

				runtime.Track(
					bindableEvent2.Event:Connect(runtime.Cleanup(fn45))
				)
				runtime.Track(folder2.Destroying:Connect(runtime.Guard(fn45)))
			end

			local chilliHelperLocalRuntime =
				CoreGui:FindFirstChild("__Nullx11BrainrotHelperLocalRuntime")

			if chilliHelperLocalRuntime then
				local cleanup =
					chilliHelperLocalRuntime:FindFirstChild("Cleanup")

				if cleanup and cleanup:IsA("BindableEvent") then
					pcall(function()
						cleanup:Fire()
					end)
				end

				pcall(function()
					chilliHelperLocalRuntime:Destroy()
				end)
			end

			do
				local folder3 = Instance.new("Folder")
				folder3.Name = "__Nullx11BrainrotHelperLocalRuntime"
				folder3.Archivable = false
				folder3.Parent = CoreGui
				local bindableEvent2 = Instance.new("BindableEvent")
				bindableEvent2.Name = "Cleanup"
				bindableEvent2.Parent = folder3
				flag = true
				local tbl5 = {}

				fn2 = function(arg)
					tbl5[#tbl5 + 1] = arg
				end

				local function fn31()
					if not flag then
						return
					end
					flag = false

					for _, v21 in ipairs(tbl5) do
						pcall(v21)
					end

					table.clear(tbl5)
				end

				runtime.Track(
					bindableEvent2.Event:Connect(runtime.Cleanup(fn31))
				)
				runtime.Track(folder3.Destroying:Connect(runtime.Guard(fn31)))
			end
		end

		tbl2 = { ProtectedHumanoid = nil, RescueSerial = 0 }

		do
			local n = 0.5
			local v12 = nil
			local tbl3 = nil
			local tbl4 = {}
			local flag2 = false
			local n2 = 0

			local function fn4()
				for _, v13 in ipairs(tbl4) do
					if v13.Connected then
						v13:Disconnect()
					end
				end

				table.clear(tbl4)
			end

			local function fn5()
				fn4()
				local v13 = v12
				local v14 = tbl3
				v12 = nil
				tbl3 = nil
				tbl2.ProtectedHumanoid = nil
				if not v13 or not v13.Parent or not v14 then
					return
				end

				pcall(function()
					v13.BreakJointsOnDeath = v14.BreakJointsOnDeath
					v13.RequiresNeck = v14.RequiresNeck
					v13:SetStateEnabled(
						Enum.HumanoidStateType.Dead,
						v14.DeadStateEnabled
					)
				end)
			end

			local function fn6(arg)
				if not arg or not arg.Parent then
					return false
				end

				return pcall(function()
					arg.BreakJointsOnDeath = false
					arg.RequiresNeck = false
					arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				end) and arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(
					Enum.HumanoidStateType.Dead
				) == false
			end

			local function fn7(arg)
				if arg ~= v12 or not arg or not arg.Parent or flag2 then
					return false
				end
				local maxHealth = arg.MaxHealth
				if maxHealth <= 0 then
					return false
				end

				if maxHealth == math.huge or arg.Health >= maxHealth then
					return true
				end
				local flag3 = arg.Health <= 0
				flag2 = true

				local ok = pcall(function()
					arg.Health = maxHealth
				end)

				flag2 = false

				if ok and flag3 and arg.Health > 0 then
					tbl2.RescueSerial = tbl2.RescueSerial + 1
				end

				return ok and arg.Health >= maxHealth
			end

			local function fn8(arg)
				fn5()
				if not flag or not arg or arg ~= localPlayer.Character then
					return false
				end
				local humanoid = arg:FindFirstChildOfClass("Humanoid")
					or arg:WaitForChild("Humanoid", 5)
				if
					not flag
					or arg ~= localPlayer.Character
					or not humanoid
					or not humanoid:IsA("Humanoid")
				then
					return false
				end
				v12 = humanoid
				tbl2.ProtectedHumanoid = humanoid

				tbl3 = {
					BreakJointsOnDeath = humanoid.BreakJointsOnDeath,
					RequiresNeck = humanoid.RequiresNeck,
					DeadStateEnabled = humanoid:GetStateEnabled(
						Enum.HumanoidStateType.Dead
					),
				}

				if not fn6(humanoid) or not fn7(humanoid) then
					fn5()
					return false
				end

				tbl4[#tbl4 + 1] = runtime.Track(
					humanoid.HealthChanged:Connect(runtime.Guard(function()
						fn7(humanoid)
					end))
				)

				tbl4[#tbl4 + 1] = runtime.Track(
					humanoid
						:GetPropertyChangedSignal("MaxHealth")
						:Connect(runtime.Guard(function()
							fn7(humanoid)
						end))
				)

				tbl4[#tbl4 + 1] = runtime.Track(
					humanoid.StateChanged:Connect(
						runtime.Guard(function(old, new)
							if new == Enum.HumanoidStateType.Dead then
								fn6(humanoid)
								fn7(humanoid)
							end
						end)
					)
				)

				n2 = os.clock()
				return true
			end

			local connection = runtime.Track(
				localPlayer.CharacterAdded:Connect(
					runtime.Guard(function(character_)
						fn8(character_)
					end)
				)
			)

			local connection2 = runtime.Track(
				RunService.Heartbeat:Connect(runtime.Guard(function()
					local now = os.clock()

					if v12 and now - n2 >= n then
						n2 = now
						fn6(v12)
						fn7(v12)
					end
				end))
			)

			task.spawn(function()
				fn8(localPlayer.Character)
			end)

			fn2(function()
				fn5()

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end
			end)
		end

		local fn4, fn5
		local n = 2

		fn4 = function(arg)
			local character_ = localPlayer.Character
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")
			return character_ and character_:FindFirstChild(arg)
				or backpack and backpack:FindFirstChild(arg)
		end

		fn5 = function(arg)
			local v12 = fn4(arg)
			if v12 then
				return v12
			end
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
			playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
			playerGui = playerGui and playerGui:FindFirstChild("Content")
			playerGui = playerGui and playerGui:FindFirstChild("Items")
			playerGui = playerGui and playerGui:FindFirstChild(arg)
			local locked = playerGui and playerGui:FindFirstChild("Locked")
			playerGui = playerGui and playerGui:FindFirstChild("Buy")
			if locked and locked.Visible then
				return nil, "rebirth"
			end

			if not playerGui then
				return nil, "unavailable"
			end
			local ok, result = pcall(getconnections, playerGui.Activated)
			if not ok or type(result) ~= "table" then
				return nil, "unavailable"
			end
			local flag2 = false

			for _, v13 in ipairs(result) do
				if v13.Enabled and type(v13.Fire) == "function" then
					if pcall(function()
						v13:Fire()
					end) then
						flag2 = true
						break
					end
				end
			end

			if not flag2 then
				return nil, "unavailable"
			end
			local now = os.clock()

			while true do
				local v13 = fn4(arg)

				if v13 then
					return v13
				else
					RunService.Heartbeat:Wait()
					if not (n <= os.clock() - now) then
						continue
					end
					break
				end
			end

			return fn4(arg), "cash"
		end

		local fn6

		fn6 = function(arg, arg2)
			local str

			if arg2 == "rebirth" then
				str = "A higher Rebirth level is required for " .. arg .. "."
			elseif arg2 == "cash" then
				str = "Not enough cash to buy " .. arg .. "."
			else
				str = "Unable to buy " .. arg .. " right now."
			end

			v.Notify("Tool unavailable", str, 5)
		end

		local fn7
		local n2 = 0

		fn3 = function(arg)
			n2 = math.max(n2, os.clock() + (tonumber(arg) or 1))
		end

		fn7 = function()
			return os.clock() < n2
		end

		do
			local n3 = 0.02
			local n4 = 5
			local n5 = 7
			local n6 = 5
			local n7 = 12
			local n8 = 4
			local n9 = 2
			local flag2 = false
			local flag3 = false
			local n10 = 0
			local connection = nil
			local connection2 = nil
			local connection3 = nil
			local v12 = nil
			local tbl3 = {}
			local n11 = 0
			local n12 = 0
			local v13 = nil
			local fn8 = nil

			local function fn9(arg)
				if not arg then
					return nil
				end
				local character_ = arg.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				character_ = character_
					and character_:FindFirstChild("HumanoidRootPart")
				if humanoid and humanoid.Health > 0 and character_ then
					return character_
				end
				return nil
			end

			local function fn10(arg)
				local v14 = nil
				local v15 = nil

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local v16 = fn9(player)

						if v16 then
							local magnitude = (v16.Position - arg.Position).Magnitude

							if not v14 or magnitude < v14 then
								v14 = magnitude
								v15 = player
							end
						end
					end
				end

				return v15
			end

			local function fn11()
				local character_ = localPlayer.Character
				return character_
						and character_:FindFirstChild("Body Swap Potion")
					or localPlayer.Backpack:FindFirstChild("Body Swap Potion")
			end

			local function fn12(arg, arg2)
				local ok, result = pcall(getconnections, arg.Activated)
				if not ok then
					return
				end

				for _, v14 in ipairs(result) do
					local function_ = nil

					pcall(function()
						function_ = v14.Function
					end)

					if typeof(function_) == "function" then
						local ok2, result2 = pcall(debug.getinfo, function_)
						ok2 = ok2 and result2

						if ok2 then
							ok2 = string.find(
								result2.source or "",
								"BodySwapScript",
								1,
								true
							)
						end

						if ok2 then
							local n13 = tonumber(result2.nups) or 0
							local flag4 = false

							for i_ = 1, n13 do
								local ok3, result3, result4 =
									pcall(debug.getupvalue, function_, i_)
								local flag5 = string.find(
									string.lower(tostring(result3 or "")),
									"target",
									1,
									true
								) ~= nil
								local flag6 = typeof(result4) == "Instance"
									and result4:IsA("Player")
									and result4 ~= localPlayer
								flag5 = flag5
									and (
										result4 == nil
										or typeof(result4) == "Instance"
											and result4:IsA("Player")
									)

								if ok3 and (flag5 or flag6) then
									flag4 = pcall(
										debug.setupvalue,
										function_,
										i_,
										arg2
									) or flag4
								end
							end

							local flag5 = not flag4

							if flag5 then
								flag5 = (tonumber(result2.nups) or 0) >= 2
							end

							if flag5 then
								pcall(debug.setupvalue, function_, 2, arg2)
							end
						end
					end
				end
			end

			local function fn13(arg)
				local tbl4 = {}

				for _, child in ipairs(arg:GetChildren()) do
					if child:IsA("Tool") then
						tbl4[#tbl4 + 1] = child
					end
				end

				return tbl4
			end

			local function fn14(arg)
				if not arg then
					return
				end
				local v14 = arg.PreviousToolStates[1]
				local bodySwapTool = arg.BodySwapTool

				if bodySwapTool and bodySwapTool.Parent then
					pcall(function()
						bodySwapTool:Deactivate()
						bodySwapTool.Enabled = true
						bodySwapTool.Parent = localPlayer.Backpack
					end)
				end

				for _, previousToolState in ipairs(arg.PreviousToolStates) do
					pcall(function()
						if previousToolState.Tool.Parent then
							previousToolState.Tool.Enabled =
								previousToolState.Enabled

							if previousToolState.Tool.Parent == character then
								previousToolState.Tool.Parent =
									localPlayer.Backpack
							end
						end
					end)
				end

				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 then
					return
				end
				local tool = character_:FindFirstChildWhichIsA("Tool")

				if tool == bodySwapTool then
					pcall(function()
						bodySwapTool:Deactivate()
						bodySwapTool.Parent = localPlayer.Backpack
					end)

					tool = nil
				end

				if
					not tool
					and v14
					and v14.Tool.Parent == localPlayer.Backpack
				then
					pcall(function()
						fn3(0.5)
						humanoid:EquipTool(v14.Tool)
					end)
				end
			end

			local function fn15()
				local character_ = localPlayer.Character
				local v14 = fn11()
				if not v14 or not v14.Parent then
					return
				end

				pcall(function()
					v14:Deactivate()
					v14.Enabled = true

					if v14.Parent == character_ then
						v14.Parent = localPlayer.Backpack
					end
				end)
			end

			local function fn16(arg)
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local bodySwapPotion

				if character_ then
					bodySwapPotion = fn11() or fn5("Body Swap Potion")
				else
					bodySwapPotion = character_
				end

				if not character_ or not humanoid or not bodySwapPotion then
					return nil
				end
				fn3(2)
				local tbl4 = {}

				for _, v14 in ipairs(fn13(character_)) do
					if v14 ~= bodySwapPotion then
						tbl4[#tbl4 + 1] = { Tool = v14, Enabled = v14.Enabled }

						pcall(function()
							v14:Deactivate()
							v14.Enabled = false
							v14.Parent = localPlayer.Backpack
						end)
					end
				end

				humanoid:UnequipTools()
				fn3(2)
				local n13 = os.clock() + 0.45

				while true do
					pcall(function()
						humanoid:EquipTool(bodySwapPotion)
					end)

					if bodySwapPotion.Parent == character_ then
						break
					else
						task.wait(0.03)
						if not (n13 <= os.clock()) then
							continue
						end
						break
					end
				end

				for _, v14 in ipairs(fn13(character_)) do
					if v14 ~= bodySwapPotion then
						pcall(function()
							v14:Deactivate()
							v14.Parent = localPlayer.Backpack
						end)
					end
				end

				fn12(bodySwapPotion, arg)

				return {
					Character = character_,
					Humanoid = humanoid,
					BodySwapTool = bodySwapPotion,
					PreviousToolStates = tbl4,
					StartedAt = os.clock(),
				}
			end

			local function fn17(arg, arg2, arg3)
				if flag3 then
					return
				end
				flag3 = true
				local v14 = n10

				task.spawn(function()
					local v15 = nil

					local ok = pcall(function()
						local n13 = arg3 and n7 + 3 or 12
						local n14 = os.clock() + n13
						local v16 = arg2

						while true do
							if flag2 and n10 == v14 and os.clock() < n14 then
								local v17 = fn9(localPlayer)

								if not v17 then
									task.wait(0.08)
									continue
								elseif
									not ((v17.Position - arg).Magnitude <= n6)
								then
									local flag4 = v15

									if v15 then
										local startedAt = v15.StartedAt
										flag4 = os.clock() - startedAt >= n8
									end

									if not flag4 then
										if not v16 or not fn9(v16) then
											v16 = fn10(v17)
										end

										if not v16 then
											task.wait(0.08)
											continue
										else
											local character_, humanoid, bodySwapTool, tool

											if
												not v15
												or localPlayer.Character ~= v15.Character
												or not v15.BodySwapTool.Parent
											then
												fn14(v15)
												v13 = nil
												v15 = fn16(v16)
												v13 = v15

												if not v15 then
													task.wait(0.12)
													continue
												else
													character_ = v15.Character
													humanoid = v15.Humanoid
													bodySwapTool =
														v15.BodySwapTool
													tool =
														character_:FindFirstChildWhichIsA(
															"Tool"
														)
													tool = tool
														and tool
															~= bodySwapTool

													if not tool then
														if
															bodySwapTool.Parent
															~= character_
														then
															pcall(function()
																fn3(1)
																humanoid:EquipTool(
																	bodySwapTool
																)
															end)
														end

														if
															bodySwapTool.Parent
															== character_
														then
															fn12(
																bodySwapTool,
																v16
															)

															if
																bodySwapTool.Enabled
																~= false
															then
																pcall(function()
																	bodySwapTool:Deactivate()
																	bodySwapTool:Activate()
																end)
															end
														end

														task.wait(0.08)
														continue
													end
												end
											else
												character_ = v15.Character
												humanoid = v15.Humanoid
												bodySwapTool = v15.BodySwapTool
												tool =
													character_:FindFirstChildWhichIsA(
														"Tool"
													)
												tool = tool
													and tool ~= bodySwapTool

												if not tool then
													if
														bodySwapTool.Parent
														~= character_
													then
														pcall(function()
															fn3(1)
															humanoid:EquipTool(
																bodySwapTool
															)
														end)
													end

													if
														bodySwapTool.Parent
														== character_
													then
														fn12(bodySwapTool, v16)

														if
															bodySwapTool.Enabled
															~= false
														then
															pcall(function()
																bodySwapTool:Deactivate()
																bodySwapTool:Activate()
															end)
														end
													end

													task.wait(0.08)
													continue
												end
											end
										end
									end
								end
							end

							break
						end
					end)

					fn14(v15)

					if v13 == v15 then
						v13 = nil
					end

					fn15()
					task.wait(0.2)

					if n10 == v14 then
						flag3 = false

						if fn8 then
							fn8()
						end

						if not ok then
							fn15()
						end
					end
				end)
			end

			fn8 = function()
				v12 = nil
				table.clear(tbl3)
				n11 = 0
			end

			local function fn18(deltaTime)
				if localPlayer:GetAttribute("Stealing") == true then
					n12 = os.clock() + n9
				end

				n11 += deltaTime
				if n11 < n3 then
					return
				end
				n11 = 0
				local v14 = fn9(localPlayer)
				if not v14 then
					fn8()
					return
				end
				local position = v14.Position

				if v12 and not flag3 then
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= localPlayer then
							local v15 = fn9(player)
							local v16 = tbl3[player]

							if v15 and v16 then
								local position2 = v15.Position
								if
									(position - v12).Magnitude >= n4
									and (position2 - v16).Magnitude >= n4
									and (position - v16).Magnitude <= n5
									and (position2 - v12).Magnitude <= n5
								then
									fn17(
										v12,
										player,
										localPlayer:GetAttribute("Stealing")
												== true
											or os.clock() <= n12
									)
									break
								end
							end
						end
					end
				end

				v12 = position

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local v15 = fn9(player)
						tbl3[player] = v15 and v15.Position or nil
					end
				end
			end

			local function fn19()
				local v14 = flag3
				local flag4

				if flag3 then
					flag4 = v14
				else
					flag4 = v13 ~= nil
				end

				local v15 = v13
				v13 = nil
				flag2 = false
				flag3 = false
				n10 += 1
				fn14(v15)

				if flag4 then
					fn15()
				end

				fn8()

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end
			end

			local function fn20()
				fn19()
				flag2 = true
				fn8()
				local bodySwapPotion, v14 = fn5("Body Swap Potion")

				if not bodySwapPotion then
					fn6("Body Swap Potion", v14)
				end

				connection2 = runtime.Track(
					localPlayer.CharacterAdded:Connect(runtime.Guard(function()
						n10 += 1
						local v15 = v13
						v13 = nil
						fn14(v15)
						flag3 = false
						fn8()
						task.defer(fn15)
					end))
				)

				connection3 = runtime.Track(
					localPlayer
						:GetAttributeChangedSignal("Stealing")
						:Connect(runtime.Guard(function()
							if localPlayer:GetAttribute("Stealing") == true then
								n12 = os.clock() + n9
							end
						end))
				)

				if localPlayer:GetAttribute("Stealing") == true then
					n12 = os.clock() + n9
				end

				connection = runtime.Track(
					RunService.Heartbeat:Connect(runtime.Guard(fn18))
				)
				return true
			end

			fn2(fn19)

			v10:CreateToggle({
				Name = "Anti Body Swap",
				Default = false,
				Callback = function(arg)
					if arg then
						fn20()
					else
						fn19()
					end
				end,
			})
		end

		do
			local flag2 = false
			local tbl3 = {}
			local tbl4 = {}
			local tbl5 = {}
			local obj2 = setmetatable({}, { __mode = "k" })
			local obj3 = setmetatable({}, { __mode = "k" })
			local obj4 = setmetatable({}, { __mode = "k" })
			local obj5 = setmetatable({}, { __mode = "k" })
			local obj6 = setmetatable({}, { __mode = "k" })
			local v12 = nil
			local moveFunction = nil
			local move = nil
			local moveFunction2 = nil
			local n3 = 0
			local n4 = 0
			local currentCamera = nil
			local humanoid = nil
			local flag3 = false
			local fieldOfView = 70
			local vector = Vector3.zero
			local tbl6 = {
				Blue = true,
				DiscoEffect = true,
				BeeBlur = true,
				ColorCorrection = true,
			}
			local fn8 = nil
			local fn9 = nil

			local function fn10(arg)
				for _, v13 in ipairs(arg) do
					if typeof(v13) == "RBXScriptConnection" then
						v13:Disconnect()
					end
				end

				table.clear(arg)
			end

			local fn11 = nil

			fn11 = function(arg, arg2, arg3)
				if typeof(arg) ~= "function" or arg2 > 3 or arg3[arg] then
					return false
				end
				arg3[arg] = true
				local ok, result = pcall(debug.getconstants, arg)
				local flag4 = false
				local flag5 = false
				local flag6 = false

				if ok then
					for _, v13 in ipairs(result) do
						if type(v13) == "string" then
							local v14 = string.lower(v13)

							if string.find(v14, "discoeffect", 1, true) then
								flag5 = true
							end

							if string.find(v14, "boogie", 1, true) then
								flag4 = true
							end

							if v14 == "fieldofview" then
								flag6 = true
							end
						end
					end
				end

				if flag5 and (flag4 or flag6) then
					return true
				end
				local ok2, result2 = pcall(debug.getprotos, arg)

				if ok2 then
					for _, v13 in ipairs(result2) do
						if fn11(v13, arg2 + 1, arg3) then
							return true
						end
					end
				end

				return false
			end

			local function fn12(arg)
				local enabled = nil

				return pcall(function()
					enabled = arg.Enabled
				end) and enabled == true
			end

			local function fn13(arg)
				if typeof(arg) ~= "function" then
					return false
				end
				local ok, result = pcall(debug.info, arg, "s")
				return ok
					and type(result) == "string"
					and string.find(
							string.lower(result),
							"paintballguncontroller",
							1,
							true
						)
						~= nil
			end

			local function fn14(arg)
				if not flag2 or not flag then
					return
				end

				if fn12(arg) then
					if pcall(function()
						arg:Disable()
					end) then
						obj5[arg] = true
					end
				end
			end

			local function fn15(arg)
				if
					not flag2
					or not flag
					or not arg
					or not arg.Parent
					or not arg:IsA("RemoteEvent")
				then
					return
				end
				local ok, result = pcall(getconnections, arg.OnClientEvent)

				if ok then
					for _, v13 in ipairs(result) do
						if not obj6[v13] then
							obj6[v13] = true
							local function_ = nil

							pcall(function()
								function_ = v13.Function
							end)

							if fn11(function_, 1, {}) or fn13(function_) then
								obj4[v13] = true
								fn14(v13)
							end
						end
					end
				end
			end

			local function fn16()
				n4 += 1
				local v13 = n4

				task.spawn(function()
					local tbl7 = {
						{ Object = Lighting, Kind = "Lighting" },
						{ Object = ReplicatedStorage, Kind = "Remotes" },
					}
					local playerScripts =
						localPlayer:FindFirstChild("PlayerScripts")

					if playerScripts then
						tbl7[#tbl7 + 1] =
							{ Object = playerScripts, Kind = "Sounds" }
					end

					local n5 = 1

					while flag2 and flag and n4 == v13 and n5 <= #tbl7 do
						local now = os.clock()
						local n6 = 0

						while true do
							local v14 = tbl7[n5]
							n5 += 1
							local object = v14.Object

							if object and object.Parent then
								if v14.Kind == "Lighting" then
									fn8(object)
								elseif v14.Kind == "Sounds" then
									fn9(object)
								elseif
									v14.Kind == "Remotes"
									and object:IsA("RemoteEvent")
								then
									fn15(object)
								end

								local tbl8 = {}

								pcall(function()
									tbl8 = object:GetChildren()
								end)

								for _, v15 in ipairs(tbl8) do
									tbl7[#tbl7 + 1] =
										{ Object = v15, Kind = v14.Kind }
								end
							end

							n6 += 1
							if
								not (
									n5 > #tbl7
									or n6 >= 20
									or os.clock() - now >= 0.0015
								)
							then
								continue
							end
							break
						end

						if n5 <= #tbl7 then
							RunService.Heartbeat:Wait()
						end
					end
				end)
			end

			local function fn17()
				for k in pairs(obj5) do
					pcall(function()
						if not k.Enabled then
							k:Enable()
						end
					end)
				end

				table.clear(obj5)
				table.clear(obj4)
				table.clear(obj6)
			end

			fn8 = function(arg)
				if arg and arg.Parent and tbl6[arg.Name] then
					pcall(function()
						arg:Destroy()
					end)
				end
			end

			local function fn18()
				return localPlayer:GetAttribute("ChilliTpMoving") == true
					or localPlayer:GetAttribute("Teleporting") == true
			end

			fn9 = function(arg)
				if not arg or not arg:IsA("Sound") or arg.Name ~= "Buzzing" then
					return
				end

				if obj3[arg] == nil then
					obj3[arg] = arg.Volume
				end

				local flag4 = false

				local function fn19()
					if flag4 or not flag2 or not arg.Parent then
						return
					end
					flag4 = true

					pcall(function()
						if arg.Playing then
							arg:Stop()
						end

						if arg.Volume ~= 0 then
							arg.Volume = 0
						end
					end)

					flag4 = false
				end

				fn19()
				if obj2[arg] then
					return
				end
				obj2[arg] = true
				tbl4[#tbl4 + 1] = runtime.Track(
					arg:GetPropertyChangedSignal("Volume")
						:Connect(runtime.Guard(fn19))
				)
				tbl4[#tbl4 + 1] = runtime.Track(
					arg:GetPropertyChangedSignal("Playing")
						:Connect(runtime.Guard(fn19))
				)
			end

			local function fn19()
				if flag3 or not flag2 then
					return
				end
				flag3 = true

				pcall(function()
					if
						currentCamera
						and currentCamera.Parent
						and currentCamera.FieldOfView ~= fieldOfView
					then
						currentCamera.FieldOfView = fieldOfView
					end

					if
						humanoid
						and humanoid.Parent
						and humanoid.CameraOffset ~= vector
					then
						humanoid.CameraOffset = vector
					end
				end)

				flag3 = false
			end

			local function fn20()
				fn10(tbl5)
				currentCamera = Workspace.CurrentCamera
				local character_ = localPlayer.Character
				humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				fn19()

				if currentCamera then
					tbl5[#tbl5 + 1] = runtime.Track(
						currentCamera
							:GetPropertyChangedSignal("FieldOfView")
							:Connect(runtime.Guard(fn19))
					)
				end

				if humanoid then
					tbl5[#tbl5 + 1] = runtime.Track(
						humanoid
							:GetPropertyChangedSignal("CameraOffset")
							:Connect(runtime.Guard(fn19))
					)
				end
			end

			local function fn21()
				fn10(tbl5)
				currentCamera = nil
				humanoid = nil
				flag3 = false
			end

			local function fn22()
				if v12 then
					pcall(function()
						v12.moveFunction = move or moveFunction
					end)
				end

				v12 = nil
				moveFunction = nil
				move = nil
				moveFunction2 = nil
			end

			local function fn23()
				if v12 and moveFunction2 then
					if v12.moveFunction ~= moveFunction2 then
						v12.moveFunction = moveFunction2
					end

					return
				end

				pcall(function()
					local playerScripts =
						localPlayer:FindFirstChild("PlayerScripts")
					playerScripts = playerScripts
						and playerScripts:FindFirstChild("PlayerModule")
					if not playerScripts then
						return
					end
					local controls = require(playerScripts):GetControls()
					if not controls then
						return
					end
					v12 = controls
					moveFunction = controls.moveFunction
					move = localPlayer.Move

					moveFunction2 = function(arg, arg2, arg3)
						return localPlayer:Move(arg2, arg3)
					end

					v12.moveFunction = moveFunction2
				end)
			end

			local function fn24()
				fn10(tbl4)

				for k, v13 in pairs(obj3) do
					if k and k.Parent then
						pcall(function()
							k.Volume = v13
						end)
					end
				end

				table.clear(obj2)
				table.clear(obj3)
			end

			local function fn25()
				flag2 = false
				n3 += 1
				n4 += 1
				fn10(tbl3)
				fn17()
				fn21()
				fn22()
				fn24()
			end

			local function fn26()
				fn25()
				flag2 = true
				n3 += 1
				local v13 = n3
				fn23()
				fn20()
				fn16()

				tbl3[#tbl3 + 1] = runtime.Track(
					Lighting.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 then
								fn8(descendant)
							end
						end)
					)
				)

				tbl3[#tbl3 + 1] = runtime.Track(
					ReplicatedStorage.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 and descendant:IsA("RemoteEvent") then
								task.defer(function()
									fn15(descendant)
								end)

								task.delay(0.5, function()
									fn15(descendant)
								end)
							end
						end)
					)
				)

				local playerScripts =
					localPlayer:FindFirstChild("PlayerScripts")

				if playerScripts then
					tbl3[#tbl3 + 1] = runtime.Track(
						playerScripts.DescendantAdded:Connect(
							runtime.Guard(function(descendant)
								if flag2 then
									fn9(descendant)
								end
							end)
						)
					)
				end

				tbl3[#tbl3 + 1] = runtime.Track(
					Workspace:GetPropertyChangedSignal("CurrentCamera")
						:Connect(runtime.Guard(function()
							if flag2 then
								fn20()
							end
						end))
				)

				tbl3[#tbl3 + 1] = runtime.Track(
					localPlayer.CharacterAdded:Connect(
						runtime.Guard(function(character_)
							task.spawn(function()
								character_:WaitForChild("Humanoid", 5)

								if
									flag2
									and character_ == localPlayer.Character
								then
									fn20()
								end
							end)
						end)
					)
				)

				task.spawn(function()
					while true do
						if flag2 and flag and n3 == v13 then
							task.wait(0.1)

							if not (not flag2 or not flag or n3 ~= v13) then
								if not fn18() then
									fn23()
								end

								continue
							end
						end

						break
					end
				end)
			end

			fn2(fn25)

			v10:CreateToggle({
				Name = "Anti Bee, Disco & Paintball Effect",
				Default = false,
				Callback = function(arg)
					if arg then
						fn26()
					else
						fn25()
					end
				end,
			})
		end

		do
			local n3 = 1.06
			local vector = Vector3.new(2.9, 1.15, 2.9)
			local color = Color3.fromRGB(255, 45, 45)
			local lineThickness = 0.03
			local flag2 = false
			local connection = nil
			local connection2 = nil
			local tbl3 = {}

			local function fn8(arg)
				return arg:IsA("Model") and arg.Name:match("^Trap") ~= nil
			end

			local function fn9(arg, arg2)
				local v12 = arg:FindFirstChild(arg2)
				if v12 and v12:IsA("BasePart") then
					return v12
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if
						descendant.Name == arg2 and descendant:IsA("BasePart")
					then
						return descendant
					end
				end

				return nil
			end

			local function fn10(arg)
				local v12 = tbl3[arg]
				if not v12 then
					return
				end
				tbl3[arg] = nil

				if v12.Connection then
					pcall(function()
						v12.Connection:Disconnect()
					end)
				end

				for _, propertyConnection in ipairs(v12.PropertyConnections) do
					pcall(function()
						propertyConnection:Disconnect()
					end)
				end

				table.clear(v12.PropertyConnections)

				if v12.Outline then
					pcall(function()
						v12.Outline:Destroy()
					end)
				end

				if v12.Target and v12.Target.Parent then
					pcall(function()
						v12.Target.Size = v12.OriginalSize
						v12.Target.CFrame = v12.OriginalCFrame
						v12.Target.CanCollide = v12.OriginalCanCollide
						v12.Target.CanTouch = v12.OriginalCanTouch
					end)
				end
			end

			local function fn11()
				for k in pairs(tbl3) do
					fn10(k)
				end

				table.clear(tbl3)
			end

			local function fn12(arg, arg2)
				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChild("HumanoidRootPart")
				if not character_ then
					return false
				end
				local v12 = arg:PointToObjectSpace(character_.Position)
				local n4 = arg2 * 0.5
				local x = n4.X
				local flag3 = math.abs(v12.X) <= x

				if flag3 then
					local y = n4.Y
					flag3 = math.abs(v12.Y) <= y
				end

				if flag3 then
					local z = n4.Z
					flag3 = math.abs(v12.Z) <= z
				end

				return flag3
			end

			local function fn13(arg)
				if not flag2 or tbl3[arg] then
					return
				end
				local open = fn9(arg, "Open")
				local close = fn9(arg, "Close")
				if not open or not close then
					return
				end
				local boundingBox, v12 = arg:GetBoundingBox()
				local n4 = v12 * n3 + vector
				local n5 = math.max(n4.X, n4.Z)
				local vector2 = Vector3.new(n5, n4.Y, n5)
				if fn12(open.CFrame, vector2) then
					return
				end

				local tbl4 = {
					Target = close,
					OriginalSize = close.Size,
					OriginalCFrame = close.CFrame,
					OriginalCanCollide = close.CanCollide,
					OriginalCanTouch = close.CanTouch,
					PropertyConnections = {},
				}

				tbl3[arg] = tbl4
				local flag3 = false

				local function fn14()
					if
						flag3
						or not flag2
						or not close.Parent
						or not open.Parent
					then
						return
					end
					flag3 = true

					pcall(function()
						close.Size = vector2
						close.CFrame = open.CFrame
						close.CanCollide = true
						close.CanTouch = false
					end)

					flag3 = false
				end

				fn14()
				tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] =
					runtime.Track(
						close
							:GetPropertyChangedSignal("Size")
							:Connect(runtime.Guard(fn14))
					)
				tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] =
					runtime.Track(
						close
							:GetPropertyChangedSignal("CFrame")
							:Connect(runtime.Guard(fn14))
					)
				tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] =
					runtime.Track(
						close
							:GetPropertyChangedSignal("CanCollide")
							:Connect(runtime.Guard(fn14))
					)
				tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] =
					runtime.Track(
						close
							:GetPropertyChangedSignal("CanTouch")
							:Connect(runtime.Guard(fn14))
					)
				tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] =
					runtime.Track(
						open:GetPropertyChangedSignal("CFrame")
							:Connect(runtime.Guard(fn14))
					)
				local selectionBox = Instance.new("SelectionBox")
				selectionBox.Name = fn()
				selectionBox.Adornee = close
				selectionBox.Archivable = false
				selectionBox.Color3 = color
				selectionBox.LineThickness = lineThickness
				selectionBox.SurfaceTransparency = 1
				selectionBox.Transparency = 0
				selectionBox.Parent = close
				tbl4.Outline = selectionBox

				tbl4.Connection = runtime.Track(
					arg.AncestryChanged:Connect(
						runtime.Guard(function(child, parent)
							if not parent then
								fn10(arg)
							end
						end)
					)
				)
			end

			local function fn14()
				for _, child in ipairs(Workspace:GetChildren()) do
					if fn8(child) then
						fn13(child)
					end
				end
			end

			local function fn15()
				flag2 = false

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				fn11()
			end

			local function fn16()
				fn15()
				flag2 = true
				fn14()

				connection2 = runtime.Track(
					Workspace.ChildAdded:Connect(runtime.Guard(function(child)
						if not flag2 or not fn8(child) then
							return
						end

						task.defer(function()
							if flag2 and child.Parent then
								fn13(child)
							end
						end)
					end))
				)

				connection = runtime.Track(
					localPlayer.CharacterAdded:Connect(runtime.Guard(function()
						if flag2 then
							task.defer(fn14)
						end
					end))
				)
			end

			fn2(fn15)

			v10:CreateToggle({
				Name = "Anti Trap",
				Default = false,
				Callback = function(arg)
					if arg then
						fn16()
					else
						fn15()
					end
				end,
			})
		end

		do
			local flag2 = false
			local n3 = 0
			local connection = nil
			local tbl3 = {}
			local tbl4 = {}
			local v12 = nil
			local v13 = nil
			local n4 = 0
			local str = "Sentry_" .. tostring(localPlayer.UserId)

			local function fn8(arg)
				local isModel

				if arg then
					isModel = arg:IsA("Model") or arg:IsA("BasePart")
				else
					isModel = arg
				end

				return isModel
					and arg.Name:match("^Sentry_") ~= nil
					and arg.Name ~= str
			end

			local function fn9(arg)
				if arg:IsA("BasePart") then
					return arg
				end
				return arg:FindFirstChildWhichIsA("BasePart", true)
			end

			local function fn10(arg)
				return arg:FindFirstChild("SetupReady", true) ~= nil
			end

			local function fn11(arg)
				arg = arg and arg:FindFirstChildWhichIsA("Tool")
				if arg and arg.Name:lower():find("bat", 1, true) then
					return arg
				end
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				if not backpack then
					return nil
				end

				for _, child in ipairs(backpack:GetChildren()) do
					if
						child:IsA("Tool")
						and child.Name:lower():find("bat", 1, true)
					then
						return child
					end
				end

				return nil
			end

			local function fn12()
				local v14 = v12
				local v15 = v13
				v12 = nil
				v13 = nil
				if not v14 or not v14.Parent then
					return
				end
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				if
					not character_
					or not humanoid
					or humanoid.Health <= 0
					or v14.Parent ~= character_ and v14.Parent ~= backpack
				then
					return
				end
				local tool = character_:FindFirstChildWhichIsA("Tool")
				if tool == v14 then
					return
				end

				if tool and tool ~= v15 then
					return
				end

				pcall(function()
					fn3(0.5)
					humanoid:EquipTool(v14)
				end)
			end

			local function fn13()
				return localPlayer:GetAttribute("Stealing") == true
					or localPlayer:GetAttribute("ChilliTpMoving") == true
					or localPlayer:GetAttribute("Teleporting") == true
			end

			local function fn14(arg)
				if not tbl4[arg] then
					tbl4[arg] = {
						CanCollide = arg.CanCollide,
						Transparency = arg.Transparency,
						Size = arg.Size,
					}
				end

				arg.CanCollide = false
				arg.Transparency = 1
				arg.Size = Vector3.new(10, 10, 10)
			end

			local function fn15()
				for k, v14 in pairs(tbl4) do
					if k and k.Parent then
						pcall(function()
							k.CanCollide = v14.CanCollide
							k.Transparency = v14.Transparency
							k.Size = v14.Size
						end)
					end
				end

				tbl4 = {}
			end

			local function fn16()
				if fn13() then
					return
				end
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character_
					and character_:FindFirstChild("HumanoidRootPart")
				if
					not humanoid
					or humanoid.Health <= 0
					or not humanoidRootPart
				then
					return
				end
				local v14 = nil
				local huge = math.huge
				local v15 = nil

				for k in pairs(tbl3) do
					if not k.Parent then
						tbl3[k] = nil
					elseif fn10(k) then
						local v16 = fn9(k)

						if v16 then
							local magnitude = (
								humanoidRootPart.Position - v16.Position
							).Magnitude

							if magnitude < huge then
								v14 = v16
								huge = magnitude
								v15 = k
							end
						end
					end
				end

				if not v15 or not v15.Parent or not v14 or not v14.Parent then
					return
				end

				pcall(function()
					fn14(v14)
					v14.CFrame = humanoidRootPart.CFrame
				end)

				local v16 = fn11(character_)
				if not v16 then
					return
				end

				if v16.Parent ~= character_ then
					local tool = character_:FindFirstChildWhichIsA("Tool")

					if tool and tool ~= v16 and not v12 then
						v12 = tool
					end

					v13 = v16

					pcall(function()
						fn3(1)
						humanoid:EquipTool(v16)
					end)
				end

				if v16.Parent == character_ then
					n4 = os.clock()

					pcall(function()
						v16:Activate()
					end)
				end
			end

			local function fn17()
				flag2 = false
				n3 += 1
				n4 = 0
				fn12()

				if connection then
					connection:Disconnect()
					connection = nil
				end

				tbl3 = {}
				fn15()
			end

			local function fn18()
				fn17()
				flag2 = true
				n3 += 1
				local v14 = n3

				for _, descendant in ipairs(Workspace:GetDescendants()) do
					if fn8(descendant) then
						tbl3[descendant] = true
					end
				end

				connection = runtime.Track(
					Workspace.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 and fn8(descendant) then
								tbl3[descendant] = true
							end
						end)
					)
				)

				fn16()

				task.spawn(function()
					local v15 = n4

					while flag2 and n3 == v14 and flag do
						if not fn13() then
							local character_ = localPlayer.Character
							local humanoid = character_
								and character_:FindFirstChildOfClass("Humanoid")
							local humanoidRootPart = character_
								and character_:FindFirstChild(
									"HumanoidRootPart"
								)

							if
								humanoid
								and humanoid.Health > 0
								and humanoidRootPart
							then
								local v16 = nil
								local huge = math.huge
								local v17 = nil

								for k in pairs(tbl3) do
									if not k.Parent then
										tbl3[k] = nil
									elseif fn10(k) then
										local v18 = fn9(k)

										if v18 then
											local magnitude = (
												humanoidRootPart.Position
												- v18.Position
											).Magnitude

											if magnitude < huge then
												v16 = v18
												huge = magnitude
												v17 = k
											end
										end
									end
								end

								if
									v17
									and v17.Parent
									and v16
									and v16.Parent
								then
									pcall(function()
										fn14(v16)
										v16.CFrame = humanoidRootPart.CFrame
									end)

									local now = os.clock()

									if now - v15 >= 0.01 then
										local v18 = fn11(character_)

										if v18 then
											if v18.Parent ~= character_ then
												local tool =
													character_:FindFirstChildWhichIsA(
														"Tool"
													)

												if
													tool
													and tool ~= v18
													and not v12
												then
													v12 = tool
												end

												v13 = v18

												pcall(function()
													fn3(1)
													humanoid:EquipTool(v18)
												end)
											end

											if v18.Parent == character_ then
												pcall(function()
													v18:Activate()
												end)
											end
										end

										v15 = now
									end
								else
									fn12()
								end
							end
						else
							fn12()
						end

						task.wait()
					end
				end)
			end

			fn2(fn17)

			v10:CreateToggle({
				Name = "Auto Destroy Turrets",
				Default = false,
				Callback = function(arg)
					if arg then
						fn18()
					else
						fn17()
					end
				end,
			})
		end

		do
			local n3 = 0.6
			local n4 = 2
			local n5 = 0.2
			local n6 = 0.6
			local n7 = 1.5
			local flag2 = false

			local function fn8()
				local character_ = localPlayer.Character
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				return character_
						and character_:FindFirstChild("Quantum Cloner")
					or backpack
						and backpack:FindFirstChild("Quantum Cloner")
			end

			local function fn9(arg)
				local character_ = localPlayer.Character
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				if
					not character_
					or not backpack
					or not humanoid
					or humanoid.Health <= 0
				then
					return false
				end
				fn3(5)

				for _, child in ipairs(character_:GetChildren()) do
					if child:IsA("Tool") and child ~= arg then
						pcall(function()
							child:Deactivate()
						end)

						child.Parent = backpack
					end
				end

				if arg.Parent ~= character_ then
					humanoid:EquipTool(arg)
				end

				local now = os.clock()

				while arg.Parent ~= character_ and os.clock() - now < 0.5 do
					RunService.Heartbeat:Wait()
				end

				return arg.Parent == character_
			end

			local function fn10(arg, arg2)
				if not arg or not arg.Parent then
					return
				end
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				if
					not character_
					or not humanoid
					or humanoid.Health <= 0
					or arg.Parent ~= character_ and arg.Parent ~= backpack
				then
					return
				end
				local tool = character_:FindFirstChildWhichIsA("Tool")
				if tool == arg then
					return
				end

				if tool and tool ~= arg2 then
					return
				end

				pcall(function()
					fn3(0.5)
					humanoid:EquipTool(arg)
				end)
			end

			local function fn11(arg, arg2, arg3)
				local magnitude = (arg2 - arg3).Magnitude
				local now = os.clock()

				repeat
					local n8 = os.clock() - now
					local character_ = localPlayer.Character
					character_ = character_
						and character_:FindFirstChild("HumanoidRootPart")
					local humanoidRootPart = arg
						and arg.Parent
						and arg:FindFirstChild("HumanoidRootPart")
					if
						n8 >= n5
						and character_
						and (character_.Position - arg3).Magnitude <= n7
						and (
							not arg
							or not arg.Parent
							or humanoidRootPart
								and (humanoidRootPart.Position - arg2).Magnitude <= n7
						)
					then
						return true
					end

					if magnitude <= n7 and n8 >= n6 then
						return true
					end
					RunService.Heartbeat:Wait()
				until os.clock() - now >= n4

				return false
			end

			local function fn12()
				local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
				local toolsFrames = playerGui
					and playerGui:FindFirstChild("ToolsFrames")
				toolsFrames = toolsFrames
					and toolsFrames:FindFirstChild("QuantumCloner")
				local teleportToClone = toolsFrames
					and toolsFrames:FindFirstChild("TeleportToClone")
				if not teleportToClone then
					return nil
				end

				local ok, result = pcall(function()
					return getconnections(teleportToClone.MouseButton1Up)
				end)

				if not ok or type(result) ~= "table" then
					return nil
				end

				for _, v12 in ipairs(result) do
					local function_ = v12.Function
					function_ = function_ and debug.getinfo(function_) or nil
					function_ = function_ and function_.source or ""
					if
						v12.Enabled
						and type(v12.Fire) == "function"
						and string.find(
							function_,
							"QuantumClonerScript",
							1,
							true
						)
					then
						return v12
					end
				end
			end

			v10:CreateButton({
				Name = "Instant Clone Swap",
				ButtonText = "Swap",
				Callback = function()
					if flag2 then
						return false
					end
					flag2 = true
					local character_ = localPlayer.Character
					character_ = character_
						and character_:FindFirstChildWhichIsA("Tool")
					local quantumCloner = fn8()

					if not quantumCloner then
						local v12
						quantumCloner, v12 = fn5("Quantum Cloner")

						if not quantumCloner then
							fn6("Quantum Cloner", v12)
							flag2 = false
							return false
						end
					end

					if character_ == quantumCloner then
						character_ = nil
					end

					if
						not quantumCloner
						or not quantumCloner:IsA("Tool")
						or not fn9(quantumCloner)
					then
						fn10(character_, quantumCloner)
						flag2 = false
						return false
					end

					local v12 = fn12()

					if not v12 then
						fn10(character_, quantumCloner)
						flag2 = false
						return false
					end

					local str = tostring(localPlayer.UserId) .. "_Clone"
					local v13 = Workspace:FindFirstChild(str)
					local v14 = nil
					local now = os.clock()

					local connection = runtime.Track(
						Workspace.ChildAdded:Connect(
							runtime.Guard(function(child)
								if child.Name == str and child ~= v13 then
									v14 = child
								end
							end)
						)
					)

					local ok

					while true do
						if not v14 then
							pcall(function()
								quantumCloner:Activate()
							end)

							local v15 = Workspace:FindFirstChild(str)

							if v15 and v15 ~= v13 then
								v14 = v15
							end
						end

						local humanoidRootPart = v14
							and v14:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart then
							local humanoidRootPart2 = localPlayer.Character
								and localPlayer.Character:FindFirstChild(
									"HumanoidRootPart"
								)
							humanoidRootPart2 = humanoidRootPart2
								and humanoidRootPart2.Position
							local position = humanoidRootPart.Position

							ok = pcall(function()
								v12:Fire()
							end)

							if ok and humanoidRootPart2 then
								fn11(v14, humanoidRootPart2, position)
							end

							break
						else
							RunService.Heartbeat:Wait()
							ok = false
							if not (os.clock() - now >= n3) then
								continue
							end
						end

						break
					end

					connection:Disconnect()
					fn10(character_, quantumCloner)
					flag2 = false
					return ok
				end,
			})
		end

		do
			local n3 = 0.05
			local n4 = 0.05
			local n5 = 200

			local tbl3 = {
				["Web Slinger"] = true,
				["Taser Gun"] = true,
				["Laser Cape"] = true,
				["Paintball Gun"] = true,
			}

			local PlayerMouse = require(
				ReplicatedStorage:WaitForChild("Packages", 8)
					:WaitForChild("PlayerMouse", 8)
			)
			local flag2 = false
			local flag3 = false
			local n6 = 0
			local flag4 = false
			local n7 = 0
			local flag5 = false
			local hit = nil
			local target = nil
			local v12 = nil
			local n8 = 0
			local n9 = 0
			local n10 = 0
			local obj2 = setmetatable({}, { __mode = "k" })
			local connection = nil

			local function fn8()
				if flag5 then
					return
				end
				flag5 = true
				hit = PlayerMouse.Hit
				target = PlayerMouse.Target
			end

			local function fn9(arg)
				local character_ = arg.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")

				if character_ then
					character_ = character_:FindFirstChild("HumanoidRootPart")
						or character_:FindFirstChild("UpperTorso")
						or character_:FindFirstChild("Torso")
				end

				if humanoid and humanoid.Health > 0 and character_ then
					return humanoid, character_
				end
			end

			local function fn10()
				local character_ = localPlayer.Character
				if not character_ then
					return nil
				end

				for k in pairs(tbl3) do
					local v13 = character_:FindFirstChild(k)
					if v13 and v13:IsA("Tool") then
						return v13
					end
				end
			end

			local function fn11()
				local v13, v14 = fn9(localPlayer)
				if not v14 then
					return nil
				end
				local v15 = nil
				local v16 = nil

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local v17, v18 = fn9(player)

						if v18 then
							local magnitude = (v18.Position - v14.Position).Magnitude

							if not v15 or magnitude < v15 then
								v15 = magnitude
								v16 = v18
							end
						end
					end
				end

				return v16
			end

			local function fn12(arg)
				local now = os.clock()

				if arg or not v12 or not v12.Parent or now - n8 >= n3 then
					n8 = now
					v12 = fn11()
				end

				return v12
			end

			local function fn13(arg)
				local muzzle = obj2[arg]

				if not muzzle or not muzzle.Parent then
					muzzle = arg:FindFirstChild("Muzzle", true)
						or arg:FindFirstChild("FirePoint", true)
						or arg:FindFirstChild("Handle")
					obj2[arg] = muzzle
				end

				if muzzle then
					if muzzle:IsA("Attachment") then
						return muzzle.WorldPosition
					end

					if muzzle:IsA("BasePart") then
						return muzzle.Position
					end
				end

				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChild("HumanoidRootPart")
				return character_ and character_.Position
			end

			local function fn14()
				local now = os.clock()
				if now < n10 then
					return n9
				end
				n10 = now + 0.5

				local ok, result = pcall(function()
					return localPlayer:GetNetworkPing()
				end)

				if ok and type(result) == "number" then
					n9 = math.clamp(result, 0, 0.35)
				end

				return n9
			end

			local function fn15(arg, arg2)
				local n11 = n5 * n5
				local n12 = arg2:Dot(arg2) - n11
				local n13 = 2 * arg:Dot(arg2)
				local v13 = arg:Dot(arg)
				local n14

				if math.abs(n12) < 0.0001 then
					n14 = nil

					if math.abs(n13) > 0.0001 then
						n14 = -v13 / n13
						local v14 = nil

						if not (n14 > 0) then
							n14 = v14
						end
					end
				else
					local n15 = n13 * n13 - 4 * n12 * v13
					n14 = nil

					if n15 >= 0 then
						local v14 = math.sqrt(n15)
						local n16 = (-n13 - v14) / 2 * n12
						local n17 = (-n13 + v14) / 2 * n12

						if n16 > 0 and n17 > 0 then
							n14 = math.min(n16, n17)
						elseif n16 > 0 then
							n14 = n16
						else
							n14 = nil

							if n17 > 0 then
								n14 = n17
							end
						end
					end
				end

				return math.clamp(n14 or arg.Magnitude / n5, 0, 3)
			end

			local function fn16(arg, arg2)
				local v13 = fn13(arg)
				if not v13 then
					return arg2.Position
				end
				local assemblyLinearVelocity = arg2.AssemblyLinearVelocity
				local n11 = arg2.Position + assemblyLinearVelocity * fn14()
				return n11
					+ assemblyLinearVelocity
						* fn15(n11 - v13, assemblyLinearVelocity)
			end

			local function fn17(arg)
				local v13 = fn10()
				if not flag2 and not flag3 and not flag4 or not v13 then
					return false
				end
				local v14 = fn12(arg)
				if not v14 then
					return false
				end
				local n11

				if v13.Name == "Paintball Gun" then
					n11 = fn16(v13, v14)
				else
					n11 = v14.Position + v14.AssemblyLinearVelocity * n4
				end

				PlayerMouse.Hit = CFrame.new(n11)
				PlayerMouse.Target = v14
				return true
			end

			local function fn18()
				if not flag5 then
					return
				end
				flag5 = false
				v12 = nil
				n8 = 0
				PlayerMouse.Hit = hit
				PlayerMouse.Target = target
				hit = nil
				target = nil
			end

			local function fn19()
				flag2 = false
				ContextActionService:UnbindAction("ChilliToolAimbotAction")

				pcall(function()
					RunService:UnbindFromRenderStep(
						"Nullx11BrainrotToolAimbotRender"
					)
				end)

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if not flag3 and not flag4 then
					fn18()
				end
			end

			local function fn20()
				fn19()
				flag2 = true

				ContextActionService:BindActionAtPriority(
					"ChilliToolAimbotAction",
					function(arg, arg2)
						if arg2 == Enum.UserInputState.Begin and fn10() then
							fn17(true)
						end

						return Enum.ContextActionResult.Pass
					end,
					false,
					10000,
					Enum.UserInputType.MouseButton1,
					Enum.UserInputType.Touch
				)

				connection = runtime.Track(
					UserInputService.InputBegan:Connect(
						runtime.Guard(function(input)
							local userInputType = input.UserInputType

							if
								userInputType
									== Enum.UserInputType.MouseButton1
								or userInputType == Enum.UserInputType.Touch
							then
								fn17(true)
							end
						end)
					)
				)

				runtime.BindRender(
					RunService,
					"Nullx11BrainrotToolAimbotRender",
					Enum.RenderPriority.Last.Value + 20,
					function()
						if fn10() then
							fn8()
							fn17(false)
						elseif not flag3 and not flag4 then
							fn18()
						end
					end
				)
			end

			local function fn21()
				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChild("Paintball Gun")
				return character_ and character_:IsA("Tool") and character_
					or nil
			end

			local function fn22()
				flag3 = false
				n6 += 1
				local v13 = fn21()

				if v13 then
					pcall(function()
						v13:Deactivate()
					end)
				end

				if not flag2 and not flag4 then
					fn18()
				end
			end

			local function fn23()
				fn22()
				local paintballGun, v13 = fn5("Paintball Gun")

				if not paintballGun then
					fn6("Paintball Gun", v13)
				end

				flag3 = true
				n6 += 1
				local v14 = n6

				task.spawn(function()
					while flag3 and v14 == n6 and flag do
						local v15 = fn21()

						if v15 then
							fn8()

							if fn17(false) then
								pcall(function()
									v15:Activate()
								end)
							end
						elseif not flag2 and not flag4 then
							fn18()
						end

						task.wait(0.04)
					end
				end)

				return true
			end

			local function fn24()
				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChild("Laser Cape")
				return character_ and character_:IsA("Tool") and character_
					or nil
			end

			local function fn25()
				flag4 = false
				n7 += 1
				local v13 = fn24()

				if v13 then
					pcall(function()
						v13:Deactivate()
					end)
				end

				if not flag2 and not flag3 then
					fn18()
				end
			end

			local function fn26()
				fn25()
				local laserCape, v13 = fn5("Laser Cape")

				if not laserCape then
					fn6("Laser Cape", v13)
				end

				flag4 = true
				n7 += 1
				local v14 = n7

				task.spawn(function()
					while flag4 and v14 == n7 and flag do
						local v15 = fn24()

						if v15 then
							fn8()

							if fn17(false) then
								pcall(function()
									v15:Activate()
								end)
							end
						elseif not flag2 and not flag3 then
							fn18()
						end

						task.wait(0.04)
					end
				end)

				return true
			end

			fn2(function()
				fn25()
				fn22()
				fn19()
			end)

			v11:CreateToggle({
				Name = "Aimbot",
				Default = false,
				Callback = function(arg)
					if arg then
						fn20()
					else
						fn19()
					end
				end,
			})

			v11:CreateToggle({
				Name = "Auto Paintball",
				Note = "Automatically uses the Paintball Gun while equipped.",
				Default = false,
				Callback = function(arg)
					if arg then
						fn23()
					else
						fn22()
					end
				end,
			})

			v11:CreateToggle({
				Name = "Auto Laser Cape",
				Note = "Automatically uses the Laser Cape while equipped.",
				Default = false,
				Callback = function(arg)
					if arg then
						fn26()
					else
						fn25()
					end
				end,
			})
		end

		local v12
		v12 = v9:CreateSection({ Name = "Speed Boost" })
		local v13
		v13 = v9:CreateSection({ Name = "Jump Boost" })
		v6 = v9:CreateSection({ Name = "Character" })
		v7 = v9:CreateSection({ Name = "Invisibility" })
		v8 = v9:CreateSection({ Name = "Respawn", Expanded = false })

		do
			local n3 = 0.0083333333333333332
			local n4 = 4
			local n5 = 0.12
			local n6 = 25
			local n7 = 0.045
			local n8 = 0.03
			local n9 = 0.015
			local n10 = 10
			local n11 = 60
			local flag2 = false
			local connection = nil
			local connection2 = nil
			local connection3 = nil
			local connection4 = nil
			local connection5 = nil
			local flag3 = false
			local humanoid = nil
			local humanoidRootPart = nil
			local flag4 = false
			local flag5 = false
			local n12 = 0
			local n13 = 0
			local n14 = 0
			local n15 = 0
			local n16 = 0
			local n17 = 60
			local n18 = 19.1
			local flag6 = false
			local y = nil

			local function fn8()
				return math.max(n17 / n11, 0.01)
			end

			local function fn9()
				if
					not flag2
					or not humanoidRootPart
					or not humanoidRootPart.Parent
				then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end
				y = y or humanoidRootPart.Position.Y
				if flag6 and humanoidRootPart.Position.Y - y >= n18 then
					return
				end
				local v14 = fn8()
				n13 = n11 * v14
				local n19 = n5 / v14
				n12 = os.clock() + n19
				flag5 = true
				n15 = os.clock()
			end

			local function fn10()
				if
					not humanoid
					or not humanoidRootPart
					or not humanoidRootPart.Parent
				then
					return
				end

				if humanoid.Health <= 0 then
					flag4 = false
					flag5 = false
					return
				end

				local assemblyLinearVelocity =
					humanoidRootPart.AssemblyLinearVelocity
				local flag7 = humanoid.FloorMaterial ~= Enum.Material.Air
				local now = os.clock()
				local v14 = fn8()

				if flag7 then
					y = humanoidRootPart.Position.Y
				end

				local flag8 = flag6
					and (flag4 or flag5)
					and y
					and humanoidRootPart.Position.Y - y >= n18

				if flag4 and not flag8 then
					if
						now - n15 >= n7 / v14
						or flag5 and n12 - now <= n8 / v14
					then
						fn9()
					end
				end

				if flag8 then
					flag5 = false

					if assemblyLinearVelocity.Y > 0 then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
							assemblyLinearVelocity.X,
							0,
							assemblyLinearVelocity.Z
						)
					end
				elseif flag5 then
					if n12 <= now then
						flag5 = false
					else
						local n19 = (
							Workspace.Gravity * v14 * v14 - Workspace.Gravity
						) * n3
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
							assemblyLinearVelocity.X,
							assemblyLinearVelocity.Y
								+ (n13 - assemblyLinearVelocity.Y) * (1 - math.exp(
									-n6 * v14 * n3
								))
								- n19,
							assemblyLinearVelocity.Z
						)
					end
				elseif not flag7 then
					local gravity = Workspace.Gravity

					if assemblyLinearVelocity.Y < 0 then
						gravity += n10
					end

					local n19 = gravity * v14 * v14 - Workspace.Gravity

					if math.abs(n19) > 0.001 then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
							assemblyLinearVelocity.X,
							assemblyLinearVelocity.Y - n19 * n3,
							assemblyLinearVelocity.Z
						)
					end
				end
			end

			local function fn11(deltaTime)
				if not flag2 or not flag then
					return
				end
				n16 += deltaTime
				if n16 < n3 then
					return
				end
				local n19 = math.floor(n16 / n3)

				if n4 < n19 then
					n16 = 0
					n19 = 4
				else
					n16 -= n19 * n3
				end

				for i_ = 1, n19 do
					fn10()
				end
			end

			local function fn12(arg, arg2)
				if not flag2 then
					return Enum.ContextActionResult.Pass
				end

				if arg2 == Enum.UserInputState.Begin then
					local now = os.clock()

					if n9 <= now - n14 then
						n14 = now
						flag4 = true
						y = humanoidRootPart and humanoidRootPart.Position.Y
							or nil
						fn9()
					end
				elseif
					arg2 == Enum.UserInputState.End
					or arg2 == Enum.UserInputState.Cancel
				then
					flag4 = false
				end

				return Enum.ContextActionResult.Pass
			end

			local function fn13()
				if flag3 then
					ContextActionService:UnbindAction("ChilliInfinityJump2")
					flag3 = false
				end
			end

			local function fn14()
				fn13()
				ContextActionService:BindAction(
					"ChilliInfinityJump2",
					fn12,
					false,
					Enum.KeyCode.Space,
					Enum.KeyCode.ButtonA
				)
				flag3 = true
			end

			local function fn15(arg)
				if connection3 then
					connection3:Disconnect()
				end

				if connection4 then
					connection4:Disconnect()
				end

				connection3 = runtime.Track(
					arg.InputBegan:Connect(runtime.Guard(function(input)
						if
							not flag2
							or input.UserInputType
								~= Enum.UserInputType.Touch
						then
							return
						end
						local now = os.clock()

						if now - n14 >= n9 then
							n14 = now
							y = humanoidRootPart and humanoidRootPart.Position.Y
								or nil
							fn9()
						end

						flag4 = true
					end))
				)

				connection4 = runtime.Track(
					arg.InputEnded:Connect(runtime.Guard(function(input)
						if input.UserInputType ~= Enum.UserInputType.Touch then
							return
						end
						flag4 = false
					end))
				)
			end

			local function fn16()
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end
			end

			local function fn17(arg)
				return (arg:IsA("ImageButton") or arg:IsA("TextButton"))
					and arg.Name:lower():find("jump", 1, true) ~= nil
			end

			local function fn18()
				fn16()
				if not UserInputService.TouchEnabled then
					return
				end
				local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
				if not playerGui then
					return
				end
				local touchGui = playerGui:FindFirstChild("TouchGui", true)

				if touchGui then
					for _, descendant in ipairs(touchGui:GetDescendants()) do
						if fn17(descendant) then
							fn15(descendant)
							break
						end
					end
				end

				connection5 = runtime.Track(
					playerGui.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 and fn17(descendant) then
								fn15(descendant)
							end
						end)
					)
				)
			end

			local function fn19(arg)
				humanoid = arg:FindFirstChildOfClass("Humanoid")
					or arg:WaitForChild("Humanoid", 5)
				humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
					or arg:WaitForChild("HumanoidRootPart", 5)
				flag4 = false
				flag5 = false
				y = humanoidRootPart and humanoidRootPart.Position.Y or nil
				n16 = 0
			end

			local function fn20()
				flag2 = false
				flag4 = false
				flag5 = false

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				fn13()
				fn16()
				humanoid = nil
				humanoidRootPart = nil
			end

			local function fn21()
				fn20()
				flag2 = true

				if localPlayer.Character then
					fn19(localPlayer.Character)
				end

				connection2 = runtime.Track(
					localPlayer.CharacterAdded:Connect(
						runtime.Guard(function(character_)
							if flag2 then
								fn19(character_)
							end
						end)
					)
				)

				fn14()
				fn18()
				connection = runtime.Track(
					RunService.Heartbeat:Connect(runtime.Guard(fn11))
				)
			end

			fn2(fn20)

			v13:CreateSlider({
				Name = "Jump Speed",
				ShowWhen = v13:CreateToggle({
					Name = "Infinity Jump",
					Default = false,
					Callback = function(arg)
						if arg then
							fn21()
						else
							fn20()
						end
					end,
				}),
				Min = 20,
				Max = 100,
				Default = 60,
				AllowDecimals = true,
				Increment = 0.1,
				Note = "Changes jump timing while preserving the height of the original 60 speed.",
				Callback = function(arg)
					n17 = math.clamp(tonumber(arg) or 60, 20, 100)
				end,
			})

			v13:CreateSlider({
				Name = "Jump Height",
				ShowWhen = v13:CreateToggle({
					Name = "Limit Jump Height",
					Default = false,
					Note = "Limits the height of each jump. Leave this off to keep air jumping upward.",
					Callback = function(arg)
						flag6 = arg == true
						y = humanoidRootPart and humanoidRootPart.Position.Y
							or nil
					end,
				}),
				Min = 1,
				Max = 21,
				Default = 19.1,
				AllowDecimals = true,
				Increment = 0.1,
				Callback = function(arg)
					n18 = math.clamp(tonumber(arg) or 19.1, 1, 21)
				end,
			})
		end

		floatSpeedToolBridge = {}
		local n3
		n3 = 0.3
		local n4
		n4 = 200
		local n5
		n5 = 0.05
		local n6
		n6 = 0.02
		local n7
		n7 = 0.5
		local n8
		n8 = 0.5
		local n9
		n9 = 2
		local n10
		n10 = 14
		local n11
		n11 = 2
		local n12
		n12 = 19.1
		local n13
		n13 = 0.2
		local n14
		n14 = 0
		local n15
		n15 = 0.52
		local n16
		n16 = 52
		local n17
		n17 = 28
		local n18
		n18 = 240
		local n19
		n19 = 185
		local flag2
		flag2 = false
		local flag3
		flag3 = true
		local flag4
		flag4 = true
		local flag5
		flag5 = false
		local n20
		n20 = n17 - n8
		local n21
		n21 = 1
		local str
		str = "Bottom"
		local now
		now = os.clock()
		local v14
		v14 = nil
		local v15
		v15 = nil
		local y
		y = nil
		local now2
		now2 = os.clock()
		local n22
		n22 = 0
		local str2
		str2 = "Grapple Hook"
		local v16, n23, v17, v18, flag6, flag7, v19, v20, flag8, flag9
		local connection, connection2, connection3, connection4, connection5, flag10, flag11, n24, fn8

		do
			local n25 = 0.8
			v16 = nil
			n23 = 0
			local flag12 = false
			v17 = nil
			v18 = nil
			flag6 = false
			flag7 = localPlayer:GetAttribute("Stealing") == true
			v19 = nil
			v20 = nil
			flag8 = false
			flag9 = false
			local connection6 = nil
			local v21 = nil
			connection = nil
			connection2 = nil
			connection3 = nil
			connection4 = nil
			connection5 = nil
			local connection7 = nil
			local flag13 = false
			flag10 = false
			flag11 = false
			n24 = 0
			local flag14 = false
			local v22 = nil
			local tbl3 = {}
			local tbl4 = {}
			local v23 = nil
			local connection8 = nil
			local raycastParams = RaycastParams.new()
			local v24 = nil
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true

			pcall(function()
				raycastParams.RespectCanCollide = true
			end)

			local function fn9()
				local character_ = localPlayer.Character
				if not character_ then
					return nil, nil
				end
				local findFirstChildOfClass = character_.FindFirstChildOfClass
				return character_:FindFirstChild("HumanoidRootPart"),
					findFirstChildOfClass(character_, "Humanoid")
			end

			fn8 = function(arg)
				return arg and arg:IsA("Tool")
			end

			local function fn10()
				local tbl5 = {}
				local items = ReplicatedStorage:FindFirstChild("Items")

				if items then
					for _, child in ipairs(items:GetChildren()) do
						if
							child:IsA("Tool")
							and child:GetAttribute("IgnoreAntiCheat")
								== true
						then
							tbl5[child.Name] = true
						end
					end
				end

				local tbl6 = {}

				for k in pairs(tbl5) do
					if k ~= str2 and fn8(fn4(k)) then
						tbl6[#tbl6 + 1] = k
					end
				end

				table.sort(tbl6, function(arg, arg2)
					return string.lower(arg) < string.lower(arg2)
				end)

				tbl6[#tbl6 + 1] = str2
				return tbl6, tbl6[1] or "Grapple Hook"
			end

			local v25, v26 = fn10()
			local flag15 = v26 == str2 and n18 or n19

			local function fn11()
				local flag16 = v26 == str2
				local n26 = flag16 and 270 or 210
				flag15 = math.clamp(flag16 and n18 or n19, 50, n26)

				if v20 then
					v20:SetRange(50, n26, false)
					v20:Set(flag15, false)
				end
			end

			local function fn12()
				v23 = nil

				if connection8 then
					connection8:Disconnect()
					connection8 = nil
				end

				for k, v27 in pairs(tbl3) do
					pcall(function()
						k.Attachment0 = v27.Attachment0
						k.Attachment1 = v27.Attachment1
						k.Enabled = v27.Enabled
					end)
				end

				table.clear(tbl3)

				for k, v27 in pairs(tbl4) do
					pcall(function()
						k.Volume = v27
					end)
				end

				table.clear(tbl4)
			end

			local function fn13(arg)
				if v23 == arg then
					return
				end
				fn12()
				v23 = arg
				local handle = arg:FindFirstChild("Handle")
				local beam = handle and handle:FindFirstChild("Beam")

				if beam and beam:IsA("Beam") then
					tbl3[beam] = {
						Enabled = beam.Enabled,
						Attachment0 = beam.Attachment0,
						Attachment1 = beam.Attachment1,
					}
					beam.Enabled = false
					beam.Attachment0 = nil

					connection8 = runtime.Track(
						beam:GetPropertyChangedSignal("Enabled")
							:Connect(runtime.Guard(function()
								if v23 == arg and beam.Enabled then
									beam.Enabled = false
								end
							end))
					)
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Sound") then
						tbl4[descendant] = descendant.Volume
						descendant.Volume = 0
					end
				end
			end

			local function fn14()
				if
					type(hookfunction) ~= "function"
					or type(checkcaller) ~= "function"
					or type(newcclosure) ~= "function"
				then
					return false
				end

				if v22 then
					flag14 = true
					local flag16 = false

					pcall(function()
						flag16 = checkcaller() == false
					end)

					flag14 = false
					if flag16 then
						return true
					end
					v22 = nil
				end

				return pcall(function()
					v22 = hookfunction(
						checkcaller,
						newcclosure(function()
							if flag14 then
								return false
							end
							return v22()
						end)
					)
				end) and v22 ~= nil
			end

			local function fn15(arg)
				if not arg or arg.Parent ~= localPlayer.Character then
					return
				end
				flag14 = true

				pcall(function()
					arg:Deactivate()
					arg:Activate()
				end)

				if type(firesignal) == "function" then
					pcall(function()
						firesignal(arg.Activated)
					end)
				end

				if type(getconnections) == "function" then
					pcall(function()
						local v27 = getconnections(arg.Activated)

						if type(v27) == "table" then
							for _, v28 in ipairs(v27) do
								if v28.Enabled then
									if type(v28.Fire) == "function" then
										v28:Fire()
									elseif type(v28.Function) == "function" then
										v28.Function()
									end
								end
							end
						end
					end)
				end

				flag14 = false
			end

			local function fn16(arg)
				if
					not (flag10 or flag11)
					or not arg
					or arg.Parent ~= localPlayer.Character
					or arg:GetAttribute("CooldownTime") ~= nil
				then
					return
				end
				n24 = os.clock() + n25
				fn15(arg)
			end

			local function fn17()
				v21 = nil

				if connection6 then
					connection6:Disconnect()
					connection6 = nil
				end
			end

			local function fn18(arg)
				if v21 == arg then
					return
				end
				fn17()
				v21 = arg

				connection6 = runtime.Track(
					arg:GetAttributeChangedSignal("CooldownTime")
						:Connect(runtime.Guard(function()
							if
								(flag10 or flag11)
								and arg:GetAttribute("CooldownTime") == nil
							then
								fn16(arg)
							end
						end))
				)
			end

			local function fn19()
				if not flag9 then
					return
				end
				flag9 = false
				local v27, v28 = fn9()
				if not v27 or not v28 or v28.Health <= 0 then
					return
				end
				local assemblyLinearVelocity = v27.AssemblyLinearVelocity
				local moveDirection = v28.MoveDirection
				local vector = Vector3.zero

				if moveDirection.Magnitude > 0.001 then
					vector = moveDirection.Unit * v28.WalkSpeed
				end

				v27.AssemblyLinearVelocity =
					Vector3.new(vector.X, assemblyLinearVelocity.Y, vector.Z)
			end

			local function fn20()
				fn19()
				flag5 = false
				flag8 = false
				flag10 = false
				v16 = nil

				if not flag11 then
					n24 = 0
					fn17()
					fn12()
				end
			end

			local function fn21()
				fn20()

				if v17 then
					v17:Set(false, true)
				end
			end

			local function fn22()
				if flag12 then
					return
				end
				flag12 = true

				task.defer(function()
					flag12 = false
					fn21()
				end)
			end

			local function fn23(arg, arg2)
				if arg == str2 and arg2 == "rebirth" then
					v.Notify(
						"Tool unavailable",
						"Grapple Hook requires 3 Rebirths.",
						5
					)
					return
				end
				fn6(arg, arg2)
			end

			local function fn24(arg)
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				if
					not character_
					or not humanoid
					or humanoid.Health <= 0
					or not fn8(arg)
				then
					return nil
				end
				n23 = os.clock() + 1.5
				if arg.Parent == character_ then
					return arg
				end

				if
					not (
						character_:FindFirstChild("RightHand")
						or character_:FindFirstChild("Right Arm")
					)
				then
					if not character_:WaitForChild("RightHand", 1.5) then
						character_:WaitForChild("Right Arm", 1.5)
					end
				end

				pcall(function()
					humanoid:EquipTool(arg)
				end)

				local now3 = os.clock()

				while os.clock() - now3 < 0.6 do
					if arg.Parent ~= character_ then
						RunService.Heartbeat:Wait()
						continue
					end
					break
				end

				if arg.Parent ~= character_ and humanoid.Health > 0 then
					pcall(function()
						humanoid:EquipTool(arg)
					end)

					local now4 = os.clock()

					while os.clock() - now4 < 0.6 do
						if arg.Parent ~= character_ then
							RunService.Heartbeat:Wait()
							continue
						end
						break
					end
				end

				if arg.Parent ~= character_ then
					pcall(function()
						arg.Parent = character_
					end)
				end

				if arg.Parent == character_ then
					RunService.Heartbeat:Wait()
					return arg
				end
				local v27 = character_:FindFirstChild(v26)
				return fn8(v27) and v27 or nil
			end

			local function fn25()
				local grappleHook = fn4(v26)

				if not fn8(grappleHook) and v26 == str2 then
					local v27
					grappleHook, v27 = fn5("Grapple Hook")
					if not fn8(grappleHook) then
						fn23("Grapple Hook", v27)
						return false
					end
				elseif not fn8(grappleHook) then
					v.Notify(
						"Tool unavailable",
						v26 .. " is not currently owned.",
						5
					)
					return false
				end

				v16 = fn24(grappleHook)
				if not v16 then
					v.Notify(
						"Tool unavailable",
						"Unable to equip " .. v26 .. " right now.",
						5
					)
					return false
				end
				flag5 = true
				flag8 = true

				if v26 == str2 then
					fn14()
					flag10 = true
					fn13(v16)
					fn18(v16)
					fn16(v16)
				end

				return true
			end

			local function fn26()
				local v27, v28 = fn10()
				local v29, v30, v31 = ipairs(v27)
				local flag16 = false

				for _, v32 in v29, v30, v31 do
					if v32 == v26 then
						flag16 = true
						break
					end
				end

				if not flag16 then
					v26 = v28

					if flag5 then
						fn22()
					end
				end

				fn11()

				if v19 then
					v19:SetOptions(v27, v26, false)
				end
			end

			local function fn27()
				if flag13 then
					return
				end
				flag13 = true

				task.defer(function()
					flag13 = false
					fn26()
				end)
			end

			local function fn28(arg)
				if connection then
					connection:Disconnect()
				end

				if connection2 then
					connection2:Disconnect()
				end

				if connection3 then
					connection3:Disconnect()
				end

				connection = runtime.Track(
					arg.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if not (flag10 or flag11) or os.clock() > n24 then
								return
							end

							if
								not (
									descendant:IsA("BodyMover")
									or descendant:IsA("Constraint")
								)
							then
								return
							end

							task.defer(function()
								if descendant.Parent then
									pcall(function()
										descendant:Destroy()
									end)
								end
							end)
						end)
					)
				)

				connection2 = runtime.Track(
					arg.ChildAdded:Connect(runtime.Guard(function(child)
						fn27()
						local humanoid = arg:FindFirstChildOfClass("Humanoid")
						humanoid = humanoid and humanoid.Health > 0
						local v27 = flag5

						if not flag5 then
							humanoid = v27
						end

						if
							humanoid
							and child:IsA("Tool")
							and child.Name ~= v26
							and not fn7()
							and os.clock() >= n23
						then
							fn22()
						end
					end))
				)

				connection3 = runtime.Track(
					arg.ChildRemoved:Connect(runtime.Guard(function(child)
						fn27()
						local humanoid = arg:FindFirstChildOfClass("Humanoid")
						humanoid = humanoid and humanoid.Health > 0
						local v27 = flag5

						if not flag5 then
							humanoid = v27
						end

						if
							humanoid
							and child == v16
							and not fn7()
							and os.clock() >= n23
						then
							task.defer(function()
								local character_ = localPlayer.Character
								local humanoid2 = character_
									and character_:FindFirstChildOfClass(
										"Humanoid"
									)
								if not humanoid2 or humanoid2.Health <= 0 then
									return
								end
								character_ = character_
									and character_:FindFirstChild(v26)

								if flag5 and not fn8(character_) then
									fn22()
								end
							end)
						end
					end))
				)
			end

			local function fn29(arg)
				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				if connection7 then
					connection7:Disconnect()
					connection7 = nil
				end

				if arg then
					connection4 = runtime.Track(
						arg.ChildAdded:Connect(runtime.Guard(fn27))
					)
					connection5 = runtime.Track(
						arg.ChildRemoved:Connect(runtime.Guard(fn27))
					)
				end
			end

			if localPlayer.Character then
				fn28(localPlayer.Character)
			end

			local backpack = localPlayer:FindFirstChildOfClass("Backpack")

			if backpack then
				fn29(backpack)
			end

			connection7 = runtime.Track(
				localPlayer.ChildAdded:Connect(runtime.Guard(function(child)
					if child:IsA("Backpack") then
						fn29(child)
						fn27()
					end
				end))
			)

			local function fn30(arg, arg2)
				str = arg
				now = arg2
				v14 = nil
			end

			local function fn31(arg, arg2)
				if not arg then
					v14 = nil
					return false
				end
				local v27 = v14
				local v28

				if v14 then
					v28 = v27
				else
					v28 = arg2
				end

				v14 = v28
				return arg2 - v14 >= n6
			end

			local function fn32(arg, arg2)
				local assemblyLinearVelocity = arg.AssemblyLinearVelocity
				arg.AssemblyLinearVelocity = Vector3.new(
					assemblyLinearVelocity.X,
					arg2,
					assemblyLinearVelocity.Z
				)
			end

			local function fn33(arg, arg2)
				local parent = arg.Parent

				if v24 ~= parent then
					v24 = parent
					raycastParams.FilterDescendantsInstances = { parent }
				end

				local n26

				if arg2.RigType == Enum.HumanoidRigType.R6 then
					n26 = 3
				else
					n26 = math.max(
						arg.Size.Y * 0.5,
						arg2.HipHeight + arg.Size.Y * 0.5
					)
				end

				local hit = Workspace:Raycast(
					arg.Position,
					Vector3.new(0, -(n26 + n7), 0),
					raycastParams
				)
				return hit ~= nil and hit.Normal.Y > 0.15
			end

			local connection9 = runtime.Track(
				RunService.Heartbeat:Connect(runtime.Guard(function(deltaTime)
					local v27, v28 = fn9()
					local now3 = os.clock()

					if not v27 or not v28 or v28.Health <= 0 then
						v15 = nil
						y = nil
						n22 = 0
						return
					end

					if v27 ~= v15 or not y then
						v15 = v27
						y = v27.Position.Y
						now2 = now3
						n22 = 0
						fn30("Bottom", now3)
					else
						local n26 = now3 - now2

						if n26 > 0 then
							n22 = (v27.Position.Y - y) / n26
						end

						y = v27.Position.Y
						now2 = now3
					end

					if flag2 then
						local n26 = math.max(0.02, n3 / n15)
						local n27 = math.max(0.01, n5 / n15)
						local n28 = n4 * n15
						local n29 = now3 - now

						if str == "Rise" then
							local n30 = math.clamp(n29 / n26, 0, 1)
							local n31 = n12
								* 3.1415926535897931
								/ 2
								* n26
								* math.cos(n30 * 3.1415926535897931 * 0.5)

							if
								fn31(
									n29 >= 0.06
										and n31 >= n10
										and math.abs(n22) <= n11,
									now3
								)
							then
								fn30("Fall", now3)
							elseif n30 >= 1 then
								fn30("Hold", now3)
								fn32(v27, 0)
							else
								fn32(v27, n31)
							end
						elseif str == "Hold" then
							if n13 <= n29 then
								fn30("Fall", now3)
							else
								fn32(v27, 0)
							end
						elseif str == "Fall" then
							local n30 = math.clamp(n29 / n27, 0, 1)
							local n31 = -n28
								* math.sin(n30 * 3.1415926535897931 * 0.5)

							if
								fn31(
									n29 >= 0.01 and n31 <= -n10 and n22 >= -n11,
									now3
								) or n30 >= 1
							then
								fn30("Bottom", now3)
							else
								fn32(v27, n31)
							end
						else
							v14 = nil

							if n29 >= n14 and fn33(v27, v28) then
								fn30("Rise", now3)
							end
						end
					else
						v14 = nil

						if str ~= "Bottom" then
							fn30("Bottom", now3)
						end
					end

					if flag5 then
						local character_ = localPlayer.Character
						local humanoid = character_
							and character_:FindFirstChildOfClass("Humanoid")

						if not (humanoid and humanoid.Health > 0) then
							flag8 = false
							n23 = math.max(n23, now3 + 1.5)
						else
							local tool =
								character_:FindFirstChildWhichIsA("Tool")
							flag8 = tool ~= nil and tool.Name == v26

							if not tool or tool.Name ~= v26 then
								if not fn7() and now3 >= n23 then
									fn22()
								end
							elseif v26 == str2 then
								v16 = tool
								flag10 = true
								fn13(tool)
								fn18(tool)
								fn16(tool)
							end
						end
					else
						flag8 = false
					end

					local flag16 = localPlayer:GetAttribute("Stealing") == true
					local flag17 = flag16 and not flag7
					flag7 = flag16

					if
						flag17
						and flag3
						and v18
						and (not flag4 or v18:Get() ~= true)
						and not flag6
					then
						flag6 = true

						task.defer(function()
							flag6 = false
							if
								not flag
								or localPlayer:GetAttribute("Stealing") ~= true
								or not flag3
								or not v18
							then
								return
							end

							if v18:Get() ~= true then
								v18:Set(true, true)
							else
								flag4 = true
								n20 = math.max(20, n17 - n8)
								n21 = 1
							end
						end)
					end

					local v29 = flag16 and flag4
					local flag18 = flag5 and flag8 and not flag16

					if flag18 then
						local assemblyLinearVelocity =
							v27.AssemblyLinearVelocity
						local moveDirection = v28.MoveDirection
						local vector = Vector3.zero

						if moveDirection.Magnitude > 0.001 then
							vector = moveDirection.Unit * flag15
						end

						v27.AssemblyLinearVelocity = Vector3.new(
							vector.X,
							assemblyLinearVelocity.Y,
							vector.Z
						)
						flag9 = true
					else
						fn19()
					end

					local v30

					if v29 then
						local n26 = math.max(20, n17 - n8)

						if n17 <= n26 then
							n20 = n17
						else
							n20 += n21 * n9 * deltaTime

							if n17 <= n20 then
								n20 = n17
								n21 = -1
							elseif n20 <= n26 then
								n20 = n26
								n21 = 1
							end
						end

						v30 = n20
					else
						local flag19 = not flag16 and flag3 and not flag18
						v30 = nil

						if flag19 then
							v30 = n16
						end
					end

					if v30 then
						local moveDirection = v28.MoveDirection
						local n26 = v30 - v28.WalkSpeed

						if
							moveDirection.Magnitude > 0.001
							and math.abs(n26) > 0.001
						then
							v27.CFrame = v27.CFrame
								+ moveDirection * n26 * deltaTime
						end
					end
				end))
			)

			local connection10 = runtime.Track(
				localPlayer.CharacterAdded:Connect(
					runtime.Guard(function(character_)
						v15 = nil
						y = nil
						fn17()
						fn12()
						v16 = nil
						flag8 = false
						n23 = os.clock() + 3
						fn28(character_)
						local backpack2 =
							localPlayer:FindFirstChildOfClass("Backpack")

						if backpack2 then
							fn29(backpack2)
						end

						fn27()

						if flag5 then
							task.spawn(function()
								local humanoid =
									character_:WaitForChild("Humanoid", 3)
								if not humanoid then
									return
								end

								if
									not character_:WaitForChild(
										"HumanoidRootPart",
										3
									)
								then
									return
								end
								local now3 = os.clock()
								local grappleHook

								while true do
									grappleHook = fn4(v26)

									if fn8(grappleHook) then
										break
									else
										task.wait(0.1)
										if
											not (
												fn8(grappleHook)
												or os.clock() - now3 >= 3
												or not flag5
											)
										then
											continue
										end
										break
									end
								end

								if not flag5 then
									return
								end

								if not fn8(grappleHook) and v26 == str2 then
									grappleHook = fn5("Grapple Hook")
								end

								if
									fn8(grappleHook)
									and flag5
									and humanoid.Health > 0
								then
									task.wait(0.15)
									v16 = fn24(grappleHook)

									if v16 then
										flag8 = true

										if v26 == str2 then
											fn14()
											flag10 = true
											fn13(v16)
											fn18(v16)
											RunService.Heartbeat:Wait()
											fn16(v16)
										end
									else
										fn21()
									end
								elseif flag5 then
									fn21()
								end
							end)
						end
					end)
				)
			)

			fn2(function()
				flag2 = false
				flag3 = false
				flag4 = false
				flag11 = false
				fn20()
				flag14 = false

				if v22 then
					pcall(function()
						hookfunction(checkcaller, v22)
					end)
				end

				if connection10 then
					connection10:Disconnect()
					connection10 = nil
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				if connection9 then
					connection9:Disconnect()
					connection9 = nil
				end
			end)

			v12:CreateSlider({
				Name = "Adjust Speed",
				ShowWhen = v12:CreateToggle({
					Name = "Speed Boost",
					Default = false,
					Note = "Moves faster without a tool and pauses while stealing.",
					Callback = function(arg)
						flag3 = arg == true
					end,
				}),
				Min = 20,
				Max = 64,
				Default = 52,
				AllowDecimals = true,
				Increment = 0.1,
				Callback = function(arg)
					n16 = math.clamp(tonumber(arg) or 52, 20, 64)
				end,
			})

			v18 = v12:CreateToggle({
				Name = "Speed Boost While Stealing",
				Default = false,
				Note = "Smoothly varies speed while stealing.",
				Callback = function(arg)
					flag4 = arg == true
					n20 = math.max(20, n17 - n8)
					n21 = 1
				end,
			})

			v12:CreateSlider({
				Name = "Adjust Auto Speed",
				DisplayName = "Adjust Speed On Steal",
				ShowWhen = v18,
				Min = 20,
				Max = 29,
				Default = 28,
				AllowDecimals = true,
				Increment = 0.1,
				Callback = function(arg)
					n17 = math.clamp(tonumber(arg) or 28, 20, 29)
					n20 = math.max(20, n17 - n8)
					n21 = 1
				end,
			})

			v17 = v12:CreateToggle({
				Name = "Tool Speed Boost",
				Default = false,
				Keybind = Enum.KeyCode.Q,
				Note = "Equips the selected speed tool. Switching tools turns this off.",
				Callback = function(arg)
					if arg then
						if not fn25() then
							task.defer(function()
								if v17 then
									v17:Set(false, true)
								end
							end)
						end
					else
						fn20()
					end
				end,
			})

			v19 = v12:CreateDropdown({
				Name = "Speed Tool",
				ShowWhen = v17,
				Options = v25,
				Default = "Grapple Hook",
				Callback = function(arg)
					local str3 = tostring(arg or "Grapple Hook")
					if str3 == v26 then
						return
					end
					v26 = str3
					fn11()

					if flag5 then
						fn21()
					end
				end,
			})

			v20 = v12:CreateSlider({
				Name = "Adjust Tool Speed",
				ShowWhen = v17,
				Min = 50,
				Max = v26 == str2 and 270 or 210,
				Default = 240,
				AllowDecimals = true,
				Increment = 0.1,
				Callback = function(arg)
					if v26 == str2 then
						n18 = math.clamp(tonumber(arg) or 240, 50, 270)
						flag15 = n18
					else
						n19 = math.clamp(tonumber(arg) or 185, 50, 210)
						flag15 = n19
					end
				end,
			})

			local v27 = v13:CreateToggle({
				Name = "Auto Jump",
				Default = false,
				Note = "Automatically repeats jumps.",
				Callback = function(arg)
					flag2 = arg == true
					fn30("Bottom", os.clock())
				end,
			})

			v13:CreateSlider({
				Name = "Height",
				SubOf = v27,
				Min = 1,
				Max = 21,
				Default = 16,
				AllowDecimals = true,
				Increment = 0.1,
				Note = "Sets the maximum height of each jump.",
				Callback = function(arg)
					n12 = math.clamp(tonumber(arg) or 19.1, 1, 21)
				end,
			})

			v13:CreateSlider({
				Name = "Auto Jump Speed",
				SubOf = v27,
				DisplayName = "Jump Speed",
				Min = 20,
				Max = 110,
				Default = 50,
				AllowDecimals = true,
				Increment = 0.1,
				Note = "Controls jump speed (20 to 110, default 52 = 0.52x).",
				Callback = function(arg)
					n15 = math.clamp(tonumber(arg) or 52, 20, 110) / 100
				end,
			})

			v13:CreateSlider({
				Name = "Air Hold",
				SubOf = v27,
				Min = 0,
				Max = 1,
				Default = 0.1,
				AllowDecimals = true,
				Increment = 0.01,
				Note = "Controls how long you stay at the top of each jump.",
				Callback = function(arg)
					n13 = math.clamp(tonumber(arg) or 0.2, 0, 1)
				end,
			})

			v13:CreateSlider({
				Name = "Ground Delay",
				SubOf = v27,
				Min = 0,
				Max = 1,
				Default = 0,
				AllowDecimals = true,
				Increment = 0.01,
				Note = "Controls how long to wait on the ground before jumping again.",
				Callback = function(arg)
					n14 = math.clamp(tonumber(arg) or 0, 0, 1)
				end,
			})

			floatSpeedToolBridge.GetSelectedName = function()
				return v26
			end

			floatSpeedToolBridge.EquipSelected = function()
				local grappleHook = fn4(v26)

				if not fn8(grappleHook) and v26 == str2 then
					local v28
					grappleHook, v28 = fn5("Grapple Hook")
					if not fn8(grappleHook) then
						fn23("Grapple Hook", v28)
						return nil
					end
				elseif not fn8(grappleHook) then
					v.Notify(
						"Tool unavailable",
						v26 .. " is not currently owned.",
						5
					)
					return nil
				end

				local v28 = fn24(grappleHook)
				if not v28 then
					v.Notify(
						"Tool unavailable",
						"Unable to equip " .. v26 .. " right now.",
						5
					)
					return nil
				end
				return v28
			end

			floatSpeedToolBridge.StartGrappleSpam = function(arg)
				if not fn8(arg) or arg.Name ~= str2 then
					return false
				end
				flag11 = true
				fn14()
				fn13(arg)
				fn18(arg)
				fn16(arg)
				return true
			end

			floatSpeedToolBridge.PulseGrapple = function(arg)
				if not flag11 or not fn8(arg) or arg.Name ~= str2 then
					return false
				end
				fn13(arg)
				fn18(arg)
				fn16(arg)
				return true
			end

			floatSpeedToolBridge.StopGrappleSpam = function()
				flag11 = false

				if not flag10 then
					n24 = 0
					fn17()
					fn12()
				end
			end
		end

		do
			local n25 = 0.0083333333333333332
			local n26 = 4
			local n27 = 0.12
			local n28 = 25
			local n29 = 0.045
			local n30 = 0.03
			local n31 = 10
			local n32 = 60
			local flag12 = false
			local connection6 = nil
			local n33 = 0
			local flag13 = false
			local n34 = 0
			local n35 = 0
			local n36 = 0
			local v21 = nil
			local flag14 = false
			local flag15 = false
			local v22 = nil
			local flag16 = false

			local function fn9()
				if connection6 then
					connection6:Disconnect()
					connection6 = nil
				end

				flag12 = false
				n33 = 0
				flag13 = false
				n34 = 0
				n35 = 0
				n36 = 0
				v21 = nil
				local stopGrappleSpam = floatSpeedToolBridge.StopGrappleSpam

				if type(stopGrappleSpam) == "function" then
					stopGrappleSpam()
				end
			end

			local function fn10()
				if flag16 then
					return
				end
				flag16 = true

				task.defer(function()
					flag16 = false
					fn9()

					if v22 and v22:Get() == true then
						v22:Set(false, true)
					end
				end)
			end

			local function fn11(arg)
				if not flag12 or not arg or not arg.Parent then
					return
				end
				local now3 = os.clock()
				n35 = n32
				n34 = now3 + n27
				flag13 = true
				n36 = now3
			end

			local function fn12(arg, arg2)
				local assemblyLinearVelocity = arg.AssemblyLinearVelocity
				local flag17 = arg2.FloorMaterial ~= Enum.Material.Air
				local now3 = os.clock()

				if now3 - n36 >= n29 or flag13 and n34 - now3 <= n30 then
					fn11(arg)
				end

				if flag13 then
					if n34 <= now3 then
						flag13 = false
					else
						local n37 = (Workspace.Gravity - Workspace.Gravity)
							* n25
						arg.AssemblyLinearVelocity = Vector3.new(
							assemblyLinearVelocity.X,
							assemblyLinearVelocity.Y
								+ (n35 - assemblyLinearVelocity.Y) * (1 - math.exp(
									-n28 * n25
								))
								- n37,
							assemblyLinearVelocity.Z
						)
					end
				elseif not flag17 then
					local gravity = Workspace.Gravity

					if assemblyLinearVelocity.Y < 0 then
						gravity += n31
					end

					local n37 = gravity - Workspace.Gravity

					if math.abs(n37) > 0.001 then
						arg.AssemblyLinearVelocity = Vector3.new(
							assemblyLinearVelocity.X,
							assemblyLinearVelocity.Y - n37 * n25,
							assemblyLinearVelocity.Z
						)
					end
				end
			end

			local function fn13(arg)
				fn9()
				v21 = arg
				local startGrappleSpam = floatSpeedToolBridge.StartGrappleSpam

				if v21 and type(startGrappleSpam) == "function" then
					if not startGrappleSpam(v21) then
						v21 = nil
					end
				end

				flag12 = true
				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChild("HumanoidRootPart")

				if character_ then
					fn11(character_)
				end

				connection6 = runtime.Track(
					RunService.Heartbeat:Connect(
						runtime.Guard(function(deltaTime)
							if not flag12 then
								return
							end

							if
								flag15
								and localPlayer:GetAttribute("Stealing")
									== true
							then
								fn10()
								return
							end
							local character_2 = localPlayer.Character
							local humanoidRootPart = character_2
								and character_2:FindFirstChild(
									"HumanoidRootPart"
								)
							if not humanoidRootPart then
								return
							end
							local humanoid =
								character_2:FindFirstChildOfClass("Humanoid")
							if humanoid and humanoid.Health <= 0 then
								fn10()
								return
							end
							local pulseGrapple =
								floatSpeedToolBridge.PulseGrapple

							if v21 and type(pulseGrapple) == "function" then
								if not pulseGrapple(v21) then
									v21 = nil
								end
							end

							n33 += deltaTime
							if n33 < n25 then
								return
							end
							local n37 = math.floor(n33 / n25)

							if n26 < n37 then
								n33 = 0
								n37 = 4
							else
								n33 -= n37 * n25
							end

							for i_ = 1, n37 do
								fn12(humanoidRootPart, humanoid)
							end
						end)
					)
				)
			end

			v22 = v5:CreateToggle({
				Name = "Float",
				Default = false,
				Callback = function(arg)
					if arg then
						if
							flag15
							and localPlayer:GetAttribute("Stealing") == true
						then
							fn10()
							return
						end
						local v23 = nil

						if flag14 then
							local equipSelected =
								floatSpeedToolBridge.EquipSelected

							if type(equipSelected) ~= "function" then
								v.Notify(
									"Tool unavailable",
									"The Speed Tool selection is not available right now.",
									5
								)
								fn10()
								return
							end

							v23 = equipSelected()
							if not v23 then
								fn10()
								return
							end
						end

						fn13(v23)
					else
						fn9()
					end
				end,
			})

			v5:CreateToggle({
				Name = "Auto Equip Speed Tool",
				Note = "Equips the current Speed Tool selection before Float starts.",
				Default = false,
				SubOf = v22,
				Callback = function(arg)
					flag14 = arg == true
				end,
			})

			v5:CreateToggle({
				Name = "Auto Off After Steal",
				Default = false,
				SubOf = v22,
				Callback = function(arg)
					flag15 = arg == true

					if
						flag15
						and flag12
						and localPlayer:GetAttribute("Stealing") == true
					then
						fn10()
					end
				end,
			})

			fn2(function()
				fn9()
			end)
		end

		do
			local n25 = 1
			local flag12 = false
			local connection6 = nil
			local v21 = nil
			local n26 = 5

			local function fn9()
				if v21 then
					pcall(function()
						v21:Destroy()
					end)

					v21 = nil
				end
			end

			local function fn10()
				if connection6 then
					connection6:Disconnect()
					connection6 = nil
				end

				flag12 = false
				fn9()
			end

			local function createPart()
				if v21 and v21.Parent then
					return v21
				end
				fn9()
				local part = Instance.new("Part")
				part.Name = fn()
				part.Anchored = true
				part.CanCollide = true
				part.CanQuery = false
				part.CanTouch = false
				part.CastShadow = false
				part.Massless = true
				part.Size = Vector3.new(6, 1, 6)
				part.Transparency = 1
				part.Parent = Workspace
				v21 = part
				return part
			end

			local function fn11()
				fn10()
				flag12 = true

				connection6 = runtime.Track(
					RunService.Heartbeat:Connect(
						runtime.Guard(function(deltaTime)
							if not flag12 then
								return
							end
							local character_ = localPlayer.Character
							local humanoidRootPart = character_
								and character_:FindFirstChild(
									"HumanoidRootPart"
								)
							if not humanoidRootPart then
								fn9()
								return
							end
							local v22 = createPart()
							local n27 = math.min(deltaTime, 0.1) * n26
							local humanoid =
								character_:FindFirstChildOfClass("Humanoid")
							local n28 = 3.2

							if humanoid then
								n28 = humanoid.HipHeight
									+ humanoidRootPart.Size.Y * 0.5
							end

							local n29 = humanoidRootPart.Position.Y - n28
							local y2 = v22.Position.Y
							local n30

							if math.abs(y2 + n25 * 0.5 - n29) > 6 then
								n30 = n29 - n25 * 0.5
							else
								n30 = y2 + n27
							end

							v22.CFrame = CFrame.new(
								humanoidRootPart.Position.X,
								n30,
								humanoidRootPart.Position.Z
							)
							local n31 = n30 + n25 * 0.5

							if n31 > n29 then
								local n32 = n31 + n28
								local n33 = humanoidRootPart.CFrame
									- humanoidRootPart.CFrame.Position
								humanoidRootPart.CFrame = CFrame.new(
									humanoidRootPart.Position.X,
									n32,
									humanoidRootPart.Position.Z
								) * n33
								local assemblyLinearVelocity =
									humanoidRootPart.AssemblyLinearVelocity
								humanoidRootPart.AssemblyLinearVelocity =
									Vector3.new(
										assemblyLinearVelocity.X,
										0,
										assemblyLinearVelocity.Z
									)
							end
						end)
					)
				)
			end

			v5:CreateSlider({
				Name = "Floor Push Speed",
				Min = 5,
				Max = 40,
				Default = 10,
				AllowDecimals = false,
				Increment = 1,
				Unit = " studs/s",
				Quick = false,
				SubOf = v5:CreateToggle({
					Name = "Floor Push",
					Note = "Raises an invisible platform under you and carries you up with it.",
					Default = false,
					Callback = function(arg)
						if arg then
							fn11()
						else
							fn10()
						end
					end,
				}),
				Callback = function(arg)
					n26 = math.clamp(tonumber(arg) or 5, 5, 40)
				end,
			})
		end
	end

	local v9, v10, v11, fn4, fn5, fn6, fn7, fn8, fn9, tbl3
	local fn10, fn11, fn12, n, fn13, fn14, fn15

	do
		do
			local n2 = 0.01
			local flag2 = false
			local n3 = 50
			local connection = nil
			local connection2 = nil
			local v12 = nil
			local v13 = nil
			local autoRotate = true
			local v14 = nil
			local v15 = nil
			local flag3 = false
			local flag4 = false
			local n4 = 0
			local obj2 = setmetatable({}, { __mode = "k" })

			local function fn16(arg)
				arg = arg and arg.Character
				local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart

				if arg then
					humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
						or arg:FindFirstChild("UpperTorso")
						or arg:FindFirstChild("Torso")
				else
					humanoidRootPart = arg
				end

				if humanoid and humanoid.Health > 0 and humanoidRootPart then
					return arg, humanoid, humanoidRootPart
				end
			end

			local function fn17(arg)
				local huge = math.huge
				local v16 = nil

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local v17, v18, v19 = fn16(player)

						if v19 then
							local magnitude = (v19.Position - arg.Position).Magnitude

							if magnitude < huge then
								huge = magnitude
								v16 = v19
							end
						end
					end
				end

				return v16
			end

			local function fn18(arg)
				arg = arg and arg:FindFirstChildWhichIsA("Tool")
				if arg and arg.Name:lower():find("bat", 1, true) then
					return arg
				end
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")

				if backpack then
					for _, child in ipairs(backpack:GetChildren()) do
						if
							child:IsA("Tool")
							and child.Name:lower():find("bat", 1, true)
						then
							return child
						end
					end
				end
			end

			local function fn19(arg, arg2)
				local v16 = fn18(arg)

				if not v16 then
					if not flag4 then
						flag4 = true
						v.Notify(
							"Bat unavailable",
							"Bat was not found in your character or Backpack.",
							5
						)
					end

					return nil
				end

				flag4 = false

				if v16.Parent ~= arg then
					local tool = arg:FindFirstChildWhichIsA("Tool")

					if tool and tool ~= v16 and not v14 then
						v14 = tool
					end

					v15 = v16
					flag3 = true

					pcall(function()
						fn3(1)
						arg2:EquipTool(v16)
					end)
				end

				return v16.Parent == arg and v16 or nil
			end

			local function fn20(arg)
				if not arg:IsA("BasePart") then
					return
				end

				if obj2[arg] == nil then
					obj2[arg] = arg.CanCollide
				end

				arg.CanCollide = false
			end

			local function fn21()
				for k, v16 in pairs(obj2) do
					if k.Parent then
						pcall(function()
							k.CanCollide = v16
						end)
					end

					obj2[k] = nil
				end
			end

			local function fn22(arg)
				if v12 == arg then
					return
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				fn21()
				v12 = arg
				if not arg then
					return
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					fn20(descendant)
				end

				connection2 = runtime.Track(
					arg.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 then
								fn20(descendant)
							end
						end)
					)
				)
			end

			local function fn23()
				local v16 = v13
				v13 = nil
				if not v16 or not v16.Parent then
					return
				end

				pcall(function()
					v16.AutoRotate = autoRotate
					local physics = Enum.HumanoidStateType.Physics

					if v16:GetState() == physics then
						v16:ChangeState(Enum.HumanoidStateType.Freefall)
					end
				end)
			end

			local function fn24(arg)
				if v13 ~= arg then
					fn23()
					v13 = arg
					autoRotate = arg.AutoRotate
				end

				arg.AutoRotate = false
				local physics = Enum.HumanoidStateType.Physics

				if arg:GetState() ~= physics then
					arg:ChangeState(Enum.HumanoidStateType.Physics)
				end
			end

			local function fn25()
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local v16 = v15
				local v17 = v14
				v15 = nil
				v14 = nil
				if
					not flag3
					or not character_
					or not humanoid
					or humanoid.Health <= 0
				then
					flag3 = false
					return
				end
				flag3 = false
				local tool = character_:FindFirstChildWhichIsA("Tool")
				if tool and tool ~= v16 then
					return
				end

				pcall(function()
					fn3(0.5)

					if v17 and v17.Parent then
						humanoid:EquipTool(v17)
					else
						humanoid:UnequipTools()
					end
				end)
			end

			local function fn26()
				flag2 = false
				n4 = 0
				flag4 = false

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				v12 = nil
				fn23()
				fn21()
				fn25()
			end

			local function fn27()
				fn26()
				flag2 = true

				connection = runtime.Track(
					RunService.Heartbeat:Connect(
						runtime.Guard(function(deltaTime)
							local v16, v17, v18 = fn16(localPlayer)

							if not v16 or not v17 or not v18 then
								n4 = 0
								fn23()
								return
							end

							fn22(v16)
							local v19 = fn19(v16, v17)
							local v20 = fn17(v18)

							if not v20 then
								n4 = 0
								fn23()
								return
							end

							fn24(v17)
							local lookVector = v20.CFrame.LookVector
							local vector =
								Vector3.new(lookVector.X, 0, lookVector.Z)
							local vector2

							if vector.Magnitude <= 0.001 then
								vector2 = Vector3.new(0, 0, -1)
							else
								vector2 = vector.Unit
							end

							local position = v20.Position
							local n5 = position - v18.Position
							local magnitude = n5.Magnitude

							if magnitude > 0.001 then
								position = v18.Position
									+ n5.Unit
										* math.min(magnitude, n3 * deltaTime)
							end

							v18.CFrame = CFrame.lookAt(
								position,
								position + vector2,
								Vector3.new(0, 1, 0)
							)
							v18.AssemblyLinearVelocity =
								v20.AssemblyLinearVelocity
							v18.AssemblyAngularVelocity = Vector3.zero
							if not v19 then
								n4 = 0
								return
							end
							n4 += deltaTime
							local n6 = math.min(math.floor(n4 / n2), 6)
							if n6 <= 0 then
								return
							end
							n4 -= n6 * n2

							for i_ = 1, n6 do
								pcall(function()
									v19:Deactivate()
									v19:Activate()
								end)
							end
						end)
					)
				)
			end

			fn2(fn26)

			v5:CreateSlider({
				Name = "Follow Speed",
				DisplayName = "Follow Speed",
				SubOf = v5:CreateToggle({
					Name = "Auto Hit Nearest Player",
					Default = false,
					Callback = function(arg)
						if arg then
							fn27()
						else
							fn26()
						end
					end,
				}),
				Min = 20,
				Max = 64,
				Default = 50,
				AllowDecimals = true,
				Increment = 0.1,
				Callback = function(arg)
					n3 = math.clamp(tonumber(arg) or 50, 20, 64)
				end,
			})
		end

		do
			local tbl4 = {
				BallSocketConstraint = true,
				NoCollisionConstraint = true,
				HingeConstraint = true,
			}

			local tbl5 = {
				[Enum.HumanoidStateType.Physics] = true,
				[Enum.HumanoidStateType.Ragdoll] = true,
				[Enum.HumanoidStateType.FallingDown] = true,
			}

			local n2 = 12
			local n3 = 5
			local n4 = 0
			local v12 = nil

			local ok, result = pcall(function()
				return require(ReplicatedStorage.Controllers.RagdollController)
			end)

			if ok then
				v12 = result
			end

			local v13 = nil

			local function fn16()
				if v13 then
					return v13
				end

				local ok2, result2 = pcall(function()
					return require(
						localPlayer
							:WaitForChild("PlayerScripts", 5)
							:WaitForChild("PlayerModule", 5)
					):GetControls()
				end)

				if ok2 then
					v13 = result2
				end

				return v13
			end

			local flag2 = false
			local connection = nil
			local n5 = 0
			local tbl6 = {}
			local tbl7 = {}
			local n6 = 0
			local v14 = nil
			local humanoid = nil

			local function fn17(arg)
				for _, v15 in ipairs(arg) do
					if v15.Connected then
						v15:Disconnect()
					end
				end

				table.clear(arg)
			end

			local function fn18(arg)
				tbl6[#tbl6 + 1] = arg
			end

			local function fn19(arg)
				tbl7[#tbl7 + 1] = arg
			end

			local function fn20()
				if not v14 or not humanoid then
					return
				end
				local humanoidRootPart = v14:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end
				local assemblyLinearVelocity =
					humanoidRootPart.AssemblyLinearVelocity
				local vector = Vector3.new(
					assemblyLinearVelocity.X,
					0,
					assemblyLinearVelocity.Z
				)
				local n7 = humanoid.WalkSpeed + n3
				local y = assemblyLinearVelocity.Y
				local flag3 = false

				if n7 < vector.Magnitude then
					vector = vector.Unit * n7
					flag3 = true
				end

				if n4 < y then
					y = n4
					flag3 = true
				end

				if flag3 then
					pcall(function()
						humanoidRootPart.AssemblyLinearVelocity =
							Vector3.new(vector.X, y, vector.Z)
					end)
				end
			end

			local function fn21()
				if not v14 or not v14.Parent then
					return
				end

				for _, descendant in ipairs(v14:GetDescendants()) do
					if tbl4[descendant.ClassName] then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end

			local function fn22()
				if not v14 or not v14.Parent then
					return
				end

				for _, descendant in ipairs(v14:GetDescendants()) do
					if
						descendant:IsA("AnimationConstraint")
						and not descendant.Enabled
					then
						pcall(function()
							descendant.Enabled = true
						end)
					end
				end
			end

			local function fn23()
				local v15 = fn16()

				if v15 and v15.controlsEnabled == false then
					pcall(function()
						v15:Enable()
					end)
				end
			end

			local function fn24()
				local currentCamera = Workspace.CurrentCamera

				if
					currentCamera
					and humanoid
					and currentCamera.CameraSubject ~= humanoid
				then
					pcall(function()
						currentCamera.CameraSubject = humanoid
					end)
				end
			end

			local function fn25()
				if
					not humanoid
					or not humanoid.Parent
					or humanoid.Health <= 0
				then
					return
				end

				if tbl5[humanoid:GetState()] then
					pcall(function()
						humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end

				if humanoid.PlatformStand then
					humanoid.PlatformStand = false
				end
			end

			local function fn26()
				if not v12 then
					return false
				end

				local ok2, result2 = pcall(function()
					return v12.IsInRagdoll()
				end)

				return ok2 and result2 == true
			end

			local function fn27()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end

			local function fn28()
				if
					not flag2
					or not v14
					or v14 ~= localPlayer.Character
					or not humanoid
					or not humanoid:IsDescendantOf(v14)
				then
					return
				end
				n5 = os.clock() + n2
				if connection then
					return
				end

				connection = runtime.Track(
					RunService.Heartbeat:Connect(runtime.Guard(function()
						if not flag2 then
							fn27()
							return
						end

						if
							v14 ~= localPlayer.Character
							or not humanoid
							or not humanoid:IsDescendantOf(v14)
						then
							fn27()
							return
						end
						fn20()
						fn21()
						fn22()
						fn25()
						fn23()
						fn24()

						if os.clock() > n5 or not fn26() then
							fn27()
						end
					end))
				)
			end

			local function fn29(arg)
				n6 += 1
				local v15 = n6
				fn17(tbl7)
				fn27()
				v14 = arg
				humanoid = nil
				if not flag2 or not arg then
					return
				end
				humanoid = arg:FindFirstChildOfClass("Humanoid")
					or arg:WaitForChild("Humanoid", 5)
				if
					not flag2
					or n6 ~= v15
					or arg ~= localPlayer.Character
					or not humanoid
					or not humanoid:IsA("Humanoid")
				then
					return
				end

				if humanoid then
					fn19(
						runtime.Track(
							humanoid.StateChanged:Connect(
								runtime.Guard(function(old, new)
									if flag2 and tbl5[new] then
										fn28()
									end
								end)
							)
						)
					)
				end

				fn19(
					runtime.Track(
						arg.DescendantAdded:Connect(
							runtime.Guard(function(descendant)
								if flag2 and tbl4[descendant.ClassName] then
									fn28()
								end
							end)
						)
					)
				)

				fn24()

				if fn26() then
					fn28()
				end
			end

			local function fn30()
				flag2 = false
				n6 += 1
				fn27()
				fn17(tbl7)
				fn17(tbl6)
				v14 = nil
				humanoid = nil
			end

			local function fn31()
				fn30()
				flag2 = true
				fn16()

				fn18(
					runtime.Track(
						localPlayer.CharacterAdded:Connect(
							runtime.Guard(function(character_)
								if flag2 then
									task.defer(function()
										if
											flag2
											and character_
												== localPlayer.Character
										then
											fn29(character_)
										end
									end)
								end
							end)
						)
					)
				)

				fn18(
					runtime.Track(
						localPlayer.CharacterRemoving:Connect(
							runtime.Guard(function(character_)
								if flag2 and character_ == v14 then
									n6 += 1
									fn27()
									fn17(tbl7)
									v14 = nil
									humanoid = nil
								end
							end)
						)
					)
				)

				fn18(
					runtime.Track(
						localPlayer
							:GetAttributeChangedSignal("RagdollEndTime")
							:Connect(runtime.Guard(function()
								if flag2 then
									fn28()
								end
							end))
					)
				)

				local packages = ReplicatedStorage:FindFirstChild("Packages")
				local net = packages and packages:FindFirstChild("Net")
				net = net
					and net:FindFirstChild("RE/CombatService/ApplyImpulse")

				if net then
					fn18(
						runtime.Track(
							net.OnClientEvent:Connect(runtime.Guard(function()
								if flag2 then
									fn20()
									fn28()
								end
							end))
						)
					)
				end

				if localPlayer.Character then
					fn29(localPlayer.Character)
				end
			end

			fn2(fn30)

			v6:CreateToggle({
				Name = "Anti Ragdoll",
				Default = false,
				Callback = function(arg)
					if arg then
						fn31()
					else
						fn30()
					end
				end,
			})
		end

		do
			local flag2 = false
			local n2 = 0
			local connection = nil
			local connection2 = nil
			local connection3 = nil
			local v12 = nil
			local tbl4 = {}

			local function fn16(arg)
				local character_ = localPlayer.Character
				character_ = character_
					and character_:FindFirstChildWhichIsA("Tool")
				if not character_ or not character_:IsA("Tool") then
					return false
				end
				local animation = arg.Animation
				local v13 = string.lower(tostring(arg.Name or ""))
				local v14 =
					string.lower(tostring(animation and animation.Name or ""))
				local priority = arg.Priority
				local flag3 = priority == Enum.AnimationPriority.Action
					or priority == Enum.AnimationPriority.Action2
					or priority == Enum.AnimationPriority.Action3
					or priority == Enum.AnimationPriority.Action4
				local flag4 = string.find(v13, "tool", 1, true) ~= nil
					or string.find(v13, "paint", 1, true) ~= nil
					or string.find(v13, "gun", 1, true) ~= nil
					or string.find(v14, "tool", 1, true) ~= nil
					or string.find(v14, "paint", 1, true) ~= nil
					or string.find(v14, "gun", 1, true) ~= nil
				return flag4 or flag3, flag4
			end

			local function fn17()
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end
			end

			local function fn18()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end
			end

			local function fn19(arg, arg2)
				local v13 = tbl4[arg]
				if not v13 then
					return
				end
				tbl4[arg] = nil

				if v13.WeightConnection then
					v13.WeightConnection:Disconnect()
				end

				if v13.StoppedConnection then
					v13.StoppedConnection:Disconnect()
				end

				if arg2 then
					pcall(function()
						if arg.IsPlaying then
							arg:AdjustWeight(v13.DesiredWeight, 0.1)
						end
					end)
				end
			end

			local function fn20(arg)
				local tbl5 = {}

				for k in pairs(tbl4) do
					tbl5[#tbl5 + 1] = k
				end

				for _, v13 in ipairs(tbl5) do
					fn19(v13, arg)
				end
			end

			local function fn21(arg)
				if not flag2 then
					return
				end
				local v13, v14 = fn16(arg)

				if v13 then
					if tbl4[arg] then
						fn19(arg, true)
					elseif v14 then
						pcall(function()
							if
								arg.IsPlaying
								and arg.WeightTarget <= 0
								and arg.WeightCurrent <= 0.01
							then
								arg:AdjustWeight(1, 0.05)
							end
						end)
					end

					return
				end

				if tbl4[arg] then
					return
				end
				local n3 = 1

				pcall(function()
					if arg.WeightTarget > 0 then
						n3 = arg.WeightTarget
					elseif arg.WeightCurrent > 0 then
						n3 = arg.WeightCurrent
					end
				end)

				local tbl5 = { Applying = false, DesiredWeight = n3 }
				tbl4[arg] = tbl5

				tbl5.WeightConnection = runtime.Track(
					arg:GetPropertyChangedSignal("WeightTarget")
						:Connect(runtime.Guard(function()
							if not flag2 or tbl5.Applying then
								return
							end

							if fn16(arg) then
								fn19(arg, true)
								return
							end

							pcall(function()
								local weightTarget = arg.WeightTarget

								if weightTarget > 0 then
									tbl5.DesiredWeight = weightTarget
								end

								tbl5.Applying = true
								arg:AdjustWeight(0, 0)
							end)

							tbl5.Applying = false
						end))
				)

				tbl5.StoppedConnection =
					runtime.Track(arg.Stopped:Connect(runtime.Guard(function()
						fn19(arg, false)
					end)))

				tbl5.Applying = true

				pcall(function()
					arg:AdjustWeight(0, 0)
				end)

				tbl5.Applying = false
			end

			local function fn22(arg)
				if not flag2 or arg ~= v12 then
					return
				end

				for _, v13 in ipairs(arg:GetPlayingAnimationTracks()) do
					fn21(v13)
				end
			end

			local function fn23(arg)
				fn17()
				fn18()
				fn20(arg)
				v12 = nil
			end

			local function fn24(arg)
				n2 += 1
				local v13 = n2

				task.spawn(function()
					local humanoid = arg:FindFirstChildOfClass("Humanoid")
						or arg:WaitForChild("Humanoid", 5)
					if
						not flag2
						or n2 ~= v13
						or arg ~= localPlayer.Character
						or not humanoid
					then
						return
					end
					local animator = humanoid:FindFirstChildOfClass("Animator")
						or humanoid:WaitForChild("Animator", 5)
					if
						not flag2
						or n2 ~= v13
						or arg ~= localPlayer.Character
						or not animator
					then
						return
					end
					fn23(false)
					v12 = animator
					fn22(animator)

					connection3 = runtime.Track(
						animator.AnimationPlayed:Connect(
							runtime.Guard(function(arg2)
								if flag2 and v12 == animator then
									fn21(arg2)
								end
							end)
						)
					)

					local function fn25(child)
						if not child:IsA("Tool") then
							return
						end

						task.defer(function()
							if
								flag2
								and n2 == v13
								and arg == localPlayer.Character
								and v12 == animator
							then
								fn22(animator)
							end
						end)
					end

					connection = runtime.Track(
						arg.ChildAdded:Connect(runtime.Guard(fn25))
					)
					connection2 = runtime.Track(
						arg.ChildRemoved:Connect(runtime.Guard(fn25))
					)
				end)
			end

			local connection4 = runtime.Track(
				localPlayer.CharacterAdded:Connect(
					runtime.Guard(function(character_)
						if flag2 then
							fn24(character_)
						end
					end)
				)
			)

			fn2(function()
				flag2 = false
				n2 += 1
				fn23(true)

				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end
			end)

			v6:CreateToggle({
				Name = "No Animation",
				Default = false,
				Callback = function(arg)
					flag2 = arg == true

					if flag2 then
						local character_ = localPlayer.Character

						if character_ then
							fn24(character_)
						end
					else
						n2 += 1
						fn23(true)
					end
				end,
			})
		end

		do
			local flag2 = false
			local n2 = 0
			local connection = nil
			local connection2 = nil
			local connection3 = nil
			local connection4 = nil
			local tbl4 = {}
			local tbl5 = {}
			local obj2 = setmetatable({}, { __mode = "k" })

			local function fn16(arg)
				local flag3 = arg and arg:GetAttribute("Web") == true
				local flag4

				if flag3 then
					local name = localPlayer.Name
					flag4 = arg:GetAttribute("WebTo") == name
				else
					flag4 = flag3
				end

				return flag4
			end

			local function fn17(arg, arg2)
				if not flag2 or not arg.Parent or arg2.Applying then
					return
				end
				local canCollide = false

				if fn16(arg2.OwnerPlayer) then
					canCollide = arg2.OriginalCanCollide
				end

				if arg.CanCollide ~= canCollide then
					arg2.Applying = true

					pcall(function()
						arg.CanCollide = canCollide
					end)

					arg2.Applying = false
				end
			end

			local function fn18(arg, arg2)
				local v12 = obj2[arg]
				if not v12 then
					return
				end
				obj2[arg] = nil

				if v12.CollisionConnection then
					v12.CollisionConnection:Disconnect()
				end

				if v12.DestroyingConnection then
					v12.DestroyingConnection:Disconnect()
				end

				if arg2 and arg.Parent then
					pcall(function()
						v12.Applying = true
						arg.CanCollide = v12.OriginalCanCollide
						v12.Applying = false
					end)
				end
			end

			local function fn19(arg, ownerPlayer)
				if not flag2 then
					return
				end
				local v12 = obj2[arg]

				if v12 then
					v12.OwnerPlayer = ownerPlayer
					fn17(arg, v12)
					return
				end

				local tbl6 = {
					Applying = false,
					OwnerPlayer = ownerPlayer,
					OriginalCanCollide = arg.CanCollide,
				}
				obj2[arg] = tbl6

				tbl6.CollisionConnection = runtime.Track(
					arg:GetPropertyChangedSignal("CanCollide")
						:Connect(runtime.Guard(function()
							if flag2 and not tbl6.Applying and arg.Parent then
								fn17(arg, tbl6)
							end
						end))
				)

				tbl6.DestroyingConnection = runtime.Track(
					arg.Destroying:Connect(runtime.Guard(function()
						fn18(arg, false)
					end))
				)

				fn17(arg, tbl6)
			end

			local function fn20(arg, ownerPlayer)
				if not flag2 then
					return
				end
				local v12 = obj2[arg]

				if not v12 then
					fn19(arg, ownerPlayer)
				else
					v12.OwnerPlayer = ownerPlayer
					fn17(arg, v12)
				end
			end

			local function fn21(arg, arg2)
				if arg.DescendantAddedConnection then
					arg.DescendantAddedConnection:Disconnect()
					arg.DescendantAddedConnection = nil
				end

				if arg.DescendantRemovingConnection then
					arg.DescendantRemovingConnection:Disconnect()
					arg.DescendantRemovingConnection = nil
				end

				local character_ = arg.Character
				arg.Character = nil
				if not character_ then
					return
				end
				local tbl6 = {}

				for k in pairs(obj2) do
					if k:IsDescendantOf(character_) then
						tbl6[#tbl6 + 1] = k
					end
				end

				for _, v12 in ipairs(tbl6) do
					fn18(v12, arg2)
				end
			end

			local function fn22(arg, character_)
				local v12 = tbl4[arg]
				if not flag2 or not v12 or arg == localPlayer then
					return
				end
				fn21(v12, false)
				v12.Character = character_

				for _, descendant in ipairs(character_:GetDescendants()) do
					if descendant:IsA("BasePart") then
						fn20(descendant, arg)
					end
				end

				v12.DescendantAddedConnection = runtime.Track(
					character_.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 and descendant:IsA("BasePart") then
								fn20(descendant, arg)
							end
						end)
					)
				)

				v12.DescendantRemovingConnection = runtime.Track(
					character_.DescendantRemoving:Connect(
						runtime.Guard(function(descendant)
							if descendant:IsA("BasePart") then
								fn18(descendant, false)
							end
						end)
					)
				)
			end

			local function fn23(arg)
				if not arg:IsA("Model") then
					return false
				end
				return string.sub(string.lower(arg.Name), -6) == "_clone"
			end

			local function fn24(arg, arg2)
				local v12 = tbl5[arg]
				if not v12 then
					return
				end
				tbl5[arg] = nil

				if v12.DestroyingConnection then
					v12.DestroyingConnection:Disconnect()
					v12.DestroyingConnection = nil
				end

				fn21(v12, arg2)
			end

			local function fn25(arg)
				if not flag2 or tbl5[arg] or not fn23(arg) then
					return
				end
				local tbl6 = { Character = arg }
				tbl5[arg] = tbl6

				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("BasePart") then
						fn20(descendant, nil)
					end
				end

				tbl6.DescendantAddedConnection = runtime.Track(
					arg.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag2 and descendant:IsA("BasePart") then
								fn20(descendant, nil)
							end
						end)
					)
				)

				tbl6.DescendantRemovingConnection = runtime.Track(
					arg.DescendantRemoving:Connect(
						runtime.Guard(function(descendant)
							if descendant:IsA("BasePart") then
								fn18(descendant, false)
							end
						end)
					)
				)

				tbl6.DestroyingConnection = runtime.Track(
					arg.Destroying:Connect(runtime.Guard(function()
						fn24(arg, false)
					end))
				)
			end

			local function fn26()
				for _, child in ipairs(Workspace:GetChildren()) do
					if fn23(child) then
						fn25(child)

						for _, descendant in ipairs(child:GetDescendants()) do
							if descendant:IsA("BasePart") then
								fn20(descendant, nil)
							end
						end
					end
				end

				local tbl6 = {}

				for k in pairs(tbl5) do
					if not k:IsDescendantOf(Workspace) then
						tbl6[#tbl6 + 1] = k
					end
				end

				for _, v12 in ipairs(tbl6) do
					fn24(v12, false)
				end
			end

			local function fn27(arg)
				for k, v12 in pairs(obj2) do
					if v12.OwnerPlayer == arg then
						fn17(k, v12)
					end
				end
			end

			local function fn28(arg, arg2)
				local v12 = tbl4[arg]
				if not v12 then
					return
				end
				tbl4[arg] = nil
				fn21(v12, arg2)

				if v12.CharacterAddedConnection then
					v12.CharacterAddedConnection:Disconnect()
				end

				if v12.CharacterRemovingConnection then
					v12.CharacterRemovingConnection:Disconnect()
				end

				if v12.WebConnection then
					v12.WebConnection:Disconnect()
				end

				if v12.WebTargetConnection then
					v12.WebTargetConnection:Disconnect()
				end
			end

			local function fn29(arg)
				if arg == localPlayer or tbl4[arg] then
					return
				end
				local tbl6 = {}
				tbl4[arg] = tbl6

				tbl6.WebConnection = runtime.Track(
					arg:GetAttributeChangedSignal("Web")
						:Connect(runtime.Guard(function()
							if flag2 then
								fn27(arg)
							end
						end))
				)

				tbl6.WebTargetConnection = runtime.Track(
					arg:GetAttributeChangedSignal("WebTo")
						:Connect(runtime.Guard(function()
							if flag2 then
								fn27(arg)
							end
						end))
				)

				tbl6.CharacterAddedConnection = runtime.Track(
					arg.CharacterAdded:Connect(
						runtime.Guard(function(character_)
							if flag2 then
								fn22(arg, character_)
							end
						end)
					)
				)

				tbl6.CharacterRemovingConnection = runtime.Track(
					arg.CharacterRemoving:Connect(
						runtime.Guard(function(character_)
							if tbl6.Character == character_ then
								fn21(tbl6, false)
							end
						end)
					)
				)

				if arg.Character then
					fn22(arg, arg.Character)
				end
			end

			local function fn30()
				flag2 = false
				n2 += 1

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if connection4 then
					connection4:Disconnect()
					connection4 = nil
				end

				local tbl6 = {}

				for k in pairs(tbl4) do
					tbl6[#tbl6 + 1] = k
				end

				for _, v12 in ipairs(tbl6) do
					fn28(v12, true)
				end

				local tbl7 = {}

				for k in pairs(tbl5) do
					tbl7[#tbl7 + 1] = k
				end

				for _, v12 in ipairs(tbl7) do
					fn24(v12, true)
				end

				local tbl8 = {}

				for k in pairs(obj2) do
					tbl8[#tbl8 + 1] = k
				end

				for _, v12 in ipairs(tbl8) do
					fn18(v12, true)
				end
			end

			local function fn31()
				n2 += 1
				local v12 = n2

				task.spawn(function()
					while flag2 and n2 == v12 do
						for _, player in ipairs(Players:GetPlayers()) do
							if player ~= localPlayer then
								pcall(function()
									fn29(player)
									local v13 = tbl4[player]
									local character_ = player.Character

									if v13 and character_ then
										if v13.Character ~= character_ then
											fn22(player, character_)
										else
											for _, descendant in
												ipairs(
													character_:GetDescendants()
												)
											do
												if
													descendant:IsA("BasePart")
												then
													fn20(descendant, player)
												end
											end
										end
									end
								end)
							end
						end

						fn26()
						task.wait(1)
					end
				end)
			end

			local function fn32()
				if flag2 then
					return
				end
				flag2 = true

				connection = runtime.Track(
					Players.PlayerAdded:Connect(runtime.Guard(function(player)
						fn29(player)

						task.defer(function()
							local v12 = tbl4[player]
							local character_ = player.Character

							if
								flag2
								and v12
								and character_
								and v12.Character ~= character_
							then
								fn22(player, character_)
							end
						end)
					end))
				)

				connection2 = runtime.Track(
					Players.PlayerRemoving:Connect(
						runtime.Guard(function(player)
							fn28(player, false)
						end)
					)
				)

				connection3 = runtime.Track(
					Workspace.ChildAdded:Connect(runtime.Guard(function(child)
						if flag2 and fn23(child) then
							fn25(child)
						end
					end))
				)

				connection4 = runtime.Track(
					Workspace.ChildRemoved:Connect(runtime.Guard(function(child)
						if tbl5[child] then
							fn24(child, false)
						end
					end))
				)

				for _, player in ipairs(Players:GetPlayers()) do
					fn29(player)
				end

				fn26()
				fn31()
			end

			fn2(fn30)

			v6:CreateToggle({
				Name = "Disable Player Collision",
				Note = "Lets you move through other players and player clones without being blocked.",
				Default = false,
				Callback = function(arg)
					if arg then
						fn32()
					else
						fn30()
					end
				end,
			})
		end

		local animationId
		animationId = "rbxassetid://18537363391"
		local n2
		n2 = 5
		local n3
		n3 = 1.5
		local n4
		n4 = 0.04
		local flag2, flag3, flag4, flag5, flag6, flag7, n5, n6, clone, humanoidRootPart
		local v12, n7

		do
			local n8 = 0.01
			flag2 = false
			flag3 = false
			flag4 = false
			flag5 = true
			flag6 = false
			flag7 = false
			n5 = 0.09
			n6 = 225
			clone = nil
			humanoidRootPart = nil
			v12 = nil
			local hipHeight = nil
			local v13 = nil
			local n9 = 0
			n7 = 0
			local n10 = 0
			local tbl4 = {}
			local v14 = nil
			local n11 = 0
			local v15 = nil
			local n12 = 0
			local n13 = 0
			local v16 = nil
			local n14 = 0
			local createSlider = nil

			local function fn16(arg)
				if arg and arg.Connected then
					arg:Disconnect()
				end
			end

			local function fn17()
				for _, v17 in ipairs(tbl4) do
					fn16(v17)
				end

				table.clear(tbl4)
			end

			local function fn18(arg)
				tbl4[#tbl4 + 1] = arg
				return arg
			end

			local function fn19(arg)
				if
					not arg
					or tbl2.ProtectedHumanoid ~= arg
					or arg.Health <= 0
				then
					return false
				end

				local ok, result = pcall(function()
					return arg.BreakJointsOnDeath == false
						and arg.RequiresNeck == false
						and arg:GetStateEnabled(Enum.HumanoidStateType.Dead)
							== false
				end)

				return ok and result == true
			end

			local function fn20(arg, arg2)
				for _, descendant in ipairs(arg:GetDescendants()) do
					if
						descendant:IsA("Weld")
						or descendant:IsA("WeldConstraint")
					then
						local part0 = descendant.Part0
						local part1 = descendant.Part1

						if not (part0 and not part0:IsDescendantOf(arg)) then
							local flag8 = part1
								and not part1:IsDescendantOf(arg)
							local v17 = nil
							local v18 = nil

							if flag8 then
								local v19 = part0
								part0 = part1
								part1 = v19
							else
								part0 = v17
								part1 = v18
							end
						end

						if
							part0
							and part0:IsA("BasePart")
							and part1
							and part1:IsA("BasePart")
							and part1:IsDescendantOf(arg)
							and (part0.Position - arg2.Position).Magnitude
								<= 5
						then
							return part0, part1
						end
					end
				end

				return nil
			end

			local function fn21(arg)
				if localPlayer:GetAttribute("Stealing") ~= true then
					return nil
				end
				local character_ = localPlayer.Character
				local tbl5 = { arg }

				if
					humanoidRootPart
					and humanoidRootPart.Parent
					and humanoidRootPart ~= arg
				then
					tbl5[#tbl5 + 1] = humanoidRootPart
				end

				local huge = math.huge
				local v17 = nil

				for _, child in ipairs(Workspace:GetChildren()) do
					if
						child:IsA("Model")
						and child ~= character_
						and not Players:GetPlayerFromCharacter(child)
						and child.Name:sub(-6) ~= "_Clone"
					then
						local rootPart = child:FindFirstChild("RootPart")
							or child.PrimaryPart
							or child:FindFirstChildWhichIsA("BasePart")

						if rootPart and rootPart:IsA("BasePart") then
							for i_, v18 in ipairs(tbl5) do
								local v19, v20 = fn20(child, v18)

								if v19 and v20 then
									local v21 = v18.CFrame:PointToObjectSpace(
										v19.Position
									)
									local magnitude = (
										v20.Position - v18.Position
									).Magnitude

									if
										math.abs(v21.X) <= 5
										and v21.Y >= -3
										and v21.Y <= 7
										and v21.Z >= -7
										and v21.Z <= 4
										and magnitude <= 14
									then
										local n15 = (
											v19.Position - v18.Position
										).Magnitude + magnitude * 0.05 + (i_ - 1) * 0.01

										if n15 < huge then
											huge = n15
											v17 = child
										end
									end
								end
							end
						end
					end
				end

				return v17
			end

			local function fn22()
				if
					localPlayer:GetAttribute("Stealing") == true
					and v15
					and v15.Parent
				then
					return v15
				end
				return nil
			end

			local function fn23()
				n12 += 1
				local v17 = n12
				v15 = nil
				v16 = nil
				if
					not flag
					or not flag3
					or not flag7
					or localPlayer:GetAttribute("Stealing") ~= true
				then
					return
				end

				task.spawn(function()
					while
						flag
						and v17 == n12
						and flag3
						and flag7
						and localPlayer:GetAttribute("Stealing") == true
					do
						local character_ = localPlayer.Character
						character_ = character_
							and character_:FindFirstChild("HumanoidRootPart")

						if character_ then
							local v18 = fn21(character_)
							if v18 then
								v15 = v18
								return
							end
						end

						task.wait(0.15)
					end
				end)
			end

			local function fn24(arg, arg2)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.IgnoreWater = true
				raycastParams.FilterDescendantsInstances =
					{ localPlayer.Character, arg2, humanoidRootPart }
				local hit = Workspace:Raycast(
					arg.Position + Vector3.new(0, 8, 0),
					Vector3.new(0, -50, 0),
					raycastParams
				)
				return hit and hit.Position.Y or nil
			end

			local function fn25(arg, arg2)
				return math.abs((arg - arg2 + 180) % 360 - 180)
			end

			local function fn26(arg, arg2)
				local v17 = fn22()
				if
					not v17
					or not humanoidRootPart
					or not humanoidRootPart.Parent
				then
					v16 = nil
					return
				end
				local v18 = fn24(arg, v17)
				if not v18 then
					return
				end

				local ok, result, result2 = pcall(function()
					local boundingBox, v19 = v17:GetBoundingBox()
					return boundingBox, v19
				end)

				if not ok or not result or not result2 then
					return
				end
				local tbl5 = {}

				for i_ = -1, 1, 2 do
					for i_2 = -1, 1, 2 do
						for i_3 = -1, 1, 2 do
							local n15 = #tbl5 + 1
							local cFrame = humanoidRootPart.CFrame
							local pointToObjectSpace = cFrame.PointToObjectSpace
							local v19 = result:PointToWorldSpace(
								Vector3.new(
									result2.X * 0.5 * i_,
									result2.Y * 0.5 * i_2,
									result2.Z * 0.5 * i_3
								)
							)
							tbl5[n15] = pointToObjectSpace(cFrame, v19)
						end
					end
				end

				local n15 = arg.CFrame
					- Vector3.new(
						0,
						arg2.HipHeight + arg.Size.Y * 0.5 - 1 + n5,
						0
					)
				local n16 = n6 % 360
				local huge = math.huge
				local v19 = n16

				for i_ = 0, 13 do
					local n17 = 217 + i_
					local n18 = n15 * CFrame.Angles(math.rad(n17), 0, 0)
					local tbl6 = {}
					local n19 = -math.huge

					for _, v20 in ipairs(tbl5) do
						local y = n18:PointToWorldSpace(v20).Y
						tbl6[#tbl6 + 1] = y

						if n19 < y then
							n19 = y
						end
					end

					local n20 = n19 - v18
					local v20, v21, v22 = ipairs(tbl6)
					local n21 = 0
					local n22 = 0
					local n23 = 0

					for _, v23 in v20, v21, v22 do
						local n24 = v23 - v18

						if n8 < n24 then
							n21 += 1
							n22 += n24
						end

						if n19 - v23 <= 0.035 then
							n23 += 1
						end
					end

					local n24

					if n21 == 0 then
						n24 = n20 * 100 + fn25(n17, n16) * 0.001
					else
						n24 = n21 * 1000
							+ n23 * 100
							+ math.max(n20, 0) * 50
							+ n22 * 10
							+ fn25(n17, n16) * 0.001
					end

					if n24 < huge then
						huge = n24
						v19 = n17
					end
				end

				v16 = v19
			end

			local function fn27(arg, arg2, arg3)
				return (arg + ((arg2 - arg + 180) % 360 - 180) * arg3) % 360
			end

			local function fn28()
				local v17 = Workspace:FindFirstChild(localPlayer.Name)
				if not v17 then
					return
				end
				local doubleRig = v17:FindFirstChild("DoubleRig")

				if doubleRig then
					doubleRig:Destroy()
				end

				local constraints = v17:FindFirstChild("Constraints")

				if constraints then
					constraints:Destroy()
				end

				fn18(
					runtime.Track(
						v17.ChildAdded:Connect(runtime.Guard(function(child)
							if
								child.Name == "DoubleRig"
								or child.Name == "Constraints"
							then
								task.defer(function()
									if flag3 and child.Parent then
										child:Destroy()
									end
								end)
							end
						end))
					)
				)
			end

			local function fn29()
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				if not character_ or not humanoid or not fn19(humanoid) then
					return false
				end
				hipHeight = humanoid.HipHeight
				humanoidRootPart = character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart or not humanoidRootPart.Parent then
					return false
				end
				v12 = character_
				local model = Instance.new("Model")
				model.Parent = game
				character_.Parent = model
				clone = humanoidRootPart:Clone()
				clone.Parent = character_
				humanoidRootPart.Parent = Workspace.CurrentCamera
				clone.CFrame = humanoidRootPart.CFrame
				character_.PrimaryPart = clone
				character_.Parent = Workspace

				for _, descendant in ipairs(character_:GetDescendants()) do
					if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
						if descendant.Part0 == humanoidRootPart then
							descendant.Part0 = clone
						end

						if descendant.Part1 == humanoidRootPart then
							descendant.Part1 = clone
						end
					end
				end

				model:Destroy()
				return true
			end

			local function fn30()
				local v17 = v12
				if
					not humanoidRootPart
					or not humanoidRootPart:IsDescendantOf(game)
					or not v17
				then
					return false
				end

				if v17 ~= localPlayer.Character or v17.Parent ~= Workspace then
					if clone and clone.Parent then
						pcall(function()
							clone:Destroy()
						end)
					end

					if humanoidRootPart and humanoidRootPart.Parent then
						pcall(function()
							humanoidRootPart:Destroy()
						end)
					end

					return false
				end

				local ok = pcall(function()
					local model = Instance.new("Model")
					model.Parent = game
					v17.Parent = model
					humanoidRootPart.Parent = v17
					v17.PrimaryPart = humanoidRootPart
					v17.Parent = Workspace
					humanoidRootPart.CanCollide = true

					for _, descendant in ipairs(v17:GetDescendants()) do
						if
							descendant:IsA("Weld") or descendant:IsA("Motor6D")
						then
							if descendant.Part0 == clone then
								descendant.Part0 = humanoidRootPart
							end

							if descendant.Part1 == clone then
								descendant.Part1 = humanoidRootPart
							end
						end
					end

					if clone then
						local cFrame = clone.CFrame
						clone:Destroy()
						clone = nil
						humanoidRootPart.CFrame = cFrame
					end

					local humanoid = v17:FindFirstChildOfClass("Humanoid")

					if humanoid and hipHeight ~= nil then
						humanoid.HipHeight = hipHeight
					end

					model:Destroy()
				end)

				if not ok and humanoidRootPart and humanoidRootPart.Parent then
					pcall(function()
						humanoidRootPart:Destroy()
					end)
				end

				return ok
			end

			local fn31 = nil

			fn31 = function()
				if not flag3 then
					return
				end
				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				if not character_ or not humanoid or humanoid.Health <= 0 then
					return
				end
				local animation = Instance.new("Animation")
				animation.AnimationId = animationId
				local v17 = (
					humanoid:FindFirstChildOfClass("Animator")
					or Instance.new("Animator", humanoid)
				):LoadAnimation(animation)
				animation:Destroy()
				v13 = v17
				v17.Priority = Enum.AnimationPriority.Action4
				v17:Play(0, 1, 0)

				fn18(runtime.Track(v17.Stopped:Connect(runtime.Guard(function()
					if flag3 and v13 == v17 then
						fn31()
					end
				end))))

				task.defer(function()
					if flag3 and v13 == v17 then
						pcall(function()
							v17.TimePosition = 0.7
						end)

						task.delay(1, function()
							if flag3 and v13 == v17 then
								pcall(function()
									v17:AdjustSpeed(math.huge)
								end)
							end
						end)
					end
				end)
			end

			local flag8 = false

			local function fn32(arg)
				if arg ~= false then
					n7 += 1
					flag8 = false
				end

				n9 += 1
				n10 += 1
				flag3 = false
				n12 += 1
				v15 = nil
				v16 = nil
				n13 = 0
				v14 = nil

				if v13 then
					pcall(function()
						v13:Stop()
					end)

					pcall(function()
						v13:Destroy()
					end)

					v13 = nil
				end

				fn17()
				fn30()
				clone = nil
				humanoidRootPart = nil
				v12 = nil
				hipHeight = nil
			end

			local fn33 = nil

			local function fn34()
				if flag8 then
					return
				end
				flag8 = true
				n7 += 1
				local v17 = n7

				task.spawn(function()
					fn32(false)
					local character_ = localPlayer.Character

					if character_ then
						character_ = character_.PrimaryPart
							or character_:FindFirstChild("HumanoidRootPart")
					end

					character_ = character_ and character_.Position or nil
					local now = os.clock()
					local n15 = 0

					while true do
						if
							flag
							and v17 == n7
							and flag2
							and os.clock() - now < 3.5
						then
							local result = RunService.Heartbeat:Wait()

							if not (v17 ~= n7 or not flag2) then
								local character_2 = localPlayer.Character
								local primaryPart = character_2
									and (
										character_2.PrimaryPart
										or character_2:FindFirstChild(
											"HumanoidRootPart"
										)
									)
								character_2 = character_2
									and character_2:FindFirstChildOfClass(
										"Humanoid"
									)

								if
									primaryPart
									and character_2
									and character_2.Health > 0
								then
									local position = primaryPart.Position

									if character_ then
										if
											(position - character_).Magnitude
											> 4
										then
											n15 = 0
											character_ = position
											continue
										else
											n15 += result
											local n16 = os.clock() - now
											if
												not (n15 >= 0.6 and n16 >= 0.7)
											then
												character_ = position
												continue
											end
										end
									else
										character_ = position
										continue
									end
								else
									n15 = 0
									continue
								end
							end
						end

						break
					end

					flag8 = false

					if v17 == n7 and flag and flag2 then
						if fn33 then
							fn33()
						end
					end
				end)
			end

			fn33 = function()
				if flag3 then
					return true
				end

				if humanoidRootPart or clone or v12 then
					fn32()
				end

				local character_ = localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart2 = character_
					and character_:FindFirstChild("HumanoidRootPart")
				if
					not character_
					or character_.Parent ~= Workspace
					or not humanoid
					or humanoid.Health <= 0
					or not humanoidRootPart2
					or humanoidRootPart2.Parent ~= character_
					or character_.PrimaryPart ~= humanoidRootPart2
				then
					return false
				end
				n9 += 1
				local v17 = n9
				fn17()
				fn28()
				if not fn29() then
					fn17()
					return false
				end
				flag3 = true
				task.wait(0.1)
				if v17 ~= n9 or not flag3 then
					return false
				end
				fn31()
				fn23()

				fn18(
					runtime.Track(
						RunService.PreSimulation:Connect(
							runtime.Guard(function()
								local character_2 = localPlayer.Character
								local humanoid2 = character_2
									and character_2:FindFirstChildOfClass(
										"Humanoid"
									)
								character_2 = character_2
									and character_2.PrimaryPart
								if
									not flag3
									or not humanoid2
									or humanoid2.Health <= 0
									or not humanoidRootPart
									or not humanoidRootPart.Parent
									or not character_2
								then
									return
								end

								if
									flag7
									and localPlayer:GetAttribute("Stealing")
										== true
								then
									local now = os.clock()

									if n4 <= now - n13 then
										n13 = now
										fn26(character_2, humanoid2)
									end

									if v16 ~= nil then
										n6 = fn27(n6, v16, 0.42)
									end

									if createSlider and now >= n14 then
										n14 = now + 0.1
										createSlider:Set(
											math.floor(n6 + 0.5),
											false
										)
									end
								else
									v15 = nil
									v16 = nil
								end

								local cframe = CFrame.Angles
								humanoidRootPart.CFrame = (
									character_2.CFrame
									- Vector3.new(
										0,
										humanoid2.HipHeight
											+ character_2.Size.Y * 0.5
											- 1
											+ n5,
										0
									)
								) * cframe(math.rad(n6), 0, 0)
								humanoidRootPart.Velocity = character_2.Velocity
								humanoidRootPart.CanCollide = false
							end)
						)
					)
				)

				v14 = nil

				fn18(
					runtime.Track(
						RunService.PreAnimation:Connect(runtime.Guard(function()
							if
								not flag3
								or not humanoidRootPart
								or not humanoidRootPart.Parent
							then
								v14 = nil
								return
							end
							local position = humanoidRootPart.Position

							if v14 then
								local magnitude = (position - v14).Magnitude
								local now = os.clock()

								if magnitude > n2 and now - n11 > n3 then
									n11 = now

									if flag5 then
										v.Notify(
											"Lagback detected",
											"Invisible position was corrected by the server.",
											5
										)
									end

									if flag6 then
										fn34()
									end
								end
							end

							v14 = position
						end))
					)
				)

				return true
			end

			local function fn35(arg, arg2)
				n10 += 1
				local v17 = n10

				task.spawn(function()
					if arg2 and arg2 > 0 then
						task.wait(arg2)
					end

					for i_ = 1, 50 do
						if
							not flag
							or v17 ~= n10
							or not flag2
							or arg ~= localPlayer.Character
						then
							return
						end
						local humanoid = arg
							and arg:FindFirstChildOfClass("Humanoid")
						local humanoidRootPart2 = arg
							and arg:FindFirstChild("HumanoidRootPart")

						if
							humanoid
							and fn19(humanoid)
							and humanoidRootPart2
							and humanoidRootPart2.Parent == arg
						then
							if fn33() then
								return
							end
						end

						task.wait(0.1)
					end
				end)
			end

			local v17 = v7:CreateToggle({
				Name = "Invisible",
				Default = false,
				Keybind = Enum.KeyCode.U,
				Callback = function(arg)
					flag2 = arg == true

					if flag2 then
						fn35(localPlayer.Character, 0.15)
					else
						fn32()
					end
				end,
			})

			local function fn36()
				if not flag4 or not v17 then
					return
				end
				local flag9 = localPlayer:GetAttribute("Stealing") == true
				if v17:Get() ~= flag9 then
					v17:Set(flag9, true)
					return
				end

				if flag9 then
					flag2 = true

					if not flag3 then
						fn35(localPlayer.Character, 0.05)
					end
				elseif
					flag2
					or flag3
					or humanoidRootPart ~= nil
					or clone ~= nil
				then
					flag2 = false
					fn32()
				end
			end

			v7:CreateToggle({
				Name = "Auto Invisible On Steal",
				Default = false,
				Callback = function(arg)
					flag4 = arg == true

					if flag4 then
						fn36()
					end
				end,
			})

			v7:CreateToggle({
				Name = "Auto Rotation",
				Default = false,
				Callback = function(arg)
					flag7 = arg == true
					n13 = 0
					fn23()
				end,
			})

			createSlider = v7.CreateSlider

			createSlider = createSlider(v7, {
				Name = "Rotation",
				Min = 180,
				Max = 300,
				Default = 279,
				AllowDecimals = false,
				Increment = 1,
				Callback = function(arg)
					n6 = math.clamp(
						math.floor((tonumber(arg) or 225) + 0.5),
						180,
						300
					)
				end,
			})

			v7:CreateSlider({
				Name = "Depth",
				Min = 0,
				Max = 0.7,
				Default = 0.12,
				AllowDecimals = true,
				DecimalPlaces = 2,
				Increment = 0.01,
				Callback = function(arg)
					n5 = math.clamp(tonumber(arg) or 0.09, 0, 0.7)
				end,
			})

			v7:CreateToggle({
				Name = "Lagback Detect",
				Default = false,
				Callback = function(arg)
					flag5 = arg == true
				end,
			})

			v7:CreateToggle({
				Name = "Auto Fix Lagback",
				Default = false,
				Callback = function(arg)
					flag6 = arg == true

					if not flag6 then
						n7 += 1
						flag8 = false
					end
				end,
			})

			tbl.IsActive = function()
				return flag3 == true
			end

			tbl.GetDrop = function()
				local character_ = v12 or localPlayer.Character
				local humanoid = character_
					and character_:FindFirstChildOfClass("Humanoid")

				if character_ then
					character_ = character_.PrimaryPart
						or character_:FindFirstChild("HumanoidRootPart")
				end

				return (
					humanoid
						and humanoid.HipHeight
						and humanoid.HipHeight > 0
						and humanoid.HipHeight
					or 2
				)
					+ (character_ and character_.Size and character_.Size.Y or 2) * 0.5
					- 1
					+ n5
			end

			tbl.SuspendForReset = function(arg)
				local v18 = v12
				local v19

				if v12 then
					v19 = arg
				else
					v19 = v18
				end

				if v19 and arg ~= v12 then
					return false
				end
				local flag9 = flag3 or humanoidRootPart ~= nil or clone ~= nil

				if flag9 then
					fn32()
				end

				return flag9
			end

			tbl.ResumeIfRequested = function(arg)
				if flag2 and arg == localPlayer.Character then
					fn35(arg, 0.05)
				end
			end

			local connection = runtime.Track(
				localPlayer
					:GetAttributeChangedSignal("Stealing")
					:Connect(runtime.Guard(function()
						fn36()
						fn23()
					end))
			)

			local connection2 = runtime.Track(
				localPlayer.CharacterRemoving:Connect(
					runtime.Guard(function(character_)
						if
							character_ == localPlayer.Character
							or character_ == v12
						then
							fn32()
						end
					end)
				)
			)

			local connection3 = runtime.Track(
				localPlayer.CharacterAdded:Connect(
					runtime.Guard(function(character_)
						if v12 and v12 ~= character_ then
							fn32()
						end

						if flag2 then
							fn35(character_, 0.35)
						end
					end)
				)
			)

			fn2(function()
				flag2 = false
				flag4 = false
				flag8 = false
				fn32()
				fn16(connection)
				fn16(connection2)
				fn16(connection3)
				tbl.SuspendForReset = nil
				tbl.ResumeIfRequested = nil
				tbl.IsActive = nil
				tbl.GetDrop = nil
			end)
		end

		do
			local flag8 = true
			local flag9 = false
			local flag10 = true
			local flag11 = false
			local flag12 = false
			local v13 = nil
			local v14 = nil
			local flag13 = false
			local tbl4 = {}
			local connection = nil
			local chilliFastResetRuntime =
				CoreGui:FindFirstChild("__Nullx11BrainrotFastResetRuntime")

			if chilliFastResetRuntime then
				local cleanup = chilliFastResetRuntime:FindFirstChild("Cleanup")

				if cleanup and cleanup:IsA("BindableEvent") then
					pcall(function()
						cleanup:Fire()
					end)
				end

				pcall(function()
					chilliFastResetRuntime:Destroy()
				end)
			end

			local folder = Instance.new("Folder")
			folder.Name = "__Nullx11BrainrotFastResetRuntime"
			folder.Archivable = false
			folder.Parent = CoreGui
			local bindableEvent = Instance.new("BindableEvent")
			bindableEvent.Name = "Cleanup"
			bindableEvent.Parent = folder

			local function fn16()
				for _, v15 in ipairs(tbl4) do
					if v15.Connected then
						v15:Disconnect()
					end
				end

				table.clear(tbl4)
			end

			local function fn17()
				return localPlayer:GetAttribute("ChilliDropBrainrotActive")
					== true
			end

			local function fn18(arg, arg2)
				if not flag8 or flag9 then
					return false
				end
				local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
				if
					not arg
					or arg ~= localPlayer.Character
					or not humanoid
					or not arg2 and humanoid.Health <= 0
				then
					return false
				end
				local flag14 = false

				if type(tbl.SuspendForReset) == "function" then
					local result
					flag14, result = pcall(tbl.SuspendForReset, arg)
					flag14 = flag14 and result == true
				end

				local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

				if not humanoidRootPart2 then
					if flag14 and type(tbl.ResumeIfRequested) == "function" then
						tbl.ResumeIfRequested(arg)
					end

					return false
				end

				flag9 = true
				local v15 = arg

				task.spawn(function()
					local cFrame = humanoidRootPart2.CFrame
					local assemblyLinearVelocity =
						humanoidRootPart2.AssemblyLinearVelocity
					local assemblyAngularVelocity =
						humanoidRootPart2.AssemblyAngularVelocity
					local health = humanoid.Health
					local flag15 = true

					pcall(function()
						flag15 = humanoid:GetStateEnabled(
							Enum.HumanoidStateType.Dead
						)
						humanoid:SetStateEnabled(
							Enum.HumanoidStateType.Dead,
							false
						)

						if humanoid.Health <= 0 then
							humanoid.Health = math.max(humanoid.MaxHealth, 1)
						end
					end)

					local connection2 = runtime.Track(
						humanoid.HealthChanged:Connect(
							runtime.Guard(function(health2)
								if
									flag8
									and flag9
									and localPlayer.Character == v15
									and health2 <= 0
								then
									pcall(function()
										humanoid.Health = math.max(
											humanoid.MaxHealth,
											health,
											1
										)
									end)
								end
							end)
						)
					)

					local cFrame2 = cFrame + Vector3.new(0, 31000, 0)

					while flag8 and localPlayer.Character == v15 do
						if humanoidRootPart2.Parent then
							pcall(function()
								humanoidRootPart2.CFrame = cFrame2
							end)
						end

						if humanoid.Parent and humanoid.Health <= 0 then
							pcall(function()
								humanoid.Health =
									math.max(humanoid.MaxHealth, health, 1)
							end)
						end

						task.wait()
					end

					local flag16 = localPlayer.Character ~= v15
					connection2:Disconnect()

					if not flag16 then
						if humanoidRootPart2.Parent then
							pcall(function()
								humanoidRootPart2.CFrame = cFrame
								humanoidRootPart2.AssemblyLinearVelocity =
									assemblyLinearVelocity
								humanoidRootPart2.AssemblyAngularVelocity =
									assemblyAngularVelocity
							end)
						end

						if humanoid.Parent then
							pcall(function()
								humanoid:SetStateEnabled(
									Enum.HumanoidStateType.Dead,
									flag15
								)

								if health > 0 and humanoid.Health <= 0 then
									humanoid.Health = health
								end
							end)
						end
					end

					flag9 = false
				end)

				return true
			end

			local function fn19()
				return fn18(localPlayer.Character, false)
			end

			local function fn20()
				if not flag8 or not flag11 or flag12 then
					return
				end
				flag12 = true

				task.spawn(function()
					for i_ = 1, 20 do
						if not (not flag8 or not flag11 or flag9) then
							if not fn18(localPlayer.Character, false) then
								task.wait(0.05)
								continue
							end
						end

						break
					end

					flag12 = false
				end)
			end

			local function fn21()
				if
					flag13
					and v13
					and v14
					and type(hookfunction) == "function"
				then
					pcall(function()
						hookfunction(v13, v14)
					end)
				end

				flag13 = false
				v13 = nil
				v14 = nil
			end

			local function fn22()
				if flag13 then
					return true
				end

				if type(hookfunction) ~= "function" then
					return false
				end

				local ok, result = pcall(function()
					return require(
						ReplicatedStorage.Datas.AdminCommands.balloon
					).effects.Victim
				end)

				if not ok or type(result) ~= "function" then
					return false
				end
				v13 = result
				local v15 = nil

				local ok2, result2 = pcall(function()
					return hookfunction(result, function(...)
						local v16 = table.pack(v15(...))

						if flag8 and flag11 then
							task.defer(fn20)
						end

						return table.unpack(v16, 1, v16.n)
					end)
				end)

				if not ok2 or type(result2) ~= "function" then
					v13 = nil
					return false
				end
				v15 = result2
				v14 = result2
				flag13 = true
				return true
			end

			local function fn23(arg)
				flag11 = arg == true
				flag12 = false

				if flag11 then
					if not fn22() then
						flag11 = false
					end
				else
					fn21()
				end
			end

			local function fn24(arg)
				fn16()
				if not flag8 or not flag10 or not arg then
					return
				end

				task.spawn(function()
					local humanoid = arg:FindFirstChildOfClass("Humanoid")
						or arg:WaitForChild("Humanoid", 5)
					if
						not flag8
						or not flag10
						or not humanoid
						or arg ~= localPlayer.Character
					then
						return
					end
					local flag14 = false
					local flag15 = false

					local function fn25()
						local v15 = flag14
						local v16

						if flag14 then
							v16 = v15
						else
							v16 = flag15
						end

						if
							v16
							or flag9
							or arg ~= localPlayer.Character
							or fn17()
						then
							return
						end
						flag15 = true
						local rescueSerial = tbl2.RescueSerial

						task.defer(function()
							flag15 = false
							if
								flag14
								or flag9
								or arg ~= localPlayer.Character
								or fn17()
								or not humanoid.Parent
							then
								return
							end

							if
								tbl2.ProtectedHumanoid == humanoid
								and (
									humanoid.Health > 0
									or tbl2.RescueSerial ~= rescueSerial
								)
							then
								return
							end

							if humanoid.Health > 0 then
								return
							end
							flag14 = fn18(arg, true) == true
						end)
					end

					tbl4[#tbl4 + 1] = runtime.Track(
						humanoid.HealthChanged:Connect(
							runtime.Guard(function(health)
								if health <= 0 then
									fn25()
								end
							end)
						)
					)

					tbl4[#tbl4 + 1] = runtime.Track(
						humanoid.Died:Connect(runtime.Guard(fn25))
					)
				end)
			end

			local function fn25(arg)
				flag10 = arg == true

				if flag10 then
					fn24(localPlayer.Character)
				else
					fn16()
				end
			end

			local function fn26()
				if not flag8 then
					return
				end
				flag8 = false
				flag9 = false
				flag10 = false
				flag11 = false
				flag12 = false
				fn16()
				fn21()

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end

			connection = runtime.Track(
				localPlayer.CharacterAdded:Connect(
					runtime.Guard(function(character_)
						flag9 = false

						if flag10 then
							fn24(character_)
						end
					end)
				)
			)

			runtime.Track(bindableEvent.Event:Connect(runtime.Cleanup(fn26)))
			runtime.Track(folder.Destroying:Connect(runtime.Guard(fn26)))
			v8:CreateButton({
				Name = "Fast Reset",
				ButtonText = "Reset",
				Callback = fn19,
			})
			v8:CreateToggle({
				Name = "Auto Fast Reset",
				Default = false,
				Callback = fn25,
			})
			v8:CreateToggle({
				Name = "Auto Reset Balloon",
				Default = false,
				Callback = fn23,
			})
			fn24(localPlayer.Character)
		end

		local v13
		v13 = esp:CreateSection({ Name = "Player ESP", Expanded = false })
		v9 = esp:CreateSection({ Name = "Brainrot ESP", Expanded = false })
		v10 = esp:CreateSection({
			Name = "Brainrot Notifications",
			Expanded = false,
		})
		v11 = esp:CreateSection({ Name = "Base ESP", Expanded = false })

		fn4 = function()
			if type(gethui) == "function" then
				local ok, result = pcall(gethui)
				if ok and typeof(result) == "Instance" then
					return result
				end
			end

			return CoreGui
		end

		fn5 = function(name)
			local v14 = fn4()
			local tbl4 = {}

			for _, v15 in ipairs({ v14, CoreGui }) do
				if v15 and not tbl4[v15] then
					tbl4[v15] = true
					local v16 = v15:FindFirstChild(name)

					if v16 then
						local cleanup = v16:FindFirstChild("Cleanup")

						if cleanup and cleanup:IsA("BindableEvent") then
							pcall(function()
								cleanup:Fire()
							end)
						end

						pcall(function()
							v16:Destroy()
						end)
					end
				end
			end

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = name
			screenGui.Archivable = false
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.DisplayOrder = 48
			screenGui.Parent = v14
			local bindableEvent = Instance.new("BindableEvent")
			bindableEvent.Name = "Cleanup"
			bindableEvent.Parent = screenGui
			return screenGui, bindableEvent
		end

		fn6 = function(arg)
			for _, v14 in ipairs(arg) do
				if typeof(v14) == "RBXScriptConnection" then
					v14:Disconnect()
				end
			end

			table.clear(arg)
		end

		fn7 = function()
			local v14 = Workspace:FindFirstChild(localPlayer.Name)
			if not v14 or not v14:IsA("Model") then
				return nil
			end
			local humanoidRootPart2 = v14:FindFirstChild("HumanoidRootPart")
			if
				humanoidRootPart2
				and humanoidRootPart2:IsA("BasePart")
				and humanoidRootPart2.Parent == v14
			then
				return humanoidRootPart2
			end
			local hitbox = v14:FindFirstChild("__HITBOX")
				or v14:FindFirstChild("__hitbox")
				or v14:FindFirstChild("Hitbox")
				or v14:FindFirstChild("HitBox")
			if hitbox and hitbox:IsA("BasePart") then
				return hitbox
			end
			return nil
		end

		fn8 = function(arg)
			arg = arg and arg:FindFirstChild("PlotSign")
			if not arg then
				return nil
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					local str = tostring(descendant.Text or "")
					if
						str ~= ""
						and string.lower(str) ~= "your base"
						and string.find(string.lower(str), "base", 1, true)
					then
						return descendant
					end
				end
			end

			return nil
		end

		local fn16

		fn16 = function(arg)
			local str = fn8(arg)

			if str then
				str = tostring(str.Text or "")
			end

			str = str or ""
			return str ~= "" and str or "Base"
		end

		fn9 = function(arg)
			local v14 = string.lower(fn16(arg))
			return string.find(v14, string.lower(localPlayer.Name), 1, true)
					~= nil
				or string.find(
						v14,
						string.lower(localPlayer.DisplayName),
						1,
						true
					)
					~= nil
		end

		local fn17
		local n8 = 12

		fn17 = function(arg)
			if not arg then
				return nil
			end
			local animalPodiums = arg:FindFirstChild("AnimalPodiums")
			local huge = math.huge
			local n9 = -math.huge
			local n10 = -math.huge
			local huge2 = math.huge
			local huge3 = math.huge

			if animalPodiums then
				for _, child in ipairs(animalPodiums:GetChildren()) do
					local base = child:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")

					if base and base:IsA("BasePart") then
						local position = base.Position
						huge3 = math.min(huge3, position.X)
						n10 = math.max(n10, position.X)
						huge = math.min(huge, position.Z)
						n9 = math.max(n9, position.Z)
						huge2 = math.min(huge2, position.Y)
					end
				end
			end

			local stealHitbox = arg:FindFirstChild("StealHitbox")
			local x, z

			if stealHitbox and stealHitbox:IsA("BasePart") then
				x = stealHitbox.Position.X
				z = stealHitbox.Position.Z

				if huge2 == math.huge then
					huge2 = stealHitbox.Position.Y - stealHitbox.Size.Y * 0.5
				end
			elseif huge3 ~= math.huge then
				x = (huge3 + n10) * 0.5
				z = (huge + n9) * 0.5
			else
				local mainRoot = arg:FindFirstChild("MainRoot")
				local isBasePart = mainRoot and mainRoot:IsA("BasePart")
				z = nil
				x = nil

				if isBasePart then
					x = mainRoot.Position.X
					z = mainRoot.Position.Z
					huge2 = mainRoot.Position.Y
				end
			end

			if not x or huge2 == math.huge then
				return nil
			end
			return Vector3.new(x, huge2 + n8, z)
		end

		local fn18

		fn18 = function(arg)
			return arg
				and arg:IsA("BasePart")
				and (
					arg.Name == "PlotSign"
					or arg.Name == "MainRoot"
					or arg.Name == "Spawn"
				)
		end

		tbl3 = { YourBaseClear = false, ClearBaseTransparency = 0.8 }
		local tbl4 = {}

		fn10 = function(arg)
			tbl4[#tbl4 + 1] = arg
		end

		fn11 = function(arg, arg2)
			if tbl3[arg] == arg2 then
				return
			end
			tbl3[arg] = arg2

			for _, v14 in ipairs(tbl4) do
				pcall(v14, arg, arg2)
			end
		end

		do
			local v14 = nil

			local ok, result = pcall(function()
				return require(ReplicatedStorage.Datas.Index)
			end)

			if ok and type(result) == "table" then
				v14 = result
			end

			fn12 = function(arg)
				local tbl5 = {}
				local v15 = v14 and v14[arg]
				if not v15 then
					return tbl5
				end

				if type(v15.BaseColors) == "table" then
					for _, baseColor in pairs(v15.BaseColors) do
						if typeof(baseColor) == "Color3" then
							tbl5[#tbl5 + 1] = baseColor
						end
					end
				end

				if #tbl5 == 0 and typeof(v15.MainColor) == "Color3" then
					tbl5[#tbl5 + 1] = v15.MainColor
				end

				return tbl5
			end
		end

		local n9
		n9 = 5
		local n10
		n10 = 12
		local n11
		n11 = 4.5
		local tbl5
		tbl5 =
			{ "HumanoidRootPart", "LowerTorso", "UpperTorso", "Torso", "Head" }
		local font
		font = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Italic
		)
		local n12
		n12 = 0.25
		local transparency
		transparency = 0
		local tbl6

		tbl6 = {
			Head = true,
			Torso = true,
			UpperTorso = true,
			LowerTorso = true,
			["Left Arm"] = true,
			["Right Arm"] = true,
			["Left Leg"] = true,
			["Right Leg"] = true,
			LeftUpperArm = true,
			LeftLowerArm = true,
			LeftHand = true,
			RightUpperArm = true,
			RightLowerArm = true,
			RightHand = true,
			LeftUpperLeg = true,
			LeftLowerLeg = true,
			LeftFoot = true,
			RightUpperLeg = true,
			RightLowerLeg = true,
			RightFoot = true,
		}

		local font2
		font2 = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.ExtraBold,
			Enum.FontStyle.Normal
		)
		local v14

		do
			local colorSequence = ColorSequence.new
			local tbl7 = {}
			local v15 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 255, 205))
			local v16 =
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 225, 255))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl7[1] = v15
			tbl7[2] = v16

			do
				local values = table.pack(new(1, color(210, 135, 255)))
				table.move(values, 1, values.n, 3, tbl7)
			end

			v14 = colorSequence(tbl7)
		end

		local colorSequence

		do
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			colorSequence = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 73, 66)),
				new(1, color(35, 17, 79)),
			})
		end

		local v15

		do
			local colorSequence2 = ColorSequence.new
			local tbl7 = {}
			local v16 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
			local v17 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl7[1] = v16
			tbl7[2] = v17

			do
				local values = table.pack(new(1, color(184, 0, 18)))
				table.move(values, 1, values.n, 3, tbl7)
			end

			v15 = colorSequence2(tbl7)
		end

		local v16

		do
			local colorSequence2 = ColorSequence.new
			local tbl7 = {}
			local v17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
			local v18 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl7[1] = v17
			tbl7[2] = v18

			do
				local values = table.pack(new(1, color(18, 0, 3)))
				table.move(values, 1, values.n, 3, tbl7)
			end

			v16 = colorSequence2(tbl7)
		end

		local tbl7

		tbl7 = {
			[""] = 1,
			K = 1000,
			M = 1000000,
			B = 1e9,
			T = 1e12,
			Qa = 1e15,
			Qi = 1e18,
			Sx = 1e21,
			Sp = 1e24,
			Oc = 1e27,
			No = 1e30,
			Dc = 1e33,
		}

		local tbl8
		tbl8 = {}
		local tbl9

		tbl9 = {
			Limit = 1000000,
			Fill = Color3.fromRGB(255, 196, 66),
			Outline = Color3.fromRGB(255, 232, 152),
		}

		do
			local colorSequence2 = ColorSequence.new
			local tbl10 = {}
			local v17 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
			local v18 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl10[1] = v17
			tbl10[2] = v18

			do
				local values = table.pack(new(1, color(214, 142, 12)))
				table.move(values, 1, values.n, 3, tbl10)
			end

			tbl9.Text = colorSequence2(tbl10)
		end

		do
			local colorSequence2 = ColorSequence.new
			local tbl10 = {}
			local v17 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
			local v18 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl10[1] = v17
			tbl10[2] = v18

			do
				local values = table.pack(new(1, color(20, 12, 0)))
				table.move(values, 1, values.n, 3, tbl10)
			end

			tbl9.Stroke = colorSequence2(tbl10)
		end

		do
			local tbl10 = {
				Limit = 10000000,
				Fill = Color3.fromRGB(255, 146, 40),
				Outline = Color3.fromRGB(255, 194, 112),
			}

			local colorSequence2 = ColorSequence.new
			local tbl11 = {}
			local v17 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
			local v18 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
			local new = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl11[1] = v17
			tbl11[2] = v18

			do
				local values = table.pack(new(1, color(206, 92, 0)))
				table.move(values, 1, values.n, 3, tbl11)
			end

			tbl10.Text = colorSequence2(tbl11)
			local colorSequence3 = ColorSequence.new
			local tbl12 = {}
			local v19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 50, 0))
			local v20 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 25, 0))
			local new2 = ColorSequenceKeypoint.new
			local color2 = Color3.fromRGB
			tbl12[1] = v19
			tbl12[2] = v20

			do
				local values = table.pack(new2(1, color2(18, 8, 0)))
				table.move(values, 1, values.n, 3, tbl12)
			end

			tbl10.Stroke = colorSequence3(tbl12)

			local tbl13 = {
				Limit = 100000000,
				Fill = Color3.fromRGB(255, 82, 38),
				Outline = Color3.fromRGB(255, 140, 96),
			}

			local colorSequence4 = ColorSequence.new
			local tbl14 = {}
			local v21 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 158, 116))
			local v22 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
			local new3 = ColorSequenceKeypoint.new
			local color3 = Color3.fromRGB
			tbl14[1] = v21
			tbl14[2] = v22

			do
				local values = table.pack(new3(1, color3(196, 40, 0)))
				table.move(values, 1, values.n, 3, tbl14)
			end

			tbl13.Text = colorSequence4(tbl14)
			local colorSequence5 = ColorSequence.new
			local tbl15 = {}
			local v23 = ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 24, 0))
			local v24 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(54, 12, 0))
			local new4 = ColorSequenceKeypoint.new
			local color4 = Color3.fromRGB
			tbl15[1] = v23
			tbl15[2] = v24

			do
				local values = table.pack(new4(1, color4(18, 4, 0)))
				table.move(values, 1, values.n, 3, tbl15)
			end

			tbl13.Stroke = colorSequence5(tbl15)

			local tbl16 = {
				Limit = math.huge,
				Fill = Color3.fromRGB(220, 12, 28),
				Outline = Color3.fromRGB(255, 55, 65),
				Text = v15,
				Stroke = v16,
			}

			tbl8[1] = tbl9
			tbl8[2] = tbl10
			tbl8[3] = tbl13
			tbl8[4] = tbl16
		end

		local fn19

		local function fn20(arg)
			if type(arg) ~= "string" then
				return nil
			end
			local match, str = arg:match("%$%s*([%d%.]+)%s*(%a*)")
			local num = tonumber(match)
			if not num then
				return nil
			end

			if str ~= "" then
				str = str:sub(1, 1):upper() .. str:sub(2):lower()
			end

			return num * (tbl7[str] or 1)
		end

		fn19 = function(arg)
			local v17 = fn20(arg)
			if not v17 then
				return tbl8[#tbl8]
			end

			for _, v18 in ipairs(tbl8) do
				if v17 < v18.Limit then
					return v18
				end
			end

			return tbl8[#tbl8]
		end

		local screenGui

		do
			local function fn21()
				if type(gethui) == "function" then
					local ok, result = pcall(gethui)
					if ok and typeof(result) == "Instance" then
						return result
					end
				end

				return CoreGui
			end

			local v17 = fn21()
			local tbl10 = {}

			for _, v18 in ipairs({ v17, CoreGui }) do
				if v18 and not tbl10[v18] then
					tbl10[v18] = true
					local chilliPlayerESPRuntime =
						v18:FindFirstChild("__Nullx11BrainrotPlayerESPRuntime")

					if chilliPlayerESPRuntime then
						local cleanup =
							chilliPlayerESPRuntime:FindFirstChild("Cleanup")

						if cleanup and cleanup:IsA("BindableEvent") then
							pcall(function()
								cleanup:Fire()
							end)
						end

						pcall(function()
							chilliPlayerESPRuntime:Destroy()
						end)
					end
				end
			end

			screenGui = Instance.new("ScreenGui")
			screenGui.Name = "__Nullx11BrainrotPlayerESPRuntime"
			screenGui.Archivable = false
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.DisplayOrder = 50
			screenGui.Parent = v17
		end

		local bindableEvent
		bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = "Cleanup"
		bindableEvent.Parent = screenGui
		local flag8, tbl10, n13, tbl11, tbl12, n14, fn21, fn22, fn23, fn24

		do
			local v17 = screenGui
			flag8 = false

			tbl10 = {
				Name = true,
				Username = false,
				Avatar = true,
				Tool = true,
				Brainrot = true,
				["Admin Panel"] = true,
			}

			n13 = 1
			tbl11 = {}
			tbl12 = {}
			local tbl13 = {}
			n14 = 0

			fn21 = function(arg)
				for _, v18 in ipairs(arg) do
					if v18.Connected then
						v18:Disconnect()
					end
				end

				table.clear(arg)
			end

			fn22 = function(arg)
				local nameDisplayHumanoid = arg.NameDisplayHumanoid
				local nameDisplayDistance = arg.NameDisplayDistance

				if
					nameDisplayHumanoid
					and nameDisplayHumanoid.Parent
					and nameDisplayDistance ~= nil
				then
					pcall(function()
						nameDisplayHumanoid.NameDisplayDistance =
							nameDisplayDistance
					end)
				end

				arg.NameDisplayHumanoid = nil
				arg.NameDisplayDistance = nil
			end

			fn23 = function(arg, nameDisplayHumanoid)
				nameDisplayHumanoid = nameDisplayHumanoid
					and nameDisplayHumanoid:FindFirstChildOfClass("Humanoid")
				if not nameDisplayHumanoid then
					return
				end

				if arg.NameDisplayHumanoid ~= nameDisplayHumanoid then
					fn22(arg)
					arg.NameDisplayHumanoid = nameDisplayHumanoid
					arg.NameDisplayDistance =
						nameDisplayHumanoid.NameDisplayDistance
				end

				nameDisplayHumanoid.NameDisplayDistance = 0
			end

			local function fn25(arg)
				local str = tostring(arg or "")
				if str == "" then
					return ""
				end

				if str:match("^%d+$") then
					return "rbxassetid://" .. str
				end
				return str
			end

			local function fn26(arg)
				if not arg or not arg:IsA("Tool") then
					return ""
				end
				local v18 = fn25(arg.TextureId)
				if v18 ~= "" then
					return v18
				end

				for _, v19 in ipairs({
					"Icon",
					"Image",
					"Thumbnail",
					"TextureId",
				}) do
					local attribute = arg:GetAttribute(v19)
					if type(attribute) ~= "string" then
						continue
					end
					v18 = fn25(attribute)
					if v18 ~= "" then
						return v18
					end
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Decal") or descendant:IsA("Texture") then
						v18 = fn25(descendant.Texture)
					elseif
						descendant:IsA("ImageLabel")
						or descendant:IsA("ImageButton")
					then
						v18 = fn25(descendant.Image)
					end

					if v18 ~= "" then
						return v18
					end
				end

				return ""
			end

			local function fn27(arg)
				return arg and arg:FindFirstChildOfClass("Tool") or nil
			end

			fn24 = function(arg, arg2)
				for _, v18 in ipairs(tbl5) do
					local v19 = arg:FindFirstChild(v18)
					if v19 and v19:IsA("BasePart") then
						return v19
					end
				end

				return arg2
			end

			local function fn28(arg, arg2)
				if arg2 == arg then
					return Vector3.new(0, 3.1, 0)
				end
				local n15 = arg.Position.Y - arg2.Position.Y
				if math.abs(n15) <= n11 then
					return Vector3.new(0, math.clamp(n15 + 3.1, 3.8, 6), 0)
				end
				return Vector3.new(0, 4.8, 0)
			end

			local function fn29(arg, arg2)
				for _, descendant in ipairs(arg:GetDescendants()) do
					if
						descendant:IsA("Weld")
						or descendant:IsA("WeldConstraint")
					then
						local part0 = descendant.Part0
						local part1 = descendant.Part1
						local v18

						if part0 and not part0:IsDescendantOf(arg) then
							v18 = part0
						else
							local flag9 = part1
								and not part1:IsDescendantOf(arg)
							local v19 = nil
							local v20 = nil

							if flag9 then
								v18 = part1
								part1 = part0
							else
								v18 = v19
								part1 = v20
							end
						end

						if
							v18
							and v18:IsA("BasePart")
							and v18.Parent == Workspace
							and part1
							and part1:IsA("BasePart")
							and part1:IsDescendantOf(arg)
							and (v18.Position - arg2.Position).Magnitude
								<= n9
						then
							return v18, part1
						end
					end
				end

				return nil
			end

			local function fn30(arg)
				if type(arg) ~= "string" or not arg:find("/s", 1, true) then
					return false
				end
				local match = arg:match("%$([%d%.]+)")
				local flag9 = match ~= nil

				if flag9 then
					flag9 = (tonumber(match) or 0) > 0
				end

				return flag9
			end

			local function fn31(arg, arg2)
				for k, v18 in pairs(arg:GetAttributes()) do
					if
						k ~= "__AssetDescendantCount"
						and arg2:GetAttribute(k) ~= v18
					then
						return false
					end
				end

				return true
			end

			local function fn32(arg)
				local generation = arg:FindFirstChild("Generation", true)
				if
					generation
					and generation:IsA("TextLabel")
					and fn30(generation.Text)
				then
					return generation
				end
				local plots = Workspace:FindFirstChild("Plots")
				local debris = Workspace:FindFirstChild("Debris")
				if not plots or not debris then
					return nil
				end
				local tbl14 = {}
				local tbl15 = {}

				for _, child in ipairs(plots:GetChildren()) do
					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("Model") and child2.Name == arg.Name then
							local position = child2:GetPivot().Position
							tbl15[#tbl15 + 1] = position

							if fn31(arg, child2) then
								tbl14[#tbl14 + 1] = position
							end
						end
					end
				end

				tbl14 = #tbl14 > 0 and tbl14 or tbl15
				if #tbl14 == 0 then
					return nil
				end
				local mutation = arg:FindFirstChild("Mutation", true)
				local text = mutation
						and mutation:IsA("TextLabel")
						and mutation.Text
					or nil
				local huge = math.huge
				local v18 = nil

				for _, child in ipairs(debris:GetChildren()) do
					if
						child.Name == "FastOverheadTemplate"
						and child:IsA("BasePart")
					then
						local animalOverhead =
							child:FindFirstChild("AnimalOverhead")
						local displayName = animalOverhead
							and animalOverhead:FindFirstChild("DisplayName")
						local generation2 = animalOverhead
							and animalOverhead:FindFirstChild("Generation")
						animalOverhead = animalOverhead
							and animalOverhead:FindFirstChild("Mutation")

						if
							displayName
							and displayName:IsA("TextLabel")
							and displayName.Text == arg.Name
							and generation2
							and generation2:IsA("TextLabel")
							and fn30(generation2.Text)
						then
							local huge2 = math.huge

							for _, v19 in ipairs(tbl14) do
								huge2 = math.min(
									huge2,
									(child.Position - v19).Magnitude
								)
							end

							local flag9 = text
								and animalOverhead
								and animalOverhead:IsA("TextLabel")
								and animalOverhead.Text ~= text
							local n15 = 0

							if flag9 then
								n15 = 1000
							end

							local n16 = huge2 + n15

							if n16 < huge then
								huge = n16
								v18 = generation2
							end
						end
					end
				end

				return v18
			end

			local function fn33(arg)
				if not arg then
					return nil
				end
				local mutation = arg:FindFirstChild("Mutation", true)
				if mutation and mutation:IsA("TextLabel") then
					return mutation
				end
				return nil
			end

			local function fn34(arg)
				if not (arg and arg.Parent and arg.Visible) then
					return nil
				end
				local str = tostring(arg.Text or "")
				if str == "" then
					return nil
				end

				local tbl14 = {
					Text = str,
					RichText = arg.RichText == true,
					Color = arg.TextColor3,
					Font = arg.FontFace,
					Gradient = nil,
					StrokeColor = nil,
				}

				local uiStroke = arg:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					tbl14.StrokeColor = uiStroke.Color
				end

				local uiGradient = arg:FindFirstChildOfClass("UIGradient")

				if uiGradient then
					tbl14.Gradient = {
						Color = uiGradient.Color,
						Rotation = uiGradient.Rotation,
					}
				end

				return tbl14
			end

			local function fn35(arg)
				if arg:GetAttribute("Stealing") ~= true then
					return nil
				end
				local character_ = arg.Character
				local humanoidRootPart2 = character_
					and character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return nil
				end
				local huge = math.huge
				local v18 = nil

				for _, child in ipairs(Workspace:GetChildren()) do
					if
						child:IsA("Model")
						and child ~= character_
						and not Players:GetPlayerFromCharacter(child)
						and child.Name:sub(-6) ~= "_Clone"
					then
						local rootPart = child:FindFirstChild("RootPart")
							or child.PrimaryPart
							or child:FindFirstChildWhichIsA("BasePart")

						if rootPart and rootPart:IsA("BasePart") then
							local v19, v20 = fn29(child, humanoidRootPart2)

							if v19 and v20 then
								local v21 =
									humanoidRootPart2.CFrame:PointToObjectSpace(
										v19.Position
									)
								local magnitude = (
									v20.Position - humanoidRootPart2.Position
								).Magnitude

								if
									math.abs(v21.X) <= 4
									and v21.Y >= -2
									and v21.Y <= 6
									and v21.Z >= -6
									and v21.Z <= 3
									and magnitude <= n10
								then
									local n15 = (
										v19.Position
										- humanoidRootPart2.Position
									).Magnitude + magnitude * 0.05

									if n15 < huge then
										huge = n15
										v18 = child
									end
								end
							end
						end
					end
				end

				if not v18 then
					return nil
				end
				local v19 = fn32(v18)
				return v18.Name, v18, v19 and v19.Text or nil, v19, fn33(v18)
			end

			local function fn36()
				local currentCamera = Workspace.CurrentCamera
				return math.max(
					1,
					math.floor(
						math.clamp(
							(
								currentCamera
									and currentCamera.ViewportSize.Y
								or 1080
							) * 0.024,
							26,
							35
						) * n13
					)
				)
			end

			local function fn37(text, font3, size)
				local getTextBoundsParams = Instance.new("GetTextBoundsParams")
				getTextBoundsParams.Text = text
				getTextBoundsParams.Font = font3
				getTextBoundsParams.Size = size
				getTextBoundsParams.Width = 1000

				local ok, result = pcall(function()
					return TextService:GetTextBoundsAsync(getTextBoundsParams)
				end)

				getTextBoundsParams:Destroy()
				if ok then
					return result.X
				end
				return (utf8.len(text) or #text) * size * 0.56
			end

			local function fn38(arg, color, arg2, arg3)
				arg.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				arg.Color = color
				arg.Enabled = true
				arg.LineJoinMode = Enum.LineJoinMode.Round
				arg.Transparency = 0

				local ok = pcall(function()
					arg.BorderOffset = UDim.new(0, 0)
					arg.BorderStrokePosition = Enum.BorderStrokePosition.Outer
					arg.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
				end)

				arg.Thickness = ok and arg2 or arg3
				return ok
			end

			local function createTextLabel(name, parent, zIndex)
				local textLabel = Instance.new("TextLabel")
				textLabel.Name = name
				textLabel.AnchorPoint = Vector2.new(0, 0.5)
				textLabel.BackgroundTransparency = 1
				textLabel.FontFace = font2
				textLabel.Text = ""
				textLabel.TextScaled = true
				textLabel.TextStrokeTransparency = 1
				textLabel.TextXAlignment = Enum.TextXAlignment.Center
				textLabel.TextYAlignment = Enum.TextYAlignment.Center
				textLabel.ZIndex = zIndex
				textLabel.Parent = parent
				return textLabel
			end

			local function fn39(arg, hasTool)
				local v18 = fn36()
				local visible = tbl10.Name == true
				local text = tbl10.Username == true
				local visible2 = tbl10.Avatar == true
				local flag9 = tbl10.Tool == true
				local visible3 = tbl10.Brainrot == true
				local visible4 = tbl10["Admin Panel"] == true
				local n15 = visible2 and math.floor(v18 * 0.72) or 0
				local n16 = flag9 and math.floor(v18 * 0.82) or 0
				local n17 = math.floor(v18 * 0.7)
				local n18 = math.max(1, math.floor(v18 * 0.04))
				local targetPlayer = arg.TargetPlayer
				text = text and targetPlayer.Name or targetPlayer.DisplayName
				arg.DisplayName.Text = text
				arg.NameShadow.Text = text
				local n19 = math.floor(
					math.clamp(
						fn37(arg.DisplayName.Text, font2, n17) + 4,
						n17,
						230
					)
				)
				local v19 = flag9 and hasTool
				local n20 = 0
				local n21 = 0

				if visible2 then
					n20 = 0 + n15
				end

				local n22 = 0

				if visible then
					if not (n20 > 0) then
						n22 = n20
					else
						n22 = n20 + n18
					end

					n20 = n22 + n19
				end

				local n23 = 0

				if v19 then
					if not (n20 > 0) then
						n23 = n20
					else
						n23 = n20 + n18
					end

					n20 = n23 + n16
				end

				local n24 = math.max(n20, 1)
				visible3 = visible3
					and type(arg.BrainrotName) == "string"
					and arg.BrainrotName ~= ""
				local n25 = math.floor(v18 * 0.88)
				local n26 = -math.max(2, math.floor(v18 * 0.16))
				local brainrotName = visible3 and arg.BrainrotName or ""
				local n27 = visible3
						and math.floor(
							math.clamp(
								fn37(brainrotName, font2, n25) + 6,
								n25,
								320
							)
						)
					or 0
				local visible5 = visible3
					and type(arg.BrainrotGeneration) == "string"
					and arg.BrainrotGeneration ~= ""
				local brainrotGeneration = visible5 and arg.BrainrotGeneration
					or ""
				local n28 = math.max(2, math.floor(v18 * 0.12))
				local n29 = visible5
						and math.floor(
							math.clamp(
								fn37(brainrotGeneration, font2, n25) + 4,
								n25,
								150
							)
						)
					or 0
				local n30 = n27 + (visible5 and n28 + n29 or 0)
				local n31 = visible and n22 + n19 * 0.5 or n24 * 0.5
				local n32 = n31 - n30 * 0.5
				local n33 = math.min(0, n32)
				local n34 = math.max(n24, n32 + n30)
				local v20 = math.ceil(n34 - n33)
				visible4 = visible4 and arg.IsAdmin == true
				local n35 = math.max(1, math.floor(v18 * 0.6))
				local n36 = visible4
						and math.floor(
							math.clamp(
								fn37("Admin Panel", font, n35) + 3,
								n35,
								150
							)
						)
					or 0
				local n37 = n35 + -math.max(2, math.floor(v18 * 0.2))
				local brainrotMutation = visible3 and arg.BrainrotMutation
					or nil
				local visible6 = brainrotMutation ~= nil
				local n38 = math.floor(v18 * 0.62)
				local n39 = -math.max(1, math.floor(v18 * 0.1))
				local n40 = visible6
						and math.floor(
							math.clamp(
								fn37(
									brainrotMutation.Text:gsub("<[^<>]->", ""),
									font2,
									n38
								) + 6,
								n38,
								260
							)
						)
					or 0
				local n41 = visible6 and n38 + n39 or 0
				local n42 = n31 - n40 * 0.5
				local n43

				if visible6 then
					n43 = math.min(n33, n42)
					v20 = math.ceil(math.max(n34, n42 + n40) - n43)
				else
					n43 = n33
				end

				local n44 = visible3 and n25 + n26 or 0
				local n45 = n37 + n41 + n44 + v18
				local n46 = -n43
				local n47 = n46 + n32
				local n48 = (n37 + n41 + n44 + v18 * 0.5) / n45
				local n49 = visible3 and (n37 + n41 + n25 * 0.5) / n45 or 0
				local n50 = visible6 and (n37 + n38 * 0.5) / n45 or 0
				local n51 = visible4 and n35 * 0.5 / n45 or 0
				local n52 = 1 / v20
				local n53 = 1 / n45
				arg.HasTool = hasTool
				arg.Billboard.Size = UDim2.fromOffset(v20, n45)
				arg.DisplayName.Visible = visible
				arg.NameShadow.Visible = visible
				arg.Avatar.Visible = visible2
				arg.ToolIcon.Visible = flag9 and arg.ToolIcon.Image ~= ""
				arg.ToolShadow.Visible = flag9 and arg.ToolShadow.Image ~= ""
				arg.Avatar.Position = UDim2.fromScale((n46 + n21) / v20, n48)
				arg.Avatar.Size = UDim2.fromScale(n15 / v20, n15 / n45)
				arg.DisplayName.Position =
					UDim2.fromScale((n46 + n22) / v20, n48)
				arg.DisplayName.Size = UDim2.fromScale(n19 / v20, n17 / n45)
				arg.NameShadow.Position =
					UDim2.fromScale((n46 + n22) / v20 + n52, n48 + n53)
				arg.NameShadow.Size = arg.DisplayName.Size
				arg.ToolIcon.Position = UDim2.fromScale((n46 + n23) / v20, n48)
				arg.ToolIcon.Size = UDim2.fromScale(n16 / v20, n16 / n45)
				arg.ToolShadow.Position =
					UDim2.fromScale((n46 + n23) / v20 + n52, n48 + n53)
				arg.ToolShadow.Size = arg.ToolIcon.Size
				arg.AdminLine.Visible = visible4

				if visible4 then
					arg.AdminLine.Position =
						UDim2.fromScale((n46 + n31) / v20, n51)
					arg.AdminLine.Size = UDim2.fromScale(n36 / v20, n35 / n45)
					arg.AdminText.Position = UDim2.fromScale(0, 0.5)
					arg.AdminText.Size = UDim2.fromScale(n36 / n36, 1)
					arg.AdminShadow.Position =
						UDim2.fromScale(1 / n36, 0.5 + 1 / n35)
					arg.AdminShadow.Size = arg.AdminText.Size
				end

				arg.MutationText.Visible = visible6
				arg.MutationShadow.Visible = visible6

				if visible6 then
					arg.MutationText.RichText = brainrotMutation.RichText
					arg.MutationText.Text = brainrotMutation.Text
					arg.MutationText.TextColor3 = brainrotMutation.Color

					if brainrotMutation.Font then
						arg.MutationText.FontFace = brainrotMutation.Font
						arg.MutationShadow.FontFace = brainrotMutation.Font
					end

					local uiStroke =
						arg.MutationText:FindFirstChildOfClass("UIStroke")

					if uiStroke and brainrotMutation.StrokeColor then
						uiStroke.Color = brainrotMutation.StrokeColor
					end

					arg.MutationShadow.RichText = false
					arg.MutationShadow.Text =
						brainrotMutation.Text:gsub("<[^<>]->", "")

					if brainrotMutation.Gradient then
						arg.MutationGradient.Color =
							brainrotMutation.Gradient.Color
						arg.MutationGradient.Rotation =
							brainrotMutation.Gradient.Rotation
						arg.MutationGradient.Enabled = true
					else
						arg.MutationGradient.Enabled = false
					end

					arg.MutationText.Position =
						UDim2.fromScale((n46 + n42) / v20, n50)
					arg.MutationText.Size =
						UDim2.fromScale(n40 / v20, n38 / n45)
					arg.MutationShadow.Position =
						UDim2.fromScale((n46 + n42) / v20 + n52, n50 + n53)
					arg.MutationShadow.Size = arg.MutationText.Size
				end

				arg.BrainrotText.Text = brainrotName
				arg.BrainrotShadow.Text = brainrotName
				arg.BrainrotText.Visible = visible3
				arg.BrainrotShadow.Visible = visible3
				arg.GenerationText.Text = brainrotGeneration
				arg.GenerationShadow.Text = brainrotGeneration
				arg.GenerationText.Visible = visible5
				arg.GenerationShadow.Visible = visible5

				if visible3 then
					local n54 = n47 / v20
					arg.BrainrotText.Position = UDim2.fromScale(n54, n49)
					arg.BrainrotText.Size =
						UDim2.fromScale(n27 / v20, n25 / n45)
					arg.BrainrotShadow.Position =
						UDim2.fromScale(n54 + n52, n49 + n53)
					arg.BrainrotShadow.Size = arg.BrainrotText.Size

					if visible5 then
						local n55 = (n47 + n27 + n28) / v20
						arg.GenerationText.Position = UDim2.fromScale(n55, n49)
						arg.GenerationText.Size =
							UDim2.fromScale(n29 / v20, n25 / n45)
						arg.GenerationShadow.Position =
							UDim2.fromScale(n55 + n52, n49 + n53)
						arg.GenerationShadow.Size = arg.GenerationText.Size
					end
				end
			end

			local function fn40(arg, arg2, arg3)
				local v18 = arg3 or arg2
				local highlight = Instance.new("Highlight")
				highlight.Name = "PlayerHighlight"
				highlight.Adornee = arg2.Parent
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillColor = Color3.fromRGB(0, 67, 148)
				highlight.FillTransparency = 0.76
				highlight.OutlineColor = Color3.fromRGB(72, 207, 255)
				highlight.OutlineTransparency = 0.02
				highlight.Parent = v17
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "PlayerTag"
				billboardGui.Adornee = v18
				billboardGui.AlwaysOnTop = true
				billboardGui.LightInfluence = 0
				billboardGui.MaxDistance = 1000
				billboardGui.Size = UDim2.fromOffset(1, 1)
				billboardGui.StudsOffsetWorldSpace = fn28(arg2, v18)
				billboardGui.Parent = v17
				local boxHandleAdornment = Instance.new("BoxHandleAdornment")
				boxHandleAdornment.Name = "NetworkPosition"
				boxHandleAdornment.Adornee = v18
				boxHandleAdornment.AlwaysOnTop = true
				boxHandleAdornment.CFrame = CFrame.new(0, 1.2, 0)
				boxHandleAdornment.Color3 = Color3.fromRGB(72, 207, 255)
				boxHandleAdornment.Size = Vector3.new(3.2, 5.2, 2.2)
				boxHandleAdornment.Transparency = 0.78
				boxHandleAdornment.Visible = false
				boxHandleAdornment.ZIndex = 1
				boxHandleAdornment.Parent = v17
				local frame = Instance.new("Frame")
				frame.Name = "Content"
				frame.Size = UDim2.fromScale(1, 1)
				frame.BackgroundTransparency = 1
				frame.Parent = billboardGui
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Name = "Avatar"
				imageLabel.AnchorPoint = Vector2.new(0, 0.5)
				imageLabel.BackgroundTransparency = 1
				imageLabel.ScaleType = Enum.ScaleType.Crop
				imageLabel.Parent = frame
				local uiAspectRatioConstraint =
					Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint.AspectRatio = 1
				uiAspectRatioConstraint.Parent = imageLabel
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(1, 0)
				uiCorner.Parent = imageLabel
				local NameShadow = createTextLabel("NameShadow", frame, 1)
				NameShadow.Text = arg.DisplayName
				NameShadow.TextColor3 = Color3.fromRGB(7, 19, 34)
				NameShadow.TextTransparency = 0.05
				local DisplayName = createTextLabel("DisplayName", frame, 2)
				DisplayName.Text = arg.DisplayName
				DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke = Instance.new("UIStroke")
				fn38(uiStroke, Color3.fromRGB(255, 255, 255), 0.044, 1.4)
				uiStroke.Parent = DisplayName
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Color = colorSequence
				uiGradient.Rotation = 90
				uiGradient.Parent = uiStroke
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Color = v14
				uiGradient2.Rotation = 90
				uiGradient2.Parent = DisplayName
				local BrainrotShadow =
					createTextLabel("BrainrotShadow", frame, 3)
				BrainrotShadow.TextColor3 = Color3.fromRGB(25, 0, 4)
				local BrainrotText = createTextLabel("BrainrotText", frame, 4)
				BrainrotText.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke2 = Instance.new("UIStroke")
				fn38(uiStroke2, Color3.fromRGB(124, 0, 15), 0.052, 1.7)
				uiStroke2.Parent = BrainrotText
				local uiGradient3 = Instance.new("UIGradient")
				uiGradient3.Color = v16
				uiGradient3.Rotation = 90
				uiGradient3.Parent = uiStroke2
				local uiGradient4 = Instance.new("UIGradient")
				uiGradient4.Color = v15
				uiGradient4.Rotation = 90
				uiGradient4.Parent = BrainrotText
				local MutationShadow =
					createTextLabel("MutationShadow", frame, 3)
				MutationShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
				MutationShadow.TextTransparency = 0.15
				local MutationText = createTextLabel("MutationText", frame, 4)
				MutationText.TextColor3 = Color3.fromRGB(255, 255, 255)
				MutationText.RichText = true
				local uiStroke3 = Instance.new("UIStroke")
				fn38(uiStroke3, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
				uiStroke3.Transparency = 0.15
				uiStroke3.Parent = MutationText
				local uiGradient5 = Instance.new("UIGradient")
				uiGradient5.Enabled = false
				uiGradient5.Rotation = 90
				uiGradient5.Parent = MutationText
				local GenerationShadow =
					createTextLabel("GenerationShadow", frame, 3)
				GenerationShadow.TextColor3 = Color3.fromRGB(18, 48, 0)
				GenerationShadow.TextTransparency = 0.08
				local GenerationText =
					createTextLabel("GenerationText", frame, 4)
				GenerationText.TextColor3 = Color3.fromRGB(115, 255, 0)
				local uiStroke4 = Instance.new("UIStroke")
				fn38(uiStroke4, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
				uiStroke4.Transparency = 0.3
				uiStroke4.Parent = GenerationText
				local imageLabel2 = Instance.new("ImageLabel")
				imageLabel2.Name = "ToolShadow"
				imageLabel2.AnchorPoint = Vector2.new(0, 0.5)
				imageLabel2.BackgroundTransparency = 1
				imageLabel2.ImageColor3 = Color3.fromRGB(0, 0, 0)
				imageLabel2.ImageTransparency = 0.35
				imageLabel2.ScaleType = Enum.ScaleType.Fit
				imageLabel2.Visible = false
				imageLabel2.ZIndex = 1
				imageLabel2.Parent = frame
				local uiAspectRatioConstraint2 =
					Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint2.AspectRatio = 1
				uiAspectRatioConstraint2.Parent = imageLabel2
				local imageLabel3 = Instance.new("ImageLabel")
				imageLabel3.Name = "ToolIcon"
				imageLabel3.AnchorPoint = Vector2.new(0, 0.5)
				imageLabel3.BackgroundTransparency = 1
				imageLabel3.ScaleType = Enum.ScaleType.Fit
				imageLabel3.Visible = false
				imageLabel3.ZIndex = 2
				imageLabel3.Parent = frame
				local uiAspectRatioConstraint3 =
					Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint3.AspectRatio = 1
				uiAspectRatioConstraint3.Parent = imageLabel3
				local frame2 = Instance.new("Frame")
				frame2.Name = "AdminLine"
				frame2.AnchorPoint = Vector2.new(0.5, 0.5)
				frame2.BackgroundTransparency = 1
				frame2.BorderSizePixel = 0
				frame2.Visible = false
				frame2.ZIndex = 3
				frame2.Parent = frame
				local AdminShadow = createTextLabel("AdminShadow", frame2, 3)
				AdminShadow.AnchorPoint = Vector2.new(0, 0.5)
				AdminShadow.FontFace = font
				AdminShadow.Text = "Admin Panel"
				AdminShadow.TextColor3 = Color3.fromRGB(10, 14, 22)
				AdminShadow.TextTransparency = 0.08
				local AdminText = createTextLabel("AdminText", frame2, 4)
				AdminText.AnchorPoint = Vector2.new(0, 0.5)
				AdminText.FontFace = font
				AdminText.Text = "Admin Panel"
				AdminText.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke5 = Instance.new("UIStroke")
				fn38(uiStroke5, Color3.fromRGB(10, 24, 45), 0.02, 1.45)
				uiStroke5.Transparency = 0.02
				uiStroke5.Parent = AdminText
				local uiGradient6 = Instance.new("UIGradient")
				local colorSequence2 = ColorSequence.new
				local tbl14 = {}
				local v19 =
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
				local v20 = ColorSequenceKeypoint.new(
					0.55,
					Color3.fromRGB(235, 242, 255)
				)
				tbl14[1] = v19
				tbl14[2] = v20

				do
					local values = table.pack(
						ColorSequenceKeypoint.new(
							1,
							Color3.fromRGB(255, 255, 255)
						)
					)
					table.move(values, 1, values.n, 3, tbl14)
				end

				uiGradient6.Color = colorSequence2(tbl14)
				uiGradient6.Rotation = 90
				uiGradient6.Parent = AdminText

				local tbl15 = {
					TargetPlayer = arg,
					PlayerHighlight = highlight,
					NetworkTracker = boxHandleAdornment,
					NetworkAnchor = v18,
					VisualHead = arg2,
					Billboard = billboardGui,
					Avatar = imageLabel,
					NameShadow = NameShadow,
					DisplayName = DisplayName,
					BrainrotShadow = BrainrotShadow,
					BrainrotText = BrainrotText,
					BrainrotGradient = uiGradient4,
					BrainrotStrokeGradient = uiGradient3,
					GenerationShadow = GenerationShadow,
					GenerationText = GenerationText,
					MutationShadow = MutationShadow,
					MutationText = MutationText,
					MutationGradient = uiGradient5,
					ToolShadow = imageLabel2,
					ToolIcon = imageLabel3,
					AdminLine = frame2,
					AdminShadow = AdminShadow,
					AdminText = AdminText,
					BrainrotName = nil,
					BrainrotGeneration = nil,
					BrainrotMutation = nil,
					IsAdmin = false,
					HasTool = false,
				}

				fn39(tbl15, false)
				return tbl15
			end

			local function fn41(arg)
				local tag = arg.Tag
				local character_ = arg.Character
				if not tag or not character_ then
					return false
				end
				local visualHead = tag.VisualHead
				local networkAnchor = tag.NetworkAnchor
				if
					not visualHead
					or not visualHead:IsDescendantOf(character_)
					or not networkAnchor
					or not networkAnchor:IsDescendantOf(character_)
				then
					return false
				end
				tag.Billboard.Adornee = networkAnchor
				local visible = networkAnchor ~= visualHead
					and (networkAnchor.Position - visualHead.Position).Magnitude
						>= n11
				tag.PlayerHighlight.Enabled = not visible
				tag.NetworkTracker.Adornee = networkAnchor
				tag.NetworkTracker.Visible = visible
				return true
			end

			local function fn42(arg)
				if arg:GetAttribute("AdminCommands") == true then
					return true
				end
				local attribute = arg:GetAttribute("Role")
				return type(attribute) == "string"
					and string.find(
							string.lower(attribute),
							"admin",
							1,
							true
						)
						~= nil
			end

			local function fn43(arg, arg2)
				if not arg.Tag then
					return
				end
				arg.Tag.IsAdmin = fn42(arg2)
				fn39(arg.Tag, arg.Tag.HasTool == true)
			end

			local function fn44(arg)
				if not arg.Tag or not arg.Character then
					return
				end
				local v18 = fn26(fn27(arg.Character))
				local visible = v18 ~= ""
				arg.Tag.ToolIcon.Image = v18
				arg.Tag.ToolIcon.Visible = visible
				arg.Tag.ToolShadow.Image = v18
				arg.Tag.ToolShadow.Visible = visible
				fn39(arg.Tag, visible)
			end

			local function fn45(arg)
				if not arg.Tag then
					return
				end
				arg.Tag.BrainrotName = arg.BrainrotName
				arg.Tag.BrainrotGeneration = arg.BrainrotGeneration
				arg.Tag.BrainrotMutation = fn34(arg.BrainrotMutationLabel)
				fn39(arg.Tag, arg.Tag.HasTool == true)
				local v18 = fn19(arg.BrainrotGeneration)

				if arg.Tag.BrainrotGradient then
					arg.Tag.BrainrotGradient.Color = v18.Text
				end

				if arg.Tag.BrainrotStrokeGradient then
					arg.Tag.BrainrotStrokeGradient.Color = v18.Stroke
				end

				if
					arg.BrainrotHighlight
					and (
						tbl10.Brainrot ~= true
						or arg.BrainrotHighlight.Adornee
							~= arg.BrainrotModel
					)
				then
					arg.BrainrotHighlight:Destroy()
					arg.BrainrotHighlight = nil
				end

				if
					tbl10.Brainrot == true
					and arg.BrainrotModel
					and arg.BrainrotModel.Parent
					and not arg.BrainrotHighlight
				then
					local highlight = Instance.new("Highlight")
					highlight.Name = "BrainrotHighlight"
					highlight.Adornee = arg.BrainrotModel
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillTransparency = 0.68
					highlight.OutlineTransparency = 0
					highlight.Parent = v17
					arg.BrainrotHighlight = highlight
				end

				if arg.BrainrotHighlight then
					arg.BrainrotHighlight.FillColor = v18.Fill
					arg.BrainrotHighlight.OutlineColor = v18.Outline
				end
			end

			local function fn46(arg)
				if arg.BrainrotGenerationConnection then
					arg.BrainrotGenerationConnection:Disconnect()
					arg.BrainrotGenerationConnection = nil
				end

				local v18 = ipairs
				local brainrotMutationConnections = arg.BrainrotMutationConnections
					or {}

				for _, brainrotMutationConnection in
					v18(brainrotMutationConnections)
				do
					brainrotMutationConnection:Disconnect()
				end

				arg.BrainrotMutationConnections = nil
				arg.BrainrotMutationLabel = nil
			end

			local function fn47(arg, brainrotMutationLabel, arg2)
				if not brainrotMutationLabel then
					return
				end
				arg.BrainrotMutationLabel = brainrotMutationLabel
				local brainrotMutationConnections = {}

				local function fn48()
					if arg.BrainrotModel == arg2 then
						fn45(arg)
					end
				end

				brainrotMutationConnections[#brainrotMutationConnections + 1] =
					runtime.Track(
						brainrotMutationLabel
							:GetPropertyChangedSignal("Text")
							:Connect(runtime.Guard(fn48))
					)
				brainrotMutationConnections[#brainrotMutationConnections + 1] =
					runtime.Track(
						brainrotMutationLabel
							:GetPropertyChangedSignal("Visible")
							:Connect(runtime.Guard(fn48))
					)
				brainrotMutationConnections[#brainrotMutationConnections + 1] =
					runtime.Track(
						brainrotMutationLabel
							:GetPropertyChangedSignal("TextColor3")
							:Connect(runtime.Guard(fn48))
					)
				arg.BrainrotMutationConnections = brainrotMutationConnections
			end

			local function fn48(arg, arg2)
				arg.StealingVersion = arg.StealingVersion + 1
				local stealingVersion = arg.StealingVersion

				if arg2:GetAttribute("Stealing") ~= true then
					fn46(arg)
					arg.BrainrotName = nil
					arg.BrainrotGeneration = nil
					arg.BrainrotModel = nil
					fn45(arg)
					return
				end

				task.spawn(function()
					for i_ = 1, 7 do
						if
							not flag8
							or arg.StealingVersion ~= stealingVersion
							or tbl11[arg2] ~= arg
						then
							return
						end
						local v18, v19, v20, v21, v22 = fn35(arg2)

						if v18 then
							fn46(arg)
							arg.BrainrotName = v18
							arg.BrainrotModel = v19
							arg.BrainrotGeneration = v20
							fn47(arg, v22, v19)

							if v21 then
								arg.BrainrotGenerationConnection =
									runtime.Track(
										v21:GetPropertyChangedSignal("Text")
											:Connect(runtime.Guard(function()
												if arg.BrainrotModel == v19 then
													arg.BrainrotGeneration =
														v21.Text
													fn45(arg)
												end
											end))
									)
							end

							fn45(arg)
							return
						end

						if i_ < 7 then
							task.wait(0.12)
						end
					end

					if arg.StealingVersion == stealingVersion then
						fn46(arg)
						arg.BrainrotName = nil
						arg.BrainrotGeneration = nil
						arg.BrainrotModel = nil
						fn45(arg)
					end
				end)
			end

			local function fn49(arg, arg2, arg3)
				local image = tbl13[arg2.UserId]

				if image == nil then
					local ok

					ok, image = pcall(function()
						return Players:GetUserThumbnailAsync(
							arg2.UserId,
							Enum.ThumbnailType.HeadShot,
							Enum.ThumbnailSize.Size100x100
						)
					end)

					image = ok and image or ""
					tbl13[arg2.UserId] = image
				end

				if
					flag8
					and arg.Version == arg3
					and arg.Tag
					and arg.Tag.Avatar.Parent
				then
					arg.Tag.Avatar.Image = image
				end
			end

			local flag9 = false

			local function fn50(arg)
				if arg:IsA("BasePart") then
					return arg.Name ~= "HumanoidRootPart"
				end
				return arg:IsA("Decal") or arg:IsA("Texture")
			end

			local function fn51(arg, arg2)
				if flag9 or not arg2.Parent then
					return
				end
				local transparency2 = arg2.Transparency

				if transparency2 <= n12 then
					arg.RevealOriginals[arg2] = transparency2
					arg.RevealHidden[arg2] = nil
					return
				end

				if arg.RevealOriginals[arg2] == nil then
					return
				end
				arg.RevealHidden[arg2] = transparency2
				flag9 = true

				pcall(function()
					arg2.Transparency = transparency

					if arg2:IsA("BasePart") then
						arg2.LocalTransparencyModifier = 0
					end
				end)

				flag9 = false
			end

			local function fn52(arg, arg2)
				if arg.RevealBound[arg2] then
					return
				end
				arg.RevealBound[arg2] = true
				local transparency2 = arg2.Transparency

				if transparency2 <= n12 then
					arg.RevealOriginals[arg2] = transparency2
				elseif arg2:IsA("BasePart") and tbl6[arg2.Name] then
					arg.RevealOriginals[arg2] = 0
				elseif
					arg2:IsA("Decal") and string.lower(arg2.Name) == "face"
				then
					arg.RevealOriginals[arg2] = 0
				end

				arg.RevealConnections[#arg.RevealConnections + 1] =
					runtime.Track(
						arg2:GetPropertyChangedSignal("Transparency")
							:Connect(runtime.Guard(function()
								if flag8 then
									fn51(arg, arg2)
								end
							end))
					)

				fn51(arg, arg2)
			end

			local function fn53(arg, arg2)
				for _, descendant in ipairs(arg2:GetDescendants()) do
					if fn50(descendant) then
						fn52(arg, descendant)
					end
				end

				arg.RevealConnections[#arg.RevealConnections + 1] =
					runtime.Track(
						arg2.DescendantAdded:Connect(
							runtime.Guard(function(descendant)
								if flag8 and fn50(descendant) then
									fn52(arg, descendant)
								end
							end)
						)
					)
			end

			local function fn54(arg)
				fn21(arg.RevealConnections)
				flag9 = true

				for k, v18 in pairs(arg.RevealHidden) do
					if k.Parent then
						pcall(function()
							k.Transparency = v18
						end)
					end
				end

				flag9 = false
				table.clear(arg.RevealHidden)
				table.clear(arg.RevealOriginals)
				table.clear(arg.RevealBound)
			end

			local function fn55(arg)
				fn21(arg.CharacterConnections)
				fn22(arg)
				fn54(arg)
				fn46(arg)

				if arg.BrainrotHighlight then
					arg.BrainrotHighlight:Destroy()
					arg.BrainrotHighlight = nil
				end

				arg.BrainrotModel = nil
				arg.BrainrotGeneration = nil

				if arg.Tag then
					if arg.Tag.PlayerHighlight then
						arg.Tag.PlayerHighlight:Destroy()
					end

					if arg.Tag.NetworkTracker then
						arg.Tag.NetworkTracker:Destroy()
					end

					arg.Tag.Billboard:Destroy()
					arg.Tag = nil
				end

				arg.Character = nil
				arg.BindingCharacter = nil
			end

			local fn56 = nil

			fn56 = function(arg, arg2, character_)
				fn55(arg)
				arg.Version = arg.Version + 1
				local version = arg.Version
				if not flag8 or not character_ then
					return
				end
				arg.Character = character_
				arg.BindingCharacter = character_
				fn23(arg, character_)
				fn53(arg, character_)

				local function fn57()
					task.defer(function()
						if flag8 and arg.Version == version then
							fn44(arg)
						end
					end)
				end

				arg.CharacterConnections[#arg.CharacterConnections + 1] =
					runtime.Track(
						character_.ChildAdded:Connect(
							runtime.Guard(function(child)
								if child:IsA("Tool") then
									fn57()
								elseif child:IsA("Humanoid") then
									fn23(arg, character_)
								end
							end)
						)
					)

				arg.CharacterConnections[#arg.CharacterConnections + 1] =
					runtime.Track(
						character_.ChildRemoved:Connect(
							runtime.Guard(function(child)
								if child:IsA("Tool") then
									fn57()
								end
							end)
						)
					)

				arg.CharacterConnections[#arg.CharacterConnections + 1] =
					runtime.Track(
						character_.AncestryChanged:Connect(
							runtime.Guard(function()
								if
									not flag8
									or arg.Version ~= version
									or character_ ~= arg2.Character
								then
									return
								end

								if character_:IsDescendantOf(Workspace) then
									if not arg.Tag then
										task.defer(function()
											if
												flag8
												and arg.Version == version
											then
												fn56(arg, arg2, character_)
											end
										end)
									end

									return
								end

								arg.Version = arg.Version + 1
								fn55(arg)
							end)
						)
					)

				task.spawn(function()
					local head = character_:FindFirstChild("Head")
						or character_:WaitForChild("Head", 5)

					if
						not flag8
						or arg.Version ~= version
						or character_ ~= arg2.Character
						or not character_:IsDescendantOf(Workspace)
						or not head
						or not head:IsDescendantOf(character_)
					then
						if arg.Version == version then
							arg.BindingCharacter = nil
						end

						return
					end

					local v18 = fn24(character_, head)
					arg.Tag = fn40(arg2, head, v18)
					fn41(arg)
					arg.BindingCharacter = nil

					arg.CharacterConnections[#arg.CharacterConnections + 1] =
						runtime.Track(
							head.AncestryChanged:Connect(
								runtime.Guard(function()
									if
										not flag8
										or arg.Version ~= version
										or head:IsDescendantOf(character_)
									then
										return
									end
									arg.Version = arg.Version + 1
									fn55(arg)
									local character_2 = arg2.Character

									if
										character_2
										and character_2:IsDescendantOf(
											Workspace
										)
									then
										task.defer(function()
											if flag8 and tbl11[arg2] == arg then
												fn56(arg, arg2, character_2)
											end
										end)
									end
								end)
							)
						)

					fn43(arg, arg2)
					fn44(arg)
					fn48(arg, arg2)
					fn49(arg, arg2, version)
				end)
			end

			local function fn57(player)
				local v18 = tbl11[player]
				if not v18 then
					return
				end
				v18.Version = v18.Version + 1
				v18.StealingVersion = v18.StealingVersion + 1
				fn55(v18)
				fn21(v18.PlayerConnections)
				tbl11[player] = nil
			end

			local function fn58(player)
				if player == localPlayer or tbl11[player] then
					return
				end

				local tbl14 = {
					Version = 0,
					StealingVersion = 0,
					Character = nil,
					BindingCharacter = nil,
					Tag = nil,
					BrainrotName = nil,
					BrainrotGeneration = nil,
					BrainrotGenerationConnection = nil,
					BrainrotModel = nil,
					BrainrotHighlight = nil,
					NameDisplayHumanoid = nil,
					NameDisplayDistance = nil,
					RevealOriginals = {},
					RevealHidden = {},
					RevealBound = {},
					RevealConnections = {},
					CharacterConnections = {},
					PlayerConnections = {},
				}

				tbl11[player] = tbl14

				for _, v18 in ipairs({ "AdminCommands", "Role" }) do
					tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] =
						runtime.Track(
							player
								:GetAttributeChangedSignal(v18)
								:Connect(runtime.Guard(function()
									if flag8 and tbl11[player] == tbl14 then
										fn43(tbl14, player)
									end
								end))
						)
				end

				tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] =
					runtime.Track(
						player.CharacterAdded:Connect(
							runtime.Guard(function(character_)
								fn56(tbl14, player, character_)
							end)
						)
					)

				tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] =
					runtime.Track(
						player.CharacterRemoving:Connect(
							runtime.Guard(function(character_)
								if tbl14.Character == character_ then
									tbl14.Version = tbl14.Version + 1
									fn55(tbl14)
								end
							end)
						)
					)

				tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] =
					runtime.Track(
						player
							:GetPropertyChangedSignal("Character")
							:Connect(runtime.Guard(function()
								task.defer(function()
									if not flag8 or tbl11[player] ~= tbl14 then
										return
									end
									local character_ = player.Character

									if character_ ~= tbl14.Character then
										fn56(tbl14, player, character_)
									elseif tbl14.Tag then
										local adornee =
											tbl14.Tag.Billboard.Adornee

										if
											not adornee
											or not adornee:IsDescendantOf(
												Workspace
											)
										then
											fn56(tbl14, player, character_)
										end
									end
								end)
							end))
					)

				tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] =
					runtime.Track(
						player
							:GetAttributeChangedSignal("Stealing")
							:Connect(runtime.Guard(function()
								fn48(tbl14, player)
							end))
					)

				fn56(tbl14, player, player.Character)
			end

			local function fn59()
				for k, v18 in pairs(tbl11) do
					local character_ = k.Character

					if character_ and character_:IsDescendantOf(Workspace) then
						local tag = v18.Tag
						local billboard = tag and tag.Billboard
						tag = tag and tag.PlayerHighlight
						local adornee = billboard and billboard.Adornee
						local parent = billboard
							and billboard.Parent
							and adornee
							and adornee:IsDescendantOf(character_)
							and tag
							and tag.Parent
							and fn41(v18)

						if
							(v18.Character ~= character_ or not parent)
							and v18.BindingCharacter ~= character_
						then
							fn56(v18, k, character_)
						end
					elseif v18.Character then
						v18.Version = v18.Version + 1
						fn55(v18)
					end
				end
			end

			local function fn60()
				flag8 = false
				n14 += 1
				fn21(tbl12)
				local tbl14 = {}

				for k in pairs(tbl11) do
					tbl14[#tbl14 + 1] = k
				end

				for _, v18 in ipairs(tbl14) do
					fn57(v18)
				end
			end

			local function fn61()
				for _, v18 in pairs(tbl11) do
					if v18.Tag and v18.Tag.Billboard.Parent then
						fn39(v18.Tag, v18.Tag.HasTool == true)
					end
				end
			end

			local function fn62()
				for _, v18 in pairs(tbl11) do
					if v18.Tag and v18.Tag.Billboard.Parent then
						fn44(v18)
						fn45(v18)
					end
				end
			end

			local function fn63()
				fn60()
				flag8 = true
				local v18 = n14
				tbl12[#tbl12 + 1] = runtime.Track(
					Players.PlayerAdded:Connect(runtime.Guard(fn58))
				)
				tbl12[#tbl12 + 1] = runtime.Track(
					Players.PlayerRemoving:Connect(runtime.Guard(fn57))
				)
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					tbl12[#tbl12 + 1] = runtime.Track(
						currentCamera
							:GetPropertyChangedSignal("ViewportSize")
							:Connect(runtime.Guard(fn61))
					)
				end

				for _, player in ipairs(Players:GetPlayers()) do
					fn58(player)
				end

				task.spawn(function()
					while flag8 and n14 == v18 do
						task.wait(0.2)

						if flag8 and n14 == v18 then
							fn59()
						end
					end
				end)
			end

			runtime.Track(bindableEvent.Event:Connect(runtime.Cleanup(fn60)))
			runtime.Track(screenGui.Destroying:Connect(runtime.Guard(fn60)))

			v13:CreateToggle({
				Name = "Player ESP",
				Default = false,
				Callback = function(arg)
					if arg then
						fn63()
					else
						fn60()
					end
				end,
			})

			v13:CreateMultiDropdown({
				Name = "Show Information",
				Note = "Choose what Player ESP shows. Username replaces the display name.",
				Options = {
					"Name",
					"Username",
					"Avatar",
					"Tool",
					"Brainrot",
					"Admin Panel",
				},
				Default = { "Name", "Tool", "Brainrot", "Admin Panel" },
				Callback = function(arg)
					local tbl14 = {
						Name = false,
						Username = false,
						Avatar = false,
						Tool = false,
						Brainrot = false,
						["Admin Panel"] = false,
					}

					if type(arg) == "table" then
						for k, v18 in pairs(arg) do
							if type(v18) == "string" and tbl14[v18] ~= nil then
								tbl14[v18] = true
							elseif
								type(k) == "string"
								and v18 == true
								and tbl14[k] ~= nil
							then
								tbl14[k] = true
							end
						end
					end

					tbl10 = tbl14
					fn62()
				end,
			})

			v13:CreateSlider({
				Name = "ESP Size",
				Min = 50,
				Max = 200,
				Default = 100,
				AllowDecimals = false,
				Increment = 1,
				Unit = "%",
				Callback = function(arg)
					n13 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
					fn61()
				end,
			})
		end

		do
			local chilliBaseLockTimerRuntime, v17 =
				fn5("__Nullx11BrainrotBaseLockTimerRuntime")
			local flag9 = false
			n = 1
			local v18 = nil
			local folder = nil
			local tbl13 = {}
			local tbl14 = {}
			local color = Color3.fromRGB(255, 58, 74)
			local color2 = Color3.fromRGB(154, 255, 62)
			local colorSequence2 = ColorSequence.new
			local tbl15 = {}
			local v19 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
			local v20 =
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(222, 222, 222))
			tbl15[1] = v19
			tbl15[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
				)
				table.move(values, 1, values.n, 3, tbl15)
			end

			local v21 = colorSequence2(tbl15)

			local function fn25()
				local currentCamera = Workspace.CurrentCamera
				local n15 = math.floor(
					math.clamp(
						(currentCamera and currentCamera.ViewportSize.Y or 1080)
							* 0.064,
						52,
						76
					)
				)
				return math.floor(n15 * 2.8), n15
			end

			local function fn26(arg)
				if not arg.Tag or not arg.Tag.Gui or not arg.Tag.Gui.Parent then
					return
				end
				local v22, v23 = fn25()
				arg.Tag.Gui.Size = UDim2.fromOffset(
					math.floor(v22 * n + 0.5),
					math.floor(v23 * n + 0.5)
				)
			end

			local function createPart(arg)
				local v22 = fn17(arg)
				if not v22 then
					return nil
				end
				local part = Instance.new("Part")
				part.Name = fn()
				part.Size = Vector3.one
				part.Transparency = 1
				part.Anchored = true
				part.CanCollide = false
				part.CanTouch = false
				part.CanQuery = false
				part.Massless = true
				part.CastShadow = false
				part.Position = v22
				part.Parent = folder
				return part
			end

			local function fn27(arg)
				local v22 = createPart(arg)
				if not v22 then
					return nil
				end
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "BaseLockTimer"
				billboardGui.Adornee = v22
				billboardGui.AlwaysOnTop = true
				billboardGui.LightInfluence = 0
				billboardGui.MaxDistance = 2500
				billboardGui.Parent = chilliBaseLockTimerRuntime
				local frame = Instance.new("Frame")
				frame.Name = "Frame"
				frame.BackgroundTransparency = 1
				frame.BorderSizePixel = 0
				frame.Size = UDim2.fromScale(1, 1)
				frame.Parent = billboardGui
				local textLabel = Instance.new("TextLabel")
				textLabel.Name = "Status"
				textLabel.BackgroundTransparency = 1
				textLabel.FontFace = Font.new(
					"rbxasset://fonts/families/FredokaOne.json",
					Enum.FontWeight.Regular,
					Enum.FontStyle.Normal
				)
				textLabel.Position = UDim2.fromScale(0.02, 0)
				textLabel.Size = UDim2.fromScale(0.96, 0.53)
				textLabel.Text = "Open"
				textLabel.TextColor3 = color2
				textLabel.TextScaled = true
				textLabel.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
				textLabel.TextStrokeTransparency = 0
				textLabel.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Name = "TextOutline"
				uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				uiStroke.Color = textLabel.TextStrokeColor3
				uiStroke.LineJoinMode = Enum.LineJoinMode.Round
				uiStroke.Thickness = 2.1
				uiStroke.Transparency = 0
				uiStroke.Parent = textLabel
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Name = "Sheen"
				uiGradient.Color = v21
				uiGradient.Rotation = 90
				uiGradient.Parent = textLabel
				local textLabel2 = Instance.new("TextLabel")
				textLabel2.Name = "Timer"
				textLabel2.BackgroundTransparency = 1
				textLabel2.FontFace = Font.new(
					"rbxasset://fonts/families/FredokaOne.json",
					Enum.FontWeight.Regular,
					Enum.FontStyle.Normal
				)
				textLabel2.Position = UDim2.fromScale(0.02, 0.43)
				textLabel2.Size = UDim2.fromScale(0.96, 0.57)
				textLabel2.Text = ""
				textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel2.TextScaled = true
				textLabel2.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
				textLabel2.TextStrokeTransparency = 0
				textLabel2.Visible = false
				textLabel2.Parent = frame
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Name = "Sheen"
				uiGradient2.Color = v21
				uiGradient2.Rotation = 90
				uiGradient2.Parent = textLabel2
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Name = "TextOutline"
				uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				uiStroke2.Color = textLabel2.TextStrokeColor3
				uiStroke2.LineJoinMode = Enum.LineJoinMode.Round
				uiStroke2.Thickness = 2.1
				uiStroke2.Transparency = 0.05
				uiStroke2.Parent = textLabel2

				return {
					Gui = billboardGui,
					Anchor = v22,
					Status = textLabel,
					StatusStroke = uiStroke,
					Timer = textLabel2,
					TimerStroke = uiStroke2,
					StatusStyleSource = nil,
					TimerStyleSource = nil,
					StatusMode = nil,
				}
			end

			local function fn28(arg, arg2, arg3, textColor3)
				if arg3 and arg3:IsA("TextLabel") then
					arg.FontFace = arg3.FontFace
					arg.TextColor3 = arg3.TextColor3
					arg.TextStrokeColor3 = arg3.TextStrokeColor3
					arg.TextStrokeTransparency = arg3.TextStrokeTransparency
				else
					arg.TextColor3 = textColor3
				end

				arg2.Color = arg.TextStrokeColor3
				arg2.Transparency =
					math.clamp(arg.TextStrokeTransparency * 0.35, 0, 0.35)
			end

			local function fn29(arg)
				local str = tostring(arg or "")
				local n15 = tonumber(str:match("(%d+)%s*[mM]")) or 0
				local num = tonumber(str:match("(%d+)%s*[sS]"))

				if num == nil and n15 == 0 then
					num = tonumber(str:match("%d+")) or 0
				end

				return n15 * 60 + (num or 0)
			end

			local function fn30(arg)
				if not flag9 or not arg.Tag then
					return
				end
				local anchor = arg.Tag.Anchor
				if not anchor or not anchor.Parent then
					arg.Tag.Gui.Enabled = false
					return
				end
				local v22 = fn17(arg.Base)

				if v22 and anchor.Position ~= v22 then
					anchor.Position = v22
				end

				local v23 = nil
				local v24 = nil
				local flag10 = false
				local n15 = -1
				local v25 = nil
				local v26 = nil

				for _, timerLabel in ipairs(arg.TimerLabels) do
					if timerLabel.Parent then
						local locked =
							timerLabel.Parent:FindFirstChild("Locked")
						local open = timerLabel.Parent:FindFirstChild("Open")
							or timerLabel.Parent:FindFirstChild("Unlocked")

						if not v23 and locked and locked:IsA("TextLabel") then
							v23 = locked
						end

						if not v24 and open and open:IsA("TextLabel") then
							v24 = open
						end

						if
							timerLabel.Visible
							or locked
								and locked:IsA("GuiObject")
								and locked.Visible
						then
							local str = tostring(timerLabel.Text or "")
							local v27 = fn29(str)
							flag10 = true
							local flag11 = true

							if not (n15 < v27) then
								flag10 = flag11
							else
								n15 = v27
								v25 = str
								v26 = timerLabel
							end
						end
					end
				end

				arg.Tag.Gui.Enabled = not string.find(
					string.lower(fn16(arg.Base)),
					"empty base",
					1,
					true
				)
				if not arg.Tag.Gui.Enabled then
					return
				end

				if flag10 then
					arg.Tag.Status.Position = UDim2.fromScale(0.02, 0)
					arg.Tag.Status.Size = UDim2.fromScale(0.96, 0.53)
					arg.Tag.Status.Text = "Locked:"
					arg.Tag.Timer.Text = v25 or ""
					arg.Tag.Timer.Visible = v25 ~= nil and v25 ~= ""

					if
						arg.Tag.StatusMode ~= "Locked"
						or arg.Tag.StatusStyleSource ~= v23
					then
						arg.Tag.StatusMode = "Locked"
						arg.Tag.StatusStyleSource = v23
						fn28(arg.Tag.Status, arg.Tag.StatusStroke, v23, color)
					end

					if arg.Tag.TimerStyleSource ~= v26 then
						arg.Tag.TimerStyleSource = v26
						fn28(
							arg.Tag.Timer,
							arg.Tag.TimerStroke,
							v26,
							Color3.fromRGB(255, 255, 255)
						)
					end
				else
					arg.Tag.Status.Position = UDim2.fromScale(0.08, 0.15)
					arg.Tag.Status.Size = UDim2.fromScale(0.84, 0.7)
					arg.Tag.Status.Text = "Open"
					arg.Tag.Timer.Text = ""
					arg.Tag.Timer.Visible = false
					v24 = v24 or v23

					if
						arg.Tag.StatusMode ~= "Open"
						or arg.Tag.StatusStyleSource ~= v24
					then
						arg.Tag.StatusMode = "Open"
						arg.Tag.StatusStyleSource = v24
						fn28(arg.Tag.Status, arg.Tag.StatusStroke, v24, color2)
						arg.Tag.Status.TextColor3 = color2
					end
				end
			end

			local function fn31(arg)
				fn6(arg.TimerConnections)
				table.clear(arg.TimerLabels)
				if not arg.Base.Parent then
					return
				end

				for _, descendant in ipairs(arg.Base:GetDescendants()) do
					if
						descendant:IsA("TextLabel")
						and descendant.Name == "RemainingTime"
					then
						arg.TimerLabels[#arg.TimerLabels + 1] = descendant

						arg.TimerConnections[#arg.TimerConnections + 1] =
							runtime.Track(
								descendant
									:GetPropertyChangedSignal("Text")
									:Connect(runtime.Guard(function()
										fn30(arg)
									end))
							)

						arg.TimerConnections[#arg.TimerConnections + 1] =
							runtime.Track(
								descendant
									:GetPropertyChangedSignal("Visible")
									:Connect(runtime.Guard(function()
										fn30(arg)
									end))
							)

						local locked = descendant.Parent
							and descendant.Parent:FindFirstChild("Locked")

						if locked and locked:IsA("GuiObject") then
							arg.TimerConnections[#arg.TimerConnections + 1] =
								runtime.Track(
									locked
										:GetPropertyChangedSignal("Visible")
										:Connect(runtime.Guard(function()
											fn30(arg)
										end))
								)
						end
					end
				end

				fn30(arg)
			end

			local function fn32(child)
				local v22 = tbl13[child]
				if not v22 then
					return
				end
				fn6(v22.Connections)
				fn6(v22.TimerConnections)

				if v22.Tag and v22.Tag.Gui then
					v22.Tag.Gui:Destroy()
				end

				if v22.Tag and v22.Tag.Anchor then
					v22.Tag.Anchor:Destroy()
				end

				tbl13[child] = nil
			end

			local function fn33(child)
				if not flag9 or not child:IsA("Model") or tbl13[child] then
					return
				end
				local v22 = fn27(child)
				if not v22 then
					return
				end

				local tbl16 = {
					Base = child,
					Tag = v22,
					TimerLabels = {},
					Connections = {},
					TimerConnections = {},
					RefreshPending = false,
				}

				tbl13[child] = tbl16
				fn26(tbl16)

				local function fn34(descendant)
					if
						descendant
						and descendant.Name ~= "RemainingTime"
						and descendant.Name ~= "Locked"
						and not fn18(descendant)
					then
						return
					end

					if tbl16.RefreshPending then
						return
					end
					tbl16.RefreshPending = true

					task.defer(function()
						tbl16.RefreshPending = false

						if flag9 and tbl13[child] == tbl16 then
							fn31(tbl16)
						end
					end)
				end

				tbl16.Connections[#tbl16.Connections + 1] = runtime.Track(
					child.DescendantAdded:Connect(runtime.Guard(fn34))
				)
				tbl16.Connections[#tbl16.Connections + 1] = runtime.Track(
					child.DescendantRemoving:Connect(runtime.Guard(fn34))
				)

				tbl16.Connections[#tbl16.Connections + 1] = runtime.Track(
					child.Destroying:Connect(runtime.Guard(function()
						fn32(child)
					end))
				)

				local v23 = fn8(child)

				if v23 then
					tbl16.Connections[#tbl16.Connections + 1] = runtime.Track(
						v23:GetPropertyChangedSignal("Text")
							:Connect(runtime.Guard(function()
								fn30(tbl16)
							end))
					)
				end

				fn31(tbl16)
			end

			fn13 = function()
				for _, v22 in pairs(tbl13) do
					fn26(v22)
				end
			end

			fn14 = function()
				flag9 = false
				fn6(tbl14)
				local tbl16 = {}

				for k in pairs(tbl13) do
					tbl16[#tbl16 + 1] = k
				end

				for _, v22 in ipairs(tbl16) do
					fn32(v22)
				end

				if folder then
					folder:Destroy()
					folder = nil
				end

				v18 = nil
			end

			local function fn34(arg)
				v18 = arg
				tbl14[#tbl14 + 1] =
					runtime.Track(arg.ChildAdded:Connect(runtime.Guard(fn33)))
				tbl14[#tbl14 + 1] =
					runtime.Track(arg.ChildRemoved:Connect(runtime.Guard(fn32)))

				tbl14[#tbl14 + 1] = runtime.Track(
					arg.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if not fn18(descendant) then
								return
							end
							local parent = descendant.Parent

							if parent and parent.Parent == arg then
								fn33(parent)
							end
						end)
					)
				)

				for _, child in ipairs(arg:GetChildren()) do
					fn33(child)
				end
			end

			fn15 = function()
				fn14()
				flag9 = true
				folder = Instance.new("Folder")
				folder.Name = fn()
				folder.Archivable = false
				folder.Parent = Workspace
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					tbl14[#tbl14 + 1] = runtime.Track(
						currentCamera
							:GetPropertyChangedSignal("ViewportSize")
							:Connect(runtime.Guard(fn13))
					)
				end

				tbl14[#tbl14 + 1] = runtime.Track(
					Workspace:GetPropertyChangedSignal("CurrentCamera")
						:Connect(runtime.Guard(fn13))
				)
				local plots = Workspace:FindFirstChild("Plots")

				if plots then
					fn34(plots)
				else
					tbl14[#tbl14 + 1] = runtime.Track(
						Workspace.ChildAdded:Connect(
							runtime.Guard(function(child)
								if flag9 and child.Name == "Plots" then
									fn34(child)
								end
							end)
						)
					)
				end
			end

			runtime.Track(v17.Event:Connect(runtime.Guard(fn14)))
			runtime.Track(
				chilliBaseLockTimerRuntime.Destroying:Connect(
					runtime.Guard(fn14)
				)
			)
		end
	end

	local chilliBrainrotESPRuntime, v12, tbl4, flag2, tbl5, tbl6, n2, flag3, flag4, n3
	local tbl7, tbl8, fn16, fn17, fn18, fn19, fn20, fn21, fn22, fn23
	local attachment, v13, v14, fn24, fn25, fn26, fn27, n4, fn28, fn29

	do
		local v15 = v11:CreateToggle({
			Name = "Timer ESP",
			Default = false,
			Callback = function(arg)
				if arg then
					fn15()
				else
					fn14()
				end
			end,
		})

		v11:CreateSlider({
			Name = "Timer ESP Size",
			Min = 50,
			Max = 200,
			Default = 80,
			AllowDecimals = false,
			Increment = 1,
			Unit = "%",
			Quick = false,
			SubOf = v15,
			ShowWhen = v15,
			Callback = function(arg)
				n = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
				fn13()
			end,
		})

		local chilliYourBaseESPRuntime, v16
		chilliYourBaseESPRuntime, v16 =
			fn5("__Nullx11BrainrotYourBaseESPRuntime")
		local fillTransparency
		fillTransparency = 0.45
		local color
		color = Color3.fromRGB(255, 255, 255)
		local flag5, flag6, flag7, v17, v18, highlight, attachment2, attachment3, beam, beam2
		local tbl9, flag8, flag9, tbl10, tbl11

		do
			local tbl12 = {
				AnimalPodiums = true,
				Unlock = true,
				PlotSign = true,
				Purchases = true,
				Conveyor = true,
				Walls = true,
				Wall = true,
				Floors = true,
				Floor = true,
				Roof = true,
				Decorations = true,
				Model = true,
				Laser = true,
				LaserHitbox = true,
				InvisibleWalls = true,
				Spawn = true,
			}

			flag5 = false
			flag6 = false
			flag7 = false
			v17 = nil
			v18 = nil
			highlight = nil
			attachment2 = nil
			attachment3 = nil
			beam = nil
			beam2 = nil
			local v19 = nil
			local v20 = nil
			local n5 = 0.5
			tbl9 = { Part = nil, Base = nil, Dirty = true, NextLookup = 0 }
			flag8 = false
			flag9 = false
			local tbl13 = {}
			local n6 = 0
			local tbl14 = {}
			local obj2 = setmetatable({}, { __mode = "k" })
			tbl10 = {}
			tbl11 = {}
			local connection = nil

			local function fn30(arg, arg2)
				local v21 = obj2[arg]
				if v21 ~= nil then
					return v21
				end
				local flag10 = false

				if not tbl12[arg.Name] then
					if arg.Parent == arg2 then
						flag10 = true
					elseif
						arg:FindFirstChildOfClass("Humanoid")
						or arg:FindFirstChildOfClass("AnimationController")
						or arg:GetAttribute("Mutation") ~= nil
					then
						flag10 = true
					end
				end

				if flag10 or #arg:GetChildren() > 0 then
					obj2[arg] = flag10
				end

				return flag10
			end

			local function fn31(arg, arg2)
				if not arg:IsA("BasePart") or arg.Transparency >= 1 then
					return false
				end

				if arg.Name == "PlotSign" then
					return false
				end

				for _, child in ipairs(arg:GetChildren()) do
					if
						child:IsA("SurfaceGui")
						or child:IsA("BillboardGui")
						or child:IsA("Decal")
						or child:IsA("Texture")
					then
						return false
					end
				end

				while arg and arg ~= arg2 do
					if arg:IsA("Model") and fn30(arg, arg2) then
						return false
					end
					arg = arg.Parent
				end

				return arg == arg2
			end

			local function fn32(arg, arg2)
				if tbl14[arg] ~= nil or not fn31(arg, arg2) or #tbl13 == 0 then
					return
				end
				n6 += 1
				local v21 = tbl13[(n6 - 1) % #tbl13 + 1]
				local color2 = arg.Color
				tbl14[arg] = color2
				arg.Color = color2:Lerp(v21, 0.78)
			end

			local function fn33()
				for k, v21 in pairs(tbl14) do
					if k.Parent then
						pcall(function()
							k.Color = v21
						end)
					end
				end

				table.clear(tbl14)
				table.clear(obj2)
				table.clear(tbl13)
				n6 = 0
				flag9 = false
			end

			local function fn34(arg)
				fn33()
				if not arg or not arg.Parent then
					return
				end
				tbl13 = fn12("Phantom")

				for _, descendant in ipairs(arg:GetDescendants()) do
					fn32(descendant, arg)
				end

				flag9 = true
			end

			local function fn35(arg)
				for _, descendant in ipairs(arg:GetDescendants()) do
					local isTextLabel = descendant:IsA("TextLabel")

					if isTextLabel then
						isTextLabel = string.find(
							string.lower(tostring(descendant.Text or "")),
							"collect",
							1,
							true
						)
					end

					if isTextLabel then
						local parent = descendant.Parent

						while parent and parent ~= arg do
							if parent:IsA("BasePart") then
								return parent
							end
							parent = parent.Parent
						end
					end
				end

				local cashPad = arg:FindFirstChild("CashPad")
					or arg:FindFirstChild("Cash")
				return cashPad
						and cashPad:FindFirstChildWhichIsA("BasePart", true)
					or nil
			end

			local function fn36(arg, arg2)
				while arg and arg ~= arg2 do
					local str = string.lower(arg.Name):gsub("[^%w]", "")
					local flag10 = str == "cashpad"
						or str == "cash"
						or string.find(str, "collect", 1, true)

					if not flag10 then
						flag10 = arg:IsA("TextLabel")

						if flag10 then
							flag10 = string.find(
								string.lower(tostring(arg.Text or "")),
								"collect",
								1,
								true
							)
						end
					end

					if flag10 then
						return true
					end
					arg = arg.Parent
				end

				return false
			end

			local function fn37()
				if attachment2 then
					attachment2:Destroy()
				end

				if attachment3 then
					attachment3:Destroy()
				end

				attachment2 = nil
				attachment3 = nil
				beam = nil
				beam2 = nil
				v19 = nil
				v20 = nil
			end

			local function fn38(arg)
				local v21 = v18
				if not v21 then
					return nil
				end
				local part = tbl9.Part

				if tbl9.Base ~= v21 or part and not part.Parent then
					tbl9.Dirty = true
				end

				if part and part.Parent and not tbl9.Dirty then
					return part
				end

				if not tbl9.Dirty and arg < tbl9.NextLookup then
					return nil
				end
				local v22 = fn35(v21)
				tbl9.Part = v22
				tbl9.Base = v21
				tbl9.Dirty = false
				tbl9.NextLookup = arg + n5
				return v22
			end

			local function fn39(parent, parent2)
				fn37()
				attachment2 = Instance.new("Attachment")
				attachment2.Name = fn()
				attachment2.Archivable = false
				attachment2.Position = Vector3.zero
				attachment2.Parent = parent
				attachment3 = Instance.new("Attachment")
				attachment3.Name = fn()
				attachment3.Archivable = false
				attachment3.Position =
					Vector3.new(0, parent2.Size.Y * 0.5 + 5, 0)
				attachment3.Parent = parent2
				beam2 = Instance.new("Beam")
				beam2.Name = fn()
				beam2.Archivable = false
				beam2.Attachment0 = attachment2
				beam2.Attachment1 = attachment3
				beam2.FaceCamera = true
				beam2.Width0 = 0.38
				beam2.Width1 = 0.56
				beam2.Segments = 20
				beam2.CurveSize0 = 1.8
				beam2.CurveSize1 = -1.8
				beam2.LightEmission = 1
				beam2.Color = ColorSequence.new(
					Color3.fromRGB(20, 145, 255),
					Color3.fromRGB(90, 240, 255)
				)
				beam2.Transparency = NumberSequence.new(0.72)
				beam = Instance.new("Beam")
				beam.Name = fn()
				beam.Archivable = false
				beam.Attachment0 = attachment2
				beam.Attachment1 = attachment3
				beam.FaceCamera = true
				beam.Width0 = 0.09
				beam.Width1 = 0.18
				beam.Segments = 20
				beam.CurveSize0 = 1.8
				beam.CurveSize1 = -1.8
				beam.LightEmission = 1
				local v21 = beam
				local colorSequence = ColorSequence.new
				local tbl15 = {}
				local v22 =
					ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 205, 255))
				local v23 = ColorSequenceKeypoint.new(
					0.5,
					Color3.fromRGB(225, 255, 255)
				)
				local new = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				tbl15[1] = v22
				tbl15[2] = v23

				do
					local values = table.pack(new(1, color2(70, 165, 255)))
					table.move(values, 1, values.n, 3, tbl15)
				end

				v21.Color = colorSequence(tbl15)
				beam.Transparency = NumberSequence.new(0.04)
				obj[beam2] = true
				obj[beam] = true
				local flag10 = v4:NextInteger(0, 1) == 0
				beam2.Parent = flag10 and attachment2 or attachment3
				beam.Parent = flag10 and attachment3 or attachment2
				v19 = parent
				v20 = parent2
			end

			local function fn40()
				if not (flag5 and flag7) then
					if attachment2 then
						fn37()
					end

					return
				end

				local flag10 = localPlayer:GetAttribute("Stealing") == true
					and v18 ~= nil
					and fn7()
				local v21 = flag10 and fn38(os.clock())

				if not (flag10 and v21) then
					if attachment2 then
						fn37()
					end
				else
					local flag11 = v19 ~= flag10 or v20 ~= v21

					if not flag11 then
						flag11 = not (attachment2 and attachment2.Parent)
					end

					if not flag11 then
						flag11 = not (attachment3 and attachment3.Parent)
					end

					if not flag11 then
						flag11 = not (beam and beam.Parent)
					end

					if not flag11 then
						flag11 = not (beam2 and beam2.Parent)
					end

					if flag11 then
						fn39(flag10, v21)
					end
				end
			end

			local function fn41()
				local flag10 = flag5
					and v18 ~= nil
					and localPlayer:GetAttribute("Stealing") == true
				local v21 = flag10 and flag6
				flag10 = flag10 and flag7

				if v21 and not flag9 then
					fn34(v18)
				elseif not v21 and flag9 then
					fn33()
				end

				if highlight and highlight.Parent then
					highlight.Enabled = v21
				end

				fn11("UnfadedPlot", (v21 or flag10) and v18 or nil)
			end

			local function fn42()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				fn37()
				fn33()

				if highlight then
					highlight:Destroy()
					highlight = nil
				end

				v18 = nil
				fn41()
			end

			local function fn43(adornee)
				v18 = adornee
				highlight = Instance.new("Highlight")
				highlight.Name = "YourBaseHighlight"
				highlight.Adornee = adornee
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.FillTransparency = fillTransparency
				highlight.OutlineTransparency = 0
				highlight.Parent = chilliYourBaseESPRuntime
				local v21 = fn12("Phantom")[1] or color
				highlight.FillColor = v21
				highlight.OutlineColor = v21

				connection = runtime.Track(
					adornee.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag5 and v18 == adornee then
								if flag9 then
									fn32(descendant, adornee)
								end

								if
									not (tbl9.Part and tbl9.Part.Parent)
									and fn36(descendant, adornee)
								then
									tbl9.Dirty = true
								end
							end
						end)
					)
				)

				fn41()
			end

			local function fn44()
				if not v17 then
					return nil
				end

				for _, child in ipairs(v17:GetChildren()) do
					if child:IsA("Model") and fn9(child) then
						return child
					end
				end

				return nil
			end

			local function fn45()
				flag8 = false
				if not flag5 then
					return
				end
				local v21 = fn44()
				if v21 == v18 and highlight and highlight.Parent then
					fn41()
					return
				end
				fn42()

				if v21 then
					fn43(v21)
				end
			end

			local function fn46()
				if flag8 then
					return
				end
				flag8 = true
				task.defer(fn45)
			end

			local function fn47()
				fn6(tbl11)
				if not v17 then
					return
				end

				for _, child in ipairs(v17:GetChildren()) do
					local v21 = fn8(child)

					if v21 then
						tbl11[#tbl11 + 1] = runtime.Track(
							v21:GetPropertyChangedSignal("Text")
								:Connect(runtime.Guard(fn46))
						)
					end
				end
			end

			local function fn48()
				if not flag5 then
					return
				end
				fn47()
				fn46()
			end

			local function fn49(arg)
				v17 = arg

				tbl10[#tbl10 + 1] = runtime.Track(
					arg.ChildAdded:Connect(runtime.Guard(function()
						task.defer(fn48)
					end))
				)

				tbl10[#tbl10 + 1] = runtime.Track(
					arg.ChildRemoved:Connect(runtime.Guard(function()
						task.defer(fn48)
					end))
				)

				tbl10[#tbl10 + 1] = runtime.Track(
					arg.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if descendant:IsA("TextLabel") then
								task.defer(fn48)
							end
						end)
					)
				)

				fn47()
				fn45()
			end

			local function fn50()
				flag5 = false
				flag8 = false
				fn6(tbl10)
				fn6(tbl11)
				fn42()
				v17 = nil
			end

			local function fn51()
				fn50()
				flag5 = true
				tbl10[#tbl10 + 1] = runtime.Track(
					RunService.RenderStepped:Connect(runtime.Guard(fn40))
				)
				tbl10[#tbl10 + 1] = runtime.Track(
					localPlayer
						:GetAttributeChangedSignal("Stealing")
						:Connect(runtime.Guard(fn41))
				)

				tbl10[#tbl10 + 1] = runtime.Track(
					localPlayer.CharacterAdded:Connect(
						runtime.Guard(function(character_)
							task.spawn(function()
								character_:WaitForChild("HumanoidRootPart", 5)

								if
									flag5
									and character_ == localPlayer.Character
								then
									fn37()
									fn41()
								end
							end)
						end)
					)
				)

				local plots = Workspace:FindFirstChild("Plots")

				if plots then
					fn49(plots)
				else
					tbl10[#tbl10 + 1] = runtime.Track(
						Workspace.ChildAdded:Connect(
							runtime.Guard(function(child)
								if flag5 and child.Name == "Plots" then
									fn49(child)
								end
							end)
						)
					)
				end
			end

			local function fn52()
				local v21 = flag6
				local v22

				if flag6 then
					v22 = v21
				else
					v22 = flag7
				end

				if v22 and not flag5 then
					fn51()
				elseif not v22 and flag5 then
					fn50()
				elseif v22 then
					fn41()
				end
			end

			runtime.Track(v16.Event:Connect(runtime.Guard(fn50)))
			runtime.Track(
				chilliYourBaseESPRuntime.Destroying:Connect(runtime.Guard(fn50))
			)

			v11:CreateToggle({
				Name = "Your Base ESP (While Stealing)",
				Default = false,
				Callback = function(arg)
					flag6 = arg == true
					fn52()
				end,
			})

			v11:CreateToggle({
				Name = "Beam to Your Base (While Stealing)",
				Default = false,
				Callback = function(arg)
					flag7 = arg == true
					fn52()
				end,
			})
		end

		v11:CreateSlider({
			Name = "Base Transparency",
			Min = 0,
			Max = 100,
			Default = 80,
			AllowDecimals = false,
			Increment = 1,
			Unit = "%",
			ShowWhen = v11:CreateToggle({
				Name = "Clear Base",
				Default = false,
				Callback = function(arg)
					fn11("YourBaseClear", arg == true)
				end,
			}),
			Note = "Adjusts base visibility: 0% keeps the original look and 100% makes it invisible.",
			Callback = function(arg)
				fn11(
					"ClearBaseTransparency",
					math.clamp(tonumber(arg) or 80, 0, 100) / 100
				)
			end,
		})

		local n5
		n5 = math.clamp(tonumber(tbl3.ClearBaseTransparency) or 0.8, 0, 1)
		local n6
		n6 = 0.0015
		local folder, bindableEvent, flag10, n7, plots, connection, connection2

		do
			local tbl12 = {
				AnimalPodiums = true,
				Unlock = true,
				PlotSign = true,
				Purchases = true,
				Conveyor = true,
				Walls = true,
				Wall = true,
				Floors = true,
				Floor = true,
				Roof = true,
				Decorations = true,
			}

			local v19 = fn4()
			local tbl13 = {}

			for _, v20 in ipairs({ v19, CoreGui }) do
				if v20 and not tbl13[v20] then
					tbl13[v20] = true
					local chilliFadePlotsRuntime =
						v20:FindFirstChild("__Nullx11BrainrotFadePlotsRuntime")

					if chilliFadePlotsRuntime then
						local cleanup =
							chilliFadePlotsRuntime:FindFirstChild("Cleanup")

						if cleanup and cleanup:IsA("BindableEvent") then
							pcall(function()
								cleanup:Fire()
							end)
						end

						pcall(function()
							chilliFadePlotsRuntime:Destroy()
						end)
					end
				end
			end

			folder = Instance.new("Folder")
			folder.Name = "__Nullx11BrainrotFadePlotsRuntime"
			folder.Archivable = false
			folder.Parent = v19
			bindableEvent = Instance.new("BindableEvent")
			bindableEvent.Name = "Cleanup"
			bindableEvent.Parent = folder
			flag10 = false
			n7 = 0
			plots = nil
			connection = nil
			connection2 = nil
			local v20 = Random.new()
			local tbl14 = {}
			local n8 = 0
			local flag11 = false
			local v21 = nil
			local tbl15 = {}
			local obj2 = setmetatable({}, { __mode = "k" })

			local function fn30(arg)
				while arg do
					local parent = arg.Parent
					if parent == plots then
						return arg
					end

					if not parent or parent == Workspace then
						return nil
					end
					arg = parent
				end

				return nil
			end

			local function fn31(arg, arg2)
				local v22 = obj2[arg]
				if v22 ~= nil then
					return v22
				end
				local flag12 = false

				if not tbl12[arg.Name] then
					if arg.Parent == arg2 then
						flag12 = true
					elseif
						arg:FindFirstChildOfClass("Humanoid")
						or arg:FindFirstChildOfClass("AnimationController")
					then
						flag12 = true
					end
				end

				if flag12 or #arg:GetChildren() > 0 then
					obj2[arg] = flag12
				end

				return flag12
			end

			local function fn32(arg, arg2)
				while arg and arg ~= arg2 do
					if arg:IsA("Model") and fn31(arg, arg2) then
						return true
					end
					arg = arg.Parent
				end

				return false
			end

			local function fn33(arg)
				if tbl15[arg] ~= nil then
					return
				end

				if not arg:IsA("BasePart") then
					return
				end

				if arg.Transparency >= 1 then
					return
				end
				local v22 = fn30(arg)
				if not v22 or v22 == v21 or fn32(arg, v22) then
					return
				end
				local localTransparencyModifier = arg.LocalTransparencyModifier

				if math.abs(localTransparencyModifier - n5) <= 0.001 then
					localTransparencyModifier = 0
				end

				tbl15[arg] = localTransparencyModifier

				pcall(function()
					arg.LocalTransparencyModifier =
						math.max(localTransparencyModifier, n5)
				end)
			end

			local function fn34()
				for k, v22 in pairs(tbl15) do
					pcall(function()
						k.LocalTransparencyModifier = v22
					end)
				end

				table.clear(tbl15)
				table.clear(obj2)
				table.clear(tbl14)
				n8 = 0
				flag11 = false
			end

			local function fn35(arg)
				for k, v22 in pairs(tbl15) do
					if fn30(k) == arg then
						pcall(function()
							k.LocalTransparencyModifier = v22
						end)

						tbl15[k] = nil
					end
				end
			end

			local function fn36(arg)
				if not arg or not arg.Parent then
					return
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					fn33(descendant)
				end
			end

			local function fn37(arg)
				if v21 == arg then
					return
				end
				local v22 = v21
				v21 = arg
				if not flag10 then
					return
				end

				if arg then
					fn35(arg)
				end

				if v22 then
					fn36(v22)
				end
			end

			local function fn38(arg)
				n5 = math.clamp(tonumber(arg) or 0.8, 0, 1)
				if not flag10 then
					return
				end

				for k, v22 in pairs(tbl15) do
					if k.Parent then
						pcall(function()
							k.LocalTransparencyModifier = math.max(v22, n5)
						end)
					else
						tbl15[k] = nil
					end
				end
			end

			fn10(function(arg, arg2)
				if arg == "UnfadedPlot" then
					local v22 = fn37
					arg2 = typeof(arg2) == "Instance" and arg2
					v22(arg2 or nil)
				elseif arg == "ClearBaseTransparency" then
					fn38(arg2)
				end
			end)

			local function fn39(arg)
				n8 += 1
				tbl14[n8] = arg
				if flag11 then
					return
				end
				flag11 = true
				local v22 = n7

				task.delay(v20:NextNumber(0.18, 0.42), function()
					flag11 = false
					if not flag10 or v22 ~= n7 then
						return
					end
					local v23 = tbl14
					local v24 = n8
					tbl14 = {}
					n8 = 0

					for i_ = 1, v24 do
						local v25 = v23[i_]

						if v25 and v25.Parent then
							fn33(v25)
						end
					end
				end)
			end

			local function fn40()
				n7 += 1
				local v22 = n7

				task.spawn(function()
					local children = plots:GetChildren()
					local n9 = 1

					while flag10 and v22 == n7 and n9 <= #children do
						local now = os.clock()

						while true do
							local v23 = children[n9]
							n9 += 1

							if v23 then
								fn33(v23)

								for _, child in ipairs(v23:GetChildren()) do
									children[#children + 1] = child
								end
							end

							if
								not (n9 > #children or os.clock() - now >= n6)
							then
								continue
							end
							break
						end

						if n9 <= #children then
							RunService.Heartbeat:Wait()
						end
					end
				end)
			end

			local function fn41()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				if not plots then
					return
				end

				connection = runtime.Track(
					plots.DescendantAdded:Connect(
						runtime.Guard(function(descendant)
							if flag10 then
								fn39(descendant)
							end
						end)
					)
				)

				fn40()
			end

			local function fn42()
				flag10 = false
				n7 += 1

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				fn34()
			end

			local function fn43()
				fn42()
				flag10 = true
				plots = Workspace:FindFirstChild("Plots")
				if plots then
					fn41()
					return
				end

				connection2 = runtime.Track(
					Workspace.ChildAdded:Connect(runtime.Guard(function(child)
						if flag10 and child.Name == "Plots" then
							plots = child

							if connection2 then
								connection2:Disconnect()
								connection2 = nil
							end

							fn41()
						end
					end))
				)
			end

			local function fn44()
				local flag12 = tbl3.YourBaseClear == true

				if flag12 and not flag10 then
					fn43()
				elseif not flag12 and flag10 then
					fn42()
				end
			end

			fn10(function(arg)
				if arg == "YourBaseClear" then
					fn44()
				end
			end)

			fn44()
			runtime.Track(bindableEvent.Event:Connect(runtime.Cleanup(fn42)))
			runtime.Track(folder.Destroying:Connect(runtime.Guard(fn42)))
		end

		chilliBrainrotESPRuntime, v12 =
			fn5("__Nullx11BrainrotBrainrotESPRuntime")
		local font
		font = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.ExtraBold,
			Enum.FontStyle.Normal
		)
		local tbl12
		tbl12 = {}
		local tbl13
		tbl13 = { Limit = 1000000, Outline = Color3.fromRGB(255, 232, 152) }

		do
			local colorSequence = ColorSequence.new
			local tbl14 = {}
			local v19 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
			local v20 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
			tbl14[1] = v19
			tbl14[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 142, 12))
				)
				table.move(values, 1, values.n, 3, tbl14)
			end

			tbl13.Text = colorSequence(tbl14)
		end

		do
			local colorSequence = ColorSequence.new
			local tbl14 = {}
			local v19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
			local v20 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
			local new = ColorSequenceKeypoint.new
			local color2 = Color3.fromRGB
			tbl14[1] = v19
			tbl14[2] = v20

			do
				local values = table.pack(new(1, color2(20, 12, 0)))
				table.move(values, 1, values.n, 3, tbl14)
			end

			tbl13.Stroke = colorSequence(tbl14)
		end

		local tbl14
		tbl14 = { Limit = 10000000, Outline = Color3.fromRGB(255, 194, 112) }

		do
			local colorSequence = ColorSequence.new
			local tbl15 = {}
			local v19 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
			local v20 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
			tbl15[1] = v19
			tbl15[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 92, 0))
				)
				table.move(values, 1, values.n, 3, tbl15)
			end

			tbl14.Text = colorSequence(tbl15)
		end

		do
			local colorSequence = ColorSequence.new
			local tbl15 = {}
			local v19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
			local v20 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
			tbl15[1] = v19
			tbl15[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 0))
				)
				table.move(values, 1, values.n, 3, tbl15)
			end

			tbl14.Stroke = colorSequence(tbl15)
		end

		local tbl15
		tbl15 = { Limit = 100000000, Outline = Color3.fromRGB(255, 160, 132) }

		do
			local colorSequence = ColorSequence.new
			local tbl16 = {}
			local v19 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
			local v20 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
			tbl16[1] = v19
			tbl16[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 42, 0))
				)
				table.move(values, 1, values.n, 3, tbl16)
			end

			tbl15.Text = colorSequence(tbl16)
		end

		do
			local colorSequence = ColorSequence.new
			local tbl16 = {}
			local v19 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
			local v20 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
			tbl16[1] = v19
			tbl16[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 4, 0))
				)
				table.move(values, 1, values.n, 3, tbl16)
			end

			tbl15.Stroke = colorSequence(tbl16)
		end

		do
			local tbl16 =
				{ Limit = math.huge, Outline = Color3.fromRGB(255, 128, 138) }
			local colorSequence = ColorSequence.new
			local tbl17 = {}
			local v19 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
			local v20 =
				ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
			tbl17[1] = v19
			tbl17[2] = v20

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 0, 18))
				)
				table.move(values, 1, values.n, 3, tbl17)
			end

			tbl16.Text = colorSequence(tbl17)
			local colorSequence2 = ColorSequence.new
			local tbl18 = {}
			local v21 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
			local v22 =
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
			tbl18[1] = v21
			tbl18[2] = v22

			do
				local values = table.pack(
					ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 0, 3))
				)
				table.move(values, 1, values.n, 3, tbl18)
			end

			tbl16.Stroke = colorSequence2(tbl18)
			tbl12[1] = tbl13
			tbl12[2] = tbl14
			tbl12[3] = tbl15
			tbl12[4] = tbl16
		end

		do
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Datas.Animals)
			end)

			tbl4 = ok and type(result) == "table" and result or {}
		end

		local tbl16

		do
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Datas.Rarities)
			end)

			tbl16 = ok and type(result) == "table" and result or {}
		end

		local flag11, fn30

		do
			local ok, result = pcall(function()
				return require(ReplicatedStorage.Datas.Mutations)
			end)

			local tbl17 = ok and type(result) == "table" and result or {}

			local ok2, result2 = pcall(function()
				return require(ReplicatedStorage.Packages.Gradients)
			end)

			flag11 = ok2 and type(result2) == "table" and result2 or nil
			local tbl18 = {}

			local ok3, result3 = pcall(function()
				return require(ReplicatedStorage.Datas.Traits)
			end)

			local tbl19 = ok3 and type(result3) == "table" and result3 or {}

			for k, v19 in pairs(tbl19) do
				if type(v19) == "table" then
					v19.TraitKey = k

					if v19.Icon then
						local str = tostring(v19.Icon)
						tbl18[str] = v19
						local match = str:match("%d+")

						if match then
							tbl18[match] = v19
						end
					end
				end
			end

			flag2 = false
			tbl5 = {}
			tbl6 = {}
			n2 = 1
			flag3 = false
			flag4 = false
			n3 = 1000000
			tbl7 = {
				Name = true,
				Mutation = true,
				Value = true,
				Trails = true,
				Rarity = false,
			}

			tbl8 = {
				["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
				["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
				["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
			}

			fn30 = function(arg)
				for _, v19 in ipairs(tbl12) do
					if arg < v19.Limit then
						return v19
					end
				end

				return tbl12[#tbl12]
			end

			local function fn31(arg)
				local v19 = tbl4[arg]
				if type(v19) == "table" and v19.Rarity then
					return tostring(v19.Rarity)
				end
				return nil
			end

			local function fn32(arg)
				if arg >= 1e9 then
					return string.format("$%.2fB/s", arg / 1e9)
				end

				if arg >= 1000000 then
					return string.format("$%.2fM/s", arg / 1000000)
				end

				if arg >= 1000 then
					return string.format("$%.1fK/s", arg / 1000)
				end
				return string.format("$%d/s", math.floor(arg))
			end

			local function fn33(arg, arg2)
				local debris = Workspace:FindFirstChild("Debris")
				if not debris then
					return nil
				end
				local v19 = nil
				local v20 = nil

				for _, child in ipairs(debris:GetChildren()) do
					if
						child.Name == "FastOverheadTemplate"
						and child:IsA("BasePart")
					then
						local animalOverhead =
							child:FindFirstChild("AnimalOverhead")
						local displayName = animalOverhead
							and animalOverhead:FindFirstChild("DisplayName")

						if
							displayName
							and displayName:IsA("TextLabel")
							and displayName.Text == arg.Name
						then
							local magnitude = (child.Position - arg2.Position).Magnitude

							if not v19 or magnitude < v19 then
								v19 = magnitude
								v20 = animalOverhead
							end
						end
					end
				end

				if v20 and v19 and v19 <= 14 then
					return v20
				end
				return nil
			end

			local function fn34(arg)
				if arg.CachedOverhead and arg.CachedOverhead.Parent then
					return arg.CachedOverhead
				end
				local v19 = fn33(arg.Model, arg.Root)
				arg.CachedOverhead = v19
				return v19
			end

			local function fn35(arg, arg2, arg3)
				local mutation = arg3 or fn33(arg, arg2)
				mutation = mutation and mutation:FindFirstChild("Mutation")
				if
					not (
						mutation
						and mutation:IsA("TextLabel")
						and mutation.Visible
					)
				then
					return nil
				end
				local str = tostring(mutation.Text or "")
				if str == "" then
					return nil
				end

				local tbl20 = {
					Text = str,
					RichText = mutation.RichText == true,
					Color = mutation.TextColor3,
					Font = mutation.FontFace,
					StrokeColor = nil,
					Gradient = nil,
					SourceGrad = mutation:FindFirstChildOfClass("UIGradient"),
				}

				local uiStroke = mutation:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					tbl20.StrokeColor = uiStroke.Color
				end

				if tbl20.SourceGrad then
					tbl20.Gradient = {
						Color = tbl20.SourceGrad.Color,
						Rotation = tbl20.SourceGrad.Rotation,
						Offset = tbl20.SourceGrad.Offset,
					}
				end

				return tbl20
			end

			local function fn36(arg)
				if not arg or arg == "" then
					return nil
				end
				local match, v19 = arg:gsub("[%$,/s]", "")
					:gsub("%s+", "")
					:match("^([%d%.]+)([KkMmBbTt]?)$")

				if match then
					local n8 = tonumber(match) or 0
					local str = v19:upper()

					if str == "K" then
						n8 *= 1000
					elseif str == "M" then
						n8 *= 1000000
					elseif str == "B" then
						n8 *= 1e9
					elseif str == "T" then
						n8 *= 1e12
					end

					return n8
				end

				return nil
			end

			local function fn37(arg, arg2, arg3, arg4)
				local v19 = tbl4[arg]
				local n8 = type(v19) == "table" and tonumber(v19.Generation)
					or 0
				if n8 <= 0 then
					return fn36(arg4) or 0
				end
				local v20 = arg2 and tbl17 and tbl17[arg2]
				local n9 = 1

				if v20 then
					n9 = 1 + (tonumber(tbl17[arg2].Modifier) or 0)
				end

				local v21 = arg3 and tbl19
				local flag12 = false

				if v21 then
					for _, v22 in ipairs(arg3) do
						local v23 = tbl19[v22] or tbl19[v22:gsub("_", " ")]

						if v23 then
							if v22 == "Sleepy" or v23.Name == "Sleepy" then
								flag12 = true
							else
								n9 += tonumber(v23.MultiplierModifier) or 0
							end
						end
					end
				end

				local v22 = math.round(n8 * n9 * (flag12 and 0.5 or 1))
				local v23 = fn36(arg4)
				if v23 and v23 > v22 then
					return v23
				end
				return v22 > 0 and v22 or v23 or n8
			end

			local function fn38(arg, arg2, arg3)
				local tbl20 = {}
				local tbl21 = {}
				local tbl22 = {}
				local tbl23 = {}

				local function fn39(arg4, arg5)
					if arg4 and not tbl23[arg4] then
						tbl23[arg4] = true
						table.insert(tbl21, arg4)
					end

					if
						arg5
						and arg5 ~= ""
						and arg5 ~= "rbxassetid://110835412437000"
					then
						local match = tostring(arg5):match("%d+")
						local str = match or tostring(arg5)

						if not tbl22[str] then
							tbl22[str] = true
							local str2 = tostring(arg5)

							if not str2:find("://") and match then
								str2 = "rbxassetid://" .. match
							end

							table.insert(tbl20, str2)
						end
					end
				end

				local traits = arg3 or fn33(arg, arg2)
				traits = traits and traits:FindFirstChild("Traits")

				if traits and traits.Visible then
					for _, child in ipairs(traits:GetChildren()) do
						if
							child:IsA("ImageLabel")
							and child.Visible
							and child.Image
							and child.Image ~= ""
						then
							local str = tostring(child.Image)
							local match = str:match("%d+")
							local traitKey = tbl18[str]
								or match and tbl18[match]

							if traitKey then
								traitKey = traitKey.TraitKey
									or traitKey.Display
									or traitKey.Name
							end

							fn39(traitKey, child.Image)
						end
					end
				end

				for _, child in ipairs(arg:GetChildren()) do
					local match = child.Name:match("^_Trait%.(.+)$")

					if match then
						local v19 = tbl19[match] or tbl19[match:gsub("_", " ")]
						fn39(match, v19 and v19.Icon)
					end
				end

				local attribute = arg:GetAttribute("Trait")
					or arg:GetAttribute("Traits")

				if attribute then
					local str = tostring(attribute)
					local v19 = tbl19[str] or tbl19[str:gsub("_", " ")]
					fn39(str, v19 and v19.Icon)
				end

				return #tbl20 > 0 and tbl20 or nil, #tbl21 > 0 and tbl21 or nil
			end

			fn16 = function(arg)
				return arg:FindFirstChild("RootPart")
					or arg.PrimaryPart
					or arg:FindFirstChildWhichIsA("BasePart")
			end

			local function fn39(parent, layoutOrder, arg)
				local frame = Instance.new("Frame")
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = layoutOrder
				frame.Size = UDim2.new(1, 0, 0, arg)
				frame.Parent = parent
				local textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.FontFace = font
				textLabel.Position = UDim2.fromOffset(1, 1)
				textLabel.Size = UDim2.fromScale(1, 1)
				textLabel.Text = ""
				textLabel.TextColor3 = Color3.fromRGB(12, 0, 2)
				textLabel.TextScaled = true
				textLabel.TextStrokeTransparency = 1
				textLabel.TextTransparency = 0.1
				textLabel.ZIndex = 2
				textLabel.Parent = frame
				local textLabel2 = Instance.new("TextLabel")
				textLabel2.BackgroundTransparency = 1
				textLabel2.FontFace = font
				textLabel2.Size = UDim2.fromScale(1, 1)
				textLabel2.Text = ""
				textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel2.TextScaled = true
				textLabel2.TextStrokeTransparency = 1
				textLabel2.ZIndex = 3
				textLabel2.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				uiStroke.Color = Color3.fromRGB(0, 0, 0)
				uiStroke.LineJoinMode = Enum.LineJoinMode.Round

				uiStroke.Thickness = pcall(function()
					uiStroke.BorderOffset = UDim.new(0, 0)
					uiStroke.BorderStrokePosition =
						Enum.BorderStrokePosition.Outer
					uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
				end) and 0.05 or 1.6

				uiStroke.Transparency = 0.05
				uiStroke.Parent = textLabel2
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Rotation = 90
				uiGradient.Enabled = false
				uiGradient.Parent = uiStroke
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Rotation = 90
				uiGradient2.Enabled = false
				uiGradient2.Parent = textLabel2
				return {
					Holder = frame,
					Label = textLabel2,
					Shadow = textLabel,
					Stroke = uiStroke,
					StrokeGradient = uiGradient,
					TextGradient = uiGradient2,
				}
			end

			local function fn40(parent, layoutOrder, arg)
				local frame = Instance.new("Frame")
				frame.Name = "TraitRow"
				frame.BackgroundTransparency = 1
				frame.LayoutOrder = layoutOrder
				frame.Size = UDim2.new(1, 0, 0, arg)
				frame.Parent = parent
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Horizontal
				uiListLayout.HorizontalAlignment =
					Enum.HorizontalAlignment.Center
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.Padding = UDim.new(0, 3)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.Parent = frame
				return {
					Holder = frame,
					Layout = uiListLayout,
					Icons = {},
					CurrentKey = "",
				}
			end

			fn17 = function(adornee, adornee2)
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "BrainrotTag"
				billboardGui.Adornee = adornee2
				billboardGui.AlwaysOnTop = true
				billboardGui.ClipsDescendants = false
				billboardGui.LightInfluence = 0
				billboardGui.MaxDistance = math.huge
				billboardGui.Size = UDim2.fromOffset(220, 95)
				billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.4, 0)
				billboardGui.Parent = adornee2
				local frame = Instance.new("Frame")
				frame.BackgroundTransparency = 1
				frame.Size = UDim2.fromScale(1, 1)
				frame.Parent = billboardGui
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Vertical
				uiListLayout.HorizontalAlignment =
					Enum.HorizontalAlignment.Center
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				uiListLayout.Parent = frame
				local v19 = fn33(adornee, adornee2)
				local text = v19
					and v19:FindFirstChild("Generation")
					and v19.Generation.Text
				local text2 = v19
					and v19:FindFirstChild("Mutation")
					and v19.Mutation.Visible
					and v19.Mutation.Text

				if not text2 then
					local attribute = adornee:GetAttribute("Mutation")
						or adornee:GetAttribute("__mutation")

					if attribute and tostring(attribute) ~= "" then
						text2 = tostring(attribute)
					end
				end

				local v20, v21 = fn38(adornee, adornee2)
				local v22 = fn37(adornee.Name, text2, v21, text)

				local tbl20 = {
					Model = adornee,
					Root = adornee2,
					Billboard = billboardGui,
					Column = frame,
					RarityRow = fn39(frame, 0, 16),
					TraitRow = fn40(frame, 1, 18),
					MutationRow = fn39(frame, 2, 15),
					NameRow = fn39(frame, 3, 19),
					ValueRow = fn39(frame, 4, 16),
					Name = adornee.Name,
					Generation = v22,
				}

				tbl20.RarityRow.Label.RichText = true
				tbl20.MutationRow.Label.RichText = true
				tbl20.RarityRow.Holder.Visible = false
				tbl20.TraitRow.Holder.Visible = false
				local v23 = fn30(tbl20.Generation)
				tbl20.NameRow.TextGradient.Color = v23.Text
				tbl20.NameRow.TextGradient.Enabled = true
				tbl20.NameRow.StrokeGradient.Color = v23.Stroke
				tbl20.NameRow.StrokeGradient.Enabled = true
				tbl20.ValueRow.TextGradient.Enabled = false
				tbl20.ValueRow.StrokeGradient.Enabled = false
				tbl20.ValueRow.Label.TextColor3 = Color3.fromRGB(115, 255, 0)
				tbl20.ValueRow.Shadow.TextColor3 = Color3.fromRGB(18, 48, 0)
				tbl20.ValueRow.Stroke.Transparency = 0.3
				tbl20.NameRow.Label.Text = tbl20.Name
				tbl20.NameRow.Shadow.Text = tbl20.Name
				local v24 = fn32(tbl20.Generation)
				tbl20.ValueRow.Label.Text = v24
				tbl20.ValueRow.Shadow.Text = v24
				local highlight2 = Instance.new("Highlight")
				highlight2.Name = "BrainrotHighlight"
				highlight2.Adornee = adornee
				highlight2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight2.FillColor = v23.Outline
				highlight2.FillTransparency = 0.86
				highlight2.OutlineColor = v23.Outline
				highlight2.OutlineTransparency = 0.3
				highlight2.Enabled = false
				highlight2.Parent = adornee
				tbl20.Highlight = highlight2
				tbl20.BeamTint = v23.Outline
				return tbl20
			end

			fn18 = function(arg)
				local floor = math.floor
				local n8 = 95 * n2
				arg.Billboard.Size =
					UDim2.fromOffset(math.floor(220 * n2), floor(n8))
				arg.RarityRow.Holder.Size =
					UDim2.new(1, 0, 0, math.floor(16 * n2))
				local n9 = math.floor(18 * n2)
				arg.TraitRow.Holder.Size = UDim2.new(1, 0, 0, n9)

				for _, icon in ipairs(arg.TraitRow.Icons) do
					icon.Size = UDim2.fromOffset(n9, n9)
				end

				arg.MutationRow.Holder.Size =
					UDim2.new(1, 0, 0, math.floor(15 * n2))
				arg.NameRow.Holder.Size =
					UDim2.new(1, 0, 0, math.floor(19 * n2))
				arg.ValueRow.Holder.Size =
					UDim2.new(1, 0, 0, math.floor(16 * n2))
			end

			local function fn41(arg)
				if arg.RarityGradientCleanup then
					pcall(arg.RarityGradientCleanup)
					arg.RarityGradientCleanup = nil
				end

				arg.ActiveRarityEffect = nil
				arg.SourceRarityGrad = nil
				arg.SourceMutationGrad = nil
			end

			fn19 = function(arg, arg2)
				pcall(function()
					if not tbl7.Mutation then
						arg.MutationShown = false
						arg.MutationRow.Holder.Visible = false
						return
					end

					if arg2 < (arg.MutationCheckedAt or 0) then
						arg.MutationRow.Holder.Visible = arg.MutationShown
							== true
						return
					end
					arg.MutationCheckedAt = arg2 + 0.4
					local v19 = fn35(arg.Model, arg.Root, fn34(arg))

					if not v19 then
						arg.MutationShown = false
						arg.MutationRow.Holder.Visible = false
						arg.SourceMutationGrad = nil
						return
					end

					arg.MutationShown = true
					local mutationRow = arg.MutationRow
					mutationRow.Holder.Visible = true
					mutationRow.Label.RichText = v19.RichText
					mutationRow.Label.Text = v19.Text

					if v19.Color then
						mutationRow.Label.TextColor3 = v19.Color
					end

					if v19.Font then
						pcall(function()
							mutationRow.Label.FontFace = v19.Font
							mutationRow.Shadow.FontFace = v19.Font
						end)
					end

					if v19.StrokeColor then
						mutationRow.Stroke.Color = v19.StrokeColor
					end

					if v19.Gradient then
						pcall(function()
							mutationRow.TextGradient.Color = v19.Gradient.Color
							mutationRow.TextGradient.Rotation =
								v19.Gradient.Rotation
							mutationRow.TextGradient.Offset =
								v19.Gradient.Offset
							mutationRow.TextGradient.Enabled = true
						end)

						arg.SourceMutationGrad = v19.SourceGrad
					else
						mutationRow.TextGradient.Enabled = false
						arg.SourceMutationGrad = nil
					end

					mutationRow.Shadow.RichText = false
					mutationRow.Shadow.Text = v19.Text:gsub("<[^<>]->", "")
				end)
			end

			fn20 = function(arg, arg2)
				if not tbl7.Rarity then
					arg.RarityShown = false
					arg.RarityRow.Holder.Visible = false
					fn41(arg)
					return
				end

				if arg2 < (arg.RarityCheckedAt or 0) then
					arg.RarityRow.Holder.Visible = arg.RarityShown == true
					return
				end
				arg.RarityCheckedAt = arg2 + 0.5
				local text = fn31(arg.Model.Name)
				local v19 = fn34(arg)
				local rarity = v19 and v19:FindFirstChild("Rarity")

				if
					rarity
					and rarity:IsA("TextLabel")
					and rarity.Visible
					and rarity.Text ~= ""
				then
					text = rarity.Text
				end

				if not text or text == "" then
					arg.RarityShown = false
					arg.RarityRow.Holder.Visible = false
					fn41(arg)
					return
				end

				arg.RarityShown = true
				local rarityRow = arg.RarityRow
				rarityRow.Holder.Visible = true
				rarityRow.Label.Text = text
				rarityRow.Shadow.Text = text:gsub("<[^<>]->", "")
				local gradientPreset = tbl16[text]
				gradientPreset = gradientPreset
					and gradientPreset.GradientPreset
				local flag12 = false

				pcall(function()
					if gradientPreset and flag11 and flag11.apply then
						if arg.ActiveRarityEffect ~= gradientPreset then
							if arg.RarityGradientCleanup then
								pcall(arg.RarityGradientCleanup)
								arg.RarityGradientCleanup = nil
							end

							arg.ActiveRarityEffect = gradientPreset

							local ok4, rarityGradientCleanup = pcall(function()
								return flag11.apply(
									rarityRow.Label,
									gradientPreset
								)
							end)

							if
								ok4
								and typeof(rarityGradientCleanup)
									== "function"
							then
								arg.RarityGradientCleanup =
									rarityGradientCleanup
							end
						end

						pcall(function()
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(255, 255, 255)
						end)

						arg.SourceRarityGrad = nil
						flag12 = true
					end
				end)

				if not flag12 then
					pcall(function()
						if arg.RarityGradientCleanup then
							pcall(arg.RarityGradientCleanup)
							arg.RarityGradientCleanup = nil
						end

						arg.ActiveRarityEffect = nil
						local uiGradient = rarity
							and rarity:FindFirstChildOfClass("UIGradient")
						local uiStroke = rarity
							and rarity:FindFirstChildOfClass("UIStroke")

						if uiGradient then
							rarityRow.TextGradient.Color = uiGradient.Color
							rarityRow.TextGradient.Rotation =
								uiGradient.Rotation
							rarityRow.TextGradient.Offset = uiGradient.Offset
							rarityRow.TextGradient.Enabled = true
							arg.SourceRarityGrad = uiGradient
						else
							rarityRow.TextGradient.Enabled = false
							arg.SourceRarityGrad = nil
						end

						if uiStroke then
							rarityRow.Stroke.Color = uiStroke.Color
						else
							rarityRow.Stroke.Color = Color3.fromRGB(0, 0, 0)
						end

						if rarity and rarity.TextColor3 then
							rarityRow.Label.TextColor3 = rarity.TextColor3
						elseif text == "Mythic" then
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(255, 0, 0)
						elseif text == "Legendary" or text == "Legend" then
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(255, 175, 0)
						elseif text == "Epic" then
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(134, 0, 171)
						elseif text == "Rare" then
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(0, 131, 171)
						elseif text == "Common" then
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(0, 171, 40)
						else
							rarityRow.Label.TextColor3 =
								Color3.fromRGB(130, 210, 255)
						end
					end)
				end
			end

			fn21 = function(arg, arg2)
				if not tbl7.Trails then
					arg.TraitRow.Holder.Visible = false
					return
				end

				if arg2 < (arg.TraitCheckedAt or 0) then
					arg.TraitRow.Holder.Visible = arg.TraitIcons ~= nil
					return
				end
				arg.TraitCheckedAt = arg2 + 0.5
				local v19, v20 = fn38(arg.Model, arg.Root, fn34(arg))
				arg.ActiveTraitNames = v20

				if not v19 then
					arg.TraitIcons = nil
					arg.TraitRow.Holder.Visible = false
					arg.TraitRow.CurrentKey = ""

					for _, icon in ipairs(arg.TraitRow.Icons) do
						icon.Visible = false
					end

					return
				end

				arg.TraitIcons = v19
				arg.TraitRow.Holder.Visible = true
				local currentKey = table.concat(v19, "|")

				if arg.TraitRow.CurrentKey ~= currentKey then
					arg.TraitRow.CurrentKey = currentKey
					local n8 = math.floor(18 * n2)

					for i_ = 1, #v19 do
						local imageLabel = arg.TraitRow.Icons[i_]

						if not imageLabel then
							imageLabel = Instance.new("ImageLabel")
							imageLabel.BackgroundTransparency = 1
							imageLabel.ScaleType = Enum.ScaleType.Fit
							imageLabel.ImageColor3 =
								Color3.fromRGB(255, 255, 255)
							imageLabel.ZIndex = 3
							imageLabel.Parent = arg.TraitRow.Holder
							arg.TraitRow.Icons[i_] = imageLabel
						end

						imageLabel.Image = v19[i_]
						imageLabel.Size = UDim2.fromOffset(n8, n8)
						imageLabel.LayoutOrder = i_
						imageLabel.Visible = true
					end

					for i_ = #v19 + 1, #arg.TraitRow.Icons do
						arg.TraitRow.Icons[i_].Visible = false
					end
				end
			end

			fn22 = function(arg, arg2)
				if arg2 < (arg.GenerationCheckedAt or 0) then
					return
				end
				arg.GenerationCheckedAt = arg2 + 0.4
				local mutation = fn34(arg)
				local text = mutation
					and mutation:FindFirstChild("Generation")
					and mutation.Generation.Text
				mutation = mutation and mutation:FindFirstChild("Mutation")
				local text2

				if mutation and mutation.Visible and mutation.Text ~= "" then
					text2 = mutation.Text
				else
					local attribute = arg.Model:GetAttribute("Mutation")
						or arg.Model:GetAttribute("__mutation")
					local flag12 = attribute and tostring(attribute) ~= ""
					text2 = nil

					if flag12 then
						text2 = tostring(attribute)
					end
				end

				local activeTraitNames = arg.ActiveTraitNames

				if not activeTraitNames then
					local v19
					v19, activeTraitNames = fn38(arg.Model, arg.Root)
					arg.ActiveTraitNames = activeTraitNames
				end

				local v19 = fn37(arg.Name, text2, activeTraitNames, text)

				if v19 ~= arg.Generation and v19 > 0 then
					arg.Generation = v19
					local v20 = fn32(v19)
					arg.ValueRow.Label.Text = v20
					arg.ValueRow.Shadow.Text = v20
					local v21 = fn30(v19)
					arg.NameRow.TextGradient.Color = v21.Text
					arg.NameRow.StrokeGradient.Color = v21.Stroke
					arg.Highlight.FillColor = v21.Outline
					arg.Highlight.OutlineColor = v21.Outline
					arg.BeamTint = v21.Outline
				end
			end

			fn23 = function(arg, arg2)
				if flag4 then
					return arg2
				end
				return (arg.Generation or 0) >= n3
			end

			attachment = nil
			local attachment4 = nil
			local beam3 = nil
			local beam4 = nil
			v13 = nil
			v14 = nil

			fn24 = function()
				pcall(function()
					if beam3 then
						beam3:Destroy()
					end
				end)

				pcall(function()
					if beam4 then
						beam4:Destroy()
					end
				end)

				pcall(function()
					if attachment then
						attachment:Destroy()
					end
				end)

				pcall(function()
					if attachment4 then
						attachment4:Destroy()
					end
				end)

				beam3 = nil
				beam4 = nil
				attachment = nil
				attachment4 = nil
				v13 = nil
				v14 = nil
			end

			fn25 = function(parent, parent2)
				fn24()
				if not (parent and parent2) then
					return
				end
				attachment = Instance.new("Attachment")
				attachment.Name = "BrainrotBeamStart"
				attachment.Position = Vector3.new(0, 1, 0)
				attachment.Parent = parent
				attachment4 = Instance.new("Attachment")
				attachment4.Name = "BrainrotBeamTarget"
				attachment4.Position = Vector3.new(0, 2.5, 0)
				attachment4.Parent = parent2
				local color2 = Color3.fromRGB(255, 25, 140)
				local color3 = Color3.fromRGB(255, 120, 220)
				local color4 = Color3.fromRGB(180, 35, 255)
				beam3 = Instance.new("Beam")
				beam3.Name = "BrainrotBeamGlow"
				beam3.Attachment0 = attachment
				beam3.Attachment1 = attachment4
				beam3.Color = ColorSequence.new(color2, color4)
				beam3.CurveSize0 = 1.8
				beam3.CurveSize1 = -1.8
				beam3.FaceCamera = true
				beam3.LightEmission = 0.55
				beam3.Segments = 20
				beam3.Transparency = NumberSequence.new(0.65)
				beam3.Width0 = 0.42
				beam3.Width1 = 0.6
				obj[beam3] = true
				beam3.Parent = attachment
				beam4 = Instance.new("Beam")
				beam4.Name = "BrainrotBeamCore"
				beam4.Attachment0 = attachment
				beam4.Attachment1 = attachment4
				local v19 = beam4
				local colorSequence = ColorSequence.new
				local tbl20 = {}
				local v20 = ColorSequenceKeypoint.new(0, color2)
				local v21 = ColorSequenceKeypoint.new(0.5, color3)
				local new = ColorSequenceKeypoint.new
				tbl20[1] = v20
				tbl20[2] = v21

				do
					local values = table.pack(new(1, color4))
					table.move(values, 1, values.n, 3, tbl20)
				end

				v19.Color = colorSequence(tbl20)
				beam4.CurveSize0 = 1.8
				beam4.CurveSize1 = -1.8
				beam4.FaceCamera = true
				beam4.LightEmission = 0.6
				beam4.Segments = 20
				beam4.Transparency = NumberSequence.new(0.04)
				beam4.Width0 = 0.12
				beam4.Width1 = 0.22
				obj[beam4] = true
				beam4.Parent = attachment4
				v13 = parent
				v14 = parent2
			end

			fn26 = function(arg)
				fn41(arg)

				pcall(function()
					arg.Billboard:Destroy()
				end)

				pcall(function()
					arg.Highlight:Destroy()
				end)

				if v14 == arg.Root then
					fn24()
				end
			end
		end

		fn27 = function()
			for k, v19 in pairs(tbl6) do
				fn26(v19)
				tbl6[k] = nil
			end
		end

		n4 = 14

		do
			local v19 = nil
			local obj2 = setmetatable({}, { __mode = "k" })

			fn28 = function(arg)
				if v19 and v19.Parent then
					return arg == v19
				end
				local plotSign = arg and arg:FindFirstChild("PlotSign")
				if not plotSign then
					return false
				end
				local v20 = string.lower(localPlayer.Name)
				local v21 = string.lower(localPlayer.DisplayName)

				for _, descendant in ipairs(plotSign:GetDescendants()) do
					if descendant:IsA("TextLabel") then
						local v22 =
							string.lower(tostring(descendant.Text or ""))
						if
							v22 == "your base"
							or string.find(v22, v20, 1, true)
							or string.find(v22, v21, 1, true)
						then
							v19 = arg
							return true
						end
					end
				end

				return false
			end

			local function fn31(arg, arg2)
				local v20 = obj2[arg]
				if
					v20
					and v20.Parent
					and tostring(v20.ActionText) == "Steal"
				then
					return v20
				end
				obj2[arg] = nil

				for _, descendant in ipairs(arg2:GetDescendants()) do
					if
						descendant:IsA("ProximityPrompt")
						and tostring(descendant.ActionText) == "Steal"
					then
						obj2[arg] = descendant
						return descendant
					end
				end

				return nil
			end

			fn29 = function(arg)
				local tbl17 = {}
				local animalPodiums = arg
					and arg:FindFirstChild("AnimalPodiums")
				if not animalPodiums then
					return tbl17
				end

				for _, child in ipairs(animalPodiums:GetChildren()) do
					local base = child:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")

					if base and base:IsA("BasePart") then
						local v20 = fn31(
							child,
							base:FindFirstChild("PromptAttachment") or base
						)

						if v20 then
							local str = tostring(v20.ObjectText or "")

							if str ~= "" then
								local tbl18 = tbl17[str]

								if not tbl18 then
									tbl18 = {}
									tbl17[str] = tbl18
								end

								tbl18[#tbl18 + 1] = base.Position
							end
						end
					end
				end

				return tbl17
			end
		end
	end

	do
		local function fn30(arg, arg2)
			if not (arg and arg2) then
				return false
			end

			for _, v15 in ipairs(arg2) do
				if (arg.Position - v15).Magnitude <= n4 then
					return true
				end
			end

			return false
		end

		local function fn31()
			local plots = Workspace:FindFirstChild("Plots")
			if not plots then
				fn27()
				return
			end
			local tbl9 = {}

			for _, child in ipairs(plots:GetChildren()) do
				if not fn28(child) then
					local v15 = fn29(child)

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("Model") and tbl4[child2.Name] then
							local v16 = fn16(child2)

							if fn30(v16, v15[child2.Name]) then
								tbl9[child2] = true
								local v17 = tbl6[child2]

								if v17 and v17.Root ~= v16 then
									fn26(v17)
									v17 = nil
								end

								if not v17 then
									local v18 = fn17(child2, v16)
									tbl6[child2] = v18
									fn18(v18)
								end
							end
						end
					end
				end
			end

			for k, v15 in pairs(tbl6) do
				if not tbl9[k] or not k.Parent then
					fn26(v15)
					tbl6[k] = nil
				end
			end
		end

		local function fn32()
			if not flag2 then
				return
			end
			flag2 = false
			fn6(tbl5)
			fn24()
			fn27()
		end

		local function fn33()
			if flag2 then
				return
			end
			flag2 = true
			fn31()
			local n5 = 0

			tbl5[#tbl5 + 1] = runtime.Track(
				RunService.RenderStepped:Connect(runtime.Guard(function()
					if not flag2 then
						return
					end
					local now = os.clock()

					if n5 <= now then
						n5 = now + 1
						fn31()
					end

					local generation = nil
					local v15 = nil

					for _, v16 in pairs(tbl6) do
						if v16.Root.Parent then
							local flag5 = flag4

							if not flag4 then
								flag5 = (v16.Generation or 0) >= n3
							end

							if
								flag5
								and (
									not generation
									or v16.Generation > generation
								)
							then
								generation = v16.Generation
								v15 = v16
							end
						end
					end

					for _, v16 in pairs(tbl6) do
						local v17 = fn23(v16, v16 == v15)
						v16.Billboard.Enabled = v17
						v16.Highlight.Enabled = v17

						if v17 then
							v16.NameRow.Holder.Visible = tbl7.Name
							v16.ValueRow.Holder.Visible = tbl7.Value
							pcall(fn20, v16, now)
							pcall(fn19, v16, now)
							pcall(fn21, v16, now)
							pcall(fn22, v16, now)

							if
								tbl7.Rarity
								and v16.SourceRarityGrad
								and v16.SourceRarityGrad.Parent
							then
								pcall(function()
									v16.RarityRow.TextGradient.Offset =
										v16.SourceRarityGrad.Offset
									v16.RarityRow.TextGradient.Rotation =
										v16.SourceRarityGrad.Rotation
									v16.RarityRow.TextGradient.Color =
										v16.SourceRarityGrad.Color
								end)
							end

							if
								tbl7.Mutation
								and v16.SourceMutationGrad
								and v16.SourceMutationGrad.Parent
							then
								pcall(function()
									v16.MutationRow.TextGradient.Offset =
										v16.SourceMutationGrad.Offset
									v16.MutationRow.TextGradient.Rotation =
										v16.SourceMutationGrad.Rotation
									v16.MutationRow.TextGradient.Color =
										v16.SourceMutationGrad.Color
								end)
							end
						end
					end

					local v16 = fn7()
					local v17 = flag3
					local v18

					if flag3 then
						v18 = v15
					else
						v18 = v17
					end

					if not (v18 and v16) then
						if attachment then
							fn24()
						end
					else
						local flag5 = v13 ~= v16 or v14 ~= v15.Root

						if not flag5 then
							flag5 = not (attachment and attachment.Parent)
						end

						if flag5 then
							fn25(v16, v15.Root, v15.BeamTint)
						end
					end
				end))
			)
		end

		runtime.Track(v12.Event:Connect(runtime.Guard(fn32)))
		runtime.Track(
			chilliBrainrotESPRuntime.Destroying:Connect(runtime.Guard(fn32))
		)

		local v15 = v9:CreateToggle({
			Name = "Brainrot ESP",
			Default = false,
			Callback = function(arg)
				if arg then
					fn33()
				else
					fn32()
				end
			end,
		})

		v9:CreateSlider({
			Name = "Brainrot ESP Size",
			Min = 50,
			Max = 200,
			Default = 100,
			AllowDecimals = false,
			Increment = 1,
			Unit = "%",
			Quick = false,
			SubOf = v15,
			Callback = function(arg)
				n2 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)

				for _, v16 in pairs(tbl6) do
					fn18(v16)
				end
			end,
		})

		v9:CreateMultiDropdown({
			Name = "Show Information",
			Note = "Choose what each Brainrot tag shows.",
			Options = { "Name", "Mutation", "Value", "Trails", "Rarity" },
			Default = { "Name", "Value", "Trails" },
			Quick = false,
			SubOf = v15,
			Callback = function(arg)
				local tbl9 = {
					Name = false,
					Mutation = false,
					Value = false,
					Trails = false,
					Rarity = false,
				}

				if type(arg) == "table" then
					for k, v16 in pairs(arg) do
						if type(v16) == "string" then
							if tbl9[v16] ~= nil then
								tbl9[v16] = true
							elseif v16 == "Type" then
								tbl9.Rarity = true
							end
						elseif type(k) == "string" and v16 == true then
							if tbl9[k] ~= nil then
								tbl9[k] = true
							elseif k == "Type" then
								tbl9.Rarity = true
							end
						end
					end
				end

				tbl7 = tbl9
			end,
		})

		local v16 = nil
		local n5 = 1
		local str = "M/s"

		local function fn34(arg, arg2)
			if arg ~= nil then
				n5 = math.floor(tonumber(arg) or n5)
			end

			if arg2 ~= nil then
				str = tostring(arg2)
			elseif v16 and v16.GetUnit then
				local unit = v16:GetUnit()

				if unit and unit ~= "" then
					str = tostring(unit)
				end
			end

			n3 = n5 * (tbl8[str] or tbl8["M/s"]).Mult
		end

		local function fn35(arg)
			str = arg
			local ms = tbl8[arg] or tbl8["M/s"]

			if v16 and v16.SetRange then
				v16:SetRange(ms.Min, ms.Max)
				local min = v16:Get() or ms.Min
				local min2 = ms.Min
				local max = ms.Max
				local n6 = math.clamp(math.floor(min + 0.5), min2, max)

				if n6 ~= min then
					v16:Set(n6)
				else
					fn34(n6, arg)
				end
			else
				fn34(nil, arg)
			end
		end

		v16 = v9:CreateSlider({
			Name = "Brainrot ESP Min Value",
			Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
			Min = 0,
			Max = 1000,
			Default = 1,
			AllowDecimals = false,
			Increment = 1,
			Unit = {
				Default = "M/s",
				Selector = true,
				Options = { "K/s", "M/s", "B/s" },
				ColorEnabled = true,
				Colors = {
					Number = Color3.fromRGB(255, 255, 255),
					Suffix = Color3.fromRGB(58, 255, 55),
				},
				Callback = function(arg)
					fn35(arg)
				end,
			},
			Quick = false,
			SubOf = v15,
			Callback = function(arg)
				fn34(arg, nil)
			end,
		})

		v9:CreateToggle({
			Name = "Best Brainrot Only",
			Default = false,
			Quick = false,
			SubOf = v15,
			Callback = function(arg)
				flag4 = arg == true
			end,
		})

		v9:CreateToggle({
			Name = "Beam To Best",
			Note = "Draws one beam from you to the highest generation Brainrot.",
			Default = false,
			Quick = false,
			SubOf = v15,
			Callback = function(arg)
				flag3 = arg == true
			end,
		})
	end

	local str
	str = "__Nullx11BrainrotBrainrotNotificationRuntime"
	local n5
	n5 = 0.75
	local n6
	n6 = 3
	local chilliBrainrotNotificationRuntim, v15
	chilliBrainrotNotificationRuntim, v15 =
		fn5("__Nullx11BrainrotBrainrotNotificationRuntime")
	local flag5
	flag5 = false
	local str2
	str2 = ""
	local soundId
	soundId = ""
	local str3
	str3 = ""
	local n7
	n7 = 1000000
	local flag6
	flag6 = true
	local n8
	n8 = 0
	local n9
	n9 = 0
	local connection
	connection = nil
	local obj2
	obj2 = setmetatable({}, { __mode = "k" })
	local v16
	v16 = nil
	local tbl9, v17, v18, TweenService, font, tbl10, tbl11, tbl12
	local v19 = nil
	tbl9 = {}
	v17 = nil
	v18 = nil
	TweenService = game:GetService("TweenService")
	font = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.ExtraBold,
		Enum.FontStyle.Normal
	)
	tbl10 = {}
	tbl11 = {}
	tbl12 = {}

	pcall(function()
		local Animals = require(ReplicatedStorage.Datas.Animals)

		if type(Animals) == "table" then
			tbl10 = Animals
		end
	end)

	pcall(function()
		local Mutations = require(ReplicatedStorage.Datas.Mutations)

		if type(Mutations) == "table" then
			tbl11 = Mutations
		end
	end)

	pcall(function()
		local Traits = require(ReplicatedStorage.Datas.Traits)

		if type(Traits) == "table" then
			tbl12 = Traits
		end
	end)

	pcall(function()
		local Gradients = require(ReplicatedStorage.Packages.Gradients)

		if type(Gradients) == "table" then
			v19 = Gradients
		end
	end)

	local tbl13
	tbl13 = {}

	do
		local tbl14 =
			{ Preset = "Zebra", Background = Color3.fromRGB(16, 16, 20) }
		local colorSequence = ColorSequence.new
		local tbl15 = {}
		local v20 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
		local v21 = ColorSequenceKeypoint.new(0.24, Color3.fromRGB(45, 45, 55))
		local v22 =
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
		local v23 = ColorSequenceKeypoint.new(0.76, Color3.fromRGB(45, 45, 55))
		tbl15[1] = v20
		tbl15[2] = v21
		tbl15[3] = v22
		tbl15[4] = v23

		do
			local values = table.pack(
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			)
			table.move(values, 1, values.n, 5, tbl15)
		end

		tbl14.Colors = colorSequence(tbl15)
		tbl13["Secret Zebra"] = tbl14
	end

	local fn30, fn31

	do
		local function fn32()
			if v16 then
				return v16
			end
			local controllers = ReplicatedStorage:FindFirstChild("Controllers")
			controllers = controllers
				and controllers:FindFirstChild("NotificationController")
			if not (controllers and controllers:IsA("ModuleScript")) then
				return nil
			end
			local ok, result = pcall(require, controllers)

			if ok and type(result) == "table" then
				v16 = result
			end

			return v16
		end

		local function fn33(arg)
			local match = tostring(arg or ""):match("(%d+)")
			if match and tonumber(match) and tonumber(match) > 0 then
				return "rbxassetid://" .. match
			end
			return nil
		end

		local function fn34(arg)
			if not arg then
				return nil
			end

			if arg:IsA("Sound") then
				return fn33(arg.SoundId)
			end

			if arg:IsA("StringValue") then
				local v20 = fn33(arg.Value)
				if v20 then
					return v20
				end
			end

			local v20 = fn33(arg:GetAttribute("SoundId"))
			if v20 then
				return v20
			end
			local sound = arg:FindFirstChildWhichIsA("Sound", true)
			return sound and fn33(sound.SoundId) or nil
		end

		local function fn35()
			local v20 = ipairs
			local tbl14 = {}
			local v21 = table.pack(game:GetService("SoundService"))
			tbl14[1] = ReplicatedStorage

			do
				local values = table.pack(table.unpack(v21, 1, v21.n))
				table.move(values, 1, values.n, 2, tbl14)
			end

			for _, v22 in v20(tbl14) do
				local crystalSpawn = v22:FindFirstChild("CrystalSpawn", true)
				local v23 = fn34(crystalSpawn)
				if v23 then
					return v23
				end
			end

			return ""
		end

		fn30 = function(arg)
			str2 = tostring(arg or "")
		end

		fn31 = function()
			local v20 = fn33(str2)

			if not v20 then
				soundId = str3
				v.Notify(
					"Sound ID Failed",
					"Invalid asset ID. Restored the default Crystal sound.",
					5
				)
				return false
			end

			local sound = Instance.new("Sound")
			sound.Name = "ChilliSoundIdValidation"
			sound.SoundId = v20
			sound.Volume = 0
			sound.Parent = game:GetService("SoundService")
			local flag7 = false

			local isLoaded = pcall(function()
				game:GetService("ContentProvider")
					:PreloadAsync({ sound }, function(arg, arg2)
						if arg2 == Enum.AssetFetchStatus.Success then
							flag7 = true
						end
					end)
			end) and (flag7 or sound.IsLoaded or sound.TimeLength > 0)

			sound:Destroy()

			if not isLoaded then
				soundId = str3
				v.Notify(
					"Sound ID Failed",
					"Audio unavailable. Restored the default Crystal sound.",
					5
				)
				return false
			end

			soundId = v20
			str2 = v20
			v.Notify(
				"Sound ID Applied",
				v20 .. " is now used for Brainrot notifications.",
				5
			)
			return true
		end

		local function fn36()
			if soundId == "" then
				return
			end
			local sound = Instance.new("Sound")
			sound.Name = "ChilliBrainrotNotificationSound"
			sound.SoundId = soundId
			sound.Volume = 1
			sound.Parent = game:GetService("SoundService")

			if not pcall(function()
				sound:Play()
			end) then
				sound:Destroy()
				return
			end

			game:GetService("Debris"):AddItem(sound, 15)
		end

		str3 = fn35()
		soundId = str3
		str2 = soundId

		local function fn37(parent, arg)
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Color = arg.Colors
			uiGradient.Rotation = 8
			uiGradient.Parent = parent
			local tween = TweenService:Create(
				uiGradient,
				TweenInfo.new(
					1.8,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.InOut,
					-1
				),
				{ Rotation = 368 }
			)
			tween:Play()

			return function()
				tween:Cancel()
			end
		end

		local function fn38(arg, parent, name, text, position, size, textSize)
			local clone = arg:Clone()
			clone.Name = name
			clone.Visible = true
			clone.RichText = true
			clone.BackgroundTransparency = 1
			clone.AutomaticSize = Enum.AutomaticSize.None
			clone.AnchorPoint = Vector2.zero
			clone.Position = position
			clone.Size = size
			clone.Text = text
			clone.TextScaled = false
			clone.TextSize = textSize
			clone.TextXAlignment = Enum.TextXAlignment.Left
			clone.TextYAlignment = Enum.TextYAlignment.Center
			clone.FontFace = font
			clone.Parent = parent
			return clone
		end

		local function fn39(parent, arg, arg2)
			if not (arg2 and arg2.Parent) then
				return false
			end

			local ok, result = pcall(function()
				return arg2:Clone()
			end)

			if not ok or not result then
				return false
			end

			for _, descendant in ipairs(result:GetDescendants()) do
				if
					descendant:IsA("ParticleEmitter")
					or descendant:IsA("Beam")
					or descendant:IsA("Trail")
					or descendant:IsA("Light")
					or descendant:IsA("Sound")
					or descendant:IsA("Script")
					or descendant:IsA("LocalScript")
				then
					descendant:Destroy()
				end
			end

			local worldModel = Instance.new("WorldModel")
			worldModel.Parent = parent
			result.Parent = worldModel

			pcall(function()
				result:PivotTo(CFrame.new())
			end)

			local cframe = CFrame.new()

			local ok2, result2, result3 = pcall(function()
				return result:GetBoundingBox()
			end)

			ok2 = ok2 and result2 and result3
			local vector = Vector3.new(4, 4, 4)

			if not ok2 then
				result3 = vector
				result2 = cframe
			end

			local position = result2.Position
			local n10 =
				math.max(math.max(result3.X, result3.Y, result3.Z) * 1.35, 3.5)
			arg.FieldOfView = 40
			arg.CFrame = CFrame.lookAt(
				position + Vector3.new(n10 * 0.28, n10 * 0.08, -n10),
				position,
				Vector3.new(0, 1, 0)
			)
			local humanoid = arg2:FindFirstChildWhichIsA("Humanoid")
				or arg2:FindFirstChildWhichIsA("AnimationController")
			humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
			local humanoid2 = result:FindFirstChildWhichIsA("Humanoid")
				or result:FindFirstChildWhichIsA("AnimationController")
			local animator = humanoid2
				and humanoid2:FindFirstChildOfClass("Animator")

			if humanoid and animator then
				local playingAnimationTracks =
					humanoid:GetPlayingAnimationTracks()
				playingAnimationTracks = playingAnimationTracks
					and playingAnimationTracks[1]

				if
					playingAnimationTracks and playingAnimationTracks.Animation
				then
					local animation = Instance.new("Animation")
					animation.AnimationId =
						playingAnimationTracks.Animation.AnimationId

					local ok3, result4 = pcall(function()
						return animator:LoadAnimation(animation)
					end)

					if ok3 and result4 then
						pcall(function()
							result4.Looped = true
							result4:Play(0)
							result4.TimePosition =
								playingAnimationTracks.TimePosition
							result4:AdjustSpeed(playingAnimationTracks.Speed)
						end)
					end
				end
			end

			return true
		end

		local function fn40(arg)
			local v20 = table.find(tbl9, arg)

			if v20 then
				table.remove(tbl9, v20)
			end
		end

		local function createFrame()
			if v18 and v18.Parent then
				return v18
			end
			local parent = CoreGui

			if type(gethui) == "function" then
				local ok
				ok, parent = pcall(gethui)
				ok = ok and typeof(parent) == "Instance"
				local v20 = CoreGui

				if not ok then
					parent = v20
				end
			end

			local name = str .. "Gui"
			local v20 = parent:FindFirstChild(name)

			if v20 then
				pcall(function()
					v20:Destroy()
				end)
			end

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = name
			screenGui.DisplayOrder = 190
			screenGui.IgnoreGuiInset = true
			screenGui.ResetOnSpawn = false
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = parent
			local frame = Instance.new("Frame")
			frame.Name = "NotificationStack"
			frame.AnchorPoint = Vector2.new(0.5, 0)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.Position = UDim2.fromScale(0.5, 0.025)
			frame.Size = UDim2.new(1, -16, 0.55, 0)
			frame.Parent = screenGui
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Vertical
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 5)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
			uiListLayout.Parent = frame
			v17 = screenGui
			v18 = frame
			return frame
		end

		local function fn41()
			local currentCamera = Workspace.CurrentCamera
			local x = currentCamera and currentCamera.ViewportSize.X or 1280

			if x <= 0 then
				x = 1280
			end

			return math.clamp((x - 24) / 620, 0.44, 0.72)
		end

		local function fn42(arg, arg2, arg3)
			local secretZebra = tbl13[arg3 or "Secret Zebra"]
				or tbl13["Secret Zebra"]
			if type(arg) ~= "table" or not arg.Model then
				return false
			end
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			local notification = playerGui
				and playerGui:FindFirstChild("Notification")
			notification = notification
				and notification:FindFirstChild("Notification")
			notification = notification
				and notification:FindFirstChild("Template")

			if not (notification and notification:IsA("TextLabel")) then
				local v20 = fn32()

				if v20 and type(v20.Notify) == "function" then
					local str4 = string.upper(tostring(arg.Name or "Brainrot"))
						.. " APPEARED!  "
						.. tostring(arg.ValueText or "")
					local v21 = pcall
					local notify = v20.Notify
					arg2 = arg2 or 6
					local top = v21(notify, v20, str4, arg2, nil, "Top")

					if top then
						fn36()
					end

					return top
				end

				return false
			end

			local v20 = createFrame()
			if not v20 then
				return false
			end

			while #tbl9 >= 4 do
				local v21 = table.remove(tbl9, 1)

				if v21 and v21.Parent then
					v21:Destroy()
				end
			end

			local frame = Instance.new("Frame")
			frame.Name = "ChilliSpecialNotificationSlot"
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			local v21 = fn41()
			frame.Size = UDim2.new(1, 0, 0, math.ceil(108 * v21 + 7))
			frame.ZIndex = 179
			frame.Parent = v20
			tbl9[#tbl9 + 1] = frame
			local frame2 = Instance.new("Frame")
			frame2.Name = "ScaledCardRoot"
			frame2.AnchorPoint = Vector2.new(0.5, 0)
			frame2.BackgroundTransparency = 1
			frame2.BorderSizePixel = 0
			frame2.Position = UDim2.fromScale(0.5, 0)
			local ceil = math.ceil
			frame2.Size =
				UDim2.fromOffset(math.ceil(620 * v21), ceil(108 * v21))
			frame2.ZIndex = 179
			frame2.Parent = frame
			local uiScale = Instance.new("UIScale")
			uiScale.Scale = v21 * 0.72
			uiScale.Parent = frame2
			local frame3 = Instance.new("Frame")
			frame3.Name = "ChilliSpecialNotification"
			frame3.BackgroundColor3 = secretZebra.Background
			frame3.BackgroundTransparency = 0.04
			frame3.BorderSizePixel = 0
			frame3.ClipsDescendants = false
			frame3.AnchorPoint = Vector2.new(0.5, 0)
			frame3.Position = UDim2.fromOffset(310, 0)
			frame3.Size = UDim2.fromOffset(620, 108)
			frame3.ZIndex = 180
			frame3.Parent = frame2
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(0, 17)
			uiCorner.Parent = frame3
			local uiGradient = Instance.new("UIGradient")
			local colorSequence = ColorSequence.new
			local tbl14 = {}
			local v22 = ColorSequenceKeypoint.new(0, secretZebra.Background)
			local v23 = ColorSequenceKeypoint.new(
				0.48,
				secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.12)
			)
			local new = ColorSequenceKeypoint.new
			local background = secretZebra.Background
			tbl14[1] = v22
			tbl14[2] = v23

			do
				local values = table.pack(new(1, background))
				table.move(values, 1, values.n, 3, tbl14)
			end

			uiGradient.Color = colorSequence(tbl14)
			uiGradient.Rotation = 12
			uiGradient.Parent = frame3
			local uiStroke = Instance.new("UIStroke")
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke.Color = Color3.new(1, 1, 1)
			uiStroke.Thickness = 2.5
			uiStroke.Transparency = 0.05
			uiStroke.Parent = frame3
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Color = secretZebra.Colors
			uiGradient2.Parent = uiStroke
			local tween = TweenService:Create(
				uiGradient2,
				TweenInfo.new(
					2.4,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.InOut,
					-1
				),
				{ Rotation = 360 }
			)
			tween:Play()
			local uiStroke2 = Instance.new("UIStroke")
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke2.Color = secretZebra.Colors.Keypoints[1].Value
			uiStroke2.Thickness = 7
			uiStroke2.Transparency = 0.72
			uiStroke2.Parent = frame3
			local viewportFrame = Instance.new("ViewportFrame")
			viewportFrame.Name = "BrainrotPreview"
			viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
			viewportFrame.BackgroundColor3 =
				secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.08)
			viewportFrame.BackgroundTransparency = 0.08
			viewportFrame.BorderSizePixel = 0
			viewportFrame.ClipsDescendants = true
			viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
			viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
			viewportFrame.Position = UDim2.fromOffset(11, 9)
			viewportFrame.Size = UDim2.fromOffset(90, 90)
			viewportFrame.ZIndex = 183
			viewportFrame.Parent = frame3
			local uiCorner2 = Instance.new("UICorner")
			uiCorner2.CornerRadius = UDim.new(0, 14)
			uiCorner2.Parent = viewportFrame
			local uiStroke3 = Instance.new("UIStroke")
			uiStroke3.Color = Color3.new(1, 1, 1)
			uiStroke3.Thickness = 2
			uiStroke3.Transparency = 0.18
			uiStroke3.Parent = viewportFrame
			local uiGradient3 = Instance.new("UIGradient")
			uiGradient3.Color = secretZebra.Colors
			uiGradient3.Rotation = -25
			uiGradient3.Parent = uiStroke3
			local camera = Instance.new("Camera")
			camera.Parent = viewportFrame
			viewportFrame.CurrentCamera = camera
			fn39(viewportFrame, camera, arg.Model)
			local brainrotName = fn38(
				notification,
				frame3,
				"BrainrotName",
				tostring(arg.Name or "Brainrot"),
				UDim2.fromOffset(115, 7),
				UDim2.new(1, -252, 0, 34),
				22
			)
			brainrotName.RichText = false
			brainrotName.TextColor3 = Color3.new(1, 1, 1)
			brainrotName.TextTruncate = Enum.TextTruncate.AtEnd
			brainrotName.Font = Enum.Font.GothamBlack
			brainrotName.ZIndex = 183
			local tbl15 = {}

			local function fn43(parent, thickness)
				local uiStroke4 = Instance.new("UIStroke")
				uiStroke4.Name = "SpecialTextOutline"
				uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				uiStroke4.Color = Color3.fromRGB(0, 0, 0)
				uiStroke4.Thickness = thickness or 1.15
				uiStroke4.Transparency = 0.18
				uiStroke4.Parent = parent
				local v24 = fn37(parent, secretZebra)

				if v24 then
					tbl15[#tbl15 + 1] = v24
				end
			end

			fn43(brainrotName, 1.35)
			local frame4 = Instance.new("Frame")
			frame4.Name = "AppearedBadge"
			frame4.AnchorPoint = Vector2.new(1, 0)
			frame4.BackgroundColor3 = secretZebra.Colors.Keypoints[1].Value
			frame4.BackgroundTransparency = 0.08
			frame4.BorderSizePixel = 0
			frame4.Position = UDim2.new(1, -13, 0, 10)
			frame4.Size = UDim2.fromOffset(112, 25)
			frame4.ZIndex = 183
			frame4.Parent = frame3
			local uiCorner3 = Instance.new("UICorner")
			uiCorner3.CornerRadius = UDim.new(1, 0)
			uiCorner3.Parent = frame4
			local uiGradient4 = Instance.new("UIGradient")
			uiGradient4.Color = secretZebra.Colors
			uiGradient4.Rotation = 12
			uiGradient4.Parent = frame4
			local uiStroke4 = Instance.new("UIStroke")
			uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke4.Color = Color3.new(1, 1, 1)
			uiStroke4.Thickness = 1.25
			uiStroke4.Transparency = 0.2
			uiStroke4.Parent = frame4
			local appearedText = fn38(
				notification,
				frame4,
				"AppearedText",
				"APPEARED!",
				UDim2.fromOffset(6, 0),
				UDim2.new(1, -12, 1, 0),
				12
			)
			appearedText.RichText = false
			appearedText.Font = Enum.Font.Arcade
			appearedText.TextColor3 = Color3.new(1, 1, 1)
			appearedText.TextXAlignment = Enum.TextXAlignment.Center
			appearedText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			appearedText.TextStrokeTransparency = 0.25
			appearedText.ZIndex = 184
			local frame5 = Instance.new("Frame")
			frame5.Name = "GenerationBadge"
			frame5.BackgroundColor3 = Color3.fromRGB(4, 24, 10)
			frame5.BackgroundTransparency = 0.18
			frame5.BorderSizePixel = 0
			frame5.Position = UDim2.fromOffset(115, 44)
			frame5.Size = UDim2.fromOffset(142, 26)
			frame5.ZIndex = 183
			frame5.Parent = frame3
			local uiCorner4 = Instance.new("UICorner")
			uiCorner4.CornerRadius = UDim.new(0, 8)
			uiCorner4.Parent = frame5
			local uiStroke5 = Instance.new("UIStroke")
			uiStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uiStroke5.Color = Color3.fromRGB(75, 255, 104)
			uiStroke5.Thickness = 1.2
			uiStroke5.Transparency = 0.35
			uiStroke5.Parent = frame5
			local brainrotValue = fn38(
				notification,
				frame5,
				"BrainrotValue",
				tostring(arg.ValueText or ""),
				UDim2.fromOffset(9, 0),
				UDim2.new(1, -18, 1, 0),
				18
			)
			brainrotValue.RichText = false
			brainrotValue.Font = Enum.Font.RobotoMono
			brainrotValue.TextColor3 = Color3.fromRGB(86, 255, 105)
			brainrotValue.TextStrokeColor3 = Color3.fromRGB(0, 32, 7)
			brainrotValue.TextStrokeTransparency = 0.15
			brainrotValue.ZIndex = 184
			local uiGradient5 = Instance.new("UIGradient")
			local colorSequence2 = ColorSequence.new
			local tbl16 = {}
			local v24 =
				ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 220, 76))
			local v25 =
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 255, 132))
			local new2 = ColorSequenceKeypoint.new
			local color = Color3.fromRGB
			tbl16[1] = v24
			tbl16[2] = v25

			do
				local values = table.pack(new2(1, color(38, 255, 105)))
				table.move(values, 1, values.n, 3, tbl16)
			end

			uiGradient5.Color = colorSequence2(tbl16)
			uiGradient5.Rotation = -8
			uiGradient5.Parent = brainrotValue
			local tween2 = TweenService:Create(
				uiGradient5,
				TweenInfo.new(
					1.45,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.InOut,
					-1,
					true
				),
				{ Rotation = 18 }
			)
			tween2:Play()

			tbl15[#tbl15 + 1] = function()
				tween2:Cancel()
			end

			if arg.MutationVisible then
				local brainrotMutation = fn38(
					notification,
					frame3,
					"BrainrotMutation",
					tostring(arg.MutationText or ""),
					UDim2.fromOffset(115, 76),
					UDim2.new(1, -304, 0, 22),
					17
				)
				brainrotMutation.RichText = arg.MutationRichText == true
				brainrotMutation.TextColor3 = arg.MutationColor
					or Color3.fromRGB(235, 235, 240)
				brainrotMutation.TextStrokeColor3 = arg.MutationStrokeColor
					or Color3.fromRGB(0, 0, 0)
				brainrotMutation.TextStrokeTransparency = arg.MutationStrokeTransparency
					or 0.25
				brainrotMutation.TextTruncate = Enum.TextTruncate.AtEnd
				brainrotMutation.ZIndex = 183

				if arg.MutationFontFace then
					brainrotMutation.FontFace = arg.MutationFontFace
				end

				if arg.MutationGradientColor then
					local uiGradient6 = Instance.new("UIGradient")
					uiGradient6.Color = arg.MutationGradientColor
					uiGradient6.Rotation = arg.MutationGradientRotation or 0
					uiGradient6.Transparency = arg.MutationGradientTransparency
						or NumberSequence.new(0)
					uiGradient6.Parent = brainrotMutation
				else
					local uiStroke6 = Instance.new("UIStroke")
					uiStroke6.Name = "MutationGlow"
					uiStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
					uiStroke6.Color = arg.MutationColor or Color3.new(1, 1, 1)
					uiStroke6.Thickness = 1.1
					uiStroke6.Transparency = 0.5
					uiStroke6.Parent = brainrotMutation
				end
			end

			local frame6 = Instance.new("Frame")
			frame6.AnchorPoint = Vector2.new(1, 0)
			frame6.BackgroundTransparency = 1
			frame6.Position = UDim2.new(1, -13, 0, 74)
			frame6.Size = UDim2.fromOffset(174, 28)
			frame6.ZIndex = 183
			frame6.Parent = frame3
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			uiListLayout.Padding = UDim.new(0, 3)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.Parent = frame6
			local v26 = ipairs
			local traitImages = arg.TraitImages or {}

			for k, traitImage in v26(traitImages) do
				if not (k > 6) then
					local frame7 = Instance.new("Frame")
					frame7.Name = "TraitBadge"
					frame7.BackgroundColor3 =
						secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.16)
					frame7.BackgroundTransparency = 0.12
					frame7.BorderSizePixel = 0
					frame7.LayoutOrder = k
					frame7.Size = UDim2.fromOffset(26, 26)
					frame7.ZIndex = 183
					frame7.Parent = frame6
					local uiCorner5 = Instance.new("UICorner")
					uiCorner5.CornerRadius = UDim.new(0, 7)
					uiCorner5.Parent = frame7
					local uiStroke6 = Instance.new("UIStroke")
					uiStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uiStroke6.Color = secretZebra.Colors.Keypoints[1].Value
					uiStroke6.Thickness = 1
					uiStroke6.Transparency = 0.35
					uiStroke6.Parent = frame7
					local imageLabel = Instance.new("ImageLabel")
					imageLabel.BackgroundTransparency = 1
					imageLabel.Image = traitImage
					imageLabel.Position = UDim2.fromOffset(2, 2)
					imageLabel.Size = UDim2.fromOffset(22, 22)
					imageLabel.ZIndex = 184
					imageLabel.Parent = frame7
					continue
				end

				break
			end

			local frame7 = Instance.new("Frame")
			frame7.Name = "ShineClip"
			frame7.BackgroundTransparency = 1
			frame7.BorderSizePixel = 0
			frame7.ClipsDescendants = true
			frame7.Size = UDim2.fromScale(1, 1)
			frame7.ZIndex = 182
			frame7.Parent = frame3
			local uiCorner5 = Instance.new("UICorner")
			uiCorner5.CornerRadius = UDim.new(0, 17)
			uiCorner5.Parent = frame7
			local frame8 = Instance.new("Frame")
			frame8.Name = "Shine"
			frame8.BackgroundColor3 = Color3.new(1, 1, 1)
			frame8.BackgroundTransparency = 0.78
			frame8.BorderSizePixel = 0
			frame8.Position = UDim2.fromScale(-0.25, 0)
			frame8.Rotation = 18
			frame8.Size = UDim2.fromScale(0.13, 1.35)
			frame8.ZIndex = 182
			frame8.Parent = frame7
			local uiGradient6 = Instance.new("UIGradient")
			local numberSequence = NumberSequence.new
			local tbl17 = {}
			local v27 = NumberSequenceKeypoint.new(0, 1)
			local v28 = NumberSequenceKeypoint.new(0.5, 0)
			local new3 = NumberSequenceKeypoint.new
			tbl17[1] = v27
			tbl17[2] = v28

			do
				local values = table.pack(new3(1, 1))
				table.move(values, 1, values.n, 3, tbl17)
			end

			uiGradient6.Transparency = numberSequence(tbl17)
			uiGradient6.Parent = frame8
			TweenService:Create(
				uiScale,
				TweenInfo.new(
					0.42,
					Enum.EasingStyle.Back,
					Enum.EasingDirection.Out
				),
				{ Scale = v21 }
			):Play()
			TweenService:Create(
				frame8,
				TweenInfo.new(
					1.25,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.InOut
				),
				{ Position = UDim2.fromScale(1.18, -0.12) }
			):Play()
			fn36()
			local n10 = tonumber(arg2) or 6

			pcall(function()
				game:GetService("Debris"):AddItem(frame, n10 + 1.5)
			end)

			local flag7 = false

			local function fn44()
				if flag7 then
					return
				end
				flag7 = true

				for i_ = #tbl15, 1, -1 do
					pcall(tbl15[i_])
					tbl15[i_] = nil
				end

				pcall(function()
					tween:Cancel()
				end)

				fn40(frame)

				if frame.Parent then
					pcall(function()
						frame:Destroy()
					end)
				end
			end

			task.delay(n10, function()
				local v29 = flag7
				local flag8

				if flag7 then
					flag8 = v29
				else
					flag8 = not frame3.Parent
				end

				if flag8 then
					fn44()
					return
				end

				pcall(function()
					tween:Cancel()
					local tbl18 = { Scale = v21 * 0.78 }
					TweenService:Create(
						uiScale,
						TweenInfo.new(
							0.3,
							Enum.EasingStyle.Back,
							Enum.EasingDirection.In
						),
						tbl18
					):Play()

					for _, descendant in ipairs(frame3:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							TweenService
								:Create(descendant, TweenInfo.new(0.28), {
									TextTransparency = 1,
									BackgroundTransparency = 1,
								})
								:Play()
						elseif descendant:IsA("UIStroke") then
							TweenService:Create(
								descendant,
								TweenInfo.new(0.28),
								{ Transparency = 1 }
							):Play()
						elseif descendant:IsA("ImageLabel") then
							TweenService:Create(
								descendant,
								TweenInfo.new(0.28),
								{ ImageTransparency = 1 }
							):Play()
						elseif descendant:IsA("ViewportFrame") then
							TweenService
								:Create(descendant, TweenInfo.new(0.28), {
									BackgroundTransparency = 1,
									ImageTransparency = 1,
								})
								:Play()
						elseif descendant:IsA("Frame") then
							TweenService:Create(
								descendant,
								TweenInfo.new(0.28),
								{ BackgroundTransparency = 1 }
							):Play()
						end
					end

					TweenService:Create(
						frame3,
						TweenInfo.new(0.28),
						{ BackgroundTransparency = 1 }
					):Play()
				end)

				task.delay(0.34, fn44)
			end)

			task.delay(n10 + 1, fn44)
			return true
		end

		local function fn43(arg)
			local match, v20 = tostring(arg or "")
				:gsub("[%$,/s]", "")
				:gsub("%s+", "")
				:match("^([%d%.]+)([KkMmBbTt]?)$")
			local num = tonumber(match)
			if not num then
				return nil
			end
			return num
				* (
					({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(
						v20
					)] or 1
				)
		end

		local function fn44(arg)
			if arg >= 1e12 then
				return string.format("$%.2fT/s", arg / 1e12)
			end

			if arg >= 1e9 then
				return string.format("$%.2fB/s", arg / 1e9)
			end

			if arg >= 1000000 then
				return string.format("$%.2fM/s", arg / 1000000)
			end

			if arg >= 1000 then
				return string.format("$%.1fK/s", arg / 1000)
			end
			return string.format("$%d/s", math.floor(arg))
		end

		local function fn45(arg)
			return arg:FindFirstChild("RootPart")
				or arg.PrimaryPart
				or arg:FindFirstChildWhichIsA("BasePart")
		end

		local function fn46()
			local tbl14 = {}
			local debris = Workspace:FindFirstChild("Debris")
			if not debris then
				return tbl14
			end

			for _, child in ipairs(debris:GetChildren()) do
				if
					child:IsA("BasePart")
					and child.Name == "FastOverheadTemplate"
				then
					local animalOverhead =
						child:FindFirstChild("AnimalOverhead")
					local displayName = animalOverhead
						and animalOverhead:FindFirstChild("DisplayName")
					local generation = animalOverhead
						and animalOverhead:FindFirstChild("Generation")

					if
						displayName
						and displayName:IsA("TextLabel")
						and generation
						and generation:IsA("TextLabel")
					then
						local str4 = tostring(displayName.Text or "")
						tbl14[str4] = tbl14[str4] or {}
						tbl14[str4][#tbl14[str4] + 1] = {
							Position = child.Position,
							Value = fn43(generation.Text),
							Overhead = animalOverhead,
						}
					end
				end
			end

			return tbl14
		end

		local function fn47(arg, arg2, arg3)
			local v20, v21, v22 = ipairs(arg3[arg] or {})
			local n10 = 14
			local v23 = nil

			for _, v24 in v20, v21, v22 do
				local magnitude = (v24.Position - arg2).Magnitude

				if magnitude < n10 then
					n10 = magnitude
					v23 = v24
				end
			end

			return v23
		end

		local function fn48(arg, arg2)
			local v20 = tbl10[arg.Name]
			local n10 = type(v20) == "table" and tonumber(v20.Generation) or 0
			if n10 <= 0 then
				arg2 = arg2 and arg2.Value
				return arg2 or 0
			end
			local attribute = arg:GetAttribute("Mutation")
				or arg:GetAttribute("__mutation")
			local mutation = arg2 and arg2.Overhead:FindFirstChild("Mutation")

			if
				mutation
				and mutation:IsA("TextLabel")
				and mutation.Visible
				and mutation.Text ~= ""
			then
				attribute = mutation.Text
			end

			attribute = attribute and tbl11[tostring(attribute)]
			local n11 = 1

			if type(attribute) == "table" then
				n11 = 1 + (tonumber(attribute.Modifier) or 0)
			end

			local flag7 = false

			for _, child in ipairs(arg:GetChildren()) do
				local match = child.Name:match("^_Trait%.(.+)$")
				local v21 = match
					and (tbl12[match] or tbl12[match:gsub("_", " ")])

				if type(v21) == "table" then
					if match == "Sleepy" or v21.Name == "Sleepy" then
						flag7 = true
					else
						n11 += tonumber(v21.MultiplierModifier) or 0
					end
				end
			end

			local v21 = math.round(n10 * n11 * (flag7 and 0.5 or 1))
			arg2 = arg2 and arg2.Value
			if arg2 and arg2 > 0 then
				return arg2
			end
			return v21
		end

		local function fn49()
			local tbl14 = {}
			local plots = Workspace:FindFirstChild("Plots")
			if not plots then
				return tbl14, 0
			end
			local v20 = fn46()
			local n10 = 0

			for _, child in ipairs(plots:GetChildren()) do
				for _, child2 in ipairs(child:GetChildren()) do
					if child2:IsA("Model") and tbl10[child2.Name] then
						local v21 = fn45(child2)

						if v21 then
							local overhead =
								fn47(child2.Name, v21.Position, v20)
							local v22 = fn48(child2, overhead)

							if v22 > 0 then
								local v23 = tbl10[child2.Name]
								overhead = overhead and overhead.Overhead
								local mutation = overhead
									and overhead:FindFirstChild("Mutation")
								local visible = mutation
									and mutation:IsA("TextLabel")
									and mutation.Visible

								if visible then
									visible = tostring(mutation.Text or "")
										~= ""
								end

								if visible then
									visible = string.lower(
										tostring(mutation.Text or "")
									) ~= "normal"
								end

								local text = nil
								local flag7 = false
								local textColor3 = nil
								local flag8 = false
								local fontFace = nil
								local textStrokeColor3 = nil
								local textStrokeTransparency = nil
								local color = nil
								local rotation = nil
								local transparency = nil

								if visible then
									text = mutation.Text
									textColor3 = mutation.TextColor3
									flag8 = mutation.RichText
									fontFace = mutation.FontFace
									textStrokeColor3 = mutation.TextStrokeColor3
									textStrokeTransparency =
										mutation.TextStrokeTransparency
									local uiGradient =
										mutation:FindFirstChildWhichIsA(
											"UIGradient"
										)
									flag7 = true
									color = nil
									rotation = nil
									transparency = nil

									if uiGradient then
										color = uiGradient.Color
										rotation = uiGradient.Rotation
										transparency = uiGradient.Transparency
									end
								end

								local tbl15 = {}
								local traits = overhead
									and overhead:FindFirstChild("Traits")

								if traits then
									for _, child3 in
										ipairs(traits:GetChildren())
									do
										if
											child3:IsA("ImageLabel")
											and child3.Visible
											and child3.Image ~= ""
											and #tbl15 < 6
										then
											tbl15[#tbl15 + 1] = child3.Image
										end
									end
								end

								local rarity = type(v23) == "table"
										and (v23.Rarity or v23.Tier or v23.Rank)
									or nil

								tbl14[#tbl14 + 1] = {
									Model = child2,
									Name = child2.Name,
									Value = v22,
									ValueText = fn44(v22),
									Rarity = rarity and tostring(rarity) or "",
									MutationVisible = flag7,
									MutationText = text and tostring(text)
										or nil,
									MutationColor = textColor3,
									MutationRichText = flag8,
									MutationFontFace = fontFace,
									MutationStrokeColor = textStrokeColor3,
									MutationStrokeTransparency = textStrokeTransparency,
									MutationGradientColor = color,
									MutationGradientRotation = rotation,
									MutationGradientTransparency = transparency,
									TraitImages = tbl15,
								}

								if n10 < v22 then
									n10 = v22
								end
							end
						end
					end
				end
			end

			return tbl14, n10
		end

		local function fn50(arg, arg2)
			fn42(arg, 7, arg2 or "Secret Zebra")
		end

		local function fn51()
			table.clear(obj2)
			local v20, v21 = fn49()

			for _, v22 in ipairs(v20) do
				obj2[v22.Model] = { FirstSeen = -math.huge, Value = v22.Value }
			end

			n8 = v21
		end

		local function fn52()
			local now = os.clock()
			local v20, v21 = fn49()
			local tbl14 = {}
			local n10 = 0

			for _, v22 in ipairs(v20) do
				local v23 = obj2[v22.Model]
				local isNew = v23 == nil
				local flag7 = v23
					and now - v23.FirstSeen <= n6
					and v22.Value > v23.Value
				v22.IsNew = isNew
				v22.IsLateValue = flag7 == true

				if isNew then
					obj2[v22.Model] = { FirstSeen = now, Value = v22.Value }
				elseif v23.Value < v22.Value then
					v23.Value = v22.Value
				end

				if not isNew and not flag7 and v22.Value > n10 then
					n10 = v22.Value
				end
			end

			local v22 = nil

			for _, v23 in ipairs(v20) do
				if (v23.IsNew or v23.IsLateValue) and v23.Value >= n7 then
					tbl14[#tbl14 + 1] = v23

					if
						v23.Value > n10 and (not v22 or v23.Value > v22.Value)
					then
						v22 = v23
					end
				end
			end

			n8 = v21

			if flag6 and v22 then
				fn50(v22)
			elseif not flag6 then
				table.sort(tbl14, function(arg, arg2)
					return arg.Value > arg2.Value
				end)

				for _, v23 in ipairs(tbl14) do
					fn50(v23)
				end
			end
		end

		local function fn53()
			flag5 = false

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end

		local function fn54()
			fn53()
			fn51()
			flag5 = true
			n9 = os.clock() + n5

			connection = runtime.Track(
				RunService.Heartbeat:Connect(runtime.Guard(function()
					if not flag5 or os.clock() < n9 then
						return
					end
					n9 = os.clock() + n5
					pcall(fn52)
				end))
			)
		end

		local function fn55()
			fn53()

			for i_ = #tbl9, 1, -1 do
				local v20 = tbl9[i_]

				if v20 and v20.Parent then
					v20:Destroy()
				end

				tbl9[i_] = nil
			end

			if v17 and v17.Parent then
				v17:Destroy()
			end

			v17 = nil
			v18 = nil
		end

		runtime.Track(v15.Event:Connect(runtime.Guard(fn55)))
		runtime.Track(
			chilliBrainrotNotificationRuntim.Destroying:Connect(
				runtime.Guard(fn55)
			)
		)

		v10:CreateToggle({
			Name = "Brainrot Notifications",
			Default = false,
			Callback = function(arg)
				if arg then
					fn54()
				else
					fn53()
				end
			end,
		})
	end

	v10:CreateToggle({
		Name = "Only New Highest",
		Note = "Only notifies when the new Brainrot is worth more than every Brainrot already present.",
		Default = false,
		Callback = function(arg)
			flag6 = arg == true
		end,
	})

	do
		local tbl14 = {
			["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
			["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
			["B/s"] = { Min = 1, Max = 1000, Mult = 1e9 },
			["T/s"] = { Min = 1, Max = 1000, Mult = 1e12 },
		}

		local v20 = nil
		local n10 = 1
		local str4 = "M/s"

		local function fn32(arg, arg2)
			if arg ~= nil then
				n10 = math.floor(tonumber(arg) or n10)
			end

			if arg2 ~= nil then
				str4 = tostring(arg2)
			elseif v20 and v20.GetUnit then
				local unit = v20:GetUnit()

				if unit and unit ~= "" then
					str4 = tostring(unit)
				end
			end

			n7 = n10 * (tbl14[str4] or tbl14["M/s"]).Mult
		end

		local function fn33(arg)
			str4 = tostring(arg)
			local ms = tbl14[str4] or tbl14["M/s"]

			if v20 and v20.SetRange then
				v20:SetRange(ms.Min, ms.Max)
				local min = v20:Get() or ms.Min
				local min2 = ms.Min
				local max = ms.Max
				local n11 = math.clamp(math.floor(min + 0.5), min2, max)

				if n11 ~= min then
					v20:Set(n11)
				else
					fn32(n11, str4)
				end
			else
				fn32(nil, str4)
			end
		end

		v20 = v10:CreateSlider({
			Name = "Notification Min Value",
			Note = "Ignores newly spawned Brainrots below this generation value.",
			Min = 0,
			Max = 1000,
			Default = 0,
			AllowDecimals = false,
			Increment = 1,
			Unit = {
				Default = "M/s",
				Selector = true,
				Options = { "K/s", "M/s", "B/s", "T/s" },
				ColorEnabled = true,
				Colors = {
					Number = Color3.fromRGB(255, 255, 255),
					Suffix = Color3.fromRGB(58, 255, 55),
				},
				Callback = function(arg)
					fn33(arg)
				end,
			},
			Quick = false,
			Callback = function(arg)
				fn32(arg, nil)
			end,
		})
	end

	v10:CreateInput({
		Name = "Notification Sound ID",
		Note = "Enter an audio asset ID, then press Apply Sound ID.",
		Placeholder = "rbxassetid://123456789",
		Default = "rbxassetid://110902246151945",
		MaxLength = 40,
		Callback = function(arg)
			fn30(arg)
		end,
	})

	v10:CreateButton({
		Name = "Apply Sound ID",
		ButtonText = "Apply",
		Callback = function()
			task.spawn(function()
				fn31()
			end)
		end,
	})

	local v20
	v20 = Misc:CreateSection({ Name = "Performance", Expanded = true })
	local flag7 = false

	v20:CreateSlider({
		Name = "FPS Cap",
		Min = 30,
		Max = 1000,
		Default = 240,
		AllowDecimals = false,
		Increment = 1,
		Unit = " FPS",
		Quick = false,
		Callback = function(arg)
			local n10 = math.clamp(math.floor(tonumber(arg) or 240), 30, 1000)

			if type(setfpscap) == "function" then
				if pcall(setfpscap, n10) then
					flag7 = false
					return
				end
			end

			if not flag7 then
				flag7 = true
				v.Notify(
					"FPS Cap Unavailable",
					"This environment does not support setfpscap.",
					5
				)
			end
		end,
	})

	local flag8, n10, thread

	do
		local n11 = 300
		flag8 = false
		n10 = 0
		thread = nil
		local tbl14 = {}
		local tbl15 = {}
		local obj3 = setmetatable({}, { __mode = "k" })
		local chilliOptimizerRuntime =
			CoreGui:FindFirstChild("__Nullx11BrainrotOptimizerRuntime")

		if chilliOptimizerRuntime then
			local cleanup = chilliOptimizerRuntime:FindFirstChild("Cleanup")

			if cleanup and cleanup:IsA("BindableEvent") then
				pcall(function()
					cleanup:Fire()
				end)
			end

			pcall(function()
				chilliOptimizerRuntime:Destroy()
			end)
		end

		local folder = Instance.new("Folder")
		folder.Name = "__Nullx11BrainrotOptimizerRuntime"
		folder.Archivable = false
		folder.Parent = CoreGui
		local bindableEvent = Instance.new("BindableEvent")
		bindableEvent.Name = "Cleanup"
		bindableEvent.Parent = folder

		local function fn32(arg, arg2, arg3)
			local ok, result = pcall(arg)
			if not ok then
				return
			end
			tbl15[#tbl15 + 1] = { Setter = arg2, Value = result }
			pcall(arg2, arg3)
		end

		local function fn33(arg, arg2, arg3)
			local tbl16 = obj3[arg]

			if not tbl16 then
				tbl16 = {}
				obj3[arg] = tbl16
			end

			if tbl16[arg2] == nil then
				local ok, result = pcall(function()
					return arg[arg2]
				end)

				if not ok then
					return
				end
				tbl16[arg2] = { Value = result }
			end

			pcall(function()
				arg[arg2] = arg3
			end)
		end

		local function fn34(arg)
			if not flag8 or not arg.Parent then
				return
			end

			if obj[arg] then
				return
			end

			if arg:IsA("ParticleEmitter") then
				fn33(arg, "Enabled", false)
				fn33(arg, "Rate", 0)
			elseif arg:IsA("Trail") or arg:IsA("Beam") then
				fn33(arg, "Enabled", false)
			elseif
				arg:IsA("PointLight")
				or arg:IsA("SpotLight")
				or arg:IsA("SurfaceLight")
			then
				fn33(arg, "Enabled", false)
				fn33(arg, "Brightness", 0)
			elseif
				arg:IsA("Fire")
				or arg:IsA("Smoke")
				or arg:IsA("Sparkles")
			then
				fn33(arg, "Enabled", false)
			elseif arg:IsA("Explosion") then
				fn33(arg, "Visible", false)
			elseif arg:IsA("SpecialMesh") then
				fn33(arg, "TextureId", "")
			elseif arg:IsA("Decal") or arg:IsA("Texture") then
				if
					not (
						arg.Name == "face"
						and arg.Parent
						and arg.Parent.Name == "Head"
					)
				then
					fn33(arg, "Transparency", 1)
				end
			elseif arg:IsA("BasePart") then
				fn33(arg, "CastShadow", false)
				fn33(arg, "Material", Enum.Material.Plastic)
				fn33(arg, "Reflectance", 0)
			elseif arg:IsA("PostEffect") then
				fn33(arg, "Enabled", false)
			elseif arg:IsA("Atmosphere") then
				fn33(arg, "Density", 0)
				fn33(arg, "Haze", 0)
				fn33(arg, "Glare", 0)
			end
		end

		local function fn35()
			for _, v21 in ipairs(tbl14) do
				if v21.Connected then
					v21:Disconnect()
				end
			end

			table.clear(tbl14)
		end

		local function fn36()
			local rendering = settings().Rendering
			local terrain = Workspace.Terrain

			fn32(function()
				return Workspace.StreamingEnabled
			end, function(streamingEnabled)
				Workspace.StreamingEnabled = streamingEnabled
			end, true)

			fn32(function()
				return Workspace.StreamingMinRadius
			end, function(streamingMinRadius)
				Workspace.StreamingMinRadius = streamingMinRadius
			end, 64)

			fn32(function()
				return Workspace.StreamingTargetRadius
			end, function(streamingTargetRadius)
				Workspace.StreamingTargetRadius = streamingTargetRadius
			end, 256)

			fn32(function()
				return Workspace.StreamingIntegrityMode
			end, function(streamingIntegrityMode)
				Workspace.StreamingIntegrityMode = streamingIntegrityMode
			end, Enum.StreamingIntegrityMode.MinimumRadiusPause)

			fn32(function()
				return rendering.QualityLevel
			end, function(qualityLevel)
				rendering.QualityLevel = qualityLevel
			end, Enum.QualityLevel.Level01)

			fn32(function()
				return rendering.MeshPartDetailLevel
			end, function(meshPartDetailLevel)
				rendering.MeshPartDetailLevel = meshPartDetailLevel
			end, Enum.MeshPartDetailLevel.Level01)

			fn32(function()
				return rendering.EditQualityLevel
			end, function(editQualityLevel)
				rendering.EditQualityLevel = editQualityLevel
			end, Enum.QualityLevel.Level01)

			fn32(function()
				return Lighting.GlobalShadows
			end, function(globalShadows)
				Lighting.GlobalShadows = globalShadows
			end, false)

			fn32(function()
				return Lighting.FogEnd
			end, function(fogEnd)
				Lighting.FogEnd = fogEnd
			end, 9e9)

			fn32(function()
				return Lighting.Technology
			end, function(technology)
				Lighting.Technology = technology
			end, Enum.Technology.Legacy)

			fn32(function()
				return Lighting.EnvironmentDiffuseScale
			end, function(environmentDiffuseScale)
				Lighting.EnvironmentDiffuseScale = environmentDiffuseScale
			end, 0)

			fn32(function()
				return Lighting.EnvironmentSpecularScale
			end, function(environmentSpecularScale)
				Lighting.EnvironmentSpecularScale = environmentSpecularScale
			end, 0)

			fn32(function()
				return terrain.Decoration
			end, function(decoration)
				terrain.Decoration = decoration
			end, false)

			fn32(function()
				return terrain.WaterWaveSize
			end, function(waterWaveSize)
				terrain.WaterWaveSize = waterWaveSize
			end, 0)

			fn32(function()
				return terrain.WaterWaveSpeed
			end, function(waterWaveSpeed)
				terrain.WaterWaveSpeed = waterWaveSpeed
			end, 0)

			fn32(function()
				return terrain.WaterReflectance
			end, function(waterReflectance)
				terrain.WaterReflectance = waterReflectance
			end, 0)

			fn32(function()
				return terrain.WaterTransparency
			end, function(waterTransparency)
				terrain.WaterTransparency = waterTransparency
			end, 1)
		end

		local function fn37(arg, arg2)
			local descendants = arg:GetDescendants()

			for i_, descendant in ipairs(descendants) do
				if not flag8 or n10 ~= arg2 then
					return false
				end
				fn34(descendant)

				if i_ % n11 == 0 then
					RunService.Heartbeat:Wait()
				end
			end

			return true
		end

		local function fn38()
			local n12 = 0

			for k, v21 in pairs(obj3) do
				if k.Parent then
					for k2, v22 in pairs(v21) do
						pcall(function()
							k[k2] = v22.Value
						end)
					end
				end

				obj3[k] = nil
				n12 += 1

				if n12 % n11 == 0 then
					RunService.Heartbeat:Wait()
				end
			end
		end

		local function fn39()
			if not flag8 then
				return
			end
			flag8 = false
			n10 += 1
			fn35()

			if thread then
				pcall(task.cancel, thread)
				thread = nil
			end

			fn38()

			for i_ = #tbl15, 1, -1 do
				local v21 = tbl15[i_]
				pcall(v21.Setter, v21.Value)
			end

			table.clear(tbl15)
		end

		local function fn40()
			if flag8 then
				return
			end
			flag8 = true
			n10 += 1
			local v21 = n10
			fn36()

			tbl14[#tbl14 + 1] = runtime.Track(
				Workspace.DescendantAdded:Connect(
					runtime.Guard(function(descendant)
						if flag8 and n10 == v21 then
							task.defer(function()
								if flag8 and n10 == v21 then
									fn34(descendant)
								end
							end)
						end
					end)
				)
			)

			tbl14[#tbl14 + 1] = runtime.Track(
				Lighting.DescendantAdded:Connect(
					runtime.Guard(function(descendant)
						if flag8 and n10 == v21 then
							task.defer(function()
								if flag8 and n10 == v21 then
									fn34(descendant)
								end
							end)
						end
					end)
				)
			)

			thread = task.spawn(function()
				if not fn37(Workspace, v21) then
					return
				end
				fn37(Lighting, v21)
			end)
		end

		runtime.Track(bindableEvent.Event:Connect(runtime.Cleanup(fn39)))
		runtime.Track(folder.Destroying:Connect(runtime.Guard(fn39)))

		v20:CreateToggle({
			Name = "Optimizer",
			Default = false,
			Callback = function(arg)
				if arg then
					fn40()
				else
					fn39()
				end
			end,
		})
	end

	do
		local flag9 = false
		local connection2 = nil
		local connection3 = nil
		local tbl14 = {}
		local tbl15 = {}

		local function fn32(arg)
			return arg:IsA("Accessory")
				or arg:IsA("Clothing")
				or arg:IsA("ShirtGraphic")
		end

		local function fn33(arg)
			if flag9 and arg.Parent and fn32(arg) then
				pcall(function()
					arg:Destroy()
				end)
			end
		end

		local function fn34(arg)
			if not flag9 or not arg then
				return
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				fn33(descendant)
			end
		end

		local function fn35(player)
			local v21 = tbl14[player]

			if v21 then
				v21:Disconnect()
				tbl14[player] = nil
			end

			local v22 = tbl15[player]

			if v22 then
				v22:Disconnect()
				tbl15[player] = nil
			end
		end

		local function fn36(arg, arg2)
			local v21 = tbl14[arg]

			if v21 then
				v21:Disconnect()
			end

			tbl14[arg] = runtime.Track(
				arg2.DescendantAdded:Connect(runtime.Guard(function(descendant)
					if flag9 and fn32(descendant) then
						task.defer(fn33, descendant)
					end
				end))
			)

			fn34(arg2)
		end

		local function fn37(player)
			fn35(player)

			tbl15[player] = runtime.Track(
				player.CharacterAdded:Connect(runtime.Guard(function(character_)
					if flag9 then
						fn36(player, character_)
					end
				end))
			)

			if player.Character then
				fn36(player, player.Character)
			end
		end

		local function fn38()
			flag9 = false

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			for k in pairs(tbl15) do
				fn35(k)
			end

			for k in pairs(tbl14) do
				fn35(k)
			end
		end

		local function fn39()
			if flag9 then
				return
			end
			flag9 = true
			connection2 =
				runtime.Track(Players.PlayerAdded:Connect(runtime.Guard(fn37)))
			connection3 = runtime.Track(
				Players.PlayerRemoving:Connect(runtime.Guard(fn35))
			)

			for _, player in ipairs(Players:GetPlayers()) do
				fn37(player)
			end
		end

		fn2(fn38)

		v20:CreateToggle({
			Name = "Hide Player Cosmetics",
			Default = false,
			Callback = function(arg)
				if arg then
					fn39()
				else
					fn38()
				end
			end,
		})
	end

	local name
	name = "ChilliFpsPingGui"
	local n11
	n11 = 132
	local n12
	n12 = 0.085
	local n13
	n13 = 0.2
	local n14
	n14 = 8
	local fn32, fn33
	local v21 = v2:CreateState({ Name = "FPS and Ping Position", Default = {} })

	fn32 = function()
		local v22 = v21:Get()
		if
			type(v22) == "table"
			and type(v22.XOffset) == "number"
			and type(v22.YOffset) == "number"
		then
			return UDim2.new(
				tonumber(v22.XScale) or 0,
				v22.XOffset,
				tonumber(v22.YScale) or 0,
				v22.YOffset
			)
		end
		return UDim2.new(0, 16, 0, 16)
	end

	fn33 = function(arg)
		v21:Set({
			XScale = arg.X.Scale,
			XOffset = arg.X.Offset,
			YScale = arg.Y.Scale,
			YOffset = arg.Y.Offset,
		})
	end

	local color
	color = Color3.fromRGB(58, 255, 55)

	do
		local color2 = Color3.fromRGB(255, 214, 84)
		local color3 = Color3.fromRGB(255, 96, 96)
		local color4 = Color3.fromRGB(150, 150, 158)
		local flag9 = false
		local tbl14 = {}
		local screenGui = nil
		local frame = nil
		local uiScale = nil
		local v22 = nil
		local v23 = nil
		local n15 = 1
		local n16 = 0
		local n17 = 0
		local v24 = nil
		local v25 = nil
		local gothamBold = Enum.Font.GothamBold

		pcall(function()
			gothamBold = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.ExtraBold,
				Enum.FontStyle.Normal
			)
		end)

		local function fn34(arg)
			if typeof(gothamBold) == "Font" then
				arg.FontFace = gothamBold
			else
				arg.Font = Enum.Font.GothamBold
			end
		end

		local function fn35(arg)
			if arg >= 100 then
				return color
			end

			if arg >= 50 then
				return color2
			end
			return color3
		end

		local function fn36(arg)
			if arg <= 90 then
				return color
			end

			if arg <= 180 then
				return color2
			end
			return color3
		end

		local function fn37()
			if not uiScale then
				return
			end
			local currentCamera = Workspace.CurrentCamera
			currentCamera = currentCamera and currentCamera.ViewportSize
				or Vector2.new(1280, 720)

			if currentCamera.X < 1 then
				currentCamera = Vector2.new(1280, 720)
			end

			uiScale.Scale = math.clamp(currentCamera.X * n12 / n11, 0.7, 1.4)
				* n15
		end

		local function fn38()
			for _, v26 in ipairs(tbl14) do
				pcall(function()
					v26:Disconnect()
				end)
			end

			table.clear(tbl14)

			if screenGui then
				pcall(function()
					screenGui:Destroy()
				end)
			end

			screenGui = nil
			frame = nil
			uiScale = nil
			v22 = nil
			v23 = nil
			v24 = nil
			v25 = nil
			n16 = 0
		end

		local function createTextLabel(
			parent,
			arg,
			arg2,
			textXAlignment,
			textColor3
		)
			local textLabel = Instance.new("TextLabel")
			textLabel.BackgroundTransparency = 1
			textLabel.Position = UDim2.fromOffset(arg, 9)
			textLabel.Size = UDim2.fromOffset(arg2, 16)
			textLabel.Text = ""
			textLabel.TextColor3 = textColor3
			textLabel.TextScaled = true
			textLabel.TextXAlignment = textXAlignment
			fn34(textLabel)
			textLabel.Parent = parent
			return textLabel
		end

		local function fn39()
			fn38()
			local v26 = CoreGui

			if type(gethui) == "function" then
				local ok, result = pcall(gethui)
				ok = ok and typeof(result) == "Instance"
				local v27 = CoreGui

				if ok then
					v26 = result
				else
					v26 = v27
				end
			end

			local chilliFpsPingGui = v26:FindFirstChild("ChilliFpsPingGui")

			if chilliFpsPingGui then
				pcall(function()
					chilliFpsPingGui:Destroy()
				end)
			end

			screenGui = Instance.new("ScreenGui")
			screenGui.Name = name
			screenGui.DisplayOrder = 58
			screenGui.IgnoreGuiInset = true
			screenGui.ResetOnSpawn = false
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = v26
			frame = Instance.new("Frame")
			frame.Active = true
			frame.AnchorPoint = Vector2.new(0, 0)
			frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
			frame.BackgroundTransparency = 0.28
			frame.BorderSizePixel = 0
			frame.Position = fn32()
			frame.Size = UDim2.fromOffset(132, 34)
			frame.Parent = screenGui
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Color = Color3.fromRGB(255, 255, 255)
			uiStroke.Thickness = 1
			uiStroke.Transparency = 0.9
			uiStroke.Parent = frame
			uiScale = Instance.new("UIScale")
			uiScale.Parent = frame
			fn37()
			v22 =
				createTextLabel(frame, 12, 34, Enum.TextXAlignment.Left, color)
			createTextLabel(frame, 48, 22, Enum.TextXAlignment.Left, color4).Text =
				"FPS"
			local frame2 = Instance.new("Frame")
			frame2.AnchorPoint = Vector2.new(0.5, 0.5)
			frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame2.BackgroundTransparency = 0.85
			frame2.BorderSizePixel = 0
			frame2.Position = UDim2.new(0, 74, 0.5, 0)
			frame2.Size = UDim2.fromOffset(1, 14)
			frame2.Parent = frame
			v23 =
				createTextLabel(frame, 82, 30, Enum.TextXAlignment.Left, color)
			createTextLabel(frame, 113, 14, Enum.TextXAlignment.Left, color4).Text =
				"ms"
			local currentCamera = Workspace.CurrentCamera

			if currentCamera then
				tbl14[#tbl14 + 1] = runtime.Track(
					currentCamera
						:GetPropertyChangedSignal("ViewportSize")
						:Connect(runtime.Guard(fn37))
				)
			end

			local flag10 = false
			local v27 = nil
			local vector2 = Vector2.new(0, 0)
			local position = nil

			tbl14[#tbl14 + 1] = runtime.Track(
				frame.InputBegan:Connect(runtime.Guard(function(input)
					if
						flag10
						or input.UserInputState ~= Enum.UserInputState.Begin
					then
						return
					end
					local flag11 = input.UserInputType
						== Enum.UserInputType.Touch
					if
						not (
							input.UserInputType
							== Enum.UserInputType.MouseButton1
						) and not flag11
					then
						return
					end
					local vector22 =
						Vector2.new(input.Position.X, input.Position.Y)
					local absolutePosition = frame.AbsolutePosition
					local absoluteSize = frame.AbsoluteSize
					if
						vector22.X < absolutePosition.X
						or vector22.X > absolutePosition.X + absoluteSize.X
						or vector22.Y < absolutePosition.Y
						or vector22.Y > absolutePosition.Y + absoluteSize.Y
					then
						return
					end
					flag10 = true
					v27 = flag11 and input or nil
					vector2 = vector22
					position = frame.Position
				end))
			)

			tbl14[#tbl14 + 1] = runtime.Track(
				UserInputService.InputChanged:Connect(
					runtime.Guard(function(input)
						if not flag10 or not frame or not position then
							return
						end

						if
							not (
								v27 and input == v27
								or not v27
									and input.UserInputType == Enum.UserInputType.MouseMovement
							)
						then
							return
						end
						local n18 = Vector2.new(
							input.Position.X,
							input.Position.Y
						) - vector2
						frame.Position = UDim2.new(
							position.X.Scale,
							position.X.Offset + n18.X,
							position.Y.Scale,
							position.Y.Offset + n18.Y
						)
					end)
				)
			)

			tbl14[#tbl14 + 1] = runtime.Track(
				UserInputService.InputEnded:Connect(
					runtime.Guard(function(input)
						if not flag10 then
							return
						end
						local flag11 = v27 and input == v27
						local flag12

						if flag11 then
							flag12 = flag11
						else
							flag12 = not v27
								and input.UserInputType
									== Enum.UserInputType.MouseButton1
						end

						if flag12 then
							flag10 = false
							v27 = nil
							position = nil
							fn33(frame.Position)
						end
					end)
				)
			)

			tbl14[#tbl14 + 1] = runtime.Track(
				RunService.RenderStepped:Connect(
					runtime.Guard(function(deltaTime)
						if not flag9 or not v22 then
							return
						end
						local n18 = math.clamp(deltaTime, 0.001, 1)
						local n19 = 1 / n18

						if n16 <= 0 then
							n16 = n19
						else
							n16 += (n19 - n16) * (1 - math.exp(-n18 * n14))
						end

						local now = os.clock()
						if now < n17 then
							return
						end
						n17 = now + n13
						local n20 = math.floor(n16 + 0.5)
						local text = tostring(n20)

						if text ~= v24 then
							v24 = text
							v22.Text = text
							v22.TextColor3 = fn35(n20)
						end

						local n21 = 0

						pcall(function()
							n21 =
								Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
						end)

						local n22 = math.floor(n21 + 0.5)
						local text2 = tostring(n22)

						if text2 ~= v25 then
							v25 = text2
							v23.Text = text2
							v23.TextColor3 = fn36(n22)
						end
					end)
				)
			)
		end

		v20:CreateSlider({
			Name = "FPS and Ping Size",
			Min = 60,
			Max = 160,
			Default = 100,
			AllowDecimals = false,
			Increment = 1,
			Unit = "%",
			Quick = false,
			SubOf = v20:CreateToggle({
				Name = "FPS and Ping",
				Note = "Shows a small draggable readout of frame rate and ping.",
				Default = false,
				Callback = function(arg)
					flag9 = arg == true

					if flag9 then
						fn39()
					else
						fn38()
					end
				end,
			}),
			Callback = function(arg)
				n15 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)
				fn37()
			end,
		})

		fn2(fn38)
	end

	do
		local v22 = Server:CreateSection({ Name = "Server", Expanded = true })

		local str4 = "Most Players"
		local flag9 = false

		v22:CreateDropdown({
			Name = "Server Hop Mode",
			Options = { "Most Players", "Random", "Least Players" },
			Default = "Most Players",
			Quick = false,
			Callback = function(arg)
				str4 = tostring(arg or "Most Players")
			end,
		})

		v22:CreateButton({
			Name = "Server Hop",
			ButtonText = "Hop",
			Callback = function()
				if flag9 then
					return
				end
				flag9 = true

				task.spawn(function()
					local v24 = str4
					local str5 = tostring(game.JobId or "")
					local tbl14 = {}
					local flag10 = v24 == "Random"
					local str6 = v24 == "Least Players" and "Asc" or "Desc"
					local n15 = flag10 and 3 or 1
					local nextPageCursor = nil

					for i_ = 1, n15 do
						local str7 = string.format(
							"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100",
							game.PlaceId,
							str6
						)

						if nextPageCursor and nextPageCursor ~= "" then
							str7 ..= "&cursor=" .. HttpService:UrlEncode(
								nextPageCursor
							)
						end

						local ok, result = pcall(function()
							return HttpService:JSONDecode(game:HttpGet(str7))
						end)

						if not ok or type(result) ~= "table" then
							break
						else
							local v25 = ipairs
							local data = result.data or {}

							for _, v26 in v25(data) do
								local str8 = tostring(v26.id or "")
								local huge = tonumber(v26.playing) or math.huge
								local n16 = tonumber(v26.maxPlayers) or 0

								if
									str8 ~= ""
									and str8 ~= str5
									and huge < n16
								then
									tbl14[#tbl14 + 1] =
										{ Id = str8, Playing = huge }
								end
							end

							if #tbl14 > 0 and not flag10 then
								break
							else
								nextPageCursor = result.nextPageCursor

								if
									not nextPageCursor
									or nextPageCursor == ""
								then
									break
								else
								end
							end
						end
					end

					if #tbl14 == 0 then
						flag9 = false
						v.Notify(
							"Server Hop Failed",
							"No different public server is currently available.",
							5
						)
						return
					end

					local id

					if flag10 then
						id = tbl14[math.random(1, #tbl14)].Id
					else
						table.sort(tbl14, function(arg, arg2)
							if v24 == "Least Players" then
								return arg.Playing < arg2.Playing
							end
							return arg.Playing > arg2.Playing
						end)

						id = tbl14[1].Id
					end

					if
						not pcall(function()
							TeleportService:TeleportToPlaceInstance(
								game.PlaceId,
								id,
								localPlayer
							)
						end)
					then
						flag9 = false
						v.Notify(
							"Server Hop Failed",
							"Roblox could not join the selected server.",
							5
						)
					end
				end)
			end,
		})

		v22:CreateButton({
			Name = "Kick",
			ButtonText = "Kick",
			ConfirmText = "",
			Callback = function()
				Players.LocalPlayer:Kick("\nDisconnected by Nullx11")
			end,
		})

		local flag10 = false
		local str5 = ""

		local function fn36(arg)
			return tostring(arg or ""):match("^%s*(.-)%s*$")
		end

		v22:CreateInput({
			Name = "Job ID",
			Placeholder = "Paste a server Job ID...",
			Default = "",
			MaxLength = 100,
			Callback = function(arg)
				str5 = fn36(arg)
			end,
		})

		v22:CreateButton({
			Name = "Join Job ID",
			ButtonText = "Join",
			Callback = function()
				local v24 = fn36(str5)
				local v25 = flag10
				local flag11

				if flag10 then
					flag11 = v25
				else
					flag11 = v24 == ""
				end

				if flag11 then
					v.Notify(
						"Join Job ID Failed",
						"Paste a valid Job ID first.",
						5
					)
					return
				end
				flag10 = true

				if
					not pcall(function()
						TeleportService:TeleportToPlaceInstance(
							game.PlaceId,
							v24,
							localPlayer
						)
					end)
				then
					flag10 = false
					v.Notify(
						"Join Job ID Failed",
						"Roblox could not join that server.",
						5
					)
				end
			end,
		})

		v22:CreateButton({
			Name = "Copy Current Job ID",
			ButtonText = "Copy",
			Callback = function()
				local v24 = setclipboard or toclipboard
				local flag11 = type(v24) == "function"

				if flag11 then
					flag11 = pcall(v24, tostring(game.JobId or ""))
				end

				v.Notify(
					flag11 and "Job ID Copied" or "Copy Failed",
					flag11 and tostring(game.JobId)
						or "Clipboard access is unavailable.",
					5
				)
			end,
		})

		v22:CreateButton({
			Name = "Rejoin Server",
			ButtonText = "Rejoin",
			Callback = function()
				if flag10 or game.JobId == "" then
					return false
				end
				flag10 = true

				local ok = pcall(function()
					TeleportService:TeleportToPlaceInstance(
						game.PlaceId,
						game.JobId,
						localPlayer
					)
				end)

				if not ok then
					flag10 = false
				end

				return ok
			end,
		})
	end

	local v22 = v3:CreateSection({ Name = "Planned", Expanded = true })
	v22:CreateText({
		Name = "Admin Panel",
		Text = "Not implemented in the supplied source.",
		Config = false,
	})
	v22:CreateText({
		Name = "Teleport To Brainrot",
		Text = "Not implemented in the supplied source.",
		Config = false,
	})
	v22:CreateText({
		Name = "Priority Brainrot",
		Text = "Not implemented in the supplied source.",
		Config = false,
	})

	v:Finalize({ Window = v2, MainTab = defaultTab, ShowMainTab = false })
	chilliGithubFastManualDefaultsRu.Status = "ready"
	return chilliGithubFastManualDefaultsRu
end
if not game:IsLoaded() then
	game.Loaded:Wait()
end
local entry = {
	Id = "stealabrainrot",
	Name = "stealabrainrot",
	Description = "Supplied Chilli controller adapted to Nullx11 controls: stealer, helper, player, ESP and server tools. Automation starts off; required game modules are checked first.",
	File = "Nullx11-StealABrainrot.luau",
	Author = "Developed by Gab; adapted from user-supplied recovered Chilli source; original attribution retained.",
}
local environment = type(getgenv) == "function" and getgenv() or _G
local library = createNullx11UI({
	Id = "StealABrainrot",
	ReducedMotion = environment.Nullx11ReducedMotion == true,
})
local function compatible()
	local storage = game:GetService("ReplicatedStorage")
	local datas = storage:FindFirstChild("Datas")
	local packages = storage:FindFirstChild("Packages")
	local animals = datas and datas:FindFirstChild("Animals")
	local mouse = packages and packages:FindFirstChild("PlayerMouse")
	return animals
		and animals:IsA("ModuleScript")
		and mouse
		and mouse:IsA("ModuleScript")
		and workspace:FindFirstChild("Plots") ~= nil
end
if not compatible() then
	wrongPlace(
		library,
		entry,
		"https://raw.githubusercontent.com/Inkflow-Gab/Nullx11-Loader/arena/bc7610cd-nullx11-loader/scripts/Nullx11-StealABrainrot.luau"
	)
	return
end
local context = makeSession(entry.Id, library)
context.Adapter =
	makeAdapter(library, entry.Name, "Nullx11 " .. "StealABrainrot")

context.Runtime = makeOwnedRuntime(context)
context.ChilliAdapter = makeChilliAdapter(library, context.Runtime)
local ok, result = xpcall(function()
	return runGame(context)
end, debug.traceback)
if not ok then
	library:Unload()
	warn("[" .. entry.Name .. "] " .. tostring(result))
	local notice = createNullx11UI({ Id = "StealABrainrotError" })
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
