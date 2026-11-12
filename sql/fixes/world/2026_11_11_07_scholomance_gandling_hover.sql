-- Scholomance (map 1007): Darkmaster Gandling 58875 (Rattlegore intro, then above Lilian's room) looked
-- like he was swimming in the air (Four, 2026-11-11). The Pandaria addon value bytes1 50331648 puts
-- 3 in the top byte, which this core reads as animation tier 3 (fly); a humanoid with no fly
-- animation plays the swim one. Tier 2 (hover) floats him standing up. The script no longer moves
-- him through the air either (tools/bfa/scholomance.patch). Safe to run again.
UPDATE `creature_template_addon` SET `bytes1`=33554432 WHERE `entry`=58875;
