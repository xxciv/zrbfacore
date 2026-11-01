-- Junk per-spawn SmartAI rows that switched off the creature's own script (passed on from the
-- Dungeon Fixes thread, 2026-10-31).
--
-- 44 creature spawns have a per-spawn row (entryorguid = -guid): out of combat, cast Fel Hands
-- (207101, a Legion dummy aura that does nothing), comment 'OOC - CS'. A per-spawn script replaces
-- the entry's script entirely (SmartScript::OnInitialize only falls back to the entry script when the
-- spawn has none), so these spawns never cast, fled, exploded, etc. Spawns, by map:
--   map 1:   Northwatch Guard 38636 (269452, 269454), Razorfen Thornweaver 7874 (269676),
--            Terrortooth Runner 37083 (269700), Outgrowth 37092 (269707), Siege Tank Engineer 39006
--            (269714), Enervated Adder 37738 (269779), Thunderhawk Cloudscraper 37557 (269832),
--            Honor's Stand Sharpshooter 34848 (269840), Warsong Demolisher 32850 (373782-373785, 373791)
--   map 0:   Rampaging Owlbeast 49245 (373855, 373858, 373860, 373864, 373867-373870)
--   map 530: Grishna Raven 20327 (373539-373545), no entry script, they just lose the dummy row
--   map 90:  Dark Iron Land Mine 8035 (373576-373581), Gnomeregan mines will now detonate
--   map 230: Dark Keeper Uggel 9439 (373572), Theldren 16059 (373573, no entry script)
--   no spawn: 267255, 14521226, 14521228, 14521733, 14521735 (orphan rows, removed too)
-- Razorfen Downs 373574/373575 are fixed by 2026_10_31_04 (PR #26) and left out here.
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `action_type` = 11 AND `action_param1` = 207101
AND `entryorguid` IN (-267255, -269452, -269454, -269676, -269700, -269707, -269714, -269779, -269832,
-269840, -373539, -373540, -373541, -373542, -373543, -373544, -373545, -373572, -373573, -373576,
-373577, -373578, -373579, -373580, -373581, -373782, -373783, -373784, -373785, -373791, -373855,
-373858, -373860, -373864, -373867, -373868, -373869, -373870, -14521226, -14521228, -14521733, -14521735);

-- Northwatch Guard (38636) has two script versions mixed together. Version kept: the ranged one
-- (ids 0-19 linked chain, phase 1 on aggro). Removed: the second Cast Shoot (id 0, in-combat timer),
-- Shield Block (id 1) and Revenge (id 2), which duplicate ids 4, 16 and 17 and would fire twice.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38636 AND `source_type` = 0 AND `link` = 0
AND ((`id` = 0 AND `event_type` = 0) OR (`id` = 1 AND `event_type` = 2) OR (`id` = 2 AND `event_type` = 0));
