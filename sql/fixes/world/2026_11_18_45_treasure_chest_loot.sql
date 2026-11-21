-- World fixes: Maplewood and Runestone Treasure Chests often open empty (2026-11-18)
-- Four: "Is the Maplewood Treasure Chest on the top floor supposed to have any loot?" (Tiragarde Keep, Durotar)
-- 11 treasure chest templates pointed at one shared loot table 207520 (not in TDB 8.3.7): 206 items rolled one
-- by one at 0.1-2% each, so about 2 chests in 5 opened empty, and every chest drew from the same list whatever its
-- level. TDB 8.3.7 gives each chest its level's table (39334-39344, already in our DB), where two groups always
-- drop: 1-2 gems or potions plus one item of the chest's level.
-- Spawns: Tiragarde Keep in Durotar (207520), plus Darkshore, Ashenvale, Stonetalon, Desolace, Feralas,
-- Thousand Needles, Howling Fjord, Borean Tundra, Grizzly Hills, Icecrown and Abyssal Depths (207521-207542).
-- Safe to run twice.

UPDATE `gameobject_template` SET `Data1`=39334 WHERE `entry`=207520;
UPDATE `gameobject_template` SET `Data1`=39335 WHERE `entry`=207521;
UPDATE `gameobject_template` SET `Data1`=39336 WHERE `entry` IN (207522,207534);
UPDATE `gameobject_template` SET `Data1`=39337 WHERE `entry` IN (207523,207535);
UPDATE `gameobject_template` SET `Data1`=39338 WHERE `entry`=207524;
UPDATE `gameobject_template` SET `Data1`=39342 WHERE `entry` IN (207528,207540);
UPDATE `gameobject_template` SET `Data1`=39343 WHERE `entry`=207529;
UPDATE `gameobject_template` SET `Data1`=39344 WHERE `entry`=207542;
