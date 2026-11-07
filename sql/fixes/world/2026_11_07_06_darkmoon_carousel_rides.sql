-- Darkmoon Faire: carousel rides turn with the carousel (zrbfacore)
--
-- From Four, 2026-11-07: the rides are stationary instead of attached to the carousel, there is
-- no way to get off, the camera follows the platform, and some rides seat you backwards.
-- The platform (gameobject 216666) spins clientside, one clockwise turn every 12 seconds; this
-- core cannot carry anything on that kind of transport. The five rides (Carousel Dragon 68231,
-- Gryphon 68232, Murloc 68233, Rocket 68238, Wyvern 68239; 6 spawns on Darkmoon Island) get the
-- new script npc_darkmoon_carousel_ride from tools/bfa/darkmoon-race.patch, which moves each ride
-- around the pole at the platform's speed. The templates had SmartAI with no script rows.
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_darkmoon_carousel_ride' WHERE `entry` IN (68231,68232,68233,68238,68239);
