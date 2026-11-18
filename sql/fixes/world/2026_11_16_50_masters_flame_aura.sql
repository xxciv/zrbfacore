-- The Wandering Isle: "The Master's Flame" stays on the player forever (Four, 2026-11-16)
-- The Lesson of the Burning Scroll 29408 puts The Master's Flame (114610, infinite duration, dummy aura + credit 59591)
-- on the player; nothing removed it, so it stayed through relogs and later quests.
-- Master Shang Xi 53566 now takes the flame back when 29408 is turned in.
DELETE FROM `smart_scripts` WHERE `entryorguid`=53566 AND `source_type`=0 AND `id` IN (10,11,12);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(53566,0,10,0,20,0,100,0,29408,0,0,0,0,'',28,114610,0,0,0,0,0,7,0,0,0,0,0,0,0,'Master Shang Xi - On Quest 29408 Rewarded - Remove The Master''s Flame from invoker'),
(53566,0,11,0,20,0,100,0,29408,0,0,0,0,'',28,114613,0,0,0,0,0,7,0,0,0,0,0,0,0,'Master Shang Xi - On Quest 29408 Rewarded - Remove The Master''s Flame, Cosmetic from invoker'),
(53566,0,12,0,20,0,100,0,29408,0,0,0,0,'',28,114746,0,0,0,0,0,7,0,0,0,0,0,0,0,'Master Shang Xi - On Quest 29408 Rewarded - Remove Snatch Master''s Flame from invoker');
