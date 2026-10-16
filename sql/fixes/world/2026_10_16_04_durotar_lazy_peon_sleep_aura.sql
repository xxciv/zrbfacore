-- Durotar, Valley of Trials: Lazy Peons (10556) say "Invalid target" to the Foreman's Blackjack.
-- Awaken Peon (19938) only accepts a target that has Peon Sleeping (17743): the core checks it in
-- Spell::CheckCast and the spell condition (conditions 17/19938) checks it too. Since core update
-- 2026_09_20_valley_of_trials_cosmetic_improvements.sql the peon's SmartAI adds 17743 once, on reset
-- (spawn and evade), and lies down with stand state 3. The old C++ script (npc_lazy_peon, removed
-- by update 2026_08_06_00) recast 17743 every 5 minutes, because the aura runs out. Once it runs out
-- the peon keeps lying there (the stand state stays) but can't be hit with the blackjack anymore.
-- Fix: event phase 1 while asleep, phase 2 while working, and re-add 17743 every 30 s while in
-- phase 1 and out of combat. The rest of the script (rows 0-6 and action list 1055600) is unchanged.
-- Revert:
-- UPDATE `smart_scripts` SET `link` = 0 WHERE `entryorguid` = 10556 AND `source_type` = 0 AND `id` IN (1, 6);
-- DELETE FROM `smart_scripts` WHERE `entryorguid` = 10556 AND `source_type` = 0 AND `id` IN (7, 8, 9);
UPDATE `smart_scripts` SET `link` = 7 WHERE `entryorguid` = 10556 AND `source_type` = 0 AND `id` = 1;
UPDATE `smart_scripts` SET `link` = 8 WHERE `entryorguid` = 10556 AND `source_type` = 0 AND `id` = 6;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10556 AND `source_type` = 0 AND `id` IN (7, 8, 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10556, 0, 7, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lazy Peon - On Reset - Set Event Phase 1 (asleep)'),
(10556, 0, 8, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lazy Peon - Wake - Set Event Phase 2 (working)'),
(10556, 0, 9, 0, 1, 1, 100, 0, 30000, 30000, 30000, 30000, 0, '', 75, 17743, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lazy Peon - OOC every 30 s while asleep (phase 1) - Re-add Peon Sleeping 17743');
