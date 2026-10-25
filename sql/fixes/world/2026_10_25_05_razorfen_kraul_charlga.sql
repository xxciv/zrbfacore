-- Razorfen Kraul (map 47): Charlga Razorflank meleed once, then only cast Elemental Binding (Four, 2026-10-25).
--
-- Her SmartAI recast Elemental Binding (151583, a root with damage over time) on her target every
-- 6 seconds after the first 10, which kept her busy for the whole fight. Crystalline Command (151534)
-- only has a dummy effect this core doesn't script, and she had two aggro speeches. New rotation:
-- Elemental Binding on a random player every 15-20 seconds, Chain Bolt (8292) at her target every
-- 6-9 seconds, and Renew (8362) on herself below 50% health; her texts and the death event that wakes
-- the Spirit of Agamaggan stay. (Her classic Purity, 8361, is left out: it makes her immune to all
-- damage.)
DELETE FROM `smart_scripts` WHERE `entryorguid`=4421 AND `source_type`=0 AND `id` IN (2, 3, 4, 6, 8, 9);
UPDATE `smart_scripts` SET `link`=0 WHERE `entryorguid`=4421 AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(4421, 0, 4, 0, 0, 0, 100, 0, 8000, 10000, 15000, 20000, 11, 151583, 0, 5, 'Charlga Razorflank - In Combat - Cast Elemental Binding on random player'),
(4421, 0, 8, 0, 0, 0, 100, 0, 2000, 4000, 6000, 9000, 11, 8292, 0, 2, 'Charlga Razorflank - In Combat - Cast Chain Bolt'),
(4421, 0, 9, 0, 2, 0, 100, 0, 0, 50, 20000, 25000, 11, 8362, 0, 1, 'Charlga Razorflank - Below 50% HP - Cast Renew on self');
