-- Blackfathom Deeps (redesign): fixes from Four's first full run, 2026-10-18

-- 1. Placeholder templates. These creatures had faction 35 (friendly) and level 1, the values a template
--    gets when the creature was never seen in combat. They now copy the hostile creature of the same name
--    and kind: Twilight Disciples at the prisoners and around Ghamoo-Ra, Ghamoo-Ra's Storm Mender,
--    Subjugator Kor'ul (a bonus boss nobody could attack) and the murlocs in his room.
UPDATE `creature_template` SET `faction` = 14, `minlevel` = 23, `maxlevel` = 23, `mingold` = 200, `maxgold` = 300, `lootid` = 75286, `pickpocketloot` = 75286 WHERE `entry` IN (74989, 75012); -- Twilight Disciple, as 75286
UPDATE `creature_template` SET `faction` = 14, `minlevel` = 24, `maxlevel` = 24, `mingold` = 300, `maxgold` = 400, `lootid` = 74980, `pickpocketloot` = 74980 WHERE `entry` = 75011; -- Twilight Storm Mender, as 74980
UPDATE `creature_template` SET `faction` = 14, `minlevel` = 25, `maxlevel` = 25, `pickpocketloot` = 74476 WHERE `entry` = 74565; -- Subjugator Kor'ul, as Domina 74476
UPDATE `creature_template` SET `faction` = 14, `minlevel` = 24, `maxlevel` = 24, `mingold` = 300, `maxgold` = 400, `lootid` = 74721, `pickpocketloot` = 74721 WHERE `entry` IN (75641, 75642); -- Blindlight Bilefin, as 74721
UPDATE `creature_template` SET `faction` = 14, `minlevel` = 23, `maxlevel` = 23, `mingold` = 100, `maxgold` = 200, `lootid` = 74720, `pickpocketloot` = 74720 WHERE `entry` = 75643; -- Blindlight Murloc, as 74720
UPDATE `creature_template` SET `lootid` = 74720 WHERE `entry` = 75640 AND `lootid` = 0; -- Blindlight Murloc (already hostile), no loot

-- 2. A second, friendly Guardian of the Deep (75410) stood on the ledge by Thruk. The boss (74508) is in its
--    own cave; the copy is removed.
DELETE FROM `creature` WHERE `guid` = 4800176 AND `id` = 75410;
DELETE FROM `creature_addon` WHERE `guid` = 4800176;
DELETE FROM `spawn_group` WHERE `spawnType` = 0 AND `spawnId` = 4800176;

-- 3. The redesign's lines used text range 1 (area): only players in the speaker's area id see them, and
--    inside Blackfathom Deeps players have no valid area id, so nobody did. Range 0 is the normal
--    say/yell distance. Executioner Gore (both), Sentinel Aluwyn, Zeya and the Frightened Prisoner.
UPDATE `creature_text` SET `TextRange` = 0 WHERE `CreatureID` IN (74988, 74518, 75606, 74409, 75428) AND `TextRange` = 1;

-- 4. Classic quests in the redesign. Players can still hold the classic Blackfathom quests, whose items
--    only classic creatures dropped. The redesign's matching creatures now drop them (quest only).
--    Twilight Pendant 5879 (Twilight Falls): every Twilight's Hammer creature.
UPDATE `creature_template` SET `lootid` = 75034 WHERE `entry` = 75034 AND `lootid` = 0; -- Twilight Tormentor had no loot table
DELETE FROM `creature_loot_template` WHERE `Item` = 5879 AND `Entry` IN (74351, 74353, 74363, 74380, 74382, 74980, 74983, 75034, 75058, 75285, 75286, 76036, 76037, 76038, 76039, 77232);
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(74351, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Disciple - Twilight Pendant'),
(74353, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Aquamancer - Twilight Pendant'),
(74363, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Shadow - Twilight Pendant'),
(74380, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Storm Mender - Twilight Pendant'),
(74382, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Shadowmage - Twilight Pendant'),
(74980, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Storm Mender - Twilight Pendant'),
(74983, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Disciple - Twilight Pendant'),
(75034, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Tormentor - Twilight Pendant'),
(75058, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Aquamancer - Twilight Pendant'),
(75285, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Storm Mender - Twilight Pendant'),
(75286, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Disciple - Twilight Pendant'),
(76036, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Shadow - Twilight Pendant'),
(76037, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Storm Mender - Twilight Pendant'),
(76038, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Shadowmage - Twilight Pendant'),
(76039, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Aquamancer - Twilight Pendant'),
(77232, 5879, 0, 100, 1, 1, 0, 1, 1, 'Twilight Disciple - Twilight Pendant');

--    Corrupted Brain Stem 5952 (Researching the Corruption): classic satyrs and naga, the redesign's murlocs.
DELETE FROM `creature_loot_template` WHERE `Item` = 5952 AND `Entry` IN (74719, 74720, 74721, 74984, 75658);
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(74719, 5952, 0, 100, 1, 1, 0, 1, 1, 'Blindlight Rotmouth - Corrupted Brain Stem'),
(74720, 5952, 0, 100, 1, 1, 0, 1, 1, 'Blindlight Murloc - Corrupted Brain Stem'),
(74721, 5952, 0, 100, 1, 1, 0, 1, 1, 'Blindlight Bilefin - Corrupted Brain Stem'),
(74984, 5952, 0, 100, 1, 1, 0, 1, 1, 'Blindlight Murloc - Corrupted Brain Stem'),
(75658, 5952, 0, 100, 1, 1, 0, 1, 1, 'Blindlight Murloc - Corrupted Brain Stem');

--    Head of Kelris 5881 (Blackfathom Villainy) from Twilight Lord Bathiel, who stands where Kelris did, and
--    Strange Water Globe 16782 (starts Baron Aquanis) from Executioner Gore, who stands where Aquanis did.
DELETE FROM `creature_loot_template` WHERE (`Entry` = 74728 AND `Item` = 5881) OR (`Entry` = 74518 AND `Item` = 16782);
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(74728, 5881, 0, 100, 1, 1, 0, 1, 1, 'Twilight Lord Bathiel - Head of Kelris'),
(74518, 16782, 0, 100, 0, 1, 0, 1, 1, 'Executioner Gore - Strange Water Globe');

--    The Fathom Stone (Fathom Core, Amongst the Ruins) and the Pitted Iron Chest (Lorgalis Manuscript,
--    Knowledge in the Deeps) were classic-only spawns. They now show in both layouts (any spawn group
--    outside the redesign's 433-440 does).
DELETE FROM `spawn_group_template` WHERE `groupId` = 442;
INSERT INTO `spawn_group_template` (`groupId`, `groupName`, `groupFlags`) VALUES
(442, 'Blackfathom Deeps - Quest objects, both layouts', 0);
DELETE FROM `spawn_group` WHERE `spawnType` = 1 AND `spawnId` IN (188159, 188182);
INSERT INTO `spawn_group` (`groupId`, `spawnType`, `spawnId`) VALUES
(442, 1, 188159), -- Fathom Stone
(442, 1, 188182); -- Pitted Iron Chest
