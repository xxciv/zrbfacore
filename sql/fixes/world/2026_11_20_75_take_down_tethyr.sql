-- Take Down Tethyr! 27222 (Major Mills 23905, Theramore docks, Dustwallow Marsh): reported by Four on
-- Wayfarer's Theramore walk, 2026-11-20 (Tethyr idling at the docks, quest can't be done).
-- The quest has no objectives: Mills's event completes it. Ours had no script at all on Mills and Tethyr,
-- and the event never started. TDB 8.3.7 has the event but keys it on the old quest id 11198 and on a
-- Mills guid (31075) that does not exist. This is TDB's event on 27222 and our Mills guid 255200.
-- Tethyr: TDB keeps him passive (he only took the hits, Four 2026-11-20); at the docks he is now rooted in
-- the water and aggressive, bolts a random enemy every 4-5 s and Spouts whoever is in front of him.
-- Accept: Mills calls the marksmen (12, as in TDB) and Tethyr swims in to the docks. The marksmen shoot
-- him, the three Cove Cannons 186432 (usable with the quest, cast 42578 on Tethyr) take 10% of his health
-- per shot (42576, TDB only cast a 62 damage Death Blast here). The cannon's shot comes from a level 1
-- invisible trigger, and 42576 cast by that trigger missed a level 40 Tethyr (Four 2026-11-20: cannons did
-- nothing), so Tethyr casts 42576 on himself: self casts never miss, and its nearby-entry target is him. Tethyr dies: Mills cheers and completes
-- the quest for players within 100 yd, the marksmen fire fireworks and leave. Five marksmen dead: the
-- quest fails for players within 90 yd and everything despawns.

-- Without SpecialFlags 2 (event) a quest with no objectives is complete the moment it is accepted.
UPDATE `quest_template_addon` SET `SpecialFlags`=`SpecialFlags`|2 WHERE `ID`=27222;
-- TDB's faction for Tethyr (the marksmen are 1770); ours had 7.
UPDATE `creature_template` SET `faction`=1771, `AIName`='SmartAI' WHERE `entry`=23899;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (23900,23905);

-- Leftover summons from a sniff, not in TDB (the event summons both): a static Tethyr wandering at the
-- docks (guid 307657) and a static marksman (guid 307658). Not tied to the quest (no starter, ender or
-- objective); the quest's Tethyr is the summoned one.
DELETE FROM `creature` WHERE (`guid`,`id`) IN ((307657,23899),(307658,23900));
DELETE FROM `creature_addon` WHERE `guid` IN (307657,307658);

-- Major Mills
DELETE FROM `smart_scripts` WHERE `entryorguid`=23905 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=2390500 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23905,0,0,0,19,0,100,0,27222,0,0,0,0,'',80,2390500,2,0,0,0,0,1,0,0,0,0,0,0,0,'Major Mills - On Quest Take Down Tethyr! Accepted - Run Event'),
(23905,0,1,2,38,0,100,0,0,1,0,0,0,'',1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Major Mills - On Data 0 1 Set (Tethyr dead) - Say Line 3'),
(23905,0,2,0,61,0,100,0,0,0,0,0,0,'',15,27222,0,0,0,0,0,18,100,0,0,0,0,0,0,'Major Mills - On Data 0 1 Set (Tethyr dead) - Complete Take Down Tethyr! for Players in 100 yd'),
(2390500,9,0,0,0,0,100,0,2000,2000,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Major Mills - Take Down Tethyr - Say Line 0'),
(2390500,9,1,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3904.77,-4635.09,9.62735,5.49334,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,2,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3856.59,-4622.45,9.24753,3.87856,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,3,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3917.6,-4648.53,9.32604,5.56795,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,4,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3890.48,-4620.7,9.55527,4.99383,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,5,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3865.94,-4617.2,9.26262,4.16523,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,6,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3834.8,-4645.41,9.25827,3.61152,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,7,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3826.61,-4655.32,9.21484,3.13243,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,8,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3830.76,-4673.74,9.50962,2.70832,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,9,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3843.65,-4687.59,9.6436,2.43735,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,10,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3858.49,-4703.49,9.17411,2.33525,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,11,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3851.97,-4697.24,9.36834,2.33525,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,12,0,0,0,100,0,0,0,0,0,0,'',12,23900,1,900000,0,0,0,8,0,0,0,-3924.35,-4656.55,9.15409,5.80749,'Major Mills - Take Down Tethyr - Summon Theramore Marksman'),
(2390500,9,13,0,0,0,100,0,0,0,0,0,0,'',12,23899,1,900000,0,0,0,8,0,0,0,-3897.37,-4750.63,-1.71901,1.79105,'Major Mills - Take Down Tethyr - Summon Tethyr'),
(2390500,9,14,0,0,0,100,0,6000,6000,0,0,0,'',1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Major Mills - Take Down Tethyr - Say Line 1'),
(2390500,9,15,0,0,0,100,0,10000,10000,0,0,0,'',1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Major Mills - Take Down Tethyr - Say Line 2');

-- Tethyr (summoned; swims to waypoint 1 of path 23899, already in waypoints)
DELETE FROM `smart_scripts` WHERE `entryorguid`=23899 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (2389900,2389901) AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23899,0,0,0,54,0,100,0,0,0,0,0,0,'',80,2389900,2,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Just Summoned - Run Swim In'),
(23899,0,1,0,54,0,100,0,0,0,0,0,0,'',48,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Just Summoned - Set Active'),
(23899,0,2,3,40,0,100,0,1,23899,0,0,0,'',101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On Waypoint 1 Reached - Set Home Position'),
(23899,0,3,10,61,0,100,0,0,0,0,0,0,'',19,128,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On Waypoint 1 Reached - Remove Unit Flag Not Attackable'),
(23899,0,10,11,61,0,100,0,0,0,0,0,0,'',103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On Waypoint 1 Reached - Root (stays in the water)'),
(23899,0,11,0,61,0,100,0,0,0,0,0,0,'',8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On Waypoint 1 Reached - Set Aggressive (fights back)'),
(23899,0,4,0,0,0,100,0,3000,3000,7000,7000,0,'',11,42584,0,0,0,0,0,2,0,0,0,0,0,0,0,'Tethyr - In Combat - Cast Spout'),
(23899,0,5,0,0,0,100,0,2000,2000,4000,5000,0,'',11,42574,0,0,0,0,0,5,0,0,0,0,0,0,0,'Tethyr - In Combat - Cast Water Bolt'),
(23899,0,6,0,8,0,100,0,42578,0,0,0,0,'',11,42576,2,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On Cannon Blast Hit - Cast Cannon Blast (10% health) on Self'),
(23899,0,7,8,6,0,100,0,0,0,0,0,0,'',45,0,1,0,0,0,0,10,255200,23905,0,0,0,0,0,'Tethyr - On Death - Set Data 0 1 on Major Mills'),
(23899,0,8,0,61,0,100,0,0,0,0,0,0,'',45,0,1,0,0,0,0,11,23900,80,0,0,0,0,0,'Tethyr - On Death - Set Data 0 1 on Theramore Marksmen'),
(23899,0,9,0,23,0,100,1,52500,5,0,0,0,'',80,2389901,2,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - On 5 Marksmen Dead - Run Fail'),
(2389900,9,0,0,0,0,100,0,0,0,0,0,0,'',53,0,23899,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Swim In - Start Waypoint'),
(2389900,9,1,0,0,0,100,0,0,0,0,0,0,'',102,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Swim In - Health Regen Off'),
(2389900,9,2,0,0,0,100,0,0,0,0,0,0,'',18,128,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Swim In - Add Unit Flag Not Attackable'),
(2389901,9,0,0,0,0,100,0,0,0,0,0,0,'',6,27222,0,0,0,0,0,18,90,0,0,0,0,0,0,'Tethyr - Fail - Fail Take Down Tethyr! for Players in 90 yd'),
(2389901,9,1,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,11,23900,80,0,0,0,0,0,'Tethyr - Fail - Despawn Theramore Marksmen'),
(2389901,9,2,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Tethyr - Fail - Despawn');

-- Theramore Marksman (already had TDB's script; the victory list 2390001 was already there too)
DELETE FROM `smart_scripts` WHERE `entryorguid`=23900 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23900,0,0,0,38,0,100,0,0,1,0,0,0,'',80,2390001,2,0,0,0,0,1,0,0,0,0,0,0,0,'Theramore Marksman - On Data 0 1 Set (Tethyr dead) - Run Fireworks'),
(23900,0,1,0,54,0,100,1,0,0,0,0,0,'',80,2390000,2,0,0,0,0,1,0,0,0,0,0,0,0,'Theramore Marksman - Just Summoned - Run Form Up'),
(23900,0,2,0,1,0,100,0,3000,3000,2000,2000,0,'',11,42580,0,0,0,0,0,19,23899,80,0,0,0,0,0,'Theramore Marksman - Out of Combat - Shoot Tethyr'),
(23900,0,3,0,0,0,100,0,3000,3000,2000,2000,0,'',11,42580,0,0,0,0,0,19,23899,80,0,0,0,0,0,'Theramore Marksman - In Combat - Shoot Tethyr'),
(23900,0,4,0,6,0,100,0,0,0,0,0,0,'',75,52500,0,0,0,0,0,19,23899,80,0,0,0,0,0,'Theramore Marksman - On Death - Add Counter to Tethyr');
