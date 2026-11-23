-- World fixes: Cape of Stranglethorn, Digsite Zombie Survivors (Four, 2026-11-20)
-- Digsite Zombie 52604 and Digsite Zombie Survivor 52870 belong to Bwemba's 4.1 quest Voodoo Zombies (29150 / 29237):
-- killing a zombie summons a survivor, which should then despawn. Bwemba 52234 has no spawn in our DB or in TDB 8.3.7,
-- and TDB 8.3.7 has none of these creatures. The 10 static survivors are left-over summons that never despawn
-- (their despawn waits for a creature_text line that does not exist), so they stand at the Explorers' League Digsite.
-- Removed: the 10 static survivors only. No quest needs them (credit comes from killing the zombie, which still
-- summons a survivor). The 3 Digsite Zombies at Gurubashi Arena are kept because they are the quest's kill target.
-- Safe to run twice.
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 307982 AND 307991;
DELETE FROM `creature` WHERE `guid` BETWEEN 307982 AND 307991 AND `id`=52870;
-- Our own tuning: a survivor summoned by a zombie kill (manual despawn) waited for the same missing text and never left.
-- It now despawns 5 seconds after it appears.
UPDATE `smart_scripts` SET `link`=0,`action_type`=41,`action_param1`=5000,`action_param2`=0,`comment`='Digsite Zombie Survivor - On Reset - Despawn after 5 s'
WHERE `entryorguid`=52870 AND `source_type`=0 AND `id`=0;
