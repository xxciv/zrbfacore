-- Razorfen Downs (map 129), the idol room by Plaguemaw (Four, 2026-10-31).

-- The room's pile-up is the Extinguishing the Idol event saved as static spawns. Each Idol Room
-- Spawner (8611) summons a Withered Battle Boar or two, a Death's Head Geomancer and a Withered
-- Quilguard per wave, and these 15 sit exactly on the three spawners in that pattern. The same rows
-- are in the Pandaria database; the AzerothCore (classic) database has none. Remove them. The room
-- keeps its own mobs (2 Battle Boars, 2 patrolling Battle Boars, a patrolling Spearhide, a Spearhide,
-- 2 Withered Warriors, a Geomancer, a Battle Boar Horror) and Plaguemaw, and the three spawners
-- stay for the quest event.
DELETE FROM `creature` WHERE `map`=129 AND `guid` IN (325230, 325231, 325232, 325234, 325235, 325236, 325237, 325239, 325240, 325241, 325242, 325243, 325244, 325245, 325246);
DELETE FROM `creature_addon` WHERE `guid` IN (325230, 325231, 325232, 325234, 325235, 325236, 325237, 325239, 325240, 325241, 325242, 325243, 325244, 325245, 325246);

-- Withered Touch (11442) is a damage over time that scales very high here. Every Withered Quilguard
-- had it twice: an aura that procs it on melee hits (11441) and a cast every 17-19 seconds. Plaguemaw
-- had the same (aura 12947 and the cast). Classic Quilguards and Plaguemaw had neither. Remove them.
-- Quilguards keep Enrage at 30%; Plaguemaw keeps Putrid Stench.
UPDATE `creature_addon` SET `auras`=NULL WHERE `auras`='11441' AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id`=7329);
UPDATE `creature_addon` SET `auras`=NULL WHERE `auras`='12947' AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id`=7356);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (7329, 7356) AND `source_type`=0 AND `action_type`=11 AND `action_param1`=11442;

-- Two script versions were mixed together on two of the room's casters, so they cast everything twice.
-- Death's Head Geomancer (7335): drop the second bolt (id 0), Slow (id 10), Flame Spike (id 11), and a
-- stray aggro row linked to the second Slow. Withered Spearhide (7332): drop the second Diseased Shot,
-- Enrage and text (ids 8-10).
DELETE FROM `smart_scripts` WHERE `entryorguid`=7335 AND `source_type`=0 AND (`id` IN (0, 10, 11) OR (`id`=1 AND `event_type`=4));
DELETE FROM `smart_scripts` WHERE `entryorguid`=7332 AND `source_type`=0 AND `id` IN (8, 9, 10);
