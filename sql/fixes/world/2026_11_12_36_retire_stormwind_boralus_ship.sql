-- Retire The Relentless (Stormwind Harbor - Boralus ship, transport 294556, map 2074).
-- It uses the exact same Stormwind pier as The Bravery (176310) in the client's path data, and the two loops
-- have different lengths, so they keep clipping through each other at the pier. It also has no crew data.
-- Players use the Wizard's Sanctum Portal to Boralus (302854) and Boralus' Portal to Stormwind (293552) instead.
-- Run this only after the Wizard's Sanctum fix (2026_11_12_35) works in game.
DELETE FROM `transports` WHERE `entry`=294556;
