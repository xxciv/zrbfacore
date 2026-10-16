-- Wailing Caverns: Muyoh (Disciple of Naralex, 3678) never offers to start
-- the awakening, and Mutanus the Devourer (3654) stands in Naralex's pool
-- from the start.
--
-- npc_disciple_of_naralex only shows "Let the event begin!" once instance
-- data 1-4 (the four Fanglords) are DONE. Nothing sets them: the lords run
-- SmartAI, and the world dump has no "on death, set instance data" rows for
-- them (TrinityCore has one per lord). The script's last step also waits for
-- data 9 (Mutanus) to be DONE, which had no row either.
--
-- Mutanus is meant to be summoned by Muyoh at the end of the ritual
-- (npc_disciple_of_naralex, same spot), but the dump also spawns him there,
-- so he could be pulled early and the event would summon a second one.
--
-- Revert:
--   DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `id` = 100 AND `entryorguid` IN (3654, 3669, 3670, 3671, 3673);
--   INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`)
--   VALUES (326392, 3654, 43, 718, 718, '1', 0, 0, 0, -1, 4088, 0, 150.943, 262.797, -103.904, 3.7001, 3600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);
--
-- Safe to run twice. Restart worldserver afterwards, and start a fresh
-- instance: lords killed before this ran are not counted.

-- On death, set instance data <field> to 3 (DONE). Fields from wailing_caverns.h.
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `id` = 100 AND `entryorguid` IN (3654, 3669, 3670, 3671, 3673);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3669, 0, 100, 0, 6, 0, 100, 0, 0, 0, 0, 0, 34, 1, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lord Cobrahn - On Just Died - Set Instance Data 1 to 3'),
(3670, 0, 100, 0, 6, 0, 100, 0, 0, 0, 0, 0, 34, 2, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lord Pythas - On Just Died - Set Instance Data 2 to 3'),
(3671, 0, 100, 0, 6, 0, 100, 0, 0, 0, 0, 0, 34, 3, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lady Anacondra - On Just Died - Set Instance Data 3 to 3'),
(3673, 0, 100, 0, 6, 0, 100, 0, 0, 0, 0, 0, 34, 4, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Lord Serpentis - On Just Died - Set Instance Data 4 to 3'),
(3654, 0, 100, 0, 6, 0, 100, 0, 0, 0, 0, 0, 34, 9, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Mutanus the Devourer - On Just Died - Set Instance Data 9 to 3');

-- Mutanus only appears when Muyoh summons him.
DELETE FROM `creature` WHERE `guid` = 326392 AND `id` = 3654;
DELETE FROM `creature_addon` WHERE `guid` = 326392;
