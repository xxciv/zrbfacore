-- World fixes: Durotar, two Sergeant Curtis up at once in Tiragarde Keep (2026-11-18)
-- Four: "I think there are 2 spawns of Seargant Curtis (Rare) in Tiragarde Keep. I killed one on the bottom
-- floor, and now I see another on the top floor."
-- Sergeant Curtis 5809 is a unique named rare with two spawn points in our dump, one per floor of the keep
-- (guid 252648 on the ground floor, 49456 upstairs). TDB 8.3.7 has none at all, so there is no reference spawn
-- to keep. Both spawn points stay, but they now share a pool: one Curtis at a time, at either spot, as with the
-- other rares in the zone reviews.
-- Safe to run twice.

DELETE FROM `pool_creature` WHERE `pool_entry`=5100635;
DELETE FROM `pool_template` WHERE `entry`=5100635;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES
(5100635,1,'Sergeant Curtis (5809) spawn points');
INSERT INTO `pool_creature` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(49456,5100635,0,'Sergeant Curtis - Tiragarde Keep, top floor'),
(252648,5100635,0,'Sergeant Curtis - Tiragarde Keep, ground floor');
