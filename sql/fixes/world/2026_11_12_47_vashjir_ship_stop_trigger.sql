-- Follow-up to 2026_11_12_40 / 43 / 45: the ship's own script (on the server's copy of the ship) never caught
-- the rider. This ship's server copy and the client's copy are not in step (Four, 2026-11-12: the ship sat at the
-- Orgrimmar docks on screen while its crew vanished, and reached the Vashj'ir stop on screen about 45 seconds after
-- the server's ship), so at the server's stop the rider is somewhere else and the stored list can miss them too.
-- Instead, an invisible bunny waits at the Vashj'ir stop itself (TaxiPath 2204 node 4, -4632.93 3863.71) in phase
-- 170, so only players on "Call of Duty" see it. Every second it takes the players within 60 yards (the deck reaches
-- about 50 yards from the ship's centre), teleports them next to Erunak Stonespeaker and gives credit 36901. The
-- player's own position follows their client's ship, so this fires when the ship reaches the stop on their screen.
-- The ship's SmartAI from 40/45 is removed.
DELETE FROM `smart_scripts` WHERE `entryorguid`=203466 AND `source_type`=1;

DELETE FROM `creature` WHERE `guid`=735400002;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735400002,23837,0,4815,5051,'0',0,170,0,-1,0,0,-4632.93,3863.71,14.0,0,300,0,0,1,0,0,0,0,0,0,0,'',0);
DELETE FROM `smart_scripts` WHERE `entryorguid`=-735400002 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735400002,0,0,1,1,0,100,0,1000,1000,1000,1000,0,'',64,1,0,0,0,0,0,17,0,60,0,0,0,0,0,'Vashj''ir ship stop bunny - OOC every 1s - Store players within 60 yd (phase 170 = on Call of Duty)'),
(-735400002,0,1,2,61,0,100,0,0,0,0,0,0,'',62,0,0,0,0,0,0,12,1,0,0,-4608.77,3982.0,-70.4,2.217,'Vashj''ir ship stop bunny - Linked - Teleport stored players to Erunak Stonespeaker'),
(-735400002,0,2,0,61,0,100,0,0,0,0,0,0,'',33,36901,0,0,0,0,0,12,1,0,0,0,0,0,0,'Vashj''ir ship stop bunny - Linked - Quest credit Call of Duty 25924');
