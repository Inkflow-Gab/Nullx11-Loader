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
		"   executor: " .. executor .. "   //   player: " .. game:GetService(
			"Players"
		).LocalPlayer.Name,
		rule,
	}, "\n"))
end

---@param label string
function Nullx11Banner.Step(label)
	local now = os.clock()
	Nullx11Banner.Done = math.min(Nullx11Banner.Done + 1, Nullx11Banner.Total)
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
		rawset(self, key, type(value) == "function" and LPH_JIT(value) or value)
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
		AutoRace = { "Remote.Class_Server.LuckOnceRE", "Config.Class.Config" },
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
local GameConfig = ReplicatedStorage:WaitForChild("Config", Config.LoadTimeout)

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

Nullx11Forge.GameLib = { Loaded = {}, Failed = {}, Apis = {}, Deferred = {} }

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
	local oreConfig = Nullx11Forge.GameLib.Need(GameConfig.Ore.Config)[oreId]
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
		local delta = Nullx11Forge.Data.Count(Nullx11Forge.Data.Get(true), id)
			- before
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
				((Nullx11Forge.Data.Get(true).Buff or {})[buffId] or 0) > before
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
	local goodsConfig = Nullx11Forge.GameLib.Need(GameConfig.TokenShop.Config)
	local exchange = Nullx11Forge.Util.Remote("TokenShop", "ExchangeGoodsRF")
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
	for slot, good in pairs(profile.TokenShop and profile.TokenShop.Goods or {}) do
		if not State.Alive then
			break
		end
		local entry = goodsConfig[tonumber(slot)] or goodsConfig[tostring(slot)]
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
			(profile.Token and profile.Token.value or 0) < (entry.Token or 0)
		then
			continue
		end
		if not good.Open then
			continue
		end
		local success = context.Send(exchange, "InvokeServer", tostring(slot))
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
	local plan = Nullx11Forge.GameLib.Api(ReplicatedStorage.LocalData.PlanKData)
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
		local stageManager = manager and manager:FindFirstChild("StageManager")
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
							context.Send(getOre, "InvokeServer", dropUuid, true)
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
	local stageId = State.Opt.Stage or Nullx11Forge.Stage.Best() or "Stage_27"
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
					if type(drop) == "table" and drop.Type == "Material" then
						context.Send(pickStone, "FireServer", uuid)
					else
						task.spawn(function()
							if
								context.Send(getOre, "InvokeServer", uuid, true)
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
	local uuid = Nullx11Forge.Ore.Ensure(oreId, count * State.Opt.ForgePerTick)
	return uuid and { [uuid] = count }
end

---@return boolean
function Nullx11Forge.Forge.Once()
	local target = Nullx11Forge.Forge.Target()
	local pick = Nullx11Forge.Forge.Pick(target.ores)
	return pick ~= nil and Nullx11Forge.Forge.Run(target.forgeType, pick) ~= nil
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
			Nullx11Forge.Forge.Run(target.forgeType, { [uuid] = target.ores })
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
	local backpack =
		Nullx11Forge.GameLib.Require(ReplicatedStorage.LocalData.BackpackData)
	if type(backpack) == "table" and type(backpack.IsLocked) == "function" then
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
		potential.Level = math.max(entry.Level or 0, State.Opt.EnhanceTarget)
	end
	local value = entry.Type == "Weapon" and balance.GetWeaponTrainValue
		or balance.GetArmorValue
	local ok, power = pcall(value, LocalPlayer, potential, backpack)
	if not ok or type(power) ~= "number" then
		return 0
	end
	return power
		* (1 + (entry.Level or 0) * 1e-6 + #(entry.EnchanceList or {}) * 1e-9)
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
	local cost = Nullx11Forge.GameLib.Need(GameConfig.Enhant.Config)[level + 1]
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
	local enhance = Nullx11Forge.Util.Remote("Backpack", "EnhantEquipmentRF")
	for _, spec in ipairs(Config.GearSlots) do
		local uuid = profile.Backpack.equiped[spec.slot]
		local entry = uuid and profile.Backpack.have[uuid]
		if entry and (entry.Level or 0) < target then
			local missing =
				Nullx11Forge.Gear.MissingForEnhance(profile, entry.Level or 0)
			if missing then
				Nullx11Forge.Gear.Gather(missing)
				return false
			end
			State.GearNote = "Enhancing"
			local useProtect = Nullx11Forge.Data.Count(profile, "EnhantProtect")
					> 0
				and (entry.Level or 0)
					>= Nullx11Forge.GameLib
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
	local enhance = Nullx11Forge.Util.Remote("Backpack", "EnhantEquipmentRF")
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
					and Nullx11Forge.Data.Count(profile, "EnhantProtect")
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
		local uuid = Nullx11Forge.Ore.Ensure(oreId, count * Config.HuntBatch)
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
	local completeRF = Nullx11Forge.Util.Remote("Dungeon", "CompleteRoundRF")
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
		gained = ((Nullx11Forge.Season.Current() or {}).SeasonCoin or 0) - start
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
	local attack = Nullx11Forge.Util.Remote("Attack", "AttackEnemyServiceRE")
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
	local claim = Nullx11Forge.Util.Remote("WorldBoss", "TryClaimBossRewardRE")
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
			local count = season and ((season.Goods or {})[goodId] or 0) or 0
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
			if not updated or ((updated.Goods or {})[goodId] or 0) <= count then
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
	for rewardName in pairs(ok and type(rewards) == "table" and rewards or {}) do
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
	if not State.Alive or type(uuid) ~= "string" or State.LootSeen[uuid] then
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
	local hitInfo =
		{ SkillID = attackId, IsCrit = State.Opt.AuraCritical, Damage = damage }

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
	local pickStone = Nullx11Forge.Util.FindRemote("Stage", "GetEnhantStoneRE")

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
				if (enemy:GetPivot().Position - origin).Magnitude > range then
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
				pcall(
					context.Send,
					attackService,
					"FireServer",
					{ name },
					{ Phase = 1, SkillID = attackId, Attacker = LocalPlayer },
					now
				)
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
			Nullx11Forge.Scheduler.Run("KillAura", Nullx11Forge.Combat.KillAll)
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
	local hpCtrl = Nullx11Forge.GameLib.Require(ReplicatedStorage.CTRL.HPCTRL)
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
	original, restore = compat.HookMeta(game, "__namecall", function(self, ...)
		if
			self == lostOre
			and State.Opt.KeepOre
			and getnamecallmethod() == "InvokeServer"
		then
			return {}
		end
		return original(self, ...)
	end)
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
	if not bestSlot or tostring(bestSlot) == tostring(classData.equiped) then
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
			and Nullx11Forge.Race.Level(classId) >= State.Opt.RaceMinLevel
		)
	return wanted
		and Nullx11Forge.Race.Stars(classId) >= (State.Opt.RaceStar or 0)
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
	local protectLevel = Nullx11Forge.Race.RarityLevel(Config.RaceProtectRarity)
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
	local skills = type(entry.ExtraSkill) == "table" and #entry.ExtraSkill or 0
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
		if not protected[item.uuid] and State.Opt.DeletePetRarities[rarity] then
			context.Send(deleteRE, "FireServer", item.uuid)
			deletedPets += 1
		end
	end
	local deletedEggs = State.Opt.AutoDeleteEggs and Nullx11Forge.Pet.TrimEggs()
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
	local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow())
		or (workspace:GetAttribute("ServerTime") or os.time())
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
	local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow())
		or (workspace:GetAttribute("ServerTime") or os.time())
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
			local rarity = petCfg and petCfg[id] and petCfg[id].Rarity or "Pet"
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
			if rarityLv >= 4 or table.find(petStore.equiped or {}, uuid) then
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
	local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow())
		or (workspace:GetAttribute("ServerTime") or os.time())
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
			table.insert(foods, { uuid = uuid, count = count, exp = info.Exp })
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
				("%s Lv.%d"):format(tostring(name), tonumber(entry.Level) or 1)
			)
		end
	end
	local eqText = #equippedNames > 0 and table.concat(equippedNames, ", ")
		or "None"
	local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow())
		or (workspace:GetAttribute("ServerTime") or os.time())
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
		if server.id == game.JobId or server.playing >= server.maxPlayers then
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
	TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer)
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
	if not ok or type(decoded) ~= "table" or type(decoded.ids) ~= "table" then
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
		if server.id ~= game.JobId and server.playing < server.maxPlayers then
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
	TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
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
	if (Nullx11Forge.Boss.SinceLastHop() or Config.HopGap) < Config.HopGap then
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
			if State.Opt.AutoRejoin and msg ~= "" and not State.Rejoining then
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
	State.JobStats[key] =
		{ ok = ok, at = os.clock(), error = not ok and tostring(err) or nil }
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
			local ok, err = pcall(Nullx11Forge.Scheduler.Run, job.key, job.run)
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
			local acquired, outcome = Nullx11Forge.Util.Exclusive(name, action)
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
		local statusBox = tab:AddLeftGroupbox(T("Status", "สถานะ"))
		statusLabel = statusBox:AddLabel("Loading...")
		gearLabel = statusBox:AddLabel("Equipped: -")
		taskLabel = statusBox:AddLabel("Working on: Idle")

		local kaitunBox = tab:AddLeftGroupbox(T("Kaitun", "ไก่ตัน"))
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
					return ("Claimed %d check-in rewards"):format(count or 0)
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

		local equipBox = tab:AddRightGroupbox(T("Equip", "ใส่ของ"))
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
			Text = T("Enhance Slot", "ช่องที่ตีบวก"),
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
				return level and ("%s is +%d"):format(opt.EnhanceSlot, level)
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

		local combatBox =
			tab:AddLeftGroupbox(T("Combat", "ต่อสู้"), nil, "OP")
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
			T("Targets Per Sweep", "เป้าหมายต่อรอบ"),
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
				opt.AuraInterval = math.clamp(tonumber(value) or 0.12, 0.05, 1)
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
					and LocalPlayer:GetAttribute("IntoFight") == "WorldBoss"
				then
					task.spawn(Nullx11Forge.Util.Try, Nullx11Forge.Boss.Leave)
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
			T("Index Types", "ประเภทที่จะเก็บ"),
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
			:AddButton(RefreshButton("MissingItem", Nullx11Forge.Index.Choices))
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
			Text = T("Forge Now", "หลอมเดี๋ยวนี้"),
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

		local oreUseBox =
			tab:AddRightGroupbox(T("Ore Usage", "การใช้แร่"))
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
			T("Sell Item Types", "ประเภทที่จะขาย"),
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
						return Nullx11Forge.Util.Try(Nullx11Forge.Tower.Exit)
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
			T("Auto Season", "ซีซั่นอัตโนมัติ"),
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
					local acquired, outcome, reason = Nullx11Forge.Spawn.Give(
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
			:AddButton(RefreshButton("SpawnItem", Nullx11Forge.Spawn.Choices))

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
				local ok, labels = pcall(Nullx11Forge.Spawn.GearChoices, slot)
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
					return ("Forged and equipped %d/3 pieces"):format(made or 0)
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
			Text = T("Buy Exclusive Gear", "ซื้อของ Exclusive"),
			Func = LongAction(
				"Tower",
				Nullx11Forge.Season.BuyExclusive,
				function(bought)
					return (bought or 0) > 0
							and ("Bought %d exclusive pieces"):format(bought)
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
			T("Skip Egg Cutscene", "ข้ามฉากเปิดไข่"),
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
					Nullx11Forge.Util.Remote("Pet", "ClaimAllDeployRewardRE"),
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
							gained > 0 and ("Acquired %d!"):format(gained)
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
		local starByLabel = { ["Any"] = 0, ["2 Stars+"] = 2, ["3 Stars"] = 3 }
		raceBox:AddDropdown("RaceStar", {
			Text = T("Target Stars", "ดาวที่ต้องการ"),
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
						Nullx11Forge.Util.Try(Nullx11Forge.Race.MuteAnim, true)
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
						Notify("Can't roll: " .. tostring(detail), "Warning")
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
			Text = T("Switch Now", "สลับเดี๋ยวนี้"),
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

		local guardBox =
			tab:AddRightGroupbox(T("Survival", "เอาตัวรอด"))
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
			T("Workers Per Task", "จำนวน worker ต่องาน"),
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

		local spotBox =
			settingsTab:AddRightGroupbox(T("Position", "ตำแหน่ง"))
		spotBox
			:AddButton({
				Text = T(
					"Save Position",
					"บันทึกตำแหน่ง"
				),
				Func = Action(function()
					Notify(
						Nullx11Forge.Session.SavePosition() and "Position saved"
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
		local sessionTab =
			Window:AddTab("Session", "settings", "Selected-game continuation")
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
		Window:AddTabSection(T("Progress", "ความคืบหน้า"))
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
		SubTitle = "Nullx11 - +1 loot to forge / Gab",
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
