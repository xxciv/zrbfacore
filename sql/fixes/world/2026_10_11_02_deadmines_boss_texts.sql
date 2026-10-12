-- The Deadmines bosses are silent: creature_text has no rows for Glubtok,
-- Helix Gearbreaker, the Lumbering Oaf, Foe Reaper 5000 or Admiral Ripsnarl,
-- so every Talk() in their scripts does nothing and logs an error.
--
-- Texts, sounds and BroadcastText IDs are retail Cataclysm data, taken from
-- The Cataclysm Preservation Project's TrinityCore 4.3.4 world database. Group
-- IDs follow HavenCore's scripts, which number them differently. A script group
-- with no retail line (Glubtok's kill line, Ripsnarl's fog howl, the Oaf's
-- second grab line) is left out. Type 14 is a yell, 41 a boss emote.
--
-- Safe to run twice. worldserver reads creature texts only at startup: restart
-- it after running this.

DELETE FROM `creature_text` WHERE `CreatureID` IN (47162, 47296, 47297, 43778, 47626);
INSERT INTO `creature_text`
(`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
-- Glubtok (boss_glubtok.cpp, enum Texts)
(47162, 0, 0, 'Glubtok show you da power of de arcane!', 14, 0, 100, 0, 0, 21151, 47256, 0, 'Glubtok - Aggro'),
(47162, 1, 0, 'TOO...MUCH...POWER!!!', 14, 0, 100, 15, 0, 21145, 47422, 0, 'Glubtok - Death'),
(47162, 3, 0, 'Fists of frost!', 14, 0, 100, 0, 0, 21156, 47238, 0, 'Glubtok - Fists of Frost'),
(47162, 4, 0, 'Fists of flame!', 14, 0, 100, 0, 0, 21153, 47239, 0, 'Glubtok - Fists of Flame'),
(47162, 5, 0, 'Glubtok ready?', 14, 0, 100, 1, 0, 21154, 47361, 0, 'Glubtok - Transition 1'),
(47162, 6, 0, 'Let''s do it!', 14, 0, 100, 15, 0, 21157, 47362, 0, 'Glubtok - Transition 2'),
(47162, 7, 0, 'ARCANE POWER!!!', 14, 0, 100, 15, 0, 21146, 47363, 0, 'Glubtok - Arcane Power'),
(47162, 8, 0, '|TInterface\\Icons\\spell_holy_innerfire.blp:20|t Glubtok creates a moving |cFFFF0000|Hspell:91398|h[Fire Wall]|h|r!', 41, 0, 100, 0, 0, 0, 49155, 0, 'Glubtok - Fire Wall (heroic)'),
-- Helix Gearbreaker (boss_helix_gearbreaker.cpp: Talk(5) aggro, 0 death, 1 wipe, 2 Oaf dead)
(47296, 0, 0, 'The scales...have...tipped...', 14, 0, 100, 0, 0, 20844, 47575, 0, 'Helix Gearbreaker - Death'),
(47296, 1, 0, 'Only ten copper? You''re not even worth killing!', 14, 0, 100, 0, 0, 20845, 47574, 0, 'Helix Gearbreaker - Wipe'),
(47296, 2, 0, 'I didn''t need him! Not when I''ve got YOU oafs!', 14, 0, 100, 0, 0, 20846, 47573, 0, 'Helix Gearbreaker - Oaf Death'),
(47296, 5, 0, 'The mistress will pay me handsomely for your heads!', 14, 0, 100, 0, 0, 20849, 47474, 0, 'Helix Gearbreaker - Aggro'),
-- Lumbering Oaf (npc_lumbering_oaf: Talk(0) when it grabs a player)
(47297, 0, 0, 'OAF SMASH!!', 14, 0, 100, 0, 0, 0, 48117, 0, 'Lumbering Oaf - Grab'),
-- Foe Reaper 5000 (boss_foe_reaper_5000.cpp, enum eSays)
(43778, 1, 0, 'Overheat threshold exceeded.  System failure.  Wheat clog in port two.  Shutting down.', 14, 0, 100, 0, 0, 22138, 47643, 0, 'Foe Reaper 5000 - Death'),
(43778, 2, 0, 'Target destroyed.', 14, 0, 100, 0, 0, 22139, 47630, 0, 'Foe Reaper 5000 - Wipe'),
(43778, 3, 0, 'Foe Reaper 5000 on-line.  All systems nominal.', 14, 0, 100, 0, 0, 22137, 47596, 0, 'Foe Reaper 5000 - Activation'),
(43778, 4, 0, 'Target acquired.  Harvesting servos engaged.', 14, 0, 100, 0, 0, 22141, 47629, 0, 'Foe Reaper 5000 - Harvest'),
(43778, 6, 0, 'Safety restrictions off-line.  Catastrophic system failure imminent.', 14, 0, 100, 0, 0, 22143, 47642, 0, 'Foe Reaper 5000 - Safety Restrictions Off-line'),
-- Admiral Ripsnarl (boss_admiral_ripsnarl.cpp, enum Says)
(47626, 0, 0, 'You will...NOT find her...until it is too late...', 14, 0, 100, 0, 0, 19875, 48010, 0, 'Admiral Ripsnarl - Death'),
(47626, 1, 0, 'Your blood only increases my hunger!', 14, 0, 100, 0, 0, 19876, 48009, 0, 'Admiral Ripsnarl - Wipe'),
(47626, 2, 0, 'Do you feel that chill running up your spine?', 14, 0, 100, 0, 0, 19877, 47914, 0, 'Admiral Ripsnarl - Fog 1'),
(47626, 3, 0, 'The fog is rolling in...', 14, 0, 100, 0, 0, 0, 47915, 0, 'Admiral Ripsnarl - Fog 2'),
(47626, 4, 0, 'I can smell your fear...', 14, 0, 100, 0, 0, 19879, 48006, 0, 'Admiral Ripsnarl - Go for the Throat 1'),
(47626, 5, 0, 'I will rip your heart from your chest!', 14, 0, 100, 0, 0, 19880, 48007, 0, 'Admiral Ripsnarl - Go for the Throat 2'),
(47626, 7, 0, 'Ah, fresh meat!', 14, 0, 100, 0, 0, 19882, 48179, 0, 'Admiral Ripsnarl - Aggro');
