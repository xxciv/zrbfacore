-- Razorfen Downs quests (Four, 2026-11-20): `.quest add` of Partners in Crime 27024 / The Coldbringer 27009
-- showed nothing. Those are the classic quests; in 8.3.7 they (and Cure the Scourge 27029, Scourge of the
-- Downs 27019, Extinguishing the Idol 27022) carry QUEST_FLAGS_UNAVAILABLE (0x4000): retired with the
-- Warlords revamp, the client hides them. The live quests are Blackthorn's Lieutenants 33513 (Aarux,
-- Mordresh, Mushlump) and The Ritual 33514 (Amnennar), started by the Warlords Koristrasza 74367 (ended by
-- 74367/74888/74889). None of those three is spawned here, nor in TDB 8.3.7, so the live quests had no
-- giver. The Koristrasza we have at the entrance (44837, guid 325121, already a quest giver) now starts and
-- ends both. Nothing is removed.
DELETE FROM `creature_queststarter` WHERE `id`=44837 AND `quest` IN (33513,33514);
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (44837,33513),(44837,33514);
DELETE FROM `creature_questender` WHERE `id`=44837 AND `quest` IN (33513,33514);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (44837,33513),(44837,33514);
