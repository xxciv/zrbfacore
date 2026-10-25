-- Scarlet Halls (map 1001): two Hooded Crusaders stood on top of each other at the entrance.
-- 64738 gives the normal quests (31490 Rank and File, 31493 Just for Safekeeping, Of Course; min level 26),
-- 64764 gives the heroic copies (31495, 31497; level 90). Both spawned in normal and heroic (1,2),
-- so normal showed the heroic one too, with its quests greyed out. Each now spawns only in its own difficulty.
UPDATE `creature` SET `spawnDifficulties`='1' WHERE `guid`=13241581 AND `id`=64738;
UPDATE `creature` SET `spawnDifficulties`='2' WHERE `guid`=13241582 AND `id`=64764;
