-- zrbfacore: Darkmoon Faire booth spell focus objects (Four, 2026-11-06: Ring Toss and the
-- Shooting Gallery both said "Requires Standing at the ... Booth").
-- The game spells need an invisible spell focus gameobject (type 8) near the player:
--   Ring Toss (bar spell 181457): 301114 "Standing at the Ring Toss Booth" (focus 1729, 20 yd),
--   Shooting Gallery: 300129 "TEMP Standing at the Booth Counter" (focus 1471, 10 yd).
-- Neither was spawned. 301114 goes on Jessica Rogers (54485); 300129 at the Pandaria 5.4.8
-- DB position, at Rinling's (14841) counter.
DELETE FROM `gameobject` WHERE `guid` IN (974000001, 974000002);
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `isActive`, `ScriptName`, `VerifiedBuild`) VALUES
(974000001, 301114, 974, 5861, 5870, '0', 0, 0, 0, -1, -4287.87, 6309.00, 13.2001, 1.48353, 0, 0, 0, 1, 120, 255, 1, 0, '', 0),
(974000002, 300129, 974, 5861, 5870, '0', 0, 0, 0, -1, -4078.42, 6354.07, 13.0772, 0, 0, 0, 0, 1, 120, 255, 1, 0, '', 0);
