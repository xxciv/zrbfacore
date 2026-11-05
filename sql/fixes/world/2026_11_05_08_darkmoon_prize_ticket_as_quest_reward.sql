-- zrbfacore: Darkmoon Game Prize hung the client (Four, 2026-11-05)
--
-- 2026_11_05_07 put the Darkmoon Prize Ticket (currency 515) into the Darkmoon Game Prize
-- (93724) as a currency loot row. This core can't hand currency out of an item's loot
-- window (the client greys the box out and hangs). Take that row out again and give the
-- ticket as the quest's currency reward instead, as the Pandaria 5.4.8 DB does
-- (RewardCurrencyId1 515, count 1 on the Faire game dailies).
DELETE FROM `item_loot_template` WHERE `Entry`=93724 AND `Item`=-515;

-- Every quest whose reward is the Darkmoon Game Prize: the five game dailies (29434 Tonk
-- Commander, 29436 Humanoid Cannonball, 29438 He Shoots He Scores, 29455 Target: Turtle,
-- 29463 It's Hammer Time), 36481 Firebird's Challenge and the races 37819, 37910, 37911.
UPDATE `quest_template` SET `RewardCurrencyID1`=515, `RewardCurrencyQty1`=1
WHERE `ID` IN (29434, 29436, 29438, 29455, 29463, 36481, 37819, 37910, 37911) AND `RewardCurrencyID1`=0;
