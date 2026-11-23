-- Upper Blackrock Spire wing (map 229): Blackrock Stadium thinned by half, 2026-11-23. Goes with 2026_11_23_05..07.
--
-- Four, 2026-11-23 (decision card "Thin the crowded Rend arena before your Upper Spire run?"): "Thin by half".
--
-- The stadium where Gyth and Warchief Rend Blackhand are fought held 30 mobs in one open room: 17 Chromatic Whelps,
-- 8 elite Chromatic Dragonspawn and 5 elite Blackhand Dragon Handlers (Pandaria the same; AzerothCore 3 whelps and
-- 1 dragonspawn). They were Rend's waves in the old game; the core's wave code is empty, so they just stand there.
-- Kept the most spread-out half: 9 whelps, 4 dragonspawn, 2 handlers (the handlers' Blackrock item still drops).
-- No addon, formation, pool, per-guid script or quest objective on any of them. Backup zr_backup_brs_arena_creature.
-- Undo: INSERT INTO `creature` SELECT * FROM `zr_backup_brs_arena_creature`;

CREATE TABLE IF NOT EXISTS `zr_backup_brs_arena_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brs_arena_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `guid` IN (322701,323108,323109,323110,323124,323125,323126,323128,323131,323133,323135,323142,323145,323146,323147);
DELETE FROM `creature` WHERE `map` = 229 AND `id` IN (10442, 10447, 10742) AND `guid` IN (322701,323108,323109,323110,323124,323125,323126,323128,323131,323133,323135,323142,323145,323146,323147);

-- Check: expect whelps 9, dragonspawn 4, handlers 2, backed up 15
SELECT CONCAT('Whelps ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 10442),
    ', dragonspawn ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 10447),
    ', handlers ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 10742),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brs_arena_creature`)) AS `check`;
