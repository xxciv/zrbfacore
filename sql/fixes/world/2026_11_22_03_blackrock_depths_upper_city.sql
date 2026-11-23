-- Blackrock Depths (map 230): Upper City, 2026-11-22. Goes with blackrock-depths.patch.
--
-- 1. Lyceum: the two Shadowforge Braziers (174744 south, 174745 north) spawned lit (state 0, the 8.x sniff
--    caught them after a group had used them). Lighting them with a Shadowforge Torch (dropped by the Shadowforge
--    Flame Keepers) is what opens the Golem Room doors to Magmus, and a lit brazier can't be lit again.
--    Unlit like Pandaria 5.4.8 and AzerothCore (state 1).
-- 2. The Throne Room doors (170575) to Emperor Dagran Thaurissan spawned open, so the Emperor could be pulled
--    before Magmus. Closed like Pandaria and AzerothCore; Magmus's death opens them (boss_magmus.cpp, and the
--    instance script on reload).
-- 3. Seven Burning Spirits (9178) stood in a ring around Ambassador Flamelash's room. They are his summons
--    (four every 30 seconds in the fight, boss_ambassador_flamelash.cpp) caught by the sniff; Pandaria and
--    AzerothCore have none. Removed, backed up in zr_backup_brd_creature. No quest asks for them.

-- 1. Lyceum braziers
UPDATE `gameobject` SET `state` = 1 WHERE `map` = 230 AND `guid` IN (188553, 188427) AND `id` IN (174744, 174745);

-- 2. Throne Room doors
UPDATE `gameobject` SET `state` = 1 WHERE `map` = 230 AND `guid` = 188317 AND `id` = 170575;

-- 3. Burning Spirits
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `id` = 9178
    AND `guid` IN (322273, 322274, 322275, 322276, 322277, 322278, 322279);
DELETE FROM `creature_addon` WHERE `guid` IN (322273, 322274, 322275, 322276, 322277, 322278, 322279);
DELETE FROM `creature` WHERE `map` = 230 AND `id` = 9178 AND `guid` IN (322273, 322274, 322275, 322276, 322277, 322278, 322279);

-- Check
SELECT CONCAT('Unlit braziers ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 230 AND `id` IN (174744, 174745) AND `state` = 1),
    ', closed throne doors ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 230 AND `id` = 170575 AND `state` = 1),
    ', static Burning Spirits ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 9178),
    ', backed up spirits ', (SELECT COUNT(*) FROM `zr_backup_brd_creature` WHERE `id` = 9178)) AS `check`;
