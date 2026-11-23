-- World fixes: Ray'ma and the Orgrimmar Brew Vendor check like their Ironforge twins (2026-11-18)
-- Four: "rayma should have a lockout too" / "as should the brew vendor next to them".
-- Our own tuning: 8.3.7 has these checks only on the Alliance side.
-- 1. Ray'ma 27489 (menu 9554): "What do you have for me?" and the greeting "I see ya got some Brewfest
--    tokens" (text 12968) only with at least 1 Brewfest Prize Token 37829, the same check as Larkin
--    Thunderbrew's menu 9548. Without a token she shows her other greeting (text 12869) and no shop.
-- 2. Brew Vendor 89830 (Orgrimmar, guid 303580): gossip menu 9549, the Ironforge Brew Vendors' menu. Its
--    "I'd like to buy this month's brew." only shows with the achievement Brew of the Month (2796,
--    joining the club); without it the vendor says the brews are for club members only.
-- Revert: DELETE the two condition rows below; UPDATE creature_template SET gossip_menu_id=0 WHERE entry=89830;
-- Safe to run twice.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9554 AND `SourceEntry`=0 AND `ConditionTypeOrReference`=2 AND `ConditionValue1`=37829;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=9554 AND `SourceEntry`=12968 AND `ConditionTypeOrReference`=2 AND `ConditionValue1`=37829;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,9554,0,0,0,2,0,37829,1,0,0,0,0,'','Ray''ma - Only show gossip option if player has at least 1 Brewfest Prize Token'),
(14,9554,12968,0,0,2,0,37829,1,0,0,0,0,'','Ray''ma - Brewfest token greeting only if player has at least 1 Brewfest Prize Token');
UPDATE `creature_template` SET `gossip_menu_id`=9549 WHERE `entry`=89830;
