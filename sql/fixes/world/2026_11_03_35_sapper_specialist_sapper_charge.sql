-- Sapper Specialist (37925, Southern Barrens): throws dynamite but never uses Sapper Charge at 10% HP
-- (Four, 2026-11-03, testing 2026_11_03_34).
--
-- Sapper Charge 82867 hits a spot at an enemy (effect 0/1 implicit target 53 TARGET_DEST_TARGET_ENEMY)
-- and then kills the caster (effect 2 instakill on self). The SAI rows cast it with target_type 1
-- (self), which is no valid enemy target, so the cast fails every time. The entry also mixes two
-- script versions: ids 0 and 1 exist twice (old version: id 0 'Cast Throw' timer, id 1 'Cast Sapper
-- Charge at 10% HP'; new version: id 0 'Stop Moving on Aggro' linked to id 1 'Cast Throw Dynamite on
-- Aggro'), so the aggro link to id 1 could land on the wrong row.
--
-- Changed: old-version rows (id 0 link 0 event 0, id 1 link 0 event 2) deleted; id 16 'Cast Sapper
-- Charge at 10% HP' now targets the victim (target_type 1 -> 2). Row 29 (scripted run that blows up
-- next to the Triumph defenders) is left as it is. The three spawns that got a copy of the entry
-- script in 2026_11_03_34 (270777, 270847, 270852) get a fresh copy.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 37925 AND `source_type` = 0 AND `id` = 0 AND `link` = 0 AND `event_type` = 0 AND `action_param1` = 7978;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 37925 AND `source_type` = 0 AND `id` = 1 AND `link` = 0 AND `event_type` = 2 AND `action_param1` = 82867;
UPDATE `smart_scripts` SET `target_type` = 2 WHERE `entryorguid` = 37925 AND `source_type` = 0 AND `id` = 16 AND `action_param1` = 82867 AND `target_type` = 1;

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `id` >= 1000 AND `entryorguid` IN (-270777, -270847, -270852);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`)
SELECT g.`guid`, 0, s.`id` + 1000, IF(s.`link` > 0, s.`link` + 1000, 0), s.`event_type`, s.`event_phase_mask`, s.`event_chance`, s.`event_flags`, s.`event_param1`, s.`event_param2`, s.`event_param3`, s.`event_param4`, s.`event_param5`, s.`event_param_string`, s.`action_type`, s.`action_param1`, s.`action_param2`, s.`action_param3`, s.`action_param4`, s.`action_param5`, s.`action_param6`, s.`target_type`, s.`target_param1`, s.`target_param2`, s.`target_param3`, s.`target_x`, s.`target_y`, s.`target_z`, s.`target_o`, s.`comment`
FROM `smart_scripts` s
JOIN (SELECT -c.`guid` AS `guid`, c.`id` AS `entry` FROM `creature` c WHERE c.`guid` IN (270777, 270847, 270852)) g ON s.`entryorguid` = g.`entry`
WHERE s.`source_type` = 0
  AND EXISTS (SELECT 1 FROM `smart_scripts` p WHERE p.`entryorguid` = g.`guid` AND p.`source_type` = 0 AND p.`id` = 0 AND p.`comment` = 'OOC - CS');
