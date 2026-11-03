-- Spawns whose cosmetic per-spawn script switched off their own script (follow-up to
-- 2026_10_31_05, Four 2026-11-03).
--
-- 40 spawns have a one-row per-spawn SmartAI script (entryorguid = -guid, id 0, comment 'OOC - CS')
-- that only casts a cosmetic spell out of combat: dummy auras 39550, 54219, 111541, 146130, 180695,
-- 183940, 185340, 217193 and dummy-effect 217160 (some aimed at a nearby bunny). Unlike Fel Hands
-- these may be real retail visuals, so they stay. But a per-spawn script replaces the creature's
-- own script entirely, so these 40 spawns never ran their entry script: no combat casts, no flee or
-- low-HP lines, and Tortolla 41504 (293563) never ran 'Teleport on Quest Add'.
--
-- Changed: each spawn's entry script (smart_scripts entryorguid = entry, source_type 0) is copied
-- under its per-spawn script with id and link + 1000, next to the cosmetic row (id 0). Copied at
-- apply time from the live table, so core updates to those entry scripts are included. Re-running
-- this file replaces the copies.
-- Revert: DELETE FROM smart_scripts WHERE source_type = 0 AND id >= 1000 AND entryorguid = -<guid>.
--
-- Spawns (entry name: guids):
--   721 Rabbit: 271453
--   3296 Orgrimmar Grunt: 266181
--   4008 Cliff Stormer: 273458
--   4376 Darkmist Spider: 270562
--   6132 Razorfen Servitor: 270614
--   7874 Razorfen Thornweaver: 269550
--   11734 Hive'Regal Hive Lord: 268164
--   11737 Stonelash Flayer: 268158
--   11739 Rock Stalker: 268160
--   11910 Grimtotem Ruffian: 273391
--   34848 Honor's Stand Sharpshooter: 270526
--   34886 Kalimdor Eagle: 273105
--   34894 Stonetalon Ram: 273468, 273469
--   34982 Emerald Spirit: 273390
--   35151 Stonetalon Warder: 273619, 273627
--   35204 Goblin Harvester: 271457
--   35334 Gnome Engineer: 271833
--   37084 Terrortooth Scytheclaw: 270833
--   37086 Hecklefang Scavenger: 269807
--   37090 Deviate Terrortooth: 269810
--   37091 Deviate Plainstrider: 270843
--   37093 Lashvine: 269575
--   37167 Stonetalon Prisoner: 270672
--   37206 Plains Prowler: 270533
--   37207 Plains Pridemane: 270540
--   37560 Razormane Pathfinder: 270650
--   37660 Razormane Warfrenzy: 270262, 270757
--   37923 Triumph Vanguard: 270845
--   37925 Sapper Specialist: 270777, 270847, 270852
--   38659 Rageroar Lieutenant: 270728
--   39280 Frazzlecraz Miner: 269433
--   40906 Lumbering Oaf: 273111
--   41504 Tortolla: 293563
--   41989 Frightened Peon: 271458
--   42548 Muddy Crawfish: 266469

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `id` >= 1000 AND `entryorguid` IN (
-266181, -266469, -268158, -268160, -268164, -269433, -269550, -269575, -269807, -269810, -270262, -270526, -270533, -270540, -270562, -270614, -270650, -270672, -270728, -270757, -270777, -270833, -270843, -270845, -270847, -270852, -271453, -271457, -271458, -271833, -273105, -273111, -273390, -273391, -273458, -273468, -273469, -273619, -273627, -293563);

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`)
SELECT g.`guid`, 0, s.`id` + 1000, IF(s.`link` > 0, s.`link` + 1000, 0), s.`event_type`, s.`event_phase_mask`, s.`event_chance`, s.`event_flags`, s.`event_param1`, s.`event_param2`, s.`event_param3`, s.`event_param4`, s.`event_param5`, s.`event_param_string`, s.`action_type`, s.`action_param1`, s.`action_param2`, s.`action_param3`, s.`action_param4`, s.`action_param5`, s.`action_param6`, s.`target_type`, s.`target_param1`, s.`target_param2`, s.`target_param3`, s.`target_x`, s.`target_y`, s.`target_z`, s.`target_o`, s.`comment`
FROM `smart_scripts` s
JOIN (SELECT -c.`guid` AS `guid`, c.`id` AS `entry` FROM `creature` c WHERE c.`guid` IN (
266181, 266469, 268158, 268160, 268164, 269433, 269550, 269575, 269807, 269810, 270262, 270526, 270533, 270540, 270562, 270614, 270650, 270672, 270728, 270757, 270777, 270833, 270843, 270845, 270847, 270852, 271453, 271457, 271458, 271833, 273105, 273111, 273390, 273391, 273458, 273468, 273469, 273619, 273627, 293563)) g ON s.`entryorguid` = g.`entry`
WHERE s.`source_type` = 0
  AND EXISTS (SELECT 1 FROM `smart_scripts` p WHERE p.`entryorguid` = g.`guid` AND p.`source_type` = 0 AND p.`id` = 0 AND p.`comment` = 'OOC - CS');
