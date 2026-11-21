-- Stratholme (map 329), Main Gate, 2026-11-21: the Scarlet Cannons do nothing.
--
-- Found: Four (screenshots): after Willey Hopebreaker 10997 dies, seven Risen Riflemen 11054 line up down the
--   hall (his JustDied summons them for 4 minutes). A Scarlet Cannonball from a Cannonball Stack 176215
--   loads into a Scarlet Cannon 176216/176217, the cannon animates, and nothing else happens.
-- Cause: the cannons have AIName SmartGameObjectAI but no smart_scripts rows (Pandaria 5.4.8 has none
--   either). The blast spell Cannon Fire 17278 and its landing spot (spell_target_position, 30 yards
--   around 3534 -2967) are in place; nothing casts it, and nothing makes the Riflemen die from it.
-- Changed (as AzerothCore does it):
--   1. Loading a cannon makes the player cast Cannon Fire 17278 (triggered).
--   2. Cannon Fire only hits Risen Riflemen (condition), so the Risen Defenders and Sorcerers standing
--      in that hall are not pulled.
--   3. A Risen Rifleman hit by Cannon Fire dies (id 8).

-- 1. Cannons
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (176216, 176217) AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(176216, 1, 0, 0, 64, 0, 100, 0, 1, 0, 0, 0, 0, 86, 17278, 2, 7, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Scarlet Cannon - On Use - Invoker Casts Cannon Fire'),
(176217, 1, 0, 0, 64, 0, 100, 0, 1, 0, 0, 0, 0, 86, 17278, 2, 7, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Scarlet Cannon - On Use - Invoker Casts Cannon Fire');

-- 2. Cannon Fire hits Risen Riflemen only
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 17278;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 17278, 0, 0, 31, 0, 3, 11054, 0, 0, 0, 0, '', 'Cannon Fire - Target Risen Rifleman');

-- 3. Riflemen die from it
DELETE FROM `smart_scripts` WHERE `entryorguid` = 11054 AND `source_type` = 0 AND `id` = 8;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11054, 0, 8, 0, 8, 0, 100, 0, 17278, 0, 0, 0, 0, 37, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Risen Rifleman - On Spellhit Cannon Fire - Die');

-- Check
SELECT CONCAT('Cannon rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` IN (176216, 176217) AND `source_type` = 1),
              ', Cannon Fire condition ', (SELECT COUNT(*) FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 17278),
              ', Rifleman die row ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 11054 AND `source_type` = 0 AND `action_type` = 37),
              ', landing spot ', (SELECT COUNT(*) FROM `spell_target_position` WHERE `ID` = 17278)) AS `stratholme_cannons`;
