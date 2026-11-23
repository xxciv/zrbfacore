-- Blackrock Depths (map 230): faction quest chains, 2026-11-22. Goes with blackrock-depths.patch (same day).
--
-- Morgan's Militia (Alliance) and the Kargath Expeditionary Force (Horde) give the same chain from the same
-- spots, but the 8.x dump let every race take both: an Alliance player saw a "!" over Thal'trak Proudtusk and
-- Galamav the Marksman as well as Jalinda Sprig and Oralius. Race masks as in Pandaria 5.4.8 and the two
-- Adventurers Wanted quests (28068 Alliance, 28069 Horde). blackrock-depths.patch also hides the other
-- side's quest givers.

UPDATE `quest_template` SET `AllowableRaces` = 6130900294268439629
WHERE `ID` IN (27565, 27567, 27568, 27569, 27571, 27573, 27578);
UPDATE `quest_template` SET `AllowableRaces` = 12261800583900083122
WHERE `ID` IN (27579, 27581, 27582, 27585, 27589, 27591, 27593);

-- Check
SELECT CONCAT('Alliance chain quests ', (SELECT COUNT(*) FROM `quest_template` WHERE `ID` IN (27565, 27567, 27568, 27569, 27571, 27573, 27578) AND `AllowableRaces` = 6130900294268439629),
    ', Horde chain quests ', (SELECT COUNT(*) FROM `quest_template` WHERE `ID` IN (27579, 27581, 27582, 27585, 27589, 27591, 27593) AND `AllowableRaces` = 12261800583900083122)) AS `check`;
