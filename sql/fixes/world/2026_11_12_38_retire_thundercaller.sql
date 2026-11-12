-- Retire The Thundercaller (Orgrimmar - Undercity zeppelin, transport 164871, map 591): on BFA the
-- Orgrimmar platform has a Portal to Undercity (293684, already spawned) instead, and the client map shows a
-- Portal to Orgrimmar on the Tirisfal Glades tower. That portal (293689, Teleport: Orgrimmar 3567) existed
-- as a template but was never spawned. Spot picked by Four in game.
DELETE FROM `transports` WHERE `entry`=164871;

-- Its crew from 2026_11_12_33 (map 591), no longer loaded by any transport
DELETE FROM `creature` WHERE `guid` BETWEEN 735200050 AND 735200070 AND `map`=591;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735200050 AND 735200070;

-- Portal to Orgrimmar on the Tirisfal Glades zeppelin tower, Horde only like the Orgrimmar side (faction 1735)
DELETE FROM `gameobject` WHERE `guid`=735400101;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`isActive`,`ScriptName`,`VerifiedBuild`) VALUES
(735400101,293689,0,85,85,'0',0,0,0,-1,2067.744,290.337,97.031,4.585337,0,0,0.75057,-0.660791,120,255,1,0,'',0);
DELETE FROM `gameobject_template_addon` WHERE `entry`=293689;
INSERT INTO `gameobject_template_addon` (`entry`,`faction`,`flags`,`mingold`,`maxgold`,`WorldEffectID`,`AIAnimKitID`) VALUES
(293689,1735,0,0,0,0,0);

-- Watcher Umjin 25107 on The Purple Princess (guid 735200049 from 2026_11_12_33): his template addon has him
-- asleep (stand state 3, also in TDB), and lying down he clips through the cabin wall. Standing per-spawn addon.
DELETE FROM `creature_addon` WHERE `guid`=735200049;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`) VALUES
(735200049,0,0,0,1,0,0,0,0);

-- The portal template casts Teleport: Orgrimmar 3567 (the mage spell: 10 s cast, lands at 1776.5 -4338.8 -7.5 in
-- the city). No portal spell lands on the zeppelin tower, so the portal casts nothing (Data0 0) and its per-spawn
-- SmartAI teleports the player on use, instantly, next to the Portal to Undercity (spot picked by Four in game).
UPDATE `gameobject_template` SET `Data0`=0 WHERE `entry`=293689;
DELETE FROM `smart_scripts` WHERE `entryorguid`=-735400101 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735400101,1,0,0,64,0,100,0,0,0,0,0,0,'',62,1,0,0,0,0,0,7,0,0,0,1841.119,-4391.987,135.234,5.553,'Portal to Orgrimmar (Tirisfal tower) - On use - Teleport to Orgrimmar zeppelin tower');

-- Orgrimmar's Portal to Undercity 293684 (guid 210400316) reuses Portal Effect: Undercity 17611, which lands inside
-- Undercity (1773.4 61.7 -46.3). Make the pair tower to tower (Four's call): it now casts nothing and its per-spawn
-- SmartAI teleports the player instantly onto the Tirisfal Glades zeppelin tower, at the new Portal to Orgrimmar.
UPDATE `gameobject_template` SET `Data0`=0 WHERE `entry`=293684;
DELETE FROM `smart_scripts` WHERE `entryorguid`=-210400316 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-210400316,1,0,0,64,0,100,0,0,0,0,0,0,'',62,0,0,0,0,0,0,7,0,0,0,2067.744,290.337,97.031,4.585,'Portal to Undercity (Orgrimmar tower) - On use - Teleport to Tirisfal Glades zeppelin tower');
