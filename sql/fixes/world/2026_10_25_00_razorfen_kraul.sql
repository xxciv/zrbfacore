-- Razorfen Kraul (map 47), pre-run check (2026-10-25).
--
-- The BFA spawns are the Pandaria 5.4.8 set with three classic bosses swapped for the Warlords
-- versions: Aggem Thorncurse -> Hunter Bonetusk (75001), Overlord Ramtusk -> Warlord Ramtusk (74462)
-- and a Razorfen Groundshaker beside Death Speaker Jargba -> Roogug (74948). Two swaps were missed.

-- Groyat, the Blind Hunter (75247) is one of the scenario's five bosses but had no spawn; the classic
-- Blind Hunter (4425) stood in his room instead. Turn that spawn into Groyat, and give him the
-- scaling row for the dungeon's difficulty he was missing.
UPDATE `creature` SET `id`=75247, `modelid`=0, `equipment_id`=0 WHERE `guid`=52982 AND `id` IN (4425, 75247);
DELETE FROM `creature_template_scaling` WHERE `Entry`=75247 AND `DifficultyID`=1;
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(75247, 1, 1, 100, 0, 0, 0, 0);

-- The classic Roogug (6168) was still spawned as well as the new one, so there were two Roogugs.
-- Remove the classic spawn.
DELETE FROM `creature` WHERE `guid`=325276 AND `id`=6168;
DELETE FROM `creature_addon` WHERE `guid`=325276;

-- Dungeon encounters. Only 438 Roogug existed, pointing at the classic Roogug. Use the client's
-- DungeonEncounter rows for map 47: 438 Roogug, 1656 Hunter Bonetusk, 1659 Warlord Ramtusk,
-- 1660 Groyat, 1661 Charlga Razorflank (last boss of dungeon finder entry 16, Razorfen Kraul).
DELETE FROM `instance_encounters` WHERE `entry` IN (438, 1656, 1659, 1660, 1661);
INSERT INTO `instance_encounters` (`entry`, `creditType`, `creditEntry`, `lastEncounterDungeon`, `comment`) VALUES
(438, 0, 74948, 0, 'Razorfen Kraul - Roogug'),
(1656, 0, 75001, 0, 'Razorfen Kraul - Hunter Bonetusk'),
(1659, 0, 74462, 0, 'Razorfen Kraul - Warlord Ramtusk'),
(1660, 0, 75247, 0, 'Razorfen Kraul - Groyat, the Blind Hunter'),
(1661, 0, 4421, 16, 'Razorfen Kraul - Charlga Razorflank');

-- Razorfen Handler (4530), Beast Trainer (4531) and Beastmaster (4532) each had two SmartAI scripts
-- mixed together, both summoning the pet on spawn, so each brought two pets. Drop the second summon.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (4530, 4531, 4532) AND `source_type`=0 AND `id`=12 AND `event_type`=11;

-- Movement. The BFA database had no waypoint paths and no wandering on map 47. Matched by entry and
-- position (or, where Cataclysm swapped the entry on a spot, the nearest spawn within 5 yards):
-- 5 paths from the Pandaria 5.4.8 database (same guids), 4 from the AzerothCore 3.3.5 database
-- (including Agathelos), and AzerothCore's random wandering for 46 spawns, capped at 5 yards.
-- Path ids 47000001+ are new.
DELETE FROM `waypoint_data` WHERE `id` BETWEEN 47000001 AND 47000999;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES
(47000001, 1, 2193.45, 1819.74, 61.8994, 0, 0, 0, 0, 100, 0),
(47000001, 2, 2194.44, 1819.92, 61.8994, 0, 0, 0, 0, 100, 0),
(47000001, 3, 2195.3, 1820.55, 61.8445, 0, 0, 0, 0, 100, 0),
(47000001, 4, 2197.27, 1821.99, 61.8816, 0, 0, 0, 0, 100, 0),
(47000001, 5, 2196.25, 1830.12, 61.3121, 0, 0, 0, 0, 100, 0),
(47000001, 6, 2196.08, 1831.45, 61.2234, 0, 0, 0, 0, 100, 0),
(47000001, 7, 2196.08, 1831.45, 61.2234, 0, 0, 0, 0, 100, 0),
(47000002, 1, 2162.25, 1857.61, 56.9991, 0, 0, 0, 0, 100, 0),
(47000002, 2, 2187.9, 1836.53, 59.9296, 0, 0, 0, 0, 100, 0),
(47000002, 3, 2162.25, 1857.61, 56.9991, 0, 0, 0, 0, 100, 0),
(47000002, 4, 2145.03, 1848.63, 49.5718, 0, 0, 0, 0, 100, 0),
(47000003, 1, 2192.38, 1903.5, 71.0586, 0, 0, 0, 0, 100, 0),
(47000003, 2, 2193.25, 1903, 71.0586, 0, 0, 0, 0, 100, 0),
(47000003, 3, 2190.9, 1904.34, 71.086, 0, 0, 0, 0, 100, 0),
(47000003, 4, 2183.02, 1908.8, 70.3085, 0, 0, 0, 0, 100, 0),
(47000003, 5, 2180.77, 1910.07, 70.0415, 0, 0, 0, 0, 100, 0),
(47000003, 6, 2179.25, 1910.94, 69.8276, 0, 0, 0, 0, 100, 0),
(47000003, 7, 2179.25, 1910.94, 69.8276, 0, 0, 0, 0, 100, 0),
(47000004, 1, 2036.34, 1656.67, 80.226, 0, 0, 0, 0, 100, 0),
(47000004, 2, 2035.37, 1656.88, 80.226, 0, 0, 0, 0, 100, 0),
(47000004, 3, 2033.54, 1658.19, 80.0875, 0, 0, 0, 0, 100, 0),
(47000004, 4, 2031.87, 1659.4, 80.0941, 0, 0, 0, 0, 100, 0),
(47000004, 5, 2030.43, 1660.44, 80.9365, 0, 0, 0, 0, 100, 0),
(47000004, 6, 2030.43, 1660.44, 80.9365, 0, 0, 0, 0, 100, 0),
(47000005, 1, 2093.21, 1739.26, 78.4485, 0, 0, 0, 0, 100, 0),
(47000005, 2, 2093.51, 1738.3, 78.4485, 0, 0, 0, 0, 100, 0),
(47000005, 3, 2094.43, 1737.12, 78.7596, 0, 0, 0, 0, 100, 0),
(47000005, 4, 2098.89, 1731.4, 78.1548, 0, 0, 0, 0, 100, 0),
(47000005, 5, 2103.19, 1725.89, 78.1256, 0, 0, 0, 0, 100, 0),
(47000005, 6, 2106.92, 1721.12, 78.5222, 0, 0, 0, 0, 100, 0),
(47000005, 7, 2114.58, 1711.29, 81.1165, 0, 0, 0, 0, 100, 0),
(47000005, 8, 2114.58, 1711.29, 81.1165, 0, 0, 0, 0, 100, 0),
(47000006, 1, 2116.94, 1439.54, 64.0232, 0, 0, 0, 0, 100, 0),
(47000006, 2, 2132.24, 1465.09, 66.4455, 0, 0, 0, 0, 100, 0),
(47000006, 3, 2155.46, 1478.35, 67.0293, 0, 0, 0, 0, 100, 0),
(47000006, 4, 2132.24, 1465.09, 66.4455, 0, 0, 0, 0, 100, 0),
(47000007, 1, 2070.68, 1846.22, 55.0831, 0, 0, 0, 0, 100, 0),
(47000007, 2, 2109.22, 1854.23, 49.3642, 0, 0, 0, 0, 100, 0),
(47000007, 3, 2131.82, 1834.13, 47.0597, 0, 0, 0, 0, 100, 0),
(47000007, 4, 2109.22, 1854.23, 49.3642, 0, 0, 0, 0, 100, 0),
(47000008, 1, 2132.63, 1502.59, 72.9424, 0, 0, 0, 0, 100, 0),
(47000008, 2, 2133.19, 1503.42, 72.9424, 0, 0, 0, 0, 100, 0),
(47000008, 3, 2134.17, 1504.86, 72.8372, 0, 0, 0, 0, 100, 0),
(47000008, 4, 2135.78, 1506.29, 72.7513, 0, 0, 0, 0, 100, 0),
(47000008, 5, 2139.84, 1509.89, 72.4923, 0, 0, 0, 0, 100, 0),
(47000008, 6, 2139.84, 1509.89, 72.4923, 0, 0, 0, 0, 100, 0),
(47000009, 1, 1994.4, 1976.44, 63.292, 0, 0, 0, 0, 100, 0),
(47000009, 2, 2017.38, 2002.92, 61.6866, 0, 0, 0, 0, 100, 0);
-- Path owners: 325280 (4517, Pandaria), 325287 (4437, AzerothCore), 325300 (4531, Pandaria), 325303 (4436, Pandaria), 325327 (4623, Pandaria), 325349 (4442, AzerothCore), 325361 (4511, AzerothCore), 325405 (6035, Pandaria), 325408 (4422, AzerothCore)
UPDATE `creature` SET `MovementType`=2, `spawndist`=0, `currentwaypoint`=0 WHERE `guid` IN (325280, 325287, 325300, 325303, 325327, 325349, 325361, 325405, 325408);
INSERT INTO `creature_addon` (`guid`, `path_id`) VALUES
(325280, 47000001),
(325287, 47000002),
(325300, 47000003),
(325303, 47000004),
(325327, 47000005),
(325349, 47000006),
(325361, 47000007),
(325405, 47000008),
(325408, 47000009)
ON DUPLICATE KEY UPDATE `path_id`=VALUES(`path_id`);
-- Random wandering (AzerothCore wander radius, at most 5 yards).
UPDATE `creature` SET `MovementType`=1, `spawndist`=1 WHERE `MovementType`=0 AND `guid` IN (325314, 325317, 325319, 325320, 325375, 325378);
UPDATE `creature` SET `MovementType`=1, `spawndist`=2 WHERE `MovementType`=0 AND `guid` IN (325297, 325336, 325353, 325355, 325394, 325395, 325396);
UPDATE `creature` SET `MovementType`=1, `spawndist`=3 WHERE `MovementType`=0 AND `guid` IN (325255, 325256, 325257, 325259, 325260, 325261, 325262, 325265, 325266, 325267, 325268, 325269, 325270, 325272, 325273, 325275, 325312, 325360, 325362, 325367, 325370, 325371, 325374, 325397, 325398, 325399, 325400);
UPDATE `creature` SET `MovementType`=1, `spawndist`=5 WHERE `MovementType`=0 AND `guid` IN (124143, 325306, 325318, 325363, 325403, 325404);
