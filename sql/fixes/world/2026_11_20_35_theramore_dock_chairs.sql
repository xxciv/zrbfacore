-- World fixes: Theramore dock, floating ship chairs (Four, 2026-11-20)
-- Same leftover as at Ratchet (2026_11_20_34): the dump has two sniff snapshots of The Lady Mehley (Menethil - Theramore)
-- docked at Theramore, so 18 Wooden Chairs (164759-164767, two copies of the ship's 9) float on the water off the dock.
-- TDB 8.3.7 has none of them, there or on the ship (map 584 has no deck objects in TDB either), and they have no quest role.
-- Removed: the 18 chairs (guids 173730-173747). Safe to run twice.
DELETE FROM `gameobject_addon` WHERE `guid` BETWEEN 173730 AND 173747;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 173730 AND 173747 AND `id` BETWEEN 164759 AND 164767;
