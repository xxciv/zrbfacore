-- World fixes: Zeth'Gor towers only burn after a Smoke Beacon (2026-11-24)
-- Four: the four Zeth'Gor towers already burn and explode before Zeth'Gor Must Burn! (10895) is done, and an
-- Enraged Crusher 18062 (DB GUID 74299) stands on top of the south tower.
-- Found, against TDB 8.3.7:
--   * Zeth'Gor (area 3582) has 52 always-on fire objects TDB doesn't have: Big Barracks Flame 176746 x41,
--     Black Smoke Emitter 1604 x2, Hellfire Fire 183816 x7 on the towers (the 3 TDB has at the stable stay),
--     and two Smoke Beacons 184661 already standing at the south tower. A beacon belongs only to the player who
--     plants one (spell 36374 'Summon Smoke Beacon'), and the tower fire comes from spell 34386 'Create Hellfire Fire'
--     that the tower marker casts when the beacon hits it.
--   * The Smoke Beacon needs Tower Spell Focus 1447 within 5 yards. TDB has Tower Spell Focus 185293 at each tower
--     foot; ours has 'TEMP Zeth'Gor Tower' 300120 there instead, with spawntimesecs -300, so it never spawns.
--   * GUID 74299 is TDB's Tower South marker 21182 (same spot and facing), turned into a Crusher. Ours had put a
--     second Tower South marker at GUID 123040 instead.
--   * The tower markers' 'call gryphon riders' set-data rows point at TDB GUIDs 78738/74239 of the bomber
--     controllers 21173; ours has those controllers at 124679/123039 (74239 is Spirit Sage Zran here), so the
--     gryphon riders never came.
--   * The Horde building markers 20813-20816 (Zeth'Gor Must Burn! 10792, Throw Torch) had 1 copy each, low down,
--     and died on hit; TDB has 3-4 copies each up on the roofs and only gives credit.
-- Changed: the 52 objects and the 4 TEMP towers removed; TDB's 4 Tower Spell Focus objects added (TDB GUIDs
-- 99979-99982); GUID 74299 is the Tower South marker again at TDB's spot and 123040 is removed (one marker stays);
-- the North/Forge/Foothill markers moved to TDB's spots; the building markers moved to TDB's spots with 11 more
-- copies (GUIDs 735401749-735401759, TDB 73504-73517); SmartAI of all Zeth'Gor quest markers, the bomber
-- controller and the four gryphon riders copied from TDB, with the set-data targets pointed at our controller
-- GUIDs; marker templates get TDB's unit_flags (not selectable), controller flags_extra 130, rider 22406 faction 55.
-- Not changed: the 152 Big Barracks Flames and 34 smoke emitters elsewhere in Outland (outside this report).
-- Safe to run twice.

-- 1. Always-on fire, smoke, placed beacons and the TEMP towers out
DELETE FROM `gameobject` WHERE `guid` IN (19917,19918,19919,19920,19921,19922,19923,19924,19925,19926,19927,19928,19929,19930,19931,19932,19933,19934,19935,19936,19937,19938,19939,19940,19941,19942,19943,19944,19945,19946,19947,19948,19949,19950,19952,19953,19954,19955,19956,19957,19958,19959,19960,68037,68038,68039,68040,70999,71000,71001,184234,184235,49578,49579,49580,49581);
DELETE FROM `gameobject_addon` WHERE `guid` IN (19917,19918,19919,19920,19921,19922,19923,19924,19925,19926,19927,19928,19929,19930,19931,19932,19933,19934,19935,19936,19937,19938,19939,19940,19941,19942,19943,19944,19945,19946,19947,19948,19949,19950,19952,19953,19954,19955,19956,19957,19958,19959,19960,68037,68038,68039,68040,70999,71000,71001,184234,184235,49578,49579,49580,49581);

-- 2. TDB's Tower Spell Focus at each tower foot
DELETE FROM `gameobject` WHERE `guid` BETWEEN 99979 AND 99982;
DELETE FROM `gameobject_addon` WHERE `guid` BETWEEN 99979 AND 99982;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`isActive`,`ScriptName`,`VerifiedBuild`) VALUES
(99979,185293,530,3483,3582,'0',0,0,0,-1,-897.39,1920.97,66.93,0,0,0,0,1,180,0,1,0,'',0),
(99980,185293,530,3483,3582,'0',0,0,0,-1,-977.39,1877.65,94.81,0,0,0,0,1,180,0,1,0,'',0),
(99981,185293,530,3483,3582,'0',0,0,0,-1,-1153.73,2107.55,68.1,0,0,0,0,1,180,0,1,0,'',0),
(99982,185293,530,3483,3582,'0',0,0,0,-1,-822.39,2031.01,39.25,0,0,0,0,1,180,0,1,0,'',0);

-- 3. Tower markers: 74299 is Tower South again (TDB), the duplicate 123040 goes; the other three at TDB's spots
DELETE FROM `creature` WHERE `guid` IN (74299,123040);
DELETE FROM `creature_addon` WHERE `guid` IN (74299,123040);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(74299,21182,530,3483,3582,'0',0,0,0,-1,0,0,-1157.05,2104.98,82.9548,1.18682,300,0,0,1,0,0,0,0,0,0,0,'',0);
UPDATE `creature` SET `position_x`=-825.249,`position_y`=2026.35,`position_z`=46.5842,`orientation`=1.18682,`spawntimesecs`=300 WHERE `guid`=123042 AND `id`=22401; -- TDB 78735
UPDATE `creature` SET `position_x`=-894.47,`position_y`=1919.87,`position_z`=93.7102,`orientation`=1.18682,`spawntimesecs`=300 WHERE `guid`=123043 AND `id`=22402; -- TDB 78736
UPDATE `creature` SET `position_x`=-979.369,`position_y`=1876.67,`position_z`=121.587,`orientation`=1.18682,`spawntimesecs`=300 WHERE `guid`=123044 AND `id`=22403; -- TDB 78737

-- 4. Horde building markers (10792): TDB's roof spots, 3-4 per building
UPDATE `creature` SET `position_x`=-1176.71,`position_y`=1972.19,`position_z`=107.183,`orientation`=5.18363,`spawntimesecs`=300 WHERE `guid`=123024; -- TDB 73503
UPDATE `creature` SET `position_x`=-1067.28,`position_y`=1998.95,`position_z`=76.2863,`orientation`=5.86431,`spawntimesecs`=300 WHERE `guid`=123028; -- TDB 73507
UPDATE `creature` SET `position_x`=-934.393,`position_y`=1934.01,`position_z`=82.0316,`orientation`=3.35103,`spawntimesecs`=300 WHERE `guid`=123032; -- TDB 73511
UPDATE `creature` SET `position_x`=-1156.84,`position_y`=2060.87,`position_z`=79.1764,`orientation`=3.83972,`spawntimesecs`=300 WHERE `guid`=123036; -- TDB 73515
DELETE FROM `creature` WHERE `guid` BETWEEN 735401749 AND 735401759;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735401749 AND 735401759;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401749,20813,530,3483,3582,'0',0,0,0,-1,0,0,-1137.1,1951.25,94.1159,2.32129,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401750,20813,530,3483,3582,'0',0,0,0,-1,0,0,-1152.89,1961.49,92.9795,0.994838,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401751,20813,530,3483,3582,'0',0,0,0,-1,0,0,-1120.22,1929.89,92.3609,0.890118,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401752,20814,530,3483,3582,'0',0,0,0,-1,0,0,-1052.26,1996.34,79.3775,0.628319,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401753,20814,530,3483,3582,'0',0,0,0,-1,0,0,-1052.19,2012.1,80.9462,5.95157,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401754,20814,530,3483,3582,'0',0,0,0,-1,0,0,-1043.44,2002.14,76.0305,2.00713,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401755,20815,530,3483,3582,'0',0,0,0,-1,0,0,-935.543,1921.16,82.4132,2.67035,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401756,20815,530,3483,3582,'0',0,0,0,-1,0,0,-944.015,1928.16,82.1055,5.98648,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401757,20815,530,3483,3582,'0',0,0,0,-1,0,0,-927.878,1927.45,81.0489,5.25344,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401758,20816,530,3483,3582,'0',0,0,0,-1,0,0,-1145.41,2064.83,80.7826,5.044,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401759,20816,530,3483,3582,'0',0,0,0,-1,0,0,-1152.72,2073.5,80.6229,2.00713,300,0,0,1,0,0,0,0,0,0,0,'',0);

-- 5. Templates as TDB
UPDATE `creature_template` SET `unit_flags`=33554432 WHERE `entry` IN (20813,20814,20815,20816,21173,21182,22401,22402,22403);
UPDATE `creature_template` SET `flags_extra`=130 WHERE `entry`=21173;
UPDATE `creature_template` SET `faction`=55 WHERE `entry`=22406;

-- 6. SmartAI from TDB (set-data targets: TDB 78738 -> our 124679, TDB 74239 -> our 123039)
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (20813,20814,20815,20816,21170,21173,21182,22401,22402,22403,22404,22405,22406) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20813,0,0,0,8,0,100,512,35724,0,0,0,0,'',33,20813,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, Barracks - On Spellhit ''Throw Torch'' - Quest Credit ''Zeth''Gor Must Burn!'' (No Repeat)'),
(20814,0,0,0,8,0,100,512,35724,0,0,0,0,'',33,20814,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, Stable - On Spellhit ''Throw Torch'' - Quest Credit ''Zeth''Gor Must Burn!'' (No Repeat)'),
(20815,0,0,0,8,0,100,512,35724,0,0,0,0,'',33,20815,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, East Hovel - On Spellhit ''Throw Torch'' - Quest Credit ''Zeth''Gor Must Burn!'' (No Repeat)'),
(20816,0,0,0,8,0,100,512,35724,0,0,0,0,'',33,20816,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, West Hovel - On Spellhit ''Throw Torch'' - Quest Credit ''Zeth''Gor Must Burn!'' (No Repeat)'),
(21170,0,0,0,25,0,100,0,0,0,0,0,0,'',11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Respawn - Cast ''They Must Burn Bomb Aura (self)'''),
(21170,0,1,0,38,0,100,512,0,1,0,0,0,'',53,1,2117000,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Data Set 0 1 - Start Waypoint'),
(21170,0,2,0,38,0,100,512,0,2,0,0,0,'',53,1,2117001,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Data Set 0 2 - Start Waypoint'),
(21170,0,3,0,38,0,100,512,0,3,0,0,0,'',53,1,2117002,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Data Set 0 3 - Start Waypoint'),
(21170,0,4,0,38,0,100,512,0,4,0,0,0,'',53,1,2117003,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Data Set 0 4 - Start Waypoint'),
(21170,0,5,0,40,0,100,512,10,2117000,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Waypoint 10 Reached - Despawn Instant'),
(21170,0,6,0,40,0,100,512,10,2117001,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Waypoint 10 Reached - Despawn Instant'),
(21170,0,7,0,40,0,100,512,11,2117002,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Waypoint 11 Reached - Despawn Instant'),
(21170,0,8,0,40,0,100,512,11,2117003,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, South - On Waypoint 11 Reached - Despawn Instant'),
(21173,0,0,0,38,0,100,512,0,1,0,0,0,'',80,2117300,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn - On Data Set 0 1 - Run Script'),
(21173,0,1,0,38,0,100,512,0,2,0,0,0,'',80,2117301,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn - On Data Set 0 2 - Run Script'),
(21173,0,2,0,38,0,100,512,0,3,0,0,0,'',80,2117302,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn - On Data Set 0 3 - Run Script'),
(21173,0,3,0,38,0,100,512,0,4,0,0,0,'',80,2117303,0,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn - On Data Set 0 4 - Run Script'),
(21182,0,0,0,11,0,100,512,0,0,0,0,0,'',53,0,21182,1,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Respawn - Start Waypoint'),
(21182,0,1,2,8,0,100,512,36374,0,0,0,0,'',45,0,1,0,0,0,0,10,124679,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spellhit ''Summon Smoke Beacon'' - Set Data 0 1'),
(21182,0,2,3,61,0,100,512,0,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spellhit ''Summon Smoke Beacon'' - Cast ''Create Hellfire Fire'''),
(21182,0,3,0,61,0,100,512,0,0,0,0,0,'',33,21182,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower South - On Spellhit ''Summon Smoke Beacon'' - Quest Credit ''Zeth''Gor Must Burn!'''),
(22401,0,0,0,11,0,100,512,0,0,0,0,0,'',53,0,22401,1,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Respawn - Start Waypoint (Phase 1) (No Repeat)'),
(22401,0,1,2,8,0,100,512,36374,0,0,0,0,'',45,0,2,0,0,0,0,10,123039,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Spellhit ''Summon Smoke Beacon'' - Set Data 0 2'),
(22401,0,2,3,61,0,100,512,0,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Spellhit ''Summon Smoke Beacon'' - Cast ''Create Hellfire Fire'''),
(22401,0,3,0,61,0,100,512,0,0,0,0,0,'',33,22401,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower North - On Spellhit ''Summon Smoke Beacon'' - Quest Credit ''Zeth''Gor Must Burn!'''),
(22402,0,0,0,11,0,100,512,0,0,0,0,0,'',53,0,22402,1,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Respawn - Start Waypoint'),
(22402,0,1,2,8,0,100,512,36374,0,0,0,0,'',45,0,3,0,0,0,0,10,123039,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Spellhit ''Summon Smoke Beacon'' - Set Data 0 3'),
(22402,0,2,3,61,0,100,512,0,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Spellhit ''Summon Smoke Beacon'' - Cast ''Create Hellfire Fire'''),
(22402,0,3,0,61,0,100,512,0,0,0,0,0,'',33,22402,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Forge - On Spellhit ''Summon Smoke Beacon'' - Quest Credit ''Zeth''Gor Must Burn!'''),
(22403,0,0,0,11,0,100,512,0,0,0,0,0,'',53,0,22403,1,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Respawn - Start Waypoint'),
(22403,0,1,2,8,0,100,512,36374,0,0,0,0,'',45,0,4,0,0,0,0,10,123039,21173,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Spellhit ''Summon Smoke Beacon'' - Set Data 0 4'),
(22403,0,2,3,61,0,100,512,0,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Spellhit ''Summon Smoke Beacon'' - Cast ''Create Hellfire Fire'''),
(22403,0,3,0,61,0,100,512,0,0,0,0,0,'',33,22403,0,0,0,0,0,7,0,0,0,0,0,0,0,'Zeth''Gor Quest Credit Marker, They Must Burn, Tower Foothill - On Spellhit ''Summon Smoke Beacon'' - Quest Credit ''Zeth''Gor Must Burn!'''),
(22404,0,0,0,11,0,100,0,0,0,0,0,0,'',11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Respawn - Cast ''They Must Burn Bomb Aura (self)'''),
(22404,0,1,0,38,0,100,512,0,1,0,0,0,'',53,1,2240400,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Data Set 0 1 - Start Waypoint'),
(22404,0,2,0,38,0,100,512,0,2,0,0,0,'',53,1,2240401,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Data Set 0 2 - Start Waypoint'),
(22404,0,3,0,38,0,100,512,0,3,0,0,0,'',53,1,2240402,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Data Set 0 3 - Start Waypoint'),
(22404,0,4,0,38,0,100,512,0,4,0,0,0,'',53,1,2240403,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Data Set 0 4 - Start Waypoint'),
(22404,0,5,0,40,0,100,512,12,2240400,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Waypoint 12 Reached - Despawn Instant'),
(22404,0,6,0,40,0,100,512,11,2240401,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Waypoint 11 Reached - Despawn Instant'),
(22404,0,7,0,40,0,100,512,12,2240402,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Waypoint 12 Reached - Despawn Instant'),
(22404,0,8,0,40,0,100,512,12,2240403,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, North - On Waypoint 12 Reached - Despawn Instant'),
(22405,0,0,0,11,0,100,0,0,0,0,0,0,'',11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Respawn - Cast ''They Must Burn Bomb Aura (self)'''),
(22405,0,1,0,38,0,100,512,0,1,0,0,0,'',53,1,2240500,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Data Set 0 1 - Start Waypoint'),
(22405,0,2,0,38,0,100,512,0,2,0,0,0,'',53,1,2240501,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Data Set 0 2 - Start Waypoint'),
(22405,0,3,0,38,0,100,512,0,3,0,0,0,'',53,1,2240502,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Data Set 0 3 - Start Waypoint'),
(22405,0,4,0,38,0,100,512,0,4,0,0,0,'',53,1,2240503,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Data Set 0 4 - Start Waypoint'),
(22405,0,5,0,40,0,100,512,13,2240500,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Waypoint 13 Reached - Despawn Instant'),
(22405,0,6,0,40,0,100,512,13,2240501,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Waypoint 13 Reached - Despawn Instant'),
(22405,0,7,0,40,0,100,512,12,2240502,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Waypoint 12 Reached - Despawn Instant'),
(22405,0,8,0,40,0,100,512,14,2240503,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Forge - On Waypoint 14 Reached - Despawn Instant'),
(22406,0,0,0,11,0,100,0,0,0,0,0,0,'',11,36350,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Respawn - Cast ''They Must Burn Bomb Aura (self)'''),
(22406,0,1,0,38,0,100,512,0,1,0,0,0,'',53,1,2240600,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Data Set 0 1 - Start Waypoint'),
(22406,0,2,0,38,0,100,512,0,2,0,0,0,'',53,1,2240601,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Data Set 0 2 - Start Waypoint'),
(22406,0,3,0,38,0,100,512,0,3,0,0,0,'',53,1,2240602,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Data Set 0 3 - Start Waypoint'),
(22406,0,4,0,40,0,100,512,15,2240600,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Waypoint 15 Reached - Despawn Instant'),
(22406,0,5,0,40,0,100,512,15,2240601,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Waypoint 15 Reached - Despawn Instant'),
(22406,0,6,0,40,0,100,512,15,2240602,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Gryphon Brigadier, Foothill - On Waypoint 15 Reached - Despawn Instant');

-- Summary: expect 0 fires, 4 foci, 1 south marker, 15 building markers, 58 scripts
SELECT (SELECT COUNT(*) FROM `gameobject` WHERE `guid` IN (19917,19918,19919,19920,19921,19922,19923,19924,19925,19926,19927,19928,19929,19930,19931,19932,19933,19934,19935,19936,19937,19938,19939,19940,19941,19942,19943,19944,19945,19946,19947,19948,19949,19950,19952,19953,19954,19955,19956,19957,19958,19959,19960,68037,68038,68039,68040,70999,71000,71001,184234,184235,49578,49579,49580,49581)) AS `fires_left`,
       (SELECT COUNT(*) FROM `gameobject` WHERE `id`=185293 AND `map`=530) AS `tower_foci`,
       (SELECT COUNT(*) FROM `creature` WHERE `id`=21182) AS `south_markers`,
       (SELECT COUNT(*) FROM `creature` WHERE `id` IN (20813,20814,20815,20816)) AS `building_markers`,
       (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` IN (20813,20814,20815,20816,21170,21173,21182,22401,22402,22403,22404,22405,22406) AND `source_type`=0) AS `scripts`;
