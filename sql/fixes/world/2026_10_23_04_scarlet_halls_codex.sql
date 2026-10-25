-- Scarlet Halls: Codex of the Crusade for "Just for Safekeeping, Of Course".
-- Flameweaver Koegler (59150) had the normal quest item 87267 (quest 31493) at Chance 1 with QuestRequired 0,
-- so it dropped one kill in a hundred. The heroic copy 87268 (quest 31497) used loot mode 2, which this
-- core never turns on. Both now drop every time, only for players on the quest that needs them.
UPDATE `creature_loot_template` SET `Chance`=100, `QuestRequired`=1, `LootMode`=1 WHERE `Entry`=59150 AND `Item` IN (87267, 87268);
