-- The Wandering Isle: Jaomin Ro 54611 vanishes and resets after Hawk Diving to Earth (Four, 2026-11-16, video)
-- His special cast 108955, which summons "Jaomin Ro's Vehicle" (57750, a hawk) and seats Jaomin in it. The hawk flew up
-- and dove, then the vehicle despawned and Jaomin was gone ("There is nothing to attack") until he reset.
-- Do the dive without a vehicle: Jaomin takes the hawk form himself (model 39796, the same one the core's Jaomin script
-- uses), casts the dive 108935 "Hawk Diving to Earth" (instant, 75% weapon damage plus a short stun around him), then
-- turns back. He stays the same creature and keeps his target.
DELETE FROM `smart_scripts` WHERE `entryorguid`=5461102 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5461102,9,0,0,0,0,100,0,0,0,0,0,0,'',3,0,39796,0,0,0,0,1,0,0,0,0,0,0,0,'Jaomin Ro - Morph to Hawk'),
(5461102,9,1,0,0,0,100,0,1000,1000,0,0,0,'',11,108935,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jaomin Ro - Cast Hawk Diving to Earth (dive, no hawk vehicle)'),
(5461102,9,2,0,0,0,100,0,1500,1500,0,0,0,'',3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jaomin Ro - Demorph');
