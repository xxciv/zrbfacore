-- zrbfacore: two Darkmoon Faire follow-ups from Four's test (2026-11-06).
--
-- 1. Shooting Gallery (Rinling): the targets (54231) showed their name over their heads.
--    Only the target with the green arrow counts, so the names were just clutter. The name is
--    now empty, so nothing is drawn over them. Delete the client Cache folder to see this.
UPDATE `creature_template` SET `name`='' WHERE `entry`=54231;

-- 2. Carl Goodup (55305): he pushes his Balloon Cart (55306) now, but the balloons stayed
--    where the cart was first made. The balloons are the Balloon Cart Contents aura (103320)
--    on the Balloon Cart Bunny (55307), which was meant to ride on the cart as a second
--    vehicle accessory; that second step does not follow the cart here. The aura now sits on
--    the cart itself, so the balloons are part of the cart and move with it, and the bunny is
--    no longer made. The cart keeps its own aura (96847). Safe to run more than once.
DELETE FROM `vehicle_template_accessory` WHERE `entry`=55306 AND `accessory_entry`=55307;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=55306 AND `spell_id`=46598;
DELETE FROM `creature_template_addon` WHERE `entry`=55306;
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(55306,0,0,0,1,0,0,0,0,0,'96847 103320');
