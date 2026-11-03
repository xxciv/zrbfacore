-- Razorfen Downs (map 129): Koristrasza dropped to the ground wherever she was put (Four, 2026-11-03).
--
-- Koristrasza (44843) plays a flying animation but her template only allows ground and water
-- (InhabitType 3), so the server snaps her down to the floor below her spawn point. Let her fly
-- (4 = air) so she hovers where she is placed.
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry`=44843;
