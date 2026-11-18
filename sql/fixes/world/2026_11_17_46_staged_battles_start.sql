-- World fixes: staged battle pairs that stand still start fighting (2026-11-17)
-- Four: Sentinel Hill Guard 735401039 and Riverpaw Brute 735401030 stand 3 yards apart and never fight.
-- Creatures only notice each other when one of them moves, so a pair where both stand still (8.3.7
-- positions and stillness) never starts. Same at the Orgrimmar gate in Azshara (16 Talrendis Raiders)
-- and a few pairs in the Ruins of Gilneas. Our own tuning: out of combat, every 2-4 s, the attacking
-- side attacks the closest living opponent within 8 yards. Safe to run twice.
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND ((`entryorguid` IN (54371,54372,54373,35177,45535,45532) AND `id`=10) OR (`entryorguid`=45375 AND `id` IN (10,11)));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`comment`) VALUES
(54371,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,42407,8,0,'Riverpaw Bandit - OOC - Attack closest Sentinel Hill Guard within 8 yards'),
(54372,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,42407,8,0,'Riverpaw Brute - OOC - Attack closest Sentinel Hill Guard within 8 yards'),
(54373,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,42407,8,0,'Riverpaw Herbalist - OOC - Attack closest Sentinel Hill Guard within 8 yards'),
(35177,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,35190,8,0,'Talrendis Raider - OOC - Attack closest Orgrimmar Gatekeeper within 8 yards'),
(45375,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,45532,8,0,'Worgen Rusher - OOC - Attack closest Forsaken Vanguard within 8 yards'),
(45375,0,11,0,1,0,100,0,1500,3500,2000,4000,49,0,19,45533,8,0,'Worgen Rusher - OOC - Attack closest Forsaken Catapult within 8 yards'),
(45535,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,45280,8,0,'Worgen Rusher - OOC - Attack closest Forsaken Vanguard within 8 yards'),
(45532,0,10,0,1,0,100,0,1000,3000,2000,4000,49,0,19,45539,8,0,'Forsaken Vanguard - OOC - Attack closest 7th Legion Submariner within 8 yards');
