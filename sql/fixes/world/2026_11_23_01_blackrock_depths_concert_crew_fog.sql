-- Blackrock Depths (map 230): the purple mist over the dungeon floors, 2026-11-23.
--
-- Cause: Mizli Crankwheel (28209, guid 321720) and Ognip Blastbolt (28210, guid 321719), the L70ETC
-- concert crew on the Grim Guzzler stage, were spawned all year with no game event. Their SmartAI runs
-- the show on its own: every 5 s out of combat Mizli sets data 6 9 on Ognip, which (11 min cooldown)
-- runs action list 2821001: Ognip casts spell 105389 ("blue plague-like fog" aura, drawn as a purple
-- mist over the floors), shouts the 5-minute announcement and 5 min later summons the band; the fog is
-- removed 265 s after that. So the mist was up about 9 of every 11 minutes, everywhere in view.
-- Found by hiding spawns in halves (thread "Remove purple fog in Blackrock Depths").
-- Fix: the crew belongs to the Brewfest concert, so it spawns only on Brewfest (event 24) like the band,
-- the controllers (2026_11_23_00) and the stage rig (2026_11_22_07). The show and its fog still run
-- during Brewfest.
-- Undo: DELETE FROM `game_event_creature` WHERE `eventEntry` = 24 AND `guid` IN (321719, 321720);

DELETE FROM `game_event_creature` WHERE `guid` IN (321719, 321720);
INSERT INTO `game_event_creature` (`eventEntry`, `guid`)
SELECT 24, `guid` FROM `creature`
WHERE `map` = 230 AND `guid` IN (321719, 321720) AND `id` IN (28209, 28210);

-- Check: expect 2
SELECT CONCAT('Concert crew on Brewfest: ', COUNT(*)) AS `check`
FROM `game_event_creature` WHERE `eventEntry` = 24 AND `guid` IN (321719, 321720);
