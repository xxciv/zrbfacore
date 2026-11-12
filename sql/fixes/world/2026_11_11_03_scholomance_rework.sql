-- Scholomance (map 1007): spawns, doors, yells and scripts for the ported Pandaria scripts
-- (tools/bfa/scholomance.patch). The story cast and the stalkers the scripts use come from the Pandaria
-- 5.4.8 world DB (alexkulya): this database had no Lilian Voss 59200, no Gandling at Rattlegore 58875,
-- no phylactery, ice wall, Soulflame braziers or book targets. The trash already here is a retail sniff
-- and stays as it is. Safe to run again.

-- 1) Creature spawns. The old Lilian Voss 58722 (an unscripted copy in the Rattlegore hall) goes.
DELETE FROM `creature` WHERE `map`=1007 AND `id`=58722;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 1007000001 AND 1007000999 OR `guid` IN (510000181, 510000221);
DELETE FROM `creature` WHERE `guid` BETWEEN 1007000001 AND 1007000999;
DELETE FROM `waypoint_data` WHERE `id` BETWEEN 1007000001 AND 1007000999;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1007000001, 59167, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, -19.2205, 57.7344, 73.7656, 6.23082, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000002, 30298, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 30.25, 57.842, 92.7124, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000003, 59167, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 30.5781, 132.503, 73.7336, 4.64258, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000004, 59167, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 31.2882, 145.538, 83.596, 4.67748, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000005, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 156.951, 37.0295, 122.342, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000006, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 157.602, 27.316, 122.478, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000007, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 163.587, 10.6146, 121.497, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000008, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 170.174, -4.44792, 121.884, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000009, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 177.66, -7.36632, 121.644, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000010, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 194.688, -12.2569, 119.96, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000011, 68291, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 199.988, -5.299, 119.225, 1.56, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000012, 58664, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 200.58, 21.2153, 118.566, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000013, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 207.479, -13.9375, 122.544, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000014, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 223.299, -10.8455, 123.282, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000015, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 226.472, -4.5191, 120.257, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000016, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 233.427, 10.8038, 122.684, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000017, 58917, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 240.688, 28.8212, 122.6, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000018, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.26, 118.002, 113.809, 0.0207071, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000019, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.319, 80.467, 113.808, 6.27411, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000020, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.41, 99.8733, 113.812, 6.28311, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000021, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.42, 118.182, 113.815, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000022, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.512, 99.4271, 113.806, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000023, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 246.609, 80.526, 113.811, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000024, 59200, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 1, 261.351, 98.8924, 113.572, 1.57661, 86400, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000025, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 276.672, 99.8472, 113.809, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000026, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 276.71, 99.7465, 113.808, 3.13334, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000027, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 276.731, 118.252, 113.815, 3.13722, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000028, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 276.75, 118.2, 113.814, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000029, 59316, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 276.879, 80.6406, 113.813, 3.16216, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000030, 45979, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 0, 277.188, 80.7396, 113.818, 0, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000031, 58875, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 0, 1, 261.313, 118.796, 117.595, 4.74816, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000032, 59167, 1007, 6066, 6066, '1', 0, 0, 0, -1, 0, 0, 32.6548, 145.927, 73.8782, 4.69684, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000033, 59167, 1007, 6066, 6066, '1', 0, 0, 0, -1, 0, 0, -60.4878, 61.9793, 69.0579, 0.322179, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1007000034, 59167, 1007, 6066, 6066, '1', 0, 0, 0, -1, 0, 0, 30.5216, -23.9382, 73.5354, 1.56311, 7200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);

-- Risen Guard patrols: the two guards at the start of a Pandaria patrol path walk it (path id 1007000901/2).
UPDATE `creature` SET `MovementType`=2, `spawndist`=0 WHERE `guid` IN (510000181, 510000221);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(510000181, 1007000901, 0, 0, 1, 0, 0, 0, 0, 0, ''),
(510000221, 1007000902, 0, 0, 1, 0, 0, 0, 0, 0, '');
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES
(1007000901, 1, 176.889, 11.6761, 119.226, 0, 0, 0, 0, 100, 0),
(1007000901, 2, 176.954, 38.5824, 119.226, 0, 0, 0, 0, 100, 0),
(1007000902, 1, 225.006, -44.0878, 119.24, 0, 0, 0, 0, 100, 0),
(1007000902, 2, 212.869, -44.3552, 119.244, 0, 0, 0, 0, 100, 0),
(1007000902, 3, 225.306, -43.8098, 119.24, 0, 0, 0, 0, 100, 0),
(1007000902, 4, 250.396, -43.404, 113.432, 0, 0, 0, 0, 100, 0),
(1007000902, 5, 265.779, -43.0771, 113.432, 0, 0, 0, 0, 100, 0),
(1007000902, 6, 250.56, -43.8726, 113.431, 0, 0, 0, 0, 100, 0),
(1007000902, 7, 239.133, -43.7185, 116.056, 0, 0, 0, 0, 100, 0);

-- 2) Gameobjects: the Chillheart-to-Jandice and Jandice entrance gates (boss doors the scripts open and
--    close), plus the alchemy bottles and lore books missing here. The Challenge Mode start door stood
--    closed in the entrance hall on every difficulty; it and the Challenger's Orb are keystone-only now.
DELETE FROM `gameobject` WHERE `guid` BETWEEN 1007000001 AND 1007000999;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `isActive`, `ScriptName`, `VerifiedBuild`) VALUES
(1007000001, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.292, 77.4514, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000002, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 116.569, 74.6007, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000003, 211648, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 109.576, 90.0781, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000004, 211648, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 110.531, 91.1753, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000005, 211648, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.505, 83.4948, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000006, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 104.595, 76.7031, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000007, 214279, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 219.703, -21.3507, 120.219, 2.61176, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000008, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 316.385, -13.5434, 115.313, 2.48663, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000009, 214279, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 193.896, -10.092, 120.157, 1.69201, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000010, 212899, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 186.708, 125.464, 143.247, 0.0160105, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000011, 214280, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 174.741, 167.734, 114.233, 0.115568, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000012, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 124.076, 89.0903, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000013, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 125.361, 92.2847, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000014, 211648, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.72, 90.7274, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000015, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 124.554, 75.309, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000016, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 109.578, 106.924, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000017, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 110.774, 103.906, 103.922, 5.44266, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000018, 210784, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 9.87102, 57.8554, 74.4162, 4.71239, 0, 0, 1, -0.0000000437114, 7200, 255, 1, 0, '', 0),
(1007000019, 211257, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 261.18, -28.0247, 113.289, 4.71239, 0, 0, 1, -0.0000000437114, 7200, 255, 0, 0, '', 0),
(1007000020, 211648, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 110.618, 73.6667, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000021, 214279, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 226.273, -2.92708, 120.178, 0.83384, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000022, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 287.871, 9.80556, 115.313, 2.39775, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000023, 214280, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 176.694, 122.339, 114.379, 0.797715, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000024, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 153.182, 96.4635, 109.158, 1.91776, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000025, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 124.116, 106.344, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000026, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 125.422, 107.158, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000027, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.302, 104.174, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000028, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.644, 86.2812, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000029, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.505, 83.4948, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000030, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 125.422, 107.158, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000031, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 153.635, 120.08, 108.881, 4.5576, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000032, 214280, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 210.971, 166.177, 114.22, 4.45336, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000033, 211258, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 214.828, -26.6222, 119.299, 1.5708, 0, 0, 1, -0.0000000437114, 7200, 255, 1, 0, '', 0),
(1007000034, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.72, 90.7274, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000035, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 109.578, 106.924, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000036, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.194, 73.2309, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000037, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 104.531, 85.8524, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000038, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 110.618, 73.6667, 103.851, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000039, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.88, 84.4688, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000040, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 310.722, 58.7413, 115.307, 3.92893, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000041, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 125.361, 92.2847, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000042, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.616, 105.031, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000043, 214279, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 240.764, 44.9323, 120.147, 1.69201, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000044, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.72, 90.7274, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000045, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 124.554, 75.309, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000046, 214280, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 213.016, 119.304, 114.364, 1.04092, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000047, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 125.554, 74.2569, 106.995, 5.77329, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000048, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.321, 75.0226, 105.15, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000049, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 316.339, 19.7726, 115.313, 3.01587, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000050, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 117.769, 92.3125, 105.222, 1.17729, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000051, 214279, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 211.925, 37.1441, 120.619, 4.37138, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000052, 211647, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.464, 76.2483, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000053, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.292, 77.4514, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000054, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 255.33, -0.522569, 115.313, 5.72346, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000055, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 124.076, 89.0903, 106.911, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000056, 214106, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 219.74, 175.431, 114.258, 4.45336, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000057, 214101, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 193.896, -10.092, 120.157, 1.69201, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000058, 214107, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 104.483, 83.4271, 102.592, 4.08062, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000059, 214105, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 310.722, 58.7413, 115.307, 3.92893, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000060, 214101, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 169.726, 5.54167, 120.159, 0.964698, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000061, 214105, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 255.198, 23.8976, 115.313, 5.60041, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000062, 214106, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 213.016, 119.304, 114.364, 1.04092, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000063, 211649, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 105.464, 76.2483, 102.513, 0, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000064, 214277, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 104.483, 83.4271, 102.592, 4.08062, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000065, 214280, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 219.74, 175.431, 114.258, 4.45336, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0),
(1007000066, 214278, 1007, 6066, 6066, '1,2,8', 0, 0, 0, -1, 255.231, 46.8906, 115.313, 0.80381, 0, 0, 0, 1, 7200, 255, 1, 0, '', 0);
UPDATE `gameobject` SET `spawnDifficulties`='8' WHERE `map`=1007 AND `id` IN (211988, 211674);
UPDATE `gameobject_template` SET `ScriptName`='go_chillheart_iron_door' WHERE `entry`=211259;

-- 3) Scripts. The bosses and their helpers run the ported C++ scripts; the trash keeps its SmartAI.
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (58633, 58664, 68291, 59707, 66240, 59227, 59711, 59184, 59220, 59153, 59200, 58791, 59080, 59167, 58875, 64562);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_instructor_chillheart' WHERE `entry`=58633;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_instructor_chillhearts_phylactery' WHERE `entry`=58664;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ice_wall_stalker' WHERE `entry`=68291;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_magical_tomes' WHERE `entry` IN (59707, 66240, 59227, 59711);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_jandice_barov' WHERE `entry`=59184;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_jandice_illusion' WHERE `entry`=59220;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_rattlegore' WHERE `entry`=59153;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_lilian_voss' WHERE `entry`=59200;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_lilian_soul' WHERE `entry`=58791;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_grandmaster_gandling' WHERE `entry`=59080;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_gandling_room_stalker' WHERE `entry`=59167;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_gandling_at_rattlegore' WHERE `entry`=58875;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_talking_skull' WHERE `entry`=64562;

-- The classic Scholomance (map 289) scripts are gone from the core; clear their names so the
-- worldserver doesn't report missing scripts. Map 289 can't be entered in 8.3.7.
UPDATE `creature_template` SET `ScriptName`='' WHERE `entry` IN (1853, 10432, 10502, 10503, 10504, 10505, 10506, 10507, 10508, 10901, 11261, 14516, 16118);
UPDATE `gameobject_template` SET `ScriptName`='' WHERE `entry`=175564;
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_shadow_portal', 'spell_shadow_portal_rooms', 'spell_kormok_summon_bone_minions', 'spell_kormok_summon_bone_mages');
UPDATE `instance_template` SET `script`='' WHERE `map`=289;

DELETE FROM `spell_script_names` WHERE `spell_id` IN (111631, 113775, 113999, 114009, 111642, 111570);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(111631, 'spell_chillheart_wrack_soul'),
(113775, 'spell_jandice_whirl_of_illusion'),
(113999, 'spell_rattlegore_bone_spike'),
(114009, 'spell_rattlegore_soulflame'),
(111642, 'spell_lilian_blazing_soul'),
(111570, 'spell_lilian_deaths_grasp');

-- 4) Templates.
-- Darkmaster Gandling (boss) was friendly (35) and stunned/unattackable by unit_flags.
UPDATE `creature_template` SET `faction`=14, `unit_flags`=0 WHERE `entry`=59080;
-- Chillheart's flying books and the Arcane Bomb chaser were friendly (35) and so harmless.
UPDATE `creature_template` SET `faction`=16 WHERE `entry` IN (59707, 66240, 59227);
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=59711;
-- Invisible helpers: not clickable, trigger model.
UPDATE `creature_template` SET `unit_flags`=33554432, `flags_extra`=128 WHERE `entry` IN (57860, 58917, 59316, 68291);
UPDATE `creature_template` SET `flags_extra`=128 WHERE `entry`=62731;
-- Gandling at Rattlegore floats above the hall (Pandaria InhabitType 5).
UPDATE `creature_template` SET `InhabitType`=5 WHERE `entry`=58875;
-- Bone Piles: click for Bone Armor 113996, which soaks one Bone Spike.
UPDATE `creature_template` SET `npcflag`=16777216 WHERE `entry`=59304;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=59304;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(59304, 113996, 3, 0);

-- Visual auras from the Pandaria creature_template_addon (soul rip beam, boneweaving, carvers'
-- bloodthirst, skeletons' and test subjects' looks, Gandling's fire). Hovering Gandling and books.
DELETE FROM `creature_template_addon` WHERE `entry` IN (58875, 59080, 59099, 59193, 59304, 59316, 59359, 59368, 59503, 59613, 59980, 64562, 59227, 59707, 66240);
INSERT INTO `creature_template_addon` (`entry`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(58875, 0, 0, 50331648, 1, 0, 0, 0, 0, 0, '112058'),
(59080, 0, 0, 0, 1, 0, 0, 0, 0, 0, '21389'),
(59099, 0, 0, 0, 1, 0, 0, 0, 0, 0, '113280'),
(59193, 0, 0, 0, 1, 0, 0, 0, 0, 0, '113647'),
(59304, 0, 0, 0, 1, 0, 0, 0, 0, 0, '113995'),
(59316, 0, 0, 0, 1, 0, 0, 0, 0, 0, '114057'),
(59359, 0, 0, 0, 1, 0, 0, 0, 0, 0, '114176'),
(59368, 0, 0, 0, 1, 0, 0, 0, 0, 0, '128122'),
(59503, 0, 0, 0, 1, 0, 0, 0, 0, 0, '19818'),
(59613, 0, 0, 0, 1, 0, 0, 0, 0, 0, '124143'),
(59980, 0, 0, 0, 1, 0, 0, 0, 0, 0, '114178'),
(64562, 0, 0, 0, 1, 0, 0, 0, 0, 0, '126155'),
(59227, 0, 0, 50331648, 1, 0, 0, 0, 0, 0, ''),
(59707, 0, 0, 50331648, 1, 0, 0, 0, 0, 0, ''),
(66240, 0, 0, 50331648, 1, 0, 0, 0, 0, 0, '');

-- Level scaling for normal and heroic. Most of these only had a difficulty 0 row (or none), so in the
-- dungeon they rolled a random level between 43 and 92.
INSERT IGNORE INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`)
SELECT t.`entry`, d.`id`, 1, 100, 0, 0, 0, 0
FROM `creature_template` t
JOIN (SELECT 0 AS `id` UNION ALL SELECT 1 UNION ALL SELECT 2) d
WHERE t.`entry` IN (SELECT DISTINCT `id` FROM `creature` WHERE `map`=1007)
   OR t.`entry` IN (57860, 58753, 58780, 58791, 59220, 59227, 59707, 59711, 59980, 62731, 64683, 66240, 59242);

-- 5) Spell targets: Gandling's soul-rip beam hits Lilian, the students' channel hits the phylactery.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (112081, 122499);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 112081, 0, 0, 31, 0, 3, 59200, 0, 0, 0, 0, '', 'Cosmetic Soul Rip - Lilian Voss'),
(13, 1, 122499, 0, 0, 31, 0, 3, 58664, 0, 0, 0, 0, '', 'Cosmetic Shadow Channel - Chillheart''s Phylactery');

-- 6) Yells and emotes.
DELETE FROM `creature_text` WHERE `CreatureID` IN (58875, 59080, 59153, 59200, 64562);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(58875, 0, 0, 'My dear, it appears we have visitors!  Friends of yours, Voss?', 14, 0, 100, 0, 0, 27479, 58193, 0, 'Darkmaster Gandling - Rattlegore intro'),
(58875, 1, 0, 'Their deaths only serve to empower my summoners further! Behold!', 14, 0, 100, 0, 0, 27480, 58194, 0, 'Darkmaster Gandling - Rattlegore intro'),
(58875, 2, 0, 'What''s the matter, Voss, getting tired?', 14, 0, 100, 0, 0, 27481, 58195, 0, 'Darkmaster Gandling - taunting Lilian'),
(58875, 3, 0, 'Isn''t it beautiful? The weaving of flesh and bone and soul.', 14, 0, 100, 0, 0, 27482, 58196, 0, 'Darkmaster Gandling - taunting Lilian'),
(58875, 4, 0, 'You, too, are beautiful, Voss. Have you looked in a mirror recently?', 14, 0, 100, 0, 0, 27483, 58197, 0, 'Darkmaster Gandling - taunting Lilian'),
(58875, 5, 0, 'My dear, you should embrace this gift that has been bestowed upon you.', 14, 0, 100, 0, 0, 27484, 58198, 0, 'Darkmaster Gandling - taunting Lilian'),
(58875, 6, 0, 'Come, Voss, your fate awaits you.', 14, 0, 100, 0, 0, 27485, 58199, 0, 'Darkmaster Gandling - leaving with Lilian'),
(58875, 7, 0, 'Did you forget, girl? I am the Darkmaster! I command the undead!', 14, 0, 100, 0, 0, 27486, 58421, 0, 'Darkmaster Gandling - Lilian encounter start'),
(58875, 8, 0, 'Now turn your lovely runeblades on our guests, and fetch me their bones!', 14, 0, 100, 0, 0, 27487, 58422, 0, 'Darkmaster Gandling - Lilian encounter start'),
(58875, 9, 0, 'How intriguing, her spirit will not relinquish its grasp on this world.', 14, 0, 100, 0, 0, 27494, 58526, 0, 'Darkmaster Gandling - Lilian soul phase'),
(58875, 10, 0, 'What?!', 14, 0, 100, 0, 0, 27489, 58529, 0, 'Darkmaster Gandling - Lilian purified'),
(59080, 0, 0, 'School is in session!', 14, 0, 100, 0, 0, 27477, 58099, 0, 'Darkmaster Gandling - aggro'),
(59080, 1, 0, 'Dunce.', 14, 0, 100, 0, 0, 27497, 58100, 0, 'Darkmaster Gandling - slay'),
(59080, 2, 0, 'Class... dismissed.', 14, 0, 100, 0, 0, 27478, 58102, 0, 'Darkmaster Gandling - death'),
(59080, 3, 0, '|TInterface\\Icons\\inv_misc_book_01.blp:20|t%s assigns $n a |cFFFF0000|Hspell:113395|h[Harsh Lesson]|h|r!', 41, 0, 100, 0, 0, 0, 58103, 0, 'Darkmaster Gandling - Harsh Lesson'),
(59153, 0, 0, 'RATTLEGORE!', 14, 0, 100, 0, 0, 0, 58323, 0, 'Rattlegore - rises'),
(59153, 1, 0, 'Click on a Bone Pile to protect yourself from Bone Spike!', 41, 0, 100, 0, 0, 0, 59449, 0, 'Rattlegore - Bone Pile hint'),
(59200, 0, 0, 'I...won''t let you...', 14, 0, 100, 0, 0, 29464, 58423, 0, 'Lilian Voss - Rattlegore intro'),
(59200, 1, 0, 'I can''t...fight him...', 12, 0, 100, 0, 0, 29465, 58424, 0, 'Lilian Voss - encounter start'),
(59200, 2, 0, 'It burns...my soul...it burns!!!!', 14, 0, 100, 0, 0, 29468, 58492, 0, 'Lilian Voss - soul phase'),
(59200, 3, 0, 'END IT! NOW! Before he can...', 14, 0, 100, 0, 0, 29463, 58425, 0, 'Lilian Voss - purified'),
(59200, 4, 0, 'DIE, NECROMANCER!', 14, 0, 100, 0, 0, 29466, 58527, 0, 'Lilian Voss - jumps at Gandling'),
(59200, 5, 0, 'Leave me...to die...alone...please...', 12, 0, 100, 0, 0, 29467, 58528, 0, 'Lilian Voss - defeated'),
(59200, 12, 0, 'Lilian''s Soul fades into the spirit realm! It can no longer be harmed!', 41, 0, 100, 0, 0, 0, 66157, 0, 'Lilian Voss - soul fades'),
(64562, 0, 0, 'Here we go. Do try to keep yourselves alive until the end.', 12, 0, 100, 0, 0, 0, 65072, 0, 'Talking Skull - entrance'),
(64562, 1, 0, 'We''re coming for you, Chillheart! Time for payback!', 14, 0, 100, 0, 0, 0, 65074, 0, 'Talking Skull - Chillheart'),
(64562, 2, 0, 'The Talking Skull cackles gleefully as the instructor''s soul is destroyed.', 16, 0, 100, 0, 0, 0, 65077, 0, 'Talking Skull - Chillheart dead'),
(64562, 3, 0, 'The Talking Skull seems hesitant to enter the hall, but proceeds with you nonetheless.', 16, 0, 100, 0, 0, 0, 65078, 0, 'Talking Skull - Jandice hall'),
(64562, 4, 0, 'I can''t bear to watch.', 12, 0, 100, 0, 0, 0, 65085, 0, 'Talking Skull - Jandice fight'),
(64562, 5, 0, 'The Talking Skull proceeds into the next chamber without saying a word.', 16, 0, 100, 0, 0, 0, 65086, 0, 'Talking Skull - Jandice dead'),
(64562, 6, 0, 'Die, Gandling! Kill him!', 14, 0, 100, 0, 0, 0, 65149, 0, 'Talking Skull - Rattlegore hall'),
(64562, 7, 0, 'NO! Get back here coward!', 14, 0, 100, 0, 0, 0, 65203, 0, 'Talking Skull - Gandling leaves'),
(64562, 8, 0, 'Let''s go!', 12, 0, 100, 0, 0, 0, 65207, 0, 'Talking Skull - Rattlegore dead'),
(64562, 9, 0, 'There he is! Kill him now, $p!', 14, 0, 100, 0, 0, 0, 65213, 0, 'Talking Skull - Lilian room'),
(64562, 10, 0, 'Stop him! Forget about her!', 14, 0, 100, 0, 0, 0, 65221, 0, 'Talking Skull - Lilian defeated'),
(64562, 11, 0, 'PREPARE TO DIE, VILLAIN!', 14, 0, 100, 0, 0, 0, 65253, 0, 'Talking Skull - Gandling room');

-- 7) Dungeon Finder and scenario. Boss kills had no encounter rows (only the classic 451-463), so the
--    finder never marked bosses done or rewarded the run; Gandling ends normal (2) and heroic (472).
DELETE FROM `instance_encounters` WHERE `entry` BETWEEN 1426 AND 1430;
INSERT INTO `instance_encounters` (`entry`, `creditType`, `creditEntry`, `lastEncounterDungeon`, `comment`) VALUES
(1426, 0, 58633, 0, 'Instructor Chillheart'),
(1427, 0, 59184, 0, 'Jandice Barov'),
(1428, 0, 59153, 0, 'Rattlegore'),
(1429, 0, 59200, 0, 'Lilian Voss'),
(1430, 0, 59080, 2, 'Darkmaster Gandling');
UPDATE `instance_encounters` SET `lastEncounterDungeon`=0 WHERE `entry`=463;
DELETE FROM `lfg_dungeon_template` WHERE `dungeonId`=2;
INSERT INTO `lfg_dungeon_template` (`dungeonId`, `name`, `position_x`, `position_y`, `position_z`, `orientation`, `requiredItemLevel`, `VerifiedBuild`) VALUES
(2, 'Scholomance', 199.876, 125.346, 138.43, 4.67748, 0, 0);

-- 8) Way out and graveyard. The exit stairs (area trigger 7539) had no teleport row, and dying inside
--    sent you to the zone's default graveyard. This core reads Facing as radians.
DELETE FROM `areatrigger_teleport` WHERE `ID`=7539;
INSERT INTO `areatrigger_teleport` (`ID`, `PortLocID`, `Name`) VALUES
(7539, 3672, 'Scholomance - Stairs Exit Target 001');
UPDATE `world_safe_locs` SET `Facing`=3.57792 WHERE `ID`=3672;
DELETE FROM `graveyard_zone` WHERE `ID`=1878 AND `GhostZone`=6066;
INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Faction`, `Comment`) VALUES
(1878, 6066, 0, 'Western Plaguelands, Scholo GY - Scholomance');
