-- The Wandering Isle: Jaomin Ro 54611 (The Disciple's Challenge 29409) too strong for a level 1-2 monk (Four/Anvil, 2026-11-16)
-- Level 3, 160 health, melee 4-8 (crits up to 22) against a 72-health player, plus Baby Elephant Takes a Bath (~14) or
-- Hawk Diving to Earth (5-6) every 6-10 s. Level, health and damage modifiers match TDB 8.3.7 (TDB has no script, so he
-- only meleed there; our SmartAI adds the retail specials).
-- Tuning (our choice, not TDB): half melee damage, specials every 10-14 s.
UPDATE `creature_template` SET `DamageModifier`=0.5 WHERE `entry`=54611;
UPDATE `smart_scripts` SET `event_param1`=6000,`event_param2`=8000,`event_param3`=10000,`event_param4`=14000
WHERE `entryorguid`=54611 AND `source_type`=0 AND `id`=9 AND `event_type`=0;
