-- Hunt for Yenniku (26298, Stranglethorn): Bloodscalp Tusk (3901) almost never dropped
--
-- The quest needs 6 Bloodscalp Tusks from any Bloodscalp troll. The BFA dump has the tusk as a quest
-- drop (QuestRequired 1) on all 11 Bloodscalp types, but only Warriors (36%) and Axe Throwers (37%)
-- drop it often; the Shaman has 10% and the other 8 between 0.1% and 1.3%. Those rates look like
-- sniff counts over all kills, most of them by players without the quest. The Pandaria 5.4.8 world
-- DB (same quest) has 50% on every Bloodscalp. This sets 50% where the rate is lower.
-- Safe to run twice.
--
-- Revert (old chances):
-- UPDATE `creature_loot_template` SET `Chance` = 36 WHERE `Entry` = 587 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 0.59 WHERE `Entry` = 588 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 0.8 WHERE `Entry` = 595 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 1.27 WHERE `Entry` = 597 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 1.26 WHERE `Entry` = 660 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 1.2 WHERE `Entry` = 671 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 36.81 WHERE `Entry` = 694 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 10 WHERE `Entry` = 697 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 1 WHERE `Entry` = 699 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 0.71 WHERE `Entry` = 701 AND `Item` = 3901;
-- UPDATE `creature_loot_template` SET `Chance` = 0.1 WHERE `Entry` = 702 AND `Item` = 3901;

UPDATE `creature_loot_template` SET `Chance` = 50
WHERE `Item` = 3901 AND `QuestRequired` = 1 AND `Chance` < 50
  AND `Entry` IN (587, 588, 595, 597, 660, 671, 694, 697, 699, 701, 702);
