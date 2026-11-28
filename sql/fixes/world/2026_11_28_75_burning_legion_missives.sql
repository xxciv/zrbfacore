-- Burning Legion Missive, both factions (Hellfire Peninsula). Same bug as
-- Avruu's Orb: the missive STARTS its quest, but the loot row had
-- QuestRequired=1, so it could never drop.
--   Alliance: 29588 from Warbringer Arix'Amal 19298 -> The Dark Missive 10395
--   Horde:    29590 from Razorsaw 20798 -> Vile Plans 10393
-- TDB 8.3.7: QuestRequired=0, Chance 100 on both. The team conditions on these
-- rows (Alliance 469 / Horde 67) are kept, as in TDB.
UPDATE `creature_loot_template` SET `QuestRequired`=0, `Chance`=100 WHERE `Entry`=19298 AND `Item`=29588;
UPDATE `creature_loot_template` SET `QuestRequired`=0, `Chance`=100 WHERE `Entry`=20798 AND `Item`=29590;
