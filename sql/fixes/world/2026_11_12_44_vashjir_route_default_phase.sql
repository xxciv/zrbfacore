-- Follow-up to 2026_11_12_40 / 43: a player whose only phase is a quest phase (170) stops seeing every normal,
-- unphased spawn (the core only keeps a player "unphased" while it also has the default phase 169). Durotar and
-- Westfall already give 169 to everyone ("always see unphased creatures"); the other areas that now give phase 170
-- on "Call of Duty" did not, so a player on the quest saw nothing in Vashj'ir or on the sea route.
-- Give phase 169 to everyone there, like Durotar.
DELETE FROM `phase_area` WHERE `PhaseId`=169 AND `AreaId` IN (214,2339,2365,5146);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(214,169,'The Great Sea - always see unphased creatures (with Vashj''ir ship phase 170)'),
(2339,169,'The Great Sea (Stranglethorn) - always see unphased creatures (with Vashj''ir ship phase 170)'),
(2365,169,'The Great Sea (Wetlands) - always see unphased creatures (with Vashj''ir ship phase 170)'),
(5146,169,'Vashj''ir - always see unphased creatures (with Vashj''ir ship phase 170)');
