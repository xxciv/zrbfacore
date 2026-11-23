-- Blackrock Depths (map 230): Hurley Blackbreath's cronies made normal, 2026-11-22. Goes with 2026_11_22_09.
--
-- Four, 2026-11-22: "his 3 friends need to not be elite." and "it was a massacre".
--
-- The Blackbreath Cronies (9541) are elite with 4x health and 7.5x damage in this database, Pandaria 5.4.8 and
-- AzerothCore alike, and all three join Hurley (elite, 8x health) at once. For a solo player they become
-- normal creatures with the bar's normal patrons' numbers (rank 0, health x1, damage x3.5). Hurley stays as he is.
-- Backup: zr_backup_brd_creature_template.

CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_template` LIKE `creature_template`;
INSERT IGNORE INTO `zr_backup_brd_creature_template` SELECT * FROM `creature_template` WHERE `entry` = 9541;
UPDATE `creature_template` SET `rank` = 0, `HealthModifier` = 1, `DamageModifier` = 3.5 WHERE `entry` = 9541;

-- Check
SELECT CONCAT('Blackbreath Crony rank ', `rank`, ', health x', `HealthModifier`, ', damage x', `DamageModifier`,
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brd_creature_template` WHERE `entry` = 9541)) AS `check`
    FROM `creature_template` WHERE `entry` = 9541;
