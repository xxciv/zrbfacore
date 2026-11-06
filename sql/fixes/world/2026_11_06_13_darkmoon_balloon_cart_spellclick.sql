-- zrbfacore: Carl Goodup still had no cart after 2026_11_06_10 (Four, 2026-11-06). The core
-- only loads a vehicle_template_accessory row when the vehicle has an npc_spellclick_spells
-- row, so both accessories were skipped at startup. Add the Ride Vehicle (46598) rows the
-- Pandaria 5.4.8 DB has for Carl (55305) and the Balloon Cart (55306). Players still can't
-- click them (neither has the spellclick npcflag). Safe to run more than once.
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (55305,55306) AND `spell_id`=46598;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(55305,46598,1,0),
(55306,46598,1,0);
