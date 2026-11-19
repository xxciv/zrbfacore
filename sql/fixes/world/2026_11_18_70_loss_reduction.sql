-- Loss Reduction (25179, Durotar): rescuing Injured Razor Hill Grunts 39270 (Quest Fixes thread, 2026-11-18)
--
-- The quest is "Rescue 4 Injured Razor Hill Grunts": you click the grunt (spellclick 73705), it gets
-- up, thanks you, follows you a short while and leaves. The "speak/interact" cursor is correct.
-- The old SAI was broken: the kill credit was linked behind the "offer quest" row, whose conditions
-- block it once the quest is in your log, so a grunt clicked with the quest from Gar'Thok gave no
-- credit; it also called actionlist 3927000, which does not exist, and mixed links between
-- non-link rows. Rewritten from scratch.

-- feign death from the template instead of a cast on respawn
UPDATE `creature_template_addon` SET `auras`='29266' WHERE `entry`=39270;

DELETE FROM `smart_scripts` WHERE `entryorguid`=39270 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=3927000 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39270,0,0,0,1,0,100,0,5000,20000,30000,60000,0,'',1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - OOC - Say 0 (while lying down)'),
(39270,0,1,0,73,0,100,0,0,0,0,0,0,'',7,25179,1,0,0,0,0,7,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - On Spellclick - Add Quest Loss Reduction (if not taken)'),
(39270,0,2,3,73,0,100,0,0,0,0,0,0,'',28,29266,0,0,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - On Spellclick - Remove Feign Death'),
(39270,0,3,4,61,0,100,0,0,0,0,0,0,'',33,39270,0,0,0,0,0,7,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Kill Credit'),
(39270,0,4,5,61,0,100,0,0,0,0,0,0,'',83,16777216,0,0,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Remove Spellclick Flag'),
(39270,0,5,6,61,0,100,0,0,0,0,0,0,'',1,1,0,0,0,0,0,7,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Say 1'),
(39270,0,6,7,61,0,100,0,0,0,0,0,0,'',29,2,0,0,0,0,0,7,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Follow Invoker'),
(39270,0,7,0,61,0,100,0,0,0,0,0,0,'',67,1,20000,25000,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Timed Event 1'),
(39270,0,8,9,59,0,100,0,1,0,0,0,0,'',1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Timed Event 1 - Say 2'),
(39270,0,9,0,61,0,100,0,0,0,0,0,0,'',41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Link - Despawn in 5 s');

-- SAI conditions: group = id + 1
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=39270 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,39270,0,0,1,1,29266,0,0,0,0,0,'','Injured Razor Hill Grunt - only call for help while lying down'),
(22,2,39270,0,0,47,0,25179,1,0,0,0,0,'','Injured Razor Hill Grunt - add quest only if Loss Reduction is not taken');
