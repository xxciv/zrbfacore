-- Pilgrim's Bounty 116404 ("Filled with various seasonal fare."): reported by Four, 2026-11-23. The
-- reward bag you can pick from the Pilgrim's Bounty dailies (Don't Forget The Stuffing! 14051/14062 etc.,
-- QuestPackageID 17285) opened empty: it has no item_loot_template rows, in our dump or in any TDB
-- (8.3.7 to 12.1.0). Contents built from the guides (Icy Veins, Wowhead comments, Xu-Fu): always a
-- Turkey Shooter, some of the bag's own seasonal food, and a small chance (about 9% combined) at the
-- Frightened Bush Chicken pet, the Silver-Plated Turkey Shooter toy or the Fine Pilgrim's Hat.
-- Food amounts and the exact rare odds aren't published anywhere we could reach: 3% each and
-- each food at 50% for 1-2 are our own choice (about 2-3 servings a bag on average).
DELETE FROM `item_loot_template` WHERE `Entry`=116404;
INSERT INTO `item_loot_template` (`Entry`,`Item`,`Reference`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(116404,44812,0,100,0,1,0,1,1,'Pilgrim''s Bounty - Turkey Shooter'),
(116404,116405,0,50,0,1,0,1,2,'Pilgrim''s Bounty - Congealed Cranberry Chutney'),
(116404,116406,0,50,0,1,0,1,2,'Pilgrim''s Bounty - Twice-Baked Sweet Potato'),
(116404,116407,0,50,0,1,0,1,2,'Pilgrim''s Bounty - Slow-Smoked Turkey'),
(116404,116408,0,50,0,1,0,1,2,'Pilgrim''s Bounty - Herb-Infused Stuffing'),
(116404,116409,0,50,0,1,0,1,2,'Pilgrim''s Bounty - Gourmet Pumpkin Pie'),
(116404,116403,0,3,0,1,0,1,1,'Pilgrim''s Bounty - Frightened Bush Chicken (pet)'),
(116404,116400,0,3,0,1,0,1,1,'Pilgrim''s Bounty - Silver-Plated Turkey Shooter (toy)'),
(116404,116401,0,3,0,1,0,1,1,'Pilgrim''s Bounty - Fine Pilgrim''s Hat');
