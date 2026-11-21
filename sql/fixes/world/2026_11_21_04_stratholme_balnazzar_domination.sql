-- Stratholme (map 329), Main Gate, 2026-11-21: Balnazzar resets to full health when he casts Domination.
--
-- Found: Four (solo): Balnazzar 10813 casts Domination, walks off and heals to full. stratholme.patch's
--   change to boss_dathrohan_balnazzar.cpp did not help: that script belongs to Grand Crusader Dathrohan
--   10812, who is not spawned since Cataclysm. The Balnazzar standing in the hall is a SmartAI boss.
-- Cause: his row 0 casts Domination 17405 (mind control) on a random hostile target. Solo that is the only
--   player, so he has nobody left to fight, evades, and resets to full health.
-- Changed: Domination now picks a random player other than his top-threat target (target type 6,
--   players only). Solo there is none, so he skips it; in a group it takes someone other than the tank.

UPDATE `smart_scripts` SET `target_type` = 6, `target_param1` = 0, `target_param2` = 1, `comment` = 'Balnazzar - In Combat - Cast Domination (random player, not the top-threat target)'
WHERE `entryorguid` = 10813 AND `source_type` = 0 AND `id` = 0 AND `action_type` = 11 AND `action_param1` = 17405;

-- Check
SELECT CONCAT('Balnazzar Domination rows on a not-top target ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 10813 AND `source_type` = 0 AND `action_param1` = 17405 AND `target_type` = 6 AND `target_param2` = 1),
              ', on any target ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 10813 AND `source_type` = 0 AND `action_param1` = 17405 AND `target_type` <> 6)) AS `stratholme_balnazzar`;
