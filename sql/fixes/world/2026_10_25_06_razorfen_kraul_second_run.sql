-- Razorfen Kraul (map 47), second run (Four, 2026-10-25).

-- Hunter Bonetusk (75001): Barrage did nothing. It's a channel whose damage comes from a periodic
-- spell (150884) fired from an aura on Bonetusk himself; this core casts that at Bonetusk, not at his
-- channel target, so it never hits. Replace it with Aimed Shot (27632), and add Serpent Sting
-- (31975) on a random player.
DELETE FROM `smart_scripts` WHERE `entryorguid`=75001 AND `source_type`=0 AND `id` IN (1, 6, 7, 8, 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `target_param1`, `comment`) VALUES
(75001, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 12000, 16000, 11, 27632, 1, 2, 0, 'Hunter Bonetusk - In Combat - Cast Aimed Shot (Barrage never hit)'),
(75001, 0, 6, 0, 0, 0, 100, 0, 3000, 5000, 12000, 15000, 11, 31975, 0, 5, 0, 'Hunter Bonetusk - In Combat - Cast Serpent Sting on random player'),
-- His boars despawn when he dies. Each summon is a different Agam'ar so each can be found by entry.
(75001, 0, 7, 8, 6, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 100, 4514, 'Hunter Bonetusk - On Death - Despawn summoned Raging Agam''ar'),
(75001, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 100, 4511, 'Hunter Bonetusk - On Death - Despawn summoned Agam''ar'),
(75001, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 0, 0, 100, 4512, 'Hunter Bonetusk - On Death - Despawn summoned Rotting Agam''ar');
UPDATE `smart_scripts` SET `action_param1`=4511, `comment`='Hunter Bonetusk - At 50% HP - Summon Agam''ar' WHERE `entryorguid`=75001 AND `source_type`=0 AND `id`=4 AND `action_type`=12;
UPDATE `smart_scripts` SET `action_param1`=4512, `comment`='Hunter Bonetusk - At 50% HP - Summon Rotting Agam''ar' WHERE `entryorguid`=75001 AND `source_type`=0 AND `id`=5 AND `action_type`=12;

-- Groyat (75247): Sonic Charge (151454) only moved him. It leaps at the target and then lays 12
-- damaging area triggers (151407 -> areatriggers 1465-1476) that aren't in the database. Make the
-- charge hit: right after it, cast its damage spell (151429) on the target.
DELETE FROM `smart_scripts` WHERE `entryorguid`=75247 AND `source_type`=0 AND `id`=6;
UPDATE `smart_scripts` SET `link`=6 WHERE `entryorguid`=75247 AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(75247, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 11, 151429, 2, 2, 'Groyat - After Sonic Charge - Cast Sonic Charge damage on target');

-- Charlga Razorflank (4421): Elemental Binding every 25-30 seconds instead of 15-20.
UPDATE `smart_scripts` SET `event_param3`=25000, `event_param4`=30000 WHERE `entryorguid`=4421 AND `source_type`=0 AND `id`=4 AND `action_param1`=151583;
