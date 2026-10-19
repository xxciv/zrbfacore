-- Blackfathom Deeps (redesign): Executioner Gore 74988 is the executioner players meet at the prisoners
-- on the way in. His lines are "Intruders?! Move the prisoners!" and "Come along, heroes! The water is
-- fine."; the boss players fight is Executioner Gore 74518 near Bathiel's sanctum ("I was hoping you
-- would make it to me."). 74988 was a hostile elite players could kill, which gave no boss credit and
-- no boss loot. He now can't be attacked: he yells when players come into view, then leaves.

UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 0x300 WHERE `entry` = 74988; -- IMMUNE_TO_PC | IMMUNE_TO_NPC

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (74988, -4800069, -4800113) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
-- First prisoners, past the entrance
(-4800069, 0, 0, 1, 10, 0, 100, 1, 0, 40, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - On player in sight - Say "Intruders?! Move the prisoners!"'),
(-4800069, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 67, 1, 6000, 6000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - Linked - Start timed event 1'),
(-4800069, 0, 2, 3, 59, 0, 100, 0, 1, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - On timed event 1 - Say "Come along, heroes! The water is fine."'),
(-4800069, 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 41, 4000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - Linked - Despawn in 4 s'),
-- Second prisoners, on the way to Bathiel
(-4800113, 0, 0, 1, 10, 0, 100, 1, 0, 40, 0, 0, 0, '', 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - On player in sight - Say "The intruders are still alive?! Stop them!"'),
(-4800113, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 41, 5000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Executioner Gore - Linked - Despawn in 5 s');
