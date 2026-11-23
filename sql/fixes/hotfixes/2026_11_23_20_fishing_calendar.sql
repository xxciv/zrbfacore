-- Fishing tournaments missing from the in-game calendar (Four, 2026-11-23). Run against bfa_hotfixes.
--
-- The client draws holidays from its Holidays.db2, and both fishing rows there are unusable:
--   301 Stranglethorn Fishing Extravaganza: Flags 3 = 1 | 2, and 2 means "don't show in calendar".
--     Its one date is a weekly pattern (any year, any month, any day, Sunday 14:00) that no row the
--     client does show uses.
--   424 Kalu'ak Fishing Derby: its one date is "Saturday 14:00, any month, but only in 2005".
-- Each row below is the client's own row (names, descriptions, texture, calendar filter "Weekly
-- Holidays", durations 2 and 1 hours) with Flags 1 and 26 explicit weekly dates, the same format as
-- the Darkmoon Faire and holiday hotfixes that already show (2026_11_04_00, 2026_11_05_00):
--   301: Sundays 14:00 from 2026-11-29 to 2027-05-23
--   424: Saturdays 14:00 from 2026-11-28 to 2027-05-22
-- 26 is the most dates a row can hold, so the calendar needs new dates by May 2027. The server runs
-- the events every week regardless (game events 14, 15 and 64,
-- sql/fixes/world/2026_11_22_20_fishing_tournaments.sql); this file only changes what the calendar draws.
-- Date packing: minute | hour<<6 | weekday(7 = any)<<11 | (day-1)<<14 | (month-1)<<20 | (year-2000)<<24.
-- Hotfix ids are 9000000 + holiday id (zrbfacore's range).
DELETE FROM `holidays` WHERE `ID` IN (301, 424);
INSERT INTO `holidays` (`ID`, `Region`, `Looping`, `HolidayNameID`, `HolidayDescriptionID`, `Priority`, `CalendarFilterType`, `Flags`, `Duration1`, `Duration2`, `Duration3`, `Duration4`, `Duration5`, `Duration6`, `Duration7`, `Duration8`, `Duration9`, `Duration10`, `Date1`, `Date2`, `Date3`, `Date4`, `Date5`, `Date6`, `Date7`, `Date8`, `Date9`, `Date10`, `Date11`, `Date12`, `Date13`, `Date14`, `Date15`, `Date16`, `Date17`, `Date18`, `Date19`, `Date20`, `Date21`, `Date22`, `Date23`, `Date24`, `Date25`, `Date26`, `CalendarFlags1`, `CalendarFlags2`, `CalendarFlags3`, `CalendarFlags4`, `CalendarFlags5`, `CalendarFlags6`, `CalendarFlags7`, `CalendarFlags8`, `CalendarFlags9`, `CalendarFlags10`, `TextureFileDataID1`, `TextureFileDataID2`, `TextureFileDataID3`, `VerifiedBuild`) VALUES
(301, 0, 0, 6, 4, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 447167360, 447839104, 447953792, 448068480, 448183168, 453032832, 453147520, 453262208, 453376896, 453491584, 454146944, 454261632, 454376320, 454491008, 455195520, 455310208, 455424896, 455539584, 456194944, 456309632, 456424320, 456539008, 457210752, 457325440, 457440128, 457554816, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235458, 0, 0, 35662),
(424, 0, 0, 161, 161, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 447150976, 447822720, 447937408, 448052096, 448166784, 453016448, 453131136, 453245824, 453360512, 453475200, 454130560, 454245248, 454359936, 454474624, 455179136, 455293824, 455408512, 455523200, 456178560, 456293248, 456407936, 456522624, 457194368, 457309056, 457423744, 457538432, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 235458, 0, 0, 35662);
DELETE FROM `hotfix_data` WHERE `TableHash`=1972272076 AND `RecordId` IN (301, 424);
INSERT INTO `hotfix_data` (`Id`, `TableHash`, `RecordId`, `Deleted`, `VerifiedBuild`) VALUES
(9000301, 1972272076, 301, 0, 35662),
(9000424, 1972272076, 424, 0, 35662);
