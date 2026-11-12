-- Ship to Vashj'ir (Horde), transport 203466 on map 738: it sails with nobody on deck (TDB 7.3.5 has no crew for it).
-- Its crew is the 15 NPCs removed from the Orgrimmar docks water in 2026_11_12_34: they were sniffed while the ship
-- sat at its Orgrimmar stop (TaxiPath 2204 node 12: 1440.22 -5035.89 7.0). Converted to ship-relative positions
-- with the orientation the core gives the docked ship (Catmull-Rom tangent between nodes 11 and 13, + pi = 0.1914).
-- Guids 735200301-735200310. The two invisible event bunnies 43091 are left out.
-- 34 also removed 5 Hellscream's Vanguard that stand on the pier beside the ship (y about -5015, next to the
-- Dranosh'ar Fishermen), not in the water: they are restored here at their dump spots, standing still.
DELETE FROM `creature` WHERE `guid` BETWEEN 735200301 AND 735200320;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735200301 AND 735200320;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735200301,43090,738,0,0,'0',0,0,0,-1,32575,0,-10.6155,-5.9493,5.3930,0.6807,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Hellscream's Vanguard (was guid 205147)
(735200302,43090,738,0,0,'0',0,0,0,-1,32575,0,7.2316,-6.3109,5.1858,1.6232,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Hellscream's Vanguard (was guid 205149)
(735200303,43090,738,0,0,'0',0,0,0,-1,32575,0,-0.9321,-6.4403,5.2143,1.5359,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Hellscream's Vanguard (was guid 205150)
(735200304,43090,738,0,0,'0',0,0,0,-1,32575,0,-0.4705,6.8241,5.2001,5.3931,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Hellscream's Vanguard (was guid 205151)
(735200305,43090,738,0,0,'0',0,0,0,-1,32575,0,-9.4966,6.6071,5.3973,4.5728,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Hellscream's Vanguard (was guid 205152)
(735200306,43100,738,0,0,'0',0,0,0,-1,32574,0,9.8058,4.9246,5.1607,3.2289,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Legionnaire Nazgrim (was guid 205148)
(735200307,43022,738,0,0,'0',0,0,0,-1,31567,0,24.7914,-3.5814,5.2530,3.1228,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Mack Fearsen (was guid 205142)
(735200308,43051,738,0,0,'0',0,0,0,-1,22403,0,-3.4019,-6.9905,5.4231,5.0601,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Adarrah (was guid 205143)
(735200309,43023,738,0,0,'0',0,0,0,-1,21702,0,-4.8278,0.2122,5.7100,6.2644,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Budd (was guid 205144)
(735200310,43030,738,0,0,'0',0,0,0,-1,21706,0,46.0304,-0.8415,12.0460,3.0181,300,0,0,1,0,0,0,0,0,0,0,'',0); -- Captain Samir (was guid 205139)
DELETE FROM `creature` WHERE `guid` IN (205119,205120,205121,205122,205123);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(205119,43090,1,14,374,'0',0,0,0,-1,32575,0,1430.51,-5014.8,12.3135,3.63029,300,0,0,0,0,0,0,0,0,0,0,'',0),
(205120,43090,1,14,374,'0',0,0,0,-1,32575,0,1452.51,-5016.07,11.9138,2.70526,300,0,0,0,0,0,0,0,0,0,0,'',0),
(205121,43090,1,14,374,'0',0,0,0,-1,32575,0,1450.29,-5012.34,12.1183,5.25344,300,0,0,0,0,0,0,0,0,0,0,'',0),
(205122,43090,1,14,374,'0',0,0,0,-1,32575,0,1427.04,-5018.73,12.0126,1.6057,300,0,0,0,0,0,0,0,0,0,0,'',0),
(205123,43090,1,14,374,'0',0,0,0,-1,32575,0,1423.52,-5015.49,12.0487,5.46288,300,0,0,0,0,0,0,0,0,0,0,'',0);
