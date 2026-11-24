-- World fixes: Durotar, the Northwatch Marines' Ticking Time Bomb never explodes (2026-11-18)
-- Four: "Northwatch Marine - ticking time bomb, brief graphical element, no functionality, doesn't do damage."
-- Northwatch Marine 39267 casts Ticking Time Bomb 79726, which throws a Ticking Time Bomb 42776 at the target's
-- feet. The bomb's script (same as TDB 8.3.7) casts Explosion 79728 (Fire damage to enemies within 4 yards) the
-- moment it appears, while it is still being added to the world, and despawns 3 seconds later. In game the
-- explosion never lands, and an instant blast would leave no time to step away anyway: the ability's own text is
-- "Explodes after a few seconds, inflicting Fire damage. Tick-tock."
-- Now the bomb ticks for 3 seconds (our own value for "a few seconds"), then explodes (triggered cast, so nothing
-- can block it) and disappears a second later.
-- Four (2026-11-18, second video): "The bomb explosion worked, but it's still 'disappearing' from the world early."
-- The bomb is summoned as a guardian of the Marine, and guardians are aggressive: it ran after Four's imp and
-- dropped out of sight, then exploded wherever it had got to. A bomb doesn't walk, so it now turns passive and
-- rooted as soon as it lands.
-- Four (2026-11-18, screenshot): "the bomb is not visible, and its health bar is in the air". The bomb creature
-- uses an invisible trigger model (display 15294, scaled 2.25, so its health bar floats high). The bomb you see
-- is the 5-second area effect Ticking Time Bomb 79727, which nothing cast (TDB 8.3.7 only casts the explosion):
-- the bomb now casts it on itself as it lands (row id 4). Our own tuning: the invisible creature can't be
-- selected (unit_flags |= 0x02000000), so its floating name and health bar don't show.
-- The same bomb is thrown by Sergeant Curtis 5809, Nethergarde Engineer 5997 and Chief Prospector Hondo 41173.
-- Safe to run twice.

DELETE FROM `smart_scripts` WHERE `entryorguid`=42776 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42776,0,0,1,60,0,100,1,3000,3000,0,0,0,'',11,79728,2,0,0,0,0,1,0,0,0,0,0,0,0,'Ticking Time Bomb - 3 seconds after spawn - Cast Explosion (triggered)'),
(42776,0,1,0,61,0,100,1,0,0,0,0,0,'',41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ticking Time Bomb - Linked - Despawn in 1 second'),
(42776,0,2,3,60,0,100,1,100,100,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ticking Time Bomb - On landing - Set react state passive'),
(42776,0,3,4,61,0,100,1,0,0,0,0,0,'',103,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Ticking Time Bomb - Linked - Root'),
(42776,0,4,0,61,0,100,1,0,0,0,0,0,'',11,79727,2,0,0,0,0,1,0,0,0,0,0,0,0,'Ticking Time Bomb - Linked - Cast Ticking Time Bomb (visible bomb, triggered)');
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x02000000 WHERE `entry`=42776;
