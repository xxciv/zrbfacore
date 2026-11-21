-- Spell focus objects that were never in the world (found with Uther's Blessing, Four 2026-11-20).
-- 278 spawns of 155 invisible spell focus objects (type 8, display 0 or 299: the "TEMP <place>" markers
-- quest items need nearby, e.g. TEMP Darrowshire Town Square, TEMP Tide Pools, TEMP Burning Troll Hut,
-- TEMP Farshire Grain, TEMP Legion Antenna) have a negative spawntimesecs. A negative time means "not
-- spawned until a script spawns it"; no SmartAI row spawns or respawns any of them, so every quest
-- item that needs one says "Requires <place>" at the right spot. Spell focus objects can't be used
-- up, so a positive time keeps them there for good. Visible focus objects (Bank, Witherbark Village,
-- Preserved Threshadon Carcass, Earthbinder's Circle, First Burning Blade Pyre) are left alone.
UPDATE `gameobject` g JOIN `gameobject_template` t ON t.`entry`=g.`id`
SET g.`spawntimesecs`=-g.`spawntimesecs`
WHERE t.`type`=8 AND t.`displayId` IN (0,299) AND g.`spawntimesecs`<0;
