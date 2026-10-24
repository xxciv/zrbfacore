-- Scarlet Halls and Scarlet Monastery trash dropped almost nothing on normal (reported by Four,
-- 2026-10-23: "some enemies only drop money", loot "not the same density").
--
-- These are the Mists of Pandaria versions of the Scarlet mobs. Their loot tables were built for
-- heroic: most rows are LootMode 2 (heroic only; the core never gives creatures that mode), and the
-- normal-mode rows (LootMode 1) add up to only 29-47% for one item per kill, with no world-drop
-- reference tables at all. The Pandaria 5.4.8 database has the same split (DUNGEON_HEROIC). For
-- comparison, Deadmines trash has 90-330% plus 30-45% of reference drops, and the old Classic
-- Scarlet Monastery mobs, which are still in the database, have about 155% plus 25-45% of references.
--
-- Give the normal-mode trash the loot of a Classic Scarlet mob of the same level: Scarlet Augur
-- (4284, level 30-31) for Scarlet Halls, Scarlet Monk (4540, level 33) for Scarlet Monastery, and
-- Haunting Phantasm (6427, level 30) for the Frenzied Spirits in the graveyard. Quest-only rows are
-- left out, rows the mob already has are kept as they are, and the added rows carry a comment so
-- this file can be run again (or undone with the DELETE alone).

DELETE FROM `creature_loot_template` WHERE `Comment`='zrbfacore: classic Scarlet loot (normal)';

-- Scarlet Halls (map 1001)
INSERT IGNORE INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT t.`lootid`, d.`Item`, d.`Reference`, d.`Chance`, 0, 1, d.`GroupId`, d.`MinCount`, d.`MaxCount`, 'zrbfacore: classic Scarlet loot (normal)'
FROM `creature_template` t
JOIN `creature_loot_template` d ON d.`Entry`=4284 AND d.`QuestRequired`=0 AND (d.`LootMode` & 1)
WHERE t.`entry` IN (58676, 58683, 58684, 58685, 58756, 58898, 59175, 59240, 59241, 59372, 59373) AND t.`lootid`<>0;

-- Scarlet Monastery (map 1004)
INSERT IGNORE INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT t.`lootid`, d.`Item`, d.`Reference`, d.`Chance`, 0, 1, d.`GroupId`, d.`MinCount`, d.`MaxCount`, 'zrbfacore: classic Scarlet loot (normal)'
FROM `creature_template` t
JOIN `creature_loot_template` d ON d.`Entry`=4540 AND d.`QuestRequired`=0 AND (d.`LootMode` & 1)
WHERE t.`entry` IN (58555, 58569, 58590, 58605, 58783, 59705, 59746) AND t.`lootid`<>0;

INSERT IGNORE INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT t.`lootid`, d.`Item`, d.`Reference`, d.`Chance`, 0, 1, d.`GroupId`, d.`MinCount`, d.`MaxCount`, 'zrbfacore: classic Scarlet loot (normal)'
FROM `creature_template` t
JOIN `creature_loot_template` d ON d.`Entry`=6427 AND d.`QuestRequired`=0 AND (d.`LootMode` & 1)
WHERE t.`entry`=60033 AND t.`lootid`<>0;
