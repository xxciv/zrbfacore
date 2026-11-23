-- Fishing tournaments: Stranglethorn Fishing Extravaganza and Kalu'ak Fishing Derby (zrbfacore)
--
-- From Four, 2026-11-22: "where have the fishing tournaments gone? ... never seen them announced".
--
-- Stranglethorn Fishing Extravaganza (Sundays 14:00-16:00, holiday 301; the client's Holidays.db2 has
-- the same weekly Sunday 14:00 date):
--   Upstream's 2026_08_16_01_fix_game_events.sql restarted events 14 and 15 but on the wrong times
--   (14 Sunday 12:00 for a day, 15 Monday 02:00) and with a 10079-minute period, which slips a minute
--   earlier every week. Both now repeat every 10080 minutes from Sunday 2026-11-22, like TrinityCore:
--   14 (the promoters Grinkle in Orgrimmar and Barrus in Ironforge) 13:50 for 130 minutes,
--   15 (Riggle Bassbait, Jang, Fishbot 5000 and the 91 Schools of Tastyfish) 14:00 for 120 minutes.
--   Speckled Tastyfish already drop from the schools (upstream 2026_08_20_00_world_fishing_loot_restore).
--   Riggle, Jang, Fishbot, Grinkle and Barrus were each spawned twice: an old spawn and the newer
--   sniffed one (guids 315467/315470/315471 on Riggle's balcony, 301905, 307685). The old ones
--   (81456, 52967, 52968, 52976, 123736) are removed.
--
-- Kalu'ak Fishing Derby (Saturdays 14:00-15:00, holiday 424):
--   Events 63 and 64 ended in 2020, and nothing dropped the Blacktip Shark (50289) that Elder
--   Clearwater's quests (24803 Kalu'ak Fishing Derby, 24806 Better Luck Next Time) ask for.
--   Event 64 now runs Saturdays 14:00 for 60 minutes from 2026-11-21 and carries holiday 424.
--   During it, the nine Northrend fish schools that had the shark in TrinityCore's data (Pandaria
--   5.4.8 world DB) can give one: 5% (TrinityCore had 0.2%, too low for a one-hour solo event).
--   Elder Clearwater offers her two quests only during the derby. No script picks a single winner, so
--   both quests stay open to anyone who brings a shark.
--   Event 63 is left alone: despite its name it holds Perry Gatner's comedy show in Shattrath.
--
-- All events end 2030-12-31, like the other holidays (see holiday-dates-expiry).

-- Stranglethorn Fishing Extravaganza
UPDATE `game_event` SET `start_time`='2026-11-22 13:50:00', `end_time`='2030-12-31 23:59:00', `occurence`=10080, `length`=130 WHERE `eventEntry`=14;
UPDATE `game_event` SET `start_time`='2026-11-22 14:00:00', `end_time`='2030-12-31 23:59:00', `occurence`=10080, `length`=120, `holiday`=301 WHERE `eventEntry`=15;

DELETE FROM `game_event_creature` WHERE `guid` IN (81456, 52967, 52968, 52976, 123736);
DELETE FROM `creature_addon` WHERE `guid` IN (81456, 52967, 52968, 52976, 123736);
DELETE FROM `creature` WHERE `guid` IN (81456, 52967, 52968, 52976, 123736) AND `id` IN (15077, 15078, 15079, 15116, 15119);

-- Kalu'ak Fishing Derby
UPDATE `game_event` SET `start_time`='2026-11-21 14:00:00', `end_time`='2030-12-31 23:59:00', `occurence`=10080, `length`=60, `holiday`=424 WHERE `eventEntry`=64;

DELETE FROM `gameobject_loot_template` WHERE `Item`=50289 AND `Entry` IN (192046, 192048, 192049, 192050, 192051, 192052, 192053, 192054, 192057);
INSERT INTO `gameobject_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(192046, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192048, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192049, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192050, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192051, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192052, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192053, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192054, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby'),
(192057, 50289, 0, 5, 0, 1, 0, 1, 1, 'Blacktip Shark - Kalu''ak Fishing Derby');

-- 4 = gameobject loot, 19 = quest available; 12 = game event active
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=4 AND `SourceEntry`=50289 AND `SourceGroup` IN (192046, 192048, 192049, 192050, 192051, 192052, 192053, 192054, 192057);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry` IN (24803, 24806);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(4, 192046, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192048, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192049, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192050, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192051, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192052, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192053, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192054, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(4, 192057, 50289, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Blacktip Shark only during the Kalu''ak Fishing Derby'),
(19, 0, 24803, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Kalu''ak Fishing Derby: only during the derby'),
(19, 0, 24806, 0, 0, 12, 0, 64, 0, 0, 0, 0, 0, '', 'Better Luck Next Time: only during the derby');
