-- Darkmoon Faire: Game Token vendors sell one pouch and one sack (zrbfacore)
--
-- From Four, 2026-11-07: the vendors sold the same two bags at six price tiers each, so the
-- cheapest pair was always the best deal. Four chose to keep only the most expensive pair:
-- Pouch o' Tokens 78903 (5 tokens, 60 silver) and Sack o' Tokens 78909 (20 tokens, 1 gold 92 silver).
-- After 2026_11_07_04 (which removed the empty 78904 and 78910).
DELETE FROM `npc_vendor` WHERE `entry` IN (55264, 55266, 55339)
  AND `item` IN (78897, 78898, 78899, 78900, 78901, 78902, 78904, 78905, 78906, 78907, 78908, 78910);
