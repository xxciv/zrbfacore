-- Astranaar has no Alliance flight master: Daelyshia (4267, spawn 239983) lies dead (Four, 2026-11-01).
--
-- Her BFA template was sniffed while she was a corpse in a war phase: npcflag 0 (no gossip, no taxi),
-- unit_flags 0x20040300 (stunned + feign-death bit), unit_flags2 0x801 (feign death), unit_flags3 0x2000.
-- The Pandaria 5.4.8 DB has her alive as npcflag 8193 (gossip + flight master), unit_flags 0x200,
-- unit_flags2 0x800. Restore a living flight master. Gossip menu 0 already carries the
-- "I want to travel fast" option (OptionNpcflag 8192), so gossip_menu_id stays 0.
UPDATE `creature_template` SET `npcflag` = 8193, `unit_flags` = 768, `unit_flags2` = 2048, `unit_flags3` = 0
WHERE `entry` = 4267;
