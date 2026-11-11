-- Desolace entry quests: the "ride my mount" step never happens.
-- Rerouted! (14384, Officer Jankie 36410) and My Time Has Passed (14184, Furien 35286) send you on
-- the quest giver's mount to Nijel's Point (Corporal Melkins 5752) and Furien's Post (Cerelia 35295).
-- Neither the BFA nor the Pandaria world DB has any script, spellclick or path for Jankie's Mount
-- (36416/36419) or Furien's Mount (35287), and none of them is set up as a vehicle, so there is no
-- flight to restore. Stand-in: accepting the quest takes you straight to the turn-in NPC.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (36410, 35286) AND `source_type` = 0 AND `id` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(36410, 0, 0, 0, 19, 0, 100, 0, 14384, 0, 0, 0, 0, '', 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 129.0, 1235.5, 163.6, 3.93, 'Officer Jankie - On Quest Rerouted! Accepted - Teleport Invoker to Corporal Melkins'),
(35286, 0, 0, 0, 19, 0, 100, 0, 14184, 0, 0, 0, 0, '', 62, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, -427.6, 2229.9, 89.5, 3.93, 'Furien - On Quest My Time Has Passed Accepted - Teleport Invoker to Cerelia');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (36410, 35286);
