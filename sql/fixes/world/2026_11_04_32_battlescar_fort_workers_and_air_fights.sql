-- Southern Barrens, Fort Triumph / Desolation Hold / the Battlescar (Four, 2026-11-04, after SQL 31):
-- "some are just gryphons vs windriders, jankily fighting mid air. Those do not have riders on their
-- backs" and, at Fort Triumph, laborers on the scaffolding: "1 is always asleep sliding all around the
-- floor, the other two ... are constantly thrown and blasted around".
--
-- 1. Air fights: Desolation Wind Rider 37974 (faction 29) and Triumph War Gryphon 37978 (faction 894)
--    are hostile to each other, so once SQL 31 gave them flight routes they started attacking each
--    other where the routes cross. Their riders (Sky Render 37971, Wildhammer Mercenary 37977) get
--    killed in those fights and the mount flies on empty until it respawns. They now ignore other NPCs
--    (unit_flags |= 0x200 UNIT_FLAG_IMMUNE_TO_NPC); players can still fight them.
-- 2. Fort Triumph workers: the 12 Peasant Laborers 39129 and 3 Mizzy's Apprentices 39124 stand and
--    work on the scaffolding (MaNGOS Three: MovementType 0), but ours wander 3 yards (MovementType 1).
--    The laborer script naps now and then (actionlist 3912900: sit, Sleep 6431 for 30 s, stand up), so
--    a sleeping laborer slid around on the boards. The 11 Desolation Guards 38070 at Desolation Hold
--    also stand still in MaNGOS Three but wandered in ours. All 26 now stand still.
--    (The blasting is the Legion knockback on bunny 35845, fixed by SQL 2026_11_03_37.)
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 0x200 WHERE `entry` IN (37971, 37974, 37977, 37978);

UPDATE `creature` SET `MovementType` = 0, `spawndist` = 0 WHERE `map` = 1 AND `MovementType` = 1 AND `guid` IN (
-- Peasant Laborer 39129
269589, 269691, 269787, 269788, 269789, 269790, 269791, 269792, 269942, 270397, 270398, 270399,
-- Mizzy's Apprentice 39124
269398, 269399, 269587,
-- Desolation Guard 38070
268901, 268902, 268903, 268904, 269331, 269333, 269335, 269562, 269565, 269566, 269567);
