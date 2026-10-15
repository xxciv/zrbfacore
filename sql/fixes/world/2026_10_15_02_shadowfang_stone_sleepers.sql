-- Shadowfang Keep: the Stone Sleepers (3870) on the wall walk never come to life.
--
-- Stone Sleepers are gargoyles that sit as stone on the battlements and wake up when
-- someone walks past ("A nearby Gargoyle comes to life!", broadcast text 47423). In
-- HavenCore their SmartAI set every unit flag there is (16777215) on spawn, including
-- NOT_SELECTABLE and IMMUNE_TO_PC, and only cleared them on aggro, which can't happen
-- with those flags. So all four stayed inert for good.
--
-- Now a sleeper is unselectable and immune to players (NOT_SELECTABLE | IMMUNE_TO_PC,
-- 33554688) while it sleeps. When a hostile unit comes within 15 yards in line of
-- sight it wakes, emotes the line above and attacks that unit. After a reset it goes
-- back to sleep. The Normal and Heroic fear spells are unchanged.
--
-- Revert:
--   DELETE FROM smart_scripts WHERE entryorguid = 3870 AND source_type = 0;
--   INSERT INTO smart_scripts (entryorguid, source_type, id, link, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, event_param5, event_param_string, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, target_type, target_param1, target_param2, target_param3, target_x, target_y, target_z, target_o, comment) VALUES
--   (3870, 0, 0, 0, 1, 0, 100, 7, 0, 0, 0, 0, 0, '', 18, 16777215, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Set Unit Flag on Spawn'),
--   (3870, 0, 1, 4, 4, 0, 100, 7, 0, 0, 0, 0, 0, '', 19, 16777215, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Remove Unit Flag on Aggro'),
--   (3870, 0, 2, 0, 0, 0, 100, 2, 2000, 4500, 12000, 20000, 0, '', 11, 30615, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Cast Fear'),
--   (3870, 0, 3, 0, 0, 0, 100, 4, 2000, 4500, 12000, 20000, 0, '', 11, 38595, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Cast Fear'),
--   (3870, 0, 4, 0, 61, 0, 100, 7, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Say Text on Aggro');
--   DELETE FROM creature_text WHERE CreatureID = 3870;
--
-- Safe to run twice. worldserver reads these tables only at startup: restart it
-- after running this.

DELETE FROM `smart_scripts` WHERE `entryorguid` = 3870 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3870, 0, 0, 0, 1, 0, 100, 7, 0, 0, 0, 0, 0, '', 18, 33554688, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - Out of combat - Sleep (not selectable, immune to players)'),
(3870, 0, 1, 4, 10, 0, 100, 7, 0, 15, 0, 0, 0, '', 19, 33554688, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - Hostile within 15 yards - Wake up'),
(3870, 0, 2, 0, 0, 0, 100, 2, 2000, 4500, 12000, 20000, 0, '', 11, 30615, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - In combat - Cast Fear (Normal)'),
(3870, 0, 3, 0, 0, 0, 100, 4, 2000, 4500, 12000, 20000, 0, '', 11, 38595, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - In combat - Cast Fear (Heroic)'),
(3870, 0, 4, 5, 61, 0, 100, 7, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - Linked - Emote "A nearby Gargoyle comes to life!"'),
(3870, 0, 5, 0, 61, 0, 100, 7, 0, 0, 0, 0, 0, '', 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Stone Sleeper - Linked - Attack the one who woke it');

DELETE FROM `creature_text` WHERE `CreatureID` = 3870;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(3870, 0, 0, 'A nearby Gargoyle comes to life!', 41, 0, 100, 0, 0, 0, 47423, 0, 'Stone Sleeper - wakes up');
