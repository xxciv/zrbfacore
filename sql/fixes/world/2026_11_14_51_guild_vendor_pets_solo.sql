-- Guild vendor battle pets can be bought without guild progress (zrbfacore, 2026-11-14)
-- Found (Four, screenshots): Shay Pressler 46602 (Stormwind guild vendor) lists heirlooms and shirts
--   but none of the guild battle pets, although npc_vendor has them on every guild vendor.
-- Cause: vendor conditions (SourceTypeOrReferenceId 23) on the 6 pet items need a guild achievement
--   (CONDITION_ACHIEVEMENT 17) and a Guild reputation rank (CONDITION_REPUTATION_RANK 5, faction 1168).
--   ConditionMgr checks the achievement with Player::HasAchieved, i.e. the character's own achievements,
--   while 5031/5201/5812/5840 are guild achievements, so the condition never passes and
--   WorldSession::SendListInventory leaves the item out of the list.
--     63138 Dark Phoenix Hatchling  achievement 5812, Guild rank mask 128 (Exalted)
--     65361 / 65362 Guild Page      achievement 5031, mask 224 (Honored+), Alliance 469 / Horde 67
--     65363 / 65364 Guild Herald    achievement 5201, mask 192 (Revered+), Horde 67 / Alliance 469
--     71033 Lil' Tarecgosa          achievement 5840, mask 128 (Exalted)
-- Changed: the achievement and Guild reputation conditions on these 6 items are deleted on every vendor
--   (10 Cataclysm guild vendors: 46572 46602 51495 51496 51501 51502 51503 51504 51512 52268).
--   The faction conditions (CONDITION_TEAM 6) stay, so each side still sees its own Page and Herald.
--   Other guild vendor items (heirlooms, banners, mounts) keep their conditions.
DELETE FROM `conditions`
 WHERE `SourceTypeOrReferenceId` = 23
   AND `SourceEntry` IN (63138, 65361, 65362, 65363, 65364, 71033)
   AND (`ConditionTypeOrReference` = 17
        OR (`ConditionTypeOrReference` = 5 AND `ConditionValue1` = 1168));
SELECT CONCAT((SELECT COUNT(*) FROM `conditions` WHERE `SourceTypeOrReferenceId` = 23
                 AND `SourceEntry` IN (63138, 65361, 65362, 65363, 65364, 71033)
                 AND `ConditionTypeOrReference` IN (5, 17)), ' guild locks left on guild pets, ',
              (SELECT COUNT(*) FROM `conditions` WHERE `SourceTypeOrReferenceId` = 23
                 AND `SourceEntry` IN (63138, 65361, 65362, 65363, 65364, 71033)
                 AND `ConditionTypeOrReference` = 6), ' faction rows kept') AS zr_result;
