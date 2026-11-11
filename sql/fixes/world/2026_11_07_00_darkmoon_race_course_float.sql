-- Darkmoon races: course bunnies stay at their spawn height (zrbfacore)
--
-- From Four, 2026-11-07 (screenshots and the More Big Racing video): checkpoint banners spawned at
-- sea level (z 0.1-0.9) stood on the sea floor, fully under water. The course entries were
-- InhabitType 3 (ground + water), so the creatures fall to the ground or the sea bed below their
-- spawn point. InhabitType 4 (air) makes the core turn gravity off for them
-- (Creature::UpdateMovementFlags), so they stay where they were spawned: banners at the water
-- surface, everything on land unchanged.
--   75718 checkpoint banner, 75044 tripwire stake, 74153 dash, 74157 jump, 74678 rocket,
--   74800 blink, 74872 loot, 75063 rotating pads, 74362/74365/74368/74369 Racing Posts.
UPDATE `creature_template` SET `InhabitType`=4
WHERE `entry` IN (75718,75044,74153,74157,74678,74800,74872,75063,74362,74365,74368,74369);
