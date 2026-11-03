-- Dire Maul (map 429), Warpwood Quarter (east wing): scripts checked before Four's first run (2026-11-03).
--
-- 1. Pusillin 14354 (the imp you chase for his key). The dump mixes two versions of his script:
--    every Gossip Hello row fires at once (no phase masks), so the last menu always wins, and old
--    "stop at waypoint 3/14/12/7" rows cut each run short at points from a 3-point Pandaria path.
--    His four BFA paths (14354, 143540, 287080, 430620) are complete and join end to start, so the
--    script is rebuilt: talk to him, he runs one path, talk again at the end, five times in all; the
--    fifth time he turns hostile, casts Spirit of Runn Tum and fights with five Wildspawn Imps.
-- 2. Old Ironbark 11491 had gossip "We are ready for you to open the door" but no script, so the
--    Conservatory Door 176907 in front of Alzzin's area never opened. He now walks to the door on
--    that option (AzerothCore path for Ironbark the Redeemed) and opens it. The second NPC standing
--    on the same spot, Ironbark the Redeemed 14241 (guid 323214, same gossip, no script), is removed.
-- 3. Alzzin the Wildshaper 11492: 24 rows from two script versions (orphan "reset on evade" links,
--    a broken 40% chain). Rebuilt from AzerothCore: druid form, Dire Wolf Form or Tree Form picked at
--    random every 20 seconds, four Alzzin's Minions from the crumbled wall at 50% health.
-- 4. Lethtendris 14327 cast Curse of Tongues twice (ids 3 and 4); id 4 is Curse of Thorns as in
--    AzerothCore. Pimgib 14349 had two caster scripts on top of each other; replaced by one.
-- 5. Hydroling 14350 (Hydrospawn's adds) had no scaling row for Normal.

-- 1. Pusillin
DELETE FROM `smart_scripts` WHERE `entryorguid`=14354 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 1435400 AND 1435404 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(14354, 0, 0, 0, 37, 0, 100, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On AI Init - Set Event Phase 1'),
(14354, 0, 1, 0, 64, 1, 100, 0, 0, 0, 0, 0, 98, 5709, 6877, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Hello (Phase 1) - Send Gossip 5709'),
(14354, 0, 2, 0, 64, 2, 100, 0, 0, 0, 0, 0, 98, 5710, 6878, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Hello (Phase 2) - Send Gossip 5710'),
(14354, 0, 3, 0, 64, 4, 100, 0, 0, 0, 0, 0, 98, 5711, 6879, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Hello (Phase 3) - Send Gossip 5711'),
(14354, 0, 4, 0, 64, 8, 100, 0, 0, 0, 0, 0, 98, 5712, 6880, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Hello (Phase 4) - Send Gossip 5712'),
(14354, 0, 5, 0, 64, 16, 100, 0, 0, 0, 0, 0, 98, 5713, 6881, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Hello (Phase 5) - Send Gossip 5713'),
(14354, 0, 6, 11, 62, 1, 100, 0, 5709, 0, 0, 0, 80, 1435400, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip 5709 Selected - Run Script (run 1)'),
(14354, 0, 7, 11, 62, 2, 100, 0, 5710, 0, 0, 0, 80, 1435401, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip 5710 Selected - Run Script (run 2)'),
(14354, 0, 8, 11, 62, 4, 100, 0, 5711, 0, 0, 0, 80, 1435402, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip 5711 Selected - Run Script (run 3)'),
(14354, 0, 9, 11, 62, 8, 100, 0, 5712, 0, 0, 0, 80, 1435403, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip 5712 Selected - Run Script (run 4)'),
(14354, 0, 10, 11, 62, 16, 100, 0, 5713, 0, 0, 0, 80, 1435404, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip 5713 Selected - Run Script (fight)'),
(14354, 0, 11, 0, 61, 0, 100, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Gossip Selected - Close Gossip'),
(14354, 0, 12, 0, 58, 0, 100, 0, 0, 0, 0, 0, 81, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Waypoint Ended - Set Npc Flag Gossip'),
(14354, 0, 13, 0, 0, 0, 100, 0, 1000, 4000, 8000, 8000, 11, 14145, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - In Combat - Cast Fire Blast'),
(14354, 0, 14, 0, 0, 0, 100, 0, 1000, 1000, 4000, 4000, 11, 15228, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - In Combat - Cast Fireball'),
(14354, 0, 15, 0, 9, 0, 100, 0, 0, 10, 10000, 17000, 11, 22424, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - Within 0-10yd - Cast Blast Wave'),
(14354, 0, 16, 0, 4, 0, 100, 0, 0, 0, 0, 0, 39, 30, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Aggro - Call For Help'),
-- runs 1-4: no npc flag while running, say the line, next phase, run the next path
(1435400, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Remove Npc Flags'),
(1435400, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Say Line 0'),
(1435400, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Event Phase 2'),
(1435400, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 53, 1, 14354, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Start Waypoint Path 14354 (run)'),
(1435401, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Remove Npc Flags'),
(1435401, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Say Line 1'),
(1435401, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Event Phase 3'),
(1435401, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 53, 1, 143540, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Start Waypoint Path 143540 (run)'),
(1435402, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Remove Npc Flags'),
(1435402, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Say Line 2'),
(1435402, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Event Phase 4'),
(1435402, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 53, 1, 287080, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Start Waypoint Path 287080 (run)'),
(1435403, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Remove Npc Flags'),
(1435403, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Say Line 3'),
(1435403, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Event Phase 5'),
(1435403, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 53, 1, 430620, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Start Waypoint Path 430620 (run)'),
-- fight
(1435404, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Remove Npc Flags'),
(1435404, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 1, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Say Line 4'),
(1435404, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Home Position'),
(1435404, 9, 3, 0, 0, 0, 100, 0, 0, 0, 0, 0, 2, 16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Faction 16 (hostile)'),
(1435404, 9, 4, 0, 0, 0, 100, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Set Reactstate Aggressive'),
(1435404, 9, 5, 0, 0, 0, 100, 0, 0, 0, 0, 0, 11, 22735, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Cast Spirit of Runn Tum'),
(1435404, 9, 6, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 13276, 4, 10000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Summon Wildspawn Imp'),
(1435404, 9, 7, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 13276, 4, 10000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Summon Wildspawn Imp'),
(1435404, 9, 8, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 13276, 4, 10000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Summon Wildspawn Imp'),
(1435404, 9, 9, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 13276, 4, 10000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Summon Wildspawn Imp'),
(1435404, 9, 10, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 13276, 4, 10000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Summon Wildspawn Imp'),
(1435404, 9, 11, 0, 0, 0, 100, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 21, 40, 0, 0, 0, 0, 0, 0, 'Pusillin - On Script - Start Attacking Closest Player');

-- the imps join the fight at once (only summoned ones; the static imp keeps its spot)
DELETE FROM `smart_scripts` WHERE `entryorguid`=13276 AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(13276, 0, 1, 0, 54, 0, 100, 0, 0, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Wildspawn Imp - On Just Summoned - Set In Combat With Zone');

-- 2. Old Ironbark opens the Conservatory Door
DELETE FROM `creature` WHERE `guid`=323214 AND `id`=14241;
DELETE FROM `creature_addon` WHERE `guid`=323214;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11491;
DELETE FROM `smart_scripts` WHERE `entryorguid`=11491 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11491, 0, 0, 1, 62, 0, 100, 0, 5602, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Old Ironbark - On Gossip 5602 Selected - Close Gossip'),
(11491, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 81, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Old Ironbark - On Gossip 5602 Selected - Remove Npc Flags'),
(11491, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 53, 0, 1149100, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Old Ironbark - On Gossip 5602 Selected - Walk Path 1149100 to the Conservatory Door'),
(11491, 0, 3, 4, 58, 0, 100, 0, 0, 1149100, 0, 0, 5, 36, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Old Ironbark - On Path 1149100 Ended - Play Emote Attack'),
(11491, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 67, 1, 1500, 1500, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Old Ironbark - On Path 1149100 Ended - Create Timed Event 1'),
(11491, 0, 5, 0, 59, 0, 100, 0, 1, 0, 0, 0, 118, 0, 0, 0, 0, 0, 0, 20, 176907, 40, 0, 0, 0, 0, 0, 'Old Ironbark - On Timed Event 1 - Open Conservatory Door');
DELETE FROM `waypoints` WHERE `entry`=1149100;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `point_comment`) VALUES
(1149100, 1, -42.4602, -268.908, -57.3032, 'Old Ironbark to Conservatory Door'),
(1149100, 2, -30.9334, -274.496, -55.8847, 'Old Ironbark to Conservatory Door'),
(1149100, 3, -15.9251, -281.058, -54.1125, 'Old Ironbark to Conservatory Door'),
(1149100, 4, -0.318176, -285.794, -52.9219, 'Old Ironbark to Conservatory Door'),
(1149100, 5, 9.04104, -286.418, -52.4165, 'Old Ironbark to Conservatory Door'),
(1149100, 6, 12.5364, -286.238, -52.3252, 'Old Ironbark to Conservatory Door'),
(1149100, 7, 31.0773, -283.884, -52.5108, 'Old Ironbark to Conservatory Door'),
(1149100, 8, 42.6055, -275.98, -53.0081, 'Old Ironbark to Conservatory Door'),
(1149100, 9, 51.3233, -270.003, -52.9705, 'Old Ironbark to Conservatory Door'),
(1149100, 10, 60.5642, -268.871, -53.7654, 'Old Ironbark to Conservatory Door'),
(1149100, 11, 72.0036, -270.912, -54.5982, 'Old Ironbark to Conservatory Door'),
(1149100, 12, 86.9575, -273.58, -55.6531, 'Old Ironbark to Conservatory Door'),
(1149100, 13, 104.186, -276.653, -55.8901, 'Old Ironbark to Conservatory Door'),
(1149100, 14, 121.374, -278.801, -55.8569, 'Old Ironbark to Conservatory Door');

-- 3. Alzzin the Wildshaper (phase 1 = night elf, 2 = Dire Wolf Form, 3 = Tree Form)
DELETE FROM `smart_scripts` WHERE `entryorguid`=11492 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 1149200 AND 1149203 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11492, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Reset - Set Event Phase 1'),
(11492, 0, 1, 0, 4, 0, 100, 0, 0, 0, 0, 0, 11, 22128, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Aggro - Cast Thorns'),
(11492, 0, 2, 0, 0, 1, 100, 0, 4000, 8000, 14000, 18000, 11, 22691, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 1) - Cast Disarm'),
(11492, 0, 3, 0, 0, 1, 100, 0, 2000, 6000, 14000, 20000, 11, 22661, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 1) - Cast Enervate'),
(11492, 0, 4, 0, 0, 1, 100, 0, 10000, 12000, 12000, 16000, 11, 10101, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 1) - Cast Knock Away'),
(11492, 0, 5, 0, 0, 5, 100, 0, 3000, 6000, 11000, 16000, 11, 22662, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 1 or 3) - Cast Wither'),
(11492, 0, 6, 0, 0, 4, 100, 0, 2000, 4000, 14000, 18000, 11, 7948, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 3) - Cast Wild Regeneration'),
(11492, 0, 7, 0, 0, 2, 100, 0, 1000, 3000, 8000, 12000, 11, 22689, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 2) - Cast Mangle'),
(11492, 0, 8, 0, 0, 2, 100, 0, 3000, 5000, 6000, 9000, 11, 19319, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat (Phase 2) - Cast Vicious Bite'),
(11492, 0, 9, 0, 0, 0, 100, 0, 20000, 20000, 20000, 20000, 88, 1149200, 1149202, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - In Combat - Run Random Form Script'),
(11492, 0, 10, 0, 2, 0, 100, 1, 0, 50, 0, 0, 80, 1149203, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - Between 0-50% Health - Run Script (Alzzin''s Minions)'),
(1149200, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 28, 22660, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Remove Dire Wolf Form'),
(1149200, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 28, 22688, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Remove Tree Form'),
(1149200, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Set Event Phase 1'),
(1149201, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 28, 22688, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Remove Tree Form'),
(1149201, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 11, 22660, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Cast Dire Wolf Form'),
(1149201, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Set Event Phase 2'),
(1149202, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 28, 22660, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Remove Dire Wolf Form'),
(1149202, 9, 1, 0, 0, 0, 100, 0, 0, 0, 0, 0, 11, 22688, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Cast Tree Form'),
(1149202, 9, 2, 0, 0, 0, 100, 0, 0, 0, 0, 0, 22, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Script - Set Event Phase 3'),
(1149203, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 12, 11460, 4, 30000, 0, 0, 0, 8, 0, 0, 0, 252.7, -398.5, -117.2, 4.7, 'Alzzin the Wildshaper - On Script - Summon Alzzin''s Minion'),
(1149203, 9, 1, 0, 0, 0, 100, 0, 1000, 1000, 0, 0, 12, 11460, 4, 30000, 0, 0, 0, 8, 0, 0, 0, 251.5, -397.6, -117.2, 4.7, 'Alzzin the Wildshaper - On Script - Summon Alzzin''s Minion'),
(1149203, 9, 2, 0, 0, 0, 100, 0, 1000, 1000, 0, 0, 12, 11460, 4, 30000, 0, 0, 0, 8, 0, 0, 0, 252.8, -410.7, -119.9, 4.7, 'Alzzin the Wildshaper - On Script - Summon Alzzin''s Minion'),
(1149203, 9, 3, 0, 0, 0, 100, 0, 1000, 1000, 0, 0, 12, 11460, 4, 30000, 0, 0, 0, 8, 0, 0, 0, 252.0, -391.0, -117.2, 4.7, 'Alzzin the Wildshaper - On Script - Summon Alzzin''s Minion');
-- the summoned minions join the fight at once
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11460;
DELETE FROM `smart_scripts` WHERE `entryorguid`=11460 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11460, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 38, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin''s Minion - On Just Summoned - Set In Combat With Zone');

-- 4. Lethtendris and Pimgib
UPDATE `smart_scripts` SET `action_param1`=16247, `comment`='Lethtendris - In Combat - Cast Curse of Thorns' WHERE `entryorguid`=14327 AND `source_type`=0 AND `id`=4 AND `action_param1` IN (13338, 16247);
DELETE FROM `smart_scripts` WHERE `entryorguid`=14349 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(14349, 0, 0, 0, 0, 0, 100, 0, 0, 2000, 3400, 4700, 11, 14034, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Pimgib - In Combat - Cast Fireball'),
(14349, 0, 1, 0, 0, 0, 100, 0, 9000, 10000, 7000, 12000, 11, 22713, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Pimgib - In Combat - Cast Flame Buffet'),
(14349, 0, 2, 0, 9, 0, 100, 0, 0, 8, 19000, 25000, 11, 15744, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Pimgib - Within 0-8yd - Cast Blast Wave');

-- 5. Hydroling scaling
DELETE FROM `creature_template_scaling` WHERE `Entry`=14350 AND `DifficultyID`=1;
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(14350, 1, 1, 100, 0, 0, 0, 0);
