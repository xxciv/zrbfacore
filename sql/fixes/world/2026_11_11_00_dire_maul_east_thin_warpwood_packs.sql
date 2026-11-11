-- Dire Maul (map 429), Warpwood Quarter: thin the stacked Warpwood packs (Four, 2026-11-11).
--
-- Four found the Warpwood elites brutal solo where several stand on the same spot, and chose
-- thinning over a damage change. Ten spawns that stand within 0.7-5 yards of a twin are removed;
-- every pack keeps at least one of each kind it had:
--   -116,-266 room: Guardians 323183, 324036, 324037 (keeps Guardian 323184, Stomper 324035, Death Lash 323566)
--   19,-206:        Treant 323391 (and its path 429000019), Tangler 323981 (keeps Treant 323392, Tangler 323390)
--   31,-305:        Guardian 323198 (keeps Guardian 323199, Stomper 323197)
--   -75,-363:       Treant 323704 (keeps Treant 323703, Tangler 323702)
--   -154,-276:      Treant 323985 (keeps 323676)
--   4..9,-197:      Treant 323983 (keeps 323982)
--   -45,-354:       Treant 323996 (keeps 323995)
--
-- BACKUP: the removed rows are copied first into zr_backup_dm_east_creature and
-- zr_backup_dm_east_creature_addon. To put them all back:
--   INSERT IGNORE INTO `creature` SELECT * FROM `zr_backup_dm_east_creature`;
--   INSERT IGNORE INTO `creature_addon` SELECT * FROM `zr_backup_dm_east_creature_addon`;
-- (the path 429000019 rows are in zr_backup_dm_east_waypoint_data the same way).

CREATE TABLE IF NOT EXISTS `zr_backup_dm_east_creature` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_dm_east_creature_addon` LIKE `creature_addon`;
CREATE TABLE IF NOT EXISTS `zr_backup_dm_east_waypoint_data` LIKE `waypoint_data`;

SET @THIN := '323183,324036,324037,323391,323981,323198,323704,323985,323983,323996';
INSERT IGNORE INTO `zr_backup_dm_east_creature` SELECT * FROM `creature` WHERE `map`=429 AND FIND_IN_SET(`guid`, @THIN);
INSERT IGNORE INTO `zr_backup_dm_east_creature_addon` SELECT * FROM `creature_addon` WHERE FIND_IN_SET(`guid`, @THIN);
INSERT IGNORE INTO `zr_backup_dm_east_waypoint_data` SELECT * FROM `waypoint_data` WHERE `id`=429000019;

DELETE FROM `creature_addon` WHERE FIND_IN_SET(`guid`, @THIN);
DELETE FROM `creature` WHERE `map`=429 AND FIND_IN_SET(`guid`, @THIN);
DELETE FROM `waypoint_data` WHERE `id`=429000019;
