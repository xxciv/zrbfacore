-- Stormwind Wizard's Sanctum: the portal at the top of the tower did nothing, so the portal room
-- (Boralus, Dalaran, Ashran, Paw'don Village, Exodar, Shattrath, Caverns of Time portals) could not be reached.
-- The client's area triggers 4733 (top of the tower, -9016 876 148.6) and 4734 (basement, -9019 888 29.6)
-- had no areatrigger_teleport rows. Destinations are the server's own world_safe_locs:
-- 7264 'Stormwind - Portal Room - Wizard's Sanctum Dest' (-9004.44 870.63 64.86, where the mage teleport lands)
-- 3630 'Stormwind - Mage Exit Target' (-9013.2 870.63 148.62, beside the top portal).
DELETE FROM `areatrigger_teleport` WHERE `ID` IN (4733,4734);
INSERT INTO `areatrigger_teleport` (`ID`,`PortLocID`,`Name`) VALUES
(4733,7264,'Stormwind - Wizard\'s Sanctum - Portal Room Entrance'),
(4734,3630,'Stormwind - Wizard\'s Sanctum - Exit to Tower Top');

-- Portal room spawns doubled in the default phase (the second copies came with a later sniff):
-- Maginor Dumas 331, Enchanted Broom 103033, Tushui Magister 147741, and Portal to Paw'don Village 323844
-- standing in the Portal to Pandaria 315457 (both cast the same spell 130703).
DELETE FROM `creature` WHERE `guid` IN (3400000000001970,3400000000001971,3400000000001972);
DELETE FROM `creature_addon` WHERE `guid` IN (3400000000001970,3400000000001971,3400000000001972);
DELETE FROM `gameobject` WHERE `guid`=3300000000298;
DELETE FROM `gameobject_addon` WHERE `guid`=3300000000298;
