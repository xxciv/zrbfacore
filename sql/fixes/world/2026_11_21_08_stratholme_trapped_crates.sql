-- Stratholme (map 329), 2026-11-21: Supply Crates say "You can't open that".
--
-- Map 329 has two kinds of Supply Crate. 18 Holy Water crates 176224 (lock 57, loot 13646) and 51 vermin crates
-- 176304/176307/176308/176309 (no lock, no loot; opening one lets out bugs, maggots, rats or a plague mist).
-- Each vermin crate links a trap 175534-175537 (lock 1766 = Disarm Trap), which the core spawns on the same spot,
-- and the 8.x sniff also caught those traps as 47 static spawns, so most vermin crates had two traps on them.
-- A rogue sees the traps (Four selected trap 175534, guid 187948), and clicking one tries to disarm it: "You
-- can't open that". 2026_11_21_07 (Holy Water crate line of sight) did not help; undone here.
--
-- 1. The 47 static trap spawns removed (backup zr_backup_strat_crate_traps). Not tied to any quest.
-- 2. The vermin crates no longer link a trap; they run AzerothCore's script instead: opening one casts the
--    crate's vermin spell on the player, opens the lid and despawns it after 5 seconds.

UPDATE `gameobject_template` SET `Data10` = 1 WHERE `entry` = 176224;

CREATE TABLE IF NOT EXISTS `zr_backup_strat_crate_traps` LIKE `gameobject`;
INSERT IGNORE INTO `zr_backup_strat_crate_traps` SELECT * FROM `gameobject` WHERE `map` = 329 AND `id` IN (175534, 175535, 175536, 175537);
DELETE FROM `gameobject_addon` WHERE `guid` IN (SELECT `guid` FROM `zr_backup_strat_crate_traps`);
DELETE FROM `gameobject` WHERE `map` = 329 AND `id` IN (175534, 175535, 175536, 175537);

UPDATE `gameobject_template` SET `Data7` = 0, `AIName` = 'SmartGameObjectAI' WHERE `entry` IN (176304, 176307, 176308, 176309);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (176304, 176307, 176308, 176309) AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(176304, 1, 0, 1, 64, 0, 100, 0, 1, 0, 0, 0, 0, 67, 1, 5000, 5000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Create Timed Event'),
(176304, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 16369, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Cast Bugs'),
(176304, 1, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 118, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Set Gameobject State Active'),
(176304, 1, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 99, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Timed Event - Set Loot State Deactivated'),
(176307, 1, 0, 1, 64, 0, 100, 0, 1, 0, 0, 0, 0, 67, 1, 5000, 5000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Create Timed Event'),
(176307, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 16370, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Cast Maggots'),
(176307, 1, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 118, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Set Gameobject State Active'),
(176307, 1, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 99, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Timed Event - Set Loot State Deactivated'),
(176308, 1, 0, 1, 64, 0, 100, 0, 1, 0, 0, 0, 0, 67, 1, 5000, 5000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Create Timed Event'),
(176308, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 16371, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Cast Rats'),
(176308, 1, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 118, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Set Gameobject State Active'),
(176308, 1, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 99, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Timed Event - Set Loot State Deactivated'),
(176309, 1, 0, 1, 64, 0, 100, 0, 1, 0, 0, 0, 0, 67, 1, 5000, 5000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Create Timed Event'),
(176309, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 16432, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Cast Plague Mist'),
(176309, 1, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 118, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Gossip Hello - Set Gameobject State Active'),
(176309, 1, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 99, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Supply Crate - On Timed Event - Set Loot State Deactivated');

-- Check
SELECT CONCAT('Trap spawns left ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 329 AND `id` IN (175534, 175535, 175536, 175537)),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_strat_crate_traps`),
    ', crates linking a trap ', (SELECT COUNT(*) FROM `gameobject_template` WHERE `entry` IN (176304, 176307, 176308, 176309) AND `Data7` <> 0),
    ', vermin crate rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` IN (176304, 176307, 176308, 176309) AND `source_type` = 1),
    ', Holy Water crates ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 329 AND `id` = 176224)) AS `check`;
