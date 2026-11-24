-- Lower Blackrock Spire (map 229): Scarshield mobs standing two to a spot, 2026-11-23. Goes with 2026_11_23_05/06.
--
-- Four, 2026-11-23: "doubled up spawns for spellbinders and warlocks" (screenshot: a Scarshield Spellbinder and a
-- Scarshield Warlock on one body by the entrance camp).
--
-- 23 Scarshield spots hold two spawns of different entries at exactly the same point (a random-entry spawn point
-- sniffed twice, as in Blackrock Depths 2026_11_22_00), and 5 more pairs stand under 0.6 yards apart; Pandaria has
-- the same rows. The second copy of each (guids 3230xx-3231xx) is removed, 28 in all; the 3224xx-3228xx spawn stays.
-- Same for a Spirestone Mystic on a Spirestone Reaver (323154, 0.6 y) and a Rookery Hatcher on a Rookery Guardian
-- (327488, 0.1 y), 30 in all.
-- None has a formation, pool, per-guid script, event or quest objective; 3 sitting addon rows go with them.
--
-- Ghok Bashguud (rare, 9718): Pandaria pools one Ghok (guid 49090, 12%, copied in 2026_11_23_05) but also spawns a
-- second one every time (guid 327483) on top of a sleeping Bloodaxe Veteran. That one now shares a pool with the
-- Veteran under it, 12% Ghok, like the other spot (pool 22920).
-- Backups zr_backup_lbrs_stacked_creature, zr_backup_lbrs_stacked_creature_addon.
-- Undo: INSERT INTO `creature` SELECT * FROM `zr_backup_lbrs_stacked_creature`; INSERT INTO `creature_addon` SELECT * FROM `zr_backup_lbrs_stacked_creature_addon`; DELETE FROM `pool_creature` WHERE `pool_entry` = 22920; DELETE FROM `pool_template` WHERE `entry` = 22920;

CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_stacked_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_lbrs_stacked_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `guid` IN (323037,323038,323039,323040,323041,323042,323045,323046,323047,323051,323052,323053,323054,323089,323090,323091,323092,323093,323095,323096,323099,323100,323101,323103,323104,323105,323106,323107,323154,327488);
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_stacked_creature_addon` LIKE `creature_addon`;
INSERT IGNORE INTO `zr_backup_lbrs_stacked_creature_addon` SELECT * FROM `creature_addon` WHERE `guid` IN (323037,323038,323039,323040,323041,323042,323045,323046,323047,323051,323052,323053,323054,323089,323090,323091,323092,323093,323095,323096,323099,323100,323101,323103,323104,323105,323106,323107,323154,327488);

DELETE FROM `creature_addon` WHERE `guid` IN (323037,323038,323039,323040,323041,323042,323045,323046,323047,323051,323052,323053,323054,323089,323090,323091,323092,323093,323095,323096,323099,323100,323101,323103,323104,323105,323106,323107,323154,327488);
DELETE FROM `creature` WHERE `map` = 229 AND `id` IN (9045, 9097, 9098, 9257, 9198, 10683) AND `guid` IN (323037,323038,323039,323040,323041,323042,323045,323046,323047,323051,323052,323053,323054,323089,323090,323091,323092,323093,323095,323096,323099,323100,323101,323103,323104,323105,323106,323107,323154,327488);

DELETE FROM `pool_creature` WHERE `pool_entry` = 22920;
DELETE FROM `pool_template` WHERE `entry` = 22920;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES (22920, 1, 'Lower Blackrock Spire: Ghok Bashguud or Bloodaxe Veteran (-50,-298)');
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(327483, 22920, 12, 'Ghok Bashguud (rare)'),
(322704, 22920, 0, 'Bloodaxe Veteran');

-- Check: expect removed 30 (left: Acolyte 12, Legionnaire 38, Spellbinder 19, Warlock 6), Ghok pool 2
SELECT CONCAT('Removed ', (SELECT COUNT(*) FROM `zr_backup_lbrs_stacked_creature`) - (SELECT COUNT(*) FROM `creature` WHERE `guid` IN (323037,323038,323039,323040,323041,323042,323045,323046,323047,323051,323052,323053,323054,323089,323090,323091,323092,323093,323095,323096,323099,323100,323101,323103,323104,323105,323106,323107,323154,327488)),
    ' (left: Acolyte ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 9045),
    ', Legionnaire ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 9097),
    ', Spellbinder ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 9098),
    ', Warlock ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 9257),
    '), Ghok pool ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 22920)) AS `check`;
