-- Thunder Down Under (25236, Durotar): clicking a Drowned Thunder Lizard 39464 gave no credit.
-- Its spellclick cast 80948 "Razgar's Fillet Knife" (an unrelated knife spell: dummy + create item 58958).
-- The right spell is 73945 "Attach Tether": kill credit 39464 to the clicker and summons a
-- Hulking Orcish Laborer 39465 to haul the carcass out.
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=39464;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(39464,73945,1,0);

-- Only while the quest is in progress.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=39464;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,39464,73945,0,0,9,0,25236,0,0,0,0,0,'','Drowned Thunder Lizard - Attach Tether only while Thunder Down Under is in progress');

-- The summoned laborer has no duration; let it go after the lizard is gone.
DELETE FROM `smart_scripts` WHERE `entryorguid`=39465 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39465,0,0,0,54,0,100,0,0,0,0,0,'',41,8000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Hulking Orcish Laborer - Just summoned - Despawn after 8 s');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=39465;

-- Only 7 lizards for an objective of 8: respawn in 60 s instead of 5 min.
UPDATE `creature` SET `spawntimesecs`=60 WHERE `id`=39464;

-- One credit per lizard: drop the click flag as soon as it is tethered (it despawns 5 s later).
DELETE FROM `smart_scripts` WHERE `entryorguid`=39464 AND `source_type`=0 AND `id`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39464,0,2,0,73,0,100,0,0,0,0,0,'',83,16777216,0,0,0,0,0,1,0,0,0,0,0,0,0,'Drowned Thunder Lizard - On spellclick - Remove spellclick flag');

-- Objective text (was NULL, so the log read "Drowned Thunder Lizard slain").
UPDATE `quest_objectives` SET `Description`='Drowned Thunder Lizard removed' WHERE `ID`=265482;
