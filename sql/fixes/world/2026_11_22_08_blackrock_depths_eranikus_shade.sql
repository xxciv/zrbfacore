-- Blackrock Depths (map 230): Eranikus' Shade, 2026-11-22. Run after 2026_11_22_07.
--
-- Four, 2026-11-22: a purple glow band with black smoke hangs at one height around the Grim Guzzler and the
-- bridge to it. It goes away with the client's "Projected Textures" setting off (so it is a model or spell
-- effect), stays put when the player flies up, is not outside Blackrock Mountain, and no aura on the player
-- draws it. Every gameobject here stands where Pandaria 5.4.8 has one. The only creatures this database adds
-- near the bar and the bridge are two Eranikus' Shades (51366, display 7804) at 843,-216 (beside the bar's
-- upper floor) and 999,-228 (by the Upper City entrance): unselectable, immune, no script, no quest, no gossip,
-- and neither Pandaria nor AzerothCore spawns them anywhere in Blackrock Depths. Removed (backup
-- zr_backup_brd_creature). The two in Blackrock Spire (map 229) and the one in Stormwind stay for now.

CREATE TABLE IF NOT EXISTS `zr_backup_brd_creature` LIKE `creature`;
INSERT IGNORE INTO `zr_backup_brd_creature` SELECT * FROM `creature` WHERE `map` = 230 AND `id` = 51366 AND `guid` IN (327508, 327509);
DELETE FROM `creature_addon` WHERE `guid` IN (327508, 327509);
DELETE FROM `creature` WHERE `map` = 230 AND `id` = 51366 AND `guid` IN (327508, 327509);

-- Check
SELECT CONCAT('Eranikus shades in Blackrock Depths ', (SELECT COUNT(*) FROM `creature` WHERE `map` = 230 AND `id` = 51366),
    ', backed up ', (SELECT COUNT(*) FROM `zr_backup_brd_creature` WHERE `id` = 51366)) AS `check`;
