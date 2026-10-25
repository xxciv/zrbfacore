-- Maraudon (map 349): Creeping Sludge left players stuck in combat (Four, 2026-10-24).
--
-- 18 of the 21 Creeping Sludges (12222) carry Poison Shock (22638), an aura that hits everyone within
-- 8 yards every 2 seconds (22595). When it hits a player who walks past without being noticed (for
-- example in stealth), the player is put in combat with the sludge, but the sludge never adds the
-- player to its own threat list. It isn't "engaged", so it neither attacks nor evades, and the combat
-- never ends until the sludge dies. Make the sludge attack whoever its poison hurts: it then either
-- fights that player, or (if it can't see them) drops combat at once like any other mob.
DELETE FROM `smart_scripts` WHERE `entryorguid`=12222 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `target_type`, `comment`) VALUES
(12222, 0, 0, 0, 33, 0, 100, 0, 0, 1000000000, 0, 0, 49, 0, 0, 7, 'Creeping Sludge - On Damaged Target - Attack Start (Poison Shock victims)');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12222;
