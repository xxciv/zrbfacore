-- Holidays missing from the in-game calendar (Four, 2026-11-05). Run against bfa_hotfixes.
--
-- The client draws holidays from the dates in its Holidays.db2. These six move from year to year, and
-- in the 8.3.7 client their dates stop in 2020 (Lunar Festival in 2024), so the 2026 calendar doesn't
-- show them. Each row below is the client's own row (read from Four's Holidays.db2: names,
-- descriptions, textures, durations, calendar flags) with five new dates, 2026 to 2030. 2030 is the
-- last year a Holidays.db2 date can hold (5 bits from 2000; 31 means "any year").
--
-- The server runs the same holidays from these same dates: holiday-schedule.patch,
-- game_event occurence 1 (sql/fixes/world/2026_11_05_00_holiday_dates_schedule.sql).
-- Every holiday starts at 10:00 server time, as most of the client's own dates do. Rules:
-- 327 Lunar Festival: 2 days before the lunar new year, 10:00: Sun 2026-02-15, Thu 2027-02-04, Mon 2028-01-24, Sun 2029-02-11, Fri 2030-02-01
-- 423 Love is in the Air: first Monday on or after 7 February, 10:00: Mon 2026-02-09, Mon 2027-02-08, Mon 2028-02-07, Mon 2029-02-12, Mon 2030-02-11
-- 181 Noblegarden: Easter Monday, 10:00: Mon 2026-04-06, Mon 2027-03-29, Mon 2028-04-17, Mon 2029-04-02, Mon 2030-04-22
-- 201 Children's Week: the Monday between 28 April and 4 May, 10:00: Mon 2026-05-04, Mon 2027-05-03, Mon 2028-05-01, Mon 2029-04-30, Mon 2030-04-29
-- 321 Harvest Festival: second Tuesday of September, 10:00: Tue 2026-09-08, Tue 2027-09-14, Tue 2028-09-12, Tue 2029-09-11, Tue 2030-09-10
-- 404 Pilgrim's Bounty: Monday of Thanksgiving week (3 days before the 4th Thursday of November), 10:00: Mon 2026-11-23, Mon 2027-11-22, Mon 2028-11-20, Mon 2029-11-19, Mon 2030-11-25
--
-- Hotfix ids are 9000000 + holiday id (zrbfacore's range; the dump's highest is 789004).
DELETE FROM `holidays` WHERE `ID` IN (327, 423, 181, 201, 321, 404);
INSERT INTO `holidays` (`ID`, `Region`, `Looping`, `HolidayNameID`, `HolidayDescriptionID`, `Priority`, `CalendarFilterType`, `Flags`, `Duration1`, `Duration2`, `Duration3`, `Duration4`, `Duration5`, `Duration6`, `Duration7`, `Duration8`, `Duration9`, `Duration10`, `Date1`, `Date2`, `Date3`, `Date4`, `Date5`, `Date6`, `Date7`, `Date8`, `Date9`, `Date10`, `Date11`, `Date12`, `Date13`, `Date14`, `Date15`, `Date16`, `Date17`, `Date18`, `Date19`, `Date20`, `Date21`, `Date22`, `Date23`, `Date24`, `Date25`, `Date26`, `CalendarFlags1`, `CalendarFlags2`, `CalendarFlags3`, `CalendarFlags4`, `CalendarFlags5`, `CalendarFlags6`, `CalendarFlags7`, `CalendarFlags8`, `CalendarFlags9`, `CalendarFlags10`, `TextureFileDataID1`, `TextureFileDataID2`, `TextureFileDataID3`, `VerifiedBuild`) VALUES
(327, 0, 0, 18, 17, 5, -1, 1, 336, 0, 0, 0, 0, 0, 0, 0, 0, 0, 437500544, 454097536, 470153856, 487766656, 504380032, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235471, 235470, 235469, 35662),
(423, 0, 0, 9, 9, 5, -1, 1, 336, 0, 0, 0, 0, 0, 0, 0, 0, 0, 437402240, 454163072, 470923904, 487783040, 504543872, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235468, 235467, 235466, 35662),
(181, 0, 0, 15, 14, 5, -1, 1, 168, 0, 0, 0, 0, 0, 0, 0, 0, 0, 439450240, 455555712, 473184896, 489716352, 506821248, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235477, 235476, 235475, 35662),
(201, 0, 0, 13, 12, 5, -1, 1, 168, 0, 0, 0, 0, 0, 0, 0, 0, 0, 440466048, 457226880, 473971328, 490175104, 506935936, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235445, 235444, 235443, 35662),
(321, 0, 0, 17, 16, 5, -1, 1, 168, 0, 0, 0, 0, 0, 0, 0, 0, 0, 444725888, 461601408, 478345856, 495106688, 511867520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235465, 235464, 235463, 35662),
(404, 0, 0, 101, 101, 5, -1, 1, 167, 0, 0, 0, 0, 0, 0, 0, 0, 0, 447068800, 463829632, 480574080, 497334912, 514210432, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235465, 235464, 235463, 35662);
DELETE FROM `hotfix_data` WHERE `TableHash`=1972272076 AND `RecordId` IN (327, 423, 181, 201, 321, 404);
INSERT INTO `hotfix_data` (`Id`, `TableHash`, `RecordId`, `Deleted`, `VerifiedBuild`) VALUES
(9000327, 1972272076, 327, 0, 35662),
(9000423, 1972272076, 423, 0, 35662),
(9000181, 1972272076, 181, 0, 35662),
(9000201, 1972272076, 201, 0, 35662),
(9000321, 1972272076, 321, 0, 35662),
(9000404, 1972272076, 404, 0, 35662);
