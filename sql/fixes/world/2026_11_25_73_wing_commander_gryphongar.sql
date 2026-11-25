-- Wing Commander Gryphongar (10344, Alliance): Runetog Wildhammer 20234 -> Wing Commander Gryphongar 20232 at Shatter Point.
-- The quest has no objectives but SpecialFlags 2 (needs an explore/event credit). TDB gives that credit by casting
-- 35237 on accept, but 35237 is a serverside spell with no effects here, and our accept row instead summoned an
-- Enraged Gryphon 9526 (comment "Quest Credit on Quest Add"). So the quest never completed and Gryphongar showed a
-- grey "?". Make it a plain "speak with" quest; this also completes copies already in a quest log after a restart.
UPDATE `quest_template_addon` SET `SpecialFlags`=`SpecialFlags`&~2 WHERE `ID`=10344;
-- The accept row only spawned a stray gryphon and no longer has a credit to give (SAI quest credit needs flag 2).
DELETE FROM `smart_scripts` WHERE `entryorguid`=20234 AND `source_type`=0 AND `id`=0 AND `link`=0 AND `event_type`=19 AND `event_param1`=10344;
