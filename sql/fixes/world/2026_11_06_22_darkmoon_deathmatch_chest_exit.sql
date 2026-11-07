-- Darkmoon Faire Deathmatch: looting the Darkmoon Treasure Chest ends the round (zrbfacore)
--
-- From Four, 2026-11-06: after the chest (209620) in the Deathmatch pit was looted, everyone stayed
-- in the pit. On retail the winner and everyone else inside are sent back out to Korgol Crushskull.
-- The chest already uses SmartGameObjectAI but had no script. Now, when its loot is taken
-- (loot state 3, GO_JUST_DEACTIVATED, the chest is consumable), every player within 35 yd of the
-- chest is teleported to the Exit Deathmatch point (spell 108923's target position,
-- -4300.9, 6397.3, 16.5, facing away from the pit). 35 yd from the chest (Y 6438.88) stays inside
-- the pit, whose edge the core's Deathmatch script puts at Y 6400.
DELETE FROM `smart_scripts` WHERE `entryorguid`=209620 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(209620,1,0,0,70,0,100,0,3,0,0,0,0,'',62,974,0,0,0,0,0,18,35,0,0,-4300.9,6397.3,16.5,4.71,'Darkmoon Treasure Chest - On looted - Teleport players in the pit to the Deathmatch exit');
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=209620 AND `ScriptName`='';
