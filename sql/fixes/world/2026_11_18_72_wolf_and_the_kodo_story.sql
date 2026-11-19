-- The Wolf and The Kodo (25205, Durotar): the fable never played out.
-- 1) The kodos' "wolf is near" trigger used event 79, which is SCENE_TRIGGER in this
--    core (distance-to-creature is event 75), so it never fired.
-- 2) Neither The Wolf 39364 nor The Kodo 39365 had any creature_text, so the
--    text-over chain (talk -> next line -> kill credit -> teleport) had nothing to run on.
-- 3) The old kodo script ran on all six kodos and feigned death on a sniffed guid that
--    does not exist here.
-- Now: one kodo of each pair (303086, 303091, 303093) tells the ending when the wolf
-- comes within 15 yards, its partner plays dead, the rider gets the credit and is
-- returned to Shin Stonepillar, and the wolf despawns.
-- Fable lines from the quest's in-game story (warcraft.wiki.gg), shown as boss emotes.

DELETE FROM `creature_text` WHERE `CreatureID` IN (39364,39365);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(39364,0,0,'One day, The Wolf was very hungry, so he ran east to look for some food.',41,0,100,0,0,0,0,0,'The Wolf - fable 0'),
(39364,1,0,'The Wolf had grown tired of eating boar meat.',41,0,100,0,0,0,0,0,'The Wolf - fable 1'),
(39364,2,0,'The Wolf did not care for raptor meat.',41,0,100,0,0,0,0,0,'The Wolf - fable 2'),
(39364,3,0,'The Wolf found scorpid meat too bitter.',41,0,100,0,0,0,0,0,'The Wolf - fable 3'),
(39364,4,0,'He was hungry for kodo meat.',41,0,100,0,0,0,0,0,'The Wolf - fable 4'),
(39364,5,0,'The Wolf ran and ran, looking for an easy meal.',41,0,100,0,0,0,0,0,'The Wolf - fable 5'),
(39364,6,0,'The more he ran, the more his stomach growled.',41,0,100,0,0,0,0,0,'The Wolf - fable 6'),
(39364,7,0,'He scoured the sands of Durotar, hunting for his prey.',41,0,100,0,0,0,0,0,'The Wolf - fable 7'),
(39364,8,0,'The Wolf was lazy, and didn''t want to work for his meal.',41,0,100,0,0,0,0,0,'The Wolf - fable 8'),
(39365,0,0,'He happened upon a pair of battling kodos.',41,0,100,0,0,0,0,0,'The Kodo - fable 0'),
(39365,1,0,'Clever as he was, The Wolf decided to wait for one to defeat the other.',41,0,100,0,0,0,0,0,'The Kodo - fable 1'),
(39365,2,0,'When the weaker Kodo died, The Wolf approached and tried to eat it.',41,0,100,0,0,0,0,0,'The Kodo - fable 2'),
(39365,3,0,'The remaining Kodo, angry at The Wolf''s impetuousness, swiftly killed The Wolf before he had a chance to eat.',41,0,100,0,0,0,0,0,'The Kodo - fable 3');

-- Entry script is replaced by per-spawn scripts on one kodo of each pair.
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (39365,-303086,-303091,-303093);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-303086,0,0,0,75,0,100,0,0,39364,15,60000,'',1,0,6000,0,0,0,0,1,0,0,0,0,0,0,0,'The Kodo - The Wolf within 15 yd - Say fable 0'),
(-303086,0,1,0,52,0,100,0,0,39365,0,0,'',1,1,6000,0,0,0,0,1,0,0,0,0,0,0,0,'The Kodo - Text 0 over - Say fable 1'),
(-303086,0,2,3,52,0,100,0,1,39365,0,0,'',75,29266,0,0,0,0,0,10,303087,39365,0,0,0,0,0,'The Kodo - Text 1 over - Partner plays dead'),
(-303086,0,3,0,61,0,100,0,0,0,0,0,'',1,2,6000,0,0,0,0,1,0,0,0,0,0,0,0,'The Kodo - Linked - Say fable 2'),
(-303086,0,4,0,52,0,100,0,2,39365,0,0,'',1,3,7000,0,0,0,0,1,0,0,0,0,0,0,0,'The Kodo - Text 2 over - Say fable 3'),
(-303086,0,5,6,52,0,100,0,3,39365,0,0,'',33,39365,0,0,0,0,0,21,30,0,0,0,0,0,0,'The Kodo - Text 3 over - Quest credit to rider'),
(-303086,0,6,7,61,0,100,0,0,0,0,0,'',62,1,0,0,0,0,0,21,30,0,0,1289.54,-4337.85,34.032,3.752,'The Kodo - Linked - Return rider to Shin Stonepillar'),
(-303086,0,7,8,61,0,100,0,0,0,0,0,'',41,500,0,0,0,0,0,11,39364,40,0,0,0,0,0,'The Kodo - Linked - Despawn The Wolf'),
(-303086,0,8,0,61,0,100,0,0,0,0,0,'',28,29266,0,0,0,0,0,10,303087,39365,0,0,0,0,0,'The Kodo - Linked - Partner gets up');

-- Same script for the other two pairs.
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT p.`leader`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,
       IF(`target_type`=10, p.`partner`, `target_param1`),`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`
FROM `smart_scripts` s
JOIN (SELECT -303091 AS `leader`, 303092 AS `partner` UNION ALL SELECT -303093, 303094) p
WHERE s.`entryorguid`=-303086 AND s.`source_type`=0;
