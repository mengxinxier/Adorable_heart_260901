# Validation Repair Context

- schema: `hoi4skill.validation_repair_context.v1`
- status: `needs_repair`
- mod_root: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901`
- game_root: `D:\SteamLibrary\steamapps\common\Hearts of Iron IV`
- effective_errors: `6276`
- effective_warnings: `49654`
- code_example_retrieval: `ok` (libraries: `1`)

## AI Rules

- Treat every repair item as blocking until strict validation passes.
- Use only indexed candidates, explicitly authorized dependency/user-mod examples, explicit user-provided symbols, or CLI-generated patch plans.
- If candidates are empty or ambiguous, ask the user or run `check-code-symbol` / `code-catalog` before writing code.
- Do not delete player-visible user text to hide text-alignment failures.
- Do not replace dynamic modifiers with national spirits unless the user explicitly changes the design.

## Repair Items

### 1. validation_error

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: unbalanced braces, final depth 2`
- required_action: `Fix the reported file without inventing syntax, then rerun strict validation and this repair-context command.`

Related indexed code:
- `triggers` / `trigger`: `or`
- `ideas` / `idea`: `pps`
- `ideas` / `idea`: `x`
- `sprites` / `resource_id`: `x`
- `country_tags` / `resource_id`: `BRA`
- `country_tags` / `resource_id`: `BAL`
- `country_tags` / `resource_id`: `CES`
- `country_tags` / `resource_id`: `COM`

Repair queries:
- `pps`
- `BRA`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: unbalanced braces, final depth 2`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 2. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `slot`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'slot'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'AUS_propaganda_poster_slot_available', triggers/trigger 'KMK_propaganda_poster_slot_available', triggers/trigger 'LUG_propaganda_poster_slot_available', triggers/trigger 'SIA_propaganda_poster_slot_available', triggers/trigger 'SOV_propaganda_poster_slot_available'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `AUS_propaganda_poster_slot_available`
- `triggers` / `trigger`: `KMK_propaganda_poster_slot_available`
- `triggers` / `trigger`: `LUG_propaganda_poster_slot_available`
- `triggers` / `trigger`: `SIA_propaganda_poster_slot_available`
- `triggers` / `trigger`: `SOV_propaganda_poster_slot_available`
- `triggers` / `trigger`: `TAM_champion_slot_available`
- `triggers` / `trigger`: `YSS_propaganda_poster_slot_available`
- `triggers` / `trigger`: `amount_research_slots`

Repair queries:
- `slot`
- `AUS_propaganda_poster_slot_available`
- `KMK_propaganda_poster_slot_available`
- `LUG_propaganda_poster_slot_available`
- `SIA_propaganda_poster_slot_available`
- `SOV_propaganda_poster_slot_available`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'slot'; use a real trigger from 'documentation/triggers_documentatio
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol slot`
- `hoi4skill query-clausewitz-library --query slot --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 3. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `idea_token`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'idea_token'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'has_idea', triggers/trigger 'JAP_has_idea_JAP_intervene_in_china', triggers/trigger 'has_idea_with_trait', triggers/trigger 'CZE_has_neutrality_idea', triggers/trigger 'has_a_german_trade_idea'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `has_idea`
- `triggers` / `trigger`: `JAP_has_idea_JAP_intervene_in_china`
- `triggers` / `trigger`: `has_idea_with_trait`
- `triggers` / `trigger`: `CZE_has_neutrality_idea`
- `triggers` / `trigger`: `has_a_german_trade_idea`
- `triggers` / `trigger`: `has_allowed_idea_with_traits`
- `triggers` / `trigger`: `has_available_idea_with_traits`
- `triggers` / `trigger`: `has_operation_token`

Repair queries:
- `idea_token`
- `has_idea`
- `JAP_has_idea_JAP_intervene_in_china`
- `has_idea_with_trait`
- `CZE_has_neutrality_idea`
- `has_a_german_trade_idea`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'idea_token'; use a real trigger from 'documentation/triggers_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol idea_token`
- `hoi4skill query-clausewitz-library --query idea_token --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 4. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `traits`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'traits'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'has_allowed_idea_with_traits', triggers/trigger 'has_available_idea_with_traits', triggers/trigger 'has_mio_number_of_completed_traits', triggers/trigger 'date', triggers/trigger 'exists'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `has_allowed_idea_with_traits`
- `triggers` / `trigger`: `has_available_idea_with_traits`
- `triggers` / `trigger`: `has_mio_number_of_completed_traits`
- `triggers` / `trigger`: `date`
- `triggers` / `trigger`: `exists`
- `triggers` / `trigger`: `state`
- `triggers` / `trigger`: `tag`
- `triggers` / `trigger`: `threat`

Repair queries:
- `traits`
- `has_allowed_idea_with_traits`
- `has_available_idea_with_traits`
- `has_mio_number_of_completed_traits`
- `date`
- `exists`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'traits'; use a real trigger from 'documentation/triggers_documentat
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol traits`
- `hoi4skill query-clausewitz-library --query traits --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 5. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `slot`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'slot'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'AUS_propaganda_poster_slot_available', triggers/trigger 'KMK_propaganda_poster_slot_available', triggers/trigger 'LUG_propaganda_poster_slot_available', triggers/trigger 'SIA_propaganda_poster_slot_available', triggers/trigger 'SOV_propaganda_poster_slot_available'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `AUS_propaganda_poster_slot_available`
- `triggers` / `trigger`: `KMK_propaganda_poster_slot_available`
- `triggers` / `trigger`: `LUG_propaganda_poster_slot_available`
- `triggers` / `trigger`: `SIA_propaganda_poster_slot_available`
- `triggers` / `trigger`: `SOV_propaganda_poster_slot_available`
- `triggers` / `trigger`: `TAM_champion_slot_available`
- `triggers` / `trigger`: `YSS_propaganda_poster_slot_available`
- `triggers` / `trigger`: `amount_research_slots`

Repair queries:
- `slot`
- `AUS_propaganda_poster_slot_available`
- `KMK_propaganda_poster_slot_available`
- `LUG_propaganda_poster_slot_available`
- `SIA_propaganda_poster_slot_available`
- `SOV_propaganda_poster_slot_available`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'slot'; use a real trigger from 'documentation/triggers_documentatio
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol slot`
- `hoi4skill query-clausewitz-library --query slot --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 6. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `idea_token`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'idea_token'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'has_idea', triggers/trigger 'JAP_has_idea_JAP_intervene_in_china', triggers/trigger 'has_idea_with_trait', triggers/trigger 'CZE_has_neutrality_idea', triggers/trigger 'has_a_german_trade_idea'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `has_idea`
- `triggers` / `trigger`: `JAP_has_idea_JAP_intervene_in_china`
- `triggers` / `trigger`: `has_idea_with_trait`
- `triggers` / `trigger`: `CZE_has_neutrality_idea`
- `triggers` / `trigger`: `has_a_german_trade_idea`
- `triggers` / `trigger`: `has_allowed_idea_with_traits`
- `triggers` / `trigger`: `has_available_idea_with_traits`
- `triggers` / `trigger`: `has_operation_token`

Repair queries:
- `idea_token`
- `has_idea`
- `JAP_has_idea_JAP_intervene_in_china`
- `has_idea_with_trait`
- `CZE_has_neutrality_idea`
- `has_a_german_trade_idea`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'idea_token'; use a real trigger from 'documentation/triggers_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol idea_token`
- `hoi4skill query-clausewitz-library --query idea_token --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 7. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt`
- kind: `trigger`
- symbol: `traits`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'traits'; use a real trigger from 'documentation/triggers_documentation.md' or a verified scripted trigger; related indexed code: triggers/trigger 'has_allowed_idea_with_traits', triggers/trigger 'has_available_idea_with_traits', triggers/trigger 'has_mio_number_of_completed_traits', triggers/trigger 'date', triggers/trigger 'exists'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `triggers` / `trigger`: `has_allowed_idea_with_traits`
- `triggers` / `trigger`: `has_available_idea_with_traits`
- `triggers` / `trigger`: `has_mio_number_of_completed_traits`
- `triggers` / `trigger`: `date`
- `triggers` / `trigger`: `exists`
- `triggers` / `trigger`: `state`
- `triggers` / `trigger`: `tag`
- `triggers` / `trigger`: `threat`

Repair queries:
- `traits`
- `has_allowed_idea_with_traits`
- `has_available_idea_with_traits`
- `has_mio_number_of_completed_traits`
- `date`
- `exists`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\characters\kivotos.txt: trigger context 'available' uses unknown trigger 'traits'; use a real trigger from 'documentation/triggers_documentat
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind trigger --symbol traits`
- `hoi4skill query-clausewitz-library --query traits --system trigger`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 8. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\country_leader\RAE_traits.txt`
- kind: `effect`
- symbol: `experience_gain_army_factor`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\country_leader\RAE_traits.txt: effect context 'hidden_effect' uses unknown effect 'experience_gain_army_factor'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'add_mio_funds_gain_factor', effects/effect 'army_experience', effects/effect 'set_mio_funds_gain_factor', effects/effect 'AI_setting_clr_army', effects/effect 'AI_setting_get_army'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `add_mio_funds_gain_factor`
- `effects` / `effect`: `army_experience`
- `effects` / `effect`: `set_mio_funds_gain_factor`
- `effects` / `effect`: `AI_setting_clr_army`
- `effects` / `effect`: `AI_setting_get_army`
- `effects` / `effect`: `AI_setting_get_army_division_template`
- `effects` / `effect`: `gain_xp`
- `effects` / `effect`: `onm_army_ui_set_1_0_to_lv_0`

Repair queries:
- `experience_gain_army_factor`
- `add_mio_funds_gain_factor`
- `army_experience`
- `set_mio_funds_gain_factor`
- `AI_setting_clr_army`
- `AI_setting_get_army`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\country_leader\RAE_traits.txt: effect context 'hidden_effect' uses unknown effect 'experience_gain_army_factor'; use a real effect from 'docu
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol experience_gain_army_factor`
- `hoi4skill query-clausewitz-library --query experience_gain_army_factor --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 9. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH1`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH1'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH1`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH1'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH1`
- `hoi4skill query-clausewitz-library --query DH1 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 10. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH6`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH6'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH6`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH6'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH6`
- `hoi4skill query-clausewitz-library --query DH6 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 11. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH2`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH2'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH2`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH2'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH2`
- `hoi4skill query-clausewitz-library --query DH2 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 12. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH3`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH3'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH3`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH3'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH3`
- `hoi4skill query-clausewitz-library --query DH3 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 13. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH4`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH4'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH4`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH4'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH4`
- `hoi4skill query-clausewitz-library --query DH4 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 14. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH5`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH5'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH5`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH5'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH5`
- `hoi4skill query-clausewitz-library --query DH5 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 15. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH7`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH7'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH7`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH7'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH7`
- `hoi4skill query-clausewitz-library --query DH7 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 16. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH9`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH9'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH9`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'complete_effect' uses unknown effect 'DH9'; use a real effect from 'documentation/effects_docume
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH9`
- `hoi4skill query-clausewitz-library --query DH9 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 17. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH1`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH1'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH1`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH1'; use a real effect from 'documentation/effects_document
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH1`
- `hoi4skill query-clausewitz-library --query DH1 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 18. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH6`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH6'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH6`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH6'; use a real effect from 'documentation/effects_document
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH6`
- `hoi4skill query-clausewitz-library --query DH6 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 19. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH2`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH2'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH2`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH2'; use a real effect from 'documentation/effects_document
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH2`
- `hoi4skill query-clausewitz-library --query DH2 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`

### 20. unindexed_code_symbol

- blocking: `true`
- file: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt`
- kind: `effect`
- symbol: `DH3`
- message: `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH3'; use a real effect from 'documentation/effects_documentation.md' or a verified scripted effect; related indexed code: effects/effect 'if', effects/effect 'log', effects/effect 'test'`
- required_action: `Replace the symbol with an indexed candidate, generate the missing declared asset/system through a dedicated CLI command, or ask the user for an explicit mapping.`

Related indexed code:
- `effects` / `effect`: `if`
- `effects` / `effect`: `log`
- `effects` / `effect`: `test`

Repair queries:
- `DH3`
- `log`
- `test`
- `D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901\common\decisions\CHI_decisions.txt: effect context 'hidden_effect' uses unknown effect 'DH3'; use a real effect from 'documentation/effects_document
... <truncated> ...`

Do not fix by:
- do not invent a Clausewitz key that is absent from the code index
- do not silence the error by deleting user-requested player-visible content
- do not skip final validation or downgrade strict-code-index

Suggested commands:
- `hoi4skill check-code-symbol --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --kind effect --symbol DH3`
- `hoi4skill query-clausewitz-library --query DH3 --system effect`
- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index`


## Required Next Commands

- `hoi4skill validate "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --strict-code-index --output .hoi4skill/validation.json`
- `hoi4skill validate-repair-context "D:\SteamLibrary\steamapps\workshop\content\394360\Adorable_heart_260901" --game-root "D:\SteamLibrary\steamapps\common\Hearts of Iron IV" --output .hoi4skill/ai_repair_context.json --markdown-output .hoi4skill/ai_repair_context.md`

## Anti Hallucination Rule

If a symbol, syntax, scope, picture, idea, or modifier is absent from this context and strict code index, fail or ask instead of inventing Clausewitz code.
