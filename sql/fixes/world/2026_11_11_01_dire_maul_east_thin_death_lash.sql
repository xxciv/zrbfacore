-- Dire Maul (map 429), Warpwood Quarter: thin the stacked Death Lash pairs (Four, 2026-11-11).
--
-- The east wing has 23 Death Lash (13285) against 14 in classic (AzerothCore), and five pairs
-- stand within 0.8-2.3 yards of each other. One of each pair is removed (23 -> 18):
--   83,-205: 323213 (keeps 324067, which has a patrol path)
--   43,-196: 324089 (keeps 323554)      -114,-196: 324114 (keeps 323555)
--   15,-263: 324078 (keeps 323590)      -38,-195:  324100 (keeps 323748)
--
-- BACKUP: the rows go into the same backup tables as 2026_11_11_00 first. To put them back:
--   INSERT IGNORE INTO `creature` SELECT * FROM `zr_backup_dm_east_creature`;
--   INSERT IGNORE INTO `creature_addon` SELECT * FROM `zr_backup_dm_east_creature_addon`;

CREATE TABLE IF NOT EXISTS `zr_backup_dm_east_creature` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_dm_east_creature_addon` LIKE `creature_addon`;

SET @THIN := '323213,324089,324114,324078,324100';
INSERT IGNORE INTO `zr_backup_dm_east_creature` SELECT * FROM `creature` WHERE `map`=429 AND FIND_IN_SET(`guid`, @THIN);
INSERT IGNORE INTO `zr_backup_dm_east_creature_addon` SELECT * FROM `creature_addon` WHERE FIND_IN_SET(`guid`, @THIN);

DELETE FROM `creature_addon` WHERE FIND_IN_SET(`guid`, @THIN);
DELETE FROM `creature` WHERE `map`=429 AND FIND_IN_SET(`guid`, @THIN);
