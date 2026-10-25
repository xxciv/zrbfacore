-- Razorfen Kraul (map 47): Agathelos the Raging healed to full mid-fight (Four, 2026-10-25).
--
-- His Left for Dead (8555) hits and then forces the target to feign death (8359). Feigning death drops
-- the player from his threat list; solo, that leaves him with nobody to fight, so he evades and resets
-- to full health every time it lands. Remove the cast; he keeps Rushing Charge, Frenzy at 60% and 40%,
-- Rampage and Call for Help.
DELETE FROM `smart_scripts` WHERE `entryorguid`=4422 AND `source_type`=0 AND `id`=6 AND `action_param1`=8555;
