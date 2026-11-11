-- Dire Maul (map 429), Warpwood Quarter: Warpwood Treant bouncing through the air (Four, 2026-11-03).
--
-- 2026_11_03_05 gave three spawns (Warpwood Treant 323675 and 323700, Warpwood Tangler 323994) the
-- same 300-yard AzerothCore loop round the whole courtyard (paths 429000031, 429000033, 429000038,
-- 48 points each). Four saw treant 323675 bouncing through the air on it. The BFA courtyard is
-- not the 3.3.5 one, and no other database has this patrol for these guids. All three go back
-- to a 2-yard wander at their spawn point.
UPDATE `creature` SET `MovementType`=1, `spawndist`=2, `currentwaypoint`=0 WHERE `guid` IN (323675, 323700, 323994);
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid` IN (323675, 323700, 323994);
DELETE FROM `waypoint_data` WHERE `id` IN (429000031, 429000033, 429000038);
