-- Zul'Farrak (map 209), 2026-11-21. Goes with zulfarrak.patch (same day).
--
-- 1. 81 pyramid trolls (Sandfury Slave 7787, Drudge 7788, Cretin 7789, Acolyte 8876, Zealot 8877) stood at the
--    foot of the pyramid (1864-1905, 1198-1262) and two beside Sergeant Bly before the event: the 8.x sniff caught
--    the event's summons. The pyramid event (instance_zulfarrak.cpp) summons them itself; Pandaria 5.4.8 and
--    AzerothCore have none of these entries in the world. Removed, backed up in zr_backup_zf_pyramid_creature.
--    No quest uses them.
-- 2. Sergeant Bly, Raven, Oro Eyegouge, Murta Grimgut and Weegli Blastfuse stood outside their cages (Weegli by
--    the entrance at 1675, 841), as after the cages are opened, so the event could not start the classic way.
--    Moved back into the cages (AzerothCore and Pandaria positions). The cage at 1881, 1297 (141071) was open:
--    closed like the other four.
-- 3. Zerillis 10082 (rare) had two spawns up at once (Pandaria 5.4.8 has one): pooled, one per server start.

-- 1. Pyramid trolls
CREATE TABLE IF NOT EXISTS `zr_backup_zf_pyramid_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_zf_pyramid_creature` SELECT * FROM `creature` WHERE `map` = 209 AND `id` IN (7787, 7788, 7789, 8876, 8877);
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `zr_backup_zf_pyramid_creature`);
DELETE FROM `creature` WHERE `map` = 209 AND `id` IN (7787, 7788, 7789, 8876, 8877);

-- 2. Bly's crew back in their cages
UPDATE `creature` SET `position_x` = 1882.89, `position_y` = 1299.27, `position_z` = 48.3843, `orientation` = 4.83456 WHERE `guid` = 326423 AND `id` = 7604;
UPDATE `creature` SET `position_x` = 1886.64, `position_y` = 1299.11, `position_z` = 48.3146, `orientation` = 4.36332 WHERE `guid` = 326425 AND `id` = 7605;
UPDATE `creature` SET `position_x` = 1889.62, `position_y` = 1298.01, `position_z` = 48.2581, `orientation` = 3.94444 WHERE `guid` = 326426 AND `id` = 7606;
UPDATE `creature` SET `position_x` = 1891.07, `position_y` = 1294.78, `position_z` = 48.2347, `orientation` = 3.31613 WHERE `guid` = 326427 AND `id` = 7608;
UPDATE `creature` SET `position_x` = 1881.05, `position_y` = 1297.36, `position_z` = 48.419, `orientation` = 5.41052 WHERE `guid` = 326424 AND `id` = 7607;
UPDATE `gameobject` SET `state` = 1 WHERE `guid` = 189749 AND `id` = 141071;

-- 3. Zerillis
DELETE FROM `pool_creature` WHERE `guid` IN (51510, 327501);
DELETE FROM `pool_template` WHERE `entry` = 32901;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES (32901, 1, 'Zul''Farrak - Zerillis (one of two)');
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(51510, 32901, 0, 'Zul''Farrak - Zerillis'),
(327501, 32901, 0, 'Zul''Farrak - Zerillis');

-- Check
SELECT CONCAT('Pyramid trolls left ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 209 AND `id` IN (7787, 7788, 7789, 8876, 8877)),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_zf_pyramid_creature`),
    ', crew in cages ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 209 AND `id` BETWEEN 7604 AND 7608 AND `position_z` > 48),
    ', cages closed ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 209 AND `id` BETWEEN 141070 AND 141074 AND `state` = 1),
    ', Zerillis pooled ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 32901)) AS `check`;
