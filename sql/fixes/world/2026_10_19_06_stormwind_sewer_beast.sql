-- Stormwind canals: the Sewer Beast (3581, rare crocolisk) walks the canal pathways instead of
-- staying under water.
-- It has three spawns, pooled by core update 2026_09_09_00_world_sewer_beast.sql so only one is up
-- at a time. That update also set MovementType 1 and spawndist 25 on all three. Two of the spawn
-- points are at walkway height, not in the water:
--   308329 (-8583.18, 522.841, 92.7076) - the guard NPCs on the canal walkways stand at z 92.71
--   10604700 (-8781.6, 488.886, 92.6396)
-- The third, 52499 (-8560.69, 486.619, 85.8912), is on the canal floor. Random movement in this
-- core moves in a straight line to a random point up to spawndist away and up to 10 yards higher
-- (RandomMovementGenerator), so even from the canal floor a 25 yard wander reaches the walkways.
-- Fix, using the alexkulya/pandaria_5.4.8 world database as the reference (it has the same three
-- spawns, the two on the canal floor standing still):
--   * 10604700 moves to Pandaria's spot for it, (-8783.6, 487.416, 85.8914), on the canal floor.
--   * 308329 is removed (spawn and pool entry): it has no canal floor position in any data checked.
--   * The remaining two stand still (MovementType 0, spawndist 0), as in the Pandaria data.
-- Revert:
-- UPDATE `creature` SET `position_x` = -8781.6, `position_y` = 488.886, `position_z` = 92.6396, `orientation` = 0.77626 WHERE `guid` = 10604700;
-- UPDATE `creature` SET `MovementType` = 1, `spawndist` = 25 WHERE `id` = 3581;
-- INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
-- (308329, 3581, 0, 1519, 5390, '0', 0, 0, 0, -1, 0, 0, -8583.18, 522.841, 92.7076, 5.51031, 3600, 25, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0);
-- INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES (308329, 3581, 0, 'Sewer Beast');
DELETE FROM `pool_creature` WHERE `guid` = 308329;
DELETE FROM `creature_addon` WHERE `guid` = 308329;
DELETE FROM `creature` WHERE `guid` = 308329;
UPDATE `creature` SET `position_x` = -8783.6, `position_y` = 487.416, `position_z` = 85.8914, `orientation` = 0.528863 WHERE `guid` = 10604700;
UPDATE `creature` SET `MovementType` = 0, `spawndist` = 0 WHERE `id` = 3581;
