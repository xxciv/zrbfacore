-- Blackrock Depths (map 230): Panzor the Invincible spawned twice, 2026-11-22.
--
-- Found by Four in game ("You didn't catch the Panzor the Invincible double spawn"). The rare golem 8923 has two
-- spawns 56 yards apart: 327502 (always up in Pandaria 5.4.8) and 49007, which Pandaria only spawns 12% of the time
-- in a pool with a Molten War Golem (pool 181). This database has no pools on map 230, so both Panzors were always
-- up. 49007 removed (backup zr_backup_brd_creature); 327502 stays. No other rare or named boss on map 230 has a
-- second spawn.

CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `id` = 8923 AND `guid` = 49007;
DELETE FROM `creature_addon` WHERE `guid` = 49007;
DELETE FROM `creature` WHERE `map` = 230 AND `id` = 8923 AND `guid` = 49007;

-- Check
SELECT CONCAT('Panzor spawns ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 8923),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brd_creature` WHERE `id` = 8923)) AS `check`;
