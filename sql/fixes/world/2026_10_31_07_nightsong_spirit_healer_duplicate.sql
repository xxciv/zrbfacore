-- Nightsong graveyard (Ashenvale, Raynewood Tower, world_safe_locs 1427): two Spirit Healers (6491)
-- stand on the same spot, 129879 at (2300.44, -1729.46, 119.871) and 371367 at (2301.68, -1730.46,
-- 120.162), same phase and difficulty. Four asked to remove the extra one (2026-10-31). Keep the older
-- spawn 129879.
DELETE FROM `creature` WHERE `guid` = 371367 AND `id` = 6491;
DELETE FROM `creature_addon` WHERE `guid` = 371367;
