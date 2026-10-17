-- Wailing Caverns: Muyoh (Disciple of Naralex, 3678) can't be clicked, and
-- Naralex (3679) shows a "Lets Go!" dialog that does nothing.
--
-- Muyoh starts the awakening through gossip (npc_disciple_of_naralex,
-- OnGossipHello / OnGossipSelect, gossip_menu 201), but the dump gives her
-- npcflag 2 (quest giver) only, and she has no quests, so the client offers
-- nothing to click. Add the gossip flag (1).
--
-- Naralex sleeps through the event and only talks from the script. The dump
-- gives him npcflag 1 with gossip menu 3679, whose one option "Lets Go!" and
-- SmartAI gossip row ("Orgus - On Gossip - Kill Credit") belong to an
-- unrelated NPC. Remove the gossip flag so he can't be talked to.
--
-- Revert:
--   UPDATE `creature_template` SET `npcflag` = 2 WHERE `entry` = 3678;
--   UPDATE `creature_template` SET `npcflag` = 1 WHERE `entry` = 3679;
--
-- Safe to run twice. Restart worldserver afterwards.

UPDATE `creature_template` SET `npcflag` = `npcflag` | 1 WHERE `entry` = 3678;
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~1 WHERE `entry` = 3679;
