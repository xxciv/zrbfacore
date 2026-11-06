-- zrbfacore: Darkmoon Faire games, Four's retest 2026-11-06. Goes with the updated
-- tools/bfa/darkmoon-faire-gossip.patch. Safe to run more than once.

-- 1. Shooting Gallery targets (54231) and Tonk Targets (33081) spawned dead (grey names):
-- level 1 with HealthModifier 0.01 rounds to 0 health.
UPDATE `creature_template` SET `HealthModifier`=1 WHERE `entry` IN (54231,33081);

-- 2. The Shooting Gallery's Shoot (101872) had no script name, so hits never gave credit,
-- and no target conditions (cone, creature entry), so it could pick any unit.
DELETE FROM `spell_script_names` WHERE `spell_id`=101872 AND `ScriptName`='spell_shoot_gallery_shoot';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (101872,'spell_shoot_gallery_shoot');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=101872;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,101872,0,0,31,0,3,54231,0,0,0,0,'','Shooting Gallery Shoot - only the gallery targets');

-- 3. The steam tonk's Cannon (102292) only reached things touching the tonk; the new
-- spell_darkmoon_tonk_cannon picks targets up to 30 yards ahead.
DELETE FROM `spell_script_names` WHERE `spell_id`=102292 AND `ScriptName`='spell_darkmoon_tonk_cannon';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (102292,'spell_darkmoon_tonk_cannon');
