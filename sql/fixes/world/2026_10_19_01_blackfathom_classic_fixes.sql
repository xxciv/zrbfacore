-- Blackfathom Deeps (classic layout): fixes from Four's classic run, 2026-10-19

-- 1. Fire of Aku'mai room. Lighting the four fires makes the instance script summon four waves into
--    the side alcoves (4 Aku'mai Snapjaws, 8 Murkshallow Softshells, 2 Aku'mai Servants, 4 Barbed
--    Crustaceans), and the Portal of Aku'mai opens once all 18 summons are dead
--    (npc_blackfathom_deeps_event only counts summons). The DB also had 19 of those creatures standing
--    in the alcoves from the start, waiting to be killed before any fire was lit. They are removed;
--    the waves now come only from the fires.
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 321248 AND 321266;
DELETE FROM `creature` WHERE `guid` BETWEEN 321248 AND 321266 AND `id` IN (4823, 4825, 4977, 4978);

-- 2. Morridune. The instance script summons him at the altar when Aku'mai dies ("Aku'mai is dead! At
--    last, I can leave this wretched place."). A second, spawned one stood there from the start.
DELETE FROM `creature_addon` WHERE `guid` = 327435;
DELETE FROM `creature` WHERE `guid` = 327435 AND `id` = 6729;

-- 3. Two Blackfathom Myrmidons and two Blackfathom Sea Witches stood within 2 yards of each other in the
--    corridor towards Kelris. They now stand about 3 yards apart, still one pack.
UPDATE `creature` SET `position_x` = -607.3, `position_y` = -35.0, `position_z` = -24.9 WHERE `guid` = 321185 AND `id` = 4805;
UPDATE `creature` SET `position_x` = -610.3, `position_y` = -30.7, `position_z` = -24.3 WHERE `guid` = 321205 AND `id` = 4807;
UPDATE `creature` SET `position_x` = -610.0, `position_y` = -27.5, `position_z` = -24.1 WHERE `guid` = 321204 AND `id` = 4805;
