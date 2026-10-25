-- Scarlet Halls (zone 6052) and Scarlet Monastery (zone 6109) had no graveyard. Dying inside sent
-- you to the default Alliance graveyard at Sentinel Hill in Westfall (reported by Four, 2026-10-23).
-- Link both to the Scarlet Monastery graveyard in Tirisfal Glades (world_safe_locs 1874), the one the
-- old Scarlet Monastery zone (796) already uses. Same rows as the Pandaria 5.4.8 database.

DELETE FROM `graveyard_zone` WHERE `ID`=1874 AND `GhostZone` IN (6052, 6109);
INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Faction`, `Comment`) VALUES
(1874, 6052, 0, 'Tirisfal Glades, Scarlet Monastery GY - Scarlet Halls'),
(1874, 6109, 0, 'Tirisfal Glades, Scarlet Monastery GY - Scarlet Monastery');
