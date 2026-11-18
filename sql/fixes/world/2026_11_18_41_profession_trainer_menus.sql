-- World fixes: the 11 "Profession Trainer" NPCs (Runda in Razor Hill and others) teach nothing (2026-11-18)
-- Four: "Runda (Profession Trainer) - is this a real in game NPC or something added by Havencore? Either way, she
-- doesn't work". Runda 47418 is a real NPC (Cataclysm and later), like Lien Farner, Wembil Taskwidget, Nedric Sallow,
-- Lalum Darkmane, Iranis Shadebloom, Saren, Valn, Therisa Sallow, Jack "All-Trades" Derrington and Elder Oakpaw:
-- all use gossip menu 12180 and its "Tell me about..." sub menus 12185-12199.
-- Every menu lists "Train me in <profession>." for the 11 professions, but the data was broken:
--   - most of those options had OptionType 3 (vendor) or 1 (gossip with nowhere to go), so a click closed the menu;
--   - only 26 of the 154 options had a creature_trainer row telling the core which trainer list to open.
-- The sniffed rows show the intended lists: Alchemy 59, Blacksmithing 80, Enchanting 51, Engineering 102,
-- Herbalism 388, Inscription 387, Jewelcrafting 48, Leatherworking 103, Mining 389, Skinning 390, Tailoring 117.
-- Now every "Train me in X." option is a trainer option (OptionType 5, npcflag 16) and opens list X for all 11 NPCs.
-- Safe to run twice.

SET @MENUS := '12180,12185,12186,12188,12189,12190,12191,12192,12193,12195,12196,12197,12198,12199';

UPDATE `gossip_menu_option` SET `OptionType`=5,`OptionNpcFlag`=16
WHERE FIND_IN_SET(`MenuId`,@MENUS) AND `OptionText` LIKE 'Train me in %';

DELETE `ct` FROM `creature_trainer` `ct` JOIN `creature_template` `t` ON `t`.`entry`=`ct`.`CreatureId`
WHERE `t`.`gossip_menu_id`=12180 AND FIND_IN_SET(`ct`.`MenuId`,@MENUS);

INSERT INTO `creature_trainer` (`CreatureId`,`TrainerId`,`MenuId`,`OptionIndex`)
SELECT `t`.`entry`,
  CASE `o`.`OptionText`
    WHEN 'Train me in Alchemy.' THEN 59
    WHEN 'Train me in Blacksmithing.' THEN 80
    WHEN 'Train me in Enchanting.' THEN 51
    WHEN 'Train me in Engineering.' THEN 102
    WHEN 'Train me in Herbalism.' THEN 388
    WHEN 'Train me in Inscription.' THEN 387
    WHEN 'Train me in Jewelcrafting.' THEN 48
    WHEN 'Train me in Leatherworking.' THEN 103
    WHEN 'Train me in Mining.' THEN 389
    WHEN 'Train me in Skinning.' THEN 390
    WHEN 'Train me in Tailoring.' THEN 117
  END,
  `o`.`MenuId`,`o`.`OptionIndex`
FROM `creature_template` `t`
JOIN `gossip_menu_option` `o` ON FIND_IN_SET(`o`.`MenuId`,@MENUS) AND `o`.`OptionText` LIKE 'Train me in %'
WHERE `t`.`gossip_menu_id`=12180;
