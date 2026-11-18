-- The Lost Isles: Pterrordax Scavengers 36719 "freaking out" (Four, 2026-11-16, video)
-- All 70 wandered in a 3-yard radius at their template walk speed 4.4, so they kept snapping back and forth.
-- TDB 8.3.7 has the same speed but wanders them over 10 yards (86 spawns) or keeps them still (30).
-- Use TDB's 10-yard radius so they glide around instead of jittering.
UPDATE `creature` SET `spawndist`=10 WHERE `id`=36719 AND `map`=648 AND `MovementType`=1;
