-- Blackfathom Deeps (redesign): boss spells that did nothing, and the Coiled Rope shortcut.
-- Needs tools/bfa/dungeon-spell-fixes.patch (spell_gen_dummy_cast_base_points).

-- 1. These spells (or the periodic spell they trigger) end in a dummy effect whose base points name the
--    spell that does the work, e.g. Piercing Rain 151814 -> 152884, Foul Tempest 149887 -> 152799.
--    spell_gen_dummy_cast_base_points casts that spell on each target the dummy hits.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_gen_dummy_cast_base_points';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(149887, 'spell_gen_dummy_cast_base_points'), -- Foul Tempest (Domina) -> 152799
(149908, 'spell_gen_dummy_cast_base_points'), -- Catch of the Day (Thruk) -> 149909
(149910, 'spell_gen_dummy_cast_base_points'), -- Catch of the Day (Thruk) -> 149911
(150020, 'spell_gen_dummy_cast_base_points'), -- Restorative Waters (Bathiel) -> 150022, summons Restorative Waters 74569
(151159, 'spell_gen_dummy_cast_base_points'), -- Darkness Calls (Kor'ul) -> 151161, 151172, summon Deep Terrors 75396
(151303, 'spell_gen_dummy_cast_base_points'), -- Tearing the Void (Aku'mai the Devourer) -> 151304, 151313
(151304, 'spell_gen_dummy_cast_base_points'), -- Tearing the Void -> 151305
(151313, 'spell_gen_dummy_cast_base_points'), -- Grip of Darkness -> 151305
(151683, 'spell_gen_dummy_cast_base_points'), -- Static Shock (Ghamoo-Ra, periodic) -> 151684
(151814, 'spell_gen_dummy_cast_base_points'), -- Piercing Rain (Bathiel, periodic) -> 152884
(152753, 'spell_gen_dummy_cast_base_points'), -- Spore Cloud (Guardian of the Deep) -> 152755
(152965, 'spell_gen_dummy_cast_base_points'); -- Falling Debris (Aku'mai) -> 152966

-- 2. Coiled Rope shortcut, by the first prisoners. The Coiled Rope (224627) at the top of the drop was
--    not selectable (flags 0x10; TrinityCore's sniff has 0). Using it drops the rope ladder: the Rope
--    Ladder Post (224747) at the bottom becomes usable, and it casts Rope Ladder Climb (150851), a jump
--    to the nearest creature of an entry the spell's conditions name. That is the Invisible Man 75000
--    (aura Coiled Rope Usable) standing next to the Coiled Rope.
UPDATE `gameobject_template_addon` SET `flags` = 0 WHERE `entry` = 224627;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 224627 AND `source_type` = 1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(224627, 1, 0, 1, 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 106, 16, 0, 0, 0, 0, 0, 15, 224747, 40, 0, 0, 0, 0, 0, 'Coiled Rope - On use - Make Rope Ladder Post usable'),
(224627, 1, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, '', 104, 16, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Coiled Rope - Linked - Not selectable any more');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 150851;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 150851, 0, 0, 31, 0, 3, 75000, 0, 0, 0, 0, '', 'Rope Ladder Climb - jump to the Invisible Man at the top of the rope');
