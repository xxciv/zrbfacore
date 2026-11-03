-- Razorfen Downs (map 129): Amnennar never appeared after Blackthorn died (Four, 2026-11-03).
--
-- Blackthorn's death row (id 1) says a line and links to the summon row (id 2, a linked-only
-- event). None of the Warlords bosses has any creature_text, so SmartAI drops every "say" row at
-- startup, and with it the start of the chain: the summon never ran. Make the summon its own death
-- event and drop the say row. Mushlump's and Mordresh's death rows had the same shape (their
-- linked rows clear Mushlump's plague triggers and open Mordresh's GO); fix those the same way.
-- Blackthorn's step itself already completed (Four's .debug scenario: step 1173 state 3).
DELETE FROM `smart_scripts` WHERE `entryorguid`=74875 AND `source_type`=0 AND `id`=1 AND `action_type`=1;
UPDATE `smart_scripts` SET `event_type`=6 WHERE `entryorguid`=74875 AND `source_type`=0 AND `id`=2 AND `action_type`=12;

DELETE FROM `smart_scripts` WHERE `entryorguid`=74435 AND `source_type`=0 AND `id`=1 AND `action_type`=1;
UPDATE `smart_scripts` SET `event_type`=6 WHERE `entryorguid`=74435 AND `source_type`=0 AND `id`=2 AND `action_type`=51;

DELETE FROM `smart_scripts` WHERE `entryorguid`=74347 AND `source_type`=0 AND `id`=2 AND `action_type`=1;
UPDATE `smart_scripts` SET `event_type`=6 WHERE `entryorguid`=74347 AND `source_type`=0 AND `id`=3 AND `action_type`=9;
