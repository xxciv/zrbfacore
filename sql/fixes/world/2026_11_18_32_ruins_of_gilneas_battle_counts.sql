-- World fixes: Ruins of Gilneas, the Forward Command battle down to the 8.3.7 numbers (2026-11-18)
-- Four (2026-11-18, screenshot at -1081, 1593 in phase 274): "this pile under me seems a little stacked/duplicated".
-- The battle set (phase 274, 2026_11_18_31) still had our dump's numbers: 110 Worgen Rushers 45375 where 8.3.7
-- has 46, 55 Worgen Rebels 45292 where 8.3.7 has 30. The first review (2026_11_17_35) skipped these because
-- 8.3.7 has them in a quest phase. With the fight starters (2026_11_17_46) every Rusher within 8 yards of a
-- Vanguard ran to it, so the extra Rushers piled up on single Vanguards.
-- Now 1:1 with 8.3.7 phase 274 (each 8.3.7 spawn keeps its nearest match within 12 yards, moved to the 8.3.7
-- spot with the 8.3.7 wander; the rest of ours removed; 8.3.7 spots with no match added):
--   Worgen Rusher 45375: 43 kept, 67 removed, 3 added (8.3.7: 46, all standing still)
--   Worgen Rebel 45292: 19 kept, 36 removed, 11 added (8.3.7: 30, wander 10)
--   Forsaken Vanguard 45280: 79 kept, 19 removed, 23 added (8.3.7: 102; the 35 at Tempest's Reach are not in phase 274 and stay)
-- Added guids 735401110-735401146.
-- Four (same day, second screenshot at -1040, 1555): undead stacked on top of others that can't be selected. Those are
-- Forsaken Blightspreaders 45374 (battle) and 51192 (overrun camp): not selectable, standing 2 yards up on top of the
-- Forsaken Catapults, where a catapult passenger would sit. 8.3.7 has no Blightspreaders and no catapult passengers,
-- so all 13 + 12 are removed. Catapults 45282 and Sharpshooters 45376 stand still, as in 8.3.7 (dump wander 3).
-- Safe to run twice.

-- 1. Our extras removed
DELETE FROM `creature_addon` WHERE `guid` IN (307614,307611,307577,307576,307564,307553,307545,307518,307448,307449,307450,307451,307452,307453,307454,307455,307456,307457,307458,307459,307498,307508,307511,307515,307516,307517,307519,307523,307524,307525,307526,307527,307528,307536,307537,307538,307551,307552,307556,307557,307558,307559,307560,307561,307563,307565,307566,307567,307568,307569,307570,307571,307572,307573,307574,307578,307582,307583,307584,307595,307596,307598,307601,307605,307613,307615,307616,307602,307550,307539,307603,307520,307514,307505,307502,307484,307195,307212,307230,307278,307280,307285,307297,307382,307386,307411,307412,307415,307479,307481,307485,307487,307488,307490,307494,307501,307547,307580,307586,307589,307590,307593,307599,307575,307480,307587,306591,306643,306883,307056,307097,307215,307286,307287,307288,307409,307416,307495,307548,307562,307581,307600);
DELETE FROM `creature` WHERE `guid` IN (307614,307611,307577,307576,307564,307553,307545,307518,307448,307449,307450,307451,307452,307453,307454,307455,307456,307457,307458,307459,307498,307508,307511,307515,307516,307517,307519,307523,307524,307525,307526,307527,307528,307536,307537,307538,307551,307552,307556,307557,307558,307559,307560,307561,307563,307565,307566,307567,307568,307569,307570,307571,307572,307573,307574,307578,307582,307583,307584,307595,307596,307598,307601,307605,307613,307615,307616,307602,307550,307539,307603,307520,307514,307505,307502,307484,307195,307212,307230,307278,307280,307285,307297,307382,307386,307411,307412,307415,307479,307481,307485,307487,307488,307490,307494,307501,307547,307580,307586,307589,307590,307593,307599,307575,307480,307587,306591,306643,306883,307056,307097,307215,307286,307287,307288,307409,307416,307495,307548,307562,307581,307600);

-- 1b. The floating, unselectable Blightspreaders on the catapults (both phases)
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM (SELECT `guid` FROM `creature` WHERE `id` IN (45374,51192)) t);
DELETE FROM `creature` WHERE `id` IN (45374,51192);

-- 1c. Catapults and Sharpshooters of the battle stand still (8.3.7)
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `id` IN (45282,45376) AND `PhaseId`=274;

-- 2. Kept spawns on the 8.3.7 spots, with the 8.3.7 wander
UPDATE `creature` SET `position_x`=-1304.81,`position_y`=1781.74,`position_z`=12.0263,`orientation`=5.63343,`MovementType`=0,`spawndist`=0 WHERE `guid`=307465;
UPDATE `creature` SET `position_x`=-1298.89,`position_y`=1784.43,`position_z`=12.0328,`orientation`=5.63574,`MovementType`=0,`spawndist`=0 WHERE `guid`=307466;
UPDATE `creature` SET `position_x`=-1309.7,`position_y`=1783.31,`position_z`=12.0205,`orientation`=5.69955,`MovementType`=0,`spawndist`=0 WHERE `guid`=307467;
UPDATE `creature` SET `position_x`=-1315.4,`position_y`=1785.59,`position_z`=12.0192,`orientation`=5.64319,`MovementType`=0,`spawndist`=0 WHERE `guid`=307468;
UPDATE `creature` SET `position_x`=-1311.53,`position_y`=1795.26,`position_z`=12.0192,`orientation`=5.5662,`MovementType`=0,`spawndist`=0 WHERE `guid`=307469;
UPDATE `creature` SET `position_x`=-1310.13,`position_y`=1799.57,`position_z`=12.0192,`orientation`=5.61271,`MovementType`=0,`spawndist`=0 WHERE `guid`=307470;
UPDATE `creature` SET `position_x`=-1300.16,`position_y`=1789.72,`position_z`=12.0218,`orientation`=5.53787,`MovementType`=0,`spawndist`=0 WHERE `guid`=307471;
UPDATE `creature` SET `position_x`=-1309.11,`position_y`=1775.47,`position_z`=12.024,`orientation`=5.75483,`MovementType`=0,`spawndist`=0 WHERE `guid`=307474;
UPDATE `creature` SET `position_x`=-1309.5,`position_y`=1789.19,`position_z`=12.0192,`orientation`=5.68028,`MovementType`=0,`spawndist`=0 WHERE `guid`=307475;
UPDATE `creature` SET `position_x`=-1304.8,`position_y`=1794.18,`position_z`=12.0192,`orientation`=5.62092,`MovementType`=0,`spawndist`=0 WHERE `guid`=307476;
UPDATE `creature` SET `position_x`=-1304.98,`position_y`=1787.66,`position_z`=12.0211,`orientation`=5.59394,`MovementType`=0,`spawndist`=0 WHERE `guid`=307477;
UPDATE `creature` SET `position_x`=-1316.41,`position_y`=1789.91,`position_z`=12.0192,`orientation`=5.66509,`MovementType`=0,`spawndist`=0 WHERE `guid`=307478;
UPDATE `creature` SET `position_x`=-1279.51,`position_y`=1774.46,`position_z`=12.8333,`orientation`=5.62094,`MovementType`=0,`spawndist`=0 WHERE `guid`=307534;
UPDATE `creature` SET `position_x`=-1291.99,`position_y`=1775.18,`position_z`=12.4109,`orientation`=5.60843,`MovementType`=0,`spawndist`=0 WHERE `guid`=307579;
UPDATE `creature` SET `position_x`=-1275.29,`position_y`=1763.67,`position_z`=13.6168,`orientation`=5.56619,`MovementType`=0,`spawndist`=0 WHERE `guid`=307555;
UPDATE `creature` SET `position_x`=-1278.25,`position_y`=1758.53,`position_z`=13.461,`orientation`=5.78111,`MovementType`=0,`spawndist`=0 WHERE `guid`=307460;
UPDATE `creature` SET `position_x`=-1296.28,`position_y`=1783.54,`position_z`=12.3168,`orientation`=5.62797,`MovementType`=0,`spawndist`=0 WHERE `guid`=307500;
UPDATE `creature` SET `position_x`=-1278.31,`position_y`=1763.77,`position_z`=13.3162,`orientation`=5.68733,`MovementType`=0,`spawndist`=0 WHERE `guid`=307464;
UPDATE `creature` SET `position_x`=-1281.44,`position_y`=1771.02,`position_z`=12.8138,`orientation`=5.66782,`MovementType`=0,`spawndist`=0 WHERE `guid`=307532;
UPDATE `creature` SET `position_x`=-1251.35,`position_y`=1744.85,`position_z`=16.766,`orientation`=5.42237,`MovementType`=0,`spawndist`=0 WHERE `guid`=307608;
UPDATE `creature` SET `position_x`=-1253.45,`position_y`=1749.96,`position_z`=16.478,`orientation`=5.819,`MovementType`=0,`spawndist`=0 WHERE `guid`=307463;
UPDATE `creature` SET `position_x`=-1272.39,`position_y`=1752.43,`position_z`=14.25,`orientation`=5.57239,`MovementType`=0,`spawndist`=0 WHERE `guid`=307554;
UPDATE `creature` SET `position_x`=-1286.81,`position_y`=1765.04,`position_z`=12.5951,`orientation`=5.65998,`MovementType`=0,`spawndist`=0 WHERE `guid`=307535;
UPDATE `creature` SET `position_x`=-1264.67,`position_y`=1755.55,`position_z`=15.0443,`orientation`=5.58219,`MovementType`=0,`spawndist`=0 WHERE `guid`=307609;
UPDATE `creature` SET `position_x`=-1282.94,`position_y`=1777.16,`position_z`=12.5352,`orientation`=5.59394,`MovementType`=0,`spawndist`=0 WHERE `guid`=307507;
UPDATE `creature` SET `position_x`=-1276.61,`position_y`=1768.13,`position_z`=13.3377,`orientation`=5.53716,`MovementType`=0,`spawndist`=0 WHERE `guid`=307461;
UPDATE `creature` SET `position_x`=-1283.05,`position_y`=1768.99,`position_z`=12.7522,`orientation`=5.57795,`MovementType`=0,`spawndist`=0 WHERE `guid`=307541;
UPDATE `creature` SET `position_x`=-1258.18,`position_y`=1752.33,`position_z`=15.828,`orientation`=5.75224,`MovementType`=0,`spawndist`=0 WHERE `guid`=307531;
UPDATE `creature` SET `position_x`=-1271.57,`position_y`=1762.29,`position_z`=14.1063,`orientation`=5.60219,`MovementType`=0,`spawndist`=0 WHERE `guid`=307496;
UPDATE `creature` SET `position_x`=-1273.87,`position_y`=1757.68,`position_z`=13.808,`orientation`=5.3996,`MovementType`=0,`spawndist`=0 WHERE `guid`=307499;
UPDATE `creature` SET `position_x`=-1279.6,`position_y`=1761.86,`position_z`=13.1223,`orientation`=5.61546,`MovementType`=0,`spawndist`=0 WHERE `guid`=307543;
UPDATE `creature` SET `position_x`=-1272.72,`position_y`=1767.65,`position_z`=13.839,`orientation`=5.6057,`MovementType`=0,`spawndist`=0 WHERE `guid`=307492;
UPDATE `creature` SET `position_x`=-1267.0,`position_y`=1755.19,`position_z`=14.6888,`orientation`=5.60845,`MovementType`=0,`spawndist`=0 WHERE `guid`=307606;
UPDATE `creature` SET `position_x`=-1280.68,`position_y`=1763.36,`position_z`=13.0469,`orientation`=5.6811,`MovementType`=0,`spawndist`=0 WHERE `guid`=307509;
UPDATE `creature` SET `position_x`=-1287.27,`position_y`=1770.07,`position_z`=12.5219,`orientation`=5.68543,`MovementType`=0,`spawndist`=0 WHERE `guid`=307533;
UPDATE `creature` SET `position_x`=-1259.42,`position_y`=1746.46,`position_z`=15.7615,`orientation`=5.75483,`MovementType`=0,`spawndist`=0 WHERE `guid`=307510;
UPDATE `creature` SET `position_x`=-1281.99,`position_y`=1767.18,`position_z`=12.8904,`orientation`=5.60845,`MovementType`=0,`spawndist`=0 WHERE `guid`=307462;
UPDATE `creature` SET `position_x`=-1283.24,`position_y`=1764.83,`position_z`=12.8374,`orientation`=5.71009,`MovementType`=0,`spawndist`=0 WHERE `guid`=307530;
UPDATE `creature` SET `position_x`=-1270.8,`position_y`=1748.18,`position_z`=14.703,`orientation`=5.66271,`MovementType`=0,`spawndist`=0 WHERE `guid`=307544;
UPDATE `creature` SET `position_x`=-1255.8,`position_y`=1743.54,`position_z`=16.3137,`orientation`=5.6475,`MovementType`=0,`spawndist`=0 WHERE `guid`=307610;
UPDATE `creature` SET `position_x`=-1287.71,`position_y`=1769.51,`position_z`=12.535,`orientation`=5.66509,`MovementType`=0,`spawndist`=0 WHERE `guid`=307529;
UPDATE `creature` SET `position_x`=-1258.28,`position_y`=1744.53,`position_z`=15.9795,`orientation`=5.65999,`MovementType`=0,`spawndist`=0 WHERE `guid`=307607;
UPDATE `creature` SET `position_x`=-1278.06,`position_y`=1761.56,`position_z`=13.322,`orientation`=5.6811,`MovementType`=0,`spawndist`=0 WHERE `guid`=307540;
UPDATE `creature` SET `position_x`=-1111.53,`position_y`=1699.13,`position_z`=45.3716,`orientation`=5.5477,`MovementType`=1,`spawndist`=10 WHERE `guid`=307489;
UPDATE `creature` SET `position_x`=-944.598,`position_y`=1694.52,`position_z`=64.8604,`orientation`=4.90686,`MovementType`=1,`spawndist`=10 WHERE `guid`=307592;
UPDATE `creature` SET `position_x`=-1023.9,`position_y`=1714.32,`position_z`=59.6207,`orientation`=4.91486,`MovementType`=1,`spawndist`=10 WHERE `guid`=307279;
UPDATE `creature` SET `position_x`=-1068.16,`position_y`=1714.3,`position_z`=45.8788,`orientation`=5.73372,`MovementType`=1,`spawndist`=10 WHERE `guid`=307299;
UPDATE `creature` SET `position_x`=-927.413,`position_y`=1816.75,`position_z`=59.156,`orientation`=0.522147,`MovementType`=1,`spawndist`=10 WHERE `guid`=307542;
UPDATE `creature` SET `position_x`=-988.343,`position_y`=1753.93,`position_z`=58.3651,`orientation`=6.1911,`MovementType`=1,`spawndist`=10 WHERE `guid`=307291;
UPDATE `creature` SET `position_x`=-943.725,`position_y`=1749.9,`position_z`=62.3167,`orientation`=4.9386,`MovementType`=1,`spawndist`=10 WHERE `guid`=307482;
UPDATE `creature` SET `position_x`=-1071.39,`position_y`=1805.82,`position_z`=45.2248,`orientation`=3.87463,`MovementType`=1,`spawndist`=10 WHERE `guid`=307281;
UPDATE `creature` SET `position_x`=-1013.96,`position_y`=1800.39,`position_z`=50.8692,`orientation`=1.55322,`MovementType`=1,`spawndist`=10 WHERE `guid`=307493;
UPDATE `creature` SET `position_x`=-773.722,`position_y`=1764.29,`position_z`=66.2609,`orientation`=3.46384,`MovementType`=1,`spawndist`=10 WHERE `guid`=307546;
UPDATE `creature` SET `position_x`=-813.61,`position_y`=1675.91,`position_z`=67.6546,`orientation`=4.04545,`MovementType`=1,`spawndist`=10 WHERE `guid`=307213;
UPDATE `creature` SET `position_x`=-989.012,`position_y`=1695.07,`position_z`=62.193,`orientation`=5.98234,`MovementType`=1,`spawndist`=10 WHERE `guid`=307194;
UPDATE `creature` SET `position_x`=-910.417,`position_y`=1775.74,`position_z`=62.8608,`orientation`=1.79472,`MovementType`=1,`spawndist`=10 WHERE `guid`=307410;
UPDATE `creature` SET `position_x`=-822.712,`position_y`=1788.38,`position_z`=67.8878,`orientation`=4.75881,`MovementType`=1,`spawndist`=10 WHERE `guid`=307214;
UPDATE `creature` SET `position_x`=-830.071,`position_y`=1708.83,`position_z`=67.9356,`orientation`=4.62127,`MovementType`=1,`spawndist`=10 WHERE `guid`=307294;
UPDATE `creature` SET `position_x`=-959.217,`position_y`=1803.54,`position_z`=58.2124,`orientation`=1.342,`MovementType`=1,`spawndist`=10 WHERE `guid`=307486;
UPDATE `creature` SET `position_x`=-871.676,`position_y`=1809.24,`position_z`=62.7299,`orientation`=4.0482,`MovementType`=1,`spawndist`=10 WHERE `guid`=307504;
UPDATE `creature` SET `position_x`=-1099.53,`position_y`=1767.39,`position_z`=44.1969,`orientation`=4.70025,`MovementType`=1,`spawndist`=10 WHERE `guid`=307383;
UPDATE `creature` SET `position_x`=-1040.17,`position_y`=1725.96,`position_z`=52.8715,`orientation`=3.51286,`MovementType`=1,`spawndist`=10 WHERE `guid`=307491;
UPDATE `creature` SET `position_x`=-1236.67,`position_y`=1587.73,`position_z`=23.718,`orientation`=2.58309,`MovementType`=0,`spawndist`=0 WHERE `guid`=306550;
UPDATE `creature` SET `position_x`=-1025.42,`position_y`=1403.61,`position_z`=49.035,`orientation`=5.74213,`MovementType`=0,`spawndist`=0 WHERE `guid`=306553;
UPDATE `creature` SET `position_x`=-1041.93,`position_y`=1429.93,`position_z`=46.5251,`orientation`=1.09956,`MovementType`=0,`spawndist`=0 WHERE `guid`=306555;
UPDATE `creature` SET `position_x`=-828.203,`position_y`=1539.45,`position_z`=28.0939,`orientation`=2.16421,`MovementType`=0,`spawndist`=0 WHERE `guid`=306608;
UPDATE `creature` SET `position_x`=-826.087,`position_y`=1570.99,`position_z`=28.1003,`orientation`=3.75246,`MovementType`=0,`spawndist`=0 WHERE `guid`=306609;
UPDATE `creature` SET `position_x`=-999.694,`position_y`=2004.16,`position_z`=23.4054,`orientation`=5.8294,`MovementType`=0,`spawndist`=0 WHERE `guid`=306612;
UPDATE `creature` SET `position_x`=-996.495,`position_y`=1995.07,`position_z`=24.2772,`orientation`=0.715585,`MovementType`=0,`spawndist`=0 WHERE `guid`=306613;
UPDATE `creature` SET `position_x`=-995.219,`position_y`=2005.19,`position_z`=23.5964,`orientation`=5.32325,`MovementType`=0,`spawndist`=0 WHERE `guid`=306614;
UPDATE `creature` SET `position_x`=-991.477,`position_y`=2006.4,`position_z`=23.7353,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=306615;
UPDATE `creature` SET `position_x`=-987.618,`position_y`=1997.86,`position_z`=24.5156,`orientation`=2.63545,`MovementType`=0,`spawndist`=0 WHERE `guid`=306616;
UPDATE `creature` SET `position_x`=-1233.58,`position_y`=1781.11,`position_z`=19.9241,`orientation`=2.98451,`MovementType`=0,`spawndist`=0 WHERE `guid`=306620;
UPDATE `creature` SET `position_x`=-1236.53,`position_y`=1794.56,`position_z`=20.4085,`orientation`=4.5204,`MovementType`=0,`spawndist`=0 WHERE `guid`=306622;
UPDATE `creature` SET `position_x`=-1224.85,`position_y`=1785.77,`position_z`=20.2274,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306623;
UPDATE `creature` SET `position_x`=-1240.12,`position_y`=1771.57,`position_z`=19.3401,`orientation`=1.64061,`MovementType`=0,`spawndist`=0 WHERE `guid`=306624;
UPDATE `creature` SET `position_x`=-1248.39,`position_y`=1780.56,`position_z`=19.1748,`orientation`=5.63741,`MovementType`=0,`spawndist`=0 WHERE `guid`=306626;
UPDATE `creature` SET `position_x`=-1269.37,`position_y`=1373.25,`position_z`=26.5412,`orientation`=0.174533,`MovementType`=0,`spawndist`=0 WHERE `guid`=306628;
UPDATE `creature` SET `position_x`=-1263.19,`position_y`=1366.16,`position_z`=26.4928,`orientation`=2.3911,`MovementType`=0,`spawndist`=0 WHERE `guid`=306629;
UPDATE `creature` SET `position_x`=-1265.8,`position_y`=1382.77,`position_z`=26.6133,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306630;
UPDATE `creature` SET `position_x`=-1276.43,`position_y`=1395.26,`position_z`=26.3941,`orientation`=1.44862,`MovementType`=0,`spawndist`=0 WHERE `guid`=306631;
UPDATE `creature` SET `position_x`=-1269.68,`position_y`=1412.26,`position_z`=26.5014,`orientation`=5.2709,`MovementType`=0,`spawndist`=0 WHERE `guid`=306632;
UPDATE `creature` SET `position_x`=-1217.94,`position_y`=1120.4,`position_z`=34.4082,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306645;
UPDATE `creature` SET `position_x`=-1128.86,`position_y`=1169.34,`position_z`=24.2076,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306646;
UPDATE `creature` SET `position_x`=-1143.86,`position_y`=1133.97,`position_z`=24.3659,`orientation`=4.79965,`MovementType`=0,`spawndist`=0 WHERE `guid`=306647;
UPDATE `creature` SET `position_x`=-1137.83,`position_y`=1144.65,`position_z`=24.3659,`orientation`=3.42085,`MovementType`=0,`spawndist`=0 WHERE `guid`=306650;
UPDATE `creature` SET `position_x`=-1053.96,`position_y`=1408.4,`position_z`=41.1062,`orientation`=3.9968,`MovementType`=0,`spawndist`=0 WHERE `guid`=306670;
UPDATE `creature` SET `position_x`=-981.439,`position_y`=1466.25,`position_z`=47.6124,`orientation`=0.977384,`MovementType`=0,`spawndist`=0 WHERE `guid`=306671;
UPDATE `creature` SET `position_x`=-1000.35,`position_y`=1464.8,`position_z`=44.6656,`orientation`=4.15388,`MovementType`=0,`spawndist`=0 WHERE `guid`=306673;
UPDATE `creature` SET `position_x`=-1256.95,`position_y`=1535.62,`position_z`=20.617,`orientation`=1.95477,`MovementType`=0,`spawndist`=0 WHERE `guid`=306674;
UPDATE `creature` SET `position_x`=-1263.76,`position_y`=1503.59,`position_z`=20.4991,`orientation`=3.66519,`MovementType`=0,`spawndist`=0 WHERE `guid`=306675;
UPDATE `creature` SET `position_x`=-1217.84,`position_y`=1590.62,`position_z`=25.0943,`orientation`=0.837758,`MovementType`=0,`spawndist`=0 WHERE `guid`=306676;
UPDATE `creature` SET `position_x`=-1223.28,`position_y`=1814.33,`position_z`=20.4314,`orientation`=2.25148,`MovementType`=0,`spawndist`=0 WHERE `guid`=306732;
UPDATE `creature` SET `position_x`=-1227.05,`position_y`=1754.36,`position_z`=19.4039,`orientation`=1.48353,`MovementType`=0,`spawndist`=0 WHERE `guid`=306733;
UPDATE `creature` SET `position_x`=-1174.34,`position_y`=1146.94,`position_z`=24.3659,`orientation`=1.98968,`MovementType`=0,`spawndist`=0 WHERE `guid`=306736;
UPDATE `creature` SET `position_x`=-1224.38,`position_y`=1136.88,`position_z`=33.5116,`orientation`=3.68265,`MovementType`=0,`spawndist`=0 WHERE `guid`=306741;
UPDATE `creature` SET `position_x`=-842.83,`position_y`=1544.46,`position_z`=28.0953,`orientation`=1.36136,`MovementType`=0,`spawndist`=0 WHERE `guid`=306799;
UPDATE `creature` SET `position_x`=-955.786,`position_y`=1555.74,`position_z`=35.9367,`orientation`=1.36136,`MovementType`=0,`spawndist`=0 WHERE `guid`=306879;
UPDATE `creature` SET `position_x`=-855.167,`position_y`=1571.18,`position_z`=28.7583,`orientation`=4.50295,`MovementType`=0,`spawndist`=0 WHERE `guid`=306880;
UPDATE `creature` SET `position_x`=-1126.72,`position_y`=1112.71,`position_z`=24.6587,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306886;
UPDATE `creature` SET `position_x`=-1139.95,`position_y`=1111.76,`position_z`=24.3659,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306888;
UPDATE `creature` SET `position_x`=-1157.25,`position_y`=1130.78,`position_z`=24.3659,`orientation`=0.0,`MovementType`=0,`spawndist`=0 WHERE `guid`=306892;
UPDATE `creature` SET `position_x`=-1142.36,`position_y`=1157.01,`position_z`=24.3659,`orientation`=2.49582,`MovementType`=0,`spawndist`=0 WHERE `guid`=306894;
UPDATE `creature` SET `position_x`=-975.005,`position_y`=1502.24,`position_z`=47.8047,`orientation`=0.942478,`MovementType`=0,`spawndist`=0 WHERE `guid`=306946;
UPDATE `creature` SET `position_x`=-1169.44,`position_y`=1158.02,`position_z`=24.3659,`orientation`=5.89921,`MovementType`=0,`spawndist`=0 WHERE `guid`=306954;
UPDATE `creature` SET `position_x`=-1157.08,`position_y`=1164.59,`position_z`=24.3659,`orientation`=4.2586,`MovementType`=0,`spawndist`=0 WHERE `guid`=306955;
UPDATE `creature` SET `position_x`=-882.219,`position_y`=1721.33,`position_z`=65.8394,`orientation`=0.645772,`MovementType`=0,`spawndist`=0 WHERE `guid`=307038;
UPDATE `creature` SET `position_x`=-811.434,`position_y`=1554.61,`position_z`=28.0939,`orientation`=3.36848,`MovementType`=0,`spawndist`=0 WHERE `guid`=307042;
UPDATE `creature` SET `position_x`=-899.896,`position_y`=1730.19,`position_z`=65.7682,`orientation`=1.8326,`MovementType`=0,`spawndist`=0 WHERE `guid`=307044;
UPDATE `creature` SET `position_x`=-1021.52,`position_y`=1643.23,`position_z`=52.8786,`orientation`=1.51844,`MovementType`=0,`spawndist`=0 WHERE `guid`=307184;
UPDATE `creature` SET `position_x`=-969.833,`position_y`=1557.82,`position_z`=35.938,`orientation`=1.36136,`MovementType`=0,`spawndist`=0 WHERE `guid`=307282;
UPDATE `creature` SET `position_x`=-1002.65,`position_y`=1572.38,`position_z`=34.514,`orientation`=2.42601,`MovementType`=0,`spawndist`=0 WHERE `guid`=307283;
UPDATE `creature` SET `position_x`=-978.503,`position_y`=1519.11,`position_z`=47.3653,`orientation`=5.5676,`MovementType`=0,`spawndist`=0 WHERE `guid`=307284;
UPDATE `creature` SET `position_x`=-1041.23,`position_y`=1648.6,`position_z`=52.7423,`orientation`=0.663225,`MovementType`=0,`spawndist`=0 WHERE `guid`=307289;
UPDATE `creature` SET `position_x`=-996.911,`position_y`=1585.94,`position_z`=35.0722,`orientation`=2.86234,`MovementType`=0,`spawndist`=0 WHERE `guid`=307296;
UPDATE `creature` SET `position_x`=-1099.17,`position_y`=1616.6,`position_z`=33.167,`orientation`=2.82743,`MovementType`=0,`spawndist`=0 WHERE `guid`=307323;
UPDATE `creature` SET `position_x`=-1087.88,`position_y`=1642.66,`position_z`=34.0295,`orientation`=2.98451,`MovementType`=0,`spawndist`=0 WHERE `guid`=307324;
UPDATE `creature` SET `position_x`=-1087.57,`position_y`=1634.73,`position_z`=33.861,`orientation`=2.77507,`MovementType`=0,`spawndist`=0 WHERE `guid`=307387;
UPDATE `creature` SET `position_x`=-917.13,`position_y`=1815.37,`position_z`=62.8906,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=307483;
UPDATE `creature` SET `position_x`=-783.167,`position_y`=1758.67,`position_z`=65.809,`orientation`=2.21657,`MovementType`=1,`spawndist`=10 WHERE `guid`=307506;
UPDATE `creature` SET `position_x`=-1013.64,`position_y`=1809.64,`position_z`=51.6758,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=307521;
UPDATE `creature` SET `position_x`=-811.382,`position_y`=1549.16,`position_z`=28.0939,`orientation`=2.89725,`MovementType`=0,`spawndist`=0 WHERE `guid`=307039;
UPDATE `creature` SET `position_x`=-811.564,`position_y`=1546.47,`position_z`=28.0939,`orientation`=2.68781,`MovementType`=0,`spawndist`=0 WHERE `guid`=307040;
UPDATE `creature` SET `position_x`=-811.701,`position_y`=1551.88,`position_z`=28.0941,`orientation`=3.19074,`MovementType`=0,`spawndist`=0 WHERE `guid`=307041;
UPDATE `creature` SET `position_x`=-943.89,`position_y`=1690.93,`position_z`=64.3893,`orientation`=4.34384,`MovementType`=0,`spawndist`=0 WHERE `guid`=306790;
UPDATE `creature` SET `position_x`=-1023.16,`position_y`=1710.74,`position_z`=59.8545,`orientation`=5.60107,`MovementType`=0,`spawndist`=0 WHERE `guid`=306863;
UPDATE `creature` SET `position_x`=-874.477,`position_y`=1798.75,`position_z`=63.2066,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=307549;
UPDATE `creature` SET `position_x`=-862.542,`position_y`=1688.48,`position_z`=68.8546,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=306704;
UPDATE `creature` SET `position_x`=-1108.82,`position_y`=1696.67,`position_z`=45.5243,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=307207;
UPDATE `creature` SET `position_x`=-941.527,`position_y`=1746.22,`position_z`=62.29,`orientation`=2.24935,`MovementType`=0,`spawndist`=0 WHERE `guid`=307098;
UPDATE `creature` SET `position_x`=-1065.04,`position_y`=1712.38,`position_z`=45.904,`orientation`=6.04397,`MovementType`=0,`spawndist`=0 WHERE `guid`=307060;
UPDATE `creature` SET `position_x`=-815.878,`position_y`=1673.03,`position_z`=67.5723,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=306703;
UPDATE `creature` SET `position_x`=-830.354,`position_y`=1702.36,`position_z`=67.3133,`orientation`=2.20649,`MovementType`=0,`spawndist`=0 WHERE `guid`=307043;
UPDATE `creature` SET `position_x`=-857.244,`position_y`=1757.45,`position_z`=66.564,`orientation`=0.764962,`MovementType`=0,`spawndist`=0 WHERE `guid`=306926;
UPDATE `creature` SET `position_x`=-985.511,`position_y`=1693.98,`position_z`=62.1198,`orientation`=4.52915,`MovementType`=0,`spawndist`=0 WHERE `guid`=306702;
UPDATE `creature` SET `position_x`=-1105.29,`position_y`=1714.1,`position_z`=45.1992,`orientation`=1.63615,`MovementType`=0,`spawndist`=0 WHERE `guid`=307099;
UPDATE `creature` SET `position_x`=-1042.83,`position_y`=1723.69,`position_z`=51.7121,`orientation`=2.01916,`MovementType`=0,`spawndist`=0 WHERE `guid`=307095;
UPDATE `creature` SET `position_x`=-837.033,`position_y`=1688.06,`position_z`=67.3864,`orientation`=2.21657,`MovementType`=0,`spawndist`=0 WHERE `guid`=307037;
UPDATE `creature` SET `position_x`=-1210.71,`position_y`=1788.67,`position_z`=20.3043,`orientation`=0.398096,`MovementType`=0,`spawndist`=0 WHERE `guid`=306701;
UPDATE `creature` SET `position_x`=-954.677,`position_y`=1797.63,`position_z`=59.45,`orientation`=2.16935,`MovementType`=0,`spawndist`=0 WHERE `guid`=307604;
UPDATE `creature` SET `position_x`=-977.604,`position_y`=1725.52,`position_z`=59.9262,`orientation`=0.0092882,`MovementType`=0,`spawndist`=0 WHERE `guid`=307205;

-- 3. 8.3.7 spots we had no spawn for
DELETE FROM `creature` WHERE `guid` BETWEEN 735401110 AND 735401146;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`dynamicflags`,`ScriptName`,`VerifiedBuild`) VALUES
(735401110,45375,0,4706,5440,'0',0,274,0,-1,0,0,-1265.17,1748.82,15.015,5.66192,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher
(735401111,45375,0,4706,5440,'0',0,274,0,-1,0,0,-1277.47,1753.69,13.8982,5.68029,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher
(735401112,45375,0,4706,5440,'0',0,274,0,-1,0,0,-1263.8,1745.49,15.3635,5.6987,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Worgen Rusher
(735401113,45292,0,4706,5434,'0',0,274,0,-1,0,0,-859.695,1690.79,68.8196,3.82339,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401114,45292,0,4706,5440,'0',0,274,0,-1,0,0,-815.472,1736.0,69.6318,3.62978,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401115,45292,0,4706,5440,'0',0,274,0,-1,0,0,-848.787,1729.33,70.3072,2.28378,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401116,45292,0,4706,5440,'0',0,274,0,-1,0,0,-955.444,1722.72,62.3663,4.20868,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401117,45292,0,4706,5443,'0',0,274,0,-1,0,0,-1171.47,1758.85,38.067,0.403694,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401118,45292,0,4706,5443,'0',0,274,0,-1,0,0,-1211.72,1789.32,20.3043,6.27742,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401119,45292,0,4706,5440,'0',0,274,0,-1,0,0,-853.691,1761.55,66.7838,3.95579,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401120,45292,0,4706,5440,'0',0,274,0,-1,0,0,-1009.18,1730.26,60.507,5.40747,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401121,45292,0,4706,5434,'0',0,274,0,-1,0,0,-772.481,1691.69,69.8368,5.28886,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401122,45292,0,4706,5440,'0',0,274,0,-1,0,0,-814.757,1706.89,68.278,4.44849,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401123,45292,0,4706,5440,'0',0,274,0,-1,0,0,-1105.3,1722.95,45.586,4.68411,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Worgen Rebel
(735401124,45280,0,4706,5440,'0',0,274,0,-1,0,0,-895.312,1711.98,65.6432,5.21682,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401125,45280,0,4706,5440,'0',0,274,0,-1,0,0,-850.397,1728.29,70.0969,6.19249,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401126,45280,0,4706,5434,'0',0,274,0,-1,0,0,-857.848,1709.62,69.251,2.28366,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401127,45280,0,4706,5434,'0',0,274,0,-1,0,0,-771.354,1686.98,69.4987,2.05627,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401128,45280,0,4706,5434,'0',0,274,0,-1,0,0,-966.241,1523.7,47.1503,3.20595,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401129,45280,0,4706,5434,'0',0,274,0,-1,0,0,-1008.05,1652.11,53.0302,5.07127,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401130,45280,0,4706,5440,'0',0,274,0,-1,0,0,-973.048,1726.47,59.9729,2.79265,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401131,45280,0,4706,5440,'0',0,274,0,-1,0,0,-957.214,1719.51,62.3299,4.81282,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401132,45280,0,4706,5440,'0',0,274,0,-1,0,0,-1006.39,1726.68,61.2043,2.21657,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401133,45280,0,4706,5440,'0',0,274,0,-1,0,0,-986.016,1753.69,58.1412,3.06287,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401134,45280,0,4706,5440,'0',0,274,0,-1,0,0,-1072.85,1805.31,45.0786,5.36568,300,10,0,1,0,1,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401135,45280,0,4706,5443,'0',0,274,0,-1,0,0,-1166.5,1761.11,37.588,3.44004,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401136,45280,0,4706,5433,'0',0,274,0,-1,0,0,-814.097,1551.76,28.0997,3.19074,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401137,45280,0,4706,5441,'0',0,274,0,-1,0,0,-1253.01,1127.59,36.2379,0.0,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401138,45280,0,4706,5441,'0',0,274,0,-1,0,0,-1233.5,1121.75,35.637,2.46091,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401139,45280,0,4706,5433,'0',0,274,0,-1,0,0,-814.658,1546.18,28.1307,3.23629,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401140,45280,0,4706,5433,'0',0,274,0,-1,0,0,-814.662,1554.52,28.1307,3.16983,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401141,45280,0,4706,5440,'0',0,274,0,-1,0,0,-816.181,1700.15,67.3571,4.22465,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401142,45280,0,4706,5433,'0',0,274,0,-1,0,0,-814.555,1548.94,28.1307,3.21108,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401143,45280,0,4706,5440,'0',0,274,0,-1,0,0,-816.424,1732.36,69.873,1.21657,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401144,45280,0,4706,5440,'0',0,274,0,-1,0,0,-823.328,1782.69,68.297,1.46003,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401145,45280,0,4706,5440,'0',0,274,0,-1,0,0,-907.489,1769.8,63.054,1.9941,300,0,0,1,0,0,0,0,0,0,0,'',0), -- Forsaken Vanguard
(735401146,45280,0,4706,5440,'0',0,274,0,-1,0,0,-1097.5,1758.13,44.696,1.78049,300,0,0,1,0,0,0,0,0,0,0,'',0); -- Forsaken Vanguard
