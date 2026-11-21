-- Wild battle pets: spawn every pet in the zones its pet card names (zrbfacore, 2026-11-19)
--
-- Found (Four): the Mouse pet card says "Pet Battle: Duskwood, Dustwallow Marsh, Grizzly Hills, Mulgore,
--   Netherstorm, Westfall, Wetlands", but the pool only had Mice for Duskwood and Dustwallow Marsh.
-- Cause: battlepet_wild_zone_pool (which zones get which pet) has no row for many zones the cards list.
--   Audit of every capturable species (BattlePetSpecies flag 0x8) against its card's "Pet Battle:" zones
--   (10.0.2 SourceText, same text as the 8.3.7 card): 382 (species, zone) pairs had no pool row. Left alone:
--     171 Dragonflight / Shadowlands zones, species newer than 8.3.7, dungeons, raids and the Gilneas, Kezan
--       and Tol Barad instance maps;
--     65 pairs whose pet is already spawned directly in that zone;
--     Young Mutant Warturtle, already spawned in the Dalaran Underbelly (its own map);
--     6 pairs with no usable critter spot (Lost Isles Strand Crab / Rat, Azjol-Nerub and Violet Hold
--       Spider / Rat, Great Sea Squirky).
-- Changed: 139 new pool rows.
--   68 rows name a critter that lives in the zone: the conversion below turns up to Max of
--     those critters into the pet (same procedure as 2026_11_01_50, limited to these rows).
--   71 rows have no matching critter in the zone: 194 new spawns (guids 1000100039-1000100232),
--     each 1 yard from a random unscripted, unphased critter of the zone, wandering 3 yards (as in 2026_11_10_52).
--     Max = the species' usual Max elsewhere, capped at 3. These spots do not match retail exactly.
--   Levels: the zone's existing pool levels, else AreaTable WildBattlePetLevelMin/Max.
-- Undo: DELETE FROM creature WHERE guid BETWEEN 1000100039 AND 1000100232;
--       Converted critters are logged in zr_wild_battlepet_conversion (old_id, zone) like 2026_11_01_50;
--       delete the pool rows listed below to stop more conversions.

DROP TABLE IF EXISTS `zr_new_pool`;
CREATE TABLE `zr_new_pool` (`Zone` INT UNSIGNED NOT NULL, `Species` INT UNSIGNED NOT NULL, `BattlePetEntry` INT UNSIGNED NOT NULL, `Max` INT UNSIGNED NOT NULL, `RespawnTime` INT UNSIGNED NOT NULL, `MinLevel` INT UNSIGNED NOT NULL, `MaxLevel` INT UNSIGNED NOT NULL, `CreatureEntry` INT UNSIGNED NOT NULL);
INSERT INTO `zr_new_pool` VALUES
(45, 459, 62019, 1, 60, 7, 8, 0), -- Arathi Highlands: Cat, new spawns
(45, 448, 61751, 3, 60, 7, 8, 0), -- Arathi Highlands: Hare, new spawns
(16, 378, 61080, 6, 60, 3, 6, 721), -- Azshara: Rabbit, converts Rabbit 721 (125 in zone)
(16, 417, 61366, 5, 60, 3, 6, 4075), -- Azshara: Rat, converts Rat 4075 (22 in zone)
(16, 379, 61081, 10, 60, 3, 6, 1412), -- Azshara: Squirrel, converts Squirrel 1412 (143 in zone)
(7334, 569, 63002, 1, 60, 24, 25, 0), -- Azsuna: Garden Frog, new spawns
(3522, 449, 61752, 3, 60, 18, 20, 0), -- Blade's Edge Mountains: Brown Marmot, new spawns
(3522, 378, 61080, 6, 60, 18, 20, 721), -- Blade's Edge Mountains: Rabbit, converts Rabbit 721 (8 in zone)
(4, 635, 61325, 7, 60, 16, 17, 3300), -- Blasted Lands: Adder, converts Adder 3300 (7 in zone)
(3525, 417, 61366, 5, 60, 3, 6, 4075), -- Bloodmyst Isle: Rat, converts Rat 4075 (26 in zone)
(2817, 378, 61080, 3, 60, 22, 23, 0), -- Crystalsong Forest: Rabbit, new spawns
(2817, 417, 61366, 3, 60, 22, 23, 0), -- Crystalsong Forest: Rat, new spawns
(148, 378, 61080, 6, 60, 3, 6, 721), -- Darkshore: Rabbit, converts Rabbit 721 (72 in zone)
(148, 417, 61366, 5, 60, 3, 6, 4075), -- Darkshore: Rat, converts Rat 4075 (77 in zone)
(148, 379, 61081, 10, 60, 3, 6, 1412), -- Darkshore: Squirrel, converts Squirrel 1412 (78 in zone)
(148, 401, 61312, 3, 60, 3, 6, 0), -- Darkshore: Strand Crab, new spawns
(65, 401, 61312, 3, 60, 22, 23, 0), -- Dragonblight: Strand Crab, new spawns
(1, 404, 61317, 2, 60, 1, 2, 48972), -- Dun Morogh: Long-tailed Mole, converts Long-tailed Mole 48972 (3 in zone)
(1, 378, 61080, 6, 60, 1, 2, 721), -- Dun Morogh: Rabbit, converts Rabbit 721 (12 in zone)
(1, 417, 61366, 3, 60, 1, 2, 0), -- Dun Morogh: Rat, new spawns
(1, 424, 61169, 3, 60, 1, 2, 0), -- Dun Morogh: Roach, new spawns
(1, 412, 61327, 3, 60, 1, 2, 0), -- Dun Morogh: Spider, new spawns
(1, 379, 61081, 3, 60, 1, 2, 0), -- Dun Morogh: Squirrel, new spawns
(1, 401, 61312, 3, 60, 1, 2, 0), -- Dun Morogh: Strand Crab, new spawns
(10, 378, 61080, 6, 60, 5, 7, 721), -- Duskwood: Rabbit, converts Rabbit 721 (27 in zone)
(15, 646, 62664, 2, 60, 12, 13, 620), -- Dustwallow Marsh: Chicken, converts Chicken 620 (9 in zone)
(15, 379, 61081, 10, 60, 12, 13, 1412), -- Dustwallow Marsh: Squirrel, converts Squirrel 1412 (18 in zone)
(139, 406, 61319, 46, 60, 12, 13, 15475), -- Eastern Plaguelands: Beetle, converts Beetle 15475 (93 in zone)
(139, 393, 61384, 25, 60, 12, 13, 45439), -- Eastern Plaguelands: Cockroach, converts Cockroach 45439 (80 in zone)
(139, 414, 61326, 3, 60, 12, 13, 0), -- Eastern Plaguelands: Scorpid, new spawns
(139, 412, 61327, 3, 60, 12, 13, 14881), -- Eastern Plaguelands: Spider, converts Spider 14881 (86 in zone)
(12, 412, 61327, 3, 60, 1, 2, 14881), -- Elwynn Forest: Spider, converts Spider 14881 (17 in zone)
(3430, 459, 62019, 1, 60, 1, 2, 0), -- Eversong Woods: Cat, new spawns
(3430, 378, 61080, 6, 60, 1, 2, 721), -- Eversong Woods: Rabbit, converts Rabbit 721 (6 in zone)
(357, 378, 61080, 6, 60, 11, 12, 721), -- Feralas: Rabbit, converts Rabbit 721 (39 in zone)
(6720, 541, 62886, 3, 60, 24, 25, 0), -- Frostfire Ridge: Fire-Proof Roach, new spawns
(3433, 417, 61366, 5, 60, 3, 6, 4075), -- Ghostlands: Rat, converts Rat 4075 (24 in zone)
(3433, 412, 61327, 3, 60, 3, 6, 14881), -- Ghostlands: Spider, converts Spider 14881 (14 in zone)
(394, 385, 61143, 1, 60, 21, 22, 0), -- Grizzly Hills: Mouse, new spawns
(3483, 514, 62555, 3, 60, 17, 18, 0), -- Hellfire Peninsula: Flayer Youngling, new spawns
(267, 646, 62664, 1, 60, 6, 7, 620), -- Hillsbrad Foothills: Chicken, converts Chicken 620 (1 in zone)
(267, 378, 61080, 6, 60, 6, 7, 721), -- Hillsbrad Foothills: Rabbit, converts Rabbit 721 (7 in zone)
(267, 412, 61327, 3, 60, 6, 7, 14881), -- Hillsbrad Foothills: Spider, converts Spider 14881 (34 in zone)
(267, 379, 61081, 3, 60, 6, 7, 0), -- Hillsbrad Foothills: Squirrel, new spawns
(495, 378, 61080, 5, 60, 20, 22, 721), -- Howling Fjord: Rabbit, converts Rabbit 721 (5 in zone)
(495, 424, 61169, 8, 60, 20, 22, 4076), -- Howling Fjord: Roach, converts Roach 4076 (11 in zone)
(495, 412, 61327, 3, 60, 20, 22, 14881), -- Howling Fjord: Spider, converts Spider 14881 (7 in zone)
(495, 420, 61369, 3, 60, 20, 22, 0), -- Howling Fjord: Toad, new spawns
(6134, 560, 62953, 3, 60, 23, 25, 0), -- Krasarang Wilds: Sea Gull, new spawns
(6134, 388, 61158, 3, 60, 23, 25, 0), -- Krasarang Wilds: Shore Crab, new spawns
(38, 424, 61169, 3, 60, 3, 6, 0), -- Loch Modan: Roach, new spawns
(38, 419, 61071, 9, 60, 3, 6, 13321), -- Loch Modan: Small Frog, converts Small Frog 13321 (104 in zone)
(38, 379, 61081, 10, 60, 3, 6, 1412), -- Loch Modan: Squirrel, converts Squirrel 1412 (146 in zone)
(10290, 2662, 154769, 3, 60, 25, 25, 0), -- Mechagon: Duskytooth Snooter, new spawns
(10290, 2664, 154773, 3, 60, 25, 25, 0), -- Mechagon: Experimental Roach, new spawns
(10290, 2665, 154775, 3, 60, 25, 25, 0), -- Mechagon: Fleeting Frog, new spawns
(10290, 2667, 154779, 3, 60, 25, 25, 0), -- Mechagon: Motorized Croaker, new spawns
(10290, 2669, 154783, 3, 60, 25, 25, 0), -- Mechagon: Rustbolt Clucker, new spawns
(10290, 2661, 154767, 3, 60, 25, 25, 0), -- Mechagon: Rustyroot Snooter, new spawns
(10290, 2673, 154791, 3, 60, 25, 25, 0), -- Mechagon: Scrapyard Tunneler, new spawns
(10290, 2671, 154787, 3, 60, 25, 25, 0), -- Mechagon: Specimen 97, new spawns
(10290, 2666, 154777, 3, 60, 25, 25, 0), -- Mechagon: Yellow Junkhopper, new spawns
(493, 378, 61080, 6, 60, 15, 16, 721), -- Moonglade: Rabbit, converts Rabbit 721 (36 in zone)
(493, 503, 62373, 3, 60, 15, 16, 0), -- Moonglade: Silky Moth, new spawns
(493, 379, 61081, 10, 60, 15, 16, 1412), -- Moonglade: Squirrel, converts Squirrel 1412 (98 in zone)
(616, 626, 61829, 11, 60, 22, 24, 20725), -- Mount Hyjal: Bat, converts Bat 20725 (31 in zone)
(616, 478, 62177, 3, 60, 22, 24, 0), -- Mount Hyjal: Forest Moth, new spawns
(616, 378, 61080, 6, 60, 22, 24, 721), -- Mount Hyjal: Rabbit, converts Rabbit 721 (19 in zone)
(616, 379, 61081, 3, 60, 22, 24, 0), -- Mount Hyjal: Squirrel, new spawns
(215, 385, 61143, 1, 60, 1, 2, 0), -- Mulgore: Mouse, new spawns
(215, 378, 61080, 6, 60, 1, 2, 721), -- Mulgore: Rabbit, converts Rabbit 721 (10 in zone)
(3518, 378, 61080, 6, 60, 18, 19, 721), -- Nagrand: Rabbit, converts Rabbit 721 (34 in zone)
(3518, 417, 61366, 5, 60, 18, 19, 4075), -- Nagrand: Rat, converts Rat 4075 (63 in zone)
(3518, 387, 61142, 2, 60, 18, 19, 2914), -- Nagrand: Snake, converts Snake 2914 (2 in zone)
(10052, 2652, 154714, 3, 60, 25, 25, 0), -- Nazjatar: Bloodseeker, new spawns
(10052, 2648, 154706, 3, 60, 25, 25, 0), -- Nazjatar: Chitterspine Skitterling, new spawns
(10052, 2651, 154712, 3, 60, 25, 25, 0), -- Nazjatar: Deeptide Fingerling, new spawns
(10052, 2649, 154708, 3, 60, 25, 25, 0), -- Nazjatar: Hissing Chitterspine, new spawns
(10052, 2646, 154702, 3, 60, 25, 25, 0), -- Nazjatar: Sandclaw Sunshell, new spawns
(10052, 2653, 154716, 3, 60, 25, 25, 0), -- Nazjatar: Spireshell Snail, new spawns
(8500, 2397, 143054, 3, 60, 25, 25, 0), -- Nazmir: Spectral Raven, new spawns
(3523, 459, 62019, 1, 60, 20, 21, 0), -- Netherstorm: Cat, new spawns
(3523, 385, 61143, 1, 60, 20, 21, 0), -- Netherstorm: Mouse, new spawns
(1637, 414, 61326, 3, 60, 1, 1, 0), -- Orgrimmar: Scorpid, new spawns
(1637, 412, 61327, 3, 60, 1, 1, 0), -- Orgrimmar: Spider, new spawns
(4706, 417, 61366, 3, 60, 0, 0, 0), -- Ruins of Gilneas: Rat, new spawns
(4706, 412, 61327, 3, 60, 0, 0, 0), -- Ruins of Gilneas: Spider, new spawns
(4706, 379, 61081, 3, 60, 0, 0, 0), -- Ruins of Gilneas: Squirrel, new spawns
(3520, 407, 61320, 3, 60, 20, 21, 0), -- Shadowmoon Valley: Forest Spiderling, new spawns
(3703, 417, 61366, 5, 60, 0, 0, 4075), -- Shattrath City: Rat, converts Rat 4075 (25 in zone)
(3711, 379, 61081, 10, 60, 21, 22, 1412), -- Sholazar Basin: Squirrel, converts Squirrel 1412 (59 in zone)
(3487, 459, 62019, 1, 60, 1, 3, 6368), -- Silvermoon City: Cat, converts Cat 6368 (13 in zone)
(3487, 378, 61080, 3, 60, 1, 3, 721), -- Silvermoon City: Rabbit, converts Rabbit 721 (3 in zone)
(130, 378, 61080, 6, 60, 3, 6, 721), -- Silverpine Forest: Rabbit, converts Rabbit 721 (14 in zone)
(130, 417, 61366, 5, 60, 3, 6, 4075), -- Silverpine Forest: Rat, converts Rat 4075 (8 in zone)
(130, 387, 61142, 19, 60, 3, 6, 2914), -- Silverpine Forest: Snake, converts Snake 2914 (59 in zone)
(130, 379, 61081, 10, 60, 3, 6, 1412), -- Silverpine Forest: Squirrel, converts Squirrel 1412 (10 in zone)
(406, 417, 61366, 5, 60, 5, 7, 4075), -- Stonetalon Mountains: Rat, converts Rat 4075 (13 in zone)
(7541, 1917, 111172, 3, 60, 24, 25, 0), -- Stormheim: Stormstruck Beaver, new spawns
(9042, 2374, 143033, 3, 60, 25, 25, 0), -- Stormsong Valley: Freshwater Crawler, new spawns
(1519, 417, 61366, 5, 60, 1, 1, 4075), -- Stormwind City: Rat, converts Rat 4075 (34 in zone)
(8, 417, 61366, 5, 60, 14, 15, 4075), -- Swamp of Sorrows: Rat, converts Rat 4075 (9 in zone)
(8, 419, 61071, 3, 60, 14, 15, 0), -- Swamp of Sorrows: Small Frog, new spawns
(8, 412, 61327, 3, 60, 14, 15, 14881), -- Swamp of Sorrows: Spider, converts Spider 14881 (11 in zone)
(6723, 450, 61753, 7, 60, 25, 25, 16030), -- Tanaan Jungle: Maggot, converts Maggot 16030 (8 in zone)
(141, 412, 61327, 3, 60, 1, 2, 14881), -- Teldrassil: Spider, converts Spider 14881 (33 in zone)
(141, 379, 61081, 3, 60, 1, 2, 0), -- Teldrassil: Squirrel, new spawns
(141, 420, 61369, 3, 60, 1, 2, 0), -- Teldrassil: Toad, new spawns
(3519, 646, 62664, 2, 60, 18, 19, 0), -- Terokkar Forest: Chicken, new spawns
(47, 412, 61327, 3, 60, 11, 12, 14881), -- The Hinterlands: Spider, converts Spider 14881 (41 in zone)
(67, 412, 61327, 3, 60, 22, 23, 0), -- The Storm Peaks: Spider, new spawns
(1638, 386, 61141, 1, 60, 1, 3, 2620), -- Thunder Bluff: Prairie Dog, converts Prairie Dog 2620 (1 in zone)
(85, 646, 62664, 2, 60, 1, 2, 620), -- Tirisfal Glades: Chicken, converts Chicken 620 (8 in zone)
(85, 378, 61080, 6, 60, 1, 2, 721), -- Tirisfal Glades: Rabbit, converts Rabbit 721 (9 in zone)
(85, 424, 61169, 5, 60, 1, 2, 4076), -- Tirisfal Glades: Roach, converts Roach 4076 (5 in zone)
(85, 412, 61327, 3, 60, 1, 2, 14881), -- Tirisfal Glades: Spider, converts Spider 14881 (22 in zone)
(85, 454, 61889, 31, 60, 1, 2, 49965), -- Tirisfal Glades: Undercity Rat, converts Undercity Rat 49965 (31 in zone)
(4922, 379, 61081, 3, 60, 23, 24, 0), -- Twilight Highlands: Squirrel, new spawns
(4922, 420, 61369, 3, 60, 23, 24, 0), -- Twilight Highlands: Toad, new spawns
(4922, 2677, 154803, 3, 60, 23, 24, 0), -- Twilight Highlands: Twilight Whelpling, new spawns
(5034, 2863, 162499, 3, 60, 23, 24, 0), -- Uldum: Oasis Void-Duster, new spawns
(5034, 2864, 162502, 3, 60, 23, 24, 0), -- Uldum: Void-Scarred Locust, new spawns
(490, 503, 62373, 3, 60, 15, 16, 0), -- Un'Goro Crater: Silky Moth, new spawns
(7558, 379, 61081, 7, 60, 24, 25, 1412), -- Val'sharah: Squirrel, converts Squirrel 1412 (7 in zone)
(5840, 2867, 162525, 3, 60, 24, 25, 0), -- Vale of Eternal Blossoms: Golden Chirper, new spawns
(5840, 2866, 162506, 3, 60, 24, 25, 0), -- Vale of Eternal Blossoms: Voidglower, new spawns
(5840, 2865, 162518, 3, 60, 24, 25, 0), -- Vale of Eternal Blossoms: Voidskimmer, new spawns
(28, 378, 61080, 6, 60, 10, 11, 721), -- Western Plaguelands: Rabbit, converts Rabbit 721 (19 in zone)
(28, 379, 61081, 10, 60, 10, 11, 1412), -- Western Plaguelands: Squirrel, converts Squirrel 1412 (13 in zone)
(40, 385, 61143, 1, 60, 3, 4, 0), -- Westfall: Mouse, new spawns
(40, 378, 61080, 5, 60, 3, 4, 721), -- Westfall: Rabbit, converts Rabbit 721 (5 in zone)
(40, 379, 61081, 4, 60, 3, 4, 1412), -- Westfall: Squirrel, converts Squirrel 1412 (4 in zone)
(11, 646, 62664, 2, 60, 6, 7, 620), -- Wetlands: Chicken, converts Chicken 620 (11 in zone)
(11, 385, 61143, 1, 60, 6, 7, 0), -- Wetlands: Mouse, new spawns
(11, 378, 61080, 5, 60, 6, 7, 721), -- Wetlands: Rabbit, converts Rabbit 721 (5 in zone)
(11, 379, 61081, 10, 60, 6, 7, 1412), -- Wetlands: Squirrel, converts Squirrel 1412 (12 in zone)
(618, 412, 61327, 3, 60, 17, 18, 14881), -- Winterspring: Spider, converts Spider 14881 (20 in zone)
(66, 412, 61327, 3, 60, 22, 23, 0), -- Zul'Drak: Spider, new spawns
(8499, 2537, 148517, 3, 60, 25, 25, 0); -- Zuldazar: Baby Zandalari Raptor, new spawns

DELETE p FROM `battlepet_wild_zone_pool` p JOIN `zr_new_pool` n ON n.`Zone` = p.`Zone` AND n.`Species` = p.`Species` AND n.`BattlePetEntry` = p.`BattlePetEntry`;
INSERT INTO `battlepet_wild_zone_pool` (`Zone`, `Species`, `BattlePetEntry`, `Max`, `RespawnTime`, `MinLevel`, `MaxLevel`, `CreatureEntry`)
SELECT `Zone`, `Species`, `BattlePetEntry`, `Max`, `RespawnTime`, `MinLevel`, `MaxLevel`, `CreatureEntry` FROM `zr_new_pool`;

DELETE FROM `creature` WHERE `guid` BETWEEN 1000100039 AND 1000100232;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`) VALUES
(1000100039, 61080, 571, 2817, 4549, '0', 0, 0, 0, -1, 0, 0, 6021.335, 1109.927, 176.42, 4.834, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rabbit (Crystalsong Forest), next to critter 78141
(1000100040, 61080, 571, 2817, 2817, '0', 0, 0, 0, -1, 0, 0, 5884.127, 928.225, 160.891, 5.94, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rabbit (Crystalsong Forest), next to critter 78136
(1000100041, 61080, 571, 2817, 4549, '0', 0, 0, 0, -1, 0, 0, 5987.262, 1109.81, 180.357, 3.553, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rabbit (Crystalsong Forest), next to critter 78140
(1000100042, 61081, 0, 1, 1, '0', 0, 0, 0, -1, 0, 0, -5279.504, -674.667, 389.571, 1.726, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Dun Morogh), next to critter 10646549
(1000100043, 61081, 0, 1, 212, '0', 0, 0, 0, -1, 0, 0, -5652.34, -2114.149, 400.571, 4.182, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Dun Morogh), next to critter 170348
(1000100044, 61081, 0, 1, 804, '0', 0, 0, 0, -1, 0, 0, -5866.24, -1206.797, 388.473, 0.172, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Dun Morogh), next to critter 169820
(1000100045, 61081, 0, 267, 267, '0', 0, 0, 0, -1, 0, 0, 106.477, -648.373, 92.3555, 3.525, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Hillsbrad Foothills), next to critter 10649849
(1000100046, 61081, 0, 267, 267, '0', 0, 0, 0, -1, 0, 0, -567.275, -414.947, 41.8291, 0.038, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Hillsbrad Foothills), next to critter 10649847
(1000100047, 61081, 0, 267, 1681, '0', 0, 0, 0, -1, 0, 0, 651.535, 90.763, 39.5321, 0.385, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Hillsbrad Foothills), next to critter 10649873
(1000100048, 61081, 1, 616, 4989, '0', 0, 0, 0, -1, 0, 0, 5120.11, -1736.68, 1333.77, 6.164, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Mount Hyjal), next to critter 285157
(1000100049, 61081, 1, 616, 4991, '0', 0, 0, 0, -1, 0, 0, 4616.938, -4452.865, 884.087, 6.102, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Mount Hyjal), next to critter 10651506
(1000100050, 61081, 1, 616, 5087, '0', 0, 0, 0, -1, 0, 0, 4021.039, -2202.0, 1133.54, 1.299, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Mount Hyjal), next to critter 10651469
(1000100051, 61081, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -963.475, 1736.212, 60.0479, 2.763, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Ruins of Gilneas), next to critter 358682
(1000100052, 61081, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -897.464, 1976.803, 37.1633, 3.291, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Ruins of Gilneas), next to critter 299127
(1000100053, 61081, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -1165.077, 1898.148, 22.1405, 4.155, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Ruins of Gilneas), next to critter 358693
(1000100054, 61081, 1, 141, 141, '0', 0, 0, 0, -1, 0, 0, 10202.302, 1615.971, 1303.17, 0.148, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Teldrassil), next to critter 10649648
(1000100055, 61081, 1, 141, 261, '0', 0, 0, 0, -1, 0, 0, 9169.77, 1708.644, 1320.67, 2.943, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Teldrassil), next to critter 10649621
(1000100056, 61081, 1, 141, 141, '0', 0, 0, 0, -1, 0, 0, 9938.166, 893.575, 1344.77, 2.53, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Teldrassil), next to critter 277130
(1000100057, 61081, 0, 4922, 5473, '0', 0, 0, 0, -1, 0, 0, -4961.439, -4378.006, 355.139, 0.462, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Twilight Highlands), next to critter 10653465
(1000100058, 61081, 0, 4922, 4922, '0', 0, 0, 0, -1, 0, 0, -3119.214, -5367.081, 89.0076, 5.264, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Twilight Highlands), next to critter 10653443
(1000100059, 61081, 0, 4922, 5489, '0', 0, 0, 0, -1, 0, 0, -4328.72, -5126.508, 52.942, 5.127, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Squirrel (Twilight Highlands), next to critter 10653336
(1000100060, 61143, 571, 394, 394, '0', 0, 0, 0, -1, 0, 0, 3851.666, -4418.013, 196.475, 1.407, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Grizzly Hills), next to critter 10650247
(1000100061, 61143, 1, 215, 222, '0', 0, 0, 0, -1, 0, 0, -2277.095, -455.1, -8.07423, 3.021, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Mulgore), next to critter 366776
(1000100062, 61143, 530, 3523, 3735, '0', 0, 0, 0, -1, 0, 0, 3673.169, 2294.825, 107.385, 3.032, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Netherstorm), next to critter 10652870
(1000100063, 61143, 0, 40, 113, '0', 0, 0, 0, -1, 0, 0, -10494.954, 1889.517, 39.4897, 0.977, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Westfall), next to critter 215736
(1000100064, 61143, 0, 11, 118, '0', 0, 0, 0, -1, 0, 0, -3425.879, -1795.283, 16.6986, 3.749, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Mouse (Wetlands), next to critter 10647229
(1000100065, 61158, 870, 6134, 6019, '0', 0, 0, 0, -1, 0, 0, -1485.239, 2129.507, 26.8048, 2.578, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Shore Crab (Krasarang Wilds), next to critter 10543825
(1000100066, 61158, 870, 6134, 6148, '0', 0, 0, 0, -1, 0, 0, -2864.727, 1014.36, 1.09661, 4.826, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Shore Crab (Krasarang Wilds), next to critter 10550368
(1000100067, 61158, 870, 6134, 6106, '0', 0, 0, 0, -1, 0, 0, -1471.37, -225.957, 4.96041, 5.543, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Shore Crab (Krasarang Wilds), next to critter 10561219
(1000100068, 61312, 1, 148, 2077, '0', 0, 0, 0, -1, 0, 0, 4765.927, 281.627, 52.6086, 1.99, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Darkshore), next to critter 246446
(1000100069, 61312, 1, 148, 2078, '0', 0, 0, 0, -1, 0, 0, 4839.456, 917.935, -12.2534, 3.236, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Darkshore), next to critter 245957
(1000100070, 61312, 1, 148, 2077, '0', 0, 0, 0, -1, 0, 0, 4880.057, 249.054, 50.8218, 5.466, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Darkshore), next to critter 246869
(1000100071, 61312, 571, 65, 4180, '0', 0, 0, 0, -1, 0, 0, 2856.638, -422.373, 118.212, 1.966, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dragonblight), next to critter 316847
(1000100072, 61312, 571, 65, 4180, '0', 0, 0, 0, -1, 0, 0, 2911.316, -464.326, 124.207, 3.14, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dragonblight), next to critter 316880
(1000100073, 61312, 571, 65, 4180, '0', 0, 0, 0, -1, 0, 0, 2941.208, -429.369, 122.987, 3.909, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dragonblight), next to critter 316885
(1000100074, 61312, 0, 1, 809, '0', 0, 0, 0, -1, 0, 0, -5172.119, -701.864, 432.321, 3.485, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dun Morogh), next to critter 302936
(1000100075, 61312, 0, 1, 802, '0', 0, 0, 0, -1, 0, 0, -5057.856, -276.678, 442.267, 0.997, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dun Morogh), next to critter 167867
(1000100076, 61312, 0, 1, 1, '0', 0, 0, 0, -1, 0, 0, -4966.459, 794.514, 484.913, 2.396, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Strand Crab (Dun Morogh), next to critter 10646552
(1000100077, 61320, 530, 3520, 3520, '0', 0, 0, 0, -1, 0, 0, -3547.568, 859.155, 7.46331, 2.147, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Spiderling (Shadowmoon Valley), next to critter 10652686
(1000100078, 61320, 530, 3520, 3933, '0', 0, 0, 0, -1, 0, 0, -3010.489, 2002.351, 97.0583, 1.492, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Spiderling (Shadowmoon Valley), next to critter 10652672
(1000100079, 61320, 530, 3520, 3520, '0', 0, 0, 0, -1, 0, 0, -2981.019, 2949.434, 90.074, 0.426, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Spiderling (Shadowmoon Valley), next to critter 10652623
(1000100080, 61327, 0, 1, 1, '0', 0, 0, 0, -1, 0, 0, -4410.739, -1525.593, 479.902, 2.469, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Dun Morogh), next to critter 181057
(1000100081, 61327, 0, 1, 809, '0', 0, 0, 0, -1, 0, 0, -5175.995, -742.013, 448.658, 0.743, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Dun Morogh), next to critter 302912
(1000100082, 61327, 0, 1, 809, '0', 0, 0, 0, -1, 0, 0, -5103.817, -814.818, 495.579, 0.343, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Dun Morogh), next to critter 302980
(1000100083, 61327, 1, 1637, 5170, '0', 0, 0, 0, -1, 0, 0, 1601.324, -4397.722, 17.7229, 4.09, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Orgrimmar), next to critter 10652086
(1000100084, 61327, 1, 1637, 5168, '0', 0, 0, 0, -1, 0, 0, 1948.091, -4627.359, 34.9976, 3.035, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Orgrimmar), next to critter 10652096
(1000100085, 61327, 1, 1637, 5169, '0', 0, 0, 0, -1, 0, 0, 1678.901, -4035.835, 75.2697, 4.961, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Orgrimmar), next to critter 10652068
(1000100086, 61327, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -898.18, 1976.618, 37.2883, 5.649, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Ruins of Gilneas), next to critter 299123
(1000100087, 61327, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -1005.629, 1876.636, 39.342, 4.796, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Ruins of Gilneas), next to critter 358696
(1000100088, 61327, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -961.28, 1730.464, 60.7384, 5.445, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Ruins of Gilneas), next to critter 358681
(1000100089, 61327, 571, 67, 4436, '0', 0, 0, 0, -1, 0, 0, 8121.512, -122.28, 857.402, 0.375, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (The Storm Peaks), next to critter 10649078
(1000100090, 61327, 571, 67, 4419, '0', 0, 0, 0, -1, 0, 0, 6244.341, -917.745, 403.991, 4.692, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (The Storm Peaks), next to critter 10649104
(1000100091, 61327, 571, 67, 4446, '0', 0, 0, 0, -1, 0, 0, 8017.701, -2240.6, 1159.17, 3.016, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (The Storm Peaks), next to critter 10649115
(1000100092, 61327, 571, 66, 4320, '0', 0, 0, 0, -1, 0, 0, 5781.312, -2933.033, 286.14, 2.445, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Zul'Drak), next to critter 99042
(1000100093, 61327, 571, 66, 4320, '0', 0, 0, 0, -1, 0, 0, 5876.845, -3049.284, 326.98, 0.845, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Zul'Drak), next to critter 98975
(1000100094, 61327, 571, 66, 4320, '0', 0, 0, 0, -1, 0, 0, 5735.969, -2890.866, 284.593, 1.55, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spider (Zul'Drak), next to critter 99062
(1000100095, 61326, 0, 139, 139, '0', 0, 0, 0, -1, 0, 0, 1952.217, -2842.855, 80.1641, 0.366, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Eastern Plaguelands), next to critter 10649378
(1000100096, 61326, 0, 139, 2264, '0', 0, 0, 0, -1, 0, 0, 2048.774, -4632.695, 82.6751, 1.005, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Eastern Plaguelands), next to critter 10649435
(1000100097, 61326, 0, 139, 2626, '0', 0, 0, 0, -1, 0, 0, 2895.748, -2600.311, 89.4759, 3.681, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Eastern Plaguelands), next to critter 213958
(1000100098, 61326, 1, 1637, 5170, '0', 0, 0, 0, -1, 0, 0, 1563.663, -4312.42, 24.2766, 4.608, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Orgrimmar), next to critter 10652083
(1000100099, 61326, 1, 1637, 5170, '0', 0, 0, 0, -1, 0, 0, 1509.891, -4345.938, 80.1186, 1.527, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Orgrimmar), next to critter 280001035
(1000100100, 61326, 1, 1637, 5168, '0', 0, 0, 0, -1, 0, 0, 2057.367, -4764.692, 28.2677, 0.963, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scorpid (Orgrimmar), next to critter 10652028
(1000100101, 61366, 571, 2817, 4553, '0', 0, 0, 0, -1, 0, 0, 5810.229, 663.987, 162.719, 0.237, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Crystalsong Forest), next to critter 112401
(1000100102, 61366, 571, 2817, 4549, '0', 0, 0, 0, -1, 0, 0, 6021.401, 1110.401, 176.42, 0.806, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Crystalsong Forest), next to critter 78141
(1000100103, 61366, 571, 2817, 2817, '0', 0, 0, 0, -1, 0, 0, 5883.011, 926.831, 160.891, 4.106, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Crystalsong Forest), next to critter 78136
(1000100104, 61366, 0, 1, 1, '0', 0, 0, 0, -1, 0, 0, -5863.266, -20.718, 360.328, 6.046, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Dun Morogh), next to critter 168734
(1000100105, 61366, 0, 1, 1, '0', 0, 0, 0, -1, 0, 0, -5289.255, -651.532, 389.272, 2.759, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Dun Morogh), next to critter 168861
(1000100106, 61366, 0, 1, 809, '0', 0, 0, 0, -1, 0, 0, -5102.249, -730.545, 467.347, 3.015, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Dun Morogh), next to critter 302976
(1000100107, 61366, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -1178.201, 1901.815, 22.8063, 4.944, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Ruins of Gilneas), next to critter 358700
(1000100108, 61366, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -777.047, 1704.648, 68.5414, 5.368, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Ruins of Gilneas), next to critter 358676
(1000100109, 61366, 0, 4706, 5440, '0', 0, 0, 0, -1, 0, 0, -898.675, 1976.885, 37.4133, 3.858, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rat (Ruins of Gilneas), next to critter 299125
(1000100110, 61071, 0, 8, 8, '0', 0, 0, 0, -1, 0, 0, -10663.395, -3837.999, 23.4553, 5.943, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Small Frog (Swamp of Sorrows), next to critter 10646960
(1000100111, 61071, 0, 8, 1798, '0', 0, 0, 0, -1, 0, 0, -10299.268, -2983.997, 22.9584, 5.113, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Small Frog (Swamp of Sorrows), next to critter 10646936
(1000100112, 61071, 0, 8, 116, '0', 0, 0, 0, -1, 0, 0, -10220.377, -2542.394, 28.671, 4.848, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Small Frog (Swamp of Sorrows), next to critter 10646927
(1000100113, 61369, 571, 495, 495, '0', 0, 0, 0, -1, 0, 0, -229.205, -5573.011, 18.5249, 2.292, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Howling Fjord), next to critter 97873
(1000100114, 61369, 571, 495, 3984, '0', 0, 0, 0, -1, 0, 0, 820.203, -5530.047, 212.313, 3.991, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Howling Fjord), next to critter 354279
(1000100115, 61369, 571, 495, 3994, '0', 0, 0, 0, -1, 0, 0, 930.865, -4407.189, 137.119, 3.865, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Howling Fjord), next to critter 115762
(1000100116, 61369, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9906.294, 1006.927, 1337.81, 5.44, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Teldrassil), next to critter 277114
(1000100117, 61369, 1, 141, 736, '0', 0, 0, 0, -1, 0, 0, 9999.535, 1343.962, 1285.46, 3.104, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Teldrassil), next to critter 10649650
(1000100118, 61369, 1, 141, 141, '0', 0, 0, 0, -1, 0, 0, 9941.412, 1975.231, 1340.51, 2.938, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Teldrassil), next to critter 277200
(1000100119, 61369, 0, 4922, 5155, '0', 0, 0, 0, -1, 0, 0, -2872.651, -3638.427, 194.696, 1.108, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Twilight Highlands), next to critter 10653537
(1000100120, 61369, 0, 4922, 4922, '0', 0, 0, 0, -1, 0, 0, -3260.72, -4851.085, 127.624, 3.457, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Twilight Highlands), next to critter 10653545
(1000100121, 61369, 0, 4922, 5489, '0', 0, 0, 0, -1, 0, 0, -4327.943, -5124.672, 52.942, 1.987, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Toad (Twilight Highlands), next to critter 10653551
(1000100122, 61169, 0, 1, 809, '0', 0, 0, 0, -1, 0, 0, -5154.087, -728.689, 454.609, 5.44, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Dun Morogh), next to critter 302949
(1000100123, 61169, 0, 1, 5115, '0', 0, 0, 0, -1, 0, 0, -5294.904, -1654.549, 508.198, 3.774, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Dun Morogh), next to critter 181109
(1000100124, 61169, 0, 1, 716, '0', 0, 0, 0, -1, 0, 0, -5912.433, -1911.047, 405.294, 1.494, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Dun Morogh), next to critter 170350
(1000100125, 61169, 0, 38, 556, '0', 0, 0, 0, -1, 0, 0, -4951.069, -3247.395, 280.325, 2.088, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Loch Modan), next to critter 182209
(1000100126, 61169, 0, 38, 556, '0', 0, 0, 0, -1, 0, 0, -4957.198, -3251.024, 282.956, 4.011, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Loch Modan), next to critter 182533
(1000100127, 61169, 0, 38, 556, '0', 0, 0, 0, -1, 0, 0, -5153.25, -3183.586, 291.049, 3.839, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Roach (Loch Modan), next to critter 182618
(1000100128, 61751, 0, 45, 45, '0', 0, 0, 0, -1, 0, 0, -1818.756, -2468.111, 49.0914, 0.505, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hare (Arathi Highlands), next to critter 160403
(1000100129, 61751, 0, 45, 45, '0', 0, 0, 0, -1, 0, 0, -650.328, -1922.631, 60.8872, 1.172, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hare (Arathi Highlands), next to critter 160213
(1000100130, 61751, 0, 45, 45, '0', 0, 0, 0, -1, 0, 0, -1952.324, -2480.123, 64.6836, 3.404, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hare (Arathi Highlands), next to critter 217304
(1000100131, 61752, 530, 3522, 3904, '0', 0, 0, 0, -1, 0, 0, 2680.546, 5699.111, -15.8483, 5.042, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Brown Marmot (Blade's Edge Mountains), next to critter 10652804
(1000100132, 61752, 530, 3522, 3824, '0', 0, 0, 0, -1, 0, 0, 1855.026, 6479.532, 2.57748, 2.143, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Brown Marmot (Blade's Edge Mountains), next to critter 10652793
(1000100133, 61752, 530, 3522, 3775, '0', 0, 0, 0, -1, 0, 0, 2751.254, 5958.967, 12.4024, 4.77, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Brown Marmot (Blade's Edge Mountains), next to critter 10652800
(1000100134, 62019, 0, 45, 314, '0', 0, 0, 0, -1, 0, 0, -1681.677, -3045.496, 26.0295, 0.205, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Cat (Arathi Highlands), next to critter 10648423
(1000100135, 62019, 530, 3430, 3665, '0', 0, 0, 0, -1, 0, 0, 9520.64, -6816.161, 16.5733, 3.534, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Cat (Eversong Woods), next to critter 361274
(1000100136, 62019, 530, 3523, 3735, '0', 0, 0, 0, -1, 0, 0, 3604.76, 2005.338, 104.924, 2.989, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Cat (Netherstorm), next to critter 10652876
(1000100137, 62177, 1, 616, 4861, '0', 0, 0, 0, -1, 0, 0, 5117.905, -1314.212, 1358.0, 5.791, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Moth (Mount Hyjal), next to critter 284509
(1000100138, 62177, 1, 616, 616, '0', 0, 0, 0, -1, 0, 0, 4094.897, -2592.542, 1019.01, 1.807, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Moth (Mount Hyjal), next to critter 10651478
(1000100139, 62177, 1, 616, 4861, '0', 0, 0, 0, -1, 0, 0, 4632.581, -2422.783, 1150.68, 1.865, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Forest Moth (Mount Hyjal), next to critter 10651327
(1000100140, 62373, 1, 493, 2361, '0', 0, 0, 0, -1, 0, 0, 7906.255, -2413.936, 483.004, 0.54, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Moonglade), next to critter 259822
(1000100141, 62373, 1, 493, 656, '0', 0, 0, 0, -1, 0, 0, 7632.535, -2429.939, 453.867, 5.76, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Moonglade), next to critter 259943
(1000100142, 62373, 1, 493, 656, '0', 0, 0, 0, -1, 0, 0, 7496.816, -2713.518, 457.981, 5.409, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Moonglade), next to critter 259870
(1000100143, 62373, 1, 490, 537, '0', 0, 0, 0, -1, 0, 0, -7365.496, -1530.299, -253.825, 0.931, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Un'Goro Crater), next to critter 281011
(1000100144, 62373, 1, 490, 4885, '0', 0, 0, 0, -1, 0, 0, -6882.088, -1956.107, -270.733, 1.772, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Un'Goro Crater), next to critter 281458
(1000100145, 62373, 1, 490, 538, '0', 0, 0, 0, -1, 0, 0, -6366.11, -1475.785, -250.024, 4.981, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Silky Moth (Un'Goro Crater), next to critter 280993
(1000100146, 62555, 530, 3483, 3543, '0', 0, 0, 0, -1, 0, 0, -839.658, 4082.186, 33.4577, 2.34, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Flayer Youngling (Hellfire Peninsula), next to critter 10652341
(1000100147, 62555, 530, 3483, 3816, '0', 0, 0, 0, -1, 0, 0, -1074.382, 3028.672, 14.7836, 4.436, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Flayer Youngling (Hellfire Peninsula), next to critter 10652353
(1000100148, 62555, 530, 3483, 3483, '0', 0, 0, 0, -1, 0, 0, -1252.933, 3080.252, 31.5432, 0.665, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Flayer Youngling (Hellfire Peninsula), next to critter 10652351
(1000100149, 62886, 1116, 6720, 6869, '0', 0, 0, 0, -1, 0, 0, 5683.47, 6404.037, 120.412, 4.805, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fire-Proof Roach (Frostfire Ridge), next to critter 1410581
(1000100150, 62886, 1116, 6720, 6784, '0', 0, 0, 0, -1, 0, 0, 7477.499, 3231.9, 161.858, 6.073, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fire-Proof Roach (Frostfire Ridge), next to critter 1414497
(1000100151, 62886, 1116, 6720, 6779, '0', 0, 0, 0, -1, 0, 0, 5161.028, 3772.467, 128.276, 0.601, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fire-Proof Roach (Frostfire Ridge), next to critter 1415482
(1000100152, 62953, 870, 6134, 6108, '0', 0, 0, 0, -1, 0, 0, -1311.596, -508.998, -70.2383, 3.15, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sea Gull (Krasarang Wilds), next to critter 10561074
(1000100153, 62953, 870, 6134, 6010, '0', 0, 0, 0, -1, 0, 0, -797.884, -66.842, 9.87027, 0.08, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sea Gull (Krasarang Wilds), next to critter 10568101
(1000100154, 62953, 870, 6134, 6018, '0', 0, 0, 0, -1, 0, 0, -1186.372, 1399.846, -13.4647, 2.434, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sea Gull (Krasarang Wilds), next to critter 10568124
(1000100155, 63002, 1220, 7334, 7354, '0', 0, 0, 0, -1, 0, 0, -390.696, 7245.41, 22.4075, 4.077, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Garden Frog (Azsuna), next to critter 20501317
(1000100156, 62664, 530, 3519, 3519, '0', 0, 0, 0, -1, 0, 0, -2504.335, 3433.815, -15.2658, 1.093, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Chicken (Terokkar Forest), next to critter 10652533
(1000100157, 62664, 530, 3519, 3519, '0', 0, 0, 0, -1, 0, 0, -2252.767, 5231.296, -3.30232, 2.014, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Chicken (Terokkar Forest), next to critter 65596
(1000100158, 111172, 1220, 7541, 7652, '0', 0, 0, 0, -1, 0, 0, 3005.362, 1157.038, 150.874, 1.482, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Stormstruck Beaver (Stormheim), next to critter 20532751
(1000100159, 111172, 1220, 7541, 7789, '0', 0, 0, 0, -1, 0, 0, 2799.425, 753.299, 92.025, 2.451, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Stormstruck Beaver (Stormheim), next to critter 20530206
(1000100160, 111172, 1220, 7541, 8172, '0', 0, 0, 0, -1, 0, 0, 3175.56, 2095.132, 200.177, 1.845, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Stormstruck Beaver (Stormheim), next to critter 20527547
(1000100161, 143033, 1643, 9042, 9042, '0', 0, 0, 0, -1, 0, 0, 3487.68, 603.656, 93.9672, 2.733, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Freshwater Crawler (Stormsong Valley), next to critter 210326792
(1000100162, 143033, 1643, 9042, 9698, '0', 0, 0, 0, -1, 0, 0, 3820.125, 824.866, 136.094, 4.276, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Freshwater Crawler (Stormsong Valley), next to critter 210327001
(1000100163, 143033, 1643, 9042, 9581, '0', 0, 0, 0, -1, 0, 0, 3119.025, 836.856, 5.99412, 1.395, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Freshwater Crawler (Stormsong Valley), next to critter 210331025
(1000100164, 143054, 1642, 8500, 8500, '0', 0, 0, 0, -1, 0, 0, 2133.113, 1818.256, 9.77358, 1.049, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spectral Raven (Nazmir), next to critter 210419283
(1000100165, 143054, 1642, 8500, 8711, '0', 0, 0, 0, -1, 0, 0, 2057.528, -97.076, 8.61717, 6.226, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spectral Raven (Nazmir), next to critter 210424085
(1000100166, 143054, 1642, 8500, 9008, '0', 0, 0, 0, -1, 0, 0, 2095.605, 1464.655, 5.20616, 2.636, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spectral Raven (Nazmir), next to critter 210417527
(1000100167, 148517, 1642, 8499, 8923, '0', 0, 0, 0, -1, 0, 0, -674.347, 224.026, 210.236, 3.015, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Baby Zandalari Raptor (Zuldazar), next to critter 210404587
(1000100168, 148517, 1642, 8499, 9714, '0', 0, 0, 0, -1, 0, 0, -992.853, -988.61, 39.3346, 5.526, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Baby Zandalari Raptor (Zuldazar), next to critter 210412056
(1000100169, 148517, 1642, 8499, 9324, '0', 0, 0, 0, -1, 0, 0, -2533.134, -598.039, -39.2939, 2.383, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Baby Zandalari Raptor (Zuldazar), next to critter 210411706
(1000100170, 154702, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 877.206, -594.875, -285.512, 2.31, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sandclaw Sunshell (Nazjatar), next to critter 2103360743390298
(1000100171, 154702, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 877.011, -593.756, -285.614, 4.3, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sandclaw Sunshell (Nazjatar), next to critter 3100000000000387
(1000100172, 154702, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1848.317, 340.582, -346.632, 1.07, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Sandclaw Sunshell (Nazjatar), next to critter 3100000000000643
(1000100173, 154706, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1924.91, 487.679, -328.449, 2.424, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Chitterspine Skitterling (Nazjatar), next to critter 3100000000000780
(1000100174, 154706, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1934.246, 394.989, -350.832, 1.553, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Chitterspine Skitterling (Nazjatar), next to critter 3100000000000795
(1000100175, 154706, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1866.748, 427.503, -348.164, 4.521, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Chitterspine Skitterling (Nazjatar), next to critter 2103360743390644
(1000100176, 154708, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1845.818, 366.153, -347.429, 3.167, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hissing Chitterspine (Nazjatar), next to critter 2103360743390612
(1000100177, 154708, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1846.116, 366.583, -347.429, 4.845, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hissing Chitterspine (Nazjatar), next to critter 3100000000000704
(1000100178, 154708, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1899.084, 362.504, -352.446, 5.492, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Hissing Chitterspine (Nazjatar), next to critter 2103360743390607
(1000100179, 154712, 1718, 10052, 10052, '0', 0, 0, 0, -1, 0, 0, 980.352, -281.815, -257.422, 2.111, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Deeptide Fingerling (Nazjatar), next to critter 3520000000000527
(1000100180, 154712, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1886.299, 487.202, -331.085, 2.281, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Deeptide Fingerling (Nazjatar), next to critter 3100000000000774
(1000100181, 154712, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1055.969, -515.13, -279.99, 5.461, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Deeptide Fingerling (Nazjatar), next to critter 2103360743390027
(1000100182, 154714, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1847.844, 485.809, -334.659, 2.668, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Bloodseeker (Nazjatar), next to critter 3100000000000768
(1000100183, 154714, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1924.907, 487.684, -328.449, 5.757, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Bloodseeker (Nazjatar), next to critter 3100000000000780
(1000100184, 154714, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1525.163, 107.189, -387.833, 0.833, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Bloodseeker (Nazjatar), next to critter 2103360743390467
(1000100185, 154716, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1861.237, 415.916, -349.594, 0.096, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spireshell Snail (Nazjatar), next to critter 2103360743390643
(1000100186, 154716, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1559.361, 71.391, -393.482, 4.149, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spireshell Snail (Nazjatar), next to critter 3100000000000580
(1000100187, 154716, 1718, 10052, 10333, '0', 0, 0, 0, -1, 0, 0, 1844.784, 335.438, -347.108, 2.383, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Spireshell Snail (Nazjatar), next to critter 2103360743390545
(1000100188, 154767, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3137.755, 5028.402, 21.1597, 0.208, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustyroot Snooter (Mechagon), next to critter 3300000000000936
(1000100189, 154767, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2820.457, 4735.965, 17.8622, 0.083, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustyroot Snooter (Mechagon), next to critter 3300000000001283
(1000100190, 154767, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2763.605, 5162.657, 48.9231, 3.107, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustyroot Snooter (Mechagon), next to critter 3300000000001191
(1000100191, 154769, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2773.096, 4714.442, 10.3152, 0.149, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Duskytooth Snooter (Mechagon), next to critter 3300000000001254
(1000100192, 154769, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2785.458, 5383.034, 77.3464, 2.581, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Duskytooth Snooter (Mechagon), next to critter 3300000000001035
(1000100193, 154769, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2848.511, 5180.179, 34.9495, 1.17, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Duskytooth Snooter (Mechagon), next to critter 3300000000000973
(1000100194, 154773, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2803.63, 5155.366, 43.3906, 3.804, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Experimental Roach (Mechagon), next to critter 3300000000000987
(1000100195, 154773, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2922.991, 4973.918, 41.9713, 5.779, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Experimental Roach (Mechagon), next to critter 3300000000001293
(1000100196, 154773, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2820.151, 4737.314, 17.8622, 2.207, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Experimental Roach (Mechagon), next to critter 3300000000001283
(1000100197, 154775, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2773.062, 4715.272, 10.3152, 3.681, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fleeting Frog (Mechagon), next to critter 3300000000001254
(1000100198, 154775, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3039.229, 5023.514, 17.4607, 5.372, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fleeting Frog (Mechagon), next to critter 3300000000000954
(1000100199, 154775, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2742.467, 5033.364, -0.00877762, 1.67, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Fleeting Frog (Mechagon), next to critter 3300000000001228
(1000100200, 154777, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2746.818, 4714.43, 2.9007, 0.649, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Yellow Junkhopper (Mechagon), next to critter 3300000000001248
(1000100201, 154777, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2730.215, 4975.912, 0.951119, 4.757, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Yellow Junkhopper (Mechagon), next to critter 3300000000001227
(1000100202, 154777, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3099.853, 5508.161, 35.9416, 0.808, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Yellow Junkhopper (Mechagon), next to critter 3300000000001109
(1000100203, 154779, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2872.642, 5250.627, 40.9209, 1.187, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Motorized Croaker (Mechagon), next to critter 3300000000000989
(1000100204, 154779, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3175.036, 5025.865, 21.4123, 4.958, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Motorized Croaker (Mechagon), next to critter 3300000000000933
(1000100205, 154779, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3100.357, 5506.691, 35.9416, 0.494, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Motorized Croaker (Mechagon), next to critter 3300000000001109
(1000100206, 154783, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2998.069, 5010.814, 24.5032, 0.001, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustbolt Clucker (Mechagon), next to critter 3300000000000961
(1000100207, 154783, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2874.619, 5250.765, 40.9209, 6.09, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustbolt Clucker (Mechagon), next to critter 3300000000000989
(1000100208, 154783, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2746.663, 4713.319, 2.9007, 4.013, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Rustbolt Clucker (Mechagon), next to critter 3300000000001248
(1000100209, 154787, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2762.853, 5164.149, 48.9231, 3.71, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Specimen 97 (Mechagon), next to critter 3300000000001191
(1000100210, 154787, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2873.004, 5249.788, 40.9209, 3.431, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Specimen 97 (Mechagon), next to critter 3300000000000989
(1000100211, 154787, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 3186.405, 5300.565, 14.1705, 2.499, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Specimen 97 (Mechagon), next to critter 3300000000001147
(1000100212, 154791, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2773.883, 5158.249, 45.5341, 6.221, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scrapyard Tunneler (Mechagon), next to critter 3300000000001194
(1000100213, 154791, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2997.106, 5012.459, 24.5032, 6.01, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scrapyard Tunneler (Mechagon), next to critter 3300000000000961
(1000100214, 154791, 1643, 10290, 10418, '0', 0, 0, 0, -1, 0, 0, 2779.778, 5138.943, 43.3077, 0.6, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Scrapyard Tunneler (Mechagon), next to critter 3300000000001196
(1000100215, 154803, 0, 4922, 5143, '0', 0, 0, 0, -1, 0, 0, -2557.883, -5410.017, 163.891, 3.346, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Twilight Whelpling (Twilight Highlands), next to critter 10653387
(1000100216, 154803, 0, 4922, 5493, '0', 0, 0, 0, -1, 0, 0, -3919.599, -5357.779, 28.3209, 2.982, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Twilight Whelpling (Twilight Highlands), next to critter 10653469
(1000100217, 154803, 0, 4922, 5000, '0', 0, 0, 0, -1, 0, 0, -3856.61, -5020.925, 51.379, 4.491, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Twilight Whelpling (Twilight Highlands), next to critter 10653435
(1000100218, 162499, 1, 5034, 5670, '0', 0, 0, 0, -1, 0, 0, -8253.857, 703.467, -79.9375, 0.719, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Oasis Void-Duster (Uldum), next to critter 267578
(1000100219, 162499, 1, 5034, 5599, '0', 0, 0, 0, -1, 0, 0, -10780.099, -1385.633, 15.8534, 0.817, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Oasis Void-Duster (Uldum), next to critter 10653641
(1000100220, 162499, 1, 5034, 5034, '0', 0, 0, 0, -1, 0, 0, -9359.229, 782.625, 233.866, 5.267, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Oasis Void-Duster (Uldum), next to critter 10653622
(1000100221, 162502, 1, 5034, 5499, '0', 0, 0, 0, -1, 0, 0, -10073.614, -756.131, 51.5314, 1.501, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Void-Scarred Locust (Uldum), next to critter 290940
(1000100222, 162502, 1, 5034, 5420, '0', 0, 0, 0, -1, 0, 0, -9020.973, -1733.516, 94.9525, 6.015, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Void-Scarred Locust (Uldum), next to critter 10653648
(1000100223, 162502, 1, 5034, 5613, '0', 0, 0, 0, -1, 0, 0, -10078.049, -2413.701, 20.329, 6.068, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Void-Scarred Locust (Uldum), next to critter 10653593
(1000100224, 162518, 870, 5840, 6031, '0', 0, 0, 0, -1, 0, 0, 624.515, 1625.896, 378.1, 4.482, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidskimmer (Vale of Eternal Blossoms), next to critter 10654958
(1000100225, 162518, 870, 5840, 6554, '0', 0, 0, 0, -1, 0, 0, 1550.234, 940.835, 473.674, 1.567, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidskimmer (Vale of Eternal Blossoms), next to critter 10562254
(1000100226, 162518, 870, 5840, 6145, '0', 0, 0, 0, -1, 0, 0, 1160.54, 282.286, 435.511, 1.45, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidskimmer (Vale of Eternal Blossoms), next to critter 10654961
(1000100227, 162506, 870, 5840, 6554, '0', 0, 0, 0, -1, 0, 0, 1550.318, 941.179, 473.674, 0.957, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidglower (Vale of Eternal Blossoms), next to critter 10562254
(1000100228, 162506, 870, 5840, 6034, '0', 0, 0, 0, -1, 0, 0, 1135.498, 1386.563, 344.328, 3.697, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidglower (Vale of Eternal Blossoms), next to critter 10654959
(1000100229, 162506, 870, 5840, 6145, '0', 0, 0, 0, -1, 0, 0, 1191.303, 734.037, 364.015, 4.74, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Voidglower (Vale of Eternal Blossoms), next to critter 10655000
(1000100230, 162525, 870, 5840, 6145, '0', 0, 0, 0, -1, 0, 0, 1487.937, 652.368, 406.662, 1.718, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Golden Chirper (Vale of Eternal Blossoms), next to critter 10654960
(1000100231, 162525, 870, 5840, 6145, '0', 0, 0, 0, -1, 0, 0, 1161.839, 283.27, 435.511, 2.072, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0), -- Golden Chirper (Vale of Eternal Blossoms), next to critter 10654961
(1000100232, 162525, 870, 5840, 6554, '0', 0, 0, 0, -1, 0, 0, 1547.468, 939.834, 473.674, 6.038, 120, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', 0); -- Golden Chirper (Vale of Eternal Blossoms), next to critter 10562258

-- Conversion of critters into pets for the new rows (2026_11_01_50 logic, logged in zr_wild_battlepet_conversion).
CREATE TABLE IF NOT EXISTS `zr_wild_battlepet_conversion` (`guid` bigint unsigned NOT NULL, `old_id` int unsigned NOT NULL, `new_id` int unsigned NOT NULL, `old_modelid` int unsigned NOT NULL DEFAULT '0', `zone` int unsigned NOT NULL, PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DROP PROCEDURE IF EXISTS `zr_convert_wild_battlepets_card_zones`;
DELIMITER //
CREATE PROCEDURE `zr_convert_wild_battlepets_card_zones`()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_zone, v_pet, v_max, v_critter, v_have, v_need INT UNSIGNED;
  DECLARE cur CURSOR FOR
    SELECT n.`Zone`, n.`BattlePetEntry`, n.`Max`, n.`CreatureEntry`
      FROM zr_new_pool n
      JOIN creature_template t ON t.entry = n.`BattlePetEntry` AND t.type = 14
     WHERE n.`CreatureEntry` <> 0
     ORDER BY n.`Zone`, n.`BattlePetEntry`;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN cur;
  pool_loop: LOOP
    FETCH cur INTO v_zone, v_pet, v_max, v_critter;
    IF done THEN
      LEAVE pool_loop;
    END IF;
    SELECT COUNT(*) INTO v_have FROM creature
     WHERE id = v_pet AND (zoneId = v_zone OR areaId = v_zone);
    IF v_have < v_max THEN
      SET v_need = v_max - v_have;
      INSERT IGNORE INTO zr_wild_battlepet_conversion (guid, old_id, new_id, old_modelid, zone)
        SELECT guid, id, v_pet, modelid, v_zone FROM creature
         WHERE id = v_critter AND (zoneId = v_zone OR areaId = v_zone)
           AND NOT EXISTS (SELECT 1 FROM smart_scripts s WHERE s.source_type = 0 AND s.entryorguid = -CAST(creature.guid AS SIGNED))
         ORDER BY RAND() LIMIT v_need;
      UPDATE creature c JOIN zr_wild_battlepet_conversion b ON b.guid = c.guid
         SET c.id = b.new_id, c.modelid = 0
       WHERE b.zone = v_zone AND b.new_id = v_pet AND c.id = v_critter;
    END IF;
  END LOOP;
  CLOSE cur;
END//
DELIMITER ;
CALL zr_convert_wild_battlepets_card_zones();
DROP PROCEDURE `zr_convert_wild_battlepets_card_zones`;

SELECT CONCAT((SELECT COUNT(*) FROM `battlepet_wild_zone_pool` p JOIN `zr_new_pool` n ON n.`Zone` = p.`Zone` AND n.`Species` = p.`Species` AND n.`BattlePetEntry` = p.`BattlePetEntry`), ' new pool rows, ',
              (SELECT COUNT(*) FROM `creature` WHERE `guid` BETWEEN 1000100039 AND 1000100232), ' new spawns, ',
              (SELECT COUNT(*) FROM `creature` c JOIN `zr_new_pool` n ON c.`id` = n.`BattlePetEntry` AND (c.`zoneId` = n.`Zone` OR c.`areaId` = n.`Zone`)), ' pets now in those zones') AS zr_result;
DROP TABLE `zr_new_pool`;
