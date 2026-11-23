-- Lower Blackrock Spire (map 229): Spirestone ogres two to a spot, and two rares that always spawn, 2026-11-23.
-- Goes with 2026_11_23_05 (pools 22906-22908) and 2026_11_23_09.
--
-- Four, 2026-11-23: "ogres are doubled up. spirestone butcher and spirestone battle lord (both rares) both spawned."
--
-- 1. Seven spawns stand 0.7-1.9 yards from another mob (2026_11_23_09 only took pairs under 0.6 y). Pandaria has
--    the same rows. Removed: Spirestone Reavers 323138 (0.8 y from Reaver 322721), 323132 and 322709 (both on the
--    Spirestone Battle Lord's pool spot 49191), 323153 (on Mystic 322719), Ogre Magus 323139 (on Mystic 322722), and
--    the last two Scarshield copies, Spellbinder 323035 (0.7 y from Legionnaire 322518) and Legionnaire 323044
--    (0.8 y from Spellbinder 322773). Reavers go from 7 to 3, as in AzerothCore.
--    None has a formation, pool, per-guid script, linked respawn or quest objective.
-- 2. Spirestone Butcher 322713 and Spirestone Lord Magus 323152 (rares) were outside their pools, so each spawned
--    every time. Both join the pool of their kind: one Butcher at 12% across its three spots (4% each), one Lord
--    Magus at 12% across two spots (6% each). The Battle Lord keeps its own pool, so two different rares can still
--    show up in one run now and then, as in Pandaria.
-- Backups zr_backup_lbrs_spirestone_creature, zr_backup_lbrs_spirestone_creature_addon.
-- Undo: INSERT INTO `creature` SELECT * FROM `zr_backup_lbrs_spirestone_creature`; INSERT INTO `creature_addon` SELECT * FROM `zr_backup_lbrs_spirestone_creature_addon`; DELETE FROM `pool_creature` WHERE `guid` IN (322713, 323152); UPDATE `pool_creature` SET `chance` = 6 WHERE `guid` IN (47613, 49165);

CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_spirestone_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_lbrs_spirestone_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `guid` IN (322709,323132,323138,323139,323153,323035,323044);
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_spirestone_creature_addon` LIKE `creature_addon`;
INSERT IGNORE INTO `zr_backup_lbrs_spirestone_creature_addon` SELECT * FROM `creature_addon` WHERE `guid` IN (322709,323132,323138,323139,323153,323035,323044);

-- 1. Doubles
DELETE FROM `creature_addon` WHERE `guid` IN (322709,323132,323138,323139,323153,323035,323044);
DELETE FROM `creature` WHERE `map` = 229 AND `id` IN (9200, 9201, 9097, 9098) AND `guid` IN (322709,323132,323138,323139,323153,323035,323044);

-- 2. Static rares into their pools
DELETE FROM `pool_creature` WHERE `guid` IN (322713, 323152);
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(322713, 22907, 4, 'Spirestone Butcher (rare, was static)'),
(323152, 22908, 6, 'Spirestone Lord Magus (rare, was static)');
UPDATE `pool_creature` SET `chance` = 4 WHERE `pool_entry` = 22907 AND `guid` IN (47613, 49165);

-- Check: expect removed 7, Reavers 3, Butcher pool 4 (12%), Lord Magus pool 3 (12%), unpooled rares 0
SELECT CONCAT('Removed ', (SELECT COUNT(*) FROM `zr_backup_lbrs_spirestone_creature`) - (SELECT COUNT(*) FROM `creature` WHERE `guid` IN (322709,323132,323138,323139,323153,323035,323044)),
    ', Reavers ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 9200),
    ', Butcher pool ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 22907), ' (', (SELECT SUM(`chance`) FROM `pool_creature` WHERE `pool_entry` = 22907), '%)',
    ', Lord Magus pool ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 22908), ' (', (SELECT SUM(`chance`) FROM `pool_creature` WHERE `pool_entry` = 22908), '%)',
    ', unpooled rares ', (SELECT COUNT(*) FROM `creature` c WHERE c.`map` = 229 AND c.`id` IN (9217, 9218, 9219) AND c.`guid` NOT IN (SELECT `guid` FROM `pool_creature`))) AS `check`;
