-- Gnomeregan: Mekgineer Thermaplugg's fight and the Walking Bombs, 2026-10-19
-- Four's run: Knock Away came very often, Walking Bombs appeared in the middle of the room and then under
-- Thermaplugg wherever he stood, and none came out of the Gnome Faces on the walls as in the original fight.
-- One Walking Bomb was already standing below a face before the fight. Bombs that detonated kept meleeing.
--
-- Thermaplugg's SmartAI mixed two script versions: two rows each with ids 3 and 5, three Knock Away rows
-- (10101 twice, 11130 once), bombs summoned on himself (ids 3/4) and at one spot mid-room (id 5), and
-- broken links (5 -> 6, which is not a linked row). The Walking Bomb's Detonation row linked to id 3,
-- which doesn't exist, so the despawn after Detonation never ran.

-- 1. Thermaplugg: one Knock Away (10101) every 12-15 s; every 12-16 s a random Gnome Face (one of six action
--    lists, 780000-780005) sends a Walking Bomb out in front of its pedestal. The Gnome Face and Button
--    gameobject positions lie 40-55 yards from the room's centre, well outside the room the player sees, so the
--    bombs stand 15 yards from the centre of the six faces (-522.75, 670.10) on the line to each face, on
--    the floor (z -325.0). Four's `.gps` in front of Gnome Face 01's pedestal (-532.85, 682.18, floor
--    -325.27) is 1.3 yards from that face's spot. Yells, Pound, Steam Blast and Welding Beam are unchanged.
--    The faces' buttons still do nothing.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 7800 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 780000 AND 780005 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(7800, 0, 0, 0, 0, 0, 100, 0, 5000, 5000, 12000, 15000, 0, '', 11, 10101, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Cast Knock Away'),
(7800, 0, 1, 0, 4, 0, 100, 1, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - On Aggro - Say Line 0'),
(7800, 0, 2, 0, 0, 0, 100, 0, 20000, 20000, 40000, 65000, 0, '', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Say Line 1'),
(7800, 0, 3, 0, 0, 0, 100, 0, 8000, 8000, 12000, 16000, 0, '', 87, 780000, 780001, 780002, 780003, 780004, 780005, 1, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Activate a random Gnome Face (Walking Bomb)'),
(7800, 0, 4, 0, 0, 0, 100, 0, 30000, 30000, 45000, 60000, 0, '', 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Say Line 2'),
(7800, 0, 6, 0, 5, 0, 100, 0, 5000, 5000, 0, 0, 0, '', 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - On Killed Unit - Say Line 3'),
(7800, 0, 7, 0, 0, 0, 100, 0, 8000, 8000, 14000, 16000, 0, '', 11, 74720, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Cast Pound'),
(7800, 0, 9, 0, 0, 0, 100, 0, 9000, 10000, 33500, 39000, 0, '', 11, 93655, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Cast Steam Blast'),
(7800, 0, 10, 0, 0, 0, 100, 0, 2000, 15000, 8000, 29000, 0, '', 11, 52778, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Mekgineer Thermaplugg - In Combat - Cast Welding Beam'),
(780000, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -533.181, 680.879, -325.0, 5.481, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 01'),
(780001, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -521.562, 685.051, -325.0, 4.633, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 02'),
(780002, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -509.67, 677.437, -325.0, 3.653, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 03'),
(780003, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -510.015, 662.175, -325.0, 2.585, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 04'),
(780004, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -522.218, 655.107, -325.0, 1.606, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 05'),
(780005, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 12, 7915, 3, 60000, 0, 0, 0, 8, 0, 0, 0, -533.662, 659.804, -325.0, 0.756, 'Mekgineer Thermaplugg - Actionlist - Summon Walking Bomb below Gnome Face 06');

-- 2. Walking Bomb: despawns after Detonation, and a summoned bomb goes for the players straight away.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 7915 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(7915, 0, 0, 1, 9, 0, 100, 1, 0, 10, 0, 0, 0, '', 11, 4043, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Walking Bomb - Within 0-10 Range - Cast Detonation'),
(7915, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 41, 500, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Walking Bomb - Linked - Despawn In 500 ms'),
(7915, 0, 2, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Walking Bomb - Just Summoned - Set In Combat With Zone');

-- 3. The Walking Bomb standing below a Gnome Face from the start (a summoned bomb saved as a spawn).
DELETE FROM `creature_addon` WHERE `guid` = 324517;
DELETE FROM `creature` WHERE `guid` = 324517 AND `id` = 7915;
