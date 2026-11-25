-- Wing Commander Dabir'ee 19409 (Honor Hold, menu 7970) offered "I'm on a bombing mission for Forward Commander
-- Kingston" to everyone. Option 0 is the real one (shown only on Mission: The Murketh and Shaadraz Gateways 10146,
-- SAI casts 33768). Option 3 is an old copy of it with no condition and no script. TDB 8.3.7 keeps option 3 hidden
-- (OptionType 0, OptionNpcFlag 0), like the hidden Shatter Point copy option 2. Kept, now hidden the same way.
UPDATE `gossip_menu_option` SET `OptionType`=0, `OptionNpcFlag`=0 WHERE `MenuId`=7970 AND `OptionIndex`=3;

-- Horde twin: Wing Commander Brack 19401 (menu 7967) option 1 "Send me to the Abyssal Shelf!" had no condition,
-- so it showed for everyone. TDB 8.3.7 shows it only on Return to the Abyssal Shelf 10347 (option 0 is for 10162).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=7967 AND `SourceEntry`=1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,7967,1,0,0,9,0,10347,0,0,0,0,0,'','Wing Commander Brack - Show gossip option 1 if player has Quest 10347 "Return to the Abyssal Shelf"');
