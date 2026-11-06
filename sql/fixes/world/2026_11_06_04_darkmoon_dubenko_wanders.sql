-- zrbfacore: Dubenko (54490), the Ring Toss turtle, stood still. His spawn (guid 1400112)
-- had MovementType 2 (waypoints) but no path, so he never moved. Four asked for him to
-- move around the pen to make the game harder: wander up to 3 yards from his spot.
-- Safe to run more than once.
UPDATE `creature` SET `MovementType`=1, `spawndist`=3 WHERE `guid`=1400112 AND `id`=54490;
UPDATE `creature_template` SET `MovementType`=0 WHERE `entry`=54490;
