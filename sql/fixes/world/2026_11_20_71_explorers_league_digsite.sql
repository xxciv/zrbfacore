-- Explorers' League Digsite, Cape of Stranglethorn (Four, 2026-11-20), plus every vendor option that
-- closed the window instead of opening the vendor.

-- 1. Two quests named 'Dask "The Flask" Gobfizzle' at Bronwyn Hewstrike 44082 AND at Dask 44099 himself.
--    26825 is the version for players who arrive through Wulfred's chain (its text names him); 26826 is
--    the version for the Hero's Call board (PrevQuestID 28702). Both lead to 26823 Too Big For His
--    Britches (26823 accepts either). A player who did both breadcrumbs saw both, and Dask also offered
--    the quests whose job is to walk over to Dask.
--    Now: only Bronwyn starts them; 26825 is offered only to players who have NOT done Hero's Call
--    28702, 26826 only to those who have (its PrevQuestID); one exclusive group so only one can be taken.
DELETE FROM `creature_queststarter` WHERE `id`=44099 AND `quest` IN (26825,26826);
UPDATE `quest_template_addon` SET `ExclusiveGroup`=26825 WHERE `ID` IN (26825,26826);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry`=26825 AND `ConditionTypeOrReference`=8 AND `ConditionValue1`=28702;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,26825,0,0,8,0,28702,0,0,1,0,0,'','Dask "The Flask" Gobfizzle (Wulfred version) only without Hero''s Call: The Cape of Stranglethorn! (26826 is that version)');

-- 2. Linzi Hewstrike 44083: "I would like to buy from you." closed the window. Her menu option (11801)
--    had OptionType 1 (GOSSIP, no submenu = close) instead of 3 (VENDOR, npcflag 128). The dump has 98
--    vendor options like this (same text, OptionType 1, OptionNpcFlag 1, no submenu action); fix them all.
UPDATE `gossip_menu_option` g
LEFT JOIN `gossip_menu_option_action` a ON a.`MenuId`=g.`MenuId` AND a.`OptionIndex`=g.`OptionIndex`
SET g.`OptionType`=3, g.`OptionNpcFlag`=128
WHERE g.`OptionType`=1 AND g.`OptionNpcFlag`=1
  AND (g.`OptionText` LIKE 'I would like to buy%' OR g.`OptionText` LIKE 'Let me browse your goods%')
  AND (a.`MenuId` IS NULL OR (a.`ActionMenuId`=0 AND a.`ActionPoiId`=0));

-- 3. Two Colin Swifthammers. 43043 (guid 300879) is the camp's gryphon master. 52646 (guid 307980) is the
--    level 85 Rise of the Zandalari version (zombie outbreak, quest 29152 Making Contact), sniffed in that
--    event's phase on the exact spot where Dask stands (0.9 yd away). Remove that spawn and let the
--    camp's own Colin 43043 offer Making Contact (level 85, so lower players never see it).
DELETE FROM `creature` WHERE `guid`=307980 AND `id`=52646;
DELETE FROM `creature_addon` WHERE `guid`=307980;
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry`=43043;
DELETE FROM `creature_queststarter` WHERE `id`=43043 AND `quest`=29152;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (43043,29152);
