-- Darkmoon Faire concert: Darkmoon Firework instead of Rain of Fire (zrbfacore)
--
-- [DND] L70ETC FX Controller (23830) casts 'L70ETC Rain of Fire' (42501) five times per song
-- (18.0, 87.9, 142.3, 247.3 and 260.5 s after it spawns). 42501 is a persistent area aura whose
-- visual does not play in the 8.3.7 client, so those moments showed nothing. Four tested other
-- fire spells in game and picked Darkmoon Firework (103740), which plays when cast on self.
UPDATE `smart_scripts` SET `action_param1`=103740,
  `comment`='[DNT] L70ETC FX Controller - Out Of Combat - Cast Darkmoon Firework'
WHERE `entryorguid`=23830 AND `source_type`=0 AND `id` IN (3,6,9,12,15) AND `action_type`=11 AND `action_param1` IN (42501,103740);
