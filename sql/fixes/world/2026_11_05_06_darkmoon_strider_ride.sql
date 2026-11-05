-- zrbfacore: "Dusty" Brandom and the Darkmoon Striders (Darkmoon Island arrival hill, map 974)
--
-- Retail: Dusty (68492, Tallstrider Handler) stands at the start of the Darkmoon Path
-- with Darkmoon Striders (68491) that give anyone a free ride down to the Faire.
-- Here Dusty had npcflag 0 (no gossip) and the striders had no spellclick, so neither
-- did anything. Values from the Pandaria 5.4.8 DB: Dusty gossip, menu 15306 (its
-- gossip_menu row and npc_text 21955 are already in this DB), unit_flags 768; striders
-- npcflag SPELLCLICK, unit_flags 33536, click casts Darkmoon Strider 134931 (mounts
-- you on a Darkmoon Strider, creature 68491).
UPDATE `creature_template` SET `npcflag`=1, `gossip_menu_id`=15306, `unit_flags`=768, `AIName`='' WHERE `entry`=68492;
-- His only SAI row talked on gossip hello, but he has no creature_text.
DELETE FROM `smart_scripts` WHERE `entryorguid`=68492 AND `source_type`=0;

UPDATE `creature_template` SET `npcflag`=16777216, `unit_flags`=33536 WHERE `entry`=68491;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=68491;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(68491, 134931, 3, 0);
