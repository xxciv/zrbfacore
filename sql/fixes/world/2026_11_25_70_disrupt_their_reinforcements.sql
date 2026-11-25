-- Disrupt Their Reinforcements (10144 Horde / 10208 Alliance), Hellfire Peninsula.
-- Kingston's Primers (28106 / 28478) cast Detonating Rune Stones 34387 on the portal you click.
-- Effect 0 OPEN_LOCK opens the portal (GOOBER use = objective credit). Effect 1 is a DUMMY with
-- target 38 (nearby entry), which only searches units. Its conditions named the four portal
-- objects, so the search found nothing and the whole cast failed with "You have no target".
-- Point the dummy at the caster instead; the portal is still opened by effect 0.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceGroup`=2 AND `SourceEntry`=34387;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,2,34387,0,0,51,0,6,0,0,0,0,0,'','Detonating Rune Stones - effect 1 dummy targets the caster (portal is opened by effect 0)');
