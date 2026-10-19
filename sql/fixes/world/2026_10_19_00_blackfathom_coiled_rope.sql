-- Blackfathom Deeps (redesign): the Coiled Rope shortcut, second try.
-- Four's run 2026-10-19: the Rope Ladder Post at the bottom (224747) worked before anyone had used the
-- Coiled Rope, and using the Coiled Rope changed nothing anyone could see.
--
-- In the sniff, the second Rope Ladder Post (224628, beside the Coiled Rope) and the Invisible Man next
-- to it (74997) appear only after the Coiled Rope is used (CreateObject2); 2026_10_17_03 spawned them
-- from the start. The bottom post's 0x10 (not selectable) flag doesn't stop the client from using it,
-- and the core doesn't check that flag either, so the climb spell itself now checks for the deployed rope.

-- 1. The top post and its Invisible Man are no longer spawned from the start; the Coiled Rope summons them.
--    (Creature guid 4800007 is Ghamoo-Ra: only the gameobject 4800007 goes.)
DELETE FROM `gameobject` WHERE `guid` = 4800007 AND `id` = 224628;
DELETE FROM `spawn_group` WHERE `spawnType` = 1 AND `spawnId` = 4800007;
DELETE FROM `creature` WHERE `guid` = 4800158 AND `id` = 74997;
DELETE FROM `creature_addon` WHERE `guid` = 4800158;
DELETE FROM `spawn_group` WHERE `spawnType` = 0 AND `spawnId` = 4800158;

-- 2. Using the Coiled Rope (once per instance): summon the top post and its Invisible Man where the sniff
--    has them, make the bottom post usable, take the "usable" sparkle off the Invisible Man 75000 at the
--    Coiled Rope, and make the Coiled Rope itself unselectable.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 224627 AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(224627, 1, 0, 1, 64, 0, 100, 1, 1, 0, 0, 0, 0, '', 12, 74997, 8, 0, 0, 0, 0, 8, 0, 0, 0, -289.306, 82.3385, -52.1101, 5.11362, 'Coiled Rope - On use (once) - Summon Invisible Man at the top post'),
(224627, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 50, 224628, 7200, 0, 0, 0, 0, 8, 0, 0, 0, -289.2704, 82.3707, -52.2637, 5.26897, 'Coiled Rope - Linked - Summon Rope Ladder Post (top)'),
(224627, 1, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 106, 16, 0, 0, 0, 0, 0, 15, 224747, 40, 0, 0, 0, 0, 0, 'Coiled Rope - Linked - Make Rope Ladder Post (bottom) selectable'),
(224627, 1, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 28, 150866, 0, 0, 0, 0, 0, 11, 75000, 10, 0, 0, 0, 0, 0, 'Coiled Rope - Linked - Remove Coiled Rope Usable from Invisible Man'),
(224627, 1, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 104, 16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coiled Rope - Linked - Not selectable any more');

-- 3. The summoned Invisible Man casts Rope Ladder (150850) at the Invisible Man by the bottom post (74998).
--    Its second effect is an aura on the nearest creature of an entry its conditions name; this is the
--    likely source of the rope drawn between the posts.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 74997 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(74997, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 11, 150850, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Invisible Man (top post) - Just summoned - Cast Rope Ladder');

-- 4. Rope Ladder Climb (150851, cast by the player using the bottom post) only works once the top post's
--    Invisible Man exists, i.e. after the Coiled Rope was used. It still jumps you to the Invisible Man 75000.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (13, 17) AND `SourceEntry` IN (150850, 150851);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 2, 150850, 0, 0, 31, 0, 3, 74998, 0, 0, 0, 0, '', 'Rope Ladder - aura on the Invisible Man by the bottom post'),
(13, 1, 150851, 0, 0, 31, 0, 3, 75000, 0, 0, 0, 0, '', 'Rope Ladder Climb - jump to the Invisible Man at the top of the rope'),
(17, 0, 150851, 0, 0, 29, 0, 74997, 40, 0, 0, 0, 0, '', 'Rope Ladder Climb - only after the Coiled Rope was used');
