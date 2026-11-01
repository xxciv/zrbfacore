-- Warsong Demolisher (32850, level 23, Ashenvale) Flamethrower one-shots players (Four, 2026-10-31).
--
-- Its SmartAI came back to life with 2026_10_31_05. Row id 3 casts Flamethrower (65388) every 14-19 s
-- within 20 yards. 65388 is a vehicle weapon whose damage scales with the caster's level by a large
-- coefficient (about 38.6 direct + 7.7 per tick): at level 23 it hit Four for 764 fire plus a 144 fire
-- tick every second. Remove that row. Flaming Ball (61865, id 2), the out-of-combat ball at trigger
-- NPCs (61864, id 4) and the death explosion (65417, id 4) stay.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 32850 AND `source_type` = 0 AND `id` = 3 AND `action_param1` = 65388;

-- Follow-up (Four, 2026-11-01): without Flamethrower the demolishers stood still and only meleed,
-- and Flaming Ball never fires either. Rows id 0 and id 1 (both "Stop Moving on Aggro", event 4,
-- action 21 with 0) root them in place for a ranged fight they cannot fight. Remove both so they
-- chase their target like a normal melee mob.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 32850 AND `source_type` = 0 AND `id` IN (0, 1) AND `event_type` = 4 AND `action_type` = 21;
