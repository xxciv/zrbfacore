-- zrbfacore: The Tauren Chieftains on the Darkmoon Faire stage (Bergrisst 23619, Chief
-- Thunder-Skins 23623, Mai'Kyl 23624, Samuro 23625, Sig Nicious 23626; the same entries play
-- in Shattrath and Blackrock Depths). Four, 2026-11-06: "Bergrisst has unholy armor proccing
-- constantly ... After a while they all disappear ... but Bergrisst is still on stage".
-- Their show is a ~280 s list of one-shot timed events (out of combat). It ran once after a
-- restart: at 280.8 s everyone casts Greater Invisibility (16380) and nothing ever brought
-- them back. Each member's first event cast 89344, meant as "Clear Target Auras", but in
-- 8.3.7 spell 89344 is "Armor" (an aura with its own sound); Bergrisst's row also repeated
-- every second, so it played nonstop and he stayed visible.
-- Now: every timed event repeats every 300 s, so the show loops (20 s break after the
-- vanish), and the 89344 casts are replaced by removing Greater Invisibility, so each member
-- reappears at their entrance flare. Safe to run more than once.
UPDATE `smart_scripts` SET `event_flags`=0, `event_param3`=300000, `event_param4`=300000
WHERE `entryorguid` IN (23619,23623,23624,23625,23626) AND `source_type`=0 AND `event_type`=1;

UPDATE `smart_scripts` SET `action_type`=28, `action_param1`=16380, `action_param2`=0,
`comment`=CONCAT(SUBSTRING_INDEX(`comment`,' - ',1),' - Show starts - Remove Greater Invisibility')
WHERE `entryorguid` IN (23619,23623,23624,23625,23626) AND `source_type`=0 AND `action_type`=11 AND `action_param1`=89344;
