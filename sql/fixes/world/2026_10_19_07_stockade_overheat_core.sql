-- The Stockade: Lord Overheat's Fiery Core (62305), the item for "By Fire Be Saved!" (27737).
-- Four's run 2026-10-19: no core on the first kill, a second kill (after .respawn) dropped it.
-- The row only drops for players on the quest (QuestRequired 1) but had a 36.5696% chance, so most
-- kills of the boss dropped nothing for the quest. Every kill now drops it for a player on the quest.
UPDATE `creature_loot_template` SET `Chance` = 100 WHERE `Entry` = 46264 AND `Item` = 62305;
