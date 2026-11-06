-- zrbfacore: Darkmoon Faire Tonk Commander (Finlay Coolshot 54605, quest 29434: 30 x Tonk
-- Target 33081). Four, 2026-11-06: "Tonk doesn't attack or kill anything ... Enemy tonks leave
-- the arena." Goes with darkmoon-faire-gossip.patch (end of game in DarkmoonTonk.cpp).

-- 1. The steam tonk's Cannon (102292) is a cone that picks targets by entry, and it had no
-- target conditions, so it hit nothing. It may hit the Tonk Targets the game pops up (33081),
-- the Enemy Tonks (54642) and the Enemy MiniZeps (54643).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=102292;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,102292,0,0,31,0,3,33081,0,0,0,0,'','Tonk Cannon - Tonk Target'),
(13,1,102292,0,1,31,0,3,54642,0,0,0,0,'','Tonk Cannon - Enemy Tonk'),
(13,1,102292,0,2,31,0,3,54643,0,0,0,0,'','Tonk Cannon - Enemy MiniZep');

-- 2. A hit Tonk Target only despawned; nothing gave the quest credit. Credit the tonk's
-- driver (invoker = the tonk, SAI credits its passengers), then despawn.
DELETE FROM `smart_scripts` WHERE `entryorguid`=33081 AND `source_type`=0 AND `id` IN (1,2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33081,0,1,0,8,0,100,0,102292,0,0,0,0,'',33,33081,0,0,0,0,0,7,0,0,0,0,0,0,0,'Tonk Target - Spellhit Cannon - Kill credit to the tonk driver'),
(33081,0,2,0,8,0,100,0,102292,0,0,0,0,'',41,200,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tonk Target - Spellhit Cannon - Despawn');

-- 3. Enemy Tonks and MiniZeps had SmartAI with no script: they went after the player's tonk
-- and wandered out of the arena. Keep them passive, give the same credit when shot, die, and
-- come back after 10 seconds instead of 2 minutes.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (54642,54643) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(54642,0,0,0,25,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Enemy Tonk - On reset - Passive'),
(54642,0,1,0,8,0,100,0,102292,0,0,0,0,'',33,33081,0,0,0,0,0,7,0,0,0,0,0,0,0,'Enemy Tonk - Spellhit Cannon - Kill credit to the tonk driver'),
(54642,0,2,0,8,0,100,0,102292,0,0,0,0,'',37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Enemy Tonk - Spellhit Cannon - Die'),
(54643,0,0,0,25,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Enemy MiniZep - On reset - Passive'),
(54643,0,1,0,8,0,100,0,102292,0,0,0,0,'',33,33081,0,0,0,0,0,7,0,0,0,0,0,0,0,'Enemy MiniZep - Spellhit Cannon - Kill credit to the tonk driver'),
(54643,0,2,0,8,0,100,0,102292,0,0,0,0,'',37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Enemy MiniZep - Spellhit Cannon - Die');
UPDATE `creature` SET `spawntimesecs`=10 WHERE `map`=974 AND `id` IN (54642,54643);
