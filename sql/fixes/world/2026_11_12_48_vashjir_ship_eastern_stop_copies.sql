-- The Ship to Vashj'ir (Horde) stops for 10 seconds off the Eastern Kingdoms coast (TaxiPath 2204 node 1,
-- -7006.78 2238.04). The dump has 19 world spawns sniffed on its deck at that stop: Turgore 42982, Adarrah 43051 and
-- 17 invisible event bunnies (Phase Caster 40559, Budd's Vehicle Bunny 43025 x7, Totally Generic Bunny 43091 x8,
-- Sail Activator 46244), all wandering (MovementType 1). They are not passengers, so they stay behind on the water
-- when the ship sails on and drift through the hull (Four, 2026-11-12). Adarrah already rides the ship (2026_11_12_39);
-- Turgore has no deck position, and the bunnies belong to the unscripted ride event. Remove them.
DELETE FROM `creature` WHERE `map`=0 AND `guid` IN
(205700,205701,205702,205703,205704,205705,205706,205707,205708,205709,205710,205711,205712,205713,205714,205715,205717,205718,205720);
DELETE FROM `creature_addon` WHERE `guid` IN
(205700,205701,205702,205703,205704,205705,205706,205707,205708,205709,205710,205711,205712,205713,205714,205715,205717,205718,205720);
