-- Stormwind: two stray single spawns.
-- 1. Prisoner (53527), guid 300000881, standing alone in the middle of the bridge between the
--    Trade District and the Mage Quarter (-8852.22, 732.729, 99.9581). It is the only Prisoner
--    spawn in the world, with no waypoints, formation or SmartAI, so the guard escort it belongs
--    to doesn't exist on this server and it just stands there.
-- 2. Gil (3504), guid 189600, under the bridge next to it (-8867.41, 760.137, 97.1436), below
--    the bridge deck. Gil is one of the orphans who followed Miss Danna (3513) around Stormwind;
--    Miss Danna and the other children (3505-3512) have no spawns in this database, Gil has no
--    formation or path, and his spawn is not sniffed (VerifiedBuild 0), so there is no correct
--    place to move him to.
-- Both spawns are removed.
-- Revert:
-- INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
-- (300000881, 53527, 0, 1519, 5154, '0', 0, 0, 0, -1, 0, 0, -8852.22, 732.729, 99.9581, 2.03857, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 27101),
-- (189600, 3504, 0, 1519, 5390, '0', 0, 0, 0, -1, 338, 0, -8867.41, 760.137, 97.1436, 4.16563, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);
DELETE FROM `creature_addon` WHERE `guid` IN (300000881, 189600);
DELETE FROM `creature` WHERE `guid` IN (300000881, 189600);
