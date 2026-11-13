-- Uldaman (map 70), 2026-11-13: Obsidian Shards stand still.
--
-- Found (Four): the Obsidian Sentinel 7023 splits off Obsidian Shards 7209 (Summon Obsidian Shard 10061
-- at 80/60/40/20% health) that just stand where they appear and never attack.
-- Cause: spell 10061 summons with SummonProperties 61 (Control 1 = ally, Title 2 = guardian), so the
-- core makes the shard a guardian of the Sentinel. A guardian only follows and defends its owner and does
-- not pick a target from line of sight, and its SmartAI (only "cast Obsidian Reflection on aggro") never
-- starts combat. The shards already die with the Sentinel.
-- Changed: two SmartAI rows on 7209: when summoned, enter combat with the players in the instance and
-- attack the closest player within 40 yards.

DELETE FROM `smart_scripts` WHERE `entryorguid` = 7209 AND `source_type` = 0 AND `id` IN (9, 10);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(7209, 0, 9, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Obsidian Shard - On Just Summoned - Set In Combat With Zone'),
(7209, 0, 10, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 49, 0, 0, 0, 0, 0, 0, 21, 40, 0, 0, 0, 0, 0, 0, 'Obsidian Shard - On Just Summoned - Attack Closest Player');

-- Check
SELECT CONCAT((SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 7209 AND `source_type` = 0), ' Obsidian Shard SmartAI rows') AS `uldaman`;
