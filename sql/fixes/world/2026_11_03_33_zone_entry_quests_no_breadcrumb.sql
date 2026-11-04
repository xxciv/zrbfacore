-- Zone entry quests locked behind breadcrumbs (Four, 2026-11-03; same cause as Rerouted! in
-- 2026_11_03_30).
--
-- The core turns quest_template_addon.PrevQuestID AND every quest whose NextQuestID points at a quest
-- into hard requirements (ObjectMgr::LoadQuests -> prevQuests; Player::SatisfyQuestPreviousQuest needs
-- one of them rewarded). For the 67 zone entry quests below every such requirement is a breadcrumb:
-- a Hero's Call / Warchief's Command board quest, or a talk-only quest (no quest_objectives) that
-- starts outside the zone. Walking into the zone without picking up a breadcrumb left the first quest
-- hidden. Upstream already fixed Westfall 26209 this way (2026_08_29_03 / 2026_09_08_06); Desolace
-- 14384/14184 are in 2026_11_03_30. Quests whose requirement includes a real or in-zone step are
-- left alone.
--
-- Changed, per quest: PrevQuestID -> 0 where it named one of its breadcrumbs, and NextQuestID -> 0 on
-- those breadcrumbs. The breadcrumbs stay available and still turn in at the same NPC. Each UPDATE only
-- matches the exact old value. Revert: restore the old values named in the comments.


-- 8280 Securing the Supply Lines (MinLevel 40) <- 28527 Warchief's Command: Silithus!; 28528 Hero's Call: Silithus!; 28856 The Sands of Silithus; 28859 The Dunes of Silithus
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28527, 28528, 28856, 28859) AND `NextQuestID` = 8280;

-- 9329 The Forsaken (MinLevel 10) <- 28560 Warchief's Command: Ghostlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 9329 AND `PrevQuestID` = 28560;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28560) AND `NextQuestID` = 9329;

-- 9634 Alien Predators (MinLevel 10) <- 28559 Hero's Call: Bloodmyst Isle!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 9634 AND `PrevQuestID` = 28559;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28559) AND `NextQuestID` = 9634;

-- 9716 Disturbance at Umbrafen Lake (MinLevel 60) <- 39180 Warchief's Command: Zangarmarsh!; 39181 Hero's Call: Zangarmarsh!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 9716 AND `PrevQuestID` = 39180;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (39180, 39181) AND `NextQuestID` = 9716;

-- 10288 Arrival in Outland (MinLevel 58) <- 10119 Through the Dark Portal; 28708 Hero's Call: Outland!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10288 AND `PrevQuestID` = 10119;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (10119, 28708) AND `NextQuestID` = 10288;

-- 10455 The Encroaching Wilderness (MinLevel 65) <- 39199 Hero's Call: Blade's Edge Mountains!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10455 AND `PrevQuestID` = 39199;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (39199) AND `NextQuestID` = 10455;

-- 10476 Fierce Enemies (MinLevel 64) <- 39197 Hero's Call: Nagrand!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10476 AND `PrevQuestID` = 39197;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (39197) AND `NextQuestID` = 10476;

-- 10486 The Encroaching Wilderness (MinLevel 65) <- 39198 Warchief's Command: Blade's Edge Mountains!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10486 AND `PrevQuestID` = 39198;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (39198) AND `NextQuestID` = 10486;

-- 10595 Besieged! (MinLevel 67) <- 11048 Kroghan's Report; 49532 Warchief's Command: Shadowmoon Valley!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10595 AND `PrevQuestID` = 11048;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (11048, 49532) AND `NextQuestID` = 10595;

-- 11167 The New Plague (MinLevel 58) <- 49533 Warchief's Command: Howling Fjord!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 11167 AND `PrevQuestID` = 49533;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49533) AND `NextQuestID` = 11167;

-- 11228 Hell Has Frozen Over... (MinLevel 58) <- 49551 Hero's Call: Howling Fjord!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 11228 AND `PrevQuestID` = 49551;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49551) AND `NextQuestID` = 11228;

-- 11585 Hellscream's Vigil (MinLevel 58) <- 28711 Warchief's Command: Borean Tundra!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 11585 AND `PrevQuestID` = 28711;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28711) AND `NextQuestID` = 11585;

-- 11672 Enlistment Day (MinLevel 58) <- 28709 Hero's Call: Borean Tundra!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 11672 AND `PrevQuestID` = 28709;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28709) AND `NextQuestID` = 11672;

-- 12292 Local Support (MinLevel 63) <- 12511 The Hills Have Us; 39207 Hero's Call: Grizzly Hills!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 12292 AND `PrevQuestID` = 12511;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (12511, 39207) AND `NextQuestID` = 12292;

-- 12468 The Conqueror's Task (MinLevel 63) <- 12487 To Conquest Hold, But Be Careful!; 39206 Warchief's Command: Grizzly Hills!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 12468 AND `PrevQuestID` = 12487;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (12487, 39206) AND `NextQuestID` = 12468;

-- 12521 Where in the World is Hemet Nesingwary? (MinLevel 66) <- 49535 Warchief's Command: Sholazar Basin!; 49553 Hero's Call: Sholazar Basin!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 12521 AND `PrevQuestID` = 49535;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49535, 49553) AND `NextQuestID` = 12521;

-- 12853 Luxurious Getaway! (MinLevel 67) <- 49536 Warchief's Command: Storm Peaks!; 49554 Hero's Call: Storm Peaks!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 12853 AND `PrevQuestID` = 49536;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49536, 49554) AND `NextQuestID` = 12853;

-- 12902 In Search Of Answers (MinLevel 64) <- 49534 Warchief's Command: Zul'Drak!; 49552 Hero's Call: Zul'Drak!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 12902 AND `PrevQuestID` = 49534;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49534, 49552) AND `NextQuestID` = 12902;

-- 13418 Preparations for War (MinLevel 67) <- 49555 Hero's Call: Icecrown!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 13418 AND `PrevQuestID` = 49555;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49555) AND `NextQuestID` = 13418;

-- 13419 Preparations for War (MinLevel 67) <- 49537 Warchief's Command: Icecrown!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 13419 AND `PrevQuestID` = 49537;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49537) AND `NextQuestID` = 13419;

-- 13518 The Last Wave of Survivors (MinLevel 10) <- 26383 Breaking Waves of Change; 26385 Breaking Waves of Change; 28490 Hero's Call: Darkshore!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 13518 AND `PrevQuestID` = 26383;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26383, 26385, 28490) AND `NextQuestID` = 13518;

-- 13594 Don't Forget the Horde (MinLevel 15) <- 28492 Hero's Call: Ashenvale!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 13594 AND `PrevQuestID` = 28492;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28492) AND `NextQuestID` = 13594;

-- 13612 Mor'shan Defense (MinLevel 15) <- 28493 Warchief's Command: Ashenvale!; 28876 To the Mor'shan Rampart
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28493, 28876) AND `NextQuestID` = 13612;

-- 13913 They Took Our Gnomes (MinLevel 20) <- 28539 Hero's Call: Stonetalon Mountains!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 13913 AND `PrevQuestID` = 28539;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28539) AND `NextQuestID` = 13913;

-- 14129 Runaway Shredder! (MinLevel 10) <- 25275 Report to the Labor Captain; 28496 Warchief's Command: Azshara!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 14129 AND `PrevQuestID` = 25275;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (25275, 28496) AND `NextQuestID` = 14129;

-- 24504 Clear the High Road (MinLevel 25) <- 28549 Warchief's Command: Southern Barrens!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 24504 AND `PrevQuestID` = 28549;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28549) AND `NextQuestID` = 24504;

-- 24740 Volcanic Activity (MinLevel 40) <- 28525 Hero's Call: Un'Goro Crater!; 28526 Warchief's Command: Un'Goro Crater!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 24740 AND `PrevQuestID` = 28525;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28525, 28526) AND `NextQuestID` = 24740;

-- 24862 Running the Gauntlet (MinLevel 25) <- 28550 Hero's Call: Southern Barrens!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 24862 AND `PrevQuestID` = 28550;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28550) AND `NextQuestID` = 24862;

-- 24907 Puddle Stomping (MinLevel 40) <- 28509 Warchief's Command: Tanaris!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 24907 AND `PrevQuestID` = 28509;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28509) AND `NextQuestID` = 24907;

-- 24921 Report to Aubrey (MinLevel 25) <- 28551 Hero's Call: Southern Barrens!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 24921 AND `PrevQuestID` = 28551;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28551) AND `NextQuestID` = 24921;

-- 25049 Puddle Stomping (MinLevel 40) <- 28507 Hero's Call: Tanaris!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25049 AND `PrevQuestID` = 28507;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28507) AND `NextQuestID` = 25049;

-- 25210 Signs of Change (MinLevel 35) <- 28510 Warchief's Command: Feralas!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25210 AND `PrevQuestID` = 28510;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28510) AND `NextQuestID` = 25210;

-- 25395 The Stolen Keg (MinLevel 20) <- 26137 Checking on the Boys; 28565 Hero's Call: Wetlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25395 AND `PrevQuestID` = 26137;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26137, 28565) AND `NextQuestID` = 25395;

-- 25447 Signs of Change (MinLevel 35) <- 14410 The Wilds of Feralas; 28511 Hero's Call: Feralas!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25447 AND `PrevQuestID` = 14410;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (14410, 28511) AND `NextQuestID` = 25447;

-- 25478 To the Summit (MinLevel 40) <- 28504 Warchief's Command: Thousand Needles!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25478 AND `PrevQuestID` = 28504;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28504) AND `NextQuestID` = 25478;

-- 25674 Futile Pride (MinLevel 40) <- 28553 Okrilla and the Blasted Lands; 28671 Warchief's Command: Blasted Lands!; 28858 Blasted Lands: The Other Side of the World
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25674 AND `PrevQuestID` = 28553;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28553, 28671, 28858) AND `NextQuestID` = 25674;

-- 25710 Minor Distractions (MinLevel 40) <- 28673 Hero's Call: Blasted Lands!; 28857 Blasted Lands: The Other Side of the World
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25710 AND `PrevQuestID` = 28673;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28673, 28857) AND `NextQuestID` = 25710;

-- 25924 Call of Duty (MinLevel 80) <- 27718 Warchief's Command: Vashj'ir!; 28816 To the Depths
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25924 AND `PrevQuestID` = 27718;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (27718, 28816) AND `NextQuestID` = 25924;

-- 25945 We're Here to Do One Thing, Maybe Two... (MinLevel 20) <- 28532 Warchief's Command: Stonetalon Mountains!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25945 AND `PrevQuestID` = 28532;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28532) AND `NextQuestID` = 25945;

-- 26022 First Blood (MinLevel 25) <- 28572 Warchief's Command: Arathi Highlands!; 28619 Warchief's Command: Arathi Highlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26022 AND `PrevQuestID` = 28572;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28572, 28619) AND `NextQuestID` = 26022;

-- 26093 Northfold Manor (MinLevel 25) <- 26139 Into Arathi; 28573 Hero's Call: Arathi Highlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26093 AND `PrevQuestID` = 26139;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26139, 28573) AND `NextQuestID` = 26093;

-- 26238 The Savage Dwarves (MinLevel 30) <- 28574 Warchief's Command: The Hinterlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26238 AND `PrevQuestID` = 28574;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28574) AND `NextQuestID` = 26238;

-- 26293 Machines of War (MinLevel 84) <- 28717 Warchief's Command: Twilight Highlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26293 AND `PrevQuestID` = 28717;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28717) AND `NextQuestID` = 26293;

-- 26503 Still Assessing the Threat (MinLevel 15) <- 26365 Hero's Call: Redridge Mountains!; 28563 Hero's Call: Redridge Mountains!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26503 AND `PrevQuestID` = 26365;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26365, 28563) AND `NextQuestID` = 26503;

-- 26547 A Mangy Threat (MinLevel 30) <- 26542 Hero's Call: The Hinterlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26547 AND `PrevQuestID` = 26542;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26542) AND `NextQuestID` = 26547;

-- 26618 Wolves at Our Heels (MinLevel 20) <- 26728 Hero's Call: Duskwood!; 28564 Hero's Call: Duskwood!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26618 AND `PrevQuestID` = 26728;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26728, 28564) AND `NextQuestID` = 26618;

-- 26682 A Shambling Threat (MinLevel 35) <- 26701 Flight to Brackenwall; 28554 Warchief's Command: Dustwallow Marsh!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26682 AND `PrevQuestID` = 26701;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26701, 28554) AND `NextQuestID` = 26682;

-- 26735 The Fate of Kurzen (MinLevel 25) <- 26838 Rebels Without a Clue; 28699 Hero's Call: Northern Stranglethorn!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26735 AND `PrevQuestID` = 26838;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26838, 28699) AND `NextQuestID` = 26735;

-- 26826 Dask "The Flask" Gobfizzle (MinLevel 30) <- 28702 Hero's Call: The Cape of Stranglethorn!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26826 AND `PrevQuestID` = 28702;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28702) AND `NextQuestID` = 26826;

-- 26854 The Lost Pilot (MinLevel 10) <- 28567 Hero's Call: Loch Modan!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26854 AND `PrevQuestID` = 28567;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28567) AND `NextQuestID` = 26854;

-- 26921 Scourge First... Alliance Later (MinLevel 35) <- 26920 The Battle for Andorhal; 28508 The Battle for Andorhal; 28575 Warchief's Command: Western Plaguelands!; 28750 The Battle for Andorhal
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26921 AND `PrevQuestID` = 26920;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26920, 28508, 28575, 28750) AND `NextQuestID` = 26921;

-- 26960 My Son, the Prince (MinLevel 84) <- 28716 Hero's Call: Twilight Highlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26960 AND `PrevQuestID` = 28716;

-- 26965 The Warchief Cometh (MinLevel 10) <- 26964 Warchief's Command: Silverpine Forest!; 28568 Warchief's Command: Silverpine Forest!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 26965 AND `PrevQuestID` = 26964;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26964, 28568) AND `NextQuestID` = 26965;

-- 27003 Easy Money (MinLevel 83) <- 28295 Meetup with the Caravan; 28296 Meetup with the Caravan; 28557 Warchief's Command: Uldum!; 28558 Hero's Call: Uldum!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27003 AND `PrevQuestID` = 28295;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28295, 28296, 28557, 28558) AND `NextQuestID` = 27003;

-- 27203 The Maelstrom (MinLevel 82) <- 27722 Warchief's Command: Deepholm!; 27727 Hero's Call: Deepholm!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27203 AND `PrevQuestID` = 27722;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (27722, 27727) AND `NextQuestID` = 27203;

-- 27367 Gidwin Goldbraids (MinLevel 40) <- 28577 Warchief's Command: Eastern Plaguelands!; 28578 Hero's Call: Eastern Plaguelands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27367 AND `PrevQuestID` = 28577;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28577, 28578) AND `NextQuestID` = 27367;

-- 27587 Maliciously Delicious (MinLevel 40) <- 28569 The Bogpaddle Bullet; 28570 The Bogpaddle Bullet; 28675 Hero's Call: Swamp of Sorrows!; 28677 Warchief's Command: Swamp of Sorrows!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27587 AND `PrevQuestID` = 28569;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28569, 28570, 28675, 28677) AND `NextQuestID` = 27587;

-- 27762 Fuselight, Ho! (MinLevel 40) <- 28579 Hero's Call: Badlands!; 28580 Warchief's Command: Badlands!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27762 AND `PrevQuestID` = 28579;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28579, 28580) AND `NextQuestID` = 27762;

-- 27963 A New Master... But Who? (MinLevel 40) <- 28512 To the Aid of the Thorium Brotherhood; 28581 Warchief's Command: Searing Gorge!; 28582 Hero's Call: Searing Gorge!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27963 AND `PrevQuestID` = 28512;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28512, 28581, 28582) AND `NextQuestID` = 27963;

-- 27997 The Corruption of the Jadefire (MinLevel 40) <- 28542 Warchief's Command: Felwood!; 28543 Hero's Call: Felwood!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27997 AND `PrevQuestID` = 28542;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28542, 28543) AND `NextQuestID` = 27997;

-- 28096 Welcome to the Machine (MinLevel 15) <- 28089 Warchief's Command: Hillsbrad Foothills!; 28571 Warchief's Command: Hillsbrad Foothills!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 28096 AND `PrevQuestID` = 28089;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28089, 28571) AND `NextQuestID` = 28096;

-- 28174 Burning Vengeance (MinLevel 40) <- 28666 Hero's Call: Burning Steppes!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 28174 AND `PrevQuestID` = 28666;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28666) AND `NextQuestID` = 28174;

-- 28418 Burning Vengeance (MinLevel 40) <- 28667 Warchief's Command: Burning Steppes!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 28418 AND `PrevQuestID` = 28667;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28667) AND `NextQuestID` = 28418;

-- 30079 What's Eating Zhu's Watch? (MinLevel 81) <- 29873 Ken-Ken; 49540 Warchief's Command: Krasarang Wilds!; 49558 Hero's Call: Krasarang Wilds!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 30079 AND `PrevQuestID` = 29873;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (29873, 49540, 49558) AND `NextQuestID` = 30079;

-- 31001 Falling Down (MinLevel 84) <- 31895 Better Off Dread; 49543 Warchief's Command: Dread Wastes!; 49561 Hero's Call: Dread Wastes!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 31001 AND `PrevQuestID` = 31895;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (31895, 49543, 49561) AND `NextQuestID` = 31001;

-- 31254 The Road to Kun-Lai (MinLevel 82) <- 49559 Hero's Call: Kun-Lai Summit!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 31254 AND `PrevQuestID` = 49559;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49559) AND `NextQuestID` = 31254;

-- 31255 The Road to Kun-Lai (MinLevel 82) <- 49541 Warchief's Command: Kun-Lai Summit!
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 31255 AND `PrevQuestID` = 49541;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (49541) AND `NextQuestID` = 31255;
