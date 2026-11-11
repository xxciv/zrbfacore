-- zrbfacore: Darkmoon Faire NPC audit (Four, 2026-11-06: "review every quest giver and
-- merchant, make sure their flags are correct, interactable, and have quests that lead to
-- something. ensure their gossips lead somewhere, locales are enUS").
-- Checked every creature on Darkmoon Island (map 974) with a gossip, quest or vendor flag
-- (62 entries) plus the Faire's game_event 3 spawns elsewhere. Goes with the updated
-- tools/bfa/darkmoon-faire-gossip.patch (Jessica Rogers, Rinling, Finlay Coolshot, Maxima,
-- Mola gossip texts). Safe to run more than once.

-- 1. Gossip menus that had options but no text row, so the NPC opened with the generic
-- "Greetings" page. Text ids from the Pandaria 5.4.8 DB; every npc_text exists here.
DELETE FROM `gossip_menu` WHERE (`MenuId`,`TextId`) IN
((8849,11482),(13012,18284),(13013,18286),(13018,18289),(13065,18350),(13066,18352));
INSERT INTO `gossip_menu` (`MenuId`,`TextId`,`VerifiedBuild`) VALUES
(8849,11482,0),  -- Silas Darkmoon (14823)
(13012,18284,0), -- Jessica Rogers (54485), Ring Toss
(13013,18286,0), -- Ring Toss: "How do I play?"
(13018,18289,0), -- Mola (54601), Whack-a-Gnoll
(13065,18350,0), -- Whack-a-Gnoll: "How do I play?"
(13066,18352,0); -- Tonk Challenge: "How do I play?"

-- 2. Ziggie Sparks (85546, Firebird's Challenge 36481) had gossip_menu_id 0, so her own
-- menu 16970 ("How do I play Firebird's Challenge?", "Ready to fly!") and its SAI (option 1
-- casts 170819, menu 16972 option 0 closes) never showed. Menu 16972 had no rows at all:
-- give it npc_text 24704 (broadcast 87078, the text right after the menu's own 24702 /
-- 87077, and not used by any other menu; a guess, the Pandaria DB predates this NPC) and
-- the "I understand." option her SAI expects.
UPDATE `creature_template` SET `gossip_menu_id`=16970 WHERE `entry`=85546;
DELETE FROM `gossip_menu_option_action` WHERE `MenuId`=16970 AND `OptionIndex`=0;
INSERT INTO `gossip_menu_option_action` (`MenuId`,`OptionIndex`,`ActionMenuId`,`ActionPoiId`) VALUES (16970,0,16972,0);
DELETE FROM `gossip_menu` WHERE `MenuId`=16972;
INSERT INTO `gossip_menu` (`MenuId`,`TextId`,`VerifiedBuild`) VALUES (16972,24704,0);
DELETE FROM `gossip_menu_option` WHERE `MenuId`=16972;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(16972,0,0,'I understand.',0,1,1,0);

-- 3. Christoph VonFeasel (85519, Grand Master Pet Tamer, quest 36471 "A New Darkmoon
-- Challenger!") had npcflag 2 (quest giver only). The tamer battle starts from the
-- "Let's do battle!" gossip option (battle-pet-trainers.patch), which needs the gossip
-- flag; Jeremy Feasel (67370) already has npcflag 3.
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry`=85519;

-- 4. Chronos (14833) offered "DEPRECATED: Putting the Carnies Back Together Again" (29512).
-- Blizzard marked it deprecated; the island's Injured Carnies (54518) have no script for it.
DELETE FROM `creature_queststarter` WHERE `id`=14833 AND `quest`=29512;
DELETE FROM `creature_questender` WHERE `id`=14833 AND `quest`=29512;

-- 5. The old Outland Darkmoon Faire in Terokkar Forest (map 530, zone 3519) still spawned
-- with game_event 3: 26 creatures (copies of Silas, Sayge, Rinling, Maxima, the vendors...)
-- and 120 gameobjects. Since Cataclysm the Faire is only on Darkmoon Island, with the
-- Mystic Mages as portals. Keep a copy, then remove them.
CREATE TABLE IF NOT EXISTS `zr_dmf_terokkar_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_dmf_terokkar_creature`
SELECT c.* FROM `creature` c JOIN `game_event_creature` e ON e.`guid`=c.`guid`
WHERE e.`eventEntry`=3 AND c.`map`=530 AND c.`zoneId`=3519;
CREATE TABLE IF NOT EXISTS `zr_dmf_terokkar_gameobject` LIKE `gameobject`;
INSERT IGNORE INTO `zr_dmf_terokkar_gameobject`
SELECT g.* FROM `gameobject` g JOIN `game_event_gameobject` e ON e.`guid`=g.`guid`
WHERE e.`eventEntry`=3 AND g.`map`=530 AND g.`zoneId`=3519;

DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `zr_dmf_terokkar_creature`);
DELETE FROM `game_event_creature` WHERE `eventEntry`=3 AND `guid` IN (SELECT `guid` FROM `zr_dmf_terokkar_creature`);
DELETE FROM `creature` WHERE `guid` IN (SELECT `guid` FROM `zr_dmf_terokkar_creature`);
DELETE FROM `game_event_gameobject` WHERE `eventEntry`=3 AND `guid` IN (SELECT `guid` FROM `zr_dmf_terokkar_gameobject`);
DELETE FROM `gameobject` WHERE `guid` IN (SELECT `guid` FROM `zr_dmf_terokkar_gameobject`);
