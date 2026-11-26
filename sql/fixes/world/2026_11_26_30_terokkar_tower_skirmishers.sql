-- World fixes: Terokkar Forest Spirit Tower skirmishes (2026-11-26)
-- Four: the Hellfire tower skirmishes for Terokkar's five Spirit Towers in the Bone Wastes. While players of one
-- faction capture a tower with no enemy players there, waves of the other faction's soldiers attack them; wave 4
-- (an elite and a mage) is the finale and the tower can't be taken until it is dead. Each soldier gives honor and
-- an honorable kill. Once one faction holds all five towers, the Blessing of Auchindoun lasts 10 minutes and then
-- all five go back to neutral (blizzlike: locked for 6 hours, towers keep their owner).
-- This file is the soldiers; the waves and reset are in tools/bfa/terokkar-tower-skirmish.patch (after
-- hellfire-tower-skirmish.patch, which has the honor-kill flag and /pvp).
-- Our own design, not Blizzard's: the Hellfire soldiers' stats and spells, dressed as Stonebreaker Hold (Horde) and
-- Allerian Stronghold (Alliance) soldiers with those guards' looks and weapons from TDB 8.3.7. Levels scale like
-- the Bone Wastes' mobs (62-83); elites are one level above. flags_extra 2112 = honor kill (0x800) + no XP (0x40).
-- Also: the five static 'Terokkar Banner' capture objects (67500, 67719-67722) go. TDB 8.3.7 has none; the core
-- spawns its own capture banner at each tower, so ours stood on top of a second, dead one.
-- Safe to run twice.

DELETE FROM `creature_template` WHERE `entry` BETWEEN 9100107 AND 9100112;
INSERT INTO `creature_template` (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`rank`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`unit_class`,`unit_flags`,`unit_flags2`,`type`,`lootid`,`AIName`,`MovementType`,`InhabitType`,`HoverHeight`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`ExperienceModifier`,`RegenHealth`,`flags_extra`,`ScriptName`,`VerifiedBuild`) VALUES
(9100107,'Stonebreaker Skirmisher','',62,80,1668,0,1,1.14286,1,0,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,1.5,1,1,1.2,1,1,2112,'',0),
(9100108,'Stonebreaker Battlemage','',62,80,1668,0,1,1.14286,1,0,0,2000,2000,8,32768,2048,7,0,'SmartAI',0,3,1,1.2,1,1,1,1,1,2112,'',0),
(9100109,'Stonebreaker Warbringer','',62,80,1668,0,1,1.14286,1.1,1,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,3.4,1,1,1.6,1,1,2112,'',0),
(9100110,'Allerian Skirmisher','',62,80,1666,0,1,1.14286,1,0,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,1.5,1,1,1.2,1,1,2112,'',0),
(9100111,'Allerian Battlemage','',62,80,1666,0,1,1.14286,1,0,0,2000,2000,8,32768,2048,7,0,'SmartAI',0,3,1,1.2,1,1,1,1,1,2112,'',0),
(9100112,'Allerian Vanguard','',62,80,1666,0,1,1.14286,1.1,1,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,3.4,1,1,1.6,1,1,2112,'',0);

-- Level scaling like the Bone Wastes' mobs (62-83); elites one level above the player
DELETE FROM `creature_template_scaling` WHERE `Entry` BETWEEN 9100107 AND 9100112;
INSERT INTO `creature_template_scaling` (`Entry`,`DifficultyID`,`LevelScalingMin`,`LevelScalingMax`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`VerifiedBuild`) VALUES
(9100107,0,62,83,0,0,0,0),(9100108,0,62,83,0,0,0,0),(9100109,0,62,83,1,1,0,0),
(9100110,0,62,83,0,0,0,0),(9100111,0,62,83,0,0,0,0),(9100112,0,62,83,1,1,0,0);

-- Looks: Stonebreaker Grunt, Undercity Mage, Stonebreaker Guard (scale 1.1); Allerian Defender, Stormwind Mage, Allerian Horseman
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 9100107 AND 9100112;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(9100107,0,4259,1,1,0),(9100107,1,4260,1,1,0),(9100107,2,4601,1,1,0),(9100107,3,4602,1,1,0),
(9100108,0,18454,1,1,0),(9100108,1,18455,1,1,0),
(9100109,0,4261,1,1,0),(9100109,1,12166,1,1,0),(9100109,2,12165,1,1,0),(9100109,3,4264,1,1,0),
(9100110,0,18437,1,1,0),(9100110,1,18438,1,1,0),(9100110,2,18439,1,1,0),(9100110,3,18440,1,1,0),
(9100111,0,18452,1,1,0),(9100111,1,18453,1,1,0),
(9100112,0,18446,1,1,0),(9100112,1,18447,1,1,0);

DELETE FROM `creature_equip_template` WHERE `CreatureID` BETWEEN 9100107 AND 9100112;
INSERT INTO `creature_equip_template` (`CreatureID`,`ID`,`ItemID1`,`AppearanceModID1`,`ItemVisual1`,`ItemID2`,`AppearanceModID2`,`ItemVisual2`,`ItemID3`,`AppearanceModID3`,`ItemVisual3`,`VerifiedBuild`) VALUES
(9100107,1,5289,0,0,0,0,0,2507,0,0,0),
(9100108,1,13050,0,0,0,0,0,0,0,0,0),
(9100109,1,12285,0,0,0,0,0,5260,0,0,0),
(9100110,1,12944,0,0,143,0,0,2552,0,0,0),
(9100111,1,14873,0,0,0,0,0,0,0,0,0),
(9100112,1,4991,0,0,0,0,0,0,0,0,0);

-- Fighting: warriors charge in, Strike and Hamstring; mages Frostbolt and Frost Nova; elites charge in,
-- Mortal Strike, Cleave, Thunderclap and Enrage at 30% health
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 9100107 AND 9100112 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9100107,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Skirmisher - On Aggro - Cast Charge'),
(9100107,0,1,0,0,0,100,0,3000,5000,6000,9000,0,'',11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Skirmisher - In Combat - Cast Strike'),
(9100107,0,2,0,0,0,100,0,6000,9000,15000,20000,0,'',11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Skirmisher - In Combat - Cast Hamstring'),
(9100108,0,0,0,0,0,100,0,0,0,3400,4700,0,'',11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Battlemage - In Combat - Cast Frostbolt'),
(9100108,0,1,0,9,0,100,0,0,8,13600,14500,0,'',11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonebreaker Battlemage - Within 0-8 Range - Cast Frost Nova'),
(9100109,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Warbringer - On Aggro - Cast Charge'),
(9100109,0,1,0,0,0,100,0,5000,7000,9000,12000,0,'',11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Warbringer - In Combat - Cast Mortal Strike'),
(9100109,0,2,0,9,0,100,0,0,5,8000,9000,0,'',11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonebreaker Warbringer - Within 0-5 Range - Cast Cleave'),
(9100109,0,3,0,0,0,100,0,10000,12000,18000,22000,0,'',11,15588,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonebreaker Warbringer - In Combat - Cast Thunderclap'),
(9100109,0,4,0,2,0,100,1,0,30,0,0,0,'',11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonebreaker Warbringer - Between 0-30% Health - Cast Enrage (No Repeat)'),
(9100110,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Skirmisher - On Aggro - Cast Charge'),
(9100110,0,1,0,0,0,100,0,3000,5000,6000,9000,0,'',11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Skirmisher - In Combat - Cast Strike'),
(9100110,0,2,0,0,0,100,0,6000,9000,15000,20000,0,'',11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Skirmisher - In Combat - Cast Hamstring'),
(9100111,0,0,0,0,0,100,0,0,0,3400,4700,0,'',11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Battlemage - In Combat - Cast Frostbolt'),
(9100111,0,1,0,9,0,100,0,0,8,13600,14500,0,'',11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,'Allerian Battlemage - Within 0-8 Range - Cast Frost Nova'),
(9100112,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Vanguard - On Aggro - Cast Charge'),
(9100112,0,1,0,0,0,100,0,5000,7000,9000,12000,0,'',11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Vanguard - In Combat - Cast Mortal Strike'),
(9100112,0,2,0,9,0,100,0,0,5,8000,9000,0,'',11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,'Allerian Vanguard - Within 0-5 Range - Cast Cleave'),
(9100112,0,3,0,0,0,100,0,10000,12000,18000,22000,0,'',11,15588,0,0,0,0,0,1,0,0,0,0,0,0,0,'Allerian Vanguard - In Combat - Cast Thunderclap'),
(9100112,0,4,0,2,0,100,1,0,30,0,0,0,'',11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,'Allerian Vanguard - Between 0-30% Health - Cast Enrage (No Repeat)');

-- The dead duplicate capture banners (the core spawns the working ones)
DELETE FROM `gameobject` WHERE `guid` IN (67500,67719,67720,67721,67722) AND `id` IN (183104,183411,183412,183413,183414);
DELETE FROM `gameobject_addon` WHERE `guid` IN (67500,67719,67720,67721,67722);

-- Summary: expect 6 soldiers, 6 scaling rows, 18 models, 6 weapons, 20 scripts, 0 static banners
SELECT (SELECT COUNT(*) FROM `creature_template` WHERE `entry` BETWEEN 9100107 AND 9100112) AS `soldiers`,
       (SELECT COUNT(*) FROM `creature_template_scaling` WHERE `Entry` BETWEEN 9100107 AND 9100112) AS `scaling`,
       (SELECT COUNT(*) FROM `creature_template_model` WHERE `CreatureID` BETWEEN 9100107 AND 9100112) AS `models`,
       (SELECT COUNT(*) FROM `creature_equip_template` WHERE `CreatureID` BETWEEN 9100107 AND 9100112) AS `weapons`,
       (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` BETWEEN 9100107 AND 9100112 AND `source_type`=0) AS `scripts`,
       (SELECT COUNT(*) FROM `gameobject` WHERE `id` IN (183104,183411,183412,183413,183414)) AS `static_banners`;
