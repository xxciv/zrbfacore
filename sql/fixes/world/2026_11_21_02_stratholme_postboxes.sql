-- Stratholme (map 329), 2026-11-21: clicking a postbox does nothing.
--
-- Found: Four: none of the six postboxes summoned anything.
-- Cause: each postbox (176346, 176349-176353) has an "On Activate - Start Script" row that runs action list
--   17634600 .. 17635300, but the dump has none of those lists, so the click ran an empty script.
--   Since Cataclysm Postmaster Malown 11143 is a normal boss standing in Crusaders' Square (static spawn
--   here, as in Pandaria 5.4.8); the postboxes only call three Undead Postmen 11142 each.
-- Changed: the six action lists copied from Pandaria 5.4.8 (three Undead Postmen per postbox, at the
--   sniffed spots next to it, despawn after 5 minutes if not killed). The postbox rows are made
--   not-repeatable (event_flags 1), so one postbox calls its postmen once per instance.

DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 17634600 AND 17635399 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(17634600, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3675.35, -3395.92, 132.86, 5.83, 'Market Row Postbox - On Script - Summon Creature ''Undead Postman'''),
(17634600, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3679.93, -3408.58, 133.18, 1.04, 'Market Row Postbox - On Script - Summon Creature ''Undead Postman'''),
(17634600, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3687.89, -3410.59, 133.04, 1.64, 'Market Row Postbox - On Script - Summon Creature ''Undead Postman'''),
(17634900, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3664.55, -3176.47, 126.42, 2.2, 'Crusaders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17634900, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3656.82, -3160.63, 129.03, 4.84, 'Crusaders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17634900, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3644.62, -3168.25, 128.52, 5.93, 'Crusaders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635000, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3651.67, -3477.88, 138.05, 5.59, 'Festival Lane Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635000, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3657.14, -3475.36, 138.7, 4.91, 'Festival Lane Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635000, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3669.61, -3478.49, 137.49, 3.39, 'Festival Lane Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635100, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3659.46, -3634.96, 138.33, 1.28, 'Elders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635100, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3656.25, -3635.08, 138.36, 1.02, 'Elders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635100, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3661.24, -3621, 138.4, 3.58, 'Elders'' Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635200, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3568.5, -3356.91, 131.06, 2.07, 'King''s Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635200, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3570.91, -3351.01, 130.57, 2.71, 'King''s Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635200, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3562.79, -3353.38, 130.78, 0.81, 'King''s Square Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635300, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3493, -3300.28, 130.47, 0.07, 'Fras Siabi''s Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635300, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3503.16, -3294.9, 131.09, 4.28, 'Fras Siabi''s Postbox - On Script - Summon Creature ''Undead Postman'''),
(17635300, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 12, 11142, 1, 300000, 0, 1, 0, 8, 0, 0, 0, 3496.26, -3295.4, 130.98, 5.34, 'Fras Siabi''s Postbox - On Script - Summon Creature ''Undead Postman''');

UPDATE `smart_scripts` SET `event_flags` = `event_flags` | 1 WHERE `entryorguid` IN (176346, 176349, 176350, 176351, 176352, 176353) AND `source_type` = 1 AND `id` = 0 AND `event_type` = 70;

-- Check
SELECT CONCAT('Postbox action list rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` BETWEEN 17634600 AND 17635399 AND `source_type` = 9),
              ', postbox start rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` IN (176346, 176349, 176350, 176351, 176352, 176353) AND `source_type` = 1 AND `action_type` = 80 AND `event_flags` & 1)) AS `stratholme_postboxes`;
