-- Blackrock Spire (map 229): a guide who takes you into the old Upper Spire wing, 2026-11-23. Goes with 2026_11_23_06/07/08.
--
-- Four, 2026-11-23: "walking into UBRS loads the WOD version" ... "heading towards the hall to go to UBRS teleports
-- you out of the dungeon. if you could access the path up top, you could get to it ... i can get you a location
-- for the teleporter npc". Four chose "Add teleporter".
--
-- Since Warlords of Draenor the Blackrock Mountain portal and the hall toward the Dragonspine Door both send you to
-- the new Upper Blackrock Spire (map 1358). The old wing (Emberseer, the Rookery, Rend's arena, Drakkisath) is still
-- in map 229 with floor and mobs, so a new NPC at the Lower Spire entrance, Scarshield Guide (entry 4822900, spawn
-- guid 4822900), offers one gossip option that moves you, inside the same instance, to the Dragonspine Door (Four's
-- spot, 105.8 -319.0 65.5). The new Upper Blackrock Spire stays in the Dungeon Finder and the outside portal as it is.
-- Undo: DELETE FROM `creature` WHERE `guid` = 4822900; DELETE FROM `creature_template` WHERE `entry` = 4822900; DELETE FROM `creature_template_model` WHERE `CreatureID` = 4822900; DELETE FROM `gossip_menu` WHERE `MenuId` = 4822900; DELETE FROM `gossip_menu_option` WHERE `MenuId` = 4822900; DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 4822900;

DELETE FROM `creature_template` WHERE `entry` = 4822900;
INSERT INTO `creature_template` (`entry`, `name`, `subname`, `gossip_menu_id`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `unit_class`, `unit_flags`, `type`, `AIName`, `ScriptName`, `VerifiedBuild`) VALUES
(4822900, 'Scarshield Guide', 'Upper Blackrock Spire', 4822900, 60, 60, 35, 1, 1, 768, 7, 'SmartAI', '', 0);
DELETE FROM `creature_template_model` WHERE `CreatureID` = 4822900;
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(4822900, 0, 9642, 1, 1, 0); -- Acride's model (Scarshield Infiltrator)

DELETE FROM `gossip_menu` WHERE `MenuId` = 4822900;
INSERT INTO `gossip_menu` (`MenuId`, `TextId`, `VerifiedBuild`) VALUES (4822900, 68, 0); -- "Greetings, $n."
DELETE FROM `gossip_menu_option` WHERE `MenuId` = 4822900;
INSERT INTO `gossip_menu_option` (`MenuId`, `OptionIndex`, `OptionIcon`, `OptionText`, `OptionBroadcastTextId`, `OptionType`, `OptionNpcFlag`, `VerifiedBuild`) VALUES
(4822900, 0, 0, 'Take me up to the old Upper Blackrock Spire.', 0, 1, 1, 0);

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 4822900;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(4822900, 0, 0, 1, 62, 0, 100, 0, 4822900, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Scarshield Guide - On Gossip Option 0 - Close Gossip'),
(4822900, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 62, 229, 0, 0, 0, 0, 0, 7, 0, 0, 0, 105.808731, -319.014526, 65.475677, 0.002359, 'Scarshield Guide - Linked - Move player to the Dragonspine Door (same instance), Four''s spot');

DELETE FROM `creature` WHERE `guid` = 4822900;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(4822900, 4822900, 229, 1583, 1583, '1', 0, 0, 0, -1, 0, 0, 42.150948, -314.779022, 53.684311, 4.049838, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);

-- Check: expect guide 1, gossip option 1, script rows 2
SELECT CONCAT('Guide ', (SELECT COUNT(*) FROM `creature` WHERE `guid` = 4822900 AND `map` = 229),
    ', gossip option ', (SELECT COUNT(*) FROM `gossip_menu_option` WHERE `MenuId` = 4822900),
    ', script rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 4822900)) AS `check`;
