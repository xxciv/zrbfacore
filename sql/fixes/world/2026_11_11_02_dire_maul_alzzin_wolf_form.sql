-- Dire Maul (map 429): Alzzin the Wildshaper's wolf phase out-damaged any solo player (Four, 2026-11-11).
--
-- Dire Wolf Form (22660) is a transform plus +75% melee attack speed (aura 138) and +50% damage
-- done (aura 79). With Mangle and Vicious Bite on top, and a random form every 20 seconds since
-- 2026_11_03_04, a wolf phase came round often and could not be out-healed. Alzzin now only takes
-- the wolf's look (Fenrus the Devourer 4274, the creature the spell itself transforms into) and
-- keeps his wolf abilities; no haste, no damage bonus. Tree Form is unchanged.
UPDATE `smart_scripts` SET `action_type`=3, `action_param1`=4274, `action_param2`=0, `comment`='Alzzin the Wildshaper - On Script - Take Dire Wolf Look (no Dire Wolf Form buffs)' WHERE `entryorguid`=1149201 AND `source_type`=9 AND `id`=1;
-- the other two forms first drop the wolf look (Dire Wolf Form itself is never cast any more)
UPDATE `smart_scripts` SET `action_type`=3, `action_param1`=0, `action_param2`=0, `comment`='Alzzin the Wildshaper - On Script - Drop Dire Wolf Look' WHERE `entryorguid` IN (1149200, 1149202) AND `source_type`=9 AND `id`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=11492 AND `source_type`=0 AND `id`=11;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(11492, 0, 11, 0, 25, 0, 100, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Alzzin the Wildshaper - On Reset - Drop Dire Wolf Look');
