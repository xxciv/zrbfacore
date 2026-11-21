-- Stratholme (map 329), 2026-11-21: Supply Crates 176224 (Stratholme Holy Water) say "You can't open that".
--
-- The server never sends that message (ERR_USE_CANT_OPEN is not used anywhere in the core), so the client refuses
-- the click before it casts Opening. The crates' lock (57), loot (13646) and spawns are fine, and the Gordok Tribute
-- in Dire Maul opens with the same lock. The one difference is Data10, require line of sight, which the client
-- checks against the crate itself; the server ignores it. Turned off. The client caches gameobject data, so delete
-- the client's Cache folder before testing.

UPDATE `gameobject_template` SET `Data10` = 0 WHERE `entry` = 176224;

-- Check
SELECT CONCAT('Supply Crate lock ', `Data0`, ', loot ', `Data1`, ', require LOS ', `Data10`) AS `check`
FROM `gameobject_template` WHERE `entry` = 176224;
