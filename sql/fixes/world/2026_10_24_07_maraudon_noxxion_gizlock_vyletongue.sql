-- Maraudon (map 349), first test run (2026-10-24).
--
-- Noxxion (13282) could not be targeted or attacked. His template carried the "not selectable" unit
-- flag (0x02000000) and the quest giver npc flag, and he was listed as a starter of quest 27698
-- "Servants of Theradras" (that quest asks you to kill him). Use the Pandaria 5.4.8 values: npcflag 0,
-- unit_flags 32832, no SmartAI (his fight is the core script boss_noxxion).
-- Razorlash (12258) had the same bogus quest giver flag and starter row. The real giver and ender of
-- 27698 is Zaetar's Spirit (12238), which keeps its row.
UPDATE `creature_template` SET `npcflag`=0, `unit_flags`=32832, `AIName`='' WHERE `entry`=13282;
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=12258;
DELETE FROM `creature_queststarter` WHERE `quest`=27698 AND `id` IN (13282, 12258);

-- Noxxion's Spawn (13456), the adds Noxxion summons, had no scaling row for the dungeon's difficulty.
DELETE FROM `creature_template_scaling` WHERE `Entry`=13456 AND `DifficultyID`=1;
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(13456, 1, 1, 100, 0, 0, 0, 0);

-- Tinkerer Gizlock (13601) and Lord Vyletongue (12236) each had two SmartAI scripts mixed together:
-- an old one with plain spell timers, and a ranged-hunter template that stops moving and stops melee
-- on aggro and then hands everything to phase 1 rows. Nothing ever sets phase 1, so after the pull they
-- just stood still, never meleed, and fired whatever old timer was left. Replace both with one clean
-- script: they chase and melee, shoot when the target is 5-30 yards away, and use their full kit.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (13601, 12236) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(13601, 0, 0, 0, 4, 0, 100, 1, 0, 0, 0, 0, 1, 0, 0, 1, 'Tinkerer Gizlock - On Aggro - Say Line 0'),
(13601, 0, 1, 0, 9, 0, 100, 0, 5, 30, 2300, 3900, 11, 16100, 0, 2, 'Tinkerer Gizlock - Within 5-30 Range - Cast Shoot'),
(13601, 0, 2, 0, 0, 0, 100, 0, 4000, 4000, 12000, 12000, 11, 9143, 0, 5, 'Tinkerer Gizlock - In Combat - Cast Bomb on random player'),
(13601, 0, 3, 0, 0, 0, 100, 0, 6000, 9000, 16000, 19000, 11, 21833, 0, 2, 'Tinkerer Gizlock - In Combat - Cast Goblin Dragon Gun'),
(13601, 0, 4, 0, 0, 0, 100, 0, 12000, 15000, 25000, 25000, 11, 29419, 0, 1, 'Tinkerer Gizlock - In Combat - Cast Flash Bomb'),
(12236, 0, 0, 0, 9, 0, 100, 0, 5, 30, 2300, 3900, 11, 16100, 0, 2, 'Lord Vyletongue - Within 5-30 Range - Cast Shoot'),
(12236, 0, 1, 0, 0, 0, 100, 0, 7000, 9500, 19500, 27800, 11, 21390, 0, 5, 'Lord Vyletongue - In Combat - Cast Multi-Shot on random player'),
(12236, 0, 2, 0, 0, 0, 100, 0, 8000, 12000, 14000, 19000, 11, 7964, 0, 1, 'Lord Vyletongue - In Combat - Cast Smoke Bomb'),
(12236, 0, 3, 0, 0, 0, 100, 0, 15000, 20000, 20000, 30000, 11, 21655, 0, 1, 'Lord Vyletongue - In Combat - Cast Blink');
