-- Stratholme (map 329), Main Gate, 2026-11-21: Patchwork Horrors can't be clicked or attacked.
--
-- Found: Four (screenshot): the Patchwork Horror 10414 abominations show see-through green and can't be
--   selected, so nothing can be done to them.
-- Cause: the dump's creature_template.dynamicflags for 10414 is 2, UNIT_DYNFLAG_HIDE_MODEL. No other
--   Stratholme creature has it (only three other templates in the whole world DB do). Pandaria 5.4.8 and
--   AzerothCore both have 0.
-- Changed: dynamicflags 0. The four spawns have no per-spawn dynamicflags.

UPDATE `creature_template` SET `dynamicflags` = 0 WHERE `entry` = 10414;

-- Check
SELECT CONCAT('Patchwork Horror dynamicflags ', (SELECT `dynamicflags` FROM `creature_template` WHERE `entry` = 10414),
              ', spawns with own dynamicflags ', (SELECT COUNT(*) FROM `creature` WHERE `id` = 10414 AND `dynamicflags` <> 0)) AS `stratholme_patchwork_horror`;
