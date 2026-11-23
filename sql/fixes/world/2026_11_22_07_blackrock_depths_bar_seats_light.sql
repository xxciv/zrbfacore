-- Blackrock Depths (map 230): Grim Guzzler, second pass, 2026-11-22. Run after 2026_11_22_06.
--
-- 1. Four, 2026-11-22: "the top floor of the grim guzzler is better, there are still a few strays standing inside
--    tables, etc. the bottom floor is still pretty bad." The 06 pass only seated patrons within 3 yards of a
--    chair; the lower floor's patrons stood as a crowd in front of the concert stage (843,-173), up to 14 yards
--    from the tables. 19 more patrons take the nearest free chair on their own floor (3 to 14 yards). 64 of 69
--    now sit; the 4 at the upper bar counter (880-888,-180) and 1 on the stairs (840,-205) stand.
-- 2. Four's video (2026-11-22, a different client): the purple light pulses about every second and a half with
--    the camera still, so it is not the camera. The L70ETC Music Doodad (186312, the concert stage's light and
--    music rig) was spawned with no event (188711, 843.4,-173.6), unlike the band that 2026_11_22_02 put on
--    Brewfest. Put on Brewfest (event 24) too; AzerothCore has no rig in the bar outside the concert.

CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_moved` LIKE `creature`;
CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature_addon` LIKE `creature_addon`;

-- 1. Seats (patron guid, chair guid, chair spot)
DROP TEMPORARY TABLE IF EXISTS `zr_brd_seat`;
CREATE TEMPORARY TABLE `zr_brd_seat` (`guid` BIGINT UNSIGNED PRIMARY KEY, `chair` BIGINT UNSIGNED, `x` FLOAT, `y` FLOAT, `z` FLOAT, `o` FLOAT);
INSERT INTO `zr_brd_seat` VALUES
(321642, 188376, 878.786, -168.690, -49.740, -3.0107),
(321643, 188455, 822.200, -163.345, -49.740, -2.5220),
(321646, 188371, 858.867, -166.316, -49.740, 0.1833),
(321647, 188298, 830.798, -153.023, -49.740, -2.5220),
(321963, 188229, 829.437, -156.665, -49.740, 0.3752),
(321967, 188366, 894.583, -203.382, -43.697, 0.5323),
(322128, 188222, 844.962, -145.934, -49.737, -1.4224),
(322130, 188293, 861.907, -198.118, -43.694, 1.0472),
(322182, 188278, 874.797, -211.648, -43.721, -2.5482),
(322185, 188457, 830.015, -162.580, -49.716, -0.9774),
(322214, 188283, 889.649, -207.771, -43.721, 2.0508),
(322216, 188261, 877.005, -215.300, -43.721, -2.5482),
(322217, 188373, 873.163, -214.855, -43.721, 0.5236),
(322233, 188395, 831.309, -165.398, -49.740, 2.0944),
(322234, 188528, 828.191, -154.671, -49.740, 0.5498),
(322235, 188226, 825.240, -174.031, -49.740, 0.5498),
(322240, 188326, 853.396, -208.027, -43.721, 2.0333),
(322249, 188350, 859.924, -137.933, -49.740, -2.5220),
(322252, 188305, 875.730, -146.120, -49.740, 0.3752);
INSERT IGNORE INTO `zr_backup_brd_creature_moved` SELECT c.* FROM `creature` c JOIN `zr_brd_seat` s ON s.`guid` = c.`guid` WHERE c.`map` = 230;
INSERT IGNORE INTO `zr_backup_brd_creature_addon` SELECT a.* FROM `creature_addon` a JOIN `zr_brd_seat` s ON s.`guid` = a.`guid`;
UPDATE `creature` c JOIN `zr_brd_seat` s ON s.`guid` = c.`guid`
    SET c.`position_x` = s.`x`, c.`position_y` = s.`y`, c.`position_z` = s.`z`, c.`orientation` = s.`o`, c.`spawndist` = 0, c.`MovementType` = 0
    WHERE c.`map` = 230 AND c.`id` IN (9545, 9547, 9554);
UPDATE `creature_addon` a JOIN `zr_brd_seat` s ON s.`guid` = a.`guid` SET a.`bytes1` = 5;
INSERT IGNORE INTO `creature_addon` (`guid`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`)
    SELECT s.`guid`, 0, 0, 5, t.`bytes2`, 0, 0, 0, 0, 0, t.`auras`
    FROM `zr_brd_seat` s JOIN `creature` c ON c.`guid` = s.`guid` JOIN `creature_template_addon` t ON t.`entry` = c.`id`;
DROP TEMPORARY TABLE `zr_brd_seat`;

-- 2. Concert light and music rig only at Brewfest
DELETE FROM `game_event_gameobject` WHERE `guid` = 188711;
INSERT INTO `game_event_gameobject` (`eventEntry`, `guid`) SELECT 24, `guid` FROM `gameobject` WHERE `map` = 230 AND `guid` = 188711 AND `id` = 186312;

-- Check
SELECT CONCAT('Seated patrons ', (SELECT COUNT(*) FROM `creature` c JOIN `creature_addon` a ON a.`guid` = c.`guid` WHERE c.`map` = 230 AND c.`id` IN (9545, 9547, 9554) AND a.`bytes1` = 5),
    ' of ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` IN (9545, 9547, 9554)),
    ', patrons within 1 yard of another ', (SELECT COUNT(*) FROM `creature` p JOIN `creature` q ON q.`map` = 230 AND p.`guid` < q.`guid`
        AND q.`id` IN (9545, 9547, 9554) AND POW(p.`position_x` - q.`position_x`, 2) + POW(p.`position_y` - q.`position_y`, 2) < 1
        WHERE p.`map` = 230 AND p.`id` IN (9545, 9547, 9554)),
    ', music rig on Brewfest ', (SELECT COUNT(*) FROM `game_event_gameobject` WHERE `guid` = 188711 AND `eventEntry` = 24)) AS `check`;
