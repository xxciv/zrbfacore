-- Stratholme (map 329), Service Entrance, 2026-11-21. Goes with stratholme.patch (same day).
--
-- Scenario 637 runs in order: 1150 destroy the three Ash'ari Crystals and kill Baroness Anastari, Nerub'enkan
-- and Maleki the Pallid; 1151 kill the nine abominations in Slaughter Square; 1152 Ramstein the Gorger; 1155 the
-- five Black Guard Sentries and Lord Aurius Rivendare; Magistrate Barthilas is a bonus kill.
--
-- 1. Ash'ari Crystals 10415: their rows wait for five made-up auras and then use action 205 as "update
--    scenario" (here 205 is SET_OVERRIDE_ZONE_LIGHT), so no crystal ever broke. Each crystal is fed by the five
--    Thuzadin Acolytes 10399 inside its ziggurat (AzerothCore does the same): an acolyte's death now tells the
--    nearest crystal, and the crystal breaks on the fifth. stratholme.patch sends scenario event 5167 when a
--    crystal dies and opens the Slaughter Square portcullises after the third.
-- 2. Abominations: Bile Spewer 10416 had the same action 205 row (removed; stratholme.patch sends event 5211
--    for every Bile Spewer and Venom Belcher) and a row setting instance data 5 (Ramstein) to IN_PROGRESS,
--    which shut the gauntlet portcullis behind you after the first Bile Spewer (removed). Timmy the Cruel's
--    action 205 row (Main Gate, did nothing useful) is removed too.
-- 3. The Slaughter Square portcullises 175373 and 175374 are missing from the 8.x spawns, so nothing kept you
--    out of Slaughter Square before the crystals were done, and abominations killed early never counted.
--    Spawned as in Pandaria 5.4.8 (same guids); the instance opens them.
-- 4. Lord Aurius Rivendare 45412 replaced Baron Rivendare 10440: the Dungeon Finder completion (instance
--    encounter 484) still pointed at 10440.
-- 5. Mounted Argent Crusaders stand next to the ziggurat bosses, Ramstein and the sentries. A crusader that
--    sees a boss move joins in, and NPC damage could take a boss's kill away from you. The bosses, sentries
--    and Stonespine get the staged battle flag (flags_extra 0x400: creatures can't bring them below 85%,
--    players deal full damage).
-- 6. Stonespine 10809 is a rare with four spawn points, and all four stood at once (Pandaria 5.4.8 too):
--    pooled, one per server start.
-- 7. 26 Mindless Undead 11030 stood at the Slaughter Square gate from the start: they are the wave
--    boss_ramstein_the_gorger.cpp summons when Ramstein dies (30 around 3969 -3392), caught by a sniff.
--    Removed, with a backup (zr_backup_strat_se_creature). Not tied to any quest.

-- 1. Crystals and acolytes
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10415 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10399 AND `source_type` = 0 AND `id` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10415, 0, 0, 0, 11, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ash''ari Crystal - On Spawn - Set Event Phase 1'),
(10415, 0, 1, 0, 38, 16, 100, 0, 1, 1, 0, 0, 0, 37, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ash''ari Crystal - On Data Set 1 1 (fifth acolyte dead) - Die'),
(10415, 0, 2, 0, 38, 15, 100, 0, 1, 1, 0, 0, 0, 23, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ash''ari Crystal - On Data Set 1 1 (acolyte dead) - Increment Event Phase'),
(10399, 0, 0, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 19, 10415, 80, 0, 0, 0, 0, 0, 'Thuzadin Acolyte - On Death - Set Data 1 1 on Closest Ash''ari Crystal');

-- 2. Abomination and Timmy rows that misuse action 205
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10416 AND `source_type` = 0 AND `id` IN (2, 3);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10808 AND `source_type` = 0 AND `action_type` = 205;

-- 3. Slaughter Square portcullises (Pandaria 5.4.8)
DELETE FROM `gameobject` WHERE `guid` IN (187780, 187797);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `isActive`, `ScriptName`, `VerifiedBuild`) VALUES
(187780, 175373, 329, 2017, 5917, '1', 0, 0, 0, -1, 4037.15, -3469.16, 121.804, -3.05433, 0, 0, -0.999048, 0.0436191, 7200, 255, 1, 0, '', 0),
(187797, 175374, 329, 2017, 5917, '1', 0, 0, 0, -1, 4039.97, -3504.3, 121.711, -3.05433, 0, 0, -0.999048, 0.0436191, 7200, 255, 1, 0, '', 0);

-- 4. Dungeon Finder completion
UPDATE `instance_encounters` SET `creditEntry` = 45412 WHERE `entry` = 484 AND `creditType` = 0;

-- 5. Staged battle flag on the bosses near the crusaders
UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 1024 WHERE `entry` IN (10394, 10435, 10436, 10437, 10438, 10439, 10809, 45412);

-- 6. Stonespine: one of four spawn points
DELETE FROM `pool_creature` WHERE `guid` IN (18737, 47963, 319977, 320441);
DELETE FROM `pool_template` WHERE `entry` = 32900;
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES (32900, 1, 'Stratholme - Stonespine (one of four)');
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(18737, 32900, 0, 'Stonespine'), (47963, 32900, 0, 'Stonespine'), (319977, 32900, 0, 'Stonespine'), (320441, 32900, 0, 'Stonespine');

-- 7. Mindless Undead sniffed from Ramstein's death wave
-- To put them back:
--   INSERT IGNORE INTO `creature` SELECT * FROM `zr_backup_strat_se_creature`;
--   INSERT IGNORE INTO `creature_addon` SELECT * FROM `zr_backup_strat_se_creature_addon`;
CREATE TABLE IF NOT EXISTS `zr_backup_strat_se_creature` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_strat_se_creature_addon` LIKE `creature_addon`;
INSERT IGNORE INTO `zr_backup_strat_se_creature` SELECT * FROM `creature` WHERE `map` = 329 AND `id` = 11030 AND `guid` IN (320587, 320588, 320589, 320590, 320591, 320592, 320593, 320594, 320596, 320597, 320598, 320599, 320601, 320602, 320603, 320604, 320605, 320606, 320607, 320608, 320609, 320610, 320611, 320612, 320613, 320614);
INSERT IGNORE INTO `zr_backup_strat_se_creature_addon` SELECT * FROM `creature_addon` WHERE `guid` IN (320587, 320588, 320589, 320590, 320591, 320592, 320593, 320594, 320596, 320597, 320598, 320599, 320601, 320602, 320603, 320604, 320605, 320606, 320607, 320608, 320609, 320610, 320611, 320612, 320613, 320614);
DELETE FROM `creature_addon` WHERE `guid` IN (320587, 320588, 320589, 320590, 320591, 320592, 320593, 320594, 320596, 320597, 320598, 320599, 320601, 320602, 320603, 320604, 320605, 320606, 320607, 320608, 320609, 320610, 320611, 320612, 320613, 320614);
DELETE FROM `creature` WHERE `map` = 329 AND `id` = 11030 AND `guid` IN (320587, 320588, 320589, 320590, 320591, 320592, 320593, 320594, 320596, 320597, 320598, 320599, 320601, 320602, 320603, 320604, 320605, 320606, 320607, 320608, 320609, 320610, 320611, 320612, 320613, 320614);

-- Check
SELECT CONCAT('Crystal rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 10415 AND `source_type` = 0),
              ', acolyte rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 10399 AND `source_type` = 0),
              ', action 205 rows left ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` IN (10415, 10416, 10808) AND `action_type` = 205),
              ', portcullises ', (SELECT COUNT(*) FROM `gameobject` WHERE `guid` IN (187780, 187797)),
              ', Rivendare credit ', (SELECT `creditEntry` FROM `instance_encounters` WHERE `entry` = 484),
              ', staged bosses ', (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (10394, 10435, 10436, 10437, 10438, 10439, 10809, 45412) AND `flags_extra` & 1024),
              ', Stonespine pooled ', (SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry` = 32900),
              ', Mindless Undead left ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 329 AND `id` = 11030),
              ', backed up ', (SELECT COUNT(*) FROM `zr_backup_strat_se_creature`)) AS `stratholme_service_entrance`;
