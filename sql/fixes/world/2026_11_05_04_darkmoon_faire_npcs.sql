-- zrbfacore: Darkmoon Faire NPC fixes (Darkmoon Island, map 974)

-- 1. Selina Dourman (10445) could not be talked to.
-- Her C++ script npc_selina_dourman sends npc_text 23004-23006, which do not
-- exist in this database, and her template points at gossip menu 8776, which
-- has no gossip_menu row. The database already holds her real menu 13075
-- (Darkmoon Adventurer's Guide, What can I purchase?, Prize Tickets, Cards,
-- Attractions) plus SAI that hands out the guide (menu 13113 -> spell 103413).
-- Drop the script and use menu 13075. unit_flags 768 = not attackable, as
-- on the other Faire staff.
UPDATE `creature_template` SET `ScriptName`='', `gossip_menu_id`=13075, `unit_flags`=768 WHERE `entry`=10445;

-- 2. Fire Jugglers that pass fire to each other (spell 196717) aimed at the
-- partner's sniffed spawn guid (2099, 2104, ...), which does not exist here,
-- so they never threw. Point each one at its partner's spawn on this server.
UPDATE `smart_scripts` SET `target_param1`=1400016 WHERE `entryorguid`=55220 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55221 (entrance, next to Selina)
UPDATE `smart_scripts` SET `target_param1`=1400017 WHERE `entryorguid`=55221 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55220
UPDATE `smart_scripts` SET `target_param1`=1400081 WHERE `entryorguid`=55222 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55223
UPDATE `smart_scripts` SET `target_param1`=1400086 WHERE `entryorguid`=55223 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55222
UPDATE `smart_scripts` SET `target_param1`=1400313 WHERE `entryorguid`=55225 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55226
UPDATE `smart_scripts` SET `target_param1`=1400349 WHERE `entryorguid`=55226 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55225
UPDATE `smart_scripts` SET `target_param1`=1400114 WHERE `entryorguid`=55341 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55342
UPDATE `smart_scripts` SET `target_param1`=1400294 WHERE `entryorguid`=55342 AND `source_type`=0 AND `id`=0 AND `action_param1`=196717; -- -> 55341

-- 3. Alliance Citizen (55347, faction 1732) and Horde Citizen (55348, faction
-- 1735) are ambient Faire visitors and children. unit_flags 512 let the other
-- faction attack them. 768 adds IMMUNE_TO_PC (same as the Pandaria 5.4.8 DB).
UPDATE `creature_template` SET `unit_flags`=768 WHERE `entry` IN (55347, 55348);
