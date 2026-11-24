-- World fixes: stealthed creatures creep on the ground instead of floating (2026-11-19)
-- Four (Northern Stranglethorn, Kurzen Commando): "Kurzen Commandos are floating while in stealth. I think this
-- affects most stealthed units".
-- Their addon rows have bytes1 0x02000000: byte 3 is the animation tier, and 2 is "hover", so the client
-- draws them hovering. The value belongs one byte lower: byte 2 = 0x02 is the "creep" stand flag, the
-- crouched stealth walk. AzerothCore (WotLK) has these same creatures at 131072 (0x00020000, creep);
-- TDB 8.3.7 has the shifted value too.
-- Changed only on stealthed creatures (they cast a stealth spell from SmartAI or their aura list, or
-- AzerothCore gives them the creep flag), 16 creature_template_addon rows and 14 creature_addon rows:
--   templates: Defias Night Runner 215, Shadowhide Assassin 579, Shadow Panther 768, Kurzen Commando 938, Fen Creeper 1040, Elder Shadowmaw Panther 1713, Fallenroot Shadowstalker 4798, Theramore Infiltrator 4834, Stonevault Cave Lurker 4850, Razorfen Stalker 6035, Onin MacHammar 6886, Putridus Shadowstalker 11792, Coldmist Stalker 16170, Stonescythe Ambusher 16928, Fenissa the Assassin 22060, Shadowsword Assassin 25484
--   spawns: Coldmist Stalker 6, Stonescythe Ambusher 4, Daggerfen Assassin 3, Expedition Druid 1
-- The other ~170 hovering creatures (Val'kyr, Shadow Orbs, proto-drakes, elementals...) keep their hover.
-- Safe to run twice.
UPDATE `creature_template_addon` SET `bytes1`=(`bytes1` & 0x00FFFFFF) | 0x00020000 WHERE ((`bytes1`>>24)&0xFF)=2 AND `entry` IN (215,579,768,938,1040,1713,4798,4834,4850,6035,6886,11792,16170,16928,22060,25484);
UPDATE `creature_addon` SET `bytes1`=(`bytes1` & 0x00FFFFFF) | 0x00020000 WHERE ((`bytes1`>>24)&0xFF)=2 AND `guid` IN (53942,53944,53945,53946,53947,53948,56923,56939,60029,60044,60570,63196,63730,63732);
