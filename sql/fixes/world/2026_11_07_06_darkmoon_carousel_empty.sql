-- Darkmoon Faire: carousel without rides (zrbfacore)
--
-- From Four, 2026-11-07: "let's just remove all the carousel mounts, and leave it as a spinning
-- empty platform." The carousel platform (gameobject 216666) spins clientside, but this core can't
-- carry anything on it, and the rides (vehicles) could not be left: the client refused Leave
-- Vehicle and a server-side exit left the rider stuck half on. Removes the six Darkmoon Island ride
-- spawns (Carousel Dragon 68231, Gryphon 68232, Murloc 68233, Rocket 68238 x2, Wyvern 68239) and
-- clears the test script name an earlier draft of this fix set on the templates. The templates stay
-- (other maps have copies). The platform keeps spinning.
DELETE FROM `creature` WHERE `map`=974 AND `guid` IN (1400047,1400048,1400049,1400050,1400056,1400058);
UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='' WHERE `entry` IN (68231,68232,68233,68238,68239) AND `ScriptName`='npc_darkmoon_carousel_ride';
