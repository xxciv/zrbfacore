-- Razorfen Downs (map 129): Koristrasza kept flying past the player (Four, 2026-11-03).
--
-- Koristrasza (44843, guid 325205) is a friendly blue dragon from the Cataclysm quest line, parked
-- high above the dungeon. 2026_10_31_01 gave her the Pandaria database's waypoint path, which is a
-- one-way flight from that spot down to the trail at 2384, 951. As a looping path she dives through
-- the dungeon over and over. Take the path off so she stays where she was.
UPDATE `creature` SET `MovementType`=0, `spawndist`=0, `currentwaypoint`=0 WHERE `guid`=325205 AND `id`=44843;
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=325205;
DELETE FROM `waypoint_data` WHERE `id`=129000018;
