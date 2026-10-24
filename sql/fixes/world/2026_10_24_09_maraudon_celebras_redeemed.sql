-- Maraudon (map 349): Celebras the Redeemed stood next to Celebras the Cursed (Four, 2026-10-24).
--
-- The redeemed spirit (13716) is meant to appear only after the boss dies: the core script
-- celebras_the_cursed summons him on its corpse (JustDied, 10 minutes). The world database also spawns
-- him permanently at the boss's side (guid 324986, the Pandaria 5.4.8 database has the same row), so
-- both versions stood there from the start. Remove the static spawn.
DELETE FROM `creature` WHERE `guid`=324986 AND `id`=13716;
DELETE FROM `creature_addon` WHERE `guid`=324986;
