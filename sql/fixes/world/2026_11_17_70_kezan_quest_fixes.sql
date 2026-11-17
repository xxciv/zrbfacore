-- Kezan quest fixes (Quest Fixes thread, 2026-11-17)

-- ---------------------------------------------------------------------------
-- Necessary Roughness (24502)
-- ---------------------------------------------------------------------------
-- The summon spell 70015 looks for the parked Bilgewater Buccaneer 48526. Its target condition
-- was written as legacy type 31 with the new unit type id 5, which the core reads as
-- "gameobject 48526" (a campfire), so the cast always failed and no shredder appeared.
UPDATE `conditions` SET `ConditionTypeOrReference`=51
 WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=70015 AND `ConditionTypeOrReference`=31 AND `ConditionValue1`=5 AND `ConditionValue2`=48526;

-- The parked shredder is hidden by aura 90366 and only seen with detection 90161, which was
-- only given inside Kajaro Field (4822). Coach Crosscheck stands in Bilgewater Port (4767),
-- so at the coach the shredder was invisible and the summon could not target it. Give the
-- detection in all of Kezan.
DELETE FROM `spell_area` WHERE `spell`=90161 AND `area` IN (4822,4737);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`teamId`,`racemask`,`gender`,`flags`,`quest_start_status`,`quest_end_status`) VALUES
(90161,4737,0,0,0,-1,0,2,3,64,11);

-- Parked shredder: clickable while the quest is in progress (spellclick row 70015 already exists).
UPDATE `creature_template` SET `npcflag`=`npcflag`|16777216 WHERE `entry`=48526;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=48526 AND `SourceEntry`=70015;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,48526,70015,0,0,9,0,24502,0,0,0,0,0,'','Bilgewater Buccaneer - spellclick only while Necessary Roughness is in progress');

-- The second objective row (8 sharks) was missing; only the boarding credit existed and had no text.
UPDATE `quest_objectives` SET `Description`='Bilgewater Buccaneer' WHERE `ID`=266618;
DELETE FROM `quest_objectives` WHERE `ID`=266619;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Flags2`,`ProgressBarWeight`,`Description`,`VerifiedBuild`) VALUES
(266619,24502,0,1,1,37114,8,0,0,0,'Steamwheedle Shark Footbombed',35662);

-- Leftovers: a shark listed as quest giver, two extra shark summons on the coach (the core script
-- summons the 8 sharks itself), and one hand-placed permanent shark on the field.
DELETE FROM `creature_queststarter` WHERE `id`=37114 AND `quest`=24502;
DELETE FROM `smart_scripts` WHERE `entryorguid`=37106 AND `source_type`=0 AND `id` IN (1,2) AND `action_type`=11 AND `action_param1`=69971;
DELETE FROM `creature` WHERE `guid`=3530203330003155 AND `id`=37114;
DELETE FROM `creature_addon` WHERE `guid`=3530203330003155;

-- ---------------------------------------------------------------------------
-- Fourth and Goal (28414)
-- ---------------------------------------------------------------------------
-- The second shredder 37213 had no script name, so the core script that seats the player in it
-- never ran.
UPDATE `creature_template` SET `ScriptName`='npc_boucanier_gob' WHERE `entry`=37213;

-- ---------------------------------------------------------------------------
-- 447 (14125)
-- ---------------------------------------------------------------------------
-- The fourth objective (Gasbot) was missing, so the quest completed without the Gasbot.
UPDATE `quest_objectives` SET `Description`='Overload the Defective Generator' WHERE `ID`=266731;
UPDATE `quest_objectives` SET `Description`='Activate the Leaky Stove' WHERE `ID`=266732;
UPDATE `quest_objectives` SET `Description`='Drop a Cigar on the Flammable Bed' WHERE `ID`=266733;
DELETE FROM `quest_objectives` WHERE `ID`=266734;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Flags2`,`ProgressBarWeight`,`Description`,`VerifiedBuild`) VALUES
(266734,14125,0,3,3,37598,1,0,0,0,'KTC Headquarters Set Ablaze with Gasbot!',35662);

-- The Gasbot Control Panel stood in the default phase 169, which the player has left by then
-- (169 ends when The Uninvited Guest is rewarded). Put it in the headquarters phase 382 where
-- Sassy and the three other objects are.
UPDATE `gameobject` SET `PhaseId`=382 WHERE `id`=201736 AND `map`=648 AND `PhaseId`=169;
-- Claims Adjuster (second turn-in for 447) was also left in 169; show him once 447 is complete (384).
UPDATE `creature` SET `phaseId`=384 WHERE `id`=37602 AND `map`=648 AND `phaseId`=169;

-- ---------------------------------------------------------------------------
-- Objective texts (tracker showed "<kill credit name> slain")
-- ---------------------------------------------------------------------------
UPDATE `quest_objectives` SET `Description`='Bruno Flameretardant beaten down' WHERE `ID`=265427;
UPDATE `quest_objectives` SET `Description`='Frankie Gearslipper beaten down' WHERE `ID`=265428;
UPDATE `quest_objectives` SET `Description`='Jack the Hammer beaten down' WHERE `ID`=265429;
UPDATE `quest_objectives` SET `Description`='Sudsy Magee beaten down' WHERE `ID`=265430;
UPDATE `quest_objectives` SET `Description`='Partygoer entertained' WHERE `ID` IN (266170,255509);
