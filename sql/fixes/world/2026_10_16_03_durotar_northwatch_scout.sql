-- Durotar, Valley of Trials: Northwatch Scout (39317) never melees, only casts Fan of Knives.
-- The dump has 23 smart_scripts rows for 39317 from two different script versions mixed
-- together. On aggro, the old link chain (ids 0 -> 1 -> 2) runs action 20 (SMART_ACTION_AUTO_ATTACK)
-- with 0, which turns melee off for the whole fight. The rows that turn it back on (ids 4-15)
-- all have event_phase_mask 1, and nothing ever sets phase 1, so they never run. Shoot (6660)
-- has a minimum range, so in melee range the only thing left that works is Fan of Knives.
-- Id 16 talks group 0, but 39317 has no creature_text, so it did nothing.
-- New script: stealth on spawn and after evade, normal melee, Shoot when the target is
-- 5-30 yards away, Fan of Knives every 15-22 s when the target is within 8 yards.
-- Faction 190 (neutral) is unchanged: it is sniffed data from build 35662, and every other mob in
-- Valley of Trials is neutral too (faction 7).
-- Revert: re-import the 39317 smart_scripts rows from dumps/bfa_world.sql.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 39317 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39317, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 58506, 32, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Northwatch Scout - On Reset - Cast Stealth'),
(39317, 0, 1, 0, 9, 0, 100, 0, 5, 30, 2300, 3900, 0, '', 11, 6660, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Northwatch Scout - Within 5-30 Range - Cast Shoot'),
(39317, 0, 2, 0, 9, 0, 100, 0, 0, 8, 15000, 22000, 0, '', 11, 79584, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Northwatch Scout - Within 0-8 Range - Cast Fan of Knives');
