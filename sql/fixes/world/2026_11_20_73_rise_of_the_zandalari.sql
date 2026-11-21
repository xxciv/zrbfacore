-- Rise of the Zandalari, the 4.1 intro chain in Stranglethorn (Four, 2026-11-20): review of the whole
-- Alliance (29156 -> 29155) and Horde (29157 -> 29253) chains. Needs tools/bfa/zandalari-bwemba-spirit.patch
-- (spell script for 96591). Nothing tied to a quest is dropped: where the dump has a 4.1 copy of an NPC on
-- the spot of the camp's own NPC, the quests move to the camp's NPC and only the stacked copy goes.
-- Digsite zombies stay as Wayfarer left them (2026_11_20_30).

-- 1. Bwemba's spirit 52234 starts or ends 26 quests of the chain, but she only existed when Vol'jin's script
--    cast 96591 (and his gossip menu did not exist). 96591 now has a spell script (follows you, comes back
--    after a flight, teleport, relog or death) and spell_area keeps it on in Northern Stranglethorn and the
--    Cape from Bwemba's Spirit (complete or turned in) until Making Contact is turned in.
DELETE FROM `spell_script_names` WHERE `spell_id`=96591;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (96591,'spell_zg_event_bwemba_spirit');
DELETE FROM `spell_area` WHERE `spell`=96591;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`teamId`,`racemask`,`gender`,`flags`,`quest_start_status`,`quest_end_status`) VALUES
(96591,33,29100,29152,0,-1,0,2,3,66,11),
(96591,5287,29100,29152,0,-1,0,2,3,66,11),
(96591,33,29219,29250,0,-1,0,2,3,66,11),
(96591,5287,29219,29250,0,-1,0,2,3,66,11);
-- Bwemba in Stormwind / Orgrimmar also offers To Fort Livingston / To Bambala: only after Bwemba's Spirit,
-- so the spirit (who carries the rest of the chain) is always with you.
UPDATE `quest_template_addon` SET `PrevQuestID`=29100 WHERE `ID`=29102;
UPDATE `quest_template_addon` SET `PrevQuestID`=29219 WHERE `ID`=29220;

-- 2. Vol'jin 52767 (Booty Bay): Bwemba's Spirit 29100 / 29219 needs his credit 52930, given from gossip
--    menu 52767, which did not exist (gossip_menu_id 0, no gossip flag). One option while either quest is
--    in progress: closes the window, gives the credit, runs his scene (timed list 5276700, unchanged) and
--    summons the spirit if you don't have her yet.
UPDATE `creature_template` SET `npcflag`=`npcflag`|1, `gossip_menu_id`=52767 WHERE `entry`=52767;
DELETE FROM `gossip_menu_option` WHERE `MenuId`=52767;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(52767,0,0,'Bwemba sent me to speak with you.',0,1,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=52767;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=52767 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,52767,0,0,0,47,0,29100,8,0,0,0,0,'','Vol''jin: Bwemba sent me (Alliance) while Bwemba''s Spirit 29100 is in progress'),
(15,52767,0,0,1,47,0,29219,8,0,0,0,0,'','Vol''jin: Bwemba sent me (Horde) while Bwemba''s Spirit 29219 is in progress'),
(22,4,52767,0,0,1,0,96591,1,0,1,0,0,'','Vol''jin: summon Bwemba''s spirit only if the player does not have her');
DELETE FROM `smart_scripts` WHERE `entryorguid`=52767 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52767,0,0,1,62,0,100,0,52767,0,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Vol''jin - On Gossip Select - Close Gossip'),
(52767,0,1,2,61,0,100,0,0,0,0,0,0,'',33,52930,0,0,0,0,0,7,0,0,0,0,0,0,0,'Vol''jin - On Gossip Select - Credit Phase Master (Bwemba''s Spirit)'),
(52767,0,2,0,61,0,100,0,0,0,0,0,0,'',80,5276700,0,2,0,0,0,1,0,0,0,0,0,0,0,'Vol''jin - On Gossip Select - Run Scene'),
(52767,0,3,0,62,0,100,0,52767,0,0,0,0,'',85,96591,2,0,0,0,0,7,0,0,0,0,0,0,0,'Vol''jin - On Gossip Select - Invoker Cast ZG Event Phase - Bwemba (after the credit, see condition)');

-- 3. To the Digsite 29133 (Alliance): starter James Stillair 52753 was never spawned; his 4.1 spawn (MaNGOS
--    guid 307972) is on the exact spot of the Rebel Camp's own James Stillair 43045 (guid 300886). So 43045
--    now offers 29133 and the ride, from gossip menu 12783 (52753's menu, it had no options): the flight
--    master option plus "take me to the digsite" while 29133 is in progress (credit 52762, then teleport).
UPDATE `creature_template` SET `npcflag`=`npcflag`|2, `gossip_menu_id`=12783 WHERE `entry`=43045;
DELETE FROM `creature_queststarter` WHERE `id`=43045 AND `quest`=29133;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (43045,29133);
DELETE FROM `gossip_menu_option` WHERE `MenuId`=12783;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(12783,0,2,'Show me where I can fly.',12271,4,8192,0),
(12783,1,0,'I need to get to the Explorers'' League Digsite.',0,1,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12783;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12783,1,0,0,47,0,29133,8,0,0,0,0,'','James Stillair: ride to the digsite while To the Digsite 29133 is in progress');
DELETE FROM `smart_scripts` WHERE `entryorguid`=43045 AND `source_type`=0 AND `id` IN (1,2,3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43045,0,1,2,62,0,100,0,12783,1,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'James Stillair - On Gossip Select - Close Gossip'),
(43045,0,2,3,61,0,100,0,0,0,0,0,0,'',33,52762,0,0,0,0,0,7,0,0,0,0,0,0,0,'James Stillair - On Gossip Select - Credit At the Digsite'),
(43045,0,3,0,61,0,100,0,0,0,0,0,0,'',62,0,0,0,0,0,0,7,0,0,0,-13598.3,-81.5065,36.9852,2.61575,'James Stillair - On Gossip Select - Teleport to the Explorers'' League Digsite');

-- 4. To Hardwrench Hideaway 29236 (Horde): its starter, the 4.1 Thysta 53008 (guid 300919), stands 0.5 yd
--    from Grom'gol's own Thysta 1387 (guid 372309): two Thystas. 1387 now offers 29236; her script already
--    expected option 2 of the flight master menu 6944 (shared by 95 flight masters), which did not exist.
--    Option 2 now shows only on Thysta 1387 while 29236 is in progress. The stacked 53008 spawn goes.
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry`=1387;
DELETE FROM `creature_queststarter` WHERE `id`=1387 AND `quest`=29236;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (1387,29236);
DELETE FROM `creature` WHERE `guid`=300919 AND `id`=53008;
DELETE FROM `creature_addon` WHERE `guid`=300919;
DELETE FROM `gossip_menu_option` WHERE `MenuId`=6944 AND `OptionIndex`=2;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(6944,2,0,'I need to get to Hardwrench Hideaway.',0,1,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=6944 AND `SourceEntry`=2;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,6944,2,0,0,47,0,29236,8,0,0,0,0,'','Thysta: ride to Hardwrench Hideaway while To Hardwrench Hideaway 29236 is in progress'),
(15,6944,2,0,0,51,1,5,1387,0,0,0,0,'','Thysta: ride to Hardwrench Hideaway only on Thysta 1387 (menu 6944 is shared)');
DELETE FROM `smart_scripts` WHERE `entryorguid`=1387 AND `source_type`=0 AND `id` IN (3,4,5);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1387,0,3,4,62,0,100,0,6944,2,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Thysta - On Gossip Select - Close Gossip'),
(1387,0,4,5,61,0,100,0,0,0,0,0,0,'',33,52762,0,0,0,0,0,7,0,0,0,0,0,0,0,'Thysta - On Gossip Select - Credit At the Digsite'),
(1387,0,5,0,61,0,100,0,0,0,0,0,0,'',62,0,0,0,0,0,0,7,0,0,0,-13287.1,721.324,3.69226,5.91598,'Thysta - On Gossip Select - Teleport to Hardwrench Hideaway');

-- 5. Warn Grom'gol 29233 / Defend Grom'gol 29235: the 4.1 Commander Aggro'gosh 52996 (guid 300945) stands
--    6.6 yd from Grom'gol's own Aggro'gosh 2464 (guid 183224): two commanders. 2464 now ends 29233 and
--    starts and ends 29235; the stacked 52996 spawn goes.
DELETE FROM `creature_queststarter` WHERE `id`=2464 AND `quest`=29235;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (2464,29235);
DELETE FROM `creature_questender` WHERE `id`=2464 AND `quest` IN (29233,29235);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (2464,29233),(2464,29235);
DELETE FROM `creature` WHERE `guid`=300945 AND `id`=52996;
DELETE FROM `creature_addon` WHERE `guid`=300945;

-- 6. Nesingwary Will Know 29105 / 29223 end, and Track the Tracker 29114 / 29226 and The Hunter's Revenge
--    29227 start, at the 4.1 Hemet Nesingwary Jr. 52294, who was never spawned (MaNGOS has him 11 yd from
--    the camp's own Hemet 715). The camp's Hemet 715 takes them over.
DELETE FROM `creature_questender` WHERE `id`=715 AND `quest` IN (29105,29223);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (715,29105),(715,29223);
DELETE FROM `creature_queststarter` WHERE `id`=715 AND `quest` IN (29114,29226,29227);
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (715,29114),(715,29226),(715,29227);

-- 7. Serpents and Poison 29103 / 29221: Jungle Serpent 52224 had no spawns. The 56 MaNGOS (4.3.4) spawns,
--    same guids (all free here), around Fort Livingston and Bambala, in new phase 314: only players with
--    either quest in progress see them (they are level 83 and aggressive). Area 33 gets phase 169 as well,
--    or a player with only phase 314 would lose every normal spawn there.
DELETE FROM `creature` WHERE `id`=52224 AND `guid` IN (300913,300941,300952,300953,300971,300979,300980,300981,300982,300983,300985,300986,300987,300989,300992,300993,300994,301006,301009,301010,301011,301014,301016,301037,301041,301042,301043,301044,301045,301046,301047,301048,301049,301051,301055,301063,301064,301065,301066,301067,301068,301069,301070,301071,301072,301073,301074,301075,301076,301078,301084,301085,301086,301087,301089,301090);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(300913,52224,0,33,0,'0',0,314,0,-1,0,0,-11957.8,-551.402,11.941,4.1884,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300941,52224,0,33,0,'0',0,314,0,-1,0,0,-11896.2,-507.974,13.5956,2.40658,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300952,52224,0,33,0,'0',0,314,0,-1,0,0,-12506.3,-72.3807,19.0199,4.50347,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300953,52224,0,33,0,'0',0,314,0,-1,0,0,-12481.3,-168.442,13.1419,-1.97486,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300971,52224,0,33,0,'0',0,314,0,-1,0,0,-12471,-101.085,16.5786,1.60984,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300979,52224,0,33,0,'0',0,314,0,-1,0,0,-12413.5,-345.984,16.0126,1.47206,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300980,52224,0,33,0,'0',0,314,0,-1,0,0,-12573.1,-247.881,16.9574,6.17358,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300981,52224,0,33,0,'0',0,314,0,-1,0,0,-12523.5,-109.482,14.2164,2.41345,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300982,52224,0,33,0,'0',0,314,0,-1,0,0,-12456.6,-185.722,15.7273,1.01154,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300983,52224,0,33,0,'0',0,314,0,-1,0,0,-12588.8,-180.391,15.1009,2.29089,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300985,52224,0,33,0,'0',0,314,0,-1,0,0,-12027.1,-561.277,13.1586,2.93354,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300986,52224,0,33,0,'0',0,314,0,-1,0,0,-11921.1,-581.893,17.0121,4.63207,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300987,52224,0,33,0,'0',0,314,0,-1,0,0,-11939.4,-625.461,15.0265,5.45876,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300989,52224,0,33,0,'0',0,314,0,-1,0,0,-12427.6,-212.743,16.2181,2.41574,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300992,52224,0,33,0,'0',0,314,0,-1,0,0,-12179.5,-654.253,15.3021,2.36172,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300993,52224,0,33,0,'0',0,314,0,-1,0,0,-12126.7,-620.867,13.7687,4.93155,300,3,0,1,0,1,0,0,0,0,0,'',0),
(300994,52224,0,33,0,'0',0,314,0,-1,0,0,-12133.6,-671.781,14.5838,4.11633,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301006,52224,0,33,0,'0',0,314,0,-1,0,0,-11988.1,-888.758,33.169,-2.92541,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301009,52224,0,33,0,'0',0,314,0,-1,0,0,-12141.8,-702.304,17.7742,1.5557,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301010,52224,0,33,0,'0',0,314,0,-1,0,0,-11980.8,-654.825,17.6382,3.00052,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301011,52224,0,33,0,'0',0,314,0,-1,0,0,-11988.8,-885.226,32.5761,-1.64772,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301014,52224,0,33,0,'0',0,314,0,-1,0,0,-12046.9,-1001.04,49.4181,4.43185,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301016,52224,0,33,0,'0',0,314,0,-1,0,0,-11988.7,-604.136,13.4671,2.8075,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301037,52224,0,33,0,'0',0,314,0,-1,0,0,-12082,-769.346,15.7022,-0.383985,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301041,52224,0,33,0,'0',0,314,0,-1,0,0,-12047.4,-743.775,14.3766,3.96156,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301042,52224,0,33,0,'0',0,314,0,-1,0,0,-12089.3,-709.761,15.374,2.28175,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301043,52224,0,33,0,'0',0,314,0,-1,0,0,-12017.1,-783.759,16.58,1.1563,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301044,52224,0,33,0,'0',0,314,0,-1,0,0,-11979.6,-745.223,15.6557,5.07248,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301045,52224,0,33,0,'0',0,314,0,-1,0,0,-11958.8,-709.52,17.6458,3.36983,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301046,52224,0,33,0,'0',0,314,0,-1,0,0,-12013.6,-712.94,14.5096,4.14087,300,0,0,1,0,0,0,0,0,0,0,'',0),
(301047,52224,0,33,0,'0',0,314,0,-1,0,0,-12041.1,-672.691,15.547,0.788474,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301048,52224,0,33,0,'0',0,314,0,-1,0,0,-12085.5,-587.214,12.7411,0,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301049,52224,0,33,0,'0',0,314,0,-1,0,0,-12048.6,-619.143,13.5702,6.01502,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301051,52224,0,33,0,'0',0,314,0,-1,0,0,-12181.8,-816.702,38.214,1.54151,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301055,52224,0,33,0,'0',0,314,0,-1,0,0,-12180,-751.377,21.8033,2.1732,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301063,52224,0,33,0,'0',0,314,0,-1,0,0,-12011.2,-945.246,40.4936,0.701612,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301064,52224,0,33,0,'0',0,314,0,-1,0,0,-12043.4,-895.915,41.2625,-2.75951,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301065,52224,0,33,0,'0',0,314,0,-1,0,0,-12167.9,-962.169,43.8793,0.544169,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301066,52224,0,33,0,'0',0,314,0,-1,0,0,-12178.4,-940.915,42.5037,0.15708,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301067,52224,0,33,0,'0',0,314,0,-1,0,0,-12051.3,-851.868,44.1277,3.07178,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301068,52224,0,33,0,'0',0,314,0,-1,0,0,-12186.4,-840.616,39.9025,5.91667,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301069,52224,0,33,0,'0',0,314,0,-1,0,0,-12009.5,-907.364,34.7478,2.86986,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301070,52224,0,33,0,'0',0,314,0,-1,0,0,-12080.2,-984.049,43.0441,0,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301071,52224,0,33,0,'0',0,314,0,-1,0,0,-12053.3,-891.165,44.3128,3.07178,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301072,52224,0,33,0,'0',0,314,0,-1,0,0,-12067.2,-813.574,43.2273,-2.69584,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301073,52224,0,33,0,'0',0,314,0,-1,0,0,-12152.6,-817.033,41.8021,5.37561,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301074,52224,0,33,0,'0',0,314,0,-1,0,0,-12063.8,-917.587,45.034,2.84811,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301075,52224,0,33,0,'0',0,314,0,-1,0,0,-12115.6,-807.988,39.1378,4.72984,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301076,52224,0,33,0,'0',0,314,0,-1,0,0,-12049.7,-921.448,43.0068,0,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301078,52224,0,33,0,'0',0,314,0,-1,0,0,-12207.6,-865.507,44.3208,0,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301084,52224,0,33,0,'0',0,314,0,-1,0,0,-12063.4,-811.762,42.82,3.07178,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301085,52224,0,33,0,'0',0,314,0,-1,0,0,-12059.8,-918.774,44.8666,3.07178,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301086,52224,0,33,0,'0',0,314,0,-1,0,0,-12053.7,-891.154,44.4238,3.11453,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301087,52224,0,33,0,'0',0,314,0,-1,0,0,-12055.7,-852.156,45.2422,-3.07905,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301089,52224,0,33,0,'0',0,314,0,-1,0,0,-12016.5,-948.321,40.4919,0,300,3,0,1,0,1,0,0,0,0,0,'',0),
(301090,52224,0,33,0,'0',0,314,0,-1,0,0,-12019,-883.915,37.7394,0,300,3,0,1,0,1,0,0,0,0,0,'',0);
DELETE FROM `phase_area` WHERE `AreaId`=33 AND `PhaseId` IN (169,314);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(33,169,'Northern Stranglethorn - always see unphased creatures'),
(33,314,'Northern Stranglethorn - Jungle Serpents while Serpents and Poison 29103 / 29221 is in progress');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=314 AND `SourceEntry`=33;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,314,33,0,0,47,0,29103,8,0,0,0,0,'','Northern Stranglethorn phase 314 while Serpents and Poison 29103 is in progress'),
(26,314,33,0,1,47,0,29221,8,0,0,0,0,'','Northern Stranglethorn phase 314 while Serpents and Poison 29221 is in progress');

-- 8. Serpents and Poison 29221 (Horde): the Injured Bambala Headhunters 52978 have the same click script as
--    the Fort Livingston Adventurers 52225 (Bwemba cleanses them, credit 52307), but no click: no spellclick
--    flag and no npc_spellclick_spells row. Same as 52225 now.
UPDATE `creature_template` SET `npcflag`=`npcflag`|16777216 WHERE `entry`=52978;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=52978;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES (52978,99467,1,0);

-- 9. Defend the Rebel Camp 29131 / Defend Grom'gol 29235 ("help defend for three minutes"): event quests
--    that never started (no SourceSpellID). Accepting now casts the event spell (Mandokir 52411 and Ohgan'aka
--    appear, the Defender aura gives the bar and fails the quest if you die), and Mandokir 52411 completes
--    the event for his summoner after 3 minutes.
UPDATE `quest_template_addon` SET `SourceSpellID`=96983 WHERE `ID`=29131;
UPDATE `quest_template_addon` SET `SourceSpellID`=98003 WHERE `ID`=29235;
DELETE FROM `smart_scripts` WHERE `entryorguid`=52411 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52411,0,0,1,60,0,100,0,178000,178000,0,0,0,'',15,29131,0,0,0,0,0,23,0,0,0,0,0,0,0,'Bloodlord Mandokir - After 3 Minutes - Complete Defend the Rebel Camp for Summoner'),
(52411,0,1,2,61,0,100,0,0,0,0,0,0,'',15,29235,0,0,0,0,0,23,0,0,0,0,0,0,0,'Bloodlord Mandokir - After 3 Minutes - Complete Defend Grom''gol for Summoner'),
(52411,0,2,0,61,0,100,0,0,0,0,0,0,'',41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Bloodlord Mandokir - After 3 Minutes - Despawn');

-- 10. Bury Me With Me Boots... 29121 / 29232: Direhammer's Boots 68937 had no source. Grent says the panther
--     cub at his feet has been pawing at them; the cub 52374 (next to Grent 52371) now hands them over from
--     gossip while either quest is in progress and you don't have the boots.
UPDATE `creature_template` SET `npcflag`=1, `gossip_menu_id`=52374 WHERE `entry`=52374;
DELETE FROM `gossip_menu_option` WHERE `MenuId`=52374;
INSERT INTO `gossip_menu_option` (`MenuId`,`OptionIndex`,`OptionIcon`,`OptionText`,`OptionBroadcastTextId`,`OptionType`,`OptionNpcFlag`,`VerifiedBuild`) VALUES
(52374,0,0,'Let go of Grent''s boots, little one.',0,1,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=52374;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,52374,0,0,0,47,0,29121,8,0,0,0,0,'','Panther Cub: boots while Bury Me With Me Boots 29121 is in progress'),
(15,52374,0,0,0,2,0,68937,1,0,1,0,0,'','Panther Cub: boots only without Direhammer''s Boots'),
(15,52374,0,0,1,47,0,29232,8,0,0,0,0,'','Panther Cub: boots while Bury Me With Me Boots 29232 is in progress'),
(15,52374,0,0,1,2,0,68937,1,0,1,0,0,'','Panther Cub: boots only without Direhammer''s Boots');
DELETE FROM `smart_scripts` WHERE `entryorguid`=52374 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52374,0,0,1,62,0,100,0,52374,0,0,0,0,'',72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Panther Cub - On Gossip Select - Close Gossip'),
(52374,0,1,0,61,0,100,0,0,0,0,0,0,'',56,68937,1,0,0,0,0,7,0,0,0,0,0,0,0,'Panther Cub - On Gossip Select - Give Direhammer''s Boots');
