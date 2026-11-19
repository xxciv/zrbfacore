-- World fixes: the Ticking Time Bomb can be seen (2026-11-18, run after 2026_11_18_43)
-- Four (screenshot): "the bomb is not visible, and its health bar is in the air".
-- The bomb creature 42776 uses an invisible trigger model (display 15294, scaled 2.25, so its health
-- bar floats high). The bomb you see is the 5-second area effect Ticking Time Bomb 79727 (periodic dummy
-- at the caster's feet), which nothing ever cast: TDB 8.3.7 only casts Explosion 79728.
-- 1. As it lands the bomb casts 79727 on itself (new row id 4, linked from the landing row id 3). The
--    effect goes away with the bomb when it despawns 1 second after the explosion.
-- 2. Our own tuning: the invisible bomb creature can't be selected (unit_flags |= 0x02000000), so its
--    floating health bar and name no longer show.
-- Safe to run twice.
DELETE FROM `smart_scripts` WHERE `entryorguid`=42776 AND `source_type`=0 AND `id` IN (3,4);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`target_type`,`comment`) VALUES
(42776,0,3,4,61,0,100,1,0,0,0,0,103,1,0,1,'Ticking Time Bomb - Linked - Root'),
(42776,0,4,0,61,0,100,1,0,0,0,0,11,79727,2,1,'Ticking Time Bomb - Linked - Cast Ticking Time Bomb (visible bomb, triggered)');
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x02000000 WHERE `entry`=42776;
