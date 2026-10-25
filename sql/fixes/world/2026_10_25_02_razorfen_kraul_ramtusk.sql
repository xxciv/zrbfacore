-- Razorfen Kraul (map 47): Warlord Ramtusk only meleed and threw one Spirit Axe (Four, 2026-10-25).
--
-- Spirit Axe (151312) was his only spell, first after 8-12 seconds and then every 10-20, so a short
-- solo fight saw one. The rest of his script was speech rows whose texts don't exist and a door
-- opener pointing at a gameobject guid that isn't spawned. New script: Spirit Axe at a random player
-- every 10-14 seconds (first after 6-8), plus the kit of the classic Overlord Ramtusk he replaced:
-- Battle Stance out of combat, Battle Shout, and Thunderclap when players are in melee range.
-- The axe's odd texture is the spell's client-side visual; the server can't change it.
DELETE FROM `smart_scripts` WHERE `entryorguid`=74462 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(74462, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 11, 7165, 0, 1, 'Warlord Ramtusk - On Reset - Cast Battle Stance'),
(74462, 0, 1, 0, 0, 0, 100, 0, 1000, 3000, 30000, 45000, 11, 9128, 0, 1, 'Warlord Ramtusk - In Combat - Cast Battle Shout'),
(74462, 0, 2, 0, 0, 0, 100, 0, 6000, 8000, 10000, 14000, 11, 151312, 0, 5, 'Warlord Ramtusk - In Combat - Cast Spirit Axe on random player'),
(74462, 0, 3, 0, 9, 0, 100, 0, 0, 8, 8000, 14000, 11, 15548, 0, 1, 'Warlord Ramtusk - Within 0-8 Range - Cast Thunderclap');
