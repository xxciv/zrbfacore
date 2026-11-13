-- Dire Maul, Gordok Commons (map 429): Knot Thimblejack 14338 offers "The Gordok Ogre Suit" twice.
--
-- Found (Four, 2026-11-13): Knot lists two quests with the same name side by side.
-- Cause: 27119 is the first-time quest (story text, XP) and 27120 the repeat version (no text, no XP).
-- Both reward the Gordok Ogre Suit 18258 for one Ogre Tannin 18240, but nothing ties 27120 to 27119
-- and 27120 is not repeatable, so both show at once and each can only be done once.
--
-- Changed: 27120 needs 27119 turned in first (PrevQuestID) and is repeatable (SpecialFlags |= 1), like
-- the classic pair 5518/5519. Their empty turn-in and progress texts are copied from Pandaria 5.4.8.

UPDATE `quest_template_addon` SET `PrevQuestID` = 27119, `SpecialFlags` = `SpecialFlags` | 1 WHERE `ID` = 27120;

DELETE FROM `quest_offer_reward` WHERE `ID` IN (27119, 27120);
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`, `VerifiedBuild`) VALUES
(27119, 'Yeah, this will do the trick.  Just a slip here, and tuck here... heh - this is going to work out just fine!   Here you go, you''re all set.  Remember- this isn''t the most securely fashioned item in the world.  You''ll have ten minutes of use before it falls apart, and then you''re not going to fool anybody!  Try using it just before you approach him to make sure it lasts as long as you''re going to need it. ', 0),
(27120, 'Here ya go $n - put this thing on, and you''ll have ten minutes to do whatever.  Good luck! Oh, and if you happen to find a key to get me out of here, BY ALL MEANS LET ME KNOW!!! ', 0);

DELETE FROM `quest_request_items` WHERE `ID` = 27119;
INSERT INTO `quest_request_items` (`ID`, `CompletionText`, `VerifiedBuild`) VALUES
(27119, 'Just get me that Ogre Tannin, and I''ll whip you up an ogre suit that will fool Captain Kromcrush into thinking you''re one of his men. ', 0);

SELECT CONCAT('27120 PrevQuestID ', `PrevQuestID`, ', repeatable ', `SpecialFlags` & 1,
              ', reward texts ', (SELECT COUNT(*) FROM `quest_offer_reward` WHERE `ID` IN (27119, 27120))) AS `check`
FROM `quest_template_addon` WHERE `ID` = 27120;
