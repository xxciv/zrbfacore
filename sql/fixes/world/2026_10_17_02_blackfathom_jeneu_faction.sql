-- Blackfathom Deeps: Je'neu Sancrea <The Earthen Ring> (12736) is hostile to
-- the Alliance and attacks when talked to.
--
-- He stands at the entrance next to the Alliance quest givers and gives or
-- takes quests open to every race (Blackfathom Deeps 26894, Nightmare of the
-- Deeps 26888, Amongst the Ruins 26891, The Essence of Aku'Mai 6563), and is
-- the turn-in for "Adventurers Wanted: Blackfathom Deeps" (28010). The dump
-- gives him faction 126, a Horde faction (red to a night elf in game). Make him
-- friendly to both factions (35), like Zeya (44375) beside him.
--
-- Revert:
--   UPDATE `creature_template` SET `faction` = 126 WHERE `entry` = 12736;
--
-- Safe to run twice. Restart worldserver afterwards.

UPDATE `creature_template` SET `faction` = 35 WHERE `entry` = 12736;
