-- Conditions written with the wrong object type id (Quest Fixes thread, 2026-11-17)
--
-- The core has two "object is of type X with entry Y" conditions:
--   31 = legacy type ids (3 unit, 4 player, 5 gameobject)
--   51 = current type ids (5 unit, 6 player, 8 gameobject)
-- 154 rows used type 31 with value 5 while meaning a creature (comments like "Require unit",
-- value 2 is a creature entry). The core read them as "gameobject", so the spell or spellclick
-- they guard could never find its target. Found through Necessary Roughness on Kezan.
-- 23 more rows used type 51 with the legacy unit id 3 (read as an Azerite item).

-- one row already has a correct twin
DELETE a FROM `conditions` a JOIN `conditions` b
  ON a.`SourceTypeOrReferenceId`=b.`SourceTypeOrReferenceId` AND a.`SourceGroup`=b.`SourceGroup` AND a.`SourceEntry`=b.`SourceEntry`
 AND a.`SourceId`=b.`SourceId` AND a.`ElseGroup`=b.`ElseGroup` AND a.`ConditionTarget`=b.`ConditionTarget`
 AND a.`ConditionValue1`=b.`ConditionValue1` AND a.`ConditionValue2`=b.`ConditionValue2` AND a.`ConditionValue3`=b.`ConditionValue3`
 WHERE a.`ConditionTypeOrReference`=31 AND b.`ConditionTypeOrReference`=51 AND a.`ConditionValue1`=5;

UPDATE `conditions` SET `ConditionTypeOrReference`=51 WHERE `ConditionTypeOrReference`=31 AND `ConditionValue1`=5;
UPDATE `conditions` SET `ConditionValue1`=5 WHERE `ConditionTypeOrReference`=51 AND `ConditionValue1`=3;
