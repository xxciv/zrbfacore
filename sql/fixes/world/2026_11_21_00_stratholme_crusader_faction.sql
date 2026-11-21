-- Stratholme (map 329), Main Gate, 2026-11-21: Argent Crusaders standing idle next to the Risen.
--
-- Found: many Argent Crusaders 45346 stood next to Risen Guardsmen, Sorcerers and Defenders without fighting,
--   while the ones next to skeletons and cadavers fought.
-- Cause: the crusaders use faction template 2131 (Argent Crusade), whose only enemies are faction 1107 and the
--   Scourge (20). The Risen use template 67 (Scarlet Crusade, faction 56), and neither side lists the other, so
--   they are neutral. Creature vs creature attacks need one side to be hostile (Unit::_IsValidAttackTarget), so
--   the attack start rows from 2026_11_20_00 could not stick on a Risen either.
-- Changed:
--   1. Crusader 45346 faction 2131 -> 2115 (Actor Good, the template the Rageclaw allies in Zul'Drak use):
--      friendly to players, hostile to every monster faction, so also to the Risen. The Risen still ignore the
--      crusaders until a crusader hits them.
--   2. Hostile to every monster also means natural aggro on bosses and rats across the street, so the crusaders
--      are made defensive on spawn and after each fight (id 19): they only fight what their start rows pick,
--      or what attacks them.
--   3. Start rows for the seven staged Main Gate kinds that had none (id 12-18): Risen Inquisitor, Risen Battle
--      Mage, Risen Monk, Ravaged and Broken Cadavers, Vengeful Phantom, Patchwork Horror. Same rule as id 0-11:
--      out of combat, every 2-4 seconds, attack the closest one within 8 yards.
-- Not changed: Service Entrance crusaders 45456; the Eye of Naxxramas (flies out of reach).

UPDATE `creature_template` SET `faction` = 2115 WHERE `entry` = 45346;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 45346 AND `source_type` = 0 AND `id` BETWEEN 12 AND 19;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(45346, 0, 12, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10426, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Risen Inquisitor'),
(45346, 0, 13, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10425, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Risen Battle Mage'),
(45346, 0, 14, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 11043, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Risen Monk'),
(45346, 0, 15, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10381, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Ravaged Cadaver'),
(45346, 0, 16, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10383, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Broken Cadaver'),
(45346, 0, 17, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10387, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Vengeful Phantom'),
(45346, 0, 18, 0, 1, 0, 100, 0, 2000, 4000, 2000, 4000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 10414, 8, 0, 0, 0, 0, 0, 'Argent Crusader - OOC - Attack Closest Patchwork Horror'),
(45346, 0, 19, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 8, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Argent Crusader - On Reset - Set Reactstate Defensive');

-- Check
SELECT CONCAT('Crusader faction ', (SELECT `faction` FROM `creature_template` WHERE `entry` = 45346),
              ', start rows ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 45346 AND `source_type` = 0 AND `action_type` = 49),
              ', defensive row ', (SELECT COUNT(*) FROM `smart_scripts` WHERE `entryorguid` = 45346 AND `source_type` = 0 AND `action_type` = 8)) AS `stratholme_crusaders`;
