-- The Source of the Madness (quest 26734, Northern Stranglethorn): Whispering Blue Stone 60263
-- (1 needed) dropped from the four Kurzen chiefs in the back of the cave at 7.7-26.7%.
-- Make it a sure drop from each chief while the quest is active (QuestRequired 1 stays).
-- Kurzen Elite/Headshrinker/Witch Doctor/Subchief/Shadow Hunter keep their 1-5% chance.
UPDATE `creature_loot_template` SET `Chance` = 100
WHERE `Item` = 60263 AND `Entry` IN (43910, 43911, 43912, 43913);
