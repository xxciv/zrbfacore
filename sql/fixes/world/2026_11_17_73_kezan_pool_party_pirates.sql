-- Kezan pool party (Pirate Party Crashers 14115), Quest Fixes thread, 2026-11-17

-- Four: far too many pirates. 34 Pirate Party Crashers 35200 stood in phase 380; the quest needs 12.
-- Keep 17, spread over the whole party area (farthest-point pick), remove the other 17.
DELETE FROM `creature` WHERE `id`=35200 AND `guid` IN (21015029,21015030,21015033,21015034,21015035,21015058,21015061,21015070,21015083,21015091,21015103,21015106,21015109,21015112,21015119,21015133,21015142);
DELETE FROM `creature_addon` WHERE `guid` IN (21015029,21015030,21015033,21015034,21015035,21015058,21015061,21015070,21015083,21015091,21015103,21015106,21015109,21015112,21015119,21015133,21015142);

-- Kezan Partygoer 35202 (70 spawns, phase 380) and 35235 (4 spawns, phase 381) use the
-- invisible-stalker model (display 21342): they are hidden anchors the pirates were brawling with,
-- which showed up as "invisible attackers" with name plates. Make them unselectable (0x02000000)
-- and immune to NPCs (0x200, 35202 already got it in 2026_11_17_72).
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x02000200 WHERE `entry` IN (35202,35235);
