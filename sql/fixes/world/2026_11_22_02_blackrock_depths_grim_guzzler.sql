-- Blackrock Depths (map 230): The Grim Guzzler, 2026-11-22.
--
-- 1. Four saw a purple light show over the bar in November: the L70ETC concert (the band Bergrisst, Chief
--    Thunder-Skins, Mai'Kyl, Samuro and Sig Nicious, their FX controller casting Lightning Cloud, Earthquake
--    and fireworks, and the drums) was linked to game events 34 and 71 (70 for the drums). In this database
--    those are "Brew of the Month October" and "WoW's 10th Anniversary" (and the 9th): old TrinityCore event
--    ids that were renumbered. The Grim Guzzler concert is a Brewfest show, so its spawns move to Brewfest
--    (event 24) only. The Shattrath copies (map 530) are left as they are.
-- 2. Guzzling Patron 9547 and Hammered Patron 9554 used faction 54 (hostile) while the Grim Patrons next to
--    them use the bar's faction 674, so some patrons attacked on sight and others did not. Pandaria 5.4.8 has
--    674 for all three.

-- 1. Concert
DELETE FROM `game_event_creature` WHERE `guid` IN (321726, 321727, 322326, 322327, 322328, 322329, 322330);
INSERT INTO `game_event_creature` (`eventEntry`, `guid`) VALUES
(24, 321726), (24, 321727), (24, 322326), (24, 322327), (24, 322328), (24, 322329), (24, 322330);

-- 2. Patrons
UPDATE `creature_template` SET `faction` = 674 WHERE `entry` IN (9547, 9554);

-- Check
SELECT CONCAT('Concert spawns on Brewfest ', (SELECT COUNT(*) FROM `game_event_creature` WHERE `eventEntry` = 24 AND `guid` IN (321726, 321727, 322326, 322327, 322328, 322329, 322330)),
    ', on other events ', (SELECT COUNT(*) FROM `game_event_creature` WHERE `eventEntry` <> 24 AND `guid` IN (321726, 321727, 322326, 322327, 322328, 322329, 322330)),
    ', hostile patron kinds ', (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (9545, 9547, 9554) AND `faction` <> 674)) AS `check`;
