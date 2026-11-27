-- Tainted Helboar Meat 23270 still never showed after 2026_11_27_70. Its loot rows on the four boars also carry a
-- loot condition (quest 9361 taken). This core never shows a loot item that has any loot condition
-- (Loot::BuildLootResponse only lists items whose condition list is empty), so the meat was rolled but hidden.
-- The condition only repeats what the quest gate already does (QuestRequired 1 + quest 9361 ItemDrop1), so remove it.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=1 AND `SourceGroup` IN (16863,16879,16880,16992) AND `SourceEntry`=23270
  AND `ConditionTypeOrReference`=9 AND `ConditionValue1`=9361;
