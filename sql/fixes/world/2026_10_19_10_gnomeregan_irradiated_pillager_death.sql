-- Gnomeregan: Irradiated Pillager (6329) kept players in combat after it died, 2026-10-19
-- Four's run: right after killing one, `.debug combat` still showed "[PvE] Irradiated Pillager (SpawnID
-- 324438)" and the player stayed in combat until `.combatstop`.
-- Two SmartAI rows (ids 2 and 5, from two script versions) cast Radiation (9798) when it dies. In 8.3.7
-- 9798 puts a permanent (duration index 21) aura on every enemy within 13 yards that triggers Radiation
-- (9770) damage every 3 s, with the dead Pillager as caster, so each tick put the player back in combat
-- with the corpse. The living Pillager's own Radiation auras (9769, and 9798 on some spawns, from
-- creature_addon and On Reset) are unchanged; only the casts on death go.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 6329 AND `source_type` = 0 AND `id` = 2 AND `event_type` = 6 AND `action_param1` = 9798;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 6329 AND `source_type` = 0 AND `id` = 5 AND `event_type` = 61 AND `action_param1` = 9798;
