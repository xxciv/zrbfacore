-- Scarlet Halls (map 1001): hounds at the entrance.
--
-- 1) Starving Hound (58876) cast Hungry Dog (111582) every 12-15 s. Hungry Dog is a 30 s channel that
--    stuns its target (aura 12) and only ends early when the hound is interrupted, which is a group
--    mechanic: someone else hits the dog off you. Four hounds per pack chained it, so a solo player
--    never stood up again. Now the hound channels it for 4 s and then stops itself, every 20-25 s.
DELETE FROM `smart_scripts` WHERE `entryorguid`=58876 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=5887600 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(58876, 0, 0, 0, 0, 0, 100, 0, 5000, 8000, 20000, 25000, 0, '', 80, 5887600, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Starving Hound - In Combat - Run Script (Hungry Dog, 4 s)'),
(5887600, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 111582, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Starving Hound - Script - Cast Hungry Dog on Victim'),
(5887600, 9, 1, 0, 0, 0, 100, 0, 4000, 4000, 0, 0, 0, '', 92, 0, 111582, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Starving Hound - Script - After 4 s - Stop Hungry Dog');

-- 2) Angry Hound (58674) was level 1 with faction 7 (neutral creature), so it stood there friendly-looking.
--    It is an elite with its own loot table (lootid 58674). The Pandaria 5.4.8 DB has it hostile at level 30.
--    Same levels and faction as the Starving Hounds next to it.
UPDATE `creature_template` SET `faction`=14, `minlevel`=29, `maxlevel`=90 WHERE `entry`=58674;
