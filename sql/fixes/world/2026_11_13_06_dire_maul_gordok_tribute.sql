-- Dire Maul, Gordok Commons (map 429): the classic "tribute run" ending after King Gordok dies.
--
-- Found (Four, 2026-11-13): the Gordok Tribute chest 179564 is a fixed spawn (guid 189238) next to King
-- Gordok, lootable at any time; Mizzle the Crafty 14353 stands in the courtyard from the start (guid
-- 323984), so his gossip summons a second tribute; Cho'Rush the Observer 14324 keeps fighting after
-- King Gordok 11501 dies. The BFA dump has Mizzle's own script (walk in, say lines, crown, summon the
-- tribute once) but nothing ever summons him.
--
-- Changed, following AzerothCore's script for the same event:
--   1. Static Gordok Tribute guid 189238 and static Mizzle guid 323984 deleted.
--   2. King Gordok SmartAI ids 100-101: on death summon Mizzle at the start of his path (waypoints 14353),
--      and set data 1 1 on Cho'Rush.
--   3. Cho'Rush SmartAI ids 100-102: on data 1 1 yell (creature_text 14324/0 from AzerothCore), faction 35,
--      evade. A Cho'Rush who is still alive accepts the new king instead of fighting on.
--   4. Mizzle's "Henchmen? Tribute?" gossip option needs the King of the Gordok aura 22799 (AzerothCore
--      condition; the dump only had the opposite one on the first option).
--   5. Gordok Tribute loot 16577: the single reference roll 12007 (loot mode 1, up to 2 rolls) is replaced
--      by five rolls on loot modes 2, 4, 8, 16, 32. tools/bfa/dire-maul-north.patch turns on one of those
--      modes for each Gordok guard still alive (Mol'dar, Fengus, Slip'kik, Kromcrush, Cho'Rush).

-- 1.
DELETE FROM `gameobject` WHERE `guid` = 189238 AND `id` = 179564;
DELETE FROM `gameobject_addon` WHERE `guid` = 189238;
DELETE FROM `creature` WHERE `guid` = 323984 AND `id` = 14353;
DELETE FROM `creature_addon` WHERE `guid` = 323984;

-- 2.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 11501 AND `source_type` = 0 AND `id` IN (100, 101);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11501, 0, 100, 101, 6, 0, 100, 0, 0, 0, 0, 0, 0, 12, 14353, 8, 0, 0, 0, 0, 8, 0, 0, 0, 683.297, 484.384, 29.5445, 0.0174533, 'King Gordok - On Death - Summon Mizzle the Crafty'),
(11501, 0, 101, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 19, 14324, 100, 0, 0, 0, 0, 0, 'King Gordok - Linked - Set Data 1 1 on Cho''Rush the Observer');

-- 3.
DELETE FROM `creature_text` WHERE `CreatureID` = 14324 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(14324, 0, 0, 'The king is dead - OH NOES! Summon Mizzle da Crafty! He knows what to do next!', 14, 0, 100, 0, 0, 0, 0, 0, 'Cho''Rush the Observer - King Gordok died');
DELETE FROM `smart_scripts` WHERE `entryorguid` = 14324 AND `source_type` = 0 AND `id` IN (100, 101, 102);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(14324, 0, 100, 101, 38, 0, 100, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Cho''Rush the Observer - On Data Set 1 1 - Yell'),
(14324, 0, 101, 102, 61, 0, 100, 0, 0, 0, 0, 0, 0, 2, 35, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Cho''Rush the Observer - Linked - Set Faction Friendly'),
(14324, 0, 102, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Cho''Rush the Observer - Linked - Evade');

-- 4.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 5708 AND `SourceEntry` = 1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 5708, 1, 0, 0, 1, 0, 22799, 0, 0, 0, 0, 0, '', 'Mizzle the Crafty - show "Henchmen? Tribute?" only with King of the Gordok');

-- 5.
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 16577 AND (`Item` = 12007 OR `Item` BETWEEN 1 AND 5);
INSERT INTO `gameobject_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(16577, 1, 12007, 100, 0, 2, 0, 1, 1, 'Gordok Tribute - guard 1 alive'),
(16577, 2, 12007, 100, 0, 4, 0, 1, 1, 'Gordok Tribute - guard 2 alive'),
(16577, 3, 12007, 100, 0, 8, 0, 1, 1, 'Gordok Tribute - guard 3 alive'),
(16577, 4, 12007, 100, 0, 16, 0, 1, 1, 'Gordok Tribute - guard 4 alive'),
(16577, 5, 12007, 100, 0, 32, 0, 1, 1, 'Gordok Tribute - guard 5 alive');

SELECT CONCAT('Static tribute ', (SELECT COUNT(*) FROM `gameobject` WHERE `id` = 179564),
              ', static Mizzle ', (SELECT COUNT(*) FROM `creature` WHERE `id` = 14353),
              ', Gordok rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 11501 AND `id` >= 100),
              ', Cho''Rush rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 14324 AND `id` >= 100),
              ', tribute rolls ', (SELECT COUNT(*) FROM `gameobject_loot_template` WHERE `Entry` = 16577 AND `Reference` = 12007)) AS `check`;
