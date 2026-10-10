-- Fishing trainers such as Astaia in Darnassus sell "Fishing" but the character
-- never gets the Fishing skill, ability or fishing pole proficiency. The trainer
-- then shows Fishing as "Already known" and won't sell it again.
--
-- After worldserver has applied upstream's sql/updates, NPCs whose gossip menu
-- is 0 (2026_09_04_00_world_trainer_mapping_sync.sql) offer the default "Train me!"
-- option, which has no creature_trainer row, so the core falls back to the legacy
-- npc_trainer list. On 20 fishing trainers that list starts with spell 7620, the
-- pre-BFA Apprentice Fishing rank, which in 8.3.7 no longer grants the skill.
-- Arnold Leland in Stormwind (5493) lists 131476 instead, which does: learning
-- it gives Fishing, Fishing Skills and the Fishing skill (verified in game
-- 2026-10-10). This gives the other 20 the same spell.
--
-- Characters that already bought 7620 can buy the new entry; nothing to undo.
-- Safe to run twice. worldserver reads trainers only at startup: restart it
-- after running this.

UPDATE IGNORE `npc_trainer` SET `SpellID` = 131476
WHERE `SpellID` = 7620
  AND `ID` IN (1651, 1680, 1683, 2834, 3028, 3179, 4156, 4573, 5161, 5690, 5938,
               5941, 7946, 12032, 16780, 17101, 18911, 25580, 26957, 28742);
