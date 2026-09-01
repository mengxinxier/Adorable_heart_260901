$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outFile = Join-Path $dir "LFC_goal_icon_reference.md"
$utf8Bom = [System.Text.UTF8Encoding]::new($true)

# Load JSON labels
$json = Join-Path $dir "_icon_chinese_labels.json"
$jsonData = Get-Content $json -Encoding UTF8 | ConvertFrom-Json
$labelMap = @{}
foreach ($entry in $jsonData) {
    $labelMap[$entry.SpriteName] = $entry.ChineseLabel
}

# Load TSV
$tsv = Join-Path $dir "_candidate_pool.tsv"
$tsvLines = [System.IO.File]::ReadAllLines($tsv, [System.Text.Encoding]::UTF8)

# Load CSV
$csv = Join-Path $dir "LFC_icon_assignments.csv"
$csvLines = [System.IO.File]::ReadAllLines($csv, [System.Text.Encoding]::UTF8)

# Category name mapping
$catNames = @{
    'air/AA' = '空军-防空'
    'air/bomber' = '空军-轰炸机'
    'air/fighter' = '空军-战斗机'
    'air/para' = '空军-伞兵/空降'
    'air/rocket' = '空军-火箭/导弹'
    'air/air_wing' = '空军-空军联队'
    'army/artillery' = '陆军-炮兵'
    'army/command' = '陆军-军事指挥'
    'army/defense' = '陆军-国防/防御'
    'army/elite' = '陆军-精锐部队'
    'army/fortify' = '陆军-防御工事'
    'army/guerrilla' = '陆军-游击/民兵'
    'army/infantry' = '陆军-步兵'
    'army/marines' = '陆军-海军陆战队'
    'army/morale' = '陆军-士气加成'
    'army/mountain' = '陆军-山地部队'
    'army/attack' = '陆军-进攻/击溃'
    'army/purge' = '陆军-肃清/清洗'
    'army/conscription' = '陆军-动员征兵'
    'army/armor' = '陆军-装甲/坦克'
    'army/tech' = '陆军-军事科技'
    'army/training' = '陆军-军事训练'
    'army/multinational' = '陆军-多国联军'
    'navy/battleship' = '海军-战舰/主力舰'
    'navy/carrier' = '海军-航母'
    'navy/landing' = '海军-登陆作战'
    'navy/liberty' = '海军-自由轮/民船'
    'navy/naval_air' = '海军-海军航空'
    'navy/navy' = '海军-海军/航海'
    'navy/port' = '海军-港口/海防'
    'navy/shipyard' = '海军-造船/船坞'
    'navy/submarine' = '海军-潜艇'
    'industry/auto' = '工业-汽车工业'
    'industry/construction' = '工业-建筑工程'
    'industry/factory' = '工业-工业/工厂'
    'industry/housing' = '工业-住房/城市化'
    'industry/machinery' = '工业-机械/工程'
    'industry/power' = '工业-电力/电气化'
    'industry/rail' = '工业-铁路'
    'industry/road' = '工业-公路/道路'
    'industry/water' = '工业-水利/水电'
    'economy/agriculture' = '经济-农业/种植'
    'economy/finance' = '经济-金融/投资'
    'economy/growth' = '经济-经济增长'
    'economy/labor' = '经济-劳工/工会'
    'economy/land' = '经济-土地改革'
    'economy/military_reform' = '经济-军事改革'
    'economy/trade' = '经济-贸易/商业'
    'economy/welfare' = '经济-民生/福利'
    'resource/dev' = '资源-资源开发'
    'resource/aluminum' = '资源-铝'
    'resource/chromium' = '资源-铬'
    'resource/coal' = '资源-煤炭'
    'resource/diamond' = '资源-钻石/宝石'
    'resource/gold' = '资源-黄金'
    'resource/mining' = '资源-采矿/矿产'
    'resource/nuclear' = '资源-核能'
    'resource/oil' = '资源-石油'
    'resource/rubber' = '资源-橡胶'
    'resource/tungsten' = '资源-钨'
    'tech/chemical' = '科技-化学'
    'tech/computer' = '科技-计算机'
    'tech/education' = '科技-教育/学校'
    'tech/radio' = '科技-无线电/电子'
    'tech/research' = '科技-科研'
    'politics/communism' = '政治-共产主义'
    'politics/corruption' = '政治-反腐'
    'politics/democracy' = '政治-民主主义'
    'politics/diplomacy' = '政治-外交'
    'politics/fascism' = '政治-法西斯/独裁'
    'politics/freedom' = '政治-自由/解放'
    'politics/independence' = '政治-独立/解放'
    'politics/intelligence' = '政治-情报/间谍'
    'politics/law' = '政治-法律'
    'politics/parliament' = '政治-议会'
    'politics/propaganda' = '政治-宣传/审查'
    'politics/puppet' = '政治-傀儡/附庸'
    'politics/secret' = '政治-机密'
    'politics/unity' = '政治-团结/统一'
    'society/backstab' = '社会-背叛'
    'society/cooperation' = '社会-合作'
    'society/general' = '社会-通用'
    'society/immigration' = '社会-移民'
    'society/reform' = '社会-改革'
    'society/women' = '社会-女性/性别'
    'society/youth' = '社会-青年'
}

$out = New-Object System.Text.StringBuilder

[void]$out.AppendLine('# LFC 国策图标速查表')
[void]$out.AppendLine('> 生成日期：2026-06-26 | 最后更新：2026-06-27（全量分类重建）')
[void]$out.AppendLine('> 图标总数：42 个 LFC 国策（全部 mod 注册，无重复，无 vanilla 回退）')
[void]$out.AppendLine('> 候选池：981 个图标，按 92 个语义类别整理，均附中文用途标注（自动生成+人工校验）')
[void]$out.AppendLine('> 数据源：205 个 .gfx → 47,316 spriteType → **10,432 goals 注册**（标准 5,000 + 非标准 5,432）→ 5,237 去重 → 3,543 已分类 → 1,190 已标注中文')
[void]$out.AppendLine('')
[void]$out.AppendLine('---')
[void]$out.AppendLine('')
[void]$out.AppendLine('## 方案说明（给 AI 读）')
[void]$out.AppendLine('')
[void]$out.AppendLine('### 这是什么')
[void]$out.AppendLine('本文件是 **Adorable Heart 模组 LFC 国家国策图标** 的完整参考。包含：')
[void]$out.AppendLine('1. **42 个已分配图标的对照表**（国策ID → 图标名 → 语义）')
[void]$out.AppendLine('2. **图标名速译**（英文关键词 → 中文含义，用于快速判断陌生图标的用途）')
[void]$out.AppendLine('3. **语义分类候选池**（按主题整理的备用图标，附中文标注，供新国策选图用）')
[void]$out.AppendLine('')
[void]$out.AppendLine('### HOI4 图标系统简介')
[void]$out.AppendLine('```')
[void]$out.AppendLine('.dds 或 .png 图片文件（在 gfx/interface/goals/ 下）')
[void]$out.AppendLine('    → 通过 .gfx 文件注册')
[void]$out.AppendLine('spriteType 名称（如 GFX_goal_generic_army_mobilization）')
[void]$out.AppendLine('    → 在国策文件中引用')
[void]$out.AppendLine('focus = { icon = GFX_goal_generic_army_mobilization }')
[void]$out.AppendLine('```')
[void]$out.AppendLine('')
[void]$out.AppendLine('- **注册** = .gfx 文件里的 `spriteType = { name = "GFX_xxx" texturefile = "gfx/interface/goals/.../xxx.png" }`')
[void]$out.AppendLine('- **mod 注册** = 本 mod 的 205 个 .gfx 文件中出现的注册名（**高优先级**，共 10,432 个 goals 图标，标准命名 5,000 + 非标准命名 5,432）')
[void]$out.AppendLine('- **原版注册** = 只在原版 .gfx 中的注册名（**低优先级**，本表不收录）')
[void]$out.AppendLine('- **命名惯例**：标准图标以 `GFX_goal_`/`GFX_focus_` 开头，但也有大量图标直接以 `GFX_[TAG]_` 命名（如 `GFX_DVL_Hayek_scheme`、`GFX_PAN_xxx`）。速查表覆盖所有命名模式')
[void]$out.AppendLine('- **注意**：.gfx 中 `spriteType` 和 `SpriteType`（大小写）都存在，解析时需大小写不敏感')
[void]$out.AppendLine('- 未注册的图片文件即使存在也无法在游戏中使用')
[void]$out.AppendLine('')
[void]$out.AppendLine('### 图标名解读规则')
[void]$out.AppendLine('看到 `GFX_goal_generic_army_mobilization` 这样的名字时：')
[void]$out.AppendLine('| 部分 | 含义 |')
[void]$out.AppendLine('|------|------|')
[void]$out.AppendLine('| `GFX_` | 固定前缀 |')
[void]$out.AppendLine('| `goal_` / `focus_` / `decision_` / `idea_` | 用途类型（国策 / 决议 / 理念）|')
[void]$out.AppendLine('| `generic_` | 通用图标（加分项，视觉简洁）|')
[void]$out.AppendLine('| `r56_` | 来自 Road to 56 模组 |')
[void]$out.AppendLine('| `[TAG]_` | 国家特定（如 `CHI_`=中国、`GER_`=德国、`TRB_`=特利巴）|')
[void]$out.AppendLine('| `break_army` | 实际含义关键词 |')
[void]$out.AppendLine('| `_shine` | 发光特效变体（**避免使用**，视觉过曝）|')
[void]$out.AppendLine('')
[void]$out.AppendLine('### 为新国策选图标的流程')
[void]$out.AppendLine('')
[void]$out.AppendLine('1. **确定语义类别**：根据国策标题判断属于哪个类别（陆军/海军/经济/政治…）')
[void]$out.AppendLine('2. **查速译表**：如果不确定某图标含义，在「图标名速译」中查关键词')
[void]$out.AppendLine('3. **浏览候选池**：在对应类别中找标注中文含义的图标，选最匹配的')
[void]$out.AppendLine('4. **检查优先级**：')
[void]$out.AppendLine('   - 优先选 `generic_` 前缀的（通用、视觉清晰）')
[void]$out.AppendLine('   - 优先选来源含 `generic_goals.gfx` 或 `adorable_heart_goals.gfx` 的')
[void]$out.AppendLine('   - 避免 `_shine` 后缀（发光特效）')
[void]$out.AppendLine('   - 避免带 `[TAG]_` 国家前缀的（除非国策与该国直接相关）')
[void]$out.AppendLine('5. **确认未重复**：在对照表检查 42 个已分配图标，确保不重复使用')
[void]$out.AppendLine('6. **修改国策文件**：在 `common/national_focus/LFC.txt` 中修改 `icon = GFX_xxx`')
[void]$out.AppendLine('')
[void]$out.AppendLine('### 配套数据文件')
[void]$out.AppendLine('')
[void]$out.AppendLine('| 文件 | 用途 |')
[void]$out.AppendLine('|------|------|')
[void]$out.AppendLine('| `LFC_icon_assignments.csv` | 42 个国策分配表，机器可读 |')
[void]$out.AppendLine('| `_icon_chinese_labels.json` | 1,190 个图标的中文含义 JSON（程序化查询用）|')
[void]$out.AppendLine('| `_candidate_pool.tsv` | 92 类别 × 981 候选项分类表（制表符分隔，机器可读）|')
[void]$out.AppendLine('| `_summary_stats.json` | 最新统计数据（总量/分类/标注覆盖等）|')
[void]$out.AppendLine('| `_unmatched_names.json` | 未归类的 1,694 个图标名（改进分类用）|')
[void]$out.AppendLine('')
[void]$out.AppendLine('### 图标命名规则速查')
[void]$out.AppendLine('')
[void]$out.AppendLine('| 关键词 | 含义 | 关键词 | 含义 | 关键词 | 含义 |')
[void]$out.AppendLine('|--------|------|--------|------|--------|------|')
[void]$out.AppendLine('| `break_army` | 击溃陆军 | `battleship` | 战列舰 | `air_wing` | 空军联队 |')
[void]$out.AppendLine('| `army_purges` | 陆军清洗 | `carrier` | 航母 | `bomber` | 轰炸机 |')
[void]$out.AppendLine('| `army_elite` | 精锐部队 | `submarine` | 潜艇 | `fighter` | 战斗机 |')
[void]$out.AppendLine('| `national_defense` | 国防 | `naval_invasion` | 登陆作战 | `paratrooper` | 伞兵 |')
[void]$out.AppendLine('| `recruitment` | 动员征兵 | `sea_navy` | 海军航海 | `industrial` | 工业 |')
[void]$out.AppendLine('| `morale_bonus` | 士气加成 | `convoy` | 运输船队 | `construction` | 建筑工程 |')
[void]$out.AppendLine('| `multinational_army` | 多国联军 | `oil` | 石油 | `mining` | 采矿 |')
[void]$out.AppendLine('| `warfighting_tech` | 军事科技 | `rubber` | 橡胶 | `nuclear_energy` | 核能 |')
[void]$out.AppendLine('| `fortify` | 防御工事 | `coal` | 煤炭 | `radio` | 无线电 |')
[void]$out.AppendLine('| `tank` | 装甲坦克 | `steel/iron` | 钢铁 | `research` | 科研 |')
[void]$out.AppendLine('| `artillery` | 炮兵 | `gold` | 黄金 | `agriculture` | 农业 |')
[void]$out.AppendLine('| `infantry` | 步兵 | `diamond` | 钻石 | `trade` | 贸易 |')
[void]$out.AppendLine('| `diplomacy` | 外交 | `law` | 法律 | `parliament` | 议会 |')
[void]$out.AppendLine('| `intelligence` | 情报间谍 | `corruption` | 反腐调查 | `liberty` | 自由 |')
[void]$out.AppendLine('| `propaganda` | 宣传审查 | `independence` | 独立解放 | `backstab` | 背叛 |')
[void]$out.AppendLine('| `communist` | 共产主义 | `fascist` | 法西斯 | `democratic` | 民主主义 |')
[void]$out.AppendLine('| `housing` | 住房城市 | `road/highway` | 道路 | `railroad` | 铁路 |')
[void]$out.AppendLine('| `water/dam` | 水利 | `train_` | 铁路/训练 | `automobile` | 汽车 |')
[void]$out.AppendLine('| `all_resource` | 全部资源 | `continuous_extraction` | 持续开采 | `economics_reform` | 经济改革 |')
[void]$out.AppendLine('')
[void]$out.AppendLine('---')
[void]$out.AppendLine('')
[void]$out.AppendLine('## 完整对照表')
[void]$out.AppendLine('| # | 国策ID | 国策标题 | 图标 | 语义 | 来源 |')
[void]$out.AppendLine('|---|--------|---------|------|------|------|')

# Build assignment table from CSV
for ($i = 1; $i -lt $csvLines.Count; $i++) {
    $line = $csvLines[$i].Trim()
    if ($line -eq '') { continue }
    $parts = $line -split ','
    if ($parts.Count -ge 5) {
        [void]$out.AppendLine("| $i | ``$($parts[0])`` | $($parts[2]) | ``$($parts[1])`` | $($parts[3]) | $($parts[4]) |")
    }
}

[void]$out.AppendLine('')
[void]$out.AppendLine('---')
[void]$out.AppendLine('')
[void]$out.AppendLine('## 图标名速译（Pattern → 中文含义）')
[void]$out.AppendLine('当看到不认识的图标名时，按下表快速判断用途：')
[void]$out.AppendLine('')
[void]$out.AppendLine('| 英文关键词 | 中文含义 |')
[void]$out.AppendLine('|-----------|---------|')
[void]$out.AppendLine('| `break_army` / `smash_army` | 击溃陆军 |')
[void]$out.AppendLine('| `army_purges` / `purge_army` | 陆军清洗 |')
[void]$out.AppendLine('| `army_elite` / `elite_forces` | 精锐部队 |')
[void]$out.AppendLine('| `multinational_army` / `joint_army` | 多国联军 |')
[void]$out.AppendLine('| `national_defense_fund` / `defense_fund` | 国防基金 |')
[void]$out.AppendLine('| `morale_bonus` | 士气加成 |')
[void]$out.AppendLine('| `recruitment` / `mobilization` | 动员征兵 |')
[void]$out.AppendLine('| `train_` / `military_training` | 军事训练 |')
[void]$out.AppendLine('| `warfighting_technology` | 军事科技 |')
[void]$out.AppendLine('| `infantry` / `soldier` / `rifle` | 步兵 |')
[void]$out.AppendLine('| `tank` / `armor` / `panzer` / `mechanized` | 装甲/坦克 |')
[void]$out.AppendLine('| `artillery` / `cannon` | 炮兵 |')
[void]$out.AppendLine('| `fortify` / `fortress` / `bunker` / `trench` | 防御工事 |')
[void]$out.AppendLine('| `sea_navy` / `coastal_navy` / `navigate_the_seas` | 海军/航海 |')
[void]$out.AppendLine('| `battleship` / `capital_ship` | 战列舰 |')
[void]$out.AppendLine('| `carrier` / `naval_air` | 航母 |')
[void]$out.AppendLine('| `submarine` / `u_boat` | 潜艇 |')
[void]$out.AppendLine('| `naval_invasion` / `amphibious` / `landing` | 登陆作战 |')
[void]$out.AppendLine('| `air_wing` / `air_command` / `air_force` | 空军 |')
[void]$out.AppendLine('| `fighter` / `interceptor` | 战斗机 |')
[void]$out.AppendLine('| `bomber` / `strategic_bomb` | 轰炸机 |')
[void]$out.AppendLine('| `construction` / `public_works` | 建筑工程 |')
[void]$out.AppendLine('| `road` / `highway` | 道路 |')
[void]$out.AppendLine('| `railroad` / `railway` / `train_` | 铁路 |')
[void]$out.AppendLine('| `housing` / `urban` | 住房/城市化 |')
[void]$out.AppendLine('| `water` / `dam` / `irrigation` | 水利 |')
[void]$out.AppendLine('| `industrial` / `industrialisation` | 工业 |')
[void]$out.AppendLine('| `machinery` / `engineering` | 机械/工程 |')
[void]$out.AppendLine('| `automobile` | 汽车工业 |')
[void]$out.AppendLine('| `mining` / `coal` / `iron` / `extraction` | 采矿 |')
[void]$out.AppendLine('| `oil` / `petroleum` / `refinery` | 石油 |')
[void]$out.AppendLine('| `rubber` / `latex` | 橡胶 |')
[void]$out.AppendLine('| `nuclear_energy` / `nuclear_power` | 核能 |')
[void]$out.AppendLine('| `radio` / `radar` / `electronic` | 无线电/电子 |')
[void]$out.AppendLine('| `research` / `science` / `laboratory` | 科研 |')
[void]$out.AppendLine('| `economics_reform` / `tax` / `fiscal` | 经济改革 |')
[void]$out.AppendLine('| `agriculture` / `farming` / `crop` | 农业 |')
[void]$out.AppendLine('| `trade` / `commerce` / `export` / `import` | 贸易 |')
[void]$out.AppendLine('| `financial` / `growing_economy` / `market` | 经济/市场 |')
[void]$out.AppendLine('| `diplomacy` / `foreign` / `embassy` | 外交 |')
[void]$out.AppendLine('| `parliament` / `dissolve` / `congress` | 议会 |')
[void]$out.AppendLine('| `law` / `repeal` / `martial_law` | 法律/废法 |')
[void]$out.AppendLine('| `corruption` / `investigate` | 反腐/调查 |')
[void]$out.AppendLine('| `intelligence` / `spy` / `espionage` | 情报/间谍 |')
[void]$out.AppendLine('| `secret_documents` / `classified` | 机密文件 |')
[void]$out.AppendLine('| `communist` / `fascist` / `democratic` | 意识形态 |')
[void]$out.AppendLine('| `liberty` / `freedom` / `emancipation` | 自由/解放 |')
[void]$out.AppendLine('| `independence` / `liberation` / `sovereignty` | 独立/解放 |')
[void]$out.AppendLine('| `backstab` / `betrayal` | 背叛 |')
[void]$out.AppendLine('| `propaganda` / `press` / `censorship` | 宣传/审查 |')
[void]$out.AppendLine('| `unity` / `solidarity` | 团结/统一 |')
[void]$out.AppendLine('| `all_resource` / `continuous_extraction` | 资源开发 |')
[void]$out.AppendLine('| `gold` / `diamond` / `jungle_gold` | 黄金/钻石 |')
[void]$out.AppendLine('')
[void]$out.AppendLine('> **优先级**: mod注册图标（高）> 原版图标（低）')
[void]$out.AppendLine('> **避用**: `_shine` 后缀（发光特效变体）')
[void]$out.AppendLine('> **加分**: `generic_` 前缀的图标通常视觉简洁、通用性强')
[void]$out.AppendLine('')

# Build candidate pools from TSV
$prevCat = ''
for ($i = 1; $i -lt $tsvLines.Count; $i++) {
    $line = $tsvLines[$i].Trim()
    if ($line -eq '') { continue }
    $parts = $line -split "`t"
    $cat = $parts[0]
    $sub = $parts[1]
    $count = $parts[2]
    $items = @()
    for ($j = 3; $j -lt $parts.Count; $j++) {
        $items += $parts[$j]
    }

    $catKey = "$cat/$sub"
    $chineseName = if ($catNames.ContainsKey($catKey)) { $catNames[$catKey] } else { "$cat-$sub" }

    if ($cat -ne $prevCat -and $prevCat -ne '') {
        [void]$out.AppendLine('')
    }
    $prevCat = $cat

    [void]$out.AppendLine("---### $chineseName")
    [void]$out.AppendLine('')

    foreach ($item in $items) {
        $label = if ($labelMap.ContainsKey($item)) { $labelMap[$item] } else { '?' }
        [void]$out.AppendLine("- ``$item``{$label}")
    }
}

[void]$out.AppendLine('')
[void]$out.AppendLine('---')
[void]$out.AppendLine('')
[void]$out.AppendLine('## 更新日志')
[void]$out.AppendLine('- 2026-06-26: 初始生成，覆盖 42 个 LFC 国策')
[void]$out.AppendLine('- 2026-06-27: **增强更新**')
[void]$out.AppendLine('  - 新增「图标名速译」章节，支持从文件名快速判断图标用途')
[void]$out.AppendLine('  - 候选池图标追加中文标注')
[void]$out.AppendLine('  - 基于关键词分析 + 本地化反馈修正归类错误')
[void]$out.AppendLine('  - 新增拼音/中文命名图标识别')
[void]$out.AppendLine('- 2026-06-27: **全量分类重建**')
[void]$out.AppendLine('  - 候选池从 231 个扩充到 981 个（覆盖全部 10,432 注册图标的关键词分类）')
[void]$out.AppendLine('  - 纳入 5,432 个非标准命名图标（GFX_DVL_xxx, GFX_PAN_xxx 等）')
[void]$out.AppendLine('  - 92 个语义子类别自动分类（陆军/海军/空军/工业/资源/科技/经济/政治/社会）')
[void]$out.AppendLine('  - 新增 `_candidate_pool.tsv` 和 `_summary_stats.json` 配套数据文件')
[void]$out.AppendLine('  - 中文标签覆盖率提升（关键词 + 现有JSON双源匹配）')

# Write file
[System.IO.File]::WriteAllText($outFile, $out.ToString(), $utf8Bom)
Write-Output "Rebuilt!"
Write-Output ("Lines: " + $out.ToString().Split("`n").Count)
