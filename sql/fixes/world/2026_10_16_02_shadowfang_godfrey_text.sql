-- Shadowfang Keep: typos in Lord Godfrey's (46964) yells. Fixed in game by Four on
-- 2026-10-16; this file makes the same fix for a fresh database. Missing spaces after
-- punctuation, "clearn" -> "clean", "would not of" -> "would not have".
-- Revert:
-- UPDATE `creature_text` SET `Text` = 'That bitch Sylvanas sent you too,did she?No matter,your journey ends in agony.' WHERE `CreatureID` = 46964 AND `GroupID` = 0 AND `ID` = 0;
-- UPDATE `creature_text` SET `Text` = 'I thank you for the clearn death.I would not of done the same...' WHERE `CreatureID` = 46964 AND `GroupID` = 2 AND `ID` = 0;
UPDATE `creature_text` SET `Text` = 'That bitch Sylvanas sent you too, did she? No matter - your journey ends in agony.' WHERE `CreatureID` = 46964 AND `GroupID` = 0 AND `ID` = 0;
UPDATE `creature_text` SET `Text` = 'I thank you for the clean death. I would not have done the same...' WHERE `CreatureID` = 46964 AND `GroupID` = 2 AND `ID` = 0;
