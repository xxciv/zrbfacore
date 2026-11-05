-- Darkmoon Island: the strider race course stood everywhere for everyone (Four, 2026-11-05).
--
-- The island's strider race (started at "Dusty" Brandom 68492) has no scripts on this server, but its
-- course is spawned: checkpoint arches, power-up crates, tripwire posts, marker arrows and start bunnies.
-- Retail shows these only to players in a race. Here every player saw them, with their [DND]-style names.
-- Until the race exists, the course goes into spawn group 450 with flag 0x04 (SPAWNGROUP_FLAG_MANUAL_SPAWN),
-- so the core keeps it despawned. The race work can switch the group on later.
--
-- Entries (all on map 974): 74153 Powerup Bunny (Dash), 74157 (Jump), 74678 (Rocket), 74800 (Blink),
-- 74872 (Loot), 75063 (Rotating), 75044 Tripwire, 75718 Checkpoint, 74260-74263 Marker 1-4 Pointer,
-- 74420 Marker Camp Pointer, 74536 Bunny Darkmoon Start Race. About 250 spawns in the dump.
DELETE FROM `spawn_group` WHERE `spawnType`=0 AND `spawnId` IN (SELECT `guid` FROM `creature` WHERE `map`=974 AND `id` IN (74153, 74157, 74678, 74800, 74872, 75063, 75044, 75718, 74260, 74261, 74262, 74263, 74420, 74536));
DELETE FROM `spawn_group_template` WHERE `groupId`=450;
INSERT INTO `spawn_group_template` (`groupId`, `groupName`, `groupFlags`) VALUES
(450, 'Darkmoon Island - strider race course (no race script yet)', 0x04);
INSERT INTO `spawn_group` (`groupId`, `spawnType`, `spawnId`)
SELECT 450, 0, `guid` FROM `creature` WHERE `map`=974 AND `id` IN (74153, 74157, 74678, 74800, 74872, 75063, 75044, 75718, 74260, 74261, 74262, 74263, 74420, 74536);
