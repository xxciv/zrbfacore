-- Shadowfang Keep: show only your own faction's allies, and only for the stage you're at.
--
-- The keep has an Alliance version (Packleader Ivar Bloodfang and his Bloodfang
-- worgen) and a Horde version (Deathstalker Commander Belmont, High Warlord
-- Cromush and the Forsaken), and both move forward through the keep as each boss
-- dies. The database spawns every copy of both at once: an Alliance player saw
-- Belmont and the Forsaken at the door (hostile to Alliance), and the Horde
-- disease clouds were up everywhere from the start.
--
-- This puts each copy in a spawn group, using the group ids and stages of the
-- Cataclysm Preservation Project (TrinityCore 4.3.4). shadowfang-fixes.patch
-- decides from the team in the instance and the bosses killed which groups are
-- shown, and keeps the rest out of sight. The groups are plain groups (flags 0):
-- they spawn exactly as before, so without the patch nothing changes.
--
-- HavenCore has no copy of the Alliance "after Silverlaine" troops (group 423),
-- and its "after Springvale" copy is one group of 7 where CPP had two (425, plus
-- 426 that an areatrigger spawned); both are group 425 here.
--
-- Also: the Veteran Forsaken Trooper (47030) and Forsaken Blightspreader (47031)
-- templates had Permanent Feign Death (29266), so every Forsaken lay on the floor
-- as a corpse, and the Blightspreader also carried the feign death unit flag.
-- Only the dead troops outside Godfrey's room should be corpses, and they have
-- the aura on their own spawns. Belmont's template had Stealth (58506) and
-- Cromush's had kneel (bytes1 8); only one spawn of each should, and those have
-- it on the spawn.
--
-- Needs shadowfang-fixes.patch built in to have any effect on what is shown.
--
-- Revert:
--   DELETE FROM spawn_group WHERE groupId BETWEEN 412 AND 432;
--   DELETE FROM spawn_group_template WHERE groupId BETWEEN 412 AND 432;
--   UPDATE creature_template_addon SET auras = '29266' WHERE entry IN (47030, 47031);
--   UPDATE creature_template_addon SET auras = '58506' WHERE entry = 47293;
--   UPDATE creature_template_addon SET bytes1 = 8 WHERE entry = 47294;
--   UPDATE creature_template SET unit_flags = 512, unit_flags2 = 33556481 WHERE entry = 47031;
--
-- Safe to run twice. worldserver reads these tables only at startup: restart it
-- after running this.

UPDATE `creature_template_addon` SET `auras` = '' WHERE `entry` IN (47030, 47031, 47293);
UPDATE `creature_template_addon` SET `bytes1` = 0 WHERE `entry` = 47294;
UPDATE `creature_template` SET `unit_flags` = 768, `unit_flags2` = 33556480 WHERE `entry` = 47031;

DELETE FROM `spawn_group` WHERE `groupId` BETWEEN 412 AND 432;
DELETE FROM `spawn_group_template` WHERE `groupId` BETWEEN 412 AND 432;
INSERT INTO `spawn_group_template` (`groupId`, `groupName`, `groupFlags`) VALUES
(412, 'Shadowfang Keep - Alliance entrance (Ivar Bloodfang)', 0),
(413, 'Shadowfang Keep - Horde entrance (Belmont)', 0),
(414, 'Shadowfang Keep - Horde disease clouds, entrance', 0),
(415, 'Shadowfang Keep - Horde disease clouds, Baron Ashbury', 0),
(416, 'Shadowfang Keep - Horde disease clouds, Baron Silverlaine', 0),
(417, 'Shadowfang Keep - Horde disease clouds, Commander Springvale', 0),
(418, 'Shadowfang Keep - Horde disease clouds, Lord Walden', 0),
(419, 'Shadowfang Keep - Alliance dead troops at Godfrey', 0),
(420, 'Shadowfang Keep - Horde dead troops at Godfrey', 0),
(421, 'Shadowfang Keep - Alliance troops after Baron Ashbury', 0),
(422, 'Shadowfang Keep - Horde troops after Baron Ashbury', 0),
(424, 'Shadowfang Keep - Horde troops after Baron Silverlaine', 0),
(425, 'Shadowfang Keep - Alliance troops after Commander Springvale', 0),
(427, 'Shadowfang Keep - Alliance troops after Lord Walden', 0),
(428, 'Shadowfang Keep - Horde troops after Springvale or Walden', 0),
(429, 'Shadowfang Keep - Belmont after Commander Springvale', 0),
(430, 'Shadowfang Keep - Belmont after Lord Walden', 0),
(431, 'Shadowfang Keep - Ivar Bloodfang at Godfrey', 0),
(432, 'Shadowfang Keep - Belmont at Godfrey', 0);

INSERT INTO `spawn_group` (`groupId`, `spawnType`, `spawnId`) VALUES
-- 412: 7
(412, 0, 327319),
(412, 0, 327321),
(412, 0, 327322),
(412, 0, 327323),
(412, 0, 327324),
(412, 0, 327326),
(412, 0, 327328),
-- 413: 7
(413, 0, 325948),
(413, 0, 325974),
(413, 0, 325978),
(413, 0, 325981),
(413, 0, 325984),
(413, 0, 325993),
(413, 0, 326002),
-- 414: 37
(414, 0, 325941),
(414, 0, 325942),
(414, 0, 325943),
(414, 0, 325945),
(414, 0, 325946),
(414, 0, 325947),
(414, 0, 325949),
(414, 0, 325950),
(414, 0, 325971),
(414, 0, 325972),
(414, 0, 325973),
(414, 0, 325975),
(414, 0, 325976),
(414, 0, 325977),
(414, 0, 325979),
(414, 0, 325980),
(414, 0, 325982),
(414, 0, 325983),
(414, 0, 325985),
(414, 0, 325986),
(414, 0, 325987),
(414, 0, 325988),
(414, 0, 325989),
(414, 0, 325990),
(414, 0, 325991),
(414, 0, 325992),
(414, 0, 325994),
(414, 0, 325995),
(414, 0, 325996),
(414, 0, 325997),
(414, 0, 325998),
(414, 0, 325999),
(414, 0, 326000),
(414, 0, 326001),
(414, 0, 326003),
(414, 0, 326004),
(414, 0, 326005),
-- 415: 29
(415, 0, 326013),
(415, 0, 326014),
(415, 0, 326016),
(415, 0, 326017),
(415, 0, 326018),
(415, 0, 326019),
(415, 0, 326020),
(415, 0, 326021),
(415, 0, 326022),
(415, 0, 326023),
(415, 0, 326024),
(415, 0, 326025),
(415, 0, 326026),
(415, 0, 326027),
(415, 0, 326028),
(415, 0, 326029),
(415, 0, 326030),
(415, 0, 326031),
(415, 0, 326032),
(415, 0, 326033),
(415, 0, 326034),
(415, 0, 326035),
(415, 0, 326036),
(415, 0, 326037),
(415, 0, 326038),
(415, 0, 326039),
(415, 0, 326040),
(415, 0, 326041),
(415, 0, 326042),
-- 416: 44
(416, 0, 326043),
(416, 0, 326045),
(416, 0, 326049),
(416, 0, 326050),
(416, 0, 326051),
(416, 0, 326052),
(416, 0, 326053),
(416, 0, 326054),
(416, 0, 326055),
(416, 0, 326056),
(416, 0, 326057),
(416, 0, 326059),
(416, 0, 326060),
(416, 0, 326062),
(416, 0, 326063),
(416, 0, 326065),
(416, 0, 326066),
(416, 0, 326067),
(416, 0, 326068),
(416, 0, 326069),
(416, 0, 326070),
(416, 0, 326071),
(416, 0, 326072),
(416, 0, 326073),
(416, 0, 326074),
(416, 0, 326075),
(416, 0, 326077),
(416, 0, 326078),
(416, 0, 326079),
(416, 0, 326080),
(416, 0, 326081),
(416, 0, 326082),
(416, 0, 326083),
(416, 0, 326084),
(416, 0, 326086),
(416, 0, 326087),
(416, 0, 326090),
(416, 0, 326091),
(416, 0, 326092),
(416, 0, 326093),
(416, 0, 326094),
(416, 0, 326101),
(416, 0, 326102),
(416, 0, 326103),
-- 417: 22
(417, 0, 326076),
(417, 0, 326122),
(417, 0, 326125),
(417, 0, 326126),
(417, 0, 326127),
(417, 0, 326128),
(417, 0, 326129),
(417, 0, 326130),
(417, 0, 326132),
(417, 0, 326133),
(417, 0, 326134),
(417, 0, 326135),
(417, 0, 326136),
(417, 0, 326137),
(417, 0, 326138),
(417, 0, 326139),
(417, 0, 326140),
(417, 0, 326141),
(417, 0, 326142),
(417, 0, 326143),
(417, 0, 326144),
(417, 0, 326145),
-- 418: 30
(418, 0, 326154),
(418, 0, 326155),
(418, 0, 326156),
(418, 0, 326157),
(418, 0, 326158),
(418, 0, 326159),
(418, 0, 326160),
(418, 0, 326161),
(418, 0, 326162),
(418, 0, 326163),
(418, 0, 326164),
(418, 0, 326165),
(418, 0, 326166),
(418, 0, 326167),
(418, 0, 326168),
(418, 0, 326169),
(418, 0, 326170),
(418, 0, 326171),
(418, 0, 326172),
(418, 0, 326173),
(418, 0, 326174),
(418, 0, 326175),
(418, 0, 326176),
(418, 0, 326177),
(418, 0, 326179),
(418, 0, 326180),
(418, 0, 326181),
(418, 0, 326182),
(418, 0, 326183),
(418, 0, 326184),
-- 419: 6
(419, 0, 327320),
(419, 0, 327325),
(419, 0, 327327),
(419, 0, 327329),
(419, 0, 327330),
(419, 0, 327331),
-- 420: 7
(420, 0, 326185),
(420, 0, 326186),
(420, 0, 326187),
(420, 0, 326188),
(420, 0, 326189),
(420, 0, 326190),
(420, 0, 326191),
-- 421: 7
(421, 0, 327332),
(421, 0, 327333),
(421, 0, 327334),
(421, 0, 327335),
(421, 0, 327336),
(421, 0, 327337),
(421, 0, 327338),
-- 422: 7
(422, 0, 326006),
(422, 0, 326007),
(422, 0, 326008),
(422, 0, 326009),
(422, 0, 326010),
(422, 0, 326011),
(422, 0, 326012),
-- 424: 8
(424, 0, 326088),
(424, 0, 326089),
(424, 0, 326095),
(424, 0, 326096),
(424, 0, 326097),
(424, 0, 326098),
(424, 0, 326099),
(424, 0, 326104),
-- 425: 7
(425, 0, 327339),
(425, 0, 327340),
(425, 0, 327341),
(425, 0, 327342),
(425, 0, 327343),
(425, 0, 327344),
(425, 0, 327345),
-- 427: 8
(427, 0, 327346),
(427, 0, 327347),
(427, 0, 327348),
(427, 0, 327349),
(427, 0, 327350),
(427, 0, 327351),
(427, 0, 327352),
(427, 0, 327353),
-- 428: 7
(428, 0, 326146),
(428, 0, 326147),
(428, 0, 326148),
(428, 0, 326149),
(428, 0, 326150),
(428, 0, 326151),
(428, 0, 326152),
-- 429: 1
(429, 0, 326105),
-- 430: 1
(430, 0, 326178),
-- 431: 1
(431, 0, 327354),
-- 432: 1
(432, 0, 326192);
