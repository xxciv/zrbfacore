-- The Wandering Isle: Master Shang Xi 53566 hands out The Master's Flame on every visit (Four, 2026-11-16)
-- 1) His "on gossip hello" SmartAI row made every visitor cast Create The Master's Flame (114611) on every quest accept
--    or turn-in, long after The Lesson of the Burning Scroll (29408). It also shared id 0 with another row and linked to
--    a row that isn't a link event. Re-added as its own row that only fires while 29408 is in the quest log and the
--    flame item (80212) isn't in the bags.
-- 2) He had a click spell (Snatch Master's Flame 114746) and the spell-click npcflag on top of his quest flags. Clicking
--    him ran that spell every time, and he is a vehicle (VehicleId 1416), so the player ended up on him.
--    The quest doesn't need it (the flame comes from the gossip row above, the credit from his quest-accept row).
--    TDB 8.3.7 has no click spell and npcflag 3 (gossip + quest giver); use that.
UPDATE `creature_template` SET `npcflag`=3 WHERE `entry`=53566;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=53566;
DELETE FROM `smart_scripts` WHERE `entryorguid`=53566 AND `source_type`=0 AND `event_type`=64;
DELETE FROM `smart_scripts` WHERE `entryorguid`=53566 AND `source_type`=0 AND `id`=13;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(53566,0,13,0,64,0,100,0,0,0,0,0,0,'',85,114611,0,0,0,0,0,7,0,0,0,0,0,0,0,'Master Shang Xi - On Gossip Hello - Invoker Cast Create The Master''s Flame (only on 29408, no flame yet)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=14 AND `SourceEntry`=53566 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,14,53566,0,0,9,0,29408,0,0,0,0,0,'','Master Shang Xi - flame only while The Lesson of the Burning Scroll is taken'),
(22,14,53566,0,0,2,0,80212,1,0,1,0,0,'','Master Shang Xi - flame only without The Master''s Flame item');
