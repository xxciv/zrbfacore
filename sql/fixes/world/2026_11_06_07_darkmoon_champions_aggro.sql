-- zrbfacore: Champion Faesrol (55732) and Champion Isimode (55733) by the Tonk Commander
-- area on Darkmoon Island pulled players from far away (normal aggro radius, up to 45 yd
-- for low-level players against these level 80s). Four: "lower their aggro range to if a
-- player gets right up on them". They had SmartAI with no rows. Now they are defensive and
-- only attack a hostile player within 5 yards (and anyone who attacks them).
-- The player-only condition keeps them from starting on each other (they stand 2 yd apart).
-- Safe to run more than once.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (55732,55733) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(55732,0,0,0,25,0,100,0,0,0,0,0,0,'',8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Champion Faesrol - On Reset - Set Defensive'),
(55732,0,1,0,10,0,100,0,0,5,1000,1000,0,'',49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Champion Faesrol - Hostile Player Within 5 yd - Attack'),
(55733,0,0,0,25,0,100,0,0,0,0,0,0,'',8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Champion Isimode - On Reset - Set Defensive'),
(55733,0,1,0,10,0,100,0,0,5,1000,1000,0,'',49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Champion Isimode - Hostile Player Within 5 yd - Attack');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=2 AND `SourceEntry` IN (55732,55733) AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,2,55732,0,0,52,0,64,0,0,0,0,0,'','Champion Faesrol - aggro only on players'),
(22,2,55733,0,0,52,0,64,0,0,0,0,0,'','Champion Isimode - aggro only on players');
