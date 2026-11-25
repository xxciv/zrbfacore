-- World fixes: Runetog Wildhammer (20234, Shatter Point gryphon master), 2026-11-24
-- Four: Wing Commander Dabir'ee sent him to Runetog. Found: our SmartAI for Runetog differs from TDB 8.3.7:
-- accepting Wing Commander Gryphongar (10344) summoned an Enraged Gryphon (action 12, entry 9526) next to the player
-- instead of casting 35237 (the Shatter Point to Beach Head taxi flight to Gryphongar), and the aggro rows summoned
-- the gryphon by entry. Restored 1:1 to TDB 8.3.7: on aggro he casts 14313 (summon Enraged Gryphon) and yells
-- "Guards!"; on accepting 10344 he casts 35237 on the player. Safe to run twice.
DELETE FROM `smart_scripts` WHERE `entryorguid`=20234 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20234,0,0,2,4,0,100,512,0,0,0,0,0,'',11,14313,2,0,0,0,0,1,0,0,0,0,0,0,0,'Runetog Wildhammer - On Aggro - Summon Creature ''Enraged Gryphon'''),
(20234,0,2,0,4,0,100,0,0,0,0,0,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Runetog Wildhammer - On Aggro - Say Line 0'),
(20234,0,3,0,19,0,100,0,10344,0,0,0,0,'',11,35237,0,0,0,0,0,7,0,0,0,0,0,0,0,'Runetog Wildhammer - On Quest accept - Cast spell');
