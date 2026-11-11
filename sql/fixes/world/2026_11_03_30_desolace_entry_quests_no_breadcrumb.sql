-- Desolace entry quests at Tethris Aran were locked behind their breadcrumbs.
-- Rerouted! (14384, Officer Jankie 36410, Alliance) and My Time Has Passed (14184, Furien 35286,
-- Horde) are the zone's starting quests, but:
--   * 14384 had PrevQuestID 25938 (Help for Desolace) and 14184 had PrevQuestID 28548
--     (Warchief's Command: Desolace!);
--   * the breadcrumbs 25938 and 28531 (Hero's Call: Desolace!) have NextQuestID 14384, and 28548
--     has NextQuestID 14184. The core turns a positive NextQuestID into a requirement on the
--     next quest (ObjectMgr adds it to prevQuests), so you had to finish one of the breadcrumbs.
-- Players who walked in without a breadcrumb got no quest. Clear both links; the breadcrumbs
-- still turn in at Jankie and Furien.
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 14384 AND `PrevQuestID` = 25938;
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 14184 AND `PrevQuestID` = 28548;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (25938, 28531) AND `NextQuestID` = 14384;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 28548 AND `NextQuestID` = 14184;
