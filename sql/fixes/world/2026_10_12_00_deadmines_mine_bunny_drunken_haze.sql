-- The Mine Bunnies (48338, 48351) cast Drunken Haze (91032) every 7-10 seconds.
-- Besides its 10-second snare and slow, the spell sets the player's drunk level
-- to 100. That level is stored on the character and only drops by 1 every 9
-- seconds, so players stayed fully drunk for about 15 minutes after the fight,
-- with no debuff shown. deadmines-fixes.patch adds spell_dm_drunken_haze, which
-- keeps the debuff and skips the drunk part. This binds it to the spell.
--
-- Needs deadmines-fixes.patch built in, or worldserver logs the script name as
-- unknown and the spell behaves as before.
--
-- Revert:
--   DELETE FROM spell_script_names WHERE spell_id = 91032 AND ScriptName = 'spell_dm_drunken_haze';
--
-- Safe to run twice. worldserver reads spell scripts only at startup: restart it
-- after running this.

DELETE FROM `spell_script_names` WHERE `spell_id` = 91032 AND `ScriptName` = 'spell_dm_drunken_haze';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (91032, 'spell_dm_drunken_haze');
