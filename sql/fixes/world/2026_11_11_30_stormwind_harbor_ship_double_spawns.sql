-- Stormwind Harbor, 7th Legion warship (Vereesa Windrunner, Arator the Redeemer, Grand Admiral
-- Jes-Tereth): 14 NPCs are spawned twice on the exact same spot.
--
-- The dump has the ship crew as guids 401232-401247 (sniffed, builds 26365/27101). A later block
-- (guids 300001112-300001158, same build 27101) copies 14 of them with identical entry, position
-- and phase, so the riflemen, marines, Arator and the Grand Admiral each stand twice.
-- The two 7th Legion Cannoneers (300001147, 300001159) only exist in the later block and stay.
-- Vereesa 3000000 and Vindicator Boros 3000003 sit on top of 401233/401231 too, but in phase 7439,
-- which nothing turns on (no phase_area row), so players never see them; they are left alone.
--
-- Removed: the 14 copies from the later block, checked by guid and entry. No creature_addon,
-- formation, waypoint, pool or per-guid script uses them.

DELETE FROM `creature` WHERE
    (`guid` = 300001112 AND `id` = 121753) OR -- Grand Admiral Jes-Tereth (copy of 401236)
    (`guid` = 300001148 AND `id` = 121755) OR -- Arator the Redeemer (copy of 401232)
    (`guid` = 300001123 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401235)
    (`guid` = 300001129 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401247)
    (`guid` = 300001150 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401246)
    (`guid` = 300001153 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401245)
    (`guid` = 300001155 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401244)
    (`guid` = 300001158 AND `id` = 121757) OR -- 7th Legion Marine (copy of 401243)
    (`guid` = 300001119 AND `id` = 121775) OR -- 7th Legion Rifleman (copy of 401242)
    (`guid` = 300001124 AND `id` = 121775) OR -- 7th Legion Rifleman (copy of 401237)
    (`guid` = 300001141 AND `id` = 121775) OR -- 7th Legion Rifleman (copy of 401238)
    (`guid` = 300001143 AND `id` = 121775) OR -- 7th Legion Rifleman (copy of 401239)
    (`guid` = 300001146 AND `id` = 121775) OR -- 7th Legion Rifleman (copy of 401240)
    (`guid` = 300001152 AND `id` = 121775);   -- 7th Legion Rifleman (copy of 401241)
