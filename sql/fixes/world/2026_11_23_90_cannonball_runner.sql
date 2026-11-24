-- zrbfacore: Cannonball Runner (item 13382, equip spell 250091) never procs.
-- Needs tools/bfa/cannonball-runner.patch (spell_item_cannonball_runner).
-- The proc row is our own tuning: melee/ranged attacks and harmful spells, 1 proc per minute,
-- at most one cannon every 10 sec (the cannon lasts 10 sec).
DELETE FROM `spell_script_names` WHERE `spell_id` = 250091;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(250091, 'spell_item_cannonball_runner');

DELETE FROM `spell_proc` WHERE `SpellId` = 250091;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(250091, 0, 0, 0, 0, 0, 0, 65876, 0, 2, 0, 0, 0, 1, 0, 10000, 0);

SELECT
  (SELECT COUNT(*) FROM `spell_script_names` WHERE `spell_id` = 250091 AND `ScriptName` = 'spell_item_cannonball_runner') AS `script rows`,
  (SELECT COUNT(*) FROM `spell_proc` WHERE `SpellId` = 250091) AS `proc rows`;
