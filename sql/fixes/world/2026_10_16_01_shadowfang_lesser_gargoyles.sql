-- Shadowfang Keep: Lesser Gargoyles (3869) on the wall walk never aggro.
-- The world dump marks them CREATURE_FLAG_EXTRA_CIVILIAN (flags_extra 2),
-- which stops a creature from ever starting a fight, although they are
-- hostile (faction 16) and carry loot and gold like any other trash mob.
-- Clear only that bit.
-- Revert: UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 2 WHERE `entry` = 3869;
UPDATE `creature_template` SET `flags_extra` = `flags_extra` & ~2 WHERE `entry` = 3869;
