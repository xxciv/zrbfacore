-- See Raptor (26773, Northern Stranglethorn): Priestess Thaalia 44017's "I am ready for the Mind Vision
-- ritual" did nothing. The ritual was never scripted; the spells for it are in the game data:
--   79845 See Raptor: Teleport In (into Zul'Gurub, -12161.7 -1818.5 94.0)
--   79834 See Raptor: Summon Raptor (Captured Lashtail Hatchling 42840, vehicle 926, passenger hidden
--         and not selectable, so the Gurubashi ignore you)
--   79838 See Raptor: Summon Mandokir (Bloodlord Mandokir 42842, in front of the caster)
--   82399 See Raptor: Teleport Out A (back to Thaalia, removes the Mind Vision/Mind Control auras)
-- Scene built from those: you are sent into Zul'Gurub inside the hatchling, Mandokir comes to look at
-- it, you get the credit (42840) and return to Thaalia. Mandokir's lines are the original ones as quoted on warcraft.wiki.gg (See Raptor);
-- Thaalia's line is our own wording.

-- 79834 summons at a database destination that had no row.
DELETE FROM `spell_target_position` WHERE `ID`=79834;
INSERT INTO `spell_target_position` (`ID`,`EffectIndex`,`MapID`,`PositionX`,`PositionY`,`PositionZ`,`VerifiedBuild`) VALUES
(79834,0,0,-12161.7,-1818.5,94.0228,0);

DELETE FROM `creature_text` WHERE (`CreatureID`=44017 AND `GroupID`=0) OR `CreatureID`=42842;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(44017,0,0,'Close your eyes, $n. Priestess sends your mind to the little raptor, yes. Watch, and remember.',12,0,100,0,0,0,0,0,'Priestess Thaalia - Mind Vision ritual'),
(42842,0,0,'Welcome to Zul''Gurub, little one. It might not look like much now, but give it time.',12,0,100,0,0,0,0,0,'Bloodlord Mandokir - See Raptor 0'),
(42842,1,0,'Ahh... it''s good to be home.',12,0,100,0,0,0,0,0,'Bloodlord Mandokir - See Raptor 1'),
(42842,2,0,'There''s plenty others of your kind here, but I wouldn''t worry about competition. You''re from the bloodline of Ohgan, my oldest friend...',12,0,100,0,0,0,0,0,'Bloodlord Mandokir - See Raptor 2'),
(42842,3,0,'Here we are. Get ready for your training, little one. I recommend you forget about that worthless $r $c...',12,0,100,0,0,0,0,0,'Bloodlord Mandokir - See Raptor 3');

-- Thaalia: Mind Vision option -> close, speak, send the player in, then put them in the hatchling.
-- She is made an active object for the ritual: once the player is teleported away nobody is near her,
-- her grid cell stops updating and the timed event never fired (first test: player left standing in
-- Zul'Gurub as themselves). The player is also made immune to NPCs (0x200) for the short wait, so the
-- Gurubashi leave them alone before the hatchling arrives; the hatchling clears it again.
DELETE FROM `smart_scripts` WHERE `entryorguid`=44017 AND `source_type`=0 AND `id` BETWEEN 0 AND 9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(44017,0,0,1,62,0,100,0,11785,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Priestess Thaalia - Mind Vision option - Close gossip'),
(44017,0,1,2,61,0,100,0,0,0,0,0,'',1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - Say ritual line'),
(44017,0,2,3,61,0,100,0,0,0,0,0,'',18,512,0,0,0,0,0,7,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - Player immune to NPCs until the hatchling has them'),
(44017,0,3,4,61,0,100,0,0,0,0,0,'',48,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - Stay active while the player is away'),
(44017,0,4,5,61,0,100,0,0,0,0,0,'',85,79845,2,0,0,0,0,7,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - Player casts See Raptor: Teleport In'),
(44017,0,5,0,61,0,100,0,0,0,0,0,'',67,1,2500,2500,0,0,100,1,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - In 2.5 s, put the player in the hatchling'),
(44017,0,6,7,59,0,100,0,1,0,0,0,'',85,79834,2,0,0,0,0,7,0,0,0,0,0,0,0,'Priestess Thaalia - Timed 1 - Player casts See Raptor: Summon Raptor (rides it)'),
(44017,0,7,0,61,0,100,0,0,0,0,0,'',48,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Priestess Thaalia - Linked - No longer active');

-- Hatchling 42840: Mandokir arrives; when he is done, credit and send the player home.
-- The summon gives it the player's faction, which the Gurubashi attack; it goes back to its own
-- friendly faction 35 and is immune to NPCs for the scene.
DELETE FROM `smart_scripts` WHERE `entryorguid`=42840 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42840,0,0,9,27,0,100,0,0,0,0,0,'',67,1,4000,4000,0,0,100,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Player boarded - Mandokir in 4 s'),
(42840,0,9,10,61,0,100,0,0,0,0,0,'',2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Friendly faction'),
(42840,0,10,0,61,0,100,0,0,0,0,0,'',18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Immune to NPCs'),
(42840,0,1,0,59,0,100,0,1,0,0,0,'',11,79838,2,0,0,0,0,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Timed 1 - Summon Bloodlord Mandokir'),
(42840,0,2,3,38,0,100,0,1,1,0,0,'',33,42840,0,0,0,0,0,23,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Mandokir done - See Raptor credit to the player'),
(42840,0,3,4,61,0,100,0,0,0,0,0,'',11,82399,2,0,0,0,0,23,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Send the player back to Thaalia'),
(42840,0,4,5,61,0,100,0,0,0,0,0,'',41,1000,0,0,0,0,0,11,42842,60,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Despawn Mandokir'),
(42840,0,5,0,61,0,100,0,0,0,0,0,'',41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Despawn'),
(42840,0,6,11,28,0,100,0,0,0,0,0,'',19,512,0,0,0,0,0,7,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Player left - Clear their NPC immunity'),
(42840,0,11,7,61,0,100,0,0,0,0,0,'',11,82399,2,0,0,0,0,7,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Send them back to Thaalia'),
(42840,0,7,8,61,0,100,0,0,0,0,0,'',41,1000,0,0,0,0,0,11,42842,60,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Despawn Mandokir'),
(42840,0,8,0,61,0,100,0,0,0,0,0,'',41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Captured Lashtail Hatchling - Linked - Despawn');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (42840,42842,44017);

-- Mandokir 42842: looks the hatchling over, then tells it he is done.
DELETE FROM `smart_scripts` WHERE `entryorguid`=42842 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42842,0,0,1,54,0,100,0,0,0,0,0,'',66,0,0,0,0,0,0,23,0,0,0,0,0,0,0,'Bloodlord Mandokir - Just summoned - Face the hatchling'),
(42842,0,1,0,61,0,100,0,0,0,0,0,'',1,0,6000,0,0,0,0,21,20,0,0,0,0,0,0,'Bloodlord Mandokir - Linked - Say 0'),
(42842,0,2,0,52,0,100,0,0,42842,0,0,'',1,1,6000,0,0,0,0,21,20,0,0,0,0,0,0,'Bloodlord Mandokir - Text 0 over - Say 1'),
(42842,0,3,0,52,0,100,0,1,42842,0,0,'',1,2,8000,0,0,0,0,21,20,0,0,0,0,0,0,'Bloodlord Mandokir - Text 1 over - Say 2'),
(42842,0,4,0,52,0,100,0,2,42842,0,0,'',1,3,7000,0,0,0,0,21,20,0,0,0,0,0,0,'Bloodlord Mandokir - Text 2 over - Say 3'),
(42842,0,5,0,52,0,100,0,3,42842,0,0,'',45,1,1,0,0,0,0,23,0,0,0,0,0,0,0,'Bloodlord Mandokir - Text 3 over - Tell the hatchling the scene is over');
