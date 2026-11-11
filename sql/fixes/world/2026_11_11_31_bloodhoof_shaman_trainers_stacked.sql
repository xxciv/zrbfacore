-- Bloodhoof Village (Mulgore): two Shaman Trainers stand on exactly the same spot.
--
-- Narm Skychaser 3066 (guid 260382) and Tarl Cloudsong 51637 (guid 302648) are both
-- <Shaman Trainer> at -2298.96 -437.742 -5.355, same orientation and phase (MaNGOS Three has the
-- same pair). They are interchangeable: same trainer gossip (menu 4103, npcflag 51), no quests,
-- no per-guid script, no addon. Narm Skychaser is the long-standing Bloodhoof trainer and stays;
-- Tarl Cloudsong's spawn is removed, checked by guid and entry.

DELETE FROM `creature` WHERE `guid` = 302648 AND `id` = 51637;
