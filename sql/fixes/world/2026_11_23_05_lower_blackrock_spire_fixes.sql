-- Lower Blackrock Spire (map 229): survey fixes, 2026-11-23.
--
-- 1. Scenario: map 229 had no `scenarios` row, so the dungeon had no objective tracker. Scenario 734 (Lower
--    Blackrock Spires: Omokk, Vosh'gajin, Voone, Mother Smolderweb, Zigris, Halycon, Gizrul, Wyrmthalak; bonus
--    Urok Doomhowl) is now created for normal difficulty. The Dungeon Finder reward still comes from Wyrmthalak.
-- 2. Rares: Pandaria 5.4.8 pools 8 rare spots with their normal stand-ins (Bannok Grimaxe, Burning Felguard,
--    Crystal Fang, Ghok Bashguud, Jed Runewatcher, Spirestone Battle Lord / Butcher / Lord Magus) and 11 pairs of
--    Spire Spider Eggs on the same spot. This database has no pools, so every member spawned: two Bannoks, three
--    Burning Felguards, two Crystal Fangs, doubled eggs. Pandaria's pools copied (pool entries 22901-22919).
-- 3. 95 Rookery Whelps (10161) in the Rookery: not in Pandaria or AzerothCore (sniffed hatchlings; the Rookery
--    Hatchers still hatch theirs). Removed.
-- 4. Two unselectable Eranikus' Shades (51366), not in Pandaria or AzerothCore (same as Blackrock Depths
--    2026_11_22_08). Removed.
-- 5. Gizrul the Slavener (10268) stood in his den from the start AND Halycon's core script summons him when she
--    dies, so there were two. The static one is removed; he comes when Halycon dies, as scripted.
-- 6. Urok Doomhowl (bonus boss): Omokk's Head (12534) dropped only for a quest no longer in the game (82%,
--    quest-only) and the challenge event (4845, sent by using the head at Urok's Tribute Pile) did nothing in
--    this core. Now the head always drops (Pandaria: 100%), and using it at the pile brings two waves of Urok's
--    ogres 20 s apart, then Urok at 40 s. The ogres are normal instead of elite for solo play (6x health and
--    7.5x damage before, like Hurley Blackbreath's cronies), and the Ogre Magus' doubled script is cleaned up.
-- Backups: zr_backup_lbrs_creature, zr_backup_lbrs_creature_template, zr_backup_lbrs_smart_scripts,
-- zr_backup_lbrs_creature_loot_template.

CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_lbrs_creature` SELECT * FROM `creature` WHERE `map` = 229 AND `id` IN (10161, 51366, 10268);
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_creature_template` LIKE `creature_template`;
INSERT IGNORE INTO `zr_backup_lbrs_creature_template` SELECT * FROM `creature_template` WHERE `entry` IN (10601, 10602);
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_smart_scripts` LIKE `smart_scripts`;
INSERT IGNORE INTO `zr_backup_lbrs_smart_scripts` SELECT * FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (10584, 10601, 10602)
    AND NOT EXISTS (SELECT 1 FROM `zr_backup_lbrs_smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (10584, 10601, 10602));
CREATE TABLE IF NOT EXISTS `zr_backup_lbrs_creature_loot_template` LIKE `creature_loot_template`;
INSERT IGNORE INTO `zr_backup_lbrs_creature_loot_template` SELECT * FROM `creature_loot_template` WHERE `Entry` = 9196 AND `Item` = 12534;

-- 1. Scenario
DELETE FROM `scenarios` WHERE `map` = 229;
INSERT INTO `scenarios` (`map`, `difficulty`, `scenario_A`, `scenario_H`) VALUES (229, 1, 734, 734);

-- 2. Pandaria's rare and egg pools
DELETE FROM `pool_creature` WHERE `pool_entry` BETWEEN 22901 AND 22919;
DELETE FROM `pool_gameobject` WHERE `pool_entry` BETWEEN 22901 AND 22919;
DELETE FROM `pool_template` WHERE `entry` BETWEEN 22901 AND 22919;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES
(22901, 1, 'Lower Blackrock Spire: Pandaria pool 108'),
(22902, 1, 'Lower Blackrock Spire: Pandaria pool 114'),
(22903, 1, 'Lower Blackrock Spire: Pandaria pool 118'),
(22904, 1, 'Lower Blackrock Spire: Pandaria pool 138'),
(22905, 1, 'Lower Blackrock Spire: Pandaria pool 160'),
(22906, 1, 'Lower Blackrock Spire: Pandaria pool 206'),
(22907, 1, 'Lower Blackrock Spire: Pandaria pool 207'),
(22908, 1, 'Lower Blackrock Spire: Pandaria pool 208'),
(22909, 1, 'Lower Blackrock Spire: Pandaria pool 14196'),
(22910, 1, 'Lower Blackrock Spire: Pandaria pool 14197'),
(22911, 1, 'Lower Blackrock Spire: Pandaria pool 14198'),
(22912, 1, 'Lower Blackrock Spire: Pandaria pool 14199'),
(22913, 1, 'Lower Blackrock Spire: Pandaria pool 14200'),
(22914, 1, 'Lower Blackrock Spire: Pandaria pool 14201'),
(22915, 1, 'Lower Blackrock Spire: Pandaria pool 14202'),
(22916, 1, 'Lower Blackrock Spire: Pandaria pool 14203'),
(22917, 1, 'Lower Blackrock Spire: Pandaria pool 14204'),
(22918, 1, 'Lower Blackrock Spire: Pandaria pool 14205'),
(22919, 1, 'Lower Blackrock Spire: Pandaria pool 14206');
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(32447, 22901, 6, 'LBRS pool 108 (Pandaria)'),
(49095, 22901, 0, 'LBRS pool 108 (Pandaria)'),
(49112, 22901, 6, 'LBRS pool 108 (Pandaria)'),
(33692, 22902, 4, 'LBRS pool 114 (Pandaria)'),
(49066, 22902, 4, 'LBRS pool 114 (Pandaria)'),
(49147, 22902, 0, 'LBRS pool 114 (Pandaria)'),
(49185, 22902, 4, 'LBRS pool 114 (Pandaria)'),
(47495, 22903, 6, 'LBRS pool 118 (Pandaria)'),
(49070, 22903, 6, 'LBRS pool 118 (Pandaria)'),
(49111, 22903, 0, 'LBRS pool 118 (Pandaria)'),
(49086, 22904, 0, 'LBRS pool 138 (Pandaria)'),
(49090, 22904, 12, 'LBRS pool 138 (Pandaria)'),
(49155, 22905, 0, 'LBRS pool 160 (Pandaria)'),
(49220, 22905, 12, 'LBRS pool 160 (Pandaria)'),
(49067, 22906, 6, 'LBRS pool 206 (Pandaria)'),
(49191, 22906, 0, 'LBRS pool 206 (Pandaria)'),
(51081, 22906, 6, 'LBRS pool 206 (Pandaria)'),
(47613, 22907, 6, 'LBRS pool 207 (Pandaria)'),
(49157, 22907, 0, 'LBRS pool 207 (Pandaria)'),
(49165, 22907, 6, 'LBRS pool 207 (Pandaria)'),
(49130, 22908, 0, 'LBRS pool 208 (Pandaria)'),
(51077, 22908, 6, 'LBRS pool 208 (Pandaria)');
INSERT INTO `pool_gameobject` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(7624, 22909, 0, 'Spire Spider Egg (Pandaria pool 14196)'),
(22521, 22909, 0, 'Spire Spider Egg (Pandaria pool 14196)'),
(7626, 22910, 0, 'Spire Spider Egg (Pandaria pool 14197)'),
(22520, 22910, 0, 'Spire Spider Egg (Pandaria pool 14197)'),
(7628, 22911, 0, 'Spire Spider Egg (Pandaria pool 14198)'),
(22519, 22911, 0, 'Spire Spider Egg (Pandaria pool 14198)'),
(7631, 22912, 0, 'Spire Spider Egg (Pandaria pool 14199)'),
(22518, 22912, 0, 'Spire Spider Egg (Pandaria pool 14199)'),
(7634, 22913, 0, 'Spire Spider Egg (Pandaria pool 14200)'),
(22517, 22913, 0, 'Spire Spider Egg (Pandaria pool 14200)'),
(7637, 22914, 0, 'Spire Spider Egg (Pandaria pool 14201)'),
(22516, 22914, 0, 'Spire Spider Egg (Pandaria pool 14201)'),
(7639, 22915, 0, 'Spire Spider Egg (Pandaria pool 14202)'),
(22515, 22915, 0, 'Spire Spider Egg (Pandaria pool 14202)'),
(71556, 22916, 0, 'Spire Spider Egg (Pandaria pool 14203)'),
(7642, 22917, 0, 'Spire Spider Egg (Pandaria pool 14204)'),
(7644, 22917, 0, 'Spire Spider Egg (Pandaria pool 14204)'),
(71557, 22917, 0, 'Spire Spider Egg (Pandaria pool 14204)'),
(7645, 22918, 0, 'Spire Spider Egg (Pandaria pool 14205)'),
(71558, 22918, 0, 'Spire Spider Egg (Pandaria pool 14205)'),
(7648, 22919, 0, 'Spire Spider Egg (Pandaria pool 14206)'),
(71559, 22919, 0, 'Spire Spider Egg (Pandaria pool 14206)');

-- 3-5. Rookery Whelps, Eranikus' Shades, static Gizrul
DELETE FROM `creature` WHERE `map` = 229 AND `id` IN (10161, 51366, 10268);

-- 6. Urok Doomhowl's challenge
UPDATE `creature_loot_template` SET `Chance` = 100, `QuestRequired` = 0 WHERE `Entry` = 9196 AND `Item` = 12534;
UPDATE `creature_template` SET `rank` = 0, `HealthModifier` = 1, `DamageModifier` = 3.5 WHERE `entry` IN (10601, 10602);

DELETE FROM `event_scripts` WHERE `id` = 4845;
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `dataint`, `x`, `y`, `z`, `o`) VALUES
(4845, 2, 10, 10601, 600000, 0, -23.54, -393.32, 48.58, 0.27),
(4845, 2, 10, 10602, 600000, 0, -16.45, -386.32, 48.76, 4.85),
(4845, 22, 10, 10601, 600000, 0, -22.50, -391.50, 48.60, 0.27),
(4845, 22, 10, 10602, 600000, 0, -18.00, -385.50, 48.70, 4.85),
(4845, 42, 10, 10584, 600000, 0, -23.54, -393.32, 48.58, 0.27);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (10584, 10601, 10602);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(10584, 0, 0, 0, 9, 0, 100, 0, 0, 5, 9000, 13000, 11, 15580, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Doomhowl - Within 0-5 Range - Cast Strike'),
(10584, 0, 1, 0, 0, 0, 100, 0, 7000, 8000, 18000, 24000, 11, 16508, 0, 0, 0, 0, 0, 5, 0, 0, 0, 'Urok Doomhowl - In Combat - Cast Intimidating Roar'),
(10584, 0, 2, 0, 0, 0, 100, 0, 9000, 14000, 14000, 20000, 11, 16509, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Doomhowl - In Combat - Cast Rend'),
(10584, 0, 3, 4, 54, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Urok Doomhowl - On Just Summoned - Say Line 0'),
(10584, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 60, 0, 0, 'Urok Doomhowl - Linked - Attack nearest player'),
(10601, 0, 0, 0, 0, 0, 100, 0, 3000, 5000, 6000, 9000, 11, 14516, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Enforcer - In Combat - Cast Strike'),
(10601, 0, 1, 0, 0, 0, 100, 0, 8000, 8000, 12000, 16000, 11, 15976, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Enforcer - In Combat - Cast Puncture'),
(10601, 0, 2, 0, 54, 0, 100, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 60, 0, 0, 'Urok Enforcer - On Just Summoned - Attack nearest player'),
(10602, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 60, 0, 0, 'Urok Ogre Magus - On Just Summoned - Attack nearest player'),
(10602, 0, 1, 0, 0, 0, 100, 0, 1000, 2000, 3500, 5000, 11, 15979, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Ogre Magus - In Combat - Cast Arcane Bolt'),
(10602, 0, 2, 0, 0, 0, 100, 0, 6000, 9000, 15000, 20000, 11, 13747, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Urok Ogre Magus - In Combat - Cast Slow'),
(10602, 0, 3, 0, 16, 0, 100, 0, 6742, 30, 20000, 30000, 11, 6742, 0, 0, 0, 0, 0, 7, 0, 0, 0, 'Urok Ogre Magus - Friendly Missing Bloodlust - Cast Bloodlust'),
(10602, 0, 4, 5, 2, 0, 100, 1, 0, 15, 0, 0, 25, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Urok Ogre Magus - Below 15% Health - Flee'),
(10602, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Urok Ogre Magus - Linked - Say Line 0');

-- Check: expect scenario 1, pools 19 / 22 creatures / 22 eggs, whelps 0, shades 0, static Gizrul 0, head 100% not quest-only, event rows 5, normal ogres 2, script rows 5/3/6
SELECT CONCAT('Scenario ', (SELECT COUNT(*) FROM `scenarios` WHERE `map` = 229 AND `scenario_A` = 734),
    ', pools ', (SELECT COUNT(*) FROM `pool_template` WHERE `entry` BETWEEN 22901 AND 22919),
    ' / ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` BETWEEN 22901 AND 22919),
    ' / ', (SELECT COUNT(*) FROM `pool_gameobject` WHERE `pool_entry` BETWEEN 22901 AND 22919),
    ', whelps ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 10161),
    ', shades ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 51366),
    ', static Gizrul ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 229 AND `id` = 10268),
    ', head ', (SELECT CONCAT(ROUND(`Chance`), '%/q', `QuestRequired`) FROM `creature_loot_template` WHERE `Entry` = 9196 AND `Item` = 12534),
    ', event rows ', (SELECT COUNT(*) FROM `event_scripts` WHERE `id` = 4845),
    ', normal ogres ', (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (10601, 10602) AND `rank` = 0),
    ', script rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 10584),
    '/', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 10601),
    '/', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 10602)) AS `check`;
