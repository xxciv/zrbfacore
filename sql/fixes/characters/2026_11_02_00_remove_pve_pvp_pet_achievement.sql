-- Remove "No Time To Heal" (6620) and Pet Brawler progress that PvE pet battles wrongly earned.
--
-- The first version of battle-pet-achievements.patch sent "1 win" in the value that the PvP check
-- (criteria modifier 90) reads, so every PvE win passed it. That awarded No Time To Heal (6620, "win 5
-- consecutive PvP pet battles", criteria 22225) and counted PvE wins towards Pet Brawler 6595-6599
-- (criteria 21525). The patch now reads "is PvP" instead. Run with worldserver stopped; it only touches
-- these two PvP-only criteria and the one achievement.
DELETE FROM `character_achievement` WHERE `achievement` = 6620;
DELETE FROM `character_achievement_progress` WHERE `criteria` IN (21525, 22225);
