-- Darkmoon races: Let's Keep Racing! and More Big Racing! are repeatable (zrbfacore)
--
-- From Four, 2026-11-07: after finishing them once, Malle Earnhard (74056) and Patti Earnhard
-- (90473) offered nothing. Both quests carry QUEST_FLAGS_EX_DISPLAY_AS_DAILY_QUEST (0x8000, the
-- blue repeatable marker) and no daily/weekly flag: they are the repeatable runs of the two
-- courses (no reward). quest_template_addon had SpecialFlags 0, so the core treated them as
-- one-time quests. SpecialFlags 1 = QUEST_SPECIAL_FLAGS_REPEATABLE.
UPDATE `quest_template_addon` SET `SpecialFlags`=`SpecialFlags`|1 WHERE `ID` IN (33756, 37868);
