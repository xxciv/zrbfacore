-- World fixes: the Dark Portal in the Blasted Lands takes players to Outland again (2026-11-24)
-- Four: "the dark portal doesn't take you to outland ... you walk right through it" (Map 0, Area 72 The Dark Portal,
-- -11815.2 -3195.54 -30.9).
-- Found: area trigger 4354 (the portal) runs the C++ script at_wod_dark_portal, a Warlords intro script: below level
-- 90 (or with Time Shift) it returns false "to fall through to the Outland teleport", but no teleport row exists for
-- 4354, so nothing happens. At 90+ it sends players into the Tanaan Jungle intro or Ashran instead.
-- TDB 8.3.7 runs 4354 as a SmartTrigger: players above level 57 are teleported to the Hellfire Peninsula side of the
-- portal (530: -248.149, 921.875, 84.3885). Changed to exactly that. Safe to run twice.

UPDATE `areatrigger_scripts` SET `ScriptName`='SmartTrigger' WHERE `entry`=4354;
DELETE FROM `smart_scripts` WHERE `entryorguid`=4354 AND `source_type`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4354,2,0,0,46,0,100,0,4354,0,0,0,62,530,8,0,0,0,-248.149,921.875,84.3885,1.58415,'Areatrigger - On Trigger - Teleport Player');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=4354 AND `SourceId`=2;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,4354,2,0,27,0,57,1,0,0,0,0,'','SAI areatrigger 4354 triggers only if player level is higher than 57');
