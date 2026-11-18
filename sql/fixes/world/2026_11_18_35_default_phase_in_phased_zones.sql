-- World fixes: Darkshore and the Ruins of Gilneas lost every normal spawn (2026-11-18)
-- Four (2026-11-18): "i think you got rid of mobs everywhere": the Blackwood camp, the shore and the Ruins of Auberdine
-- in Darkshore were empty, and so were the Ruins of Gilneas outside the Forward Command battle.
-- Cause: 2026_11_18_30 and 2026_11_18_31 give a quest phase (Darkshore 308/310, Ruins of Gilneas 274/312) to the whole
-- zone. A player who is in a quest phase but not in the default phase 169 only sees spawns of that quest phase
-- (PhaseShift::CanSee: the Unphased flag drops once a non-default phase is added without phase 169), so every
-- normal spawn in the zone disappeared (Four's location readout showed "Phases: 274" only).
-- Fix: both zones always add phase 169 as well, the same way Westfall, the Lost Isles, Kezan and Vashj'ir do.
-- Safe to run twice.

DELETE FROM `phase_area` WHERE `AreaId` IN (148,4706) AND `PhaseId`=169;
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(148,169,'Darkshore - always see unphased creatures (with Shatterspear Vale phases 308/310)'),
(4706,169,'Ruins of Gilneas - always see unphased creatures (with Forward Command phases 274/312)');
