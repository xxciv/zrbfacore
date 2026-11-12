-- Scholomance (map 1007): the dungeon pulled players in before they reached the entrance door.
-- Western Plaguelands has two areatriggers in front of Scholomance that both teleport to map 1007:
--   2567 at (1282.05, -2548.73, 85.40), box 10.6 x 13.0 x 21.7: the Mists of Pandaria entrance,
--        down the stairs past the door (the only one the Pandaria 5.4.8 database has).
--   6339 at (1270.56, -2570.14, 97.00), box 6 x 10 x 10: named "This was old Scholo entrance",
--        on the way to the door. It fires before the door when walking in, and after the stairs
--        exit drops players at (1273.91, -2553.09, 91.84) it pulls them back in when they head out.
-- Positions from AreaTrigger.db2. Nothing else (scripts, quests) uses 6339.
DELETE FROM `areatrigger_teleport` WHERE `ID` = 6339 AND `PortLocID` = 3671;
