-- Arzeth's Demise (10369): Arzeth the Merciless (19354) had no spawn, so the
-- quest could not be done. Restore the TDB 8.3.7 spawn (TDB guid 69051 is used
-- by another creature here, so a Herald-range guid is used) with its patrol
-- path 690510, which was already in waypoint_data but unused.
-- Also restore the missing SAI rows: OOC shouts, the Powerless shout when the
-- Staff of the Dreghood Elders (spell 35460) turns him into 20680, and the
-- reset back to 19354 if he evades.

DELETE FROM `creature` WHERE `guid`=735490001;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735490001,19354,530,3483,3551,'0',0,0,0,-1,0,1,-617.618,4800.32,38.5306,6.0912,300,0,0,30954,5240,2,0,0,0,0,0,'',0);

DELETE FROM `creature_addon` WHERE `guid`=735490001;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(735490001,690510,0,0,1,0,0,0,0,0,'');

UPDATE `smart_scripts` SET `link`=4 WHERE `entryorguid`=19354 AND `source_type`=0 AND `id`=2;
DELETE FROM `smart_scripts` WHERE `entryorguid`=19354 AND `source_type`=0 AND `id` IN (3,4,5);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19354,0,3,0,1,0,100,0,35000,45000,40000,90000,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Arzeth the Merciless - OOC - Say'),
(19354,0,4,0,61,0,100,512,0,0,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Arzeth the Merciless - Link - Say'),
(19354,0,5,0,25,0,100,0,0,0,0,0,0,'',36,19354,0,0,0,0,0,1,0,0,0,0,0,0,0,'Arzeth the Merciless - On Reset - Update Template To \'Arzeth the Merciless\'');

-- The staff only works on Arzeth (TDB 8.3.7 condition).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry`=35460;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,35460,0,0,31,1,3,19354,0,0,0,0,'','Spell \'Fury of the Dreghood Elders\' can only be used on NPC \'Arzeth the Merciless\'');
