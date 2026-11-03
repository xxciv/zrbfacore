-- Razorfen Downs (map 129): Lady Falther'ess still only meleed after 2026_10_31_02 (Four, 2026-10-31).
--
-- Her spawn (guid 373575) and Ragglesnout's (373574) each had a per-spawn SmartAI row casting
-- Fel Hands (207101), a Legion dummy aura with no effect, out of combat. A per-spawn script replaces
-- the creature's own script entirely, so neither rare ever ran its combat rows. Delete both.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-373575, -373574) AND `source_type`=0 AND `action_param1`=207101;

-- With its own script running again, Ragglesnout (7354) would cast everything twice: two script
-- versions are mixed together. Drop the second Shadow Word: Pain, Heal and Dominate Mind (ids 10-12).
DELETE FROM `smart_scripts` WHERE `entryorguid`=7354 AND `source_type`=0 AND `id` IN (10, 11, 12);
