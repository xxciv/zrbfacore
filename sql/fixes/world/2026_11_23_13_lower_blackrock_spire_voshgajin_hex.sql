-- Lower Blackrock Spire (map 229): Shadow Hunter Vosh'gajin's hex, 2026-11-23.
--
-- Four, 2026-11-23: "Shadowhunter Vosh has a nasty hex/polymorph. While it doesn't break her combat, she uses it
-- every single cooldown keeping you locked out of combat."
--
-- Her C++ script (boss_shadow_hunter_voshgajin) casts Hex 16708 every 15 seconds: an instant 20-second hex, so one
-- player is never free of it. Pandaria and AzerothCore give her Hex 16097 instead (8 seconds, with a cast time you
-- can interrupt). Same approach as Jammal'an (2026_11_23_02): she moves to SmartAI with Curse of Blood 16098 and
-- Cleave 20691 as before, and Hex 16097 every 25-30 seconds. The C++ only kept her boss state for the instance,
-- which nothing in Lower Spire reads; her kill credit (encounter 268) and the scenario step come from the kill.
-- Undo: UPDATE `creature_template` SET `ScriptName` = 'boss_shadow_hunter_voshgajin' WHERE `entry` = 9236; DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9236;

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 9236;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9236;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(9236, 0, 0, 0, 0, 0, 100, 0, 2000, 2000, 45000, 45000, 11, 16098, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Shadow Hunter Vosh''gajin - In Combat - Cast Curse of Blood'),
(9236, 0, 1, 0, 0, 0, 100, 0, 10000, 12000, 25000, 30000, 11, 16097, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Shadow Hunter Vosh''gajin - In Combat - Cast Hex (8 s, interruptible)'),
(9236, 0, 2, 0, 0, 0, 100, 0, 14000, 14000, 7000, 10000, 11, 20691, 0, 0, 0, 0, 0, 2, 0, 0, 0, 'Shadow Hunter Vosh''gajin - In Combat - Cast Cleave');

-- Check: expect AI SmartAI, script '', rows 3
SELECT CONCAT('AI ', `AIName`, ', script ''', `ScriptName`, ''', rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 9236)) AS `check` FROM `creature_template` WHERE `entry` = 9236;
