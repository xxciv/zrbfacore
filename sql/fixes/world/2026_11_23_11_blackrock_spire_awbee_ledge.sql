-- Blackrock Spire (map 229): Awbee and two Blackhand Thugs on a ledge with no floor, 2026-11-23.
--
-- Four, 2026-11-23: "Can't attack him, and can't interact with Awbee" ... "It just says out of range" ...
-- "none of that ledge ... has actual floor/collision. you fall right through it."
--
-- Awbee (10740, guid 322615) and Blackhand Thugs (10762, guids 322613/322614) are the old Upper Spire scene where
-- you killed the Thugs and Awbee gave The Matron Protectorate. Blizzard removed that quest and her dialogue in
-- Cataclysm, and this patch's map has no floor at their spot (FloorZ -200000 at 71,-420,112; the rest of Upper
-- Spire has floor). The client draws them on the Lower Spire floor 66 yards below, where they can't be reached.
-- Not tied to any quest here. Removed (backups zr_backup_brs_awbee_creature, zr_backup_brs_awbee_creature_addon).
-- Undo: INSERT INTO `creature` SELECT * FROM `zr_backup_brs_awbee_creature`; INSERT INTO `creature_addon` SELECT * FROM `zr_backup_brs_awbee_creature_addon`;

CREATE TABLE IF NOT EXISTS `zr_backup_brs_awbee_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brs_awbee_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `guid` IN (322613, 322614, 322615);
CREATE TABLE IF NOT EXISTS `zr_backup_brs_awbee_creature_addon` LIKE `creature_addon`;
INSERT IGNORE INTO `zr_backup_brs_awbee_creature_addon` SELECT * FROM `creature_addon` WHERE `guid` IN (322613, 322614, 322615);

DELETE FROM `creature_addon` WHERE `guid` IN (322613, 322614, 322615);
DELETE FROM `creature` WHERE `map` = 229 AND `guid` IN (322613, 322614, 322615) AND `id` IN (10740, 10762);

-- Check: expect Awbee 0, Thugs 0, backed up 3
SELECT CONCAT('Awbee ', (SELECT COUNT(*) FROM `creature` WHERE `id` = 10740),
    ', Thugs ', (SELECT COUNT(*) FROM `creature` WHERE `id` = 10762),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brs_awbee_creature`)) AS `check`;
