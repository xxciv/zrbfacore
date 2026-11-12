-- Follow-up to 2026_11_12_40 / 43: the ship's script looked for players near the ship when the server's ship
-- reached the Vashj'ir stop, but the player's client runs behind the server's ship after each map change (Four's
-- client pauses 5-10 seconds loading the new map while the server ship sails on). Four reached the stop about 45
-- seconds after the server's ship, so the search found nobody, and the next map change pulled Four back to Kalimdor.
-- Instead, remember the riders when the ship leaves Orgrimmar (departure event 26515, TaxiPath 2204 node 12, where
-- the client and the server ship are still in step) and act on that list at the Vashj'ir stop (arrival event 25428,
-- node 4) wherever the riders' clients are on the way. The list is cleared after use.
-- Riders who stepped off in Orgrimmar stay on Kalimdor and are not found (the stored list only resolves players on
-- the ship's current map).
DELETE FROM `smart_scripts` WHERE `entryorguid`=203466 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(203466,1,0,0,71,0,100,0,26515,0,0,0,0,'',64,1,0,0,0,0,0,17,0,80,0,0,0,0,0,'Ship to Vashj''ir (Horde) - On leaving Orgrimmar - Store players aboard (phase 170 = on Call of Duty)'),
(203466,1,1,0,71,0,100,0,25428,0,0,0,0,'',62,0,0,0,0,0,0,12,1,0,0,-4608.77,3982.0,-70.4,2.217,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Teleport stored players to Erunak Stonespeaker'),
(203466,1,2,0,71,0,100,0,25428,0,0,0,0,'',33,36901,0,0,0,0,0,12,1,0,0,0,0,0,0,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Quest credit Call of Duty 25924'),
(203466,1,3,0,71,0,100,0,25428,0,0,0,0,'',64,1,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Clear stored players');
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=203466;
