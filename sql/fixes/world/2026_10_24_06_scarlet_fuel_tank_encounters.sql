-- Scarlet Monastery, second test run (2026-10-24).
--
-- Fuel Tank (59706) still could not be clicked after 2026_10_24_04 cleared its unselectable flag.
-- Not explained yet. As a fallback the tank now also goes off when a player hits it
-- (npc_scm_fuel_tank, scarlet-monastery.patch): give it the Monster faction (14) so players can attack
-- it, and let the spell click work for anyone, not only friendly players (user_type 0), since the tank
-- is no longer friendly.
UPDATE `creature_template` SET `faction`=14 WHERE `entry`=59706;
UPDATE `npc_spellclick_spells` SET `user_type`=0 WHERE `npc_entry`=59706 AND `spell_id`=114953;

-- Dungeon encounter credit. The only rows for Scarlet Halls and Scarlet Monastery were the classic
-- encounters (448 Herod, 450 Whitemane), which belong to the old maps. So killing Koegler (map 1001) or
-- Whitemane (map 1004) completed no dungeon encounter, and the "Scarlet Halls" / "Scarlet Monastery"
-- achievements and the dungeon finder completion never fired. Add the Mists encounters, as the
-- Pandaria 5.4.8 database has them: 1420 Flameweaver Koegler (last boss of Scarlet Halls, dungeon
-- finder 163) and 1425 High Inquisitor Whitemane (last boss of Scarlet Monastery, dungeon finder 164).
-- The classic rows also claimed to be the last boss of 163 and 164; the core keeps only one last boss
-- per dungeon finder entry and skips the rest, so take that off them.
UPDATE `instance_encounters` SET `lastEncounterDungeon`=0 WHERE `entry` IN (448, 450);
DELETE FROM `instance_encounters` WHERE `entry` IN (1420, 1425);
INSERT INTO `instance_encounters` (`entry`, `creditType`, `creditEntry`, `lastEncounterDungeon`, `comment`) VALUES
(1420, 0, 59150, 163, 'Flameweaver Koegler'),
(1425, 0, 3977, 164, 'High Inquisitor Whitemane');
