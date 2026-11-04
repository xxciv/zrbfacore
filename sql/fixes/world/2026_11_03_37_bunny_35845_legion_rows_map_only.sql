-- "Dave's Industrial Light and Magic Bunny (Small)(Sessile)" 35845 zaps nearby players and keeps them
-- in combat (Four, 2026-11-03, Southern Barrens spawn 269123 next to the Sapper Specialists).
--
-- 35845 is a generic invisible effect bunny with 144 spawns (Broken Isles 33, Draenor 44, Hyjal 17,
-- Southern Barrens 9, ...). Its entry script mixes rows from many unrelated uses, and three of them
-- fire on a timer (SMART_EVENT_UPDATE 60, in and out of combat) on every spawn:
--   id 3: every 3-8 s cast 206750 on self (school damage + knockback to enemies around the bunny),
--         linked id 4 casts 181569;
--   id 5: send data to Azuregos 104902 (a Broken Isles NPC, map 1220);
--   id 8: every 2-3 s cast 199886 on the closest player within 100 yd (aura on the player).
-- All three are Legion spells/NPCs. Changed: these rows only run on map 1220 (Broken Isles) through
-- SMART_EVENT conditions (source 22, CONDITION_MAPID 22). The data-triggered rows are untouched.
-- Revert: delete the three conditions rows below.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 35845 AND `SourceId` = 0 AND `SourceGroup` IN (4, 6, 9) AND `ConditionTypeOrReference` = 22;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 4, 35845, 0, 0, 22, 1, 1220, 0, 0, 0, 0, 0, '', 'Bunny 35845 SAI id 3 (cast 206750) only on Broken Isles'),
(22, 6, 35845, 0, 0, 22, 1, 1220, 0, 0, 0, 0, 0, '', 'Bunny 35845 SAI id 5 (data to Azuregos) only on Broken Isles'),
(22, 9, 35845, 0, 0, 22, 1, 1220, 0, 0, 0, 0, 0, '', 'Bunny 35845 SAI id 8 (cast 199886 on closest player) only on Broken Isles');
