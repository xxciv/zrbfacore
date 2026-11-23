-- Blackrock Depths (map 230): Detention Block, 2026-11-22. Goes with blackrock-depths.patch (same day).
--
-- 1. Scenarios: map 230 has one per Dungeon Finder wing (669 Detention Block, 670 Upper City) and 671 for the
--    whole dungeon. The `scenarios` row linked 671 to every run; blackrock-depths.patch picks the scenario per
--    run, so the row goes (it was: 230, 1, 671, 671).
-- 2. The Dungeon Finder ended the Detention Block at High Interrogator Gerstahn (instance encounter 227), the
--    first boss on the way in. The patch ends it with the scenario's main step (Lord Incendius and Fineous
--    Darkvire) instead.
-- 3. Ring of Law: High Justice Grimstone stood in the arena from the start (the Ring of Law trigger summons
--    him, so the event ran twice), and 18 of the event's beasts and champions stood in the arena and its pens:
--    6 Burrowing Thundersnouts, 4 Deep Stingers, 6 Cave Creepers, Eviscerator and Ok'thor the Breaker. The 8.x
--    sniff caught the event's summons; AzerothCore has none of them. Removed, backed up in zr_backup_brd_creature.
-- 4. 48 spawn points had two creatures on the exact same spot (one random-entry spawn point sniffed twice, for
--    example a Guardsman and a Warden at the Detention Block door). One of each pair removed, keeping the entry
--    AzerothCore has there, else the older spawn. Same backup table. None is in a formation, pool or script.
-- 5. Warbringer Construct 8905: the 8.x template made all ten untargetable but left them hostile, so they could
--    hit a player who could not hit back. Now peaceful scenery (immune to players and creatures).
-- 6. Black Vault: the twelve Relic Coffer Doors stood open but their coffers stayed unclickable. Doors closed
--    again (Relic Coffer Key 11078 opens one), and opening a door makes its coffer clickable (AzerothCore
--    scripts); the same for the Dark Coffer (Dark Keeper Key 11197). The Secret Safe with the Heart of the
--    Mountain opens when Watchman Doomgrip dies (patch).
-- 7. Thunderheart 45824 and Warlord Goretooth 45840, Horde quest givers in the Upper City, used faction 83
--    (hostile to the Alliance). Now 35 like the other quest givers here.

-- 1. Scenario row
DELETE FROM `scenarios` WHERE `map` = 230;

-- 2. Dungeon Finder end of the Detention Block
UPDATE `instance_encounters` SET `lastEncounterDungeon` = 0 WHERE `entry` = 227 AND `lastEncounterDungeon` = 30;

-- 3 and 4. Event statics and stacked spawns
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `guid` IN (
    322257, 322258, 322259, 322260, 322261, 322262, 322263, 327503, 327504, 327505, 327506, 355191, 355192,
    355193, 355194, 355195, 355196, 322265, 327507);
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `guid` IN (
    321423, 321422, 322401, 322402, 322400, 322397, 321851, 322406, 322293, 321787, 322313, 322355, 321745,
    322349, 322344, 322420, 322422, 321694, 322423, 322424, 322309, 322308, 322307, 322342, 322433, 322432,
    322431, 322428, 322408, 322407, 322396, 322395, 322394, 321870, 322159, 322343, 322190, 322325, 322324,
    322323, 322320, 322173, 322295, 322294, 322290, 322286, 322244, 322230);
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `zr_backup_brd_creature`);
DELETE FROM `creature` WHERE `map` = 230 AND `guid` IN (SELECT `guid` FROM `zr_backup_brd_creature`);

-- 5. Warbringer Constructs
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 768 WHERE `entry` = 8905;

-- 6. Black Vault coffers
UPDATE `gameobject` SET `state` = 1 WHERE `map` = 230 AND `id` IN (174554,174555,174556,174557,174558,174559,174560,174561,174562,174563,174564,174566);
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI' WHERE `entry` IN (174554,174555,174556,174557,174558,174559,174560,174561,174562,174563,174564,174566, 174565);
DELETE FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` IN (174554,174555,174556,174557,174558,174559,174560,174561,174562,174563,174564,174566, 174565);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(174554, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174555, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174556, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174557, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174558, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174559, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174560, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174561, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174562, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174563, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174564, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174566, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160836, 5, 0, 0, 0, 0, 0, 'Relic Coffer Door - On Opened - Make Relic Coffer Selectable'),
(174565, 1, 0, 0, 64, 0, 100, 0, 0, 0, 0, 0, 0, 106, 16, 0, 0, 0, 0, 0, 20, 160845, 10, 0, 0, 0, 0, 0, 'Dark Coffer Door - On Opened - Make Dark Coffer Selectable');

-- 7. Horde quest givers
UPDATE `creature_template` SET `faction` = 35 WHERE `entry` IN (45824, 45840);

-- Check
SELECT CONCAT('Scenario rows for map 230 ', (SELECT COUNT(*) FROM `scenarios` WHERE `map` = 230),
    ', Gerstahn ends a dungeon ', (SELECT `lastEncounterDungeon` FROM `instance_encounters` WHERE `entry` = 227),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brd_creature`),
    ', ring statics left ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` IN (10096, 8926, 8928, 8933, 9029, 9030)),
    ', creatures on map 230 ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230),
    ', peaceful constructs ', (SELECT COUNT(*) FROM `creature` c JOIN `creature_template` t ON t.`entry` = c.`id` WHERE c.`map` = 230 AND t.`entry` = 8905 AND t.`unit_flags` & 768 = 768),
    ', closed coffer doors ', (SELECT COUNT(*) FROM `gameobject` WHERE `map` = 230 AND `id` IN (174554,174555,174556,174557,174558,174559,174560,174561,174562,174563,174564,174566, 174565) AND `state` = 1),
    ', coffer door rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `source_type` = 1 AND `entryorguid` IN (174554,174555,174556,174557,174558,174559,174560,174561,174562,174563,174564,174566, 174565)),
    ', hostile Horde givers ', (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (45824, 45840) AND `faction` <> 35)) AS `check`;
