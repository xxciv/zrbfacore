-- Display companion pets cannot be attacked (zrbfacore, 2026-11-13)
--
-- Found (Four, screenshot): Lil' Tarecgosa 54027 in Stormwind can be attacked.
--
-- Cause: 2026_11_07_51 made display pets of non-capturable species unattackable
-- (unit_flags | 0x300, IMMUNE_TO_PC | IMMUNE_TO_NPC) only when their template is type 14
-- (wild pet). 76 spawned templates of those species are type 12 (non-combat pet) instead,
-- 165 spawns in the world DB, e.g. Lil' Tarecgosa. They were never battle pets, but with
-- faction 188 and no immunity they could always be attacked and killed.
--
-- Changed: the same unit_flags | 0x300 on every spawned type 12 template whose species is a
-- non-capturable battle pet (battlepet_info NpcID moved to NpcID + 10000000 by 2026_11_07_51).
-- Needs 2026_11_07_51 to have run first.
--
-- Undo: clear 0x300 on the templates listed by the same join.

UPDATE `creature_template` ct
  JOIN `battlepet_info` bi ON ct.`entry` = bi.`NpcID` - 10000000
   SET ct.`unit_flags` = ct.`unit_flags` | 0x300
 WHERE bi.`NpcID` >= 10000000 AND ct.`type` = 12
   AND EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = ct.`entry`);

SELECT CONCAT(COUNT(*), ' display companion templates unattackable (Lil'' Tarecgosa: ',
              (SELECT IF(`unit_flags` & 0x300 = 0x300, 'yes', 'no') FROM `creature_template` WHERE `entry` = 54027), ')') AS zr_result
  FROM `creature_template` ct JOIN `battlepet_info` bi ON ct.`entry` = bi.`NpcID` - 10000000
 WHERE bi.`NpcID` >= 10000000 AND ct.`type` = 12 AND ct.`unit_flags` & 0x300 = 0x300
   AND EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = ct.`entry`);
