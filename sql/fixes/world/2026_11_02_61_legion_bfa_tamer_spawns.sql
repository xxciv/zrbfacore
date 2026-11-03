-- Legion/BFA pet tamer spawns (zrbfacore, 2026-11-02)
-- 7 tamers with a team in 2026_11_02_60_legion_bfa_tamer_teams.sql had no spawn at all.
-- X/Y from each tamer's world quest POI (quest_poi_points), Z and facing from Four's .gps on the spot.
-- The Shipwrecked Captive (98489) is still unspawned: no position known.

DELETE FROM `creature` WHERE `guid` BETWEEN 1157000001 AND 1157000007;
DELETE FROM `creature` WHERE `id` IN (139489, 140813, 141077, 141814, 115286, 124617, 115307);
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1157000001, 139489, 1643, 8721, 9465, '0', 0, 0, 0, -1, 0, 0, -1276.401, 4082.493, 1.894, 5.945, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Captain Hermes (Drustvar, Crimson Coast)
(1157000002, 140813, 1643, 8721, 9608, '0', 0, 0, 0, -1, 0, 0, -212.000, 3115.000, 313.669, 0.188, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Fizzie Sparkwhistle (Drustvar, Arom's Crossing)
(1157000003, 141077, 1643, 8567, 8567, '0', 0, 0, 0, -1, 0, 0, 404.046, -1415.275, -53.367, 4.315, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Kwint (Tiragarde Sound, on the sea floor; mid-water he could not be talked to)
(1157000004, 141814, 1642, 8500, 9008, '0', 0, 0, 0, -1, 0, 0, 2164.170, 1178.665, 1.072, 2.018, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Korval Darkbeard (Nazmir, The Dreadmire)
(1157000005, 115286, 1, 17, 17, '0', 0, 0, 0, -1, 0, 0, 439.567, -3452.627, 92.388, 2.120, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Crysa (Northern Barrens)
(1157000006, 124617, 0, 1, 5495, '0', 0, 0, 0, -1, 0, 0, -5146.244, 826.715, 287.386, 6.149, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0), -- Environeer Bert (Dun Morogh, Gnomeregan entrance)
(1157000007, 115307, 571, 67, 4445, '0', 0, 0, 0, -1, 0, 0, 9030.281, -1112.029, 1165.275, 3.117, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0); -- Algalon the Observer (Storm Peaks, Ulduar)

-- Five tamers had npcflag 0, so they could not be right-clicked and the "Let's do battle!" gossip never showed.
-- npcflag 0 -> 1 (UNIT_NPC_FLAG_GOSSIP), like the other 18 tamers.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 1 WHERE `entry` IN (139489, 141077, 115286, 124617, 115307);
