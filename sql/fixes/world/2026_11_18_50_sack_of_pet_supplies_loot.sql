-- Sack of Pet Supplies has contents (zrbfacore, 2026-11-18)
-- Found (Four): the Sack of Pet Supplies (item 89125) from Zunta, The Pet Tamer (quest 31812) opened empty.
-- Cause: item_loot_template has no rows for 89125. The sack is the reward of 42 pet tamer quests
--   (Julia 31316, Zunta 31812, Old MacDonald 31724, Lindsay 31725, Eric Davidson 31726, Bill Buckler
--   31728, Steven Lisbane 31729, Dagra 31813, Analynn 31814, Zonya 31815, Merda 31817, Cassandra Kaboom
--   31870, the Battle Pet Tamers: <continent> quests and the Grand Master tamers), so all of them gave an
--   empty sack.
-- Changed: 13 rows for 89125. Contents from the item's wiki page (warcraft.wiki.gg/wiki/Sack_of_Pet_Supplies),
--   chances copied from the dump's sniffed table for the same items in Darkmoon Pet Supplies 91086:
--     GroupId 1 (exactly one grey pet junk item, 20% each): Rusty Pet Cage 90043, Tattered Collar 90044,
--       Sack of Expired Pet Food 90047, Hair Ball 90057, Well-Loved Toy 90058
--     Rolled on their own: Battle Pet Bandage 86143 47% x2-4, Happy Pet Snack 43626 / Pet Grooming Kit 43352 /
--       Magical Pet Biscuit 71153 / Magical Mini-Treat 89906 11% x2-4 each, Fetch Ball 37431 8%,
--       Exquisite Murloc Leash 90048 1%, Porcupette 89587 (battle pet) 1%.
--   Every sack gives at least the grey item. Item loot is read at startup: restart worldserver afterwards.
DELETE FROM `item_loot_template` WHERE `Entry` = 89125;
INSERT INTO `item_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(89125, 90043, 0, 20, 0, 1, 1, 1, 1, 'Sack of Pet Supplies - Rusty Pet Cage'),
(89125, 90044, 0, 20, 0, 1, 1, 1, 1, 'Sack of Pet Supplies - Tattered Collar'),
(89125, 90047, 0, 20, 0, 1, 1, 1, 1, 'Sack of Pet Supplies - Sack of Expired Pet Food'),
(89125, 90057, 0, 20, 0, 1, 1, 1, 1, 'Sack of Pet Supplies - Hair Ball'),
(89125, 90058, 0, 20, 0, 1, 1, 1, 1, 'Sack of Pet Supplies - Well-Loved Toy'),
(89125, 86143, 0, 47, 0, 1, 0, 2, 4, 'Sack of Pet Supplies - Battle Pet Bandage'),
(89125, 43626, 0, 11, 0, 1, 0, 2, 4, 'Sack of Pet Supplies - Happy Pet Snack'),
(89125, 43352, 0, 11, 0, 1, 0, 2, 4, 'Sack of Pet Supplies - Pet Grooming Kit'),
(89125, 71153, 0, 11, 0, 1, 0, 2, 4, 'Sack of Pet Supplies - Magical Pet Biscuit'),
(89125, 89906, 0, 11, 0, 1, 0, 2, 4, 'Sack of Pet Supplies - Magical Mini-Treat'),
(89125, 37431, 0, 8, 0, 1, 0, 1, 1, 'Sack of Pet Supplies - Fetch Ball'),
(89125, 90048, 0, 1, 0, 1, 0, 1, 1, 'Sack of Pet Supplies - Exquisite Murloc Leash'),
(89125, 89587, 0, 1, 0, 1, 0, 1, 1, 'Sack of Pet Supplies - Porcupette');
SELECT CONCAT(COUNT(*), ' Sack of Pet Supplies loot rows') AS zr_result FROM `item_loot_template` WHERE `Entry` = 89125;
