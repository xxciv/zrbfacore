-- Razorfen Kraul (map 47): Groyat's Sonic Field did nothing (Four, 2026-10-25).
--
-- Sonic Field (151432) only has a dummy effect, which needs a spell script this core doesn't have.
-- Use Sonic Burst (8281) instead, the classic Blind Hunter's area attack that Groyat replaced:
-- weapon damage and a short silence on everyone within 13 yards, every 12-16 seconds.
UPDATE `smart_scripts` SET `action_param1`=8281, `event_param1`=6000, `event_param2`=8000, `event_param3`=12000, `event_param4`=16000, `target_type`=1,
  `comment`='Groyat - In Combat - Cast Sonic Burst (stands in for dummy-only Sonic Field)'
WHERE `entryorguid`=75247 AND `source_type`=0 AND `id`=2 AND `action_type`=11 AND `action_param1` IN (151432, 8281);
