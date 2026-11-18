-- The Wolf and The Kodo (25205, Durotar), Quest Fixes thread, 2026-11-18
--
-- Shin Stonepillar 39380 had gossip_menu_id 0, so right-clicking him showed nothing (he has no
-- quest to offer once 25205 is taken). His fable option already exists as menu 11209
-- ("Can you tell me your fable, Shin?") and his SAI casts Summon The Wolf 73840 on that option
-- (you ride the wolf to the kodos, which act out the story and give the credit), but the menu
-- was never attached and had no gossip_menu text row.
-- Text 15612 (broadcast 39442) is the unused npc_text between Garrosh's 11206/15606 and
-- Thunderflash's 11211/15615, the neighbouring menus of this quest batch.
UPDATE `creature_template` SET `gossip_menu_id`=11209 WHERE `entry`=39380;
DELETE FROM `gossip_menu` WHERE `MenuID`=11209;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (11209,15612,0);

-- Close the window when the option is picked (the wolf summon follows)
DELETE FROM `smart_scripts` WHERE `entryorguid`=39380 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39380,0,0,1,62,0,100,0,11209,0,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Shin Stonepillar - On Gossip Option 0 - Close Gossip'),
(39380,0,1,0,61,0,100,0,0,0,0,0,0,'',85,73840,0,0,0,0,0,7,0,0,0,0,0,0,0,'Shin Stonepillar - Link - Invoker Casts Summon The Wolf');

-- Only offer the fable while the quest is in progress
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=11209;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11209,0,0,0,9,0,25205,0,0,0,0,0,'','Shin Stonepillar - fable option only while The Wolf and The Kodo is in progress');

-- Tracker read "The Kodo slain"; retail objective is "Listen to the shaman's fable"
UPDATE `quest_objectives` SET `Description`='Listen to the shaman''s fable' WHERE `ID`=265242;
