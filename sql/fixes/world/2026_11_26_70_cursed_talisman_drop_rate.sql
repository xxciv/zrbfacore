-- Cursed Talisman 30157 (Ill Omens 10483 needs 1, Cursed Talismans 10484 needs 12), Bleeding Hollow orcs in
-- Hellfire Peninsula. Rates were 17-25% on the orcs (about 55 kills for 12). Four asked for a better rate
-- (2026-11-26): common orcs now 50% (about 24 kills for 12), named orc leaders 100%. Worgs and boars keep their
-- tiny chances (they don't carry talismans).
UPDATE `creature_loot_template` SET `Chance`=50  WHERE `Item`=30157 AND `Entry` IN (16871,16873,16907,19422,19424); -- Grunt, Dark Shaman, Peon, Necrolyte, Tormentor
UPDATE `creature_loot_template` SET `Chance`=100 WHERE `Item`=30157 AND `Entry` IN (19442,19457);                   -- Worg Master Kruush, Grillok "Darkeye"
