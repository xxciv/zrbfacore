-- Dire Maul, Gordok Commons (map 429): Knot Thimblejack's ice trap never caught Guard Slip'kik.
--
-- Found: turning in "A Broken Trap" (27118) at the Broken Trap (179485) did nothing. The trap has no
-- script in the BFA dump, Slip'kik 14323 has none for it, and a Fixed Trap (179512, guid 189237) is
-- already spawned on top of the broken one. The Fixed Trap is an inert type 6 trap (radius 0), so it
-- never freezes anything by itself. The quest is also not repeatable, so the trap works once per character.
--
-- Changed, following AzerothCore's script for the same event:
--   1. Static Fixed Trap guid 189237 removed; the Broken Trap (guid 189157) respawn raised to 24 h.
--   2. Broken Trap SmartAI: on reward of 27118 it despawns, summons the Fixed Trap in its place and
--      sets data 1 1 on Guard Slip'kik.
--   3. Guard Slip'kik SmartAI ids 10-14: on data 1 1 he walks to the trap; on arrival he casts Ice Lock
--      22856 on himself (stun, no duration), turns passive and gets unit_flags 768 (immune to players
--      and NPCs), so the group can walk past him. A frozen Slip'kik cannot be killed.
--   4. Quest 27118 repeatable (SpecialFlags |= 1) and given its turn-in text (copied from Pandaria 5.4.8).

-- 1.
DELETE FROM `gameobject` WHERE `guid` = 189237 AND `id` = 179512;
DELETE FROM `gameobject_addon` WHERE `guid` = 189237;
UPDATE `gameobject` SET `spawntimesecs` = 86400 WHERE `guid` = 189157 AND `id` = 179485;

-- 2.
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI' WHERE `entry` = 179485;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 179485 AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(179485, 1, 0, 1, 20, 0, 100, 0, 27118, 0, 0, 0, 0, 99, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Broken Trap - On Quest Reward (A Broken Trap) - Despawn'),
(179485, 1, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 50, 179512, 0, 0, 0, 0, 0, 8, 0, 0, 0, 558.806, 550.065, -25.4008, 3.14159, 'Broken Trap - Linked - Summon Fixed Trap'),
(179485, 1, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 19, 14323, 200, 0, 0, 0, 0, 0, 'Broken Trap - Linked - Set Data 1 1 on Guard Slip''kik');

-- 3.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 14323 AND `source_type` = 0 AND `id` BETWEEN 10 AND 14;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(14323, 0, 10, 11, 38, 0, 100, 0, 1, 1, 0, 0, 0, 59, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Guard Slip''kik - On Data Set 1 1 - Walk'),
(14323, 0, 11, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 69, 1, 0, 0, 0, 0, 0, 8, 0, 0, 0, 558.652, 550.057, -25.4008, 0, 'Guard Slip''kik - Linked - Move To Fixed Trap'),
(14323, 0, 12, 13, 34, 0, 100, 0, 8, 1, 0, 0, 0, 11, 22856, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Guard Slip''kik - On Reached Trap - Cast Ice Lock'),
(14323, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 18, 768, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Guard Slip''kik - Linked - Set Unit Flags Immune To PC/NPC'),
(14323, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Guard Slip''kik - Linked - Set React Passive');

-- 4.
UPDATE `quest_template_addon` SET `SpecialFlags` = `SpecialFlags` | 1 WHERE `ID` = 27118;
DELETE FROM `quest_offer_reward` WHERE `ID` = 27118;
INSERT INTO `quest_offer_reward` (`ID`, `RewardText`, `VerifiedBuild`) VALUES
(27118, 'A large, broken trap lies before you.  From the looks of it, the ogres have tried to repair the trap but to no avail.$B$BA hastily written note lies next to the trap, and strangely enough it details exactly how to repair it: just a few simple adjustments ought to do it.  Were the trap repaired, an ogre passing near it might get trapped, and could be avoided.$B$BClearly, it would seem fortuitous that very few ogres know how to read.$B$BClearly.', 0);

SELECT CONCAT('Trap rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 179485 AND `source_type` = 1),
              ', Slip''kik trap rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 14323 AND `id` BETWEEN 10 AND 14),
              ', static Fixed Traps ', (SELECT COUNT(*) FROM `gameobject` WHERE `id` = 179512),
              ', quest repeatable ', (SELECT `SpecialFlags` & 1 FROM `quest_template_addon` WHERE `ID` = 27118)) AS `check`;
