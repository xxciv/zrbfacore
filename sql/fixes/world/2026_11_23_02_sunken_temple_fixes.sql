-- Sunken Temple (map 109): survey fixes, 2026-11-23.
--
-- 1. Nine Atal'ai Deathwalker's Spirits (8317, guids 320777-320785) stand among the nine Atal'ai Deathwalkers
--    (5271) in the room before Jammal'an. Every Deathwalker already summons its spirit on death (SAI row 2,
--    spell 12095, summon 8317), so these are sniffed summons: 18 elites in the room instead of 9, and the
--    static spirits respawn. AzerothCore has none. Removed (backup zr_backup_st_creature).
-- 2. Jammal'an the Prophet (5710) runs two scripts merged into one with duplicate ids. Rows 7/8 use action 32
--    (nothing in this core), rows 10/11 summon a second Dreamscythe and Weaver on death although both stand
--    in the temple already, Healing Wave is a 5-7 s in-combat loop, Earthgrab Totem and Hex are cast twice,
--    and he says "The Soulflayer comes!" every 31-33 s. Replaced with one script: line 0 when he sees a
--    player, line 1 on aggro, Flamestrike, Earthgrab Totem, Hex plus "Join us!", Healing Wave below 50%
--    health, sound on a kill, no summons. Backup zr_backup_st_smart_scripts.
--    His Hex of Jammal'an (12480) turns the target into a friendly troll (creature 8505, faction 35); alone,
--    that leaves him with no enemy, so he evades and heals to full (Four, 2026-11-23). Swapped for the plain
--    Hex (11641: frog, 5 s, no faction change), still with "Join us!".
-- 3. Dreamscythe (5721, guid 320786) and Weaver (5720, guid 320787) stand 15-20 yards from Morphaz and Hazzas,
--    so the four elite dragons pull together. Moved back to their Pandaria 5.4.8 spots (backup zr_backup_st_creature).
-- Everything the scenario needs (Avatar of Hakkar, Jammal'an, Dreamscythe, Weaver, Morphaz, Hazzas, Shade of
-- Eranikus) and every quest giver and drop are unchanged.

CREATE TABLE IF NOT EXISTS `zr_backup_st_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_st_creature` SELECT * FROM `creature` WHERE `guid` BETWEEN 320777 AND 320787;
CREATE TABLE IF NOT EXISTS `zr_backup_st_smart_scripts` LIKE `smart_scripts`;
INSERT IGNORE INTO `zr_backup_st_smart_scripts` SELECT * FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 5710
    AND NOT EXISTS (SELECT 1 FROM `zr_backup_st_smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 5710);

-- 1. Static Deathwalker's Spirits
DELETE FROM `creature` WHERE `guid` BETWEEN 320777 AND 320785 AND `id` = 8317 AND `map` = 109;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 320777 AND 320785;

-- 2. Jammal'an the Prophet
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 5710;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(5710, 0, 0, 0, 10, 0, 100, 1, 0, 85, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - On OOC LoS - Say Line 0 (once)'),
(5710, 0, 1, 0, 4, 0, 100, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - On Aggro - Say Line 1'),
(5710, 0, 2, 0, 0, 0, 100, 0, 8000, 35000, 20000, 52000, 11, 12468, 0, 0, 0, 0, 0, 5, 0, 0, 0, 'Jammal''an the Prophet - In Combat - Cast Flamestrike'),
(5710, 0, 3, 0, 0, 0, 100, 0, 6000, 16000, 26000, 36000, 11, 8376, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - In Combat - Cast Earthgrab Totem'),
(5710, 0, 4, 5, 0, 0, 100, 0, 16000, 19000, 31000, 53000, 11, 11641, 0, 0, 0, 0, 0, 5, 0, 0, 0, 'Jammal''an the Prophet - In Combat - Cast Hex (frog, 5 s; solo-safe)'),
(5710, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - Linked - Say Line 2'),
(5710, 0, 6, 0, 2, 0, 100, 0, 0, 50, 12000, 16000, 11, 12492, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - Between 0-50% Health - Cast Healing Wave'),
(5710, 0, 7, 0, 5, 0, 100, 0, 0, 0, 0, 0, 4, 5863, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Jammal''an the Prophet - On Killed Unit - Play Sound 5863');

-- 3. Dreamscythe and Weaver back to Pandaria's spots
UPDATE `creature` SET `position_x` = -638.788, `position_y` = 67.189, `position_z` = -90.8441, `orientation` = 4.4666 WHERE `guid` = 320786 AND `id` = 5721;
UPDATE `creature` SET `position_x` = -621.106, `position_y` = 81.2433, `position_z` = -90.8765, `orientation` = 3.08551 WHERE `guid` = 320787 AND `id` = 5720;

-- Check: expect spirits 0, Jammal'an rows 8, summon rows 0, dragons moved 2
SELECT CONCAT('Static spirits ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 109 AND `id` = 8317),
    ', Jammal''an rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 5710),
    ', summon rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 5710 AND `action_type` IN (12, 32)),
    ', dragons moved ', (SELECT COUNT(*) FROM `creature` WHERE (`guid` = 320786 AND ROUND(`position_x`) = -639) OR (`guid` = 320787 AND ROUND(`position_x`) = -621)),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_st_creature`), '/', (SELECT COUNT(*) FROM `zr_backup_st_smart_scripts`)) AS `check`;
