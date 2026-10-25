-- Scarlet Halls: Commander Lindon's Shield Breaker turned players invisible.
--
-- Shield Breaker (125492) fires two shells. 125507 knocks everyone within 8 yards down and strips
-- Heroic Defense (113436), which is the intended "knock the shield out of your hands". The other,
-- 125493, transforms its targets into Invisible Man (64188) with no duration limit. Its targets are
-- picked by creature entry (TARGET_UNIT_DEST_AREA_ENTRY), and with no conditions row the core falls
-- back to every enemy within 13 yards, so it hit the player: character model gone, only the weapons
-- left floating, until `.unaura all`. It is meant for the Reinforced Archery Target (59163) the
-- player carries; limit it to that.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=125493;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 125493, 0, 0, 31, 0, 3, 59163, 0, 0, 0, 0, '', 'Shield Breaker (transform) - only the Reinforced Archery Target');
