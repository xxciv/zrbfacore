-- zrbfacore: Darkmoon Island fishing loot to match retail (Four, 2026-11-06). Run after
-- 2026_11_06_17, which this replaces for zone 5861. Safe to run more than once.
--
-- Darkmoon Island (zone 5861) had no fishing loot of its own, so every cast used the core's
-- default table (Arctic Char, Bristle Whisker Catfish). These rows come from Wowhead's
-- Darkmoon Island fishing list (Four's CSV, 2026-11-06).
-- * Salty Sea Dog (73269, "Great Sea Herring" on current Wowhead): 29%, only while on
--   Spoilin' for Salty Sea Dogs (29513), on top of the normal catch.
-- * Everything else is one group (one catch per cast). Each item's chance is its share of
--   Wowhead's catch counts (Wowhead's % column adds up to more than 100 because it mixes game
--   versions); Darkmoon Daggermaw (124669, about 54.0%) takes what is left. Catches Wowhead
--   shows at 0% (fewer than 400 of 8 million catches) are left out: Reinforced Locked Chest, Sharp Fangs, Battered Chest, Bonescale Snapper, Deep Sea Monsterbelly, Dented Crate, Heavy Crate, Sealed Crate, Small Chest, Sturdy Locked Chest, Sea Turtle.
-- * The two Sealed Crates (ilvl 32) are the Darkmoon ones, 78930 and 88496; both hold Darkmoon
--   Firewater. Darkmoon Firewater itself is 78883.
-- Not covered here: Sealed Darkmoon Crate (124670), Big-Mouth Clam (7973), Darkwater Clam
-- (36781) and Jaggal Clam (24476) have no contents in our DB, so they open empty.
DELETE FROM `fishing_loot_template` WHERE `Entry`=5861;
INSERT INTO `fishing_loot_template` (`Entry`,`Item`,`Reference`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(5861,73269,0,29,1,1,0,1,1,'Darkmoon Island - Salty Sea Dog (quest 29513)'),
(5861,127141,0,2.498,0,1,1,1,1,'Darkmoon Island - Bloated Thresher'),
(5861,78930,0,2.442,0,1,1,1,1,'Darkmoon Island - Sealed Crate'),
(5861,164973,0,0.464,0,1,1,1,1,'Darkmoon Island - Severed Azurefin Head'),
(5861,164972,0,0.472,0,1,1,1,1,'Darkmoon Island - Severed Crimsonscale Head'),
(5861,35285,0,0.306,0,1,1,1,1,'Darkmoon Island - Giant Sunfish'),
(5861,133688,0,0.246,0,1,1,1,1,'Darkmoon Island - Tugboat Bobber'),
(5861,73953,0,0.202,0,1,1,1,1,'Darkmoon Island - Sea Pony'),
(5861,6354,0,0.103,0,1,1,1,1,'Darkmoon Island - Small Locked Chest'),
(5861,6352,0,0.101,0,1,1,1,1,'Darkmoon Island - Waterlogged Crate'),
(5861,24476,0,0.062,0,1,1,1,1,'Darkmoon Island - Jaggal Clam'),
(5861,35286,0,0.041,0,1,1,1,1,'Darkmoon Island - Bloated Giant Sunfish'),
(5861,93732,0,0.045,0,1,1,1,1,'Darkmoon Island - Darkmoon Fishing Cap'),
(5861,13893,0,0.026,0,1,1,1,1,'Darkmoon Island - Large Raw Mightfish'),
(5861,78883,0,0.014,0,1,1,1,1,'Darkmoon Island - Darkmoon Firewater'),
(5861,6360,0,0.015,0,1,1,1,1,'Darkmoon Island - Steelscale Crushfish'),
(5861,124669,0,0,0,1,1,1,1,'Darkmoon Island - Darkmoon Daggermaw'),
(5861,6361,0,9.351,0,1,1,1,1,'Darkmoon Island - Raw Rainbow Fin Albacore'),
(5861,124670,0,6.894,0,1,1,1,1,'Darkmoon Island - Sealed Darkmoon Crate'),
(5861,6358,0,3.704,0,1,1,1,1,'Darkmoon Island - Oily Blackmouth'),
(5861,88496,0,1.828,0,1,1,1,1,'Darkmoon Island - Sealed Crate'),
(5861,6359,0,1.524,0,1,1,1,1,'Darkmoon Island - Firefin Snapper'),
(5861,74866,0,0.919,0,1,1,1,1,'Darkmoon Island - Golden Carp'),
(5861,74857,0,0.727,0,1,1,1,1,'Darkmoon Island - Giant Mantis Shrimp'),
(5861,74864,0,0.722,0,1,1,1,1,'Darkmoon Island - Reef Octopus'),
(5861,6303,0,0.328,0,1,1,1,1,'Darkmoon Island - Raw Slitherskin Mackerel'),
(5861,6362,0,0.23,0,1,1,1,1,'Darkmoon Island - Raw Rockscale Cod'),
(5861,41803,0,0.242,0,1,1,1,1,'Darkmoon Island - Rockfin Grouper'),
(5861,4603,0,0.214,0,1,1,1,1,'Darkmoon Island - Raw Spotted Yellowtail'),
(5861,53069,0,0.168,0,1,1,1,1,'Darkmoon Island - Murglesnout'),
(5861,13888,0,0.133,0,1,1,1,1,'Darkmoon Island - Darkclaw Lobster'),
(5861,41802,0,0.102,0,1,1,1,1,'Darkmoon Island - Imperial Manta Ray'),
(5861,41805,0,0.101,0,1,1,1,1,'Darkmoon Island - Borean Man O'' War'),
(5861,53070,0,0.091,0,1,1,1,1,'Darkmoon Island - Fathom Eel'),
(5861,6307,0,0.072,0,1,1,1,1,'Darkmoon Island - Message in a Bottle'),
(5861,13422,0,0.067,0,1,1,1,1,'Darkmoon Island - Stonescale Eel'),
(5861,7973,0,0.059,0,1,1,1,1,'Darkmoon Island - Big-Mouth Clam'),
(5861,36781,0,0.05,0,1,1,1,1,'Darkmoon Island - Darkwater Clam'),
(5861,13756,0,0.045,0,1,1,1,1,'Darkmoon Island - Raw Summer Bass'),
(5861,13755,0,0.047,0,1,1,1,1,'Darkmoon Island - Winter Squid'),
(5861,53071,0,0.033,0,1,1,1,1,'Darkmoon Island - Algaefin Rockfish'),
(5861,53072,0,0.033,0,1,1,1,1,'Darkmoon Island - Deepsea Sagefish'),
(5861,13754,0,0.03,0,1,1,1,1,'Darkmoon Island - Raw Glossy Mightfish'),
(5861,37705,0,0.005,0,1,1,1,1,'Darkmoon Island - Crystallized Water'),
(5861,44475,0,0.005,0,1,1,1,1,'Darkmoon Island - Reinforced Crate'),
(5861,45190,0,1.915,0,1,1,1,1,'Darkmoon Island - Driftwood'),
(5861,45191,0,1.849,0,1,1,1,1,'Darkmoon Island - Empty Clam'),
(5861,45195,0,1.848,0,1,1,1,1,'Darkmoon Island - Empty Rum Bottle'),
(5861,45194,0,1.83,0,1,1,1,1,'Darkmoon Island - Tangled Fishing Line'),
(5861,45189,0,1.754,0,1,1,1,1,'Darkmoon Island - Torn Sail'),
(5861,45188,0,1.868,0,1,1,1,1,'Darkmoon Island - Withered Kelp'),
(5861,45196,0,0.18,0,1,1,1,1,'Darkmoon Island - Tattered Cloth');
