-- Scholomance (map 1007): the gates stood turned sideways (Four, 2026-11-11, the Iron Gate 211259 in
-- front of Chillheart's room). Every door on the map had the rotation quaternion (0, 0, 1, ~0), which
-- is a 180 degree turn, whatever its orientation said. The 8.3.7 client draws gameobjects by the
-- quaternion, so a gate with orientation pi/2 stood along the corridor instead of across it.
-- Rebuild the quaternion from the orientation (a turn about z: rotation2 = sin(o/2), rotation3 = cos(o/2)).
-- 12 rows; gates with orientation pi were already right and keep the same values. Safe to run again.
UPDATE `gameobject` SET `rotation2`=SIN(`orientation`/2), `rotation3`=COS(`orientation`/2)
WHERE `map`=1007 AND `rotation0`=0 AND `rotation1`=0 AND `rotation2`=1 AND ABS(`rotation3`)<0.0001;
