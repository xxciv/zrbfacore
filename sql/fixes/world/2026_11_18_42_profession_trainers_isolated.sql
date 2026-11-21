-- World fixes: the other all-in-one profession trainers (2026-11-18)
-- Four: "can you do a pass of all profession trainers of this kind?" (after Runda, 2026_11_18_41).
-- Five more NPCs teach several professions; they stand where no other trainer is:
--   KTC Train-a-Tron Deluxe 45286 (Lost Isles, 4 spawns) and Whittler Dewei 57620 (Wandering Isle): 8.3.7 gives
--     both gossip menu 12180, like Runda. Ours had the fishing trainers' menu 17157 (Fishing only) on the
--     Train-a-Tron and a HavenCore menu 15125 on Dewei with no "Train me in" options at all.
--   KTC Train-a-Tron Deluxe 49885 (Azshara): menu 12002 "primary / secondary profession training". Both options
--     were trainer options that never opened their sub menus 12045 and 12046 (8.3.7's links), the 14 professions on 12045/12046 were plain
--     gossip options that closed the menu, its trainer rows sat on menus 12006/12007 that don't exist, and
--     "Access profession vending machine" was a gossip option with nowhere to go.
--   Profession Liaisons Leedan Gustaf 142564 (Boralus) and Ozgrom Ragefang 142552 (Dazar'alor): "I would like to
--     buy from you." was a gossip option with nowhere to go (134 items each).
-- Our own addition (8.3.7's 12180 has none): "Show me your wares, please." on menu 12180, so the Train-a-Tron
-- and Dewei can still sell their goods. It only shows on NPCs that are vendors and have goods, so Runda and the
-- other town trainers don't get it.
-- Side effect: Acride 10296/10299 and Tinza Silvermug 45563 also point at menu 12046 and used to show
-- "Cooking / First Aid / Fishing" options that did nothing; those are trainer options now and they are not
-- trainers, so the options no longer show for them.
-- Trainer lists are not changed (same ids as 2026_11_18_41; Cooking 136, First Aid 880, Fishing 10).
-- Safe to run twice.

SET @MENUS := '12180,12185,12186,12188,12189,12190,12191,12192,12193,12195,12196,12197,12198,12199';

-- 1. Train-a-Tron 45286 and Dewei 57620 use menu 12180 (8.3.7), and get the same lists as Runda
UPDATE `creature_template` SET `gossip_menu_id`=12180 WHERE `entry` IN (45286,57620);

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

-- 2. Vending on menu 12180 (our addition, vendors only)
DELETE FROM `gossip_menu_option` WHERE `MenuId`=12180 AND `OptionIndex`=13;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(12180,13,1,'Show me your wares, please.',41360,3,128,0);

-- 3. Train-a-Tron 49885 (Azshara): vending, primary and secondary training
UPDATE `gossip_menu_option` SET `OptionType`=3,`OptionNpcFlag`=128 WHERE `MenuId`=12002 AND `OptionIndex`=0;
-- the two training options were trainer options themselves, so they ignored their sub menus; now they open them
UPDATE `gossip_menu_option` SET `OptionType`=1,`OptionNpcFlag`=1 WHERE `MenuId`=12002 AND `OptionIndex` IN (1,2);
DELETE FROM `gossip_menu_option_action` WHERE `MenuId`=12002;
INSERT INTO `gossip_menu_option_action` (`MenuId`,`OptionIndex`,`ActionMenuId`,`ActionPoiId`) VALUES
(12002,1,12045,0),
(12002,2,12046,0);
UPDATE `gossip_menu_option` SET `OptionType`=5,`OptionNpcFlag`=16 WHERE `MenuId` IN (12045,12046);

DELETE FROM `creature_trainer` WHERE `CreatureId`=49885;
INSERT INTO `creature_trainer` (`CreatureId`,`TrainerId`,`MenuId`,`OptionIndex`) VALUES
(49885,59,12045,0),(49885,80,12045,1),(49885,51,12045,2),(49885,102,12045,3),(49885,388,12045,4),
(49885,387,12045,5),(49885,48,12045,6),(49885,103,12045,7),(49885,389,12045,8),(49885,390,12045,9),
(49885,117,12045,10),
(49885,136,12046,0),(49885,880,12046,1),(49885,10,12046,2);

-- 4. Profession Liaisons: "I would like to buy from you." opens their goods
UPDATE `gossip_menu_option` SET `OptionType`=3,`OptionNpcFlag`=128 WHERE `MenuId` IN (23161,23163) AND `OptionIndex`=0;
