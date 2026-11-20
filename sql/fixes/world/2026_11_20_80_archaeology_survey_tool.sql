-- Archaeology: green survey tool name (Four, 2026-11-20). Run against bfa_world.
--
-- Found: the green Survey Tool 204272 (find under 35 yards) is named 'Pointeur de test d'archéologie' in the
-- dump, a French test name, so its tooltip shows that instead of the name the yellow 206589 and red 206590
-- tools have.
-- Changed: name 'Survey Tool (Green)'. Safe to run twice.

UPDATE `gameobject_template` SET `name` = 'Survey Tool (Green)' WHERE `entry` = 204272;
