-- World fixes: Pilgrim's Bounty feast tables, doubled chairs (2026-11-23)
-- Four (Pilgrim's Bounty, after 2026_11_18_46 put the feast back on its event): "looks like chairs are doubled up",
-- "they also chase you around if you move in them when you're sitting and exit", and "Don't need to have names
-- displayed on the chairs and tables."
-- Found: each Bountiful Table 32823 (vehicle 320) brings its own five chairs as vehicle accessories
-- (vehicle_template_accessory: Turkey 34812, Cranberry 34823, Stuffing 34819, Sweet Potato 34824, Pie 34822).
-- Our dump also has 159 loose chair spawns (event 26) next to the 32 tables, so every seat is doubled. A loose chair
-- is a vehicle with no table under it: the player can drive it, and after leaving it the chair walks back home.
-- TDB 8.3.7 has no loose chairs at all (tables only, chairs come from the table). Templates differ from TDB too:
-- the table is clickable (npcflag spellclick) where 8.3.7 has it unselectable, and The Pie Chair has
-- REMOVE_CLIENT_CONTROL (0x4) where 8.3.7 has none; all chairs lack 8.3.7's DISABLE_TURN (unit_flags2 0x8000).
-- Changed:
--   1. The 159 loose chairs removed (the quest role stays on the table's own chairs).
--   2. Table and chair flags as in TDB 8.3.7.
--   3. Our own tuning (Four): no name over tables and chairs (type_flags DO_NOT_RENDER_OBJECT_NAME 0x40000000).
--      The client caches this: delete the WoW client's Cache folder before checking.
-- Safe to run twice.

-- 1. Loose chairs
DELETE FROM `game_event_creature` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (34812,34819,34822,34823,34824));
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (34812,34819,34822,34823,34824));
DELETE FROM `creature` WHERE `id` IN (34812,34819,34822,34823,34824);

-- 2. Flags as in TDB 8.3.7
UPDATE `creature_template` SET `unit_flags`=0x2000000,`npcflag`=0 WHERE `entry`=32823;
UPDATE `creature_template` SET `unit_flags`=0x4000,`unit_flags2`=0x8800 WHERE `entry` IN (34812,34819,34822,34823,34824);

-- 3. No names over the feast (our own tuning)
UPDATE `creature_template` SET `type_flags`=`type_flags`|0x40000000 WHERE `entry` IN (32823,34812,34819,34822,34823,34824);
