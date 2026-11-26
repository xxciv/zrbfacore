-- World fixes: Hellfire Peninsula tower skirmishes (2026-11-25)
-- Four: emulate PvP at the three Hellfire towers (Broken Hill, the Overlook, the Stadium). While players of one
-- faction capture a tower with no enemy players there, waves of the other faction's soldiers attack them, getting
-- harder each wave, until the tower is taken. Each soldier gives honor and an honorable kill. Once one faction holds
-- all three towers for 10 minutes, they go back to neutral.
-- This file is the soldiers; the waves, honor and reset are in tools/bfa/hellfire-tower-skirmish.patch, which also
-- turns /pvp back on (the core ignored it, so nobody could be flagged to capture a tower).
-- Our own design, not Blizzard's: names, looks, stats and spells are our tuning (looks and spells borrowed from
-- the Dark Portal defenders and Hellfire mobs). Levels scale with the player like Hellfire mobs (58-83); elites are
-- one level above. flags_extra 2112 = honor kill (0x800, new in the patch) + no XP (0x40), like a PvP kill.
-- Waves (warriors / mages / elites): 1/0/0, 2/0/0, 2/1/0, 0/1/1, 1/1/1, 0/0/2, 1/0/2, 1/1/2, 0/1/3, then 1/1/3 again.
-- Also: the three static 'Hellfire Banner' capture objects 66761-66763 go. TDB 8.3.7 has none; the core spawns its
-- own capture banner at each tower, so ours stood on top of a second, dead one.
-- Safe to run twice.

DELETE FROM `creature_template` WHERE `entry` BETWEEN 9100101 AND 9100106;
INSERT INTO `creature_template` (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`rank`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`unit_class`,`unit_flags`,`unit_flags2`,`type`,`lootid`,`AIName`,`MovementType`,`InhabitType`,`HoverHeight`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`ExperienceModifier`,`RegenHealth`,`flags_extra`,`ScriptName`,`VerifiedBuild`) VALUES
(9100101,'Thrallmar Skirmisher','',58,80,1668,0,1,1.14286,1,0,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,1.5,1,1,1.2,1,1,2112,'',0),
(9100102,'Thrallmar Battlemage','',58,80,1668,0,1,1.14286,1,0,0,2000,2000,8,32768,2048,7,0,'SmartAI',0,3,1,1.2,1,1,1,1,1,2112,'',0),
(9100103,'Thrallmar Warbringer','',58,80,1668,0,1,1.14286,1.1,1,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,3.4,1,1,1.6,1,1,2112,'',0),
(9100104,'Honor Hold Skirmisher','',58,80,1666,0,1,1.14286,1,0,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,1.5,1,1,1.2,1,1,2112,'',0),
(9100105,'Honor Hold Battlemage','',58,80,1666,0,1,1.14286,1,0,0,2000,2000,8,32768,2048,7,0,'SmartAI',0,3,1,1.2,1,1,1,1,1,2112,'',0),
(9100106,'Honor Hold Vanguard','',58,80,1666,0,1,1.14286,1.1,1,0,2000,2000,1,32768,2048,7,0,'SmartAI',0,3,1,3.4,1,1,1.6,1,1,2112,'',0);

-- Level scaling like Hellfire Peninsula's mobs; elites one level above the player
DELETE FROM `creature_template_scaling` WHERE `Entry` BETWEEN 9100101 AND 9100106;
INSERT INTO `creature_template_scaling` (`Entry`,`DifficultyID`,`LevelScalingMin`,`LevelScalingMax`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`VerifiedBuild`) VALUES
(9100101,0,58,83,0,0,0,0),(9100102,0,58,83,0,0,0,0),(9100103,0,58,83,1,1,0,0),
(9100104,0,58,83,0,0,0,0),(9100105,0,58,83,0,0,0,0),(9100106,0,58,83,1,1,0,0);

-- Looks: Orgrimmar Grunt, Undercity Mage, Kor'kron Elite; Stormwind Soldier, Stormwind Mage, Stormwind Royal Guard
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 9100101 AND 9100106;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(9100101,0,4259,1,1,0),(9100101,1,4260,1,1,0),(9100101,2,4601,1,1,0),(9100101,3,4602,1,1,0),
(9100102,0,18454,1,1,0),(9100102,1,18455,1,1,0),
(9100103,0,14360,1,1,0),(9100103,1,14361,1,1,0),(9100103,2,14362,1,1,0),(9100103,3,14363,1,1,0),
(9100104,0,3167,1,1,0),(9100104,1,5446,1,1,0),
(9100105,0,18452,1,1,0),(9100105,1,18453,1,1,0),
(9100106,0,34004,1,1,0),(9100106,1,34005,1,1,0);

DELETE FROM `creature_equip_template` WHERE `CreatureID` BETWEEN 9100101 AND 9100106;
INSERT INTO `creature_equip_template` (`CreatureID`,`ID`,`ItemID1`,`AppearanceModID1`,`ItemVisual1`,`ItemID2`,`AppearanceModID2`,`ItemVisual2`,`ItemID3`,`AppearanceModID3`,`ItemVisual3`,`VerifiedBuild`) VALUES
(9100101,1,5289,0,0,0,0,0,0,0,0,0),
(9100102,1,13050,0,0,0,0,0,0,0,0,0),
(9100103,1,5289,0,0,0,0,0,0,0,0,0),
(9100104,1,1899,0,0,143,0,0,0,0,0,0),
(9100105,1,14873,0,0,0,0,0,0,0,0,0),
(9100106,1,1899,0,0,143,0,0,0,0,0,0);

-- Fighting: warriors charge in, Strike and Hamstring; mages Frostbolt and Frost Nova; elites charge in,
-- Mortal Strike, Cleave, Thunderclap and Enrage at 30% health
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 9100101 AND 9100106 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9100101,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Skirmisher - On Aggro - Cast Charge'),
(9100101,0,1,0,0,0,100,0,3000,5000,6000,9000,0,'',11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Skirmisher - In Combat - Cast Strike'),
(9100101,0,2,0,0,0,100,0,6000,9000,15000,20000,0,'',11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Skirmisher - In Combat - Cast Hamstring'),
(9100102,0,0,0,0,0,100,0,0,0,3400,4700,0,'',11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Battlemage - In Combat - Cast Frostbolt'),
(9100102,0,1,0,9,0,100,0,0,8,13600,14500,0,'',11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrallmar Battlemage - Within 0-8 Range - Cast Frost Nova'),
(9100103,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Warbringer - On Aggro - Cast Charge'),
(9100103,0,1,0,0,0,100,0,5000,7000,9000,12000,0,'',11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Warbringer - In Combat - Cast Mortal Strike'),
(9100103,0,2,0,9,0,100,0,0,5,8000,9000,0,'',11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,'Thrallmar Warbringer - Within 0-5 Range - Cast Cleave'),
(9100103,0,3,0,0,0,100,0,10000,12000,18000,22000,0,'',11,15588,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrallmar Warbringer - In Combat - Cast Thunderclap'),
(9100103,0,4,0,2,0,100,1,0,30,0,0,0,'',11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thrallmar Warbringer - Between 0-30% Health - Cast Enrage (No Repeat)'),
(9100104,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Skirmisher - On Aggro - Cast Charge'),
(9100104,0,1,0,0,0,100,0,3000,5000,6000,9000,0,'',11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Skirmisher - In Combat - Cast Strike'),
(9100104,0,2,0,0,0,100,0,6000,9000,15000,20000,0,'',11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Skirmisher - In Combat - Cast Hamstring'),
(9100105,0,0,0,0,0,100,0,0,0,3400,4700,0,'',11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Battlemage - In Combat - Cast Frostbolt'),
(9100105,0,1,0,9,0,100,0,0,8,13600,14500,0,'',11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Battlemage - Within 0-8 Range - Cast Frost Nova'),
(9100106,0,0,0,4,0,100,0,0,0,0,0,0,'',11,35570,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Vanguard - On Aggro - Cast Charge'),
(9100106,0,1,0,0,0,100,0,5000,7000,9000,12000,0,'',11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Vanguard - In Combat - Cast Mortal Strike'),
(9100106,0,2,0,9,0,100,0,0,5,8000,9000,0,'',11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,'Honor Hold Vanguard - Within 0-5 Range - Cast Cleave'),
(9100106,0,3,0,0,0,100,0,10000,12000,18000,22000,0,'',11,15588,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Vanguard - In Combat - Cast Thunderclap'),
(9100106,0,4,0,2,0,100,1,0,30,0,0,0,'',11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,'Honor Hold Vanguard - Between 0-30% Health - Cast Enrage (No Repeat)');

-- The dead duplicate capture banners (the core spawns the working ones)
DELETE FROM `gameobject` WHERE `guid` IN (66761,66762,66763) AND `id` IN (182173,182174,182175);
DELETE FROM `gameobject_addon` WHERE `guid` IN (66761,66762,66763);

-- Summary: expect 6 soldiers, 6 scaling rows, 16 models, 6 weapons, 20 scripts, 0 static banners
SELECT (SELECT COUNT(*) FROM `creature_template` WHERE `entry` BETWEEN 9100101 AND 9100106) AS `soldiers`,
       (SELECT COUNT(*) FROM `creature_template_scaling` WHERE `Entry` BETWEEN 9100101 AND 9100106) AS `scaling`,
       (SELECT COUNT(*) FROM `creature_template_model` WHERE `CreatureID` BETWEEN 9100101 AND 9100106) AS `models`,
       (SELECT COUNT(*) FROM `creature_equip_template` WHERE `CreatureID` BETWEEN 9100101 AND 9100106) AS `weapons`,
       (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` BETWEEN 9100101 AND 9100106 AND `source_type`=0) AS `scripts`,
       (SELECT COUNT(*) FROM `gameobject` WHERE `id` IN (182173,182174,182175)) AS `static_banners`;
