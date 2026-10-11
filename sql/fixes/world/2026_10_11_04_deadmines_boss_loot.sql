-- The Deadmines bosses often drop nothing but gold on Normal. Each of their
-- usual items rolls on its own at 9-19%, so Glubtok drops no item about 58% of
-- the time and Helix Gearbreaker about 64%. On retail every boss drops loot.
--
-- Put each boss's usual Normal items (LootMode 1, 5% or more) into one loot
-- group with Chance 0: exactly one of them drops on every kill, picked evenly.
-- The rare extras under 5% still roll on their own. The Cataclysm heroic items
-- (LootMode 2) are left alone.
--
-- Revert (original chances, all in group 0):
--   Glubtok 47162:          2169 15, 5195 16, 5444 18
--   Helix 47296:            5191 9, 5199 11, 5200 9, 5443 10
--   Foe Reaper 5000 43778:  1937 13, 5187 13, 5201 14
--   Admiral Ripsnarl 47626: 872 15, 1156 19, 5196 14, 21524 7
--   "Captain" Cookie 47739: 5192 9, 5193 15, 5197 10, 5198 12, 5202 10
--   e.g. UPDATE creature_loot_template SET GroupId = 0, Chance = 15 WHERE Entry = 47162 AND Item = 2169;
--
-- Safe to run twice. worldserver reads loot tables only at startup: restart it
-- after running this (or use .reload creature_loot_template).

UPDATE `creature_loot_template` SET `GroupId` = 1, `Chance` = 0
WHERE (`Entry` = 47162 AND `Item` IN (2169, 5195, 5444))
   OR (`Entry` = 47296 AND `Item` IN (5191, 5199, 5200, 5443))
   OR (`Entry` = 43778 AND `Item` IN (1937, 5187, 5201))
   OR (`Entry` = 47626 AND `Item` IN (872, 1156, 5196, 21524))
   OR (`Entry` = 47739 AND `Item` IN (5192, 5193, 5197, 5198, 5202));
