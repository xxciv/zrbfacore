-- The Lost Isles: Bomb-Throwing Monkeys 34699 standing in the fly pose
-- Seven spawns had bytes1 50331648 (anim tier 3 = fly) in creature_addon. They stand on the ground,
-- so they floated in the flying animation. Ground anim tier like the other 31 monkeys.
UPDATE `creature_addon` SET `bytes1`=0 WHERE `guid` IN (40000114,40000127,40000134,40000136,40000144,40000234,40000441) AND `bytes1`=50331648;
