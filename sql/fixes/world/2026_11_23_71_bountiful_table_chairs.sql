-- Sharing a Bountiful Feast 14064/14065 and the other Pilgrim's Bounty table quests: reported by Four,
-- 2026-11-23 (sitting in a chair at a Bountiful Table gives an empty vehicle bar, nothing to eat or pass).
-- Our five chairs had no vehicle spells at all. TDB 8.3.7 gives each chair its "Pass The <food>" spell
-- and the five "Feast On <food>" spells (61784 Turkey, 61785 Cranberries, 61788 Stuffing, 61786 Sweet
-- Potatoes, 61787 Pie), and unit_flags2 34816 (adds 0x8000, chairs don't turn); the Pie Chair also had unit_flags 16388 (TDB 16384).
-- Our chairs also had a SmartAI row re-adding their "Can Eat - <food>" aura every 5 s (not in TDB). The
-- core already does this when a chair is seated at a table (npc_bountiful_table casts "A Serving of
-- <food>", whose aura applies Can Eat), so the chairs go back to no AI, as in TDB.
-- The doubled static chairs next to each table are a separate fix (Wayfarer).
UPDATE `creature_template` SET `spell1`=66250,`spell2`=61784,`spell3`=61785,`spell4`=61788,`spell5`=61786,`spell6`=61787,`unit_flags2`=34816,`AIName`='' WHERE `entry`=34812; -- The Turkey Chair
UPDATE `creature_template` SET `spell1`=66259,`spell2`=61784,`spell3`=61785,`spell4`=61788,`spell5`=61786,`spell6`=61787,`unit_flags2`=34816,`AIName`='' WHERE `entry`=34819; -- The Stuffing Chair
UPDATE `creature_template` SET `spell1`=66260,`spell2`=61784,`spell3`=61785,`spell4`=61788,`spell5`=61786,`spell6`=61787,`unit_flags`=16384,`unit_flags2`=34816,`AIName`='' WHERE `entry`=34822; -- The Pie Chair
UPDATE `creature_template` SET `spell1`=66261,`spell2`=61784,`spell3`=61785,`spell4`=61788,`spell5`=61786,`spell6`=61787,`unit_flags2`=34816,`AIName`='' WHERE `entry`=34823; -- The Cranberry Chair
UPDATE `creature_template` SET `spell1`=66262,`spell2`=61784,`spell3`=61785,`spell4`=61788,`spell5`=61786,`spell6`=61787,`unit_flags2`=34816,`AIName`='' WHERE `entry`=34824; -- The Sweet Potato Chair
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (34812,34819,34822,34823,34824) AND `source_type`=0;
