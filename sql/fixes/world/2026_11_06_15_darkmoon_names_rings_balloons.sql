-- zrbfacore: Darkmoon Faire follow-ups from Four's test (2026-11-06). Goes with the updated
-- tools/bfa/darkmoon-faire-gossip.patch. Safe to run more than once.
--
-- 1. Shooting Gallery targets (54231) still showed "[DND] Darkmoon Shooting Gallery" after
--    2026_11_06_14 emptied the name. The name is put back and the creature now carries the
--    client flags that hide it: type_flags 0x40000000 (do not draw the name) and 0x00100000
--    (no name plate). Delete the client Cache folder to see it.
UPDATE `creature_template` SET `name`='[DND] Darkmoon Shooting Gallery', `type_flags`=`type_flags`|0x40100000 WHERE `entry`=54231;

-- 2. Firebird's Challenge: only one ring came. Blazing Ring (170823, cast for each ring caught)
--    has a script effect that renews the flight; it had no script.
DELETE FROM `spell_script_names` WHERE `spell_id`=170823 AND `ScriptName`='spell_darkmoon_firebird_blazing_ring';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (170823,'spell_darkmoon_firebird_blazing_ring');

-- 3. Carl Goodup: the balloons on the cart itself (2026_11_06_14) sat too low. They go back on
--    the Balloon Cart Bunny (55307, aura 103320), which sits in the cart's seat 1 yard up. The
--    cart's script (npc_darkmoon_balloon_cart) seats the bunny once the cart rides on Carl; the
--    cart keeps the Ride Vehicle spellclick row so the bunny boards it.
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_darkmoon_balloon_cart' WHERE `entry`=55306;
UPDATE `creature_template_addon` SET `auras`='96847' WHERE `entry`=55306;
DELETE FROM `vehicle_template_accessory` WHERE `entry`=55306;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=55306 AND `spell_id`=46598;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES (55306,46598,1,0);
