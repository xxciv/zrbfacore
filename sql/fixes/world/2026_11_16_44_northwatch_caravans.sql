-- Northwatch supply caravans (Durotar, south road), 2026-11-16
-- Before: snapshots of moving caravans stood frozen: 17 invisible caravan carriers (Northwatch Caravan A/B/C, visible in GM mode),
-- 17 Northwatch Supply Crates hanging in the air and 33 Northwatch Lugs standing in or beside them. The caravan SAI was there
-- (start path 39244, despawn passengers at the end) but the path, the vehicle passengers and the spawners' script were missing.
-- After: the three Caravan Spawners each send out a caravan every 2-2.5 minutes. Lugs carry the crate (vehicle seats from
-- VehicleSeat.db2: A = 3 lugs + crate, B = 1 lug + crate, C = 2 lugs + crate) along the road north and despawn at the end.
DELETE FROM `creature` WHERE `guid` IN (252743,252758,252772,252791,252818,252830,252744,252755,252756,252759,252769,252770,252773,252792,252815,252816,252819,252827,252828,252831,252745,252747,252749,252760,252762,252765,252774,252776,252778,252793,252795,252797,252810,252820,252822,252824,252832,252834,252836,252746,252750,252757,252761,252766,252771,252775,252779,252794,252798,252811,252817,252821,252825,252829,252833,252837,252748,252764,252777,252796,252809,252823,252835,252754,252768,252814,252826);
DELETE FROM `creature_addon` WHERE `guid` IN (252743,252758,252772,252791,252818,252830,252744,252755,252756,252759,252769,252770,252773,252792,252815,252816,252819,252827,252828,252831,252745,252747,252749,252760,252762,252765,252774,252776,252778,252793,252795,252797,252810,252820,252822,252824,252832,252834,252836,252746,252750,252757,252761,252766,252771,252775,252779,252794,252798,252811,252817,252821,252825,252829,252833,252837,252748,252764,252777,252796,252809,252823,252835,252754,252768,252814,252826);
-- spawners stand still (were random-moving)
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `guid` IN (251643,251644,251645);
DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (39244,39318,39319);
INSERT INTO `vehicle_template_accessory` (`entry`,`accessory_entry`,`seat_id`,`minion`,`description`,`summontype`,`summontimer`) VALUES
(39244,39245,0,0,'Northwatch Caravan - Lug',8,0),
(39244,39249,1,0,'Northwatch Caravan - Lug',8,0),
(39244,39251,2,0,'Northwatch Caravan - Supply Crate',8,0),
(39244,39249,3,0,'Northwatch Caravan - Lug',8,0),
(39318,39245,0,0,'Northwatch Caravan - Lug',8,0),
(39318,39251,1,0,'Northwatch Caravan - Supply Crate',8,0),
(39319,39245,0,0,'Northwatch Caravan - Lug',8,0),
(39319,39249,1,0,'Northwatch Caravan - Lug',8,0),
(39319,39251,2,0,'Northwatch Caravan - Supply Crate',8,0);
DELETE FROM `waypoints` WHERE `entry`=39244;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(39244,1,-1044,-4700,17.5,'Northwatch Caravan'),
(39244,2,-1022,-4698,21.7,'Northwatch Caravan'),
(39244,3,-995,-4690,22.8,'Northwatch Caravan'),
(39244,4,-988,-4672,27.7,'Northwatch Caravan'),
(39244,5,-981,-4605,25.6,'Northwatch Caravan'),
(39244,6,-991,-4557,25.8,'Northwatch Caravan'),
(39244,7,-1007,-4519,25.6,'Northwatch Caravan'),
(39244,8,-1014,-4466,26.0,'Northwatch Caravan'),
(39244,9,-1014,-4422,26.6,'Northwatch Caravan');
-- caravan: passengers despawn at the last point (9) instead of point 10
UPDATE `smart_scripts` SET `event_param1`=9 WHERE `entryorguid` IN (39244,39318,39319) AND `source_type`=0 AND `event_type`=40;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-251643,-251644,-251645);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-251643,0,0,0,1,0,100,0,5000,10000,120000,150000,0,'',12,39318,3,600000,0,0,0,1,0,0,0,0,0,0,0,'Northwatch Caravan Spawner - OOC - Summon caravan 39318'),
(-251644,0,0,0,1,0,100,0,45000,50000,120000,150000,0,'',12,39244,3,600000,0,0,0,1,0,0,0,0,0,0,0,'Northwatch Caravan Spawner - OOC - Summon caravan 39244'),
(-251645,0,0,0,1,0,100,0,85000,90000,120000,150000,0,'',12,39319,3,600000,0,0,0,1,0,0,0,0,0,0,0,'Northwatch Caravan Spawner - OOC - Summon caravan 39319');
