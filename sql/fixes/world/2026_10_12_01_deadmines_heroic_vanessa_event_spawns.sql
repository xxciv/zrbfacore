-- Vanessa VanCleef's encounter and her nightmare event are Heroic-only, but
-- their spawns are set for Normal too (spawnDifficulties '1,2'). On Normal, the
-- nightmare Vanessas (49671) put every player nearby into combat with themselves,
-- which blocks logging out and holds combat through the Foe Reaper room, and a
-- ghostly Ripsnarl (49682) stands outside the door to the ship. This makes these
-- 21 spawns Heroic-only ('2'), like the event's lightning spawns already are:
--
--   49429  Vanessa VanCleef (ship intro)       326855
--   49454  Vanessa's Trap Bunny                 326857
--   49457  Steam Valve                          326856, 326858, 326859, 326860
--   49552  Vanessa's Rope Anchor                326765, 326766, 326767, 326768, 326769
--   49670  Glubtok (nightmare)                  326861, 326904
--   49671  Vanessa VanCleef (nightmare)         326862, 327028, 327095
--   49674  Helix Gearbreaker (nightmare)        326922
--   49681  Foe Reaper 5000 (nightmare)          327029, 327093
--   49682  Ripsnarl (nightmare)                 327094
--   51624  Vanessa Anchor Bunny JMF             326763
--
-- Revert:
--   UPDATE creature SET spawnDifficulties = '1,2' WHERE map = 36 AND guid IN (326855, 326857, 326856, 326858, 326859, 326860, 326765, 326766, 326767, 326768, 326769, 326861, 326904, 326862, 327028, 327095, 326922, 327029, 327093, 327094, 326763);
--
-- Safe to run twice. Restart worldserver after running this: spawns are read at
-- startup, and an instance that is already open keeps what it has.

UPDATE `creature` SET `spawnDifficulties` = '2'
WHERE `map` = 36 AND `guid` IN (326855, 326857, 326856, 326858, 326859, 326860, 326765, 326766, 326767, 326768, 326769,
                                 326861, 326904, 326862, 327028, 327095, 326922, 327029, 327093, 327094, 326763);
