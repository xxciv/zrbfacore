-- Sunken Temple (map 109): the Avatar of Hakkar waits for the Shrine of the Soulflayer, 2026-11-23. Goes with 2026_11_23_02.
--
-- Four, 2026-11-23: "avatar of hakkar was already spawned" (the shrine should bring him).
--
-- Since Cataclysm the Avatar (8443, guid 320776) is summoned by clicking the Shrine of the Soulflayer
-- (208321, guid 188000) in the Sanctum of the Fallen God. Pandaria 5.4.8 does it in C++
-- (go_shrine_of_soulflayer, boss_avatar_of_hakkar), which this core does not have, so here he stood in
-- the room from the start and the shrine did nothing. Now, with the same SmartAI pattern as Hurley
-- Blackbreath (2026_11_22_06/09): the Avatar spawns invisible, passive and immune to players; clicking the
-- shrine (16 yards away) makes him visible, attackable and aggressive, and he attacks the nearest player.
-- After a wipe he stays up, so the shrine is only needed once per instance.
-- Undo: DELETE FROM `smart_scripts` WHERE (`source_type` = 0 AND `entryorguid` = 8443) OR (`source_type` = 1 AND `entryorguid` = 208321);

DELETE FROM `smart_scripts` WHERE (`source_type` = 0 AND `entryorguid` = 8443) OR (`source_type` = 1 AND `entryorguid` = 208321);
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 8443;
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI', `ScriptName` = '' WHERE `entry` = 208321;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `comment`) VALUES
(8443, 0, 0, 1, 11, 0, 100, 256, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - On Spawn - Immune to players'),
(8443, 0, 1, 2, 61, 0, 100, 256, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - Linked - Invisible'),
(8443, 0, 2, 0, 61, 0, 100, 256, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - Linked - Passive'),
(8443, 0, 3, 4, 38, 0, 100, 257, 1, 1, 0, 0, 47, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - On Data 1 1 (shrine used) - Visible'),
(8443, 0, 4, 5, 61, 0, 100, 256, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - Linked - Attackable'),
(8443, 0, 5, 6, 61, 0, 100, 256, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 'Avatar of Hakkar - Linked - Aggressive'),
(8443, 0, 6, 0, 61, 0, 100, 256, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 50, 0, 0, 'Avatar of Hakkar - Linked - Attack nearest player'),
(208321, 1, 0, 0, 70, 0, 100, 0, 2, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 9, 8443, 0, 50, 'Shrine of the Soulflayer - On Use - Summon the Avatar of Hakkar');

-- Check: expect Avatar rows 7, shrine rows 1
SELECT CONCAT('Avatar rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 8443),
    ', shrine rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` = 208321),
    ', Avatar AI ', (SELECT `AIName` FROM `creature_template` WHERE `entry` = 8443),
    ', shrine AI ', (SELECT `AIName` FROM `gameobject_template` WHERE `entry` = 208321)) AS `check`;
