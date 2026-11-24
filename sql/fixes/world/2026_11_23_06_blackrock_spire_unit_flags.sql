-- Blackrock Spire (map 229): stuck, silenced and untargetable mobs, 2026-11-23. Goes with 2026_11_23_05.
--
-- Templates compared with Pandaria 5.4.8. This database carries sniffed states on several of them:
--   Scarshield Legionnaire 9097 (47 in Lower Spire)   unit_flags 0x48040: STUNNED, cannot fight back
--   Scarshield Acolyte 9045, Spellbinder 9098, Warlock 9257 (56)   0xA040: SILENCED, cannot cast
--   Scarshield Worg 9416 (14)                         0x8008: PLAYER_CONTROLLED
--   Blackhand Elite 10317, Blackhand Assassin 10318 (21 in the Upper Spire halls)
--                                                     0x2008140: NOT_SELECTABLE + IMMUNE_TO_PC, untargetable
--   Lord Victor Nefarius 10162 (Rend's balcony)       faction 14, hostile; Pandaria 35, friendly
--   Pyroguard Emberseer 9816                          faction 754, hostile to his own Blackhand jailers; Pandaria 40
-- All set to Pandaria's values. Emberseer's and the Incarcerators' scripts still add and remove their own
-- immune flags during his event. Backup zr_backup_brs_creature_template.

CREATE TABLE IF NOT EXISTS `zr_backup_brs_creature_template` LIKE `creature_template`;
INSERT IGNORE INTO `zr_backup_brs_creature_template` SELECT * FROM `creature_template` WHERE `entry` IN (9045, 9097, 9098, 9257, 9416, 10317, 10318, 10162, 9816);

UPDATE `creature_template` SET `unit_flags` = 32832 WHERE `entry` IN (9045, 9097, 9098, 9257, 10317, 10318);
UPDATE `creature_template` SET `unit_flags` = 32768 WHERE `entry` = 9416;
UPDATE `creature_template` SET `faction` = 35 WHERE `entry` = 10162;
UPDATE `creature_template` SET `faction` = 40 WHERE `entry` = 9816;

-- Check: expect fixed 7, Nefarius 35, Emberseer 40, backed up 9
SELECT CONCAT('Fixed flags ', (SELECT COUNT(*) FROM `creature_template` WHERE (`entry` IN (9045, 9097, 9098, 9257, 10317, 10318) AND `unit_flags` = 32832) OR (`entry` = 9416 AND `unit_flags` = 32768)),
    ', Nefarius ', (SELECT `faction` FROM `creature_template` WHERE `entry` = 10162),
    ', Emberseer ', (SELECT `faction` FROM `creature_template` WHERE `entry` = 9816),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brs_creature_template`)) AS `check`;
