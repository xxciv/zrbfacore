-- Stratholme (map 329), Service Entrance, 2026-11-21: the mounted Argent Crusaders fight the Scourge as a backdrop,
-- like the Main Gate crusaders (2026_11_20_00 and 2026_11_21_00).
--
-- Argent Crusader 45456 had SmartAI with no rows. Two creatures that both stand still never notice each other, so
-- the crusaders stood next to the Scourge without fighting. Same fix as 45346 in the Main Gate:
-- 1. Faction 2131 -> 2115 (the Main Gate crusaders' faction). 2131 is hostile to faction 20 (most of the wing) but
--    not to the monster group, so the Plagued Insects were safe from it.
-- 2. Out of combat, every 2-4 seconds, attack the closest of 14 Service Entrance trash kinds within 8 yards, and
--    stay defensive after a reset. The ziggurat bosses, Ramstein, the sentries and the abominations are not on the
--    list (abominations count for the scenario only while that step is active).
-- 3. The staged battle flag (flags_extra 0x400, staged-npc-battles.patch: creatures can't bring them below 85%,
--    players deal full damage) on the Service Entrance trash that lacked it, and on the acolytes and abominations
--    in case a crusader is attacked by one.

UPDATE `creature_template` SET `faction` = 2115 WHERE `entry` = 45456;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 45456 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(45456, 0, 0, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10381, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Ravaged Cadaver'),
(45456, 0, 1, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10382, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Mangled Cadaver'),
(45456, 0, 2, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10383, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Broken Cadaver'),
(45456, 0, 3, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10390, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Skeletal Guardian'),
(45456, 0, 4, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10391, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Skeletal Berserker'),
(45456, 0, 5, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 42975, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Plague Ghoul'),
(45456, 0, 6, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10405, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Plague Ghoul'),
(45456, 0, 7, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10406, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Ghoul Ravener'),
(45456, 0, 8, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10407, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Fleshflayer Ghoul'),
(45456, 0, 9, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10398, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Thuzadin Shadowcaster'),
(45456, 0, 10, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10400, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Thuzadin Necromancer'),
(45456, 0, 11, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10408, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Rockwing Gargoyle'),
(45456, 0, 12, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10463, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Shrieking Banshee'),
(45456, 0, 13, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10461, 8, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - OOC - Attack Closest Plagued Insect'),
(45456, 0, 14, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 8, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Argent Crusader (mounted) - On Reset - Set Reactstate Defensive');

UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 1024 WHERE `entry` IN (10398, 10399, 10400, 10405, 10406, 10407, 10408, 10416, 10417, 10461, 10463);

-- Check
SELECT CONCAT('Mounted crusader faction ', (SELECT `faction` FROM `creature_template` WHERE `entry` = 45456),
    ', start rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 45456 AND `source_type` = 0 AND `action_type` = 49),
    ', defensive row ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 45456 AND `source_type` = 0 AND `event_type` = 25),
    ', staged Service Entrance kinds ', (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (10381, 10382, 10383, 10390, 10391, 10398, 10399, 10400, 10405, 10406, 10407, 10408, 10416, 10417, 10461, 10463, 42975) AND `flags_extra` & 1024)) AS `check`;
