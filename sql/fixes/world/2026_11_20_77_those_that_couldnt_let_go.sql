-- Those That Couldn't Let Go 27168 (Western Plaguelands): reported by Four, 2026-11-20. The Holy Thurible
-- (spell 84375) on a Withdrawn Soul 45166 counted every time on the same soul, which never went away.
-- Cause: our dump's hit script ran credit -> say 0 -> despawn as one linked chain. The Withdrawn Soul has
-- no creature_text, so the say row is dropped at load and the despawn after it never runs; the despawn
-- also targeted the player (invoker) instead of the soul. The rows also reused id 0 (TDB 8.3.7 only has
-- the Spirit Burst row; the credit was ours).
-- Now: on a Holy Thurible hit the player gets credit and the soul despawns 2 s later (normal respawn).
-- A 10 s cooldown on the hit stops a second cast in those 2 s from counting twice.

DELETE FROM `smart_scripts` WHERE `entryorguid`=45166 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45166,0,0,0,0,0,100,0,5000,8000,12000,15000,0,'',11,85424,0,0,0,0,0,2,0,0,0,0,0,0,0,'Withdrawn Soul - In Combat - Cast Spirit Burst'),
(45166,0,1,2,8,0,100,0,84375,0,10000,10000,0,'',33,45166,0,0,0,0,0,7,0,0,0,0,0,0,0,'Withdrawn Soul - On Holy Thurible Hit - Kill Credit to Invoker'),
(45166,0,2,0,61,0,100,0,0,0,0,0,0,'',41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Withdrawn Soul - On Holy Thurible Hit - Despawn in 2 s');
