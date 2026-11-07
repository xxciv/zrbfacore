-- Darkmoon Faire: race arch and camp post names hidden, token vendors' empty bags removed (zrbfacore)
--
-- From Four, 2026-11-07.
-- 1. "Arch, Start Race" (74333, 2 spawns) and "Camp Post" (74388, 4 spawns) at Malle's and Patti's
--    start lines showed their names. They are scenery with no gossip or quests. Not selectable
--    (UNIT_FLAG_NOT_SELECTABLE 0x02000000) hides the name, as for the Shooting Gallery targets
--    (2026_11_06_16).
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x02000000 WHERE `entry` IN (74333, 74388);

-- 2. The three Game Token vendors (Sazz Coincatcher 55264, Zina Sharpworth 55266, Trixi Sharpworth
--    55339) sold 14 Pouches/Sacks o' Tokens. Two of them, Pouch o' Tokens 78904 (1 gold) and Sack
--    o' Tokens 78910 (3 gold 20 silver), have no contents at all, and the Pandaria 5.4.8 DB doesn't
--    sell them. The other 12 hold 5 (pouch) or 20 (sack) Darkmoon Game Tokens.
DELETE FROM `npc_vendor` WHERE `entry` IN (55264, 55266, 55339) AND `item` IN (78904, 78910);
