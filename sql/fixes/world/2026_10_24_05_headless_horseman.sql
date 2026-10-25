-- The Headless Horseman (Hallow's End) on the Scarlet Monastery graveyard, map 1004.
--
-- The classic script flew the Horseman over map 189, which the 8.3.7 client no longer has, so the
-- Pumpkin Shrine (186267, spawned by game_event 12) did nothing useful. scarlet-monastery.patch now
-- carries a port of the Pandaria 5.4.8 map-1004 script: "Call the Headless Horseman" at the shrine
-- summons him from the soil beside it, he circles the graveyard and lands, and the fight runs in
-- three phases (head, Conflagration, pumpkins). This file binds the scripts and fixes the data around
-- them.

-- Script bindings (the C++ scripts take over from the empty SmartAI the templates pointed at).
UPDATE `creature_template` SET `AIName`='', `ScriptName`='boss_headless_horseman' WHERE `entry`=23682;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_head' WHERE `entry`=23775;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_pulsing_pumpkin' WHERE `entry`=23694;
-- npc_wisp_invis and go_loosely_turned_soil belonged to the classic script and are gone.
UPDATE `creature_template` SET `ScriptName`='' WHERE `entry` IN (23686, 24034) AND `ScriptName`='npc_wisp_invis';
UPDATE `gameobject_template` SET `ScriptName`='' WHERE `entry`=186314 AND `ScriptName`='go_loosely_turned_soil';
UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_pumpkin_shrine' WHERE `entry`=186267;

DELETE FROM `spell_script_names` WHERE `spell_id`=42281;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(42281, 'spell_sprouting');

-- Texts, from the Pandaria set (the BFA rows used the classic group order).
DELETE FROM `creature_text` WHERE `CreatureID` IN (23682, 23775);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(23682, 0, 0, 'It is over, your search is done. Let fate choose now, the righteous one.', 14, 0, 100, 0, 0, 11961, 0, 0, 'Headless Horseman - entrance'),
(23682, 1, 0, 'Here\'s my body, fit and pure! Now, your blackened souls I\'ll cure!', 14, 0, 100, 0, 0, 12567, 0, 0, 'Headless Horseman - head rejoined'),
(23682, 2, 0, 'Harken, cur! Tis you I spurn! Now feel... the burn!', 14, 0, 100, 0, 0, 12573, 0, 0, 'Headless Horseman - Conflagration'),
(23682, 3, 0, 'Soldiers arise, stand and fight! Bring victory at last to this fallen knight!', 14, 0, 100, 0, 0, 11963, 0, 0, 'Headless Horseman - pumpkins'),
(23682, 4, 0, 'Your body lies beaten, battered and broken! Let my curse be your own, fate has spoken!', 14, 0, 100, 0, 0, 11962, 0, 0, 'Headless Horseman - player killed'),
(23682, 4, 1, 'I am over here, you fool of a body!', 14, 0, 100, 0, 0, 12568, 0, 0, 'Headless Horseman - player killed'),
(23682, 5, 0, 'This end have I reached before. What new adventure lies in store?', 14, 0, 100, 0, 0, 11964, 0, 0, 'Headless Horseman - death'),
(23775, 0, 0, 'Get over here, you idiot!', 14, 0, 100, 0, 0, 12575, 0, 0, 'Head of the Horseman - head lost');

-- Level scaling for the dungeon's difficulties (1 normal, 2 heroic). Only DifficultyID 0 rows existed,
-- so in the dungeon these would get a random level ("level ??"). Scale to the player, up to 120.
DELETE FROM `creature_template_scaling` WHERE `Entry` IN (23682, 23775, 23694, 23904) AND `DifficultyID` IN (1, 2);
INSERT INTO `creature_template_scaling` (`Entry`, `DifficultyID`, `LevelScalingMin`, `LevelScalingMax`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `VerifiedBuild`) VALUES
(23682, 1, 1, 120, 0, 0, 0, 0), (23682, 2, 1, 120, 0, 0, 0, 0),
(23775, 1, 1, 120, 0, 0, 0, 0), (23775, 2, 1, 120, 0, 0, 0, 0),
(23694, 1, 1, 120, 0, 0, 0, 0), (23694, 2, 1, 120, 0, 0, 0, 0),
(23904, 1, 1, 120, 0, 0, 0, 0), (23904, 2, 1, 120, 0, 0, 0, 0);

-- Dungeon finder "The Headless Horseman" (285): the arrival spot was the classic map-189 one, which
-- on map 1004 is out in the void. Use the Scarlet Monastery entrance. Its reward rows stopped at
-- level 85; add one for 86-120.
UPDATE `lfg_dungeon_template` SET `position_x`=1124.64, `position_y`=512.467, `position_z`=0.989549, `orientation`=1.5708 WHERE `dungeonId`=285;
DELETE FROM `lfg_dungeon_rewards` WHERE `dungeonId`=285 AND `maxLevel`=120;
INSERT INTO `lfg_dungeon_rewards` (`dungeonId`, `maxLevel`, `firstQuestId`, `otherQuestId`) VALUES
(285, 120, 25482, 0);
