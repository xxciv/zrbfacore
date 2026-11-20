-- World fixes: Duskwood, doubled Night Watch watchers in Darkshire (Four, 2026-11-20)
-- Four: "watcher jordan double spawn, watcher fraizer double spawn, watch burkouris double spawn".
-- None of these watchers starts, ends or is needed for a quest (no starter/ender rows, objectives or kill credit).
-- Watcher Jordan 887: 3 spawns (TDB 8.3.7: 1). The pair 170441/170926 at the east gate removed; 170824 kept and moved
--   to TDB's spot, standing still.
-- Watcher Fraizer 2470: 2 spawns 2.5 yards apart (TDB: 1). 170415 (wandering copy) removed, 170801 kept.
-- Watcher Mocarski 827: 2 spawns 12 yards apart (TDB: 1). 170440 removed, 170823 kept, standing still as in TDB.
-- Watcher Bukouris 494: 2 spawns 9 yards apart. TDB 8.3.7 has two as well; removing one is our own call, after Four's report.
--   170416 removed, 170804 kept, standing still as in TDB.
-- Safe to run twice.
DELETE FROM `creature_addon` WHERE `guid` IN (170441,170926,170415,170440,170416);
DELETE FROM `creature` WHERE `guid` IN (170441,170926,170415,170440,170416);
UPDATE `creature` SET `position_x`=-10731.9,`position_y`=-1162.25,`position_z`=26.5651,`orientation`=2.58077,`MovementType`=0,`spawndist`=0 WHERE `guid`=170824;
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `guid` IN (170823,170804,170801);
