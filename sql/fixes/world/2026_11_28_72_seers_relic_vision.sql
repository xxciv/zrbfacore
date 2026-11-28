-- The Seer's Relic (9545): using the relic gives the credit (event 10745), but
-- the vision it should show never played. Vindicator Sedai stood around with a
-- stand-in "You are free" gossip credit, Krun Spinebreaker stood on a hill, and
-- the Mag'har escorts and Laughing Skull ambushers were not spawned.
-- Restore the TDB 8.3.7 event: the six actors stay invisible until the relic's
-- Sedai Quest Credit Marker (17413) is summoned. The escorts march Sedai down,
-- the ambushers jump them, Krun executes Sedai, then everyone despawns and
-- respawns hidden after 2 minutes.
-- Existing Sedai (307814) and Krun (373556) spawns are moved into the event
-- (TDB guids 78644 / 78647); escorts and ambushers get Herald-range guids.

-- Spawns
UPDATE `creature` SET `position_x`=211.676,`position_y`=4126.36,`position_z`=79.0458,`orientation`=2.3911,`spawntimesecs`=120,`spawndist`=0,`MovementType`=0 WHERE `guid`=307814 AND `id`=17404;
UPDATE `creature` SET `position_x`=230.508,`position_y`=4118.71,`position_z`=83.562,`orientation`=2.94961,`spawntimesecs`=120,`spawndist`=0,`MovementType`=0,`equipment_id`=1 WHERE `guid`=373556 AND `id`=17405;
DELETE FROM `creature` WHERE `guid` BETWEEN 735490002 AND 735490005;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735490002,17417,530,3483,3483,'0',0,0,0,-1,0,1,214.657,4122.55,79.8511,2.25148,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735490003,17417,530,3483,3483,'0',0,0,0,-1,0,1,216.035,4125.61,80.2234,2.25148,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735490004,17418,530,3483,3483,'0',0,0,0,-1,0,1,261.518,4106.81,93.315,2.66398,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735490005,17418,530,3483,3483,'0',0,0,0,-1,0,1,260.63,4103.53,93.3337,2.60972,120,0,0,1,0,0,0,0,0,0,0,'',0);

-- TDB factions/flags: Mag'har side 1683, Laughing Skull side 1684, players
-- can't interfere (IMMUNE_TO_PC). Sedai loses the stand-in gossip.
UPDATE `creature_template` SET `faction`=1683,`npcflag`=0,`gossip_menu_id`=0,`unit_flags`=256 WHERE `entry`=17404;
UPDATE `creature_template` SET `faction`=1684,`unit_flags`=256 WHERE `entry`=17405;
UPDATE `creature_template` SET `faction`=1683,`unit_flags`=33024 WHERE `entry`=17417;
UPDATE `creature_template` SET `faction`=1684,`unit_flags`=33024 WHERE `entry`=17418;

-- SmartAI (TDB 8.3.7, guids remapped)
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (17404,17413,-307814,-373556,-735490002,-735490003,-735490004,-735490005);
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (1740400,1740500);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17413,0,0,1,54,0,100,512,0,0,0,0,0,'',45,1,1,0,0,0,0,10,735490002,17417,0,0,0,0,0,'Sedai Quest Credit Marker - On Just Summoned - Set Data on Mag har Escort'),
(17413,0,1,2,61,0,100,512,0,0,0,0,0,'',45,1,1,0,0,0,0,10,735490003,17417,0,0,0,0,0,'Sedai Quest Credit Marker - On Just Summoned - Set Data on Mag har Escort'),
(17413,0,2,0,61,0,100,512,0,0,0,0,0,'',45,1,1,0,0,0,0,10,307814,17404,0,0,0,0,0,'Sedai Quest Credit Marker - On Just Summoned - Set Data on Vindicator Sedai'),
(1740400,9,0,0,0,0,100,0,2000,2000,0,0,0,'',45,1,1,0,0,0,0,10,735490004,17418,0,0,0,0,0,'Vindicator Sedai - Script - Set Data'),
(1740400,9,1,0,0,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,10,735490005,17418,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740400,9,2,0,0,0,100,0,7000,7000,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740400,9,3,0,0,0,100,0,15000,15000,0,0,0,'',1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740400,9,4,0,0,0,100,0,5000,5000,0,0,0,'',1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740400,9,5,0,0,0,100,0,18000,18000,0,0,0,'',1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740400,9,6,0,0,0,100,0,2000,2000,0,0,0,'',45,1,1,0,0,0,0,10,373556,17405,0,0,0,0,0,'Vindicator Sedai - Script - Say'),
(1740500,9,0,0,0,0,100,0,0,0,0,0,0,'',11,30462,2,0,0,0,0,19,17404,0,0,0,0,0,0,'Krun Spinebreaker - Script - Cast Execute Sedai'),
(1740500,9,1,0,0,0,100,0,0,0,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - Script - Say'),
(1740500,9,2,0,0,0,100,0,7000,7000,0,0,0,'',41,0,0,0,0,0,0,10,735490002,17417,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn Mag har Escort'),
(1740500,9,3,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,10,735490003,17417,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn Mag har Escort'),
(1740500,9,4,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,10,307814,17404,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn Vindicator Sedai'),
(1740500,9,5,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,10,735490004,17418,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn Laughing Skull Ambusher'),
(1740500,9,6,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,10,735490005,17418,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn'),
(1740500,9,7,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - Script - Despawn'),
(-373556,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Respawn - Set Immune'),
(-373556,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Respawn - Set Invisible'),
(-373556,0,1,2,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Data Set - Set Immune'),
(-373556,0,2,3,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Data Set - Set visible'),
(-373556,0,3,0,61,0,100,512,0,0,0,0,0,'',53,1,17405,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Respawn - Start WP'),
(-373556,0,4,0,40,0,100,512,3,17405,0,0,0,'',80,1740500,2,0,0,0,0,1,0,0,0,0,0,0,0,'Krun Spinebreaker - On Reached WP3 - Run Script'),
(-735490005,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (2) - On Respawn - Set Immune'),
(-735490005,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (2) - On Respawn - Set Invisible'),
(-735490005,0,2,3,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (2) - On Data Set - Set Immune'),
(-735490005,0,3,0,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (2) - On Data Set - Set visible'),
(-735490005,0,5,0,38,0,100,0,3,3,0,0,0,'',49,0,0,0,0,0,0,19,17417,0,0,0,0,0,0,'Laughing Skull Ambusher (2) - On Data Set - Start Attack'),
(-735490004,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (1) - On Respawn - Set Immune'),
(-735490004,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (1) - On Respawn - Set Invisible'),
(-735490004,0,2,3,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (1) - On Data Set - Set Immune'),
(-735490004,0,3,0,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Laughing Skull Ambusher (1) - On Data Set - Set visible'),
(-735490004,0,5,0,38,0,100,0,3,3,0,0,0,'',49,0,0,0,0,0,0,19,17417,0,0,0,0,0,0,'Laughing Skull Ambusher (1) - On Data Set - Start Attack'),
(-307814,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Respawn - Set Immune'),
(-307814,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Respawn - Set Invisible'),
(-307814,0,1,2,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Data Set - Set Immune'),
(-307814,0,2,3,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Data Set - Set visible'),
(-307814,0,3,0,61,0,100,512,0,0,0,0,0,'',53,0,17404,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Respawn - Start WP'),
(-307814,0,4,0,38,0,100,512,2,2,0,0,0,'',80,1740400,2,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Data Set - Run Script'),
(-307814,0,5,0,40,0,100,512,3,17404,0,0,0,'',54,21000,2,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Reached WP3 - Pause WP'),
(-307814,0,6,0,40,0,100,512,5,17404,0,0,0,'',54,18000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Vindicator Sedai - On Reached WP5 - Pause WP'),
(-735490003,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Respawn - Set Immune'),
(-735490003,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Respawn - Set Invisible'),
(-735490003,0,1,2,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Data Set - Set Immune'),
(-735490003,0,2,3,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Data Set - Set visible'),
(-735490003,0,3,0,61,0,100,512,0,0,0,0,0,'',53,0,1741701,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Respawn - Start WP'),
(-735490003,0,4,5,40,0,100,512,3,1741701,0,0,0,'',54,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Reached WP9 - Pause WP'),
(-735490003,0,5,0,61,0,100,512,0,0,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (2) - On Reached WP9 - Say'),
(-735490003,0,6,7,40,0,100,512,10,1741701,0,0,0,'',45,3,3,0,0,0,0,10,735490005,17418,0,0,0,0,0,'Mag har Escort (2) - On Reached WP12 - Start Attack'),
(-735490003,0,7,0,61,0,100,512,0,0,0,0,0,'',49,0,0,0,0,0,0,10,735490005,17418,0,0,0,0,0,'Mag har Escort (2) - On Reached WP12 - Start Attack'),
(-735490003,0,8,0,0,0,100,513,3000,3000,0,0,0,'',45,4,4,0,0,0,0,10,735490005,17418,0,0,0,0,0,'Mag har Escort (2) - IC - Set Data'),
(-735490002,0,0,1,11,0,100,512,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Respawn - Set Immune'),
(-735490002,0,1,0,61,0,100,512,0,0,0,0,0,'',47,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Respawn - Set Invisible'),
(-735490002,0,1,2,38,0,100,513,1,1,0,0,0,'',19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Data Set - Set Immune'),
(-735490002,0,2,3,61,0,100,512,0,0,0,0,0,'',47,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Data Set - Set visible'),
(-735490002,0,3,0,61,0,100,512,0,0,0,0,0,'',53,0,1741700,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Respawn - Start WP'),
(-735490002,0,4,5,40,0,100,512,2,1741700,0,0,0,'',54,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Mag har Escort (1) - On Reached WP3 - Pause WP'),
(-735490002,0,5,6,61,0,100,512,0,0,0,0,0,'',11,30460,2,0,0,0,0,19,17404,0,0,0,0,0,0,'Mag har Escort (1) - On Reached WP3 - Cast Kick'),
(-735490002,0,6,0,61,0,100,512,0,0,0,0,0,'',45,2,2,0,0,0,0,19,17404,0,0,0,0,0,0,'Mag har Escort (1) - On Reached WP3 - Set Data on Sedai'),
(-735490002,0,7,8,40,0,100,512,5,1741700,0,0,0,'',45,3,3,0,0,0,0,10,735490004,17418,0,0,0,0,0,'Mag har Escort (1) - On Reached WP6 - Start Attack'),
(-735490002,0,8,0,61,0,100,512,0,0,0,0,0,'',49,0,0,0,0,0,0,10,735490004,17418,0,0,0,0,0,'Mag har Escort (2) - On Reached WP12 - Start Attack'),
(-735490002,0,9,0,0,0,100,513,3000,3000,0,0,0,'',45,4,4,0,0,0,0,10,735490004,17418,0,0,0,0,0,'Mag har Escort (2) - IC - Set Data');
