-- zrbfacore: Shooting Gallery targets (54231) still showed "[DND] Darkmoon Shooting Gallery"
-- over their heads after the name flags in 2026_11_06_15 (Four, 2026-11-06). The client does
-- not draw names on units that can't be selected (Carl's cart and balloon bunny already show
-- none for that reason), so the targets get UNIT_FLAG_NOT_SELECTABLE (0x02000000). Shooting
-- still works: the Shoot script picks its target itself. Delete the client Cache folder.
-- Safe to run more than once.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x02000000 WHERE `entry`=54231;
