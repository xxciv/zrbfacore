-- Northern Stranglethorn / Cape of Stranglethorn quest fixes (Four, 2026-11-19).

-- 1) The Mosh'Ogg Bounty was offered twice by Wulfred Harrys 44018: 26782 and 26783 are the same
--    quest (same objective Mosh'Ogg Bounty 58205, same text except "some"/"a"). Keep 26782; 26783 is
--    no longer offered. Wulfred still takes 26783 in, so anyone who already has it can finish it.
--    Both share an exclusive group so only one of them can ever be done.
DELETE FROM `creature_queststarter` WHERE `id`=44018 AND `quest`=26783;
UPDATE `quest_template_addon` SET `ExclusiveGroup`=26782 WHERE `ID` IN (26782,26783);

-- 2) Robert Rhodes 43042 (Fort Livingston flight master): "Wulfred says that he paid for my trip..."
--    showed all the time, and picking it ran a teleport with no target (its SAI listened for menu
--    43042, which does not exist). Now it shows only while To the Cape! 26805 is in progress or
--    complete, and picking it flies the player to the Explorers' League Digsite for free with
--    82504 "Explorer's League Digsite: Taxi Flight" (taxi path 2240, Fort Livingston -> Digsite).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=11791 AND `SourceEntry`=1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11791,1,0,0,47,0,26805,10,0,0,0,0,'','Robert Rhodes - free flight to the Digsite only while To the Cape! is in progress or complete');

DELETE FROM `smart_scripts` WHERE `entryorguid`=43042 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43042,0,0,1,62,0,100,0,11791,1,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Robert Rhodes - Gossip option 1 - Close gossip'),
(43042,0,1,0,61,0,100,0,0,0,0,0,'',85,82504,2,0,0,0,0,7,0,0,0,0,0,0,0,'Robert Rhodes - Linked - Player takes the free flight to the Explorers'' League Digsite');

-- 3) Priestess Thaalia 44017: both ritual options showed all the time. Mind Vision belongs to
--    See Raptor 26773, Mind Control to Be Raptor 26775; each now shows only while its quest is in
--    progress. (What happens after picking them is a separate fix.)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=11785 AND `SourceEntry` IN (0,1);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11785,0,0,0,9,0,26773,0,0,0,0,0,'','Priestess Thaalia - Mind Vision ritual only while See Raptor is in progress'),
(15,11785,1,0,0,9,0,26775,0,0,0,0,0,'','Priestess Thaalia - Mind Control ritual only while Be Raptor is in progress');
