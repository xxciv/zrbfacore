-- World fixes: Brew of the Month Club, one brew a month (2026-11-18)
-- Four: "Vendor sells all brews all year. They should be in a cycle i believe, 1 type per month?" (Brew Vendor 89830,
-- guid 303580, Orgrimmar) and "i imagine its 1 brew per month until you try all 12 to get Brew of the Year achievement".
-- Needs 2026_11_18_46 first: until then the Brew of the Month events also carried Pilgrim's Bounty, Isle of Conquest
-- and L70ETC spawns.
-- Found:
--   - Brew Vendor 89830 in Orgrimmar sold all 12 brews (37488-37499) all year. TDB 8.3.7 gives it no wares of its own.
--   - The club events 34-45 ("Brew of the Month January" .. "December") ended on 2020-12-31, so the monthly
--     Brew Vendors 27806-27820 (outside Orgrimmar's gate and in Ironforge) never appear any more.
--   - Ironforge had only the February vendor, and it stood there all year (no event link); 8.3.7 has one per month.
-- Changed:
--   - 89830 sells only the current month's brew (game_event_npc_vendor on its spawn).
--   - Events 34-45 run every year again until the end of 2030. Start dates move to the first of the month this year
--     (our own dates: the old 2012 starts drifted a day every leap year, as the event repeats every 365 days; from
--     March 2028 each month will start one day early).
--   - Ironforge gets the other 11 monthly vendors at 8.3.7's spot (guids 735401187-735401197), and the
--     February one only shows in February.
-- Brew of the Year still takes a year: each brew is only sold in its month.
-- Safe to run twice.

-- 1. Orgrimmar Brew Vendor 89830: the month's brew only
DELETE FROM `npc_vendor` WHERE `entry`=89830 AND `item` BETWEEN 37488 AND 37499;
DELETE FROM `game_event_npc_vendor` WHERE `guid`=303580;
INSERT INTO `game_event_npc_vendor` (`eventEntry`,`guid`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`) VALUES
(37,303580,0,37488,0,0,0,1,NULL,0,0),
(38,303580,0,37489,0,0,0,1,NULL,0,0),
(39,303580,0,37490,0,0,0,1,NULL,0,0),
(40,303580,0,37491,0,0,0,1,NULL,0,0),
(41,303580,0,37492,0,0,0,1,NULL,0,0),
(42,303580,0,37493,0,0,0,1,NULL,0,0),
(43,303580,0,37494,0,0,0,1,NULL,0,0),
(44,303580,0,37495,0,0,0,1,NULL,0,0),
(45,303580,0,37496,0,0,0,1,NULL,0,0),
(34,303580,0,37497,0,0,0,1,NULL,0,0),
(35,303580,0,37498,0,0,0,1,NULL,0,0),
(36,303580,0,37499,0,0,0,1,NULL,0,0);

-- 2. The monthly events run again (our own start dates, see above)
UPDATE `game_event` SET `start_time`='2026-01-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=37; -- January
UPDATE `game_event` SET `start_time`='2026-02-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=38; -- February
UPDATE `game_event` SET `start_time`='2026-03-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=39; -- March
UPDATE `game_event` SET `start_time`='2026-04-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=40; -- April
UPDATE `game_event` SET `start_time`='2026-05-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=41; -- May
UPDATE `game_event` SET `start_time`='2026-06-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=42; -- June
UPDATE `game_event` SET `start_time`='2026-07-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=43; -- July
UPDATE `game_event` SET `start_time`='2026-08-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=44; -- August
UPDATE `game_event` SET `start_time`='2026-09-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=45; -- September
UPDATE `game_event` SET `start_time`='2026-10-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=34; -- October
UPDATE `game_event` SET `start_time`='2026-11-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=35; -- November
UPDATE `game_event` SET `start_time`='2025-12-01 00:01:00',`end_time`='2030-12-31 23:59:00' WHERE `eventEntry`=36; -- December

-- 3. Ironforge: the February vendor only in February, and the other 11 months at 8.3.7's spot
DELETE FROM `game_event_creature` WHERE `guid`=10968;
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (38,10968);
DELETE FROM `game_event_creature` WHERE `guid` BETWEEN 735401187 AND 735401197;
DELETE FROM `creature` WHERE `guid` BETWEEN 735401187 AND 735401197;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401187,27818,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401188,27819,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401189,27820,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401190,27806,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401191,27811,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401192,27812,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401193,27813,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401194,27814,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401195,27815,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401196,27816,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0),
(735401197,27817,0,1537,5719,'0',0,0,0,-1,0,1,-4845.95,-861.944,501.997,4.4855,120,0,0,0,0,0,0,0,0,0,0,'',0);
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (34,735401187),(35,735401188),(36,735401189),(37,735401190),(39,735401191),(40,735401192),(41,735401193),(42,735401194),(43,735401195),(44,735401196),(45,735401197);
