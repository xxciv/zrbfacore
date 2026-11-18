-- Teldrassil review (starter zones pass, 2026-11-16): zones Teldrassil 141 and Shadowglen 6450
-- Reference: TDB 8.3.7. Teldrassil is close to TDB; critters and wild battle pets are never touched.
-- 1) small overspawns: Vicious Grell and Giant Webwood Spider trimmed to TDB, two of three stacked Boglings removed
DELETE FROM `creature` WHERE `guid` IN (277706,278145,277517,278674,278726,278669,278660,278733,302865,302866);
DELETE FROM `creature_addon` WHERE `guid` IN (277706,278145,277517,278674,278726,278669,278660,278733,302865,302866);
-- 2) Fel Cone quest objects standing twice on the same spot
DELETE FROM `gameobject` WHERE `guid` IN (177505,177520,177549,177593,177665,177780);
DELETE FROM `gameobject_addon` WHERE `guid` IN (177505,177520,177549,177593,177665,177780);
-- 3) holiday pieces: Midsummer bonfire bunny, Spring Rabbit; every Noblegarden Bunny Controller in the world (none were linked)
DELETE FROM `game_event_creature` WHERE `guid` IN (353124,10649606);
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (1,353124),(9,10649606);
DELETE FROM `game_event_creature` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id`=32784);
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) SELECT 9,`guid` FROM `creature` WHERE `id`=32784;
