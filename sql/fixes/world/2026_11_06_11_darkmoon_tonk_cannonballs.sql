-- zrbfacore: Tonk Commander enemies fire back. Four, 2026-11-06: enemy tonks and MiniZeps
-- never attacked; asked for a 25% chance every 3-4 seconds, a hit costing 1 point. Each Enemy
-- Tonk (54642) and MiniZep (54643) has a 25% chance every 3-4 s to fire Cannon Blast (102227)
-- at the nearest player tonk (54588) within 40 yards. spell_darkmoon_enemy_tonk_cannon_blast
-- (darkmoon-faire-gossip.patch) stuns a tonk within 4 yd of the landing spot for 2 s and
-- takes 1 Tonk Target credit off its driver (quest 29434, while incomplete).
-- Safe to run more than once.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (54642,54643) AND `source_type`=0 AND `id`=3;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(54642,0,3,0,1,0,25,0,3000,4000,3000,4000,0,'',11,102227,0,0,0,0,0,19,54588,40,0,0,0,0,0,'Enemy Tonk - OOC every 3-4 s (25%) - Cast Cannon Blast at nearest player tonk'),
(54643,0,3,0,1,0,25,0,3000,4000,3000,4000,0,'',11,102227,0,0,0,0,0,19,54588,40,0,0,0,0,0,'Enemy MiniZep - OOC every 3-4 s (25%) - Cast Cannon Blast at nearest player tonk');

DELETE FROM `spell_script_names` WHERE `spell_id`=102227 AND `ScriptName`='spell_darkmoon_enemy_tonk_cannon_blast';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (102227,'spell_darkmoon_enemy_tonk_cannon_blast');
