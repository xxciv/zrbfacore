-- World fixes: staged NPC battles that last (second-tier zones, 2026-11-17)
-- Needs tools/bfa/staged-npc-battles.patch: flags_extra 0x400 = NPC damage stops at 85% health.
-- Players and their pets deal full damage. Safe to run twice.

-- 1. Flag the staged-battle creatures (our own tuning, the same idea as the Camp Narache battle)
-- Westfall, Sentinel Hill: Sentinel Hill Guard 42407, Riverpaw Bandit 54371, Riverpaw Brute 54372, Riverpaw Herbalist 54373
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (42407,54371,54372,54373);
-- Silverpine Forest: Worgen Renegade 44793, Forsaken Trooper 44791, Forsaken Trooper 44792, Hillsbrad Worgen 45254, Hillsbrad Worgen 45255, Hillsbrad Worgen 46063, Hillsbrad Worgen 46064, Orc Sea Dog 45196, Orc Sea Dog 46057
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (44793,44791,44792,45254,45255,46063,46064,45196,46057);
-- Ruins of Gilneas: Forsaken Vanguard 45280, Forsaken Vanguard 45532, Worgen Rebel 45292, Worgen Rusher 45375, Worgen Rusher 45535, Forsaken Sharpshooter 45376, Forsaken Catapult 45533, Forsaken Blightspreader 51192, 7th Legion Submariner 45539
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (45280,45532,45292,45375,45535,45376,45533,51192,45539);
-- Azshara: Talrendis Saboteur 35312, Mountainfoot Grunt 36936, Valormok Grunt 36815, Talrendis Defender 36816, Talrendis Raider 35177, Orgrimmar Gatekeeper 35190
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (35312,36936,36815,36816,35177,35190);
-- Northern Barrens: Rageroar Sea Dog 38661, Blackpool Crewman 38664, Razormane Pillager 34503, Grol'dom Grunt 34504
UPDATE `creature_template` SET `flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (38661,38664,34503,34504);

-- 2. Sentinel Hill gnolls 1:1 with the 8.3.7 reference (TDB 8.3.7): 26 gnolls, not 43.
-- Our dump had the old Riverpaw entries (452/124/501) and the Sentinel Hill ones (54371-54373) on the same spots.
-- Matched spawns take the 8.3.7 entry; the second copies go; 7 missing 8.3.7 gnolls are added.
UPDATE `creature` SET `id`=54373 WHERE `guid`=215093;
UPDATE `creature` SET `id`=54371 WHERE `guid`=216098;
UPDATE `creature` SET `id`=54371 WHERE `guid`=215011;
UPDATE `creature` SET `id`=54372 WHERE `guid`=215095;
UPDATE `creature` SET `id`=54373 WHERE `guid`=215009;
UPDATE `creature` SET `id`=54373 WHERE `guid`=214915;
UPDATE `creature` SET `id`=54372 WHERE `guid`=216072;
UPDATE `creature` SET `id`=54373 WHERE `guid`=215227;
UPDATE `creature` SET `id`=54373 WHERE `guid`=215230;
UPDATE `creature` SET `id`=54372 WHERE `guid`=216094;
UPDATE `creature` SET `id`=54372 WHERE `guid`=214909;
UPDATE `creature` SET `id`=54373 WHERE `guid`=214907;
UPDATE `creature` SET `id`=54372 WHERE `guid`=215215;
UPDATE `creature` SET `id`=54371 WHERE `guid`=215097;
UPDATE `creature` SET `id`=54371 WHERE `guid`=214908;
UPDATE `creature` SET `id`=54371 WHERE `guid`=215226;
DELETE FROM `creature_addon` WHERE `guid` IN (214910,215096,215235,214923,215233,216089,216158,215091,215232,216069,216358,216155,216086,215255,302995,302998,303000,303002,302993,302990,302986,302991,302996,302999);
DELETE FROM `creature` WHERE `guid` IN (214910,215096,215235,214923,215233,216089,216158,215091,215232,216069,216358,216155,216086,215255,302995,302998,303000,303002,302993,302990,302986,302991,302996,302999);
-- 3. Sentinel Hill guards: add the 10 8.3.7 guards we lacked (34 guards, 26 gnolls; 8.3.7 has 31 and 26).
DELETE FROM `creature` WHERE `guid` BETWEEN 735401026 AND 735401042;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401026,54371,0,0,0,0,0,0,0,-1,0,0,-10611.3,1239.59,32.8965,3.70079,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401027,54371,0,0,0,0,0,0,0,-1,0,0,-10553.5,1195.5,32.023,3.03489,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401028,54371,0,0,0,0,0,0,0,-1,0,0,-10515.7,1119.2,42.5908,0.175974,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401029,54372,0,0,0,0,0,0,0,-1,0,0,-10635.3,1216.08,33.8133,6.01308,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401030,54372,0,0,0,0,0,0,0,-1,0,0,-10563.6,1104.65,40.2375,4.70122,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401031,54373,0,0,0,0,0,0,0,-1,0,0,-10565.9,1101.87,40.5408,3.68951,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401032,54373,0,0,0,0,0,0,0,-1,0,0,-10585.7,1201.29,32.9114,4.35344,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401033,42407,0,0,0,0,0,0,0,-1,0,0,-10637.2,1042.41,33.4888,3.54302,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401034,42407,0,0,0,0,0,0,0,-1,0,0,-10625.5,1053.13,34.0689,4.74729,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401035,42407,0,0,0,0,0,0,0,-1,0,0,-10618,1052.7,34.3961,3.63029,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401036,42407,0,0,0,0,0,0,0,-1,0,0,-10616.8,1035.53,34.1982,2.21657,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401037,42407,0,0,0,0,0,0,0,-1,0,0,-10634.1,1031.29,33.4911,3.54302,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401038,42407,0,0,0,0,0,0,0,-1,0,0,-10623.2,1037.21,34.0038,0.663225,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401039,42407,0,0,0,0,0,0,0,-1,0,0,-10563.6,1101.94,40.8883,1.55942,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401040,42407,0,0,0,0,0,0,0,-1,0,0,-10590.7,1180.5,35.3372,0.977384,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401041,42407,0,0,0,0,0,0,0,-1,0,0,-10549.2,1130.75,37.1041,1.79779,120,0,0,1,0,0,0,0,0,0,0,'',0),
(735401042,42407,0,0,0,0,0,0,0,-1,0,0,-10512.5,1119.78,42.4512,3.31741,120,0,0,1,0,0,0,0,0,0,0,'',0);

-- 4. Counterattack! (quest 4021): Regthar Deathgate's script summons the Horde defenders, axe throwers,
-- Kolkar invaders and Warlord Krom'zar. Our dump also had 17 of them as static spawns, so a battle that
-- nobody started ran out at his camp and Krom'zar stood there for anyone. Classic data has only Regthar here.
DELETE FROM `creature_addon` WHERE `guid` IN (265894,265901,265902,265908,265906,265893,265898,265900,265903,265885,265883,265895,265892,265887,265890,265886,265907);
DELETE FROM `creature` WHERE `guid` IN (265894,265901,265902,265908,265906,265893,265898,265900,265903,265885,265883,265895,265892,265887,265890,265886,265907);

-- 5. Rageroar Sea Dogs at the rowboats off the coast stay with their boats (8.3.7: standing still), not swimming off.
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `guid` IN (265361,265362,265363,265365,265366,265367,265370,265371,265372,270714,270715,270716);

-- 6. Dead bodies (permanent feign death auras 29266/31261/84386) don't wander: 80 in these zones had the dump's jitter.
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `MovementType`=1 AND `guid` IN (186795,186796,245585,245593,245595,245596,245622,245625,245627,245629,245630,245651,245652,245653,245655,245712,245714,245718,245740,245742,245744,245756,245757,245759,245786,245790,245796,245835,245853,245856,245857,245861,245875,306925,306556,306558,306559,306561,306564,306565,306682,306684,306686,306764,306771,306834,306836,306843,306847,306923,306924,312222,312227,312232,312233,312235,312236,312237,312265,312268,312270,312271,312272,312274,312277,312278,312280,312304,312309,312311,312313,312315,312316,312317,312319,312320,312325,312345,312348,40001105);
