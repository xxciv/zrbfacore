-- Avruu's Orb (9418): Avruu (17084) never dropped Avruu's Orb (23580).
-- The orb STARTS the quest, but the loot row had QuestRequired=1. A
-- QuestRequired item only shows when a quest in the log needs it
-- (Player::HasQuestForItem), so a quest-starting item flagged that way can
-- never drop. TDB 8.3.7 has QuestRequired=0, Chance 80. Without the flag the
-- core still hides the orb once the quest is taken or done (ItemSparse
-- StartQuestID check in LootItem::AllowedForPlayer).
-- Named single-source quest drop -> 100% (Four's rule).
UPDATE `creature_loot_template` SET `QuestRequired`=0, `Chance`=100 WHERE `Entry`=17084 AND `Item`=23580;
