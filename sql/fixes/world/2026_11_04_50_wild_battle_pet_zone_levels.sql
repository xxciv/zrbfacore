-- Wild battle pets: let the zone decide the level (zrbfacore, 2026-11-04)
--
-- WildBattlePetMgr::EnableWildBattle rolls a wild pet's level between
-- max(battlepet_info.minlevel, zone min) and max(battlepet_info.maxlevel, zone max),
-- with the zone range taken from AreaTable (WildBattlePetLevelMin/Max).
-- Almost every wild pet template is 1-1, so the zone range decides. These 30
-- wild pet templates were 5-5 or 1-25 instead, so for example every Elwynn Fawn
-- was level 5 (zone 1-2) and a Loch Modan Little Black Ram could roll 3-25
-- (zone 3-6). Setting them to 1-1 makes them follow their zone like the rest.
-- Tamer team pets and companion entries are not touched.
--
-- Old values (to undo, set minlevel/maxlevel back):
--   NpcID  name                          min max
--   61160  Tiny Harvester                  1  25
--   61165  Fawn                            5   5
--   61459  Little Black Ram                1  25
--   61689  Snow Cub                        5   5
--   61703  Tiny Twister                    1  25
--   61826  Blighthawk                      1  25
--   61827  Infected Fawn                   5   5
--   62020  Ruby Sapling                    1  25
--   62051  Ravager Hatchling               1  25
--   62116  Creepy Crawly                   1  25
--   62191  Venomspitter Hatchling          1  25
--   62246  Shimmershell Snail              5   5
--   62258  Silithid Hatchling              1  25
--   62317  Minfernal                       1  25
--   62375  Diemetradon Hatchling           1  25
--   62395  Nether Faerie Dragon            1  25
--   62526  Qiraji Guardling                1  25
--   62555  Flayer Youngling                1  25
--   62669  Fjord Worg Pup                  1  25
--   62816  Stunted Shardhorn               1  25
--   62819  Imperial Eagle Chick            1  25
--   62900  Wildhammer Gryphon Hatchling    1  25
--   62921  Stowaway Rat                    1  25
--   63097  Shore Crawler                   1  25
--   63098  Gilnean Raven                   1  25
--   68804  Harpy Youngling                 1  25
--   68819  Arcane Eye                      1  25
--   68820  Infinite Whelpling              1  25
--   68839  Anodized Robo Cub               1  25
--   68841  Cogblade Raptor                 1  25

UPDATE `battlepet_info` SET `minlevel` = 1, `maxlevel` = 1 WHERE `NpcID` IN (
    61160, 61165, 61459, 61689, 61703, 61826, 61827, 62020, 62051, 62116,
    62191, 62246, 62258, 62317, 62375, 62395, 62526, 62555, 62669, 62816,
    62819, 62900, 62921, 63097, 63098, 68804, 68819, 68820, 68839, 68841);

SELECT CONCAT(ROW_COUNT(), ' wild pet templates set to 1-1') AS zr_result;
