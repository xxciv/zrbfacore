-- Rebel Camp and Nesingwary's Expedition (Northern Stranglethorn), Four 2026-11-20: the dump has the
-- 4.1 (Rise of the Zandalari) copies of named camp NPCs next to the camp's own. Nothing tied to a quest is
-- dropped: the 4.1 Lieutenant Doren's two quests move to the camp's Doren first. The five Nesingwary
-- copies have no quests, no shop, no menu, no script and nothing refers to them.

-- 1. Lieutenant Doren: 469 (guid 171871, classic quests) and the 4.1 copy 52410 (guid 307971, 49 yd away,
--    Warn the Rebel Camp 29124 end, Defend the Rebel Camp 29131 start/end). 469 takes 29124 and 29131.
DELETE FROM `creature_questender` WHERE `id`=469 AND `quest` IN (29124,29131);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (469,29124),(469,29131);
DELETE FROM `creature_queststarter` WHERE `id`=469 AND `quest`=29131;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (469,29131);
DELETE FROM `creature` WHERE `guid`=307971 AND `id`=52410;
DELETE FROM `creature_addon` WHERE `guid`=307971;
-- 469's old script completed 29131 the moment it was accepted (it never fired: 469 did not start 29131).
-- Defend the Rebel Camp now runs its 3 minute event (2026_11_20_73), so that row goes.
DELETE FROM `smart_scripts` WHERE `entryorguid`=469 AND `source_type`=0 AND `id`=0 AND `event_type`=19 AND `action_type`=15;

-- 2. Nesingwary's Expedition: 4.1 copies next to the camp's own (distance to the camp's NPC):
--    Ajeck Rouack 52293 (guid 302758, 9.5 yd from 717), Sir S. J. Erlgadin 52298 (302727, 7 yd from 718),
--    Barnil Stonepot 52291 (302702, 38 yd from 716), Drizzlik 52295 (302699, 44 yd from 2495),
--    Jaquilina Dramet 52296 (302734, 37 yd from 2483).
DELETE FROM `creature` WHERE (`guid`,`id`) IN ((302758,52293),(302727,52298),(302702,52291),(302699,52295),(302734,52296));
DELETE FROM `creature_addon` WHERE `guid` IN (302758,302727,302702,302699,302734);
