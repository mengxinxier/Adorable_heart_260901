
-- 生涯档案
NDefines.NCareerProfile.MOD_STATISTICS_GROUP = "AdorableHeart_career_profile"
NDefines.NCareerProfile.MOD_STATISTICS_GROUP_NAME = "ADORABLEHEART_CAREER_PROFILE"

-- 游戏性预设
NDefines.NGame.SAVE_VERSION = 318											-- Vanilla is 30 存档标识
NDefines.NGame.END_DATE = "1999.1.1.1"										-- Vanilla is 1949.1.1.1
NDefines.NCountry.EVENT_PROCESS_OFFSET = 5									-- Vanilla is 20 再苦一苦CPU...

--三军经验最大值
NDefines.NMilitary.MAX_ARMY_EXPERIENCE = 1000
NDefines.NMilitary.MAX_NAVY_EXPERIENCE = 1000
NDefines.NMilitary.MAX_AIR_EXPERIENCE = 1000

--列车炮、船厂最大生产线
NDefines.NProduction.RAILWAY_GUN_MAX_MIL_FACTORIES_PER_LINE = 50
NDefines.NProduction.DEFAULT_MAX_NAV_FACTORIES_PER_LINE = 50
NDefines.NProduction.CONVOY_MAX_NAV_FACTORIES_PER_LINE = 50
NDefines.NProduction.CAPITAL_SHIP_MAX_NAV_FACTORIES_PER_LINE = 50

-- 更多特种部队
-- NDefines.NCountry.SPECIAL_FORCES_CAP_BASE = 0.1								-- Vanilla is 0.05
-- NDefines.NCountry.SPECIAL_FORCES_CAP_MIN = 32								-- Vanilla is 24

-- 更少装备消耗
-- NDefines.NMilitary.EQUIPMENT_COMBAT_LOSS_FACTOR = 0.45						-- Vanilla is 0.7

-- 战争支持度&稳定度
NDefines.NCountry.MAX_BOMBING_WAR_SUPPORT_IMPACT = -2.0						-- Vanilla is -0.3 骇人轰炸.jpg
NDefines.NCountry.MAX_HEROES_BEING_KILLED_WAR_SUPPORT_IMPACT = -2.0			-- Vanilla is -0.3 国家需要英雄！
NDefines.NCountry.MAX_CONVOYS_BEING_RAIDED_WAR_SUPPORT_IMPACT = -2.0		-- Vanilla is -0.5 没有运输车没饭吃了捏

-- 和平会议
NDefines.NDiplomacy.PEACE_SCORE_SCALE_FACTOR = 2.15							-- Vanilla is 1.35 更多分数，更多扯皮
NDefines.NDiplomacy.PEACE_SCORE_DISTRIBUTION = { 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2 }

-- 志愿军
NDefines.NAI.SEND_VOLUNTEER_EVAL_BASE_DISTANCE = 1000.0  					-- Vanilla is 175.0 
NDefines.NAI.SEND_VOLUNTEER_EVAL_CONTAINMENT_FACTOR = 0						-- Vanilla is 0.1
NDefines.NDiplomacy.TENSION_VOLUNTEER_FORCE_DIVISION = 0					-- Vanilla is 0.5 别紧张，派个志愿军
NDefines.NAI.SEND_VOLUNTEER_EVAL_MAJOER_POWER = 1.5   	                    -- Vanilla is 1.0 主要国家更愿意派遣志愿军
NDefines.NDiplomacy.VOLUNTEERS_DIVISIONS_REQUIRED = 20   	                -- Vanilla is 20
NDefines.NDiplomacy.VOLUNTEERS_PER_COUNTRY_ARMY = 0.02   	                -- Vanilla is 0.05

--  AI行为
NDefines.NAI.ASSIGN_TANKS_TO_NON_WAR_FRONT = -4								-- Vanilla is 0.4 坦克统统上前线
NDefines.NAI.ASSIGN_TANKS_TO_MOUNTAINS = -12								-- Vanilla is -6 坦克冲山是吧
NDefines.NAI.ASSIGN_TANKS_TO_JUNGLE = -12									-- Vanilla is -6 逢林莫入
NDefines.NAI.FRONT_EVAL_UNIT_ACCURACY = 1.5									-- Vanilla is 1.0 AI的微操速度
NDefines.NAI.HOUR_BAD_COMBAT_REEVALUATE = 24								-- Vanilla is 100 重新评估计划的时间
NDefines.NAI.PLAN_ATTACK_MIN_STRENGTH_FACTOR_LOW = 0.85						-- Vanilla is 0.4 执行攻击的最低兵力
NDefines.NAI.PLAN_ACTIVATION_SUPERIORITY_AGGRO = 1.2						-- Vanilla is 1.0 执行计划的力量比
NDefines.NAI.ATTACK_HEAVILY_DEFENDED_LIMIT = 1.1							-- Vanilla is 0.5 除非比较强AI不会攻击严密防守的敌人

NDefines.NAI.LAND_COMBAT_OUR_COMBATS_AIR_IMPORTANCE = 1000                  -- Vanilla is 155 空军的重要性
NDefines.NAI.MAX_FULLY_TRAINED_SHIP_RATIO_FOR_TRAINING = 0.99				-- Vanilla is 0.7 训练你的海军

-- 生产
NDefines.NAI.PRODUCTION_EQUIPMENT_SURPLUS_FACTOR = 1.0						-- Vanilla is 0.4  AI给军队更多枪
NDefines.NAI.REFIT_SHIP_PERCENTAGE_OF_FORCES = 0.25							-- Vanilla is 0.1 更加愿意改装船只
NDefines.NAI.DESIRE_USE_XP_TO_UPGRADE_AIR_EQUIPMENT = 1.5					-- Vanilla is 1 速度改装飞机
NDefines.NAI.UPGRADE_PERCENTAGE_OF_FORCES = 0.25							-- Vanilla is 0.1 升级军队的比例
NDefines.NAI.UPGRADE_DIVISION_RELUCTANCE = 5					            -- Vanilla is 7.0 升级军队的不情愿度
NDefines.NAI.RESEARCH_DAYS_BETWEEN_WEIGHT_UPDATE = 5                        -- Vanilla is 7.0 升级军队的频率
NDefines.NAI.UPGRADES_DEFICIT_LIMIT_DAYS = 50							    -- Vanilla is 50 没有枪不升级（缺乏x天装备产量以上时）
NDefines.NAI.XP_RATIO_REQUIRED_TO_RESEARCH_WITH_XP = 1.6					-- Vanilla is 2 加速改进装备
NDefines.NProduction.MAX_CIV_FACTORIES_PER_LINE = 50    					-- Vanilla is 15 民工产线数量

-- 科研
NDefines.NAI.MAX_AHEAD_RESEARCH_PENALTY = 1.5				                -- Vanilla is 2 减少超前研发
NDefines.NAI.RESEARCH_BONUS_FACTOR = 3.0									-- Vanilla is 0.9 优先研发有科技加成的科技

-- 补给
NDefines.NSupply.AI_FRONT_DIVISIONS_PER_SUPPLY_POINT = 0.7					-- Vanilla is 1.0 降低每个补给点部署的部队数量
NDefines.NAITheatre.AI_THEATRE_SUPPLY_CRISIS_LIMIT = 0.25					-- Vanilla is 0.1 部队逃荒了（）
NDefines.NAI.STR_BOMB_SUPPLY_HUB_IMPORTANCE = 100	                        -- Vanilla is 1.0 补给中心的重要性 敌方
NDefines.NAI.LAND_DEFENSE_SUPPLY_HUB_IMPORTANCE = 100	                    -- Vanilla is 4.0 补给中心的重要性 我方
NDefines.NAI.UPDATE_SUPPLY_BOTTLENECKS_FREQUENCY_HOURS = 24                 -- Vanilla is 168 多久检查一次补给不足

-- 市场
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_OPINION = 1.1                              -- Acceptance factor for opinion
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_SAME_IDEOLOGY = 15                         -- Acceptance value added if same ideology
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_SCRIPTED_IDEOLOGY_ACCEPTANCE = 1.0         -- Acceptance factor for scripted ideology acceptance modifier
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_TRADE_INFLUENCE = 0.70                     -- Acceptance factor for trade influence (adjusted from base value)
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_COMPETING_FACTIONS = 0                     -- Acceptance value added if both countries are in factions  and factions are different
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_EMBARGO = -200                             -- Acceptance value added if either side has embargoed the other
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_NO_TRADE_ROUTE = -100                      -- Acceptance value added if there is no valid trade route between the countries
NDefines.NDiplomacy.MARKET_ACCESS_ACCEPTANCE_NON_AGGRESSION_PACT = 25                   -- Acceptance value added if there is a non-aggression pact between the countries

-- 消费品
NDefines.NProduction.MINIMUM_NUMBER_OF_FACTORIES_TAKEN_BY_CONSUMER_GOODS_PERCENT = 0.05	-- The minimum number of factories we have to put on consumer goods, in percent.

-- 丝滑的摄像机
NDefines_Graphics.NFrontend.CAMERA_MIN_HEIGHT = 30.0
NDefines_Graphics.NGraphics.CAMERA_ZOOM_SPEED = 50
NDefines_Graphics.NGraphics.CAMERA_ZOOM_KEY_SCALE = 0.02
NDefines_Graphics.NGraphics.CAMERA_ZOOM_SPEED_DISTANCE_MULT = 8.0

-- 奇迹工程
NDefines.NProject.BREAKTHROUGH_DAILY_TECHNOLOGY_GAIN = 24          -- Vanilla is 12 突破点每日获取
NDefines.NProject.BREAKTHROUGH_DAILY_SCIENTIST_SKILL_GAIN = 10     -- Vanilla is 5 科学家技能的突破点获取
NDefines.NProject.BREAKTHROUGH_DAILY_ROCKET_SITE_GAIN = 2          -- Vanilla is 1 火箭基地的突破点获取
NDefines.NProject.BREAKTHROUGH_DAILY_NUCLEAR_REACTOR_GAIN = 2      -- Vanilla is 1 核反应堆的突破点获取