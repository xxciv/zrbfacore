-- The Wandering Isle: trainees for The Lesson of Stifled Pride 29524 too strong for a level 1 player (Four, 2026-11-16, video)
-- Even one at a time, a trainee killed a level 1 monk (72 health): melee 6-7 every 2 s plus Blackout Kick/Jab every 2 s
-- (TDB 8.3.7's timer), against a trainee with double health. This is the very first fight of the zone.
-- Tuning (our choice, not TDB): half melee damage, and the special attack every 5-7 s instead of every 2 s.
UPDATE `creature_template` SET `DamageModifier`=0.5 WHERE `entry` IN (54586,54587,65470,65471);
UPDATE `smart_scripts` SET `event_param1`=5000,`event_param2`=7000,`event_param3`=5000,`event_param4`=7000
WHERE `source_type`=0 AND `entryorguid` IN (54586,54587,65470,65471) AND `id`=5 AND `event_type`=0;
