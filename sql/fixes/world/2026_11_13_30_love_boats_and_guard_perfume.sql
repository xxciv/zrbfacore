-- Love is in the Air (game_event 8) pieces that ran outside the holiday (Four, 2026-11-13: love boats in the
-- Darnassus canals, perfumed guards in Stormwind, in November). The event itself was not running; these were never
-- tied to it.
--
-- 1) Love boats (Darnassus Love Boat 37980, Undercity Love Boat 37966). On retail and in TrinityCore TDB 7.3.5 only
--    the two [DND] Love Boat Summoners are spawned, during the event: every 20 s they summon a boat
--    (Love Boat Summon 70863 / 70846) that sails its waypoint path from the summoner and despawns at the end.
--    Our dump also had 22 Darnassus and 17 Undercity boats sniffed mid-canal, and 2026_11_12_30 gave the boats
--    their TDB script (start the path 5 s after spawning), so every static boat crossed the canals to the first
--    waypoint, they bunched up, sailed the loop and despawned, then respawned at their old spots 5 minutes later.
DELETE FROM `game_event_creature` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (37980,37966));
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (37980,37966));
DELETE FROM `creature` WHERE `id` IN (37980,37966);
--    Summoners only during Love is in the Air, standing still on the first waypoint (they wandered 3 yards).
DELETE FROM `game_event_creature` WHERE `guid` IN (357540,357491);
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (8,357540),(8,357491);
UPDATE `creature` SET `MovementType`=0, `spawndist`=0 WHERE `guid` IN (357540,357491);
--    Boarding: TDB clicks with Ride Vehicle 69342 only. Ours also had Ride Vehicle Hardcoded 46598 (a second ride
--    spell on the same click) and Love Boat 69341 (the boat's own periodic aura, which its script already applies).
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (37980,37966) AND `spell_id` IN (46598,69341);

-- 2) Heavily Perfumed (71507). The dump gives Stormwind City Guards 68, Royal Guards 1756, City Patrollers 1976,
--    Melris Malagan 12480, Orgrimmar Grunts 3296 and Darkspear Headhunters 74228 a 25% chance to put it on
--    themselves whenever they reset, all year. Only during Love is in the Air now (CONDITION_ACTIVE_EVENT 8).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceId`=0 AND `ConditionTypeOrReference`=12 AND
  ((`SourceGroup`=23 AND `SourceEntry` IN (68,1756,1976,3296,12480,74228)) OR (`SourceGroup`=1023 AND `SourceEntry`=-266181));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,23,68,0,0,12,0,8,0,0,0,0,0,'','Stormwind City Guard - Heavily Perfumed only during Love is in the Air'),
(22,23,1756,0,0,12,0,8,0,0,0,0,0,'','Stormwind Royal Guard - Heavily Perfumed only during Love is in the Air'),
(22,23,1976,0,0,12,0,8,0,0,0,0,0,'','Stormwind City Patroller - Heavily Perfumed only during Love is in the Air'),
(22,23,3296,0,0,12,0,8,0,0,0,0,0,'','Orgrimmar Grunt - Heavily Perfumed only during Love is in the Air'),
(22,23,12480,0,0,12,0,8,0,0,0,0,0,'','Melris Malagan - Heavily Perfumed only during Love is in the Air'),
(22,23,74228,0,0,12,0,8,0,0,0,0,0,'','Darkspear Headhunter - Heavily Perfumed only during Love is in the Air'),
(22,1023,-266181,0,0,12,0,8,0,0,0,0,0,'','Orgrimmar Grunt 266181 - Heavily Perfumed only during Love is in the Air');
--    The Love Guard Perfume Bunny in Orgrimmar (38288, guid 301908) perfumed nearby guards every 10 minutes all year;
--    the other ten bunnies are already in the event.
DELETE FROM `game_event_creature` WHERE `guid`=301908;
INSERT INTO `game_event_creature` (`eventEntry`,`guid`) VALUES (8,301908);
