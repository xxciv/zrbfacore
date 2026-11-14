-- Battle Pet Training costs 10 silver instead of 10 gold (zrbfacore, 2026-11-14)
-- Found (Four, screenshot): Battle Pet Training (spell 119467, requires level 5) costs 9g 50s at a
--   battle pet trainer, a lot of money for a starter-zone spell.
-- Cause: the 12 battle pet trainer lists in npc_trainer (63014, 63061, 63067, 63070, 63073, 63075,
--   63077, 63080, 63083, 63086, 63596, 63626) list 119467 at MoneyCost 100000 (10g). The client shows
--   9g 50s because Friendly reputation with the trainer's faction takes 5% off.
-- Changed: MoneyCost 100000 -> 1000 (10s) for spell 119467 in npc_trainer, and in trainer_spell in case
--   a later update added it there (the dump has no trainer_spell row for it). Friendly players pay 9s 50c.
--   Restart worldserver afterwards: trainer lists load at startup.
UPDATE `npc_trainer`   SET `MoneyCost` = 1000 WHERE `SpellID` = 119467;
UPDATE `trainer_spell` SET `MoneyCost` = 1000 WHERE `SpellId` = 119467;
SELECT CONCAT((SELECT COUNT(*) FROM `npc_trainer`   WHERE `SpellID` = 119467 AND `MoneyCost` = 1000), ' trainer lists at 10s, ',
              (SELECT COUNT(*) FROM `npc_trainer`   WHERE `SpellID` = 119467 AND `MoneyCost` <> 1000)
            + (SELECT COUNT(*) FROM `trainer_spell` WHERE `SpellId` = 119467 AND `MoneyCost` <> 1000), ' left at another price') AS zr_result;
