-- Scarlet Halls: move the arrival spot (dungeon finder and the entrance portal in Tirisfal) to the spot
-- Four picked with .gps on 2026-10-24, inside the entrance hall facing in. Replaces the spot from
-- 2026_10_23_01 (837.23, 615.755, 12.8115).

UPDATE `lfg_dungeon_template` SET `position_x`=821.987, `position_y`=608.059, `position_z`=13.5985, `orientation`=0.021594 WHERE `dungeonId` IN (163, 473);
UPDATE `world_safe_locs` SET `LocX`=821.987, `LocY`=608.059, `LocZ`=13.5985, `Facing`=0.021594 WHERE `ID`=4077;
