-- Creature type stored in the family column (236 creatures, entries 3-660)
--
-- In the BFA dump, these creature_template rows have type = 0 ("None") and the real creature type in
-- the family column (Bloodscalp Warrior 587: type 0, family 7, where 7 is Humanoid). A creature with
-- type 0 is not a Humanoid/Beast/Undead/... to the core, so spells limited to a creature type fail on
-- it: Sap, Polymorph, Hibernate, Shackle Undead, Banish, Turn Evil, Scare Beast and others. The
-- beasts among them also lost their pet family (boars, spiders, carrion birds, wolves).
--
-- Each row gets the type and family from the alexkulya Pandaria 5.4.8 world DB (world_04_03_2023),
-- which agrees with the shifted value for all 236. Only rows still at type 0 are changed, so this is
-- safe to run twice.
-- Revert: UPDATE `creature_template` SET `family` = `type`, `type` = 0 WHERE `entry` IN (<same lists>);

-- Beast, family 1 (4 creatures)
UPDATE `creature_template` SET `type` = 1, `family` = 1 WHERE `type` = 0 AND `entry` IN (
    118, 213, 521, 565);

-- Beast, family 3 (7 creatures)
UPDATE `creature_template` SET `type` = 1, `family` = 3 WHERE `type` = 0 AND `entry` IN (
    442, 471, 505, 539, 569, 574, 616);

-- Beast, family 5 (6 creatures)
UPDATE `creature_template` SET `type` = 1, `family` = 5 WHERE `type` = 0 AND `entry` IN (
    113, 119, 330, 345, 454, 524);

-- Beast, family 7 (3 creatures)
UPDATE `creature_template` SET `type` = 1, `family` = 7 WHERE `type` = 0 AND `entry` IN (
    154, 199, 462);

-- Dragonkin, family 0 (1 creature)
UPDATE `creature_template` SET `type` = 2, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    397);

-- Elemental, family 0 (3 creatures)
UPDATE `creature_template` SET `type` = 4, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    92, 329, 575);

-- Undead, family 0 (15 creatures)
UPDATE `creature_template` SET `type` = 6, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    3, 48, 202, 203, 210, 302, 315, 392, 511, 522, 604, 623, 624, 625, 626);

-- Humanoid, family 0 (193 creatures)
UPDATE `creature_template` SET `type` = 7, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    6, 40, 46, 54, 60, 61, 66, 74, 78, 79, 80, 95, 97, 98, 99, 100, 117, 121, 122, 123, 124, 126, 127,
    151, 152, 167, 171, 190, 196, 197, 198, 205, 206, 212, 218, 222, 223, 225, 226, 227, 228, 232, 234,
    235, 237, 238, 239, 240, 241, 244, 246, 247, 248, 250, 251, 252, 253, 255, 257, 258, 261, 263, 264,
    265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 276, 278, 285, 288, 289, 294, 295, 300, 313, 325,
    327, 328, 332, 334, 341, 342, 343, 344, 346, 347, 348, 372, 374, 375, 377, 379, 381, 382, 383, 384,
    391, 415, 422, 423, 424, 426, 429, 430, 431, 432, 433, 434, 435, 436, 437, 445, 446, 448, 449, 452,
    453, 456, 458, 459, 460, 464, 465, 466, 468, 469, 472, 473, 474, 475, 476, 478, 486, 487, 488, 489,
    490, 494, 495, 499, 500, 501, 504, 506, 507, 513, 514, 515, 517, 518, 519, 520, 523, 533, 534, 543,
    544, 545, 548, 568, 576, 578, 579, 580, 583, 584, 587, 588, 589, 590, 594, 595, 596, 597, 599, 603,
    615, 633, 636, 645, 646, 647, 648, 657, 658, 660);

-- Critter, family 0 (1 creature)
UPDATE `creature_template` SET `type` = 8, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    582);

-- Mechanical, family 0 (3 creatures)
UPDATE `creature_template` SET `type` = 9, `family` = 0 WHERE `type` = 0 AND `entry` IN (
    114, 115, 573);
