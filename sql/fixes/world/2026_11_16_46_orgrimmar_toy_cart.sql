-- Orgrimmar, The Drag: stray Toy Cart (Four, 2026-11-16)
-- A static Toy Cart 52812 (guid 299102) with its Toy Cart Bunny 52810 (guid 299103) stood at 1805.8 -4531.8.
-- Blax Bottlerocket 52809 already pulls his own cart: vehicle_template_accessory seats Toy Cart 52812 on him and
-- the bunny on the cart. TDB 8.3.7 spawns only Blax (370878), no loose cart or bunny.
DELETE FROM `creature_addon` WHERE `guid` IN (299102,299103);
DELETE FROM `creature` WHERE `guid` IN (299102,299103) AND `id` IN (52812,52810);
