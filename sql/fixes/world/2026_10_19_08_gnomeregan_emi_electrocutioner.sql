-- Gnomeregan: fixes found before the first run, 2026-10-19

-- 1. Blastmaster Emi Shortfuse (7998) starts the trogg event from her gossip option "I am ready to begin."
--    (menu 1080, OptionNpcFlag 1), but her npcflag was 2 (questgiver) and she gives no quests, so the
--    client had nothing to open on her. The Pandaria 5.4.8 world database has npcflag 1 (gossip).
UPDATE `creature_template` SET `npcflag` = 1 WHERE `entry` = 7998;

-- 2. Electrocutioner 6000 (6235) had two "On Aggro - Say Line 0" rows (ids 0 and 3, from two script
--    versions), so he yelled "Electric justice!" twice. The second one goes.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 6235 AND `source_type` = 0 AND `id` = 3 AND `event_type` = 4 AND `action_type` = 1;
