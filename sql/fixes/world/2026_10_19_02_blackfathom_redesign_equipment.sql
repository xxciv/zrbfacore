-- Blackfathom Deeps (redesign): the Twilight's Hammer, the murlocs and the bosses held no weapons.
-- Their spawns (2026_10_17_03) name equipment set 1 (Thruk also set 2), but the sets were never added:
-- TrinityCore's sniff for the redesign only had the two entrance Sentinels'. These rows are TrinityCore's
-- (sql/old/9.x/world/22012_2022_03_06/2022_02_16_09_world_910.sql, sniffed on build 40120), for every
-- creature the redesign spawns. The highest item id is 106945 (Warlords of Draenor), so all predate 8.3.7.
DELETE FROM `creature_equip_template` WHERE `CreatureID` IN (74351, 74353, 74363, 74380, 74382, 74408, 74409, 74476, 74505, 74518, 74565, 74720, 74721, 74980, 74983, 74984, 74988, 74989, 75011, 75012, 75058, 75285, 75286, 75640, 75641, 75642, 75643, 76036, 76037, 76038, 76039, 77232);
INSERT INTO `creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`) VALUES
(74351, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Disciple
(74353, 1, 50998, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Aquamancer
(74363, 1, 2018, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Shadow
(74380, 1, 2176, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Storm Mender
(74382, 1, 3227, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Shadowmage
(74408, 1, 36606, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Je'neu Sancrea
(74409, 1, 52962, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Zeya
(74476, 1, 78477, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Domina
(74505, 1, 36684, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Thruk
(74505, 2, 106945, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Thruk
(74518, 1, 55411, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Executioner Gore
(74565, 1, 29355, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Subjugator Kor'ul
(74720, 1, 52962, 0, 0, 52962, 0, 0, 0, 0, 0, 40120), -- Blindlight Murloc
(74721, 1, 36606, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Blindlight Bilefin
(74980, 1, 2176, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Storm Mender
(74983, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Disciple
(74984, 1, 52962, 0, 0, 52962, 0, 0, 0, 0, 0, 40120), -- Blindlight Murloc
(74988, 1, 55411, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Executioner Gore
(74989, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Disciple
(75011, 1, 2176, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Storm Mender
(75012, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Disciple
(75058, 1, 50998, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Aquamancer
(75285, 1, 2176, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Storm Mender
(75286, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Disciple
(75640, 1, 52962, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Blindlight Murloc
(75641, 1, 36606, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Blindlight Bilefin
(75642, 1, 36606, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Blindlight Bilefin
(75643, 1, 52962, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Blindlight Murloc
(76036, 1, 2018, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Shadow
(76037, 1, 2176, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Storm Mender
(76038, 1, 3227, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Shadowmage
(76039, 1, 50998, 0, 0, 0, 0, 0, 0, 0, 0, 40120), -- Twilight Aquamancer
(77232, 1, 55959, 0, 0, 0, 0, 0, 0, 0, 0, 40120); -- Twilight Disciple
