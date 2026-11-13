-- Dire Maul, Capital Gardens: Magister Kalendris 11487 reset to full health when fought solo.
-- His Dominate Mind (7645) picked a random player (target_type 5). Alone, that is the only player on
-- his threat list: once charmed, he has nobody left to fight, evades and heals to full.
-- Now it picks a random player other than his current target (target_type 6,
-- SMART_TARGET_HOSTILE_RANDOM_NOT_TOP): in a group it still dominates someone, solo it is skipped.
-- Rows 3 and 12 are the two copies of the cast (the dump mixes two script versions for this entry).
UPDATE `smart_scripts` SET `target_type`=6 WHERE `entryorguid`=11487 AND `source_type`=0 AND `id` IN (3, 12) AND `action_type`=11 AND `action_param1`=7645;
