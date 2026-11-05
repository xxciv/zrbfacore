-- zrbfacore: Darkmoon Faire follow-ups from Four's first race (2026-11-05)

-- 1. Race course bunnies showed their names ("Powerup Bunny Checkpoint", ...) over
-- the course. Hide the name and nameplate (type_flags DO_NOT_RENDER_OBJECT_NAME
-- 0x40000000 | HIDE_NAME_PLATE 0x00100000) and make them unselectable
-- (unit_flags NOT_SELECTABLE 0x02000000). The client caches creature data:
-- delete the WoW client's Cache folder after this.
UPDATE `creature_template` SET `type_flags`=`type_flags`|0x40100000, `unit_flags`=`unit_flags`|0x02000000
WHERE `entry` IN (75718, 75044, 74153, 74157, 74678, 74800, 74872, 75063, 74536, 74260, 74261, 74262, 74263, 74420);

-- 2. Darkmoon Game Prize (93724, the reward of every Faire game daily and race) was
-- empty most of the time: its 14 rows are all independent small chances (about 29%
-- in total), and the prize ticket was missing. On retail it always holds a Darkmoon
-- Prize Ticket (currency 515); the Pandaria 5.4.8 DB gives 1 ticket for each game
-- daily. A negative Item is a currency in this core's loot tables.
DELETE FROM `item_loot_template` WHERE `Entry`=93724 AND `Item`=-515;
INSERT INTO `item_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(93724, -515, 0, 100, 0, 1, 0, 1, 1, 'Darkmoon Game Prize - Darkmoon Prize Ticket (currency 515)');
