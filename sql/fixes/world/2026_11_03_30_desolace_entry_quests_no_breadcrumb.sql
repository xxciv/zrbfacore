-- Desolace entry quests at Tethris Aran were locked behind one specific breadcrumb.
-- Rerouted! (14384, Officer Jankie 36410, Alliance) required Help for Desolace (25938), and
-- My Time Has Passed (14184, Furien 35286, Horde) required Warchief's Command: Desolace! (28548).
-- Players who arrive by Hero's Call: Desolace! (28531), the other breadcrumb, or by just walking
-- in got no quest. They are the zone's starting quests, so clear the requirement; the breadcrumbs
-- still point at them (NextQuestID) and turn in at the same NPCs.
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 14384 AND `PrevQuestID` = 25938;
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 14184 AND `PrevQuestID` = 28548;
