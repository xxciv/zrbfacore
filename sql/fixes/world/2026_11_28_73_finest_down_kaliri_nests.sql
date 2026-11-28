-- The Finest Down (9420): Kaliri Nests (181582) did nothing when opened. The
-- nest is a goober with SmartGameObjectAI but had no SAI rows.
-- TDB 8.3.7: opening a nest hatches a Female (17034) or Male (17039) Kaliri
-- Hatchling, and the hatchlings drop the Kaliri Feathers 23588.
-- TDB routes this through Invisible Location Trigger 19656 casting 29396/29397
-- (Summon Kaliri Female/Male). Those spells are not in the 8.3.7 client data,
-- and 19656 is a shared trigger (49 static spawns in Hellfire, also used by
-- Amanitar in Ahn'kahet), so the nest picks a hatchling itself instead.
-- Hatchlings despawn after 2 minutes if left alone.

DELETE FROM `smart_scripts` WHERE `entryorguid`=181582 AND `source_type`=1;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (18158200,18158201) AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(181582,1,0,0,70,0,100,0,2,0,0,0,0,'',87,18158200,18158201,0,0,0,0,1,0,0,0,0,0,0,0,'Kaliri Nest - On State Changed - Run Random Script'),
(18158200,9,0,0,0,0,100,0,0,0,0,0,0,'',12,17034,2,120000,0,0,0,1,0,0,0,0,0,0,0,'Kaliri Nest - Script 1 - Summon Female Kaliri Hatchling'),
(18158201,9,0,0,0,0,100,0,0,0,0,0,0,'',12,17039,2,120000,0,0,0,1,0,0,0,0,0,0,0,'Kaliri Nest - Script 2 - Summon Male Kaliri Hatchling');
