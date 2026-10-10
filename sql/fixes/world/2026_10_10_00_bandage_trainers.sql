-- Alliance bandage trainers (Byancie in Dolanaar, Michelle Belle in Goldshire,
-- Thamner Pol in Kharanos, Anchorite Fateema on Azuremyst and the others on
-- trainer 877) list "Engineering" at the top of their window.
--
-- After worldserver has applied upstream's sql/updates, these NPCs use trainer
-- 877 (2026_09_04_00_world_trainer_mapping_sync.sql; the old trainer 160 is
-- deleted by 2026_08_20_01_world_first_aid_bfa_migration.sql). Trainer 877
-- carries spell 264478, the "Engineering" apprentice spell that belongs on the
-- engineering trainers (102, 126, 405, 406, 407, 873, 993). The Horde bandage
-- trainer 880 doesn't have it. The bandage recipes on 877 are fine.
--
-- worldserver reads trainers only at startup: restart it after running this.

DELETE FROM `trainer_spell` WHERE `TrainerId` = 877 AND `SpellId` = 264478;
