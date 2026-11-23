-- Blackrock Depths (map 230): Hurley Blackbreath picks a fight with Ribbly, 2026-11-22. Goes with 2026_11_22_09.
--
-- Four, 2026-11-22: "it almost worked. Hurley decided to go pick a fight with Ribbly and Company."
--
-- Ribbly Screwspigot (9543) and his three cronies (10043) stand 14 yards from Hurley's corner, and their faction
-- (735) is hostile to Hurley's (54). Once Hurley walks out aggressive he attacks them. AzerothCore gives both
-- templates Immune to NPCs (unit_flags 0x200: Ribbly 33344, crony 576), so nothing but players can fight them;
-- this database lost that flag. Added back. Players can still fight them (Ribbly's quest is unchanged).

UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 512 WHERE `entry` IN (9543, 10043);

-- Check
SELECT CONCAT('Ribbly and cronies immune to NPCs ',
    (SELECT COUNT(*) FROM `creature_template` WHERE `entry` IN (9543, 10043) AND `unit_flags` & 512), ' of 2') AS `check`;
