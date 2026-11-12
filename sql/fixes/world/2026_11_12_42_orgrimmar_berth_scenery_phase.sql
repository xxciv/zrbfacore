-- Follow-up to 2026_11_12_40: the inverse phase 170 on the Orgrimmar berth scenery did not hide it. Durotar also
-- gives every player phase 169 ("always see unphased creatures"), which keeps the player "unphased", and an
-- unphased player sees every inverse-phased object. Use a normal phase instead: phase 307 (unused) in Durotar for
-- everyone EXCEPT players with "Call of Duty" 25924 in progress, and put the scenery in phase 307.
DELETE FROM `phase_area` WHERE `AreaId`=14 AND `PhaseId`=307;
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(14,307,'Durotar - Orgrimmar berth scenery ships, hidden while on Call of Duty 25924 (Vashj''ir ship docks there)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=307 AND `SourceEntry`=14;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,307,14,0,0,47,0,25924,8,0,1,0,0,'','Durotar phase 307 unless Call of Duty 25924 is incomplete');
-- 101352 Horde ship 269836, 101353 Mantaray 269837, 184257 Gooblin Boat 203471
UPDATE `gameobject` SET `phaseUseFlags`=0, `PhaseId`=307, `PhaseGroup`=0 WHERE `guid` IN (101352,101353,184257) AND `map`=1;
-- 401248 Lady Liadrin (on the Horde ship), 20500904 Hired Courier (on the Gooblin Boat)
UPDATE `creature` SET `phaseUseFlags`=0, `PhaseId`=307, `PhaseGroup`=0 WHERE `guid` IN (401248,20500904) AND `map`=1;
