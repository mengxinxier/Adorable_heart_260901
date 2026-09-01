# LFC 国策图标速查表
> 生成日期：2026-06-26 | 最后更新：2026-06-27（全量分类重建）
> 图标总数：42 个 LFC 国策（全部 mod 注册，无重复，无 vanilla 回退）
> 候选池：981 个图标，按 92 个语义类别整理，均附中文用途标注（自动生成+人工校验）
> 数据源：205 个 .gfx → 47,316 spriteType → **10,432 goals 注册**（标准 5,000 + 非标准 5,432）→ 5,237 去重 → 3,543 已分类 → 1,190 已标注中文

---

## 方案说明（给 AI 读）

### 这是什么
本文件是 **Adorable Heart 模组 LFC 国家国策图标** 的完整参考。包含：
1. **42 个已分配图标的对照表**（国策ID → 图标名 → 语义）
2. **图标名速译**（英文关键词 → 中文含义，用于快速判断陌生图标的用途）
3. **语义分类候选池**（按主题整理的备用图标，附中文标注，供新国策选图用）

### HOI4 图标系统简介
```
.dds 或 .png 图片文件（在 gfx/interface/goals/ 下）
    → 通过 .gfx 文件注册
spriteType 名称（如 GFX_goal_generic_army_mobilization）
    → 在国策文件中引用
focus = { icon = GFX_goal_generic_army_mobilization }
```

- **注册** = .gfx 文件里的 `spriteType = { name = "GFX_xxx" texturefile = "gfx/interface/goals/.../xxx.png" }`
- **mod 注册** = 本 mod 的 205 个 .gfx 文件中出现的注册名（**高优先级**，共 10,432 个 goals 图标，标准命名 5,000 + 非标准命名 5,432）
- **原版注册** = 只在原版 .gfx 中的注册名（**低优先级**，本表不收录）
- **命名惯例**：标准图标以 `GFX_goal_`/`GFX_focus_` 开头，但也有大量图标直接以 `GFX_[TAG]_` 命名（如 `GFX_DVL_Hayek_scheme`、`GFX_PAN_xxx`）。速查表覆盖所有命名模式
- **注意**：.gfx 中 `spriteType` 和 `SpriteType`（大小写）都存在，解析时需大小写不敏感
- 未注册的图片文件即使存在也无法在游戏中使用

### 图标名解读规则
看到 `GFX_goal_generic_army_mobilization` 这样的名字时：
| 部分 | 含义 |
|------|------|
| `GFX_` | 固定前缀 |
| `goal_` / `focus_` / `decision_` / `idea_` | 用途类型（国策 / 决议 / 理念）|
| `generic_` | 通用图标（加分项，视觉简洁）|
| `r56_` | 来自 Road to 56 模组 |
| `[TAG]_` | 国家特定（如 `CHI_`=中国、`GER_`=德国、`TRB_`=特利巴）|
| `break_army` | 实际含义关键词 |
| `_shine` | 发光特效变体（**避免使用**，视觉过曝）|

### 为新国策选图标的流程

1. **确定语义类别**：根据国策标题判断属于哪个类别（陆军/海军/经济/政治…）
2. **查速译表**：如果不确定某图标含义，在「图标名速译」中查关键词
3. **浏览候选池**：在对应类别中找标注中文含义的图标，选最匹配的
4. **检查优先级**：
   - 优先选 `generic_` 前缀的（通用、视觉清晰）
   - 优先选来源含 `generic_goals.gfx` 或 `adorable_heart_goals.gfx` 的
   - 避免 `_shine` 后缀（发光特效）
   - 避免带 `[TAG]_` 国家前缀的（除非国策与该国直接相关）
5. **确认未重复**：在对照表检查 42 个已分配图标，确保不重复使用
6. **修改国策文件**：在 `common/national_focus/LFC.txt` 中修改 `icon = GFX_xxx`

### 配套数据文件

| 文件 | 用途 |
|------|------|
| `LFC_icon_assignments.csv` | 42 个国策分配表，机器可读 |
| `_icon_chinese_labels.json` | 1,190 个图标的中文含义 JSON（程序化查询用）|
| `_candidate_pool.tsv` | 92 类别 × 981 候选项分类表（制表符分隔，机器可读）|
| `_summary_stats.json` | 最新统计数据（总量/分类/标注覆盖等）|
| `_unmatched_names.json` | 未归类的 1,694 个图标名（改进分类用）|

### 图标命名规则速查

| 关键词 | 含义 | 关键词 | 含义 | 关键词 | 含义 |
|--------|------|--------|------|--------|------|
| `break_army` | 击溃陆军 | `battleship` | 战列舰 | `air_wing` | 空军联队 |
| `army_purges` | 陆军清洗 | `carrier` | 航母 | `bomber` | 轰炸机 |
| `army_elite` | 精锐部队 | `submarine` | 潜艇 | `fighter` | 战斗机 |
| `national_defense` | 国防 | `naval_invasion` | 登陆作战 | `paratrooper` | 伞兵 |
| `recruitment` | 动员征兵 | `sea_navy` | 海军航海 | `industrial` | 工业 |
| `morale_bonus` | 士气加成 | `convoy` | 运输船队 | `construction` | 建筑工程 |
| `multinational_army` | 多国联军 | `oil` | 石油 | `mining` | 采矿 |
| `warfighting_tech` | 军事科技 | `rubber` | 橡胶 | `nuclear_energy` | 核能 |
| `fortify` | 防御工事 | `coal` | 煤炭 | `radio` | 无线电 |
| `tank` | 装甲坦克 | `steel/iron` | 钢铁 | `research` | 科研 |
| `artillery` | 炮兵 | `gold` | 黄金 | `agriculture` | 农业 |
| `infantry` | 步兵 | `diamond` | 钻石 | `trade` | 贸易 |
| `diplomacy` | 外交 | `law` | 法律 | `parliament` | 议会 |
| `intelligence` | 情报间谍 | `corruption` | 反腐调查 | `liberty` | 自由 |
| `propaganda` | 宣传审查 | `independence` | 独立解放 | `backstab` | 背叛 |
| `communist` | 共产主义 | `fascist` | 法西斯 | `democratic` | 民主主义 |
| `housing` | 住房城市 | `road/highway` | 道路 | `railroad` | 铁路 |
| `water/dam` | 水利 | `train_` | 铁路/训练 | `automobile` | 汽车 |
| `all_resource` | 全部资源 | `continuous_extraction` | 持续开采 | `economics_reform` | 经济改革 |

---

## 完整对照表
| # | 国策ID | 国策标题 | 图标 | 语义 | 来源 |
|---|--------|---------|------|------|------|
| 1 | `LFC_1_xycyz` | 筹备下一次远征 | `GFX_goal_national_mobilization` | 陆军-全国动员 | mod:generic_goals.gfx |
| 2 | `LFC_1_1_slex` | 顺流而下 | `GFX_goal_coastal_navy` | 海军-近海 | mod:generic_goals.gfx |
| 3 | `LFC_2_kzkwzh` | 控制魁伟扎河 | `GFX_goal_generic_national_defense_fund` | 陆军-防御 | mod:generic_goals.gfx |
| 4 | `LFC_3_sqytz` | 肃清伊塔扎 | `GFX_goal_generic_army_purges` | 陆军-肃清 | mod:generic_goals.gfx |
| 5 | `LFC_4_yjzdzx` | 遗迹中的真相 | `GFX_goal_generic_secret_documents` | 政治-机密 | mod:TAG_Middle_East_goals |
| 6 | `LFC_5_gsdyc` | 古圣的遗产 | `GFX_goal_generic_gold` | 资源-黄金 | mod:generic_goals.gfx |
| 7 | `LFC_6_fwsb` | 访问神滨 | `GFX_goal_generic_foreign_diplomacy` | 政治-外交 | mod:generic_goals.gfx |
| 8 | `LFC_7_myxd` | 关税协定 | `GFX_goal_generic_deals` | 经济-贸易协定 | mod:generic_goals.gfx |
| 9 | `LFC_8_tzml` | 潘帕斯农牧业投资案 | `GFX_goal_generic_agriculture` | 经济-农业 | mod:generic_goals.gfx |
| 10 | `LFC_9_kthz` | 雨林勘探合作 | `GFX_goal_generic_jungle_diamond` | 资源-丛林勘探 | mod:generic_goals.gfx |
| 11 | `LFC_10_jsjl` | 联合研发魔导技术 | `GFX_goal_generic_double_research` | 科技-联合研究 | mod:generic_goals.gfx |
| 12 | `LFC_11_mlzy` | 引入魔法少女军事支援 | `GFX_goal_generic_multinational_army` | 陆军-多国部队 | mod:generic_goals.gfx |
| 13 | `LFC_12_zzpd` | 反种族歧视法 | `GFX_goal_generic_freedom` | 政治-自由 | mod:generic_goals.gfx |
| 14 | `LFC_13_gyxd` | 雇佣妖精向导 | `GFX_goal_generic_espionage` | 政治-情报 | mod:ICON_TRB.gfx |
| 15 | `LFC_13_2_kfbj` | 边境开放与贸易自由 | `GFX_goal_free_trade` | 经济-自由贸易 | mod:TAG_Middle_East_goals |
| 16 | `LFC_14_ymxtl` | 第一条亚马逊铁路 | `GFX_goal_generic_railroad` | 工业-铁路 | mod:generic_goals.gfx |
| 17 | `LFC_15_tzbj` | 开发无垠之海 | `GFX_goal_generic_expand_the_naval_industry` | 海军-工业扩张 | mod:generic_goals.gfx |
| 18 | `LFC_16_yjzc` | 组建妖精侦查部队 | `GFX_goal_generic_army_elite` | 陆军-精英侦查 | mod:generic_goals.gfx |
| 19 | `LFC_40_jjtzh` | 紧急听证会 | `GFX_goal_generic_parliament` | 政治-议会 | mod:TAG_Middle_East_goals |
| 20 | `LFC_41_jksb` | 进口廉价设备 | `GFX_goal_generic_construction_tools` | 工业-设备进口 | mod:generic_goals.gfx |
| 21 | `LFC_42_cjml` | 超级马林航空授权 | `GFX_goal_generic_air_wing` | 空军-航空联队 | mod:generic_goals.gfx |
| 22 | `LFC_43_gcw` | 干船坞扩建 | `GFX_The_Shipyard_In_Bay` | 海军-船坞 | mod:TAG_Middle_East_goals |
| 23 | `LFC_44_btjs` | 引进本土技术 | `GFX_goal_generic_warfighting_technology` | 科技-技术引进 | mod:generic_goals.gfx |
| 24 | `LFC_45_fdjcy` | 补贴发动机产业 | `GFX_goal_generic_automobile` | 工业-汽车 | mod:generic_goals.gfx |
| 25 | `LFC_46_mkn` | 马可尼无线电合同 | `GFX_goal_generic_radio_development` | 科技-无线电 | mod:generic_goals.gfx |
| 26 | `LFC_47_gyth` | 工业统合计划 | `GFX_goal_generic_industrial_planning` | 工业-工业计划 | mod:ICON_CHI.gfx |
| 27 | `LFC_48_zykf` | 重视资源开发 | `GFX_goal_generic_all_resource` | 资源-全资源 | mod:generic_goals.gfx |
| 28 | `LFC_49_mgfht` | 投资煤钢复合体 | `GFX_goal_generic_mining_iron` | 资源-煤钢 | mod:generic_goals.gfx |
| 29 | `LFC_50_zfxj` | 引种中非橡胶 | `GFX_focus_generic_rubber` | 资源-橡胶 | mod:generic_goals.gfx |
| 30 | `LFC_51_ckmy` | 重振出口贸易 | `GFX_focus_USS_reopen_trade` | 经济-贸易重开 | mod:TAG_USS_goals.gfx |
| 31 | `LFC_52_nyaq` | 确保能源安全 | `GFX_goal_generic_power_plant2` | 工业-能源 | mod:generic_goals.gfx |
| 32 | `LFC_53_sykf` | 石油开发谈判 | `GFX_goal_generic_oil_SPR` | 资源-石油 | mod:adorable_heart_goals |
| 33 | `LFC_54_jkmt` | 进口煤炭 | `GFX_goal_generic_coal_mining` | 资源-煤炭 | mod:generic_goals.gfx |
| 34 | `LFC_56_kzys` | 扩张源石产业 | `GFX_focus_continuous_extraction` | 资源-持续开采 | mod:generic_goals.gfx |
| 35 | `LFC_57_gggc` | 公共工程建设署 | `GFX_focus_generic_public_works_A` | 工业-公共工程 | mod:generic_goals.gfx |
| 36 | `LFC_58_gsgl` | 扩张高速公路网络 | `GFX_goal_generic_road2` | 工业-公路 | mod:generic_goals.gfx |
| 37 | `LFC_59_xxsl` | 兴修水利 | `GFX_goal_water` | 工业-水利 | mod:adorable_heart_goals |
| 38 | `LFC_60_csh` | 露斯契亚城市化 | `GFX_goal_generic_housing` | 工业-住房 | mod:generic_goals.gfx |
| 39 | `LFC_61_bjkz` | 边疆垦殖法 | `GFX_goal_generic_promote_ruralism` | 经济-垦殖 | mod:generic_goals.gfx |
| 40 | `LFC_62_glym` | 鼓励技工移民 | `GFX_goal_generic_decrease_unemployment` | 经济-就业 | mod:generic_goals.gfx |
| 41 | `LFC_63_ldf` | 标准工时法 | `GFX_goal_generic_labor_regulation` | 政治-劳工法规 | mod:generic_goals.gfx |
| 42 | `LFC_64_jmss` | 减免企业税收 | `GFX_goal_generic_economics_reform_gold` | 经济-减税 | mod:generic_goals.gfx |

---

## 图标名速译（Pattern → 中文含义）
当看到不认识的图标名时，按下表快速判断用途：

| 英文关键词 | 中文含义 |
|-----------|---------|
| `break_army` / `smash_army` | 击溃陆军 |
| `army_purges` / `purge_army` | 陆军清洗 |
| `army_elite` / `elite_forces` | 精锐部队 |
| `multinational_army` / `joint_army` | 多国联军 |
| `national_defense_fund` / `defense_fund` | 国防基金 |
| `morale_bonus` | 士气加成 |
| `recruitment` / `mobilization` | 动员征兵 |
| `train_` / `military_training` | 军事训练 |
| `warfighting_technology` | 军事科技 |
| `infantry` / `soldier` / `rifle` | 步兵 |
| `tank` / `armor` / `panzer` / `mechanized` | 装甲/坦克 |
| `artillery` / `cannon` | 炮兵 |
| `fortify` / `fortress` / `bunker` / `trench` | 防御工事 |
| `sea_navy` / `coastal_navy` / `navigate_the_seas` | 海军/航海 |
| `battleship` / `capital_ship` | 战列舰 |
| `carrier` / `naval_air` | 航母 |
| `submarine` / `u_boat` | 潜艇 |
| `naval_invasion` / `amphibious` / `landing` | 登陆作战 |
| `air_wing` / `air_command` / `air_force` | 空军 |
| `fighter` / `interceptor` | 战斗机 |
| `bomber` / `strategic_bomb` | 轰炸机 |
| `construction` / `public_works` | 建筑工程 |
| `road` / `highway` | 道路 |
| `railroad` / `railway` / `train_` | 铁路 |
| `housing` / `urban` | 住房/城市化 |
| `water` / `dam` / `irrigation` | 水利 |
| `industrial` / `industrialisation` | 工业 |
| `machinery` / `engineering` | 机械/工程 |
| `automobile` | 汽车工业 |
| `mining` / `coal` / `iron` / `extraction` | 采矿 |
| `oil` / `petroleum` / `refinery` | 石油 |
| `rubber` / `latex` | 橡胶 |
| `nuclear_energy` / `nuclear_power` | 核能 |
| `radio` / `radar` / `electronic` | 无线电/电子 |
| `research` / `science` / `laboratory` | 科研 |
| `economics_reform` / `tax` / `fiscal` | 经济改革 |
| `agriculture` / `farming` / `crop` | 农业 |
| `trade` / `commerce` / `export` / `import` | 贸易 |
| `financial` / `growing_economy` / `market` | 经济/市场 |
| `diplomacy` / `foreign` / `embassy` | 外交 |
| `parliament` / `dissolve` / `congress` | 议会 |
| `law` / `repeal` / `martial_law` | 法律/废法 |
| `corruption` / `investigate` | 反腐/调查 |
| `intelligence` / `spy` / `espionage` | 情报/间谍 |
| `secret_documents` / `classified` | 机密文件 |
| `communist` / `fascist` / `democratic` | 意识形态 |
| `liberty` / `freedom` / `emancipation` | 自由/解放 |
| `independence` / `liberation` / `sovereignty` | 独立/解放 |
| `backstab` / `betrayal` | 背叛 |
| `propaganda` / `press` / `censorship` | 宣传/审查 |
| `unity` / `solidarity` | 团结/统一 |
| `all_resource` / `continuous_extraction` | 资源开发 |
| `gold` / `diamond` / `jungle_gold` | 黄金/钻石 |

> **优先级**: mod注册图标（高）> 原版图标（低）
> **避用**: `_shine` 后缀（发光特效变体）
> **加分**: `generic_` 前缀的图标通常视觉简洁、通用性强

---### 空军-防空

- `GFX_Anti_Air_Scythe`{防空}
---### 空军-轰炸机

- `GFX_goal_generic_air_bomber_new`{空军/航空}
- `GFX_goal_generic_air_naval_bomber_new`{海军/舰船/基地}
- `GFX_goal_generic_air_naval_bomber2_new`{海军/舰船/基地}
- `GFX_goal_generic_air_strategic_bomber_new`{空军/航空}
- `GFX_goal_generic_air_tactical_bomber_new`{空军/航空}
- `GFX_goal_multiple_bombers`{空军/航空}
---### 空军-战斗机

- `GFX_goal_generic_air_fighter_new`{空军/航空}
- `GFX_goal_generic_air_fighter2_new`{空军/航空}
- `GFX_goal_generic_air_heavy_fighter_new`{空军/航空}
- `GFX_goal_generic_air_heavy_fighter2_new`{空军/航空}
- `GFX_goal_america_goal_freedom_fighters`{空军/航空}
- `GFX_goal_fighters_germany`{空军/航空}
- `GFX_goal_fighters_italy`{空军/航空}
- `GFX_goal_fighters_japan`{空军/航空}
- `GFX_goal_fighters_soviet`{空军/航空}
- `GFX_goal_fighters_uk`{空军/航空}
- `GFX_goal_fighters_usa`{空军/航空}
- `GFX_GRU_fighter_focus`{空军/航空}
---### 空军-伞兵/空降

- `GFX_FRA_New_Airborne_Forces`{空降/伞兵}
---### 空军-火箭/导弹

- `GFX_goal_generic_rocket_artillery`{炮兵}
- `GFX_goal_soviet_rocketry`{科研/太空}
- `GFX_SWE_Plan_Sunset_rockets`{科研/太空}
---### air-wing

- `GFX_goal_generic_air_command`{空军/航空}
- `GFX_goal_generic_air_wing`{空军/航空}
- `GFX_generic_air_command`{空军/航空}
- `GFX_goal_CHI_Chinese_National_Air_Force`{空军/航空}
- `GFX_goal_CHL_coa_air_force`{空军/航空}
- `GFX_goal_r56_goal_PRC_coa_air_force`{空军/航空}
- `GFX_goal_SWI_air_force`{空军/航空}
- `GFX_MON_air_force`{空军/航空}

---### army-allied

- `GFX_goal_generic_multinational_army`{多国联军}
- `GFX_goal_NFA_foreign_legion`{外交/条约}
---### 陆军-炮兵

- `GFX_goal_generic_army_artillery`{炮兵}
- `GFX_goal_generic_artillery_factories`{炮兵}
- `GFX_goal_generic_artillery_improved`{炮兵}
- `GFX_goal_generic_combined_arms_artillery_antiair_antitank`{装甲/坦克}
- `GFX_goal_generic_mobile_artillery_light`{炮兵}
- `GFX_goal_generic_mobile_artillery_medium`{炮兵}
- `GFX_goal_generic_railway_artillery`{炮兵}
- `GFX_goal_generic_rocket_artillery`{炮兵}
- `GFX_r56_goal_generic_artillery`{炮兵}
- `GFX_focus_TRB_coin_and_cannon`{炮兵}
- `GFX_focus_USS_artillery_harbinger`{炮兵}
- `GFX_focus_USS_artillery_warlock`{炮兵}
- `GFX_GER_Revolutionize_artillery_tactics`{炮兵}
- `GFX_PRC_New_artillery`{炮兵}
- `GFX_PRC_No_conscience_cannon`{炮兵}
- `GFX_USS_artillery_harbinger`{炮兵}
---### 陆军-军事指挥

- `GFX_goal_generic_army_high_command`{?}
- `GFX_goal_RUS_National_High_Command_Formation_School`{教育}
---### 陆军-国防/防御

- `GFX_goal_generic_national_defense_fund`{国防基金}
- `GFX_goal_focus_national_defense`{?}
---### 陆军-精锐部队

- `GFX_goal_generic_army_elite`{精锐部队}
- `GFX_goal_generic_red_commando`{?}
- `GFX_CAN_special_forces`{精锐部队}
- `GFX_focus_USS_expand_special_forces`{精锐部队}
---### army-fort

- `GFX_goal_generic_bastion_of_democracy`{意识形态}
- `GFX_goal_generic_fortification`{防御工事/要塞}
- `GFX_goal_generic_fortify_aa`{防御工事/要塞}
- `GFX_goal_generic_nested_fortifications`{防御工事/要塞}
- `GFX_r56_goal_generic_defensive_position2`{?}
- `GFX_focus_RUS_generic_bastion_of_democracy`{意识形态}
- `GFX_goal_america_fortress`{防御工事/要塞}
- `GFX_goal_defensive_position2`{?}
- `GFX_goal_fortify_city_AA`{防御工事/要塞}
- `GFX_goal_nested_fortifications`{防御工事/要塞}
- `GFX_goal_skull_fortification`{防御工事/要塞}
- `GFX_focus_MGU_COUP_arrogant_fortress`{防御工事/要塞}
- `GFX_focus_TGI_fortress_on_border`{防御工事/要塞}
- `GFX_focus_USS_southern_fortress`{防御工事/要塞}
- `GFX_Mobile_Fortress`{防御工事/要塞}
---### 陆军-游击/民兵

- `GFX_goal_generic_left_militia`{?}
- `GFX_goal_generic_partisans`{占领/镇压}
- `GFX_goal_TRB_militia`{?}
- `GFX_focus_NGL_the_problem_of_guerrillas`{?}
- `GFX_focus_TGI_expand_guerrillas`{?}
- `GFX_focus_TGI_guerrilla_country`{?}
- `GFX_focus_TGI_guerrilla_problem`{?}
- `GFX_focus_TGI_unswerving_guerrillas`{?}
- `GFX_focus_USS_continue_suppress_guerrillas`{宣传/舆论}
- `GFX_FRA_GFN_Hare_Guerrilla_Warfare`{战争/冲突}
- `GFX_FRA_Integrate_local_militias`{?}
- `GFX_PRC_Guerrilla_tactics`{?}
---### 陆军-步兵

- `GFX_goal_generic_break_rifle`{?}
- `GFX_goal_generic_spanish_civil_war_soldier`{独立/革命}
- `GFX_r56_goal_generic_infantry_flames`{步兵}
- `GFX_goal_agrarian_soldiers`{农业/乡村}
- `GFX_goal_focus_chinese_red_soldier`{?}
- `GFX_goal_focus_whampoa_rifle`{?}
- `GFX_goal_infantry_flames`{步兵}
- `GFX_goal_infantry_offensive`{步兵}
- `GFX_goal_KSV_for_the_soldier`{?}
- `GFX_goal_machine_gun`{?}
- `GFX_goal_small_infantry`{步兵}
- `GFX_goal_SOV_naval_infantry`{步兵}
- `GFX_goal_zhang_rifle`{?}
- `GFX_focus_TGI_our_soldiers`{?}
- `GFX_focus_TGI_soldiers`{?}
- `GFX_focus_TGI_soldiers_apart_of_fight`{战争/冲突}
- `GFX_Machete_And_Rifle`{?}
---### army-marine

- `GFX_goal_generic_marines2`{?}
- `GFX_goal_generic_submarine`{海军/舰船/基地}
- `GFX_goal_focus_chinese_submarines`{海军/舰船/基地}
- `GFX_goal_recreate_the_kuk_kriegsmarine`{?}
- `GFX_goal_SOV_naval_infantry`{步兵}
- `GFX_GRU_submarine_focus`{海军/舰船/基地}
---### 陆军-士气加成

- `GFX_goal_generic_morale_bonus`{士气加成}
- `GFX_goal_morale_bonus`{士气加成}
---### 陆军-山地部队

- `GFX_goal_generic_mountain_warfare`{战争/冲突}
- `GFX_goal_generic_mountain_warfare2`{战争/冲突}
---### army-offense

- `GFX_goal_generic_break_army`{击溃陆军}
---### 陆军-肃清/清洗

- `GFX_goal_generic_army_purges`{陆军清洗}
---### army-recruit

- `GFX_goal_generic_army_mobilization`{?}
- `GFX_goal_generic_army_mobilization2`{?}
- `GFX_goal_generic_recruitment`{动员征兵}
- `GFX_goal_CAL_aggressive_conscription`{动员征兵}
- `GFX_goal_class_a_reservists`{?}
- `GFX_goal_extensive_conscription_communism`{动员征兵}
- `GFX_goal_extensive_conscription_fascism`{动员征兵}
- `GFX_goal_national_mobilization`{?}
- `GFX_focus_TGI_old_fashion_conscription_law`{动员征兵}
- `GFX_GRU_mass_conscription`{动员征兵}
---### army-tank

- `GFX_goal_generic_armored_car_offensive`{?}
- `GFX_goal_generic_army_tanks3`{装甲/坦克}
- `GFX_goal_generic_combined_arms_artillery_antiair_antitank`{装甲/坦克}
- `GFX_goal_generic_license_tanks`{装甲/坦克}
- `GFX_goal_generic_tank_destroyer_2`{装甲/坦克}
- `GFX_goal_generic_tank_map`{装甲/坦克}
- `GFX_r56_goal_generic_mechanized_offensive`{装甲/坦克}
- `GFX_r56_goal_generic_tank_map`{装甲/坦克}
- `GFX_generic_mechanized_wave`{装甲/坦克}
- `GFX_generic_tank_cogs`{装甲/坦克}
- `GFX_goal_American_Armor`{装甲/坦克}
- `GFX_goal_anti_tank`{装甲/坦克}
- `GFX_goal_aoqiao_panzer`{装甲/坦克}
- `GFX_goal_CAL_Power_Armor`{装甲/坦克}
- `GFX_goal_JAP_tank`{装甲/坦克}
- `GFX_goal_japanese_tank_import`{装甲/坦克}
- `GFX_goal_mechanized_offensive`{装甲/坦克}
- `GFX_goal_new_generation_of_tanks`{装甲/坦克}
- `GFX_goal_POL_tank_hunt`{装甲/坦克}
- `GFX_goal_POL_tank_map`{装甲/坦克}
- `GFX_goal_tank_hunt`{装甲/坦克}
- `GFX_goal_tank_map`{装甲/坦克}
- `GFX_goal_tank_offensive`{装甲/坦克}
- `GFX_aoqiao_panzer`{装甲/坦克}
- `GFX_AUS_Research_on_new_types_of_armor`{装甲/坦克}
- `GFX_Big_Foot_Tank`{装甲/坦克}
- `GFX_focus_LAN_tank_2`{装甲/坦克}
- `GFX_focus_USS_heavy_armor_windigo`{?}
- `GFX_ger_heavy_tanks`{装甲/坦克}
- `GFX_GER_panzergrenadier`{装甲/坦克}
---### 陆军-军事科技

- `GFX_goal_generic_military_research`{科研/太空}
- `GFX_goal_generic_military_research_2`{科研/太空}
- `GFX_goal_generic_warfighting_technology`{军事科技}
- `GFX_focus_secret_rearmament`{?}
- `GFX_FRA_Kappa_Heavy_Industries_Institute_of_Armaments`{?}
---### 陆军-军事训练

- `GFX_focus_NGL_military_academy`{教育}
- `GFX_focus_USS_huge_military_exercise`{?}
- `GFX_PRC_Military_academy`{教育}

---### econ-agriculture

- `GFX_goal_focus_generic_agriculture`{农业/乡村}
- `GFX_goal_generic_agrarian_reform`{农业/乡村}
- `GFX_goal_generic_agriculture`{农业/乡村}
- `GFX_goal_generic_agriculture2`{农业/乡村}
- `GFX_goal_Generic_China_Uplift_Peasants`{农业/乡村}
- `GFX_goal_generic_Coffee_Plantations`{农业/乡村}
- `GFX_goal_generic_farm_tractor`{农业/乡村}
- `GFX_goal_generic_farming`{农业/乡村}
- `GFX_goal_generic_peasant_army`{农业/乡村}
- `GFX_goal_generic_peasant_commitees`{农业/乡村}
- `GFX_goal_generic_price_controls`{?}
- `GFX_goal_generic_wheat`{?}
- `GFX_r56_goal_generic_farm_tractor`{农业/乡村}
- `GFX_generic_price_controls`{?}
- `GFX_goal_agrarian_reform`{农业/乡村}
- `GFX_goal_agrarian_soldiers`{农业/乡村}
- `GFX_goal_ALB_Albanian_Farmers`{农业/乡村}
- `GFX_goal_AUS_agriculture`{农业/乡村}
- `GFX_goal_focus_feed_the_peasants`{农业/乡村}
- `GFX_goal_magic_agriculture`{农业/乡村}
- `GFX_goal_RUS_Prosperity_For_Peasants`{农业/乡村}
- `GFX_goal_SOV_agricultural_aid`{?}
- `GFX_agrarian_socialism`{农业/乡村}
- `GFX_agriculture`{农业/乡村}
- `GFX_CHI_focus_subsidise_subsistence_farmers`{农业/乡村}
- `GFX_Cotton_And_Dignity`{?}
- `GFX_focus_AUS_agriculture`{农业/乡村}
- `GFX_focus_NGL_imperial_agriculture`{农业/乡村}
- `GFX_focus_NGL_more_farmland`{农业/乡村}
- `GFX_focus_NGL_surplus_grain_collection`{农业/乡村}
---### econ-finance

- `GFX_goal_generic_commie_investments`{贸易/经济}
- `GFX_goal_generic_financial_markets`{贸易/经济}
- `GFX_goal_generic_foreign_investments`{贸易/经济}
- `GFX_generic_financial_markets`{贸易/经济}
- `GFX_goal_BRY_Support_Capitalists`{?}
- `GFX_goal_CSA_Liberate_Masses_From_Capitalist_Exploitation`{?}
- `GFX_goal_industrial_investment`{工业/工厂}
- `GFX_goal_LIB_the_plan_of_lunar_capital`{?}
- `GFX_goal_SOV_overthrow_capital`{?}
- `GFX_goal_stock_exchange`{?}
- `GFX_goal_TRB_communism_beat_capitalism`{意识形态}
- `GFX_goal_TRM_Scientific_Investment`{贸易/经济}
- `GFX_goal_WCC_punish_capital`{?}
- `GFX_CHI_focus_Expanding_foreign_investment`{贸易/经济}
- `GFX_CHI_focus_make_way_for_national_capital`{?}
- `GFX_focus_JAP_attracting_foreign_capital`{外交/条约}
- `GFX_focus_JAP_economic_zone`{贸易/经济}
- `GFX_focus_NGL_attracting_investment`{贸易/经济}
- `GFX_FRA_Human_Village_financial_capital`{贸易/经济}
- `GFX_FRA_social_responsibility_of_capitalists`{?}
- `GFX_FRA_Supervise_the_capitalists`{?}
- `GFX_kaz_investment_industry`{贸易/经济}
- `GFX_vnc_investment_military`{贸易/经济}
---### econ-growth

- `GFX_goal_generic_growing_economy`{贸易/经济}
- `GFX_goal_USA_america_economic_miracle`{贸易/经济}
---### econ-labor

- `GFX_goal_generic_labor_regulation`{财政/税收/劳工}
- `GFX_goal_collaborate_local_elites`{?}
- `GFX_goal_MAF_labor_charter`{?}
- `GFX_goal_NEE_New_Labor_Movement`{?}
- `GFX_goal_RUS_labour`{?}
- `GFX_CHI_focus_organise_trade_union`{贸易/经济}
- `GFX_collaborate_local_elites`{?}
- `GFX_focus_NGL_infected_labor_act`{?}
- `GFX_focus_TGI_reformation_for_labor_act`{内政/法律}
- `GFX_GER_Air_ground_collaboration`{?}
- `GFX_GER_Collaborative_training`{?}
- `GFX_GRU_worker_rights`{?}
- `GFX_requisition_labor`{?}
- `GFX_SWE_Restructuring_of_trade_unions`{贸易/经济}
---### econ-land

- `GFX_goal_generic_agrarian_reform`{农业/乡村}
- `GFX_generic_land_reform`{内政/法律}
- `GFX_goal_agrarian_reform`{农业/乡村}
- `GFX_BAY_land_reform`{内政/法律}
- `GFX_focus_POL_agrarian_reform`{农业/乡村}
- `GFX_MAN_Widely_cultivated_tea`{?}
---### econ-reform

- `GFX_goal_generic_balanced_budget`{财政/税收/劳工}
- `GFX_goal_generic_landowner_tax_cuts`{财政/税收/劳工}
- `GFX_DVL_Control_laws_of_economic_development`{贸易/经济}
- `GFX_focus_TGI_abolish_agricultural_tax`{财政/税收/劳工}
- `GFX_GEU_Rudolph_Economic_Plan`{贸易/经济}
- `GFX_GEU_STAXI`{财政/税收/劳工}
- `GFX_UAL_more_taxation`{财政/税收/劳工}
---### econ-trade

- `GFX_goal_generic_arms_export`{海军/舰船/基地}
- `GFX_goal_generic_positive_trade_relations_gold`{贸易/经济}
- `GFX_goal_generic_trade_interdiction`{贸易/经济}
- `GFX_generic_positive_trade_relations_gold`{贸易/经济}
- `GFX_goal_free_trade`{贸易/经济}
- `GFX_goal_japanese_tank_import`{装甲/坦克}
- `GFX_CHI_focus_organise_trade_union`{贸易/经济}
- `GFX_CHI_focus_Protecting_maritime_trade`{贸易/经济}
- `GFX_DVL_Anzi_Confederate_Trade_Fair`{贸易/经济}
- `GFX_focus_JAP_trade_gate`{贸易/经济}
- `GFX_focus_NGL_attach_importance_to_power_of_people`{贸易/经济}
- `GFX_focus_NGL_new_trade_network`{贸易/经济}
- `GFX_focus_TRB_focus_sea_trade`{贸易/经济}
- `GFX_focus_TRB_sea_trade`{贸易/经济}
- `GFX_focus_TRB_trade_center`{贸易/经济}
- `GFX_focus_USS_rebuild_trade_system`{建筑/工程}
- `GFX_focus_USS_reopen_trade`{贸易/经济}
- `GFX_kbz_angels_trade`{贸易/经济}
- `GFX_SWE_Restructuring_of_trade_unions`{贸易/经济}
- `GFX_vnc_chamber_of_commerce`{贸易/经济}
---### econ-welfare

- `GFX_goal_generic_aristocratic_cooperation`{?}
- `GFX_goal_generic_decrease_unemployment`{?}
- `GFX_goal_generic_seperation`{?}
- `GFX_focus_generic_decrease_unemployment`{?}
- `GFX_goal_BAN_army_cooperation`{?}
- `GFX_goal_DKB_Liberation_Army`{独立/革命}
- `GFX_goal_new_generation_of_tanks`{装甲/坦克}
- `GFX_goal_NFA_All_For_the_Liberation`{独立/革命}
- `GFX_goal_research_silver_cooperation`{科研/太空}
- `GFX_goal_RUS_A_New_Generation`{?}
- `GFX_CHI_focus_CHI_GER_cooperation`{?}
- `GFX_CHI_focus_Improving_social_security`{?}
- `GFX_czech_immigration`{?}
- `GFX_DVL_Bavarian_Pre_war_preparations`{?}
- `GFX_DVL_Rhineland_Pre_war_preparations`{?}
- `GFX_DVL_Schleswig_Holstein_Pre_war_preparations`{?}
- `GFX_focus_BAL_battle_maiden_operations_manual`{战争/冲突}
- `GFX_focus_manufacturers_cooperation`{工业/工厂}
- `GFX_focus_neptune_integration_of_four_churches`{文化/艺术/宗教}
- `GFX_focus_NPT_declaration_of_revenge`{?}
- `GFX_focus_TGI_cooperation_with_non_infected`{?}
- `GFX_focus_TGI_make_preparation`{?}
- `GFX_focus_TGI_proper_integration_is_good`{?}
- `GFX_focus_TUR_aegean_federation`{?}
- `GFX_form_south_german_federation`{?}
- `GFX_FRA_Special_operations_are_normalized`{?}
- `GFX_FRA_Start_integration_process`{?}
- `GFX_GER_Air_ground_collaboration`{?}
- `GFX_GER_Guard_against_ideological_infiltration`{情报/间谍}
- `GFX_LUG_Witch_Cult_Purge_Operation`{?}

---### 工业-汽车工业

- `GFX_goal_generic_automobile`{机械/汽车}
- `GFX_goal_TRB_motorization`{?}
- `GFX_FRA_military_horn_struck_gold_come`{机械/汽车}
- `GFX_Iron_Plate_On_Trucks`{机械/汽车}
---### industry-build

- `GFX_goal_focus_focus_generic_construction_military_small`{建筑/工程}
- `GFX_goal_focus_generic_construction_repair`{建筑/工程}
- `GFX_goal_generic_construction_engineering`{建筑/工程}
- `GFX_goal_generic_construction_tools`{建筑/工程}
- `GFX_goal_generic_construction3`{建筑/工程}
- `GFX_focus_generic_public_works_A`{建筑/工程}
- `GFX_generic_german_construction`{建筑/工程}
- `GFX_generic_railway_construction`{建筑/工程}
- `GFX_goal_focus_carrier_construction`{海军/舰船/基地}
- `GFX_focus_NGL_reconstruction_of_gaul`{建筑/工程}
- `GFX_focus_NGL_reconstruction_of_industrial_areas`{工业/工厂}
---### 工业-工业/工厂

- `GFX_goal_generic_industrial_democracy`{工业/工厂}
- `GFX_goal_generic_industrial_plan`{工业/工厂}
- `GFX_goal_generic_industrial_planning`{工业/工厂}
- `GFX_goal_generic_industrial_unionism`{工业/工厂}
- `GFX_goal_aggressive_industrialisation`{工业/工厂}
- `GFX_goal_BBR_industrializing_land`{工业/工厂}
- `GFX_goal_CSA_all_industrial_congress`{工业/工厂}
- `GFX_goal_industrial_investment`{工业/工厂}
- `GFX_goal_ITA_industrial`{工业/工厂}
- `GFX_goal_SOV_industrializing_land`{工业/工厂}
- `GFX_CHI_focus_industrialisation_of_China`{工业/工厂}
- `GFX_focus_NGL_industrial_recovery`{工业/工厂}
- `GFX_focus_NGL_reconstruction_of_industrial_areas`{工业/工厂}
- `GFX_focus_TGI_far_east_industrial_center`{工业/工厂}
- `GFX_focus_USS_rebuild_industrial_system`{工业/工厂}
- `GFX_TRY_industrial_focus_1_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_10_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_11_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_12_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_13_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_14_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_2_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_3_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_4_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_5_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_6_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_7_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_8_icon`{工业/工厂}
- `GFX_TRY_industrial_focus_9_icon`{工业/工厂}
- `GFX_vnc_industrial_restructuring`{工业/工厂}
---### 工业-住房/城市化

- `GFX_goal_generic_build_housing`{城市/水利}
- `GFX_goal_generic_construct_public_housing`{城市/水利}
- `GFX_goal_generic_housing`{城市/水利}
- `GFX_goal_generic_urban_warfare`{城市/水利}
- `GFX_generic_build_housing`{城市/水利}
- `GFX_goal_SOV_rural_urban_fringe`{农业/乡村}
---### industry-machine

- `GFX_goal_generic_construction_engineering`{建筑/工程}
- `GFX_goal_generic_engineering`{建筑/工程}
- `GFX_goal_generic_machinery`{机械/汽车}
- `GFX_goal_SOV_research_automatic_machinery`{机械/汽车}
- `GFX_FRA_Automechanical_research`{科研/太空}
- `GFX_goalSOV_research_automatic_machinery`{机械/汽车}
---### 工业-电力/电气化

- `GFX_goal_generic_power_plant`{工业/工厂}
- `GFX_goal_generic_power_plant2`{核能/能源}
- `GFX_generic_electricity`{?}
- `GFX_goal_power_plant`{工业/工厂}
---### 工业-铁路

- `GFX_goal_generic_railroad`{基建/运输}
- `GFX_goal_generic_railway_artillery`{炮兵}
- `GFX_goal_generic_seize_railway`{基建/运输}
- `GFX_generic_railway_construction`{建筑/工程}
- `GFX_generic_seize_railway`{基建/运输}
- `GFX_goal_MON_dev_sib_railway`{基建/运输}
- `GFX_goal_RJE_JAP_sea_railway`{基建/运输}
- `GFX_goal_RUS_Privatize_Railroad`{基建/运输}
- `GFX_focus_BUL_state_railways`{基建/运输}
- `GFX_focus_TGI_railway_across_USAS`{基建/运输}
- `MGU_yuki_railway`{基建/运输}
---### 工业-公路/道路

- `GFX_goal_generic_railroad`{基建/运输}
- `GFX_goal_generic_road`{基建/运输}
- `GFX_goal_generic_road2`{基建/运输}
- `GFX_goal_generic_road3`{基建/运输}
- `GFX_goal_Maritime_Silkroad_2`{基建/运输}
- `GFX_goal_NEE_interstate_highway`{基建/运输}
- `GFX_goal_POL_national_highway_system`{基建/运输}
- `GFX_goal_RUS_Privatize_Railroad`{基建/运输}
- `GFX_goal_TRB_road_in_the_left`{基建/运输}
- `GFX_goal_TRB_which_road_in_the_left`{基建/运输}
- `GFX_CHI_focus_reopen_silk_road`{基建/运输}
- `GFX_focus_NPT_neptune_crossroads`{基建/运输}
- `GFX_focus_USS_reservation_road`{基建/运输}
- `GFX_kbz_road_plan`{基建/运输}
- `GFX_UAL_revolutionary_broadcasting`{基建/运输}
- `MGU_yuki_highway`{基建/运输}
---### 工业-水利/水电

- `GFX_goal_water`{城市/水利}
- `GFX_Boiling_Amazon_Water`{城市/水利}
- `GFX_focus_NGL_that_damned_emperor`{城市/水利}
- `GFX_focus_NPT_watermelon`{?}
- `GFX_focus_TGI_a_real_damn_army`{城市/水利}
- `GFX_focus_TGI_move_to_the_damn_enemy`{城市/水利}
- `GFX_FRA_Water_fertile_fields_with_enemy_filthy_blood`{?}
- `GFX_kaz_defense_city_damashige`{城市/水利}
- `GFX_Muddy_Water_Flow`{?}

---### 海军-战舰/主力舰

- `GFX_goal_generic_battleship`{海军/舰船/基地}
- `GFX_goal_generic_navy_battleship3alt`{海军/舰船/基地}
- `GFX_generic_naval_battleship2`{海军/舰船/基地}
- `GFX_generic_navy_battleship3alt`{海军/舰船/基地}
- `GFX_focus_TRB_focus_battleship`{海军/舰船/基地}
---### 海军-航母

- `GFX_goal_generic_carrier_aircraft`{海军/舰船/基地}
- `GFX_generic_carrier_aircraft`{海军/舰船/基地}
- `GFX_generic_naval_carrier2`{海军/舰船/基地}
- `GFX_goal_carrier`{海军/舰船/基地}
- `GFX_goal_focus_carrier_construction`{海军/舰船/基地}
---### navy-invasion

- `GFX_goal_generic_landing_craft`{登陆作战}
- `GFX_Amphibious_Assault`{登陆作战}
---### 海军-自由轮/民船

- `GFX_goal_liberty_ships`{自由/解放}
- `GFX_USA_goal_liberty_ships`{自由/解放}
---### 海军-海军航空

- `GFX_goal_generic_air_naval_bomber_new`{海军/舰船/基地}
- `GFX_goal_generic_air_naval_bomber2_new`{海军/舰船/基地}
- `GFX_goal_generic_carrier_aircraft`{海军/舰船/基地}
- `GFX_generic_carrier_aircraft`{海军/舰船/基地}
---### 海军-海军/航海

- `GFX_goal_generic_blue_navy`{海军/舰船/基地}
- `GFX_goal_generic_naval_academy`{海军/舰船/基地}
- `GFX_goal_generic_navigate_the_seas`{海军/舰船/基地}
- `GFX_goal_coastal_navy`{海军/舰船/基地}
- `GFX_goal_sea_navy`{海军/舰船/基地}
---### 海军-港口/海防

- `GFX_goal_generic_naval_base`{海军/舰船/基地}
- `GFX_goal_LIC_austrian_customs`{贸易/经济}
---### navy-shipbuild

- `GFX_goal_generic_expand_the_naval_industry`{海军/舰船/基地}
- `GFX_focus_generic_shipbuilding`{建筑/工程}
- `GFX_generic_naval_industry`{海军/舰船/基地}
- `GFX_The_Shipyard_In_Bay`{海军/舰船/基地}
---### 海军-潜艇

- `GFX_goal_generic_submarine`{海军/舰船/基地}
- `GFX_goal_focus_chinese_submarines`{海军/舰船/基地}
- `GFX_GRU_submarine_focus`{海军/舰船/基地}
- `GFX_wolfpack_under_sea`{海军/舰船/基地}

---### politics-betray

- `GFX_goal_generic_backstab`{战争/冲突}
- `GFX_goal_backstab`{战争/冲突}
- `GFX_kaz_betrayal_of_cronies`{战争/冲突}
---### politics-colonial

- `GFX_goal_New_Mandate_of_heaven`{?}
- `GFX_FRA_neocolonialism`{?}
---### politics-communist

- `GFX_generic_goal_communist_reforms`{内政/法律}
- `GFX_goal_generic_anti_communism`{意识形态}
- `GFX_goal_generic_attack_communists`{意识形态}
- `GFX_goal_generic_befriend_albania_communist`{意识形态}
- `GFX_goal_generic_befriend_bulgaria_communist`{意识形态}
- `GFX_goal_generic_befriend_greece_communist`{意识形态}
- `GFX_goal_generic_befriend_indochina_communist`{意识形态}
- `GFX_goal_generic_befriend_romania_communist`{意识形态}
- `GFX_goal_generic_befriend_yugoslavia_communist`{意识形态}
- `GFX_goal_generic_communism`{意识形态}
- `GFX_goal_generic_communist_economy`{贸易/经济}
- `GFX_goal_generic_communist_government`{内政/法律}
- `GFX_goal_generic_communist_government2`{内政/法律}
- `GFX_goal_generic_communist_industries`{意识形态}
- `GFX_goal_generic_communist_loyalty`{意识形态}
- `GFX_goal_generic_communist_officer`{意识形态}
- `GFX_goal_generic_communist_pride`{意识形态}
- `GFX_goal_generic_communist_revolt`{意识形态}
- `GFX_goal_generic_communist_secret_police`{内政/法律}
- `GFX_goal_generic_council_communism`{意识形态}
- `GFX_goal_generic_dictatorship_of_proletariat`{?}
- `GFX_goal_generic_join_comintern`{外交/条约}
- `GFX_goal_generic_marxist_enlightenment`{意识形态}
- `GFX_goal_generic_revolutionary_guards`{独立/革命}
- `GFX_goal_generic_socialism_fist`{意识形态}
- `GFX_goal_generic_socialist_democracy`{意识形态}
- `GFX_goal_SOV_generic_socialist_action`{意识形态}
- `GFX_focus_generic_attack_communist_spain_focus`{意识形态}
- `GFX_focus_generic_befriend_communist_spain_focus`{意识形态}
- `GFX_focus_generic_russian_deal_communist`{意识形态}
---### 政治-反腐

- `GFX_goal_generic_investigate_corruption`{贸易/经济}
- `GFX_goal_DOM_End_Judicial_Corruption`{内政/法律}
- `GFX_goal_investigate_magic_card`{贸易/经济}
- `GFX_focus_SGL_special_investigation_team`{贸易/经济}
- `GFX_focus_USS_investigate_internal_security`{贸易/经济}
- `GFX_UAL_fight_corruption`{内政/法律}
---### politics-democratic

- `GFX_goal_generic_bastion_of_democracy`{意识形态}
- `GFX_goal_generic_constitutional_monarchy`{内政/法律}
- `GFX_goal_generic_democracy`{意识形态}
- `GFX_goal_generic_democracy_people`{意识形态}
- `GFX_goal_generic_democratic_army`{意识形态}
- `GFX_goal_generic_election`{?}
- `GFX_goal_generic_election_chaos`{?}
- `GFX_goal_generic_election_rigged`{?}
- `GFX_goal_generic_elections`{?}
- `GFX_goal_generic_industrial_democracy`{工业/工厂}
- `GFX_goal_generic_internal_democracy`{意识形态}
- `GFX_goal_generic_socialist_democracy`{意识形态}
- `GFX_focus_generic_attack_republican_spain_focus`{意识形态}
- `GFX_focus_generic_befriend_republican_spain_focus`{意识形态}
- `GFX_focus_RUS_generic_bastion_of_democracy`{意识形态}
- `GFX_goal_constitutional_monarchy`{内政/法律}
- `GFX_goal_democracy_people`{意识形态}
- `GFX_goal_DKB_restore_democracy`{意识形态}
- `GFX_goal_FNG_End_Republican_Warlords`{军事将领}
- `GFX_goal_focus_lighthouse_of_democracy`{意识形态}
- `GFX_goal_focus_proletariat_and_democracy`{意识形态}
- `GFX_goal_goal_USA_Ensure_Election_Fairness`{?}
- `GFX_goal_HKG_Silence_Liberals`{意识形态}
- `GFX_goal_ideology_social_liberal`{意识形态}
- `GFX_goal_ITA_democracy`{意识形态}
- `GFX_goal_ITA_republic`{意识形态}
- `GFX_goal_ITA_republicanism`{意识形态}
- `GFX_goal_LIB_election`{?}
- `GFX_goal_LIB_election2`{?}
- `GFX_goal_NEE_defend_freedom_from_democracy`{意识形态}
---### 政治-外交

- `GFX_goal_generic_deadly_treaty`{外交/条约}
- `GFX_goal_generic_foreign_diplomacy`{外交/条约}
- `GFX_goal_generic_foreign_diplomacy2`{外交/条约}
- `GFX_goal_generic_foreign_investments`{贸易/经济}
- `GFX_goal_generic_peaceful_diplomacy`{外交/条约}
- `GFX_goal_european_african_diplomacy`{外交/条约}
- `GFX_goal_naval_treaty`{海军/舰船/基地}
- `GFX_goal_NFA_foreign_legion`{外交/条约}
- `GFX_goal_venetia_treaty`{外交/条约}
- `GFX_CHI_focus_Expanding_foreign_investment`{贸易/经济}
- `GFX_CHI_focus_Forced_nationalisation_foreign`{外交/条约}
- `GFX_focus_foreign_owned_factories`{外交/条约}
- `GFX_focus_JAP_attracting_foreign_capital`{外交/条约}
- `GFX_focus_RUS_champagne_diplomacy`{外交/条约}
- `GFX_focus_SKM_Foreign_Financed_Mechanization`{贸易/经济}
- `GFX_focus_TUR_cornerstone_of_alliance`{外交/条约}
- `GFX_FRA_Gensokyo_Alliance`{外交/条约}
- `GFX_FRA_Pro_Western_diplomacy`{外交/条约}
- `GFX_GEU_FOREIGN_STU`{外交/条约}
- `GFX_new_treaty`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_1_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_10_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_11_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_12_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_13_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_2_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_3_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_4_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_5_icon`{外交/条约}
- `GFX_TRY_Mika_diplomacy_focus_6_icon`{外交/条约}
---### politics-fascist

- `GFX_goal_generic_dictatorship_of_proletariat`{?}
- `GFX_goal_generic_fascist_bills`{意识形态}
- `GFX_generic_authoritarian_government`{内政/法律}
- `GFX_goal_CHL_the_spread_of_fascism`{意识形态}
- `GFX_goal_extensive_conscription_fascism`{动员征兵}
- `GFX_goal_fascism_banned`{意识形态}
- `GFX_goal_fascist_factory`{工业/工厂}
- `GFX_goal_focus_prc_cult_of_personality`{?}
- `GFX_goal_ideology_authoritarian_democrat`{意识形态}
- `GFX_goal_ideology_paternal_autocrat`{意识形态}
- `GFX_goal_ITA_dictator`{?}
- `GFX_goal_SOV_dictatorship_of_proletariat`{?}
- `GFX_FRA_Gensokyo_style_fascism`{意识形态}
- `GFX_FRA_GFN_cult_of_personality`{?}
---### 政治-自由/解放

- `GFX_goal_generic_freedom`{独立/革命}
- `GFX_goal_generic_liberty`{自由/解放}
- `GFX_goal_generic_red_freedom`{独立/革命}
- `GFX_goal_america_goal_freedom_fighters`{空军/航空}
- `GFX_goal_DKB_Liberation_Army`{独立/革命}
- `GFX_goal_Fight_for_Freedom`{独立/革命}
- `GFX_goal_focus_SOV_respect_baltic_self_determination`{?}
- `GFX_goal_liberty_ships`{自由/解放}
- `GFX_goal_NEE_defend_freedom_from_democracy`{意识形态}
- `GFX_goal_NFA_All_For_the_Liberation`{独立/革命}
- `GFX_goal_NFA_guarantor_of_independence`{独立/革命}
- `GFX_goal_TRM_freedom`{独立/革命}
- `GFX_USA_goal_liberty_ships`{自由/解放}
- `GFX_CHI_focus_Expanding_economic_autonomy`{贸易/经济}
- `GFX_CHI_focus_self_determination_personnel_matters`{?}
- `GFX_focus_NGL_land_of_freedom`{独立/革命}
- `GFX_FRA_Liberty_equality_fraternity_and_king`{自由/解放}
- `GFX_grant_autonomy`{独立/革命}
- `GFX_Oil_Independence`{独立/革命}
- `GFX_PRC_Start_War_of_Liberation`{独立/革命}
- `GFX_USA_Itsuka_Kotori_Defenders_of_freedom`{独立/革命}
- `PA1_fight_for_freedom`{独立/革命}
---### politics-intel

- `GFX_goal_generic_communist_secret_police`{内政/法律}
- `GFX_goal_generic_espionage`{情报/间谍}
- `GFX_goal_generic_secret_police`{内政/法律}
- `GFX_goal_generic_secret_police_2`{内政/法律}
- `GFX_generic_espionage`{情报/间谍}
- `GFX_goal_TRB_intelligence`{情报/间谍}
- `GFX_DVL_Artificial_intelligence_assists_in_combat`{情报/间谍}
- `GFX_DVL_Artificial_Intelligence_Project`{情报/间谍}
- `GFX_DVL_Bavarian_Dispatch_of_intelligence_officers`{情报/间谍}
- `GFX_DVL_Protective_surveillance_of_nationals`{?}
- `GFX_DVL_Rhineland_Dispatch_of_intelligence_officers`{情报/间谍}
- `GFX_DVL_Schleswig_Holstein_Dispatch_of_intelligence_officers`{情报/间谍}
- `GFX_focus_NGL_imperial_intelligence_agency`{情报/间谍}
- `GFX_focus_NGL_restricted_intelligence_agency`{情报/间谍}
- `GFX_focus_SGL_dispatch_intelligence_department`{情报/间谍}
- `GFX_focus_USS_surveillance_infector_pickets`{?}
- `GFX_GER_Guard_against_ideological_infiltration`{情报/间谍}
- `MGU_yuki_spy_infect`{情报/间谍}
---### 政治-法律

- `GFX_goal_generic_banking_legislation`{财政/税收/劳工}
- `GFX_goal_generic_bills`{法案}
- `GFX_goal_generic_business_bills`{法案}
- `GFX_goal_generic_constitutional_monarchy`{内政/法律}
- `GFX_goal_generic_fascist_bills`{意识形态}
- `GFX_goal_generic_martial_law`{内政/法律}
- `GFX_goal_generic_repeal_opressive_law`{内政/法律}
- `GFX_generic_banking_legislation`{财政/税收/劳工}
- `GFX_generic_suspend_constitution`{内政/法律}
- `GFX_goal_constitution`{内政/法律}
- `GFX_goal_constitution_focus`{内政/法律}
- `GFX_goal_constitutional_monarchy`{内政/法律}
- `GFX_goal_DOM_End_Judicial_Corruption`{内政/法律}
- `GFX_goal_ITA_law`{内政/法律}
- `GFX_goal_NFA_Restore_the_Suspended_Constitution`{内政/法律}
- `GFX_goal_repeal_political`{内政/法律}
- `GFX_goal_RUS_Adjust_Constitution`{内政/法律}
- `GFX_goal_RUS_New_Constitution`{内政/法律}
- `GFX_CHI_focus_formulate_provincial_constitutions`{内政/法律}
- `GFX_DVL_Control_laws_of_economic_development`{贸易/经济}
- `GFX_focus_JAP_government_bill`{内政/法律}
- `GFX_focus_JAP_government_bill_nopass`{内政/法律}
- `GFX_focus_JAP_government_bill_pass`{内政/法律}
- `GFX_focus_JAP_new_law_used`{内政/法律}
- `GFX_focus_JAP_writing_new_law`{内政/法律}
- `GFX_focus_NGL_new_constitution`{内政/法律}
- `GFX_focus_NGL_perfecting_the_bill`{?}
- `GFX_focus_NGL_tear_up_false_law`{内政/法律}
- `GFX_focus_RUS_reform_voting_law`{内政/法律}
- `GFX_focus_TGI_old_fashion_conscription_law`{动员征兵}
---### politics-monarchy

- `GFX_goal_generic_banking`{财政/税收/劳工}
- `GFX_goal_generic_banking_legislation`{财政/税收/劳工}
- `GFX_goal_generic_constitutional_monarchy`{内政/法律}
- `GFX_goal_generic_royal_industry`{?}
- `GFX_generic_banking_legislation`{财政/税收/劳工}
- `GFX_goal_AUS_raised_working_week`{?}
- `GFX_goal_constitutional_monarchy`{内政/法律}
- `GFX_goal_COR_american_empire`{?}
- `GFX_goal_crush_monarchy`{意识形态}
- `GFX_goal_CSA_protect_working_class`{?}
- `GFX_goal_FNG_Empires_Stockpile`{?}
- `GFX_goal_Fourth_empire`{?}
- `GFX_goal_goal_SRD_royalist_fervor`{?}
- `GFX_goal_japanese_imperialism`{?}
- `GFX_goal_NFA_July_Monarchy`{意识形态}
- `GFX_goal_NFA_Royal_Corporatism`{?}
- `GFX_goal_POL_Albedo_king`{?}
- `GFX_goal_r56_goal_CHI_waking_the_tiger`{?}
- `GFX_goal_r56_goal_MAN_place_in_empire`{?}
- `GFX_goal_regent_bigger_than_emperor`{?}
- `GFX_goal_RUS_Denounce_Monarchist_Senate`{内政/法律}
- `GFX_goal_SOV_Working_Day`{?}
- `GFX_AUS_Restore_Sanity_Habsburg_Empire`{?}
- `GFX_CHI_focus_Hearts_of_Celestial_Empire`{?}
- `GFX_CHI_focus_Imperial_comeback`{?}
- `GFX_CHI_focus_Make_monarchy_Great_Again`{意识形态}
- `GFX_CHI_focus_Royal_News`{?}
- `GFX_CHI_shared_rebuild_concept_of_imperial`{建筑/工程}
- `GFX_DVL_All_king_courtier`{?}
- `GFX_DVL_All_king_land`{?}
---### 政治-议会

- `GFX_goal_generic_dissolve_parliament1`{内政/法律}
- `GFX_goal_generic_dissolve_parliament2`{内政/法律}
- `GFX_goal_generic_parliament`{内政/法律}
- `GFX_generic_parliament`{内政/法律}
- `GFX_goal_assembly_const_focus`{工业/工厂}
- `GFX_goal_CSA_all_industrial_congress`{工业/工厂}
- `GFX_goal_CSA_empower_congress`{内政/法律}
- `GFX_goal_dissolve_parliament`{内政/法律}
- `GFX_goal_focus_const_assembly`{工业/工厂}
- `GFX_goal_RUS_Appease_Senate`{内政/法律}
- `GFX_goal_RUS_Denounce_Monarchist_Senate`{内政/法律}
- `GFX_goal_RUS_Dissolve_Duma`{内政/法律}
- `GFX_goal_USA_congress_released`{内政/法律}
- `GFX_focus_NGL_secret_assembly`{工业/工厂}
- `GFX_focus_USS_imperial_parliament`{内政/法律}
- `GFX_focus_USS_parliament_stalled`{内政/法律}
- `GFX_focus_USS_removal_parliament`{内政/法律}
- `GFX_FRA_Parliamentary_reform`{内政/法律}
- `GFX_GRU_union_congress`{内政/法律}
---### politics-police

- `GFX_goal_generic_communist_secret_police`{内政/法律}
- `GFX_goal_generic_secret_police`{内政/法律}
- `GFX_goal_generic_secret_police_2`{内政/法律}
- `GFX_goal_america_goal_police_state`{内政/法律}
- `GFX_goal_BBR_jacobin_police`{内政/法律}
- `GFX_goal_KSV_follow_orders`{?}
- `GFX_goal_SIC_legionary_order`{?}
- `GFX_border_liaison_post`{?}
- `GFX_focus_NGL_old_order_wins`{?}
- `GFX_focus_TGI_arms_police_watch_workers`{内政/法律}
- `GFX_focus_TGI_fortress_on_border`{防御工事/要塞}
- `GFX_focus_TGI_northern_border_base`{?}
- `GFX_focus_TRB_the_order_from_emperor`{?}
- `GFX_focus_USS_emperors_orders`{?}
- `GFX_focus_USS_imperial_police`{内政/法律}
- `GFX_focus_USS_investigate_internal_security`{贸易/经济}
- `GFX_focus_USS_order_in_progress`{发展/计划}
- `GFX_FRA_European_New_Order`{?}
- `GFX_vnc_ocean_order`{海军/舰船/基地}
- `MGU_yuki_law_and_order`{内政/法律}
- `MGU_yuki_new_order`{?}
---### 政治-宣传/审查

- `GFX_goal_generic_censorship`{海军/舰船/基地}
- `GFX_goal_generic_monarchic_oppression`{意识形态}
- `GFX_goal_generic_oppression`{宣传/舆论}
- `GFX_goal_generic_repeal_opressive_law`{内政/法律}
- `GFX_goal_Control_propaganda_machine`{宣传/舆论}
- `GFX_goal_focus_media_industry`{宣传/舆论}
- `GFX_goal_SOV_big_news`{?}
- `GFX_goal_suppress_man`{宣传/舆论}
- `GFX_goal_TEX_media_propaganda`{宣传/舆论}
- `GFX_AFG_Oversee_The_press`{宣传/舆论}
- `GFX_CHI_focus_Royal_News`{?}
- `GFX_DVL_Bavarian_Infiltrate_propaganda`{宣传/舆论}
- `GFX_DVL_Rhineland_Infiltrate_propaganda`{宣传/舆论}
- `GFX_DVL_Schleswig_Holstein_Infiltrate_propaganda`{宣传/舆论}
- `GFX_focus_propaganda_soviet`{宣传/舆论}
- `GFX_focus_TGI_suppress_anger`{宣传/舆论}
- `GFX_focus_USS_continue_suppress_guerrillas`{宣传/舆论}
- `GFX_focus_USS_suppress_old_aristocracy`{宣传/舆论}
- `GFX_FRA_GFN_Kaguya_legitimacy_propaganda`{宣传/舆论}
- `GFX_FRA_GFN_Propaganda_of_national_glory`{宣传/舆论}
- `GFX_NFA_national_propaganda`{宣传/舆论}
- `GFX_UAL_propaganda_attack_from_sky`{空军/航空}
- `GFX_UAL_rise_oppressers`{宣传/舆论}
---### 政治-傀儡/附庸

- `GFX_generic_puppet_monarch`{外交/条约}
- `GFX_focus_USS_puppet_council`{外交/条约}
- `GFX_FRA_Puppet_tactics`{外交/条约}
- `MGU_yuki_magic_puppet`{外交/条约}
- `MGU_yuki_set_puppet`{外交/条约}
---### politics-religion

- `GFX_goal_generic_church_economy`{贸易/经济}
- `GFX_goal_generic_crusade`{?}
- `GFX_goal_generic_friendship_with_church`{文化/艺术/宗教}
- `GFX_goal_BBR_spiritual_patriotism`{文化/艺术/宗教}
- `GFX_goal_DSR_Church`{文化/艺术/宗教}
- `GFX_goal_ITA_church_economic`{贸易/经济}
- `GFX_goal_SOV_spiritual_patriotism`{文化/艺术/宗教}
- `GFX_CHI_focus_Taoist_priest_Army`{文化/艺术/宗教}
- `GFX_CHI_focus_Taoist_priest_weapon`{文化/艺术/宗教}
- `GFX_focus_neptune_integration_of_four_churches`{文化/艺术/宗教}
- `GFX_focus_NGL_bishop`{?}
- `GFX_focus_rus_for_faith`{文化/艺术/宗教}
- `GFX_focus_USS_empire_is_ultimate_faith`{文化/艺术/宗教}
- `GFX_form_holy_roman_empire`{文化/艺术/宗教}
- `GFX_holy_roma_empire`{文化/艺术/宗教}
- `GFX_PAL_Heart_of_Holy_City`{文化/艺术/宗教}
- `GFX_SWE_Reestablish_original_faith`{文化/艺术/宗教}
- `GFX_SWE_Separation_of_church_and_state`{文化/艺术/宗教}
- `GFX_USA_Reactionary_Church`{文化/艺术/宗教}
---### politics-reparation

- `GFX_DVL_Bavarian_Pre_war_preparations`{?}
- `GFX_DVL_Rhineland_Pre_war_preparations`{?}
- `GFX_DVL_Schleswig_Holstein_Pre_war_preparations`{?}
- `GFX_UAL_distribute_fields`{?}
---### 政治-机密

- `GFX_goal_generic_secret_documents`{情报/间谍}
- `GFX_goal_LIB_hidden_gensokyo`{?}
- `GFX_goal_NFA_strike_hidden_socialism`{意识形态}
---### 政治-团结/统一

- `GFX_goal_generic_attack_united_states`{团结/统一}
- `GFX_goal_generic_befriend_united_caribbean`{团结/统一}
- `GFX_goal_generic_befriend_united_states`{团结/统一}
- `GFX_goal_consolidating_coalitionv2`{采矿}
- `GFX_goal_FNG_unification_by_subjugation`{?}
- `GFX_goal_FNG_unification_conference`{外交/条约}
- `GFX_goal_ITA_reunited`{团结/统一}
- `GFX_goal_ITA_unification`{?}
- `GFX_goal_ITA_united`{团结/统一}
- `GFX_goal_NFA_Unity_through_struggle`{团结/统一}
- `GFX_goal_RUS_United_Russia`{团结/统一}
- `GFX_goal_RUS_unity`{团结/统一}
- `GFX_goal_SOV_coalition_of_opposition`{采矿}
- `GFX_goal_SOV_community_to_stand`{团结/统一}
- `GFX_goal_UKR_Coalition`{采矿}
- `GFX_CHI_focus_China_coalition_government`{采矿}
- `GFX_CHI_focus_unification_of_Central`{?}
- `GFX_consolidating_coalitionv2`{采矿}
- `GFX_focus_JAP_social_reconciliation`{情报/间谍}
- `GFX_focus_JAP_united_protest`{团结/统一}
- `GFX_focus_rus_organic_solidarity`{团结/统一}
- `GFX_focus_TGI_together_fuckall_act`{团结/统一}
- `GFX_focus_TGI_together_we_are_strong`{团结/统一}
- `GFX_FRA_The_tengu_work_together`{团结/统一}
- `GFX_FRA_Unifying_Gensokyo`{?}
- `GFX_MAN_Mother_of_the_United_Province_of_China`{团结/统一}
- `GFX_MAN_Second_united_front`{团结/统一}
- `GFX_MAN_unity_and_compromise`{团结/统一}
- `GFX_PAL_signal_for_reconciliation`{情报/间谍}
- `GFX_USA_North_American_United_Front`{团结/统一}

---### resource-all

- `GFX_goal_generic_all_resource`{资源开发}
- `GFX_goal_All_resource`{资源开发}
- `GFX_focus_continuous_extraction`{采矿}
---### 资源-铝

- `GFX_kbz_resource_aluminium`{资源开发}
---### resource-chrome

- `GFX_goal_generic_chromium`{?}
---### 资源-煤炭

- `GFX_goal_generic_coal_mining`{采矿}
- `GFX_goal_consolidating_coalitionv2`{采矿}
- `GFX_goal_SOV_coalition_of_opposition`{采矿}
- `GFX_goal_UKR_Coalition`{采矿}
- `GFX_CHI_focus_China_coalition_government`{采矿}
- `GFX_consolidating_coalitionv2`{采矿}
- `GFX_focus_TRB_coal`{采矿}
---### 资源-钻石/宝石

- `GFX_goal_generic_extraction_diamond`{采矿}
- `GFX_goal_generic_jungle_diamond`{?}
- `GFX_focus_USS_hegemonism`{?}
- `GFX_focus_USS_military_encouragement`{?}
---### 资源-黄金

- `GFX_goal_generic_economics_reform_gold`{贸易/经济}
- `GFX_goal_generic_extraction_gold`{采矿}
- `GFX_goal_generic_gold`{财政/税收/劳工}
- `GFX_goal_generic_gold_money`{财政/税收/劳工}
- `GFX_goal_generic_jungle_gold`{财政/税收/劳工}
- `GFX_goal_generic_positive_trade_relations_gold`{贸易/经济}
- `GFX_r56_goal_generic_gold`{财政/税收/劳工}
- `GFX_focus_generic_gold`{财政/税收/劳工}
- `GFX_generic_positive_trade_relations_gold`{贸易/经济}
- `GFX_chained_by_gold`{财政/税收/劳工}
- `GFX_focus_neptune_authorized_golden`{财政/税收/劳工}
- `GFX_focus_TRB_gold_stock_up`{财政/税收/劳工}
- `GFX_FRA_military_horn_struck_gold_come`{机械/汽车}
- `GFX_Golden_Foil_Relic`{财政/税收/劳工}
- `GFX_new_golden_witch`{财政/税收/劳工}
- `GFX_UAL_golden_ocean`{海军/舰船/基地}
---### 资源-采矿/矿产

- `GFX_goal_generic_armored_car_offensive`{?}
- `GFX_goal_generic_coal_mining`{采矿}
- `GFX_goal_generic_defense_of_the_shores`{?}
- `GFX_goal_generic_excavation_equipment`{采矿}
- `GFX_goal_generic_extraction_diamond`{采矿}
- `GFX_goal_generic_extraction_gold`{采矿}
- `GFX_goal_generic_famine`{采矿}
- `GFX_goal_generic_foreign_diplomacy`{外交/条约}
- `GFX_goal_generic_foreign_diplomacy2`{外交/条约}
- `GFX_goal_generic_foreign_investments`{贸易/经济}
- `GFX_goal_generic_forest_warfare`{战争/冲突}
- `GFX_goal_generic_mining_iron`{采矿}
- `GFX_goal_DKB_restore_democracy`{意识形态}
- `GFX_goal_excavation`{采矿}
- `GFX_goal_famine`{采矿}
- `GFX_goal_JAP_Sword_Forever_Drawn`{?}
- `GFX_goal_more_poster`{?}
- `GFX_goal_NFA_foreign_legion`{外交/条约}
- `GFX_goal_NFA_Restore_the_Suspended_Constitution`{内政/法律}
- `GFX_goal_ore_disease`{?}
- `GFX_goal_TRB_build_more_complex`{?}
- `GFX_AUS_Restore_Sanity_Habsburg_Empire`{?}
- `GFX_CAN_explore_north`{?}
- `GFX_CHI_focus_Expanding_foreign_investment`{贸易/经济}
- `GFX_CHI_focus_Forced_nationalisation_foreign`{外交/条约}
- `GFX_CHI_focus_Free_korea`{?}
- `GFX_CHI_focus_restore_old_country`{?}
- `GFX_emporer_mark`{?}
- `GFX_focus_continuous_extraction`{采矿}
- `GFX_focus_foreign_owned_factories`{外交/条约}
---### 资源-核能

- `GFX_goal_generic_nuclear_energy`{核能/能源}
---### 资源-石油

- `GFX_goal_generic_basic_oil`{石油/橡胶}
- `GFX_goal_generic_oil_refinery`{化工/炼油}
- `GFX_goal_generic_oil_SPR`{石油/橡胶}
- `GFX_goal_desert_oil`{石油/橡胶}
- `GFX_goal_Further_Oil`{石油/橡胶}
- `GFX_goal_oil`{石油/橡胶}
- `GFX_goal_SAU_duoqu_oil`{石油/橡胶}
- `GFX_boil_the_sea`{海军/舰船/基地}
- `GFX_Boiling_Amazon_Water`{城市/水利}
- `GFX_Golden_Foil_Relic`{财政/税收/劳工}
- `GFX_Hold_Up_Red_Soil`{石油/橡胶}
- `GFX_kbz_resource_oil`{石油/橡胶}
- `GFX_Oil_Independence`{独立/革命}
- `GFX_Sugar_Is_Fuel`{化工/炼油}
---### 资源-橡胶

- `GFX_focus_generic_rubber`{石油/橡胶}
- `GFX_goal_DEI_focus_moar_rubber`{石油/橡胶}
---### 资源-钨

- `GFX_focus_generic_tungsten`{?}

---### society-culture

- `GFX_goal_focus_generic_agriculture`{农业/乡村}
- `GFX_goal_generic_agriculture`{农业/乡村}
- `GFX_goal_generic_agriculture2`{农业/乡村}
- `GFX_goal_generic_army_artillery`{炮兵}
- `GFX_goal_generic_artillery_factories`{炮兵}
- `GFX_goal_generic_artillery_improved`{炮兵}
- `GFX_goal_generic_combined_arms_artillery_antiair_antitank`{装甲/坦克}
- `GFX_goal_generic_martial_law`{内政/法律}
- `GFX_goal_generic_mobile_artillery_light`{炮兵}
- `GFX_goal_generic_mobile_artillery_medium`{炮兵}
- `GFX_goal_generic_multipartism`{?}
- `GFX_goal_generic_partisans`{占领/镇压}
- `GFX_goal_generic_party_bottle`{?}
- `GFX_goal_generic_railway_artillery`{炮兵}
- `GFX_goal_generic_rocket_artillery`{炮兵}
- `GFX_r56_goal_generic_artillery`{炮兵}
- `GFX_goal_AUS_agriculture`{农业/乡村}
- `GFX_goal_BBR_american_traditions`{文化/艺术/宗教}
- `GFX_goal_CHI_assume_intra_party_leadership`{海军/舰船/基地}
- `GFX_goal_COOP_new_culture`{文化/艺术/宗教}
- `GFX_goal_FNG_Japanese_Culture`{文化/艺术/宗教}
- `GFX_goal_focus_chi_party_net`{?}
- `GFX_goal_form_new_party`{?}
- `GFX_goal_FRA_soviet_culture`{文化/艺术/宗教}
- `GFX_goal_goal_one_party`{?}
- `GFX_goal_HKG_One_Party`{?}
- `GFX_goal_KMT_Deepen_the_Party_State`{?}
- `GFX_goal_LIC_austrian_customs`{贸易/经济}
- `GFX_goal_MAF_labor_charter`{?}
- `GFX_goal_magic_agriculture`{农业/乡村}
---### society-environment

- `GFX_goal_generic_forest_warfare`{战争/冲突}
- `GFX_goal_generic_jungle_diamond`{?}
- `GFX_goal_generic_jungle_gold`{财政/税收/劳工}
- `GFX_goal_generic_jungle_warfare`{战争/冲突}
- `GFX_goal_focus_SOV_transformation_of_nature`{?}
- `GFX_Boiling_Amazon_Water`{城市/水利}
- `GFX_Clinic_In_Jungle`{?}
- `GFX_focus_NGL_in_the_jungle`{?}
- `GFX_focus_NPT_Blanc_life_and_growth_in_nature`{?}
- `MGU_yuki_conservation`{?}
---### society-refugee

- `GFX_goal_POL_exile_of_Manna`{?}
- `GFX_czech_immigration`{?}
---### society-sport

- `GFX_focus_NGL_transportation_network`{基建/运输}
- `GFX_focus_USS_rebuild_transportation_system`{建筑/工程}
- `GFX_FRA_All_out_competition`{?}
- `GFX_UAL_do_they_have_soccer_in_ursus`{?}
---### 社会-女性/性别

- `GFX_goal_SOV_chairwoman_Anna`{?}
- `GFX_goal_SOV_chairwoman_Averell`{?}
- `GFX_goal_SOV_chairwoman_Talulah`{?}
- `GFX_goal_SOV_Sakura_chairwoman`{?}
- `GFX_goal_SOV_Women`{?}
- `GFX_goal_SOV_youjun_girl`{?}
- `GFX_goal_womens_rights`{?}
- `GFX_goal_womens_rights2`{?}
- `GFX_focus_BAL_swordswoman_academy_expansion`{教育}
- `GFX_focus_JAP_free_woman`{?}
- `GFX_focus_MGU_male_magicgirl`{?}
- `GFX_FRA_Valiant_girls_go_to_war`{战争/冲突}
---### 社会-青年

- `GFX_goal_NFA_Youth_Devotion`{?}
- `GFX_goal_Youth_army_of_Yuan`{?}
- `GFX_FRA_GFN_Reisen_Youth_League`{?}
- `GFX_UBR_hitler_youth`{?}

---### tech-chemistry

- `GFX_GRU_CORPORATE_CHEMICAL`{化工/炼油}
---### 科技-计算机

- `GFX_goal_TRB_computer`{无线电/电子/科技}
- `GFX_DVL_Computing_power_leaps`{?}
- `GFX_DVL_Promote_cybernetic_research`{科研/太空}
- `GFX_focus_era_of_handheld_computers`{无线电/电子/科技}
---### 科技-教育/学校

- `GFX_goal_focus_generic_university`{教育}
- `GFX_goal_generic_catholic_education`{教育}
- `GFX_goal_generic_christian_education`{教育}
- `GFX_goal_generic_education`{教育}
- `GFX_goal_generic_islamic_education`{教育}
- `GFX_goal_GFX_establishmentofreeducationcamps`{教育}
- `GFX_goal_Hiring_international_students`{外交/条约}
- `GFX_goal_RUS_National_High_Command_Formation_School`{教育}
- `GFX_focus_BUL_university_sofia`{教育}
- `GFX_focus_NGL_education_popularization`{教育}
- `GFX_focus_NGL_education_recovery`{教育}
- `GFX_focus_NGL_reopen_university`{教育}
- `GFX_focus_TGI_reopen_old_days_mil_school`{教育}
- `GFX_focus_USS_rebuild_education_system`{建筑/工程}
- `GFX_FRA_education_of_Fujiwara_no_Mokou`{教育}
- `GFX_GEU_YIWU_EDUCATION`{教育}
- `GFX_GRU_higher_education_grants`{教育}
- `GFX_kaz_school_pp`{教育}
- `GFX_literacy_for_survival`{教育}
- `GFX_MAF_divest_native_education`{教育}
- `GFX_Schools_Before_Foundries`{教育}
- `GFX_SWE_Warrior_education`{教育}
- `GFX_teach_literacy`{教育}
- `GFX_UAL_deeper_education_reformation`{内政/法律}
- `GFX_UAL_education_on_brain`{教育}
- `GFX_UAL_educational_reformation`{内政/法律}
- `MGU_yuki_set_army_school`{教育}
---### tech-medical

- `GFX_goal_generic_medicine_crescent`{?}
- `GFX_goal_focus_healthcare_program`{?}
- `GFX_goal_ITA_healthcare`{?}
- `GFX_goal_medicine`{?}
- `GFX_goal_public_health_commission`{?}
- `GFX_focus_NGL_healthy_people`{?}
- `GFX_focus_NGL_medical_institution`{?}
- `GFX_focus_TGI_good_for_your_health`{?}
- `GFX_kaz_doctor_Kelsey`{?}
- `GFX_UAL_improve_epidemic_prevention_system`{?}
- `MGU_yuki_ship_doctorine`{?}
---### 科技-无线电/电子

- `GFX_goal_generic_control_the_radio`{无线电/电子/科技}
- `GFX_goal_generic_radar2`{无线电/电子/科技}
- `GFX_goal_generic_radio_development`{无线电/电子/科技}
- `GFX_goal_generic_radio_development_2`{无线电/电子/科技}
- `GFX_generic_radar_instillation`{无线电/电子/科技}
- `GFX_goal_radio`{无线电/电子/科技}
- `GFX_DVL_radio`{无线电/电子/科技}
- `GFX_electronics`{无线电/电子/科技}
- `GFX_UAL_revolutionary_broadcasting`{基建/运输}
---### 科技-科研

- `GFX_goal_generic_double_research`{科研/太空}
- `GFX_goal_generic_military_research`{科研/太空}
- `GFX_goal_generic_military_research_2`{科研/太空}
- `GFX_goal_life_sciences`{?}
- `GFX_goal_research_silver`{科研/太空}
- `GFX_goal_research_silver_cooperation`{科研/太空}
- `GFX_goal_SOV_research_automatic_machinery`{机械/汽车}
- `GFX_goal_TRM_Scientific_Investment`{贸易/经济}
- `GFX_AUS_Research_on_new_types_of_armor`{装甲/坦克}
- `GFX_DVL_Advancing_biomimetic_neural_network_research`{科研/太空}
- `GFX_DVL_Advancing_transistor_research`{科研/太空}
- `GFX_DVL_Integrating_European_research_force`{科研/太空}
- `GFX_DVL_Leap_forward_in_materials_science`{科研/太空}
- `GFX_DVL_Nasalik_Scientific_Research_Society`{科研/太空}
- `GFX_DVL_Promote_cybernetic_research`{科研/太空}
- `GFX_focus_NGL_gaul_academy_of_sciences`{教育}
- `GFX_FRA_Automechanical_research`{科研/太空}
- `GFX_FRA_Research_on_new_types_of_aircraft`{空军/航空}
- `GFX_GEU_SCIENCE_MANAGE`{?}
- `GFX_goalSOV_research_automatic_machinery`{机械/汽车}
- `GFX_great_science`{科研/太空}
- `GFX_kaz_research_pp`{科研/太空}
- `GFX_PRC_No_conscience_cannon`{炮兵}
- `GFX_UAL_scientific_Way_of_training`{?}
---### tech-space

- `GFX_focus_DVL_orbital_bombardment`{轨道轰炸}

---

## 更新日志
- 2026-06-26: 初始生成，覆盖 42 个 LFC 国策
- 2026-06-27: **增强更新**
  - 新增「图标名速译」章节，支持从文件名快速判断图标用途
  - 候选池图标追加中文标注
  - 基于关键词分析 + 本地化反馈修正归类错误
  - 新增拼音/中文命名图标识别
- 2026-06-27: **全量分类重建**
  - 候选池从 231 个扩充到 981 个（覆盖全部 10,432 注册图标的关键词分类）
  - 纳入 5,432 个非标准命名图标（GFX_DVL_xxx, GFX_PAN_xxx 等）
  - 92 个语义子类别自动分类（陆军/海军/空军/工业/资源/科技/经济/政治/社会）
  - 新增 `_candidate_pool.tsv` 和 `_summary_stats.json` 配套数据文件
  - 中文标签覆盖率提升（关键词 + 现有JSON双源匹配）
