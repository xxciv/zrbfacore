-- Darkmoon Island (map 974) rares (Four, 2026-11-07: "The Death Metal Knight, Darkmoon Rabbit, and
-- Moonfang may need reviewing").
--
-- 1. Darkmoon Rabbit 58336 (rare elite, drops the Darkmoon Rabbit pet 80008 at 11%) had no spawn
--    in the BFA dump. Its core script (npc_darkmoon_rabbit_ird) and loot are there. Spawned at the
--    Pandaria 5.4.8 DB spot by the rabbit's cave, with its 32-hour respawn.
-- 2. Moonfang 71992 (Darkmoon Den Mother) had a spawn but no fight at all: no SmartAI rows and no
--    core script, so she only meleed. Her fight is rebuilt from the Pandaria 5.4.8 core script
--    (npc_darkmoon_moonfang), with the same timers:
--    Fangs of the Moon 144700 on her target every 12.5 s, Moonfang Tears 144579 (the pool her
--    144702 drops on each player; 144702 only works through a spell script) every 20 s, Leap for
--    the Kill 144546 every 16 s, Call the Pack 144602 (summons Moonfang Packmates 72038) every 32 s.
--    Moonfang Curse 144590 is left out: it charms half the players in range, and solo that is you.
--    Packmates now attack the closest player when summoned.
-- 3. Moonfang Dreadhowl 71982: 2 spawns here, 5 in the Pandaria DB. The 3 missing ones (around
--    Moonfang's den) are added, and all 5 wander 5 yards like in the Pandaria DB.
-- 4. Death Metal Knight 122899 (Legion rare, has a template and loot here but no spawn in any
--    reference DB) spawned where Four says he belongs, in the Cauldron of Rock (area 8901), with a
--    5-minute respawn like Moonfang. He has no SmartAI or core script, so for now he only melees.
-- 5. Darkmoon Rabbit and Moonfang showed as level 1 with 31 health (Four): neither had a
--    creature_template_scaling row, so they never scaled to the player, and their HealthModifier
--    was 1. They get the same scaling row as Death Metal Knight, Moonfang Dreadhowl and Moonfang
--    Packmate (levels 1-100, scales with the player) and the Pandaria 5.4.8 health modifiers
--    (Moonfang Packmate 8; Darkmoon Rabbit and Moonfang 400 at first, see 9). Faction stays 7: all three rares
--    are neutral until attacked, as on retail.
-- 6. Darkmoon Rabbit's pet (Darkmoon Rabbit 80008) dropped 11%; the Pandaria 5.4.8 DB has it at
--    100% as his only real drop, so 100%.
-- 7. Darkmoon Rabbit one-shot Four. His core script (npc_darkmoon_rabbit_ird) casts Huge, Sharp
--    Teeth 114078 the moment he is pulled: it holds you, deals 20% of your health every second
--    (aura 89) and blocks all healing (114109, -100% healing taken), a group mechanic you can't
--    survive solo; the dump's own SmartAI recast it every 60 s. He now uses SmartAI without it:
--    on aggro he takes his rabbit form (114085, as in the Pandaria 5.4.8 DB) and fights in melee.
--    Rank 3 (boss, level ??) -> 1 (elite, shows his scaled level), as in the Pandaria 5.4.8 DB.
-- 8. Death Metal Knight had no weapon: he now wields Necromedes, the Death Resonator 151255 (the
--    two-handed weapon from his own loot table).
-- 9. Health: Moonfang came out at 456K health at level 38 (HealthModifier 400) and the same
--    modifier made the rabbit just as tanky, while Death Metal Knight at 300 was a good solo fight
--    (Four). Darkmoon Rabbit and Moonfang now use 300 as well, and Moonfang is rank 1 (elite)
--    instead of 3 (boss), as in the Pandaria 5.4.8 DB.
-- 10. Moonfang tuning after Four's fight: Fangs of the Moon (stun, bleed, more damage taken) came
--    every 12.5 s, far too often solo: now every 25-30 s, first at 10-12 s. Her loot had only
--    independent rolls (Moonfang's Paw 22%, Shimmering Moonstone 22%, Moonfang Shroud 21%, Moon Moon
--    4.8%, plus grey fangs; Moonfang's Pelt is quest-only), so a third of her kills dropped nothing.
--    The four items are now one loot group, so exactly one always drops: Paw, Moonstone and
--    Shroud 31-32% each, Moon Moon 5%.
-- New creature guids 974200001-974200005 (974100001-974100043 are the pet battle thread's crows).

DELETE FROM `creature` WHERE `guid` BETWEEN 974200001 AND 974200005;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(974200001, 58336, 974, 5861, 5861, '0', 0, 0, 0, -1, 0, 0, -4291.81, 5860.5, 3.38236, 4.09891, 115200, 5, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Darkmoon Rabbit
(974200002, 71982, 974, 5861, 5861, '0', 0, 0, 0, -1, 0, 0, -3889.19, 6470.56, 14.3052, 1.75537, 120, 5, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Moonfang Dreadhowl
(974200003, 71982, 974, 5861, 5861, '0', 0, 0, 0, -1, 0, 0, -3908.56, 6560.66, 17.1611, 4.10685, 120, 5, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Moonfang Dreadhowl
(974200004, 71982, 974, 5861, 5861, '0', 0, 0, 0, -1, 0, 0, -4001.25, 6568.14, 17.9383, 4.00516, 120, 5, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Moonfang Dreadhowl
(974200005, 122899, 974, 5861, 8901, '0', 0, 0, 0, -1, 0, 1, -4181.957, 6019.819, 6.289, 1.285, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0); -- Death Metal Knight (Cauldron of Rock)
UPDATE `creature` SET `spawndist` = 5, `MovementType` = 1 WHERE `guid` = 1400330 AND `id` = 71982;

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (71992, 72038);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (71992, 72038) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(71992, 0, 0, 0, 0, 0, 100, 0, 10000, 12000, 25000, 30000, 0, '', 11, 144700, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Moonfang - IC - Cast Fangs of the Moon on victim'),
(71992, 0, 1, 0, 0, 0, 100, 0, 11000, 11000, 20000, 20000, 0, '', 11, 144579, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Moonfang - IC - Cast Moonfang Tears on victim'),
(71992, 0, 2, 0, 0, 0, 100, 0, 15000, 15000, 16000, 16000, 0, '', 11, 144546, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Moonfang - IC - Cast Leap for the Kill on victim'),
(71992, 0, 3, 0, 0, 0, 100, 0, 25000, 25000, 32000, 32000, 0, '', 11, 144602, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Moonfang - IC - Cast Call the Pack'),
(72038, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 49, 0, 0, 0, 0, 0, 0, 25, 40, 1, 0, 0, 0, 0, 0, 'Moonfang Packmate - Just Summoned - Attack closest player');

DELETE FROM `creature_template_scaling` WHERE `Entry` IN (58336, 71992) AND `DifficultyID` = 0;
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(58336, 0, 1, 100, 0, 0, 0, 0), -- Darkmoon Rabbit
(71992, 0, 1, 100, 0, 0, 0, 0); -- Moonfang
UPDATE `creature_template` SET `HealthModifier` = 300 WHERE `entry` IN (58336, 71992);
UPDATE `creature_template` SET `rank` = 1 WHERE `entry` = 71992;
UPDATE `creature_template` SET `HealthModifier` = 8 WHERE `entry` = 72038;
UPDATE `creature_loot_template` SET `Chance` = 100 WHERE `Entry` = 58336 AND `Item` = 80008;

UPDATE `creature_template` SET `ScriptName` = '', `AIName` = 'SmartAI', `rank` = 1 WHERE `entry` = 58336;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 58336 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(58336, 0, 0, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 114085, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkmoon Rabbit - On aggro - Cast Darkmoon Rabbit form'),
(58336, 0, 1, 0, 7, 0, 100, 0, 0, 0, 0, 0, 0, '', 28, 114085, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Darkmoon Rabbit - On evade - Remove Darkmoon Rabbit form');

DELETE FROM `creature_equip_template` WHERE `CreatureID` = 122899;
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(122899, 1, 151255, 0, 0, 0, 0, 0, 0, 0, 0, 0); -- Death Metal Knight: Necromedes, the Death Resonator
UPDATE `creature` SET `equipment_id` = 1 WHERE `guid` = 974200005;

UPDATE `creature_loot_template` SET `GroupId` = 1, `Chance` = 31 WHERE `Entry` = 71992 AND `Item` = 105898; -- Moonfang's Paw
UPDATE `creature_loot_template` SET `GroupId` = 1, `Chance` = 32 WHERE `Entry` = 71992 AND `Item` = 101675; -- Shimmering Moonstone
UPDATE `creature_loot_template` SET `GroupId` = 1, `Chance` = 32 WHERE `Entry` = 71992 AND `Item` = 101571; -- Moonfang Shroud
UPDATE `creature_loot_template` SET `GroupId` = 1, `Chance` = 5 WHERE `Entry` = 71992 AND `Item` = 101570; -- Moon Moon
