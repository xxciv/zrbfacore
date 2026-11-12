-- Stormwind portal room: the exit portal (Doodad_8SW_Stormwind_MagePortal001 311875, guid 280200645 at
-- -9000.1 864.5 65.9) is only a decoration; on retail a server-side area trigger sends you back out,
-- and our core has no area trigger teleport action. An invisible ELM General Purpose Bunny 23837 on the
-- portal teleports any player who steps within 1 yard (spot picked by Four in game) to world_safe_locs 3630 'Stormwind - Mage Exit Target'
-- (-9013.2 870.63 148.62), beside the tower-top portal that leads in.
DELETE FROM `creature` WHERE `guid`=735400001;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735400001,23837,0,1519,10523,'0',0,0,0,-1,0,0,-9000.56,865.064,65.889,5.325,300,0,0,1,0,0,0,0,0,0,0,'',0);
DELETE FROM `smart_scripts` WHERE `entryorguid`=-735400001 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735400001,0,0,0,10,0,100,0,1,1,1000,1000,0,'',62,0,0,0,0,0,0,7,0,0,0,-9013.2,870.627,148.617,5.361,'Stormwind portal room exit - OOC LOS 1 yd - teleport player to Mage Exit Target');
