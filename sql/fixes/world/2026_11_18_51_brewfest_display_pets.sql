-- Brewfest companion pets only appear during Brewfest (zrbfacore, 2026-11-18)
-- Found (Four, screenshots): a Wolpertinger and a Pint-Sized Pink Pachyderm stand in the open in Durotar
--   all year. Both are Brewfest companions (Wolpertinger 22943 = species 153, Pink Pachyderm 24753 =
--   species 166, neither capturable), not wild battle pets.
-- Cause: 6 display spawns of these pets have no game_event_creature row, so they never despawn:
--     10647404 Wolpertinger      Durotar   1159.73 -4140.95
--     10647405 Pink Pachyderm    Durotar   1180.88 -4098.65
--     10646514 Wolpertinger      Dun Morogh -5175.68 -566.15  (Brewfest grounds, among the Wild Wolpertingers)
--     10646515 Pink Pachyderm    Dun Morogh -5175.68 -615.13
--     10652003 Pink Pachyderm    Orgrimmar  1633.21 -4386.48  (next to Ray'ma, Brew of the Month Club)
--     10651977 Pink Pachyderm    Ironforge  -4849.93 -870.14  (next to Larkin Thunderbrew, Brew of the Month Club)
--   The Wild Wolpertingers and Brewfest decorations around them are already in event 24 (Brewfest).
-- Changed: the 6 spawns join game_event 24 (Brewfest), so they only spawn while Brewfest runs.
--   Restart worldserver afterwards.
DELETE FROM `game_event_creature` WHERE `guid` IN (10647404, 10647405, 10646514, 10646515, 10652003, 10651977);
INSERT INTO `game_event_creature` (`eventEntry`, `guid`) VALUES
(24, 10647404), (24, 10647405), (24, 10646514), (24, 10646515), (24, 10652003), (24, 10651977);
SELECT CONCAT(COUNT(*), ' Brewfest pet spawns linked to event 24') AS zr_result
  FROM `game_event_creature` WHERE `eventEntry` = 24
   AND `guid` IN (10647404, 10647405, 10646514, 10646515, 10652003, 10651977);
