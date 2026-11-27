-- Helboar, the Other White Meat (9361): kill Helboars for Tainted Helboar Meat 23270, then use the Purification
-- Mixture 23268 on it (consumes the meat; 50% Purified Helboar Meat 23248, 50% Toxic). Needs 8 Purified.
-- The meat is a quest-only drop (QuestRequired 1), and the core only drops such an item when it is a quest
-- objective or listed in the quest's ItemDrop fields. 23270 is neither (only the purified meat is the objective),
-- so it never dropped for anyone. List it as the quest's drop item (quantity 0 = up to a full stack).
UPDATE `quest_template` SET `ItemDrop1`=23270, `ItemDropQuantity1`=0 WHERE `ID`=9361 AND `ItemDrop1`=0;
-- Chances to TDB 8.3.7 (100% on these boars); ours were 42.8% Deranged, 4.6% Starving, 1.3% Hulking.
-- About 16 meat are needed on average because half the purifications fail.
UPDATE `creature_loot_template` SET `Chance`=100 WHERE `Item`=23270 AND `Entry` IN (16863,16879,16880); -- Deranged, Starving, Hulking Helboar
