-- Gnomeregan convoys and Gnome Travelers march (New Tinkertown road), 2026-11-16
-- Before: 18 frozen recruit+cart+bunny stacks and 6 frozen mounted travelers (snapshots of moving groups; no TrinityCore dump scripts them).
-- Old per-guid convoy scripts pointed at spawn ids that no longer exist.
-- After: 3 recruits each summon and hitch their own Ammo Cart (existing cart SAI), walk the road from New Tinkertown
-- toward Kharanos with pathfinding (SAI waypoints use MovePoint), despawn at the end and respawn after 60 s.
-- One group of 3 mounted Gnome Travelers rides the road the other way.
DELETE FROM `creature` WHERE `id` IN (43273,43276,43279,43297) AND `map`=0 AND `guid` < 735400000;
DELETE FROM `creature_addon` WHERE `guid` IN (168886,168887,168888,169297,169298,169299);
-- actionlist: summon cart for 15 min (the old 4 min ran out before the road ends), hitch it
DELETE FROM `smart_scripts` WHERE `entryorguid`=4327601 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4327601,9,0,0,0,0,100,0,1000,1000,0,0,0,'',12,43273,3,900000,0,0,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - Summon Ammo Cart'),
(4327601,9,1,0,0,0,100,0,1000,1000,0,0,0,'',11,88811,6,0,0,0,0,19,43273,5,0,0,0,0,0,'Gnomeregan Recruit - Cast hitch dummy on nearest Ammo Cart');
DELETE FROM `creature` WHERE `guid` BETWEEN 735400169 AND 735400174;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735400169 AND 735400174;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735400169,43276,0,6457,0,'0',0,0,0,-1,0,0,-5127.5,444.0,395.8,3.435,60,0,0,1,0,0,0,0,0,0,0,'',0),
(735400170,43276,0,6457,0,'0',0,0,0,-1,0,0,-5339.9,373.9,393.8,4.337,60,0,0,1,0,0,0,0,0,0,0,'',0),
(735400171,43276,0,6457,0,'0',0,0,0,-1,0,0,-5422.0,134.0,393.5,4.746,60,0,0,1,0,0,0,0,0,0,0,'',0),
(735400172,43297,0,1,0,'0',0,0,0,-1,2581,0,-5421.2,-285.0,400.7,1.525,60,0,0,1,0,0,0,0,0,0,0,'',0),
(735400173,43297,0,1,0,'0',0,0,0,-1,2581,0,-5423.34,-287.91,400.7,1.525,60,0,0,1,0,0,0,0,0,0,0,'',0),
(735400174,43297,0,1,0,'0',0,0,0,-1,2581,0,-5419.34,-288.09,400.7,1.525,60,0,0,1,0,0,0,0,0,0,0,'',0);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(735400172,0,9476,0,1,0,0,0,0,0,''),
(735400173,0,9473,0,1,0,0,0,0,0,''),
(735400174,0,9476,0,1,0,0,0,0,0,'');
DELETE FROM `creature_formations` WHERE `leaderGUID`=735400172;
INSERT INTO `creature_formations` (`leaderGUID`,`memberGUID`,`dist`,`angle`,`groupAI`,`point_1`,`point_2`) VALUES
(735400172,735400172,0,0,515,0,0),
(735400172,735400173,3,210,515,0,0),
(735400172,735400174,3,150,515,0,0);
DELETE FROM `waypoints` WHERE `entry` BETWEEN 7354164 AND 7354167;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(7354164,1,-5249.5,407.2,391.8,'Gnomeregan Recruit convoy'),
(7354164,2,-5339.9,373.9,393.8,'Gnomeregan Recruit convoy'),
(7354164,3,-5364.9,310.5,394.2,'Gnomeregan Recruit convoy'),
(7354164,4,-5422.0,134.0,393.5,'Gnomeregan Recruit convoy'),
(7354164,5,-5413.6,-119.5,395.4,'Gnomeregan Recruit convoy'),
(7354164,6,-5421.2,-285.0,400.7,'Gnomeregan Recruit convoy'),
(7354165,1,-5364.9,310.5,394.2,'Gnomeregan Recruit convoy'),
(7354165,2,-5422.0,134.0,393.5,'Gnomeregan Recruit convoy'),
(7354165,3,-5413.6,-119.5,395.4,'Gnomeregan Recruit convoy'),
(7354165,4,-5421.2,-285.0,400.7,'Gnomeregan Recruit convoy'),
(7354166,1,-5413.6,-119.5,395.4,'Gnomeregan Recruit convoy'),
(7354166,2,-5421.2,-285.0,400.7,'Gnomeregan Recruit convoy'),
(7354167,1,-5413.6,-119.5,395.4,'Gnome Traveler ride'),
(7354167,2,-5422.0,134.0,393.5,'Gnome Traveler ride'),
(7354167,3,-5364.9,310.5,394.2,'Gnome Traveler ride'),
(7354167,4,-5339.9,373.9,393.8,'Gnome Traveler ride'),
(7354167,5,-5249.5,407.2,391.8,'Gnome Traveler ride'),
(7354167,6,-5127.5,444.0,395.8,'Gnome Traveler ride');
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-735400169,-735400170,-735400171,-735400172);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735400169,0,0,0,37,0,100,0,0,0,0,0,0,'',80,4327601,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - On AI init - Run actionlist (summon cart)'),
(-735400169,0,1,2,27,0,100,0,0,0,0,0,0,'',64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gnomeregan Recruit - Passenger boarded - Store cart'),
(-735400169,0,2,0,61,0,100,0,0,0,0,0,0,'',53,0,7354164,0,0,1000,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - Link - Start waypoints, despawn at end'),
(-735400169,0,3,0,40,0,100,0,6,7354164,0,0,0,'',45,1,1,0,0,0,0,12,1,0,0,0,0,0,0,'Gnomeregan Recruit - Last waypoint - Despawn cart'),
(-735400170,0,0,0,37,0,100,0,0,0,0,0,0,'',80,4327601,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - On AI init - Run actionlist (summon cart)'),
(-735400170,0,1,2,27,0,100,0,0,0,0,0,0,'',64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gnomeregan Recruit - Passenger boarded - Store cart'),
(-735400170,0,2,0,61,0,100,0,0,0,0,0,0,'',53,0,7354165,0,0,1000,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - Link - Start waypoints, despawn at end'),
(-735400170,0,3,0,40,0,100,0,4,7354165,0,0,0,'',45,1,1,0,0,0,0,12,1,0,0,0,0,0,0,'Gnomeregan Recruit - Last waypoint - Despawn cart'),
(-735400171,0,0,0,37,0,100,0,0,0,0,0,0,'',80,4327601,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - On AI init - Run actionlist (summon cart)'),
(-735400171,0,1,2,27,0,100,0,0,0,0,0,0,'',64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,'Gnomeregan Recruit - Passenger boarded - Store cart'),
(-735400171,0,2,0,61,0,100,0,0,0,0,0,0,'',53,0,7354166,0,0,1000,0,1,0,0,0,0,0,0,0,'Gnomeregan Recruit - Link - Start waypoints, despawn at end'),
(-735400171,0,3,0,40,0,100,0,2,7354166,0,0,0,'',45,1,1,0,0,0,0,12,1,0,0,0,0,0,0,'Gnomeregan Recruit - Last waypoint - Despawn cart'),
(-735400172,0,0,0,37,0,100,0,0,0,0,0,0,'',53,0,7354167,0,0,1000,0,1,0,0,0,0,0,0,0,'Gnome Traveler - On AI init - Start waypoints, despawn at end'),
(-735400172,0,1,0,40,0,100,0,6,7354167,0,0,0,'',41,1000,0,0,0,0,0,11,43297,0,20,0,0,0,0,'Gnome Traveler - Last waypoint - Despawn group');
