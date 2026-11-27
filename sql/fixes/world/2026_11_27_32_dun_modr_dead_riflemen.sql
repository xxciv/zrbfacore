-- World fixes: the Twilight Riflemen at the Dun Modr camp lie dead, as in 8.3.7 (2026-11-27)
-- Four, at the dwarven camp outside Dun Modr (Wetlands): "a fair bit of enemy mobs near the camp. Looks like it may be wrong."
-- Found: our 15 Twilight Riflemen (42155) stand on exactly TDB 8.3.7's 15 spots, some right among the camp NPCs, alive,
--   hostile and wandering 3 yards. In TDB the template carries the feign-death flag (unit_flags2 0x1) and the spawns
--   stand still: they are bodies left over from the fight for the camp. No quest needs them (Twilight Converts 42154
--   are the kill target of 26127 and stay alive), nothing summons them, and they spawn nowhere else.
-- Changed: the riflemen lie dead (Permanent Feign Death 29266, as our other corpses) and stand still, as TDB.
-- Not changed: the Twilight Converts in and around Dun Modr.
-- Safe to run twice.

UPDATE `creature_template_addon` SET `bytes2`=1,`auras`='29266' WHERE `entry`=42155;
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`)
SELECT 42155,0,0,0,1,0,0,0,0,0,'29266' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `creature_template_addon` WHERE `entry`=42155);
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `id`=42155;

-- Summary: expect 15 riflemen, 15 standing still, aura 29266
SELECT COUNT(*) AS `riflemen`, SUM(`MovementType`=0 AND `spawndist`=0) AS `still`,
       (SELECT `auras` FROM `creature_template_addon` WHERE `entry`=42155) AS `aura`
FROM `creature` WHERE `id`=42155;
