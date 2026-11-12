-- 13 rare beasts that TDB 7.3.5 spawns but we never did: 7 in Silithus, 6 in Tirisfal Glades.
-- Our templates came from an 8.3.7 sniff without faction or level (friendly faction 35, level 1);
-- TDB 7.3.5 (sniffed, build 25549) has them hostile (faction 14) at these levels.
-- Spawns use new guids 735100001-735100013 at the TDB positions and respawn times; SmartAI from TDB for six of them.

UPDATE `creature_template` SET `faction`=14, `minlevel`=5, `maxlevel`=5 WHERE `entry`=50328; -- Fangor
UPDATE `creature_template` SET `faction`=14, `minlevel`=56, `maxlevel`=56 WHERE `entry`=50370; -- Karapax
UPDATE `creature_template` SET `faction`=14, `minlevel`=55, `maxlevel`=55 WHERE `entry`=50737; -- Acroniss
UPDATE `creature_template` SET `faction`=14, `minlevel`=57, `maxlevel`=57 WHERE `entry`=50742; -- Qem
UPDATE `creature_template` SET `faction`=14, `minlevel`=58, `maxlevel`=58 WHERE `entry`=50744; -- Qu'rik
UPDATE `creature_template` SET `faction`=14, `minlevel`=58, `maxlevel`=58 WHERE `entry`=50745; -- Losaj
UPDATE `creature_template` SET `faction`=14, `minlevel`=6, `maxlevel`=6 WHERE `entry`=50763; -- Shadowstalker
UPDATE `creature_template` SET `faction`=14, `minlevel`=7, `maxlevel`=7 WHERE `entry`=50803; -- Bonechewer
UPDATE `creature_template` SET `faction`=14, `minlevel`=55, `maxlevel`=55 WHERE `entry`=50897; -- Ffexk the Dunestalker
UPDATE `creature_template` SET `faction`=14, `minlevel`=9, `maxlevel`=9 WHERE `entry`=50908; -- Nighthowl
UPDATE `creature_template` SET `faction`=14, `minlevel`=7, `maxlevel`=7 WHERE `entry`=50930; -- Hibernus the Sleeper
UPDATE `creature_template` SET `faction`=14, `minlevel`=56, `maxlevel`=56 WHERE `entry`=51004; -- Toxx
UPDATE `creature_template` SET `faction`=14, `minlevel`=8, `maxlevel`=8 WHERE `entry`=51044; -- Plague

DELETE FROM `creature` WHERE `guid` BETWEEN 735100001 AND 735100013;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735100001,50328,0,85,6454,'0',0,0,0,-1,0,0,1681.28,1456.45,136.872,0.09,900,10,0,0,0,1,0,0,0,0,0,'',0), -- Fangor
(735100002,50370,1,1377,1377,'0',0,0,0,-1,0,0,-6268.13,664.432,16.0354,0.714238,120,0,0,0,0,0,0,0,0,0,0,'',0), -- Karapax
(735100003,50737,1,1377,1377,'0',0,0,0,-1,0,0,-6326.19,10.7899,6.59167,5.58496,120,0,0,0,0,0,0,0,0,0,0,'',0), -- Acroniss
(735100004,50742,1,1377,1377,'0',0,0,0,-1,0,0,-6347.13,1198.8,-21.0276,5.52579,120,0,0,0,0,0,0,0,0,0,0,'',0), -- Qem
(735100005,50744,1,1377,1377,'0',0,0,0,-1,0,0,-6591.38,777.278,-53.7069,5.6571,120,0,0,0,0,0,0,0,0,0,0,'',0), -- Qu'rik
(735100006,50745,1,1377,1377,'0',0,0,0,-1,0,0,-7393.88,1262.85,-86.8569,3.92073,120,5,0,0,0,1,0,0,0,0,0,'',0), -- Losaj
(735100007,50763,0,85,85,'0',0,0,0,-1,0,0,2259.75,1317.58,33.858,0.055,900,0,0,0,0,0,0,0,0,0,0,'',0), -- Shadowstalker
(735100008,50803,0,85,85,'0',0,0,0,-1,0,0,2445.5,1629.19,82.413,5.103,900,10,0,0,0,1,0,0,0,0,0,'',0), -- Bonechewer
(735100009,50897,1,1377,1377,'0',0,0,0,-1,0,0,-7325.33,1644.42,-31.5893,3.15038,120,5,0,0,0,1,0,0,0,0,0,'',0), -- Ffexk the Dunestalker
(735100010,50908,0,85,85,'0',0,0,0,-1,0,0,2973.44,1112.69,81.724,5.274,900,0,0,0,0,0,0,0,0,0,0,'',0), -- Nighthowl
(735100011,50930,0,85,85,'0',0,0,0,-1,0,0,1717.27,893.31,59.59,1.05,900,0,0,0,0,0,0,0,0,0,0,'',0), -- Hibernus the Sleeper
(735100012,51004,1,1377,1377,'0',0,0,0,-1,0,0,-6348.62,1252.47,4.53634,3.70725,120,5,0,0,0,1,0,0,0,0,0,'',0), -- Toxx
(735100013,51044,0,85,85,'0',0,0,0,-1,0,0,2835.54,410.229,20.932,1.429,900,0,0,0,0,0,0,0,0,0,0,'',0); -- Plague

DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (50328,50763,50803,50908,50930,51044);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(50328,0,0,0,0,0,100,0,2000,4000,6000,9000,0,'',11,8281,0,0,0,0,0,2,0,0,0,0,0,0,0,'Fangor - In Combat - Cast \'Sonic Burst\''),
(50763,0,1,0,0,0,100,0,1000,5000,15000,17000,0,'',11,744,0,0,0,0,0,2,0,0,0,0,0,0,0,'Shadowstalker - In Combat - Cast \'Poison\''),
(50763,0,0,0,0,0,100,0,2000,4000,7000,9000,0,'',11,745,0,0,0,0,0,2,0,0,0,0,0,0,0,'Shadowstalker - In Combat - Cast \'Web\''),
(50803,0,0,0,0,0,100,0,2000,4000,18000,20000,0,'',11,3427,0,0,0,0,0,2,0,0,0,0,0,0,0,'Bonechewer - In Combat - Cast \'Infected Wound\''),
(50908,0,0,0,0,0,100,0,2000,4000,14000,16000,0,'',11,5781,0,0,0,0,0,2,0,0,0,0,0,0,0,'Nighthowl - In Combat - Cast \'Threatening Growl\''),
(50908,0,1,0,4,0,100,0,0,0,0,0,0,'',11,75002,0,0,0,0,0,2,0,0,0,0,0,0,0,'Nighthowl - In Aggro - Cast \'Leaping Rush\''),
(50930,0,1,0,4,0,100,0,0,0,0,0,0,'',11,87187,0,0,0,0,0,2,0,0,0,0,0,0,0,'Hibernus the Sleeper - In Aggro - Cast \'Feral Charge\''),
(50930,0,0,0,0,0,100,0,2000,4000,5000,8000,0,'',11,5422,0,0,0,0,0,2,0,0,0,0,0,0,0,'Hibernus the Sleeper - In Combat - Cast \'Lacerate\''),
(51044,0,0,0,0,0,100,0,2000,4000,14000,16000,0,'',11,3149,0,0,0,0,0,1,0,0,0,0,0,0,0,'Plague - In Combat - Cast \'Furious Howl\''),
(51044,0,1,0,0,0,100,0,3000,5000,15000,18000,0,'',11,13443,0,0,0,0,0,2,0,0,0,0,0,0,0,'Plague - In Combat - Cast \'Rend\'');
