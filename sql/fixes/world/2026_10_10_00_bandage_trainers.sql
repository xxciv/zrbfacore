-- Bandage trainers (Byancie in Dolanaar and the 17 other NPCs on trainer 160)
-- list "Engineering" at the top of their window.
--
-- That row is spell 3279, the old "Apprentice First Aid" skill spell. First Aid
-- was removed in 8.0 and its bandages moved to Tailoring; the 8.3.7 client no
-- longer has a First Aid entry for that id and shows it as Engineering. It is
-- the only spell on trainer 160 with no skill requirement, so every player sees
-- it as trainable. The bandage recipes on the same trainer are fine.
--
-- worldserver reads trainers only at startup: restart it after running this.

DELETE FROM `trainer_spell` WHERE `TrainerId` = 160 AND `SpellId` = 3279;
