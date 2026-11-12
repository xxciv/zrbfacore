-- Scholomance (map 1007): Darkmaster Gandling 59080 died to one Ambush (Four, 2026-11-11). His template
-- was level 1-1 with HealthScalingExpansion 0 and rank 1 (elite), so his health came from the level-1
-- classic table. The other four bosses are level 43-92, HealthScalingExpansion 4, rank 3 (boss).
-- Gandling at Rattlegore 58875 (not attackable) had the same level 1 and gets the same levels.
-- Safe to run again.
UPDATE `creature_template` SET `minlevel`=43, `maxlevel`=92, `HealthScalingExpansion`=4, `rank`=3 WHERE `entry`=59080;
UPDATE `creature_template` SET `minlevel`=43, `maxlevel`=92 WHERE `entry`=58875;
