-- Uther's Blessing 27169 (Western Plaguelands, Uther's Tomb): reported by Four, 2026-11-20 ("Requires
-- Uther's Tomb Statue" anywhere in the tomb). The item's spell 85752 needs spell focus 1323, the
-- invisible Uther's Tomb Statue 1323 (guid 19147, 5 yd radius, centred in the statue). Its
-- spawntimesecs was -600: a negative respawn time means "not spawned until a script spawns it", and
-- nothing does, so the focus was never in the world (the client hides it too and shows the error).
-- Spell focus objects can't be used up, so a positive time keeps it there for good.
UPDATE `gameobject` SET `spawntimesecs`=300 WHERE `guid`=19147 AND `id`=1323;
