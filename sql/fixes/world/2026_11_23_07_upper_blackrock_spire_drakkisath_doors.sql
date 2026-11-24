-- Upper Blackrock Spire wing (map 229): General Drakkisath's doors, 2026-11-23.
--
-- Acride's quest "General Drakkisath, Hand of Nefarian" (27445) needs General Drakkisath (10363). His hall is shut
-- by Doodad_BOSSGATE01/02 (175946 guid 188737, 175947 guid 188732), spawned closed (state 1). The core's Blackrock
-- Spire script names them (GO_DRAKKISATH_DOOR_1/2) but never opens them, so the room could not be entered.
-- Both doors now spawn open.
-- Undo: UPDATE `gameobject` SET `state` = 1 WHERE `guid` IN (188737, 188732);

UPDATE `gameobject` SET `state` = 0 WHERE `guid` IN (188737, 188732) AND `id` IN (175946, 175947) AND `map` = 229;

-- Check: expect open doors 2
SELECT CONCAT('Open doors ', (SELECT COUNT(*) FROM `gameobject` WHERE `guid` IN (188737, 188732) AND `state` = 0)) AS `check`;
