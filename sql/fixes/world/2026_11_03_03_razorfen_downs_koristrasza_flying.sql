-- Razorfen Downs (map 129): Koristrasza dropped to the ground wherever she was put (Four, 2026-11-03).
--
-- Koristrasza (44843) plays a flying animation but her template only allows ground and water
-- (InhabitType 3), so the server snaps her down to the floor below her spawn point. Let her fly
-- (4 = air) so she hovers where she is placed.
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry`=44843;

-- Where Four placed her in game (2026-11-03), clear of the vines.
UPDATE `creature` SET `position_x`=2369.33, `position_y`=1020.62, `position_z`=69.838 WHERE `guid`=325205 AND `id`=44843;
