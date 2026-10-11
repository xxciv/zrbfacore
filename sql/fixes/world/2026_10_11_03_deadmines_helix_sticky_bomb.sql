-- Helix Gearbreaker never throws his Sticky Bombs. His Throw Bomb spell (88264)
-- is bound to spell_throw_bomb, a Winter Veil quest script that fails the cast
-- unless the caster is on a flying mount, so every throw is cancelled. Nothing
-- else uses that binding. Without it Helix's bombs (Sticky Bomb, 47314) land
-- again.
--
-- Revert:
--   INSERT INTO spell_script_names (spell_id, ScriptName) VALUES (88264, 'spell_throw_bomb');
--
-- Safe to run twice. worldserver reads spell scripts only at startup: restart it
-- after running this.

DELETE FROM `spell_script_names` WHERE `spell_id` = 88264 AND `ScriptName` = 'spell_throw_bomb';
