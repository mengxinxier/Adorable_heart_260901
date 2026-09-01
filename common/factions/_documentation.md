<!-- 缩写说明（Abbreviations）
FI - Faction Initiative（派系主动权） -->

# Faction Goals
```
faction_goal_id = { # 派系目标ID（自定义唯一标识）
	name = [...] # 目标名称（本地化环境 = 派系 + 玩家国家，需配合本地化文本）
	description = [...] # 目标描述（本地化环境 = 派系 + 玩家国家，需配合本地化文本）
	category = [...] # 目标类别（可选值：short_term短期 / medium_term中期 / long_term长期）
	visible = {
		# 触发器 - 检查目标是否会显示在选择列表中
		# 作用域说明：SCOPE = ROOT = 派系领袖国 : 国家类型 / FROM = 派系成员国 : 国家类型
	}
	available = {
		# 触发器 - 检查目标是否可在选择列表中被选中
		# 作用域说明：SCOPE = ROOT = 派系领袖国 : 国家类型 / FROM = 派系成员国 : 国家类型
	}
	completed = {
		# 触发器 - 检查目标完成条件是否满足
		# 注意：若该字段为空，则目标永不完成！
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	group = # UI分类标识，用于筛选功能。UI资源对应GFX_group，本地化文本对应group_FACTION_GOAL_FILTER
	auto_complete = yes # 若进度达到100%，自动完成该目标（可选配置）
	
	ai_will_do = { # 若存在空闲目标槽位，派系领袖AI选择该目标的概率
		factor = 200 # 概率权重（数值越高，AI越倾向选择）
		# 作用域说明：SCOPE = 派系成员国 : 国家类型
	}
	complete_effect = {
		# 效果 - 目标完成时执行一次
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	
	cancel = {
		# 触发器 - 检查目标是否应从派系中移除
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	cancel_effect = {
		# 效果 - 目标被取消时执行一次
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	select_effect = {
		# 效果 - 目标被选中时执行一次（仅游戏开始后选中才触发）
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	remove_effect = {
		# 效果 - 目标被移除时执行一次（仅游戏开始后移除才触发）
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	# 注意：以下代码块为可选配置 - 仅适用于持续型目标！
	progress = {
		# 可通过定义不同进度段，为各阶段添加效果（如修饰符）
		# 配置方式如下：
		#progress_sections = {
		#  可定义任意数量的进度段，支持动态配置
		#  新增进度段格式：
		#  	SectionNameLoc = { # 进度段名称（本地化标识）
		#  	Min = 进度段起始值（例：0.1 表示进度达到10%时激活该段）
		#  	Max = 进度段结束值（例：0.5 表示进度超过50%时退出该段）
		#  	注意：若Section1的Max=0.5且Section2的Min=0.5，两段会同时激活
		#	
		#	Modifier = 该进度段激活时生效的修饰符
		#	Rule = 该进度段激活时生效的规则
		#	on_activate = 派系目标中此配置无效
		#   on_deactivate = 派系目标中此配置无效
		#	}
		# 
		#}
	}
	ratio_progress = {
		# 进度计算的扩展版本（适用于持续型目标）
		# 持续型目标的当前进度 = "已完成数量集合"的大小 / "总数量集合"的大小
		#
		# 注意：脚本化集合定义在 "common/collections" 目录下
		#
		# 示例：
		#    total_amount_collection = game:all_countries # 总数量集合 = 游戏中所有国家
		#    completed_amount_collection = democratic_countries # 已完成数量集合 = 实行民主制的国家
		#
		# 上述示例中，进度 = 全球民主制国家数量 / 全球总国家数量
		# 若所有国家均为民主制，进度为100%；若无民主制国家，进度为0%
		#
		# 集合作用域：SCOPE = 派系领袖国 : 国家类型
		#
		total_amount_collection = collection_id # 总数量集合（引用集合ID）
		completed_amount_collection = collection_id # 已完成数量集合（引用集合ID）
		
		# 可选方案：总数量和已完成数量也可设为固定值或变量
		total_amount = MY_VALUE # 固定总数量（自定义值）
		completed_amount = MY_OTHER_VALUE # 固定已完成数量（自定义值）
		
		# 注意事项：
		#  - 'total_amount' 和 'total_amount_collection' 互斥（二选一）
		#  - 'completed_amount' 和 'completed_amount_collection' 互斥（二选一）
		# 可选配置：定义上述比例与目标进度的映射关系
		#
		# 示例1：
		#
		#    range = { max = 0.75 }
		#
		# 含义：当比例≥0.75时，目标进度设为100%
		#
		# 示例2：
		#
		#    range = { min = 0.1 max = 0.8 }
		#
		# 含义：
		#  - 当比例≤0.1时，目标进度设为0%
		#  - 当比例≥0.8时，目标进度设为100%
		#
		# 补充说明：
		#  - min和max均为可选，默认值：min=0，max=1
		#  - min可大于max，此时比例降低则进度升高，反之亦然
		#
		range = { min = X max = Y } # 比例-进度映射配置（X=最小比例，Y=最大比例）
	}
}
```

# Faction Rules
```
faction_rule_id = { # 派系规则ID（自定义唯一标识）
	# 规则类型
	#  - 定义规则的适用场景
	#  - 决定规则触发器调用时的作用域
	#
	# 可自定义任意标识，但以下标识具有特殊含义：
	#
	#    joining_rule - 检查国家能否加入派系
	#        作用域：SCOPE = 申请加入国 : 国家类型
	#        作用域：FROM = 派系领袖国 : 国家类型
	#
	#    war_declaration_rule - 检查谁有权宣战
	#        作用域：SCOPE = 宣战国 : 国家类型
	#        作用域：FROM = 被宣战国 : 国家类型
	#	
	#	 call_to_war_rule - 检查谁有权号召参战
	#         作用域：SCOPE = 号召参战国 : 国家类型
	#         作用域：FROM = 被号召目标国 : 国家类型
	#
	#    member_rules - 检查成员国能否成为流亡政府
	#        作用域：SCOPE = 派系领袖国 : 国家类型
	#
	#	 change_leader_rules - 检查哪个国家可成为新派系领袖
	#	 	 作用域：SCOPE = 候选领袖国 : 国家类型
	#
	#    peace_conference_rules - 用于定义和平会议中生效的和平行动修饰符列表
	#
	# 规则名称的本地化环境：国家 + 派系
	#
	type = type_token # 规则类型标识（填入上述特殊标识或自定义标识）
	
	visible = {
		# 规则是否显示在列表中
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	available = {
		# 规则是否对派系可用
		# 注意：该配置不会阻止通过效果强制设置规则！
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	can_remove = {
		# 规则当前激活时，是否可被移除
		# 注意：该配置不会阻止通过效果强制移除规则！
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
	trigger = {
		# 注意：作用域取决于派系规则类型（详见上文类型说明）
	}
	modifier = {
		# 规则激活时生效的所有修饰符
	}
	# 引用和平会议中生效的和平行动修饰符
	# 和平行动修饰符定义在 "common/peace_conference/cost_modifiers" 目录下
	# 注意1：仅当 type = peace_conference_rules 时生效
	# 注意2：修饰符的启用触发器不生效 - 只要规则激活，修饰符就生效！
	peace_action_modifiers = {
		# 该组中的修饰符列表
	}
	
	ai_will_do = {
		# AI使用该规则的权重系数
		# 若数值≤0，AI不会使用该规则
		#
		# 作用域说明：SCOPE = 派系领袖国 : 国家类型
	}
}
```

# Faction Rule Groups
```
group_id = { # 规则组ID（自定义唯一标识）
	default_rule = rule_token # 该组的默认规则（引用规则标识）
	rules = {
		# 组内规则列表
		# 注意：可为数据库引用（已有规则ID）或内联定义（直接写规则配置）
	}
}
```

# Faction Templates
```
faction_template_id = { # 派系模板ID（自定义唯一标识）
	name = [...] # 派系名称（需配合本地化文本）
	
	visible = {
		# 检查模板在国家创建新派系时是否显示
		# 若字段为空，则模板不显示（适用于仅通过脚本创建的派系模板）
		# 
		# 作用域说明：SCOPE = 创建派系的国家 : 国家类型
	}
	
	available = {
		# 检查模板在国家创建新派系时是否可选择
		# 若字段为空，则模板在显示时始终可用
		#
		# 作用域说明：SCOPE = 创建派系的国家 : 国家类型
	}
    can_leader_join_other_factions = yes # 允许该派系领袖加入其他派系
	# 补充说明：若领袖加入新派系，将解散当前派系，并邀请所有符合加入条件的成员国加入新派系
	manifest = faction_goal_id # 主要目标（派系宣言，引用派系目标ID）
	goals = {
		# 派系初始目标列表
		# 注意：可为数据库引用（已有目标ID）或内联定义（直接写目标配置）
	}
	default_rules = {
		# 默认启用的规则列表
		# 该配置会覆盖规则组中定义的默认规则
	}
}
```

触发器与效果（Triggers and Effects）
派系相关效果列表（List of faction-related effects）
create_faction - 创建无模板的派系（已过时，不推荐使用）
create_faction_from_template - 推荐使用：通过模板创建派系
dismantle_faction - 解散派系
set_faction_leader - 更换派系领袖
set_faction_spymaster - 更换派系间谍主管
set_faction_name - 更改派系名称
add_to_faction - 将某个国家加入派系
remove_from_faction - 将某个国家移出派系
leave_faction - 当前国家退出派系
set_faction_rule - 为派系设置规则
set_faction_manifest - 更改派系宣言（主要目标）
add_faction_goal - 为派系添加目标
remove_faction_goal - 从派系中移除目标
add_faction_initiative - 为派系添加 FI（派系主动权）
add_faction_power_projection - 为派系添加权力投射
add_faction_influence_score - 为当前国家增加在派系中的影响力分数
add_faction_influence_ratio - 按派系总影响力的指定比例，为当前国家增加影响力

派系相关触发器列表（List of faction-related triggers）
faction_manifest_fulfillment - 对比当前国家所属派系的宣言完成度与目标值
has_faction_template - 检查当前国家是否属于通过模板创建的派系
faction_power_projection - 对比当前国家所属派系的权力投射与目标值
faction_influence_score - 检查当前国家在派系中的影响力分数
faction_influence_ratio - 检查当前国家在派系中的影响力占比
faction_influence_rank - 检查当前国家在派系中的影响力排名
has_faction_goal - 检查当前国家所属派系是否有活跃或已完成的目标
has_completed_faction_goal - 检查当前国家所属派系是否已完成某个目标
faction_goal_fulfillment - 检查当前国家所属派系的某个目标完成度
has_manpower_to_become_leader - 检查当前国家的部署人力是否超过现任派系领袖及其附庸国
has_industry_to_become_leader - 检查当前国家的工厂数量是否超过现任派系领袖

派系相关修饰符列表（List of faction-related modifiers）
faction_influence_war_score_factor - 影响力相关的战争分数修饰符
faction_influence_industrial_capacity_factor - 影响力相关的工业产能修饰符
faction_influence_garrison_support_provider_factor - 影响力相关的驻军支援提供方修饰符
faction_influence_garrison_support_reciver_factor - 影响力相关的驻军支援接收方修饰符（注：原文 reciver 应为 receiver，保留原文拼写）
faction_influence_expeditionary_force_provider_factor - 影响力相关的远征军提供方修饰符
faction_influence_expeditionary_force_reciver_factor - 影响力相关的远征军接收方修饰符（注：原文 reciver 应为 receiver，保留原文拼写）

定义（Defines）
NFactions 模块
FACTION_INITIATIVE_CHANGE_RULE_COST - 更改派系规则所需的 FI（派系主动权）成本
控制台命令（Console Commands）
faction_initiative X - 向当前玩家所属派系添加 X 点 FI（派系主动权）（简写："fi X"）
派系成员升级（Faction Member Upgrades）
Faction_Member_Upgrade_Id = { # 派系成员升级项 ID（自定义唯一标识）name = 激活时显示在界面上的名称（本地化文本键），将覆盖升级组的名称desc = 激活时显示在界面上的描述（本地化文本键），将覆盖升级组的描述icon = 激活时显示的图标，将覆盖升级组的图标upgrade_cost = 用其他升级项替换该升级时所需的派系主动权数量bonus = 数值型加成，具体效果取决于升级类型}
派系成员升级组（Faction Member Upgrade Group）
Faction_Upgrade_Group_Id = { # 升级组 ID（自定义唯一标识）name = 界面显示的默认名称（本地化文本键）desc = 界面显示的默认描述（本地化文本键）icon = 默认显示的图标upgrades = {该组内的派系升级项列表，将按加成数值排序}
有代码支持的派系成员升级类型列表
faction_member_upgrade_manpower = 加成效果：将本国人力的指定百分比转入派系人力池}

# AI Faction Initiative Spending

AI spending of faction initiative can be affected by AI strategies like such:
```
default_add_faction_facility = {
	enable = {
		always = yes # 始终启用该策略
	}
	abort_when_not_enabled = yes # 未启用时终止策略
	ai_strategy = {
		type = spent_faction_initiative_priority # 策略类型：派系主动权花费优先级
		id = program # <---- 指定FI的花费用途（详见下方有效ID列表）
		value = 5 # 优先级数值（越高越优先）
	}
}
```
Valid ids are:
```
program # 方案研发
unlock_doctrine_sharing # 解锁学说共享
unlock_faction_commander # 解锁派系指挥官
```

Intel Advisors work a bit differently, and use custom AI strategy types, e.g:
```
default_become_spymaster_minor = {
	allowed = {
		has_dlc = "La Resistance" # 要求拥有DLC《抵抗运动》
	}
	enable = {
		is_major = no # 仅非主要国家启用
	}
	abort_when_not_enabled = yes # 未启用时终止策略
	ai_strategy = {
		type = become_spymaster # 策略类型：成为间谍主管
		value = 2 # 优先级数值
	}
}
```
Valid types are:
```
become_spymaster # 成为间谍主管
become_head_of_crypto # 成为密码学主管
become_head_of_counter_intel # 成为反情报主管
become_head_of_operations # 成为行动主管
```
Faction Rules initiative spending priority are scripted in the faction rules themselves (ai_will_do)  ###派系规则的主动权花费优先级，在派系规则自身的ai_will_do字段中配置。