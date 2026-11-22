-- Blackrock Depths (map 230): Hurley Blackbreath's keg event, 2026-11-22. Goes with 2026_11_22_06.
--
-- Four, 2026-11-22: "hurleys keg event doesn't trigger after breaking 3 kegs".
--
-- The Thunderbrew Lager Kegs (164911) from 2026_11_22_06 counted breaks by telling each other (SAI target 13,
-- game objects in range), and the third keg woke Hurley. In this core target 13 never finds anything when an
-- entry is given (SmartScript.cpp tests `!entry && GetEntry() == entry` where creature range tests
-- `!entry || ...`), so no keg was ever counted and Hurley stayed hidden. Now each broken keg tells Hurley
-- (target 9, creature range, which works), Hurley counts with his event phase, and the third break wakes him
-- exactly as before (visible, cronies, "Get away from those kegs!", walk to the kegs, fight).
-- Hurley stands 37 yards from the kegs, inside the 50 yard reach.
-- Backup: zr_backup_brd_smart_scripts already holds the rows from before 2026_11_22_06.

-- Kegs: tell Hurley on every break
DELETE FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` = 164911;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(164911, 1, 0, 0, 70, 0, 100, 0, 2, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 9, 9537, 0, 50, 'Thunderbrew Lager Keg - On Use - Tell Hurley Blackbreath');

-- Hurley: row 3 now counts a broken keg; the old wake-up chain starts from row 21 on the third one (phase 3 = mask 4)
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9537 AND `id` IN (3, 21);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(9537, 0, 3, 0, 38, 0, 100, 256, 1, 1, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Data 1 1 (keg broken) - Count it'),
(9537, 0, 21, 4, 38, 4, 100, 257, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Data 1 1 after the third keg - Visible');

-- Check
SELECT CONCAT('Keg rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` = 164911),
    ', keg rows aimed at Hurley ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` = 164911 AND `target_type` = 9 AND `target_param1` = 9537),
    ', Hurley rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9537),
    ', Hurley wake row ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9537 AND `id` = 21 AND `link` = 4 AND `event_phase_mask` = 4)) AS `check`;
