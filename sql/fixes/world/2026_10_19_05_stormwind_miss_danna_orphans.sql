-- Stormwind: Miss Danna (3513) and her school group, and Gil (3504), walking their routes again.
-- On this server Miss Danna and the children Pat (3505), Andi (3507), Mikey (3508), Geoff (3509),
-- Twain (3510), Steven (3511) and Jimmy (3512) had creature templates and SmartAI but no spawns,
-- Miss Danna's SmartAI started a `waypoints` path 3513 that doesn't exist, and she had no
-- creature_text. Gil only had a static spawn under the Trade District bridge (removed by
-- 2026_10_19_04_stormwind_stray_spawns.sql).
-- Everything below is copied from the alexkulya/pandaria_5.4.8 world database
-- (sql/base/world_04_03_2023.zip), the same reference zrpandaria548 uses, converted to this
-- core's columns:
--   * spawns: Miss Danna guid 188983 and the 7 children 188984-188990 at the Trade District
--     (-8838.52, 670.28), Gil guid 6183 at (-8780, 899.541). These guids are free here.
--   * waypoint_data path 188983 (60 points, Trade District -> Cathedral Square -> Stormwind Keep ->
--     Valley of Heroes -> back) and path 6183 (25 points, Gil's walk to the Mage Quarter and back).
--     Gil's path had waypoint_scripts actions 102-116 on the Pandaria side; they are not copied
--     (action 0), his own SmartAI already says his lines.
--   * creature_formations: the children follow Miss Danna. groupAI is 514 here, not Pandaria's 2:
--     this core only moves formation members along with the leader when FLAG_IDLE_IN_FORMATION
--     (0x200) is set (CreatureGroup::LeaderMoveTo).
--   * smart_scripts: Miss Danna's stops are "movement inform" events on her path that start action
--     lists 351300-351306 (talk, emote, and tell the children which way to face). The old rows here
--     (WP start on a missing path, follow-Miss-Danna rows on the children, action lists
--     351300-351302) are replaced. The children's emote reaction rows (ids 100 and up) are kept.
--   * creature_text: Miss Danna groups 0-4, 7, 8, Steven 0, Jimmy 0 from Pandaria. Group 5 (her
--     answer to Steven at the Keep) is missing there; its text is taken from Wowpedia
--     (wowpedia.fandom.com/wiki/Miss_Danna). The line for group 6 (at the Valley of Heroes) isn't
--     known, so that talk row is left out and she only plays the emote there.
-- Revert: delete the guids, paths, formation, texts and smart_scripts rows below (the removed
-- BFA rows are in dumps/bfa_world.sql).

DELETE FROM `creature` WHERE `guid` IN (6183, 188983, 188984, 188985, 188986, 188987, 188988, 188989, 188990);
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(6183, 3504, 0, 1519, 5390, '0', 0, 0, 0, -1, 0, 0, -8780, 899.541, 100.501, 6.256, 300, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, '', 0),
(188983, 3513, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8838.52, 670.28, 98.0987, 0.553153, 300, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, '', 0),
(188984, 3509, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8841.45, 668.822, 97.9588, 0.507234, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188985, 3512, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8841.64, 671.515, 97.9739, 0.556232, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188986, 3508, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8841.74, 670.394, 97.9404, 0.629918, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188987, 3511, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8841.58, 669.168, 97.9151, 0.55451, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188988, 3510, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8841.32, 667.768, 97.8914, 0.553006, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188989, 3507, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8840.46, 666.881, 97.9108, 0.553158, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(188990, 3505, 0, 1519, 5148, '0', 0, 0, 0, -1, 0, 0, -8838.57, 667.07, 98.0103, 0.553137, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);
DELETE FROM `creature_addon` WHERE `guid` IN (6183, 188983, 188984, 188985, 188986, 188987, 188988, 188989, 188990);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(188983, 188983, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(6183, 6183, 0, 0, 0, 0, 0, 0, 0, 0, '');
DELETE FROM `waypoint_data` WHERE `id` IN (188983, 6183);
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES
(188983, 1, -8824.65, 677.359, 97.6724, 0, 1000, 0, 0, 100, 0),
(188983, 2, -8844.06, 721.315, 97.3127, 0, 1000, 0, 0, 100, 0),
(188983, 3, -8794.66, 745.738, 97.8358, 0, 2500, 0, 0, 100, 0),
(188983, 4, -8765.71, 737.339, 98.9571, 0, 1000, 0, 0, 100, 0),
(188983, 5, -8744.1, 711.742, 98.1589, 0, 0, 0, 0, 100, 0),
(188983, 6, -8736.13, 717.57, 101.035, 0, 0, 0, 0, 100, 0),
(188983, 7, -8714.09, 735.726, 97.8129, 0, 0, 0, 0, 100, 0),
(188983, 8, -8698.83, 714.642, 97.0168, 0, 0, 0, 0, 100, 0),
(188983, 9, -8657.55, 748.029, 96.6892, 0, 0, 0, 0, 100, 0),
(188983, 11, -8658.68, 767.899, 96.6925, 0, 0, 0, 0, 100, 0),
(188983, 12, -8634.49, 787.411, 96.6512, 0, 1500, 0, 0, 100, 0),
(188983, 13, -8662.17, 821.239, 96.6386, 0, 0, 0, 0, 100, 0),
(188983, 14, -8653.53, 826.735, 96.5285, 0, 2000, 0, 0, 100, 0),
(188983, 15, -8608.62, 861.791, 96.6798, 0, 0, 0, 0, 100, 0),
(188983, 16, -8600.32, 850.058, 96.6911, 0, 0, 0, 0, 100, 0),
(188983, 17, -8616.11, 837.915, 96.7385, 0, 3000, 0, 0, 100, 0),
(188983, 18, -8637.49, 816.942, 96.6393, 0, 2500, 0, 0, 100, 0),
(188983, 19, -8629.56, 781.904, 96.6514, 0, 0, 0, 0, 100, 0),
(188983, 20, -8623.89, 774.974, 96.6518, 0, 0, 0, 0, 100, 0),
(188983, 21, -8623.29, 775.529, 96.6512, 0, 1000, 0, 0, 100, 0),
(188983, 22, -8623.29, 775.529, 96.6512, 0, 22000, 0, 0, 100, 0),
(188983, 23, -8594.06, 757.656, 96.6537, 0, 0, 0, 0, 100, 0),
(188983, 24, -8578.89, 737.947, 96.6719, 0, 0, 0, 0, 100, 0),
(188983, 25, -8596.77, 717.424, 96.6572, 0, 1000, 0, 0, 100, 0),
(188983, 26, -8562.25, 673.301, 97.0168, 0, 0, 0, 0, 100, 0),
(188983, 27, -8536.52, 690.402, 97.6668, 0, 0, 0, 0, 100, 0),
(188983, 28, -8522.24, 670.618, 102.794, 0, 0, 0, 0, 100, 0),
(188983, 29, -8508.77, 650.151, 100.292, 0, 0, 0, 0, 100, 0),
(188983, 30, -8557.68, 615.023, 102.352, 0, 0, 0, 0, 100, 0),
(188983, 31, -8568.14, 613.353, 102.382, 0, 0, 0, 0, 100, 0),
(188983, 32, -8581.15, 593.053, 103.562, 0, 3000, 0, 0, 100, 0),
(188983, 33, -8585.6, 562.85, 101.927, 0, 1000, 0, 0, 100, 0),
(188983, 34, -8573.45, 540.833, 101.757, 0, 0, 0, 0, 100, 0),
(188983, 35, -8535.68, 488.072, 101.081, 0, 0, 0, 0, 100, 0),
(188983, 36, -8538.69, 479.398, 102.572, 0, 0, 0, 0, 100, 0),
(188983, 37, -8548.29, 467.484, 104.514, 0, 0, 0, 0, 100, 0),
(188983, 38, -8544.94, 464.148, 104.414, 0, 1000, 0, 0, 100, 0),
(188983, 39, -8544.94, 464.148, 104.414, 0, 15000, 0, 0, 100, 0),
(188983, 40, -8564.17, 466.02, 104.524, 0, 1000, 0, 0, 100, 0),
(188983, 41, -8583.28, 480.99, 104.214, 0, 0, 0, 0, 100, 0),
(188983, 42, -8606.08, 504.922, 103.722, 0, 0, 0, 0, 100, 0),
(188983, 43, -8633.15, 534.792, 100.272, 0, 0, 0, 0, 100, 0),
(188983, 44, -8655.92, 552.797, 96.9437, 0, 0, 0, 0, 100, 0),
(188983, 45, -8671.53, 554.116, 97.1805, 0, 0, 0, 0, 100, 0),
(188983, 46, -8713.5, 519.816, 97.1699, 0, 0, 0, 0, 100, 0),
(188983, 47, -8731.17, 541.957, 101.124, 0, 1500, 0, 0, 100, 0),
(188983, 48, -8749.98, 561.766, 97.3988, 0, 0, 0, 0, 100, 0),
(188983, 49, -8736.87, 574.559, 97.3823, 0, 0, 0, 0, 100, 0),
(188983, 50, -8770.53, 609.421, 97.2463, 0, 0, 0, 0, 100, 0),
(188983, 51, -8795.9, 587.923, 97.3792, 0, 0, 0, 0, 100, 0),
(188983, 52, -8827.8, 624.687, 93.8494, 0, 0, 0, 0, 100, 0),
(188983, 53, -8928.94, 540.519, 94.3157, 0, 0, 0, 0, 100, 0),
(188983, 54, -8907.67, 509.135, 93.8416, 0, 0, 0, 0, 100, 0),
(188983, 55, -8933.21, 488.088, 93.8429, 0, 1000, 0, 0, 100, 0),
(188983, 56, -8933.21, 488.088, 93.8429, 0, 16000, 0, 0, 100, 0),
(188983, 57, -8911.65, 505.615, 93.8585, 0, 0, 0, 0, 100, 0),
(188983, 58, -8925.24, 543.334, 94.268, 0, 1250, 0, 0, 100, 0),
(188983, 59, -8833.34, 620.843, 93.4683, 0, 0, 0, 0, 100, 0),
(188983, 60, -8854.67, 660.036, 96.8874, 0, 0, 0, 0, 100, 0),
(188983, 61, -8838.52, 670.28, 98.0987, 0, 5000, 0, 0, 100, 0),
(6183, 1, -8773.94, 903.74, 100.521, 0, 0, 0, 0, 100, 0),
(6183, 2, -8815.03, 954.304, 100.767, 0, 0, 0, 0, 100, 0),
(6183, 3, -8850.27, 932.19, 102.528, 0, 0, 0, 0, 100, 0),
(6183, 4, -8895.27, 911.404, 110.834, 0, 0, 0, 0, 100, 0),
(6183, 5, -8923.64, 952.425, 117.251, 0, 0, 0, 0, 100, 0),
(6183, 6, -8952.45, 951.203, 117.028, 0, 0, 0, 0, 100, 0),
(6183, 7, -8979.83, 964.815, 116.279, 0, 0, 0, 0, 100, 0),
(6183, 8, -9001.24, 964.721, 116.316, 0, 0, 0, 0, 100, 0),
(6183, 9, -9013.25, 954.157, 116.255, 0, 0, 0, 0, 100, 0),
(6183, 10, -9008.13, 944.594, 116.937, 0, 0, 0, 0, 100, 0),
(6183, 11, -8997.53, 944.59, 115.095, 0, 0, 0, 0, 100, 0),
(6183, 12, -8995.56, 944.59, 117.095, 0, 10, 0, 0, 100, 0),
(6183, 13, -8995.56, 944.59, 117.095, 0, 21000, 0, 0, 100, 0),
(6183, 14, -8997.53, 944.59, 115.095, 0, 0, 0, 0, 100, 0),
(6183, 15, -9008.13, 944.594, 117.937, 0, 0, 0, 0, 100, 0),
(6183, 16, -9013.25, 954.157, 117.255, 0, 0, 0, 0, 100, 0),
(6183, 17, -9001.24, 964.721, 117.316, 0, 0, 0, 0, 100, 0),
(6183, 18, -8979.83, 964.815, 117.279, 0, 0, 0, 0, 100, 0),
(6183, 19, -8952.45, 951.203, 117.028, 0, 0, 0, 0, 100, 0),
(6183, 20, -8923.64, 952.425, 117.251, 0, 0, 0, 0, 100, 0),
(6183, 21, -8895.27, 911.404, 110.834, 0, 0, 0, 0, 100, 0),
(6183, 22, -8850.27, 932.19, 102.528, 0, 0, 0, 0, 100, 0),
(6183, 23, -8815.03, 954.304, 100.767, 0, 0, 0, 0, 100, 0),
(6183, 24, -8773.94, 903.74, 100.521, 0, 0, 0, 0, 100, 0),
(6183, 25, -8831.75, 942.784, 104.586, 0, 0, 0, 0, 100, 0);
DELETE FROM `creature_formations` WHERE `leaderGUID` = 188983 OR `memberGUID` IN (6183, 188983, 188984, 188985, 188986, 188987, 188988, 188989, 188990);
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`, `point_1`, `point_2`) VALUES
(188983, 188983, 0, 0, 514, 0, 0),
(188983, 188984, 3, 360, 514, 0, 0),
(188983, 188985, 3, 300, 514, 0, 0),
(188983, 188986, 3, 60, 514, 0, 0),
(188983, 188987, 3, 330, 514, 0, 0),
(188983, 188988, 3, 90, 514, 0, 0),
(188983, 188989, 3, 270, 514, 0, 0),
(188983, 188990, 3, 30, 514, 0, 0);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (3505, 3507, 3508, 3509, 3510, 3511, 3512) AND `id` < 100;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 3513;
DELETE FROM `smart_scripts` WHERE `source_type` = 9 AND `entryorguid` BETWEEN 351300 AND 351306;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3505, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Pat - On Data Set 1 1 - Set Orientation (0.658629)'),
(3505, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Pat - On Data Set 2 2 - Set Orientation (5.378945)'),
(3505, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Pat - On Data Set 3 3 - Set Orientation (3.849771)'),
(3507, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Andi - On Data Set 1 1 - Set Orientation (0.658629)'),
(3507, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Andi - On Data Set 2 2 - Set Orientation (5.378945)'),
(3507, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Andi - On Data Set 3 3 - Set Orientation (3.849771)'),
(3508, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Mikey - On Data Set 1 1 - Set Orientation (0.658629)'),
(3508, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Mikey - On Data Set 2 2 - Set Orientation (5.378945)'),
(3508, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Mikey - On Data Set 3 3 - Set Orientation (3.849771)'),
(3509, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Geoff - On Data Set 1 1 - Set Orientation (0.658629)'),
(3509, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Geoff - On Data Set 2 2 - Set Orientation (5.378945)'),
(3509, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Geoff - On Data Set 3 3 - Set Orientation (3.849771)'),
(3510, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Twain - On Data Set 1 1 - Set Orientation (0.658629)'),
(3510, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Twain - On Data Set 2 2 - Set Orientation (5.378945)'),
(3510, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Twain - On Data Set 3 3 - Set Orientation (3.849771)'),
(3511, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Steven - On Data Set 1 1 - Set Orientation (0.658629)'),
(3511, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Steven - On Data Set 2 2 - Set Orientation (5.378945)'),
(3511, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Steven - On Data Set 3 3 - Set Orientation (3.849771)'),
(3512, 0, 0, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Jimmy - On Data Set 1 1 - Set Orientation (0.658629)'),
(3512, 0, 1, 0, 38, 0, 100, 0, 2, 2, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Jimmy - On Data Set 2 2 - Set Orientation (5.378945)'),
(3512, 0, 2, 0, 38, 0, 100, 0, 3, 3, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Jimmy - On Data Set 3 3 - Set Orientation (3.849771)'),
(3513, 0, 0, 0, 34, 0, 100, 0, 2, 20, 0, 0, 0, '', 80, 351300, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 20 P - Start Script (00)'),
(3513, 0, 1, 0, 34, 0, 100, 0, 2, 34, 0, 0, 0, '', 80, 351301, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 34 P - Start Script (01)'),
(3513, 0, 2, 0, 34, 0, 100, 0, 2, 35, 0, 0, 0, '', 80, 351302, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 35 P - Start Script (02)'),
(3513, 0, 3, 0, 34, 0, 100, 0, 2, 37, 0, 0, 0, '', 80, 351303, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 37 P - Start Script (03)'),
(3513, 0, 4, 0, 34, 0, 100, 0, 2, 51, 0, 0, 0, '', 80, 351304, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 51 P - Start Script (04)'),
(3513, 0, 5, 0, 34, 0, 100, 0, 2, 52, 0, 0, 0, '', 80, 351305, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 52 P - Start Script (05)'),
(3513, 0, 6, 0, 34, 0, 100, 0, 2, 54, 0, 0, 0, '', 80, 351306, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On MI 54 P - Start Script (06)'),
(351300, 9, 0, 0, 0, 0, 100, 0, 1000, 1000, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0.658629, 'Miss Danna - On Script - Set Orientation (0.658629)'),
(351300, 9, 1, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3512, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3512, 25 Yards)'),
(351300, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3508, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3508, 25 Yards)'),
(351300, 9, 3, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3505, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3505, 25 Yards)'),
(351300, 9, 4, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3511, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3511, 25 Yards)'),
(351300, 9, 5, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3510, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3510, 25 Yards)'),
(351300, 9, 6, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3507, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3507, 25 Yards)'),
(351300, 9, 7, 0, 0, 0, 100, 0, 100, 100, 0, 0, 0, '', 45, 1, 1, 0, 0, 0, 0, 19, 3509, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 1 1 (Creature ID: 3509, 25 Yards)'),
(351300, 9, 8, 0, 0, 0, 100, 0, 1500, 1500, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 0'),
(351300, 9, 9, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351300, 9, 10, 0, 0, 0, 100, 0, 3000, 3000, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 19, 3512, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 0 (Creature ID: 3512, 25 Yards)'),
(351300, 9, 11, 0, 0, 0, 100, 0, 3500, 3500, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 1'),
(351300, 9, 12, 0, 0, 0, 100, 0, 5000, 5000, 0, 0, 0, '', 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 2'),
(351301, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 3'),
(351301, 9, 1, 0, 0, 0, 100, 0, 200, 200, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351302, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 4'),
(351302, 9, 1, 0, 0, 0, 100, 0, 200, 200, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351303, 9, 0, 0, 0, 0, 100, 0, 1500, 1500, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 5.37894, 'Miss Danna - On Script - Set Orientation (5.378945)'),
(351303, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351303, 9, 2, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3512, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3512, 25 Yards)'),
(351303, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3508, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3508, 25 Yards)'),
(351303, 9, 4, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3505, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3505, 25 Yards)'),
(351303, 9, 5, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3511, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3511, 25 Yards)'),
(351303, 9, 6, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3510, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3510, 25 Yards)'),
(351303, 9, 7, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3507, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3507, 25 Yards)'),
(351303, 9, 8, 0, 0, 0, 100, 0, 100, 100, 0, 0, 0, '', 45, 2, 2, 0, 0, 0, 0, 19, 3509, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 2 2 (Creature ID: 3509, 25 Yards)'),
(351303, 9, 9, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 19, 3511, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 0 (Creature ID: 3511, 25 Yards)'),
(351303, 9, 10, 0, 0, 0, 100, 0, 3500, 3500, 0, 0, 0, '', 1, 5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 5'),
(351303, 9, 11, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351304, 9, 1, 0, 0, 0, 100, 0, 200, 200, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351305, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 1, 7, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 7'),
(351305, 9, 1, 0, 0, 0, 100, 0, 200, 200, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351306, 9, 0, 0, 0, 0, 100, 0, 1500, 1500, 0, 0, 0, '', 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 3.84977, 'Miss Danna - On Script - Set Orientation (3.849771)'),
(351306, 9, 1, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3512, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3512, 25 Yards)'),
(351306, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3508, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3508, 25 Yards)'),
(351306, 9, 3, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3505, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3505, 25 Yards)'),
(351306, 9, 4, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3511, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3511, 25 Yards)'),
(351306, 9, 5, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3510, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3510, 25 Yards)'),
(351306, 9, 6, 0, 0, 0, 100, 0, 500, 500, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3507, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3507, 25 Yards)'),
(351306, 9, 7, 0, 0, 0, 100, 0, 100, 100, 0, 0, 0, '', 45, 3, 3, 0, 0, 0, 0, 19, 3509, 25, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Set Data 3 3 (Creature ID: 3509, 25 Yards)'),
(351306, 9, 8, 0, 0, 0, 100, 0, 2500, 2500, 0, 0, 0, '', 1, 8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Say Text Line 8'),
(351306, 9, 9, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)'),
(351306, 9, 10, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Miss Danna - On Script - Play Emote (1)');
DELETE FROM `creature_text` WHERE `CreatureID` IN (3511, 3512, 3513);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(3511, 0, 0, 'Why do we have to learn this stuff anyway?', 12, 7, 100, 1, 0, 0, 0, 0, 'Steven'),
(3512, 0, 0, 'Is it true that the paladins train here?', 12, 7, 100, 1, 0, 0, 0, 0, 'Jimmy'),
(3513, 0, 0, 'Here we have the Cathedral of Light, the center of spiritual enlightenment here in Stormwind.', 12, 7, 100, 1, 0, 0, 0, 0, 'Miss Danna'),
(3513, 1, 0, 'Yes, that is true. Paladins and Priests alike train their skills and research great truths behind the walls of the Cathedral.', 12, 7, 100, 1, 0, 0, 0, 0, 'Miss Danna'),
(3513, 2, 0, 'Children if you would please follow me, we will now be going to see the keep where King Anduin Wrynn himself sits on his throne.', 12, 7, 100, 1, 0, 0, 0, 0, 'Miss Danna'),
(3513, 3, 0, 'Here we have Stormwind Keep. Built upon the ruins of Stormwind Castle, which was destroyed by the Horde in the first Great War.', 12, 7, 100, 0, 0, 0, 0, 0, 'Miss Danna'),
(3513, 4, 0, 'When the Horde was shattered, men returned here and began to rebuild the once great city as a testament to our own survival.', 12, 7, 100, 0, 0, 0, 0, 0, 'Miss Danna'),
(3513, 5, 0, 'Yes, well... let\'s head on to the monument dedicated to the heroes of the two Great Wars, the Valley of Heroes. Follow me.', 12, 7, 100, 1, 0, 0, 0, 0, 'Miss Danna'),
(3513, 7, 0, 'Breathtaking. Children, when we return to the school, you will each give an oral report on one of these legendary people.', 12, 7, 100, 0, 0, 0, 0, 0, 'Miss Danna'),
(3513, 8, 0, 'Now, take another long look before we make our way to the Holy District and the great Cathedral of Light.', 12, 7, 100, 1, 0, 0, 0, 0, 'Miss Danna');
