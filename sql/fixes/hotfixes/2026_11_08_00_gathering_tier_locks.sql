-- Caps two Classic ore locks at Classic Mining's 300 (Four, 2026-11-08). Run against bfa_hotfixes.
--
-- Lock 1632 (Small and Large Obsidian Chunk) asked for 305 and 399 (Arcanite Lode) for 310, more than
-- Classic Mining can reach; both now need 300. Every other field is the client's own value.
--
-- The first version of this file also added 38 new herb and ore locks (IDs 5xxxx) for the expansion
-- nodes. The client refused a skill number on them and never tracked them, so the nodes now use
-- Blizzard's own expansion locks instead (world fix of the same name, gathering-tier-locks.patch). This
-- file removes those locks and their hotfix_data rows if you ran the first version.
--
-- hotfix_data: table hash 0xE9BECB23 (3921595171) is Lock.db2; hotfix ids 93xxxxx.
-- Restart worldserver and delete the client Cache folder. Safe to run more than once.
DELETE FROM `lock` WHERE `ID` BETWEEN 50000 AND 59999;
DELETE FROM `hotfix_data` WHERE `TableHash`=3921595171 AND `RecordId` BETWEEN 50000 AND 59999;

DELETE FROM `lock` WHERE `ID` IN (1632, 399);
INSERT INTO `lock` (`ID`, `Index1`, `Index2`, `Index3`, `Index4`, `Index5`, `Index6`, `Index7`, `Index8`, `Skill1`, `Skill2`, `Skill3`, `Skill4`, `Skill5`, `Skill6`, `Skill7`, `Skill8`, `Type1`, `Type2`, `Type3`, `Type4`, `Type5`, `Type6`, `Type7`, `Type8`, `Action1`, `Action2`, `Action3`, `Action4`, `Action5`, `Action6`, `Action7`, `Action8`, `VerifiedBuild`) VALUES
(1632, 3, 0, 0, 0, 0, 0, 0, 0, 300, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35662),
(399, 3, 0, 0, 0, 0, 0, 0, 0, 300, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35662);
DELETE FROM `hotfix_data` WHERE `TableHash`=3921595171 AND `RecordId` IN (1632, 399);
INSERT INTO `hotfix_data` (`Id`, `TableHash`, `RecordId`, `Deleted`, `VerifiedBuild`) VALUES
(9301632, 3921595171, 1632, 0, 35662),
(9300399, 3921595171, 399, 0, 35662);
