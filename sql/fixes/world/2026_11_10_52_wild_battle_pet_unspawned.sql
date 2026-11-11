-- Wild battle pets: spawn the zone pets that have no spawn data at all (zrbfacore, 2026-11-10)
--
-- After 2026_11_10_51, six zone pets from battlepet_wild_zone_pool still had no spawns and no
-- critters anywhere in the world DB to convert. Four agreed (2026-11-10) to place them at existing
-- critter spots in their zone: each spawn sits 1 yard from a randomly picked, unscripted, unphased
-- critter of that zone and wanders 3 yards. Counts follow each zone's Max:
--   Exodar Mouse 61143 (1), Talador Crimsonwing Moth 88413 (1), Frostfire Ridge Ironclaw Scuttler
--   88474 (2), Gorgrond Sapphire Firefly 88356 (1), Azsuna Fledgling Kingfeather 97076 (1),
--   Azsuna Eldritch Manafiend 98386 (4). The spots do not match retail exactly.
-- Eldritch Manafiend's battlepet_info template was 1-25; set to 1-1 so Azsuna's zone range decides
-- its level (see 2026_11_04_50). The other five were already 1-1.
--
-- Left alone on purpose: Undercity Rat and Lost of Lordaeron (they exist, filed under Tirisfal),
-- Shadowmoon Valley Warpstalker Hatchling (lives in Terokkar) and Wetlands Highlands Mouse
-- (Twilight Highlands pet); those last two look like wrong pool rows.
--
-- Undo: DELETE FROM creature WHERE guid BETWEEN 1000100029 AND 1000100038;
--       UPDATE battlepet_info SET maxlevel = 25 WHERE NpcID = 98386;

UPDATE `battlepet_info` SET `minlevel` = 1, `maxlevel` = 1 WHERE `NpcID` = 98386;

DELETE FROM `creature` WHERE `guid` BETWEEN 1000100029 AND 1000100038;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1000100029, 61143, 530, 3557, 3557, '0', 0, 0, 0, -1, 0, 0, -4099.15, -11930.8, 3.80229, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Exodar), next to critter 10653181
(1000100030, 88413, 1116, 6662, 6662, '0', 0, 0, 0, -1, 0, 0, 1748.59, 3548.36, 139.519, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Crimsonwing Moth (Talador), next to critter 1396037
(1000100031, 88474, 1116, 6720, 6968, '0', 0, 0, 0, -1, 0, 0, 7665.27, 4758.43, 129.445, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Ironclaw Scuttler (Frostfire Ridge), next to critter 1412432
(1000100032, 88474, 1116, 6720, 7013, '0', 0, 0, 0, -1, 0, 0, 7731.01, 4960.27, 124.323, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Ironclaw Scuttler (Frostfire Ridge), next to critter 1412245
(1000100033, 88356, 1116, 6722, 6998, '0', 0, 0, 0, -1, 0, 0, -1646.72, 1024.76, 7.52922, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sapphire Firefly (Gorgrond), next to critter 1454900
(1000100034, 97076, 1220, 7334, 7361, '0', 0, 0, 0, -1, 0, 0, 1138.00, 6133.12, 80.168, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fledgling Kingfeather (Azsuna), next to critter 20502929
(1000100035, 98386, 1220, 7334, 7365, '0', 0, 0, 0, -1, 0, 0, -118.06, 5751.45, 0.534232, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Eldritch Manafiend (Azsuna), next to critter 20505443
(1000100036, 98386, 1220, 7334, 7359, '0', 0, 0, 0, -1, 0, 0, 1185.32, 6626.1, 154.849, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Eldritch Manafiend (Azsuna), next to critter 20502215
(1000100037, 98386, 1220, 7334, 7521, '0', 0, 0, 0, -1, 0, 0, -664.37, 6534.73, 114.899, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Eldritch Manafiend (Azsuna), next to critter 20507590
(1000100038, 98386, 1220, 7334, 7362, '0', 0, 0, 0, -1, 0, 0, -245.36, 7163.23, 10.4716, 0, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0); -- Eldritch Manafiend (Azsuna), next to critter 20501149

SELECT CONCAT(COUNT(*), ' new zone pet spawns') AS zr_result FROM `creature` WHERE `guid` BETWEEN 1000100029 AND 1000100038;
