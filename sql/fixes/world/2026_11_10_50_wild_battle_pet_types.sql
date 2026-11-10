-- Wild battle pets: Rabbit, Squirrel, Echo Batling and Globe Yeti templates were not wild pets
-- (zrbfacore, 2026-11-10)
--
-- Found (Four): no Rabbit, Squirrel or Chicken battle pets to be seen in Elwynn Forest, only
-- Black Lambs, Small Frogs and Fawns.
--
-- Cause: a creature only becomes a wild battle pet when its template is type 14 (wild pet)
-- (Unit::IsWildBattlePet, Map::AddBattlePet). The battle pet templates Rabbit 61080 and
-- Squirrel 61081 are type 0, Echo Batling 88542 is type 12 (non-combat pet) and Globe Yeti
-- 128156 is type 0. Their spawns (43 Rabbits, 208 Squirrels, 7 Echo Batlings in the world DB)
-- were plain critters you could not battle, and the wild spawn SQL (2026_11_01_50) skipped
-- them because it only converts critters into type 14 pets. These are the only capturable
-- species (BattlePetSpecies flag 0x8) in battlepet_info whose template is not type 14.
-- Elwynn's Chickens are fine (type 14); the zone only allows 2 of them.
--
-- Changed: type = 14 for those 4 templates. After this, run 2026_11_01_50 again so it
-- converts critter rabbits and squirrels up to each zone's cap.
--
-- Undo: UPDATE creature_template SET type = 0 WHERE entry IN (61080, 61081, 128156);
--       UPDATE creature_template SET type = 12 WHERE entry = 88542;

UPDATE `creature_template` SET `type` = 14 WHERE `entry` IN (61080, 61081, 88542, 128156);

SELECT CONCAT((SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (61080, 61081, 88542, 128156) AND `type` = 14),
              ' of 4 pet templates are wild pets') AS zr_result;
