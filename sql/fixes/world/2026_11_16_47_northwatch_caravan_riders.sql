-- Northwatch caravans follow-up (Four, 2026-11-16): the caravans from 2026_11_16_44 walked but carried nobody.
-- The core only loads vehicle_template_accessory rows for vehicles that also have an npc_spellclick_spells row
-- (ObjectMgr::LoadVehicleTemplateAccessories), so the lugs and crates were dropped at startup.
-- Add the standard "Ride Vehicle Hardcoded" 46598 click spell (cast_flags 1) that the passengers' scripts already expect.
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (39244,39318,39319) AND `spell_id`=46598;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(39244,46598,1,0),
(39318,46598,1,0),
(39319,46598,1,0);
