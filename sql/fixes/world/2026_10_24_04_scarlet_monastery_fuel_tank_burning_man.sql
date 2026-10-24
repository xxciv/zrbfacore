-- Scarlet Monastery, first test run (2026-10-24).
--
-- Fuel Tank (59706): the template carries UNIT_FLAG_NOT_SELECTABLE (0x02000000), so the tank could not
-- be clicked even though its spellclick row (114953) and script were in place. Drop the flag (the
-- script also clears it on spawn).
--
-- Burning Man (125844 from Blazing Fists, 125852 from Firestorm Kick): Brother Korloff's fire is meant
-- to set the Training Dummies (64446, 60197) alight for the achievement. The spells pick targets by
-- creature entry, and with no conditions row the core falls back to everyone in range, so the player
-- got the burning visual with no duration until `.unaura all`. Limit both to the dummies.

UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~0x02000000 WHERE `entry`=59706;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (125844, 125852);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 125844, 0, 0, 31, 0, 3, 64446, 0, 0, 0, 0, '', 'Burning Man (Blazing Fists) - only Training Dummies'),
(13, 1, 125844, 0, 1, 31, 0, 3, 60197, 0, 0, 0, 0, '', 'Burning Man (Blazing Fists) - only Training Dummies'),
(13, 1, 125852, 0, 0, 31, 0, 3, 64446, 0, 0, 0, 0, '', 'Burning Man (Firestorm Kick) - only Training Dummies'),
(13, 1, 125852, 0, 1, 31, 0, 3, 60197, 0, 0, 0, 0, '', 'Burning Man (Firestorm Kick) - only Training Dummies');
