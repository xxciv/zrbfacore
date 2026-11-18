-- Kezan review: zone 4737 (starter zones pass, 2026-11-16)
-- Reference: TDB 8.3.7. Critters and wild battle pets are never touched; entries TDB does not spawn here are left alone.
-- Extra creatures: each TDB spawn keeps its nearest match of ours, unmatched extras go down to the TDB count; exact doubles removed.
-- creatures removed: 1 (Kezan Citizen 1)
DELETE FROM `creature` WHERE `guid` IN (
21016079);
DELETE FROM `creature_addon` WHERE `guid` IN (
21016079);
-- objects standing twice on the same spot: 3 (Kezan Small Fire - Phase 7 2, Kezan Large Fire - Phase 7 1)
DELETE FROM `gameobject` WHERE `guid` IN (
21003757,21003799,21003800);
DELETE FROM `gameobject_addon` WHERE `guid` IN (
21003757,21003799,21003800);
