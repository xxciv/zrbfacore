-- Fizzled (25260, Durotar): Fizzle's Orb 52580 stayed in the bags after turn-in.
-- Fizzle Darkclaw 3203 handed out extra orbs: every right-click (gossip hello) made the player cast
-- 74024 "Remove Fizzle's Hand" (creates 52580), and picking "<Attempt to remove the orb.>" both cast it
-- and added another 52580. The turn-in takes only the 1 the quest asks for, so the rest stayed.
-- Now: only the option gives the orb (the player casts 74024 once), and only while 25260 is in
-- progress and the player has no orb yet.
DELETE FROM `smart_scripts` WHERE `entryorguid`=3203 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3203,0,0,1,62,0,100,0,11240,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Fizzle Darkclaw - Gossip option 0 - Close gossip'),
(3203,0,1,0,61,0,100,0,0,0,0,0,'',85,74024,2,0,0,0,0,7,0,0,0,0,0,0,0,'Fizzle Darkclaw - Linked - Player casts Remove Fizzle''s Hand (gives Fizzle''s Orb)');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=11240;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11240,0,0,0,9,0,25260,0,0,0,0,0,'','Fizzle Darkclaw - orb option only while Fizzled is in progress'),
(15,11240,0,0,0,2,0,52580,1,1,1,0,0,'','Fizzle Darkclaw - orb option only without Fizzle''s Orb (bank included)');
