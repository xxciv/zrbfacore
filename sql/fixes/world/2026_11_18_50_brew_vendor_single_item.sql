-- World fixes: each monthly Brew Vendor sells its brew once (2026-11-18)
-- Four (Ironforge Brew Vendor, after 2026_11_18_49): "offering 2 of the same item, instead of one inventory space".
-- The monthly Brew Vendors 27806, 27810-27820 (Ironforge and outside the Orgrimmar gate) each listed their brew
-- twice: the 37488-37499 item and its same-named copy 37898-37909. 8.3.7 lists one item per vendor:
-- 37488-37499, except Izzard's Ever Flavor at 27810, which is 37899.
-- Safe to run twice.
DELETE FROM `npc_vendor` WHERE `entry` IN (27806,27811,27812,27813,27814,27815,27816,27817,27818,27819,27820) AND `item` BETWEEN 37898 AND 37909;
DELETE FROM `npc_vendor` WHERE `entry`=27810 AND `item`=37489;
