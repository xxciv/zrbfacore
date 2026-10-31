-- Bloodlord Mandokir stays forever in the Rebel Camp after "Bloodlord Mandokir"
--
-- Turning in quest 26748 (Alliance, Rebel Camp) casts reward spell 82340,
-- which summons Bloodlord Mandokir 43989 (SummonProperties 492, infinite
-- duration). The Horde twin, quest 26334 at Grom'gol, casts 79783 and summons
-- 42799 the same way. Neither creature has a script, so the summon never
-- leaves: it stands where the quest giver was and blocks the NPC behind it.
--
-- Changed: 43989 and 42799 get a SmartAI line that despawns them 5 seconds
-- after they are summoned (event 54 JUST_SUMMONED -> action 41 FORCE_DESPAWN).
-- Both already have AIName 'SmartAI' and had no smart_scripts rows.

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (43989, 42799);

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (43989, 42799) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(43989, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 41, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Bloodlord Mandokir (quest 26748 reward) - Just Summoned - Despawn in 5s'),
(42799, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 41, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Bloodlord Mandokir (quest 26334 reward) - Just Summoned - Despawn in 5s');
