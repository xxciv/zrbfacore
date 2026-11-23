-- World fixes: Durotar, Razor Hill Grunt directions (2026-11-18)
-- Four: "Razor Hill Grunts - none of their direction gossip works. Just closes the menu."
-- Razor Hill Grunt 5953 uses gossip menu 3285. Its six options (bank, wind rider master, inn, stable master,
-- class trainer, profession trainer) had no gossip_menu_option_action rows, so every click closed the menu
-- (TDB 8.3.7 has the same gap), and "A class trainer" (option 4) was missing. The answer menus and the
-- WotLK-era map markers (points_of_interest 10403-10418) are all in the data; only the links were missing.
-- The links are AzerothCore's (same menus, texts and markers), except where Cataclysm moved an NPC:
--   the class menu gained Druid at the top, so the old links were one row off (Druid answered "Thotar",
--   Warrior answered nothing); Un'Thuwa (mage) and Burok (wind rider master) now stand in Razor Hill, and
--   Jabul is the Razor Hill druid trainer. Those three get a map marker at their spawn and no answer text
--   (the old texts send you to Sen'jin Village / Orgrimmar). Markers 54200-54202 are new.
-- Safe to run twice.

-- 1. The missing "A class trainer" option (8.3.7 has it)
DELETE FROM `gossip_menu_option` WHERE `MenuId`=3285 AND `OptionIndex`=4;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(3285,4,0,'A class trainer',6792,1,1,0);

-- 2. New map markers for NPCs that moved in Cataclysm
DELETE FROM `points_of_interest` WHERE `ID` IN (54200,54201,54202);
INSERT INTO `points_of_interest` (`ID`,`PositionX`,`PositionY`,`Icon`,`Flags`,`Importance`,`Name`,`VerifiedBuild`) VALUES
(54200,342.1,-4771.4,7,99,0,'Jabul',0),
(54201,334.7,-4767.6,7,99,0,'Un''Thuwa',0),
(54202,272.2,-4769.9,7,99,0,'Burok',0);

-- 3. Main menu: each option opens its answer (and marks the inn and stable on the map)
DELETE FROM `gossip_menu_option_action` WHERE `MenuId`=3285;
INSERT INTO `gossip_menu_option_action` (`MenuId`,`OptionIndex`,`ActionMenuId`,`ActionPoiId`) VALUES
(3285,0,3280,0),     -- The bank: in Orgrimmar
(3285,1,0,54202),    -- The wind rider master: Burok, Razor Hill
(3285,2,3282,10403), -- The inn: Innkeeper Grosk
(3285,3,4901,10404), -- The stable master: Shoja'my
(3285,4,3283,0),     -- A class trainer
(3285,5,3284,0);     -- A profession trainer

-- 4. Class menu, realigned to its Cataclysm order (Druid first)
DELETE FROM `gossip_menu_option_action` WHERE `MenuId`=3283;
INSERT INTO `gossip_menu_option_action` (`MenuId`,`OptionIndex`,`ActionMenuId`,`ActionPoiId`) VALUES
(3283,0,0,54200),    -- Druid: Jabul
(3283,1,3261,10405), -- Hunter: Thotar
(3283,2,0,54201),    -- Mage: Un'Thuwa, now in Razor Hill
(3283,3,3263,10407), -- Priest: Tai'jin
(3283,4,3264,10408), -- Rogue: Kaplak
(3283,5,3265,10409), -- Shaman: Swart
(3283,6,3266,10410), -- Warlock: Dhugru Gorelust
(3283,7,3267,10411); -- Warrior: Tarshaw Jaggedscar
