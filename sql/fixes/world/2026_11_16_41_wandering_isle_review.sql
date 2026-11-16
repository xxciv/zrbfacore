-- The Wandering Isle review: zone 5736 (starter zones pass, 2026-11-16)
-- Reference: TDB 8.3.7. Critters and wild battle pets are never touched; entries TDB does not spawn here are left alone.
-- Extra creatures: each TDB spawn keeps its nearest match of ours, unmatched extras go down to the TDB count; exact doubles removed.
-- objects standing twice on the same spot: 2 (Kun-pai Ritual Charm 1, Explosive Bundle 1)
DELETE FROM `gameobject` WHERE `guid` IN (
21000500,21000590);
DELETE FROM `gameobject_addon` WHERE `guid` IN (
21000500,21000590);
