-- Southern Barrens, the Battlescar: "Scout out the flag marker" in Claim the Battlescar never
-- completes (found while investigating the Battlescar with Four, 2026-11-04).
--
-- Claim the Battlescar (Alliance 25081, objective 259939) and Claim the Battle Scar (Horde 24618,
-- objective 266351) have an area-trigger objective (type 10, ObjectID -1) next to "kill 10". Nothing
-- in the DB completes it: no areatrigger_involvedrelation row, no script. The core only marks a
-- type-10 objective done from Player::AreaExploredOrEventHappens, so both quests stay incomplete.
-- (The 4.3.4 version of the quest in the MaNGOS Three DB was kill-only; the scouting step was added
-- later.)
--
-- Changed: the invisible bunny that stands on the flag (35845, guid 269123, -3244.4 -2002.5) gets a
-- per-spawn script: a player within 15 yards and in line of sight gets the scouting credit for
-- whichever of the two quests they have (AreaExploredOrEventHappens does nothing without the quest).
-- A per-spawn script replaces the entry script for this one spawn, so this bunny also stops running
-- 35845's Legion timer rows (the lightning beam at the closest player).
DELETE FROM `smart_scripts` WHERE `entryorguid` = -269123 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(-269123, 0, 0, 0, 10, 0, 100, 0, 1, 15, 1000, 1000, 0, '', 15, 25081, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Battlescar flag bunny - OOC LOS player - Scout the flag (Claim the Battlescar)'),
(-269123, 0, 1, 0, 10, 0, 100, 0, 1, 15, 1000, 1000, 0, '', 15, 24618, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Battlescar flag bunny - OOC LOS player - Scout the flag (Claim the Battle Scar)');
