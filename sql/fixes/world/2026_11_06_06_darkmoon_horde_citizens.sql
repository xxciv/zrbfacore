-- zrbfacore: Horde Citizens (55348) on Darkmoon Island looked like humans. Four: "Horde
-- Citizens should appear as horde races". Their models are the Stormwind citizen pair
-- (1501, 21621); retail dresses them with Citizen Costume (71084, cast by their SAI), a
-- transform with no creature set, which the core ignores. Give them Horde civilian models
-- from existing Horde citizens: orc (Orgrimmar Citizen 1370/31416), troll (Troll Citizen
-- 2588/2589), blood elf (Silvermoon Citizen 18211/18212), Forsaken (Undercity Citizen
-- 34459/25893). Each spawn picks one at random. Safe to run more than once.
DELETE FROM `creature_template_model` WHERE `CreatureID`=55348;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(55348,0,1370,1,1,0),
(55348,1,31416,1,1,0),
(55348,2,2588,1,1,0),
(55348,3,2589,1,1,0),
(55348,4,18211,1,1,0),
(55348,5,18212,1,1,0),
(55348,6,34459,1,1,0),
(55348,7,25893,1,1,0);
