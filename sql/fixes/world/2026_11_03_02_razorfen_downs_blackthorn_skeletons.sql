-- Razorfen Downs (map 129): Blackthorn's Summon Skeletons never summoned anything (Four, 2026-11-03).
--
-- His script casts Summon Skeletons 150601, which only puts a dummy aura on him; the server-side
-- script that should then summon is missing. The spell that actually summons is 150603 (Summon
-- Skeletons, summon effect for Splinterbone Warrior 74902 at the caster). Cast that three times
-- instead, from 70% health and then every 20-35 seconds as before. The warriors also get the
-- scaling row for the dungeon's difficulty.
UPDATE `smart_scripts` SET `action_param1`=150603, `link`=6, `comment`='Death Speaker Blackthorn - Below 70% HP - Cast Summon Skeletons (Splinterbone Warrior 1)' WHERE `entryorguid`=74875 AND `source_type`=0 AND `id`=5 AND `action_param1` IN (150601, 150603);
DELETE FROM `smart_scripts` WHERE `entryorguid`=74875 AND `source_type`=0 AND `id` IN (6, 7);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(74875, 0, 6, 7, 61, 0, 100, 0, 0, 0, 0, 0, 11, 150603, 2, 1, 'Death Speaker Blackthorn - Below 70% HP - Cast Summon Skeletons (Splinterbone Warrior 2)'),
(74875, 0, 7, 0, 61, 0, 100, 0, 0, 0, 0, 0, 11, 150603, 2, 1, 'Death Speaker Blackthorn - Below 70% HP - Cast Summon Skeletons (Splinterbone Warrior 3)');

DELETE FROM `creature_template_scaling` WHERE `Entry`=74902 AND `DifficultyID`=1;
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(74902, 1, 1, 100, 0, 0, 0, 0);
