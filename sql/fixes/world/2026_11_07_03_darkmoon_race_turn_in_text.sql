-- Darkmoon races: turn-in text (zrbfacore)
--
-- From Four, 2026-11-07: turning in Let's Keep Racing! and More Big Racing! showed an empty page.
-- None of the five race quests had a quest_offer_reward row. Texts from Wowhead's quest pages.
-- The practice runs (33756, 37868) have no reward on retail either; the other three already give
-- the Darkmoon Game Prize and Darkmoon Faire reputation from quest_template.
DELETE FROM `quest_offer_reward` WHERE `ID` IN (37819, 37910, 33756, 37868, 37911);
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(37819,0,0,0,0,0,0,0,0,'You made it! This is just a practice race so your time doesn''t matter... other than bragging rights.$B$BTime to try the real race!',0),
(37910,0,0,0,0,0,0,0,0,'Good job, and nice time!',0),
(33756,0,0,0,0,0,0,0,0,'Good job, and nice time!',0),
(37868,0,0,0,0,0,0,0,0,'Good job, and nice time!',0),
(37911,0,0,0,0,0,0,0,0,'Good job, and nice time!',0);
