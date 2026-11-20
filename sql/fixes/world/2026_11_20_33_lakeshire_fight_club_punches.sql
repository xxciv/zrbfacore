-- World fixes: Redridge Mountains, Lakeshire Inn fight club, Big Earl hits back (Four, 2026-11-20)
-- Four (after 2026_11_20_32): "Dumpy vs. Big Earl. Big Earl is just taking it. Never throwing back a punch."
-- Cause: Big Earl (faction 2101) and Keeshan/Dumpy (1934) are enemies. Only Dumpy's script sets him passive, so Big
-- Earl and Keeshan count as engaged and their out-of-combat punch events never run. Big Earl's punches also only
-- targeted Keeshan, who isn't in the Dumpy stage.
-- Our own tuning (TDB 8.3.7 has no script here; these rows build on the dump script):
--   Big Earl 43248 and John J. Keeshan 43184 turn passive on spawn, as Dumpy does.
--   Big Earl also punches Dumpy (rows 5-7, same spells and timers as his Keeshan rows).
--   The knocked-out Big Earl (735401314) and the Keeshan who stands with his crew (735401313) from the last stage get
--   their own short script, so they don't punch: passive, and Big Earl stays lying down.
-- Run after 2026_11_20_32. Safe to run twice.
DELETE FROM `smart_scripts` WHERE `entryorguid`=43248 AND `source_type`=0 AND `id` BETWEEN 4 AND 7;
DELETE FROM `smart_scripts` WHERE `entryorguid`=43184 AND `source_type`=0 AND `id`=6;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-735401313,-735401314) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43248,0,4,0,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Big Earl - On Spawn - Set Passive'),
(43248,0,5,0,1,0,100,0,10000,20000,10000,20000,0,'',11,130490,0,0,0,0,0,19,43249,4,0,0,0,0,0,'Big Earl - OOC - Cosmetic Attack to Dumpy'),
(43248,0,6,0,1,0,100,0,1000,2000,1000,2000,0,'',11,65620,0,0,0,0,0,19,43249,4,0,0,0,0,0,'Big Earl - OOC - Cosmetic Attack Special to Dumpy'),
(43248,0,7,0,1,0,100,0,3000,7000,3000,7000,0,'',11,147299,0,0,0,0,0,19,43249,4,0,0,0,0,0,'Big Earl - OOC - Cosmetic Attack with blood to Dumpy'),
(43184,0,6,0,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'John J. Keeshan - On Spawn - Set Passive'),
(-735401313,0,0,0,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'John J. Keeshan (with his crew) - On Spawn - Set Passive'),
(-735401314,0,0,1,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Big Earl (knocked out) - On Spawn - Set Passive'),
(-735401314,0,1,0,61,0,100,0,0,0,0,0,0,'',90,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'Big Earl (knocked out) - On Spawn - Lie down');
