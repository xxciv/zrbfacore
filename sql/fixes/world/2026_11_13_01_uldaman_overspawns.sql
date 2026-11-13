-- Uldaman (map 70), 2026-11-13: overspawned trogg packs.
--
-- Found (Four, screenshot): in the first hall a dozen troggs and scorpids stand on top of each other
-- around (-274, 140, -47.4): 4 Stonevault Pillagers 24830, 3 Stonevault Oracles 4852, 2 Stonevault
-- Ambushers 7175 and 3 Venomlash Scorpids 7022 within 6 yards (two scorpids inside an Ambusher).
-- AzerothCore has 2 troggs on that spot. The same 12 are in the Pandaria 5.4.8 database, so this is
-- a sniff stack, not a pack. A second stack of 5 Stonevault Brawlers 4855 at (50, 332, -43) has 1-2
-- in AzerothCore.
-- Kept: Pillagers 320968 and 321010, Oracle 321012 (wanders), Venomlash Scorpid 320832, and three
-- Brawlers (320860, 320863, 320864). None of the removed spawns has addon, formation, pool or SAI rows.

DELETE FROM `creature` WHERE `map` = 70 AND `guid` IN (
    320803, 320967,         -- Stonevault Pillager 24830
    320804, 320966,         -- Stonevault Oracle 4852
    321070, 321072,         -- Stonevault Ambusher 7175
    320828, 320829,         -- Venomlash Scorpid 7022
    320861, 321001);        -- Stonevault Brawler 4855
DELETE FROM `creature_addon` WHERE `guid` IN (320803, 320967, 320804, 320966, 321070, 321072, 320828, 320829, 320861, 321001);

-- Check
SELECT CONCAT((SELECT COUNT(*) FROM `creature` WHERE `map` = 70), ' Uldaman spawns, ',
              (SELECT COUNT(*) FROM `creature` WHERE `map` = 70 AND `position_x` BETWEEN -280 AND -265 AND `position_y` BETWEEN 133 AND 145),
              ' left in the first-hall pack') AS `uldaman`;
