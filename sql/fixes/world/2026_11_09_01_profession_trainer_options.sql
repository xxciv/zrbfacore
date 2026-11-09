-- Profession trainers open the list they are meant to (Four, 2026-11-09). Run against bfa_world, after
-- 2026_11_09_00_profession_tier_trainers.sql.
--
-- The core picks a trainer list by the creature and the gossip option clicked: creature_trainer
-- (CreatureId, MenuId, OptionIndex). A trainer with no gossip menu of its own (gossip_menu_id 0) but the
-- gossip flag shows the generic "Train me!" option, menu 0 option 3; one without the gossip flag opens
-- its list directly, menu 0 option 0. When no creature_trainer row matches, the core falls back to the
-- old npc_trainer list (old rank spells, no expansion skills), as for the fishing trainers in
-- 2026_10_10_01. The 2026_09_04 trainer sync left 266 profession trainers with no row for the option
-- they actually show, and a few pointing at another profession's list (Seymour and Gaston at
-- Enchanting). Each line adds the row for the option the trainer shows, pointing at:
--   - the trainer's own list for that profession, when it has one;
--   - Boralus and Tiragarde trainers: the Kul Tiras lists (Classic to Kul Tiran): Alchemy 846,
--     Cooking 858, Enchanting 831, Engineering 873, Herbalism 851, Inscription 836, Jewelcrafting 821,
--     Leatherworking 826, Mining 841, Skinning 868, Tailoring 863;
--   - Zuldazar trainers with no list: Cooking 858, Tailoring 864 (Zandalar lists);
--   - everyone else: the profession's main list (Classic to Legion, 2026_11_09_00): Alchemy 122,
--     Blacksmithing 991, Cooking 136, Enchanting 62, Engineering 993, Herbalism 424, Inscription 63,
--     Jewelcrafting 119, Leatherworking 990, Mining 992, Skinning 989, Tailoring 163.
--
-- Also: Grix "Ironfists" Barlow's list 133536 (Boralus blacksmithing) and Shuga Blastcaps's list 874
-- (Zuldazar engineering) taught only the Kul Tiran / Zandalari skill. They now also teach Classic to
-- Legion, with the same cost and requirements as list 817 (Zuldazar blacksmithing).
--
-- Not changed: 23 trainers whose own gossip menu has no "Train me" option at all (listed in the patch
-- notes). Safe to run more than once.

-- Grix (133536) and Shuga (874): Classic to Legion skills
DELETE FROM `trainer_spell` WHERE (`TrainerId`, `SpellId`) IN ((133536, 264435), (133536, 264437), (133536, 264439), (133536, 264441), (133536, 264443), (133536, 264445), (133536, 264447), (874, 264478), (874, 264480), (874, 264482), (874, 264484), (874, 264486), (874, 264488), (874, 264491));
INSERT INTO `trainer_spell` (`TrainerId`, `SpellId`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqAbility1`, `ReqAbility2`, `ReqAbility3`, `ReqLevel`, `VerifiedBuild`) VALUES
(133536, 264435, 10, 0, 0, 0, 0, 0, 5, 35662),
(133536, 264437, 10, 164, 1, 0, 0, 0, 0, 35662),
(133536, 264439, 10, 164, 1, 0, 0, 0, 0, 35662),
(133536, 264441, 10, 164, 1, 0, 0, 0, 0, 35662),
(133536, 264443, 10, 164, 1, 0, 0, 0, 0, 35662),
(133536, 264445, 10, 164, 1, 0, 0, 0, 0, 35662),
(133536, 264447, 10, 164, 1, 0, 0, 0, 0, 35662),
(874, 264478, 10, 0, 0, 0, 0, 0, 5, 35662),
(874, 264480, 10, 202, 1, 0, 0, 0, 0, 35662),
(874, 264482, 10, 202, 1, 0, 0, 0, 0, 35662),
(874, 264484, 10, 202, 1, 0, 0, 0, 0, 35662),
(874, 264486, 10, 202, 1, 0, 0, 0, 0, 35662),
(874, 264488, 10, 202, 1, 0, 0, 0, 0, 35662),
(874, 264491, 10, 202, 1, 0, 0, 0, 0, 35662);

-- Alchemy: 18 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((1215, 0, 3), (1386, 4134, 0), (2391, 4129, 0), (3964, 0, 0), (16161, 7524, 1), (16723, 0, 3), (18802, 0, 3), (26975, 0, 0), (27023, 0, 0), (27029, 0, 0), (33674, 0, 3), (65186, 0, 3), (85905, 0, 3), (86009, 0, 3), (92456, 18380, 0), (92458, 0, 3), (122703, 22632, 0), (132228, 22007, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(1215, 122, 0, 3), -- Alchemist Mallory
(1386, 122, 4134, 0), -- Rogvar
(2391, 122, 4129, 0), -- Serge Hinott
(3964, 122, 0, 0), -- Kylanna
(16161, 122, 7524, 1), -- Arcanist Sheynathren
(16723, 122, 0, 3), -- Lucc
(18802, 122, 0, 3), -- Alchemist Gribble
(26975, 122, 0, 0), -- Arthur Henslowe
(27023, 122, 0, 0), -- Apothecary Bressa
(27029, 122, 0, 0), -- Apothecary Wormwick
(33674, 122, 0, 3), -- Alchemist Kanhu
(65186, 122, 0, 3), -- Poisoncrafter Kil'zit
(85905, 122, 0, 3), -- Jaiden Trask
(86009, 122, 0, 3), -- Kristoph Cossey
(92456, 122, 18380, 0), -- Linzy Blackbolt
(92458, 122, 0, 3), -- Deucus Valdera
(122703, 847, 22632, 0), -- Clever Kumali
(132228, 846, 22007, 0); -- Elric Whalgrene

-- Blacksmithing: 29 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((3478, 2783, 0), (4596, 0, 3), (5164, 0, 3), (6299, 0, 3), (11146, 0, 3), (15400, 7256, 0), (16583, 0, 3), (16724, 0, 3), (19341, 0, 3), (26564, 9459, 0), (26952, 0, 0), (27034, 0, 0), (65114, 0, 0), (65129, 0, 3), (85917, 0, 3), (86048, 0, 3), (92183, 0, 3), (92242, 30020, 0), (92243, 0, 3), (92264, 18475, 2), (97261, 0, 0), (99118, 0, 0), (99121, 0, 0), (99954, 0, 0), (104664, 0, 0), (106655, 0, 3), (107890, 0, 0), (127112, 22155, 0), (133322, 0, 3));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(3478, 991, 2783, 0), -- Traugh
(4596, 991, 0, 3), -- James Van Brunt
(5164, 991, 0, 3), -- Grumnus Steelshaper
(6299, 991, 0, 3), -- Delfrum Flintbeard
(11146, 991, 0, 3), -- Ironus Coldsteel
(15400, 991, 7256, 0), -- Arathel Sunforge
(16583, 991, 0, 3), -- Rohok
(16724, 991, 0, 3), -- Miall
(19341, 991, 0, 3), -- Grutah
(26564, 991, 9459, 0), -- Borus Ironbender
(26952, 991, 0, 0), -- Kristen Smythe
(27034, 991, 0, 0), -- Josric Fame
(65114, 991, 0, 0), -- Len the Hammer
(65129, 991, 0, 3), -- Zen Master Lao
(85917, 991, 0, 3), -- Aimee Goldforge
(86048, 991, 0, 3), -- Mazdon Bizratchet
(92183, 991, 0, 3), -- Alard Schmied
(92242, 991, 30020, 0), -- Barm Stonebreaker
(92243, 991, 0, 3), -- Muirn Ironhorn
(92264, 991, 18475, 2), -- Felsmith Nal'ryssa
(97261, 991, 0, 0), -- Alard Schmied
(99118, 991, 0, 0), -- Orland Schaeffer
(99121, 991, 0, 0), -- Alard Schmied
(99954, 991, 0, 0), -- Tognus Flintfire
(104664, 991, 0, 0), -- Traugh
(106655, 991, 0, 3), -- Arcanomancer Vridiel
(107890, 991, 0, 0), -- Clarise Gnarltree
(127112, 817, 22155, 0), -- Forgemaster Zak'aal
(133322, 991, 0, 3); -- Elya

-- Cooking: 31 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((1382, 5854, 0), (3966, 0, 0), (5036, 0, 0), (8306, 5854, 0), (16253, 7171, 0), (18987, 0, 3), (18988, 7818, 0), (26953, 9987, 0), (26972, 9988, 0), (29631, 9831, 0), (34708, 0, 3), (34710, 0, 3), (34711, 0, 3), (34712, 0, 3), (34713, 0, 3), (34714, 0, 3), (34785, 0, 3), (34786, 0, 3), (85925, 0, 3), (86029, 0, 3), (93534, 0, 3), (93536, 0, 3), (95981, 0, 0), (98527, 0, 0), (99330, 0, 0), (99843, 0, 0), (99991, 0, 0), (129014, 21754, 0), (131741, 0, 0), (136052, 21754, 0), (150632, 0, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(1382, 136, 5854, 0), -- Mudduk
(3966, 136, 0, 0), -- Kaleem
(5036, 136, 0, 0), -- World Cooking Trainer
(8306, 136, 5854, 0), -- Duhng
(16253, 136, 7171, 0), -- Master Chef Mouldier
(18987, 136, 0, 3), -- Gaston
(18988, 136, 7818, 0), -- Baxter (was list 62)
(26953, 136, 9987, 0), -- Thomas Kolichio
(26972, 136, 9988, 0), -- Orn Tenderhoof
(29631, 136, 9831, 0), -- Awilo Lon'gomba
(34708, 136, 0, 3), -- Caitrin Ironkettle
(34710, 136, 0, 3), -- Ellen Moore
(34711, 136, 0, 3), -- Mary Allerton
(34712, 136, 0, 3), -- Roberta Carter
(34713, 136, 0, 3), -- Ondani Greatmill
(34714, 136, 0, 3), -- Mahara Goldwheat
(34785, 136, 0, 3), -- Alnar Whitebough
(34786, 136, 0, 3), -- Alice Rigsdale
(85925, 136, 0, 3), -- Elton Black
(86029, 136, 0, 3), -- Guy Fireeye
(93534, 136, 0, 3), -- Katherine Lee
(93536, 136, 0, 3), -- Awilo Lon'gomba
(95981, 136, 0, 0), -- Duhng
(98527, 136, 0, 0), -- Pyall Silentstride
(99330, 136, 0, 0), -- Katherine Lee
(99843, 136, 0, 0), -- Cook Ghilm
(99991, 136, 0, 0), -- Gremlock Pilsnor
(129014, 858, 21754, 0), -- Hessir
(131741, 858, 0, 0), -- Cooka Mala
(136052, 858, 21754, 0), -- "Cap'n" Byron Mehlsack
(150632, 136, 0, 0); -- Stacks

-- Enchanting: 15 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((1317, 0, 3), (5157, 0, 3), (16160, 7524, 1), (16725, 8866, 0), (18753, 0, 3), (18773, 0, 3), (19540, 0, 3), (65127, 0, 3), (85914, 0, 3), (86027, 0, 3), (93531, 0, 3), (98017, 0, 3), (122702, 23391, 0), (133394, 0, 3), (136041, 23254, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(1317, 62, 0, 3), -- Lucan Cordell
(5157, 62, 0, 3), -- Gimble Thistlefuzz
(16160, 125, 7524, 1), -- Magistrix Eredania
(16725, 62, 8866, 0), -- Nahogg (was list 122)
(18753, 62, 0, 3), -- Felannia
(18773, 62, 0, 3), -- Johan Barnes
(19540, 62, 0, 3), -- Asarnan
(65127, 62, 0, 3), -- Lai the Spellpaw
(85914, 62, 0, 3), -- Bil Sparktonic
(86027, 62, 0, 3), -- Hane'ke
(93531, 62, 0, 3), -- Enchanter Nalthanis
(98017, 62, 0, 3), -- Guron Twaintail
(122702, 832, 23391, 0), -- Enchantress Quinni
(133394, 125, 0, 3), -- Elestrae Dawnshard
(136041, 831, 23254, 0); -- Emily Fairweather

-- Engineering: 27 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((3494, 4140, 0), (7406, 0, 3), (10993, 0, 3), (11031, 0, 3), (17637, 0, 3), (18752, 0, 3), (18775, 0, 3), (19576, 0, 3), (25099, 0, 3), (55143, 0, 0), (85918, 0, 0), (86012, 0, 3), (92194, 0, 3), (93519, 0, 0), (93520, 0, 3), (95907, 0, 0), (98872, 0, 0), (99078, 0, 0), (99098, 0, 0), (102961, 0, 0), (107898, 0, 0), (113926, 0, 0), (131840, 0, 3), (133326, 0, 3), (136059, 23266, 0), (150630, 9541280, 0), (150631, 9541281, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(3494, 993, 4140, 0), -- Tinkerwiz
(7406, 993, 0, 3), -- Oglethorpe Obnoticus
(10993, 993, 0, 3), -- Twizwick Sprocketgrind
(11031, 993, 0, 3), -- Franklin Lloyd
(17637, 993, 0, 3), -- Mack Diver
(18752, 993, 0, 3), -- Zebig
(18775, 993, 0, 3), -- Lebowski
(19576, 993, 0, 3), -- Xyrol
(25099, 993, 0, 3), -- Jonathan Garrett
(55143, 993, 0, 0), -- Sally Fizzlefury
(85918, 993, 0, 0), -- Hilda Copperfuze
(86012, 993, 0, 3), -- Han Leaprocket
(92194, 993, 0, 3), -- Timofey Oshenko
(93519, 993, 0, 0), -- Findle Whistlesteam
(93520, 993, 0, 3), -- Didi the Wrench
(95907, 993, 0, 0), -- Fixxia Geartweak
(98872, 993, 0, 0), -- Buzzek Bracketswing
(99078, 993, 0, 0), -- Findle Whistlesteam
(99098, 993, 0, 0), -- Timofey Oshenko
(102961, 993, 0, 0), -- Didi the Wrench
(107898, 993, 0, 0), -- Finbus Geargrind
(113926, 993, 0, 0), -- Findle Whistlesteam
(131840, 874, 0, 3), -- Shuga Blastcaps
(133326, 993, 0, 3), -- Artificer Farud
(136059, 873, 23266, 0), -- Layla Evenkeel
(150630, 993, 9541280, 0), -- Flip Quickcharge
(150631, 993, 9541281, 0); -- Pristy Quickcharge

-- Herbalism: 26 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((1458, 7691, 0), (3965, 0, 0), (4204, 0, 3), (4998, 0, 0), (5502, 0, 3), (12025, 0, 0), (16367, 7524, 1), (16527, 0, 0), (17983, 0, 3), (18748, 0, 3), (18776, 0, 3), (26974, 0, 0), (33678, 0, 3), (65141, 0, 0), (65877, 0, 0), (66980, 15099, 0), (67025, 0, 3), (84620, 0, 0), (85921, 0, 3), (86006, 0, 3), (92464, 18379, 0), (99167, 0, 0), (99903, 0, 3), (110345, 0, 0), (122704, 22545, 0), (136096, 22544, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(1458, 424, 7691, 0), -- Telurinon Moonshadow
(3965, 424, 0, 0), -- Cylania Rootstalker
(4204, 424, 0, 3), -- Firodren Mooncaller
(4998, 424, 0, 0), -- World Herbalism Trainer
(5502, 424, 0, 3), -- Shylamiir
(12025, 424, 0, 0), -- Malvor
(16367, 424, 7524, 1), -- Botanist Tyniarrel
(16527, 424, 0, 0), -- Outland Herbalism Trainer
(17983, 424, 0, 3), -- Heur
(18748, 424, 0, 3), -- Ruak Stronghorn
(18776, 424, 0, 3), -- Rorelien
(26974, 424, 0, 0), -- Tansy Wildmane
(33678, 424, 0, 3), -- Jijia
(65141, 424, 0, 0), -- Survivalist Tylania
(65877, 424, 0, 0), -- Han Flowerbloom
(66980, 424, 15099, 0), -- Grower Miao
(67025, 424, 0, 3), -- Orchard Keeper Li Mei
(84620, 424, 0, 0), -- Aranae Venomblood
(85921, 424, 0, 3), -- Jie Wildblossom
(86006, 424, 0, 3), -- Anthony Allain
(92464, 424, 18379, 0), -- Kuhuine Tenderstride
(99167, 424, 0, 0), -- Dorothy Egan
(99903, 424, 0, 3), -- Sprig Hashhoof
(110345, 424, 0, 0), -- Aranae Venomblood
(122704, 852, 22545, 0), -- Jahden Fla
(136096, 851, 22544, 0); -- Declan Senal

-- Inscription: 10 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((25263, 0, 0), (62327, 0, 0), (64691, 14582, 0), (85911, 0, 0), (86015, 0, 3), (92195, 0, 3), (99169, 0, 0), (130399, 21871, 0), (130901, 0, 3), (132264, 0, 3));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(25263, 63, 0, 0), -- World Inscription Trainer
(62327, 63, 0, 0), -- Scribe Rinji
(64691, 63, 14582, 0), -- Lorewalker Huynh
(85911, 63, 0, 0), -- Scribe Chi-Yuan
(86015, 63, 0, 3), -- Joro'man
(92195, 63, 0, 3), -- Professor Pallin
(99169, 63, 0, 0), -- Professor Pallin
(130399, 836, 21871, 0), -- Zooey Inksprocket
(130901, 837, 0, 3), -- Chronicler Grazzul
(132264, 837, 0, 3); -- Chronicler Kizani

-- Jewelcrafting: 13 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((18751, 0, 3), (18774, 0, 3), (19539, 0, 3), (26960, 9895, 0), (26982, 9893, 0), (52587, 0, 3), (65098, 14625, 0), (85916, 0, 0), (86010, 0, 3), (93527, 0, 3), (100538, 0, 0), (122695, 0, 3), (130368, 21869, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(18751, 29, 0, 3), -- Kalaen
(18774, 119, 0, 3), -- Tatiana
(19539, 29, 0, 3), -- Jazdalaad
(26960, 119, 9895, 0), -- Carter Tiffens
(26982, 119, 9893, 0), -- Geba'li
(52587, 119, 0, 3), -- Neller Fayne
(65098, 119, 14625, 0), -- Mai the Jade Shaper
(85916, 119, 0, 0), -- Artificer Nissea
(86010, 29, 0, 3), -- Alixander Swiftsteel
(93527, 119, 0, 3), -- Timothy Jones
(100538, 119, 0, 0), -- Timothy Jones
(122695, 822, 0, 3), -- Seshuli
(130368, 821, 21869, 0); -- Samuel D. Colton III

-- Leatherworking: 28 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((3703, 4206, 0), (4588, 0, 3), (5040, 0, 0), (5784, 0, 0), (7867, 0, 0), (7869, 0, 0), (7871, 0, 0), (11097, 4243, 0), (16278, 0, 3), (16728, 0, 3), (18754, 0, 3), (18771, 0, 3), (21087, 0, 0), (26996, 0, 0), (28400, 0, 0), (65121, 0, 3), (85920, 0, 0), (86032, 0, 3), (93523, 0, 3), (98948, 0, 3), (98950, 0, 0), (98958, 0, 0), (98964, 0, 3), (98969, 0, 3), (99073, 0, 0), (122698, 0, 3), (136063, 23262, 0), (151287, 0, 3));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(3703, 990, 4206, 0), -- Krulmoo Fullmoon
(4588, 990, 0, 3), -- Arthur Moore
(5040, 990, 0, 0), -- World Leatherworking Trainer
(5784, 990, 0, 0), -- Waldor
(7867, 990, 0, 0), -- Thorkaf Dragoneye
(7869, 990, 0, 0), -- Brumn Winterhoof
(7871, 990, 0, 0), -- Se'Jib
(11097, 990, 4243, 0), -- Drakk Stonehand
(16278, 990, 0, 3), -- Sathein
(16728, 990, 0, 3), -- Akham
(18754, 56, 0, 3), -- Barim Spilthoof
(18771, 990, 0, 3), -- Brumman
(21087, 990, 0, 0), -- Grikka
(26996, 990, 0, 0), -- Awan Iceborn
(28400, 990, 0, 0), -- Northrend Leatherworking Trainer
(65121, 990, 0, 3), -- Clean Pelt
(85920, 990, 0, 0), -- Jistun Sharpfeather
(86032, 56, 0, 3), -- Burga Stronghide
(93523, 990, 0, 3), -- Namha Moonwater
(98948, 990, 0, 3), -- Hrul Sharphoof
(98950, 990, 0, 0), -- Namha Moonwater
(98958, 990, 0, 0), -- Andellion
(98964, 990, 0, 3), -- Celea
(98969, 990, 0, 3), -- Stalriss Dawnrunner
(99073, 990, 0, 0), -- Manfred Staller
(122698, 827, 0, 3), -- Xanjo
(136063, 826, 23262, 0), -- Cassandra Brennor
(151287, 990, 0, 3); -- Telonis

-- Mining: 16 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((3555, 0, 0), (4598, 0, 3), (6297, 0, 3), (18747, 0, 3), (18779, 0, 3), (26962, 0, 0), (65092, 14624, 0), (66360, 0, 3), (66979, 15098, 0), (67024, 0, 3), (86014, 0, 3), (93189, 0, 3), (93691, 0, 3), (122694, 23184, 0), (133369, 0, 3), (136091, 22655, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(3555, 992, 0, 0), -- Johan Focht
(4598, 992, 0, 3), -- Brom Killian
(6297, 992, 0, 3), -- Kurdram Stonehammer
(18747, 992, 0, 3), -- Krugosh
(18779, 91, 0, 3), -- Hurnak Grimmord
(26962, 992, 0, 0), -- Jonathan Lewis
(65092, 992, 14624, 0), -- Smeltmaster Ashpaw
(66360, 992, 0, 3), -- Master Brandom
(66979, 992, 15098, 0), -- Stonebreaker Ruian
(67024, 992, 0, 3), -- Rockseeker Guo
(86014, 992, 0, 3), -- Murg Stonecrack
(93189, 992, 0, 3), -- Mama Diggs
(93691, 992, 0, 3), -- Ronos Ironhorn
(122694, 842, 23184, 0), -- Secott the Goldsmith
(133369, 992, 0, 3), -- Druben Stoutarm
(136091, 841, 22655, 0); -- Myra Cabot

-- Skinning: 28 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((6242, 0, 0), (6288, 0, 0), (6290, 0, 3), (6295, 0, 0), (6306, 0, 0), (6387, 0, 3), (7089, 0, 3), (8144, 0, 3), (8777, 0, 0), (12030, 0, 3), (16273, 0, 3), (18755, 0, 3), (18777, 0, 3), (26986, 0, 0), (33641, 10360, 0), (33683, 10360, 0), (65144, 0, 0), (66981, 15100, 0), (67026, 0, 3), (85923, 0, 3), (86028, 0, 3), (98720, 0, 3), (98721, 0, 3), (98722, 0, 0), (98791, 0, 3), (98936, 0, 0), (122699, 23355, 0), (136061, 22797, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(6242, 989, 0, 0), -- World Skinning Trainer
(6288, 989, 0, 0), -- Jayla
(6290, 989, 0, 3), -- Yonn Deepcut
(6295, 989, 0, 0), -- Wilma Ranthal
(6306, 989, 0, 0), -- Helene Peltskinner
(6387, 989, 0, 3), -- Dranh
(7089, 989, 0, 3), -- Mooranta
(8144, 196, 0, 3), -- Kulleg Stonehorn
(8777, 989, 0, 0), -- Seinrick Coulthane
(12030, 196, 0, 3), -- Malux
(16273, 989, 0, 3), -- Mathreyn
(18755, 196, 0, 3), -- Moorutu
(18777, 196, 0, 3), -- Jelena Nightsky
(26986, 989, 0, 0), -- Tiponi Stormwhisper
(33641, 989, 10360, 0), -- Irduil
(33683, 989, 10360, 0), -- Dremm
(65144, 989, 0, 0), -- Tapin Wildbeard
(66981, 989, 15100, 0), -- Trapper Ri
(67026, 989, 0, 3), -- Hao of the Stag's Horns
(85923, 989, 0, 3), -- Rangari Laandon
(86028, 196, 0, 3), -- Kondal Huntsworn
(98720, 989, 0, 3), -- Ske'rit
(98721, 989, 0, 3), -- Seymour
(98722, 989, 0, 0), -- Agnes
(98791, 989, 0, 3), -- Glielle
(98936, 989, 0, 0), -- Derik Marks
(122699, 869, 23355, 0), -- Rana the Cutta
(136061, 868, 22797, 0); -- Camilla Darksky

-- Tailoring: 25 rows
DELETE FROM `creature_trainer` WHERE (`CreatureId`, `MenuId`, `OptionIndex`) IN ((3484, 4270, 0), (3704, 4350, 0), (4193, 0, 3), (4576, 0, 3), (4578, 0, 0), (16366, 7524, 1), (18772, 0, 3), (26964, 10117, 0), (26969, 10115, 0), (28699, 10118, 0), (33684, 0, 3), (43428, 0, 3), (44783, 0, 3), (45559, 4351, 0), (84619, 0, 0), (85910, 0, 0), (86004, 0, 3), (93542, 0, 3), (95794, 0, 0), (98908, 0, 0), (98912, 0, 0), (122700, 0, 3), (132265, 0, 0), (133363, 0, 3), (136071, 23264, 0));
INSERT INTO `creature_trainer` (`CreatureId`, `TrainerId`, `MenuId`, `OptionIndex`) VALUES
(3484, 163, 4270, 0), -- Kil'hala
(3704, 163, 4350, 0), -- Mahani
(4193, 163, 0, 3), -- Grondal Moonbreeze
(4576, 163, 0, 3), -- Josef Gregorian
(4578, 163, 0, 0), -- Josephine Lister
(16366, 163, 7524, 1), -- Sempstress Ambershine
(18772, 163, 0, 3), -- Hama
(26964, 163, 10117, 0), -- Alexandra McQueen
(26969, 163, 10115, 0), -- Raenah
(28699, 163, 10118, 0), -- Charles Worth
(33684, 163, 0, 3), -- Weaver Aoa
(43428, 163, 0, 3), -- Faeyrin Willowmoon
(44783, 163, 0, 3), -- Hiwahi Three-Feathers
(45559, 163, 4351, 0), -- Nivi Weavewell
(84619, 163, 0, 0), -- Daryl Stack
(85910, 163, 0, 0), -- Joshua Fuesting
(86004, 163, 0, 3), -- Saesha Silverblood
(93542, 163, 0, 3), -- Tanithria
(95794, 163, 0, 0), -- Kil'hala
(98908, 163, 0, 0), -- Ainderu Summerleaf
(98912, 163, 0, 0), -- Charles Worth
(122700, 864, 0, 3), -- Pin'jin the Patient
(132265, 864, 0, 0), -- Milliner Hakkit
(133363, 163, 0, 3), -- Aevedos
(136071, 863, 23264, 0); -- Daniel Brineweaver
