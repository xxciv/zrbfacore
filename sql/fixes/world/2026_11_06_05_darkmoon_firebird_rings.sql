-- zrbfacore: Firebird's Challenge (Ziggie Sparks 85546, quest 36481 "Collect 15 rings while
-- flying"). Four: "Ziggie Sparks, Firebird challenge, no rings". Wings of Flame (170819)
-- triggers Summon Rings (170817) every 2.5 s, a script effect with no script, and the ring
-- spell's areatrigger (170815, spell misc 3069) had no template. Goes with the updated
-- tools/bfa/darkmoon-faire-gossip.patch (spell_darkmoon_firebird_summon_rings,
-- at_darkmoon_firebird_ring). The ring is a 5-yard sphere; areatrigger id 3069 was unused.
-- Safe to run more than once.
DELETE FROM `spell_script_names` WHERE `spell_id`=170817 AND `ScriptName`='spell_darkmoon_firebird_summon_rings';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (170817,'spell_darkmoon_firebird_summon_rings');

DELETE FROM `areatrigger_template` WHERE `Id`=3069;
INSERT INTO `areatrigger_template` (`Id`,`Type`,`Flags`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`ScriptName`,`VerifiedBuild`) VALUES
(3069,0,0,5,5,0,0,0,0,'at_darkmoon_firebird_ring',0);

DELETE FROM `spell_areatrigger` WHERE `SpellMiscId`=3069;
INSERT INTO `spell_areatrigger` (`SpellMiscId`,`AreaTriggerId`,`MoveCurveId`,`ScaleCurveId`,`MorphCurveId`,`FacingCurveId`,`AnimId`,`AnimKitId`,`DecalPropertiesId`,`TimeToTarget`,`TimeToTargetScale`,`VerifiedBuild`) VALUES
(3069,3069,0,0,0,0,0,0,0,0,0,0);
