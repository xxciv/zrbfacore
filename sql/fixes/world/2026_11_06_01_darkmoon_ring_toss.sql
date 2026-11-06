-- zrbfacore: Darkmoon Faire Ring Toss (Jessica Rogers 54485, Target: Turtle 29455).
-- The ring (181457 -> 181458 at the spot you aim at) hits every unit in its landing area,
-- because 181458 has no target conditions. Only Dubenko (54490), the turtle in the pond,
-- is a valid target. The credit comes from the C++ handler (darkmoon-faire-gossip.patch,
-- spell_ring_toss), so drop Dubenko's SAI credit row, which doubled every hit.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=181458;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,181458,0,0,31,0,3,54490,0,0,0,0,'','Ring Toss - only hits Dubenko');

DELETE FROM `smart_scripts` WHERE `entryorguid`=54490 AND `source_type`=0 AND `id`=1 AND `action_param1`=101807;
