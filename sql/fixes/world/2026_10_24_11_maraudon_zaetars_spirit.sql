-- Maraudon (map 349): Zaetar's Spirit stood beside Princess Theradras before the fight (Four, 2026-10-24).
--
-- Same problem as Celebras the Redeemed (2026_10_24_09). The core script boss_princess_theradras
-- summons Zaetar's Spirit (12238) where she dies (JustDied, 10 minutes), but the world database also
-- spawns him permanently at that spot (guid 324993; the Pandaria 5.4.8 database has the same row).
-- Remove the static spawn. He's the quest giver and ender for the Maraudon quests, which all need the
-- Princess dead or are handed in after the run, so nothing is lost.
DELETE FROM `creature` WHERE `guid`=324993 AND `id`=12238;
DELETE FROM `creature_addon` WHERE `guid`=324993;
