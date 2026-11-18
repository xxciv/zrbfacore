-- The Wandering Isle: The Lesson of Stifled Pride 29524 trainees (Four, 2026-11-16)
-- Attacking one Huojin/Tushui Trainee pulled the others and they killed the player.
-- Cause: our templates used monster faction 58 without TDB's civilian flag (flags_extra 2), so nearby trainees joined
-- the fight, and their SmartAI mixed two script versions (duplicate event ids, a missing actionlist 5458600, a 15 s
-- "reset faction" timer on the Tushui trainees) next to a core script on the Tushui trainees.
-- Fix: TDB 8.3.7 templates (faction, flags, civilian) and TDB's SmartAI for all four trainee entries: they fight one on one,
-- at 10% they yield, give quest credit 54586, say a line and leave. TDB gives the Huojin trainees no script (players had to
-- kill them); here they get the same yield script, with Jab instead of Blackout Kick.
UPDATE `creature_template` SET `faction`=2263,`unit_flags`=32768,`unit_flags2`=2048,`flags_extra`=2,`AIName`='SmartAI',`ScriptName`='' WHERE `entry` IN (54586,65470);
UPDATE `creature_template` SET `faction`=2101,`unit_flags`=32768,`unit_flags2`=2048,`flags_extra`=2,`AIName`='SmartAI',`ScriptName`='' WHERE `entry` IN (54587,65471);
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (54586,54587,65470,65471);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (5458600,5458601,5458700,5458701,5458702,5458703,5458704);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(54586,0,1,0,38,1,100,512,1,1,0,0,0,'',80,5458700,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 1 - Run Script'),
(54586,0,2,0,38,1,100,512,1,2,0,0,0,'',80,5458701,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 2 - Run Script'),
(54586,0,3,0,38,1,100,512,1,3,0,0,0,'',80,5458702,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 3 - Run Script'),
(54586,0,4,0,38,1,100,512,1,4,0,0,0,'',80,5458703,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 4 - Run Script'),
(54586,0,5,0,0,0,100,0,2000,2000,2000,2000,0,'',11,109079,0,0,0,0,0,2,0,0,0,0,0,0,0,'Huojin Trainee - In Combat - Cast Jab'),
(54586,0,6,7,2,0,100,513,0,10,0,0,0,'',80,5458704,2,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Run Script (No Repeat)'),
(54586,0,7,8,61,0,100,512,0,10,0,0,0,'',33,54586,0,0,0,0,0,2,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Quest Credit 54586 (No Repeat)'),
(54586,0,8,0,61,0,100,512,0,10,0,0,0,'',22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Set Event Phase 2 (No Repeat)'),
(54586,0,9,0,25,0,100,512,0,0,0,0,0,'',42,0,10,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Set Invincibility Hp 10%'),
(54586,0,10,0,25,0,100,512,0,0,0,0,0,'',22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Set Event Phase 1'),
(54586,0,11,0,25,0,100,512,0,0,0,0,0,'',19,33554688,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Remove Flags Immune To Players & Not Selectable'),
(65470,0,1,0,38,1,100,512,1,1,0,0,0,'',80,5458700,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 1 - Run Script'),
(65470,0,2,0,38,1,100,512,1,2,0,0,0,'',80,5458701,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 2 - Run Script'),
(65470,0,3,0,38,1,100,512,1,3,0,0,0,'',80,5458702,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 3 - Run Script'),
(65470,0,4,0,38,1,100,512,1,4,0,0,0,'',80,5458703,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Data Set 1 4 - Run Script'),
(65470,0,5,0,0,0,100,0,2000,2000,2000,2000,0,'',11,109079,0,0,0,0,0,2,0,0,0,0,0,0,0,'Huojin Trainee - In Combat - Cast Jab'),
(65470,0,6,7,2,0,100,513,0,10,0,0,0,'',80,5458704,2,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Run Script (No Repeat)'),
(65470,0,7,8,61,0,100,512,0,10,0,0,0,'',33,54586,0,0,0,0,0,2,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Quest Credit 54586 (No Repeat)'),
(65470,0,8,0,61,0,100,512,0,10,0,0,0,'',22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - Between 0-10% Health - Set Event Phase 2 (No Repeat)'),
(65470,0,9,0,25,0,100,512,0,0,0,0,0,'',42,0,10,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Set Invincibility Hp 10%'),
(65470,0,10,0,25,0,100,512,0,0,0,0,0,'',22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Set Event Phase 1'),
(65470,0,11,0,25,0,100,512,0,0,0,0,0,'',19,33554688,0,0,0,0,0,1,0,0,0,0,0,0,0,'Huojin Trainee - On Reset - Remove Flags Immune To Players & Not Selectable'),
(54587,0,1,0,38,1,100,512,1,1,0,0,0,'',80,5458700,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 1 - Run Script'),
(54587,0,2,0,38,1,100,512,1,2,0,0,0,'',80,5458701,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 2 - Run Script'),
(54587,0,3,0,38,1,100,512,1,3,0,0,0,'',80,5458702,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 3 - Run Script'),
(54587,0,4,0,38,1,100,512,1,4,0,0,0,'',80,5458703,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 4 - Run Script'),
(54587,0,5,0,0,0,100,0,2000,2000,2000,2000,0,'',11,109080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Tushui Trainee - In Combat - Cast Blackout Kick'),
(54587,0,6,7,2,0,100,513,0,10,0,0,0,'',80,5458704,2,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Run Script (No Repeat)'),
(54587,0,7,8,61,0,100,512,0,10,0,0,0,'',33,54586,0,0,0,0,0,2,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Quest Credit 54586 (No Repeat)'),
(54587,0,8,0,61,0,100,512,0,10,0,0,0,'',22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Set Event Phase 2 (No Repeat)'),
(54587,0,9,0,25,0,100,512,0,0,0,0,0,'',42,0,10,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Set Invincibility Hp 10%'),
(54587,0,10,0,25,0,100,512,0,0,0,0,0,'',22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Set Event Phase 1'),
(54587,0,11,0,25,0,100,512,0,0,0,0,0,'',19,33554688,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Remove Flags Immune To Players & Not Selectable'),
(65471,0,1,0,38,1,100,512,1,1,0,0,0,'',80,5458700,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 1 - Run Script'),
(65471,0,2,0,38,1,100,512,1,2,0,0,0,'',80,5458701,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 2 - Run Script'),
(65471,0,3,0,38,1,100,512,1,3,0,0,0,'',80,5458702,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 3 - Run Script'),
(65471,0,4,0,38,1,100,512,1,4,0,0,0,'',80,5458703,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Data Set 1 4 - Run Script'),
(65471,0,5,0,0,0,100,0,2000,2000,2000,2000,0,'',11,109080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Tushui Trainee - In Combat - Cast Blackout Kick'),
(65471,0,6,7,2,0,100,513,0,10,0,0,0,'',80,5458704,2,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Run Script (No Repeat)'),
(65471,0,7,8,61,0,100,512,0,10,0,0,0,'',33,54586,0,0,0,0,0,2,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Quest Credit 54586 (No Repeat)'),
(65471,0,8,0,61,0,100,512,0,10,0,0,0,'',22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - Between 0-10% Health - Set Event Phase 2 (No Repeat)'),
(65471,0,9,0,25,0,100,512,0,0,0,0,0,'',42,0,10,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Set Invincibility Hp 10%'),
(65471,0,10,0,25,0,100,512,0,0,0,0,0,'',22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Set Event Phase 1'),
(65471,0,11,0,25,0,100,512,0,0,0,0,0,'',19,33554688,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tushui Trainee - On Reset - Remove Flags Immune To Players & Not Selectable'),
(5458700,9,0,0,0,0,100,1,1000,1000,0,0,0,'',5,509,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Play Emote 509'),
(5458701,9,0,0,0,0,100,1,1000,1000,0,0,0,'',5,543,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Play Emote 543'),
(5458702,9,0,0,0,0,100,1,1000,1000,0,0,0,'',5,511,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Play Emote 511'),
(5458703,9,0,0,0,0,100,1,1000,1000,0,0,0,'',5,507,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Play Emote 507'),
(5458704,9,0,0,0,0,100,1,0,0,0,0,0,'',18,33554688,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Set Flags Immune To Players & Not Selectable'),
(5458704,9,1,0,0,0,100,1,0,0,0,0,0,'',27,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Combat Stop'),
(5458704,9,2,0,0,0,100,1,0,0,0,0,0,'',1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Trainee - On Script - Say Line 0'),
(5458704,9,3,0,0,0,100,1,0,0,0,0,0,'',41,4000,4000,0,0,0,0,1,0,0,0,0,0,0,0,'Trainee - On Script - Despawn in 4 s');
