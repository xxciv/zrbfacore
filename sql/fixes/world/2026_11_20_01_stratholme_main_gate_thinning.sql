-- Stratholme (map 329), Main Gate: the eight densest packs thinned, 2026-11-20.
--
-- Found (Four, 2026-11-20: "stratholme packs are pretty dense"): the Main Gate has 400 creatures,
-- AzerothCore 256. The packs match Pandaria 5.4.8 guid for guid (the 8.x layout), which added Skeletal
-- Guardians 10390 and Skeletal Berserkers 10391 to the classic packs and stacks Broken Cadavers 10383 on the
-- Ravaged Cadavers 10381 that summon them when they die. Eight packs (single-link < 5 yards, 6+ mobs) are at
-- least twice the AzerothCore pack within 8 yards: three corpse piles in King's Square (15 vs 7, 13 vs 1,
-- 12 vs 2), one in Market Row (8 vs 3) and four in the Scarlet Bastion (9 vs 3, 9 vs 3, 8 vs 4, 6 vs 3).
--
-- Changed: each of those packs cut to the AzerothCore count (at least 3), removing first the kinds
-- AzerothCore has fewer of, skeletons before others, stacked spawns before spread ones. 51 removed:
-- 15 Skeletal Berserker, 12 Skeletal Guardian, 10 Broken Cadaver, 7 Ravaged Cadaver, 3 Mangled Cadaver, 2 Plague Ghoul, 1 Risen Inquisitor, 1 Risen Sorcerer.
-- Kept: bosses and their packs (The Unforgiven's phantoms), crusaders, rats, quest NPCs, patrols, and any
-- spawn with per-guid SmartAI, formation or pool rows. None of the removed spawns has a game event row.
--
-- BACKUP: the removed rows are copied first into zr_backup_strat_mg_creature and
-- zr_backup_strat_mg_creature_addon. To put them all back:
--   INSERT IGNORE INTO `creature` SELECT * FROM `zr_backup_strat_mg_creature`;
--   INSERT IGNORE INTO `creature_addon` SELECT * FROM `zr_backup_strat_mg_creature_addon`;

CREATE TABLE IF NOT EXISTS `zr_backup_strat_mg_creature` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_strat_mg_creature_addon` LIKE `creature_addon`;
INSERT IGNORE INTO `zr_backup_strat_mg_creature` SELECT * FROM `creature` WHERE `map` = 329 AND `guid` IN (319956, 319960, 319987, 320018, 320024, 320030, 320031, 320032, 320036, 320037, 320038, 320039, 320040, 320057, 320064, 320103, 320105, 320107, 320109, 320110, 320143, 320144, 320145, 320148, 320150, 320151, 320152, 320153, 320154, 320155, 320156, 320202, 320203, 320206, 320331, 320332, 320333, 320334, 320335, 320336, 320337, 320338, 320347, 320348, 320349, 320350, 320351, 320352, 320353, 320354, 320355);
INSERT IGNORE INTO `zr_backup_strat_mg_creature_addon` SELECT * FROM `creature_addon` WHERE `guid` IN (319956, 319960, 319987, 320018, 320024, 320030, 320031, 320032, 320036, 320037, 320038, 320039, 320040, 320057, 320064, 320103, 320105, 320107, 320109, 320110, 320143, 320144, 320145, 320148, 320150, 320151, 320152, 320153, 320154, 320155, 320156, 320202, 320203, 320206, 320331, 320332, 320333, 320334, 320335, 320336, 320337, 320338, 320347, 320348, 320349, 320350, 320351, 320352, 320353, 320354, 320355);

DELETE FROM `creature_addon` WHERE `guid` IN (319956, 319960, 319987, 320018, 320024, 320030, 320031, 320032, 320036, 320037, 320038, 320039, 320040, 320057, 320064, 320103, 320105, 320107, 320109, 320110, 320143, 320144, 320145, 320148, 320150, 320151, 320152, 320153, 320154, 320155, 320156, 320202, 320203, 320206, 320331, 320332, 320333, 320334, 320335, 320336, 320337, 320338, 320347, 320348, 320349, 320350, 320351, 320352, 320353, 320354, 320355);
DELETE FROM `creature` WHERE `map` = 329 AND `guid` IN (319956, 319960, 319987, 320018, 320024, 320030, 320031, 320032, 320036, 320037, 320038, 320039, 320040, 320057, 320064, 320103, 320105, 320107, 320109, 320110, 320143, 320144, 320145, 320148, 320150, 320151, 320152, 320153, 320154, 320155, 320156, 320202, 320203, 320206, 320331, 320332, 320333, 320334, 320335, 320336, 320337, 320338, 320347, 320348, 320349, 320350, 320351, 320352, 320353, 320354, 320355);

SELECT CONCAT('Stratholme creatures ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 329),
              ', backed up ', (SELECT COUNT(*) FROM `zr_backup_strat_mg_creature`)) AS `stratholme_main_gate_thinning`;
