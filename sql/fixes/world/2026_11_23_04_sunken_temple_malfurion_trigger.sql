-- Sunken Temple (map 109): no more Malfurion Stormrage copies, 2026-11-23. Goes with 2026_11_23_02/03.
--
-- Four, 2026-11-23: "During the fight with Dreamscythe, Malfurion spawned twice and is just chillin".
--
-- Area trigger 4016 runs the core's classic script at_malfurion_stormrage: every time a player walks into it
-- with no Malfurion (15362) within 15 yards, it summons one at the player for 100 s. He was there for the
-- classic Eranikus quests (8733-8735), which this database does not have: Malfurion starts and ends no quest
-- and has no script. Pandaria 5.4.8 does not use that script on this trigger. The trigger is unbound, so no
-- more Malfurions appear (backup zr_backup_st_areatrigger_scripts). Nothing else depends on it.
-- Undo: INSERT INTO `areatrigger_scripts` SELECT * FROM `zr_backup_st_areatrigger_scripts`;

CREATE TABLE IF NOT EXISTS `zr_backup_st_areatrigger_scripts` LIKE `areatrigger_scripts`;
INSERT IGNORE INTO `zr_backup_st_areatrigger_scripts` SELECT * FROM `areatrigger_scripts` WHERE `entry` = 4016;
DELETE FROM `areatrigger_scripts` WHERE `entry` = 4016 AND `ScriptName` = 'at_malfurion_stormrage';

-- Check: expect trigger rows 0, backed up 1
SELECT CONCAT('Trigger rows ', (SELECT COUNT(*) FROM `areatrigger_scripts` WHERE `entry` = 4016),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_st_areatrigger_scripts`)) AS `check`;
