-- Quest fixes (Herald), 2026-11-16: Mulgore batch.

-- 1. Supervisor Fizsprocket (3051) summoned a Deviate Viper on aggro.
--    His SmartAI row 0 ("Cast Commanding Shout on Aggro") casts spell 7973, which is
--    "Summon Deviate Viper" (summons creature 5755), not a shout. Retail Fizsprocket only uses
--    Lantern Blaze 81767, Motivate 81754 and Throw Lantern 81764 (rows 1-3, kept).
DELETE FROM `smart_scripts` WHERE `entryorguid`=3051 AND `source_type`=0 AND `id`=0 AND `action_type`=11 AND `action_param1`=7973;

-- 2. The Restless Earth (14491): the tracker read "Earth Spirit Credit Bunny slain".
--    The objective counts kill credit 36872 and had no text, so the client fell back to the
--    creature's name. Retail text: "Spirits Calmed".
UPDATE `quest_objectives` SET `Description`='Spirits Calmed' WHERE `QuestID`=14491 AND `ObjectID`=36872 AND `Type`=0;

-- 3. Morin Cloudstalker (2988) offered "Supervisor Fizsprocket" and "The Venture Co." twice each:
--    the pre-Cataclysm quests 765 and 764 (all races, follow The Ravaged Caravan 751) next to the
--    current 26180 and 26179. Keep the old ones, but mark them in the title.
UPDATE `quest_template` SET `LogTitle`='Legacy - Supervisor Fizsprocket' WHERE `ID`=765 AND `LogTitle`='Supervisor Fizsprocket';
UPDATE `quest_template` SET `LogTitle`='Legacy - The Venture Co.' WHERE `ID`=764 AND `LogTitle`='The Venture Co.';
