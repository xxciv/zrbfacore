-- Darkmoon Faire: Fire Jugglers throwing torches at players and the Greeter (Four, 2026-11-05).
--
-- Fire Jugglers carry aura 102905 (template addon of 55089, 55093, 55225, 55397). Every 0.7 seconds it
-- casts 102882, a dummy whose torch flies to target 38 (nearby unit by entry) within 20 yards. The
-- spell needs a condition saying which entry; with none the core takes any unit near the juggler, so
-- torches flew at players, the Greeter and whatever stood closest.
-- The jugglers stand in pairs about 18 yards apart (Elwynn 55089 + 55093, Mulgore 55397 + 55398), so the
-- torch goes to the other Fire Juggler. One row per Fire Juggler entry (each its own ElseGroup = OR).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=102882;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 102882, 0, 0, 31, 0, 3, 55089, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 1, 31, 0, 3, 55093, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 2, 31, 0, 3, 55220, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 3, 31, 0, 3, 55221, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 4, 31, 0, 3, 55222, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 5, 31, 0, 3, 55223, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 6, 31, 0, 3, 55224, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 7, 31, 0, 3, 55225, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 8, 31, 0, 3, 55226, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 9, 31, 0, 3, 55341, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 10, 31, 0, 3, 55342, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 11, 31, 0, 3, 55397, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers'),
(13, 1, 102882, 0, 12, 31, 0, 3, 55398, 0, 0, 0, 0, '', 'Juggle Torch hits only Fire Jugglers');
