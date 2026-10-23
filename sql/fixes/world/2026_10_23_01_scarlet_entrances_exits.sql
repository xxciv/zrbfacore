-- Scarlet Halls (map 1001) and Scarlet Monastery (map 1004): entrances and exits.
-- Coordinates checked against the Pandaria 5.4.8 world DB (alexkulya), which has the working rows.
--
-- 1) Dungeon Finder dungeon 163 (Scarlet Halls, normal) still had the old Armory (map 189) entrance,
--    so the finder dropped players outside the map at 1610.83, -323.43. Dungeon 164 (Scarlet Monastery,
--    normal) had the right x/y but the old Cathedral height (18.67 instead of 0.99).
-- Scarlet Halls arrival spot moved a few yards back from the Pandaria value (836.666, 605.141), to where
--    Four stood with .gps on 2026-10-23. Heroic (473) gets the same spot.
UPDATE `lfg_dungeon_template` SET `position_x`=839.075, `position_y`=618.522, `position_z`=12.8115, `orientation`=4.76381 WHERE `dungeonId` IN (163, 473);
UPDATE `lfg_dungeon_template` SET `position_x`=1124.64, `position_y`=512.467, `position_z`=0.989549, `orientation`=1.5708 WHERE `dungeonId`=164;

-- 2) Area trigger 614 (Scarlet Halls door) points at WorldSafeLoc 4077, which was missing, so the core
--    skipped the trigger at startup and the door did nothing. This core reads Facing as radians.
DELETE FROM `world_safe_locs` WHERE `ID`=4077;
INSERT INTO `world_safe_locs` (`ID`, `MapID`, `LocX`, `LocY`, `LocZ`, `Facing`, `Comment`) VALUES
(4077, 1001, 839.075, 618.522, 12.8115, 4.76381, 'Scarlet Halls 5.0 - Entrance Teleport Target');

-- 3) Neither dungeon had an exit trigger. 7801 (Scarlet Halls) and 7802 (Scarlet Monastery) send you
--    to the courtyard spots the old wings used (WorldSafeLocs 3626 and 3623).
DELETE FROM `areatrigger_teleport` WHERE `ID` IN (7801, 7802);
INSERT INTO `areatrigger_teleport` (`ID`, `PortLocID`, `Name`) VALUES
(7801, 3626, 'Scarlet Halls - Exit Target'),
(7802, 3623, 'Scarlet Monastery - Exit Target');
