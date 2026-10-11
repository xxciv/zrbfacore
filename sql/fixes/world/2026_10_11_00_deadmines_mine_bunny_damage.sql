-- The two Mine Bunnies in The Deadmines (48338, 48351) melee for about 1,700 at
-- level 15, enough to kill a level 16-17 player in two hits. Their template has
-- DamageModifier 125, the range of Icecrown Citadel raid bosses. Every other elite
-- in the instance sits between 15 and 21 (Ogre Henchman, Ogre Bodyguard and Goblin
-- Overseer are 15), so this brings the bunnies in line with the ogres around them.
--
-- Safe to run twice. worldserver reads creature templates only at startup: restart
-- it after running this.

UPDATE `creature_template` SET `DamageModifier` = 15
WHERE `entry` IN (48338, 48351);
