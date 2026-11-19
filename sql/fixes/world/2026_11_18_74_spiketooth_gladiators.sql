-- Spiketooth's gladiators (Durotar): Ghislania 25257, Griswold Hanniston 25258, Gaur Icehorn 25259.
-- Talking to Ghislania 39351, Gaur Icehorn 39352 or Griswold Hanniston 39353 showed only a greeting.
-- Their gossip menus 11229-11231 had no gossip_menu row and no option, and their SAI sent a
-- non-existent menu 39590 on hello and listened for option 1 of that menu, so a fight could never
-- start. The SAI also had duplicate ids (two id 0 rows each) and an action list that made them
-- unattackable on spawn.
-- Now: each has a "Let's fight" option while its quest is in progress. Picking it makes the NPC
-- hostile and attack you; at 5% health it stops taking damage (credit fires at 6% or less), gives the credit to the closest
-- player, evades and turns friendly again.
-- Greeting texts 15641-15643 are the three unused npc_text ids between this area's menus (id order).
-- Option text is our own wording (no sniffed text in the data).

DELETE FROM `gossip_menu` WHERE `MenuID` IN (11229,11230,11231);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (11229,15641,0),(11230,15642,0),(11231,15643,0);
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (11229,11230,11231);
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES (11229,0,0,'Spiketooth wants to see what you''re made of. Let''s fight!',0,1,1,0),(11230,0,0,'Spiketooth wants to see what you''re made of. Let''s fight!',0,1,1,0),(11231,0,0,'Spiketooth wants to see what you''re made of. Let''s fight!',0,1,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup` IN (11229,11230,11231);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES (15,11229,0,0,0,9,0,25257,0,0,0,0,0,'','Ghislania - fight option only while quest 25257 is in progress'),(15,11230,0,0,0,9,0,25259,0,0,0,0,0,'','Gaur Icehorn - fight option only while quest 25259 is in progress'),(15,11231,0,0,0,9,0,25258,0,0,0,0,0,'','Griswold Hanniston - fight option only while quest 25258 is in progress');
UPDATE `creature_template` SET `npcflag`=1, `AIName`='SmartAI', `ScriptName`='' WHERE `entry` IN (39351,39352,39353);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid`=3935100;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (39351,39352,39353);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39351,0,0,0,25,0,100,0,0,0,0,0,'',42,0,5,0,0,0,0,1,0,0,0,0,0,0,0,'Reset - Cannot drop below 5% health'),
(39351,0,1,2,62,0,100,0,11229,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gossip option 0 - Close gossip'),
(39351,0,2,3,61,0,100,0,0,0,0,0,'',2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Turn hostile'),
(39351,0,3,0,61,0,100,0,0,0,0,0,'',49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Linked - Attack player'),
(39351,0,4,5,2,0,100,0,0,6,5000,5000,'',33,39351,0,0,0,0,0,21,40,0,0,0,0,0,0,'5% HP - Credit to closest player'),
(39351,0,5,0,61,0,100,0,0,0,0,0,'',24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Evade'),
(39351,0,6,0,7,0,100,0,0,0,0,0,'',2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Evade - Restore friendly faction'),
(39351,0,7,0,0,0,100,0,0,3400,4700,0,'',11,76429,64,0,0,0,0,2,0,0,0,0,0,0,0,'In combat - Cast Static Burst'),
(39351,0,8,0,0,0,100,0,5000,5000,9000,12000,'',11,79913,0,0,0,0,0,2,0,0,0,0,0,0,0,'In combat - Cast Chain Lightning'),
(39352,0,0,0,25,0,100,0,0,0,0,0,'',42,0,5,0,0,0,0,1,0,0,0,0,0,0,0,'Reset - Cannot drop below 5% health'),
(39352,0,1,2,62,0,100,0,11230,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gossip option 0 - Close gossip'),
(39352,0,2,3,61,0,100,0,0,0,0,0,'',2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Turn hostile'),
(39352,0,3,0,61,0,100,0,0,0,0,0,'',49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Linked - Attack player'),
(39352,0,4,5,2,0,100,0,0,6,5000,5000,'',33,39352,0,0,0,0,0,21,40,0,0,0,0,0,0,'5% HP - Credit to closest player'),
(39352,0,5,0,61,0,100,0,0,0,0,0,'',24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Evade'),
(39352,0,6,0,7,0,100,0,0,0,0,0,'',2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Evade - Restore friendly faction'),
(39352,0,7,0,2,0,100,1,0,30,0,0,'',11,76423,0,0,0,0,0,1,0,0,0,0,0,0,0,'30% HP - Cast Taunka Rage'),
(39352,0,8,0,2,0,100,1,0,30,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'30% HP - Say enraged'),
(39353,0,0,0,25,0,100,0,0,0,0,0,'',42,0,5,0,0,0,0,1,0,0,0,0,0,0,0,'Reset - Cannot drop below 5% health'),
(39353,0,1,2,62,0,100,0,11231,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gossip option 0 - Close gossip'),
(39353,0,2,3,61,0,100,0,0,0,0,0,'',2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Turn hostile'),
(39353,0,3,0,61,0,100,0,0,0,0,0,'',49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Linked - Attack player'),
(39353,0,4,5,2,0,100,0,0,6,5000,5000,'',33,39353,0,0,0,0,0,21,40,0,0,0,0,0,0,'5% HP - Credit to closest player'),
(39353,0,5,0,61,0,100,0,0,0,0,0,'',24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Linked - Evade'),
(39353,0,6,0,7,0,100,0,0,0,0,0,'',2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Evade - Restore friendly faction'),
(39353,0,7,0,4,0,100,0,0,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Aggro - Say text'),
(39353,0,8,0,0,0,100,0,3000,5000,8000,10000,'',11,76490,0,0,0,0,0,1,0,0,0,0,0,0,0,'In combat - Cast Flurry of Claws');

-- Objective texts (were empty).
UPDATE `quest_objectives` SET `Description`='Ghislania defeated' WHERE `ID`=266751;
UPDATE `quest_objectives` SET `Description`='Gaur defeated' WHERE `ID`=265311;
UPDATE `quest_objectives` SET `Description`='Griswold defeated' WHERE `ID`=265270;
