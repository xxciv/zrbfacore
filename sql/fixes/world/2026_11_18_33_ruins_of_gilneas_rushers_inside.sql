-- World fixes: Ruins of Gilneas, worgen back inside the Forward Command (2026-11-18)
-- Four (after 2026_11_18_32): "unfortunately, i think that got rid of all the worgen". In 8.3.7 all 46 Worgen Rushers
-- stand in one pack northwest of the camp (around -1290, 1775) and none inside the Forward Command, so the camp went quiet.
-- Our own tuning (not 8.3.7): 11 Rushers back on the dump spots that stood next to a defender (each within 5 yards of
-- its own Forsaken Vanguard, Catapult or Sharpshooter, one Rusher per defender), facing it and standing still. The dump's
-- other Rushers were piled on the same few defenders and stay removed.
-- The fight starter (2026_11_17_46) now only looks 5 yards out, so each Rusher fights its own defender instead of
-- several running to the same one, and it also takes on Sharpshooters 45376 (id 12).
-- Guids 735401147-735401157. Safe to run twice.

DELETE FROM `creature` WHERE `guid` BETWEEN 735401147 AND 735401157;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401147,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1039.59,1555.24,46.0831,3.21753,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 1.8 yards from Forsaken Catapult 306800
(735401148,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1037.33,1557.71,45.9076,1.52196,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 2.7 yards from Forsaken Sharpshooter 307122
(735401149,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1034.34,1557.46,46.1296,1.84016,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.4 yards from Forsaken Sharpshooter 307268
(735401150,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1054.04,1573.74,39.0112,4.02289,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.4 yards from Forsaken Sharpshooter 307301
(735401151,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1000.37,1585.63,34.948,0.08938,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.5 yards from Forsaken Vanguard 307296
(735401152,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1096.52,1606.34,36.2458,3.37016,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.5 yards from Forsaken Sharpshooter 307385
(735401153,45375,0,4706,5440,'0',0,274,0,-1,0,0,-1100.46,1620.03,33.2027,5.07212,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.7 yards from Forsaken Vanguard 307323
(735401154,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1046.04,1670.22,52.8669,3.26459,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.7 yards from Forsaken Sharpshooter 307384
(735401155,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1054.46,1566.87,41.0047,1.29747,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 3.7 yards from Forsaken Sharpshooter 307300
(735401156,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1088.42,1595.58,37.1664,5.17403,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher 4.5 yards from Forsaken Catapult 306944
(735401157,45375,0,4706,5434,'0',0,274,0,-1,0,0,-1051.0,1541.9,47.3171,4.02650,300,0,0,1,0,0,0,0,0,0,0,'',0); -- Worgen Rusher 4.5 yards from Forsaken Catapult 306881

UPDATE `smart_scripts` SET `target_param2`=5,`comment`='Worgen Rusher - OOC - Attack closest Forsaken Vanguard within 5 yards' WHERE `entryorguid`=45375 AND `source_type`=0 AND `id`=10;
UPDATE `smart_scripts` SET `target_param2`=5,`comment`='Worgen Rusher - OOC - Attack closest Forsaken Catapult within 5 yards' WHERE `entryorguid`=45375 AND `source_type`=0 AND `id`=11;
DELETE FROM `smart_scripts` WHERE `entryorguid`=45375 AND `source_type`=0 AND `id`=12;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45375,0,12,0,1,0,100,0,2000,4000,2000,4000,0,49,0,0,0,0,0,0,19,45376,5,0,0,0,0,0,'Worgen Rusher - OOC - Attack closest Forsaken Sharpshooter within 5 yards');
