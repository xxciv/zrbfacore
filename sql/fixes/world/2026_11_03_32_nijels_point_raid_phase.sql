-- Nijel's Point (Desolace): the town is packed with Nijel's Point Defenders, some burning, plus
-- extra Nijel's Point Merchants (Four, 2026-11-03).
--
-- Nijel's Point Defender 35506 (119 spawns) and Nijel's Point Merchant 35510 (10 spawns), all in
-- area 608, are the targets of the Horde quest Rider on the Storm (14198): "While commanding your
-- firestorm, kill 40 Nijel's Point Defenders and burn 15 Nijel's Point Merchants" (objectives
-- 256438/256439). They have no phase, so everyone sees the raid crowd in a calm Alliance town. 11
-- Defenders also carry aura 42726 (dummy aura, the whole-body fire visual) from the sniff. The
-- town's own guards (8151 x18, 51839 x8), its named NPCs and the vortex bunnies are not touched.
--
-- Changed:
--  * 35506 and 35510 spawns move to phase 303 (exists in Phase.db2, normal phase, flags 0, used
--    nowhere else in this DB). Phase 303 is active in Nijel's Point (phase_area 608) while Rider on
--    the Storm is in progress or complete (CONDITION_QUESTSTATE 47, state mask 2|8 = 10).
--  * Aura 42726 removed from the 11 burning Defenders.
--  * creature_queststarter rows (35506, 14198) and (35510, 14198) removed: the quest is started by
--    the Ancient Vortex Runestone (gameobject 195445), not by its own targets.
-- Revert: UPDATE creature SET PhaseId = 0 WHERE id IN (35506, 35510) AND PhaseId = 303; delete the
-- phase_area/conditions rows below; set creature_addon.auras = '42726' on the guids below.
UPDATE `creature` SET `PhaseId` = 303 WHERE `map` = 1 AND `id` IN (35506, 35510) AND `PhaseId` = 0 AND `PhaseGroup` = 0;

UPDATE `creature_addon` SET `auras` = '' WHERE `auras` = '42726' AND `guid` IN (
309531, 309912, 310167, 310400, 310426, 310485, 310542, 310635, 310659, 310677, 310741);

DELETE FROM `creature_queststarter` WHERE `quest` = 14198 AND `id` IN (35506, 35510);

DELETE FROM `phase_area` WHERE `AreaId` = 608 AND `PhaseId` = 303;
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(608, 303, 'Nijel''s Point - Horde firestorm raid while Rider on the Storm is active');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` = 303 AND `SourceEntry` = 608;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, 303, 608, 0, 0, 47, 0, 14198, 10, 0, 0, 0, 0, '', 'Nijel''s Point raid phase 303 while Rider on the Storm (14198) in progress or complete');
