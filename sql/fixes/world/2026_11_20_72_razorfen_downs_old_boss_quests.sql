-- Razorfen Downs: Partners in Crime 27024 and The Coldbringer 27009 could no longer be completed
-- (audit of our own fixes, 2026-11-20, Four's rule: nothing tied to a quest may be dropped).
--
-- 2026_10_31_01_razorfen_downs replaced the classic boss spawns with the Warlords bosses the dungeon's
-- scenario needs (Tuten'kash 7355 -> Aarux 74412, Mordresh 7357 -> 74347, Glutton 8567 -> Mushlump
-- 74435, Amnennar 7358 -> Blackthorn 74875, whose death summons Amnennar 74434). The quests players
-- actually get are still the Cataclysm ones from Koristrasza 44837 (spawned), which ask for the classic
-- boss entries; the Warlords quests 33513/33514 come from the Warlords Koristrasza 74367, who has no spawn.
-- Give each Warlords boss the matching classic boss as kill credit, so one kill counts for both.
UPDATE `creature_template` SET `KillCredit1`=7355 WHERE `entry`=74412; -- Aarux       -> Tuten'kash
UPDATE `creature_template` SET `KillCredit1`=7357 WHERE `entry`=74347; -- Mordresh    -> Mordresh (classic)
UPDATE `creature_template` SET `KillCredit1`=8567 WHERE `entry`=74435; -- Mushlump    -> Glutton
UPDATE `creature_template` SET `KillCredit1`=7358 WHERE `entry`=74434; -- Amnennar    -> Amnennar (classic)
