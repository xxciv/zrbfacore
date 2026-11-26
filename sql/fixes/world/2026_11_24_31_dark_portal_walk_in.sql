-- World fixes: walking into the Dark Portal teleports you, both ways (2026-11-24)
-- Follow-up to 2026_11_24_30. Four: still nothing at the portal, and `.debug areatriggers` printed nothing.
-- Found: an 8.3.7 client sends no area trigger at the Dark Portal (trigger 4354 is gone from its AreaTrigger table),
-- so 30's SmartTrigger never runs. The world DB instead has server-side area triggers in the portal (`areatrigger`
-- guids 69 and 99 in the Blasted Lands, 70 in Hellfire Peninsula, teleports -69/-99/-70), but our core never spawns
-- any `areatrigger` row: ObjectGridLoader's LoadHelper only spawns creatures and gameobjects and deletes everything
-- else. Not changed here (turning them all on would also bounce players straight back out of several dungeon exits).
-- Changed: invisible ELM General Purpose Bunnies 23837 stand just inside each side of the portal, three across the
-- opening. Every half second each one teleports the players within 12 yards (about 15 with body sizes):
--   Blasted Lands side -> world_safe_locs 7352 'Blasted Lands - Dark Portal to Hellfire Peninsula' (530: -248.113
--   922.9 84.3497, facing 90 deg). These bunnies are in phase 318, which Blasted Lands (zone 4) gives only to players
--   above level 57, as TDB 8.3.7 gates the portal; phase 169 is added with it so nothing else in the zone changes.
--   Hellfire Peninsula side -> world_safe_locs 7348 'Blasted Lands - Dark Portal' (0: -11896.8 -3206.77 -11.5962,
--   facing 10 deg), any level, like the dead trigger 70.
-- The arrival points are 21 (Blasted Lands) and 35 (Hellfire) yards from the nearest bunny, so arriving never sends
-- you back. Bunny spots, radius and the half-second timer are our own tuning, placed from the dead triggers.
-- Safe to run twice.

DELETE FROM `creature` WHERE `guid` BETWEEN 735401543 AND 735401548;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401543,23837,0,4,72,'0',0,318,0,-1,0,0,-11918.0,-3226.0,-14.88,0,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401544,23837,0,4,72,'0',0,318,0,-1,0,0,-11918.0,-3208.0,-14.88,0,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401545,23837,0,4,72,'0',0,318,0,-1,0,0,-11918.0,-3190.0,-14.88,0,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401546,23837,530,3483,3539,'0',0,0,0,-1,0,0,-264.5,888.0,84.35,0,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401547,23837,530,3483,3539,'0',0,0,0,-1,0,0,-246.5,888.0,84.35,0,300,0,0,1,0,0,0,0,0,0,0,'',0),
(735401548,23837,530,3483,3539,'0',0,0,0,-1,0,0,-228.5,888.0,84.35,0,300,0,0,1,0,0,0,0,0,0,0,'',0);
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735401543 AND 735401548;

DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN -735401548 AND -735401543 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735401543,0,0,0,1,0,100,0,500,500,500,500,0,'',62,530,0,0,0,0,0,17,0,12,0,-248.113,922.9,84.3497,1.5708,'Dark Portal bunny (Blasted Lands, phase 318 = level 58+) - OOC every 0.5s - Teleport players within 12 yd to Hellfire Peninsula'),
(-735401544,0,0,0,1,0,100,0,500,500,500,500,0,'',62,530,0,0,0,0,0,17,0,12,0,-248.113,922.9,84.3497,1.5708,'Dark Portal bunny (Blasted Lands, phase 318 = level 58+) - OOC every 0.5s - Teleport players within 12 yd to Hellfire Peninsula'),
(-735401545,0,0,0,1,0,100,0,500,500,500,500,0,'',62,530,0,0,0,0,0,17,0,12,0,-248.113,922.9,84.3497,1.5708,'Dark Portal bunny (Blasted Lands, phase 318 = level 58+) - OOC every 0.5s - Teleport players within 12 yd to Hellfire Peninsula'),
(-735401546,0,0,0,1,0,100,0,500,500,500,500,0,'',62,0,0,0,0,0,0,17,0,12,0,-11896.8,-3206.77,-11.5962,0.1745,'Dark Portal bunny (Hellfire Peninsula) - OOC every 0.5s - Teleport players within 12 yd to the Blasted Lands'),
(-735401547,0,0,0,1,0,100,0,500,500,500,500,0,'',62,0,0,0,0,0,0,17,0,12,0,-11896.8,-3206.77,-11.5962,0.1745,'Dark Portal bunny (Hellfire Peninsula) - OOC every 0.5s - Teleport players within 12 yd to the Blasted Lands'),
(-735401548,0,0,0,1,0,100,0,500,500,500,500,0,'',62,0,0,0,0,0,0,17,0,12,0,-11896.8,-3206.77,-11.5962,0.1745,'Dark Portal bunny (Hellfire Peninsula) - OOC every 0.5s - Teleport players within 12 yd to the Blasted Lands');

-- Phase 318 in the Blasted Lands for players above level 57 (with 169, so default spawns stay visible)
DELETE FROM `phase_area` WHERE `AreaId`=4 AND `PhaseId` IN (169,318);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(4,169,'Blasted Lands - default phase (needed next to 318)'),
(4,318,'Blasted Lands - Dark Portal bunnies, players above level 57');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=318 AND `SourceEntry`=4;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,318,4,0,0,27,0,57,1,0,0,0,0,'','Blasted Lands phase 318 (Dark Portal) only above level 57');

-- Summary: expect 6 bunnies, 6 scripts, 2 phase rows, 1 condition
SELECT (SELECT COUNT(*) FROM `creature` WHERE `guid` BETWEEN 735401543 AND 735401548) AS `bunnies`,
       (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` BETWEEN -735401548 AND -735401543 AND `source_type`=0) AS `scripts`,
       (SELECT COUNT(*) FROM `phase_area` WHERE `AreaId`=4 AND `PhaseId` IN (169,318)) AS `phase_rows`,
       (SELECT COUNT(*) FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=318 AND `SourceEntry`=4) AS `conditions`;
