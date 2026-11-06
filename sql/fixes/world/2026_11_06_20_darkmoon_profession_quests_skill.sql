-- zrbfacore: Darkmoon Faire profession quests hidden from low-skill players (Four, 2026-11-06:
-- "Stamp Thunderhorn is only a vendor here"). Each of the 14 profession quests has a condition
-- (type 7, skill) asking for 75 points in the profession's parent skill, a Cataclysm-era rule.
-- In Battle for Azeroth the quests only need the profession (quest_template_addon already has
-- RequiredSkillPoints 1), so the conditions now ask for 1 point. Safe to run more than once.
-- 29506 A Fizzy Fusion (Alchemy 171), 29507 Fun for the Little Ones (Archaeology 794),
-- 29508 Baby Needs Two Pair of Shoes (Blacksmithing 164), 29509 Putting the Crunch in the Frog
-- (Cooking 185), 29510 Putting Trash to Good Use (Enchanting 333), 29511 Talkin' Tonks
-- (Engineering 202), 29513 Spoilin' for Salty Sea Dogs (Fishing 356), 29514 Herbs for Healing
-- (Herbalism 182), 29515 Writing the Future (Inscription 773), 29516 Keeping the Faire Sparkling
-- (Jewelcrafting 755), 29517 Eyes on the Prizes (Leatherworking 165), 29518 Rearm, Reuse,
-- Recycle (Mining 186), 29519 Tan My Hide (Skinning 393), 29520 Banners, Banners Everywhere!
-- (Tailoring 197).
UPDATE `conditions` SET `ConditionValue2`=1
WHERE `SourceTypeOrReferenceId`=19 AND `ConditionTypeOrReference`=7 AND `ConditionValue2`=75
  AND `SourceEntry` IN (29506,29507,29508,29509,29510,29511,29513,29514,29515,29516,29517,29518,29519,29520);
UPDATE `conditions` SET `Comment`=REPLACE(`Comment`,'at least 75 skill points','at least 1 skill point')
WHERE `SourceTypeOrReferenceId`=19 AND `ConditionTypeOrReference`=7
  AND `SourceEntry` IN (29506,29507,29508,29509,29510,29511,29513,29514,29515,29516,29517,29518,29519,29520);
