-- Razorfen Downs (map 129), Four's first run (2026-10-31).

-- Lady Falther'ess (14686) only meleed: her template names SmartAI but she had no rows. Give her the
-- classic combat set from the AzerothCore database: Ribbon of Souls (22743, damage around her),
-- Banshee Curse (17105) on a random player, and Banshee Shriek (16838, silence and damage within
-- 8 yards). Her classic disguise and Scourge Invasion start are left out.
DELETE FROM `smart_scripts` WHERE `entryorguid`=14686 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `target_param1`, `comment`) VALUES
(14686, 0, 0, 0, 0, 0, 100, 0, 2500, 8000, 10000, 18000, 11, 22743, 0, 1, 0, 'Lady Falther''ess - In Combat - Cast Ribbon of Souls'),
(14686, 0, 1, 0, 0, 0, 100, 0, 12000, 15000, 19000, 22000, 11, 17105, 0, 5, 0, 'Lady Falther''ess - In Combat - Cast Banshee Curse on random player'),
(14686, 0, 2, 0, 0, 0, 100, 0, 7500, 9000, 15000, 20000, 11, 16838, 0, 1, 0, 'Lady Falther''ess - In Combat - Cast Banshee Shriek');

-- Her two items rolled separately at 20% each, so most kills gave only money. In the Pandaria
-- database they share a group (43% / 56%), so one of them always drops. Do the same.
UPDATE `creature_loot_template` SET `GroupId`=1, `Chance`=43.131 WHERE `Entry`=14686 AND `Item`=23177;
UPDATE `creature_loot_template` SET `GroupId`=1, `Chance`=56.23 WHERE `Entry`=14686 AND `Item`=23178;

-- One of the three Idol Room Spawners (invisible markers for the Extinguishing the Idol event) was
-- given random wandering by 2026_10_31_01. Keep it still.
UPDATE `creature` SET `MovementType`=0, `spawndist`=0 WHERE `guid`=325229 AND `id`=8611;
