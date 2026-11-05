-- Darkmoon Faire missing from the in-game calendar (Four, 2026-11-04). Run against bfa_hotfixes.
--
-- The server sends no holidays to the calendar: the client draws them from the dates in Holidays.db2.
-- In the 8.3.7 client, the Darkmoon Faire (holiday 479) only has dates from July 2019 to December 2020,
-- so nothing shows in 2026. This hotfix gives the client a new row 479 with the same fields as the
-- client's own (read from Four's Holidays.db2) and new dates.
--
-- The Faire has two stages (Duration 48 and 168 hours, CalendarFlags 0 and 3): each date is the
-- Friday 00:00 before the first Sunday of the month, the calendar shows the Faire from that Sunday
-- 00:00 for 7 days. 26 dates (the db2 maximum): from the Faire of Sunday 2026-11-01 to the Faire of
-- Sunday 2028-12-03. The calendar needs new dates again for 2029.
-- Date packing: minute | hour<<6 | weekday(7 = any)<<11 | (day-1)<<14 | (month-1)<<20 | (year-2000)<<24.
--
-- The server's own Faire schedule is game event 3 (holiday-schedule.patch and
-- sql/fixes/world/2026_11_04_00_darkmoon_faire_first_sunday.sql), which runs on the same days.
--
-- hotfix_data: table hash 0x758E7BCC (1972272076) is Holidays.db2. Hotfix id 9000479 is new (the
-- dump's highest is 789004), so clients that already cached hotfixes still ask for this one.
DELETE FROM `holidays` WHERE `ID`=479;
INSERT INTO `holidays` (`ID`, `Region`, `Looping`, `HolidayNameID`, `HolidayDescriptionID`, `Priority`, `CalendarFilterType`, `Flags`, `Duration1`, `Duration2`, `Duration3`, `Duration4`, `Duration5`, `Duration6`, `Duration7`, `Duration8`, `Duration9`, `Duration10`, `Date1`, `Date2`, `Date3`, `Date4`, `Date5`, `Date6`, `Date7`, `Date8`, `Date9`, `Date10`, `Date11`, `Date12`, `Date13`, `Date14`, `Date15`, `Date16`, `Date17`, `Date18`, `Date19`, `Date20`, `Date21`, `Date22`, `Date23`, `Date24`, `Date25`, `Date26`, `CalendarFlags1`, `CalendarFlags2`, `CalendarFlags3`, `CalendarFlags4`, `CalendarFlags5`, `CalendarFlags6`, `CalendarFlags7`, `CalendarFlags8`, `CalendarFlags9`, `CalendarFlags10`, `TextureFileDataID1`, `TextureFileDataID2`, `TextureFileDataID3`, `VerifiedBuild`) VALUES
(479, 0, 0, 1, 201, 1, 1, 1, 48, 168, 0, 0, 0, 0, 0, 0, 0, 0, 446134272, 447805440, 452999168, 454113280, 455161856, 456161280, 456620032, 458291200, 459307008, 459765760, 461420544, 462436352, 463550464, 464566272, 465025024, 470874112, 471906304, 472365056, 474036224, 475035648, 475494400, 477165568, 478164992, 478623744, 480294912, 481310720, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 235448, 235447, 235446, 35662);
DELETE FROM `hotfix_data` WHERE `TableHash`=1972272076 AND `RecordId`=479;
INSERT INTO `hotfix_data` (`Id`, `TableHash`, `RecordId`, `Deleted`, `VerifiedBuild`) VALUES (9000479, 1972272076, 479, 0, 35662);
