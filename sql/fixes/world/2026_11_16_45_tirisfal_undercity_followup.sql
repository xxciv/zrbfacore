-- Tirisfal Glades / Undercity follow-up (Four, 2026-11-16)
-- 1) 18 green "Undercity - Forsaken - Fire Small" 193413 effects burning on the Undercity bank and at the Ruins of Lordaeron:
--    leftovers of the Wrath "Battle for the Undercity" scene. TDB 8.3.7 to 12.1.0 spawn none of them.
DELETE FROM `gameobject_addon` WHERE `guid` IN (SELECT `guid` FROM `gameobject` WHERE `id`=193413 AND `map`=0);
DELETE FROM `gameobject` WHERE `id`=193413 AND `map`=0;
-- 2) Forsaken Bats 51384 in Undercity wandered 5 yards at their template walk speed 4.8 and looked frantic.
--    TDB 8.3.7 has them hovering in place (MovementType 0).
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `id`=51384 AND `map`=0;
-- 3) Winter Veil decorations "Tall/Thin Medium - Xmas" 187234 in Tirisfal (Calston Estate and others) shown all year -> Winter Veil (2)
DELETE FROM `game_event_gameobject` WHERE `guid` IN (SELECT `guid` FROM `gameobject` WHERE `id`=187234 AND `map`=0 AND `zoneId` IN (85,6454));
INSERT INTO `game_event_gameobject` (`eventEntry`,`guid`) SELECT 2,`guid` FROM `gameobject` WHERE `id`=187234 AND `map`=0 AND `zoneId` IN (85,6454);
