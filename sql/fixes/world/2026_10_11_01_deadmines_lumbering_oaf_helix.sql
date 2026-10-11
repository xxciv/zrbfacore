-- The Deadmines, Helix Gearbreaker encounter.
--
-- 1. Lumbering Oaf scripts were swapped. The Oaf that Helix rides (47297) ran
--    npc_oaf_lackey, the trash Oaf Lackey AI, so it never grabbed or charged
--    anyone and Helix never learned it had died. The Helix Oaf script,
--    npc_lumbering_oaf, sat on 40906 instead: an unrelated level 28 Lumbering
--    Oaf in Kalimdor, whose own SmartAI (Furious Rage, Acidic Sweat,
--    Exhaustion) was ignored because of it. Give each its own AI back.
--
-- 2. Helix (47296) swings every 0.5 s with DamageModifier 57.5, about 15 times
--    the damage per second of the other Deadmines bosses (15-17.7 on a 2 s
--    swing). ZRPandaria lowered the same boss to 20 (zrpandaria548
--    tools/pandaria/sql/2026_09_28_deadmines_helix_melee.sql). Use the same
--    value. SoloCraft here is the stock HavenCore mod: it doesn't reduce damage
--    taken, but multiplies the player's stats, Stamina included, in dungeons
--    (Solocraft.Dungeon = 5 is +400%), so the larger health pool does the
--    softening. The core patch also stops him meleeing while he rides the Oaf.

-- Revert:
--   UPDATE creature_template SET ScriptName = 'npc_oaf_lackey' WHERE entry = 47297;
--   UPDATE creature_template SET ScriptName = 'npc_lumbering_oaf' WHERE entry = 40906;
--   UPDATE creature_template SET DamageModifier = 57.5 WHERE entry = 47296;
--
-- Safe to run twice. worldserver reads creature templates only at startup:
-- restart it after running this.

UPDATE `creature_template` SET `ScriptName` = 'npc_lumbering_oaf' WHERE `entry` = 47297;
UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` = 40906;
UPDATE `creature_template` SET `DamageModifier` = 20 WHERE `entry` = 47296;
