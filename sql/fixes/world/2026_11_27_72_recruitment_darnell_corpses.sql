-- Recruitment (26800, Forsaken, Deathknell): click 6 Scarlet Corpses 49340; Darnell 49337 follows you and carries them.
-- 1) Darnell never came: Deathguard Saltain 1740 runs action list 174001 on accept and 174000 on reward, but both
--    lists were missing. Added from TDB 8.3.7: on accept the player casts Summon Darnell 91938 after 3 s; on reward
--    Darnell and nearby corpses despawn. (Subject Nine's own accept row never fires: the quest isn't taken from him.)
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (174000,174001) AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(174001,9,0,0,0,0,100,0,3000,3000,0,0,0,'',85,91938,0,0,0,0,0,7,0,0,0,0,0,0,0,'Saltain - Action list - Invoker casts Summon Darnell'),
(174000,9,0,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,19,49337,20,0,0,0,0,0,'Saltain - Action list - Despawn Darnell'),
(174000,9,1,0,0,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,11,49340,20,0,0,0,0,0,'Saltain - Action list - Despawn carried corpses');

-- 2) A corpse could be clicked again and again for credit: its chain was credit -> "enter vehicle" (action 62 is
--    TELEPORT, with a guid target that doesn't exist) -> despawn, and the broken middle row stopped the chain.
--    New chain: credit -> no more clicks (remove spellclick flag) -> ride Darnell (Ride Vehicle Hardcoded 46598,
--    as in TDB) -> despawn after 5 s. Credit stays on the click (TDB's credit path, Darnell's cross-cast, is not used).
DELETE FROM `smart_scripts` WHERE `entryorguid`=49340 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(49340,0,0,1,73,0,100,0,0,0,0,0,0,'',33,49340,0,0,0,0,0,7,0,0,0,0,0,0,0,'Scarlet Corpse - On Spellclick - Quest Credit'),
(49340,0,1,2,61,0,100,0,0,0,0,0,0,'',83,16777216,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scarlet Corpse - Linked - Remove Spellclick Flag'),
(49340,0,2,3,61,0,100,0,0,0,0,0,0,'',11,46598,2,0,0,0,0,19,49337,20,0,0,0,0,0,'Scarlet Corpse - Linked - Ride Darnell'),
(49340,0,3,0,61,0,100,0,0,0,0,0,0,'',41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Scarlet Corpse - Linked - Despawn after 5 s');
