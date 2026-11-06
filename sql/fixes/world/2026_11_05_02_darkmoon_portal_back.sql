-- Darkmoon Island: "Portal Back" left the client stuck on the loading screen (Four, 2026-11-05).
--
-- Portal Back (gameobject 216667, two spawns on map 974) is a spellcaster gameobject: using it casts its
-- spell 101260 To the Staging Area! on the player. spell_darkmoon_staging_area_teleport (bound to 101260)
-- sends Horde to Mulgore and Alliance to Elwynn. But the gameobject also had SmartAI that, on the same
-- click, cast 101260 again and 103582 (spell_target_position: Mulgore, map 1) on the player. An Alliance
-- player got three teleports at once, to Elwynn (map 0) and to Mulgore (map 1), and the client hung on
-- the loading screen. The spellcaster cast alone does the job, so the SmartAI goes.
DELETE FROM `smart_scripts` WHERE `entryorguid`=216667 AND `source_type`=1;
UPDATE `gameobject_template` SET `AIName`='' WHERE `entry`=216667;
