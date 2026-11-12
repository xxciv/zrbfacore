-- "Call of Duty" (Horde 25924, Alliance 14482): the objective had no text, so the tracker showed the raw kill credit
-- "0/1 Submerge Bunny slain". Retail text (also the quests' AreaDescription; the locale rows of 14482 say the same).
UPDATE `quest_objectives` SET `Description`='Ride the mercenary ship to Vashj''ir' WHERE `ID` IN (266797,266167) AND `QuestID` IN (25924,14482);
