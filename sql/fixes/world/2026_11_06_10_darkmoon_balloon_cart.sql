-- zrbfacore: Carl Goodup (55305, Balloon Vendor) on Darkmoon Island. Four, 2026-11-06: the
-- balloons walk around alone and the cart can be clicked but does nothing. Carl (vehicle
-- 1769) carries the Balloon Cart (55306, vehicle 1770), which carries the Balloon Cart Bunny
-- (55307, the balloons); the Pandaria 5.4.8 DB has these two vehicle accessories, the BFA dump
-- has none, so all three stood or wandered separately (the bunny had random movement).
-- Now the cart and balloons ride on Carl as one unit, the separate cart and bunny spawns are
-- removed, the cart is not selectable, and Carl wanders up to 5 yards (as in the Pandaria DB).
-- Safe to run more than once.
DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (55305,55306);
INSERT INTO `vehicle_template_accessory` (`entry`,`accessory_entry`,`seat_id`,`minion`,`description`,`summontype`,`summontimer`) VALUES
(55305,55306,0,0,'Carl Goodup - Balloon Cart',6,30000),
(55306,55307,0,0,'Balloon Cart - Balloon Cart Bunny',6,30000);

DELETE FROM `creature` WHERE `guid` IN (1400353,1400354) AND `id` IN (55306,55307);
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x2000000 WHERE `entry`=55306;
UPDATE `creature` SET `MovementType`=1, `spawndist`=5 WHERE `guid`=1400352 AND `id`=55305;
