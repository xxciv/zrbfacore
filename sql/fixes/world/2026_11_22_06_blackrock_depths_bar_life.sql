-- Blackrock Depths (map 230): life in the Grim Guzzler, 2026-11-22. Goes with 2026_11_22_05.
--
-- Four, 2026-11-22: "grim guzzler still looks pretty bad. tons of patrons just huddled up standing around. no
-- one is sitting or drinking." and "hurley Blackbreath and co are aggro right by the entrance".
--
-- 1. The patron spots come from a sniff that caught everyone standing (Pandaria 5.4.8 has the same spots;
--    AzerothCore also seats nobody), and five stood within a yard of each other at 845,-161. The bar has 337
--    chairs. 40 patrons within 3 yards of a free chair now sit on it (the chair's spot and facing, stand state
--    5 = medium chair), and the five huddled ones take the free table at 839,-151. 24 stay standing. A seated
--    patron stands up when pulled (SAI below) and sits down again when it walks home (the home movement
--    reloads creature_addon).
-- 2. Patrons get AzerothCore's idle emotes (talk, cheer, laugh) plus eat, which is the drinking motion.
-- 3. Hurley Blackbreath and his three cronies (9537, 9541) stood hostile by the bar entrance at 859,-149: the
--    sniff caught them after someone had broken the Thunderbrew Lager Kegs (164911) behind the bar. Ported
--    from AzerothCore (Pandaria has the same keg script): they wait hidden and immune at 878,-153 until three
--    kegs are broken (counting fixed in 2026_11_22_09), then Hurley yells "Get away from those kegs!", they walk to the kegs (waypoints 9537,
--    9541, 9541000, 9541001, already in the table) and fight. Flag 0x40 left alone (the template has it).
-- Backups: zr_backup_brd_creature_moved (creature rows before the move), zr_backup_brd_creature_addon,
-- zr_backup_brd_smart_scripts.

CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_moved` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_addon` LIKE `creature_addon`;
CREATE TABLE IF NOT EXISTS `zr_backup_brd_smart_scripts` LIKE `smart_scripts`;

-- 1. Seats (patron guid, chair guid, chair spot)
DROP TEMPORARY TABLE IF EXISTS `zr_brd_seat`;
CREATE TEMPORARY TABLE `zr_brd_seat` (`guid` BIGINT UNSIGNED PRIMARY KEY, `chair` BIGINT UNSIGNED, `x` FLOAT, `y` FLOAT, `z` FLOAT, `o` FLOAT);
INSERT INTO `zr_brd_seat` VALUES
(46622, 188527, 858.563, -141.575, -49.740, 0.3752),
(46624, 188257, 878.337, -144.471, -49.740, -2.5220),
(46625, 188277, 844.280, -189.470, -49.740, -3.0718),
(46626, 188481, 841.268, -191.120, -49.740, 2.0769),
(46627, 188324, 865.286, -177.086, -49.740, 0.6109),
(46630, 188230, 867.552, -163.878, -49.740, 0.5498),
(48093, 188392, 868.681, -165.685, -49.740, 0.5498),
(48169, 188443, 876.866, -160.738, -49.740, 0.5498),
(321644, 188415, 873.605, -209.623, -43.721, -2.5482),
(321648, 188409, 864.724, -197.895, -43.694, 2.7925),
(321964, 188321, 861.834, -165.583, -49.740, -2.8798),
(321965, 188322, 840.372, -151.906, -49.740, -2.5220),
(321966, 188256, 897.474, -202.262, -43.721, -2.6791),
(321968, 188461, 868.341, -145.547, -49.740, 2.6529),
(321970, 188213, 857.538, -199.724, -43.719, -2.0420),
(321971, 188204, 879.473, -159.089, -49.740, -2.5220),
(321972, 188335, 824.111, -172.223, -49.740, 0.5498),
(322124, 188235, 872.208, -172.535, -49.740, 1.6232),
(322125, 188569, 877.220, -203.719, -43.700, 2.5307),
(322127, 188444, 878.111, -162.731, -49.740, 0.3752),
(322129, 188320, 858.460, -164.224, -49.740, 0.1833),
(322131, 188544, 880.718, -161.082, -49.740, -2.5220),
(322132, 188432, 852.277, -205.135, -43.697, -1.0385),
(322178, 188421, 857.400, -203.156, -43.719, 3.1066),
(322179, 188420, 861.169, -139.926, -49.740, -2.5220),
(322180, 188438, 871.288, -164.036, -49.740, -3.1416),
(322181, 188325, 872.149, -213.228, -43.721, 0.3491),
(322186, 188351, 875.048, -203.645, -43.700, 0.0000),
(322187, 188210, 832.043, -155.016, -49.740, -2.5220),
(322212, 188306, 837.766, -153.555, -49.740, 0.3752),
(322213, 188297, 886.514, -209.760, -43.721, 1.8762),
(322215, 188364, 882.976, -208.148, -43.721, -1.0210),
(322218, 188272, 839.127, -149.913, -49.740, -2.5220),
(322219, 188426, 885.051, -207.044, -43.721, -1.0210),
(322231, 188436, 836.520, -151.562, -49.740, 0.5498),
(322232, 188407, 864.765, -138.702, -49.737, -2.5569),
(322236, 188227, 875.812, -213.275, -43.721, -2.5482),
(322237, 188209, 862.476, -196.087, -43.694, 0.0873),
(322238, 188404, 825.495, -180.732, -49.740, -2.5394),
(322239, 188319, 870.956, -211.203, -43.721, 0.5236),
(322250, 188365, 888.187, -205.056, -43.721, -1.0210),
(322253, 188440, 870.335, -162.511, -49.740, -2.5220),
(322254, 188391, 846.843, -148.808, -49.737, -2.5569),
(322255, 188207, 861.265, -163.529, -49.740, -2.8798),
(322256, 188425, 884.439, -210.863, -43.721, 2.0508);
INSERT IGNORE INTO `zr_backup_brd_creature_moved` SELECT c.* FROM `creature` c JOIN `zr_brd_seat` s ON s.`guid` = c.`guid` WHERE c.`map` = 230;
INSERT IGNORE INTO `zr_backup_brd_creature_addon` SELECT a.* FROM `creature_addon` a JOIN `zr_brd_seat` s ON s.`guid` = a.`guid`;
UPDATE `creature` c JOIN `zr_brd_seat` s ON s.`guid` = c.`guid`
    SET c.`position_x` = s.`x`, c.`position_y` = s.`y`, c.`position_z` = s.`z`, c.`orientation` = s.`o`, c.`spawndist` = 0, c.`MovementType` = 0
    WHERE c.`map` = 230 AND c.`id` IN (9545, 9547, 9554);
-- patrons with their own addon row keep it (Hammered Patrons' auras) and only sit; the rest copy their template addon
UPDATE `creature_addon` a JOIN `zr_brd_seat` s ON s.`guid` = a.`guid` SET a.`bytes1` = 5;
INSERT IGNORE INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`)
    SELECT s.`guid`, 0, 0, 5, t.`bytes2`, 0, 0, 0, 0, 0, t.`auras`
    FROM `zr_brd_seat` s JOIN `creature` c ON c.`guid` = s.`guid` JOIN `creature_template_addon` t ON t.`entry` = c.`id`;
DROP TEMPORARY TABLE `zr_brd_seat`;

-- 1+2. Patron idle emotes and standing up when pulled
INSERT IGNORE INTO `zr_backup_brd_smart_scripts` SELECT * FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (9545, 9547, 9554) AND `id` IN (30, 31);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (9545, 9547, 9554) AND `id` IN (30, 31);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(9545, 0, 30, 0, 1, 0, 55, 0, 7000, 15000, 7000, 15000, 10, 1, 4, 7, 11, 0, 0, 1, 0, 0, 0, 'Grim Patron - Out of Combat - Talk, cheer, drink or laugh'),
(9545, 0, 31, 0, 4, 0, 100, 0, 0, 0, 0, 0, 91, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Grim Patron - On Aggro - Stand up'),
(9547, 0, 30, 0, 1, 0, 55, 0, 7000, 15000, 7000, 15000, 10, 1, 4, 7, 11, 0, 0, 1, 0, 0, 0, 'Guzzling Patron - Out of Combat - Talk, cheer, drink or laugh'),
(9547, 0, 31, 0, 4, 0, 100, 0, 0, 0, 0, 0, 91, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Guzzling Patron - On Aggro - Stand up'),
(9554, 0, 30, 0, 1, 0, 55, 0, 7000, 15000, 7000, 15000, 10, 1, 4, 7, 11, 0, 0, 1, 0, 0, 0, 'Hammered Patron - Out of Combat - Talk, cheer, drink or laugh'),
(9554, 0, 31, 0, 4, 0, 100, 0, 0, 0, 0, 0, 91, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hammered Patron - On Aggro - Stand up');

-- 3. Hurley Blackbreath and his cronies wait behind the bar until the kegs are broken
INSERT IGNORE INTO `zr_backup_brd_creature_moved` SELECT * FROM `creature` WHERE `map` = 230 AND `guid` IN (322331, 322332, 322333, 322334);
UPDATE `creature` SET `position_x` = 878.121, `position_y` = -153.074, `position_z` = -49.760, `orientation` = 0.5278 WHERE `map` = 230 AND `guid` = 322331 AND `id` = 9537;
UPDATE `creature` SET `position_x` = 879.018, `position_y` = -155.273, `position_z` = -49.759, `orientation` = 0.5718 WHERE `map` = 230 AND `guid` = 322332 AND `id` = 9541;
UPDATE `creature` SET `position_x` = 876.961, `position_y` = -151.796, `position_z` = -49.759, `orientation` = 0.4995 WHERE `map` = 230 AND `guid` = 322333 AND `id` = 9541;
UPDATE `creature` SET `position_x` = 876.535, `position_y` = -154.334, `position_z` = -49.759, `orientation` = 0.3393 WHERE `map` = 230 AND `guid` = 322334 AND `id` = 9541;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `map` = 230 AND `guid` IN (322331, 322332, 322333, 322334);

INSERT IGNORE INTO `zr_backup_brd_smart_scripts` SELECT * FROM `smart_scripts`
    WHERE (`source_type` = 0 AND `entryorguid` IN (9537, -322332, -322333, -322334)) OR (`source_type` = 1 AND `entryorguid` = 164911);
DELETE FROM `smart_scripts` WHERE (`source_type` = 0 AND `entryorguid` IN (9537, -322332, -322333, -322334)) OR (`source_type` = 1 AND `entryorguid` = 164911);
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (9537, 9541);
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI', `ScriptName` = '' WHERE `entry` = 164911;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(9537, 0, 0, 1, 11, 0, 100, 256, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Spawn - Immune to players'),
(9537, 0, 1, 2, 61, 0, 100, 256, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Invisible'),
(9537, 0, 2, 0, 61, 0, 100, 256, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Passive'),
(9537, 0, 3, 4, 38, 0, 100, 257, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Data 1 1 (keg broken) - Visible'),
(9537, 0, 4, 6, 61, 0, 100, 256, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 9, 9541, 0, 50, 'Hurley Blackbreath - Linked - Wake the cronies'),
(9537, 0, 6, 7, 61, 0, 100, 256, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Say ''Get away from those kegs!'''),
(9537, 0, 7, 0, 61, 0, 100, 256, 0, 0, 0, 0, 53, 1, 9537, 0, 0, 0, 2, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Walk to the kegs'),
(9537, 0, 8, 9, 40, 0, 100, 256, 3, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Point 3 - Set Home'),
(9537, 0, 9, 10, 61, 0, 100, 256, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Attackable'),
(9537, 0, 10, 15, 61, 0, 100, 256, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Say ''You''ll pay for that!'''),
(9537, 0, 15, 0, 61, 0, 100, 256, 0, 0, 0, 0, 89, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Linked - Wander'),
(9537, 0, 11, 0, 2, 0, 100, 0, 0, 30, 30000, 45000, 11, 14872, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - Below 30% HP - Cast Drunken Rage'),
(9537, 0, 12, 0, 9, 0, 100, 0, 0, 5, 10000, 15000, 11, 9573, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Hurley Blackbreath - In Range - Cast Flame Breath'),
(9537, 0, 13, 0, 0, 0, 100, 0, 5000, 6000, 10000, 14000, 11, 26211, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Hurley Blackbreath - In Combat - Cast Hamstring'),
(9537, 0, 14, 0, 0, 0, 100, 0, 5000, 8000, 8000, 13000, 11, 16856, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Hurley Blackbreath - In Combat - Cast Mortal Strike'),
(9537, 0, 16, 17, 4, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9541, 0, 50, 'Hurley Blackbreath - On Aggro - Cronies join'),
(9537, 0, 17, 0, 61, 0, 100, 256, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Hurley Blackbreath - Linked - Attack'),
(9537, 0, 18, 0, 38, 0, 100, 0, 1, 2, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 'Hurley Blackbreath - On Data 1 2 - Attack nearest player'),
(9537, 0, 19, 0, 4, 0, 100, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Aggro - Attackable (pulled early)'),
(9537, 0, 20, 0, 38, 0, 100, 0, 1, 2, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Hurley Blackbreath - On Data 1 2 - Attackable (pulled early)'),
(-322332, 0, 0, 1, 11, 0, 100, 256, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Spawn - Immune to players'),
(-322332, 0, 1, 3, 61, 0, 100, 256, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Invisible'),
(-322332, 0, 3, 0, 61, 0, 100, 256, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Passive'),
(-322332, 0, 2, 4, 38, 0, 100, 256, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 1 - Visible'),
(-322332, 0, 4, 0, 61, 0, 100, 256, 0, 0, 0, 0, 53, 1, 9541, 0, 0, 0, 2, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Walk to the kegs'),
(-322332, 0, 5, 6, 40, 0, 100, 256, 3, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Point 3 - Set Home'),
(-322332, 0, 6, 7, 61, 0, 100, 256, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Attackable'),
(-322332, 0, 7, 0, 61, 0, 100, 256, 0, 0, 0, 0, 89, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Wander'),
(-322332, 0, 8, 0, 0, 0, 100, 0, 1000, 3000, 4000, 7000, 11, 15581, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Sinister Strike'),
(-322332, 0, 9, 0, 0, 0, 100, 0, 2000, 2000, 11000, 12000, 11, 15583, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Rupture'),
(-322332, 0, 10, 11, 4, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9541, 0, 50, 'Blackbreath Crony - On Aggro - Cronies join'),
(-322332, 0, 11, 12, 61, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9537, 0, 50, 'Blackbreath Crony - Linked - Hurley joins'),
(-322332, 0, 12, 0, 61, 0, 100, 256, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Blackbreath Crony - Linked - Attack'),
(-322332, 0, 13, 0, 38, 0, 100, 0, 1, 2, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attack nearest player'),
(-322332, 0, 14, 0, 4, 0, 100, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Aggro - Attackable (pulled early)'),
(-322332, 0, 15, 0, 38, 0, 100, 0, 1, 2, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attackable (pulled early)'),
(-322333, 0, 0, 1, 11, 0, 100, 256, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Spawn - Immune to players'),
(-322333, 0, 1, 3, 61, 0, 100, 256, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Invisible'),
(-322333, 0, 3, 0, 61, 0, 100, 256, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Passive'),
(-322333, 0, 2, 4, 38, 0, 100, 256, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 1 - Visible'),
(-322333, 0, 4, 0, 61, 0, 100, 256, 0, 0, 0, 0, 53, 1, 9541000, 0, 0, 0, 2, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Walk to the kegs'),
(-322333, 0, 5, 6, 40, 0, 100, 256, 3, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Point 3 - Set Home'),
(-322333, 0, 6, 7, 61, 0, 100, 256, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Attackable'),
(-322333, 0, 7, 0, 61, 0, 100, 256, 0, 0, 0, 0, 89, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Wander'),
(-322333, 0, 8, 0, 0, 0, 100, 0, 1000, 3000, 4000, 7000, 11, 15581, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Sinister Strike'),
(-322333, 0, 9, 0, 0, 0, 100, 0, 2000, 2000, 11000, 12000, 11, 15583, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Rupture'),
(-322333, 0, 10, 11, 4, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9541, 0, 50, 'Blackbreath Crony - On Aggro - Cronies join'),
(-322333, 0, 11, 12, 61, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9537, 0, 50, 'Blackbreath Crony - Linked - Hurley joins'),
(-322333, 0, 12, 0, 61, 0, 100, 256, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Blackbreath Crony - Linked - Attack'),
(-322333, 0, 13, 0, 38, 0, 100, 0, 1, 2, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attack nearest player'),
(-322333, 0, 14, 0, 4, 0, 100, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Aggro - Attackable (pulled early)'),
(-322333, 0, 15, 0, 38, 0, 100, 0, 1, 2, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attackable (pulled early)'),
(-322334, 0, 0, 1, 11, 0, 100, 256, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Spawn - Immune to players'),
(-322334, 0, 1, 3, 61, 0, 100, 256, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Invisible'),
(-322334, 0, 3, 0, 61, 0, 100, 256, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Passive'),
(-322334, 0, 2, 4, 38, 0, 100, 256, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 1 - Visible'),
(-322334, 0, 4, 0, 61, 0, 100, 256, 0, 0, 0, 0, 53, 1, 9541001, 0, 0, 0, 2, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Walk to the kegs'),
(-322334, 0, 5, 6, 40, 0, 100, 256, 3, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Point 3 - Set Home'),
(-322334, 0, 6, 7, 61, 0, 100, 256, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Attackable'),
(-322334, 0, 7, 0, 61, 0, 100, 256, 0, 0, 0, 0, 89, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - Linked - Wander'),
(-322334, 0, 8, 0, 0, 0, 100, 0, 1000, 3000, 4000, 7000, 11, 15581, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Sinister Strike'),
(-322334, 0, 9, 0, 0, 0, 100, 0, 2000, 2000, 11000, 12000, 11, 15583, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Blackbreath Crony - In Combat - Cast Rupture'),
(-322334, 0, 10, 11, 4, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9541, 0, 50, 'Blackbreath Crony - On Aggro - Cronies join'),
(-322334, 0, 11, 12, 61, 0, 100, 256, 0, 0, 0, 0, 45, 1, 2, 0, 0, 0, 0, 9, 9537, 0, 50, 'Blackbreath Crony - Linked - Hurley joins'),
(-322334, 0, 12, 0, 61, 0, 100, 256, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Blackbreath Crony - Linked - Attack'),
(-322334, 0, 13, 0, 38, 0, 100, 0, 1, 2, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attack nearest player'),
(-322334, 0, 14, 0, 4, 0, 100, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Aggro - Attackable (pulled early)'),
(-322334, 0, 15, 0, 38, 0, 100, 0, 1, 2, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Blackbreath Crony - On Data 1 2 - Attackable (pulled early)'),
(164911, 1, 0, 0, 70, 0, 100, 0, 2, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 13, 164911, 0, 50, 'Thunderbrew Lager Keg - On Use - Tell the other kegs'),
(164911, 1, 1, 0, 70, 2, 100, 0, 2, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 9, 9537, 0, 50, 'Thunderbrew Lager Keg - On Use in phase 2 - Wake Hurley Blackbreath'),
(164911, 1, 2, 0, 38, 0, 100, 0, 1, 1, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Thunderbrew Lager Keg - On Data 1 1 - Count a broken keg');

-- Check
SELECT CONCAT('Seated patrons ', (SELECT COUNT(*) FROM `creature` c JOIN `creature_addon` a ON a.`guid` = c.`guid` WHERE c.`map` = 230 AND c.`id` IN (9545, 9547, 9554) AND a.`bytes1` = 5),
    ', patrons within 1 yard of another ', (SELECT COUNT(*) FROM `creature` p JOIN `creature` q ON q.`map` = 230 AND p.`guid` < q.`guid`
        AND q.`id` IN (9545, 9547, 9554) AND POW(p.`position_x` - q.`position_x`, 2) + POW(p.`position_y` - q.`position_y`, 2) < 1
        WHERE p.`map` = 230 AND p.`id` IN (9545, 9547, 9554)),
    ', patron SAI rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (9545, 9547, 9554) AND `id` IN (30, 31)),
    ', Hurley rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9537),
    ', crony rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (-322332, -322333, -322334)),
    ', keg rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` = 164911)) AS `check`;
