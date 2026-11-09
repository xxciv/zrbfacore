-- Orgrimmar, outside the front gate (Huojin embassy): five Pandaren fall out of the hot air balloon.
--
-- Chao-Ju 2756, Jiming 5029, Winwa 5034, Winsum 16868 and Jising 16869 have one spawn each
-- (guids 300001459, 300001460, 300001469, 300001475, 300001476), sniffed at z 56.7, which is the
-- basket of the tethered balloon about 28 yards above the ground (z 28). The basket is not solid
-- for the server, and their templates are ground-only (InhabitType 3), so the core drops them to
-- the ground below as soon as they spawn.
--
-- Fix: InhabitType 4 (air only). Creature::UpdateMovementFlags then turns gravity off for them
-- (SetDisableGravity), so they stay standing in the basket. They have no movement (MovementType 0)
-- and no other spawns, so nothing else changes.

UPDATE `creature_template` SET `InhabitType` = 4
WHERE `entry` IN (2756, 5029, 5034, 16868, 16869);
