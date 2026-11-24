-- Lower Blackrock Spire (map 229): Four's run-through tweaks, 2026-11-23. Goes with 2026_11_23_05 and _10.
--
-- 1. Shadow Hunter Vosh'gajin's room. Four: "less about poses and more about their spawn points. seem clumped up."
--    Her six trolls stood within 5 yards of each other in the middle of the room (Pandaria the same). Moved onto
--    AzerothCore's spots for the same room, as three pairs: two by the entrance, two on the south side, two beside
--    Vosh'gajin (AzerothCore's north pair has no troll left to fill it).
-- 2. Spirestone Warlord 49130 removed (Four: "let's remove this ogre"). It was the stand-in of pool 22908; the pool
--    keeps its two Spirestone Lord Magus spots at 6% each, so most runs that spot is now empty.
-- 3. The doorway pack at (-54,-429,78), two Spirestone Warlords and two Smolderthorn Berserkers, spread onto Four's
--    four spots as two ogre-and-troll pairs: one pair stays at the doorway, one moves 33 yards up the hall.
-- 4. Unfired Plate Gauntlets (gameobject 176089, guid 188878) by the lava: its only loot is quest item 12812 for the
--    Classic blacksmithing quest "Fiery Plate Gauntlets", removed in Cataclysm; no quest here uses it, so it always
--    opened empty. Removed.
-- Backups zr_backup_lbrs_tweaks_creature, zr_backup_lbrs_tweaks_pool_creature, zr_backup_lbrs_tweaks_gameobject.
-- Undo: REPLACE INTO `creature` SELECT * FROM `zr_backup_lbrs_tweaks_creature`; REPLACE INTO `pool_creature` SELECT * FROM `zr_backup_lbrs_tweaks_pool_creature`; REPLACE INTO `gameobject` SELECT * FROM `zr_backup_lbrs_tweaks_gameobject`;

CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_tweaks_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_lbrs_tweaks_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `guid` IN (322706,322707,322728,322729,322730,322731,49130,322962,322963,322830,322831);
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_tweaks_pool_creature` LIKE `pool_creature`;
INSERT IGNORE INTO `zr_backup_lbrs_tweaks_pool_creature` SELECT * FROM `pool_creature` WHERE `guid` = 49130;
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_tweaks_gameobject` LIKE `gameobject`;
INSERT IGNORE INTO `zr_backup_lbrs_tweaks_gameobject` SELECT * FROM `gameobject` WHERE `guid` = 188878;

-- 1. Vosh'gajin's trolls
UPDATE `creature` SET `position_x` = -93.27,  `position_y` = -483.15, `position_z` = 24.42, `orientation` = 6.28 WHERE `guid` = 322728 AND `id` = 9239; -- Mystic, entrance
UPDATE `creature` SET `position_x` = -93.2,   `position_y` = -477.9,  `position_z` = 24.42, `orientation` = 6.21 WHERE `guid` = 322729 AND `id` = 9240; -- Shadow Priest, entrance
UPDATE `creature` SET `position_x` = -100.07, `position_y` = -491.54, `position_z` = 24.43, `orientation` = 1.5  WHERE `guid` = 322731 AND `id` = 9269; -- Seer, south
UPDATE `creature` SET `position_x` = -103.79, `position_y` = -491.78, `position_z` = 24.43, `orientation` = 1.43 WHERE `guid` = 322730 AND `id` = 9265; -- Shadow Hunter, south
UPDATE `creature` SET `position_x` = -125.67, `position_y` = -473.79, `position_z` = 24.44, `orientation` = 6.24 WHERE `guid` = 322706 AND `id` = 9240; -- Shadow Priest, by Vosh'gajin
UPDATE `creature` SET `position_x` = -125.34, `position_y` = -489.88, `position_z` = 24.44, `orientation` = 6.26 WHERE `guid` = 322707 AND `id` = 9240; -- Shadow Priest, by Vosh'gajin

-- 2. Spirestone Warlord 49130
DELETE FROM `pool_creature` WHERE `guid` = 49130;
DELETE FROM `creature_addon` WHERE `guid` = 49130;
DELETE FROM `creature` WHERE `map` = 229 AND `guid` = 49130 AND `id` = 9216;

-- 3. Doorway pack, two pairs
UPDATE `creature` SET `position_x` = -54.867, `position_y` = -428.451, `position_z` = 77.749, `orientation` = 1.5885 WHERE `guid` = 322962 AND `id` = 9216;
UPDATE `creature` SET `position_x` = -50.434, `position_y` = -428.361, `position_z` = 77.749, `orientation` = 1.5885 WHERE `guid` = 322963 AND `id` = 9268;
UPDATE `creature` SET `position_x` = -57.065, `position_y` = -395.935, `position_z` = 77.765, `orientation` = 1.5375 WHERE `guid` = 322830 AND `id` = 9216;
UPDATE `creature` SET `position_x` = -50.421, `position_y` = -395.724, `position_z` = 77.765, `orientation` = 1.6239 WHERE `guid` = 322831 AND `id` = 9268;

-- 4. Unfired Plate Gauntlets
DELETE FROM `gameobject_addon` WHERE `guid` = 188878;
DELETE FROM `gameobject` WHERE `guid` = 188878 AND `id` = 176089;

-- Check: expect trolls spread 6, Warlord 49130 0, Lord Magus pool 2, pairs moved 4, gauntlets 0
SELECT CONCAT('Trolls spread ', (SELECT COUNT(*) FROM `creature` WHERE `guid` IN (322706,322707,322728,322729,322730,322731) AND (ABS(`position_x` + 93.2) < 0.1 OR ABS(`position_y` + 491.6) < 0.3 OR ABS(`position_x` + 125.5) < 0.2)),
    ', Warlord 49130 ', (SELECT COUNT(*) FROM `creature` WHERE `guid` = 49130),
    ', Lord Magus pool ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 22908),
    ', pairs moved ', (SELECT COUNT(*) FROM `creature` WHERE `guid` IN (322962,322963,322830,322831) AND ROUND(`position_z`, 1) BETWEEN 77.7 AND 77.8 AND (ROUND(`position_y`) IN (-428, -396))),
    ', gauntlets ', (SELECT COUNT(*) FROM `gameobject` WHERE `id` = 176089)) AS `check`;
