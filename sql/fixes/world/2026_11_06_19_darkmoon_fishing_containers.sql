-- zrbfacore: containers from the Darkmoon Island fishing loot (2026_11_06_18) opened empty: they had
-- no item_loot_template rows (Four, 2026-11-06). Contents and chances are from Wowhead (Four's
-- CSV and screenshots); each item rolls on its own, as on Wowhead's "Contains" tab.
-- * Sealed Darkmoon Crate (124670): Darkmoon Firewater 97%, each faire food/drink 6-10%, each
--   Darkmoon Draught/Tincture and the Healing Tonic about 3%, Don Carlos Tequila 0.7%,
--   Divergence draught/tincture 0.2% (chance = Wowhead count / 250,335 crates).
-- * Darkwater Clam (36781): Succulent Clam Meat 89% (1-3), Northsea Pearl 10%, Siren's Tear 1%.
-- * Big-Mouth Clam (7973): Zesty Clam Meat 100%, Black Pearl 1%, Golden Pearl 1.7%, Iridescent
--   Pearl 2.3%, Small Lustrous Pearl 1%.
-- * Jaggal Clam (24476): Jaggal Clam Meat 100% (1-3), Jaggal Pearl 8%, Shadow Pearl 5%.
-- Safe to run more than once.
DELETE FROM `item_loot_template` WHERE `Entry` IN (124670,36781,7973,24476);
INSERT INTO `item_loot_template` (`Entry`,`Item`,`Reference`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(124670,78883,0,97.33,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Firewater'),
(124670,21151,0,9.55,0,1,0,1,1,'Sealed Darkmoon Crate - Rumsey Rum Black Label'),
(124670,74822,0,9.60,0,1,0,1,1,'Sealed Darkmoon Crate - Sasparilla Sinker'),
(124670,19300,0,9.02,0,1,0,1,1,'Sealed Darkmoon Crate - Bottled Winterspring Water'),
(124670,19222,0,9.00,0,1,0,1,1,'Sealed Darkmoon Crate - Cheap Beer'),
(124670,44940,0,8.73,0,1,0,1,1,'Sealed Darkmoon Crate - Corn-Breaded Sausage'),
(124670,19221,0,8.72,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Special Reserve'),
(124670,19225,0,8.98,0,1,0,1,1,'Sealed Darkmoon Crate - Deep Fried Candybar'),
(124670,19299,0,9.15,0,1,0,1,1,'Sealed Darkmoon Crate - Fizzy Faire Drink'),
(124670,44941,0,8.78,0,1,0,1,1,'Sealed Darkmoon Crate - Fresh-Squeezed Limeade'),
(124670,19305,0,9.12,0,1,0,1,1,'Sealed Darkmoon Crate - Pickled Kodo Foot'),
(124670,19224,0,8.75,0,1,0,1,1,'Sealed Darkmoon Crate - Red Hot Wings'),
(124670,73260,0,8.65,0,1,0,1,1,'Sealed Darkmoon Crate - Salty Sea Dog'),
(124670,19304,0,9.18,0,1,0,1,1,'Sealed Darkmoon Crate - Spiced Beef Jerky'),
(124670,19306,0,8.38,0,1,0,1,1,'Sealed Darkmoon Crate - Crunchy Frog'),
(124670,19223,0,8.19,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Dog'),
(124670,160092,0,6.40,0,1,0,1,1,'Sealed Darkmoon Crate - Pineapple Pizza'),
(124670,124647,0,3.42,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Alacrity'),
(124670,124649,0,2.89,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Defense'),
(124670,124651,0,3.05,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Deflection'),
(124670,124650,0,3.08,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Deftness'),
(124670,124646,0,2.88,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Flexibility'),
(124670,124645,0,2.87,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Precision'),
(124670,124642,0,3.22,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Supremacy'),
(124670,124660,0,3.04,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Healing Tonic'),
(124670,124656,0,3.07,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Alacrity'),
(124670,124654,0,3.18,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Defense'),
(124670,124652,0,3.03,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Deflection'),
(124670,124653,0,3.38,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Deftness'),
(124670,124658,0,2.76,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Flexibility'),
(124670,124657,0,3.16,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Precision'),
(124670,124659,0,3.32,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Supremacy'),
(124670,28284,0,0.74,0,1,0,1,1,'Sealed Darkmoon Crate - Don Carlos Tequila'),
(124670,124648,0,0.22,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Draught of Divergence'),
(124670,124655,0,0.22,0,1,0,1,1,'Sealed Darkmoon Crate - Darkmoon Tincture of Divergence'),
(36781,36782,0,89,0,1,0,1,3,'Darkwater Clam - Succulent Clam Meat'),
(36781,36783,0,10,0,1,0,1,1,'Darkwater Clam - Northsea Pearl'),
(36781,36784,0,1,0,1,0,1,1,'Darkwater Clam - Siren''s Tear'),
(7973,7974,0,100,0,1,0,1,1,'Big-Mouth Clam - Zesty Clam Meat'),
(7973,7971,0,1,0,1,0,1,1,'Big-Mouth Clam - Black Pearl'),
(7973,13926,0,1.7,0,1,0,1,1,'Big-Mouth Clam - Golden Pearl'),
(7973,5500,0,2.3,0,1,0,1,1,'Big-Mouth Clam - Iridescent Pearl'),
(7973,5498,0,1,0,1,0,1,1,'Big-Mouth Clam - Small Lustrous Pearl'),
(24476,24477,0,100,0,1,0,1,3,'Jaggal Clam - Jaggal Clam Meat'),
(24476,24478,0,8,0,1,0,1,1,'Jaggal Clam - Jaggal Pearl'),
(24476,24479,0,5,0,1,0,1,1,'Jaggal Clam - Shadow Pearl');
