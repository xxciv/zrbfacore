-- World fixes: Northern Stranglethorn, first notes from Four's walk (2026-11-19)
-- 1. Four: "DB GUID: 183538 ... Entry: 940 ... bad walking path, walks through house."
--    The 9 Kurzen Medicine Men 940 in Kurzen's Compound had the dump's 3-yard random wander (VerifiedBuild 0,
--    no path), which walks 183538 through the hut wall. TDB 8.3.7 has every Kurzen Medicine Man standing still.
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `id`=940 AND `map`=0 AND `MovementType`=1 AND `spawndist`=3;
-- 2. Four: "Krazek is double spawned". Krazek 773 (guid 182899, quest giver at Nesingwary's Expedition) is
--    the 8.3.7 spawn. Guid 302753 is a second Krazek, entry 52297 (no gossip, no quests), 2.5 yards away;
--    8.3.7 has no spawn of 52297.
DELETE FROM `creature_addon` WHERE `guid`=302753;
DELETE FROM `creature` WHERE `guid`=302753;
-- 3. Four: "DB GUID: 373403 ... Entry: 26204 ... Chillwind Lieutenant currently spawning outside of Midsummer
--    Fire Festival". Ahune's lieutenants stood all year with no game event: Chillwind Lieutenant 26204
--    (Stranglethorn), Frigid Lieutenant 26214 (Searing Gorge), Frostwave Lieutenant 26116 (Ashenvale),
--    Glacial Lieutenant 26215 (Silithus). They belong to the Midsummer Fire Festival (event 1). TDB 8.3.7 has
--    no spawns of them; ours keep their spots and only appear during Midsummer.
DELETE FROM `game_event_creature` WHERE `guid` IN (373403,373404,370754,373405);
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (1,373403),(1,373404),(1,370754),(1,373405);
