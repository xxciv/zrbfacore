-- Stonetalon Mountains, Mirkfallon Lake (Four, 2026-11-03).
--
-- Oil Pump 41475 (11 spawns, guids 272589, 272615, 272672, 273261, 273262, 273264, 273265,
-- 273407-273410): the goblin pumps that Schemin' That Sabotage (25878) has you blow up wander
-- around (MovementType 1, spawndist 3). They are machines that should stand still on their spot.
-- Pandaria DB: MovementType 0, InhabitType 7. The big model is normal (scale 1 in both DBs).
-- Changed: spawns MovementType 1 -> 0, spawndist 3 -> 0; template InhabitType 3 -> 7 so they keep
-- their sniffed height at the lake edge.
UPDATE `creature` SET `MovementType` = 0, `spawndist` = 0 WHERE `id` = 41475 AND `map` = 1 AND `MovementType` = 1;
UPDATE `creature_template` SET `InhabitType` = 7 WHERE `entry` = 41475 AND `InhabitType` = 3;

-- Krom'gar Hot Air Balloon 41418 (guid 272501, spawned at z 148.2 over the dock): InhabitType 3
-- (ground + water), so it drops into the lake. Pandaria DB has InhabitType 4 (air).
-- Changed: InhabitType 3 -> 4.
UPDATE `creature_template` SET `InhabitType` = 4 WHERE `entry` = 41418 AND `InhabitType` = 3;
