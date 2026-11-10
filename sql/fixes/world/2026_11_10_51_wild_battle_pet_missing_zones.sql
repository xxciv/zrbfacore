-- Wild battle pets: zones whose pets never spawned (zrbfacore, 2026-11-10)
--
-- Audit of every battlepet_wild_zone_pool row for a capturable species, after all earlier pet SQL
-- (2026_11_01_50, 2026_11_04_50, 2026_11_07_50/51, 2026_11_10_50): 626 of 647 rows have battle
-- pets in their zone. Of the 21 without any, this file fixes 11; the rest have no spawn data
-- (see the end of this header).
--
-- 1. Seven pool rows name the plain critter as the BattlePetEntry and have no CreatureEntry, so
--    2026_11_01_50 never touched them (the Darkmoon Crow had the same problem). Their critters
--    are converted into the species' real battle pet, up to the zone's Max:
--      Tanaris Sea Gull 55749 -> 62953 (9), Howling Fjord Turkey 23801 -> 62648 (1),
--      Ghostlands Small Frog 70495 -> 61071 (3), Jade Forest Temple Snake 58698 -> 62999 (2),
--      Frostfire Ridge Icespine Hatchling 88441 -> 85003 (20), Gorgrond Thicket Skitterer
--      88462 -> 85007 (16), Nagrand (Draenor) Shore Crab 60761 -> 61158 (13).
-- 2. Swamp of Sorrows Moccasin: its pool row points at the Water Snake 61367 instead of the
--    Moccasin 61372, so the Moccasin never appeared. Up to 32 of the zone's remaining Water Snake
--    critters 4953 become Moccasins.
-- 3. Undercity Rat 61889: the world DB files Undercity's rats under Tirisfal (zone 85, Ruins of
--    Lordaeron area 153), so the Undercity pool row (zone 1497) found none. Those 28 rat critters
--    49965 become battle Undercity Rats.
-- 4. Ironforge Long-tailed Mole 61317 and Undercity Bat 61829: no critters at all in the world DB.
--    Added from the alexkulya Pandaria 5.4.8 world DB (guids 1000100001-1000100028): 21 Ironforge moles
--    (3 battle Moles, Max 3) and 7 bats in the Ruins of Lordaeron (2 battle Bats, Max 2).
--
-- Every conversion is recorded in zr_wild_battlepet_conversion (same table and undo as
-- 2026_11_01_50). Undo the added spawns with: DELETE FROM creature WHERE guid BETWEEN 1000100001 AND 1000100028;
--
-- Not fixed (no critters or spawn data anywhere to use): Wetlands Highlands Mouse, Exodar Mouse,
-- Shadowmoon Valley (Outland) Warpstalker Hatchling (it lives in Terokkar, 27 spawns there),
-- Talador Crimsonwing Moth, Frostfire Ironclaw Scuttler, Gorgrond Sapphire Firefly, Azsuna
-- Fledgling Kingfeather and Eldritch Manafiend, Undercity Lost of Lordaeron (33 in Tirisfal).

CREATE TABLE IF NOT EXISTS `zr_wild_battlepet_conversion` (
  `guid` bigint unsigned NOT NULL,
  `old_id` int unsigned NOT NULL,
  `new_id` int unsigned NOT NULL,
  `old_modelid` int unsigned NOT NULL DEFAULT '0',
  `zone` int unsigned NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP PROCEDURE IF EXISTS `zr_convert_pets`;
DELIMITER //
CREATE PROCEDURE `zr_convert_pets`(IN p_zone INT UNSIGNED, IN p_area INT UNSIGNED, IN p_critter INT UNSIGNED,
                                   IN p_pet INT UNSIGNED, IN p_max INT UNSIGNED)
BEGIN
  DECLARE v_have, v_need INT UNSIGNED;
  -- p_area = 0: anywhere in the zone (zoneId or areaId); otherwise that area only
  SELECT COUNT(*) INTO v_have FROM creature
   WHERE id = p_pet AND IF(p_area = 0, zoneId = p_zone OR areaId = p_zone, areaId = p_area);
  IF v_have < p_max THEN
    SET v_need = p_max - v_have;
    INSERT IGNORE INTO zr_wild_battlepet_conversion (guid, old_id, new_id, old_modelid, zone)
      SELECT guid, id, p_pet, modelid, p_zone FROM creature
       WHERE id = p_critter AND IF(p_area = 0, zoneId = p_zone OR areaId = p_zone, areaId = p_area)
         AND NOT EXISTS (SELECT 1 FROM smart_scripts s WHERE s.source_type = 0 AND s.entryorguid = -CAST(creature.guid AS SIGNED))
       ORDER BY RAND() LIMIT v_need;
    UPDATE creature c JOIN zr_wild_battlepet_conversion b ON b.guid = c.guid
       SET c.id = b.new_id, c.modelid = 0
     WHERE b.new_id = p_pet AND c.id = p_critter;
  END IF;
END//
DELIMITER ;

-- 1. pool rows that name the critter as the battle pet
CALL zr_convert_pets(440,  0, 55749, 62953,  9);  -- Tanaris Sea Gull
CALL zr_convert_pets(495,  0, 23801, 62648,  1);  -- Howling Fjord Turkey
CALL zr_convert_pets(3433, 0, 70495, 61071,  3);  -- Ghostlands Small Frog
CALL zr_convert_pets(5785, 0, 58698, 62999,  2);  -- Jade Forest Temple Snake
CALL zr_convert_pets(6720, 0, 88441, 85003, 20);  -- Frostfire Ridge Icespine Hatchling
CALL zr_convert_pets(6722, 0, 88462, 85007, 16);  -- Gorgrond Thicket Skitterer
CALL zr_convert_pets(6755, 0, 60761, 61158, 13);  -- Nagrand Shore Crab
-- 2. Swamp of Sorrows Moccasin
CALL zr_convert_pets(8,    0, 4953,  61372, 32);
-- 3. Undercity Rat (filed under Tirisfal, Ruins of Lordaeron)
CALL zr_convert_pets(85, 153, 49965, 61889, 28);

DROP PROCEDURE `zr_convert_pets`;

-- 4. Ironforge moles and Undercity bats from the alexkulya DB
DELETE FROM `creature` WHERE `guid` BETWEEN 1000100001 AND 1000100028;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1000100001, 61317, 0, 1537, 1537, '0', 0, 0, 0, -1, 0, 0, -5088.19, -1285.69, 501.967, 5.05524, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100002, 48972, 0, 1537, 1537, '0', 0, 0, 0, -1, 0, 0, -5054.51, -1286.23, 501.964, 0.295281, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100003, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4628.5, -1315.84, 502.12, 0.714923, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100004, 48972, 0, 1537, 5342, '0', 0, 0, 0, -1, 0, 0, -4802.04, -1004.68, 510.811, 2.74627, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100005, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4680.12, -1170.06, 501.637, 2.01694, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100006, 48972, 0, 1537, 5719, '0', 0, 0, 0, -1, 0, 0, -4841.17, -878.942, 501.659, 2.72279, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100007, 61317, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4589.65, -1218.25, 503.382, 4.18298, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100008, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4707.38, -1172.82, 505.269, 2.80848, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100009, 48972, 0, 1537, 5719, '0', 0, 0, 0, -1, 0, 0, -4967.52, -1010.67, 503.87, 2.2802, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100010, 48972, 0, 1537, 1537, '0', 0, 0, 0, -1, 0, 0, -5087.09, -1283.22, 501.967, 1.1701, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100011, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4684.23, -1310.59, 503.382, 1.89769, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100012, 48972, 0, 1537, 5344, '0', 0, 0, 0, -1, 0, 0, -4714.07, -958.046, 511.952, 3.65651, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100013, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4731.26, -1334.3, 503.382, 2.4444, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100014, 48972, 0, 1537, 5344, '0', 0, 0, 0, -1, 0, 0, -4717.51, -873.97, 508.622, 2.75747, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100015, 48972, 0, 1537, 5341, '0', 0, 0, 0, -1, 0, 0, -4697.26, -1325.04, 503.382, 4.14049, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100016, 61317, 0, 1537, 4679, '0', 0, 0, 0, -1, 0, 0, -4629.91, -1047.36, 501.034, 0.0671708, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100017, 48972, 0, 1537, 5719, '0', 0, 0, 0, -1, 0, 0, -5017.64, -1112.54, 501.682, 1.07748, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100018, 48972, 0, 1537, 5342, '0', 0, 0, 0, -1, 0, 0, -4767.9, -1188.09, 502.728, 3.15582, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100019, 48972, 0, 1537, 5342, '0', 0, 0, 0, -1, 0, 0, -4858.61, -1152.04, 502.205, 5.04175, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100020, 48972, 0, 1537, 5344, '0', 0, 0, 0, -1, 0, 0, -4686.66, -867.135, 510.561, 1.02922, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100021, 48972, 0, 1537, 1537, '0', 0, 0, 0, -1, 0, 0, -5053.15, -1290.22, 501.964, 5.17482, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0),
(1000100022, 61829, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1796.57, 219.928, 72.1103, 3.54235, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100023, 20725, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1797.07, 229.105, 75.4921, 0.393875, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100024, 20725, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1821.3, 217.617, 74.7062, 0.587398, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100025, 20725, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1805.05, 205.678, 72.1103, 5.29126, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100026, 61829, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1814.74, 225.639, 72.1103, 4.67498, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100027, 20725, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1799.8, 198.744, 75.4921, 4.6869, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0),
(1000100028, 20725, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1828.76, 216.215, 74.7062, 4.43024, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);

SELECT CONCAT(
  (SELECT COUNT(*) FROM creature WHERE id = 62953 AND (zoneId = 440 OR areaId = 440)), ' Sea Gulls, ',
  (SELECT COUNT(*) FROM creature WHERE id = 85003 AND (zoneId = 6720 OR areaId = 6720)), ' Icespine Hatchlings, ',
  (SELECT COUNT(*) FROM creature WHERE id = 61372 AND (zoneId = 8 OR areaId = 8)), ' Moccasins, ',
  (SELECT COUNT(*) FROM creature WHERE id = 61889), ' Undercity Rats, ',
  (SELECT COUNT(*) FROM creature WHERE id = 61317 AND zoneId = 1537), ' Ironforge Moles') AS zr_result;
