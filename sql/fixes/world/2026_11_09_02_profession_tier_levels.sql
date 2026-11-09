-- Older expansion profession skills need the expansion's level (Four, 2026-11-09). Run against bfa_world,
-- after 2026_11_09_00 and 2026_11_09_01 (re-running either of those puts their rows back to no level, so
-- run this file again after them).
--
-- Every trainer row for an expansion's profession skill gets that expansion's starting level: Outland 58,
-- Northrend 68, Cataclysm 80, Pandaria 85, Draenor 90, Legion 98. Classic (level 5) and Kul Tiran (110)
-- keep Blizzard's own values. Fishing is not changed. Safe to run more than once.

-- Outland (level 58): Alchemy 264214, Blacksmithing 264437, Cooking 264635, Enchanting 264461, Engineering 264480, Herbalism 265822, Inscription 264497, Jewelcrafting 264535, Leatherworking 264580, Mining 265840, Skinning 265858, Tailoring 264619
UPDATE `trainer_spell` SET `ReqLevel` = 58 WHERE `SpellId` IN (264214, 264437, 264461, 264480, 264497, 264535, 264580, 264619, 264635, 265822, 265840, 265858);

-- Northrend (level 68): Alchemy 264221, Blacksmithing 264439, Cooking 264637, Enchanting 264463, Engineering 264482, Herbalism 265824, Inscription 264499, Jewelcrafting 264538, Leatherworking 264582, Mining 265842, Skinning 265860, Tailoring 264621
UPDATE `trainer_spell` SET `ReqLevel` = 68 WHERE `SpellId` IN (264221, 264439, 264463, 264482, 264499, 264538, 264582, 264621, 264637, 265824, 265842, 265860);

-- Cataclysm (level 80): Alchemy 264244, Blacksmithing 264441, Cooking 264639, Enchanting 264466, Engineering 264484, Herbalism 265826, Inscription 264501, Jewelcrafting 264541, Leatherworking 264584, Mining 265844, Skinning 265862, Tailoring 264623
UPDATE `trainer_spell` SET `ReqLevel` = 80 WHERE `SpellId` IN (264244, 264441, 264466, 264484, 264501, 264541, 264584, 264623, 264639, 265826, 265844, 265862);

-- Pandaria (level 85): Alchemy 264246, Blacksmithing 264443, Cooking 264641, Enchanting 264468, Engineering 264486, Herbalism 265828, Inscription 264503, Jewelcrafting 264543, Leatherworking 264586, Mining 265846, Skinning 265864, Tailoring 264625
UPDATE `trainer_spell` SET `ReqLevel` = 85 WHERE `SpellId` IN (264246, 264443, 264468, 264486, 264503, 264543, 264586, 264625, 264641, 265828, 265846, 265864);

-- Draenor (level 90): Alchemy 264248, Blacksmithing 264445, Cooking 264643, Enchanting 264470, Engineering 264488, Herbalism 265830, Inscription 264505, Jewelcrafting 264545, Leatherworking 264589, Mining 265848, Skinning 265866, Tailoring 264627
UPDATE `trainer_spell` SET `ReqLevel` = 90 WHERE `SpellId` IN (264248, 264445, 264470, 264488, 264505, 264545, 264589, 264627, 264643, 265830, 265848, 265866);

-- Legion (level 98): Alchemy 264251, Blacksmithing 264447, Cooking 264645, Enchanting 264472, Engineering 264491, Herbalism 265832, Inscription 264507, Jewelcrafting 264547, Leatherworking 264591, Mining 265850, Skinning 265868, Tailoring 264629
UPDATE `trainer_spell` SET `ReqLevel` = 98 WHERE `SpellId` IN (264251, 264447, 264472, 264491, 264507, 264547, 264591, 264629, 264645, 265832, 265850, 265868);
