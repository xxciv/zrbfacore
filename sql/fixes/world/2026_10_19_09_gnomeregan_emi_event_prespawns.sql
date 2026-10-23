-- Gnomeregan: Blastmaster Emi Shortfuse's trogg event, 2026-10-19
-- Four's run: the event ran to the end and Grubbis counted, but "way too many troggs".
-- The event (npc_blastmaster_emi_shortfuse) summons every wave of Caverndeep Ambushers in the two cave-in
-- tunnels, the explosive charges (183410), Grubbis and Chomper, and the three red rockets at the end. The
-- DB also had all of that spawned from the start (VerifiedBuild 0, at the summon spots: a sniff of the
-- event saved as spawns), so the tunnels emptied out on top of the waves. The pre-spawned copies go; the
-- event still summons its own. The original rows are in the world dump if they are ever wanted back.

-- 1. 30 Caverndeep Ambushers (6207) and 1 Caverndeep Burrower (6206) in the two tunnels, Grubbis (7361)
--    and Chomper (6215). No creature_addon, formation, spawn group, SmartAI or linked respawn rows.
DELETE FROM `creature` WHERE `map` = 90 AND `guid` BETWEEN 324522 AND 324554 AND `id` IN (6206, 6207, 6215, 7361);

-- 2. Explosive Charges (144065) where Emi places hers, and two of the three red rockets (103820) she
--    summons at the end.
DELETE FROM `gameobject_addon` WHERE `guid` IN (189336, 189337, 189338, 189339, 189340, 189341);
DELETE FROM `gameobject` WHERE `map` = 90 AND ((`guid` BETWEEN 189336 AND 189339 AND `id` = 144065) OR (`guid` IN (189340, 189341) AND `id` = 103820));
