-- Follow-up to 2026_11_12_40: Four rode the Vashj'ir ship to its stop above Vashj'ir and was not dragged under.
-- The arrival event (25428 on TaxiPath 2204 node 4) is right for 8.3.7 (checked in the client's TaxiPathNode.db2),
-- so two likely gaps are closed here:
-- 1) The SmartAI player search from the ship only finds players in the ship's phase 170, and the sea along the route
--    up the Eastern Kingdoms coast is "The Great Sea" sub-areas of Stranglethorn (2339), Westfall (2364) and the
--    Wetlands (2365), which had no phase 170. Give them phase 170 on the quest too (also keeps the crew in view).
-- 2) The search radius (40 yards from the ship's origin) was shorter than the deck: Captain Samir stands 46 yards
--    forward. Use 80 yards.
DELETE FROM `phase_area` WHERE `PhaseId`=170 AND `AreaId` IN (2339,2364,2365);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(2339,170,'The Great Sea (Stranglethorn) - Ship to Vashj''ir (Horde) while on Call of Duty 25924'),
(2364,170,'The Great Sea (Westfall) - Ship to Vashj''ir (Horde) while on Call of Duty 25924'),
(2365,170,'The Great Sea (Wetlands) - Ship to Vashj''ir (Horde) while on Call of Duty 25924');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=170 AND `SourceEntry` IN (2339,2364,2365);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,170,2339,0,0,47,0,25924,8,0,0,0,0,'','The Great Sea (Stranglethorn) phase 170 while Call of Duty 25924 is incomplete'),
(26,170,2364,0,0,47,0,25924,8,0,0,0,0,'','The Great Sea (Westfall) phase 170 while Call of Duty 25924 is incomplete'),
(26,170,2365,0,0,47,0,25924,8,0,0,0,0,'','The Great Sea (Wetlands) phase 170 while Call of Duty 25924 is incomplete');
UPDATE `smart_scripts` SET `target_param2`=80 WHERE `entryorguid`=203466 AND `source_type`=1 AND `id`=0 AND `target_type`=17;
