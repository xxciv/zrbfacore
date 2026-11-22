-- Blackrock Depths (map 230): Grim Guzzler patrons, 2026-11-22. Last of the Blackrock Depths once-over.
--
-- 1. The bar held 87 patrons (Grim 9545, Guzzling 9547, Hammered 9554) against 68 in Pandaria 5.4.8 and 68 in
--    AzerothCore. All of Pandaria's 69 spots are here, plus 18 more that sit exactly on AzerothCore spawns
--    (AzerothCore places most of its patrons a few yards from Pandaria's), so 18 tables had one patron
--    standing twice, 1 to 5 yards apart. The 18 AzerothCore-only copies are removed, backed up in
--    zr_backup_brd_creature. That leaves Grim 32, Guzzling 25, Hammered 12 (Pandaria 32, 24, 12). The patrons
--    have no quest, no gossip and no script of their own.
-- 2. Their AzerothCore formations came along by guid: 64 rows under six leaders (46624, 48092, 90739, 90746,
--    90883, 90885). Those guids are other creatures here, so the groups mixed Grim Guzzler patrons with
--    Chilled Earth Elementals and other Northrend (571) and Hellfire (545) creatures, and two Blackrock Depths
--    groups had their leader in Northrend. Pandaria has no patron formations. All 64 rows removed, backed up
--    in zr_backup_brd_creature_formations.
-- Not changed after checking against Pandaria: the Twilight's Hammer NPCs (Ambassador 15, Emissary 17,
-- Torturer 14, Bodyguard 6, all at or under Pandaria's counts and spots), the Anvilrage groups, Shadowforge
-- Flame Keepers (10, the torch droppers), Arena Spectators, Blazing Fireguards and every other entry.

-- 1. Doubled patrons
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `id` IN (9545, 9547, 9554)
    AND `guid` IN (90746, 48172, 48168, 48152, 48094, 46629, 46621, 91066, 91064, 90741, 90739, 48171, 48092, 46628, 90738, 48170, 48153, 46620);
DELETE FROM `creature_addon` WHERE `guid` IN (90746, 48172, 48168, 48152, 48094, 46629, 46621, 91066, 91064, 90741, 90739, 48171, 48092, 46628, 90738, 48170, 48153, 46620);
DELETE FROM `creature` WHERE `map` = 230 AND `id` IN (9545, 9547, 9554)
    AND `guid` IN (90746, 48172, 48168, 48152, 48094, 46629, 46621, 91066, 91064, 90741, 90739, 48171, 48092, 46628, 90738, 48170, 48153, 46620);

-- 2. Imported formations
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_formations` LIKE `creature_formations`;
INSERT IGNORE INTO `zr_backup_brd_creature_formations` SELECT * FROM `creature_formations`
    WHERE `leaderGUID` IN (46624, 48092, 90739, 90746, 90883, 90885);
DELETE FROM `creature_formations` WHERE `leaderGUID` IN (46624, 48092, 90739, 90746, 90883, 90885);

-- Check
SELECT CONCAT('Grim ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 9545),
    ', Guzzling ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 9547),
    ', Hammered ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 9554),
    ', backed up patrons ', (SELECT COUNT(*) FROM `zr_backup_brd_creature` WHERE `id` IN (9545, 9547, 9554)),
    ', patron formation rows ', (SELECT COUNT(*) FROM `creature_formations` f JOIN `creature` c ON c.`guid` = f.`memberGUID`
        WHERE c.`map` = 230 AND c.`id` IN (9545, 9547, 9554)),
    ', backed up formation rows ', (SELECT COUNT(*) FROM `zr_backup_brd_creature_formations`)) AS `check`;
