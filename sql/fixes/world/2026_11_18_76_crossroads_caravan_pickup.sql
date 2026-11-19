-- Crossroads Caravan Pickup (13949, Northern Barrens): the caravan stopped, an invisible Razormane
-- Raider killed the kodo, and the player could not fight back.
-- Causes:
-- * Razormane Raider 34487 woke up on event 79 (SCENE_TRIGGER in this core; distance-to-creature is
--   75), so they never dropped Quest Invisibility 65050. They kept their hostile template faction 109
--   while invisible and attacked the caravan and players from stealth.
-- * Lead Caravan Kodo 34430 (the player's vehicle): attackable, so a raider pulled it into combat and
--   the escort stopped; WP start was sent twice; the arrival rows (credit 53613, despawns) were never
--   linked to any event, so the quest could not complete on arrival.
-- * Far Watch Caravan Kodo 34432 (the pack kodo the raiders go for) never followed the lead kodo.
-- * Halga Bloodeye 34258's send-off line was in Spanish and was said by the kodo (talk target invoker).
-- The player fights with Halga's "Street Sweeper" 46714 (use: Shoot 65479, castable on a vehicle).

-- Raiders: invisible and friendly until the pack kodo comes within 20 yd, then visible, hostile and
-- attacking it; they give up (evade, back to invisible) within 90 yd of the Captured Razormane near the end.
DELETE FROM `smart_scripts` WHERE `entryorguid`=34487 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34487,0,0,1,25,0,100,0,0,0,0,0,'',117,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Reset - Disable evade'),
(34487,0,1,2,61,0,100,0,0,0,0,0,'',11,65050,2,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Linked - Cast Quest Invisibility 1'),
(34487,0,2,0,61,0,100,0,0,0,0,0,'',2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Linked - Friendly while hidden'),
(34487,0,3,4,75,0,100,0,0,34432,20,2000,'',2,109,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Pack kodo within 20 yd - Turn hostile'),
(34487,0,4,5,61,0,100,0,0,0,0,0,'',28,65050,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Linked - Remove Quest Invisibility 1'),
(34487,0,5,0,61,0,100,0,0,0,0,0,'',49,0,0,0,0,0,0,19,34432,20,0,0,0,0,0,'Razormane Raider - Linked - Attack the pack kodo'),
(34487,0,6,7,75,0,100,0,0,34523,90,2000,'',117,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Captured Razormane within 90 yd - Enable evade'),
(34487,0,7,0,61,0,100,0,0,0,0,0,'',24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Razormane Raider - Linked - Evade');

-- Lead Caravan Kodo: one WP start, cannot be attacked, credit + cleanup at the end of the path.
DELETE FROM `smart_scripts` WHERE `entryorguid`=34430 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34430,0,0,1,54,0,100,0,0,0,0,0,'',11,65494,2,0,0,0,0,1,0,0,0,0,0,0,0,'Lead Caravan Kodo - Just summoned - Cast Call a Pack Kodo'),
(34430,0,1,2,61,0,100,0,0,0,0,0,'',45,1,1,0,0,0,0,19,34258,30,0,0,0,0,0,'Lead Caravan Kodo - Linked - Tell Halga Bloodeye to send us off'),
(34430,0,2,3,61,0,100,0,0,0,0,0,'',18,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lead Caravan Kodo - Linked - Not attackable'),
(34430,0,3,0,61,0,100,0,0,0,0,0,'',53,1,34430,0,0,0,0,1,0,0,0,0,0,0,0,'Lead Caravan Kodo - Linked - Start path 34430'),
(34430,0,4,0,60,0,100,0,1000,1000,1000,1000,'',101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lead Caravan Kodo - Update - Set home'),
(34430,0,5,6,58,0,100,0,0,34430,0,0,'',33,53613,0,0,0,0,0,23,0,0,0,0,0,0,0,'Lead Caravan Kodo - Path ended - Quest credit to the rider'),
(34430,0,6,7,61,0,100,0,0,0,0,0,'',41,0,0,0,0,0,0,11,34432,40,0,0,0,0,0,'Lead Caravan Kodo - Linked - Despawn the pack kodo'),
(34430,0,7,0,61,0,100,0,0,0,0,0,'',41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Lead Caravan Kodo - Linked - Despawn (drops the rider)');

-- Pack kodo follows the lead kodo.
DELETE FROM `smart_scripts` WHERE `entryorguid`=34432 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34432,0,0,1,54,0,100,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Far Watch Caravan Kodo - Just summoned - Passive'),
(34432,0,1,0,61,0,100,0,0,0,0,0,'',29,5,0,0,0,0,0,23,0,0,0,0,0,0,0,'Far Watch Caravan Kodo - Linked - Follow the lead kodo');

-- Halga says her own line (was said by the kodo, and in Spanish).
UPDATE `smart_scripts` SET `target_type`=1 WHERE `entryorguid`=34258 AND `source_type`=0 AND `id`=1;
UPDATE `creature_text` SET `Text`='Move out! Get those supplies to the Crossroads!' WHERE `CreatureID`=34258 AND `GroupID`=0 AND `ID`=0;
