-- Wailing Caverns: Muyoh (Disciple of Naralex, 3678) stands halfway down the
-- first chamber, hovering in owl form, instead of at the instance entrance.
--
-- The dump spawns her (guid 326242) at (-84.2, 225.6, -83.8) with aura 8153
-- (owl form) in creature_addon. Her escort (script_waypoint 3678) starts at
-- point 0 just inside the entrance (-120.864, 132.825, -79.2972), so she walks
-- back there before the ritual can start. Owl form lifts her off the floor,
-- out of talking range (5 yd from the player), and she should only take
-- flight form at the end of the event (the script adds it).
--
-- Move her to escort point 0, facing the entrance, and drop the owl form.
--
-- Revert:
--   UPDATE `creature` SET `position_x` = -84.2184, `position_y` = 225.566, `position_z` = -83.7668, `orientation` = 2.3945 WHERE `guid` = 326242;
--   UPDATE `creature_addon` SET `auras` = '8153' WHERE `guid` = 326242;
--
-- Safe to run twice. Also overwrites any position saved with .npc move.
-- Restart worldserver afterwards.

UPDATE `creature` SET `position_x` = -120.864, `position_y` = 132.825, `position_z` = -79.2972, `orientation` = 3.17 WHERE `guid` = 326242 AND `id` = 3678;
UPDATE `creature_addon` SET `auras` = '' WHERE `guid` = 326242;
