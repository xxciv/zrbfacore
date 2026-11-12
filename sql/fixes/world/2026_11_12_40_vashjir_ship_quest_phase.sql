-- Ship to Vashj'ir (Horde), transport 203466: only for players on "Call of Duty" (25924), as on retail.
-- The transport is already in phase 170 (`transports`), but no phase_area ever gave a player phase 170 around it,
-- and the core showed it to everyone each time it crossed between Kalimdor and the Eastern Kingdoms
-- (tools/bfa/transport-phase-visibility.patch fixes that).
-- 1) Phase 170 while 25924 is in progress (not yet complete) in Durotar (Orgrimmar docks and the coast),
--    The Great Sea (map 0) and Vashj'ir.
DELETE FROM `phase_area` WHERE `PhaseId`=170 AND `AreaId` IN (14,214,5146);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(14,170,'Durotar - Ship to Vashj''ir (Horde) while on Call of Duty 25924'),
(214,170,'The Great Sea - Ship to Vashj''ir (Horde) while on Call of Duty 25924'),
(5146,170,'Vashj''ir - Ship to Vashj''ir (Horde) while on Call of Duty 25924');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=170 AND `SourceEntry` IN (14,214,5146);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,170,14,0,0,47,0,25924,8,0,0,0,0,'','Durotar phase 170 while Call of Duty 25924 is incomplete'),
(26,170,214,0,0,47,0,25924,8,0,0,0,0,'','The Great Sea phase 170 while Call of Duty 25924 is incomplete'),
(26,170,5146,0,0,47,0,25924,8,0,0,0,0,'','Vashj''ir phase 170 while Call of Duty 25924 is incomplete');

-- 2) The ship's crew (2026_11_12_39) rides in the same phase; passengers don't inherit the ship's phase.
UPDATE `creature` SET `phaseUseFlags`=0, `PhaseId`=170, `PhaseGroup`=0 WHERE `guid` BETWEEN 735200301 AND 735200310;

-- 3) The docked ship clips through the scenery ships at its Orgrimmar berth (1440 -5035): hide those (and the two
--    NPCs standing on them) from players in phase 170 only, using an inverse phase. Everyone else sees no change.
UPDATE `gameobject` SET `phaseUseFlags`=2, `PhaseId`=170, `PhaseGroup`=0 WHERE `guid` IN (101352,101353,184257) AND `map`=1;
--    101352 Horde ship 269836, 101353 Mantaray 269837, 184257 Gooblin Boat 203471
UPDATE `creature` SET `phaseUseFlags`=2, `PhaseId`=170, `PhaseGroup`=0 WHERE `guid` IN (401248,20500904) AND `map`=1;
--    401248 Lady Liadrin (on the Horde ship), 20500904 Hired Courier (on the Gooblin Boat)

-- 4) Nothing scripted the end of the ride, so "Call of Duty" could never complete. When the ship reaches its stop
--    above Vashj'ir (TaxiPath 2204 node 4, arrival event 25428), everyone aboard in phase 170 is dragged under:
--    teleported next to Erunak Stonespeaker 41618 (who starts "Sea Legs") and given the quest credit 36901.
DELETE FROM `smart_scripts` WHERE `entryorguid`=203466 AND `source_type`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(203466,1,0,0,71,0,100,0,25428,0,0,0,0,'',64,1,0,0,0,0,0,17,0,40,0,0,0,0,0,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Store players aboard'),
(203466,1,1,0,71,0,100,0,25428,0,0,0,0,'',62,0,0,0,0,0,0,12,1,0,0,-4608.77,3982.0,-70.4,2.217,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Teleport stored players to Erunak Stonespeaker'),
(203466,1,2,0,71,0,100,0,25428,0,0,0,0,'',33,36901,0,0,0,0,0,12,1,0,0,0,0,0,0,'Ship to Vashj''ir (Horde) - On Vashj''ir stop - Quest credit Call of Duty 25924');
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=203466;
