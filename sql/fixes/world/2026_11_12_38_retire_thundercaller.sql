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
