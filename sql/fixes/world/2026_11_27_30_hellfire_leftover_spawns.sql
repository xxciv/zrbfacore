-- World fixes: Hellfire Peninsula leftover spawns and the Expedition Point miners (2026-11-27)
-- Four, walking Hellfire Peninsula:
--   * gryphons in the air around Zeth'Gor are freaking out (flying back and forth on the spot);
--   * 17 Cursed Scarabs around a cauldron at Zeth'Gor, with a 'Cursed Scarab Summoner';
--   * two stationary flying gryphons almost on top of each other at -738.6, 1926.9;
--   * two guards by Forward Commander Kingston (Expedition Point) mine with a sword and shield, and the female
--     dwarf should stand at -677.083, 1865.630, 66.548, facing 0.419;
--   * 'Darkness Released' upstairs in the Honor Hold inn aggro on you.
-- Found, against TDB 8.3.7:
--   * The Honor Hold Gryphon Brigadiers (North 22404, Forge 22405, Foothill 22406, South 21170) have no spawns in
--     TDB: the bomber controller summons them when a Smoke Beacon hits a Zeth'Gor tower (Zeth'Gor Must Burn!,
--     spells 36302/39106/39107/39108) and they fly their bombing path and despawn. Ours had 20 static copies: 3 North,
--     1 Forge, 4 Foothill wandering 5 yards in the air (the freaking out), 12 South. The two stacked ones are the North
--     and Forge riders 307699/315331. The statics also stole the controller's 'set data to the closest rider' from
--     the summoned ones.
--   * Cursed Scarab 21306 and Cursed Scarab Summoner 21308 have no spawns in TDB. Ours had the summoner (it casts
--     Summon Cursed Scarabs on spawn) and 15 scarabs at the cauldron, captured with their summon auras.
--   * Darkness Released 22507 has no spawns in TDB: Colonel Jules' script summons them during The Exorcism of
--     Colonel Jules (10935) and they die to the exorcism. Ours had 8 static, hostile copies by his bed.
--   * Expedition Point: TDB has four Honor Hold / Stormwind miners (mining emote) by the rocks and one Honor Hold
--     Defender standing guard at -677.277, 1865.82, 66.4225, facing 0.418879, not mining. Ours had the mining emote on
--     that guard (the female dwarf, GUID 59047) and on Stormwind Infantry 59039; at the other miner spots a Stormwind
--     Infantry 59036 that doesn't mine (TDB: Honor Hold Defender 57933), a Nethergarde Infantry 59038 (TDB: Stormwind
--     Infantry 58140), and no fourth miner (TDB 58138).
-- Changed: the 44 leftover spawns above removed (and the per-GUID scripts of 4 South riders, which belonged to an
-- unrelated Draenor scene); the guard 59047 stays at Four's spot (the same as TDB within 0.3 yards, same facing)
-- without the mining emote; the four TDB miners mine with a Mining Pick 2901 (our tuning: TDB gives them their
-- usual weapons): 59036 (now an Honor Hold Defender, as TDB), 59038 (now a Stormwind Infantry), 59039, and
-- TDB's 58138 as GUID 735401760.
-- Not changed: the controller, the markers and the summoned riders (the bombing runs); the Colonel Jules event.
-- Safe to run twice.

-- 1. Gryphon Brigadiers (summoned by the Zeth'Gor bomber controller), scarabs and summoner, Darkness Released
DELETE FROM `creature` WHERE `guid` IN (92070,92071,92072,92073,307697,307698,307699,315331,
    318355,318356,318357,318358,318412,318413,318414,318415,318424,318425,318426,318427) AND `id` IN (21170,22404,22405,22406);
DELETE FROM `creature` WHERE `guid` IN (318349,318354,318359,318365,318369,318371,318379,318380,318381,318386,318390,
    318393,318398,318399,318400,318405) AND `id` IN (21306,21308);
DELETE FROM `creature` WHERE `guid` BETWEEN 315334 AND 315341 AND `id`=22507;
DELETE FROM `creature_addon` WHERE `guid` IN (92070,92071,92072,92073,307697,307698,307699,315331,
    318355,318356,318357,318358,318412,318413,318414,318415,318424,318425,318426,318427,
    318349,318354,318359,318365,318369,318371,318379,318380,318381,318386,318390,318393,318398,318399,318400,318405,
    315334,315335,315336,315337,315338,315339,315340,315341)
    AND `guid` NOT IN (SELECT `guid` FROM `creature`);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-318424,-318425,-318426,-318427) AND `source_type`=0
    AND -`entryorguid` NOT IN (SELECT `guid` FROM `creature`);

-- 2. Expedition Point: a Mining Pick for the miners (new equipment sets 3)
DELETE FROM `creature_equip_template` WHERE `CreatureID` IN (16842,16864) AND `ID`=3;
INSERT INTO `creature_equip_template` (`CreatureID`,`ID`,`ItemID1`,`AppearanceModID1`,`ItemVisual1`,`ItemID2`,`AppearanceModID2`,`ItemVisual2`,`ItemID3`,`AppearanceModID3`,`ItemVisual3`,`VerifiedBuild`) VALUES
(16842,3,2901,0,0,0,0,0,0,0,0,0),
(16864,3,2901,0,0,0,0,0,0,0,0,0);

-- the guard at Four's spot stands guard (TDB 57935: no emote)
UPDATE `creature` SET `position_x`=-677.083,`position_y`=1865.63,`position_z`=66.5475,`orientation`=0.418879 WHERE `guid`=59047;
UPDATE `creature_addon` SET `emote`=0 WHERE `guid`=59047;

-- the miners (TDB 57933, 58140, 58139, 58138)
UPDATE `creature` SET `id`=16842 WHERE `guid`=59036 AND `id` IN (16842,16864);
UPDATE `creature` SET `id`=16864,`position_x`=-687.488,`position_y`=1867,`position_z`=65.3849,`orientation`=5.61996 WHERE `guid`=59038 AND `id` IN (16831,16864);
UPDATE `creature` SET `equipment_id`=3 WHERE `guid` IN (59036,59038,59039);
DELETE FROM `creature` WHERE `guid`=735401760;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401760,16864,530,3483,3815,'0',0,0,0,-1,0,3,-696.879,1862.31,65.1725,5.55015,300,0,0,1,0,0,0,0,0,0,0,'',0);
DELETE FROM `creature_addon` WHERE `guid` IN (59036,59038,735401760);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(59036,0,0,0,4097,233,0,0,0,0,NULL),
(59038,0,0,0,4097,233,0,0,0,0,NULL),
(735401760,0,0,0,4097,233,0,0,0,0,NULL);
UPDATE `creature_addon` SET `emote`=233 WHERE `guid`=59039;

-- Summary: expect 0 riders, 0 scarabs, 0 Darkness Released, 4 miners with picks, the guard not mining
SELECT (SELECT COUNT(*) FROM `creature` WHERE `id` IN (21170,22404,22405,22406)) AS `riders`,
       (SELECT COUNT(*) FROM `creature` WHERE `id` IN (21306,21308)) AS `scarabs`,
       (SELECT COUNT(*) FROM `creature` WHERE `id`=22507) AS `darkness`,
       (SELECT COUNT(*) FROM `creature` c JOIN `creature_addon` a ON a.`guid`=c.`guid` WHERE c.`guid` IN (59036,59038,59039,735401760) AND a.`emote`=233 AND c.`equipment_id`=3) AS `miners`,
       (SELECT `emote` FROM `creature_addon` WHERE `guid`=59047) AS `guard_emote`;
