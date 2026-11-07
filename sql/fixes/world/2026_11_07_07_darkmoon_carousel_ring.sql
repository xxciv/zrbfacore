-- Darkmoon Faire: carousel rides evenly spaced (zrbfacore)
--
-- From Four, 2026-11-07: "The carousel dragon is out of place. should be between the murloc and
-- the rocket." The six ride spawns were sniffed while the platform was turning, so their radii
-- (6.5 to 8.1 yards) and gaps were uneven and the Dragon sat next to the Gryphon. Puts all six on
-- one 7.4-yard ring around the pole (-4031.01, 6352.32), 60 degrees apart, in the order Murloc,
-- Rocket, Wyvern, Gryphon, Rocket, Dragon, each facing the way the carousel turns.
-- npc_darkmoon_carousel_ride reads the ring from these positions. Run after _06.
UPDATE `creature` SET `position_x`=-4034.64, `position_y`=6345.87, `position_z`=14.1902, `orientation`=2.6294 WHERE `guid`=1400049 AND `id`=68233; -- Murloc
UPDATE `creature` SET `position_x`=-4027.24, `position_y`=6345.95, `position_z`=14.1902, `orientation`=3.6766 WHERE `guid`=1400056 AND `id`=68238; -- Rocket
UPDATE `creature` SET `position_x`=-4023.61, `position_y`=6352.40, `position_z`=14.1902, `orientation`=4.7238 WHERE `guid`=1400050 AND `id`=68239; -- Wyvern
UPDATE `creature` SET `position_x`=-4027.38, `position_y`=6358.77, `position_z`=14.1902, `orientation`=5.7710 WHERE `guid`=1400048 AND `id`=68232; -- Gryphon
UPDATE `creature` SET `position_x`=-4034.78, `position_y`=6358.69, `position_z`=14.1902, `orientation`=0.5350 WHERE `guid`=1400058 AND `id`=68238; -- Rocket
UPDATE `creature` SET `position_x`=-4038.41, `position_y`=6352.24, `position_z`=14.1902, `orientation`=1.5822 WHERE `guid`=1400047 AND `id`=68231; -- Dragon
