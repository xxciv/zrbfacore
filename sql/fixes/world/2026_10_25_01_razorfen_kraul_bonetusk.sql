-- Razorfen Kraul (map 47): Hunter Bonetusk only shot, and held no weapon (Four, 2026-10-25).
--
-- His SmartAI fired Shoot (150879) every 1-2 seconds at any range up to 20 yards, so his other casts
-- kept landing while he was busy and never went off. Volley (150904) only has dummy effects that need
-- a spell script this core doesn't have, and Stampede (150917) triggers spell 132660, which isn't in
-- the client's spell data, so neither did anything. His speech rows point at texts that don't exist.
-- New script: he chases and melees, Shoots when the target is 5-30 yards away, channels Barrage
-- (150881, interrupting whatever he was casting), uses Multi-Shot (21390) on a random player, and at
-- 50% health three Raging Agam'ar (4514) charge in around his target ("boars overrun", standing in
-- for the broken Stampede).
DELETE FROM `smart_scripts` WHERE `entryorguid`=75001 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `target_type`, `target_x`, `target_y`, `comment`) VALUES
(75001, 0, 0, 0, 9, 0, 100, 0, 5, 30, 2300, 3900, 11, 150879, 0, 0, 0, 2, 0, 0, 'Hunter Bonetusk - Within 5-30 Range - Cast Shoot'),
(75001, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 17000, 22000, 11, 150881, 1, 0, 0, 2, 0, 0, 'Hunter Bonetusk - In Combat - Cast Barrage'),
(75001, 0, 2, 0, 0, 0, 100, 0, 11000, 13000, 12000, 16000, 11, 21390, 0, 0, 0, 5, 0, 0, 'Hunter Bonetusk - In Combat - Cast Multi-Shot on random player'),
(75001, 0, 3, 4, 2, 0, 100, 1, 0, 50, 0, 0, 12, 4514, 2, 60000, 1, 2, 4, 0, 'Hunter Bonetusk - At 50% HP - Summon Raging Agam''ar'),
(75001, 0, 4, 5, 61, 0, 100, 0, 0, 0, 0, 0, 12, 4514, 2, 60000, 1, 2, -2, 3, 'Hunter Bonetusk - At 50% HP - Summon Raging Agam''ar'),
(75001, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 12, 4514, 2, 60000, 1, 2, -2, -3, 'Hunter Bonetusk - At 50% HP - Summon Raging Agam''ar');

-- No weapons: none of the Warlords bosses had an equipment row. Give Bonetusk the Razorfen
-- Beastmaster's dagger and bow, and Warlord Ramtusk the two axes of the classic Overlord Ramtusk
-- he replaced.
DELETE FROM `creature_equip_template` WHERE `CreatureID` IN (75001, 74462);
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(75001, 1, 2184, 0, 0, 0, 0, 0, 2551, 0, 0, 0),
(74462, 1, 5286, 0, 0, 5286, 0, 0, 0, 0, 0, 0);
UPDATE `creature` SET `equipment_id`=1 WHERE `guid` IN (10591174, 10591176);

-- The Boar Spirit (6021) next to him belonged to Aggem Thorncurse, the classic boss Bonetusk replaced.
-- It's not part of his fight; remove it.
DELETE FROM `creature` WHERE `guid`=325407 AND `id`=6021;
DELETE FROM `creature_addon` WHERE `guid`=325407;
