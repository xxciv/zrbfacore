-- World fixes: Ratchet / Booty Bay, The Maiden's Fancy leftovers (Four, 2026-11-20)
-- Four (screenshots at the Ratchet dock): "First Mate Masker is underwater, and there's a bunch of leftover furniture.
-- I assume they should be on the transport between here and Booty Bay."
-- The dump has sniff snapshots of the docked ship in world coordinates: First Mate Masker 25093 at Ratchet (265581, in
-- the water) and Booty Bay (369219), and the ship's 9 Wooden Chairs (164759-164767) floating off the Ratchet dock
-- (175554-175562). TDB 8.3.7 has none of these; it has Masker and the chairs only on the ship (map 593).
-- None of them has a quest role; Masker keeps his gossip on the ship copy (735200074, from 2026_11_12_33).
-- Changed:
--   The two static Masker copies and the 9 floating chairs removed.
--   The ship gets TDB 8.3.7's 9 deck chairs (guids 735400105-735400113) and the two crewmen our TDB 7.3.5 crew list lacked:
--   Bosun Thunderhorn 25098 (735401341) and Crewman Gearspinner 25096 (735401342). Phase 169 -> 0, as in 2026_11_12_33.
-- Safe to run twice.
DELETE FROM `creature_addon` WHERE `guid` IN (265581,369219);
DELETE FROM `creature` WHERE `guid` IN (265581,369219);
DELETE FROM `gameobject_addon` WHERE `guid` BETWEEN 175554 AND 175562;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 175554 AND 175562;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 735400105 AND 735400113;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`isActive`,`ScriptName`,`VerifiedBuild`) VALUES
(735400105,164762,593,0,0,'0',0,0,0,-1,12.8419,-1.87944,6.09668,3.2953,0,0,0.329691,0.944089,120,255,1,0,'',26365),
(735400106,164765,593,0,0,'0',0,0,0,-1,5.5116,10.927,6.09921,0.232245,0,0,-0.930417,0.366502,120,255,1,0,'',26365),
(735400107,164767,593,0,0,'0',0,0,0,-1,39.2127,-2.40047,6.09814,5.30242,0,0,0.973379,0.229201,120,255,1,0,'',26365),
(735400108,164761,593,0,0,'0',0,0,0,-1,14.2225,-0.64533,6.09668,0.232246,0,0,-0.930417,0.366502,120,255,1,0,'',26365),
(735400109,164763,593,0,0,'0',0,0,0,-1,11.2106,2.85881,6.09682,1.11363,0,0,-0.685183,0.728371,120,255,1,0,'',26365),
(735400110,164766,593,0,0,'0',0,0,0,-1,4.39428,9.88994,6.09921,3.2953,0,0,0.329691,0.944089,120,255,1,0,'',26365),
(735400111,164764,593,0,0,'0',0,0,0,-1,11.2888,1.07911,6.09682,4.17669,0,0,0.70091,0.71325,120,255,1,0,'',26365),
(735400112,164760,593,0,0,'0',0,0,0,-1,18.3479,0.59001,6.06388,0.232246,0,0,-0.930417,0.366502,120,255,1,0,'',26365),
(735400113,164759,593,0,0,'0',0,0,0,-1,17.0133,-0.629518,6.06388,3.29529,0,0,0.329691,0.944089,120,255,1,0,'',26365);
DELETE FROM `creature` WHERE `guid` IN (735401341,735401342);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401341,25098,593,0,0,'0',0,0,0,-1,0,0,12.0256,10.7424,6.46948,3.20956,120,0,0,1,0,0,0,0,0,0,0,'',26365), -- Bosun Thunderhorn
(735401342,25096,593,0,0,'0',0,0,0,-1,0,0,18.0779,0.47081,12.1682,3.16242,120,0,0,1,0,0,0,0,0,0,0,'',26365); -- Crewman Gearspinner
