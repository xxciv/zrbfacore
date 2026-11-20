# Patch notes

Newest first. Each entry says what changed, the exact values and files it touches, and what you need
to do to pick it up (rebuild, restart, run SQL).

## 2026-11-20 (World fixes: Cape of Stranglethorn, Duskwood, Redridge)

Open in the same draft PR as the 2026-11-19 and 2026-11-18 entries below. Four walks Stranglethorn, Duskwood and Redridge and reports what is off.

### World: Redridge Mountains, Lakeshire Inn fight club, Big Earl hits back
- **Found** (Four, 2026-11-20, after `2026_11_20_32`): "Dumpy vs. Big Earl. Big Earl is just taking it. Never throwing back a punch." Big Earl (faction 2101) and Keeshan/Dumpy (faction 1934) are enemies. Only Dumpy's script sets him passive, so Big Earl and Keeshan count as engaged, and their out-of-combat punch events never run. Big Earl's punches also only targeted Keeshan, who isn't in the Dumpy stage.
- **Changed** (`sql/fixes/world/2026_11_20_33_lakeshire_fight_club_punches.sql`, run after `2026_11_20_32`). Our own tuning; TDB 8.3.7 has no script here, so these rows build on the dump script:
  - Big Earl 43248 and John J. Keeshan 43184 turn passive on spawn, as Dumpy does (Big Earl row 4, Keeshan row 6).
  - Big Earl also punches Dumpy (rows 5-7, the same spells and timers as his Keeshan rows).
  - The last stage's knocked-out Big Earl (735401314) and the Keeshan standing with his crew (735401313) get their own short scripts, so they don't punch: both passive, and Big Earl stays lying down.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Redridge Mountains, Lakeshire Inn basement fight club
- **Found** (Four, 2026-11-20): "the two fighters are not fighting? Should the crowd not be cheering? Everyone is just standing around and the two fighters have a short wander distance." In 8.3.7 the basement is a scene staged by the Keeshan quests. Each spawn carries a "Quest Invis Zone" aura, and players get the matching detect aura from `spell_area` in Lakeshire (area 69), so each player sees the stage that fits their quests. Our DB had none of TDB's four `spell_area` rows, and one mixed set: Keeshan, Big Earl and Dumpy together, 20 citizens with no stage aura, and fighters wandering 3 yards. Dumpy's dump SmartAI also cast and then removed the detect auras on nearby players every second (rows 5-10; their conditions don't exist).
- **Changed** (`sql/fixes/world/2026_11_20_32_lakeshire_fight_club.sql`):
  - Our 23 basement spawns replaced by TDB 8.3.7's 51 (same entries, TDB positions and per-spawn addons, all standing still; guids 735401290-735401340):
    - Before John J. Keeshan 26567 is taken: Dumpy and Big Earl with 20 citizens.
    - From 26567 until They Drew First Blood 26607 is taken: Keeshan and Big Earl with 21 citizens.
    - From 26607 until It's Never Over 26616 is taken: Keeshan, a knocked-out Big Earl, and Messner, Jorgensen, Krakauer and Danforth.
  - TDB's 4 `spell_area` rows for area 69 added (detect spells 80817, 80818, 81202, 82100).
  - Dumpy `smart_scripts` rows 5-10 removed.
- **Not changed:** the punches between the fighters and Keeshan's cheer trigger for the crowd. Both come from the dump SmartAI; TDB has no script here. Keeshan 43184 still ends 26567/26607 and starts 26616, visible during those stages. Colonel Troteman 43221 is not touched. Once 26616 is taken the basement is empty, as in 8.3.7.
- **Status:** confirmed in game by Four (2026-11-20): Dumpy vs. Big Earl stage shows; Big Earl's punches fixed in `2026_11_20_33`.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Duskwood, doubled watchers in Darkshire
- **Found** (Four, 2026-11-20): "watcher jordan double spawn, watcher fraizer double spawn, watch burkouris double spawn". Compared with TDB 8.3.7: Watcher Jordan 887 had 3 spawns (TDB 1), Watcher Fraizer 2470 had 2 spawns 2.5 yards apart (TDB 1), and Watcher Mocarski 827 had 2 (TDB 1). Watcher Bukouris 494 has 2 spawns 9 yards apart, and TDB has two as well. None of them has a quest role.
- **Changed** (`sql/fixes/world/2026_11_20_31_duskwood_watcher_doubles.sql`):
  - Jordan: the pair 170441/170926 removed; 170824 moved to TDB's spot.
  - Fraizer: 170415 removed.
  - Mocarski: 170440 removed.
  - Our own call (TDB has two): Bukouris 170416 removed.
  - The kept watchers stand still, as in TDB.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Cape of Stranglethorn, Digsite Zombie Survivors
- **Found** (Four, 2026-11-20, screenshot): a Digsite Zombie 52604 (guid 302821) near Gurubashi Arena and "a bunch of Digsite Zombie Survivors by the Dig Site". Both belong to Bwemba's 4.1 quest Voodoo Zombies (29150 Alliance, 29237 Horde): killing a zombie summons a survivor, which should then leave. Bwemba 52234 has no spawn in our DB or in TDB 8.3.7, so the quest can't be taken, and TDB 8.3.7 has none of these creatures. The 10 survivors at the Explorers' League Digsite are static copies of that summon. Their despawn waits for a `creature_text` line that doesn't exist, so they never leave.
- **Changed** (`sql/fixes/world/2026_11_20_30_digsite_zombie_survivors.sql`):
  - The 10 static Digsite Zombie Survivors 52870 (guids 307982-307991) removed. No quest needs them: credit comes from killing the zombie, which still summons a survivor.
  - Our own tuning: a survivor summoned by a zombie kill now despawns after 5 seconds (`smart_scripts` 52870 row 0 = force despawn 5000 ms).
- **Not changed:** the 3 Digsite Zombies at Gurubashi Arena (302820-302822) stay, because they are the quest's kill target. Bwemba's whole quest chain (29100-29238) has no quest giver in 8.3.7 either.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-19 (World fixes: Northern Stranglethorn walk)

Open in the same draft PR as the 2026-11-18 feedback below. Four walks Northern Stranglethorn and reports what is off.

### World: Northern Stranglethorn zone review
- **Found** (full 8.3.7 comparison of zone 33, chosen by Four on 2026-11-19 after the first notes below): compared with TDB 8.3.7, the zone had 49 extra creatures, 92 missing spawns, two rares with several spawn points up at once, and 362 creatures with the dump's 3-yard random wander where 8.3.7 has them standing still.
- **Changed** (`sql/fixes/world/2026_11_19_32_northern_stranglethorn_review.sql`, run after `2026_11_19_30`):
  - 49 extra creatures removed (every TDB spawn keeps its nearest match): Bloodscalp Headhunter 12, Skullsplitter Berserker 7, Bloodscalp Witch Doctor 7, Mosh'Ogg Shaman 6, Mosh'Ogg Spellcrafter 6, Snapjaw Crocolisk 6, Skullsplitter Warrior 4, Skullsplitter Mystic 1.
  - Rares pooled, one up at a time: Gluggl 14487 (2 spawn points, pool 5100636) and Roloch 14488 (2 spawn points, pool 5100637).
  - 92 missing TDB spawns added (guids 735401198-735401289): Crystal Spine Basilisk 13, Saltscale Forager 11, Saltscale Hunter 10, Skullsplitter Axe Thrower 8, Bloodscalp Hunter 6, Kurzen Medicine Man 6, Murkgill Hunter 6, Saltscale Warrior 5, Bloodscalp Scavenger 4, Skullsplitter Spiritchaser 4, Mosh'Ogg Brute 4, Kurzen Subchief 4, Kurzen Commando 4 (with the creep fix from `2026_11_19_31`), Kurzen Elite 3, Bloodscalp Warrior 3, Saltscale Oracle 1.
  - 362 spawns stand still as in 8.3.7 (`MovementType` 0, `spawndist` 0). Largest groups: Zuuldaian Fetish 40, Venture Co. Geologist 31, Lesser Water Elemental 24, Skullsplitter Hunter 20, Mosh'Ogg Warmonger 15, Kurzen Jungle Fighter 13, Young Stranglethorn Tiger 12, Bloodscalp Scavenger 12.
- **Not changed:** critters and wild battle pets; spawns linked to events, pools, formations, paths or scripts; anything standing next to a hostile NPC (staged fights); phased spawns; Herald's Stranglethorn quest NPCs (Wulfred 44018, Robert Rhodes 43042, Thaalia 44017 and the raptor ritual creatures 42840, 42842, 42870). One Mosh'Ogg Brute was not added because its 8.3.7 spot is next to a Fort Livingston Adventurer. 332 creatures keep the dump's wander because 8.3.7 has them moving too or has no matching spawn.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: stealthed creatures creep instead of floating
- **Found** (Four, 2026-11-19): "Kurzen Commandos are floating while in stealth. I think this affects most stealthed units". Their addon rows have `bytes1` 0x02000000: byte 3 is the animation tier, and 2 means hover, so the client draws them hovering. The value belongs one byte lower: byte 2 = 0x02 is the "creep" stand flag, the crouched stealth walk. AzerothCore (WotLK) has these creatures at 131072 (0x00020000, creep); TDB 8.3.7 has the shifted value too.
- **Changed** (`sql/fixes/world/2026_11_19_31_stealthers_creep_not_hover.sql`): byte 3 cleared and creep set on stealthed creatures only (they cast a stealth spell from SmartAI or their aura list, or AzerothCore gives them creep). 16 `creature_template_addon` rows: Defias Night Runner 215, Shadowhide Assassin 579, Shadow Panther 768, Kurzen Commando 938, Fen Creeper 1040, Elder Shadowmaw Panther 1713, Fallenroot Shadowstalker 4798, Theramore Infiltrator 4834, Stonevault Cave Lurker 4850, Razorfen Stalker 6035, Onin MacHammar 6886, Putridus Shadowstalker 11792, Coldmist Stalker 16170, Stonescythe Ambusher 16928, Fenissa the Assassin 22060, Shadowsword Assassin 25484. 14 `creature_addon` rows: Coldmist Stalker 6, Stonescythe Ambusher 4, Daggerfen Assassin 3, Expedition Druid 1.
- **Not changed:** the other ~170 creatures with the hover value (Val'kyr, Shadow Orbs, proto-drakes, elementals and the like), which are meant to hover.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Northern Stranglethorn, first notes
- **Found** (Four, 2026-11-19):
  - Kurzen Medicine Man guid 183538 "walks through house": all 9 Kurzen Medicine Men 940 in Kurzen's Compound had the dump's 3-yard random wander (no path). TDB 8.3.7 has every one standing still.
  - "Krazek is double spawned": Krazek 773 (guid 182899, quest giver at Nesingwary's Expedition) is the 8.3.7 spawn; guid 302753 is a second Krazek (entry 52297, no gossip or quests) 2.5 yards away, which 8.3.7 doesn't have.
  - Chillwind Lieutenant guid 373403 "spawning outside of Midsummer Fire Festival": Ahune's lieutenants had no game event.
- **Changed** (`sql/fixes/world/2026_11_19_30_northern_stranglethorn_spots.sql`):
  - The 9 Kurzen Medicine Men stand still (`MovementType` 0, as in 8.3.7).
  - Krazek 302753 (entry 52297) removed.
  - Chillwind Lieutenant 26204 (373403, Stranglethorn), Frigid Lieutenant 26214 (373404, Searing Gorge), Frostwave Lieutenant 26116 (370754, Ashenvale) and Glacial Lieutenant 26215 (373405, Silithus) only appear during the Midsummer Fire Festival (event 1). TDB 8.3.7 has no spawns of them; ours keep their spots.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-18 (World fixes: feedback on the reviewed zones)

Open in a draft PR, not merged yet. Four walks the reviewed zones one at a time and reports what is off.

### World: Durotar, the Ticking Time Bomb can be seen
- **Found** (Four, 2026-11-18, screenshot): "the bomb is not visible, and its health bar is in the air". The bomb creature 42776 uses an invisible trigger model (display 15294, scaled 2.25, so its health bar floats high). The bomb itself is the 5-second area effect Ticking Time Bomb 79727, which nothing cast: TDB 8.3.7 only casts Explosion 79728.
- **Changed** (added to `sql/fixes/world/2026_11_18_43_ticking_time_bomb_fuse.sql`; first shipped as `2026_11_18_51_ticking_time_bomb_visual.sql`, folded into 43 because the pet thread also has a `2026_11_18_51` file):
  - As it lands, the bomb casts 79727 on itself (new `smart_scripts` row id 4, linked from the landing row id 3). The effect goes away with the bomb, 1 second after the explosion.
  - Our own tuning: the invisible bomb creature can't be selected (`unit_flags` |= 0x02000000), so its floating name and health bar no longer show.
- **Status:** confirmed in game by Four (2026-11-18): the bomb shows on the ground, no floating health bar.
- **Pick up:** run the SQL, restart `worldserver`.

### World: monthly Brew Vendors list their brew once
- **Found** (Four, 2026-11-18, Ironforge Brew Vendor): "offering 2 of the same item, instead of one inventory space". The monthly Brew Vendors 27806, 27810-27820 (Ironforge, and outside the Orgrimmar gate) each listed their brew twice: the 37488-37499 item and its same-named copy 37898-37909. 8.3.7 lists one item per vendor.
- **Changed** (`sql/fixes/world/2026_11_18_36_brew_vendor_single_item.sql`, first shipped as `2026_11_18_50_brew_vendor_single_item.sql`; renamed because the pet thread also has a `2026_11_18_50` file): the copies are removed, so the lists now match 8.3.7: 37488-37499, except Izzard's Ever Flavor at 27810, which keeps 37899 as in 8.3.7.
- **Status:** confirmed in game by Four (2026-11-18).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ray'ma and the Orgrimmar Brew Vendor check like the Alliance side
- **Found** (Four, 2026-11-18): Larkin Thunderbrew only opens his shop with a Brewfest Prize Token and the Ironforge Brew Vendors only sell to club members, but Ray'ma's shop and the Orgrimmar Brew Vendor 89830 were open to anyone. "rayma should have a lockout too", "as should the brew vendor next to them", "just like alliance". 8.3.7 has the checks only on the Alliance side.
- **Changed** (`sql/fixes/world/2026_11_18_49_brew_club_lockouts.sql`, our own change):
  - Ray'ma 27489 (menu 9554): "What do you have for me?" and her greeting "I see ya got some Brewfest tokens" (text 12968) need at least 1 Brewfest Prize Token 37829, the same check as Larkin's menu 9548. Without one she uses her other greeting (text 12869) and shows no shop.
  - Brew Vendor 89830 gets gossip menu 9549, the Ironforge Brew Vendors' menu: "I'd like to buy this month's brew." only shows with the achievement Brew of the Month (2796); without it the vendor says the brews are for club members only.
- **Not changed:** what they sell, and the monthly brew rotation from `2026_11_18_47`.
- **Status:** confirmed in game by Four (2026-11-18).
- **Pick up:** run the SQL, restart `worldserver`. Test with a Brewfest Prize Token in the bags (`.additem 37829`) and with the club achievement (`.achievement add 2796`).

### World: the Brew of the Month Club can be joined all year
- **Found** (Four, 2026-11-18, Ironforge Brew Vendor: "our brews are exclusive to members of the Brew of the Month Club"; "how do you join the club?"): the Ironforge vendors only sell to characters with the achievement Brew of the Month (2796), as in 8.3.7. You get it by joining: buy the membership form from Larkin Thunderbrew 27478 in Ironforge or Ray'ma 27489 in Orgrimmar and turn in Brew of the Month Club (12420 Alliance, 12421 Horde) to them. In 8.3.7 both stand there all year; ours only appeared during Brewfest, so the club couldn't be joined the rest of the year. Each also had a second Brewfest-only copy that 8.3.7 doesn't have.
- **Changed** (`sql/fixes/world/2026_11_18_48_brew_club_recruiters_all_year.sql`): Larkin 180703 and Ray'ma 194753 (the 8.3.7 spots) are no longer tied to Brewfest. The extra copies are removed: Larkin 92779 (4.6 yards from the other) and Ray'ma 92780 (in Durotar outside the Orgrimmar gate).
- **Not changed:** the Orgrimmar Brew Vendor 89830 still sells to everyone (no membership check in 8.3.7 either).
- **Status:** confirmed in game by Four (2026-11-18).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Brew of the Month Club sells one brew a month again

- **Found** (Four, 2026-11-18: "Vendor sells all brews all year. They should be in a cycle i believe, 1 type per month?", Brew Vendor 89830 in Orgrimmar): 89830 sold all 12 brews (37488-37499) all year; TDB 8.3.7 gives it no wares of its own. The club events 34-45 ("Brew of the Month January" to "December") ended on 2020-12-31, so the monthly Brew Vendors 27806-27820 outside Orgrimmar and in Ironforge never appeared. Ironforge had only the February vendor, up all year.
- **Changed** (`sql/fixes/world/2026_11_18_47_brew_of_the_month.sql`, run after `2026_11_18_46`):
  - 89830 sells only the current month's brew (`game_event_npc_vendor`, one row per month).
  - Events 34-45 run every year again until the end of 2030. Start dates moved to the first of each month this year (our own dates; the event repeats every 365 days, so from March 2028 each month starts one day early).
  - Ironforge gets the other 11 monthly vendors at 8.3.7's spot (guids 735401187-735401197); the February one only shows in February.
- Brew of the Year still takes a year: each brew is sold only in its month.
- **Status:** confirmed in game by Four (2026-11-18): Orgrimmar and Ironforge vendors sell only this month's brew.
- **Pick up:** run `2026_11_18_46` first, then this SQL, restart `worldserver`.

### World: holiday spawns appear in the right holiday

- **Found** (while fixing the Brew of the Month Club): many holiday spawns were linked to the wrong game event compared with TDB 8.3.7. Pilgrim's Bounty (26) held Brewfest decorations, kegs, mugs and revelers, plus 39 Darkmoon Faire banners and 7 Stormwind Gypsy Wagons; its own feast tables, chairs, hostesses, pilgrims, pumpkins, haystacks and cooking fires were on Brew of the Month May (41). Isle of Conquest emissaries and banners were on Brew of the Month June (42), and the six Isle of Conquest Battlemasters only showed in June. Strand of the Ancients emissaries were on Edge of Madness, Wushoolay (30). The L70ETC band and stage were on Brew of the Month October (34). Smaller mix-ups: Midsummer banners in Winter Veil, Love is in the Air giants in Winter Veil, Lunar Festival fireworks in Midsummer, Hallow's End bonfires on an event that doesn't exist (46), Elder Clearwater of the Kalu'ak derby on Brew of the Month September, holiday commoners also on 32/40/41. Broken Isles Dalaran's Brewfest decorations had been put on Pilgrim's Bounty by `2026_11_16_31`.
- **Changed** (`sql/fixes/world/2026_11_18_46_holiday_spawn_events.sql`): 3,439 spawns relinked. Each event-linked spawn was matched to the 8.3.7 spawn of the same entry within 2 yards and given that spawn's events. Without a match, a spawn moved only when all 8.3.7 spawns of its entry sit on one event and ours was one of the mixed-up events. Leftovers on the Brew of the Month events went with their set (Pilgrim's Bounty, L70ETC); the Isle of Conquest Battlemasters are always there, as in 8.3.7. Brewfest-named decorations on Pilgrim's Bounty went to Brewfest. Pilgrim's Bounty (starting next week) now shows its feast tables and no Brewfest decor.
- **Not changed:** Darkmoon Faire spawns already on event 3 (Almanac's audit), every spawn an earlier fix set by hand (city and zone passes, love boats), critters and wild battle pets, Day of the Dead (8.3.7 puts its candles on an arena season event), spawns 8.3.7 doesn't have (such as the Orgrimmar signs and fires on 26), and all event dates.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Maplewood and Runestone Treasure Chests always hold loot again

- **Found** (Four, 2026-11-18: "Is the Maplewood Treasure Chest on the top floor supposed to have any loot?", Tiragarde Keep): 11 treasure chest templates shared one loot table 207520 that TDB 8.3.7 doesn't have: 206 items rolled one by one at 0.1-2% each, so about 2 chests in 5 opened empty, and every chest drew from the same list whatever its level.
- **Changed** (`sql/fixes/world/2026_11_18_45_treasure_chest_loot.sql`): each chest gets its 8.3.7 table back (39334-39344, already in our DB): 207520 → 39334, 207521 → 39335, 207522/207534 → 39336, 207523/207535 → 39337, 207524 → 39338, 207528/207540 → 39342, 207529 → 39343, 207542 → 39344. Those tables always drop 1-2 gems or potions plus one item of the chest's level. The chests stand in Tiragarde Keep (Durotar), Darkshore, Ashenvale, Stonetalon, Desolace, Feralas, Thousand Needles, Howling Fjord, Borean Tundra, Grizzly Hills, Icecrown and Abyssal Depths.
- **Status:** confirmed in game by Four (2026-11-18, Tiragarde Keep).
- **Pick up:** run the SQL, restart `worldserver`. A chest already opened empty refills on its next respawn.

### World: Durotar, only one Sergeant Curtis in Tiragarde Keep

- **Found** (Four, 2026-11-18: "I killed one on the bottom floor, and now I see another on the top floor."): the rare Sergeant Curtis 5809 had two spawn points in our dump, one per floor of the keep (guid 252648 ground floor, 49456 top floor), both up at once. TDB 8.3.7 has no Curtis spawn at all, so there is no reference to copy.
- **Changed** (`sql/fixes/world/2026_11_18_44_sergeant_curtis_one_spawn.sql`): both spawn points join pool 5100635 (max 1), so one Curtis is up at a time, at either spot. Nothing deleted.
- **Status:** confirmed in game by Four (2026-11-18).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Durotar, the Northwatch Marines' Ticking Time Bomb explodes

- **Found** (Four, 2026-11-18, video: "ticking time bomb, brief graphical element, no functionality, doesn't do damage"): Northwatch Marine 39267 casts Ticking Time Bomb 79726, which throws a Ticking Time Bomb 42776 at your feet. The bomb's script (same as TDB 8.3.7) cast Explosion 79728 (Fire damage to enemies within 4 yards) at the very moment it appeared, while it was still being added to the world, then despawned. The explosion never landed. The ability's own text says "Explodes after a few seconds, inflicting Fire damage. Tick-tock."
- **Changed** (`sql/fixes/world/2026_11_18_43_ticking_time_bomb_fuse.sql`, run it again after the second round): the bomb now ticks for 3 seconds (our own value for "a few seconds"), then explodes (triggered cast) and disappears a second later. Step out of it to avoid the damage. Second round (Four, video: "The bomb explosion worked, but it's still 'disappearing' from the world early."): the bomb is summoned as the Marine's guardian, and guardians are aggressive, so it ran after Four's imp and out of sight before exploding. It now turns passive and rooted as it lands. The same bomb is thrown by Sergeant Curtis 5809, Nethergarde Engineer 5997 and Chief Prospector Hondo 41173.
- **Status:** confirmed in game by Four (2026-11-18), together with the visual fix in the entry above.
- **Pick up:** run the SQL, restart `worldserver`.

### World: the other all-in-one profession trainers (Train-a-Trons, Whittler Dewei, Profession Liaisons)

- **Found** (Four, 2026-11-18: "can you do a pass of all profession trainers of this kind?"; Four chose to keep all of them): five more NPCs teach several professions, all where no other trainer stands. KTC Train-a-Tron Deluxe 45286 (Lost Isles, 4 spawns) had the fishing trainers' menu 17157 (Fishing only) and Whittler Dewei 57620 (Wandering Isle) a HavenCore menu 15125 with no "Train me in" options; 8.3.7 gives both menu 12180, like Runda. KTC Train-a-Tron Deluxe 49885 (Azshara) uses menu 12002: its two training options were trainer options themselves, so they never opened the primary/secondary lists 12045/12046; those 14 professions were gossip options that closed the menu; its trainer rows sat on menus 12006/12007 that don't exist; and "Access profession vending machine" did nothing. The Profession Liaisons Leedan Gustaf 142564 (Boralus) and Ozgrom Ragefang 142552 (Dazar'alor): "I would like to buy from you." did nothing (134 items each).
- **Changed** (`sql/fixes/world/2026_11_18_42_profession_trainers_isolated.sql`):
  - Train-a-Tron 45286 and Dewei 57620 use menu 12180 (8.3.7) and get the same 11 lists as Runda.
  - Menu 12180 gets "Show me your wares, please." (vendor option, our own addition, not in 8.3.7), so the Train-a-Tron and Dewei can still sell. It only shows on NPCs that are vendors with goods, so Runda and the town trainers don't get it.
  - Train-a-Tron 49885: vending opens the shop; primary and secondary training open 12045/12046 (8.3.7's links), and each profession there opens its list (the 11 above, plus Cooking 136, First Aid 880, Fishing 10).
  - Profession Liaisons: "I would like to buy from you." opens the shop.
  - Side effect: Acride 10296/10299 and Tinza Silvermug 45563 also point at menu 12046 and showed "Cooking / First Aid / Fishing" options that did nothing. Those are trainer options now, and since these three are not trainers, the options no longer show for them.
- **Not changed:** trainer lists (same ids as `2026_11_18_41`), Journeyman's trainer work, the Nazjatar trainers (no trainer data, `npcflag` 0 in 8.3.7 too).
- **Status:** confirmed in game by Four (2026-11-18): Train-a-Trons, Whittler Dewei, and both Profession Liaisons (their single shop option opens the shop straight away, the client does that by itself for a lone vendor option).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Durotar, the 11 "Profession Trainer" NPCs teach their professions

- **Found** (Four, 2026-11-18: "Runda (Profession Trainer) - is this a real in game NPC or something added by Havencore? Either way, she doesn't work"): Runda 47418 in Razor Hill is a real NPC (Cataclysm and later). So are Lien Farner, Wembil Taskwidget, Nedric Sallow, Lalum Darkmane, Iranis Shadebloom, Saren, Valn, Therisa Sallow, Jack "All-Trades" Derrington and Elder Oakpaw. All 11 use gossip menu 12180 and its "Tell me about..." sub menus 12185-12199, where every menu lists "Train me in <profession>." for the 11 professions. Most of those options were vendor options (`OptionType` 3) or gossip options with nowhere to go, so a click closed the menu. Only 26 of the 154 had a `creature_trainer` row telling the core which list to open.
- **Changed** (`sql/fixes/world/2026_11_18_41_profession_trainer_menus.sql`): every "Train me in X." option on those 14 menus is a trainer option (`OptionType` 5, `OptionNpcFlag` 16). It opens the list the sniffed rows already used, for all 11 NPCs (1,815 `creature_trainer` rows): Alchemy 59, Blacksmithing 80, Enchanting 51, Engineering 102, Herbalism 388, Inscription 387, Jewelcrafting 48, Leatherworking 103, Mining 389, Skinning 390, Tailoring 117.
- **Status:** confirmed in game by Four (2026-11-18, Runda and the Razor Hill profession trainer).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Durotar, Razor Hill Grunts give directions again

- **Found** (Four, 2026-11-18: "none of their direction gossip works. Just closes the menu."): Razor Hill Grunt 5953 uses gossip menu 3285. Its options had no `gossip_menu_option_action` rows, so every click closed the menu; TDB 8.3.7 has the same gap. "A class trainer" (option 4) was missing. The class menu 3283 gained Druid at the top in Cataclysm, but its links were still in the old order, so Druid answered "Thotar" and Warrior answered nothing. The answer texts and map markers were all there.
- **Changed** (`sql/fixes/world/2026_11_18_40_razor_hill_grunt_directions.sql`; links as in AzerothCore, adjusted where Cataclysm moved an NPC):
  - "A class trainer" restored.
  - Main menu links: bank, inn and stable master answer with their texts, and the inn and stable get map markers. The wind rider master marks Burok in Razor Hill (the old text sends you to Orgrimmar). The class and profession menus open.
  - Class menu realigned: Druid marks Jabul and Mage marks Un'Thuwa (both now in Razor Hill, new markers 54200/54201); the others keep their texts and markers.
- **Status:** confirmed in game by Four (2026-11-18).
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-18 (Quest fixes: Crossroads Caravan Pickup, Northern Barrens)

Merged to `main` with PR #90 on 2026-11-18. Confirmed in game 2026-11-18.

### DB: the caravan stops, an invisible raider kills the kodo, no way to fight back (13949)

- **Found** (Four, 2026-11-18): riding the caravan, it stopped at random, the kodo took damage with
  no combat shown and died; back at the start an invisible Razormane Raider (seen with `.gm`) was
  hitting the player. It felt "on rails".
- **Cause:** Razormane Raider 34487 used event 79 to wake up, which in this core is SCENE_TRIGGER
  (distance-to-creature is event 75), so they never dropped Quest Invisibility 65050. Their reset
  also put back their hostile template faction 109, so they attacked the caravan and players while
  still invisible. Lead Caravan Kodo 34430 (your vehicle) could be attacked, so a raider pulled it
  into combat and the escort stopped; its path was started twice; its arrival rows (credit 53613,
  despawns) were linked to no event, so arriving could never complete the quest. The pack kodo
  Far Watch Caravan Kodo 34432 never followed. Halga Bloodeye 34258's send-off was in Spanish and
  was said by the kodo.
- **How it is meant to play:** you ride the lead kodo and shoot the raiders with Halga's "Street
  Sweeper" 46714 from your bags (its Shoot 65479 can be cast from a vehicle).
- **Changed:** `sql/fixes/world/2026_11_18_76_crossroads_caravan_pickup.sql`: SAI 34487: invisible
  and friendly (35) until the pack kodo comes within 20 yd (event 75), then visible, faction 109,
  attack the pack kodo; within 90 yd of the Captured Razormane 34523 near the end they evade and
  hide again. SAI 34430 rewritten: on summon call the pack kodo, cue Halga, become not attackable,
  start path 34430 once; at path end credit 53613 to the rider, despawn the pack kodo and itself
  (you are set down). SAI 34432: passive and follows the lead kodo. Halga's line now English (our
  wording "Move out! Get those supplies to the Crossroads!") and said by Halga.
- **Status:** confirmed in game 2026-11-18.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_76_crossroads_caravan_pickup.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

### Core: the caravan kodo stops as soon as a raider attacks (13949)

- **Found** (Four, 2026-11-18, after the SQL above): the raiders now appear, but the kodo stops the
  moment one comes out of stealth to attack.
- **Cause:** threat on a vehicle's rider goes to the vehicle (`ThreatManager::AddThreat`), so the
  Lead Caravan Kodo 34430 enters combat when a raider attacks you, even though it cannot be attacked
  itself. `SmartAI::JustEngagedWith` then cancelled its point movement, and a passive creature in
  combat never picks its path up again. If the fight ended, `EnterEvadeMode` sent it walking back to
  where its path started.
- **Changed:** `tools/bfa/smartai-passive-escort.patch` (new, after `lost-isles-zapnozzle.patch`),
  `SmartAI.cpp` only: a passive creature on a SmartAI waypoint path keeps its movement when it enters
  combat, and when it evades it carries on to its current waypoint instead of returning. Aggressive
  escorts behave as before. Guide chain + description updated.
- **Status:** confirmed in game 2026-11-18 (the kodo reached the end with the credit; the pack kodo can still die, which does not fail the quest).
- **Pick up:** core rebuild (one file in the game library, so a short build), then the SQL above if
  not run yet:

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/smartai-passive-escort.patch | git apply
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  Then restart worldserver.

## 2026-11-18 (Quest fixes: Fizzled, Durotar)

Merged to `main` with PR #90 on 2026-11-18. Confirmed in game 2026-11-18.

### DB: Fizzle's Orb stays in the bags after turning in Fizzled (25260)

- **Found** (Four, 2026-11-18): after turning in Fizzled, Fizzle's Orb 52580 was still in the bags
  and had to be deleted by hand.
- **Cause:** Fizzle Darkclaw 3203 gave out more than one orb. Every right-click (gossip hello) made
  the player cast 74024 "Remove Fizzle's Hand", which creates 52580, and picking "<Attempt to remove
  the orb.>" cast it again and also added another 52580 by script. The quest asks for 1 orb and
  takes only 1 at turn-in, so the extras stayed.
- **Changed:** `sql/fixes/world/2026_11_18_75_fizzled_orb.sql`: SAI 3203 rewritten: only the option
  gives the orb (close window, the player casts 74024 once); the gossip hello row and the extra
  add-item row are gone. Conditions on menu 11240 option 0: quest 25260 in progress and no 52580 in
  bags or bank.
- **Status:** confirmed in game 2026-11-18.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_75_fizzled_orb.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-18 (Addon fixes: FishingBuddy macro)

Client addon only, in `client/FishingBuddy`. No server change: nothing to rebuild, no SQL, no restart.

### FishingBuddy 1.10.10-zr3: "CreateMacro() failed, no name specified"
- **Reported** (Four): pressing FishingBuddy's macro (`#showtooltip Fishing`, `/fb macro`, `/stopcasting`,
  `/cast Fishing`) threw `FishingMacro.lua:86: CreateMacro() failed, no name specified` (from
  `/fb macro` -> `FishingMacro` -> `CreateOrUpdateMacro`).
- **Cause:** `/fb macro` rebuilds the macro on every press, using the saved setting `MacroName`. That setting
  was an empty string: it passes the addon's `if name` check (Lua treats `""` as true), no macro with that
  name exists, so it calls `CreateMacro("", ...)`, which the client rejects. The name edit box in the macro
  options (`LibOptionsFrame-1.0` `EditBox_OnTextChanged`) wrote every text change back to the setting,
  including text set by code, which is the likely way `""` got saved.
- **Changed:** `client/FishingBuddy/FishingMacro.lua`: new `GetMacroName()`. If `MacroName` is not a string
  or is blank, it uses the default `FBConstants.MACRONAME` ("FishingBuddy") and saves that back. Used by the
  macro build, the key binding, the "macros full" message and the options update.
- **Changed:** `client/FishingBuddy/Libs/LibOptionsFrame-1.0/LibOptionsFrame-1.0.lua`:
  `EditBox_OnTextChanged(self, userInput)` only saves when the player typed (`userInput` true).
- **Changed:** `FishingBuddy.toc` version `1.10.10-zr3`; guide line updated.
- **Confirmed in game** (Four, 2026-11-18): the macro works without the error.

## 2026-11-18 (Quest fixes: Spiketooth's gladiators, Durotar)

Merged to `main` with PR #87 on 2026-11-18. Confirmed in game 2026-11-18.

### DB: Ghislania, Griswold Hanniston and Gaur Icehorn cannot be challenged (25257, 25258, 25259)

- **Found** (Four, 2026-11-18): Spiketooth's three quests ask you to fight her gladiators, but
  talking to Ghislania 39351, Griswold Hanniston 39353 or Gaur Icehorn 39352 only shows
  "Greetings" with no option.
- **Cause:** their gossip menus 11229, 11230, 11231 had no `gossip_menu` row and no option. Their
  SAI sent a menu 39590 (does not exist) on gossip hello and waited for option 1 of that menu, so
  the fight could never start. The SAI also had two id 0 rows per NPC, and an action list 3935100
  made them unattackable on spawn.
- **Changed:** `sql/fixes/world/2026_11_18_74_spiketooth_gladiators.sql`: `gossip_menu` 11229 ->
  text 15641, 11230 -> 15642, 11231 -> 15643 (the three unused texts between this area's menus,
  matched by id order); one option per menu "Spiketooth wants to see what you're made of. Let's
  fight!" (our wording), shown only while that NPC's quest is in progress (conditions 15, quest
  taken). SAI of 39351/39352/39353 rewritten: option picked -> close window, faction 14, attack
  you; they cannot drop below 5% health; at 6% or less the closest player within 40 yd gets the
  credit (39351/39352/39353), they evade and go back to their own faction. Their own combat spells
  kept (Static Burst 76429 + Chain Lightning 79913; Taunka Rage 76423 + emote at 30%; aggro line +
  Flurry of Claws 76490). Action list 3935100 deleted. Objective texts "Ghislania defeated",
  "Gaur defeated", "Griswold defeated" (were empty).
- **Status:** confirmed in game 2026-11-18. The greeting texts are matched by id order; if one
  reads oddly, tell Herald.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_74_spiketooth_gladiators.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver and delete the client `Cache` folder (objective texts).

## 2026-11-18 (Quest fixes: Durotar, The Wolf and The Kodo + Thunder Down Under)

Merged to `main` with PR #85 on 2026-11-18. All confirmed in game 2026-11-18.

### DB: Shin Stonepillar has no gossip (25205)

- **Found** (Four, 2026-11-18): the quest says to hear Shin Stonepillar's story, but right-clicking
  him does nothing.
- **Cause:** `creature_template.gossip_menu_id` of Shin Stonepillar 39380 was 0. His fable option
  already exists (menu 11209, "Can you tell me your fable, Shin?") and his SAI already casts Summon
  The Wolf 73840 when it is picked (you ride The Wolf 39364, a vehicle, to the kodos 39365, which
  act out the fable and give the credit). The menu was simply never attached, and it had no
  `gossip_menu` text row.
- **Changed:** `sql/fixes/world/2026_11_18_71_wolf_and_the_kodo.sql`: 39380 `gossip_menu_id`
  0 -> 11209; `gossip_menu` (11209, text 15612, the unused text between the neighbouring menus
  11206 and 11211 of this quest batch); SAI 39380 also closes the window before the wolf is
  summoned; condition so the option only shows while 25205 is in progress; objective text
  "Listen to the shaman's fable" (was "The Kodo slain").
- **Status:** confirmed in game 2026-11-18 (option shows, wolf is summoned). The greeting text 15612 is matched by id order, not by a sniff;
  if Shin shows an odd greeting, tell Herald.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_71_wolf_and_the_kodo.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver and delete the client `Cache` folder (objective text).

### DB: Drowned Thunder Lizards give no credit (Thunder Down Under 25236)

- **Found** (Four, 2026-11-18): "0/8 Drowned Thunder Lizard Slain". The lizards show the
  "operate" cursor, but clicking them gives no credit.
- **Cause:** the quest is to attach a Mageweave Tether to 8 Drowned Thunder Lizards 39464 (they
  are not killed). Their spellclick cast 80948 "Razgar's Fillet Knife", an unrelated spell (dummy
  + create item 58958). The real spell is 73945 "Attach Tether": kill credit 39464 to the clicker
  and summons a Hulking Orcish Laborer 39465 to haul the carcass out.
- **Changed:** `sql/fixes/world/2026_11_18_73_thunder_down_under.sql`: `npc_spellclick_spells`
  39464 80948 -> 73945; spellclick condition (18, 39464, 73945) quest 25236 in progress; SAI 39464
  id 2 removes the click flag on click (one credit per lizard, it already despawns after 5 s);
  laborer 39465 SAI despawns it 8 s after it is summoned (the summon has no duration); the 7
  lizard spawns respawn in 60 s instead of 300 s (8 are needed); objective 265482 text "Drowned Thunder Lizard removed" (was empty, so it read
  "slain"); `creature_template_addon` 39464 `bytes1` 7 so the lizards lie dead (they stood
  around in full health).
- **Status:** confirmed in game 2026-11-18.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_73_thunder_down_under.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver and delete the client `Cache` folder (objective text).

### DB: the fable never plays out at the kodos (25205)

- **Found** (Four, 2026-11-18): after Shin turns you into The Wolf, nothing happens; running over
  to the kodos (two friendly ones per spot) does nothing and they cannot be killed.
- **Cause:** the kodos are not meant to be killed; the credit "The Kodo" comes from a script when
  The Wolf reaches them. That script (The Kodo 39365) started with event 79, which in this core is
  SCENE_TRIGGER (distance-to-creature is event 75), so it never fired. The Wolf 39364 and The Kodo
  had no `creature_text` at all, so the whole story chain (each line starts the next) had nothing
  to say. The old script also ran on all six kodos and made a sniffed guid (146730816) play dead
  that does not exist here.
- **Changed:** `sql/fixes/world/2026_11_18_72_wolf_and_the_kodo_story.sql`: 13 `creature_text`
  rows (9 for The Wolf, said one by one as you ride; 4 for The Kodo), the in-game fable lines,
  shown as on-screen emotes. Entry SAI of 39365 deleted; per-spawn SAI on one kodo of each pair
  (303086, 303091, 303093): when The Wolf is within 15 yd it tells the ending, its partner
  (303087, 303092, 303094) plays dead (29266), then the rider gets the 39365 credit, is
  teleported back to Shin Stonepillar (1289.54, -4337.85, 34.03) and The Wolf despawns. The
  trigger rests 60 s after each run.
- **Status:** confirmed in game 2026-11-18 (fable plays, credit, back at Shin).
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_72_wolf_and_the_kodo_story.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-18 (pet battles)

### Pet battles: Brewfest pets stand around all year

- **Found** (Four, 2026-11-18, screenshots): a Wolpertinger and a Pint-Sized Pink Pachyderm stand in
  the open in Durotar outside Brewfest. Both are Brewfest companions (Wolpertinger 22943 = species 153,
  Pink Pachyderm 24753 = species 166, neither capturable), not wild battle pets.
- **Cause:** 6 display spawns of these pets have no `game_event_creature` row, so they never despawn.
  The Wild Wolpertingers and Brewfest decorations around them are already in event 24 (Brewfest).

  | guid | Pet | Where |
  |---|---|---|
  | 10647404 | Wolpertinger | Durotar 1159.73 -4140.95 |
  | 10647405 | Pink Pachyderm | Durotar 1180.88 -4098.65 |
  | 10646514 | Wolpertinger | Dun Morogh Brewfest grounds -5175.68 -566.15 |
  | 10646515 | Pink Pachyderm | Dun Morogh Brewfest grounds -5175.68 -615.13 |
  | 10652003 | Pink Pachyderm | Orgrimmar, next to Ray'ma (Brew of the Month Club) |
  | 10651977 | Pink Pachyderm | Ironforge, next to Larkin Thunderbrew (Brew of the Month Club) |

- **Changed:** `sql/fixes/world/2026_11_18_51_brewfest_display_pets.sql` adds the 6 guids to
  `game_event_creature` event 24 (Brewfest), so they only spawn while Brewfest runs. Docs: Pet battles section.
- **Status:** confirmed in game by Four (2026-11-18): the Durotar Wolpertinger and Pink Pachyderm are gone outside Brewfest. SQL output: `6 Brewfest pet spawns linked to event 24`.
- **Pick up:**

  ```
  cd ~/bfa/source
  git -C ../tools-repo pull
  mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_11_18_51_brewfest_display_pets.sql
  ```

  Then restart `worldserver`.

### Pet battles: Sack of Pet Supplies opens empty

- **Found** (Four, 2026-11-18): the Sack of Pet Supplies (item 89125) from Zunta, The Pet Tamer
  (quest 31812) had nothing in it.
- **Cause:** `item_loot_template` has no rows for 89125. The sack is the reward of 42 pet tamer quests
  (Julia 31316, Zunta 31812, Old MacDonald 31724, Lindsay 31725, Eric Davidson 31726, Bill Buckler 31728,
  Steven Lisbane 31729, Dagra the Fierce 31813, Analynn 31814, Zonya the Sadist 31815, Merda Stronghoof
  31817, Cassandra Kaboom 31870, the "Battle Pet Tamers: <continent>" quests and the Grand Master
  tamers), so every one of them gave an empty sack.
- **Changed:** `sql/fixes/world/2026_11_18_50_sack_of_pet_supplies_loot.sql` adds 13 rows for 89125.
  Contents from the item's wiki page; chances copied from the dump's sniffed table for the same items
  in Darkmoon Pet Supplies (91086).

  | Item | Chance | Count |
  |---|---|---|
  | One of: Rusty Pet Cage 90043, Tattered Collar 90044, Sack of Expired Pet Food 90047, Hair Ball 90057, Well-Loved Toy 90058 (GroupId 1) | 20% each, always one | 1 |
  | Battle Pet Bandage 86143 | 47% | 2-4 |
  | Happy Pet Snack 43626, Pet Grooming Kit 43352, Magical Pet Biscuit 71153, Magical Mini-Treat 89906 | 11% each | 2-4 |
  | Fetch Ball 37431 | 8% | 1 |
  | Exquisite Murloc Leash 90048 | 1% | 1 |
  | Porcupette 89587 (battle pet) | 1% | 1 |

  Sacks already in your bags use the new table when opened. Docs: Pet battles section.
- **Status:** confirmed in game by Four (2026-11-18): a new sack from `.additem 89125` opens with loot. SQL output: `13 Sack of Pet Supplies loot rows`.
- **Pick up:**

  ```
  cd ~/bfa/source
  git -C ../tools-repo pull
  mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_11_18_50_sack_of_pet_supplies_loot.sql
  ```

  Then restart `worldserver`.

## 2026-11-18 (Addon fixes: new ZRProximity addon)

New client addon in `client/ZRProximity`. No server change: nothing to rebuild, no SQL, no restart.

### ZRProximity 1.6: "look at it" removed (game blocks it)
- **Reported** (Four, on 1.5): `/zrp look` printed "can't read its screen position (error:
  Action[FrameMeasurement] failed because[Can't measure restricted regions]: attempted from:
  <unnamed>:GetCenter().)" for every plate. On 8.3.7 nameplates, their `UnitFrame`, `healthBar` and `name`
  are restricted regions, so no addon can tell which plate is in the middle of the screen.
- **Decided** (Four): remove "look at it" entirely (offered instead: mouseover names that linger).
- **Removed** from `client/ZRProximity/ZRProximity.lua`: screen measuring (`Measure`, `ScreenOffset`,
  `LookScore`), the look reveal (`UpdateStare`, linger), `/zrp look` and its on-screen guide, and the
  settings `stare`, `stareRadius`, `stareDelay`, `stareLinger`, `stareRange` (also cleared from saved
  `ZRProximityDB`). `/zrp status` no longer mentions it.
- **Removed** from `client/ZRProximity/Options.lua`: the look checkbox and its four sliders; "Fade time" and
  the three checkboxes below moved up. Panel intro text updated.
- **Changed:** `README.md` (addon and root), guide section and TOC notes no longer mention looking at units;
  addon README explains why it isn't possible. `ZRProximity.toc` version 1.6.
- **Confirmed in game** (Four, 2026-11-18, on 1.4/1.5): distances, mouseover, target, names on plates, far
  units fully hidden. 1.6 only removes code; Lua 5.1 syntax check and stubbed smoke test pass.

### ZRProximity 1.5: look check measures the plate, its unit frame or its health bar
- **Reported** (Four, on 1.4): plate names fixed and confirmed. `/zrp look` while facing a boar 10-15 yd away
  (`/zrp range`: 10=out, 15=in, so within 20 yd) printed "0 plates near the middle" although both boar plates
  sat inside the look column: the addon could not read where the plates are on screen.
- **Changed:** `client/ZRProximity/ZRProximity.lua`: `ScreenOffset` tries the nameplate, then its
  `UnitFrame`, `healthBar` and `name` (`GetCenter` x `GetEffectiveScale`, each in `pcall`) and uses the first
  one the client lets it measure. `/zrp look` now prints the screen size and UI scale, and for up to 8 plates
  either the offset and which region it came from, or why none could be measured. `ZRProximity.toc` 1.5.
- **Checked:** Lua 5.1 syntax check and the stubbed smoke test. Not tested in game yet.

### ZRProximity 1.4: plate names no longer depend on "Hide the names above heads"
- **Reported** (Four, on 1.3, `/zrp names`): "name hook installed, called 7 times, names put back 0 times.
  Hide names above heads: off." The boars' plate names were hidden with text `nil`.
- **Cause:** `PlateName` only ran while `hideFloatingNames` was ticked. Four had unticked it and set the
  game's NPC Names to "None" by hand, so Blizzard hid the plate names and the addon left them hidden.
- **Changed:** `client/ZRProximity/ZRProximity.lua`: `PlateName` now runs whenever the addon is on. README
  says so; `ZRProximity.toc` version 1.4.
- **Checked:** Lua 5.1 syntax check and the stubbed smoke test. Not tested in game yet.

### ZRProximity 1.3: names re-checked every tick, `/zrp names`
- **Reported** (Four, on 1.2): far NPCs now fully hidden (fixed), but boars within range or under the mouse
  still show a health bar without a name (NPC Names: None).
- **Changed:** `client/ZRProximity/ZRProximity.lua`: `PlateName` also runs every 0.1 s tick for each plate the
  addon wants shown, in case Blizzard hides the name somewhere the `CompactUnitFrame_UpdateName` hook doesn't
  see. New `/zrp names` prints whether the hook is installed, how often it ran and put a name back, and for up
  to 6 plates the name's shown/visible state, text, alpha, font size and unit. `ZRProximity.toc` version 1.3.
- **Checked:** Lua 5.1 syntax check and the stubbed smoke test. Not tested in game yet.

### ZRProximity 1.2: names on plates, far floating names gone
- **Reported** (Four, on 1.1, with screenshots): with Interface > Names > NPC Names on "None" (what the addon
  sets), plates that show have a health bar but no name, unless targeted. With "All NPCs" the names come
  back, but units far away show names until you get close; only with "None" do far NPCs fully hide.
- **Cause:** on 8.3.7 Blizzard's `CompactUnitFrame_UpdateName` hides a nameplate's name unless
  `UnitShouldDisplayName` allows it, and that follows the same floating-name CVars (`UnitNameNPC`,
  `UnitNameHostleNPC`, ...) the addon turns off. With them on, the game draws a floating name over every unit
  that is beyond nameplate range (no plate yet), which the addon can't hide; within range the plate takes
  over, which is why those units "followed the rules" once closer. This was the real cause of the
  far-units report that 1.1 blamed on the look check.
- **Changed:** `client/ZRProximity/ZRProximity.lua`: new `PlateName`, hooked after
  `CompactUnitFrame_UpdateName` (`hooksecurefunc`) and run when a plate is added and on settings changes. While
  the addon and `hideFloatingNames` are on, a nameplate whose name Blizzard hid gets it back:
  `GetUnitName(unit, true)`, grey if tap-denied, otherwise `UnitSelectionColor` (Blizzard's own plate
  colours). Skips forbidden frames, the personal resource display and non-nameplate frames. The floating-name
  CVars stay off, so units beyond nameplate range show nothing.
- **Changed:** `Options.lua` tooltip and `README.md` explain it; `ZRProximity.toc` version 1.2.
- **Checked:** Lua 5.1 syntax check and the stubbed smoke test (name shown on add and again after Blizzard
  hides it; all 1.1 checks unchanged). Not tested in game yet.

### ZRProximity 1.1: "look at" fixed (far units showing, near units not showing)
- **Reported** (Four, on 1.0): units farther out showed until you got close, then followed the rules; and
  "look at" didn't really work. Mouseover and the distances worked.
- **Cause:** the look check was a circle of 80 UI units around the exact screen centre, with no distance
  limit. With the third-person camera your own character sits in the centre, so a unit you face has its
  plate above the centre (roughly 90-130 UI units up a few yards away, higher toward the horizon the farther
  it is). Nearby units you faced were outside the circle, while far-away plates near the horizon fell inside
  it (camera level or tilted up) and every one of them was revealed.
- **Changed:** `client/ZRProximity/ZRProximity.lua`
  - The look area is now a column up the middle of the screen: `stareRadius` (80) UI units each side of the
    middle, from `stareRadius` below the centre up to 40% of the screen height above it (`LookScore`).
  - Only one plate at a time can be looked at: the one nearest the middle of that column (sideways offset
    counts fully, height a fifth).
  - New setting `stareRange` (20 yd): only units within that distance can be revealed by looking.
  - New `/zrp look`: shows the look column on screen for 10 s and prints, for each plate near the middle,
    how far it sits across and up, whether it is in the look area and whether it is within `stareRange`.
- **Changed:** `client/ZRProximity/Options.lua`: new slider "Look works up to" (3-40 yd), "Look area" renamed
  "Look width". `ZRProximity.toc` version 1.1, `README.md` updated.
- **Checked:** Lua 5.1 syntax check and the stubbed smoke test: a 30 yd unit dead centre stays hidden; a
  12 yd unit faced with its plate 110 UI units above the centre shows after 1 s, stays 2 s after looking
  away, then hides; distance, `/zrp off` and the name CVars behave as in 1.0. Not tested in game yet.

### ZRProximity 1.0: nameplates by distance, target, mouseover and look
- **Asked** (Four): hide names and nameplates by default; show a plate when it's your target, when aggressive
  enemies get within about 10 m, and when neutral or friendly units get within a distance the player chooses
  (as low as 1-3 m). Optionally show names you "stare" at.
- **Added:** `client/ZRProximity/` (`ZRProximity.toc`, `Ranges.lua`, `ZRProximity.lua`, `Options.lua`,
  `README.md`).
  - Keeps nameplates on (`nameplateShowAll`, `nameplateShowEnemies`, `nameplateShowEnemyMinions`,
    `nameplateShowFriends`, `nameplateShowFriendlyNPCs` = 1) and sets each plate's `UnitFrame` alpha to 0
    on `NAME_PLATE_UNIT_ADDED`. Every 0.1 s it decides per plate whether to show it, and fades it over
    `fadeTime` (0.25 s). Changing alpha is allowed in combat.
  - A plate shows when: it is the target (`showTarget`), it is under the mouse (`showMouseover`), the unit has
    you on its threat list (`showCombat`), or the unit is within `hostileRange` (10 yd), `neutralRange`
    (5 yd) or `friendlyRange` (4 yd). Type comes from `UnitReaction`/`UnitCanAttack`.
  - Distance: `IsItemInRange` with LibRangeCheck-2.0's items of known range, giving steps of 3 (hostile) / 4
    (friendly), 5, 6, 8, 10, 15, 20, 25, 30, 35, 40 yd. `CheckInteractDistance` (10/11/28 yd) is the
    fallback. The 8.3.7 client gives no exact NPC positions, so 1 yd isn't possible.
  - Look reveal (`stare`): a plate within `stareRadius` (80 UI units) of the screen centre for `stareDelay`
    (0.5 s) shows, and stays for `stareLinger` (2 s).
  - `hideFloatingNames` (on): turns off the `UnitName*` floating-name CVars and restores the old values when
    turned off or on `/zrp off`. `hideFriendlyInInstances` (on): `nameplateShowFriends` = 0 inside
    dungeons/raids, where Blizzard forbids addons from friendly plates. `clickThrough` (off):
    `C_NamePlate.SetNamePlate*ClickThrough`. CVar changes wait until combat ends.
  - Options panel under Interface > AddOns > ZRProximity; `/zrp` (`on`, `off`, `status`, `range`, `reset`).
    Settings are saved in `ZRProximityDB`.
- **Checked:** Lua 5.1 syntax check, and a smoke test with stubbed WoW API: plate hidden at 12 yd, shown at
  9 yd, hidden again at 20 yd, shown after looking at it for 1 s, still shown 1 s after looking away, hidden
  after 3 s; `/zrp off` shows it and restores the name CVars.
- **Status:** not tested in game yet.

## 2026-11-18 (Quest fixes: Loss Reduction, Durotar)

Merged to `main` with PR #81 on 2026-11-18, together with the Kezan fixes. Confirmed in game by Four on 2026-11-18.

### DB: Injured Razor Hill Grunts give no credit (25179)

- **Found** (Four, 2026-11-18): the grunts show the speak cursor instead of attack.
- **Not a bug:** the objective is "Rescue 4 Injured Razor Hill Grunts". You click the grunt
  (spellclick 73705), it gets up and follows you for a while, then leaves. Nothing is slain.
- **Cause of the real fault:** the grunt's SAI (39270) linked the kill credit behind the "add quest"
  row, whose conditions only pass while the quest is not taken. With the quest from Gar'Thok in the
  log, a rescue gave no credit. It also called actionlist 3927000, which does not exist, and linked
  from rows that are not link events.
- **Changed:** `sql/fixes/world/2026_11_18_70_loss_reduction.sql`: SAI for 39270 rewritten (on
  click: add the quest if not taken, remove feign death, kill credit 39270, remove the spellclick
  flag, say a thank-you line, follow for 20-25 s, say goodbye and despawn; it respawns after 120 s
  lying down again). Feign death 29266 now comes from `creature_template_addon.auras`. SAI
  conditions rebuilt (calls for help only while lying down; quest added only if not taken). The
  Razor Hill Grunt directions file on PR #82 does not touch this entry.
- **Status:** confirmed in game by Four on 2026-11-18.
- **Pick up:** SQL only:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_18_70_loss_reduction.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-17 (Quest fixes: Kezan)

Merged to `main` with PR #81 on 2026-11-18. All items below confirmed in game by Four on 2026-11-18.

### DB: Necessary Roughness (24502) has no shredder and only one objective

- **Found** (Four, 2026-11-16): after The Replacements the next quest Necessary Roughness is
  accepted, but no Bilgewater Buccaneer appears, and the tracker reads `0/1 "Necessary Roughness"
  Kill Credit slain` while the quest text asks for 8 Steamwheedle Sharks.
- **Cause:** four separate data faults.
  1. Coach Crosscheck's script (`npc_coach_crosscheck`) casts 70015 (Summon Bilgewater Buccaneer)
     on accept. The spell places the shredder on the parked Bilgewater Buccaneer 48526, and the
     `conditions` row naming that target was type 31 (legacy type ids) with value 5. In legacy ids
     5 is a gameobject, so the core looked for gameobject 48526 (a "Dwarven Campfire") and the cast
     failed every time.
  2. The parked shredder carries invisibility aura 90366 and is only seen with detection 90161.
     `spell_area` gave 90161 only in Kajaro Field (area 4822); the coach stands in Bilgewater Port
     (4767). At the coach the shredder was invisible, and an invisible unit cannot be an implicit
     spell target either.
  3. `quest_objectives` only had row 266618 (kill credit 48271, the boarding credit, no text). Row
     266619 (8 x Steamwheedle Shark 37114) was missing; retail lists "Bilgewater Buccaneer (1)" and
     "Steamwheedle Shark Footbombed (8)".
  4. The parked shredder had `npcflag` 0, so its spellclick row (70015) could not be used to get
     back in after leaving the shredder.
- **Changed:** `sql/fixes/world/2026_11_17_70_kezan_quest_fixes.sql`:
  - `conditions` (13, 1, 70015): type 31 -> 51 (unit 48526).
  - `spell_area` 90161: area 4822 -> zone 4737 (all of Kezan).
  - `creature_template` 48526: `npcflag` |= 16777216 (spellclick), with a `conditions` row
    (18, 48526, 70015) so it only works while 24502 is in progress.
  - `quest_objectives`: 266618 text "Bilgewater Buccaneer"; new row 266619 (24502, kill credit
    37114, amount 8, "Steamwheedle Shark Footbombed").
  - Leftovers removed: `creature_queststarter` (37114, 24502); Coach Crosscheck `smart_scripts`
    ids 1 and 2 (two extra shark summons, the core script summons the 8 sharks); the hand-placed
    permanent shark spawn guid 3530203330003155.
- **Status:** confirmed in game by Four on 2026-11-18.

### DB: Fourth and Goal (28414) never seats the player

- **Cause:** the quest script summons a second shredder, entry 37213, and the creature script
  `npc_boucanier_gob` seats the player in it. `creature_template.ScriptName` for 37213 was empty.
- **Changed:** same file: `ScriptName` 'npc_boucanier_gob' on 37213.
- **Status:** confirmed in game by Four on 2026-11-18. Known leftover: the Deathwing fly-by (spell 66322) targets a bunny
  that only exists in the headquarters phase, so it will probably not show.

### DB: 447 (14125) completes without the Gasbot

- **Cause:** `quest_objectives` had the three objects (generator, stove, bed) but not the fourth
  retail objective "KTC Headquarters Set Ablaze with Gasbot!" (kill credit 37598, given by the
  core script `npc_kezan_gasbot`). The Gasbot Control Panel 201736 stood in phase 169, which the
  player leaves when The Uninvited Guest is rewarded, so it could not be seen at that point. The
  Claims Adjuster 37602 (second turn-in) was in 169 as well.
- **Changed:** same file: new row 266734 (14125, kill credit 37598, amount 1) plus texts for
  266731-266733; panel `PhaseId` 169 -> 382; Claims Adjuster `phaseId` 169 -> 384 (shown once 447
  is complete).
- **Status:** confirmed in game by Four on 2026-11-18.

### DB: objective texts

- Do it Yourself (14070): "<name> beaten down" for 265427-265430. Life of the Party (14113, 14153):
  "Partygoer entertained". Same file.

### DB: 177 conditions used the wrong object type id

- **Cause:** found through fault 1 above. The core has condition 31 (legacy type ids: 3 unit,
  4 player, 5 gameobject) and condition 51 (current ids: 5 unit, 6 player, 8 gameobject). 154 rows
  were type 31 with value 5 while meaning a creature (145 name a creature entry, 9 are "require
  unit" rows with no entry), so the core read them as gameobjects and the spell, spellclick or
  script they guard never found its target. 23 rows were type 51 with the legacy unit id 3 (read
  as an Azerite item). Examples: Dragonflayer installations (43986, 43990, 44213, 44214), Legion
  transporters and antennas in Netherstorm (33644, 33655, 33744), taming spells (19692-19700),
  Shade of Akama, vehicle spellclicks 46598 on 28312/32627/34776/35069/35431/35433, Wandering Isle
  summons (105333, 106623, 126040, 126043, 126059), Siege of Orgrimmar spells.
- **Changed:** `sql/fixes/world/2026_11_17_71_condition_object_types.sql`: type 31 value 5 ->
  type 51 value 5 (one row that already had a correct twin is deleted); type 51 value 3 -> value 5.
  The two type 51 value 4 rows are left alone (intent unclear).
- **Status:** confirmed in game by Four on 2026-11-18.

### DB: Ace, Gobber and Izzy ride in the Hot Rod for the rest of Kezan

- **Found** (Four, 2026-11-16): at the pool party the three companions still respawn in the car
  every time it is summoned; they should have been dropped off at the pool.
- **Cause:** `npc_hot_rod_rolling_my_homies` casts Resummon Ace/Gobber/Izzy (66644, 66645, 66646)
  whenever the driver has Rolling with my Homies rewarded, with no end. The pool-side copies
  35211-35213 are separate spawns in the pirate phase 380.
- **Changed:** `sql/fixes/world/2026_11_17_72_kezan_party_fixes.sql`: `conditions` source type 17
  on the three spells: Life of the Party 14113 and 14153 must both be "not taken" (type 47,
  mask 1). They ride along until Life of the Party is accepted and not after.
- **Status:** confirmed in game by Four on 2026-11-18.

### DB: party staff kill the Pirate Party Crashers (14115)

- **Found** (Four, 2026-11-16, video): KTC Waiters and guests kill the pirates before the player.
- **Cause:** in phase 380 Kezan Partygoer 35202 (70 spawns), KTC Waiter 48805 (7) and KTC Waitress
  48806 (5) are faction 1770, hostile to the pirates 35200 (faction 2102), with `unit_flags` 32768.
- **Changed:** same file: `unit_flags` |= 0x200 (immune to NPC) on 35202, 48805, 48806, as the
  pool-side Ace, Gobber and Izzy already have (33280).
- **Status:** confirmed in game by Four on 2026-11-18.

### DB: too many pirates at the pool party (14115)

- **Found** (Four, 2026-11-16, screenshot): the pool area is packed with pirates; thin by half.
- **Cause:** 34 Pirate Party Crashers 35200 in phase 380 for a 12-kill quest. Separately, Kezan
  Partygoer 35202 (70 spawns, phase 380) and 35235 (4, phase 381) use the invisible-stalker display
  21342: hidden anchors that the pirates fought, shown as "invisible attackers" with name plates.
- **Changed:** `sql/fixes/world/2026_11_17_73_kezan_pool_party_pirates.sql`: 17 of the 34 pirates
  deleted (kept 17 spread over the whole area, guids in the file); 35202 and 35235
  `unit_flags` |= 0x02000200 (not selectable, immune to NPCs).
- **Left:** the sleeping Pirate Party Crasher 35237 (guid 21015340, phase 381) is a deliberate
  knocked-out decoration (template aura 87259 Permanent Feign Death (Drowned), unattackable
  faction 14); the kill target is 35200.
- **Status:** confirmed in game by Four on 2026-11-18.

### Core: Doc Zapnozzle says "$n" (Don't Go Into the Light!, 14239, Lost Isles)

- **Found** (Four, 2026-11-16): `Doc Zapnozzle says: You made the right choice. We all owe you a
  great deal, $n.`
- **Cause:** on retail spell 69018 summons a personal Doc for each player; here he is a fixed spawn
  (guid 280009397, phase 0) and nothing casts 69018. `npc_zapnozzle` (lost_isles.cpp) talks to
  `GetSummoner()`, which is empty for a fixed spawn, so the chat packet had no target and the
  client could not fill in the name.
- **Changed:** new `tools/bfa/lost-isles-zapnozzle.patch` (lost_isles.cpp only, last in the chain
  after weapon-slot-attack-power.patch): `sQuestReward` remembers the player who turned in 14239,
  and `GetSummoner()` falls back to the nearest player within 40 yards. Compile-checked.
- **Status:** confirmed in game by Four on 2026-11-18.

### Not changed, for the record

- Rolling with my Homies (14071): the Keys to the Hot Rod stay after the turn-in on purpose. The
  car is needed for Robbing Hoods (14121) and Sassy takes the keys at Life Savings.
- Life Savings (14126): the core `PlayerScript` `LifeSavings` plays the movie and teleports to the
  Lost Isles as soon as the quest is complete. The quest's only objective is its own provided item,
  so by the code this happens on accept and skips the ride to the yacht and Gallywix. Left as is
  until Four reaches it and reports what happens; fixing it needs a core patch.

- **Pick up:** SQL plus one scripts-only patch. Delete the client `Cache` folder afterwards (objective texts).

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_17_70_kezan_quest_fixes.sql | mysql -u root -p bfa_world
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_17_71_condition_object_types.sql | mysql -u root -p bfa_world
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_17_72_kezan_party_fixes.sql | mysql -u root -p bfa_world
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_17_73_kezan_pool_party_pirates.sql | mysql -u root -p bfa_world
  ```

  For the Doc Zapnozzle patch (scripts only, short build):

  ```
  cd ~/bfa/source
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/lost-isles-zapnozzle.patch | git apply
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  Then restart worldserver.
## 2026-11-18 (Addon fixes: FishingBuddy options tabs)

Client addon only, in `client/FishingBuddy`. No server change: nothing to rebuild, no SQL, no restart.

### FishingBuddy: options tab empty after switching tabs
- **Found** (reported by Four, with a video): after opening the About tab, the next options tab
  (Fishing Fun in the video) stayed empty, with `LibOptionsFrame-1.0.lua:421/454/723: Action[SetPoint]
  failed because[SetPoint would result in anchor family connection]: attempted from:
  FishingOptionsFrameOpt2:SetPoint` (also `Opt7`).
- **Cause:** LibOptionsFrame puts an invisible tooltip "overlay" button over options that have a
  disabled-state tooltip (`tooltipd`, for example "Use rafts"). When the tab changes, `ResetButtons` and
  `CleanupButton` only hid the overlays, so each one stayed anchored to a checkbox from the previous tab. In
  game the client marked such an overlay as a restricted region ("Can't measure restricted regions"), which
  put the checkbox it was anchored to (`Opt2`) into a restricted anchor family. After that, even a cleared
  `Opt2` couldn't be anchored to `FishingBuddyFrameInset`. The SetPoint error aborted `LayoutOptions` before
  `ShowButtons`, so the whole page stayed empty. Confirmed in game: an unnamed Button was still anchored to
  `Opt2`, and `/run for _,o in ipairs(FishingOptionsFrame.overlaybuttons) do o:ClearAllPoints() o:Hide() end`
  brought the options back.
- **Changed:** `client/FishingBuddy/Libs/LibOptionsFrame-1.0/LibOptionsFrame-1.0.lua`:
  - `ResetButtons`: every overlay is now `ClearAllPoints()`'d as well as hidden.
  - `CleanupButton`: the button's overlay is `ClearAllPoints()`'d before the link is dropped.
  - `CheckBox_Able`: a disabled option's overlay anchors to `button.label or button` (checkboxes have no
    `label`, so it used to anchor to the options frame's corner).
  - `FishingBuddy.toc`: version `1.10.10-zr2`.
- **Status:** confirmed in game by Four on 2026-11-18 (1.10.10-zr2: tabs stay filled, no errors).

## 2026-11-17 (World fixes: second-tier zones review)

Merged to main (PR #76, 2026-11-18). Same method as the starter zones (TDB 8.3.7 as reference, critters and wild battle pets never touched), plus three new checks: wander set to TDB, missing TDB spawns added, and rares with several spawn points pooled. The wander values are TDB's own; most TDB spawns in these zones are unsniffed, so where TDB stands a mob still, that is TDB's choice, not retail sniff data.

### World: Darkshore and the Ruins of Gilneas keep their normal spawns next to the new quest phases

- **Found** (Four, 2026-11-18: "i think you got rid of mobs everywhere". The Blackwood camp, the shore and the Ruins of Auberdine in Darkshore were empty; so were the Ruins of Gilneas apart from the Forward Command battle): `2026_11_18_30` and `2026_11_18_31` give a quest phase (Darkshore 308/310, Ruins of Gilneas 274/312) to the whole zone. A player in a quest phase who isn't also in the default phase 169 only sees that quest phase's spawns, so every normal spawn in both zones disappeared. Four's location readout showed "Phases: 274" only.
- **Changed** (`sql/fixes/world/2026_11_18_35_default_phase_in_phased_zones.sql`): both zones always add phase 169 too (`phase_area` 148/169 and 4706/169), the same way Westfall, the Lost Isles, Kezan and Vashj'ir already do. Nothing was deleted; the spawns were only hidden.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ruins of Gilneas, more worgen in the forest around the Forward Command

- **Found** (Four, 2026-11-18, screenshot of empty forest near the camp: "i would add more pairs, if you get further into the forest, its pretty empty").
- **Changed** (`sql/fixes/world/2026_11_18_34_ruins_of_gilneas_forest_pairs.sql`; our own tuning, not 8.3.7):
  - Every Forsaken Vanguard of the battle (phase 274) in the Forward Command and the forest around it with no worgen within 15 yards gets one Worgen Rusher. That makes 29 Rushers (guids 735401158-735401186).
  - Each Rusher stands 2.5 yards from its Vanguard, on the side the nearest worgen come from, faces it and stands still. The 5-yard Rusher fight starter makes each pair fight.
  - The five Vanguards guarding the north road (around -995, 2000) are left alone.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ruins of Gilneas, worgen back inside the Forward Command

- **Found** (Four, 2026-11-18, after `2026_11_18_32`: "unfortunately, i think that got rid of all the worgen"; the Forsaken themselves look right now): in 8.3.7 all 46 Worgen Rushers stand in one pack northwest of the camp (around -1290, 1775), with none inside the Forward Command, so the camp went quiet.
- **Changed** (`sql/fixes/world/2026_11_18_33_ruins_of_gilneas_rushers_inside.sql`; our own tuning, not 8.3.7):
  - 11 Rushers are back on the dump spots that stood next to a defender. Each is within 5 yards of its own Forsaken Vanguard, Catapult or Sharpshooter (one Rusher per defender), faces it and stands still. Guids 735401147-735401157. The dump's other Rushers were piled on the same few defenders and stay removed.
  - The Rusher fight starter (`smart_scripts` 45375 ids 10 and 11) now looks only 5 yards out instead of 8, so each Rusher fights its own defender. New id 12 makes Rushers attack Sharpshooters 45376 too.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ruins of Gilneas, the Forward Command battle at the 8.3.7 numbers, no floating catapult crews

- **Found** (Four, 2026-11-18, two screenshots in the battle phase: Worgen Rushers piled up in one spot on the Vanguards and on a catapult; undead stacked on top of others that can't be selected): the battle set still had our dump's numbers. There were 110 Worgen Rushers 45375 where 8.3.7 has 46, and 55 Worgen Rebels 45292 where 8.3.7 has 30. The first review skipped them because 8.3.7 keeps them in a quest phase. With the fight starters from `2026_11_17_46`, every Rusher within 8 yards ran to the same Vanguard or catapult. The unselectable undead are Forsaken Blightspreaders 45374 (battle) and 51192 (overrun camp): not selectable, standing 2 yards up on top of the Forsaken Catapults, where a passenger would sit. 8.3.7 has no Blightspreaders and no catapult passengers.
- **Changed** (`sql/fixes/world/2026_11_18_32_ruins_of_gilneas_battle_counts.sql`), 1:1 with 8.3.7 phase 274. Each 8.3.7 spawn keeps its nearest match within 12 yards, moved to the 8.3.7 spot with the 8.3.7 wander; the rest of ours are removed, and 8.3.7 spots with no match are added (guids 735401110-735401146):
  - Worgen Rusher 45375: 43 kept, 67 removed, 3 added, all standing still. In 8.3.7 they stand in packs 25+ yards from the nearest Vanguard, so the fight starter no longer pulls them in.
  - Worgen Rebel 45292: 19 kept, 36 removed, 11 added (wander 10).
  - Forsaken Vanguard 45280: 79 kept, 19 removed, 23 added. The 35 at Tempest's Reach are not in the battle phase and stay.
  - All 13 + 12 Blightspreaders removed.
  - Catapults 45282 and Sharpshooters 45376 stand still (8.3.7; dump wander 3).
- **Not changed:** the overrun camp's numbers (8.3.7 has no overrun camp to compare with).
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ruins of Gilneas, the Forward Command battle until What Tomorrow Brings, the overrun camp after

- **Found** (Four, 2026-11-18, screenshots: "I'm not even sure if the player ever visits this? Or is it a fly over battle"): players do visit it; it is the end of the Horde Silverpine story (To Forsaken Forward Command, Losing Ground, Break in Communications, Vengeance for Our Soldiers, What Tomorrow Brings, Fall Back!, A Man Named Godfrey, Resistance is Futile, The Great Escape). Our dump has two full copies of Forsaken Forward Command standing on the exact same spots: the battle (Forsaken Vanguard 45280, Worgen Rusher 45375, Worgen Rebel 45292, Catapults 45282, Blightspreaders 45374, Sharpshooters 45376, Onslaught 45315, Belmont, Arthura, Deathstalkers, Angelus, Doomair, Korok 45301) and the overrun camp (Forsaken Vanguard 45532, 14 of them dead, Worgen Rusher 45535, Catapults 45533, Blightspreaders 51192, 7th Legion Submariners 45539 marching in rows, Onslaught 45534, Korok 46657). Both showed at once. 8.3.7 has only the battle set, all in phase 274. The quest text matches the second set: What Tomorrow Brings (27401) ends with the Alliance fleet landing, and Fall Back! starts on its own because "the worgen have overrun Forsaken Forward Command". Two Belmonts also stood side by side at the Forward Command. Lorna Crowley 46027 and Lord Walden 46029 at the Silverpine edge are copies of Sylvanas's Forsaken Front scene summons.
- **Changed** (`sql/fixes/world/2026_11_18_31_ruins_of_gilneas_phases.sql`; phase 274 and the battle set are 8.3.7's, the switch on What Tomorrow Brings is our own reading of the quest text):
  - The battle set (322 spawns, plus Belmont and Arthura at the Forward Command) moves to phase 274, seen in the Ruins of Gilneas until What Tomorrow Brings is turned in.
  - The overrun set (130 spawns, plus Belmont and Arthura at Emberstone Village and the second Belmont 45474 at the Forward Command) moves to phase 312, seen after What Tomorrow Brings is turned in.
  - Lorna Crowley 373753 and Lord Walden 373754 removed (Sylvanas summons them herself).
  - The fight starters from `2026_11_17_46` now pair each set with itself: Worgen Rusher 45375 attacks Forsaken Vanguard 45280 (id 10) and Catapult 45282 (id 11); Worgen Rusher 45535 attacks Forsaken Vanguard 45532 (id 10).
  - `phase_area` 4706 + `conditions` type 26 (quest 27401 rewarded / not rewarded). Both phases are in Phase.db2 and used nowhere else here.
- **Not changed** (no 8.3.7 data to go by): the coast Submariners 45403 (Vengeance for Our Soldiers), Captain Rutsak, the worgen and the 35 Forsaken Vanguards fighting at Tempest's Reach (Resistance is Futile), the Abominations 45345, the telescope scene with Halford Wyrmbane, and Belmont and Arthura on the shore (The Great Escape).
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Darkshore, Shatterspear Vale alive for its quest, then the 8.3.7 aftermath

- **Found** (Four, 2026-11-18, screenshots of the troll village: grey trolls walking that should be dead, Champions in battle stances or wandering, a crowd of trolls standing in the middle, some standing in the water): in 8.3.7 every Shatterspear Champion 32858 and Raider 33071 lies dead (same template flags as the pass). But The Ancients' Ire (13514, Kerlonian Evershade: kill 30 Shatterspear Champions, burn 6 huts) needs living Champions. Raider 33071 is immune to everyone and no quest uses it. The 18 Shatterspear Trolls 10919 and 3 Shatterspear Drummers 11196 in the middle of the village are classic residents that 8.3.7 doesn't have. Champions, Priestesses, Raiders and hut fire bunnies had the dump's wander (`2026_11_17_43` had restored it on them as "fighters", but they are immune and never fight).
- **Changed** (`sql/fixes/world/2026_11_18_30_shatterspear_vale_phases.sql`, phasing is our own, the aftermath layout is 8.3.7's):
  - The 21 classic trolls and drummers removed.
  - Shatterspear Raider 33071 template takes the 8.3.7 flags (lies dead, stunned, immune): `unit_flags` 537166592, `unit_flags2` 2049, `unit_flags3` 8192; all 34 stand still, no emote.
  - The 29 living Champions move to phase 308 and stand still; the 7 already lying dead (aura 29266) stay in every phase.
  - 41 dead Champions at the 8.3.7 spots in phase 310 (spawn flags dead, stunned, immune; the template stays alive). Guids 735401069-735401109.
  - Phase 308 shows in Darkshore until The Ancients' Ire is turned in, phase 310 after (`phase_area` 148 + `conditions` type 26, quest rewarded / not rewarded). Both are free normal phases in Phase.db2.
  - Priestesses and hut fire bunnies stand still (8.3.7).
- **Not changed:** the dancing Champions and Priestesses (emote 10 in our data; 8.3.7 has no living trolls to compare); the Shatterspear Laborers at the war camp (quest 13504 needs them alive).
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`, delete the client's `Cache` folder (Raider template changed).

### World: staged battle pairs that stand still start fighting

- **Found** (Four, 2026-11-18, Westfall "a lot better"): Sentinel Hill Guard 735401039 and Riverpaw Brute 735401030 (both added by `2026_11_17_44` at 8.3.7 spots) stand 3 yards apart and never fight. Creatures only notice each other when one of them moves, so a pair where both stand still never starts. With the flagged battle creatures, 8 such still pairs at Sentinel Hill, 16 Talrendis Raiders at the Orgrimmar gate in Azshara and 6 pairs in the Ruins of Gilneas.
- **Changed** (`sql/fixes/world/2026_11_17_46_staged_battles_start.sql`, our own tuning): out of combat, every 2-4 seconds, one side attacks the closest living opponent within 8 yards (`smart_scripts` event 1, action 49 attack, target 19 closest creature): Riverpaw Bandit 54371, Riverpaw Brute 54372, Riverpaw Herbalist 54373 attack Sentinel Hill Guard 42407 (id 10); Talrendis Raider 35177 attacks Orgrimmar Gatekeeper 35190 (id 10); Worgen Rusher 45375 attacks Forsaken Vanguard 45532 (id 10) and Forsaken Catapult 45533 (id 11); Worgen Rusher 45535 attacks Forsaken Vanguard 45280 (id 10); Forsaken Vanguard 45532 attacks 7th Legion Submariner 45539 (id 10). With `staged-npc-battles.patch` nobody dies, so the pair keeps fighting.
- **Status:** Sentinel Hill confirmed in game by Four (2026-11-18); the other zones untested.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Darkshore, Shatterspear Pass shows the aftermath of the battle

- **Found** (Four, 2026-11-17: "no one is fighting"; Four chose the 8.3.7 aftermath over a live battle): in the 8.3.7 data (retail-sniffed template) the Shatterspear Raiders 34309 at the pass play dead (`unit_flags2` 0x1), are stunned and immune, and the Lor'danel Sentinels 32969 stand still among them. Our template had the raiders alive but immune to NPCs, and the dump scripted both sides to attack each other on reset, so 6 raiders just stood there. Most of our dead raiders and some sentinels there carry aura 65181 (phase 170), which nobody sees in Darkshore. Of our 10 visible sentinels only 3 stand on 8.3.7 spots; 4 of the others were stacked on one spot (7415, -1298).
- **Changed** (`sql/fixes/world/2026_11_17_45_darkshore_shatterspear_pass.sql`):
  - Shatterspear Raider 34309 template takes the 8.3.7 flags: `unit_flags` 537166592, `unit_flags2` 2049, `unit_flags3` 8192.
  - Our 6 visible raiders (all on 8.3.7 spots) stand still without the combat-ready emote; the 3 sentinels on 8.3.7 spots stand still without emote.
  - The 7 other visible sentinels removed: 245754, 246906, 246850, 245755 (stacked), 247284, 247290, 247673.
  - The dump's "on reset, attack" rows removed: `smart_scripts` 32969 id 20 and 34309 id 22 (8.3.7 has neither).
  - Added the 12 raiders and 14 sentinels of 8.3.7 we lacked, at 8.3.7 positions, standing still (guids 735401043-735401068). The pass now has 18 raiders and 17 sentinels, as in 8.3.7.
- **Not changed:** the phase-170 copies (aura 65181); they stay hidden.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`, delete the client's `Cache` folder (the raider template changed).

### World: staged NPC battles last instead of dying out

- **Found** (Four, 2026-11-17, after `2026_11_17_43`): the open-world battles start, then one side kills the other and the survivors stand around. Westfall's gnolls still outnumbered the guards, the Ruins of Gilneas looked like an old battlefield, Azshara was half fighting and half standing, the Barrens sea dogs swam off and the Kolkar fight died out. Nothing in the data keeps these fights going: TDB 8.3.7 scripts them the same way, so creatures simply kill each other. The Camp Narache battle in Mulgore lasts only because of our own C++ script (`mulgore-bristleback-fight.patch`: NPC hits stop at 80% health).
  - Sentinel Hill had 43 gnolls where 8.3.7 has 26: our dump has the old Riverpaw entries (Bandit 452, Brute 124, Herbalist 501) on the same spots as the Sentinel Hill ones (54371-54373). It also lacked 10 of 8.3.7's guards, several of them standing next to a gnoll.
  - Northern Barrens: the Kolkar Invaders, Horde Defenders, Horde Axe Throwers and Warlord Krom'zar at Regthar Deathgate's camp are what his quest Counterattack! (4021) summons. Our dump also had 17 of them as static spawns, so a battle nobody started ran down at the camp and Krom'zar stood there all the time. Classic data (AzerothCore) has only Regthar there. `2026_11_17_43` had put 7 of the invaders back as "fighters"; that was wrong.
  - The 12 Rageroar Sea Dogs at the three rowboats off the Northern Barrens coast had the dump's 3-yard wander, so they swam away from their boats (8.3.7: standing still).
  - 80 dead bodies (permanent feign death auras 29266, 31261, 84386) had the dump's wander and slid around on the ground: Darkshore: Shatterspear Raider 14, Lor'danel Sentinel 6, Shatterspear Champion 6, Shatterspear Laborer 4, Shatterspear Overseer 1; Ruins of Gilneas: Forsaken Vanguard 14, Forsaken Catapult 4; Silverpine Forest: Worgen Warbringer 10, 7th Legion Submariner 6, Worgen Commando 5, 7th Legion Scout 4, Orc Demolisher 2, Dwarven Infantry 2, Bartolo Ginsetti 1; The Lost Isles: Bomb-Throwing Monkey 1.
- **Changed:**
  - New core patch `tools/bfa/staged-npc-battles.patch` (our own mechanism, the same idea as the Camp Narache battle): `creature_template.flags_extra` bit `0x400` (`CREATURE_FLAG_EXTRA_NO_NPC_DAMAGE_BELOW_85PCT`). A creature with it takes no damage from other creatures below 85% health. Players and their pets, totems and guardians deal full damage, so quest kills work as before. Code in `Unit::DealDamage` (`Unit.cpp`), flag in `CreatureData.h` (and allowed in the DB flag mask). Compiles against the current patch chain.
  - `sql/fixes/world/2026_11_17_44_staged_battles.sql`:
    - Flag `0x400` on 32 entries. Westfall: Sentinel Hill Guard 42407, Riverpaw Bandit 54371, Riverpaw Brute 54372, Riverpaw Herbalist 54373. Silverpine Forest: Worgen Renegade 44793, Forsaken Trooper 44791 and 44792, Hillsbrad Worgen 45254, 45255, 46063, 46064, Orc Sea Dog 45196 and 46057. Ruins of Gilneas: Forsaken Vanguard 45280 and 45532, Worgen Rebel 45292, Worgen Rusher 45375 and 45535, Forsaken Sharpshooter 45376, Forsaken Catapult 45533, Forsaken Blightspreader 51192, 7th Legion Submariner 45539. Azshara: Talrendis Saboteur 35312, Mountainfoot Grunt 36936, Valormok Grunt 36815, Talrendis Defender 36816, Talrendis Raider 35177, Orgrimmar Gatekeeper 35190. Northern Barrens: Rageroar Sea Dog 38661, Blackpool Crewman 38664, Razormane Pillager 34503, Grol'dom Grunt 34504. The flag is per entry, so these creatures also stop at 85% when other NPCs hit them elsewhere.
    - Sentinel Hill gnolls 1:1 with 8.3.7: 16 of ours matched to an 8.3.7 spot take its Sentinel Hill entry, 24 second copies removed, 7 missing 8.3.7 gnolls added (26 gnolls).
    - 10 missing 8.3.7 Sentinel Hill Guards added (34 guards against 26 gnolls; 8.3.7 has 31). Added guids 735401026-735401042, 8.3.7 positions and wander.
    - Counterattack! leftovers removed at Regthar Deathgate's camp: Warlord Krom'zar 1, Horde Defender 5, Horde Axe Thrower 3, Kolkar Invader 8. Regthar's quest still summons all of them.
    - The 12 rowboat Rageroar Sea Dogs and the 80 dead bodies above set to stand still.
- **Not changed:** Darkshore's Shatterspear Pass is waiting on Four's choice (in the 8.3.7 data the raiders there lie dead and the sentinels stand guard; our dump scripts them to fight but leaves the raiders immune to NPCs). The Ruins of Gilneas counts stay as they are: the 8.3.7 data has that battle in phase 274 with no rule that shows it, so it is no help for numbers. With the flag nobody dies, so the side with more creatures no longer wins.
- **Status:** Sentinel Hill confirmed in game by Four (2026-11-18); the other zones untested.
- **Pick up:** apply the new patch and rebuild, run the SQL, restart `worldserver`.

### World: second-tier zones re-audit (staged fights, phases, resting NPCs)

- **Found** (re-audit asked by Four, 2026-11-17, after the Sentinel Hill fight stopped): every change of `2026_11_17_30..39` was checked again against the original data. Three kinds of damage beyond Sentinel Hill:
  - Staged fights frozen: setting spawns to stand still like TDB stopped NPCs that fight each other, because they only start while they move. Hit Darkshore (Lor'danel Sentinels vs Shatterspear trolls), Silverpine (Forsaken Troopers vs Worgen Renegades), Ruins of Gilneas (the Forsaken vs worgen battle), Azshara (Talrendis vs Mountainfoot and Valormok grunts), Northern Barrens (Rageroar vs Blackpool sailors), Loch Modan and Ghostlands.
  - The overspawn trim removed some fighters and, on the Lost Isles, spawns in quest phases (it compared counts without looking at phases).
  - A few sitting or emoting NPCs had been told to wander, and a few TDB spawns were added into fights without TDB's opponents.
- **Changed** (`sql/fixes/world/2026_11_17_43_second_tier_reaudit.sql`):
  - 36 creatures put back (`INSERT IGNORE`, original rows): Northern Barrens: Kolkar Invader 7; Ruins of Gilneas: Worgen Rebel 3, Forsaken Vanguard 2; Loch Modan: Forest Lurker 5, Black Bear 1; Westfall: Riverpaw Bandit 1; The Lost Isles: Oomlot Warrior 8, Ravenous Lurker 8, Daggertooth Shark 1, Goblin Zombie 1; Azshara: Greystone Basilisk 2.
  - Wander back to the original value on 440 staged fighters (anything with a hostile NPC within 15 yards): Ghostlands: Ghostlands Guardian 4; Loch Modan: Bluegill Representative 3, Mountaineer Swarth 1, Mountaineer Cragg 1, Mountaineer Harn 1, Mountaineer Bludd 1, Forest Lurker 1, Mosshide Representative 1; Silverpine Forest: Worgen Renegade 28, Forsaken Trooper 27, Hillsbrad Worgen 17, Hillsbrad Refugee 16, Elemental Servitor 6, Orc Demolisher 2, Horde Engineer 1; Westfall: Riverpaw Herbalist 12, Riverpaw Bandit 8, Riverpaw Brute 7, Westfall Brigade Guard 1; Azshara: Mountainfoot Grunt 27, Talrendis Saboteur 21, Talrendis Defender 14, Valormok Grunt 12, Bilgewater Soldier 6, Greystone Basilisk 3, Azshara Bombing Bunny 2, Spitelash Siren 2, Talrendis Scout 2, Spitelash Warrior 1, Enslaved Son of Arkkoroc 1, Lorekeeper Amberwind 1, Thunderhead Hippogryph 1, Apprentice Illuminator 1; Darkshore: Lor'danel Sentinel 43, Shatterspear Raider 16, Shatterspear Champion 14, Shatterspear Hut Fire Bunny 13, Shatterspear Priestess 6, Vile Spray 6, Shatterspear Laborer 4, Blackwood Furbolg 3, Generic Trigger LAB - OLD 3, Twilight Worker 2, Foreman Balsoth 1, Vigilant Protector 1, Shatterspear Supplies Credit Bunny 1, Shatterspear Overseer 1, Rit'ko 1, Lady Janira 1, Vile Terror 1; Northern Barrens: Rageroar Sea Dog 6, Blackpool Crewman 5, Grol'dom Grunt 2, Chain Origin 2, Horde Defender 2, Peon 1, Horde Guard 1, Crossroads Caravan Kodo 1, Burning Blade Bruiser 1; Ruins of Gilneas: Forsaken Vanguard 30, Worgen Rusher 18, Forsaken Sharpshooter 11, Forsaken Catapult 8, Deathstalker 3.
  - 4 sitting/emoting NPCs back to standing still: Bloodmyst Isle: Sunhawk Spy 1; Ruins of Gilneas: Worgen Rebel 2; The Lost Isles: Alliance Paratrooper 1.
  - 12 added spawns removed again: Bloodmyst Isle: Void Critter 4, Blacksilt Warrior 2; Silverpine Forest: Forsaken Trooper 6.
- **Checked and fine:** no event, pool, formation, scripted or pathed spawn was removed; added spawns only use phases we already use; holiday links and rare pools are additions only.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Sentinel Hill guards no longer outnumbered, stray Defias removed

- **Found** (Four, 2026-11-17, screenshots): after `2026_11_17_41` the Sentinel Hill fight was back but the guards were outnumbered and died almost at once. `2026_11_17_37` had added 19 Riverpaw gnolls at TDB spots; TDB pairs those with guards we do not spawn. A Defias Knuckleduster (308243) stood alone near the hill: it and five other Defias are leftovers of the Defias attack on Sentinel Hill, which TDB keeps in quest phase 226 (we have no such phase).
- **Changed** (`sql/fixes/world/2026_11_17_42_sentinel_hill_balance.sql`): the 19 added gnolls removed (back to our 13), and Defias 308180, 308184, 308237, 308239, 308242, 308243 removed.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: second-tier zones, NPCs standing twice and the Sentinel Hill fight

- **Found** (Four, 2026-11-17, screenshot): Deborah Fain stood twice in Sentinel Hill, each with her own Fizzle. The zone files only removed doubles on the exact same spot that TDB did not explain, so a second copy a yard or two away stayed. Four also found nobody fighting in Sentinel Hill after `2026_11_17_37`: the guards (42407) and Riverpaw gnolls (54371-54373) only notice each other while they move, and 37 had made them stand still like TDB.
- **Changed** (`sql/fixes/world/2026_11_17_41_second_tier_doubles.sql`):
  - The first version of this file removed 469 creatures that stood within 3 yards of their own kind. That rule was too loose: it took out normal mob groups (Four, 2026-11-17). Section 1 puts all 469 back (`INSERT IGNORE`, so it does nothing if the first version was never run) with the wander the zone files gave them.
  - 23 removed: a second copy of a unique named NPC next to the first (Deborah Fain 215425, Foreman Silixiz, Cap'n Garvey, Taskmaster Fizzule, Karu, Mountaineer Morran, Warlord Krogg, Teresa Spireleaf), or a copy stacked within half a yard of another in the same phase (Lost Isles: Oomlot Warrior 5, Jungle Panther 4, Goblin Zombie 2, Spiny Raptor 2, Orc Battlesworn 1; Azshara: Spitelash Myrmidon 1).
  - Sentinel Hill: 12 guards and 12 gnolls back to the 3-yard wander they had before 37, and the gnolls 37 added wander too. Our own call, not TDB.
- **Not changed:** normal mob groups standing close together, bunnies and other invisible helpers.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Lost Isles Bomb-Throwing Monkeys stand instead of floating

- **Found** (Four, 2026-11-17, screenshot): some Bomb-Throwing Monkeys (34699) floated in a flying pose on the ground. Seven spawns had `bytes1` 50331648 in `creature_addon` (animation tier 3 = fly); TDB has the same flag on seven of its own, but these spawns stand on the ground, not in the trees.
- **Changed** (`sql/fixes/world/2026_11_17_40_lost_isles_bomb_monkeys.sql`): `bytes1` 0 on guids 40000114, 40000127, 40000134, 40000136, 40000144, 40000234, 40000441, like the other 31 monkeys.
- **Status:** confirmed in game by Four (2026-11-17).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ghostlands review

- **Found:** Ghostlands was spawned unlike TDB: some mobs doubled (Ghostclaw Lynx 101, TDB 38; Phantasmal Watcher 21, TDB 5; Dreadbone Sentinel 35, TDB 13) while others were thin (Sentinel Infiltrator 10, TDB 30; Shadowpine Catlord 15, TDB 32; Mummified Headhunter 8, TDB 22). Most mobs wandered 5 or 15 yards where TDB has them standing, or the other way round. Rathis Tomber never walked his route. The rare Dr. Whitherlimb had four spawn points up at once.
- **Changed** (`sql/fixes/world/2026_11_17_30_ghostlands_review.sql`):
  - 274 creatures removed: Ghostclaw Lynx 63, Spindleweb Lurker 29, Mistbat 25, Dreadbone Sentinel 22, Spindleweb Spider 17, Phantasmal Watcher 16, Gangled Cannibal 12, Mana Shifter 12, Shadowpine Oracle 11, Quel'dorei Wraith 10, Shadowpine Hexxer 9, Risen Creeper 9, Arcane Devourer 8, Risen Hungerer 7, Vengeful Apparition 6, Fallen Ranger 5, Deatholme Acolyte 5, Quel'dorei Ghost 5, Deatholme Darkmage 3.
  - 186 TDB spawns added (guids 735400213-735400398, only where none of ours stands within 30 yards): Shadowpine Catlord 17, Eye of Dar'Khan 14, Greater Spindleweb 14, Ghostclaw Ravager 14, Shadowpine Shadowcaster 13, Lesser Scourgebat 12, Nerubis Guard 12, Stonewing Slayer 10, Mummified Headhunter 10, Shadowpine Witch 9, Sentinel Spy 8, Sentinel Infiltrator 8, Blackpaw Scavenger 7, Blackpaw Gnoll 6, Blackpaw Shaman 6, Stonewing Tracker 5, Nerubis Centurion 5, Shadowpine Ripper 5, Shadowpine Headhunter 4, Whitetail Frenzy 3, Darnassian Druid 2, Phantasmal Seeker 2.
  - Wander set to TDB on 318 spawns (most: Shadowpine Hexxer 24, Risen Stalker 23, Nerubis Centurion 19, Wailer 18, Risen Hungerer 18, Shadowpine Catlord 15, Dreadbone Sentinel 13, Phantasmal Seeker 12).
  - Rares pooled so only one spawn point is up at a time (pool 5100600): Dr. Whitherlimb (4 spots).
  - Patrols put on the TDB waypoint paths already in our database: Rathis Tomber 67932 (path 817200).
  - Holiday spawns tied to their events: creatures 352635 to Midsummer (1).
- **Not changed:** Zul'Aman Exterior InvisMen, campfires and the burning troll huts (not in TDB) stay. Harvest nodes exist (copper, tin, silver, herbs) and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Bloodmyst Isle review

- **Found:** Bloodmyst Isle had the same mix: Corrupted Stomper, Blacksilt Scout and Sunhawk Spy doubled, while Enraged Ravager (34, TDB 69), Blacksilt Tidecaller (1, TDB 12) and Thistle Lasher (65, TDB 87) were thin and the Barbed Crawlers were missing. Eight Nazzivus satyrs, the Myst Spinner, the Void Anomaly and a Bloodcursed Naga had waypoint paths in the database but never used them. A ribbon pole target and a bonfire bunny showed all year.
- **Changed** (`sql/fixes/world/2026_11_17_31_bloodmyst_isle_review.sql`):
  - 87 creatures removed: Corrupted Stomper 14, Blacksilt Scout 11, Bristlelimb Warrior 9, Sunhawk Spy 9, Sunhawk Agent 8, Corrupted Treant 7, Mutated Tangler 7, Void Anomaly 5, Wrathscale Screamer 5, Axxarien Hellcaller 4, Axxarien Trickster 4, Contaminated Wildkin 4.
  - 156 TDB spawns added (guids 735400399-735400554, only where none of ours stands within 30 yards): Enraged Ravager 35, Thistle Lasher 22, Veridian Whelp 12, Blacksilt Tidecaller 11, Void Critter 10, Grizzled Brown Bear 10, Blacksilt Warrior 10, Sunhawk Reclaimer 9, Mutated Constrictor 8, Blacksilt Forager 6, Veridian Broodling 6, Barbed Crawler 5, Elder Brown Bear 5, Sunhawk Pyromancer 4, Nazzivus Felsworn 3.
  - Wander set to TDB on 182 spawns (most: Enraged Ravager 30, Bloodcursed Voyager 20, Wrathscale Sorceress 17, Void Critter 11, Blacksilt Forager 11, Blacksilt Scout 10, Mutated Tangler 9, Wrathscale Shorestalker 8).
  - Patrols put on the TDB waypoint paths already in our database: Void Anomaly 56327 (path 631500), Myst Spinner 66196 (path 630220), Nazzivus Satyr 66556 (path 623610), Nazzivus Rogue 66566 (path 623840), Nazzivus Satyr 66569 (path 623630), Nazzivus Rogue 66572 (path 623740), Bloodcursed Naga 68554 (path 634860), Nazzivus Felsworn 68667 (path 623980).
  - Holiday spawns tied to their events: creatures 353197, 353194 to Midsummer (1).
- **Not changed:** Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Darkshore review

- **Found:** Darkshore had almost every mob, guard and even the Buried Treasure Bunnies shuffling in a 3-yard circle (1,605 spawns); TDB has most of them standing, the rest wandering 5 to 20 yards. Nine rares (Flagglemurk, Carnivous, Lady Vespira, Shadowclaw and others) had two to four spawn points up at once. Vile Spray and Twilight Zealots were thin.
- **Changed** (`sql/fixes/world/2026_11_17_32_darkshore_review.sql`):
  - 4 creatures removed: Greymist Refugee 4.
  - 1 object(s) standing twice removed: Cat Figurine 1.
  - 29 TDB spawns added (guids 735400555-735400583, only where none of ours stands within 30 yards): Vile Spray 14, Twilight Zealot 6, Thistle Bear Cub 4, Corrupted Thistle Bear Matriarch 3, Greymist Oracle 2.
  - Wander set to TDB on 1605 spawns (most: Greymist Warrior 108, Greymist Tidehunter 92, Buried Treasure Bunny 90, Shatterspear Laborer 77, Lor'danel Sentinel 73, Shatterspear Raider 65, Corrupted Tide Crawler 64, Encrusted Tide Crawler 55).
  - Rares pooled so only one spawn point is up at a time (pools 5100601-5100609): Flagglemurk the Cruel (4 spots), Carnivous the Breaker (4 spots), Lady Vespira (3 spots), Shadowclaw (2 spots), Lord Sinslayer (2 spots), Licillin (2 spots), Lady Moongazer (2 spots), Firecaller Radison (2 spots), Strider Clutchmother (2 spots).
  - Holiday spawns tied to their events: creatures 353122 to Midsummer (1).
- **Not changed:** Darkshore's spawns otherwise match TDB closely (only 4 extra Greymist Refugees). TDB's 58 Deer are ambient animals and were not added. Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Northern Barrens review

- **Found:** Northern Barrens was the most overspawned: Ornery Plainstrider 72 (TDB 28), Venture Co. Drudger 72 (32), Razormane Thornweaver 28 (5), Burning Blade Attacker 17 (1), Kolkar Invader 11 (1). Nearly every animal shuffled 3 yards where TDB has them standing or roaming 15. Five rares had two or three copies up at once. King Reaperclaw and Trok were set to walk a path but had none assigned; a Razormane Defender never patrolled.
- **Changed** (`sql/fixes/world/2026_11_17_33_northern_barrens_review.sql`):
  - 479 creatures removed: Ornery Plainstrider 44, Venture Co. Drudger 40, Zhevra Runner 38, Sunscale Screecher 37, Barrens Vulture 35, Razormane Thornweaver 23, Savannah Prowler 19, Razormane Defender 17, Venture Co. Enforcer 17, Burning Blade Attacker 16, Venture Co. Mercenary 16, Venture Co. Overseer 14, Deviate Slayer 13, Lost Barrens Kodo 13, Razormane Plunderer 11, Kolkar Invader 10, Kolkar Wrangler 10, Deviate Stinglash 8, Razormane Hunter 8, Deviate Creeper 8, Savannah Matriarch 7, Dreadmaw Crocolisk 7, Sunscale Raptor 7, Barrens Boar 6, Razormane Frenzy 6, Kolkar Bloodcharger 6, Kolkar Packhound 6, Witchwing Harpy 5, Sunscale Lashtail 5, Razormane Geomancer 4, Kolkar Pack Runner 4, Slimeshell Makrura 4, Zhevra Charger 3, Venture Co. Drone 3, Venture Co. Lookout 3, Deviate Lurker 3, Kreenig Snarlsnout 3.
  - 31 TDB spawns added (guids 735400584-735400618, only where none of ours stands within 30 yards): Ashenvale Skirmisher 11, Hecklefang Hyena 10, Burning Blade Acolyte 5, Burning Blade Bruiser 4, Ashenvale Bowman 1.
  - Wander set to TDB on 1858 spawns (most: Fleeting Plainstrider 155, Zhevra Runner 147, Sunscale Screecher 120, Savannah Huntress 98, Barrens Vulture 78, Savannah Prowler 70, Sunscale Scytheclaw 60, Barrens Giraffe 58).
  - Rares pooled so only one spawn point is up at a time (pools 5100610-5100614): Stonearm (3 spots), Trigore the Lasher (3 spots), Sister Rathtalon (2 spots), Elder Mystic Razorsnout (2 spots), Boahn (3 spots).
  - Patrols put on the TDB waypoint paths already in our database: King Reaperclaw 303909 (path 3039090), Trok 303759 (path 3037590), Razormane Defender 262497 (path 3040270).
- **Not changed:** TDB's Caravan Kodos were not added (caravan quests spawn their own). Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Silverpine Forest review

- **Found:** Silverpine Forest: Vile Fin Tidehunters 152 (TDB 72), Vile Fin Oracles 155 (96) and Inconspicuous Bears 69 (29). Almost everything shuffled 3 yards (TDB: standing). Old Vicejaw had 11 copies up at once and Gorefang 6. Reef Frenzies were nearly missing (6, TDB 39). Two Winter Veil decorations at the Sepulcher and a ribbon pole target showed all year.
- **Changed** (`sql/fixes/world/2026_11_17_34_silverpine_forest_review.sql`):
  - 190 creatures removed: Vile Fin Tidehunter 80, Vile Fin Oracle 60, Inconspicuous Bear 40, Skitterweb Striker 8, Hillsbrad Worgen 1, Catapult Target 1.
  - 1 object(s) standing twice removed: Ambermill Strongbox 1.
  - 69 TDB spawns added (guids 735400619-735400687, only where none of ours stands within 30 yards): Reef Frenzy 33, Forsaken Trooper 16, Skitterweb Lurker 9, Bloodfang Scavenger 8, Horde Engineer 3.
  - Wander set to TDB on 997 spawns (most: Giant Rabid Bear 101, Vile Fin Oracle 100, Rabid Worg 94, Forsaken Trooper 83, Vile Fin Tidehunter 81, North Tide's Invisible Stalker 52, Hillsbrad Worgen 47, Elemental Servitor 43).
  - Rares pooled so only one spawn point is up at a time (pools 5100615-5100618): Gorefang (6 spots), Rot Hide Bruiser (2 spots), Krethis the Shadowspinner (2 spots), Old Vicejaw (11 spots).
  - Holiday spawns tied to their events: creatures 352539 to Midsummer (1); 2 Winter Veil decorations to Winter Veil (2).
- **Not changed:** The Forsaken and worgen battle NPCs that TDB lacks stay. Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Ruins of Gilneas review

- **Found:** Ruins of Gilneas: most of the Forsaken and worgen fighters shuffled 3 yards (TDB: standing), a few stood twice on the same spot, and the zone had only 5 Gilnean Hounds and 3 Highlands Foxes (TDB 43 and 42).
- **Changed** (`sql/fixes/world/2026_11_17_35_ruins_of_gilneas_review.sql`):
  - 7 creatures removed: Worgen Rebel 3, Forsaken Vanguard 2, Worgen Rusher 2.
  - 56 TDB spawns added (guids 735400688-735400743, only where none of ours stands within 30 yards): Gilnean Hound 28, Highlands Fox 28.
  - Wander set to TDB on 201 spawns (most: Forsaken Vanguard 81, Worgen Rebel 52, Forsaken Sharpshooter 20, Worgen Rusher 20, Forsaken Catapult 11, General Purpose Bunny JMF x2 size 5, Gilnean Hound 5, Highlands Fox 3).
- **Not changed:** The Forsaken vs Gilneas battle (Bloodfang Scouts, 7th Legion Submariners, Gilnean Warhounds and others, not in TDB) stays. TDB's quest-phase copies of the hounds and foxes were not added. Neither TDB nor our database has harvest nodes in Ruins of Gilneas, so none were added.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Loch Modan review

- **Found:** Loch Modan: animals and Stonesplinter troggs a third over TDB (Black Bear 65, TDB 40; Bluegill Wanderer 69, TDB 43), all shuffling 3 yards where TDB has them standing or roaming 20. Five rares (Magosh, Gosh-Haldir, Kubb, Shanda, Boss Galgosh) had two or three copies up at once. A ribbon pole target and bonfire bunny showed all year.
- **Changed** (`sql/fixes/world/2026_11_17_36_loch_modan_review.sql`):
  - 225 creatures removed: Bluegill Wanderer 26, Black Bear 25, Forest Lurker 21, Bobcat 19, Mudbelly Boar 19, Loch Buzzard 17, Loch Crocolisk 16, Golden Eagle 14, Stonesplinter Geomancer 14, Stonesplinter Digger 13, Marsh Wasp 11, Tunnel Rat Forager 10, Hill Fox 8, Tunnel Rat Surveyor 6, Scarred Crag Boar 3, Bluegill Mudskipper 3.
  - 1 object(s) standing twice removed: Silverleaf 1.
  - Wander set to TDB on 764 spawns (most: Bluegill Wanderer 42, Black Bear 39, Mudbelly Boar 38, Hill Grizzly 37, Forest Lurker 37, Marsh Wasp 36, Bobcat 32, Twilight Encroacher 30).
  - Rares pooled so only one spawn point is up at a time (pools 5100619-5100623): Magosh (2 spots), Gosh-Haldir (2 spots), Kubb (2 spots), Shanda the Spinner (2 spots), Boss Galgosh (3 spots).
  - Holiday spawns tied to their events: creatures 352648, 352647 to Midsummer (1).
- **Not changed:** Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Westfall review

- **Found:** Westfall: 1,200 mobs shuffled 3 yards (TDB: standing). Sea Crawlers, Small-Time Hustlers and West Plains Drifters were thin, Sand Crawlers and Coyotes a little doubled, and six Hobo Goods bags stood twice. Brainwashed Noble and Slark had two copies each. A ribbon pole target and bonfire bunny showed all year.
- **Changed** (`sql/fixes/world/2026_11_17_37_westfall_review.sql`):
  - 107 creatures removed: Sand Crawler 21, Coyote 17, Riverpaw Bandit 15, Riverpaw Mongrel 14, Riverpaw Brute 13, Young Fleshripper 7, Hobo Goods (Bag) 6, Riverpaw Gnoll 6, Unbound Cyclone 5, Murloc Coastrunner 3.
  - 2 object(s) standing twice removed: Sack of Oats 2.
  - 153 TDB spawns added (guids 735400744-735400896, only where none of ours stands within 30 yards): Sea Crawler 89, Small-Time Hustler 11, Chasm Slime 10, Murloc Tidehunter 9, West Plains Drifter 9, Riverpaw Bandit 7, Energized Harvest Reaper 6, Riverpaw Herbalist 6, Riverpaw Brute 6.
  - Wander set to TDB on 1200 spawns (most: Sea Crawler 179, Goretusk 92, Coyote 56, Riverpaw Herbalist 54, Sand Crawler 46, Young Goretusk 43, Hulking Goretusk 39, Riverpaw Mongrel 38).
  - Rares pooled so only one spawn point is up at a time (pools 5100624-5100625): Brainwashed Noble (2 spots), Slark (2 spots).
  - Holiday spawns tied to their events: creatures 352749, 352754 to Midsummer (1).
- **Not changed:** Westfall keeps our own quest phasing (170/171): TDB phases the Defias and the homeless NPCs differently, so its Defias copies and the Thugs were not added. Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: The Lost Isles review

- **Found:** The Lost Isles: Jungle Panthers and Goblin Zombies wandered where TDB has them standing (and the reverse), Daggertooth Sharks and Ravenous Lurkers a little doubled, and Pterrordax Scavengers, Spiny Raptors, Venom Spitters and Iceeyas were thin.
- **Changed** (`sql/fixes/world/2026_11_17_38_lost_isles_review.sql`):
  - 23 creatures removed: Daggertooth Shark 13, Ravenous Lurker 9, Goblin Zombie 1.
  - 106 TDB spawns added (guids 735400897-735401002, only where none of ours stands within 30 yards): Pterrordax Scavenger 35, Spiny Raptor 13, Venom Spitter 9, Iceeya 8, Naga Hatchling 8, Alliance Sailor 7, Steamwheedle Shark 6, Vashj'elan Warrior 5, Smart Mining Monkey 5, Frightened Miner 5, Oostan Headhunter 2, Vashj'elan Siren 2, Bomb-Throwing Monkey 1.
  - Wander set to TDB on 389 spawns (most: Jungle Panther 109, Goblin Zombie 65, Spiny Raptor 31, Oomlot Warrior 27, Alliance Sailor 25, Daggertooth Shark 17, Child of Volcanoth 14, Naga Hatchling 12).
- **Not changed:** The Lost Isles keep our own quest phasing: 1,222 spawns sit in a different phase than in TDB, and TDB's extra per-phase copies were not added where one of ours already stands. Harvest nodes exist and were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Azshara review

- **Found:** Azshara: Mosshoof Coursers 123 (TDB 68), Weakened Mosshoof Stags 98 (47), Thunderhead Hippogryphs 116 (66), Restless Spirits, Greystone Basilisks and the Blackmaw furbolgs about doubled. 2,266 mobs shuffled 3 yards (TDB: standing or roaming 20). Nine rares had two to five copies up at once. 59 Winter Veil decorations stood all year.
- **Changed** (`sql/fixes/world/2026_11_17_39_azshara_review.sql`):
  - 445 creatures removed: Mosshoof Courser 55, Weakened Mosshoof Stag 51, Thunderhead Hippogryph 50, Spitelash Myrmidon 33, Restless Spirit 32, Greystone Basilisk 31, Vile Splash 21, Mistwing Ravager 19, Blackmaw Pathfinder 17, Spitelash Enchantress 17, Blackmaw Warrior 17, Spitelash Battlemaster 16, Blackmaw Shaman 16, Makrinni Snapclaw 14, Spitelash Invader 12, Thunderhead Stagwing 12, Sable Drake 9, Legashi Rogue 8, Legashi Satyr 7, Skychaser Hippogryph 4, Warsong Assault Wind Rider 3, Goblin Cocktail 1.
  - 23 TDB spawns added (guids 735401003-735401025, only where none of ours stands within 30 yards): Mistwing Cliffdweller 17, Yellowfin Shark 3, Azshara Bombardier 3.
  - Wander set to TDB on 2266 spawns (most: Coralshell Lurker 235, Bilgewater Seal 193, Makrinni Scrabbler 108, Makrinni Razorclaw 92, Vile Splash 84, Thunderhead Hippogryph 66, Mosshoof Courser 63, Static-Charged Hippogryph 60).
  - Rares pooled so only one spawn point is up at a time (pools 5100626-5100634): Master Feardred (2 spots), The Evalcharr (4 spots), Antilos (5 spots), Varo'then's Ghost (5 spots), Scalebeard (2 spots), Monnos the Elder (2 spots), Gatekeeper Rageroar (2 spots), Lady Sesspira (2 spots), General Fangferror (2 spots).
  - Holiday spawns tied to their events: 59 Winter Veil decorations to Winter Veil (2).
- **Not changed:** Land mines and the old high-level harvest nodes (not in TDB) were not touched.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-16 (Quest fixes: The Lesson of the Burning Scroll)

Merged to `main` with PR #78 on 2026-11-16.

### DB: the Edict of Temperance doesn't burn

- **Found** (Four, 2026-11-16): The Lesson of the Burning Scroll (29408, Wandering Isle). Using the
  flame on the Edict of Temperance gives the credit, but the scroll never catches fire.
- **Cause:** the scroll is gameobject 210986 (goober, `Data5` consumable 1, spell 114580, spawn guid
  21000000 on map 860). Spell 114580 has no fire visual: it gives kill credit 59570, removes the
  flame aura 122486 and destroys item 80212. The burn is the model's despawn effect
  (`SMSG_GAMEOBJECT_DESPAWN`); Four confirmed it with `.gobject set state 21000000 -1`, while the
  custom animations 0-3 and states 0 and 2 showed nothing. `gameobject_template_addon.flags` for
  210986 was 65572 (0x10024), which includes `GO_FLAG_NODESPAWN` (0x20). With that flag
  `GameObject::Update` (`GO_JUST_DEACTIVATED`) returns before `SendGameObjectDespawn` for a used
  goober, so the effect was never sent.
- **Changed:** `sql/fixes/world/2026_11_16_71_burning_scroll.sql` clears 0x20:
  flags 65572 -> 65540 (0x10004). After use the scroll now burns away and comes back after its
  5 second spawn time. The burn starts 3 seconds after the click, together with the quest credit
  (`Data3` autoClose 3000, unchanged).
- **Status:** confirmed in game by Four on 2026-11-16 (the scroll burns when used).
- **Pick up:** SQL only, no rebuild:

  ```
  git -C ~/bfa/tools-repo fetch origin claude/project-thread-8ftb1c
  ```

  ```
  git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_16_71_burning_scroll.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-16 (core: weapon attack power reset)

### Combat: main hand weapon attack power drops to 0 after equipping or removing any other item

Open on branch `claude/project-thread-z3fwbh` (not merged yet).

- **Found** (Four, 2026-11-16, level 1 Windwalker monk fighting Jaomin Ro 54611): `.debug attackpower`
  showed `Weapon attack power: main hand 0, off hand 2` although the fist weapon was still equipped
  (main hand weapon damage 0.9 - 1.0). Tiger Palm dropped back to 1. It happened after the quest item
  Master's Flame was taken away.
- **Cause:** a bug in `weapon-attack-power.patch` (PR #79). `Player::_ApplyItemBonuses` called
  `Player::_ApplyWeaponDamage` for every equipped item, treating every slot that is not the off hand
  as the main hand (`BASE_ATTACK`). Before PR #79 that did nothing for non-weapons (no damage, no
  delay). Since PR #79, `_ApplyWeaponDamage` also sets the weapon attack power field, so equipping or
  removing armor, a ring, a tabard or a quest item set the main hand's weapon attack power to that
  item's DPS x 6, which is 0. TrinityCore 8.3.7 only calls it for weapon slots (`GetAttackBySlot`).
- **Changed:** new `tools/bfa/weapon-slot-attack-power.patch`
  (`src/server/game/Entities/Player/Player.cpp`, `Player::_ApplyItemBonuses`): returns before
  `_ApplyWeaponDamage` unless the slot is the main hand or off hand. No SQL.
- **Status:** applies cleanly after the full chain on upstream 2c13546, `Player.cpp` compiles.
  Confirmed in game by Four on 2026-11-16 (armor swaps no longer reset main hand weapon AP).

#### To pick up the main hand fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-z3fwbh
git -C ../tools-repo show FETCH_HEAD:tools/bfa/weapon-slot-attack-power.patch | git apply && echo "weapon slot patch applied"
grep -c "only the weapon slots carry weapon damage" src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Restart `worldserver`, log in, and check `.debug attackpower`: main hand weapon
attack power should be 2 again (it is set when the weapon is applied at login).

## 2026-11-16 (core)

### Combat: abilities that scale with attack power hit far too weakly

Merged to `main` with PR #79 on 2026-11-16.

- **Found** (Four, 2026-11-16, level 1 Pandaren monk): Tiger Palm hits for 1, and the monk dies to
  any mob of the same level.
- **Cause:** in 8.3.7 a melee or hunter ability's damage is "x% of attack power", and attack power
  includes the equipped weapon's share (weapon DPS x 6) and flat attack power from buffs.
  HavenCore's `Unit::GetTotalAttackPowerValue` returned only the attack power from stats
  (`AttackPower * (1 + multiplier)`). It ignored `AttackPowerModPos/Neg` (flat attack power
  auras) and the weapon fields `MainHandWeaponAttackPower`, `OffHandWeaponAttackPower` and
  `RangedWeaponAttackPower`, which HavenCore never set at all. Tiger Palm (100780) is effect 0
  School Damage with `BonusCoefficientFromAP` 0.2703 and no base points (SpellEffect.db2 row 108857),
  so a level 1 monk (17 agility, `player_classlevelstats` class 10 level 1) got about
  0.27 x 17 = 4.6 damage before armor. The weapon's share was missing.
  Armor mitigation (`Unit::CalcArmorReducedDamage`) and creature armor
  (`Creature::GetBaseArmorForLevel`, ExpectedStat) were compared with TrinityCore 8.3.7 (tag
  TDB837.20101) and are identical, so they are not part of this bug.
- **Changed:** new `tools/bfa/weapon-attack-power.patch`, all ported from TrinityCore 8.3.7:
  - `Unit::GetTotalAttackPowerValue(attType, includeWeapon = true)` (`Unit.cpp`, `Unit.h`): adds
    `AttackPowerModPos + AttackPowerModNeg` (ranged: the ranged pair), and with `includeWeapon` the
    weapon attack power: main hand and ranged take the larger of main hand / ranged weapon AP; the
    off hand adds off hand weapon AP and halves the total.
  - White hits do not count the weapon twice: `Player::CalculateMinMaxDamage`,
    `Creature::CalculateMinMaxDamage` and `Guardian::UpdateDamagePhysical` (`StatSystem.cpp`) call it
    with `includeWeapon = false`, because they already add the weapon's own damage.
  - `Player::_ApplyWeaponDamage` (`Player.cpp`): sets the weapon attack power field for the slot to
    `weapon DPS * 6` when a weapon is equipped and 0 when it is removed. New setters
    `SetMainHandWeaponAttackPower` / `SetOffHandWeaponAttackPower` / `SetRangedWeaponAttackPower`
    (`Unit.h`).
  - `ItemTemplate::GetDPS(itemLevel)` (`ItemTemplate.cpp/.h`): the DPS lookup is split out of
    `ItemTemplate::GetDamage`, which now calls it. Weapon damage itself is unchanged.
  - `Unit::SpellDamageBonusDone` (`Unit.cpp`): spells that need the off hand and not the main hand
    (`SPELL_ATTR3_REQ_OFFHAND` without `SPELL_ATTR3_MAIN_HAND`) use off hand attack power.
  - No SQL. The character sheet's attack power now also shows the weapon's share.
- **Status:** in game on 2026-11-16 (level 1 Windwalker monk, 15 agility): Tiger Palm's tooltip
  went up to 5 (the client counts the weapon share), Four now beats the Tushui Trainees, but Tiger
  Palm still lands for 2 every hit. Armor is not the cause: `.damage 100 0` and `.damage 100 1`
  both dealt 97. Still being traced; see the debug command below.
- **Also added:** `tools/bfa/attack-power-debug.patch` (`src/server/scripts/Commands/cs_debug.cpp`):
  GM command `.debug attackpower [spell id or link]`. It prints your `AttackPower`, `ModPos/ModNeg`,
  multiplier, weapon attack power fields, the totals for main hand, off hand and ranged, and main
  hand weapon damage. With a spell and a selected target it prints, per attack power damage effect,
  the AP coefficient before and after spell mods, the percent damage done multiplier, the damage
  spell mods, and the damage done before the target's own modifiers, armor and crit. With a target
  selected it also prints the target's level, armor, health and auras, the level scaling
  multipliers, a 100 damage melee hit through your bonuses, the target's bonuses and armor, and the
  spell's damage after the target's modifiers and armor.
- **Debug result 1** (Four, Tushui Trainee): AttackPower 17, weapon attack power 2 main hand and 2
  off hand, total 19.0 main hand; Tiger Palm coefficient 0.2703 (no spell mods), percent done
  x1.000, damage spell mods x1.046, damage done 5. So the server computes 5 on the attacker's side
  and the cut to 2 happens on the target's side.
- **Debug result 2** (in combat, Tushui Trainee 54587): AttackPower 15 in combat (17 seen idle, a
  temporary buff), weapon AP 2, total 17; Tiger Palm 17 x 0.2703 = 4 before armor. The trainee has
  49 armor (ArmorModifier 1, value from the client's level 1 ExpectedStat), which takes 30-31%
  (100 physical -> 69-70), so Tiger Palm lands for 2. Every step matches TrinityCore 8.3.7; the
  remaining weakness is level 1 tuning, not a core bug.
- **Final status:** confirmed by Four on 2026-11-16 (Tiger Palm 1 -> 2, trainees now beatable) and
  merged. The open question of the monk dying to early quest mobs is mob tuning, not this patch.

#### To pick up the attack power fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/weapon-attack-power.patch && echo "attack power patch applied"
grep -c "WeaponAttackPower" src/server/game/Entities/Unit/Unit.cpp src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 3 for `Unit.cpp` and 3 for `Player.cpp`. Then restart `worldserver`. Log in, take the
weapon off and put it back on (or just relog), and check the attack power on the character sheet.

The debug command on top (only `cs_debug.cpp` changes, so this rebuild is short):
```
cd ~/bfa/source
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/attack-power-debug.patch && echo "attack power debug patch applied"
grep -c "HandleDebugAttackPowerCommand" src/server/scripts/Commands/cs_debug.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2. Restart `worldserver`, target a mob and type `.debug attackpower 100780`.

## 2026-11-16 (Quest fixes: Mulgore batch and gossip menu options after Accept)

Merged to `main` with PR #77 on 2026-11-16.

### DB: Supervisor Fizsprocket summons a Deviate Viper

- **Found** (Four, 2026-11-16): Supervisor Fizsprocket (3051) summons an elite Deviate Viper when
  pulled. Nothing documents that.
- **Cause:** his SmartAI row 0, commented "Cast Commanding Shout on Aggro", casts spell 7973. That
  spell is "Summon Deviate Viper" (effect 28 summon, creature 5755), not a shout.
- **Changed:** `sql/fixes/world/2026_11_16_70_mulgore_quest_fixes.sql` deletes `smart_scripts` row
  (3051, source 0, id 0). Rows 1-3 stay: Lantern Blaze 81767, Motivate 81754, Throw Lantern 81764.
- **Status:** confirmed in game by Four on 2026-11-16.

### DB: The Restless Earth tracker reads "Earth Spirit Credit Bunny slain"

- **Found** (Four, 2026-11-16): quest 14491.
- **Cause:** the objective is kill credit 36872 (Earth Spirit Credit Bunny) x6 with no
  `quest_objectives.Description`, so the client shows the creature's name.
- **Changed:** same SQL file sets `Description` = 'Spirits Calmed' (the retail text) for
  QuestID 14491, ObjectID 36872.
- **Status:** confirmed in game by Four on 2026-11-16. The client caches quest text: delete the client's `Cache` folder.

### DB: Morin Cloudstalker offers Supervisor Fizsprocket twice

- **Found** (Four, 2026-11-16): two quests named Supervisor Fizsprocket at Morin Cloudstalker (2988),
  one rewarding the removed Goblin Smasher.
- **Cause:** the pre-Cataclysm quests are still in the DB next to their replacements: 765
  Supervisor Fizsprocket (all races, follows The Ravaged Caravan 751, `QuestPackageID` 873, no
  money) beside 26180, and 764 The Venture Co. (kill 14 + 6) beside 26179 (kill 7).
- **Changed:** same SQL file renames `quest_template.LogTitle` 765 to
  'Legacy - Supervisor Fizsprocket' and 764 to 'Legacy - The Venture Co.'. Nothing else about them
  changes; both stay available. Other legacy duplicates in the DB are not touched yet.
- **Status:** confirmed in game by Four on 2026-11-16. Needs the client `Cache` folder deleted to show the new titles.

### Core: gossip options do nothing after accepting a quest in the same window

- **Found** (Four, 2026-11-16): Skorn Whitecloud (3052, `npcflag` 4227 = gossip + quest giver +
  vendor + repair, gossip menu 24: "Tell me a story, Skorn." and "Let me browse your goods."). After
  accepting The Hunter's Way (861) the menu comes back, but "Let me browse your goods." does
  nothing until the window is closed and opened again.
- **Cause:** `quest-gossip-accept.patch` sends the gossip menu again after Accept. The client then
  ends the quest conversation with `CMSG_CLOSE_INTERACTION`, and `HandleCloseInteraction`
  (`MiscHandler.cpp`) resets `InteractionData.SourceGuid`. `HandleGossipSelectOptionOpcode` drops
  every option of a menu whose `SourceGuid` doesn't match, without a message. When the menu had no
  quest left, the patch also sent `SendCloseGossip` itself (the Tak fix), which reset it as well
  while the window stayed up. This is the same drop that hung Tak.
- **Changed:** new `tools/bfa/quest-gossip-options.patch` (last in the chain, after
  `client-ticket-poll.patch`), `GossipDef.h`, `GossipDef.cpp`, `QuestHandler.cpp`, `MiscHandler.cpp`:
  - `PlayerMenu` gets `_keepInteractionOnNextClose` (`KeepInteractionOnNextClose`,
    `ConsumeKeepInteraction`), cleared by `SendGossipMenu` and `SendCloseGossip`.
  - `HandleQuestgiverAcceptQuestOpcode`: after re-sending the gossip menu it sets that flag and
    returns. It only still sends the close when the menu is a single option that is not plain chat
    and no quest is left, which is the case the client picks by itself (Tak's flight map).
  - `HandleCloseInteraction`: when the flag is set, the next close for that NPC clears the flag and
    leaves the interaction data alone.
  - No DB change. Compiles against upstream 2c13546 and applies at the end of the full chain.
- **Status:** confirmed in game by Four on 2026-11-16.

### To pick up this batch

The core patch touches `GossipDef.h`, so expect a long build (about 226 files, like the last one).

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-gossip-options.patch | git apply && echo "quest gossip options applied"
grep -c "ConsumeKeepInteraction" src/server/game/Handlers/MiscHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```

The echo line prints and the grep prints 1. Then the SQL:

```
git -C ~/bfa/tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_16_70_mulgore_quest_fixes.sql | mysql -u root -p bfa_world
```

Restart worldserver and delete the client's `Cache` folder.
## 2026-11-16 (World fixes: starter zones review)

Open in a draft PR, not merged yet.

### World: Lost Isles Pterrordax Scavengers glide instead of jittering

- **Found** (Four, 2026-11-16, video): the Pterrordax Scavengers (36719) on the Lost Isles darted back and forth like the
  Undercity bats did. All 70 wandered in a 3-yard radius at their template walk speed of 4.4. TDB 8.3.7 has the same
  speed but a 10-yard radius (86 spawns) or none (30).
- **Changed** (`sql/fixes/world/2026_11_16_54_lost_isles_pterrordax.sql`): wander radius 10 yards, as in TDB.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: Master Shang Xi stops handing out The Master's Flame

- **Found** (Four, 2026-11-16, screenshot): every quest accept or turn-in at Master Shang Xi (53566) gave The Master's
  Flame again, long after The Lesson of the Burning Scroll (29408), and the player could end up sitting on him (he is a
  vehicle, VehicleId 1416, also in TDB). His "on gossip hello" SmartAI row made every visitor cast Create The Master's
  Flame (114611) with no quest check; it also shared id 0 with another row and linked to a non-link row. He also had the
  spell-click npcflag and a click spell (Snatch Master's Flame 114746) that ran on every click. TDB 8.3.7 has npcflag 3
  (gossip + quest giver) and no click spell.
- **Changed** (`sql/fixes/world/2026_11_16_53_master_shang_xi_flame.sql`):
  - npcflag 3 as in TDB; his click spell row removed. The quest doesn't need it: the flame item comes from his gossip
    row and the first credit from his quest-accept row.
  - The gossip row is re-added as its own row (id 13) and only fires while 29408 is in the quest log and the flame item
    (80212) isn't in the bags (conditions on SmartAI source 22).
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Jaomin Ro stays in the fight after Hawk Diving to Earth

- **Found** (Four, 2026-11-16, video): after Hawk Diving to Earth, Jaomin Ro vanished ("There is nothing to attack") and
  sometimes reset the fight. His script cast 108955, which summons "Jaomin Ro's Vehicle" (57750, a hawk) and seats him in
  it. The hawk flew up and dove, then the vehicle despawned and he was gone until he reset.
- **Changed** (`sql/fixes/world/2026_11_16_52_jaomin_ro_hawk_dive.sql`): his special no longer uses a vehicle. He takes
  the hawk form himself (model 39796, the same one the core's own Jaomin script uses), casts the dive 108935 Hawk Diving
  to Earth one second later (instant, 75% weapon damage and a short stun around him), and turns back half a second after
  that. He stays the same creature and keeps his target.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Jaomin Ro hits softer

- **Found** (Four, with the Main core changes thread, 2026-11-16): Jaomin Ro (54611, The Disciple's Challenge) is level 3
  with 160 health and hit a level 1-2 monk (72 health) for 4-8 per swing, crits up to 22, plus Baby Elephant Takes a Bath
  (about 14) or Hawk Diving to Earth (5-6) every 6 to 10 seconds. His level, health and damage modifiers match TDB 8.3.7.
  TDB gives him no script (melee only); our SmartAI adds the two specials. The player-side damage problem is a core bug
  handled in the Main core changes thread (PR #80).
- **Changed** (`sql/fixes/world/2026_11_16_51_jaomin_ro_damage.sql`), our own tuning rather than TDB's: half melee damage
  (`DamageModifier` 0.5), first special after 6-8 seconds, then every 10 to 14 seconds.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: The Master's Flame no longer stays on the player

- **Found** (Four, 2026-11-16): after The Lesson of the Burning Scroll (29408) the buff "The Master's Flame" stayed on
  the character, through relogs and later quests. The quest puts The Master's Flame (114610, infinite duration, a dummy
  aura that gives the quest credit) on the player, and nothing took it off again.
- **Changed** (`sql/fixes/world/2026_11_16_50_masters_flame_aura.sql`): Master Shang Xi 53566 removes The Master's Flame
  (114610), its cosmetic version (114613) and Snatch Master's Flame (114746) from the player when 29408 is turned in.
  A character already past that quest can clear it with `.unaura 114610`.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Wandering Isle trainees hit softer

- **Found** (Four, 2026-11-16, video): after 2026_11_16_48 the trainees fought one at a time, but a single trainee still
  killed a level 1 monk (72 health). They hit for 6-7 with melee every 2 seconds and cast Blackout Kick or Jab every
  2 seconds (TDB 8.3.7's timer), with double health. Their level, health and damage values match TDB 8.3.7, and the
  core's energy regeneration matches TrinityCore 8.3.7 (Tiger Palm costs 50 of 100 energy, so a level 1 monk gets one
  about every 5 seconds).
- **Changed** (`sql/fixes/world/2026_11_16_49_wandering_isle_trainee_damage.sql`), our own tuning rather than TDB's:
  - Melee damage halved (`DamageModifier` 0.5) for the four trainee entries 54586, 54587, 65470, 65471.
  - Blackout Kick and Jab every 5 to 7 seconds instead of every 2.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Wandering Isle trainees fight one at a time

- **Found** (Four, 2026-11-16): during The Lesson of Stifled Pride (29524), hitting one Huojin or Tushui Trainee pulled the
  ones around it, and the group killed the player. Our four trainee templates (54586, 54587, 65470, 65471) used a monster
  faction (58) without TDB's civilian flag, so nearby trainees joined in. Their SmartAI mixed two script versions:
  duplicate event ids, a missing actionlist, and a 15-second faction reset on the Tushui trainees, which also had a core
  script on top.
- **Changed** (`sql/fixes/world/2026_11_16_48_wandering_isle_trainees.sql`):
  - TDB 8.3.7 template values for all four entries: Huojin faction 2263, Tushui faction 2101, civilian, no core script.
  - TDB 8.3.7's trainee SmartAI for all four: one-on-one fight, and at 10% health the trainee yields, gives the quest
    credit, says a line and leaves after 4 seconds. TDB gives the Huojin trainees no script (players had to kill them),
    so here they get the same yield script, casting Jab instead of Blackout Kick.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Northwatch caravans carry their lugs and crates

- **Found** (Four, 2026-11-16, screenshots): after 2026_11_16_44 the caravan carriers walked the road (visible in GM mode),
  but no lugs or crates rode with them. The core only loads `vehicle_template_accessory` rows for a vehicle that also has
  an `npc_spellclick_spells` row; the three caravans had none, so their passengers were dropped at startup.
- **Changed** (`sql/fixes/world/2026_11_16_47_northwatch_caravan_riders.sql`): Northwatch Caravan A/B/C (39244/39318/39319)
  get the standard Ride Vehicle Hardcoded 46598 click spell. The caravans have no spellclick npcflag, so players still
  can't click them.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: stray toy cart in Orgrimmar

- **Found** (Four, 2026-11-16, screenshot and `.gps` at The Drag 1805.9 -4531.8): a Toy Cart stood on its own next to
  Blax Bottlerocket, who already pulls his own. The loose Toy Cart 52812 (guid 299102) and its Toy Cart Bunny 52810
  (guid 299103) are leftovers: Blax's cart comes from his vehicle passengers (cart on Blax, bunny on the cart), and TDB 8.3.7
  spawns only Blax.
- **Changed** (`sql/fixes/world/2026_11_16_46_orgrimmar_toy_cart.sql`): the loose cart and bunny removed.
- **Not changed:** three stacks of fire elementals (Surging Elemental, Searing Fire Elemental, Agitated Fire Spirit and two
  others) at the same spot belong to the Elemental Invasion event (48) and only show while it runs.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Tirisfal Glades and Undercity follow-up

- **Found** (Four, 2026-11-16, screenshots and video):
  - Green fires burned on top of the Undercity bank. They are "Undercity - Forsaken - Fire Small" 193413, 13 in Undercity
    and 5 at the Ruins of Lordaeron, left over from Wrath's Battle for the Undercity. TDB 8.3.7 to 12.1.0 spawn none of them.
    The skulls' glowing eyes are part of the building and are not affected.
  - Two Forsaken Bats 51384 over Undercity's central area darted around. All 11 wandered 5 yards at the template's walk speed
    of 4.8 (12 yards a second). TDB has them hovering in place.
  - A Winter Veil wreath decoration ("Tall/Thin Medium - Xmas" 187234) hung at Calston Estate all year, with 6 more in Tirisfal
    and Deathknell. TrinityCore also spawns them all year, but they are Winter Veil models.
- **Changed** (`sql/fixes/world/2026_11_16_45_tirisfal_undercity_followup.sql`): the 18 fire effects removed; Forsaken Bats
  hover in place (MovementType 0); the 7 Tirisfal and Deathknell 187234 decorations tied to Winter Veil (event 2).
- **Not changed:** the same decoration stands all year in other zones (Elwynn, Dun Morogh, Westfall, Hillsbrad, Silverpine and others);
  those are left for those zones' reviews.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Northwatch supply caravans (Durotar)

- **Found** (Four, 2026-11-16, screenshots): on Durotar's south road Northwatch Supply Crates hung in the air with Northwatch
  Lugs standing inside and beside them, and "Northwatch Caravan A" men were only visible in GM mode. These are snapshots of
  moving caravans: an invisible carrier (Northwatch Caravan A/B/C 39244/39318/39319) whose vehicle seats hold the lugs and the
  crate they carry overhead (the crate seat sits higher, which is why the crates looked like they were floating). TDB 8.3.7
  has the same frozen crates and lugs (13 and 26) without the carriers. Our database already had the caravan script (start
  path 39244, make the passengers despawn at the end), but the path, the seat passengers and the spawners' script were missing.
- **Changed** (`sql/fixes/world/2026_11_16_44_northwatch_caravans.sql`):
  - The 67 frozen pieces removed: 17 carriers, 17 crates, 33 lugs.
  - Vehicle passengers (seats from VehicleSeat.db2): Caravan A = 3 lugs + crate, Caravan B = 1 lug + crate, Caravan C = 2 lugs + crate.
  - SAI path 39244: 9 points along the road from the spawners north, taken from where the frozen caravans stood. The
    caravan's end-of-path event now fires at point 9 instead of 10.
  - The three Northwatch Caravan Spawners 251643-251645 stand still and each send out a caravan (B, A, C) every 2 to
    2.5 minutes, staggered.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Gilneas review

- **Found:** Gilneas and Gilneas City compared with TDB 8.3.7. 139 Wolfmaw Outriders 37938 ran loose around the Battle for Gilneas lines (phase 189), where TDB has 35 Riding War Wolves 37939 carrying them plus 3 on foot. Tempest's Reach Watchmen (40, TDB 20), Attack Mastiffs (22, TDB 9) and Mountain Mastiffs (12, TDB 6) were doubled. 5 creatures and 15 objects stood twice on the same spot.
- **Changed** (`sql/fixes/world/2026_11_16_43_gilneas_review.sql`):
  - 183 creatures removed: Wolfmaw Outrider 139, Tempest's Reach Watchman 20, Attack Mastiff 13, Mountain Mastiff 6, Orc Raider 3, Forsaken Invader 2.
  - 35 Riding War Wolves and 3 Wolfmaw Outriders added at TDB's positions (guids 735400175-735400212, phase 189); each wolf brings its rider through the existing vehicle accessory row.
  - 15 doubled objects removed: Old Journal Page 6, Disturbed Soil 5, Moonleaf 2, Linen-Wrapped Book 1, Dustfall 1.
- **Not changed:** Gilneas has fewer battle NPCs than TDB in several phases (TDB has 123 Forsaken Infantry, 116 Worgen Warriors and 84 Gilnean Militia that we don't have at all). Adding them is a bigger job and would need your call. The Hippogryphs and a few Gilneas City NPCs standing close together are phase scenes, so they were left.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Kezan review

- **Found:** Kezan matches TDB 8.3.7 closely; ours has slightly fewer party NPCs, not more. One Kezan Citizen and 3 fire effects (phase 7) stood twice.
- **Changed** (`sql/fixes/world/2026_11_16_42_kezan_review.sql`):
  - Removed: Kezan Citizen 1, Kezan Small Fire - Phase 7 2, Kezan Large Fire - Phase 7 1.
- **Not changed:** Kezan's party fireworks and fires belong to the zone's own phases and stay.
- **Status:** untested in game.
- **Pick up:** run the SQL, restart `worldserver`.

### World: The Wandering Isle review

- **Found:** The Wandering Isle matches TDB 8.3.7 closely and has no extra creatures (TDB has more in some phases, e.g. Deepscale Ravagers in the turtle's wound). Two objects stood twice.
- **Changed** (`sql/fixes/world/2026_11_16_41_wandering_isle_review.sql`):
  - Removed: Kun-pai Ritual Charm 1, Explosive Bundle 1.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Tirisfal Glades review

- **Found:** Tirisfal Glades and Deathknell compared with TDB 8.3.7: several mobs doubled, e.g. Wretched Ghoul 67 (TDB 47), Wailing Ancestor 32 (15), Scarlet Zealot 38 (22), Tirisfal Farmer 21 (11). Brill's Midsummer torch-tossing bunnies, the Spirit of Summer and two ribbon pole targets showed all year, as did Brill's Hallow's End props (Wickermen, decorations, candy bucket, lamps) and the cauldrons and campfire TDB ties to Hallow's End.
- **Changed** (`sql/fixes/world/2026_11_16_40_tirisfal_glades_review.sql`):
  - 116 creatures removed: Wretched Ghoul 20, Wailing Ancestor 17, Decrepit Darkhound 16, Scarlet Zealot 16, Rotting Ancestor 12, Tirisfal Farmer 10, Rot Hide Mongrel 8, Scarlet Disciple 6, Rotbrain Magus 5, Scarlet Sentry 5, Scarlet Missionary 1.
  - Midsummer (1): Spirit of Summer 10651846, ribbon pole targets 352573 352544, torch bunnies 370240 370241 370253 370254 370308 370309 370242.
  - Hallow's End (12): objects 162730 162527 162533 162534 (TDB), 20358958-61 decorations, candy bucket 20361246, lamps 20359152-53, Alliance Wickerman 20363057, Horde Wickerman 20363435.
- **Not changed:** a door TDB also ties to Hallow's End (158047) stays permanent.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Mulgore review

- **Found:** Mulgore and Camp Narache were the most overspawned so far: Venture Co. Worker 105 (TDB 29), Venture Co. Supervisor 63 (6), Flatland Prowler 72 (4), Prairie Wolf Alpha 71 (7), Windfury Sorceress 44 (9), Windfury Matriarch 42 (13), Taloned Swoop 21 (2). TDB 8.3.7 through TC 12.1.0 all agree on the lower numbers. 12 herb nodes stood twice on the same spot.
- **Changed** (`sql/fixes/world/2026_11_16_39_mulgore_review.sql`):
  - 418 creatures removed: Venture Co. Worker 76, Flatland Prowler 68, Prairie Wolf Alpha 64, Venture Co. Supervisor 57, Windfury Sorceress 35, Elder Plainstrider 35, Windfury Matriarch 29, Taloned Swoop 19, Wiry Swoop 13, Palemane Skinner 8, Palemane Poacher 8, Palemane Tanner 6.
  - 12 doubled nodes removed: Ambercorn 6, Peacebloom 2, Silverleaf 2, Earthroot 2.
  - Spring Rabbit 10649757 tied to Noblegarden (9).
- **Not changed:** Bristleback Interlopers, Grimtotem Defenders and Vandals and Ghost Howl are not in TDB here but stay (TDB has none to compare with).
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Durotar review

- **Found:** Durotar, Valley of Trials and Echo Isles: a few mobs doubled, e.g. Encrusted Surf Crawler 43 (TDB 22), Dustwind Harpy 32 (17), Razormane Quilboar 29 (15), Burning Blade Fanatic 25 (13). The twelve Brew of the Month vendors at the Brewfest grounds stood all year, as did a Headless Horseman fire, a Hallow's End cauldron and a Spring Rabbit.
- **Changed** (`sql/fixes/world/2026_11_16_38_durotar_review.sql`):
  - 103 creatures removed: Encrusted Surf Crawler 21, Dustwind Harpy 15, Burning Blade Fanatic 14, Wildmane Cat 14, Docile Island Boar 14, Razormane Quilboar 14, Burning Blade Apprentice 6, Dustwind Storm Witch 4, Pygmy Surf Crawler 1.
  - Brew vendors 27806-27820 tied to their Brew of the Month events (34-45) as in TDB; fire 20500905 and cauldron 172811 to Hallow's End (12); Spring Rabbit 10647406 to Noblegarden (9).
- **Not changed:** The Kodo (6, not in TDB) and the Dranosh'ar Fishermen (match TDB) stay.
- **Status:** confirmed in game by Four (2026-11-16), apart from the Northwatch caravans (own entry).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Eversong Woods review

- **Found:** Eversong Woods and Sunstrider Isle: many mobs doubled, e.g. Springpaw Cub 68 (TDB 30), Darkwraith 35 (11), Arcane Patroller 38 (17), Rotlimb Marauder 69 (40), Mana Wyrm 80 (52). A ribbon pole target and a Spring Rabbit showed all year.
- **Changed** (`sql/fixes/world/2026_11_16_37_eversong_woods_review.sql`):
  - 228 creatures removed: Springpaw Cub 38, Rotlimb Marauder 29, Mana Wyrm 28, Darkwraith 23, Arcane Patroller 21, Angershade 13, Rotlimb Cannibal 12, Withered Green Keeper 12, Ether Fiend 12, Amani Shadowpriest 12, Amani Axe Thrower 11, Arcane Wraith 7, Wretched Thug 6, Tainted Arcane Wraith 4.
  - Ribbon pole target 353254 tied to Midsummer (1), Spring Rabbit 10652209 to Noblegarden (9).
- **Not changed:** Enraged Wraiths, Lake Snappers and the Blood Elf Revelers (not in TDB) stay.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Azuremyst Isle review

- **Found:** Azuremyst Isle and Ammen Vale: Timberstrider Fledgling 76 (TDB 30), Root Thresher 128 (97), Venture Co. Saboteur 16 (6), Venture Co. Gemologist 9 (3), owlbeasts and elemental spirits a little doubled. Spirit of Summer, a ribbon pole target, a bonfire bunny and a Spring Rabbit showed all year.
- **Changed** (`sql/fixes/world/2026_11_16_36_azuremyst_isle_review.sql`):
  - 112 creatures removed: Timberstrider Fledgling 46, Root Thresher 31, Venture Co. Saboteur 10, Deranged Owlbeast 7, Venture Co. Gemologist 6, Raving Owlbeast 5, Spirit of Water 4, Spirit of Fire 3.
  - Midsummer (1): Spirit of Summer 10653172, ribbon pole target 353211, bonfire bunny 353222; Spring Rabbit 10652904 to Noblegarden (9).
- **Not changed:** Angry Murlocs (not in TDB) stay.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Teldrassil review

- **Found** (Four, 2026-11-16, starter zones). Teldrassil and Shadowglen compared with TDB 8.3.7: close to TDB, with only
  a few extra Vicious Grells (12, TDB 7) and Giant Webwood Spiders (8, TDB 5), three Boglings stacked on one spot, and 6 Fel
  Cone quest objects standing twice. A Midsummer bonfire bunny and a Spring Rabbit showed all year, and none of the
  world's 194 Noblegarden Bunny Controllers were tied to Noblegarden.
- **Changed** (`sql/fixes/world/2026_11_16_35_teldrassil_review.sql`): 5 Vicious Grells, 3 Giant Webwood Spiders and 2 of
  the 3 Boglings removed; the 6 doubled Fel Cones removed; bonfire bunny 353124 linked to Midsummer (1), Spring Rabbit
  10649606 to Noblegarden (9); every Noblegarden Bunny Controller 32784 linked to Noblegarden (9).
- **Not changed:** critters and wild pets; herbs (as in Elwynn); the 63 large Fel Cone props 208046 sitting on the quest cones (decoration only).
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Gnomeregan convoys and Gnome Travelers march

- **Found** (Four, 2026-11-16): on the road between New Tinkertown and Kharanos, 18 Gnomeregan Recruits, each stacked with
  an Ammo Cart and a cart helper, and 6 Gnome Travelers on mechastriders stood frozen. They are snapshots of groups that
  move in retail. No TrinityCore dump (6.0.4 to 12.1.0) scripts them. Our database had half a script (the recruit
  summons its cart and hitches it), but it was attached to spawn ids that no longer exist, and its 4-minute cart timer was
  shorter than the walk.
- **Changed** (`sql/fixes/world/2026_11_16_34_gnomeregan_convoys.sql`):
  - The 54 frozen convoy NPCs and 6 travelers are removed.
  - 3 Gnomeregan Recruits (guids 735400169-171) start at three points of the road. Each summons and hitches its own
    Ammo Cart (actionlist 4327601, cart lasts 15 minutes), walks from New Tinkertown toward Kharanos (SAI waypoints
    7354164-7354166, using the server's pathfinding), despawns the cart and itself at the end and respawns after 60 seconds.
  - 3 mounted Gnome Travelers (guids 735400172-174, formation led by 735400172) ride the same road the other way (path
    7354167) and despawn together at New Tinkertown.
  - The route points are the frozen snapshots' own positions, so the stretches between them follow pathfinding, not a sniff.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Dun Morogh review

- **Found** (Four, 2026-11-15, starter zones). Dun Morogh, Coldridge Valley and New Tinkertown compared with TDB 8.3.7.
  Unlike Elwynn the zone is close to TDB overall; only some mobs were doubled: Crazed Leper Gnome 77 (TDB 40), Target
  Acquisition Device 46 (15), Young Snow Leopard 76 (50), Rockjaw Invader 27 (11), Living Contamination 32 (19), Dark Iron
  Spy 28 (16), Winter Wolf 48 (37), Snow Leopard Cub 26 (16). A Dark Iron Golem, a Rockjaw Backbreaker and a Wendigo stood
  twice. Only 1 of TDB's 4 Keg of Gnomenbrau quest objects was spawned. A ribbon pole target and bonfire bunny (Midsummer)
  and a Spring Rabbit (Noblegarden) showed all year.
- **Changed** (`sql/fixes/world/2026_11_16_33_dun_morogh_review.sql`):
  - 190 extra creatures removed, same matching as Elwynn: Crazed Leper Gnome 42, Target Acquisition Device 31, Young Snow
    Leopard 26, Living Contamination 18, Rockjaw Invader 16, Dark Iron Spy 12, Winter Wolf 11, Snow Leopard Cub 10, Rockjaw
    Skullthumper 9, Dark Iron Pyromancer 5, Crushcog Sentry-Bot 4, Rockjaw Scavenger 3, and the three doubles.
  - Critters and wild battle pets untouched. Warstrider Prototypes, launchers, Sanitron 500 and the S.A.F.E. Operatives
    look doubled but match TDB, so they stay. The Dark Iron Invaders at the airfield (71, not in TDB) stay too.
  - 3 Keg of Gnomenbrau objects added from TDB (guids 735400102-104).
  - Event links: ribbon pole target 352654 and bonfire bunny 352653 to Midsummer (1), Spring Rabbit 10646516 to Noblegarden (9).
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Elwynn Forest review

- **Found** (Four, 2026-11-15: zone review, starter zones first). Compared against TrinityCore TDB 8.3.7 (the full world
  DB for this client build; TC 9.2.7 to 12.1.0 have the same Elwynn spawns):
  - Most Elwynn mobs were spawned about twice: two overlapping spawn sets, often a few yards apart. Mangy Wolf 170 (TDB 85),
    Prowler 140 (74), Murloc Forager 124 (62), Stonetusk Boar 101 (47), Murloc Lurker 94 (43), Rockhide Boar 148 (87).
  - Stormwind Royal Guard 42218: 15 guards stood in two blobs on the road south of Goldshire (8 and 5) plus singles. They are
    snapshots of TDB's mounted 9-guard patrol from the Stormwind gate to Eastvale.
  - Morgaine the Sly, Bradford and Ashley Bridenbecker and an Expeditionary Priest stood twice; 3 Stormwind Guards and 2
    Eastvale Peasants stood inside each other.
  - Holiday pieces shown all year: the Goldshire Wickerman's torch points and crowd bunnies, the Alliance Wickerman object
    and 10 Hallow's End decorations (Hallow's End), a ribbon pole target (Midsummer), a Spring Rabbit (Noblegarden) and a
    moonlight object at the Stormwind gate (Lunar Festival).
- **Changed** (`sql/fixes/world/2026_11_16_32_elwynn_forest_review.sql`):
  - 634 extra creatures removed. Each TDB spawn keeps its nearest match of ours and the unmatched extras go, down to the TDB
    count: Mangy Wolf 86, Prowler 66, Murloc Forager 62, Rockhide Boar 61, Stonetusk Boar 54, Murloc Lurker 51, Cow 37,
    Riverpaw Outrunner 32, Gray Forest Wolf 28, Cutpurse 25, Young Forest Bear 24, Bandit 23, Kobold Tunneler 16,
    Forest Spider 15, Riverpaw Runt 9, Young Wolf 7, Dockworker 5, Murloc Streamrunner 5, Longsnout 4, plus the doubles above.
  - Never touched: critters and wild battle pets (the pet battles thread owns those), rares and elites, NPCs with a menu,
    friendly NPCs, fireworks, holiday spawns, and anything pathed, pooled, linked or scripted.
  - Royal Guards: the 15 static guards (and the old one-way path 178448) replaced by TDB's patrol, guids 735400160-168,
    path 735400163, formation led by 735400160, which despawns the escort at Eastvale and respawns at the gate after 2 minutes.
  - Morgaine the Sly 177291 stands still (TDB).
  - Event links: 13 Wickerman creatures and 11 Wickerman/decoration objects to Hallow's End (12), ribbon pole target 352657
    to Midsummer (1), Spring Rabbit 10647297 to Noblegarden (9), moonlight object 19728596 to Lunar Festival (7).
- **Not changed:** herb and ore nodes (Silverleaf 109 vs TDB 28, Copper Vein 110 vs 37); they rarely overlap, so they stay
  unless you want them trimmed.
- **Status:** confirmed in game by Four (2026-11-16).
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-16 (World fixes: the remaining cities pass)

Merged to `main` with PR #75 on 2026-11-16 (untested in game at merge).

### World: foreign object and NPC names

- **Found** (Four, 2026-11-15: pass of Stormshield, Shrine of Seven Stars, Boralus, Dazar'alor, Warspear, Dalaran and
  Shattrath). Stormshield and Warspear objects had French names (mailboxes "Boîte aux lettres", "Échelle", "Clé gnome").
  The whole world has the same problem: 293 spawned object templates carry French names (mostly Draenor props), a few
  Russian or broken ones (Argus "Lighthouse Vindicarа", carts and buckets in Cyrillic). Creatures: Genn Greymane 95891 was
  "Genn Grisetête", Gidwin Goldbraids 100197 "Gidwin Nattes-d'Or", Dave's Gyrocopter 91083 French, Kin'garoth 120354 a
  broken apostrophe, and the Traveler's Tundra Mammoth and Grand Expedition Yak vendors (32641, 32642, 62821, 62822)
  were named "0".
- **Changed** (`sql/fixes/world/2026_11_16_30_foreign_object_and_npc_names.sql`): 274 object names taken from TrinityCore
  TDB 7.3.5, 18 translated by hand (Mailbox, Smoke, Guts, Training Arena, Cart, Oar, ...).
  The 8 creature names (and the vendors' subnames) set to their English names.
- **Also** (Four, 2026-11-15, TDB 8.3.7 added to the dumps repo): 37 creature templates named "0" or with no name, among
  them the Zandalar critters seen about 2,100 times (Shadric Crawler 130448, Temple Beetle 130441, Jungle Gulper 130445,
  Mosquito 125455, Emerald Boa 130699, Root Frog 132447, ...), four 7th Legion troops, Thaumaturge Vashreen and Argus quest
  bunnies, take their names from TrinityCore TDB 8.3.7; object 273846 is the Crown Pedestal.
- **Status:** untested. Objects and NPCs you have already seen may keep the old name until the client `Cache` folder is deleted.
- **Pick up:** run the SQL, restart `worldserver`, delete the client `Cache` folder.

### World: Stormshield, Warspear, Boralus, Dazar'alor, both Dalarans and Shattrath pass

- **Found:** same checks as the capitals. TDB 7.3.5 covers Stormshield, Shattrath and Northrend Dalaran; Warspear, Boralus,
  Dazar'alor and Broken Isles Dalaran have no reference, so there only clear doubles were looked for.
  - Shrine of Seven Stars: nothing to fix.
  - Stormshield: the two Stormshield Officers 86433 and the cart horses 88194 stood still; TDB walks them.
  - Warspear: two Warspear Grunts 86472 stood inside two other Warspear Grunts 86460.
  - Boralus: overlapping sniffs left 42 creatures twice, among them Katherine Proudmoore, Captain Cunningham, Diana
    Seafinch, Tabrina, Erma Milforth and Aurora (three each), Urban Planner Volrath, Constable Taylor and the children with
    their pets (Lilly, Jack, Mika, Kenshi, Gizmo, Holly, Elsie, Xander, Val, Sir Reginald). 934 objects stood two to four
    times on the same spot: chairs (526), benches, stools, braziers, campfires, mailboxes, rune traps.
  - Dazar'alor: 32 doubles: the pet trainers' pets (Bailey, Iron Starlette, Nibbler, Nuts, Piper three each), Enchantress
    Quinni (three), the Bloodscalp, Revantusk and Shatterspear Speakers, Huk, Spears, Simi, Heal Bot, Da White Shark,
    Encyclopedia Antagonistica.
  - Dalaran (Broken Isles): the yak vendors stood at map origin (0, 0, 0); 10 chairs, stools, a bench, a mailbox and The
    Arsenal Absolute were placed twice; 117 autumn decorations (named "... - Brewfest", Pilgrim's Bounty everywhere else)
    and the Battered Brewmaster 40441 stood out all year.
  - Dalaran (Northrend): 24 Skybreaker Marines 30352 at Krasus' Landing, six on each of TDB's four spots; the mammoth and yak
    vendors at map origin.
  - Shattrath: Salandria 22914 twice; 2 Avatars and 13 Minions of Terokk (hostile, only summoned by a Skettis quest event,
    not in TDB) stood in Lower City; 12 Farm Chickens where TDB has 5.
  - Checked and left alone: Boralus and Dazar'alor pterrordaxes and gryphons (perched, no reference to say otherwise),
    critter stacks (pooled or moving), training dummies, Shattrath and Dalaran dungeon image platforms (images share a spot
    on purpose), Stormshield Peasants (working emotes).
- **Changed** (`sql/fixes/world/2026_11_16_31_remaining_cities_pass.sql`):
  - Stormshield: officers and one horse replaced by TDB's walkers (guids 735400156-735400158), horse 10181767 walks path
    735400159.
  - Warspear 2, Boralus 42 creatures and 934 objects, Dazar'alor 32, Broken Isles Dalaran 2 creatures and 10 objects,
    Northrend Dalaran 23 (20 marines, 3 vendors), Shattrath 23 removed. The lowest guid of each double is kept.
  - Broken Isles Dalaran: autumn decorations in game_event 26 (Pilgrim's Bounty), Battered Brewmaster in 24 (Brewfest).
  - Boralus harbor (TrinityCore TDB 12.1.0, positions and paths only): Harbor Guard Captain 210321508, Harbor Guard Cadet
    280001882 and Tradewinds Tailor 280001932 walk their sniffed routes (paths 735400160-735400162); Tradewinds Dockworker
    210320946, a still copy on the route Dockworker 280001893 walks, removed. The other 13 sniffed walkers already walk here.
    TDB 9.2.7 to 12.1.0 have no Warspear or Dazar'alor spawns and only the harbor of Boralus (110 Harbor Guards there, 104
    here), so the rest of these cities could not be compared.
- **Status:** untested.
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-15 (Professions: trainer recipes)

### World: crafting trainers teach every trainer recipe, at the right skill

- **Found** (Four, 2026-11-15): Karn Stonehoof (Thunder Bluff) at Blacksmithing 44 never offered Rough
  Grinding Stone (25), Runed Copper Gauntlets (40), Copper Chain Belt (35), Copper Chain Pants (1),
  Copper Chain Boots (20) or the Copper weapons; Alliance blacksmiths too. Cause, for every crafting
  profession:
  - Most trainers use HavenCore-made lists (`VerifiedBuild` 0): 991 Blacksmithing, 993 Engineering, 990
    Leatherworking, 122 Alchemy, 119 Jewelcrafting. They ask for the recipe's yellow skill instead of
    the skill it is learned at (Rough Grinding Stone 45 instead of 25, Copper Chain Pants 50 instead of 1,
    Copper Chain Belt 75 instead of 35, Runed Copper Gauntlets 80 instead of 40). They have no Outland,
    Northrend or Pandaria recipes, and list 119 has only 27 Classic Jewelcrafting recipes.
  - Blizzard's own 8.0 lists are in the dump and complete (27 Blacksmithing, 62 Enchanting, 407 Engineering,
    63 Inscription, 29 Jewelcrafting, 56 Leatherworking, 163 Tailoring, 136 Cooking), but they ask for the
    profession skill on the old scale (Blacksmithing 350 for a Northrend recipe). The expansion skills
    never reach that, so those recipes stayed unavailable.
  - Sungshin Ironpaw (64231, Pandaria cooking) opened the old fallback list.
- **Changed:** `sql/fixes/world/2026_11_15_80_profession_trainer_recipes.sql` (`bfa_world`):
  - 11,463 `trainer_spell` rows, 7,863 of them new: every trainer list that teaches a profession's Classic
    skill (so every crafting trainer, the Kul Tiras and Zandalar ones included) teaches that profession's
    full Classic to Pandaria recipe set:

    | Profession | Recipes | Classic | Outland | Northrend | Cataclysm | Pandaria | Lists |
    |---|---|---|---|---|---|---|---|
    | Alchemy | 135 | 43 | 12 | 35 | 42 | 3 | 59, 105, 122, 846, 847, 987 |
    | Blacksmithing | 240 | 82 | 15 | 92 | 35 | 16 | 27, 37, 80, 695, 817, 991, 133536 |
    | Cooking | 61 | 20 | 3 | 16 | 2 | 20 | 136, 582, 858, 995 |
    | Enchanting | 185 | 63 | 18 | 39 | 35 | 30 | 51, 62, 125, 831, 832 |
    | Engineering | 225 | 80 | 36 | 43 | 30 | 36 | 102, 126, 405, 406, 407, 873, 874, 993 |
    | Inscription | 139 | 54 | 8 | 22 | 26 | 29 | 63, 383, 387, 786, 789, 790, 791, 836, 837 |
    | Jewelcrafting | 253 | 49 | 26 | 62 | 38 | 78 | 29, 48, 119, 608, 821, 822, 19778 |
    | Leatherworking | 270 | 108 | 33 | 73 | 30 | 26 | 4, 56, 103, 826, 827, 990 |
    | Tailoring | 227 | 103 | 8 | 62 | 40 | 14 | 117, 157, 163, 774, 863, 864 |

  - Each recipe requires its own expansion skill (`ReqSkillLine`), for example Classic Blacksmithing
    2477 or Northrend Blacksmithing 2475, at the skill it is learned at (`ReqSkillRank`):
    - Recipe set and Classic skill come from Blizzard's 8.0 list above. Alchemy has no Blizzard list in
      the dump, so it uses the Mists of Pandaria 5.4.8 trainer data, keeping only recipes the 8.3.7 client
      still has as Alchemy recipes.
    - Expansion recipes use the 1-75 scale: old skill minus 300 (Outland), 375 (Northrend), 450
      (Cataclysm) or 525 (Pandaria), at least 1. Blizzard's own 8.0 rows for Cataclysm recipes use
      exactly old minus 450. Examples: Rough Grinding Stone 3320 at Classic 25; Copper Chain Pants 2662
      at 1; Copper Chain Boots 3319 at 20; Copper Chain Belt 2661 at 35; Runed Copper Gauntlets 3323 at
      40; Copper Mace 2737 at 15; a Northrend recipe learned at 415 (55185) at Northrend 40.
    - The 18 Pandaria cooking recipes from list 582 need Pandaria Cooking 1, which is where the 8.3.7
      client rates them (yellow 1, grey 10).
    - `MoneyCost` is the highest cost any source lists. There is no level requirement: the expansion
      skill itself is gated by level (2026_11_09_02).
  - `creature_trainer` (64231, 582, 0, 3): Sungshin Ironpaw opens list 582.
  - Each list's rows for these recipes are deleted first, so the file is safe to run more than once. Ran
    twice in a test database with the dump's trainer rows: 7,863 rows added each time, no other row
    touched.
- **Not changed:**
  - Draenor and Legion recipes: trainers did not sell them in 8.x (garrison buildings and quests).
  - Kul Tiran recipes: already on the Kul Tiras and Zandalar lists.
  - The six Ironpaw way masters in Halfhill: their way recipes are no longer cooking recipes in the 8.3.7
    client.
  - 28 extra Pandaria Jewelcrafting rows on list 608, 18 old rows on list 582, and 3 other old rows are
    left as they were.
- **Status:** confirmed in game 2026-11-15 (Four, blacksmithing trainers).

#### To pick up the recipe fix
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-2e6el5
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_15_80_profession_trainer_recipes.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

## 2026-11-14 (core)

### Chat: character posts ".ticket CUticketGet" in guild chat

Merged to `main` with PR #73 on 2026-11-14.

- **Found** (Four, 2026-11-14): the character keeps saying `.ticket CUticketGet` in guild chat
  without typing it.
- **Cause:** the WoW Circle client's built-in ticket UI polls the server by sending chat commands
  such as `.ticket CUticketGet` (the WoW Circle server answers them; HavenCore has no `CU...` ticket
  subcommands). `WorldSession::HandleChatMessage` hands every message to
  `ChatHandler::ParseCommands` first; for a player the unknown subcommand makes it return false, so
  the text continued down the normal path and was broadcast to the chat type the client used
  (guild here).
- **Changed:** new `tools/bfa/client-ticket-poll.patch`
  (`src/server/game/Handlers/ChatHandler.cpp`, `WorldSession::HandleChatMessage`): any message that
  starts with `.ticket CU` is dropped at the top of the function, before the language, mute and
  command checks, so nothing is sent to any channel and no error is shown. A debug line
  (`network` logger) records each dropped poll. Real `.ticket` GM commands (`.ticket list`, etc.)
  are unaffected. No SQL.
- **Status:** the patch applies cleanly after the full chain on upstream 2c13546 and
  `ChatHandler.cpp` compiles. Merged to `main` on 2026-11-14 at Four's request; not yet confirmed in
  game.

#### To pick up the ticket poll fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/client-ticket-poll.patch && echo "ticket poll patch applied"
grep -c "ticket CU" src/server/game/Handlers/ChatHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2. Then restart `worldserver`.
## 2026-11-14 (guild progression)

Merged to `main` with PR #72 on 2026-11-14.

### Guild: guild reputation, guild achievements and the guild vendor locks can be earned

- **Found** (Four, 2026-11-14, pet battles thread): the guild vendors (Shay Pressler in Stormwind,
  Randah Songhorn in Thunder Bluff...) show 28 of 68 items. Four wants the retail locks kept but the
  guild system working, so the locks can be earned.
- **Causes:**
  - Guild reputation (faction 1168) was never granted by anything in the core, so every member stayed
    Neutral. Every guild reward needs Friendly to Exalted, and most guild achievements only count members
    at Honored (profession, class and reputation achievements: modifier 62 = guild reputation >= 9000,
    or 42000 for United Nations / Pandaren Embassy).
  - Vendor locks on guild achievements (`CONDITION_ACHIEVEMENT`, type 17) were checked with
    `Player::HasAchieved`, the character's own achievements. Guild achievements live on the guild, so
    the check could never pass.
  - Mix Master, Better Leveling Through Chemistry, Master Crafter and Set the Oven to "Cataclysmic"
    (criteria types 126 CRAFT_ITEMS_GUILD / 79 COOK_RECIPES_GUILD) were never credited: nothing in the
    core reported crafted items to the guild.
  - `SPELL_AURA_MOD_REPUTATION_GAIN` (156) ignored its MiscValue, which is a faction filter in 8.3.7. The
    Guild Champion tabard auras 97340 (+50%) / 97341 (+100%) are filtered to faction 1168 and would have
    boosted every reputation (same for the per-faction 50% bonuses of spells 335149-335152).
  - The vendor data was Cataclysm-era: 16 items were locked behind "Guild Level 5/10/15/20/25"
    (achievements 4943-4946, 4912), which have no criteria since guild levels were removed in 6.0
    (Reins of the Golden King, Reins of the Kor'kron Annihilator, Wrap of Unity, Guild Vault Voucher
    (7th Slot), old Cataclysm heirlooms). Guild Herald 65363/65364 had Alliance/Horde swapped, Guild Page
    65362 (Horde) asked for the Alliance-side Horde Slayer, the 7th slot voucher used a negated check.
    The Pandaria/Draenor rewards were missing. The BFA vendors Perry Charlton 142086 (Boralus) and Ulla
    Skycloven 142185 (Dazar'alor) had the BFA list but no locks at all.
  - The guild roster's guild reputation column was always 0.
- **Changed** (`tools/bfa/guild-progression.patch`, new, applies after `dire-maul-north.patch`):
  - `Player::RewardQuest`: a guild member who turns in a quest that is not gray to them (quest level
    above `Trinity::XP::GetGrayLevel`) gets guild reputation. Retail: 1 reputation per 360 guild
    experience, 60,000 guild experience per quest, about 167. The base is
    `Guild.QuestReputation` in worldserver.conf (default 167, 0 turns it off; the setting is optional),
    then the normal reputation bonuses apply (Guild Champion tabards, Diplomacy, `Rate.Reputation.*`).
  - `ConditionMgr` `CONDITION_ACHIEVEMENT`: an achievement with the guild flag (0x4000) is checked on
    the player's guild (`Guild::GetAchievementMgr().HasAchieved`); no guild = not met.
  - `Player::CalculateReputationGain`: aura 156 counts only when its MiscValue is 0 or the faction.
  - `Spell::DoCreateItem`: an item made with a profession recipe credits the guild with
    CRAFT_ITEMS_GUILD (or COOK_RECIPES_GUILD for Cooking), item id + count; the achievements' own
    filters (flask, food, epic, item level) do the rest.
  - `Guild::Member::SetStats`: the roster shows each member's guild reputation (updated at login,
    level-up and logout).
  - `.achievement add <id>` on a guild achievement gives it to the selected player's guild (GM testing).
  - `Map::GetOwnerGuildId` (Four's choice, 2026-11-14): a guild member alone in a dungeon, raid or
    scenario, not in a group, counts as a guild group. Every guild-run credit in the core goes through
    it (boss kills, encounters, scenarios, guild runs of the Dungeon Hero / Glory / Scenario Roundup /
    Challenge Gold achievements). `Guild.SoloGuildGroup = 0` in worldserver.conf restores the retail
    rule (3 of 5 / 80% of the group from one guild); the setting is optional, default 1.
- **Changed** (`sql/fixes/world/2026_11_14_70_guild_vendor_locks.sql`):
  - All 12 guild vendors sell the BFA list: Alliance vendors (Shay Pressler 46602, Steeg Haskell 51495,
    Nuri 51501, Velia Moonbow 51504) Perry Charlton's 54 items, Horde vendors (Goram 46572, Kim Horn
    51496, Larissia 51502, Randah Songhorn 51503) Ulla Skycloven's 54, Mirla Silverblaze 51512 (Dalaran)
    and Riha 52268 (Shattrath) both (64). The old Cataclysm heirlooms (replaced by the 6.1 ones) are gone;
    the Pandaria/Draenor rewards are added (Initiate's/Member's/Officer's Shirts and their Tailored /
    Artisan versions, Reins of the Thundering Jade Cloud Serpent, Deathwatch Hatchling, Blacksteel
    Battleboar, Garrison Guild Banners).
  - Every item that is in `guild_rewards` (the guild window's Rewards tab) gets exactly its locks:
    guild reputation rank, the listed guild achievements, and Alliance/Horde from its race mask. Rewards
    that list one achievement per faction (United Nations, Pandaren Embassy, Scenario Roundup) accept
    either. The 6.1 heirlooms stay unlocked (not guild rewards). 1,294 condition rows.
  - Backups: `zr_guild_vendor_backup_npc_vendor`, `zr_guild_vendor_backup_conditions`.
- **What is earnable solo:** both tabards and Reins of the Golden King / Kor'kron Annihilator, Wrap of
  Unity, Guild Vault Voucher (7th slot) need reputation only (plus Extended Storage for the voucher).
  Achievements done by the guild's members (professions, A Class Act, Profit Sharing, A Daily Routine,
  That's a Lot of Bait, Critter Kill Squad, crafting/cooking, United Nations, Pandaren Embassy, Stay
  Classy, Guild Vault) count every member, alts included. The guild-run ones (Guild Cataclysm /
  Pandaria / Draenor Dungeon Hero, the Guild Glory raid ones, Scenario Roundup, Challenge Warlords Gold
  Guild Edition) count solo runs (see `Guild.SoloGuildGroup`). The Horde/Alliance Slayer ones need
  honorable kills on players of each race and class, so the Guild Page stays out of reach solo.
- **Not done:** retail also gave guild reputation for boss kills and rated wins in guild groups and for
  honorable kills; only quests do here.
- **Status:** guild reputation from quests confirmed in game by Four (2026-11-14). Vendor locks, solo
  guild runs and crafting credit not tested in game yet. Merged to `main` with PR #72 on 2026-11-14.
- **Pick up:**

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-ouu80u
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/guild-progression.patch | git apply
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_14_70_guild_vendor_locks.sql | mysql -u root -p bfa_world
  ```

  Then restart `worldserver`.

## 2026-11-14 (pet battles)

### Pet battles: Battle Pet Training costs 10 silver instead of 10 gold

- **Found** (Four, 2026-11-14, screenshot): Battle Pet Training (spell 119467, "Requires: Level 5")
  costs 9g 50s at a battle pet trainer, far too much for a starter-zone spell.
- **Cause:** the 12 battle pet trainer lists in `npc_trainer` (63014, 63061, 63067, 63070, 63073,
  63075, 63077, 63080, 63083, 63086, 63596, 63626) list 119467 at `MoneyCost` 100000 (10g). The
  window shows 9g 50s because Friendly reputation with the trainer's faction takes 5% off
  (`Player::GetReputationPriceDiscount`).
- **Changed:** `sql/fixes/world/2026_11_14_50_battle_pet_training_cost.sql` sets `MoneyCost`
  100000 -> 1000 (10s) for spell 119467 in `npc_trainer`, and in `trainer_spell` too in case an update
  added it there (the dump has no such row). At Friendly it shows 9s 50c. Docs: Pet battles section.
- **Status:** confirmed in game by Four (2026-11-14): Battle Pet Training now shows 9s 50c at a trainer. SQL output: `12 trainer lists at 10s, 0 left at another price`.
- **Pick up:**

  ```
  cd ~/bfa/source
  git -C ../tools-repo pull
  mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_11_14_50_battle_pet_training_cost.sql
  ```

  Then restart `worldserver`.

## 2026-11-14 (World fixes: Horde and Alliance capital city pass)

Merged to `main` with PR #70 on 2026-11-14.

### World: Thunder Bluff overspawns, a Spanish Baine, standing wind riders and guards

- **Found** (Four, 2026-11-14: "Baine pezuña de sangre" in Thunder Bluff; asked for a full pass of the city
  for double spawns, foreign names, pathing and standing flyers). Every spawn in zone 1638 (726 creatures,
  907 gameobjects) was compared with TrinityCore TDB 7.3.5:
  - Baine pezuña de sangre 130773 (faction 35, level 1, no gossip): a Spanish-named copy of Baine
    Bloodhoof from a BFA scene, spawned twice (guids 6740131 in Baine's hut next to the real Baine 36648,
    6740132 near Hunter Rise). It is the only non-English creature or object name in the city.
  - Thunder Bluff Wind Rider 51372: 13 riders hanging still in the air (sniffed snapshots of patrols).
    TDB has 9: 5 leaders on flight paths, two of them with two wingmen in formation.
  - Ground patrols were snapshots too: 7 Bluffwatchers 3084 and 1 Honor Guard 3083 stood where no
    guard stands in TDB, Bluff Runner Windstrider 10881 and Chepi 8361 were each spawned twice, Hunter
    Sagewind 14440 and Hunter Ragetotem 14441 stood away from their routes. TDB walks 6 Bluffwatchers,
    1 Honor Guard, Windstrider, Chepi and both hunters on waypoint paths; none of them had a path here.
  - Four guild reward pets (Dark Phoenix Hatchling, Armadillo Pup, Lil' Tarecgosa, Thundering Serpent
    Hatchling) stood on exactly the same spot at the guild vendor.
  - Midsummer pieces on Elder Rise were not in the event, so they stood there all year: Spirit of Summer
    16701, Ribbon Pole Debug Target 17066 and 7 torch tossing / catching bunnies (25535, 25536, 26188).
    A second Lunar Festival TEMP Greater Moonlight (guid 19728807) stood next to the event's own.
  - Checked and left alone: the other 18 Bluffwatchers and 5 Honor Guards match TDB's posts; no two
    copies of the same NPC stand together anywhere else; the Cataclysm invasion elementals and Earthen
    Ring defenders (258 spawns) are in a game event that never runs; holiday decorations that are in their
    events (Winter Veil gifts, Hallow's End haystacks, Lunar Festival fireworks) are left as they are.
- **Changed** (`sql/fixes/world/2026_11_14_30_thunder_bluff_pass.sql`):
  - 130773 spawns removed, template name set to "Baine Bloodhoof".
  - 27 snapshot spawns removed (13 wind riders, 7 Bluffwatchers, Honor Guard 260252, two Windstriders,
    two Chepis, the two hunters) and TDB's 19 spawns added (guids 735400003-735400021) with 16 waypoint
    paths (599 points, ids 735400003-735400018, 735400021, 735400200) and two wind rider formations.
    Bluffwatcher 260098 keeps its spot and walks TDB's path 735400200.
  - The four guild pets wander 2 yards.
  - Midsummer spawns in game_event 1, the extra Moonlight in game_event 7.
- **Status:** confirmed in game by Four (2026-11-14).
- **Pick up:** run the SQL, restart `worldserver`.

### World: Orgrimmar, Undercity and Silvermoon City pass

- **Found** (Four, 2026-11-14: "do the same once over for Orgrimmar, Undercity, and Silvermoon"). Same checks
  as Thunder Bluff, against TrinityCore TDB 7.3.5. No foreign names in any of the three cities.
  - Orgrimmar, exact doubles: Voidbinder Zorlan 68979 and the "Take a potion" marker 137762 three times each,
    two Orgrimmar Grunts on other grunts, a Thunder Bluff Protector 72559 and a Skyway Peon 44158 on their twins.
  - Orgrimmar front gate: eight Mag'har (Grunt, Giantslayer, Warder, Warrior, Blademaster) stood inside
    Orgrimmar Grunts, two models on one spot.
  - Orgrimmar patrols: eleven named walkers stood off their routes (Scouts Stronghand, Manslayer, Tharr and
    Obrok, Krixx, Felika, Grunt Karus, Witch Doctor Umbu, Engineer Niff, Blax Bottlerocket, Craven Drok) and
    Snang, Muraga and Xan'tish had a second, standing copy. Grunts, Siegeworkers, Skyway Peons, Darkspear
    Headhunters, Bruisers, Braves and the Chief Engineer had extra copies frozen along TDB's patrol routes
    (sniff snapshots of walkers), while the walkers themselves were missing.
  - Stacked companion pets: guild reward pets (Orgrimmar and Silvermoon), the Children's Week pets at the
    Orgrimmar orphanage, Warbot with Blue Clockwork Rocket Bot.
  - Midsummer pieces out all year in Orgrimmar and Silvermoon (Spirit of Summer, torch tossing / catching
    bunnies); Lunar Festival lanterns, firecrackers and a second Moonlight out all year in Orgrimmar.
  - Undercity: Apothecary Katrina 5732 stood twice and Hepzibah Sedgewick 5747 off her route. The rest of the
    city matches TDB (the cages full of animals in the Apothecarium are stacked in TDB too).
  - Silvermoon: Brooms 17213 (17 here, 6 in TDB), Arcane Guardians 18103 and City Guardians 16222 frozen on
    TDB's patrol routes, their walkers missing.
  - Checked and left alone: Orgrimmar's BFA refugee camp, war campaign NPCs and Mag'har at the gate (not
    stacked), the Orgrimmar wind riders (fixed in `2026_11_12_34`), city bonfires, critter stacks already in pools.
- **Changed** (`sql/fixes/world/2026_11_14_31_orgrimmar_undercity_silvermoon_pass.sql`):
  - Orgrimmar: 16 doubles and Mag'har copies removed; 70 standing copies replaced by TDB's 39 walkers
    (guids 735400022-735400060, paths of the same ids), Darkspear Headhunters 266061 and 266090 walk TDB's
    routes (paths 735400061-735400062); pets wander 2 yards; Midsummer bunnies in game_event 1, Lunar pieces in 7.
  - Undercity: 3 spawns replaced by TDB's Katrina and Hepzibah on their paths (guids 735400063-735400064).
  - Silvermoon: 15 standing copies replaced by TDB's 10 walkers (guids 735400065-735400074), Broom 68155 walks
    path 735400075; guild pets wander 2 yards; Midsummer spawns in game_event 1.
  - `2026_11_14_30` now uses path id 735400200 for Bluffwatcher 260098 (735400037 is an Orgrimmar walker).
- **Status:** confirmed in game by Four (2026-11-14).
- **Pick up:** run `2026_11_14_30` (again, if you ran it before) and `2026_11_14_31`, restart `worldserver`.

### World: Stormwind, Ironforge, Darnassus and Exodar pass

- **Found** (Four, 2026-11-14: "do the same with the Alliance cities of Stormwind, Ironforge, Darnassus, and
  Exodar"). Same checks as the Horde cities, against TrinityCore TDB 7.3.5. No foreign names in any of the four.
  - Stormwind, doubles: the fishing kids Justin 1368, Brandon 1370 and Roman 1371 at the canal, three Stormwind
    Orphans 14496, a Dockhand 29019, Vereesa Windrunner 121754 and Vindicator Boros 121756 at the harbor and
    Ambassador Moorgard 133362 each stood twice; Orphan Matron Nightingale 51988 stood inside 14450 and Celestine
    of the Harvest 44395 inside 44396. Objects placed twice: ice cream shop scoops, cones and ice, the Shady Lady
    figurine and silver bar, five flower bunches, a softball.
  - Stormwind patrols: 30 Gryphon Riders 51348 hung still in the air (TDB flies 10 paths, some with wingmen);
    Nikova Raskol, Ol' Emma (twice) and Lana Ashwin stood off their routes; Myrla Stoneround had a second,
    standing copy; City Guards froze along TDB's patrol routes.
  - Ironforge: 11 Gryphon Riders 51383 hung still (TDB: 6 flight paths with wingmen); Courier Hammerfall, Thief
    Catchers Farmountain (twice) and Thunderbrew, Myra Tyrngaarde, Roetten Stonehammer, Bimble Longberry and
    Curator Thorius stood off their routes; Sognar Cliffbeard had a second copy; Ironforge Guards froze on routes.
  - Darnassus: Dendrythis 4167 spawned twice, Blessed Rice Cakes placed twice, 20 Hippogryph Riders 51371 hung
    still (TDB: 7 flight paths with wingmen), and TDB's Sentinel, Darnassian Protector and Ancient Protector
    patrols were missing.
  - Exodar: Arena Promoter 22101 twice, Peacekeepers 16733 frozen on TDB's routes (77 here, 50 in TDB), Nibblet
    19073 off his route, TDB's walking Worker 18800 missing.
  - Holiday spawns out all year: Midsummer bunnies in all four cities, Spirit of Summer in Darnassus and a
    Toasting Goblet in Stormwind; Pilgrim's Bounty turkey bunnies in Stormwind and Ironforge; a Hallow's End
    pumpkin in Stormwind.
  - Checked and left alone: BFA content (Stormwind refugee camp, war campaign NPCs, Stormwind Infantry
    formations), critter stacks already in pools, Darnassus NPCs that already walk on their template paths.
- **Changed** (`sql/fixes/world/2026_11_14_32_alliance_cities_pass.sql`):
  - Stormwind: doubles removed; 43 standing copies replaced by TDB's 26 walkers and fliers (guids
    735400076-735400101: 14 gryphon riders, 9 guards, Nikova, Ol' Emma, Lana).
  - Ironforge: 29 standing copies replaced by TDB's 25 (guids 735400102-735400126: 8 gryphon riders, 10 guards
    and the named walkers); existing guids 180626 and 180781 walk paths 735400127-735400128.
  - Darnassus: Dendrythis copy and rice cakes removed; 21 standing riders replaced by TDB's 22 walkers and fliers
    (guids 735400129-735400150); guild pets wander 2 yards.
  - Exodar: Arena Promoter copy removed; 19 standing copies replaced by TDB's 5 (guids 735400151-735400155).
  - Midsummer spawns in game_event 1, turkey bunnies in 26, the pumpkin in 12.
- **Status:** confirmed in game by Four (2026-11-14).
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-13 (Quest fixes: flight master stops responding after accepting his quest)

Merged to `main` with PR #68 on 2026-11-13.

### Core: Tak can't be talked to after accepting Ride to Thunder Bluff

- **Found** (Four, 2026-11-13, screen recording + packet trace): Tak (40809, guid 260314, Bloodhoof
  Village, `npcflag` 8195 = gossip + quest giver + flight master, gossip menu 6944) gives Ride to
  Thunder Bluff (6362). After Accept the window closed, but right-clicking Tak did nothing at all
  until a relog or restart. With `Logger.network.opcode=1,Server` the trace after
  `CMSG_QUEST_GIVER_ACCEPT_QUEST` showed `SMSG_GOSSIP_MESSAGE`, then `CMSG_GOSSIP_SELECT_OPTION`
  with no answer. A normal click on Tak shows `CMSG_TALK_TO_GOSSIP`, `SMSG_GOSSIP_MESSAGE`,
  `CMSG_GOSSIP_SELECT_OPTION`, `SMSG_SHOW_TAXI_NODES`.
- **Cause:** `quest-gossip-accept.patch` (2026-11-12) sends the NPC's gossip menu again after a quest
  is accepted from it. For Tak that menu has no quest left, only "Show me where I can fly."
  (option type 4, taxi). The client picks a lone non-chat option by itself without showing a window
  and sends `CMSG_GOSSIP_SELECT_OPTION`. By then the client had closed the quest conversation, which
  resets the server's record of who the player is talking to, so `HandleGossipSelectOptionOpcode`
  drops the request (`InteractionData.SourceGuid` no longer matches) and sends nothing. The client
  keeps waiting for the flight map inside a hidden conversation and ignores further clicks on Tak.
  The Shen'dralar Ancient was fine because his menu still lists quests, so the window is shown.
- **Changed:** `tools/bfa/quest-gossip-accept.patch`, `HandleQuestgiverAcceptQuestOpcode`
  (`QuestHandler.cpp`): after sending the gossip menu again, it only stops there when the menu still
  lists a quest (`GetQuestMenu()` not empty). With no quest left it also sends the close
  (`SendCloseGossip`, `SMSG_GOSSIP_COMPLETE`), which ends the hidden conversation. The menu is still
  sent first because it is what takes the client off the quest details page. No DB change. Compiles
  against upstream 2c13546 with the full chain.
- **Status:** confirmed in game by Four on 2026-11-13 (Tak opens the flight map right after Accept).
- **Pick up:** the patch itself changed, so the old version comes out first (`QuestHandler.cpp`
  only, short build):

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin
  git -C ../tools-repo show 3e5264e:tools/bfa/quest-gossip-accept.patch | git apply -R && echo "old gossip accept removed"
  git -C ../tools-repo show origin/claude/project-thread-8ftb1c:tools/bfa/quest-gossip-accept.patch | git apply && echo "new gossip accept applied"
  grep -c "questsLeft" src/server/game/Handlers/QuestHandler.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  Both echo lines print and the grep prints 2. Then restart worldserver.

## 2026-11-13 (World fixes: Love is in the Air boats and perfume out of season)

Merged to main via PR #67 (2026-11-13).

### World: love boats sailed the Darnassus canals and guards wore perfume in November

- **Found** (Four, 2026-11-13, video): love boats piled up in the Darnassus canals after loading in,
  sorted themselves out along the loop, then stacked up again; they could not be boarded. NPCs in
  Stormwind had "Heavily Perfumed". Love is in the Air (game_event 8) was not running: its dates follow
  the February holiday (2026_11_05_00). These pieces were simply never tied to the event.
- **Cause:**
  - Our dump has 22 Darnassus Love Boats 37980 and 17 Undercity Love Boats 37966 sniffed mid-canal.
    On retail and in TrinityCore TDB 7.3.5 only the two [DND] Love Boat Summoners (37981 Darnassus,
    37964 Undercity) are spawned, during the event, and summon a boat every 20 seconds that sails its
    path from the summoner and despawns at the end. `2026_11_12_30` brought in the boats' TDB script
    (start the path 5 seconds after spawning), so every static boat crossed the canal to the path's
    first point, sailed the loop, despawned, and came back at its old spot 5 minutes later. The
    Darnassus boats and both summoners were not in any game event.
  - The boats had three click spells: Ride Vehicle Hardcoded 46598 and Ride Vehicle 69342 (two ride
    spells on one click) plus Love Boat 69341, the boat's own aura. TDB has only 69342.
  - Stormwind City Guards 68, Royal Guards 1756, City Patrollers 1976, Melris Malagan 12480, Orgrimmar
    Grunts 3296 and Darkspear Headhunters 74228 have a dump script with a 25% chance to cast Heavily
    Perfumed 71507 on themselves whenever they reset, with no event condition. One Love Guard Perfume
    Bunny 38288 in Orgrimmar (guid 301908) also pulsed perfume on nearby guards all year (the other
    ten are in the event).
- **Changed** (`sql/fixes/world/2026_11_13_30_love_boats_and_guard_perfume.sql`):
  - The 39 static love boats are deleted (with their game event rows).
  - Summoners 357540 (Darnassus) and 357491 (Undercity) are in game_event 8 and stand still on the
    first path point (`MovementType` 0, `spawndist` 0, as in TDB).
  - Click spells 46598 and 69341 are removed from both boats, so a click only casts Ride Vehicle 69342.
  - Conditions (type 22, `CONDITION_ACTIVE_EVENT` 8) on the Heavily Perfumed script row of the six
    guard entries and the per-guid copy on Orgrimmar Grunt 266181.
  - Love Guard Perfume Bunny 301908 is in game_event 8.
- **Status:** confirmed out of season by Four (2026-11-13): no boats in Darnassus, no perfumed guards
  after a restart. Boarding during the event is untested (February, or `.event start 8`); whether the
  single click spell fixes it is a guess.
- **Pick up:** run the SQL, restart `worldserver`.

## 2026-11-13 (Dire Maul, Gordok Commons)

Draft, not merged. Branch `claude/project-thread-g6xhsv`.

### Dire Maul, Gordok Commons: hounds, Slip'kik, spirits, stacked pods, movement

- **Found** (survey before testing, north wing of map 429; scenario 668 needs Guard Mol'dar 14326,
  Guard Fengus 14321, Guard Slip'kik 14323, Captain Kromcrush 14325 and King Gordok 11501; bonus
  Stomper Kreeg 14322 and Cho'Rush 14324):
  - Gordok Mastiff 13036 (53 spawns): `unit_flags` 33544 (0x8308) has `IMMUNE_TO_PC` 0x100 and
    `PLAYER_CONTROLLED` 0x8, so the hounds could not be attacked. Pandaria 5.4.8 has 33280.
  - Guard Slip'kik 14323: `unit_flags` 295504 has `UNIT_FLAG_STUNNED` 0x40000 (sniffed while frozen
    in the Fixed Trap), so he never fought back. AzerothCore has 0.
  - Gordok Spirit 11446: 13 ghosts on the ledges around King Gordok's arena with only an emote
    script, hostile and attackable (512). Pandaria has them immune (768), AzerothCore pacified.
  - Warpwood Pods (whole map): 262 pods on 67 spots, four stacked on each (variants 179526, 179528,
    179532, 179533). Only 179528 can be looted; AzerothCore pools one pod per spot.
  - Guard Fengus 14321 (guid 323249) stood still in a hallway at (356, 342, 2.9), away from his
    chest room; Four could not find him (2026-11-13). That spot is point 16 of his AzerothCore patrol
    (guid 248079, path 2480790, 29 points through the chest room at (380, 260)).
  - Fengus's Chest 179516 is empty (loot id 0). In AzerothCore it held only the Gordok Courtyard Key
    18266, and the courtyard door already spawns open here, so it is left alone.
  - Overspawn check: no stacked creature packs in the north wing (largest is 6 Gordok Mastiffs in a
    kennel where AzerothCore has 7 spread out). Only 49 of 262 spawns moved.
  - Checked and left alone: boss SmartAI, encounters 362-368 (King Gordok gives the Dungeon Finder
    credit), quest 27124 Unfinished Gordok Business (a talk quest from Kromcrush to Mol'dar, it needs
    no objective row), the doors (courtyard and inner doors spawn open), Mizzle the Crafty's tribute
    gossip and the static Gordok Tribute chest beside King Gordok.
- **Changed:** new `sql/fixes/world/2026_11_13_03_dire_maul_north.sql`: `creature_template.unit_flags`
  13036 33544 -> 33280, 14323 295504 -> 33360, 11446 512 -> 768; 195 empty Warpwood Pods deleted (one
  179528 kept per spot, with their `gameobject_addon` rows); Guard Fengus walks his AzerothCore patrol and 5 Pandaria 5.4.8 paths on the
  same guids (429002001-429002006: Fengus, three Mastiffs, a Mage-Lord, a Brute) and AzerothCore wander radius for 50
  Carrion Swarmers. No core change.
- **Status:** confirmed in game by Four (2026-11-13): Mol'dar, Fengus (on his patrol), Slip'kik (fights back), Kromcrush and King Gordok all count, plus the Kreeg and Cho'Rush bonuses; hounds, spirits, pods and patrols looked right.

#### To pick it up
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_13_03_dire_maul_north.sql | mysql -u root -p bfa_world
```
The last line prints `Mastiff 33280, Slip'kik 33360, Spirit 768, 67 Warpwood Pods`. Then restart
`worldserver`.

### Dire Maul, Gordok Commons: Knot Thimblejack's ice trap catches Guard Slip'kik

- **Found** (Four, 2026-11-13): turning in A Broken Trap 27118 at the Broken Trap 179485 did
  nothing, although Knot Thimblejack says the repaired trap freezes the guard.
- **Cause:** nothing scripts the event in the BFA dump. The Broken Trap has no SmartAI rows, Slip'kik
  has none for it, and a Fixed Trap 179512 (guid 189237) is already spawned on top of the broken one.
  The Fixed Trap is a type 6 trap with radius 0, so it never fires by itself. The quest was also not
  repeatable, so it could only be done once per character.
- **Changed:** new `sql/fixes/world/2026_11_13_04_dire_maul_slipkik_trap.sql`, following
  AzerothCore's script for the same event: static Fixed Trap guid 189237 deleted; Broken Trap guid
  189157 respawn 7200 -> 86400; Broken Trap SmartAI (on reward of 27118: despawn, summon the Fixed
  Trap at (558.8, 550.1, -25.4), set data 1 1 on Slip'kik); Slip'kik SmartAI ids 10-14 (on data 1 1
  walk to the trap; on arrival cast Ice Lock 22856 on himself, `unit_flags` 768, react passive);
  `quest_template_addon.SpecialFlags |= 1` (repeatable) and the quest's turn-in text from Pandaria
  5.4.8 in `quest_offer_reward`; `quest_template.QuestType` 0 -> 2 (a repeatable auto-complete quest
  opens straight on the reward window without being accepted, and the client greyed out Complete
  Quest there; as a normal quest with no objectives it is accepted, completes at once and is turned
  in at the trap). A frozen Slip'kik cannot be killed, so his scenario kill does not
  count in a run where you freeze him.
- **Status:** confirmed in game by Four (2026-11-13): the trap quest can be completed and turned in, and
  Slip'kik walks over to the fixed trap and freezes.

### Dire Maul, Gordok Commons: the tribute run ending (Mizzle, Cho'Rush, Gordok Tribute)

- **Found** (Four, 2026-11-13, tribute run in the Ogre Suit): the Gordok Tribute could be looted twice.
  The chest 179564 is a fixed spawn (guid 189238) beside King Gordok, lootable at any time, and Mizzle
  the Crafty 14353 stands in the courtyard from the start (guid 323984), so his gossip summoned a second
  one. Cho'Rush the Observer 14324 kept fighting after King Gordok 11501 died. Mizzle's own script (walk
  in, say his lines, crown the player with King of the Gordok 22799, summon the tribute once) was in the
  dump, but nothing summoned him.
- **Changed:**
  - New `sql/fixes/world/2026_11_13_06_dire_maul_gordok_tribute.sql`, following AzerothCore: fixed
    tribute guid 189238 and fixed Mizzle guid 323984 deleted; King Gordok SmartAI ids 100-101 (on death
    summon Mizzle at (683.3, 484.4, 29.5), the start of his path `waypoints` 14353, and set data 1 1 on
    Cho'Rush); Cho'Rush SmartAI ids 100-102 (on data 1 1 yell, faction 35, evade) and his yell in
    `creature_text` 14324/0; condition: Mizzle's "Henchmen? Tribute?" option needs aura 22799; tribute
    loot 16577: the reference row 12007 (loot mode 1, up to 2 rolls) replaced by five reference rows
    (items 1-5) on loot modes 2, 4, 8, 16, 32.
  - New `tools/bfa/dire-maul-north.patch` (after `dungeon-scale-guardians.patch`),
    `src/server/scripts/Kalimdor/DireMaul/`: the instance saves which of Mol'dar 14326, Fengus 14321,
    Slip'kik 14323, Kromcrush 14325 and Cho'Rush 14324 were killed (`DATA_GORDOK_GUARDS_DEAD`, saved
    after the generator state; older saves load with none killed), and gives the summoned tribute loot
    mode 1 plus one extra mode per guard still alive.
- **Status:** confirmed in game by Four (2026-11-13): King Gordok killed first, Cho'Rush yielded, Mizzle
  walked in; the first talk gave the King of the Gordok buff, the second the tribute, which held the
  extra loot for every guard left alive.

### Dire Maul, Gordok Commons: Knot Thimblejack offered The Gordok Ogre Suit twice

- **Found** (Four, 2026-11-13): Knot Thimblejack 14338 lists The Gordok Ogre Suit twice.
- **Cause:** 27119 is the first-time quest (story text, XP) and 27120 the repeat version (no text, no
  XP). Both ask for one Ogre Tannin 18240 and give the Gordok Ogre Suit 18258, but nothing tied 27120
  to 27119 and 27120 was not repeatable.
- **Changed:** new `sql/fixes/world/2026_11_13_05_dire_maul_ogre_suit_quests.sql`:
  `quest_template_addon` 27120 `PrevQuestID` 0 -> 27119 and `SpecialFlags |= 1` (repeatable), like
  the classic pair 5518/5519; `quest_offer_reward` texts for 27119 and 27120 and the
  `quest_request_items` text for 27119, copied from Pandaria 5.4.8 (all three were missing).
- **Status:** confirmed in game by Four (2026-11-13): Knot shows the quest once, and the suit keeps
  Kromcrush from attacking. The Gordok Reavers already standing in the rooms still attack; they use the
  plain Ogre faction, which the suit does not change (same as classic and AzerothCore).

### DungeonScale: adds a boss summons as guardians were never scaled

- **Found** (Four, 2026-11-13): Captain Kromcrush 14325 calls two elite Gordok Reavers with over 12k
  health each, more than Kromcrush himself.
- **Cause:** Call Reavers 22860 summons Gordok Reaver 52761 with SummonProperties 61, which makes a
  `Guardian`. `Guardian::UpdateMaxHealth` rebuilds the health base from the current max health, so
  the scaled base DungeonScale sets was replaced by the unscaled value straight away.
- **Changed:** new `tools/bfa/dungeon-scale-guardians.patch` (after `uldaman.patch`),
  `src/server/scripts/Custom/solocraft.cpp`: DungeonScale remembers a guardian's unscaled max
  health when it is first tracked and scales it by setting max health before
  `UpdateMaxHealth()`. Adds summoned by a boss use the boss's multiplier
  (`DungeonScale.Summons.InheritBossScaling`), so the Reavers get MiniBoss health (x0.35 solo).
- **Status:** confirmed in game by Four (2026-11-13): the Reavers are scaled; Kromcrush's fight is hard but doable solo.

## 2026-11-13 (Uldaman)

Merged to `main` with PR #65 on 2026-11-13.

### Uldaman: Stone Keepers, Archaedas and his minions, Ironaya, dig teams, movement

- **Found** (survey before testing, map 70): the event creatures could never be fought, the
  Keystone was spawned already used, both factions' dig teams stood on the same spots at the
  entrance, and all 293 spawns stood still.
- **Cause and changes:**
  - Stone Keepers 4857, Archaedas 2748, Earthen Guardian 7076, Earthen Hallshaper 7077, Earthen
    Custodian 7309 and Vault Warder 10120 have `UNIT_FLAG_IMMUNE_TO_PC` 0x100 + `IMMUNE_TO_NPC` 0x200
    + `NOT_SELECTABLE` 0x2000000 in `creature_template.unit_flags`. Their scripts freeze them on reset
    and on waking only remove `NOT_SELECTABLE` and set faction 14, so a woken Stone Keeper or Archaedas
    still could not be attacked. SQL strips the three flags: 2748 33588032 -> 32832, 4857 and 10120
    33555264 -> 64, 7076/7077/7309 33587968 -> 32768.
  - Only 7077 had `ScriptName` `npc_archaedas_minions`; 7076, 7309 and 10120 had none, so they never
    froze or woke with Archaedas. SQL sets it on all four (as in the Pandaria 5.4.8 database).
  - Keystone 124371 (gameobject guid 188122) `state` 0 -> 1, so clicking it opens the Seal of
    Khaz'Mul and releases Ironaya.
  - New `tools/bfa/uldaman.patch` (after `dire-maul-west.patch`), `src/server/scripts/EasternKingdoms/Uldaman/`:
    - `instance_uldaman.cpp`: the Alliance dig team (46232 Explorer's League Digger, 46233 Olga
      Runesworn, 46234 Lead Prospector Durdin, 46247 Kand Sandseeker) and the Horde one (46231
      Reliquary Digger, 46235 Lidia Sunglow, 46236 High Examiner Tae'thelan Bloodwatcher, 46241 Aoren
      Sunglow) are both spawned at the entrance and are hostile to the other faction. The instance
      now takes the faction of the first player inside (`OnPlayerEnter`, or the map's players in
      `OnCreatureCreate`) and despawns the other team for the life of the instance
      (`DespawnOrUnsummon(1, Seconds(WEEK))`).
    - `instance_uldaman.cpp` `ActivateIronaya`: also removes the stone aura 10255
      (`SPELL_MINION_FREEZE_ANIM`), so Ironaya does not walk out still frozen.
    - `instance_uldaman.cpp` `GetGuidData`: bounds-checked lookups instead of `.at()`, which would
      crash the server if a Vault Warder or Earthen Guardian was missing.
    - `boss_archaedas.cpp` `Reset`: `instance->SetData(0, 5)` -> `SetData(DATA_MINIONS, NOT_STARTED)`.
      Data 0 is not a valid type, so dead minions never came back when Archaedas reset.
    - `boss_archaedas.cpp` (Archaedas and `npc_archaedas_minions`): at the end of the awaken animation
      they now set faction 14, drop `NOT_SELECTABLE` and unroot before `AttackStart` (fallback
      `DoZoneInCombat`). Before, they attacked while still faction 35; `CombatManager::CanBeginCombat`
      refuses combat between friendly units, so `JustEngagedWith` (which made them hostile) never ran
      and Archaedas woke, yelled and stayed unselectable (Four, 2026-11-13).
    - `instance_uldaman.cpp` `ActivateStoneKeepers`: the woken keeper also engages the players in the
      instance (`EngageWithTarget`, GMs skipped). Before, it turned faction 14 but never started a fight
      and Four could not attack it (2026-11-13).
  - Movement in the same SQL: 12 patrols (3 Pandaria 5.4.8 paths on the same guids, 9 AzerothCore
    paths matched by entry and nearest path point; paths 70000001-70000012: Stone Stewards, Stonevault
    Brawlers and Ambushers, Shrike Bats, Ancient Stone Keeper) and 51 wanderers (AzerothCore wander
    radius, max 5 yards). Bosses, the Stone Keepers, Archaedas' room and the dig teams are left alone.
- **Files:** `tools/bfa/uldaman.patch` (new), `sql/fixes/world/2026_11_13_00_uldaman.sql` (new).
  Compiles against upstream with the patch chain; SQL tested twice on the local database.
- **Status:** confirmed in game by Four (2026-11-13): Revelosh, Keystone, Seal of Khaz'Mul and Ironaya; the four Stone Keepers wake one by one, attack and open the doors; Archaedas wakes, fights with his minions and counts; scenario step 1175 and all four bonus objectives complete (state 3).

### Uldaman: Obsidian Shards stand still

- **Found** (Four, in game): the Obsidian Shards 7209 the Obsidian Sentinel 7023 splits off (Summon
  Obsidian Shard 10061 at 80/60/40/20% health) stand where they appear and never attack. They do die
  with the Sentinel.
- **Cause:** spell 10061 summons with SummonProperties 61 (Control 1 = ally, Title 2 = guardian), so
  the shard is a guardian of the Sentinel. A guardian does not pick targets from line of sight, and
  its SmartAI (only Obsidian Reflection 9941 on aggro) never starts combat.
- **Changed:** new `sql/fixes/world/2026_11_13_02_uldaman_obsidian_shards.sql`: `smart_scripts`
  7209 ids 9 and 10, event 54 (just summoned): action 38 (set in combat with zone) on self, and
  action 49 (attack start) on target 21 (closest player, 40 yards). No core change.
- **Status:** confirmed in game by Four (2026-11-13): the shards attack.

### Uldaman: stacked trogg packs

- **Found** (Four, screenshot): a dozen troggs and scorpids standing on top of each other in the
  first hall.
- **Cause:** sniff stack in the dump (the Pandaria 5.4.8 database has the same 12). Around
  (-274, 140, -47.4): 4 Stonevault Pillagers 24830, 3 Stonevault Oracles 4852, 2 Stonevault Ambushers
  7175, 3 Venomlash Scorpids 7022 within 6 yards; AzerothCore has 2 troggs there. Also 5 Stonevault
  Brawlers 4855 at (50, 332, -43), 1-2 in AzerothCore. A scan of all 293 spawns for packs of 4+
  found no other stacks beyond what AzerothCore also has (scorpid nests, Archaedas' room).
- **Changed:** new `sql/fixes/world/2026_11_13_01_uldaman_overspawns.sql` deletes creature guids
  320803, 320967 (Pillager), 320804, 320966 (Oracle), 321070, 321072 (Ambusher), 320828, 320829
  (Venomlash Scorpid), 320861, 321001 (Brawler). Kept: 320968, 321010, 321012, 320832 and Brawlers
  320860, 320863, 320864. No core change.
- **Status:** not checked separately in game.

#### To pick it up
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/uldaman.patch | git apply
grep -c IsAllianceDigTeam src/server/scripts/EasternKingdoms/Uldaman/instance_uldaman.cpp
grep -c EngageWithTarget src/server/scripts/EasternKingdoms/Uldaman/instance_uldaman.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The two `grep` lines print `3` and `1`.
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_13_00_uldaman.sql | mysql -u root -p bfa_world
```
The last line prints `12 patrols, 51 wanderers, Archaedas unit_flags 32832`.
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_13_01_uldaman_overspawns.sql | mysql -u root -p bfa_world
```
The last line prints `283 Uldaman spawns, 4 left in the first-hall pack`.
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_13_02_uldaman_obsidian_shards.sql | mysql -u root -p bfa_world
```
The last line prints `3 Obsidian Shard SmartAI rows`. Then restart `worldserver`.

## 2026-11-13 (pet battles)

### Pet battles: display companions like Lil' Tarecgosa can be attacked

- **Found** (Four, screenshot): Lil' Tarecgosa 54027 in Stormwind can be attacked.
- **Cause:** 2026_11_07_51 made display pets of non-capturable species unattackable only when their
  template is type 14 (wild pet). 76 spawned templates of those species are type 12 (non-combat pet),
  165 spawns in the world DB. They were never battle pets, but with faction 188 and no immunity they
  could always be attacked.
- **Changed:** new `sql/fixes/world/2026_11_13_50_display_companions_unattackable.sql` sets
  `unit_flags | 0x300` (immune to players and NPCs) on those type 12 templates. Needs 2026_11_07_51
  first. No core change.
- **Status:** confirmed in game by Four (2026-11-13): Lil' Tarecgosa in Stormwind can no longer be attacked. Four's database printed 75 templates (76 in the raw dumps).

#### To pick it up
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_13_50_display_companions_unattackable.sql | mysql -u root -p bfa_world
```
The last line prints `76 display companion templates unattackable (Lil' Tarecgosa: yes)`. Then restart
`worldserver`.

## 2026-11-12 (Quest fixes: stuck window after accepting from a gossip menu)

Merged to `main` with PR #63 on 2026-11-13.

### Core: quest window stays open after accepting a quest from a gossip NPC

- **Found** (Four, 2026-11-12): Shen'dralar Ancient (14358, guid 323496, Dire Maul map 429,
  `npcflag` 3 = gossip + quest giver, gossip menu 5729) offers The Madness Within (27110), The
  Treasure of the Shen'dralar (27111) and The Shen'dralar Ancient (27113). Accepting any of them
  leaves the window open, the same as Ahmo's list before `quest-list-accept.patch`.
- **Cause:** an NPC with the gossip flag lists its quests inside its gossip menu
  (`PlayerMenu::SendGossipMenu`, `SMSG_GOSSIP_MESSAGE`), not in a quest list
  (`SMSG_QUEST_GIVER_QUEST_LIST_MESSAGE`). `quest-list-accept.patch` only remembered quest lists,
  and `SendGossipMenu` cleared that memory, so after Accept the core still sent only the plain close
  (`SMSG_GOSSIP_COMPLETE`), which the client ignores when it came from a menu.
- **Changed:** new `tools/bfa/quest-gossip-accept.patch` (after `quest-list-accept.patch`),
  `GossipDef.h`, `GossipDef.cpp`, `QuestHandler.cpp`:
  - `PlayerMenu::SendGossipMenu`: a gossip menu that lists quests now also sets `_questListGiver`,
    with the new `_questListIsGossip` = true. `SendQuestGiverQuestListMessage` sets it to false.
  - `HandleQuestgiverAcceptQuestOpcode`: after accepting from that gossip menu, send the gossip menu
    again the way talking to the NPC does: the creature's core gossip script if it has one
    (`ScriptMgr::OnGossipHello`), otherwise its DB menu with quests
    (`PrepareGossipMenu(..., GetDefaultGossipMenuForSource, true)` + `SendPreparedGossip`).
    Only when that menu is empty does it close as before.
  - Quest lists (`quest-list-accept.patch`) work as before. No DB change. Compiles against upstream
    2c13546 with the full chain.
- **Status:** confirmed in game by Four on 2026-11-12 (Shen'dralar Ancient: Accept returns to its gossip menu, Goodbye closes it).
- **Pick up:** this only adds one patch. It touches `GossipDef.h`, so the build is longer:

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-gossip-accept.patch | git apply && echo "quest gossip accept applied"
  grep -c "_questListIsGossip" src/server/game/Entities/Creature/GossipDef.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  The echo line prints and the grep prints 3. Then restart worldserver.

## 2026-11-12 (World fixes: Vashj'ir ship Eastern Kingdoms stop leftovers)

Merged to main via PR #61 (2026-11-12).

### World: Turgore and Adarrah stayed on the water when the Vashj'ir ship sailed on

- **Found** (Four, 2026-11-12): after the ship reached the Eastern Kingdoms, Turgore and Adarrah did not
  move with it and drifted off through the hull.
- **Cause:** at the ship's 10-second stop off the Eastern Kingdoms coast (TaxiPath 2204 node 1, -7006.78
  2238.04) the dump has 19 world spawns sniffed on its deck, all wandering: Turgore 42982, Adarrah 43051
  and 17 invisible event bunnies of the unscripted ride event. They are not passengers.
- **Changed:** `sql/fixes/world/2026_11_12_48_vashjir_ship_eastern_stop_copies.sql` deletes those 19
  spawns (205700-205715, 205717, 205718, 205720 on map 0) and their addon rows. Adarrah already rides
  the ship (2026_11_12_39).
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Vashj'ir ship ride end, fourth try)

Merged to main via PR #61 (2026-11-12).

### World: the ride still ended without "Call of Duty" completing (rider list from Orgrimmar)

- **Found** (Four, 2026-11-12): with 45 applied, the ship sailed into the kraken at Vashj'ir and back to
  Durotar; Four was not dragged under.
- **Cause:** the server's copy of this ship and the one on Four's screen are not in step even in
  Orgrimmar (earlier the same day the ship sat at the docks on screen while its crew vanished), so at the
  server's Orgrimmar departure Four was not near the server's ship either. Any trigger on the server's
  ship misses the rider.
- **Changed:** `sql/fixes/world/2026_11_12_47_vashjir_ship_stop_trigger.sql`: the ship's SmartAI is
  removed. An invisible bunny 23837 (guid 735400002, phase 170 so only players on the quest see it)
  waits at the Vashj'ir stop (TaxiPath 2204 node 4, -4632.93 3863.71); every second it stores the
  players within 60 yards, teleports them next to Erunak Stonespeaker and gives credit 36901. The
  player's position follows their own screen's ship, so it fires when the ship arrives on their screen.
- **Status:** confirmed in game by Four (2026-11-12): riding the ship to the Vashj'ir stop lands the
  rider next to Erunak with "Call of Duty" complete. (The ship SmartAI of 40, 43 and 45 is replaced by this.)
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Horde ship scene hidden with its ship)

Merged to main via PR #61 (2026-11-12).

### World: on "Call of Duty", the Argus intro NPCs stood on the water at the Orgrimmar berth

- **Found** (Four, 2026-11-12): with the scenery ships hidden (2026_11_12_42), a group of NPCs stood on
  the water where the Horde ship had been.
- **Cause:** the Horde ship 269836 (guid 101352) carries the Argus intro scene (Fleet Admiral Zar'gov,
  Aethas Sunreaver, Vindicator Boros, Silgryn, Sunstrider Highguards, Kor'kron Headhunters) in phase
  11695, which every player in Bladefist Bay gets regardless of quests; 42 only moved Lady Liadrin.
- **Changed:** `sql/fixes/world/2026_11_12_46_orgrimmar_berth_ship_crew_phase.sql`: those 12 spawns
  (401234, 401249-401259) move to phase 307 with the ship, so the same players see them as before and
  they hide with the ship on the quest. Vindicator Boros 3000007 (phase 8625, which no area gives) is a
  duplicate nobody sees and is left as is.
- **Status:** confirmed in game by Four (2026-11-12): the Horde ship's NPCs are hidden with it.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Vashj'ir ship ride end, third try)

Merged to main via PR #61 (2026-11-12).

### World: the ride still ended without "Call of Duty" completing

- **Found** (Four, 2026-11-12, with `.gps` along the way): the outbound map change works (Four was on
  the Eastern Kingdoms map, phase 170, in Seafarer's Tomb at the stop), but the ship only stopped "for a
  fraction of a second" for Four, then Four was moved back to Kalimdor.
- **Cause:** the client runs behind the server's ship after each map change (it pauses 5-10 seconds
  loading the new map while the server ship sails on). By the time Four's client reached the Vashj'ir
  stop, the server's 45 second stop was nearly over. When the server's ship arrived there, Four's
  position was still far back along the route, so the script's 80-yard search found nobody.
- **Changed:** `sql/fixes/world/2026_11_12_45_vashjir_ship_riders_from_orgrimmar.sql` rewrites the
  ship's SmartAI: it stores the players aboard (phase 170, within 80 yards) when the ship leaves
  Orgrimmar (departure event 26515, node 12), where client and server are still in step, and at the
  Vashj'ir stop (event 25428) teleports that stored list to Erunak, gives credit 36901 and clears the
  list. Riders who stepped off in Orgrimmar stay on Kalimdor and are not found.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver. Board at Orgrimmar (or Azshara)
  before the ship leaves Orgrimmar.

## 2026-11-12 (World fixes: Vashj'ir quest phase hid normal spawns)

Merged to main via PR #61 (2026-11-12).

### World: on "Call of Duty", Vashj'ir and the sea route looked empty

- **Found** (Four, 2026-11-12): while on the quest, Four saw nothing in Vashj'ir.
- **Cause:** the core keeps a player "unphased" (able to see normal spawns) only while it also has the
  default phase 169. 2026_11_12_40 and 43 give phase 170 on the quest in The Great Sea (214, 2339,
  2365) and Vashj'ir (5146), which had no phase 169, so those players lost sight of every normal spawn.
  Durotar and Westfall already give 169 to everyone.
- **Changed:** `sql/fixes/world/2026_11_12_44_vashjir_route_default_phase.sql`: phase 169 for everyone
  in areas 214, 2339, 2365 and 5146 (same as Durotar's "always see unphased creatures").
- **Status:** confirmed in game by Four (2026-11-12): creatures show on the route and in Vashj'ir on the quest.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Vashj'ir ship ride end, second try)

Merged to main via PR #61 (2026-11-12).

### World: riding the Vashj'ir ship to its stop did not complete "Call of Duty"

- **Found** (Four, 2026-11-12): riding the ship on "Call of Duty", it stopped above Seafarer's Tomb,
  paused, then sailed on to Durotar; Four was not dragged under to Erunak.
- **Cause (likely, not confirmed):** the arrival event the script waits for is correct for 8.3.7 (25428
  on TaxiPath 2204 node 4, read from the client's `TaxiPathNode.db2`). The ship's SmartAI only finds
  players in its phase 170 and within 40 yards of its origin. The sea along the route up the Eastern
  Kingdoms coast ("The Great Sea" under Stranglethorn, Westfall and the Wetlands) had no phase 170, and
  the deck reaches 46 yards forward of the origin.
- **Changed:** `sql/fixes/world/2026_11_12_43_vashjir_ship_ride_end.sql`: phase 170 on the quest in
  The Great Sea areas 2339, 2364 and 2365; the ship's player search radius 40 -> 80 yards.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Orgrimmar berth scenery phase)

Merged to main via PR #61 (2026-11-12).

### World: the scenery ships at the Vashj'ir berth stayed visible on "Call of Duty"

- **Found** (Four, 2026-11-12): with 2026_11_12_40 applied and "Call of Duty" active (phase 170 shown by
  `.debug phase`), the Vashj'ir ship appeared but the scenery ships at its Orgrimmar berth stayed.
- **Cause:** 40 hid them with an inverse phase 170. Durotar also gives every player phase 169 ("always
  see unphased creatures"), which keeps the player flagged unphased, and an unphased player sees every
  inverse-phased object.
- **Changed:** `sql/fixes/world/2026_11_12_42_orgrimmar_berth_scenery_phase.sql`: unused phase 307 in
  Durotar for every player except those with 25924 in progress; the Horde ship (101352), Mantaray
  (101353), Gooblin Boat (184257), Lady Liadrin (401248) and the Hired Courier (20500904) move to phase
  307 (normal, not inverse).
- **Status:** confirmed in game by Four (2026-11-12): the scenery ships are hidden on the quest.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Call of Duty objective text)

Merged to main via PR #61 (2026-11-12).

### World: "Call of Duty" tracked "0/1 Submerge Bunny slain"

- **Found** (Four, 2026-11-12): the quest tracker for "Call of Duty" (25924) showed "0/1 Submerge Bunny
  slain".
- **Cause:** the quest's only objective (kill credit 36901, the invisible Submerge Bunny) has no
  `Description`, so the client falls back to the creature name. The Alliance version 14482 (credit
  36915) has the same gap.
- **Changed:** `sql/fixes/world/2026_11_12_41_call_of_duty_objective_text.sql`: objectives 266797
  (25924) and 266167 (14482) get the retail text "Ride the mercenary ship to Vashj'ir".
- **Status:** confirmed in game by Four (2026-11-12): the tracker reads "0/1 Ride the mercenary ship to Vashj'ir".
- **Pick up:** run the SQL on `bfa_world`, restart worldserver, and delete the client's Cache folder
  (the client caches quest text).

## 2026-11-12 (World fixes: Vashj'ir ship only on its quest)

Merged to main via PR #61 (2026-11-12).

### World: the Vashj'ir ship clipped through the Orgrimmar scenery ships, and "Call of Duty" never completed

- **Found** (Four, 2026-11-12): the Ship to Vashj'ir (Horde, transport 203466) docks across the two
  scenery ships at the Orgrimmar docks and passes through them. Four chose to show it only to players on
  its quest, as on retail, and to hide the scenery ships from those players.
- **Cause:**
  - Core: `Map::AddToMap<Transport>` sent a ship to every player on the map, ignoring its phase. This
    ship changes maps (Kalimdor / Eastern Kingdoms) every loop, so it reappeared for everyone although
    `transports` already puts it in phase 170. Login (`SendInitTransports`) did check the phase.
  - DB: no `phase_area` row ever gave phase 170 around Orgrimmar, so the quest could not show it.
  - Nothing scripted the end of the ride (no event script, SmartAI or core script for the path
    events), so "Call of Duty" 25924 (credit 36901) could never complete.
- **Changed:**
  - `tools/bfa/transport-phase-visibility.patch` (new, `src/server/game/Maps/Map.cpp`):
    `AddToMap<Transport>` only sends the ship to players in its phase; `SendUpdateTransportVisibility`
    never hides the ship a player is standing on (a rider leaving the phase area, or finishing the quest
    on board, would otherwise drop into the sea).
  - `sql/fixes/world/2026_11_12_40_vashjir_ship_quest_phase.sql`:
    - Phase 170 while 25924 is in progress (not yet complete) in Durotar (14), The Great Sea (214) and
      Vashj'ir (5146).
    - Ship crew 735200301-735200310 (from 39) set to phase 170, so they show with the ship.
    - Inverse phase 170 on the scenery at the berth: Horde ship 269836 (guid 101352), Mantaray 269837
      (101353), Gooblin Boat 203471 (184257), Lady Liadrin (401248, stands on the Horde ship) and the
      Hired Courier (20500904, stands on the Gooblin Boat). Players without the quest see no change.
    - SmartAI on the ship: on arrival at its stop above Vashj'ir (TaxiPath 2204 node 4, event 25428),
      every player aboard in phase 170 is teleported next to Erunak Stonespeaker 41618 (-4608.77
      3982.0 -70.4), who takes the quest and starts "Sea Legs", and gets credit 36901.
- **Status:** not tested in game. The patch compiles (`Map.cpp`) on upstream 2c13546; the SQL runs
  cleanly, twice in a row, on a copy of our world DB. With GM mode on you still see everything.
- **Pick up:** apply the patch and rebuild, run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Vashj'ir ship crew)

Merged to main via PR #61 (2026-11-12).

### World: the Horde ship to Vashj'ir sailed empty; 5 pier guards removed by mistake

- **Found** (Four, 2026-11-12): the Ship to Vashj'ir (Horde, transport 203466, map 738) docks at
  Orgrimmar with nobody on board. Checking the soldiers 2026_11_12_34 removed showed 5 of them stood on
  the pier, not in the water.
- **Cause:** TDB 7.3.5 has no crew for this transport. The 15 dock NPCs deleted in 34 were sniffed
  while it sat at its Orgrimmar stop (TaxiPath 2204 node 12, 1440.22 -5035.89 7.0); 10 of them are its
  deck crew, 5 Hellscream's Vanguard (205119-205123) stand on the pier beside the Dranosh'ar Fishermen.
- **Changed:** `sql/fixes/world/2026_11_12_39_vashjir_ship_crew.sql`:
  - 10 crew on map 738 at ship-relative positions, guids 735200301-735200310: Hellscream's Vanguard
    43090 (5), Legionnaire Nazgrim 43100, Mack Fearsen 43022, Adarrah 43051, Budd 43023, Captain Samir
    43030. Converted with the orientation the core gives the docked ship (Catmull-Rom tangent between
    path nodes 11 and 13, + pi = 0.1914), standing still.
  - Restored the 5 pier Hellscream's Vanguard at their dump spots and guids, standing still
    (`MovementType` 0 instead of wandering).
- **Status:** confirmed in game by Four (2026-11-12): the crew stands on deck correctly and the 5 pier
  guards are back on the pier.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Thundercaller retired)

Merged to main via PR #61 (2026-11-12).

### World: The Thundercaller still flew Orgrimmar - Undercity, but BFA replaced it with portals

- **Found** (Four, 2026-11-12): the zeppelin still runs and is crewed, while the Orgrimmar platform
  already has a Portal to Undercity and the Tirisfal Glades map shows an Orgrimmar portal at the tower.
- **Cause:** transport 164871 (map 591) is still in `transports`; the Tirisfal side Portal to Orgrimmar
  293689 (Teleport: Orgrimmar 3567) exists as a template but was never spawned.
- **Changed:** `sql/fixes/world/2026_11_12_38_retire_thundercaller.sql`:
  - Deleted transport 164871 from `transports`, and its 21 crew from 2026_11_12_33 (guids
    735200050-735200070, map 591).
  - Spawned Portal to Orgrimmar 293689 as guid 735400101 on the Tirisfal Glades zeppelin tower at the
    spot Four picked (2067.74 290.34 97.03, facing 4.585), with `gameobject_template_addon` faction
    1735 (Horde), like the Orgrimmar side's Portal to Undercity 293684.
  - Portal template 293689 `Data0` 3567 -> 0: it cast the mage spell Teleport: Orgrimmar (10 s cast,
    landing in the city; found by Four in game). Per-spawn SmartAI (GO -735400101, on use) teleports
    the player instantly to the Orgrimmar zeppelin tower beside the Portal to Undercity
    (1841.12 -4391.99 135.23, spot picked by Four).
  - Orgrimmar's Portal to Undercity 293684 (guid 210400316) landed inside Undercity (its spell 17611
    -> 121862 at 1773.4 61.7 -46.3). Four's call: tower to tower. Template `Data0` 17611 -> 0 and
    per-spawn SmartAI (GO -210400316, on use) teleports to the Tirisfal tower at the new portal.
  - Watcher Umjin 25107 on The Purple Princess (guid 735200049) stands up: his template addon has him
    asleep (bytes1 3, same in TDB) and lying down he clipped through the cabin. New per-spawn
    `creature_addon` row with bytes1 0.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: Stormwind Wizard's Sanctum, Boralus ship)

Merged to main via PR #61 (2026-11-12).

### World: the Wizard's Sanctum portal did nothing, so the Stormwind portal room was unreachable

- **Found** (Four, 2026-11-12): the portal at the top of the Mage Quarter tower goes nowhere, and the
  Wizard's Sanctum can't be entered.
- **Cause:** the client's area triggers 4733 (top of the tower, -9016 876 148.6) and 4734 (basement,
  -9019 888 29.6) have no `areatrigger_teleport` rows. The portals inside all work (their spells have
  destinations).
- **Changed:** `sql/fixes/world/2026_11_12_35_stormwind_wizards_sanctum.sql`:
  - `areatrigger_teleport` 4733 -> world_safe_locs 7264 "Stormwind - Portal Room - Wizard's Sanctum
    Dest" (-9004.44 870.63 64.86, where the mage Teleport: Stormwind also lands), 4734 -> 3630
    "Stormwind - Mage Exit Target" (-9013.2 870.63 148.62, beside the top portal).
  - Deleted doubled portal room spawns in the default phase: Maginor Dumas 331, Enchanted Broom 103033
    and Tushui Magister 147741 (guids 3400000000001970-1972), and Portal to Paw'don Village 323844
    (guid 3300000000298) standing inside Portal to Pandaria 315457 (same spell 130703).
- **Follow-up** (Four, 2026-11-12: entrance works, the way back out doesn't): the exit portal in the
  portal room (Doodad_8SW_Stormwind_MagePortal001 311875, guid 280200645) is only a decoration, sent
  through a server-side area trigger on retail that our core can't teleport with.
  `sql/fixes/world/2026_11_12_37_stormwind_portal_room_exit.sql` spawns an invisible ELM General
  Purpose Bunny 23837 (guid 735400001) on the spot Four picked in it (-9000.56 865.06 65.89), with per-guid SmartAI: any player within 1 yard is
  teleported to world_safe_locs 3630 "Stormwind - Mage Exit Target" (-9013.2 870.63 148.62).
- **Status:** entrance (35) and exit (37) confirmed in game by Four 2026-11-12.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

### World: The Relentless (Stormwind - Boralus ship) clipped through The Bravery at the pier

- **Found** (Four, 2026-11-12): the Boralus ship overlaps The Bravery in Stormwind Harbor and has no crew.
- **Cause:** both ships stop at the exact same pier in the client's path data (TaxiPath 967 and 7222,
  both at -8651 1346), and their loops have different lengths, so no fixed schedule keeps them apart.
  No crew data exists for it (TDB 7.3.5 predates BFA).
- **Changed:** `sql/fixes/world/2026_11_12_36_retire_stormwind_boralus_ship.sql` deletes transport
  294556 (The Relentless, map 2074) from `transports`. Travel goes through the Wizard's Sanctum Portal
  to Boralus 302854 and Boralus' Portal to Stormwind 293552.
- **Status:** Four's call (2026-11-12): retire the ship, portals instead. Confirmed in game 2026-11-12 (ship gone, portals work).
- **Pick up:** run the SQL on `bfa_world` after the Wizard's Sanctum fix works, then restart worldserver.

## 2026-11-12 (World fixes: Orgrimmar wind riders and docks)

Merged to main via PR #61 (2026-11-12).

### World: Orgrimmar Wind Riders hung still in the air, Vashj'ir ship crew stood in the water at the docks

- **Found** (Four, 2026-11-12): wind riders frozen in the air all around Orgrimmar (west zeppelin tower,
  Valley of Honor, Durotar side), and soldiers standing in the water and on a paddle wheel at the
  Orgrimmar docks.
- **Cause:** the dump has 149 Orgrimmar Wind Rider 51346 spawns, all static: sniff snapshots of riders
  that fly patrols on retail. Our patrol import skipped them because the template has a core script
  (`guard_generic`). At the docks, 17 NPCs from the Cataclysm Horde ship to Vashj'ir were sniffed
  while it was docked and stay behind in the water when it leaves. TDB 7.3.5 spawns none of them.
- **Changed:** `sql/fixes/world/2026_11_12_34_orgrimmar_wind_riders_and_docks.sql`:
  - Deleted the 149 static Orgrimmar Wind Riders (with their `creature_addon` and 2 formation rows).
  - Added TDB 7.3.5's flying patrols, guids 735300001-735300043: 15 riders on waypoint paths
    735300001-735300043 (1,261 points, same id as the leader's guid) and 28 wingmen in formation
    with them (40 `creature_formations` rows). TDB's 16 riders that hover in one spot are left out.
  - Deleted the docks crew: Hellscream's Vanguard 43090 (10), Legionnaire Nazgrim 43100, Totally
    Generic Bunny (Phase 2) 43091 (2), Mack Fearsen 43022, Adarrah 43051, Budd 43023, Captain Samir
    43030. No quest uses them. The Kor'kron Loyalist and Battleworg quest NPCs stay.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: transport crews from TDB 7.3.5)

Merged to main via PR #61 (2026-11-12).

### World: boats, zeppelins, turtles and the Icecrown gunships sailed with no crew

- **Found** (Four, 2026-11-12): the transports between zones and landmasses run with nobody on deck.
  Ships parked in harbors (Stormwind Harbor etc.) are normal spawns and were already fine.
- **Cause:** a transport loads its crew from `creature` rows on its own map (the map in
  `gameobject_template` `Data6`, positions relative to the ship). Our DB has no creature on any of
  those maps. The dump instead has copies of some crews in world coordinates, sniffed while a ship
  passed, so they hang in the air over Tirisfal, Stranglethorn, the Barrens and Icecrown or stand on
  the water at the docks.
- **Changed:** `sql/fixes/world/2026_11_12_33_tdb735_transport_crews.sql`:
  - 291 crew from TDB 7.3.5, guids 735200001-735200291: The Lady Mehley 584 (11), Elune's Blessing
    586 (6), The Bravery 588 (10), The Iron Eagle 589 (11), The Purple Princess 590 (11), The
    Thundercaller 591 (21), The Maiden's Fancy 593 (8), Sister Mercy 594 (24), The Cloudkisser 610
    (7), Northspear 612 (6), The Mighty Wind 613 (7), The Kraken 614 (6), Walker of Waves 620 (2),
    Green Island 621 (1), Orgrim's Hammer 622 (71), The Skybreaker 623 (77), Orgrimmar - Thunder
    Bluff zeppelin 647 (12). TDB's phase 169 is our default phase 0. The 9 Lady Mehley crew that
    walk the deck in TDB stand still here (no deck paths), 11 `creature_addon` rows keep their
    sitting/working poses.
  - Left out: the Feathermoon Ferry 587 (its gameobject is not a moving transport any more) and the
    Krazzworks Attack Zeppelin 765 (quest phase 361). Cataclysm and BFA transports (Vashj'ir ships,
    Spear of Durotar, Deepholm gunship, Krazzworks - Dragonmaw zeppelins, Kul Tiran and Zandalari
    ships) have no crew in TDB either, so they stay empty.
  - Deleted the 124 world-coordinate copies of crew that TDB has only on transports (Sky-Captain
    Cloudkicker, Sky-Captain "Dusty" Blastnut, the Northspear crew at Menethil and Valgarde, the
    Purple Princess crew over Grom'gol, the Icecrown gunship cannons, controllers and Brother Keltan,
    the Sister Mercy sea dogs, ...), with their 2 `creature_addon` rows, 1 formation row and 5
    `spawn_group` rows.
  - TDB's SmartAI (11 rows) for Captain "Stash" Torgoley 24833, First Mate Kowalski 24835 and Sailor
    Henders 24838 on The Lady Mehley (their texts were already here). No other crew member has a
    TDB script.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver. Crews appear on a ship when it
  loads, so wait for the next departure or arrival.

## 2026-11-12 (World fixes: missing rares from TDB 7.3.5)

Merged to main via PR #61 (2026-11-12).

### World: 13 rare beasts in Silithus and Tirisfal Glades never spawned

- **Found** (Wayfarer, 2026-11-12, comparing with TDB 7.3.5): of about 99,000 TDB spawns with no
  match here, only about 520 on the four continents are NPCs we never spawn that aren't summons,
  phased, critters, bunnies or a same-name NPC standing on the spot. Most of those are outdated
  (pre-Cataclysm capital and event NPCs) or have stub templates, so only this clear group is fixed.
- **Cause:** the dump has no spawn for these rares, and their templates came from an 8.3.7 sniff with
  no faction or level (friendly faction 35, level 1).
- **Changed:** `sql/fixes/world/2026_11_12_32_tdb735_missing_rares.sql`:
  - Templates set hostile (`faction` 14) at TDB 7.3.5's levels: Silithus Karapax 50370 (56),
    Acroniss 50737 (55), Qem 50742 (57), Qu'rik 50744 (58), Losaj 50745 (58), Ffexk the
    Dunestalker 50897 (55), Toxx 51004 (56); Tirisfal Glades Fangor 50328 (5), Shadowstalker
    50763 (6), Bonechewer 50803 (7), Nighthowl 50908 (9), Hibernus the Sleeper 50930 (7), Plague
    51044 (8). Ten have a scaling row, which sets the level in game.
  - One spawn each at TDB's spot and respawn time (Silithus 2 min, Tirisfal 15 min), guids
    735100001-735100013.
  - TDB's SmartAI (10 rows) for Fangor, Shadowstalker, Bonechewer, Nighthowl, Hibernus and Plague,
    checked like the scripts batch. Acroniss, Qem and Toxx already had scripts here.
- **Status:** not tested in game. The SQL runs cleanly, twice in a row, on a copy of our world DB.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (Dire Maul: Capital Gardens)

Merged to `main` with PR #62 on 2026-11-12. New core patch `tools/bfa/dire-maul-west.patch`
(after `transport-phase-visibility.patch`, build needed) and `sql/fixes/world/2026_11_12_01_dire_maul_west.sql`, `2026_11_12_02_dire_maul_kalendris_dominate.sql`.
Called complete by Four on 2026-11-12.

### Dire Maul: shield generators did nothing, Immol'thar's force field was open

- **Found** (before Four's first run): `instance_dire_maul` was an empty placeholder and nothing
  scripted the five Crystal Generators (177259, 177257, 177258, 179504, 179505). The force field
  around Immol'thar (179503) was spawned open, so Immol'thar could be pulled straight away, and the
  scenario objective "Shield Generators deactivated" (scenario 668, criteria 25064, event 8200,
  needs 5) could never move.
- **Changed:** `tools/bfa/dire-maul-west.patch` (`src/server/scripts/Kalimdor/DireMaul/`, new
  `dire_maul.h`): the instance keeps the generators running and the force field up. Each generator
  belongs to the Arcane Aberrations 11480 and Mana Remnants 11483 spawned within 40 yards of it
  (2 or 3 guards each). When its last guard dies, the generator shuts down and sends scenario event
  8200. When all five are down, the force field opens and Immol'thar becomes attackable (he is
  unattackable until then). Progress is saved with the instance, so a server restart keeps it. Same
  design as AzerothCore's `instance_dire_maul`; the Highborne Summoners around Immol'thar are left
  as they are (neutral Shen'dralar in this database).
- **Status:** confirmed in game by Four on 2026-11-12: all five generators shut down and each counted
  in the scenario tracker (5/5), the force field dropped and Immol'thar was killed. All west wing
  bosses, Prince Tortheldrin included, showed 1/1.

### Dire Maul: Magister Kalendris reset to full when fought solo

- **Found** (Four, 2026-11-12): Kalendris could not be killed: his Dominate Mind broke combat and he
  went back to full health.
- **Cause:** his SmartAI cast Dominate Mind 7645 at a random player (`target_type` 5). Solo, that is
  the only player he is fighting; once Four was charmed he had nobody left to attack, so he evaded
  and healed to full. The dump has two copies of the cast (rows 3 and 12, two script versions mixed).
- **Changed:** `sql/fixes/world/2026_11_12_02_dire_maul_kalendris_dominate.sql` sets both rows to
  `target_type` 6 (a random player other than his current target). In a group he still dominates
  someone; solo the cast is skipped. No other creature in Dire Maul casts a charm.
- **Status:** confirmed in game by Four on 2026-11-12 (Kalendris killed solo, 1/1 in the tracker).

### Dire Maul: stray Mana Bursts and west wing movement

- **Found** (before Four's first run): six Mana Burst 14397 spawns (guids 324130-324135) stood on top
  of Residual Monstrosities. A Monstrosity summons Mana Bursts when it dies (22939); the static copies
  are sniff leftovers, in neither the Pandaria 5.4.8 nor the AzerothCore database. Only 2 of the
  west wing's 268 spawns moved.
- **Changed:** `sql/fixes/world/2026_11_12_01_dire_maul_west.sql` deletes the six Mana Bursts, gives
  15 spawns their Pandaria 5.4.8 patrol (same guids, paths 429001001-429001015: 4 Ironbark
  Protectors, 3 Residual Monstrosities, 3 Eldreth Spectres, 2 Eldreth Spirits, 2 Highborne
  Summoners, 1 Petrified Treant) and makes 7 spawns wander within 5 yards (AzerothCore, matched by
  entry and position).
- **Status:** SQL runs twice cleanly on a test copy of the world database; not tested in game yet.

## 2026-11-12 (World fixes: patrols from TDB 7.3.5)

Merged to `main` with PR #60 on 2026-11-12.

### World: 733 open-world NPCs stood still where they should patrol

- **Found** (Wayfarer, 2026-11-12, comparing with TDB 7.3.5 in `xxciv/zrbfa_wdbdumps`): 1,150 spawns
  walk a waypoint path in TDB 7.3.5 but stand still or wander at random here (same NPC within 8
  yards), the same problem as the Battlescar fliers.
- **Cause:** the dump has no path for them (`MovementType` 0 or 1, no `creature_addon.path_id`).
- **Changed:** `sql/fixes/world/2026_11_12_31_tdb735_patrols.sql` (the header lists every NPC):
  - 733 spawns on the four continents get TDB's path: Outland 287, Northrend 278, Kalimdor 104,
    Eastern Kingdoms 64. Biggest groups: Orgrimmar Grunt and Arcane Patroller (17 each), Azure
    Drake and Talonbranch Wisp (12), Zabra'jin Guard, Necrolord and Gjalerhorn Scavenger (10).
  - 11,662 `waypoint_data` points in new paths 735000001-735000733, with TDB's points, delays,
    orientations and walk/run flags. TDB's waypoint actions are dropped (their scripts aren't here).
  - `creature_addon.path_id` set (row added where the spawn had none) and `creature` set to
    `MovementType` 2, `spawndist` 0, each checked by guid and entry.
  - 8 followers join their leader as in TDB (`creature_formations`, groupAI 515 so they walk with
    it): the five battleground envoys at their posts, a Gnomeregan Infantry and two Highbank
    Guardsmen.
  - Left alone: 347 dungeon spawns (dungeon thread's area), 28 NPCs with a core script, 11 whose
    SmartAI moves them, 18 with no usable TDB path, spawns already in a formation or moving, and a
    Broom whose path starts 97 yards from our spawn.
- **Status:** Orgrimmar Grunts walking their circuits confirmed in game by Four on 2026-11-12. The
  other patrols get checked as Four meets them.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

## 2026-11-12 (World fixes: SmartAI for scriptless NPCs from TDB 7.3.5, NPC spell costs)

Merged to `main` with PR #59 on 2026-11-12.

### World: 854 old-world NPCs had no script and only meleed

- **Found** (Wayfarer, 2026-11-12, comparing our world DB with the TrinityCore releases in
  `xxciv/zrbfa_wdbdumps`): 886 NPCs are spawned here with no SmartAI rows and no core script, so they
  stand and melee. TDB 7.3.5 has a SmartAI script for every one of them (Creeping Sludge 12222 is
  left out here because upstream already scripts it).
- **Cause:** the dump never had scripts for them. Most already say `AIName='SmartAI'`, but with no
  rows behind it, so they act like a plain melee mob.
- **Changed:** `sql/fixes/world/2026_11_12_30_tdb735_smartai_for_scriptless_npcs.sql` (the file's
  header lists all 854 NPCs by entry, name and spawn count):
  - 2,429 `smart_scripts` rows (source 0) for the 854 entries, copied from TDB 7.3.5 with
    `event_param5`=0 added. That is 4,046 spawns: Northrend 1,250, Outland 1,048, Kalimdor 734,
    Eastern Kingdoms 327, dungeons and other maps 687. Biggest: Dragonmaw Peon Work Node 23308 (140),
    Grizzly Bear 27131 (113), Rookery Whelp 10161 (95), Mindless Ghoul 27712 (79), Timberstrider
    Fledgling 17372 (76), Flame Breath Trigger (Skadi) 28351 (75), Glinting Dirt 28362 (73), the
    four battleground envoys 15105/15106/14990/30567 (61 each), Tortured Skeleton 18797 (59).
  - 1,612 action list rows (source 9) in 289 lists. Blood Knight Stillblade's list 1776800 keeps
    upstream's own ids 5-7 (`2026_08_09_00_death_knight_stillblade`); TDB's ids 0-4 fill the rest.
  - 123 SmartAI conditions (type 22) that belong to these scripts.
  - `AIName`='SmartAI' on Grizzly Bear 27131 and High Explorer Dellorah 33701, the two that had
    another AI name.
  - Every event, action and target type exists in HavenCore, and every spell (checked against
    SpellName.db2), creature, gameobject and quest a row names exists here. 22 standalone cast rows
    whose spell is gone in 8.3.7 were dropped and the rest of those NPCs' scripts kept. One dangling
    link (Gaffer Coilspring 46274 id 0 -> 1) is set to 0. Every text group and waypoint path the
    scripts use already exists here, so no `creature_text` or `waypoints` rows are added.
  - Two casts use the cost-free copy of the same spell. NPCs only have mana when their class is
    paladin or mage, and the core makes them pay spell costs, so these never fired: Ghostclaw Lynx
    16348 Rake 59881 (20 focus) -> 24332, Urdak 18541 Enveloping Winds 6728 (19 mana, warrior
    class) -> 15535. Found by Four: the Lynx never raked, even with `.cast back 59881`.
  - Left out (32 NPCs):
    - every row casts a spell that no longer exists: 683 Young Panther, 736 Panther, 1679 Avarus
      Kharag, 2744 Shadowforge Commander, 3811 Giant Ashenvale Bear, 3939 Razormane Wolf, 3940
      Taneel Darkwood, 4798 Fallenroot Shadowstalker, 6047 Aqua Guardian, 13219 Jorek Ironside,
      17584 Torallius the Pack Handler.
    - a gameobject it uses does not exist here: 1373 Jarven Thunderbrew (gameobject 35875), 4721
      Zangen Stonehoof (gameobject 20556), 4880 "Stinky" Ignatz (gameobject 11757), 7007 Tiev
      Mordune (gameobject 15175), 25849 Fezzix Geartwist (gameobject 60069), 25983 Dorain
      Frosthoof (gameobject 113431), 28273 Arranged Crystal Formation Bunny (gameobject 4599).
    - a quest it uses does not exist here: 4489 Braug Dimspirit (quest 6627), 7853 Scooty (quest
      2843), 8879 Royal Historian Archesonus (quest 3702), 9021 Kharan Mighthammer (quest 4342),
      23899 Tethyr (quest 11198), 23905 Major Mills (quest 11198).
    - a linked or gossip step uses a spell that no longer exists: 16287 Ambassador Sunsorrow
      (spell 37084), 19217 Ravandwyr (spell 35378), 19656 Invisible Location Trigger (spell
      29397), 21293 Borak, Son of Oronok (spell 37064), 21725 Kagrosh (spell 37245), 21727
      Flanis Swiftwing (spell 37244), 21877 Karsius the Ancient Watcher (spell 37782).
    - TDB has no rows for its action list: 44782 Rento.
- **Status:** Ghostclaw Lynx Rake confirmed in game by Four on 2026-11-12. The other scripts get
  checked as Four meets them. The SQL runs cleanly, twice in a row, on a copy of our world DB with
  all upstream `sql/updates/world` and our `sql/fixes/world` applied.
- **Pick up:** run the SQL on `bfa_world`, then restart worldserver.

### Core: NPCs never cast spells that cost a power they don't have

- **Found** (Four, 2026-11-12): the Ghostclaw Lynx never cast Rake 59881, even with `.cast back`.
- **Cause:** `Creature::UpdateLevelDependantStats` only gives paladin- and mage-class NPCs a power
  pool (mana). `Spell::CheckPower` still checks every cost, so an NPC spell that lists focus,
  energy, rage, runes or runic power, or mana on a warrior- or rogue-class NPC, always failed with
  "not enough power". Rake 59881 costs 20 focus. Our own scripts have about 570 cast rows like this
  (energy 238, mana 227, runic power 46, runes 42 and a few others), plus casts in core boss scripts.
- **Changed:** new `tools/bfa/npc-spell-power-cost.patch` (after `spell-teleport-combat.patch`):
  `Spell::CheckPower` skips a cost when the caster is a creature that no player controls and its
  max power of that type is 0. Players, pets, player-driven vehicles and NPCs that do have the
  power are unchanged. Side effect: NPCs that never used those spells here now do, as on retail,
  so some fights (including dungeons already tested) can be harder.
- **Status:** confirmed in game by Four on 2026-11-12: `.cast back 59881` (20 focus) now lands on a
  Ghostclaw Lynx, alongside its scripted Rake 24332.
- **Pick up:** apply the patch, rebuild, restart worldserver.

## 2026-11-11 (Scholomance)

Merged to `main` with PR #58 on 2026-11-12. New core patch `tools/bfa/scholomance.patch` (applied after
`spell-teleport-combat.patch`, build needed, `cmake build` first) and
`sql/fixes/world/2026_11_11_03_scholomance_rework.sql`, plus SQL 04-07 and
`2026_11_12_00`. Also `tools/bfa/instance-scenario-cleanup.patch` (after `scholomance.patch`).
Called complete by Four on 2026-11-12.

### Scholomance: Mists of Pandaria boss scripts and story

- **Found** (before Four's first run): the core still carried the classic Scholomance scripts
  (Kirtonos, Ras Frostwhisper, Kormok and the rest, map 289). Map 289 can't be entered in 8.3.7, and
  the Mists of Pandaria dungeon (map 1007) had no boss scripts at all: all five bosses ran SmartAI
  with a few rows each. The story cast was missing: no Lilian Voss 59200 (only an unscripted copy,
  58722, standing in the Rattlegore hall), no Darkmaster Gandling 58875 for the Rattlegore intro, no
  Chillheart phylactery, ice wall, book targets or Soulflame braziers. Darkmaster Gandling 59080 was
  friendly (faction 35) and unattackable (unit_flags 2147483752). The Bone Piles had no click.
  Most NPCs only had a difficulty 0 level-scaling row, so in the dungeon they rolled a random level
  between 41 and 92. There were no Dungeon Finder encounter rows for the five bosses, no exit at the
  stairs (area trigger 7539) and no graveyard for zone 6066.
- **Changed:** `tools/bfa/scholomance.patch` (in `src/server/scripts/EasternKingdoms/Scholomance/`)
  removes the 13 classic boss files and ports the Pandaria 5.4.8 scripts:
  - `instance_scholomance.cpp`, `scholomance.h`: boss states 0-4, the boss doors (Chillheart exit,
    Jandice entrance and exit, Rattlegore exit, Lilian entrance, chest and exit, Gandling's two
    doors). Killing Lilian sends scenario event 30834 (criteria 19262 "Lilian Voss defeated"). Doctor
    Theolen Krastinov 59369 only shows on heroic, one run in ten.
  - `boss_instructor_chillheart.cpp`: Ice Wrath, Frigid Grasp, Touch of the Grave, Wrack Soul
    (heroic), the flying books over the 11 book targets. At 0 health she drops and her phylactery
    58664 becomes attackable; breaking it kills her. The students channelling into the phylactery
    die when she is pulled. The Iron Gate 211259 in front of her room opens with a click.
  - `boss_jandice_barov.cpp`: Wondrous Rapidity; at 66% and 33% she vanishes among 14 illusions.
    Hitting an illusion shatters it, hitting the real Jandice brings her back.
  - `boss_rattlegore.cpp`: hidden until the Boneweavers 59193 are dead, then rises ("RATTLEGORE!").
    Two of the six braziers burst into Soulflame for 15 seconds; Bone Spike hits a random player and a
    Bone Pile click (Bone Armor 113996) soaks one spike.
  - `boss_lilian_voss.cpp`: the Rattlegore hall intro with Gandling, her walk to her room, the
    fight (Shadow Shiv, Death's Grasp, Dark Blaze), the soul phase at 50% (Lilian's Soul 58791 fixates
    a player), and her end: she jumps at Gandling and dies.
  - `boss_grandmaster_gandling.cpp`: Incinerate, Immolate, Rise, and Harsh Lesson (never on the tank,
    so not when solo).
  - `scholomance.cpp`: the Talking Skull 64562 that leads the way and comments on each boss, and
    Gandling at Rattlegore 58875.
  - Left out: Gravity Flux (no area trigger data in 8.3.7), the moving ice wall (cosmetic only), the
    polyformic acid potion morph.
- **Changed:** `sql/fixes/world/2026_11_11_03_scholomance_rework.sql`:
  - Spawns (guids 1007000001-1007000034, Pandaria 5.4.8 world DB): Lilian Voss 59200, Gandling
    58875, phylactery 58664, ice wall 68291, 11 Book Spawn Targets 58917, 6 Soulflame 59316 + 6
    brazier stalkers 45979, Gandling's fire stalker 30298, 6 more Teleport Locations 59167. The old
    Lilian Voss 58722 spawn is deleted. The trash stays as it was (retail sniff, fewer mobs than the
    Pandaria DB). Two Risen Guards (510000181, 510000221) walk the Pandaria patrol paths 1007000901
    and 1007000902.
  - Gameobjects (guids 1007000001-1007000066): the Chillheart-to-Jandice gate 211258, Jandice's gate
    211257, the missing Harsh Lesson door 210784, the instance portal 212899, alchemy bottles and lore
    books. The Challenge Mode start door 211988 (closed, in the entrance hall) and Challenger's Orb
    211674 now spawn on Mythic Keystone (8) only.
  - Scripts: AIName/ScriptName for 58633, 58664, 68291, 59707, 66240, 59227, 59711, 59184, 59220,
    59153, 59200, 58791, 59080, 59167, 58875, 64562 and their SmartAI rows deleted; gameobject 211259
    gets `go_chillheart_iron_door`; spell scripts for 111631, 113775, 113999, 114009, 111642, 111570.
    The classic map 289 script names are cleared (13 creatures, gameobject 175564, 4 spell scripts,
    instance_template 289).
  - Templates: Gandling 59080 faction 14, unit_flags 0; books 59707/66240/59227 faction 16 and Arcane
    Bomb 59711 faction 14; stalkers 57860, 58917, 59316, 68291 not selectable with the trigger model;
    Gandling 58875 InhabitType 5; Bone Pile 59304 npcflag 16777216 + spellclick 113996.
    creature_template_addon auras from the Pandaria DB for 58875, 59080, 59099, 59193, 59304, 59316,
    59359, 59368, 59503, 59613, 59980, 64562 (and hover for the books).
  - Level scaling rows 1-100 for difficulties 0, 1 and 2 for every NPC spawned on map 1007 and the
    summoned ones (INSERT IGNORE, existing rows kept).
  - Conditions: Soul Rip beam 112081 targets Lilian 59200, Shadow Channel 122499 targets the
    phylactery 58664.
  - creature_text: Gandling 58875 (11 lines), Gandling 59080 (4), Rattlegore 59153 (2), Lilian 59200
    (7), Talking Skull 64562 (12), all with their broadcast text ids.
  - instance_encounters 1426-1430 (Gandling 1430 ends Dungeon Finder dungeon 2), classic 463 no
    longer claims dungeon 2; lfg_dungeon_template row for dungeon 2 (same arrival as heroic 472).
  - Area trigger 7539 (exit stairs) -> world_safe_locs 3672 (Facing set to 3.57792 radians);
    graveyard 1878 (Scholo GY, Western Plaguelands) for zone 6066.
- **Status:** not tested in game yet. Compiles; the SQL runs cleanly (twice) on a test copy of the
  database.

### Scholomance: gates turned sideways

- **Found** (Four, 2026-11-11, screenshot): the Iron Gate in front of Instructor Chillheart's room
  stood sideways, along the corridor instead of across it.
- **Cause:** every door on map 1007 has the rotation quaternion (0, 0, 1, -0.0000000437), a 180 degree
  turn, whatever its orientation is (the Pandaria DB has the same values). The 8.3.7 client draws
  gameobjects by the quaternion, so the gates with orientation pi/2 or 3pi/2 were 90 degrees off.
- **Changed:** `sql/fixes/world/2026_11_11_04_scholomance_door_rotation.sql` sets
  rotation2 = sin(orientation/2), rotation3 = cos(orientation/2) on the 12 map 1007 gameobjects with
  that quaternion: 211259, 211258, 211257, 211256, 211261, 211262, 210781, 211260, 210789, 210784,
  210785, 210786. 211259 becomes (0, 0, 0.7071, 0.7071).
- **Status:** not tested in game yet.

### Scholomance: French object names

- **Found** (Four, 2026-11-11): the gate in front of Chillheart's room is called "Porte de fer".
- **Cause:** 13 Scholomance gameobject templates have French names in this database, cut off at the
  first accented letter.
- **Changed:** `sql/fixes/world/2026_11_11_05_scholomance_object_names.sql` sets the English names
  from the Pandaria 5.4.8 DB: Iron Gate (211256, 211257, 211259, 211260, 211261, 211262), Vault of
  Souls 210781, Reinforced Wooden Door 210771, Grandmaster Architect Holmberg 214178, Alchemy Bottle
  White/Green/Blue 211647/211648/211649, Polyformic Acid Potion 211669, Polyformic Acid Potion
  Highlight 211670. Delete the client's Cache folder to see them.
- **Status:** not tested in game yet.

### Scholomance: Lilian's Soul died for good (scaled damage)

- **Found** (Four, 2026-11-11): killing Lilian's Soul left it dead ("Dead 0 / 10,312"). Lilian stayed
  on the floor, Gandling kept floating, and Four stayed in combat.
- **Cause:** `Unit::DealDamage` calls the creature's `DamageTaken` first and only afterwards divides
  the damage by the level-scaling health multiplier (`GetHealthMultiplierForTarget`). On a scaled
  creature the health that comes off is much bigger than the damage `DamageTaken` sees, so the
  scripts' "is this the killing blow" checks missed: the soul really died instead of turning
  immortal, and Chillheart died once before her phylactery killed her (her scenario criteria showed
  progress 2).
- **Changed:** `tools/bfa/scholomance.patch`: new `RealDamage()` (`instance_scholomance.cpp`,
  `scholomance.h`) returns damage / multiplier. Chillheart's fake death, Jandice's 66%/33%
  thresholds, Lilian's 50% soul phase and final blow, and the soul's "death" all check it. When a
  hit would kill at a threshold, it now sets 1 health instead of `damage = health - 1`. If the soul
  ever dies anyway, its `JustDied` still raises Lilian.
- **Status:** confirmed in game by Four on 2026-11-11 (phylactery phase works, Lilian's scenario step
  done).

### Scholomance: Gandling swam through the air

- **Found** (Four, 2026-11-11): Darkmaster Gandling 58875 hovers in the corner of Lilian's room and
  swims to the door at the end of her fight.
- **Cause:** he is spawned above the floor with no flying movement flags, so the client plays the
  swim animation when he moves.
- **Changed:** `tools/bfa/scholomance.patch` (`scholomance.cpp`, `npc_gandling_at_rattlegore::Reset`):
  `SetDisableGravity(true)` and `SetCanFly(true)`.
- **Status:** did not help (Four, 2026-11-11: still swimming). Replaced by the entry below.

### Scholomance: Gandling swam through the air (second try)

- **Found** (Four, 2026-11-11): with the fix above, Gandling 58875 still floats and swims above
  Lilian's room.
- **Cause:** his creature_template_addon bytes1 50331648 (from the Pandaria DB, where the top byte
  held the stand/hover flags) puts 3 in the top byte. This core reads that byte as the animation tier
  and 3 is fly; his humanoid model has no fly animation, so the client plays the swim one, more so
  while he moves through the air.
- **Changed:** `sql/fixes/world/2026_11_11_07_scholomance_gandling_hover.sql`: 58875 addon bytes1
  33554432 (tier 2, hover). `tools/bfa/scholomance.patch` (`scholomance.cpp`): only
  `SetDisableGravity(true)` in Reset (no `SetCanFly`), and he no longer moves: he vanishes with the
  teleport visual from Rattlegore's hall after "Come, Voss, your fate awaits you." and reappears above
  Lilian's room, and when Lilian is beaten he vanishes the same way instead of flying to the door.
  `GandlingLeavePoint` removed.
- **Status:** not tested in game yet. Compiles; SQL checked on the test DB.

### Scholomance: Gandling died to one hit, and no Alexei

- **Found** (Four, 2026-11-11): Darkmaster Gandling 59080 died to a single 7,076 Ambush; nothing
  happened afterwards (no Spirit of Lord Alexei Barov).
- **Cause:** Gandling's template was level 1-1, HealthScalingExpansion 0, rank 1, so his health came
  from the level 1 classic table; the other bosses are level 43-92, HealthScalingExpansion 4, rank 3.
  Alexei 64683 (quest ender for An End to the Suffering 31448 and The Four Tomes 31442) was only
  summoned by the Talking Skull at its own position, a few seconds after the kill. If the skull was
  far away or not loaded, he showed up somewhere else or not at all, and he never came back after a
  server restart.
- **Changed:** `sql/fixes/world/2026_11_11_06_scholomance_gandling_level.sql`: 59080 minlevel 43,
  maxlevel 92, HealthScalingExpansion 4, rank 3; 58875 minlevel 43, maxlevel 92.
  `tools/bfa/scholomance.patch` (`instance_scholomance.cpp`, `scholomance.h`, `scholomance.cpp`): the
  instance summons Alexei at Gandling's spot (20.15, 57.74, 73.88) as soon as Gandling dies, and again
  when a player enters an instance where Gandling is already dead (only one at a time). The skull just
  leaves.
- **Status:** level fix confirmed (Gandling now fights). Alexei part replaced by the entry below.

### Scholomance: Alexei could not be talked to

- **Found** (Four, 2026-11-11): Alexei appeared where Gandling died but could not be clicked, and the
  quest map showed the turn-in at the top of the stairs, where the Talking Skull stops.
- **Cause:** there are two copies of each quest. The Talking Skull in the dungeon (64562) gives The Four
  Tomes 31440 and An End to the Suffering 31447, which end at Spirit of Lord Alexei Barov **64660**.
  The script summoned **64683**, which only ends 31442/31448 (from Talking Skull 64563, which is not
  spawned), so it had nothing to say to Four. The quest POI for 31447 puts the turn-in at (51, 59) on
  map 1007, the skull's last stop at the top of the stairs.
- **Changed:** `tools/bfa/scholomance.patch` (`scholomance.h`, `instance_scholomance.cpp`):
  `NPC_ALEXEI_BAROV` = 64660, summoned at (53.56, 59.90, 87.22), facing 2.87.
- **Status:** confirmed in game by Four on 2026-11-11 (both quests turned in). The Gandling hover
  fix (SQL 07) works too; he now floats standing up above Lilian's room (1.9 yards over the floor, as
  in Pandaria).

### Scholomance: Lilian died for no visible reason

- **Found** (Four, 2026-11-11): at the end of her fight Lilian jumps at Gandling, there is a pause,
  he teleports away and she just dies.
- **Changed:** `tools/bfa/scholomance.patch`: on "What?!" Gandling channels the Soul Rip beam
  (112081) into Lilian until he teleports (`scholomance.cpp`). After she lands, Lilian kneels and
  says "Leave me...to die...alone...please..." (creature_text 59200 group 5, broadcast 58528, sound
  29467), then dies 4 seconds later (`boss_lilian_voss.cpp`, new `EVENT_LAST_WORDS`).
- **Status:** confirmed in game by Four on 2026-11-11.

### Scholomance: graveyard

- **Status:** confirmed in game by Four on 2026-11-12 (dying inside sends you to the Scholomance
  graveyard).

### Scholomance: the entrance pulled you in before the door

- **Found** (Four, 2026-11-12, video): walking in from Caer Darrow, the dungeon teleported Four
  inside before reaching the entrance door; leaving by the stairs and heading for that door pulled
  Four back in. The real portal, down the stairs, worked.
- **Cause:** two areatriggers in Western Plaguelands teleport to Scholomance (`areatrigger_teleport`,
  both to entrance point 3671). 2567 at (1282.05, -2548.73, 85.40) is the Mists of Pandaria
  entrance down the stairs, and the only one in the Pandaria 5.4.8 database. 6339 at
  (1270.56, -2570.14, 97.00), a 6 x 10 x 10 box named "This was old Scholo entrance", sits on the way
  to the door, above the spot where the stairs exit drops you (1273.91, -2553.09, 91.84). Positions
  from `AreaTrigger.db2`.
- **Changed:** `sql/fixes/world/2026_11_12_00_scholomance_early_entrance_trigger.sql` deletes the
  `areatrigger_teleport` row for 6339. Nothing else uses that trigger.
- **Status:** confirmed in game by Four on 2026-11-12. With this, Four called Scholomance complete.

### Core: old scenario progress showed up in a new dungeon run

- **Found** (Four, 2026-11-12): every new Scholomance run opened with Chillheart, Jandice, Rattlegore
  and Gandling already at 1/1 in the scenario tracker (only Lilian at 0/1), after killing only
  Chillheart. Earlier the Chillheart counter had climbed from 2 to 3 across runs.
- **Cause:** the core saves boss kills (criteria types KILL_CREATURE and COMPLETE_DUNGEON_ENCOUNTER)
  in `instance_scenario_progress` in the characters database, keyed by instance id. At startup,
  `InstanceSaveManager::LoadInstances` deletes old rows from `instance` (expired or no longer bound to
  anyone, which is every normal 5-man you left) and then hands their ids out again, lowest first. It
  never deleted those instances' `instance_scenario_progress` rows, so the next dungeon that got the
  same id loaded the old kills. Lilian is a scenario event, not a kill, so she was never saved.
- **Changed:** new core patch `tools/bfa/instance-scenario-cleanup.patch` (after `scholomance.patch`)
  in `src/server/game/Instances/InstanceSaveMgr.cpp`: `LoadInstances` now also runs
  `DELETE FROM instance_scenario_progress WHERE id NOT IN (SELECT id FROM instance)` with the other
  startup cleanups. It affects every dungeon with a scenario, not only Scholomance. The leftover rows
  in your database go away at the first start with the patch.
- **Status:** confirmed in game by Four on 2026-11-12 (fresh run opens with all five bosses at 0/1).

## 2026-11-11 (World fixes: stacked NPCs in Stormwind Harbor and Bloodhoof Village)

Merged to `main` with PR #57 on 2026-11-11.

### World: 7th Legion warship crew spawned twice in Stormwind Harbor

- **Found** (Four, 2026-11-11): the 7th Legion warship in Stormwind Harbor, with Vereesa
  Windrunner and Arator the Redeemer, has a lot of doubled NPCs.
- **Cause:** the dump has the ship crew twice. Guids 401232-401247 are the sniffed spawns. A later
  block (guids 300001112-300001158) repeats 14 of them with the same entry, position and phase, so
  each of those NPCs stands twice on one spot. Upstream's `sql/updates` don't touch any of them.
- **Changed:** `sql/fixes/world/2026_11_11_30_stormwind_harbor_ship_double_spawns.sql` deletes the
  14 copies (each checked by guid and entry):
  - Grand Admiral Jes-Tereth 121753: 300001112 (copy of 401236).
  - Arator the Redeemer 121755: 300001148 (copy of 401232).
  - 7th Legion Marine 121757: 300001123, 300001129, 300001150, 300001153, 300001155, 300001158
    (copies of 401235, 401247, 401246, 401245, 401244, 401243).
  - 7th Legion Rifleman 121775: 300001119, 300001124, 300001141, 300001143, 300001146, 300001152
    (copies of 401242, 401237, 401238, 401239, 401240, 401241).
  - Kept: the two 7th Legion Cannoneers (300001147, 300001159), which have no other copy, and
    Vereesa 3000000 / Vindicator Boros 3000003. Those two sit on top of 401233 / 401231 but are in
    phase 7439, which nothing turns on, so players never see them.
- **Status:** confirmed in game by Four on 2026-11-11.

### World: two Shaman Trainers stacked in Bloodhoof Village

- **Found** (Four, 2026-11-11): Bloodhoof Village has at least one stacked trainer.
- **Cause:** Narm Skychaser 3066 (guid 260382) and Tarl Cloudsong 51637 (guid 302648), both
  <Shaman Trainer>, are spawned at the same position, orientation and phase (-2298.96 -437.742
  -5.355). MaNGOS Three has the same pair. Both have the same trainer gossip (menu 4103, npcflag 51)
  and no quests. Gennia Runetotem, the druid trainer, stands alone about 17 yards away. No other
  NPC in Bloodhoof Village is stacked.
- **Changed:** `sql/fixes/world/2026_11_11_31_bloodhoof_shaman_trainers_stacked.sql` deletes Tarl
  Cloudsong's spawn (guid 302648, entry 51637). Narm Skychaser stays.
- **Status:** confirmed in game by Four on 2026-11-11.
- **Pick up (both fixes of this date):**

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
  ```

  ```
  git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_11_30_stormwind_harbor_ship_double_spawns.sql | mysql -u root -p bfa_world
  ```

  ```
  git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_11_31_bloodhoof_shaman_trainers_stacked.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-11 (Dire Maul: Warpwood Quarter)

Merged to `main` with PR #36 on 2026-11-11. SQL `sql/fixes/world/2026_11_03_04` to `_06` and
`2026_11_11_00` to `_02` (Dire Maul files), plus the new core patch `tools/bfa/spell-teleport-combat.patch`
(applied last; rebuild). The thinning files copy the removed rows into backup tables first. Needs a
fresh instance (`.instance unbind all`).

Pre-run check of the east wing (Pusillin, Zevrim Thornhoof, Hydrospawn, Lethtendris, Alzzin). All
bosses are spawned with Normal scaling rows, `instance_encounters` 343-346 exist (Alzzin ends LFG
dungeon 34), and all their spells exist. Dire Maul has one scenario for all three wings (668, step
1212 "Defeat the bosses of Dire Maul", 14 bosses), so it cannot finish from one wing.

### Zevrim Thornhoof healed to full on every Sacrifice
- **Found** (reported by Four): Sacrifice (22651) stuns the player, which is right, but Zevrim
  went back to full health each time, so he could not be killed solo. Sacrifice's first effect
  teleports the player onto his altar (`spell_target_position` -25.95, -448.24, -36.09).
  `Spell::EffectTeleportUnits` (`SpellEffects.cpp`) passes no options when the target is not the
  caster, and `Player::TeleportTo` calls `CombatStop()` on a same-map teleport without
  `TELE_TO_NOT_LEAVE_COMBAT`. The player left combat, Zevrim had nobody left to fight, evaded
  and reset.
- **Changed:** new `tools/bfa/spell-teleport-combat.patch` (applied after `razorfen-downs.patch`):
  a spell teleport of another player that stays on the same map adds `TELE_TO_NOT_LEAVE_COMBAT`.
  Teleports to another map still leave combat. This covers every boss pull-to-me spell, not
  just Zevrim's.
- **Status:** confirmed in game by Four on 2026-11-11 (Zevrim killed; Sacrifice stuns without resetting him).

### Pusillin's chase stopped early and always showed the same text
- **Found:** two versions of his script on top of each other. All five Gossip Hello rows had no
  phase mask, so every one fired and the last menu won. Rows "stop at waypoint 3/14/12/7" belong to
  an old 3-point path and cut each run short. His four paths (14354, 143540, 287080, 430620) are
  complete and join end to start.
- **Changed:** `smart_scripts` 14354 and action lists 1435400-1435404 rebuilt: gossip menu 5709-5713
  by phase 1-5; each answer closes the gossip, says his line and runs the next path; at the end of a
  path he is talkable again. The fifth answer makes him hostile (faction 16), casts Spirit of Runn
  Tum (22735) and summons five Wildspawn Imps (13276, new row id 1: summoned imps join the fight).
- **Status:** confirmed in game by Four on 2026-11-11 (full chase, fight, kill).

### The Conservatory Door to Alzzin never opened
- **Found:** Old Ironbark (11491) offers "We are ready for you to open the door" but had no script,
  so choosing it did nothing and the Conservatory Door (176907) stayed shut. Ironbark the Redeemed
  (14241, guid 323214) stood on the same spot with the same gossip and no script either.
- **Changed:** Old Ironbark: on that option he closes the gossip, walks AzerothCore's 14-point path
  (new `waypoints` path 1149100) to the door and opens it. Guid 323214 deleted.
- **Status:** confirmed in game by Four on 2026-11-11 (Ironbark walks to the door and opens it).

### Alzzin the Wildshaper, Lethtendris and Pimgib scripts
- **Found:** Alzzin had 24 rows from two script versions (orphan "reset on evade" links, a broken
  40% chain). Lethtendris cast Curse of Tongues twice (ids 3 and 4). Pimgib had two caster scripts
  on top of each other. Hydroling (14350) had no Normal scaling row.
- **Changed:** Alzzin rebuilt from AzerothCore: Disarm, Enervate, Knock Away and Wither as a night
  elf; Mangle and Vicious Bite in Dire Wolf Form (22660); Wither and Wild Regeneration in Tree Form
  (22688); a random form every 20 seconds (lists 1149200-1149202); four Alzzin's Minions (11460) from
  the crumbled wall at 50% health (list 1149203; new row: summoned minions join the fight).
  Lethtendris id 4 casts Curse of Thorns (16247). Pimgib: Fireball, Flame Buffet, Blast Wave.
  Hydroling gets a scaling row for difficulty 1.
- **Status:** confirmed in game by Four on 2026-11-11 (all east-wing bosses killed).

### Warpwood packs stacked on top of each other (thinned)
- **Found** (reported by Four): Warpwood elites hit very hard solo, and in a few spots two or more
  stand on the same spot. Classic Dire Maul has about the same number of them (BFA 16 Treants,
  12 Guardians, 8 Tanglers; AzerothCore 14, 10, 8), so this is pack size, not a duplicate dump.
- **Changed:** Four chose thinning over a damage change.
  `sql/fixes/world/2026_11_11_00_dire_maul_east_thin_warpwood_packs.sql` removes ten spawns that
  stand within 0.7-5 yards of a twin: Guardians 323183, 324036, 324037, 323198; Treants 323391,
  323704, 323985, 323983, 323996; Tangler 323981 (and treant 323391's path 429000019). Every pack
  keeps at least one of each kind. The removed rows are copied first into the backup tables
  `zr_backup_dm_east_creature`, `zr_backup_dm_east_creature_addon` and
  `zr_backup_dm_east_waypoint_data`; the file header has the three lines that restore them.
- **Status:** confirmed in game by Four on 2026-11-11.

### Death Lash pairs stacked on top of each other (thinned)
- **Found:** 23 Death Lash (13285) in the east wing against 14 in classic, five pairs standing
  within 0.8-2.3 yards of each other.
- **Changed:** Four asked to thin them too.
  `sql/fixes/world/2026_11_11_01_dire_maul_east_thin_death_lash.sql` removes one of each pair:
  323213, 324089, 324114, 324078, 324100 (23 -> 18). Rows are copied first into the same backup
  tables as the Warpwood thinning.
- **Status:** confirmed in game by Four on 2026-11-11.

### Alzzin's wolf phase could not be survived solo
- **Found** (reported by Four): in wolf form Alzzin attacked so fast that no healing kept up.
  Dire Wolf Form (22660) adds +75% melee attack speed and +50% damage done on top of the
  transform, Mangle and Vicious Bite come with it, and the random form every 20 seconds brought
  it back often.
- **Changed:** `sql/fixes/world/2026_11_11_02_dire_maul_alzzin_wolf_form.sql`: the wolf phase
  (list 1149201) morphs him into Fenrus the Devourer (4274, the creature the spell transforms into)
  instead of casting 22660, so he keeps Mangle and Vicious Bite but gets no haste or damage bonus.
  The night elf and tree lists (1149200, 1149202) and his reset drop the wolf look first.
- **Status:** confirmed in game by Four on 2026-11-11: challenging but doable solo.

### Nothing in the east wing moved
- **Found:** 449 spawns, 30 random wanderers, no paths.
- **Changed:** 52 patrols (Pandaria paths for the same guids, else AzerothCore, ids 429000002+),
  2 formations, 183 wanderers. Bosses, Pusillin, Old Ironbark and the Alzzin's Minions are left still.
- **Found** (reported by Four): Warpwood Treant 323675 bounced through the air on its patrol. It
  and two more spawns (treant 323700, Warpwood Tangler 323994) had the same 300-yard AzerothCore
  loop round the whole courtyard (paths 429000031, 429000033, 429000038).
- **Changed:** `sql/fixes/world/2026_11_03_06_dire_maul_east_treant_loop.sql`: those three wander
  2 yards at their spawn point instead, and the three paths are deleted. 49 patrols left.
- **Status:** the wing was played through on 2026-11-11 with this in; Four did not report the treants separately.

## 2026-11-11 (Addon fixes: BugTabs, FishingBuddy, Sorted)

Client addons only, in `client/`. No server change: nothing to rebuild, no SQL, no restart.

### BugTabs 1.5.0: CallbackHandler error in every addon that fires callbacks
- **Found** (reported by Four): `BugTabs\Libs\CallbackHandler-1.0\CallbackHandler-1.0.lua:19: attempt to
  call upvalue 'securecallfunction' (a nil value)`, raised from FishingBuddy's HereBeDragons library.
- **Cause:** addons share one CallbackHandler-1.0 through LibStub, and LibStub keeps the copy with the
  highest minor version. BugTabs ships minor 8 (written for current clients), which dispatches callbacks
  with `securecallfunction`. That function does not exist in the 8.3.7 client. BugTabs loads early
  (alphabetical), so its copy also built the shared LibDataBroker-1.1 registry, and every addon's
  callbacks went through it.
- **Changed:** `client/BugTabs/Libs/CallbackHandler-1.0/CallbackHandler-1.0.lua`: when
  `securecallfunction` is missing, it is replaced (locally) by `xpcall(method, errorhandler, ...)`, the
  dispatch minor 7 used; callback errors still reach the error handler. `BugTabs.toc`: `## Interface:
  80300` (was the retail/classic list starting 120107), version `1.5.0-zr1`. The rest of BugTabs already
  checks for newer APIs before using them.
- **Status:** confirmed in game by Four on 2026-11-11.

### FishingBuddy 1.10.10: same CallbackHandler error
- **Found:** the error above, fired from `FishingBuddy\Libs\HereBeDragons\HereBeDragons-2.0.lua:269`.
  FishingBuddy's own copy (minor 7) is fine, but BugTabs' minor 8 replaced it.
- **Changed:** `client/FishingBuddy/Libs/CallbackHandler-1.0/CallbackHandler-1.0.lua`: `MINOR` 7 -> 100,
  code unchanged, so this 8.3.7-safe copy takes over from any newer copy loaded before it.
  `FishingBuddy.toc`: version `1.10.10-zr1`.
- **Status:** confirmed in game by Four on 2026-11-11.

### Sorted 1.2.4: UpgradeIcon and GetItemCooldown errors
- **Found** (reported by Four):
  - `Interface\FrameXML\ContainerFrame.lua:1115: attempt to index field 'UpgradeIcon' (a nil value)`,
    from `Sorted\ItemButton.lua:216`, when the item level column is turned on.
  - `Sorted\ItemButton.lua:538: Usage: GetItemCooldown(itemID)`.
- **Cause:**
  - `ItemButton.lua` creates its own upgrade arrow with `if button.UpgradeIcon then`, so only buttons that
    already had one got it. Bank (`BankItemButtonGenericTemplate`) and reagent bank buttons have none, so
    Blizzard's `ContainerFrameItemButton_UpdateItemUpgradeIcon` indexed nil on them.
  - Every slot polls `GetItemCooldown(self.itemID)` in `OnUpdate`, including empty slots, whose `itemID`
    is nil; the 8.3.7 client rejects nil.
- **Changed:** `client/Sorted/ItemButton.lua`: the check is now `if not button.UpgradeIcon then`; the
  cooldown poll uses `0, 0, 0` (no cooldown) when `itemID` is nil. `Sorted.toc`: version `1.2.4-zr1`.
- **Status:** confirmed in game by Four on 2026-11-11.

### Sorted: tooltips for the closed bank and other characters' bags
- **Found** (asked by Four): hovering an item in the Bank or Reagents list shows no tooltip unless the
  bank is open at a banker. Stock Sorted behaves the same: its tooltip uses the live
  `GameTooltip:SetInventoryItem` / `SetBagItem` calls, and the client has no live data for a closed bank
  or another character's bags, which Sorted shows from a saved snapshot.
- **Changed:** `client/Sorted/ItemButton.lua`: new `SortedItemButton_ShowSavedLinkTooltip`, called first in
  `SortedItemButton_DelayedOnEnter`. For a bank/reagent slot while the bank is closed, or any slot while
  another character is selected, it shows the tooltip from the slot's saved item link
  (`GameTooltip:SetHyperlink`; caged battle pets via `BattlePetToolTip_Show`), with the usual compare
  tooltips. Live slots are unchanged.
- **Follow-up** (Four, 2026-11-11: zr2 still showed no tooltip): Sorted calls `Disable()` on the buttons
  of snapshot slots, and a disabled button skips `OnEnter`/`OnLeave` by default, so the new code never
  ran. `Sorted_CreateItemButton` now calls `SetMotionScriptsWhileDisabled(true)` on each item button.
  Clicks stay blocked. `Sorted.toc`: version `1.2.4-zr3`.
- **Status:** confirmed in game by Four on 2026-11-11.

## 2026-11-10 (Quest fixes: patch chain on newer upstream)

Merged to `main` with PR #55 on 2026-11-10.

### Patches: quest-objective-flags and mulgore-bristleback-fight apply on newer HavenCore

- **Found** (the transmog thread, rebuilding the full patch stack, 2026-11-10): in the guide order,
  `quest-objective-flags.patch` fails on HavenCore f8f34b1 and on upstream HEAD 9876a1a
  (`Player.cpp` ~17784, `Player.h` ~1530), and `mulgore-bristleback-fight.patch` fails on 9876a1a.
  The guide's step 3 and step 10 lists also missed `razorfen-downs.patch` (the README has it).
- **Cause:**
  - Upstream 53d125a ("Add Field_10 update to client questlog for areatrigger", 2026-10-11) added
    the same `SetQuestSlotObjectiveFlag` / `RemoveQuestSlotObjectiveFlag` helpers and the same
    `SetQuestObjectiveData` change as our patch, so those hunks conflict. Upstream does not have our
    other two parts: `SetQuestSlot` clearing `Field_10` when a quest slot is reused, and
    `_LoadQuestStatusObjectives` restoring the flags at login.
  - Upstream 4561014 (Kyle's Gone Missing, 2026-11-08) added `#include "GameObject.h"` right below
    the include lines our Mulgore patch adds to.
- **Changed:**
  - New `tools/bfa/quest-objective-flags-upstream.patch`: only the `SetQuestSlot` and
    `_LoadQuestStatusObjectives` hunks, for upstream at or after 53d125a.
    `quest-objective-flags.patch` itself is unchanged (still right for 2c13546).
  - Guide step 3 and step 10: the `quest-objective-flags` line is now
    `if grep -q SetQuestSlotObjectiveFlag src/server/game/Entities/Player/Player.h; then git apply ...-upstream.patch; else git apply ...quest-objective-flags.patch; fi`.
    Upstream's fix declares that function in `Player.h`; 2c13546 does not.
  - `tools/bfa/mulgore-bristleback-fight.patch`: the two new includes (`ObjectAccessor.h`,
    `ThreatManager.h`) now go after `ScriptMgr.h`, where the context lines are the same on every
    upstream commit. The code it adds is unchanged.
  - Guide step 3 and step 10: `razorfen-downs.patch` added after `core-branding.patch`.
  - Checked: the full guide chain (all 43 patches) applies cleanly, in order, on 2c13546, f8f34b1
    and 9876a1a. Not compiled on f8f34b1 or 9876a1a.
- **Status:** no in-game change. Four's server (2c13546) already has everything; nothing to pick up.

## 2026-11-10 (Transmog re-apply)

Merged to `main` with PR #54 on 2026-11-10. Core change in the new `tools/bfa/transmog-reapply.patch`,
applied after all the other patches. It only changes `Item.cpp`, which no other patch touches.

### A transmogrified item couldn't be given another appearance
- **Found** (reported by Four): the back and waist slots wouldn't take a new appearance. Apply charged
  the cost every time and the old appearance stayed. Both items already had a transmog. Every check in
  `HandleTransmogrifyItems` passed (the cost is only taken after them), and the handler then calls
  `Item::SetModifier(ITEM_MODIFIER_TRANSMOG_APPEARANCE_ALL_SPECS, appearance)`. `SetModifier` (`Item.cpp`)
  returned straight away when the item already had that modifier, so the new value was never stored and
  the item kept its old appearance. Items with no transmog yet worked, which is why only some slots
  failed. Removing a transmog (the revert arrow) worked, because value 0 takes the remove branch.
- **Changed:** `Item.cpp`, `Item::SetModifier`: when the modifier is already set, the value is updated in
  place (`SetUpdateFieldValue` on `ItemData::Modifiers` at that index). The same function stores illusions
  and per-spec appearances, so changing an existing illusion works again too. No SQL.
- **Status:** confirmed in game by Four on 2026-11-10: the back and waist slots take a new appearance.

### To pick up the transmog re-apply fix
Everything is on `main` now. If you applied the patch from the PR branch, the file on `main` is the same,
so nothing needs rebuilding; just pull:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Without it applied yet, add the new patch. `Item.cpp` isn't a header, so the build is short. There's no SQL:
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/transmog-reapply.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Then type `server shutdown 1` in the worldserver console and start it again with
`cd ~/bfa/server/bin && ./worldserver`.

## 2026-11-10 (pet battles)

### Pet battles: spawn the six zone pets with no spawn data

- **Asked** (Four, 2026-11-10): place the zone pets that had nothing to convert or copy from.
- **Changed:** new `sql/fixes/world/2026_11_10_52_wild_battle_pet_unspawned.sql` adds 10 spawns
  (guids 1000100029-1000100038), each 1 yard from a random unscripted, unphased critter of the zone,
  wandering 3 yards. Counts follow each zone's cap: Exodar Mouse 61143 (1), Talador Crimsonwing Moth
  88413 (1), Frostfire Ridge Ironclaw Scuttler 88474 (2), Gorgrond Sapphire Firefly 88356 (1), Azsuna
  Fledgling Kingfeather 97076 (1), Azsuna Eldritch Manafiend 98386 (4). The spots don't match retail.
  Eldritch Manafiend's `battlepet_info` level range 1-25 is set to 1-1 so the zone decides.
- **Left alone:** Undercity Rat and Lost of Lordaeron exist (filed under Tirisfal); the Shadowmoon
  Valley Warpstalker Hatchling and Wetlands Highlands Mouse rows look like wrong pool rows.
- **Status:** run on Four's live DB; confirmed by Four on 2026-11-10.

#### To pick it up
Run after 2026_11_10_51, then restart `worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_10_52_wild_battle_pet_unspawned.sql | mysql -u root -p bfa_world
```
The last line prints `10 new zone pet spawns`.

### Pet battles: zone audit, 11 zone pets that never spawned

- **Asked** (Four): check every zone's wild pets are enabled.
- **Audit** (world dump plus every pet SQL so far, in a local MySQL): 647 `battlepet_wild_zone_pool`
  rows are for capturable species. 626 had battle pets in their zone (446 at the zone's cap, the rest
  ran out of critters to convert). 21 had none.
- **Changed:** new `sql/fixes/world/2026_11_10_51_wild_battle_pet_missing_zones.sql` fixes 11 of them:
  - 7 pool rows named the plain critter as the battle pet and had no critter entry, so 2026_11_01_50
    skipped them (the Darkmoon Crow's problem). Their critters become the real battle pet up to the
    zone's cap: Tanaris Sea Gull (9), Howling Fjord Turkey (1), Ghostlands Small Frog (3), Jade Forest
    Temple Snake (2), Frostfire Ridge Icespine Hatchling (20), Gorgrond Thicket Skitterer (16),
    Nagrand (Draenor) Shore Crab (13);
  - Swamp of Sorrows Moccasin: its pool row pointed at the Water Snake. 32 Water Snake critters become
    Moccasins 61372;
  - Undercity Rat: the DB files Undercity's rats under Tirisfal (Ruins of Lordaeron, area 153). Those
    28 rat critters become Undercity Rats 61889;
  - Ironforge Long-tailed Mole and Undercity Bat had no critters at all. Added from the alexkulya
    Pandaria DB (guids 1000100001-1000100028): 21 Ironforge moles (3 battle Moles) and 7 bats in the
    Ruins of Lordaeron (2 battle Bats).
  Conversions are logged in `zr_wild_battlepet_conversion`, like 2026_11_01_50. No core change.
- **Not fixed here** (no critters or spawn data to use; six of them are placed by 2026_11_10_52): Wetlands Highlands Mouse, Exodar Mouse, Outland
  Shadowmoon Valley Warpstalker Hatchling (lives in Terokkar, 27 there), Talador Crimsonwing Moth,
  Frostfire Ironclaw Scuttler, Gorgrond Sapphire Firefly, Azsuna Fledgling Kingfeather and Eldritch
  Manafiend, Undercity Lost of Lordaeron (33 in Tirisfal).
- **Status:** run on Four's live DB; confirmed by Four on 2026-11-10.

#### To pick it up
Run after the two Rabbit/Squirrel files below, then restart `worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_10_51_wild_battle_pet_missing_zones.sql | mysql -u root -p bfa_world
```
The last line prints `9 Sea Gulls, 20 Icespine Hatchlings, 32 Moccasins, 28 Undercity Rats, 3 Ironforge Moles`.

### Pet battles: Rabbits and Squirrels can't be battled

- **Found** (Four): no Rabbit, Squirrel or Chicken battle pets to be seen in Elwynn Forest, only Black
  Lambs, Small Frogs and Fawns. The live DB has 3 Rabbits, 7 Squirrels and 2 Chickens there.
- **Cause:** a creature only becomes a wild battle pet when its template is type 14 (wild pet). The
  battle pet templates Rabbit 61080 and Squirrel 61081 are type 0, Echo Batling 88542 is type 12 and
  Globe Yeti 128156 is type 0. Their spawns (43 Rabbits, 208 Squirrels, 7 Echo Batlings in the world
  DB) were plain critters you couldn't battle, and the wild spawn SQL (2026_11_01_50) skipped them,
  because it only converts critters into type 14 pets. These are the only capturable species in
  `battlepet_info` with a non-wild template. Chickens are fine; Elwynn just allows only 2.
- **Then found** (Four): Squirrels could be battled, but the mouse-over cursor stayed the normal one.
  The client takes the cursor from the creature query's CursorName, filled from
  `creature_template.IconName`. Every other capturable pet has `wildpetcapturable`; Rabbit, Squirrel,
  Globe Yeti and Young Mutant Warturtle 110666 had NULL, Echo Batling an empty string.
- **Changed:** new `sql/fixes/world/2026_11_10_50_wild_battle_pet_types.sql` sets type 14 on those 4
  templates and `IconName = 'wildpetcapturable'` on those 5. Running `2026_11_01_50_wild_battle_pet_spawns.sql` again afterwards converts critter
  rabbits and squirrels up to each zone's cap (Elwynn: 10 Rabbits, 12 Squirrels). No core change.
- **Status:** confirmed in game by Four on 2026-11-10 (Squirrel battle and paw cursor).

#### To pick it up
SQL only, then delete the client's `Cache` folder (the client caches creature types) and restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_10_50_wild_battle_pet_types.sql | mysql -u root -p bfa_world
```
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql | mysql -u root -p bfa_world
```
The first prints `4 of 4 pet templates are wild pets, 5 of 5 have the pet battle cursor`; the second prints the running total of converted
spawns (more than the 5,900 from 2026-11-01). Then restart `worldserver`.

## 2026-11-09 (World fixes: Camp Narache battle)

### Core: Bristleback Invaders can't be pulled off the braves and heal back up

- **Found** (Four, 2026-11-09): Rite of Strength asks you to kill Bristleback Invaders, but they
  are locked in the endless battle with the Tauren braves at Camp Narache. A player can barely pull
  one off its brave, and the invader keeps healing.
- **Cause:** upstream's core scripts in `src/server/scripts/Kalimdor/zone_mulgore.cpp`
  (`npc_fledgling_brave` 36942, `npc_bristleback_invader` 36943, set by upstream's
  `2026_09_20_mulgore_camp_narache_cosmetics.sql`):
  - Both `DamageTaken` hooks keep NPC hits from taking them under 80% health. They did that by
    setting the health back **up** to 80% whenever an NPC hit landed below it, so after a player
    brought an invader lower, the next brave hit healed it to 80%.
  - Pets counted as NPCs there (`attacker->IsPlayer()`), so pet damage was capped and healed too.
  - The invader kept the brave on its threat list, and the brave kept attacking it, so the invader
    stayed on the brave.
- **Changed:** new `tools/bfa/mulgore-bristleback-fight.patch` (after
  `quest-objective-flags.patch`), `zone_mulgore.cpp` only:
  - New helpers in `namespace CampNaracheBattle`: `IsPlayerSide` (player, or a player's pet,
    guardian or charmed unit), `IsTakenByPlayer` (a creature whose victim is player-side) and
    `CapNpcDamage` (NPC damage stops at 80% and never raises health).
  - `npc_bristleback_invader`: the first player-side hit calls `TakeOnPlayer`. The invader drops
    every NPC from its threat list, takes itself off their threat lists and attacks that player.
    Every update `KeepPlayerTarget` fixates it on that player (`ThreatManager::FixateTarget`). If
    that player dies or leaves, it switches to another player or pet on its threat list. If there is
    none, it evades, resets to full health and rejoins the battle. While a player fights it, NPC hits
    do 0 damage.
  - `npc_fledgling_brave`: if its target is an invader fighting a player, it drops it and turns to
    the next invader on its threat list. When it looks for a new target within 5 yards
    (`SelectFreeTarget`), it skips invaders a player is fighting.
  - Both `DamageTaken` hooks use `CapNpcDamage` and count pets as players.
  - No DB change. Compiles against upstream 2c13546.
- **Status:** confirmed in game by Four on 2026-11-09 (invaders switch to the player, braves move on,
  no healing).
- **Pick up:** this adds one patch, so only the new patch is applied:

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/mulgore-bristleback-fight.patch | git apply && echo "bristleback fight applied"
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  Then restart worldserver.

## 2026-11-09 (Quest fixes: empty quest page and stuck window after accepting)

Merged to `main` with PR #52 on 2026-11-10.

### Core: quest window turns into an empty page with a disabled Continue button

- **Found** (Four, 2026-11-09, two screen recordings): Tauren, turn in Rite of the Winds (24215) to
  Ahmo Thunderhorn (36644, guid 260022), accept Sharing the Land (14438). Instead of closing, the
  window went back to Ahmo's list ("Current Quests: Sharing the Land") and then to a Sharing the Land
  page with no text and a greyed-out Continue button; only Cancel closed it.
- **Cause:** after the accept the client goes back to Ahmo's quest list, where Sharing the Land is
  now a current quest ("?"), and opens it. The server answers with its progress page
  (`PlayerMenu::SendQuestGiverRequestItems`, reached from `Player::SendPreparedQuest` and from
  `HandleQuestgiverCompleteQuest`). Sharing the Land is a kill quest that isn't done yet and has no
  progress text (no `quest_request_items` row for 14438), so the page is empty and Continue stays
  disabled. Stock and current TrinityCore do the same.
- **Changed:** new `tools/bfa/quest-empty-progress.patch` (after `quest-complete-window.patch`),
  `GossipDef.cpp`, `PlayerMenu::SendQuestGiverRequestItems` only: when the quest can't be completed
  yet, needs no items (`QUEST_SPECIAL_FLAGS_DELIVER` not set) and its `RequestItemsText` is empty,
  send `SendCloseGossip` (close the window) instead of the empty page. Quests with progress text,
  with items to hand in, or ready to turn in open as before. No DB change.
  - The first version (ea1cfed) only guarded `Player::SendPreparedQuest`; Four's retest showed the
    window still stayed open, so the check moved into the function every route uses.
- **Found** (Four's retest of the second version, 2026-11-09): the window now stays on the Sharing
  the Land details page after Accept (quest accepted, window open). With `Logger.network=2,Server`
  the log showed, right after `CMSG_QUESTGIVER_CHOOSE_REWARD` for 24215,
  `CMSG_QUESTGIVER_HELLO 0000000000000000`: the client asked for a quest giver with an empty GUID.
- **Cause:** Rite of the Winds (24215) has `QUEST_FLAGS_AUTOCOMPLETE` (0x10000).
  `HandleQuestgiverChooseRewardOpcode` (`QuestHandler.cpp`) only looks up the NPC for quests without
  that flag; for auto-complete quests it uses the player as quest giver even when the quest is
  handed in at the NPC. `Player::SendQuestReward` then gets no creature, so
  `SMSG_QUEST_GIVER_QUEST_COMPLETE` names no NPC and the client drops its conversation with Ahmo.
  The window it opens next is no longer tied to him, so the server's close after Accept
  (`SMSG_GOSSIP_COMPLETE`) doesn't close it.
- **Changed:** new `tools/bfa/quest-autocomplete-turnin.patch` (after `quest-empty-progress.patch`),
  `HandleQuestgiverChooseRewardOpcode` only: for an auto-complete quest, when the packet names an
  NPC or object (not the player) that ends the quest (`hasInvolvedQuest`) and is in interaction
  range (`CanInteractWithQuestGiver`), use it as the quest giver. Turn-ins from the quest log
  pop-up (no NPC) work as before.
- **Found** (Four's retest with both patches, 2026-11-09): still stuck on the details page. The
  log now showed a clean conversation (`HELLO` Ahmo, `QUEST_LIST_MESSAGE`, `QUERY_QUEST 14438`,
  `QUEST_DETAILS`, `ACCEPT_QUEST`). Four then tested: a fresh conversation with Ahmo sticks, Morin
  Cloudstalker (24459) from the same list sticks, Tonga Runetotem's two-quest list sticks, and it
  sticks with no addons. Swoop Hunting (761) at Harken Windtotem, who offers a single quest, closes.
- **Cause:** after Rite of the Winds Ahmo offers two quests, Sharing the Land (14438) and Morin
  Cloudstalker (24459), so their details page is opened from his quest list
  (`SMSG_QUEST_GIVER_QUEST_LIST_MESSAGE`). Harken's single quest opens directly. After Accept from a
  list the client goes back to that list and does not close on the plain `SMSG_GOSSIP_COMPLETE` that
  `HandleQuestgiverAcceptQuestOpcode` sends (that code matches TrinityCore 8.3.7). Every NPC with a
  quest list was affected, not only Ahmo.
- **Changed:** new `tools/bfa/quest-list-accept.patch` (after `quest-autocomplete-turnin.patch`),
  `GossipDef.h`, `GossipDef.cpp`, `Player.cpp`, `QuestHandler.cpp`:
  - `PlayerMenu` remembers the NPC or object whose quest list it last sent (`_questListGiver`, set in
    `SendQuestGiverQuestListMessage`). It is cleared by `SendCloseGossip`, `SendGossipMenu` and at
    the start of `Player::SendPreparedQuest`, so a single-quest NPC or a gossip menu never counts.
  - `HandleQuestgiverAcceptQuestOpcode`: after a successful accept from that NPC or object, rebuild
    its quest menu (`PrepareQuestMenu`) and send the updated list (the accepted quest now shows
    under Current Quests). Only when the menu is empty does it close the window as before.
  - Accepts from a single-quest NPC, an item, a shared quest or a gossip menu close as before.
  - No DB change. Compiles against upstream 2c13546 with the full chain.
- **Status:** confirmed in game by Four on 2026-11-10: accepting from a quest list now returns to the NPC's updated list and Goodbye closes it. This covers all three patches in this entry.
- **Pick up:** `quest-empty-progress.patch` and `quest-autocomplete-turnin.patch` stay applied; this
  only adds `quest-list-accept.patch`. It touches `GossipDef.h`, so the build is longer:

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-list-accept.patch | git apply && echo "quest list accept applied"
  grep -c "_questListGiver" src/server/game/Entities/Creature/GossipDef.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  The echo line prints and the grep prints 3. Then restart worldserver.

  Earlier pick-up for `quest-autocomplete-turnin.patch`: if you already applied the second version of `quest-empty-progress.patch` (be0404e),
  it is unchanged; this only adds `quest-autocomplete-turnin.patch` (`QuestHandler.cpp`, short build):

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-autocomplete-turnin.patch | git apply && echo "autocomplete turn-in applied"
  grep -c "zrbfacore: an auto-complete quest" src/server/game/Handlers/QuestHandler.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  The echo line prints and the grep prints 1. Then restart worldserver.

  From the first version (ea1cfed, `Player.cpp`) instead: run
  `git -C ../tools-repo show ea1cfed:tools/bfa/quest-empty-progress.patch | git apply -R` first, then
  `git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-empty-progress.patch | git apply`, then the
  block above.

## 2026-11-09 (Quest fixes: quest window hangs or rushes after a turn-in)

Merged to `main` with PR #51 on 2026-11-09.

### Core: quest window stays open without a Complete button, or auto-accepts the next quest

- **Found** (Four, 2026-11-09): sometimes after clicking Complete Quest the rewards arrive but the
  quest window stays open with no button left, so it has to be closed with the X. Latest case: the
  Tauren Paladin quest Consecrated Note (27015) turned in to Sunwalker Helaku (37737). Also,
  sometimes turning in a quest immediately accepts the next quest in the chain and closes the window
  before its text can be read (no auto-accept addons).
- **Cause:** `Player::SendQuestReward` (`Player.cpp`) filled `SMSG_QUEST_GIVER_QUEST_COMPLETE` with
  `LaunchGossip = true` for every NPC with the gossip flag, `LaunchQuest = true` for every other quest
  giver, and `UseQuestReward` only for non-gossip, non-questgiver NPCs. With `LaunchGossip` the client
  keeps the quest window waiting for a gossip menu; with `LaunchQuest` it reopens the NPC's quest list
  and can select the next quest by itself. Stock TrinityCore 8.3.7 has the same code; TrinityCore
  fixed it later in e746cb2f ("Only launch gossip menu on quest completion when quest has
  QUEST_FLAGS_LAUNCH_GOSSIP_COMPLETE flag") and 0c7967d4 ("set LaunchQuest bit ... only when
  UseQuestReward is not set", which caused auto-accept chain quests to double-select a quest menu
  entry and other UI bugs).
- **Changed:** new `tools/bfa/quest-complete-window.patch` (after `mulgore-bristleback-fight.patch`),
  `Player::SendQuestReward` only:
  - `LaunchGossip`: gossip NPC **and** quest flag `QUEST_FLAGS_LAUNCH_GOSSIP_COMPLETE` (0x01000000).
  - `UseQuestReward`: quest is not `QUEST_FLAGS_AUTOCOMPLETE`, the NPC has a next quest in the chain
    (`GetNextQuest`) and `CanTakeQuest` says you can take it.
  - `LaunchQuest`: quest giver, `UseQuestReward` not set, and the NPC's quest dialog status
    (`GetQuestDialogStatus`) is something other than none / unavailable.
  - The next chain quest is still offered by the server as before (`HandleQuestgiverChooseRewardOpcode`
    unchanged). No DB change.
- **Status:** confirmed in game by Four on 2026-11-09 ("flawless": turn-ins close the window and
  chain quests open on their own page).
- **Pick up:** this only adds a new patch; the patches you already applied are unchanged.
  `Player.cpp` changes, so the build is short.

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-complete-window.patch | git apply && echo "quest complete window applied"
  grep -c QUEST_FLAGS_LAUNCH_GOSSIP_COMPLETE src/server/game/Entities/Player/Player.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  The echo line prints and the grep prints 1. Then restart worldserver.

## 2026-11-09 (Quest fixes: scout objectives never tick)

Merged to `main` with PR #49 on 2026-11-09.

### Core: area trigger ("scout") objectives never show as done in the quest log

- **Found** (Four, 2026-11-09): The Fargodeep Mine (quest 62, "Scout through the Fargodeep Mine")
  never counted, however often the mine was run. `.debug areatriggers` showed the server accepting
  both of its triggers (197 at the entrance, 88 in the lower cavern), and Marshal Dughan accepted
  the turn-in, but the quest tracker never changed. Reproduced on a second character.
- **Cause:** the server did credit it. `areatrigger_involvedrelation` (88, 197 -> 62), the
  SmartTrigger row on 197 and objective 252033 (type 10 area trigger, StorageIndex 0) are all
  correct, and `Player::AreaExploredOrEventHappens` stores the objective and completes the quest.
  But for objectives that are a flag rather than a count (`QuestObjective::IsStoringFlag`: area
  trigger, win pet battle against NPC, defeat battle pet, criteria tree) the core told the client by
  setting bit `256 << StorageIndex` in `QuestLog::StateFlags`, the Legion layout. The 8.3.7 client
  reads those from the quest log's `ObjectiveFlags` field (`1 << StorageIndex`), which the core
  names `Field_10` and never wrote. Stock TrinityCore 8.3.7 has the same bug; TrinityCore 9.0.5
  names the field `ObjectiveFlags` and writes it this way.
- **Changed:** new `tools/bfa/quest-objective-flags.patch` (after `gathering-tier-locks.patch`),
  `Player.cpp` / `Player.h`:
  - New `Player::SetQuestSlotObjectiveFlag` / `RemoveQuestSlotObjectiveFlag` set or clear
    `1 << StorageIndex` in `QuestLog::Field_10`.
  - `Player::SetQuestObjectiveData` (live credit) and `Player::_LoadQuestStatusObjectives` (login)
    use them instead of `SetQuestSlotState(256 << index)` / `RemoveQuestSlotState(256 << index)`.
  - `Player::SetQuestSlot` clears `Field_10` when a quest goes into a log slot, so a new quest
    doesn't inherit the previous quest's ticks.
  - No DB change. Affects every area trigger, pet battle and criteria objective, not just Fargodeep.
- **Status:** confirmed in game by Four on 2026-11-09 (The Jasperlode Mine, quest 76: the objective
  ticks on entering the mine and the quest shows ready for turn-in). The other objective types are
  covered by the same code path but were not tested one by one.
- **Affected quests:** every quest with at least one objective of type 10 (area trigger), 11 (win a
  pet battle against a tamer), 12 (defeat a battle pet) or 14 (criteria tree): **975 quests** in the
  world dump after upstream's `sql/updates` (61 area trigger, 148 tamer, 78 defeat battle pet, 688
  criteria; a few have more than one). Before this patch none of those objectives ever ticked in the
  quest log, though the server counted them. Grouped by the quest's zone or category
  (`QuestSortID`), with the quest ID; no tag means area trigger:

  <details><summary>All 975 quests</summary>

  - **Acherus: The Ebon Hold**: Investigate the Broken Shore (46031, criteria)
  - **Alchemy**: Get Your Mix On (39325, criteria), Halls of Valor: The Prime Ingredient (39348, criteria), Black Rook Hold: Heavy, But Helpful (39349, criteria), Maw of Souls: A Hope in Helheim (39350, criteria)
  - **Alliance War Campaign**: Heart of Darkness (51088, criteria), Fragment of the Firelands (51359, criteria), War of Shadows (51715, criteria), Return to Boralus (51967, criteria), Return to Boralus (51968, criteria), Return to Boralus (51969, criteria), Overseas Assassination (52026, criteria), Crippling the Horde (52147, criteria), Adapting Our Tactics (53583, criteria), Spy Versus Spy (55171, criteria)
  - **Allied Races**: A Choice of Allies (50242, criteria), A Second Ally For the Cause (50248, criteria), A Second Ally For the Cause (50254, criteria)
  - **Antoran Wastes**: Securing a Foothold (48200, criteria), Hindering the Legion War Machine (48448, criteria), Take the Edge Off (48600, criteria), Felfire Shattering (48601, criteria), Watcher (49053, defeat battle pet), (no title) (49054, defeat battle pet), Earseeker (49055, defeat battle pet), Pilfer (49056, defeat battle pet), Minixis (49057, defeat battle pet), One-of-Many (49058, defeat battle pet)
  - **Antorus, the Burning Throne**: Antoran High Command (48288, criteria), The Soulhunter (48292, criteria), The Burning Coven (48293, criteria), The Unmaker (48294, criteria), Antoran High Command (48295, criteria), The Soulhunter (48296, criteria), The Burning Coven (48297, criteria), The Unmaker (48298, criteria), Antoran High Command (48299, criteria), The Soulhunter (48300, criteria), The Burning Coven (48301, criteria), The Unmaker (48302, criteria), Antoran High Command (48303, criteria), The Soulhunter (48304, criteria), The Burning Coven (48305, criteria), The Unmaker (48306, criteria), Antorus, the Burning Throne: The Death of a Titan (49015, criteria)
  - **Archaeology**: Process of Elimination (41159, criteria), Fit for an Elven Queen (41175, criteria), Surveying Student (41187, criteria)
  - **Artifact**: The Forge of Odyn (39192, criteria), Forging New Strength (39722, criteria), A Ring Unbroken (39746, criteria), Advanced Runecarving (39761, criteria), The Voice of Thunder (39771, criteria), The Hammer in the Deep (40224, criteria), An Unexpected Message (40267, criteria), The Maelstrom Beckons (40276, criteria), Maw of Souls: Retrieving the Svalnguard (40613, criteria), The Seed of Ages (40651, criteria), Eye of Azshara: The Heart of Zin-Azshari (40668, criteria), Neltharion's Lair: Presentation is Key (40672, criteria), The Arcway: Rite of the Captain (40675, criteria), Purity of Form (40698, criteria), Power Overwhelming (40821, criteria), Injection of Power (40995, criteria), Empowering Your Artifact (41017, criteria), Return to Mardum (41033, criteria), Cursed Forge of the Nathrezim (41064, criteria), Unlocked Potential (41125, criteria), Return to Mardum (41221, criteria), Stolen Thunder (41574, criteria), Ritual Reagents (42128, criteria), Memories of Ebonchill (42429, criteria), Finishing the Job (42501, criteria), No Sanctuary (42502, criteria), The Unseen Blade (42504, criteria), The Unseen Blade (42627, criteria), Seeking Guidance (42770, criteria), Eternal Vigil (42869, criteria), The Power Within (43501, criteria), The Power Within (43505, criteria), Darkheart Thicket: Fallen Power (43517, criteria), Court of Stars: Literary Perfection (43524, criteria), Vault of the Wardens: Borrowing Without Asking (43525, criteria), Saving the Guard (43527, criteria), Balance of Power (43533, criteria), (no title) (43937, criteria), Focusing Our Efforts (43938, criteria), Greater Power for Greater Threats (46744, criteria), The Netherlight Crucible (49224, criteria)
  - **Ashran**: Survey Ashran (36127, criteria), Survey Ashran (36226, criteria), Ashran Dominance (38923, criteria), Continue the Domination (38924, criteria), Ashran Dominance (38925, criteria), Continue the Domination (38926, criteria), Ashran Dominance (39520, criteria), Continue the Domination (39521, criteria), Ashran Dominance (39522, criteria), Continue the Domination (39523, criteria), An Island of War (45180, criteria), Volrath Must Die (56338, criteria), Tremblade Must Die (56339, criteria)
  - **Azshara**: Stone Cold (14165), Wasn't It Obvious? (14389), Profitability Scouting (24452)
  - **Azsuna**: Investigation at Mak'rana (42021, criteria), Size Doesn't Matter (42063, defeat battle pet), Dazed and Confused and Adorable (42146, pet battle (tamer)), The Wine's Gone Bad (42148, defeat battle pet), Help a Whelp (42154, pet battle (tamer)), Training with the Nightwatchers (42159, pet battle (tamer)), Azsuna Specimens (42165, defeat battle pet), Court of Farondis (42420, criteria), Children of Nar'thalas (42692, criteria)
  - **Battle of Dazar'alor**: Battle of Dazar'alor (54282, criteria)
  - **Battle Pets**: Julia, The Pet Tamer (31316, pet battle (tamer)), Julia Stevens (31693, pet battle (tamer)), Old MacDonald (31724, pet battle (tamer)), Lindsay (31725, pet battle (tamer)), Eric Davidson (31726, pet battle (tamer)), Bill Buckler (31728, pet battle (tamer)), Steven Lisbane (31729, pet battle (tamer)), Old MacDonald (31780, pet battle (tamer)), Lindsay (31781, pet battle (tamer)), Zunta, The Pet Tamer (31812, pet battle (tamer)), Dagra the Fierce (31813, pet battle (tamer)), Analynn (31814, pet battle (tamer)), Zonya the Sadist (31815, pet battle (tamer)), Merda Stronghoof (31817, pet battle (tamer)), Zunta (31818, pet battle (tamer)), Dagra the Fierce (31819, pet battle (tamer)), Eric Davidson (31850, pet battle (tamer)), Bill Buckler (31851, pet battle (tamer)), Steven Lisbane (31852, pet battle (tamer)), Analynn (31854, pet battle (tamer)), Zonya the Sadist (31862, pet battle (tamer)), Cassandra Kaboom (31870, pet battle (tamer)), Traitor Gluk (31871, pet battle (tamer)), Merda Stronghoof (31872, pet battle (tamer)), Pet Battle Trainers: Kalimdor (31887, pet battle (tamer)), Battle Pet Tamers: Kalimdor (31889, pet battle (tamer)), Battle Pet Tamers: Kalimdor (31891, pet battle (tamer)), Battle Pet Trainers: Kalimdor (31892, pet battle (tamer)), Grand Master Trixxy (31897, pet battle (tamer)), Battle Pet Tamers: Eastern Kingdoms (31902, pet battle (tamer)), Battle Pet Tamers: Eastern Kingdoms (31903, pet battle (tamer)), Cassandra Kaboom (31904, pet battle (tamer)), Grazzle the Great (31905, pet battle (tamer)), Kela Grimtotem (31906, pet battle (tamer)), Zoltan (31907, pet battle (tamer)), Elena Flutterfly (31908, pet battle (tamer)), Grand Master Trixxy (31909, pet battle (tamer)), David Kosse (31910, pet battle (tamer)), Deiza Plaguehorn (31911, pet battle (tamer)), Kortas Darkhammer (31912, pet battle (tamer)), Everessa (31913, pet battle (tamer)), Durin Darkhammer (31914, pet battle (tamer)), Grand Master Lydia Accoste (31915, pet battle (tamer)), Grand Master Lydia Accoste (31916, pet battle (tamer)), Battle Pet Tamers: Outland (31919, pet battle (tamer)), Grand Master Antari (31920, pet battle (tamer)), Battle Pet Tamers: Outland (31921, pet battle (tamer)), Nicki Tinytech (31922, pet battle (tamer)), Ras'an (31923, pet battle (tamer)), Narrok (31924, pet battle (tamer)), Morulu The Elder (31925, pet battle (tamer)), Grand Master Antari (31926, pet battle (tamer)), Battle Pet Tamers: Northrend (31927, pet battle (tamer)), Grand Master Payne (31928, pet battle (tamer)), Battle Pet Tamers: Northrend (31929, pet battle (tamer)), Battle Pet Tamers: Pandaria (31930, pet battle (tamer)), Beegle Blastfuse (31931, pet battle (tamer)), Nearly Headless Jacob (31932, pet battle (tamer)), Okrut Dragonwaste (31933, pet battle (tamer)), Gutretch (31934, pet battle (tamer)), Grand Master Payne (31935, pet battle (tamer)), Battle Pet Trainers: Pandaria (31940, pet battle (tamer)), Grand Master Aki (31951, pet battle (tamer)), Battle Pet Tamers: Pandaria (31952, pet battle (tamer)), Grand Master Hyuna (31953, pet battle (tamer)), Grand Master Mo'ruk (31954, pet battle (tamer)), Grand Master Nishi (31955, pet battle (tamer)), Grand Master Yon (31956, pet battle (tamer)), Grand Master Shu (31957, pet battle (tamer)), Grand Master Aki (31958, pet battle (tamer)), Battle Pet Tamers: Cataclysm (31966, pet battle (tamer)), Battle Pet Tamers: Cataclysm (31967, pet battle (tamer)), Grand Master Obalis (31970, pet battle (tamer)), Grand Master Obalis (31971, pet battle (tamer)), Brok (31972, pet battle (tamer)), Bordin Steadyfist (31973, pet battle (tamer)), Goz Banefury (31974, pet battle (tamer)), Grand Master Zusshi (31991, pet battle (tamer)), Darkmoon Pet Battle! (32175, pet battle (tamer)), Pandaren Spirit Tamer (32428, pet battle (tamer)), Burning Pandaren Spirit (32434, pet battle (tamer)), Flowing Pandaren Spirit (32439, pet battle (tamer)), Whispering Pandaren Spirit (32440, pet battle (tamer)), Thundering Pandaren Spirit (32441, pet battle (tamer)), Beasts of Fable (32603, defeat battle pet), Beasts of Fable Book I (32604, defeat battle pet), Beasts of Fable Book II (32868, defeat battle pet), Beasts of Fable Book III (32869, defeat battle pet), Little Tommy Newcomer (33222, pet battle (tamer)), A New Darkmoon Challenger! (36471, pet battle (tamer)), Unruly Visitors (36570, pet battle (tamer)), Cymre Brightblade (37201, pet battle (tamer)), Ashlei (37203, pet battle (tamer)), Gargra (37205, pet battle (tamer)), Tarr the Terrible (37206, pet battle (tamer)), Vesharr (37207, pet battle (tamer)), Taralune (37208, pet battle (tamer)), Critters of Draenor (38299, criteria), Critters of Draenor (38300, criteria), Critters of Draenor (39058, criteria), Shipwrecked Captive (40310, pet battle (tamer)), Battle Pet Tamers: Warlords (40329, criteria), A Celestial Invitation (44767, pet battle (tamer)), Raising Your Snowfeather (44948, criteria), Hunting Lesson: Northern Hawk Owls (44950, criteria), Allies in Highmountain (44953, criteria), Snowfeather Team Up (44954, criteria), Deadly Prey (44956, criteria), Hunting Lesson: Spiketail Beaver (44957, criteria), The Unfriendly Faction (44958, criteria), Hunting Lesson: Mudshell Conch (44960, criteria), Teamwork Lesson: Naraxas (44961, criteria), Hunting Lesson: Coralback Fiddler (44962, criteria), Teamwork Lesson: Ursoc (44967, criteria), Snowfeather Team Rumble (44968, criteria), Raising Your Direbeak (44973, criteria), Hunting Lesson: Rose Taipan (44976, criteria), Allies in Stormheim (44977, criteria), Direbeak Team Up (44978, criteria), Dire Prey (44979, criteria), Hunting Lesson: Tiny Apparition (44980, criteria), The Unkindly Faction (44981, criteria), Hunting Lesson: Golden Eaglet (44983, criteria), Teamwork Lesson: Fenryr (44984, criteria), Hunting Lesson: Stormstruck Beaver (44985, criteria), Teamwork Lesson: Krosus (44986, criteria), Direbeak Team Rumble (44987, criteria), Raising Your Sharptalon (44989, criteria), Raising Your Bloodgazer (44990, criteria), Hunting Lesson: Spring Strider (44995, criteria), Hunting Lesson: Erudite Manafiend (44996, criteria), Allies in Val'sharah (44997, criteria), Allies in Azsuna (44998, criteria), Sharptalon Team Up (44999, criteria), Bloodgazer Team Up (45000, criteria), Destructive Prey (45001, criteria), Dangerous Prey (45002, criteria), Hunting Lesson: Terror Larva (45003, criteria), Hunting Lesson: Fledgling Kingfeather (45004, criteria), The Uncongenial Faction (45005, criteria), The Unfavorable Faction (45006, criteria), Hunting Lesson: Auburn Ringtail (45009, criteria), Hunting Lesson: Juvenile Scuttleback (45010, criteria), Teamwork Lesson: Dresaron (45011, criteria), Teamwork Lesson: Serpentrix (45012, criteria), Hunting Lesson: Vale Flitter (45013, criteria), Hunting Lesson: Felspider (45014, criteria), Teamwork Lesson: Xavius (45015, criteria), Teamwork Lesson: Skorpyron (45016, criteria), Sharptalon Team Rumble (45017, criteria), Bloodgazer Team Rumble (45018, criteria), Crysa's Flyers (45083, pet battle (tamer)), Wailing Critters (45423, defeat battle pet), Pet Battle Challenge: Wailing Caverns (45539, defeat battle pet), The Deadmines Strike Back (46291, defeat battle pet), Pet Battle Challenge: Deadmines (46292, defeat battle pet), Bert's Bots (47895, pet battle (tamer)), Gnomeregan's New Guardians (54185, defeat battle pet), Pet Battle Challenge: Gnomeregan (54186, defeat battle pet), Tiny Terrors of Stratholme (56491, defeat battle pet), Pet Battle Challenge: Stratholme (56492, defeat battle pet), Shadows of Blackrock (58457, pet battle (tamer)), Pet Battle Challenge: Blackrock Depths (58458, pet battle (tamer))
  - **Battlegrounds**: To Battle! (45172, criteria), Desperate Times (45173, criteria), Win the Crowd (45179, criteria), Something Different (47148, criteria), Storming the Battlefields (56499, criteria), Storming the Battlefields (56500, criteria)
  - **Black Empire Campaign**: Ny'alotha, the Waking City: The Corruptor's End (58632, criteria)
  - **Black Rook Hold**: Black Rook Hold: The Lord of Black Rook Hold (43545, criteria), Black Rook Hold: The Sorrow (43642, criteria), Black Rook Hold: The Lord of Black Rook Hold (44276, criteria), Black Rook Hold: The Lord of Black Rook Hold (44277, criteria)
  - **Black Temple**: Disturbance Detected: Black Temple (47523, criteria)
  - **Blackrock Caverns**: This Can Only Mean One Thing... (28732)
  - **Blacksmithing**: You Are Not Worthy (38514, criteria)
  - **Blade's Edge Mountains**: Doug Test - Completable Quest4 (50384, criteria)
  - **Blasted Lands**: A Closer Look (25715)
  - **Bloodmyst Isle**: I Shoot Magic Into the Darkness (9700)
  - **Borean Tundra**: The Plains of Nasam (11652), What Are They Up To? (11890)
  - **Brawler's Guild**: Everyone Loves a Good Fight (45111, criteria), Murder at the Brawl'gar Arena (53914, criteria), Murder at the Brawlpub (55002, criteria)
  - **Broken Shore**: How Do YOU Like It?! (45541, criteria), Illidari Masters: Sissix (46111, pet battle (tamer)), Illidari Masters: Madam Viciosa (46112, pet battle (tamer)), Illidari Masters: Nameless Mystic (46113, pet battle (tamer)), Armies of Legionfall (48641, criteria)
  - **Cathedral of Eternal Night**: Cathedral of Eternal Night: Altar of the Aegis (46244, criteria)
  - **Chamber of Heart**: Infusing the Heart (52428, criteria)
  - **Cooking**: A Good Recipe List (40990, criteria), Opening the Test Kitchen (40991, criteria)
  - **Court of Stars**: Court of Stars: Wraith in the Machine (42764, criteria), Court of Stars: Bring Me the Eyes (42769, criteria), Court of Stars: Disarming the Watch (42781, criteria), Court of Stars: They Bloom at Night (42783, criteria), Court of Stars: The Deceitful Student (42784, criteria), Court of Stars: Beware the Fury of a Patient Elf (43314, criteria), Court of Stars: Into the Court of Stars (43550, criteria), Court of Stars: Into the Court of Stars (44274, criteria), Court of Stars: Into the Court of Stars (44275, criteria)
  - **Crucible of Storms**: Orders from Azshara (54265, criteria), Orders from Azshara (54433, criteria), Crucible of Storms: Relics of Shadow (54438, criteria), Crucible of Storms: Relics of Shadow (54439, criteria)
  - **Dalaran**: Fight Night: Tiffany Nelson (40277, pet battle (tamer)), Fight Night: Sir Galveston (40298, pet battle (tamer)), Fight Night: Bodhi Sunwayver (40299, pet battle (tamer)), Battle: Pandaren Cuisine - Sungshin Ironpaw (41405, criteria), Battle: Pandaren Cuisine - Torg Slowflame (41406, criteria), Battle: Pandaren Cuisine - Elling Trias (41408, criteria), Fight Night: Heliosus (41881, defeat battle pet), Fight Night: Rats! (41886, defeat battle pet), Fight Night: Stitches Jr. Jr. (42062, defeat battle pet), The Wardens (42422, criteria), Fight Night: Amalia (42442, pet battle (tamer)), The Kirin Tor of Dalaran (43179, criteria), Bringer of the Light (44004, criteria), Edict of the God-King (45422, criteria)
  - **Dark Iron Dwarf**: Blackrock Depths (51813, criteria), Molten Core (53342, criteria), Firelands (53352, criteria), Stranger in a Strange Land (53500, criteria)
  - **Darkheart Thicket**: Darkheart Thicket: Into Darkheart Thicket (43551, criteria), Darkheart Thicket: Into Darkheart Thicket (44272, criteria), Darkheart Thicket: Into Darkheart Thicket (44273, criteria)
  - **Darkshore**: A Lost Companion (13564), Consumed (13881)
  - **Death Knight Campaign**: Rise, Champions (43264, criteria), Troops in the Field (43267, criteria), Tech It Up A Notch (43268, criteria), Salanar the Horseman (43539, criteria), Advancing the War Effort (43573, criteria), Steeds of the Damned (43899, criteria), Aggregates of Anguish (43928, criteria)
  - **Deepholm**: Deathwing's Fall (26258), Silvermarsh Rendezvous (27007)
  - **Demon Hunter Campaign**: Into Our Ranks (39741, criteria), Last, But Not Least (42132, criteria), Into Our Ranks (42665, criteria), Preparations for Invasion (42669, criteria), Rise, Champions (42670, criteria), Rise, Champions (42671, criteria), Things Gaardoun Needs (42677, criteria), Loramus, Is That You? (42681, criteria), Additional Accoutrements (42682, criteria), Demonic Improvements (42683, criteria), Working With the Wardens (42731, criteria), Rune Ruination (42736, criteria), Two Worthies (42776, criteria), Back in Black (42801, criteria), Securing Mardum (42802, criteria), Things Gaardoun Needs (44161, criteria), One Battle at a Time (44694, criteria), Defense of the Fel Hammer (45339, criteria), Investigate the Broken Shore (45994, criteria)
  - **Dragonblight**: Conversing With the Depths (12032), From the Depths of Azjol-Nerub (12036), The Best of Intentions (12263)
  - **Dreadscar Rift**: Investigate the Broken Shore (45990, criteria)
  - **Druid Campaign**: Sampling the Nightmare (42032, criteria), Gathering the Dreamweavers (42037, criteria), Rise, Champions (42583, criteria), A Glade Defense (42586, criteria), Branching Out (42588, criteria), Defending the Isles (43403, criteria)
  - **Drustvar**: Stick It To 'Em! (50533, criteria), Order of Embers (50600, criteria), Crab People (52009, pet battle (tamer)), Night Horrors (52218, pet battle (tamer)), Rogue Azerite (52278, pet battle (tamer)), What's the Buzz? (52297, pet battle (tamer))
  - **Dungeon**: Temple of Sethraliss: Avatar of the Loa (50551, criteria), Shrine of the Storm: Whispers Below (50825, criteria), Siege of Boralus: Lady Ashvane's Return (52153, criteria)
  - **Elwynn Forest**: The Fargodeep Mine (62), The Jasperlode Mine (76)
  - **Enchanting**: The Beat Goes On (54000, criteria), We're Going In (54001, criteria)
  - **Engineering**: Modular Modifications (40864, criteria), Court of Stars: Revamping the Recoil (40882, criteria)
  - **Eredath**: The Path Forward (46941, criteria), The Ruins of Oronaar (48445, criteria), Relics of the Ancient Eredar (48446, criteria), Shadowguard Dispersion (48447, criteria), Argussian Reach (48642, criteria), Bucky (49047, defeat battle pet), Snozz (49048, defeat battle pet), Gloamwing (49049, defeat battle pet), Shadeflicker (49050, defeat battle pet), Corrupted Blood of Argus (49051, defeat battle pet), Mar'cuus (49052, defeat battle pet)
  - **Eye of Azshara**: Eye of Azshara: Into the Eye of Azshara (43552, criteria), Eye of Azshara: Into the Eye of Azshara (44270, criteria), Eye of Azshara: Into the Eye of Azshara (44271, criteria)
  - **Felwood**: Rejoining the Forest (28228)
  - **Firelands**: Disturbance Detected: Firelands (57637, criteria)
  - **Frostfire Ridge**: Gormaul Tower (33784, criteria), Turning Timber into Profit (36138, criteria), Breaking into the Trap Game (36345, criteria), Warlord of Draenor (36874, criteria), Nemesis: Hunter - Hunted (36889, criteria), The Headhunter's Harvest (37046, criteria), The Headhunter's Harvest (37119, criteria), Treasure Contract: The Thunderlord Sage (37914), Shipbuilding (39241, criteria), Ship Shape (39242, criteria), Naval Commander (39243, criteria), Upgrading The Fleet (39245, criteria), Naval Domination (39246, criteria), Destroying the Competition (39401, criteria), I Sunk Your Battleship (39604, criteria), If At First You Fail, Try Again! (39674, criteria), A True Naval Commander (39676, criteria)
  - **Garrison Support**: Build Your Barracks (34461, criteria), Build Your Barracks (34587, criteria), Professional Processing (34670, criteria), Delegating on Draenor (34692, criteria), [Deprecated] Profession Quest (34693, criteria), Mission Probable (34775, criteria), What We Got (34824, criteria), Building for Professions (36100, criteria), Pets Versus Pests (36423, defeat battle pet), Pets Versus Pests (36469, defeat battle pet), Bigger is Better (36567, criteria), Bigger is Better (36592, criteria), My Very Own Fortress (36614, criteria), My Very Own Castle (36615, criteria), Your Second Alchemy Work Order (36838, criteria), Your Second Enchanting Work Order (36839, criteria), Your Second Engineering Work Order (36840, criteria), Ogre Waygates (36848, criteria), Unconventional Inventions (37044, criteria), Unconventional Inventions (37091, criteria), Fully Armed and Operational (37418, criteria), Fully Armed and Operational (37420, criteria), Your Second Alchemy Work Order (37584, criteria), Your Second Enchanting Work Order (37589, criteria), Building for Professions (37669, criteria)
  - **Ghostlands**: Investigate An'daroth (9160), Investigate the Amani Catacombs (9193)
  - **Gorgrond**: Feeding An Army (36272, criteria), Feeding An Army (36344, criteria), Strike While the Iron is Hot (36573, criteria), Strike While the Iron is Hot (36574, criteria), Strike While the Iron is Hot (36575, criteria), Strike While the Iron is Hot (36576, criteria)
  - **Hall of the Guardian**: Investigate the Broken Shore (45998, criteria)
  - **Hallow's End**: Missing Heirlooms (29392), Missing Heirlooms (29415)
  - **Halls of Valor**: Halls of Valor: Odyn's Challenge (43509, criteria), Halls of Valor: Odyn's Challenge (44268, criteria), Halls of Valor: Odyn's Challenge (44269, criteria)
  - **Hellfire Citadel**: Hellfire Assault (39193, criteria), The Iron Bulwark (39219, criteria), Pits of Mannoroth (39221, criteria), Court of Blood (39222, criteria), Deadeye's Vision (39223, criteria), Maw of Souls (39225, criteria), Iskar's Clutch (39226, criteria), Amphitheater of the Eternal (39227, criteria), Temple of Tyranny (39228, criteria), Grommash's Torment (39229, criteria), The Felborne Breach (39230, criteria), Destructor's Rise (39231, criteria), The Black Gate (39232, criteria), Pits of Mannoroth (39250, criteria), Maw of Souls (39253, criteria), Temple of Tyranny (39256, criteria), Destructor's Rise (39259, criteria), The Black Gate (39260, criteria)
  - **Hellfire Peninsula**: The Assassin (9400)
  - **Helmouth Cliffs**: Maw of Souls: Into the Maw of Souls (43553, criteria), Maw of Souls: Into the Maw of Souls (44266, criteria), Maw of Souls: Into the Maw of Souls (44267, criteria)
  - **Heritage**: The Fall of the Sunwell (54096, criteria), Let Sleeping Wolves Lie (54984, criteria)
  - **Highmountain**: Training with Bredda (40280, pet battle (tamer)), Tiny Poacher, Tiny Animals (40282, pet battle (tamer)), Hatchlings of the Talon (41094, criteria), Rocko Needs a Shave (41624, defeat battle pet), Snail Fight! (41687, pet battle (tamer)), Wildlife Protection Force (41766, defeat battle pet), It's Illid... Wait. (42064, defeat battle pet), Highmountain Tribes (42233, criteria)
  - **Highmountain Tauren**: Stranger in a Strange Land (50319, criteria)
  - **Hillsbrad Foothills**: A Haunting in Hillsbrad (28635)
  - **Horde War Campaign**: War of Shadows (51771, criteria), Return to Zuldazar (51984, criteria), Return to Zuldazar (51985, criteria), Return to Zuldazar (51986, criteria), With Prince in Tow (52978, criteria), Adapting Our Tactics (53602, criteria), The Hunt Never Ends (53912), Under False Colors (54999, criteria)
  - **Hunter Campaign**: Scouting Reports (42384, criteria), Requesting Reinforcements (42402, criteria), Rise, Champions (42519, criteria), Making Contact (42523, criteria), Troops in the Field (42525, criteria), Tech It Up A Notch (42526, criteria), Survival Skills (43335, criteria), Leading by Example (44680, criteria), Taking Control (45554, criteria), Investigate the Broken Shore (46023, criteria)
  - **Inscription**: By the Book (49874, criteria), Temple of Sethraliss: Booking on a Favor (49877, criteria), Penning In Protection (49878, criteria)
  - **Invasion Point**: Invasion Point Offensive (48513, criteria), Commander's Downfall (48605, criteria), Invasion Onslaught (49293, criteria)
  - **Jewelcrafting**: A Colorful Key (48075, criteria), The Missing Chapter (49584, criteria), The Missing Chapter (49599, criteria)
  - **Karazhan**: Return to Karazhan: In the Eye of the Beholder (44735, criteria), Return to Karazhan: The Tower of Power (44917, criteria)
  - **Krokuun**: Rendezvous (46816, criteria), Storming the Citadel (47892, criteria), Remnants of Darkfall Ridge (48441, criteria), Nath'raxas Hold: Preparations (48442, criteria), Nath'raxas Hold: Rescue Mission (48443, criteria), Where They Least Expect It (48461, criteria), Army of the Light (48639, criteria), Ruinhoof (49041, defeat battle pet), Foulclaw (49042, defeat battle pet), Baneglow (49043, defeat battle pet), Retch (49044, defeat battle pet), Deathscreech (49045, defeat battle pet), Gnasher (49046, defeat battle pet)
  - **Kul Tiran**: Allegiance of Kul Tiras (53720, criteria), Made in Kul Tiras (54706, criteria), For the Alliance (55142, criteria), Stranger in a Strange Land (55146, criteria)
  - **Leatherworking**: Stamped Stories (40191, criteria), The Audition (55216, criteria), Make Some Noise (55222, criteria), The Audition (55228, criteria), Make Some Noise (55234, criteria)
  - **Legionfall Campaign**: Begin Construction (46245, criteria), Strike Them Down (46246, criteria), Defending Broken Isles (46247, criteria), Self-Fulfilling Prophecy (46248, criteria), Championing Our Cause (46249, criteria), Take Out the Head... (46250, criteria), Intolerable Infestation (46252, criteria), Assault on Broken Shore (46734, criteria), The Deceiver's Downfall (46805, criteria), Champions of Legionfall (47137, criteria)
  - **Lightforged Draenei**: Forge of Aeons (49266, criteria), Stranger in a Strange Land (50313, criteria)
  - **Loch Modan**: Resupplying the Excavation (273), Resupplying the Excavation (13639)
  - **Mag'har Orc**: Tyranny of the Light (52955, criteria), Stranger in a Strange Land (53502, criteria)
  - **Mage Campaign**: Growing Power (42175, criteria), Empyrean Society Report (42222, criteria), Following In His Footsteps (42424, criteria), Ancient Magic (42433, criteria), Rise, Champions (42663, criteria), Troops in the Field (42687, criteria), Tech It Up A Notch (42696, criteria), Into the Oculus (42734, criteria), When There's a Will, There's a Way (42940, criteria), The Might of the Tirisgarde (44689, criteria), Servant to No One (45630, criteria)
  - **Mechagnome**: Stranger in a Strange Land (58147, criteria)
  - **Mechagon**: Gnomefeaster (56393, defeat battle pet), Sputtertube (56394, defeat battle pet), Goldenbot XD (56395, defeat battle pet), Creakclank (56396, defeat battle pet), CK-9 Micro-Oppression Unit (56397, defeat battle pet), Unit 35 (56398, defeat battle pet), Unit 6 (56399, defeat battle pet), Unit 17 (56400, defeat battle pet), A Little Side Action (56557, criteria), A Little Side Action (56559, criteria), Call to Arms: Mechagon (56649, criteria), Call to Arms: Mechagon (56650, criteria)
  - **Monk Campaign**: Impending Danger (32442, criteria), A Peaceful World (41086, criteria), Report from Tian Monastery (41905, criteria), Tracking the Tideskorn (41909, criteria), Freya's Spring (41910, criteria), Amaranthine Hops (41911, criteria), Rise, Champions (42187, criteria), Tech It Up A Notch (42191, criteria), Scrolls of Knowledge (42210, criteria), Further Training (43062, criteria), Panic at the Brewery (45404, criteria), Investigate the Broken Shore (46025, criteria)
  - **Mount Hyjal**: Through the Dream (25325)
  - **Nagrand**: Bigger Trap, Better Rewards (36274, criteria), Bigger Trap, Better Rewards (36346, criteria)
  - **Nazjatar**: A Brief Respite (54975, criteria), Where the Road Leads (55175), The Waveblade Ankoan (56119, criteria), The Unshackled (56120, criteria), Call to Arms: Nazjatar (56148, criteria), Friends In Need (56234, criteria), Down Into Nazjatar (56235, criteria), Down But Not Out (56236, criteria), Prince Wiggletail (56381, defeat battle pet), Chomp (56382, defeat battle pet), Silence (56383, defeat battle pet), Shadowspike Lurker (56384, defeat battle pet), Pearlhusk Crawler (56385, defeat battle pet), Elderspawn of Nalaada (56386, defeat battle pet), Ravenous Scalespawn (56387, defeat battle pet), Mindshackle (56388, defeat battle pet), Kelpstone (56389, defeat battle pet), Voltgorger (56390, defeat battle pet), Frenzied Knifefang (56391, defeat battle pet), Giant Opaline Conch (56392, defeat battle pet), Call to Arms: Nazjatar (56648, criteria), Create Your Own Strength (57003, criteria), Create Your Own Strength (57004, criteria), Becoming a Friend (57005, criteria), A Worthy Ally (57006, criteria), Legacy of the Mad Mage (57086, criteria)
  - **Nazmir**: Talanji's Expedition (50602, criteria), Marshdwellers (52754, pet battle (tamer)), Crawg in the Bog (52779, defeat battle pet), Pack Leader (52799, pet battle (tamer)), Accidental Dread (52803, pet battle (tamer))
  - **Neltharion's Lair**: Neltharion's Lair: Into Neltharion's Lair (43554, criteria), Neltharion's Lair: Into Neltharion's Lair (44264, criteria), Neltharion's Lair: Into Neltharion's Lair (44265, criteria)
  - **Netherlight Temple**: Investigate the Broken Shore (46029, criteria)
  - **Netherstorm**: Triangulation Point One (10269), Triangulation Point Two (10275)
  - **Nightborne**: Remember the Sunwell (49354, criteria), Stranger in a Strange Land (50303, criteria)
  - **No zone**: Traitor Gluk (31816, pet battle (tamer)), Brutality in the Basin, Violence in the Valley (35571, criteria), Honorable Victor (35592, criteria), The Epic Eleven (35604, criteria), Test - Fireball (40502, criteria), 2v2 Weekly Quest (44891, criteria), 3v3 Weekly Quest (44908, criteria), RBG Weekly (44909, criteria), Defeat Nekthara (48237, pet battle (tamer)), Valley of Spirits (57039, criteria), Dwarven District (57153, criteria), Old Town (57216, criteria), Trade District (57271, criteria)
  - **Northern Barrens**: To Track a Thief (869), The Forgotten Pools (870), Drag it Out of Them (13961), Investigate the Wreckage (14066)
  - **Order Hall**: Goddess Watch Over You (44338, criteria), Ravencrest's Legacy (44479, criteria), Destiny Unfulfilled (44481, criteria), Destiny Unfulfilled (44496, criteria), Destiny Unfulfilled (44497, criteria)
  - **Orgrimmar**: Protect the Home Front (44092, criteria)
  - **Paladin Campaign**: The Blood Matriarch (42846, criteria), Wrath and Justice (42849, criteria), Tech It Up a Notch (42850, criteria), The Highlord's Command (42885, criteria), The Highlord's Command (42966, criteria), The Highlord's Command (42967, criteria), The Highlord's Command (42968, criteria), Defenders of the World (43699, criteria), Moonfang Family Relics (45145, criteria)
  - **Priest Campaign**: Rise, Champions (43270, criteria), Spread the Word (43273, criteria), Troops in the Field (43276, criteria), Tech It Up A Notch (43277, criteria), Relieving the Front Lines (43371, criteria), Halls of Valor: The Light Within (43377, criteria), Infiltrating Our Enemies (43385, criteria), Fortifying the Temple (43399, criteria)
  - **Prototype**: A Terrible Place (55036, criteria)
  - **Proving Grounds**: Proving Grounds (37433, criteria), Proving Grounds (37434, criteria)
  - **Redridge Mountains**: Tuning the Gnomecorder (26512)
  - **Rogue Campaign**: Rise, Champions (42139, criteria), A More Wretched Hive of Scum and Villainy (42140, criteria), Throwing SI:7 Off the Trail (42684, criteria), The Big Bad Wolfe (43014, criteria), What Winstone Suggests (43015, criteria), Where In the World is Mathias? (43469, criteria), Pruning the Garden (43470, criteria), The World is Not Enough (43479, criteria), Spy vs. Spy (43829, criteria), Convincin' Old Yancey (43841, criteria), Investigate the Broken Shore (45992, criteria)
  - **Ruins of Gilneas**: Break in Communications: Dreadwatch Outpost (27349)
  - **Sanctum of Light**: Investigate the Broken Shore (45975, criteria)
  - **Seasonal**: How Things "Really" Happened... (57298, criteria), Soldier of Time (57300, criteria)
  - **Seething Shore**: The Seething Shore (50048, criteria), The Seething Shore (50054, criteria)
  - **Shadowmoon Valley**: The Path of Conquest (10750), The Path of Conquest (10772), Keeping it Together (35176, criteria), Turning Timber into Profit (36192, criteria), Breaking into the Trap Game (36271, criteria), Warlord of Draenor (36876, criteria), Nemesis: Hunter - Hunted (36955, criteria), Shipbuilding (39054, criteria), Ship Shape (39055, criteria), Naval Commander (39056, criteria), Upgrading The Fleet (39067, criteria), Naval Domination (39068, criteria), Destroying the Competition (39404, criteria), I Sunk Your Battleship (39601, criteria), If At First You Fail, Try Again! (39655, criteria), A True Naval Commander (39665, criteria)
  - **Shaman Campaign**: Tech It Up A Notch (41740, criteria), Troops in the Field (41741, criteria), Mission: Elemental Diplomacy (42184, criteria), Mission: Investigating Deepholm (42200, criteria), Return to the Firelands (42208, criteria), Rise, Champions (42383, criteria), Enemies of Air (42986, criteria), Worldmender (42988, criteria)
  - **Silithus: The Wound**: Champions of Azeroth (50562, criteria)
  - **Skyhold**: Investigate the Broken Shore (45987, criteria)
  - **Southern Barrens**: Claim the Battle Scar (24618), Claim the Battlescar (25081)
  - **Special**: To Outland! (49816, criteria), To Northrend! (49817, criteria), To Outland! (49862, criteria), To Northrend! (49863, criteria)
  - **Stonetalon Mountains**: Field Test: Gnomecorder (25621), Ascending the Vale (25930)
  - **Stormheim**: A Grapple a Day (38312, criteria), A Grapple a Day (38612, criteria), My Beasts's Bidding (40278, pet battle (tamer)), Beasts of Burden (41935, pet battle (tamer)), Jarrun's Ladder (41944, pet battle (tamer)), All Pets Go to Heaven (41948, pet battle (tamer)), Oh, Ominitron (41958, pet battle (tamer)), All Howl, No Bite (42067, defeat battle pet), The Valarjar (42234, criteria)
  - **Stormsong Valley**: Storm's Wake (50601, criteria), This Little Piggy Has Sharp Tusks (52126, defeat battle pet), Automated Chaos (52165, pet battle (tamer)), Sea Creatures Are Weird (52316, pet battle (tamer)), Captured Evil (52325, pet battle (tamer)), Call to Arms: Stormsong Valley (52957, criteria), One of the Hive (56107, criteria), Leaving the Hive (56108, criteria), Defender of the Hive (56109, criteria), A Defender Emerges (56110, criteria), The Usurper (56111, criteria), A Royal Awakening (56112, criteria)
  - **Stormwind City**: Rallying the Fleet (26975), Peasant Problems (27044), Protect the Home Front (40661, criteria)
  - **Stratholme**: Angry Residents (56914, pet battle (tamer))
  - **Suramar**: Flummoxed (40337, pet battle (tamer)), The Master of Pets (41895, pet battle (tamer)), Clear the Catacombs (41914, pet battle (tamer)), Mana Tap (41931, pet battle (tamer)), Chopped (41990, pet battle (tamer)), Threads of Fate (42015, pet battle (tamer)), The Nightfallen (42421, criteria), The Arcway: Opening the Arcway (42490, criteria), Mrgls of Endearment (42688, criteria), Giving It All We've Got (43562, criteria), Stabilizing Suramar (45316, criteria), Fighting on All Fronts (45317, criteria)
  - **Swamp of Sorrows**: Legends of the Sunken Temple (27704)
  - **Tailoring**: The Path to Suramar City (38962, criteria), Step Into Her Shoes (53858, criteria), Saving Nine (53868, criteria), Tearing at the Seams (55177, criteria), Tearing at the Seams (55188, criteria), Seam Stress (55214, criteria)
  - **Talador**: The Battle for Shattrath (33731, criteria), The Battle for Shattrath (34099, criteria)
  - **Tanaan Jungle**: Bring the Reinforcements (39313, criteria), Bring the Reinforcements (39315, criteria)
  - **Temple of Sethraliss**: Temple of Sethraliss: Ecological Research (51377, criteria), Temple of Sethraliss: A Bazaar Menagerie (51378, criteria), Temple of Sethraliss: Navigating Currents (51379, criteria)
  - **The Arcway**: The Arcway: Into the Arcway (43555, criteria), The Arcway: Clogged Drain (43637, criteria), The Arcway: Silver Serpent (43638, criteria), The Arcway: Arcanist Down (43639, criteria), The Arcway: Into the Arcway (44262, criteria), The Arcway: Into the Arcway (44263, criteria)
  - **The Blood Furnace**: Heart of Rage (29536), Heart of Rage (29539)
  - **The Deaths of Chromie**: The Day That Chromie Dies (47543, criteria), Rewind (47545, criteria), The Many Advantages of Being a Time Dragon (47550, criteria), Sky Ablaze With Cannonfire (47772, criteria), Sky Ablaze With Cannonfire (47773, criteria)
  - **The Dreamgrove**: Investigate the Broken Shore (46027, criteria)
  - **The Eternal Palace**: The Eternal Palace: Queen's Gambit (56356, criteria), The Eternal Palace: Queen's Gambit (56358, criteria)
  - **The Exodar**: Nobundo's Last Stand (43705, criteria)
  - **The Maelstrom**: Investigate the Broken Shore (45996, criteria)
  - **The Nighthold**: The Nighthold: High Botanist Tel'arn (43910, criteria), The Nighthold: High Botanist Tel'arn (43913, criteria), The Nighthold: High Botanist Tel'arn (43916, criteria), The Nighthold: High Botanist Tel'arn (43919, criteria), The Nighthold: Lord of the Shadow Council (45417, criteria)
  - **The Seat of the Triumvirate**: Seat of the Triumvirate: The Crest of Knowledge (47654, criteria)
  - **Thousand Needles**: (no title) (45807, criteria)
  - **Tiragarde Sound**: Proudmoore Admiralty (50599, criteria), Alliance War Effort (50605, criteria), Not So Bad Down Here (52430, pet battle (tamer)), Unbreakable (52455, defeat battle pet), That's a Big Carcass (52471, pet battle (tamer)), Strange Looking Dogs (52751, pet battle (tamer))
  - **Tomb of Sargeras**: Tomb of Sargeras: The Tomb's Mistress (47114, criteria), Tomb of Sargeras: The Tomb's Mistress (47115, criteria), Tomb of Sargeras: The Tomb's Mistress (47116, criteria), Tomb of Sargeras: The Tomb's Mistress (47117, criteria), Tomb of Sargeras: Free The Tormented (47118, criteria), Tomb of Sargeras: Free The Tormented (47119, criteria), Tomb of Sargeras: Free The Tormented (47120, criteria), Tomb of Sargeras: Free The Tormented (47121, criteria), Tomb of Sargeras: The Fallen Avatar (47122, criteria), Tomb of Sargeras: The Fallen Avatar (47123, criteria), Tomb of Sargeras: The Fallen Avatar (47124, criteria), Tomb of Sargeras: The Fallen Avatar (47125, criteria), Tomb of Sargeras: The Deceiver (47126, criteria), Tomb of Sargeras: The Deceiver (47127, criteria), Tomb of Sargeras: The Deceiver (47128, criteria), Tomb of Sargeras: The Deceiver (47129, criteria)
  - **Trial of Valor**: Trial of Valor: Odyn's Favor (44729, criteria), Trial of Valor: Odyn's Judgment (44868, criteria)
  - **Trueshot Lodge**: Infused with Power (41047, criteria)
  - **Twilight Highlands**: Scouting the Shore (27341), Scouting the Shore (27610)
  - **Ulduar**: The Celestial Planetarium (13607), Heroic: The Celestial Planetarium (13816), Disturbance Detected: Ulduar (50316, criteria)
  - **Uldum**: A Rallying Cry (58229, criteria), Lessons in Brigandry (58239, criteria), The Sun King's Chosen (58288, criteria), Guarded Secrets (58289, criteria), Retinus the Seeker (58742, defeat battle pet), Dune Buggy (58743, defeat battle pet), I Am The One Who Whispers (58744, defeat battle pet), Watch Where You Step (58745, defeat battle pet), Terrors from the Deep (58781, criteria), Things Left Behind (58782, criteria), Enter the Void (58801, criteria), Someone His Own Size (58859, criteria), Big Bad Beetle (58860, criteria), The Mantids' Mettle (58861, criteria), The Littlest Defender (58862, criteria), Call to Arms: Uldum (59016, criteria), Call to Arms: Uldum (59019, criteria)
  - **Val'sharah**: Training with Durian (40279, pet battle (tamer)), Stand Up to Bullies (41855, defeat battle pet), Dealing with Satyrs (41860, pet battle (tamer)), Meet The Maw (41861, defeat battle pet), Only Pets Can Prevent Forest Fires (41862, pet battle (tamer)), The Dreamweavers (42170, criteria), Wildlife Conservationist (42190, defeat battle pet), Battle for Val'sharah (45856, criteria)
  - **Vale of Eternal Blossoms**: Champions of the Mogu (57720, criteria), The Strongest Among Them (58423, criteria), Corrupted Curiosities (58470, criteria), Plunder the Plunderers (58487, criteria), Tiny Madness (58746, defeat battle pet), Brain Tickling (58747, defeat battle pet), Living Statues Are Tough (58748, defeat battle pet), Flight of the Vil'thik (58749, defeat battle pet), Champions of the Swarm (58754, criteria), Stashed Supplies (58755, criteria), Call to Arms: Vale of Eternal Blossoms (59017, criteria), Call to Arms: Vale of Eternal Blossoms (59018, criteria)
  - **Vault of the Wardens**: Vault of the Wardens: Into the Vault of the Wardens (43556, criteria), Vault of the Wardens: Into the Vault of the Wardens (44260, criteria), Vault of the Wardens: Into the Vault of the Wardens (44261, criteria)
  - **Violet Hold**: Assault on Violet Hold: Into the Violet Hold (43557, criteria), Assault on Violet Hold: Into the Violet Hold (44258, criteria), Assault on Violet Hold: Into the Violet Hold (44259, criteria)
  - **Vision of Orgrimmar**: The Drag (57372, criteria)
  - **Void Elf**: Telogrus Rift (48962, criteria), Stranger in a Strange Land (50305, criteria)
  - **Vol'dun**: Voldunai (50603, criteria), Keeyo's Champions of Vol'dun (52850, pet battle (tamer)), Snakes on a Terrace (52856, pet battle (tamer)), What Do You Mean, Mind Controlling Plants? (52864, defeat battle pet), Desert Survivors (52878, pet battle (tamer)), Call to Arms: Vol'dun (52950, criteria), Call to Arms: Vol'dun (52953, criteria)
  - **Vulpera**: Stranger in a Strange Land (58124, criteria)
  - **Warfronts**: Warfront: The Battle for Darkshore (53955, criteria), Darkshore Recruits (53957, criteria), Druids of Gloomtide (53974, criteria), Iron in Hand (53976, criteria), Warfront: The Battle for Darkshore (53992, criteria), Wisp'd Into Shape (54436, criteria), An Explosive Situation (54654, criteria), Darkshore Recruits (54656, criteria), An Alchemist for Everything (54659, criteria), Heroic Warfront: The Battle for Darkshore (57959, criteria), Heroic Warfront: The Battle for Darkshore (57960, criteria)
  - **Warlock Campaign**: Searching the Archives (42097, criteria), Tech It Up A Notch (42601, criteria), Troops in the Field (42602, criteria), Information at Any Cost (42603, criteria), Rise, Champions (42608, criteria), Unparalleled Power (44682, criteria)
  - **Warrior Campaign**: On the Trail of the Great Worm (42107, criteria), Champions of Skyhold (42598, criteria), Troops in the Field (42610, criteria), Einar the Runecaster (42611, criteria), The Fate of Hodir (42974, criteria), Ulduar's Oath (43090, criteria), Capturing the Gateway (43577, criteria), Preparing For War (43585, criteria), Maw of Souls: Message to Helya (43586, criteria), Will of the Valarjar (44667, criteria)
  - **Weekend Event**: A Burning Path Through Time (39020, criteria), A Frozen Path Through Time (39021, criteria), The Time to Strike (39033, criteria), Emissary of War (39034, criteria), A Call to Battle (39040, criteria), The Arena Calls (39041, criteria), A Shattered Path Through Time (40792, criteria), A Burning Path Through Time (44164, criteria), A Frozen Path Through Time (44166, criteria), A Shattered Path Through Time (44167, criteria), Emissary of War (44171, criteria), The Arena Calls (44172, criteria), A Call to Battle (44173, criteria), The World Awaits (44175, criteria), A Shrouded Path Through Time (45799, criteria), The World Awaits (53030, criteria), A Burning Path Through Time (53032, criteria), A Frozen Path Through Time (53033, criteria), A Shattered Path Through Time (53034, criteria), A Shrouded Path Through Time (53035, criteria), A Call to Battle (53036, criteria), Emissary of War (53037, criteria), The Arena Calls (53039, criteria), A Savage Path Through Time (54995, criteria)
  - **Western Plaguelands**: After the Crusade (26930), Unusual Behavior... Even For Gnolls (27152)
  - **Wintergrasp**: Victory in Wintergrasp (55508, criteria), Victory in Wintergrasp (55509, criteria)
  - **World Quest**: Tortollan Seekers (50604, criteria)
  - **Zandalari Troll**: For the Horde (55137, criteria), Stranger in a Strange Land (55138, criteria)
  - **Zangarmarsh**: Observing the Sporelings (9701), Disturbance at Umbrafen Lake (9716), Drain Schematics (9731), The Boha'mu Ruins (9786)
  - **Zul'Drak**: Trouble at the Altar of Sseratus (12506), I Sense a Disturbance (12665)
  - **Zuldazar**: A Different Outcome (50331, criteria), Zandalari Empire (50598, criteria), Horde War Effort (50606, criteria), Critters are Friends, Not Food (52892, pet battle (tamer)), Add More to the Collection (52923, pet battle (tamer)), You've Never Seen Jammer Upset (52937, defeat battle pet), Small Beginnings (52938, pet battle (tamer))

  </details>

- **Pick up:** this only adds a new patch; the patches you already applied are unchanged.
  `Player.h` changes, so most of the core rebuilds.

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-8ftb1c
  git -C ../tools-repo show FETCH_HEAD:tools/bfa/quest-objective-flags.patch | git apply && echo "quest objective flags applied"
  grep -c SetQuestSlotObjectiveFlag src/server/game/Entities/Player/Player.cpp
  sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
  ```

  The echo line prints and the grep prints 3. Then restart worldserver.

## 2026-11-09 (World fixes: Orgrimmar balloon Pandaren)

Merged to `main` with PR #47 on 2026-11-09.

### World: five Pandaren fall out of the balloon outside Orgrimmar

- **Found** (Four, 2026-11-09): outside Orgrimmar's front gate, by the Huojin Pandaren and the
  dragon turtles, a group of Pandaren falls from the tethered hot air balloon to the ground.
- **Cause:** Chao-Ju 2756, Jiming 5029, Winwa 5034, Winsum 16868 and Jising 16869 have one spawn
  each (guids 300001459, 300001460, 300001469, 300001475, 300001476) at z 56.7, inside the
  balloon's basket about 28 yards above the ground (z 28). The basket isn't solid for the server
  and their templates are ground-only (`InhabitType` 3), so they drop to the ground on spawn.
- **Changed:** `sql/fixes/world/2026_11_09_30_orgrimmar_balloon_pandaren.sql`: `creature_template`
  `InhabitType` 3 -> 4 for entries 2756, 5029, 5034, 16868, 16869. `Creature::UpdateMovementFlags`
  then turns gravity off for them, so they stand still in the basket. Their spawns are untouched.
- **Status:** confirmed in game by Four on 2026-11-09 (they stay in the basket).
- **Pick up:**

  ```
  cd ~/bfa/source
  git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
  ```

  ```
  git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_09_30_orgrimmar_balloon_pandaren.sql | mysql -u root -p bfa_world
  ```

  Then restart worldserver.

## 2026-11-09

### World: older expansion profession skills need the expansion's level

- **Found** (Four, 2026-11-09): after 2026_11_09_00 the Outland to Legion profession skills had no level
  requirement (the dump's own rows were mixed: Cataclysm 0, 5 or 78), while Classic needs level 5 and
  Kul Tiran level 110. Four wants each expansion's skill gated by that expansion's level.
- **Changed:** `sql/fixes/world/2026_11_09_02_profession_tier_levels.sql` (`bfa_world`): `trainer_spell`
  `ReqLevel` for every trainer row of the step spells, about 462 rows:

  | Expansion | Level | Step spells (Alchemy, Blacksmithing, Cooking, Enchanting, Engineering, Herbalism, Inscription, Jewelcrafting, Leatherworking, Mining, Skinning, Tailoring) |
  |---|---|---|
  | Outland | 0 -> 58 | 264214, 264437, 264635, 264461, 264480, 265822, 264497, 264535, 264580, 265840, 265858, 264619 |
  | Northrend | 0 -> 68 | 264221, 264439, 264637, 264463, 264482, 265824, 264499, 264538, 264582, 265842, 265860, 264621 |
  | Cataclysm | 0/5/78 -> 80 | 264244, 264441, 264639, 264466, 264484, 265826, 264501, 264541, 264584, 265844, 265862, 264623 |
  | Pandaria | 0 -> 85 | 264246, 264443, 264641, 264468, 264486, 265828, 264503, 264543, 264586, 265846, 265864, 264625 |
  | Draenor | 0 -> 90 | 264248, 264445, 264643, 264470, 264488, 265830, 264505, 264545, 264589, 265848, 265866, 264627 |
  | Legion | 0 -> 98 | 264251, 264447, 264645, 264472, 264491, 265832, 264507, 264547, 264591, 265850, 265868, 264629 |

  Classic (5) and Kul Tiran (110) unchanged; fishing unchanged. Re-running 2026_11_09_00 or 01 puts
  their rows back to level 0, so run this file again after them. Ran twice in a test database.
- **Status:** confirmed in game 2026-11-09 (each expansion's skill shows its level requirement).

#### To pick up the level requirements
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-2e6el5
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_09_02_profession_tier_levels.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: profession trainers open their proper list (and which trainer teaches what)

- **Found** (Four asked for a list of which trainers teach what, 2026-11-09): most Outland, Northrend
  and Pandaria trainers, and many others, still did not offer the expansion skills after the trainer
  fix below. The core picks a trainer's list by the gossip option clicked, `creature_trainer`
  (`CreatureId`, `MenuId`, `OptionIndex`): a trainer with gossip menu 0 shows the generic "Train me!"
  (menu 0, option 3), and one without the gossip flag opens its list directly (menu 0, option 0). When no
  row matches, the core falls back to the old `npc_trainer` list (old rank spells, no expansion skills),
  the same thing that broke fishing at Astaia (2026_10_10_01). The 2026_09_04 trainer sync left 266
  profession trainers (210 of them spawned) with no row for the option they actually show; Seymour and
  Gaston pointed at the Enchanting list. The Boralus trainers had no row at all, so the Alliance side had
  no trainer for the Kul Tiran skills except Grix (blacksmithing only). Grix's list 133536 and Shuga
  Blastcaps's list 874 taught only the Kul Tiran / Zandalari skill.
- **Changed:** `sql/fixes/world/2026_11_09_01_profession_trainer_options.sql` (`bfa_world`, run after
  2026_11_09_00):
  - 266 `creature_trainer` rows, one per trainer for the option it shows, pointing at:
    - the trainer's own list for that profession, when it has one;
    - Boralus and Tiragarde trainers: the Kul Tiras lists, Alchemy 846, Cooking 858, Enchanting 831,
      Engineering 873, Herbalism 851, Inscription 836, Jewelcrafting 821, Leatherworking 826, Mining
      841, Skinning 868, Tailoring 863 (the Alliance twins of the Zuldazar lists 822 to 874);
    - Cooka Mala and Milliner Hakkit (Zuldazar): Cooking 858, Tailoring 864;
    - everyone else: the profession's main list, Alchemy 122, Blacksmithing 991, Cooking 136,
      Enchanting 62, Engineering 993, Herbalism 424, Inscription 63, Jewelcrafting 119,
      Leatherworking 990, Mining 992, Skinning 989, Tailoring 163.
  - 14 `trainer_spell` rows: lists 133536 (Grix) and 874 (Shuga) also teach Classic (264435 / 264478,
    level 5) and Outland to Legion (264437-264447 / 264480-264491, 10 copper, needs Blacksmithing 164 /
    Engineering 202 at 1).
  - Each profession's rows are deleted by their exact (`CreatureId`, `MenuId`, `OptionIndex`) first, so
    it is safe to run more than once. Ran twice in a test database: 266 + 14 rows each time. Checked
    that no trainer loses a skill it taught before.
- **Not fixed:**
  - 23 trainers have their own gossip menu with no "Train me" option at all, so they cannot train
    (last table below).
  - No trainer recipes exist for the Outland to Legion crafting skills (see the entry below).
- **Status:** confirmed in game 2026-11-09: Rorelien (Honor Hold) lists Classic to Legion Herbalism,
  Declan Senal (Boralus) lists those plus Kul Tiran Herbalism.

#### Which trainer teaches what

Every trainer below teaches its profession's Classic, Outland, Northrend, Cataclysm, Pandaria, Draenor
and Legion skills (levels 5, 58, 68, 80, 85, 90, 98 after 2026_11_09_02). **(KT)** = also teaches the Kul Tiran / Zandalari skill. † = was opening the old
fallback list and is fixed by 2026_11_09_01. Only spawned trainers are listed, by the zone of their
spawn. Fishing trainers already taught every expansion and are not listed.

<details>
<summary><b>Alchemy</b>: 40 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashenvale | Kylanna † |
| Ashran | Jaiden Trask †, Kristoph Cossey † |
| Azuremyst Isle | Daedal |
| Boralus Harbor | Elric Whalgrene **(KT)** † |
| Borean Tundra | Arthur Henslowe †, Falorn Nightwhisper |
| Dalaran (Broken Isles) | Deucus Valdera †, Linzy Blackbolt † |
| Dalaran (Northrend) | Linzy Blackbolt |
| Darnassus | Ainethil |
| Dragonblight | Apothecary Bressa †, Apothecary Wormwick † |
| Dread Wastes | Poisoncrafter Kil'zit † |
| Durotar | Miao'zan |
| Dustwallow Marsh | Alchemist Narett |
| Elwynn Forest | Alchemist Mallory † |
| Eversong Woods | Arcanist Sheynathren † |
| Feralas | Kylanna Windwhisper |
| Hellfire Peninsula | Alchemist Gribble †, Apothecary Antonivich |
| Hillsbrad Foothills | Serge Hinott † |
| Howling Fjord | Lanolis Dewdrop, Wilhelmina Renel |
| Icecrown | Crystal Brightspark |
| Ironforge | Tally Berryfizz |
| Loch Modan | Ghak Healtouch |
| Orgrimmar | Yelmak |
| Shattrath City | Aelthin, Alchemist Kanhu † |
| Silvermoon City | Camberon |
| Stormwind City | Lilyssia Nightbreeze |
| Swamp of Sorrows | Rogvar † |
| Teldrassil | Cyndra Kindwhisper |
| The Cape of Stranglethorn | Jaxin Chong |
| The Exodar | Lucc † |
| Thunder Bluff | Bena Winterhoof |
| Tirisfal Glades | Carolai Anise |
| Undercity | Doctor Herbert Halsey |
| Zuldazar | Clever Kumali **(KT)** † |

</details>

<details>
<summary><b>Blacksmithing</b>: 52 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Aimee Goldforge †, Mazdon Bizratchet † |
| Azuremyst Isle | Blacksmith Calypso |
| Boralus Harbor | Grix "Ironfists" Barlow **(KT)** |
| Borean Tundra | Argo Strongstout, Crog Steelspine |
| Dalaran (Broken Isles) | Alard Schmied †, Arcanomancer Vridiel † |
| Dalaran (Northrend) | Alard Schmied, Imindril Spearsong, Orland Schaeffer |
| Dragonblight | Borus Ironbender †, Josric Fame † |
| Dun Morogh | Tognus Flintfire |
| Durotar | Dwukk |
| Duskwood | Clarise Gnarltree |
| Elwynn Forest | Smith Argus |
| Eversong Woods | Arathel Sunforge † |
| Hellfire Peninsula | Dumphry, Humphry, Rohok † |
| Highmountain | Barm Stonebreaker †, Muirn Ironhorn † |
| Howling Fjord | Kristen Smythe †, Rosina Rivet |
| Icecrown | Rekka the Hammer |
| Ironforge | Bengus Deepforge, Grumnus Steelshaper †, Ironus Coldsteel † |
| Northern Barrens | Traugh † |
| Orgrimmar | Borgosh Corebender, Kelgruk Bloodaxe, Okothos Ironrager, Rogg, Saru Steelfury, Shayis Steelfury |
| Shadowmoon Valley | Grutah † |
| Shattrath City | Barien, Kradu Grimblade, Onodo, Zula Slagfury |
| Silvermoon City | Bemarrin |
| Stormwind City | Therum Deepforge |
| Suramar | Felsmith Nal'ryssa † |
| The Cape of Stranglethorn | Brikk Keencraft |
| The Exodar | Miall † |
| The Jade Forest | Len the Hammer † |
| The Storm Peaks | Brandig |
| Thunder Bluff | Karn Stonehoof |
| Undercity | James Van Brunt † |
| Vale of Eternal Blossoms | Zen Master Lao † |
| Zuldazar | Forgemaster Zak'aal **(KT)** † |

</details>

<details>
<summary><b>Cooking</b>: 54 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Elton Black †, Guy Fireeye † |
| Azuremyst Isle | "Cookie" McWeaksauce |
| Boralus Harbor | "Cap'n" Byron Mehlsack **(KT)** † |
| Borean Tundra | Orn Tenderhoof †, Rollick MacKreel |
| Dalaran (Broken Isles) | Awilo Lon'gomba †, Katherine Lee † |
| Dalaran (Northrend) | Awilo Lon'gomba †, Katherine Lee |
| Darnassus | Alegorn, Mary Allerton † |
| Dun Morogh | Caitrin Ironkettle †, Cook Ghilm, Gremlock Pilsnor |
| Durotar | Ondani Greatmill † |
| Dustwallow Marsh | Craig Nollward |
| Elwynn Forest | Ellen Moore †, Tomas |
| Eversong Woods | Alice Rigsdale †, Quarelestra |
| Ghostlands | Master Chef Mouldier † |
| Gilneas | Fielding Chesterhill |
| Hellfire Peninsula | Allison, Gaston † |
| Howling Fjord | Brom Brewbaster, Thomas Kolichio † |
| Icecrown | Bethany Cromwell |
| Ironforge | Daryl Riknussun |
| Mulgore | Pyall Silentstride |
| Northern Barrens | Duhng † |
| Northern Stranglethorn | Mudduk † |
| Orgrimmar | Arugi, Feng Su, Zamja |
| Redridge Mountains | Crystal Boughman |
| Shadowmoon Valley | Celie Steelwing |
| Silvermoon City | Sylann |
| Stormwind City | Dalia Skyblossom, Stephen Ryback |
| Teldrassil | Zarrin |
| The Cape of Stranglethorn | Mrs. Gant |
| The Exodar | Alnar Whitebough †, Mumman |
| Thunder Bluff | Aska Mistrunner, Mahara Goldwheat † |
| Tirisfal Glades | Roberta Carter †, The Chef |
| Undercity | Eunice Burch |
| Vol'dun | Hessir **(KT)** † |
| Zangarmarsh | Naka |
| Zuldazar | Cooka Mala **(KT)** †, Howcha **(KT)**, T'sarah the Royal Chef **(KT)** |

</details>

<details>
<summary><b>Enchanting</b>: 33 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Bil Sparktonic †, Hane'ke † |
| Boralus Harbor | Emily Fairweather **(KT)** † |
| Borean Tundra | Alexis Marlowe, Eorain Dawnstrike |
| Dalaran (Broken Isles) | Enchanter Nalthanis † |
| Dalaran (Northrend) | Enchanter Nalthanis |
| Darnassus | Taladan |
| Dustwallow Marsh | Lissah Spellwick |
| Elwynn Forest | Kitta Firewind |
| Eversong Woods | Magistrix Eredania † |
| Feralas | Xylinnia Starshine |
| Hellfire Peninsula | Felannia †, Johan Barnes † |
| Highmountain | Guron Twaintail † |
| Howling Fjord | Elizabeth Jackson, Emil Autumn |
| Icecrown | Fael Morningsong |
| Ironforge | Gimble Thistlefuzz † |
| Netherstorm | Asarnan † |
| Orgrimmar | Godan |
| Shattrath City | Enchantress Andiala, Enchantress Volali, High Enchanter Bardolan, Zurii |
| Silvermoon City | Sedana |
| Stormwind City | Lucan Cordell † |
| The Exodar | Nahogg † |
| The Jade Forest | Lai the Spellpaw † |
| Thunder Bluff | Teg Dawnstrider |
| Tirisfal Glades | Vance Undergloom |
| Undercity | Lavinia Crowe |
| Zuldazar | Enchantress Quinni **(KT)** † |

</details>

<details>
<summary><b>Engineering</b>: 45 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Han Leaprocket †, Hilda Copperfuze † |
| Azuremyst Isle | Artificer Daelo |
| Boralus Harbor | Layla Evenkeel **(KT)** † |
| Borean Tundra | Chief Engineer Leveny, Sock Brightbolt |
| Dalaran (Broken Isles) | Didi the Wrench †, Timofey Oshenko † |
| Dalaran (Northrend) | Didi the Wrench, Findle Whistlesteam, Timofey Oshenko |
| Darkshore | Jenna Lemkenilli |
| Darnassus | Tana Lentner |
| Dun Morogh | Bronk Guzzlegear |
| Durotar | Mukdrak |
| Duskwood | Finbus Geargrind |
| Dustwallow Marsh | Caz Twosprocket |
| Hellfire Peninsula | Lebowski †, Zebig † |
| Howling Fjord | Jamesina Watterly, Tisha Longbridge |
| Icecrown | Binkie Brightgear |
| Ironforge | Springspindle Fizzlegear |
| Mulgore | Twizwick Sprocketgrind † |
| Netherstorm | Xyrol † |
| Northern Barrens | Tinkerwiz † |
| Orgrimmar | "Jack" Pisarek Slamfix, Roxxik |
| Shadowmoon Valley | Jonathan Garrett †, Niobe Whizzlespark |
| Shattrath City | Engineer Sinbei, Technician Mihila |
| Siege of Orgrimmar | Roxxik |
| Silvermoon City | Danwe |
| Stormwind City | Artificer Farud †, Lilliam Sparkspindle |
| Tanaris | Buzzek Bracketswing |
| The Cape of Stranglethorn | Oglethorpe Obnoticus † |
| The Exodar | Ockil |
| Thunder Bluff | Engineer Palehoof |
| Undercity | Franklin Lloyd † |
| Valley of the Four Winds | Sally Fizzlefury † |
| Zangarmarsh | K. Lee Smallfry, Mack Diver † |
| Zuldazar | Shuga Blastcaps **(KT)** † |

</details>

<details>
<summary><b>Herbalism</b>: 48 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashenvale | Cylania Rootstalker † |
| Ashran | Anthony Allain †, Jie Wildblossom † |
| Azuremyst Isle | Heur † |
| Bloodmyst Isle | Morae |
| Boralus Harbor | Declan Senal **(KT)** † |
| Borean Tundra | Kirea Moondancer, Tansy Wildmane † |
| Dalaran (Broken Isles) | Dorothy Egan, Kuhuine Tenderstride † |
| Dalaran (Northrend) | Dorothy Egan |
| Darnassus | Firodren Mooncaller † |
| Durotar | Mishiki |
| Dustwallow Marsh | Brant Jasperbloom |
| Elwynn Forest | Herbalist Pomeroy |
| Eversong Woods | Botanist Tyniarrel † |
| Feralas | Ruw |
| Hellfire Peninsula | Rorelien †, Ruak Stronghorn † |
| Highmountain | Sprig Hashhoof † |
| Hillsbrad Foothills | Aranae Venomblood |
| Howling Fjord | Fayin Whisperleaf, Marjory Kains |
| Ironforge | Reyna Stonebranch |
| Loch Modan | Kali Healtouch |
| Moonglade | Malvor † |
| Northern Stranglethorn | Angrun |
| Orgrimmar | Grove Cultivator Kados, Jandi, Muraga |
| Redridge Mountains | Alma Jainrose |
| Shattrath City | Botanist Alaenra, Jijia † |
| Silvermoon City | Botanist Nathera |
| Stormwind City | Shylamiir †, Tannysa |
| Teldrassil | Malorne Bladeleaf |
| The Cape of Stranglethorn | Flora Silverwind |
| The Exodar | Cemmorhan |
| The Jade Forest | Grower Miao †, Orchard Keeper Li Mei † |
| Thunder Bluff | Komin Winterhoof |
| Tirisfal Glades | Faruza |
| Undercity | Martha Alliestar |
| Val'sharah | Wildcrafter Osme |
| Valley of the Four Winds | Han Flowerbloom † |
| Wetlands | Telurinon Moonshadow † |
| Zuldazar | Jahden Fla **(KT)** † |

</details>

<details>
<summary><b>Inscription</b>: 28 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Joro'man †, Scribe Chi-Yuan † |
| Boralus Harbor | Zooey Inksprocket **(KT)** † |
| Borean Tundra | Adelene Sunlance, Tink Brightbolt |
| Dalaran (Broken Isles) | Professor Pallin † |
| Dalaran (Northrend) | Professor Pallin |
| Darnassus | Feyden Darkin |
| Dustwallow Marsh | Theoden Manners |
| Hellfire Peninsula | Michael Schwan, Neferatti |
| Howling Fjord | Booker Kells, Mindri Dinkles |
| Icecrown | Arthur Denny |
| Ironforge | Elise Brightletter |
| Orgrimmar | Jo'mah, Nerog |
| Shattrath City | Recorder Lidio, Scribe Lanloer |
| Silvermoon City | Zantasia |
| Stormwind City | Catarina Stanford |
| The Exodar | Thoth |
| The Jade Forest | Scribe Rinji † |
| Thunder Bluff | Poshken Hardbinder |
| Undercity | Margaux Parchley |
| Vale of Eternal Blossoms | Lorewalker Huynh † |
| Zuldazar | Chronicler Grazzul **(KT)** †, Chronicler Kizani **(KT)** † |

</details>

<details>
<summary><b>Jewelcrafting</b>: 28 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Alixander Swiftsteel †, Artificer Nissea † |
| Boralus Harbor | Samuel D. Colton III **(KT)** † |
| Borean Tundra | Alestos, Geba'li † |
| Dalaran (Broken Isles) | Timothy Jones † |
| Dalaran (Northrend) | Timothy Jones |
| Darnassus | Aessa Silverdew |
| Dustwallow Marsh | Ingo Woolybush |
| Eversong Woods | Aleinia |
| Hellfire Peninsula | Kalaen †, Tatiana † |
| Howling Fjord | Carter Tiffens †, Ounhulo |
| Icecrown | Oluros |
| Ironforge | Hanner Gembold |
| Netherstorm | Jazdalaad † |
| Orgrimmar | Lugrah |
| Shattrath City | Hamanar, Kirembri Silvermane, Nemiha |
| Silvermoon City | Kalinda |
| Stormwind City | Theresa Denman |
| The Exodar | Farii |
| The Jade Forest | Mai the Jade Shaper † |
| Thunder Bluff | Nahari Cloudchaser |
| Undercity | Neller Fayne † |
| Zuldazar | Seshuli **(KT)** † |

</details>

<details>
<summary><b>Leatherworking</b>: 44 trainers</summary>

| Zone | Trainers |
|---|---|
| Arathi Highlands | Brumn Winterhoof † |
| Ashenvale | Aayndia Floralwind |
| Ashran | Burga Stronghide †, Jistun Sharpfeather † |
| Azsuna | Celea † |
| Azuremyst Isle | Moordo |
| Blade's Edge Mountains | Grikka † |
| Boralus Harbor | Cassandra Brennor **(KT)** † |
| Borean Tundra | Awan Iceborn †, Rosemary Bovard |
| Dalaran (Broken Isles) | Namha Moonwater † |
| Dalaran (Northrend) | Andellion, Diane Cannings, Manfred Staller, Namha Moonwater |
| Darnassus | Telonis |
| Dustwallow Marsh | Eustace Tanwell |
| Elwynn Forest | Adele Fielder |
| Eversong Woods | Sathein † |
| Hellfire Peninsula | Barim Spilthoof †, Brumman † |
| Highmountain | Hrul Sharphoof † |
| Howling Fjord | Bernadette Dexter, Gunter Hansen |
| Icecrown | Kul'de |
| Ironforge | Fimble Finespindle |
| Kun-Lai Summit | Clean Pelt † |
| Mulgore | Chaw Stronghide |
| Orgrimmar | Karolek |
| Shattrath City | Daenril, Darmari, Korim |
| Silvermoon City | Lynalis |
| Southern Barrens | Krulmoo Fullmoon † |
| Stormwind City | Simon Tanner |
| Stranglethorn Vale | Se'Jib † |
| Suramar | Stalriss Dawnrunner † |
| Teldrassil | Nadyia Maneweaver |
| The Exodar | Akham † |
| The Hinterlands | Drakk Stonehand † |
| Thunder Bluff | Una |
| Tirisfal Glades | Shelene Rhobart |
| Undercity | Arthur Moore † |
| Zuldazar | Xanjo **(KT)** † |

</details>

<details>
<summary><b>Mining</b>: 37 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Murg Stonecrack † |
| Azuremyst Isle | Dulvi |
| Boralus Harbor | Myra Cabot **(KT)** † |
| Borean Tundra | Brunna Ironaxe, Fendrig Redbeard |
| Dalaran (Broken Isles) | Mama Diggs † |
| Dalaran (Northrend) | Jedidiah Handers |
| Darkshore | Periale |
| Darnassus | Foreman Pernic |
| Dun Morogh | Dank Drizzlecut, Yarr Hammerstone |
| Durotar | Krunn |
| Duskwood | Matt Johnson |
| Hellfire Peninsula | Hurnak Grimmord †, Krugosh † |
| Highmountain | Ronos Ironhorn † |
| Howling Fjord | Grumbol Stoutpick, Jonathan Lewis † |
| Ironforge | Geofram Bouldertoe |
| Kun-Lai Summit | Master Brandom † |
| Loch Modan | Brock Stoneseeker |
| Orgrimmar | Gonto, Layla Stonebreaker, Makaru |
| Shattrath City | Fono, Hanlir |
| Silvermoon City | Belil |
| Silverpine Forest | Johan Focht † |
| Stormwind City | Gelman Stonehand |
| Tanaris | Pikkle |
| The Exodar | Muaat |
| The Jade Forest | Rockseeker Guo †, Smeltmaster Ashpaw †, Stonebreaker Ruian † |
| Thunder Bluff | Brek Stonehoof |
| Undercity | Brom Killian † |
| Zuldazar | Secott the Goldsmith **(KT)** † |

</details>

<details>
<summary><b>Skinning</b>: 41 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashenvale | Jayla † |
| Ashran | Kondal Huntsworn †, Rangari Laandon † |
| Azsuna | Glielle † |
| Azuremyst Isle | Gurf |
| Borean Tundra | Tiponi Stormwhisper †, Trapper Jack |
| Dalaran (Broken Isles) | Kondal Huntsworn |
| Dalaran (Northrend) | Derik Marks |
| Darnassus | Eladriel |
| Desolace | Malux † |
| Dustwallow Marsh | Humbert Tanwell |
| Elwynn Forest | Helene Peltskinner † |
| Eversong Woods | Mathreyn † |
| Feralas | Kulleg Stonehorn † |
| Hellfire Peninsula | Jelena Nightsky †, Moorutu † |
| Howling Fjord | Frederic Burrhus, Roberta Jacks |
| Ironforge | Balthus Stoneflayer |
| Mulgore | Yonn Deepcut † |
| Orgrimmar | Rento, Thuwd |
| Redridge Mountains | Wilma Ranthal † |
| Shattrath City | Dremm †, Irduil † |
| Silvermoon City | Tyn |
| Southern Barrens | Dranh † |
| Stormheim | Agnes †, Seymour † |
| Stormwind City | Maris Granger |
| Suramar | Ske'rit † |
| Teldrassil | Radnaal Maneweaver |
| The Exodar | Remere |
| The Jade Forest | Hao of the Stag's Horns †, Trapper Ri † |
| Thunder Bluff | Mooranta † |
| Tiragarde Sound | Camilla Darksky **(KT)** † |
| Tirisfal Glades | Rand Rhobart |
| Undercity | Killian Hagey |
| Zuldazar | Rana the Cutta **(KT)** † |

</details>

<details>
<summary><b>Tailoring</b>: 38 trainers</summary>

| Zone | Trainers |
|---|---|
| Ashran | Joshua Fuesting †, Saesha Silverblood † |
| Azuremyst Isle | Erin Kelly |
| Boralus Harbor | Daniel Brineweaver **(KT)** † |
| Borean Tundra | Darin Goodstitch, Raenah † |
| Dalaran (Broken Isles) | Ainderu Summerleaf, Tanithria † |
| Dalaran (Northrend) | Charles Worth † |
| Darkshore | Faeyrin Willowmoon † |
| Darnassus | Me'lynn |
| Dustwallow Marsh | Timothy Worthington |
| Elwynn Forest | Eldrin |
| Eversong Woods | Sempstress Ambershine † |
| Hellfire Peninsula | Hama † |
| Howling Fjord | Alexandra McQueen †, Benjamin Clegg |
| Icecrown | Dustin Vail |
| Ironforge | Jormund Stonebrow |
| Northern Barrens | Kil'hala † |
| Orgrimmar | Hiwahi Three-Feathers †, Leyweaver Aurielle, Magar |
| Shattrath City | Miralisse, Weaver Aoa † |
| Silvermoon City | Keelen Sheets |
| Southern Barrens | Mahani † |
| Stormwind City | Aevedos †, Georgio Bolero, Jalane Ayrole |
| The Cape of Stranglethorn | Grarnik Goodstitch |
| The Exodar | Refik |
| Thunder Bluff | Tepa |
| Tirisfal Glades | Bowen Brisboise |
| Undercity | Josef Gregorian †, Josephine Lister † |
| Zuldazar | Milliner Hakkit **(KT)** †, Pin'jin the Patient **(KT)** † |

</details>

<details>
<summary><b>No "Train me" option</b>: 23 trainers (not changed)</summary>

| Profession | Trainers |
|---|---|
| Alchemy | Lorokeem (Shattrath City) |
| Blacksmithing | Guillaume Sorouy (Silverpine Forest), Jordan Smith (Stormwind City), Marie Holdston (Dustwallow Marsh), Opuno Ironhorn (Orgrimmar), Rolf Karner (Darnassus), Taryel Firestrike (Darkshore) |
| Cooking | Jack Trapper (Shattrath City) |
| Enchanting | Alanna Raveneye (Teldrassil), Annora (Uldaman), Hgarth (Stonetalon Mountains) |
| Engineering | Deek Fizzlebizz (Loch Modan), Nixx Sprocketspring (Tanaris), Tinkmaster Overspark (Ironforge), Vazario Linkgrease (Northern Barrens) |
| Inscription | Inkmaster Wei (The Jade Forest) |
| Leatherworking | Brawn (Northern Stranglethorn), Hahrana Ironhide (Feralas), Narv Hidecrafter (Desolace) |
| Mining | "Kobold" Kerik (Dustwallow Marsh) |
| Skinning | Seymour (Shattrath City) |
| Tailoring | Dalinna (Hellfire Peninsula), Daryl Stack (Hillsbrad Foothills) |

</details>

#### To pick up the trainer list fix
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-2e6el5
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_09_01_profession_trainer_options.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`. Run 2026_11_09_00 first if you have not yet.

### World: trainers teach every expansion's profession skill

- **Found** (Four asked where to learn Outland Herbalism, 2026-11-09): no `trainer_spell` row taught
  the Outland, Northrend, Pandaria, Draenor or Legion skill of any profession. Classic trainer lists
  taught Classic and, for some lists, Cataclysm (122, 991, 407, 993, 19778, 990, 163, 136, 995, 5566,
  989, 91, 992). The herbalism trainers Rorelien, Ruak Stronghorn, Botanist Alaenra, Jijia, Morae, the
  Northrend and both Dalaran trainers, Kali Healtouch, Aranae Venomblood, Angrun and Ruw pointed at
  trainer list 133, which has no `trainer` row, so they taught nothing. Grix "Ironfists" Barlow
  (133536) pointed at the missing list 994.
- **Changed:** `sql/fixes/world/2026_11_09_00_profession_tier_trainers.sql` (`bfa_world`):
  - 436 `trainer_spell` rows: every trainer list that teaches a profession's Classic skill also teaches
    its Outland, Northrend, Cataclysm (where missing), Pandaria, Draenor and Legion skill spells
    (Herbalism 265822/265824/265826/265828/265830/265832, Mining 265840-265850, Skinning
    265858-265868, crafting 2642xx-2646xx). 10 copper, `ReqSkillLine` = the profession (182, 186, 393,
    ...) at 1, no level requirement. Bandage list 877 is left out.
  - `creature_trainer` list 133 -> 424 (herbalism), and Grix 994 -> 133536 (his own list).
  - Kul Tiran stays with the Kul Tiras/Zandalar lists; fishing lists already teach every expansion.
  - Ran twice in a test database: 436 rows each time, no existing row removed.
- **Not fixed:** trainers did not sell the Outland to Pandaria crafting recipes. (This entry first said the
  database had none; it had them on Blizzard's lists at the wrong skill. Fixed on 2026-11-15, see
  "Crafting trainers teach every trainer recipe".)
- **Status:** confirmed in game 2026-11-09: Simon Tanner (Stormwind) lists Outland to Legion
  Leatherworking.

#### To pick up the trainer fix
```
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_11_09_00_profession_tier_trainers.sql
```
Run it from `~/bfa/source` after `git -C ../tools-repo pull`, then restart `worldserver`.

## 2026-11-08

### Core: skinning uses each expansion's own skill

- **Found** (Four, 2026-11-08): Cataclysm beasts (Hyjal, Vashj'ir, Deepholm, Uldum, Twilight Highlands,
  levels 80-88 in `creature_template`) could never be skinned. `Spell::CheckCast` asked for 5 skill per
  creature level (400-440) from the profession skill 393, which can't go above 300 (Classic Skinning's
  max). `Spell::EffectSkinning` always raised Classic Skinning (2564), so Cataclysm Skinning (2561) and
  the other expansion skills never moved. The same held for every beast above level 60.
- **Changed:** new `tools/bfa/skinning-tiers.patch`:
  - New `src/server/game/Spells/SkinningTiers.h`. `GetSkinningTier` picks the beast's expansion skill,
    and `GetSkinningTierRequirement` sets the skill it needs.
  - `Spell::CheckCast` (`SPELL_EFFECT_SKINNING`, `Spell.cpp`) checks that expansion skill. Classic
    beasts keep the old numbers, but they now check Classic Skinning (2564) instead of 393.
  - `Spell::EffectSkinning` (`SpellEffects.cpp`) raises that expansion skill, using the same requirement
    for its skill-up chance.
  - Beasts skinned with Herbalism, Mining or Engineering are unchanged. No SQL.
  - Compiles with GCC 13 on the full patch chain.

  What each expansion needs:

  | Expansion | Skill (ID) | Beasts it covers | Skill needed by beast level |
  |---|---|---|---|
  | Classic | Classic Skinning (2564), max 300 | `HealthScalingExpansion` 0 and level 1-60 | unchanged: 1-10 any, 15: 50, 20: 100, 30: 150, 40: 200, 50: 250, 60: 300 (`(level-10)*10` below 100 skill, `level*5` from 100) |
  | Outland | Outland Skinning (2563), max 75 | expansion 1, or level 61-70 | 58: 1, 60: 9, 62: 17, 64: 25, 66: 33, 68: 41, 70: 50 |
  | Northrend | Northrend Skinning (2562), max 75 | expansion 2, or level 71-80 | 68: 1, 70: 9, 72: 17, 74: 25, 76: 33, 78: 41, 80: 50 |
  | Cataclysm | Cataclysm Skinning (2561), max 75 | expansion 3, or level 81-85 | 80: 1, 81: 10, 82: 20, 83: 30, 84: 40, 85: 50 |
  | Pandaria | Pandaria Skinning (2560), max 75 | expansion 4, or level 86-90 | 85: 1, 86: 10, 87: 20, 88: 30, 89: 40, 90: 50 |
  | Draenor | Draenor Skinning (2559), max 100 | expansion 5, or level 91-100 | 90: 1, 92: 15, 94: 30, 96: 45, 98: 60, 100: 75 |
  | Legion | Legion Skinning (2558), max 100 | expansion 6, or level 101-110 | 98: 1, 100: 13, 102: 25, 104: 38, 106: 50, 108: 62, 110: 75 |
  | Kul Tiran | Kul Tiran Skinning (2557), max 150 | expansion 7, or level 111 and up | 110: 1, 112: 25, 114: 50, 116: 75, 118: 100, 120: 125 |

  "Expansion N" is the creature's `creature_template.HealthScalingExpansion`. Many templates leave it at 0
  whatever their level, so a 0 above level 60 picks the expansion by `minlevel` instead (the level ranges
  in the third column). Outside those levels, a beast below its expansion's first level needs 1, and one above its
  last level needs the same as the last level. For every expansion except Classic the requirement rises
  evenly from 1 at the first level to the skill's max minus 25 at the last. The max is read from your
  character, so the Draenor, Legion and Kul Tiran columns assume maxes of 100, 100 and 150; if your
  character shows a different max, the top of the range is that max minus 25. Learning the
  expansion's skill from a trainer is enough to start: with it at 1 you can skin that expansion's
  lowest beasts.

- **Status:** confirmed in game by Four on 2026-11-09: Outland beasts raise Outland Skinning, and
  Fleeing Stag (47263, Hyjal, level 80) raises Cataclysm Skinning.

### Core and world: herb and ore nodes use each expansion's own skill

- **Found** (Four asked for every tradeskill to work like skinning, 2026-11-08). Four's `Lock.db2` shows
  that almost every herb and ore node from Outland to Legion uses the plain Herbalism (lock type 2) or
  Mining (3) lock with the old 1-600 skill: for example Lichbloom 425, Twilight Jasmine 525, Golden Lotus
  550, Saronite 400 and Pyrite 525. The client checks that against the profession skill, which can't go
  above 300, so none of those could be gathered, and gathering only raised Classic Herbalism/Mining
  (`SkillByLockType` maps types 2 and 3 to 2556 and 2572). Each expansion has its own lock types (33-39
  herbs, 41-47 mining) and gather spells 265821-265853, which its trainer spell teaches (265822 Outland
  Herbalism teaches 265821, and so on). `Lock.db2` has Blizzard's lock for each: herbs 2856 (Outland)
  to 2862 (Kul Tiran), ore 2864 to 2870, each with the expansion slot and a plain Herbalism/Mining slot
  at skill 0. Only Kul Tiran nodes, Cinderbloom, Rich Elementium and Blackrock used them.
- **Changed:**
  - `sql/fixes/world/2026_11_08_00_gathering_tier_locks.sql` (`bfa_world`) points `Data0` (lock) of 93
    `gameobject_template` herb and ore nodes at their expansion's Blizzard lock (2856-2861, 2864-2869).
    Gathering nodes (type 50) that had old-scale trivial skill also get `Data4`/`Data5` = difficulty
    and difficulty + 25 (colour and skill-up chance). Each line names the node, its old skill and its
    new difficulty.
    - A node's expansion is where most of its spawns are: map 530 Outland, minus the blood elf and
      draenei zones; Outland and Northrend dungeon maps; 571 Northrend; Cataclysm zones and Deepholm;
      870 Pandaria; 1116 Draenor; 1220 Legion.
    - Every node needs only its expansion's skill learned. The difficulty scales the old skill over
      the expansion's old range (Outland 300-375, Northrend 350-450, Cataclysm 425-525, Pandaria
      500-600) to 1 up to the skill's max minus 25.
    - Only locks with a single herb or mining slot change. Quest objects that also open by kneeling or
      with an item keep their lock.
  - New `tools/bfa/gathering-tier-locks.patch` (after `skinning-tiers.patch`):
    - `Spell::CanOpenLock` (`Spell.cpp`) refuses a lock's plain Herbalism/Mining slot when the lock
      also has an Outland to Kul Tiran slot, so Classic Herbalism/Mining alone can't gather expansion
      nodes through Blizzard's skill-0 plain slot. It fails with `SPELL_FAILED_MIN_SKILL` and the
      expansion skill, 1 (`Spell::CheckCast` passes them on), so the client says "Requires Northrend
      Herbalism" and so on; the first build said "Invalid target" (Four, Goldclover, 2026-11-09). With
      both spells known the client casts the expansion one.
    - `AuraEffect::HandleAuraTrackResources` (`SpellAuraEffects.cpp`): Find Herbs (lock type 2) and
      Find Minerals (3) also mark Herbalism 32-39 and Mining 40-47 in `TrackResourceMask`. The client
      tracks an expansion node by its expansion lock type, and upstream never set those, so no
      expansion node (Kul Tiran ones included) showed on the minimap.
    - Compiles with GCC 13 on the full patch chain.
  - `sql/fixes/hotfixes/2026_11_08_00_gathering_tier_locks.sql` (`bfa_hotfixes`) caps Classic locks
    1632 (Small and Large Obsidian Chunk) and 399 (Arcanite Lode) at 300, from 305 and 310
    (`hotfix_data` 9301632 and 9300399, table hash 0xE9BECB23). It also removes the 38 locks
    (IDs 5xxxx) and their `hotfix_data` that the first version of the fix added.
  - The guide's section 3 has the full table per expansion.
  - Both SQL files ran twice in a test database without errors.
- **History:** the first version added new hotfix locks. With a skill number on them the client refused
  the node ("Requires Herbalism 1" with Outland Herbalism 1); with skill 0 they opened, but never showed
  on tracking, even with a plain slot added.
- **Status:** confirmed in game by Four on 2026-11-09: Felweed raises Outland Herbalism, Fel Iron and
  Khorium raise Outland Mining, Outland and Northrend herbs and ore show with Find Herbs/Minerals, and
  Goldclover without Northrend Herbalism says "Your skill is not high enough. Requires Northrend
  Herbalism (1)". Cataclysm to Legion nodes not tried individually (same locks and code).

### Core: a lower expansion skill never lowers the profession skill

- **Found** while checking crafting for Four's request. `Player::UpdateCraftSkill` (upstream) raises the
  profession skill itself for Classic Inscription (2514) and Classic Engineering (2506) recipes. With
  `SyncParentProfessionSkill` keeping the profession skill at the highest expansion skill, learning, say,
  Cataclysm Inscription at 1 would have set Inscription back to 1. Every other crafting profession
  already raises the recipe's own expansion skill (`SkillLineAbility.SkillupSkillLineID`).
- **Changed:** `tools/bfa/profession-skill-sync.patch` (`Player.cpp`, `SyncParentProfessionSkill`): it
  only ever raises the profession skill (returns when the highest expansion skill is below it).
  Compiles with GCC 13 on the full patch chain.
- **Status:** not yet tested in game.

#### To pick up the skinning tiers, gathering locks and sync change
`profession-skill-sync.patch` changed and `skinning-tiers.patch` and `gathering-tier-locks.patch` are new, so this swaps the old
version of the sync patch for the new one. The other patches you applied are unchanged.
```
cd ~/bfa/source
git -C ../tools-repo pull
git -C ../tools-repo show 05f80be:tools/bfa/profession-skill-sync.patch | git apply -R && echo "old sync patch removed"
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch && echo "new sync patch applied"
git apply ../tools-repo/tools/bfa/skinning-tiers.patch && echo "skinning tiers applied"
git apply ../tools-repo/tools/bfa/gathering-tier-locks.patch && echo "gathering locks applied"
grep -c "bestValue < player->GetPureSkillValue" src/server/game/Entities/Player/Player.cpp
grep -c GetSkinningTier src/server/game/Spells/Spell.cpp src/server/game/Spells/SpellEffects.cpp
grep -c expansionSkill src/server/game/Spells/Spell.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
All four echo lines print. The greps print 1, then 2 for each file, then 4. Then the
two SQL files, one at a time (each asks for the password):
```
mysql -u root -p bfa_hotfixes < ../tools-repo/sql/fixes/hotfixes/2026_11_08_00_gathering_tier_locks.sql
```
```
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_11_08_00_gathering_tier_locks.sql
```
Then restart `worldserver` and delete the client's `Cache` folder.

## 2026-11-07 (World fixes: Darkmoon Island)

Merged to `main` with PR #45 on 2026-11-07.

### World: Darkmoon Rabbit never spawns, Moonfang has no fight

- **Found** (Four, 2026-11-07): the Darkmoon Island rares Death Metal Knight, Darkmoon Rabbit and
  Moonfang need reviewing.
- **Cause:**
  - Darkmoon Rabbit 58336 had no spawn in the BFA dump. Its core script (`npc_darkmoon_rabbit_ird`)
    and loot (pet item 80008 at 11%) are fine.
  - Moonfang 71992 is spawned, but has no SmartAI rows and no core script, so she only melees.
    The Pandaria 5.4.8 core scripts her as `npc_darkmoon_moonfang`.
  - Moonfang Dreadhowl 71982 has 2 spawns here and 5 in the Pandaria 5.4.8 DB.
  - Darkmoon Rabbit and Moonfang had no level scaling (level 1, 31 health).
  - Death Metal Knight 122899 has a template and loot but no spawn here, in the Pandaria DB or in
    MaNGOS Three. He is a Legion rare in the Cauldron of Rock (area 8901), which is newer than
    every reference DB we have.
- **Changed:** `sql/fixes/world/2026_11_07_30_darkmoon_island_rares.sql`:
  - Darkmoon Rabbit spawned at the Pandaria spot by the rabbit's cave (guid 974200001,
    -4291.81 5860.5 3.38), respawn 115200 s (32 h), wander 5 yards.
  - Moonfang SmartAI, rebuilt from the Pandaria script with the same timers:
    - Fangs of the Moon 144700 on her target every 12.5 s.
    - Moonfang Tears pool 144579 every 20 s.
    - Leap for the Kill 144546 every 16 s.
    - Call the Pack 144602, which summons Moonfang Packmates 72038, every 32 s.

    Moonfang Curse 144590 is left out: it charms half the players in range, which solo is you.
    Packmates attack the closest player when summoned.
  - 3 Moonfang Dreadhowls added at the Pandaria spots (guids 974200002-974200004). All 5 wander
    5 yards (guid 1400330 stood still).
  - Death Metal Knight spawned at the spot Four gave in the Cauldron of Rock (guid 974200005,
    -4181.96 6019.82 6.29), respawn 300 s. He has no SmartAI or core script yet, so he only melees.
  - Darkmoon Rabbit and Moonfang were level 1 with 31 health (Four): neither had a
    `creature_template_scaling` row, and their HealthModifier was 1.
    - Both get a scaling row (levels 1-100, scales with the player), the same as Death Metal
      Knight, Moonfang Dreadhowl and Moonfang Packmate.
    - They get the Pandaria 5.4.8 health modifiers: Darkmoon Rabbit 400, Moonfang 400, Moonfang
      Packmate 8.
    - All three rares stay faction 7, neutral until attacked, as on retail (confirmed by Four).
  - Darkmoon Rabbit's pet (item 80008) drop 11% -> 100%, as in the Pandaria 5.4.8 DB, where it is
    his only drop.
- **Follow-up (Four, after fighting them):** the Darkmoon Rabbit one-shot Four, and Death Metal
  Knight had no weapon.
  - The rabbit's core script cast Huge, Sharp Teeth 114078 as soon as he was pulled. It holds you,
    deals 20% of your health every second and blocks all healing (114109), a group mechanic you
    can't survive solo. He now uses SmartAI: on aggro he takes his rabbit form (114085, as in the
    Pandaria 5.4.8 DB), drops it on evade, and fights in melee. `ScriptName` cleared, rank 3 (boss,
    level ??) -> 1 (elite, shows his scaled level) as in the Pandaria 5.4.8 DB.
  - Death Metal Knight wields Necromedes, the Death Resonator 151255, the two-hander from his own
    loot (`creature_equip_template` 122899 id 1, spawn 974200005 `equipment_id` 1).
  - Moonfang showed 456K health at level 38 with HealthModifier 400. Death Metal Knight at 300
    was a good solo fight, so Darkmoon Rabbit and Moonfang now use 300 as well. Moonfang's rank
    goes from 3 (boss) to 1 (elite), as in the Pandaria 5.4.8 DB.
  - Moonfang (Four: "the fight was good"): Fangs of the Moon came every 12.5 s, way too often;
    now every 25-30 s. She dropped nothing because her items only had independent rolls (about a
    third of kills dropped nothing). Moonfang's Paw, Shimmering Moonstone, Moonfang Shroud and Moon
    Moon are now one loot group (31/32/32/5%), so exactly one always drops.
  - Death Metal Knight was rank 0 and had no elite frame like the other two: now rank 1 (elite),
    health unchanged.
- **Status:** everything above confirmed in game by Four on 2026-11-07: all three rares spawn and
  scale, the rabbit and Moonfang fights are good, Moonfang always drops an item, and Death Metal
  Knight is elite with his sword. Still to do some day: Death Metal Knight's full retail Cauldron
  of Rock concert event (he is only the boss for now).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_07_30_darkmoon_island_rares.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-07 (pet battles)

### Pet battles: display pets near vendors and tamers can be battled

- **Found** (Four, screenshot): Lhara's display pets on Darkmoon Island (Darkmoon Cub, Turtle,
  Zeppelin, Hatchling, Balloon) show the pet battle paw.
- **Cause:** when a creature of type 14 (wild pet) spawns, `Map::AddBattlePet` calls
  `WildBattlePetMgr::EnableWildBattle`, which makes it a wild battle pet if `battlepet_info` has a
  row with that creature entry (`NpcID`). `battlepet_info` has a row for every species, including
  pets you buy, win or get from drops, and tamer team pets. So every display pet spawned next to a
  vendor or tamer became battleable: about 530 spawns of 375 entries in the world DB.
- **Changed:** new `sql/fixes/world/2026_11_07_51_battle_pets_only_capturable_are_wild.sql`. Rows
  whose species is not capturable (BattlePetSpecies flag 0x8 not set, 1,039 species, flags from the
  10.0.2 BattlePetSpecies.db2 CSV) get `NpcID + 10000000`, so `EnableWildBattle` no longer finds them
  by creature entry. The rows stay: the core reads them by species for breed and quality when you
  learn a pet, so learned pets don't change. Tamer battles use `battlepet_npc_team_member`, not this
  table. Capturable species (Crow, Glowfly, every wild critter pet) are not touched. Undo line in the
  file header. No core change.
- **Then found** (Four): without the battle pet flag those display pets could be attacked and killed.
  The same file now also sets `unit_flags | 0x300` (immune to players and NPCs) on the templates of
  the 299 spawned type 14 creatures of those species, as on retail.
- **Status:** confirmed in game by Four on 2026-11-07.

#### To pick it up
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_07_51_battle_pets_only_capturable_are_wild.sql | mysql -u root -p bfa_world
```
The last line prints `1041 non-capturable species no longer wild, 364 wild species left, 299 display
pet templates unattackable`. Then
restart `worldserver`.

### Pet battles: no Crows to battle on Darkmoon Island; capturable Darkmoon Rabbit

- **Found** (Four, with the island's pet list): Darkmoon Island has two wild pets to capture, Crow and
  Darkmoon Glowfly. The Darkmoon Rabbit pet should only drop from the rare Darkmoon Rabbit.
- **Cause:**
  - Darkmoon Glowfly 67329 has 14 battle pet spawns. Nothing wrong there.
  - The island had only 2 crows, and both were the plain critter 55741, so no Crow could be
    battled. The battle pet is 67443. `battlepet_wild_zone_pool` names the critter 55741 as the
    Crow's battle pet, so the wild spawn SQL (2026_11_01_50) skipped it. The Crow template 67443
    was also 1-25 in `battlepet_info`.
  - The rare Darkmoon Rabbit 58336 (drops the pet, item 80008, 11%) has no spawn. Instead a
    companion copy 59358 (guid 10655373) stood in its cave as a capturable wild pet.
- **Changed:** new `sql/fixes/world/2026_11_07_50_darkmoon_island_wild_pets.sql`:
  - the 2 existing crows (10655393, 10655394) become battle Crows 67443 that wander 3 yards;
  - 43 crows in 8 flocks from the alexkulya Pandaria 5.4.8 world DB (guids 974100001-974100043):
    one battle Crow 67443 per flock (wanders 3 yards), the rest critter crows 55741. That is 10
    battle Crows on the island;
  - Crow template 67443 set to level 1-1 in `battlepet_info`, so the zone's range decides;
  - the companion Darkmoon Rabbit 59358 spawn (10655373) is removed. The rare's own spawn is left
    to the Darkmoon Island rares fix.
  - Lhara's display pets (Darkmoon Cub, Turtle, Hatchling, Zeppelin, Monkey, Tonk) were stacked on
    one spot in front of her booth. They move to their alexkulya positions: Cub, Turtle, Hatchling and
    Zeppelin spread over the booth (Cub and Hatchling inside the 1st and 3rd cages, from Four's `.gps`), the Tonk by the Tonk Challenge, the Monkey near Carl Goodup's
    balloon cart.
  The file's header has the undo lines. No core change.
- **Status:** confirmed in game by Four on 2026-11-07.

#### To pick it up
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_07_50_darkmoon_island_wild_pets.sql | mysql -u root -p bfa_world
```
The last line prints `10 battle Crows, 35 critter crows, 14 Glowflies on Darkmoon Island`. Then
restart `worldserver`.

## 2026-11-07 (Holidays: Darkmoon Faire carousel)

Merged to main via PR #43 (2026-11-07).

### Darkmoon Faire: carousel spins empty

From Four, 2026-11-07, after two test builds ("let's just remove all the carousel mounts, and leave
it as a spinning empty platform"). World SQL `2026_11_07_06_darkmoon_carousel_empty.sql`. Run the
SQL, restart. No core change.

- **Found:**
  - The platform (gameobject 216666) is turned by the client, one clockwise turn every 12 seconds
    (TransportRotation.db2). This core has no passengers for that kind of transport, so the six
    rides stood still while the floor spun.
  - A test script that moved the rides around with the platform worked, but nobody could get off.
    The client refused Leave Vehicle ("You can't do that right now"), even though both seats
    (3326, 12198, flags `0x4200800b`) allow leaving in Four's 8.3.7 VehicleSeat.db2. A server-side
    exit (`.unaura 75648`, or clicking the ride) left the rider stuck half on.
- **Changed:** the six Darkmoon Island ride spawns (guids 1400047-1400050, 1400056, 1400058) are
  removed. If an earlier test build's SQL set `npc_darkmoon_carousel_ride` on the five templates,
  this SQL clears it. The ride script is not in `darkmoon-race.patch`.
- **Status:** confirmed in game (Four, 2026-11-07: platform empty).

## 2026-11-07 (Holidays: Darkmoon Faire races)

Merged to main via PR #42 (2026-11-07).

### Darkmoon Faire: token vendors sell one pouch and one sack

From Four, 2026-11-07 ("If there's only 2 sizes of token bags, why have 12 different bags?").
World SQL `2026_11_07_05_darkmoon_token_vendors_one_pair.sql` (after `_04`). Run the SQL, restart.
No rebuild.

- **Found:** the 12 bags are Pouch o' Tokens (5 tokens) and Sack o' Tokens (20 tokens) at six price
  tiers each (pouch 50 copper to 60 silver, sack 1s 60c to 1g 92s), all shown to everyone, so the
  cheapest pair was always the best deal. The tiers were probably level bands; the data doesn't
  say.
- **Changed:** Four chose the max-level pair. Sazz, Zina and Trixi now sell only Pouch o' Tokens
  78903 (60 silver) and Sack o' Tokens 78909 (1 gold 92 silver).
- **Status:** confirmed in game (Four, 2026-11-07).

### Darkmoon Faire: race arch and camp post names, token vendors

From Four, 2026-11-07. World SQL `2026_11_07_04_darkmoon_race_names_token_vendors.sql`. Run the
SQL, restart, delete the client Cache folder. No rebuild.

- **Found:**
  - "Arch, Start Race" (74333) and "Camp Post" (74388) at both race start lines showed their names.
    They are scenery (no gossip, no quests).
  - The Game Token vendors (Sazz Coincatcher 55264, Zina Sharpworth 55266, Trixi Sharpworth 55339)
    sold 14 Pouches/Sacks o' Tokens. Pouch o' Tokens 78904 and Sack o' Tokens 78910 hold nothing,
    and the Pandaria 5.4.8 DB doesn't sell those two. The other 12 hold 5 or 20 Darkmoon Game
    Tokens.
- **Changed:** both scenery entries are not selectable, which hides the name; 78904 and 78910 are
  off the three vendors.
- **Status:** confirmed in game (Four, 2026-11-07).

### Darkmoon races: turn-in text

From Four, 2026-11-07 (Let's Keep Racing! and More Big Racing! turned in with an empty page).
World SQL `2026_11_07_03_darkmoon_race_turn_in_text.sql`. Run the SQL, restart, delete the client
Cache folder. No rebuild.

- **Found:** none of the five race quests had a turn-in text (`quest_offer_reward`).
- **Changed:** texts from Wowhead's quest pages: "Good job, and nice time!" for The Real Race,
  Let's Keep Racing!, More Big Racing! and The Real Big Race, and the practice-race text for
  Welcome to the Darkmoon Races.
- **Not changed:** Wowhead lists no reward for the two practice runs, so they still give nothing.
  The other three give the Darkmoon Game Prize, a Prize Ticket and Darkmoon Faire reputation.
- **Status:** confirmed in game (Four, 2026-11-07).

### Darkmoon races: the practice runs are repeatable

From Four, 2026-11-07 (after finishing the races, Malle Earnhard offered nothing). World SQL
`2026_11_07_02_darkmoon_race_repeatables.sql`. Run the SQL, restart. No rebuild.

- **Found:** Let's Keep Racing! (33756, Malle) and More Big Racing! (37868, Patti) are the
  repeatable runs of the two courses (blue repeatable marker flag, no reward, no daily flag), but
  `quest_template_addon.SpecialFlags` was 0, so the core let you do each only once. The Real Race
  and The Real Big Race are dailies and come back at the daily reset.
- **Changed:** SpecialFlags 1 (repeatable) on 33756 and 37868.
- **Status:** confirmed in game (Four, 2026-11-07).

### Darkmoon races: visible tripwires

From Four, 2026-11-07 ("The Real Race felt a lot better", finished in 108 seconds; "you can't tell
which way the trap is set because you can't see a wire"). Updated `tools/bfa/darkmoon-race.patch`
and world SQL `2026_11_07_01_darkmoon_race_tripwire_wires.sql`. Rebuild, run the SQL, restart.

- **Found:** any two tripwire stakes (75044) within 14 yards of each other zapped racers, with
  nothing drawn between them.
- **Changed:**
  - New script `npc_darkmoon_race_tripwire_stake`: each stake wires itself to its nearest stake
    within 14 yards if that stake picks it too. That makes 30 pairs out of the 95 stakes; the
    other 35 are safe to pass.
  - The wire is drawn as the channel beam of Lightning Tether (33628, visual only, never cast,
    `SPELL_TRIPWIRE_BEAM`) from one stake to the other. Only racers see the stakes and beams.
  - Only a wired pair zaps you (same 2 seconds without boosts as before).
- **Status:** confirmed in game (Four, 2026-11-07: "The tripwires worked perfectly").

### Darkmoon races: banners no longer sink under water

From Four, 2026-11-07 (screenshots and the More Big Racing video: banners at sea level stand on
the sea floor). World SQL `2026_11_07_00_darkmoon_race_course_float.sql`. Run the SQL, restart,
delete the client Cache folder. No rebuild.

- **Found:** the course creatures (checkpoint banners, tripwire stakes, powerup pads, Racing
  Posts) are InhabitType 3 (ground and water), so a spawn above water sinks to the bottom.
- **Changed:** InhabitType 4 (air) for those 12 entries, so the core turns their gravity off and
  they stay at their spawn height: sea-level banners float at the surface.
- **Status:** in Four's build for the confirmed race runs of 2026-11-07; the floating banners
  weren't reported on separately.

### Darkmoon races: pickups vanish, real post positions

From Four's Let's Keep Racing video, 2026-11-07 ("Power pickups never pick up and disappear. Some
race posts are under water or pointing at the wrong direction towards the next post"). Updated
`tools/bfa/darkmoon-race.patch` (`DarkmoonIsland.cpp`). Rebuild, restart.

- **Found:**
  - The race worked (Blue at 8 tolls, Green 13, Red 17, finish), but powerup pads stayed where
    they were after giving their effect.
  - The posts' places came from wiki map coordinates with no height, so the post marker was put
    at the water or ground level under them (the Blue Post stands on a rock in the sea). The
    marker always faced east.
  - The island has its own Racing Post spawns: Blue 74362, Green 74365 (two), Red 74368 (two),
    Purple 74369. The Big Race used the Marker Pointer spawns instead, which aren't its posts:
    the Purple pointer is 300 yards from the Purple Racing Post.
  - All 51 checkpoint banners' arrows point along the course (Real Race: start, blue, green,
    red, start; Big Race: start, purple, green, red, start). Banners at sea level stand in the
    shallows on purpose (each banner gives 7 seconds of water walking), but they had sunk to the sea
    floor (fixed in `2026_11_07_00` above). The More Big Racing video shows the old Big Race
    posts: Purple at the start (reached at 0 tolls) and Red out in the sea.
- **Changed:**
  - A pad disappears when you take it and comes back after 20 seconds (`POWERUP_RESPAWN_S`).
  - Real Race posts use the Blue/Green/Red Racing Post spawns with their heights. Big Race posts
    use the Purple Racing Post and the second Green and Red Racing Posts.
  - The post marker faces the next post (or the start banner after the last post).
- **Not changed:** Let's Keep Racing! (33756) has no reward and no turn-in text in the 8.3.7
  quest data, so it ends without one.
- **Status:** confirmed in game (Four, 2026-11-07): The Real Race (108 seconds), The Real Big Race
  and More Big Racing all finished.

## 2026-11-06 (Holidays: Darkmoon Faire, second batch)

Merged to main via PR #41 (2026-11-07).

### Darkmoon Faire Deathmatch: looting the chest sends everyone out

From Four, 2026-11-06 (Master Pit Fighter done, but nobody left the pit after the chest was
looted). World SQL `2026_11_06_22_darkmoon_deathmatch_chest_exit.sql`. Run the SQL, restart.
No rebuild.

- **Found:** the Darkmoon Treasure Chest (209620) uses SmartGameObjectAI but had no script, so
  looting it only gave the loot.
- **Changed:** when the chest is looted (loot state 3), every player within 35 yd of it is
  teleported to the Deathmatch exit by Korgol Crushskull (-4300.9, 6397.3, 16.5, the target
  position of Exit Deathmatch 108923), facing away from the pit.
- **Status:** confirmed in game (Four, 2026-11-07). The Darkmoon Treasure Chest itself
  (`2026_11_06_17`) is confirmed too: Four looted Pit Fighter and finished Master Pit Fighter.

### Darkmoon Faire concert: fireworks instead of Rain of Fire

From Four, 2026-11-06 (the concert's fire never showed). World SQL
`2026_11_06_21_darkmoon_concert_fireworks.sql`. Run the SQL, restart. No rebuild.

- **Found:** the concert's FX Controller (23830) casts L70ETC Rain of Fire (42501) at 18.0, 87.9,
  142.3, 247.3 and 260.5 s into the song. 42501 is a persistent area aura whose visual does not
  play in the 8.3.7 client (`.cast self 42501` shows nothing; Lightning Cloud 42500 works). Four
  tried eight other fire spells in game; none suited the show.
- **Changed:** those five script rows (ids 3, 6, 9, 12, 15) now cast Darkmoon Firework (103740),
  which Four picked in game.
- **Status:** confirmed in game (Four, 2026-11-07).

### Grisly Trophies confirmed

Four, 2026-11-06: Grisly Trophies drop from kills while carrying the Adventurer's Guide (Test Your
Strength, `2026_11_06_17` + gossip patch from PR #40). Confirmed in game.

## 2026-11-04/05 (Holidays: calendar and schedules)

Merged to main via PR #40 (2026-11-06).

### Quest objects counted twice (Tan My Hide)

From Four, 2026-11-06: Tan My Hide (29519) finished after 2 of its 4 Staked Skins. New patch
`tools/bfa/goober-quest-credit.patch` (`src/server/game/Handlers/SpellHandler.cpp`, after
`darkmoon-race.patch`). Rebuild, restart.

- **Found:** using a "goober" object (type 10, like the Staked Skin) gives its quest credit in
  `GameObject::Use`, and the client then reports the same use (`CMSG_GAME_OBJ_REPORT_USE`), where
  HavenCore gives the credit again. Every goober quest objective counted twice. Upstream
  TrinityCore gives no quest credit on the report.
- **Changed:** the report no longer gives quest credit for goobers; other object types keep it.
  The achievement update on the report is unchanged.
- **Status:** untested in game.

### Darkmoon Faire: profession quests need only the profession

From Four, 2026-11-06 ("Stamp Thunderhorn is only a vendor here"). World SQL
`2026_11_06_20_darkmoon_profession_quests_skill.sql`. Run the SQL, restart. No rebuild.

- **Found:** all 14 Darkmoon profession quests (29506-29511, 29513-29520) have a skill condition
  asking for 75 points in the profession's parent skill (Cataclysm rule), so players below 75
  never see them offered.
- **Changed:** the conditions ask for 1 point (the profession), as in Battle for Azeroth;
  `quest_template_addon` already had RequiredSkillPoints 1.
- **Status:** untested in game.

### Darkmoon Faire: fished crates and clams open with contents

From Four's Wowhead lists, 2026-11-06. World SQL `2026_11_06_19_darkmoon_fishing_containers.sql`.
Run the SQL, restart. No rebuild.

- **Found:** Sealed Darkmoon Crate (124670), Darkwater Clam (36781), Big-Mouth Clam (7973) and
  Jaggal Clam (24476), all caught at Darkmoon Island, had no `item_loot_template` rows and opened
  empty.
- **Changed:** contents from Wowhead, each item rolling on its own. Crate: Darkmoon Firewater 97%,
  16 faire foods and drinks 6-10% each, 15 Darkmoon Draughts/Tinctures and the Healing Tonic about
  3% each, Don Carlos Tequila 0.7%, the two Divergence ones 0.2%. Darkwater Clam: Succulent Clam
  Meat 89% (1-3), Northsea Pearl 10%, Siren's Tear 1%. Big-Mouth Clam: Zesty Clam Meat 100%, Black
  Pearl 1%, Golden Pearl 1.7%, Iridescent Pearl 2.3%, Small Lustrous Pearl 1%. Jaggal Clam: Jaggal
  Clam Meat 100% (1-3), Jaggal Pearl 8%, Shadow Pearl 5%.
- **Status:** untested in game.

### Darkmoon Faire: Darkmoon Island fishing loot

From Four's Wowhead list, 2026-11-06. World SQL `2026_11_06_18_darkmoon_island_fishing.sql` (run
after `_17`). Run the SQL, restart. No rebuild.

- **Found:** Darkmoon Island (zone 5861) had no fishing loot, so every cast used the core's default
  table (Arctic Char 48%, Raw Bristle Whisker Catfish 21%, junk).
- **Changed:** zone 5861 fishing loot built from Wowhead's Darkmoon Island list (Four's CSV): 51
  catches in one group (one per cast), each at its share of Wowhead's catch counts; Darkmoon
  Daggermaw (124669) takes the rest, about 54%. Raw Rainbow Fin Albacore 9.4%, Sealed Darkmoon
  Crate 6.9%, Oily Blackmouth 3.7%, Bloated Thresher 2.5%, the Darkmoon Sealed Crates (78930, 88496)
  2.4% and 1.8%, junk about 2% each, rare catches down to 0.005%. Catches Wowhead shows at 0% are
  left out. Salty Sea Dog (73269, "Great Sea Herring" on Wowhead now) stays at 29% on top, only
  for Spoilin' for Salty Sea Dogs.
- **Not covered:** Sealed Darkmoon Crate (124670) and the Big-Mouth, Darkwater and Jaggal Clams
  have no contents in our DB, so they open empty.
- **Status:** untested in game.

### Darkmoon Faire: four quests that could not be finished

From Four's questions, 2026-11-06. World SQL `2026_11_06_17_darkmoon_quest_items.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`). Rebuild, run the SQL, restart.

- **Test Your Strength (29433), found:** it needs 250 Grisly Trophies (71096) and nothing gave
  them. On retail one comes from every kill of an enemy that gives experience or honor while you
  carry the Darkmoon Adventurer's Guide (71634). **Changed:** `playerscript_darkmoon_grisly_trophy`
  adds a trophy on each such kill (creature or player) while the quest is in progress and the
  guide is in your bags. Only your own killing blows count; the core has no kill hook for pets.
- **Spoilin' for Salty Sea Dogs (29513), found:** the Salty Sea Dog (73269) was in no fishing loot
  and Darkmoon Island had no fishing loot at all (you got the default fish). **Changed:** fishing
  loot for zone 5861: Salty Sea Dog, 30%, only while on the quest (Pandaria DB: 20.9%). Other
  catches are the default fish as before.
- **Tan My Hide (29519), found:** the Staked Skins (209276) were never placed. **Changed:** the 19
  skins around the tents from the Pandaria DB, guids 974000003-974000021.
- **Master Pit Fighter (29761), found:** Pit Fighter (74034) only comes from the Darkmoon Treasure
  Chest (209620, 95%), which was never placed. **Changed:** one chest in the Deathmatch pit, back
  2 hours after it is looted (Pandaria value), guid 974000022.
- **Status:** untested in game.

### Darkmoon Faire: Firebird rings kept over the island

From Four's retest, 2026-11-06. Updated `tools/bfa/darkmoon-faire-gossip.patch`
(`DarkmoonIsland.cpp`). Rebuild, restart. No SQL.

- **Confirmed:** Carl Goodup's cart spacing (hotfix seat 10236), Rinling's targets without names,
  Firebird's height and quest.
- **Firebird, found:** rings could go out over the ocean. **Changed:** rings stay inside the area
  Four marked (X -4454 to -4144, Y 6151 to 6361), at a height of 104 to 115 (at least 10 over the
  ground), always 50 yd from the player (Four's call), with the same clearance checks. The first
  8 tries go ahead of the player, the next 8 toward the middle of the area; if all fail, the ring
  goes near the middle.
- **Status:** confirmed in game by Four, 2026-11-06 ("That was perfect").

### Darkmoon Faire: Firebird rings further out, gallery names, Carl's cart spacing

From Four's retest, 2026-11-06. World SQL `2026_11_06_16_darkmoon_gallery_unselectable.sql`,
hotfix SQL `sql/fixes/hotfixes/2026_11_06_00_darkmoon_balloon_cart_seat.sql` (run against
`bfa_hotfixes`), updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`). Rebuild,
run the SQL, restart, delete the client Cache folder.

- **Confirmed:** Firebird's Challenge quest works (rings keep coming); Carl's balloons sit on the
  cart.
- **Firebird, found:** rings came too close (20-30 yd) and some were inside the roller coaster.
  **Changed:** rings go 35-50 yd ahead, at least 10 yd over the ground, and only where the line from
  the player and the ring's 5 yd circle (both ways, and up/down) are clear of buildings and
  objects; up to 8 tries, else 40 yd straight ahead and 15 yd over the ground.
- **Shooting Gallery, found:** the name flags from `2026_11_06_15` did not hide the names either.
  The client does not draw names on units that can't be selected (Carl's cart and balloon bunny
  show none). **Changed:** 54231 unit_flags `|= 0x02000000` (not selectable); the Shoot script
  picks its target itself, so hits still count.
- **Carl Goodup, found:** the cart sits in seat VehicleSeat 10236, 0.7 yd in front of Carl, so his
  name overlapped the balloons. **Changed:** hotfix row for seat 10236 with AttachmentOffsetX 1.0
  (other fields are the client's values), hotfix_data id 9110236, table hash 0xD4A85CEB. Only
  Carl's vehicle (1769) uses this seat.
- **Status:** untested in game.

### Darkmoon Faire: Firebird rings keep coming, gallery names hidden, balloons raised

From Four's retest, 2026-11-06. World SQL `2026_11_06_15_darkmoon_names_rings_balloons.sql`,
updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`). Rebuild, run the SQL,
restart, delete the client Cache folder.

- **Confirmed:** Tonk Commander sends you back to where you started; Shooting Gallery is fast
  enough for 25/25.
- **Firebird's Challenge, found:** one ring came, it counted, then nothing. Wings of Flame
  (170819) lasts 2.5 s and starts one 10 s flight (170820), which brings one ring. Each ring
  caught casts Blazing Ring (170823); its script effect (effect 1) is what renews the flight, and
  it had no script. **Changed:** `spell_darkmoon_firebird_blazing_ring` renews the flight (170820)
  on each ring caught, which brings the next ring. Miss rings for 10 s and the flight ends.
- **Shooting Gallery, found:** the empty name from `2026_11_06_14` did not hide the name.
  **Changed:** the name is back and target 54231 has type_flags `0x40000000` (do not draw the
  name) and `0x00100000` (no name plate).
- **Carl Goodup, found:** the balloons on the cart itself sat at the cart's base. The cart's seat
  (VehicleSeat 10237) is 1 yd up, which is where the Balloon Cart Bunny (55307) belongs.
  **Changed:** the cart (55306) has a script, `npc_darkmoon_balloon_cart`, that seats the bunny
  once the cart rides on Carl (up to 5 tries, 2 s apart); the bunny carries the balloons again
  and the cart's aura is back to `96847`.
- **Status:** untested in game.

### Darkmoon Faire: Tonk return point, faster Shooting Gallery, Carl's balloons

From Four's retest, 2026-11-06. World SQL `2026_11_06_14_darkmoon_gallery_names_balloons.sql`,
updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`, `DarkmoonTonk.cpp`).
Rebuild, run the SQL, restart, delete the client Cache folder.

- **Confirmed:** Shooting Gallery credit works (Quick Shot, 5 Darkmoon dailies, 5 different games,
  Blastenheimer Bullseye unlocked); Carl pushes his cart; Tonk Commander "way better".
- **Tonk Commander, found:** at the end of the game the player was put back in the tonk pen.
  **Changed:** Finlay remembers where each player stood when they started (the "Ready to play!"
  gossip) and the end of the game sends them back there; the old console spot is only a fallback.
  The tonk now lasts 62 s (was 60 s) so the game ends before the tonk despawns under the player.
- **Shooting Gallery, found:** a new marked target came every 5 s, so only 12 showed up in the
  60 s game and 25 hits were impossible (Four's best: 12/25). **Changed:** a new round every 2 s
  (targets last 2 s), so up to 30 marked targets per game. The target name (54231) is now empty, so
  no name shows over the targets.
- **Carl Goodup, found:** the balloons stayed where the cart was made. They are the Balloon Cart
  Contents aura (103320) on the Balloon Cart Bunny (55307), which should ride on the cart as a
  second accessory; that second step does not follow the cart. **Changed:** the aura is on the
  cart itself (55306 auras `96847 103320`), the bunny accessory row and the cart's spellclick row
  are removed.
- **Status:** untested in game.

### Darkmoon Faire: concert in sync, Carl's cart, one cannon target, Shooting Gallery aim

From Four's retest, 2026-11-06. World SQL `2026_11_06_12_darkmoon_concert_sync.sql`,
`2026_11_06_13_darkmoon_balloon_cart_spellclick.sql`, updated `tools/bfa/darkmoon-faire-gossip.patch`
(`DarkmoonIsland.cpp`, `DarkmoonTonk.cpp`). Rebuild, run the SQL, restart.

- **Confirmed:** Bergrisst's constant "Armor" sound is gone; the show plays and the band vanishes
  at the end; Tonk enemies firing back works ("way better").
- **Concert, found:** the song is driven by [DND] L70ETC FX Controller (23830): on spawn it plays
  sound 11803 after 9.4 s, runs the lightning (42500), earthquake (42499) and rain of fire (42501)
  effects, and despawns after 275 s; it comes back after its spawn time (120 s), which starts the
  next song. The band's 5-minute loop from `2026_11_06_09` ran on its own clock, so they drifted
  apart (band showing up mid-break, vanishing mid-song).
- **Changed:** 1 s after each spawn the controller sends data 1 to the five band members within
  30 yd; each member then runs its show as a timed action list (`<entry>01`, same steps and times
  as its old rows, counted from the controller's spawn). The controller respawns 30 s after
  despawning (was 120 s), so the break is about 50 s. Thunder-Skins' separate on-spawn drum list
  is dropped. Same entries play in Shattrath and Blackrock Depths and follow their own controller.
- **Fire, found:** the controller does cast L70ETC Rain of Fire (42501) five times per song (18,
  88, 142, 247 and 260 s); same spell setup as the lightning except for the visual. Not changed.
- **Carl Goodup, found:** still no cart: the core only loads a `vehicle_template_accessory` row
  when the vehicle has an `npc_spellclick_spells` row, so both rows from `2026_11_06_10` were
  skipped. **Changed:** Ride Vehicle (46598) spellclick rows for 55305 and 55306 (Pandaria DB);
  players still can't click them (no spellclick npcflag).
- **Tonk Commander, changed:** the cannon hits one target per shot: the Tonk Target, Enemy Tonk or
  MiniZep within 30 yd and 60 degrees that is closest to straight ahead.
- **Shooting Gallery, found:** the targets had health but nothing hit them: Shoot (101872) is a
  cone with the same tiny radius problem as the tonk cannon. The middle target spawned at z 12.57,
  under the counter. **Changed:** Shoot hits the gallery target closest to where you face (30 yd,
  90 degrees); the middle spot is z 13.30 and the third spot's 12.24 variant is 13.24.
- **Status:** untested in game.

### Darkmoon Faire: Tauren Chieftains, Carl Goodup's cart, Tonk enemies fire back

From Four, 2026-11-06. World SQL `2026_11_06_09_darkmoon_tauren_chieftains.sql`,
`2026_11_06_10_darkmoon_balloon_cart.sql`, `2026_11_06_11_darkmoon_tonk_cannonballs.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonTonk.cpp`). Rebuild, run the SQL, restart.

- **Tauren Chieftains, found:** the band (Bergrisst 23619, Chief Thunder-Skins 23623, Mai'Kyl
  23624, Samuro 23625, Sig Nicious 23626) plays a ~280 s show of one-shot timed SAI events. It ran
  once after a restart; at 280.8 s they all cast Greater Invisibility (16380) and nothing brought
  them back. Each member's first event casts 89344, labelled "Clear Target Auras" but in 8.3.7
  89344 is "Armor" (an aura with a sound); Bergrisst's copy repeated every second, so it played
  constantly and kept him visible.
- **Changed:** every timed event repeats every 300 s (the show loops with a 20 s break), and the
  89344 casts now remove Greater Invisibility instead, so each member comes back at their
  entrance flare.
- **Not known:** where the concert music comes from. No row in the DB plays a sound; it may be the
  stage's area music in the client.
- **Carl Goodup, found:** Carl (55305, vehicle 1769) should carry the Balloon Cart (55306, vehicle
  1770), which carries the Balloon Cart Bunny (55307, the balloons). The dump had no vehicle
  accessories for them (the Pandaria 5.4.8 DB does), so the cart stood alone and could be
  clicked, and the balloons wandered by themselves.
- **Changed:** `vehicle_template_accessory` 55305 -> 55306 -> 55307 (seat 0), the separate cart
  and bunny spawns (guids 1400353, 1400354) removed, the cart not selectable, Carl wanders up to
  5 yd (Pandaria DB value).
- **Tonk Commander, changed (Four's choice):** every Enemy Tonk (54642) and MiniZep (54643) has a
  25% chance every 3-4 s to fire Cannon Blast (102227) at the nearest player tonk within 40 yd.
  The cannonball lands where the tonk was (it flies at 6 yd/s, so it can be dodged).
  `spell_darkmoon_enemy_tonk_cannon_blast` stuns a tonk within 4 yd of the landing spot for 2 s
  (Death Stun 102229) and takes 1 Tonk Target credit off its driver (quest 29434, only while
  the quest is incomplete).
- **Status:** Bergrisst's sound and the enemy cannonballs confirmed by Four, 2026-11-06; Carl's
  cart and the concert loop needed `2026_11_06_12` / `13`.

### Darkmoon Faire: retest fixes (Firebird, Ring Toss, Shooting Gallery, Tonk Commander)

From Four's retest, 2026-11-06. World SQL `sql/fixes/world/2026_11_06_08_darkmoon_game_targets.sql`,
updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`, `DarkmoonTonk.cpp`). Rebuild,
run the SQL, restart.

- **Update steps changed:** the earlier "undo the old patch version, apply the new one" loop could
  undo an older version from a newer tree (the Maxima/Mola/Fozlebub parts are the same in every
  version), which left Four's tree half-patched: French gossip again, no gossip on Jessica,
  Finlay and Rinling. Darkmoon updates now reset `src/server/scripts/DarkmoonIsland` and apply
  `darkmoon-faire-gossip.patch` then `darkmoon-race.patch` (the only two patches in that folder).
- **Firebird's Challenge, found:** the first ring appeared but never counted, and no more came.
  The ring and summon code required Wings of Flame (170819) on the player; the flight is the
  170820 aura it keeps refreshing. **Changed:** either aura counts, and each ring also checks
  every update whether its owner is within 6 yd (a fast flier can pass through between two
  target-list updates).
- **Ring Toss, found:** the ring bar stayed after the last ring or after turning in Target: Turtle
  (29455). **Changed:** Jessica removes 102058 when you have had 0 rings for two checks (2 s, so
  the last ring lands first; whisper "You're out of rings!") and when you turn in 29455.
- **Shooting Gallery, found:** the targets (54231) spawned dead: level 1 with HealthModifier 0.01
  is 0 health. Shoot (101872) had no `spell_script_names` row, so hits never gave credit. The
  decoy entry 54225 does not exist in 8.3.7, so only the marked target was summoned. The gun
  stayed after the 60 s game. **Changed:** HealthModifier 1; script name and a target condition
  (creature 54231) for 101872; decoys are 54231 too and only the round's marked target (the one
  that casts Marked! 102341) gives credit, once; at the end of the game Rinling removes 101871
  from players within 30 yd ("Time's up!"), and turning in He Shoots, He Scores! (29438) removes it.
- **Tonk Commander, found:** Tonk Targets (33081) spawned dead too (same HealthModifier 0.01), and
  the Cannon (102292) only reached things touching the tonk. **Changed:** HealthModifier 1;
  `spell_darkmoon_tonk_cannon` hits Tonk Targets, Enemy Tonks and MiniZeps up to 30 yd in a
  60 degree cone in front of the tonk.
- **Not changed yet:** Enemy Tonks and MiniZeps don't shoot back (their Cannon Blast 102227 drops a
  cannonball whose Bombs Away 102211 is a dummy with no script) and show friendly (faction 1616).
- **Status:** untested in game.

### Darkmoon Faire: Horde Citizens and the Champions

From Four, 2026-11-06 ("Horde Citizens should appear as horde races. Champion Faesrol, Champion
Isimonde - lower their aggro range to if a player gets right up on them"). World SQL only; run it
and restart. No rebuild.

- **Found:** Horde Citizen (55348) used the Stormwind citizen models 1501/21621, the same as the
  Alliance Citizen (55347). Their SAI casts Citizen Costume (71084), a transform with no creature
  set, which the core does nothing with.
- **Changed:** `sql/fixes/world/2026_11_06_06_darkmoon_horde_citizens.sql` gives 55348 eight
  models with equal chance: orc 1370/31416 (Orgrimmar Citizen), troll 2588/2589 (Troll Citizen),
  blood elf 18211/18212 (Silvermoon Citizen), Forsaken 34459/25893 (Undercity Citizen).
- **Found:** Champion Faesrol (55732) and Champion Isimode (55733) by the Tonk Commander area are
  level 80 with SmartAI but no rows, so they pulled with the normal aggro radius (up to 45 yd
  against low-level players).
- **Changed:** `sql/fixes/world/2026_11_06_07_darkmoon_champions_aggro.sql`: both go defensive on
  spawn/reset and attack a hostile player that comes within 5 yd (SAI out-of-combat LOS, max 5,
  1 s cooldown; condition: invoker is a player, so they don't start on each other). They still
  fight back when attacked.
- **Status:** Horde Citizens confirmed in game by Four, 2026-11-06; Champions untested.

### Darkmoon Faire: Firebird's Challenge (Ziggie Sparks)

From Four, 2026-11-06 ("Ziggie Sparks, Firebird challenge, no rings"). World SQL
`sql/fixes/world/2026_11_06_05_darkmoon_firebird_rings.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`). Rebuild, run the SQL, restart.

- **Found:** "Ready to fly!" casts Wings of Flame (170819), which re-casts 170820 every 2.5 s
  (flight, flight speed) and with it Summon Rings (170817). 170817 is a script effect with no
  script, so nothing was summoned. The ring spell (170815) creates areatrigger misc 3069, which had
  no `spell_areatrigger` / `areatrigger_template` rows. The quest needs 15 Darkmoon Faire Ring
  Credit (85559), given by Blazing Ring (170823).
- **Changed:**
  - `spell_darkmoon_firebird_summon_rings` (170817): while you have Wings of Flame, puts a ring
    (170815) 20-30 yd ahead of you (up to about 35 degrees to either side, 6 yd below to 8 yd
    above you, never closer than 6 yd to the ground).
  - `at_darkmoon_firebird_ring` (areatrigger 3069, 5 yd sphere): flying through your own ring
    casts Blazing Ring (170823, 1 credit) and removes the ring. Rings you miss fade after 15 s.
  - SQL: `spell_script_names` row for 170817, `areatrigger_template` 3069 and `spell_areatrigger`
    3069 -> 3069 (id 3069 was unused).
- **Not known:** whether the client draws the ring from 170815's own visual; if you can fly
  through invisible rings and get credit, the visual is the remaining gap.
- **Status:** untested in game.

### Darkmoon Faire: Tonk Commander (Finlay Coolshot)

From Four, 2026-11-06 ("Tonk doesn't attack or kill anything, player returns as the tonk on the
battlefield at the end. Enemy tonks leave the arena."). World SQL
`sql/fixes/world/2026_11_06_03_darkmoon_tonk_commander.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonTonk.cpp`). Rebuild, run the SQL, restart.

- **Found:**
  - The steam tonk's Cannon (102292) picks targets by entry in a cone and had no target
    conditions, so it hit nothing.
  - A Tonk Target (33081, the quest's credit, 30 needed) only despawned when shot; nothing gave
    credit.
  - Enemy Tonks (54642) and MiniZeps (54643) had SmartAI with no script, chased the player's tonk
    out of the arena, and respawned after 2 minutes.
  - At the end of the 60 s game nothing ended it: when the tonk (54588) timed out the player was
    left on the battlefield with the Tonk! bar (102178).
- **Changed:**
  - Conditions on 102292 effect 0: creatures 33081, 54642, 54643.
  - A shot Tonk Target, Enemy Tonk or MiniZep gives credit 33081 to the tonk's driver (SAI kill
    credit to the invoker; for a vehicle that is its passenger). Targets despawn, enemy tonks and
    MiniZeps die and respawn after 10 s (was 120). Enemy tonks and MiniZeps are passive.
  - Finlay's end-of-game event removes 102178, takes the player out of the tonk, puts them back at
    the consoles (-4127.5, 6327.0, 13.12) and despawns the tonks.
- **Status:** untested in game.

### Darkmoon Faire: Ring Toss (Jessica Rogers)

Four picked Ring Toss next (2026-11-06). World SQL `sql/fixes/world/2026_11_06_01_darkmoon_ring_toss.sql`,
updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonIsland.cpp`, `spell_ring_toss`). Rebuild,
run the SQL, restart.

- **How the game works (retail):** Jessica gives you 10 rings (the bar shows them) and a one-button
  bar. Aim the ring at Dubenko (54490), the turtle swimming in the pond next to her; 3 rings on his
  shell complete Target: Turtle (29455).
- **Found:** the ring's landing spell (181458) has no target conditions, so it hit every unit where
  it landed, and `spell_ring_toss` gave the quest credit (54495) for any unit hit, the thrower
  included. Dubenko's SAI (id 1, invoker cast 101807) gave a second credit for each real hit.
- **Changed:** condition on 181458 effect 0: only creature 54490. The handler only credits (once)
  when the hit unit is Dubenko, and still plays the ring-on-shell visuals (101697, 101737). Dubenko's
  SAI credit row is deleted.
- **Found (Four, 2026-11-06, with a screenshot):** the ring button failed with "Requires Standing
  at the Ring Toss Booth"; the Shooting Gallery failed the same way ("Requires Standing at the Booth
  Counter"). Both spells need a spell focus gameobject near the player, and neither was spawned.
- **Changed:** world SQL `sql/fixes/world/2026_11_06_02_darkmoon_booth_spell_focus.sql` spawns
  301114 "Standing at the Ring Toss Booth" (focus 1729, 20 yd) on Jessica (-4287.87, 6309.00,
  13.20, guid 974000001) and 300129 "Standing at the Booth Counter" (focus 1471, 10 yd) at Rinling's
  counter (-4078.42, 6354.07, 13.08, Pandaria 5.4.8 DB position, guid 974000002). Both are invisible.
- **Status:** confirmed in game by Four, 2026-11-06 ("Ring toss played well").
- **Found (Four, 2026-11-06):** the ring aura stays on you after you walk away from the booth, and
  Dubenko never moves. His spawn (guid 1400112) had MovementType 2 (waypoints) with no path.
- **Changed:**
  - `DarkmoonIsland.cpp`: Jessica now has an AI that checks every second; a player more than 20 yd
    from her loses the Ring Toss aura (102058) and gets the whisper "You left the Ring Toss booth.
    Game over!". Rinling does the same for the Shooting Gallery aura (101871) past 12 yd ("You
    left the Shooting Gallery. Game over!").
  - World SQL `sql/fixes/world/2026_11_06_04_darkmoon_dubenko_wanders.sql`: Dubenko wanders up to
    3 yd from his spot (MovementType 1, spawndist 3; template MovementType 0).
- **Status:** leaving the booth and Dubenko's wandering confirmed in game by Four, 2026-11-06.

### Darkmoon Faire: Humanoid Cannonball (Maxima Blastenheimer)

From Four, 2026-11-05 ("It flings you out towards the ocean ... you finally splash down much further
out. I don't know what this is"). Updated `tools/bfa/darkmoon-faire-gossip.patch`
(`DarkmoonCanon.cpp`, target bunny script `npc_darkmoon_canon_target`). Rebuild, restart.

- **How the game works (retail):** Maxima fires you from the cannon toward a target floating in the
  water to the south-west (bunny 33068 at -4478, 6221). Magic Wings (102116) slows your fall, so you
  glide well past the target unless you press the one button on your bar, Cancel Magic Wings
  (102120), while you are over it. Landing within 3 yards = Bullseye (5 points, achievement
  Blastenheimer Bullseye), 10 yards = Great Shot (3), 30 yards = Poor Shot (1). The quest (29436)
  needs 5 points.
- **Found:** the target bunny only checked players within 30 yards that had sunk below z 0. A long
  shot (the normal result without the button) never ended: no result, and the Cannon Blast override
  bar (102121) stayed. The bunny never put up its target rings (Darkmoon Cannon Target Area Aura
  A/B/C, 62171/62174/62178), so there was nothing to aim at.
- **Changed:** the bunny keeps the three target-area auras up (rechecked every 5 s) and stays
  loaded. Every 0.2 s it checks every launched player on the island: once they are in the water, or
  on land and no longer falling (after 2 s), they get their score and lose Cannon Blast and Magic
  Wings. A landing more than 30 yards out ends the shot with a whisper ("You missed the target! Use
  Cancel Magic Wings when you are over it.") and no points.
- **Found (Four, 2026-11-06):** "Speaking to maxima and saying you're ready while mounted locks up
  the event ... you remain inside the cannon".
- **Changed:** Maxima now removes mounts (`SPELL_AURA_MOUNTED`) and shapeshift forms before putting
  you in the cannon.
- **Status:** the cannon game is confirmed in game by Four (2026-11-06, "otherwise, that worked").
  The dismount fix is untested.

### Darkmoon Faire: NPC audit (gossip, flags, quests, vendors)

From Four, 2026-11-06 ("review every quest giver and merchant, make sure they're flags are
correct, interactable, and have quests that lead to something. ensure their gossips lead
somewhere, locales are enUS", "check items too for merchants/vendors"). Checked all 62 creatures on
Darkmoon Island with a gossip, quest or vendor flag, and the Faire's event spawns elsewhere. World
SQL `sql/fixes/world/2026_11_06_00_darkmoon_faire_npc_audit.sql`, updated
`tools/bfa/darkmoon-faire-gossip.patch` (now also `DarkmoonIsland.cpp` and `DarkmoonTonk.cpp`).
Rebuild, run the SQL, restart.

- **Found:**
  - Jessica Rogers (Ring Toss), Rinling (Shooting Gallery) and Finlay Coolshot (Tonk Challenge)
    sent npc_text ids that don't exist (54485/54486, 23002/23003, 54605/54606, and 54603 for "no
    token"), so their pages showed placeholder text.
  - Gossip menus 8849 (Silas Darkmoon), 13012 (Jessica), 13018 (Mola) and the "how to play" menus
    13013/13065/13066 had options but no text row.
  - Maxima and Mola had no "How do I play?" option.
  - Ziggie Sparks (Firebird's Challenge) had gossip menu 0, so her "Ready to fly!" menu and its
    SAI never showed.
  - Christoph VonFeasel (pet tamer, quest 36471) had no gossip flag, so "Let's do battle!" could
    not show.
  - Chronos offered "DEPRECATED: Putting the Carnies Back Together Again" (29512).
  - The old Outland Faire (26 creatures, 120 gameobjects in Terokkar Forest) still spawned with the
    Faire event.
  - Vendors: every Faire vendor's list is a superset of the Pandaria 5.4.8 list (the heirloom
    vendor uses the newer heirloom items). Prize vendors (tickets) have no gold-priced items. Whether
    each item exists in this build's Item.db2 can only be seen in the worldserver's DB error log.
  - Every quest giver's quests have an ender, and all texts are English. Quests whose objective has
    no source yet: Test Your Strength 29433 (Grisly Trophy 71096 drops nowhere), Spoilin' for Salty
    Sea Dogs 29513 (no fishing loot for 73269), Tan My Hide 29519 (Staked Skin 209276 not spawned),
    Master Pit Fighter 29761 (74034 only from an unspawned object), Firebird's Challenge 36481
    (untested).
- **Changed:**
  - The three game hosts use their real texts (18284/18286, 7397/18353, 18290/18352). "No token" is
    now a whisper. "Alright." is now "I understand.", and the Shooting Gallery options match the
    database ("How does the Shooting Gallery work?", "Let's shoot!").
  - Maxima ("How do I use the cannon?", text 7790) and Mola ("How do I play Whack-a-Gnoll?", text
    18350) get an instructions page.
  - The missing gossip_menu rows are added (texts from the Pandaria DB).
  - Ziggie uses menu 16970. Her instructions menu 16972 gets npc_text 24704 (a guess from the text
    ids).
  - Christoph gets the gossip flag. Chronos no longer offers 29512.
  - The Terokkar spawns are removed; copies are kept in `zr_dmf_terokkar_creature` and
    `zr_dmf_terokkar_gameobject`.
- **Status:** untested in game.

### Darkmoon Faire: Whack-a-Gnoll barrels and score bar

From Four, 2026-11-05 ("still not fast enough. Not accurately incrementing the count on the artwork
either. Can get 26/30 - just not enough spawning"). Updated `tools/bfa/darkmoon-faire-gossip.patch`
(`DarkmoonWhackGnoll.cpp`). Rebuild, restart.

- **Found:** a barrel only took a new gnoll once its "ok to hit" aura (101996) ran out, so whacked
  barrels stayed blocked and most spawn ticks found no free barrel. The score bar (alternate power)
  was set once at the start and then only moved by the credit spell's energize, so it drifted from
  the quest count.
- **Changed:** a barrel is free as soon as no gnoll, doll or boss is alive in it (2 yd). Gnoll every
  1 s, boss every 7 s (doll stays 5 s). The score bar is set to It's Hammer Time's count at the
  start, after every whack, and once a second while you play.
- **Found (second test, "you mention a boss, but i have yet to see one. 28/30", and a video):** the
  summon spells left every unwhacked gnoll standing, so all 9 barrels filled and the 1 s gnoll
  timer took each freed barrel before the bonus gnoll (54549) or the baby (54466) found one.
  Whacked gnolls left a grey corpse in the barrel, and swinging at the corpse scored again.
- **Changed:** gnolls, babies and bonus gnolls are summoned straight from the barrel and leave
  after 4 s. A bonus gnoll or baby that finds no free barrel tries again after 0.5 s instead of
  waiting for its next turn. Dead gnolls no longer count as targets, and a whacked gnoll is
  removed after 0.5 s.
- **Status:** confirmed in game by Four (2026-11-05, "That worked perfectly!").

### Darkmoon Faire: Whack-a-Gnoll pace and reset

From Four, 2026-11-05 ("You can only realistically get 15/30 at the current rate", "You can not
succeed the first time, and the quest remains along with the count you had. This should fail").
Updated `tools/bfa/darkmoon-faire-gossip.patch` (`DarkmoonWhackGnoll.cpp`). Rebuild, restart.

- **Found:** the game spawns a gnoll every 3 s, a doll every 6 s and a boss gnoll every 10 s, so the
  one-minute game holds about 20 gnolls and 6 bosses at best. Points carried over to the next
  game, but the quest is "score 30 points in a minute".
- **Changed:** gnoll every 1.5 s, doll every 5 s, boss every 9 s. When a game ends with It's Hammer
  Time (29463) still incomplete, its count goes back to 0.
- **Status:** untested in game.

### Darkmoon Faire: Game Prize hang, Let's Keep Racing

From Four, 2026-11-05 ("Opening the Darkmoon Game Prize hangs, the box is greyed out", "Let's keep
racing - nothing happens. Crossing the start line doesn't start the race"). World SQL
`sql/fixes/world/2026_11_05_08_darkmoon_prize_ticket_as_quest_reward.sql`, updated
`tools/bfa/darkmoon-race.patch`.

- **Found:**
  - The ticket row from `2026_11_05_07` (currency 515 as loot of item 93724) hangs the client: this
    core can't hand a currency out of an item's loot window.
  - Malle also gives Let's Keep Racing! (33756), a repeatable run of the Real Race course
    (blue, green, red). The race script didn't know the quest.
- **Changed:**
  - SQL removes the currency loot row and gives 1 Darkmoon Prize Ticket (currency 515) as
    `RewardCurrencyID1` on every quest that rewards the Game Prize (29434, 29436, 29438, 29455,
    29463, 36481, 37819, 37910, 37911), as in the Pandaria 5.4.8 DB. The Game Prize keeps its
    old rare contents and is still often empty.
  - `darkmoon-race.patch`: Let's Keep Racing! uses Malle's start banner and the Real Race posts
    (no achievements, those are for The Real Race).
- **Status:** untested in game.

### Darkmoon Faire: course names, empty Game Prize

From Four, 2026-11-05 ("Malle's race worked, but I can still see the doodad's names", "the reward,
Darkmoon Game Prize, has been empty twice"). World SQL
`sql/fixes/world/2026_11_05_07_darkmoon_race_names_and_game_prize.sql`. Run the SQL, restart, delete
the client's Cache folder.

- **Found:**
  - The course bunnies have visible models (checkpoint banners, tripwire stakes, pads) and no
    name-hiding flags, so racers saw "Powerup Bunny Checkpoint" and the like over the course.
  - Darkmoon Game Prize 93724 has 14 loot rows, all independent chances of 0.5% to 8.6% (about
    29% in total), so it opened empty most of the time. The Darkmoon Prize Ticket that retail
    always puts in it (currency 515; 1 per game daily in the Pandaria 5.4.8 DB) was missing.
- **Changed:**
  - 14 course entries (75718, 75044, 74153, 74157, 74678, 74800, 74872, 75063, 74536,
    74260-74263, 74420): `type_flags` |= 0x40100000 (no name, no nameplate), `unit_flags` |=
    0x02000000 (not selectable).
  - `item_loot_template` (93724, -515, chance 100, count 1): one Darkmoon Prize Ticket in every
    prize. A negative `Item` is a currency in this core's loot loader.
- **Status:** untested in game.

### Darkmoon Faire: Dusty's strider ride at the arrival hill

From Four, 2026-11-05 ("the mechastrider mount handler at the entrance isn't interactable", "Dusty
Brandom doesn't interact"). World SQL `sql/fixes/world/2026_11_05_06_darkmoon_strider_ride.sql`.
Run the SQL, restart.

- **Found:** "Dusty" Brandom (68492, Tallstrider Handler) and two Darkmoon Striders (68491) stand
  where you arrive on the island. On retail the striders give anyone a free ride down the Darkmoon
  Path to the Faire. Here Dusty had `npcflag` 0 (no gossip) and an SAI line that talks with no
  text; the striders had no spellclick. (Earlier notes in this PR wrongly tied Dusty to the races.)
- **Changed** (values from the Pandaria 5.4.8 DB): Dusty `npcflag` 1, `gossip_menu_id` 15306 (menu
  and npc_text 21955 already in the DB), `unit_flags` 768, SAI removed. Striders `npcflag`
  16777216 (spellclick), `unit_flags` 33536, `npc_spellclick_spells` (68491, 134931, 3, 0):
  clicking one mounts you on a Darkmoon Strider (spell 134931).
- **Status:** untested in game.

### Darkmoon Faire: the strider races

From Four, 2026-11-05 ("let's start on the strider race"). Core patch `tools/bfa/darkmoon-race.patch`
(after `darkmoon-faire-gossip.patch`), world SQL `sql/fixes/world/2026_11_05_05_darkmoon_race_course.sql`.
Rebuild, run the SQL, restart.

- **Found:**
  - Malle Earnhard (74056: Welcome to the Darkmoon Races 37819, The Real Race 37910) and Patti
    Earnhard (90473: More Big Racing! 37868, The Real Big Race 37911) give the race quests, but
    nothing on the server runs a race. Retail does it with server-side spells and area triggers
    that aren't in the client files, and this database has no rows for them.
  - The client files do have the pieces: the objective credit entries (start 74536, posts
    73984/73988/74030/74031, end 74004, passed 74299), the Racing Strider mount (179750), the
    course bunnies' visual spells, Invis to Non-Racers (179303) / On a Trial (149669), and the
    achievement spells (criteria "cast spell" 179420-179617, e.g. Darkmoon Racer Roadhog 9761).
  - The Real Race posts aren't spawned. Their map coordinates come from the wiki's route guide
    (blue 26.3,66.9; green 29.5,46.1; red 43.5,50.1). Fitting its 16 checkpoint coordinates to our
    checkpoint banners matched all of them within 2 yards, which gives blue (-4152.4, 6779.6),
    green (-3894.5, 6720.1), red (-3944.1, 6459.7). The Big Race posts are the Marker Pointer
    spawns: purple 74263, green 74261, red 74262.
- **Changed:**
  - `darkmoon-race.patch` adds a player script to `DarkmoonIsland.cpp`. With a race quest in
    your log, running through the start banner (Malle's for the Real Race, Patti's for the Big
    Race) uses a Darkmoon Game Token, mounts you on the Racing Strider and starts the race. Touch
    the posts in order (a marker shows the next one), then ride back through the banner.
  - The bell tolls every 5 seconds. Your toll count is shown at each post and at the finish, and
    decides the achievements: Real Race within 25/20/15/11 tolls, Big Race within 40/35/30/25/20,
    plus Darkmoon Race Enthusiast for the first race. The toll length isn't in the client data;
    5 seconds is a guess from the achievement limits and is easy to change (`RACE_TOLL_MS`).
  - On the course: checkpoint banners give +100% speed for 3 seconds and 7 seconds of water
    walking (once each per race), dash and loot pads +100% speed for 4 seconds, jump and rocket
    pads throw you forward, blink pads move you 20 yards ahead, rotating pads pick one of
    those. Running between two tripwire stakes (within 14 yards of each other) takes your mount
    speed away for 2 seconds.
  - The race is canceled (objectives reset, token not refunded) if you die, get off the strider,
    leave the island, log out or take longer than 10 minutes.
  - SQL: removes spawn group 450 from `2026_11_05_03`, so the course spawns again, and gives the
    course bunnies (checkpoints, tripwire stakes, powerup pads) Invis to Non-Racers 179303 plus
    their powerup visual. Only racers (and GMs) see them.
  - The Racing Strider's buttons, from Four's OverrideSpellData.db2 (bar 569), are scripted as
    `spell_darkmoon_racer_button`: **Jump To Banner** (179748) leaps to the nearest checkpoint
    banner ahead of you within 100 yards and keeps you safe from tripwires for 4 seconds;
    **Lasso Powerup** (316043) uses the nearest powerup pad within 25 yards at once; **Jump To
    Racer** (179804) leaps to the nearest other racer ahead. Cooldowns are the client's.
- **Not done:** the Rocketeer, Powermonger and Wanderluster racers (toys) aren't supported, only
  the Racing Strider.
- **Status:** untested in game.

### Darkmoon Faire: Selina, jugglers, Maxima, citizens

From Four, 2026-11-05. Core patch `tools/bfa/darkmoon-faire-gossip.patch` (after
`holiday-schedule.patch`), world SQL `sql/fixes/world/2026_11_05_04_darkmoon_faire_npcs.sql`.
Rebuild, run the SQL, restart.

- **Found** (reported by Four):
  - "Selina Dourman, has a quest, cannot interact": her C++ script `npc_selina_dourman` sends
    npc_text 23004-23006, which don't exist, and her template's gossip menu 8776 has no
    `gossip_menu` row. Her real menu 13075 (guide, purchases, prize tickets, cards, attractions)
    is already in the database.
  - "Fire jugglers at the entrance, not juggling": 8 jugglers in pairs (55220/55221 at the entrance,
    55222/55223, 55225/55226, 55341/55342) cast Juggle Torches (196717) at their partner by
    sniffed spawn guid (2099, 2104, 2142, 2145, 2187, 2189, 2212, 2219). Those guids don't exist
    here, so the spell had no target.
  - "Maxima Blastenheimer has French locale text" and "Unable to turn in game tokens": the
    `npc_canon_maxima` script has French text ("Je souhaite devenir un homme canon !") and only
    offers the launch while the daily Humanoid Cannonball (29436) is in progress. Mola
    (Whack-a-Gnoll, 29463) and Teleportologist Fozlebub (cannon teleport, 30 silver) had the same
    problem. Fozlebub also took the 30 silver without checking you had it.
  - "Horde Children / Citizen are hostile/attackable": Alliance Citizen 55347 and Horde Citizen
    55348 had `unit_flags` 512, so the other faction could attack them.
- **Changed:**
  - `darkmoon-faire-gossip.patch` (`DarkmoonCanon.cpp`, `DarkmoonWhackGnoll.cpp`): English
    options "Launch me! (Darkmoon Game Token)", "Ready to play! (Darkmoon Game Token)" and
    "Teleport me to the cannon." with a 30 silver confirm; English whispers when you have no
    token; the options show for everyone (the quests still count). Fozlebub checks your money.
  - Selina 10445: `ScriptName` '', `gossip_menu_id` 13075, `unit_flags` 768.
  - Juggler SAI `target_param1` set to the partner's spawn on this server: 55220->1400016,
    55221->1400017, 55222->1400081, 55223->1400086, 55225->1400313, 55226->1400349,
    55341->1400114, 55342->1400294.
  - Citizens 55347, 55348: `unit_flags` 768 (adds IMMUNE_TO_PC, as in the Pandaria 5.4.8 DB).
- **Not changed:** the carousel (its mounts aren't seated on the moving carousel, which needs core
  transport work) and the rollercoaster (none at the retail Faire as far as we know; asked Four).
- **Status:** untested in game.

### Darkmoon Faire: missing from the calendar, and on the wrong days

From Four, 2026-11-04. Core patch `tools/bfa/holiday-schedule.patch` (after all other patches),
world SQL `sql/fixes/world/2026_11_04_00_darkmoon_faire_first_sunday.sql`, hotfix SQL
`sql/fixes/hotfixes/2026_11_04_00_darkmoon_faire_calendar.sql`.

- **Found** (reported by Four: "I don't really see it on the calendar"):
  - The server sends no holidays to the calendar. The client draws them from its own Holidays.db2.
    In the 8.3.7 client (Four's file), the Darkmoon Faire, holiday 479, only has 18 dates, from
    July 2019 to December 2020. So nothing showed in 2026. The hotfix database had no row 479.
  - On the server, the Faire is game event 3. Upstream's `2026_08_16_01_fix_game_events.sql` gave it
    a start of 2026-09-06 10:01, every 30 days (`occurence` 43200), 7 days long. Months aren't 30
    days long, so the start day slid away from the retail first Sunday of the month by about 5 days
    a year. The core's `game_event` only supports fixed periods.
- **Changed:**
  - `holiday-schedule.patch` changes `src/server/game/Events/GameEventMgr.cpp`, in
    `CheckOneGameEvent`, `NextCheck`, `StopEvent` and `LoadFromDB`. A `game_event` row with
    `occurence` 0 is now a monthly event: it starts on the first Sunday of every month, at the time
    of day of its `start_time`, and runs for `length` minutes. Before, `occurence` 0 divided by zero.
    No row used it.
    - `.event start 3` runs the event for its length from now.
    - `.event stop 3` stops the current month's run until it would have ended.
    - At startup the log says "game event id (3) runs monthly from the first Sunday at 00:00".
  - `game_event` 3: `start_time` 2026-09-06 10:01 -> 2026-11-01 00:00, `occurence` 43200 -> 0,
    `length` 10080 (7 days, unchanged), `end_time` 2030-12-31 17:00 -> 2037-12-31 23:59.
    Event 23 (Darkmoon Faire Building) has no spawns or scripts, so it is unchanged.
  - Hotfix: `holidays` row 479 is the client's own row (name, description, textures, durations 48 h
    + 168 h, calendar flags 0/3) with 26 new dates. Each date is the Friday 00:00 before a first
    Sunday, from the Faire of 2026-11-01 to the Faire of 2028-12-03. `hotfix_data` row: Id 9000479,
    table hash 1972272076 (Holidays.db2), record 479. The calendar shows each Faire from Sunday 00:00
    for 7 days. Holidays.db2 holds at most 26 dates, so the calendar needs new dates again for 2029.
    The server schedule doesn't.
- **Status:** compiled (GameEventMgr.cpp), not tested in game yet.

### Darkmoon Island: the strider race course visible to everyone

From Four's visit, 2026-11-05 (screenshots of "Powerup Bunny Checkpoint" arches and "Powerup Bunny -
Trap - Tripwire - NOT MECHANICAL" posts all over the paths, with GM mode off). SQL only:
`sql/fixes/world/2026_11_05_03_darkmoon_race_course_hidden.sql`.

- **Found:** the course of the island's strider race is spawned, 290 creatures. That's the
  checkpoints, power-up crates, tripwires, marker arrows and start bunnies, with visible models
  and no trigger flag. On retail only racers see them. The race itself has no scripts here.
  "Dusty" Brandom (68492) has no gossip and npcflag 0.
- **Changed:** every map 974 spawn of 74153, 74157, 74678, 74800, 74872, 75063, 75044, 75718,
  74260-74263, 74420 and 74536 goes into new spawn group 450, "Darkmoon Island - strider race
  course", with flag 0x04 (manual spawn). The core keeps those spawns despawned until a script
  turns the group on. The rows are selected from the live `creature` table, so no guid list is
  hard-coded.
- **Next:** the race itself (Four, 2026-11-05: "yes after").
- **Status:** not tested in game yet.

### Darkmoon Island: Portal Back hung the client on the loading screen

From Four's visit, 2026-11-05. SQL only: `sql/fixes/world/2026_11_05_02_darkmoon_portal_back.sql`.

- **Found** (reported by Four: taking the portal back out left the client stuck on the loading screen):
  - Portal Back (gameobject 216667, 2 spawns on Darkmoon Island) is a spellcaster gameobject. Its
    own spell, 101260 To the Staging Area!, already sends Horde to Mulgore and Alliance to Elwynn
    (`spell_darkmoon_staging_area_teleport`).
  - It also had SmartAI that, on the same click, cast 101260 again and 103582 (Mulgore, map 1). So
    an Alliance player got teleports to Elwynn and to Mulgore at the same time.
- **Changed:** both `smart_scripts` rows of 216667 (source type 1, ids 0 and 1) are deleted, and
  `gameobject_template` 216667 `AIName` 'SmartGameObjectAI' -> ''.
- **Status:** not tested in game yet.

### Darkmoon Faire: Fire Jugglers throwing torches at players and NPCs

From Four's visit to the Elwynn Faire camp, 2026-11-05. SQL only:
`sql/fixes/world/2026_11_05_01_darkmoon_fire_juggler_torches.sql`.

- **Found** (reported by Four: the torches home in on the nearest NPC or player, some at Four,
  others at the Greeter):
  - Fire Jugglers carry aura 102905 (template addon of 55089, 55093, 55225 and 55397). Every 0.7
    seconds it casts Juggle Torch, 102882. That's a dummy spell whose torch flies to a "nearby unit
    of an entry" (target 38) within 20 yards. Which entry is meant to come from `conditions`, and
    the dump has none for 102882. So the core took any nearby unit: players, the Greeter, the Fire
    Eater.
  - Read from the client's SpellEffect.db2.
- **Changed:** 13 `conditions` rows (source type 13, group 1, entry 102882, condition 31 type 3).
  The torch may now only target a Fire Juggler: 55089, 55093, 55220-55226, 55341, 55342, 55397,
  55398. The jugglers stand in pairs about 18 yards apart, so the torches stay with the jugglers.
- **Status:** not tested in game yet.

### Holidays that move every year: missing from the calendar, and two never ran

From Four, 2026-11-05 ("please do them all"). Same core patch (`holiday-schedule.patch`, which was
first written for the Faire alone), world SQL `sql/fixes/world/2026_11_05_00_holiday_dates_schedule.sql`,
hotfix SQL `sql/fixes/hotfixes/2026_11_05_00_holiday_calendar_dates.sql`.

- **Found:**
  - In the client's Holidays.db2, six holidays have dates only up to 2020 (Lunar Festival up to 2024),
    so none of them shows on the 2026 calendar: Lunar Festival 327, Love is in the Air 423,
    Noblegarden 181, Children's Week 201, Harvest Festival 321, Pilgrim's Bounty 404. Hallow's End,
    Winter Veil, Midsummer, Brewfest, Pirates' Day, Day of the Dead and the 4th of July fireworks use
    "any year" dates and were already fine.
  - On the server, upstream's `2026_08_16_01_fix_game_events.sql` never updated game events 7
    (Lunar Festival), 26 (Pilgrim's Bounty) or 72 (Fireworks Spectacular). They still ended in 2020,
    so they never ran. The others repeat every 365 days (Noblegarden 364), so Easter-based
    Noblegarden drifts by weeks.
- **Changed:**
  - `holiday-schedule.patch`: `occurence` 1 means "start on each date of the event's holiday in
    Holidays.db2". It reads the dates from the server's own copy, hotfixes included, so the server
    runs on the dates the calendar shows. An "any year" date repeats every year. Each run lasts
    `length`. At startup the log says "game event id (N) runs on the dates of holiday H". An event
    with `occurence` 1 and no holiday logs an error and never starts.
  - Hotfix rows 327, 423, 181, 201, 321 and 404 are the client's own rows, with five dates each
    (2026 to 2030, 10:00). 2030 is the last year a Holidays.db2 date can hold. `hotfix_data` ids
    are 9000000 + holiday id. The rules:
    - Lunar Festival: 2 days before the lunar new year (2026-02-15, 2027-02-04, 2028-01-24,
      2029-02-11, 2030-02-01).
    - Love is in the Air: the first Monday on or after 7 February.
    - Noblegarden: Easter Monday (as in every client date from 2015 to 2020).
    - Children's Week: the Monday between 28 April and 4 May.
    - Harvest Festival: the second Tuesday of September.
    - Pilgrim's Bounty: the Monday of Thanksgiving week (as in every client date from 2015 to 2020).
    The Lunar Festival, Love is in the Air, Children's Week and Harvest Festival rules are close fits
    to the client's 2015-2020 dates. Retail moved those around from year to year.
  - `game_event` 7, 8, 9, 10, 11, 26 and 72: `occurence` -> 1, `start_time` -> 2026-01-01 00:00
    (only used by `.event start`), `end_time` -> 2037-12-31 23:59. `length` is unchanged. Fireworks
    (72, holiday 62, "any year" 4 July 10:00) now runs every year again.
- **Not done:**
  - Timewalking (holidays 559, 562, 587, 643). The server's events 100-103 are switched off
    (they end in 2020 or start and end in 2030), and Timewalking dungeons need their own work.
  - Brew of the Month (34-45) and the Kalu'ak Fishing Derby (63, 64) also ended in 2020.
  - The fixed-date holidays still repeat every 365 days, so they slip one day per leap year
    (first in 2028).
- **Status:** compiled (GameEventMgr.cpp), not tested in game yet.

## 2026-11-04 (pet battles)

### Pet battles: some wild pets ignore their zone's level range

- **Found** (asked by Four): Pet Tracker's map says Elwynn Forest pets are level 1-2. Are they all?
- **Cause:** `WildBattlePetMgr::EnableWildBattle` rolls a wild pet's level between
  max(`battlepet_info.minlevel`, zone min) and max(`battlepet_info.maxlevel`, zone max). The zone
  range comes from the client's AreaTable. Almost every wild pet template is 1-1, so the zone
  decides. 30 wild pet templates were 5-5 or 1-25 instead:
  - 5-5: Fawn 61165 (every Elwynn and Teldrassil fawn was level 5, zone 1-2), Snow Cub 61689,
    Infected Fawn 61827, Shimmershell Snail 62246.
  - 1-25 (could roll from the zone minimum up to 25): Tiny Harvester 61160, Little Black Ram 61459,
    Tiny Twister 61703, Blighthawk 61826, Ruby Sapling 62020, Ravager Hatchling 62051, Creepy Crawly
    62116, Venomspitter Hatchling 62191, Silithid Hatchling 62258, Minfernal 62317, Diemetradon
    Hatchling 62375, Nether Faerie Dragon 62395, Qiraji Guardling 62526, Flayer Youngling 62555,
    Fjord Worg Pup 62669, Stunted Shardhorn 62816, Imperial Eagle Chick 62819, Wildhammer Gryphon
    Hatchling 62900, Stowaway Rat 62921, Shore Crawler 63097, Gilnean Raven 63098, Harpy Youngling
    68804, Arcane Eye 68819, Infinite Whelpling 68820, Anodized Robo Cub 68839, Cogblade Raptor 68841.
- **Changed:** new `sql/fixes/world/2026_11_04_50_wild_battle_pet_zone_levels.sql` sets `minlevel`
  and `maxlevel` to 1 for those 30 `battlepet_info` rows, so they follow their zone like every other
  wild pet. The old values are listed in the file's header. Tamer team pets and companion entries
  are not touched. No core change.
- **Status:** run on Four's live DB and confirmed in game by Four on 2026-11-04.

#### To pick it up
SQL only, then a restart (levels are rolled when a pet spawns).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_50_wild_battle_pet_zone_levels.sql | mysql -u root -p bfa_world
```
The last line prints `30 wild pet templates set to 1-1`. Then restart `worldserver`.

## 2026-11-04 (World fixes)

### World: Battlescar fliers fight each other in mid-air; Fort Triumph laborers slide and get blasted

- **Found** (Four, after SQL 31): some wind riders and gryphons fight each other in mid-air without
  riders on their backs. At Fort Triumph, a sleeping laborer slides around on the scaffolding and the
  other laborers keep getting thrown around next to the effect bunny.
- **Cause:**
  - Desolation Wind Rider 37974 (faction 29) and Triumph War Gryphon 37978 (faction 894) are hostile
    to each other, so they attack where their new flight routes cross. The riders die in those
    fights, and the mount flies on empty until it respawns.
  - The 12 Peasant Laborers 39129 and 3 Mizzy's Apprentices 39124 at Fort Triumph, and the 11
    Desolation Guards 38070, wander 3 yards (MovementType 1). MaNGOS Three has all of them standing
    still. The laborer script naps (actionlist 3912900: Sleep 6431 for 30 s), so a sleeping laborer
    slides along the boards.
  - The blasting is bunny 35845's Legion knockback 206750 (its id 3 timer row). The laborer script
    only expects knockback 177984. See SQL 37.
- **Changed:** `sql/fixes/world/2026_11_04_32_battlescar_fort_workers_and_air_fights.sql`:
  - `unit_flags |= 0x200` (IMMUNE_TO_NPC) on 37971, 37974, 37977 and 37978, so the mounts and their
    riders ignore other NPCs. Players can still fight them.
  - MovementType 0, spawndist 0 on the 26 spawns listed in the file.
- **Status:** confirmed in game by Four (2026-11-04): fliers keep their riders, no more sliding.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_32_battlescar_fort_workers_and_air_fights.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Battlescar fliers hang still in the sky and the patrols stand still

- **Found** while looking into the Battlescar with Four (see
  `/mnt/project-files/world-fixes/battlescar.md` in the project for the whole picture).
- **Cause:** our Battlescar spawns are the same spawns as the MaNGOS Three Cataclysm DB (same guids,
  same positions), but our dump lost the waypoint paths of 27 of them, which were left at
  MovementType 0. The wind riders' and gryphons' riders were spawned on their own in mid-air
  (z 110-145) with random movement instead of riding their mounts.
- **Changed:** `sql/fixes/world/2026_11_04_31_battlescar_fliers_and_patrols.sql`:
  - New paths 485500001-485500027 (from MaNGOS Three `creature_movement`), with creature_addon
    `path_id` and MovementType 2:
    - 6 Desolation Wind Riders 37974 (269007, 269009, 269011, 269013, 269015, 269017) and
      6 Triumph War Gryphons 37978 (269019, 270158, 270332, 270334, 270343, 270347): flight
      routes of 33-54 points, run speed.
    - 3 Desolation Raiders 37922 (269585, 270589, 270667), 2 Triumph Vanguards 37923 (269077,
      270905), 5 Sapper Specialists 37925 (270711, 270780, 270827, 270850, 270851) and 5 Barrens
      Operatives 37924 (269147, 269148, 269149, 270197, 270336): walking patrols of 4-8 points.
  - `vehicle_template_accessory`: Desolation Sky Render 37971 rides seat 0 of the Wind Rider
    37974, and Wildhammer Mercenary 37977 rides seat 0 of the War Gryphon 37978. The gryphon's
    script already expects a rider ("Passenger Boarded").
  - The 12 loose mid-air riders are deleted (37971: 269008, 269010, 269012, 269014, 269016,
    269018; 37977: 269020, 270159, 270333, 270335, 270344, 270348). The stray Mercenary 200478
    in the Eastern Kingdoms is left alone.
- **Not fixed (no data):** the flag capture (events 23033/23034 do nothing, here and in MaNGOS
  Three), the gryphon Hook Shot (no caster), and the sapper suicide runs into Fort Triumph (their
  trigger spawns 92564-92569 and paths 3792500-3792505 are missing).
- **Status:** patrols confirmed in game by Four (2026-11-04). Fliers flew with riders, but mid-air fights killed riders; fixed in SQL 32 (confirmed).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_31_battlescar_fliers_and_patrols.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Claim the Battlescar never completes ("Scout out the flag marker")

- **Found** while looking into the Battlescar with Four (Southern Barrens, between Fort Triumph and
  Desolation Hold).
- **Cause:** Claim the Battlescar (Alliance 25081, objective 259939) and Claim the Battle Scar
  (Horde 24618, objective 266351) have an area objective (type 10, ObjectID -1) next to "kill 10".
  Nothing completes it: there is no `areatrigger_involvedrelation` row and no script. The core only
  sets a type-10 objective from `Player::AreaExploredOrEventHappens`, so both quests stay
  incomplete forever. (The 4.3.4 quest in the MaNGOS Three DB was kill-only; the scouting step came
  later and was never wired up.)
- **Changed:** `sql/fixes/world/2026_11_04_30_claim_the_battlescar_scout_flag.sql`: a per-spawn
  script on the invisible bunny that stands on the flagpole (35845, guid 269123, -3244.4 -2002.5):
  SMART_EVENT_OOC_LOS (non-hostile, 15 yards, 1 s cooldown) -> SMART_ACTION_CALL_AREAEXPLOREDOREVENTHAPPENS
  for 25081 (id 0) and 24618 (id 1), target the player. A player without the quest gets nothing.
  Because a per-spawn script replaces the entry script, this one bunny also stops running 35845's
  Legion timer rows (the zap at the closest player).
- **Status:** confirmed in game by Four (2026-11-04).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_04_30_claim_the_battlescar_scout_flag.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03 (World fixes, second batch)

### World: invisible effect bunny zaps nearby players and keeps them in combat

- **Found** (reported by Four, Southern Barrens near the Sapper Specialists): a lightning-like
  effect hits you and you stay in combat with "Dave's Industrial Light and Magic Bunny
  (Small)(Sessile)" (35845, spawn 269123).
- **Cause:** 35845 is a generic invisible effect bunny with 144 spawns (Broken Isles 33, Draenor 44,
  Mount Hyjal 17, Southern Barrens 9 and more). Its entry script mixes rows from unrelated uses, and
  three Legion rows run on a timer (event 60, in and out of combat) on every spawn: id 3 casts
  206750 (damage + knockback around the bunny) every 3-8 s, id 5 sends data to Azuregos 104902 (a
  Broken Isles NPC), id 8 casts 199886 on the closest player within 100 yards every 2-3 s.
- **Changed:** `sql/fixes/world/2026_11_03_37_bunny_35845_legion_rows_map_only.sql`: SMART_EVENT
  conditions (source 22, groups 4, 6 and 9, CONDITION_MAPID 22 on the bunny itself) so ids 3, 5 and
  8 only run on map 1220 (Broken Isles). The data-triggered rows are untouched.
- **Status:** back on (2026-11-04). The Battlescar investigation showed the same rows misfiring at
  Fort Triumph: bunny 269877 zaps players and knocks the scaffolding laborers around with 206750.
  Neither the Battlescar nor Fort Triumph scripts use these spells. Confirmed in game by Four
  (2026-11-04): lightning and explosions gone.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_37_bunny_35845_legion_rows_map_only.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Stonetalon oil pumps wander and the Krom'gar balloon sinks into the lake

- **Found** (reported by Four, Mirkfallon Lake): the Oil Pumps walk around, and the Krom'gar Hot Air
  Balloon sits half under water.
- **Cause:** Oil Pump 41475 (11 spawns, the targets of Schemin' That Sabotage 25878) had
  MovementType 1 with spawndist 3. The balloon 41418 (guid 272501, spawned at z 148.2) has
  InhabitType 3 (ground + water), so it falls into the lake. The Pandaria DB has the pumps still
  with InhabitType 7 and the balloon at InhabitType 4 (air). The pumps' size is their normal model
  (scale 1 in both DBs).
- **Changed:** `sql/fixes/world/2026_11_03_36_stonetalon_oil_pumps_balloon.sql`: 41475 spawns
  MovementType 1 -> 0 and spawndist 3 -> 0, template InhabitType 3 -> 7; 41418 template InhabitType
  3 -> 4.
- **Not changed:** the big fire Four saw at 1497.8, 1006.2: no creature or gameobject is spawned
  within 50 yards in the DB, so it is part of the client's map art (inferred).
- **Status:** confirmed in game by Four on 2026-11-04.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_36_stonetalon_oil_pumps_balloon.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Sapper Specialist never uses Sapper Charge

- **Found** (reported by Four while testing the per-spawn script entry below): the Sapper Specialist
  (37925, Southern Barrens) throws dynamite but never blows himself up at 10% HP.
- **Cause:** Sapper Charge (82867) hits a spot at an enemy (implicit target 53,
  TARGET_DEST_TARGET_ENEMY) and then kills the caster. The SmartAI rows cast it on target_type 1
  (self), which is not an enemy, so every cast failed. The entry also mixed two script versions:
  ids 0 and 1 existed twice, so the aggro link to id 1 could land on the wrong row.
- **Changed:** `sql/fixes/world/2026_11_03_35_sapper_specialist_sapper_charge.sql`: old-version rows
  deleted (id 0 'Cast Throw' timer, id 1 'Cast Sapper Charge at 10% HP'); id 16 'Cast Sapper Charge
  at 10% HP' target_type 1 -> 2 (victim). Row 29 (the scripted run that blows up next to the Triumph
  defenders) is unchanged. Spawns 270777, 270847 and 270852 get a fresh copy of the entry script
  (from `2026_11_03_34`).
- **Status:** confirmed in game by Four on 2026-11-04.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_35_sapper_specialist_sapper_charge.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: zone entry quests hidden unless you picked up a breadcrumb (67 quests)

- **Found** (Four asked for a sweep after Rerouted!, 2026-11-03): the same lock as Officer Jankie's
  Rerouted! (14384) exists in many zones.
- **Cause:** the core turns `quest_template_addon.PrevQuestID` and every quest whose `NextQuestID`
  points at a quest into hard requirements (`ObjectMgr::LoadQuests` -> `prevQuests`;
  `Player::SatisfyQuestPreviousQuest` needs one of them rewarded). For 67 zone entry quests every
  such requirement is a breadcrumb: a Hero's Call / Warchief's Command board quest, or a talk-only
  quest (no objectives) that starts outside the zone. Arriving without one hid the first quest.
  Upstream already fixed Westfall (26209) this way; Desolace (14384, 14184) is in
  `2026_11_03_30`. Quests where one of the requirements is a real or in-zone step (28 found, for
  example In Defense of Far Watch 871 after Conscript of the Horde 840) are left alone.
- **Changed:** `sql/fixes/world/2026_11_03_33_zone_entry_quests_no_breadcrumb.sql`: on 65 quests
  `PrevQuestID` -> 0 where it named one of its breadcrumbs, and `NextQuestID` -> 0 on 115
  breadcrumbs that pointed at them. Each quest and its breadcrumbs are listed in the file. Examples:
  The Forsaken 9329 (Ghostlands), Alien Predators 9634 (Bloodmyst), Hellscream's Vigil 11585 and
  Enlistment Day 11672 (Borean Tundra), The Last Wave of Survivors 13518 (Darkshore), Signs of
  Change 25210/25447 (Feralas), The Lost Pilot 26854 (Loch Modan), The Maelstrom 27203 (Deepholm),
  The Road to Kun-Lai 31254/31255. The breadcrumbs stay available and still turn in at the same NPC.
- **Status:** confirmed in game by Four on 2026-11-03 (The Lost Pilot, The Last Wave of Survivors,
  The Stolen Keg, Northfold Manor and Signs of Change all offered without a breadcrumb).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_33_zone_entry_quests_no_breadcrumb.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: 40 spawns with a cosmetic per-spawn script never ran their own script

- **Found:** follow-up to the Fel Hands rows (`2026_10_31_05`). The same importer left a second kind
  of one-row per-spawn script (comment 'OOC - CS') on 40 spawns, mostly in Stonetalon Mountains,
  Southern Barrens, Silithus, Dustwallow Marsh and Orgrimmar.
- **Cause:** each casts a cosmetic spell out of combat (dummy auras 39550, 54219, 111541, 146130,
  180695, 183940, 185340, 217193, or dummy-effect 217160 aimed at a nearby bunny). These may be real
  retail visuals, but a per-spawn script replaces the creature's own script, so these spawns never
  cast in combat, fled or said their lines, and Tortolla (41504, guid 293563) in Mount Hyjal never
  ran 'Teleport on Quest Add'.
- **Changed:** `sql/fixes/world/2026_11_03_34_cosmetic_spawn_scripts_keep_entry_script.sql`: each
  spawn's entry script is copied under its per-spawn script with `id` and `link` + 1000, next to the
  cosmetic row (id 0), so both run. It copies from the live table when applied; re-running replaces
  the copies. Spawns and entries are listed in the file (for example Lumbering Oaf 40906, Sapper
  Specialist 37925, Razormane Pathfinder 37560, Orgrimmar Grunt 3296).
- **Status:** confirmed in game by Four on 2026-11-03: the Sapper Specialist now throws dynamite.
  Its Sapper Charge was broken in the entry script itself, see the next entry.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
```

```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_34_cosmetic_spawn_scripts_keep_entry_script.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03

Merged to `main` with PR #37 on 2026-11-03.

### World: Nijel's Point is packed with Defenders (some on fire) and extra Merchants

- **Found** (reported by Four): Nijel's Point in Desolace is crowded with Nijel's Point Defenders,
  several of them burning, and many copies of Nijel's Point Merchant.
- **Cause:** Nijel's Point Defender (35506, 119 spawns) and Nijel's Point Merchant (35510, 10
  spawns) are the targets of the Horde quest Rider on the Storm (14198: kill 40 Defenders and burn
  15 Merchants while riding the firestorm). Like the Astranaar siege, they have no phase, so every
  player sees the raid crowd in the town. 11 Defenders also keep the sniffed fire visual (aura
  42726). The two entries were also listed as quest givers for 14198, which really starts at the
  Ancient Vortex Runestone (gameobject 195445).
- **Changed:** `sql/fixes/world/2026_11_03_32_nijels_point_raid_phase.sql`:
  - All 35506 and 35510 spawns: `PhaseId` 0 -> 303 (a normal Phase.db2 phase used nowhere else).
  - `phase_area` (608, 303) plus a condition (type 26, quest state 47, quest 14198, mask 10):
    phase 303 shows only while Rider on the Storm is in progress or complete.
  - `creature_addon.auras` '42726' -> '' on guids 309531, 309912, 310167, 310400, 310426, 310485,
    310542, 310635, 310659, 310677 and 310741.
  - `creature_queststarter` rows (35506, 14198) and (35510, 14198) deleted.
  - The town's own guards (8151 x18, 51839 x8), its named NPCs and the vortex bunnies are untouched.
- **Status:** confirmed in game by Four on 2026-11-03 (Alliance view: raid crowd gone).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_32_nijels_point_raid_phase.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Rerouted! (Desolace) gives no mount to ride

- **Found** (reported by Four): after taking Rerouted! from Officer Jankie, there is no mount.
- **Cause:** nothing is scripted. Jankie (36410), Jankie's Mount (36416/36419), Furien (35286) and
  Furien's Mount (35287) have no SmartAI rows, spellclick or waypoint path in this DB (or the Pandaria
  one), and none of the mounts is set up as a vehicle. The only retail trace is spell 68693, which
  summons 36419 next to Jankie (`spell_target_position` 171.4, 1793.5, 86.2).
- **Changed:** `sql/fixes/world/2026_11_03_31_desolace_entry_flights.sql`, a stand-in for the flight:
  - Jankie 36410 SAI id 0: on accepting 14384, teleport the player to Corporal Melkins at Nijel's
    Point (map 1, 129.0, 1235.5, 163.6).
  - Furien 35286 SAI id 0 (Horde): on accepting My Time Has Passed (14184), teleport to Cerelia at
    Furien's Post (map 1, -427.6, 2229.9, 89.5).
- **Status:** Alliance side (Jankie teleport) confirmed in game by Four on 2026-11-03. Furien's side
  not tested (Horde only).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_31_desolace_entry_flights.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: no quest from Officer Jankie (or Furien) at the Desolace entrance

- **Found** (reported by Four): Officer Jankie (36410) at Tethris Aran shows no quest marker.
- **Cause:** her quest Rerouted! (14384), which flies you to Nijel's Point and starts Alliance
  Desolace, could only be taken after a breadcrumb. It had `quest_template_addon.PrevQuestID` = 25938
  (Help for Desolace), and the breadcrumbs Help for Desolace (25938) and Hero's Call: Desolace!
  (28531) have `NextQuestID` = 14384, which the core also turns into a requirement on 14384
  (`ObjectMgr::LoadQuests` adds them to its `prevQuests`). Arriving without a breadcrumb gave nothing.
  The Horde side has the same lock: Furien's My Time Has Passed (14184) had `PrevQuestID` 28548 and
  Warchief's Command: Desolace! (28548) has `NextQuestID` 14184.
- **Changed:** `sql/fixes/world/2026_11_03_30_desolace_entry_quests_no_breadcrumb.sql`:
  `PrevQuestID` 25938 -> 0 on 14384 and 28548 -> 0 on 14184; `NextQuestID` 14384 -> 0 on 25938 and
  28531, 14184 -> 0 on 28548. The breadcrumbs still turn in at Jankie and Furien.
- **Status:** confirmed in game by Four on 2026-11-03 (Rerouted! offered by Jankie without a
  breadcrumb). Furien's side not tested (Horde only).
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_03_30_desolace_entry_quests_no_breadcrumb.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

## 2026-11-03 (Holidays)

Merged to `main` with PR #35 on 2026-11-03.

### Day of the Dead: dancing with Catrina gave no skeleton and no Dead Man's Party

From Four, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_20_holiday_emote_casts.sql`.

- **Found** (reported by Four): `/dance` with Catrina (34383) during Day of the Dead did nothing, so
  achievement 3456 Dead Man's Party never came.
  - The achievement has one criterion (10918, type 69 "be spell target") for spell 65386 Honor the
    Dead, the skeleton transform. The core credits it when that spell hits the player.
  - Catrina's SmartAI row (event 22 receive emote, emote 34 dance, action 11 cast 65386) has
    `target_type` 0 (none). SmartAI finds no target for that, so she never cast the spell.
  - A scan of every receive-emote cast row in the dump found one more with the same mistake: Winter
    Reveler (15760, Winter Veil), who should cast Mistletoe (26218) on a player who `/kiss`es him.
- **Changed:** `target_type` 0 -> 7 (the player who did the emote) on both rows:
  `smart_scripts` 34383/0/0/0 and 15760/0/0/0.
- **Status:** Catrina confirmed in game by Four on 2026-11-03 (skeleton transform and Dead Man's
  Party awarded). Winter Reveler not tested yet: Winter Veil starts 2026-12-15 on this server.
## 2026-11-03 (Transmog apply)

Merged to `main` with PR #34 on 2026-11-03. Core change in the new `tools/bfa/transmog-apply.patch`,
applied after all the other patches. It needs `transmog-collection.patch`.

### Apply at the transmogrifier did nothing
- **Found** (reported by Four): Apply at the transmogrifier stopped doing anything. Every check in
  `WorldSession::HandleTransmogrifyItems` (`TransmogrificationHandler.cpp`) ends the request with a
  debug log line only, and one refused slot cancels the whole request, so a refusal looks like nothing
  happening. One check, `Player::CanUseItem(itemTemplate)` on the item the appearance comes from,
  refuses the very appearances `transmog-collection.patch` lets you collect: items above your level
  (`Transmog.CollectIgnoreLevel`) and items your class, race or faction can't use
  (`Transmog.CollectAnyClass`). The client offers every collected appearance, so picking one of those
  breaks Apply for every slot.
- **Changed:** `TransmogrificationHandler.cpp`, `HandleTransmogrifyItems`:
  - With `Transmog.CollectAnyClass` 1 the `CanUseItem` check is skipped. With it 0 and
    `Transmog.CollectIgnoreLevel` 1, it skips only the required level (`CanUseItem(itemTemplate, true)`).
    With both 0 it is the stock check. `Item::CanTransmogrifyItemWithItem` is unchanged, so the
    appearance still has to match the item's armor type, weapon type and slot.
  - Every refusal now also prints `Transmogrify refused: <reason>` in chat: transmogrifier out of reach,
    bad slot, nothing equipped, unknown or uncollected appearance, an item you can't use (with its
    `InventoryResult`), an appearance that doesn't fit the item, illusion problems, or not enough money.
  - No SQL, no new settings.
- **Status:** confirmed in game by Four on 2026-11-03: Apply works again.

### To pick up the transmog apply fix
Everything is on `main` now. If you applied the patch from the PR branch, the file on `main` is the same,
so nothing needs rebuilding; just pull:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Without it applied yet, add the new patch. Only one file changes, so the build is short. There's no SQL:
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/transmog-apply.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Then type `server shutdown 1` in the worldserver console and start it again with
`cd ~/bfa/server/bin && ./worldserver`.

## 2026-11-03 (Razorfen Downs)

Merged to `main` with PR #26 on 2026-11-03.

### Razorfen Downs: Koristrasza dropped to the ground wherever she was put

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_03_razorfen_downs_koristrasza_flying.sql`.

- **Found** (reported by Four, while moving her off a vine with `.npc move`): Koristrasza (44843)
  plays a flying animation, but her template only allowed ground and water (InhabitType 3). So the
  server dropped her to the floor below wherever she was placed.
- **Changed:** InhabitType 4 (air), so she hovers where she is placed. Her spawn is moved to the spot
  Four picked in game: 2369.33, 1020.62, 69.84.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: Blackthorn's Summon Skeletons summoned nothing

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_02_razorfen_downs_blackthorn_skeletons.sql`.

- **Found** (reported by Four): Death Speaker Blackthorn cast Summon Skeletons, but no skeletons
  came. His script casts 150601, which only puts a dummy aura on him. The server-side script that
  should then summon is missing. The spell that actually summons is 150603 (Summon Skeletons: a
  Splinterbone Warrior, 74902, at the caster).
- **Changed:**
  - He casts 150603 three times, from 70% health and then every 20-35 seconds as before.
  - The warriors get the scaling row for the dungeon's difficulty.
- **Status:** confirmed in game by Four on 2026-11-03 ("much more fun and challenging").

### Razorfen Downs: Amnennar never appeared after Blackthorn died

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_01_razorfen_downs_amnennar_summon.sql`.

- **Found** (Four's `.debug scenario`): the first two steps completed. The three lieutenants were
  done, and Blackthorn's step was at state 3, so `razorfen-downs.patch` works. But Amnennar never
  appeared.
  - Blackthorn's death row says a line and links to the row that summons Amnennar. That summon row
    only runs through the link.
  - None of the Warlords bosses has any creature_text, so SmartAI drops every "say" row at startup.
    That took the start of the chain with it, so the summon never ran.
  - Mushlump's death row (clearing his plague triggers) and Mordresh's (opening a GO) had the same
    shape.
- **Changed:**
  - Blackthorn's summon row is now its own death event, and the say row is deleted.
  - Mushlump's and Mordresh's death rows are fixed the same way.
- **Status:** confirmed in game by Four on 2026-11-03: Blackthorn summoned Amnennar, and his corpse
  was lootable.

### Razorfen Downs: Koristrasza kept flying past

From Four's run, 2026-11-03. SQL only: `sql/fixes/world/2026_11_03_00_razorfen_downs_koristrasza.sql`.

- **Found** (reported by Four): Koristrasza (44843, guid 325205), a friendly blue dragon from the
  Cataclysm quest line, kept showing up on the trail. She is parked high above the dungeon.
  `2026_10_31_01` gave her the Pandaria database's waypoint path, which is a one-way flight from her
  perch down to the trail. Run as a loop, it made her dive through the dungeon over and over.
- **Changed:** her path (129000018) is removed and she stays on her perch.
- **Status:** confirmed in game by Four on 2026-11-03: she stays put. She clips into a vine there; Four
  may move her with `.npc move` in their own database.

### Razorfen Downs: Lady Falther'ess still only meleed (and Ragglesnout never cast)

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_04_razorfen_downs_rare_guid_scripts.sql`.

- **Found** (reported by Four after `2026_10_31_02`, which had loaded fine):
  - Her spawn (guid 373575) and Ragglesnout's (373574) each had a per-spawn SmartAI row. It cast
    Fel Hands (207101) out of combat, a Legion dummy aura that does nothing.
  - A per-spawn script replaces the creature's own script entirely, so neither rare ever ran its
    combat rows.
  - Ragglesnout's own script also mixed two versions together.
- **Changed:**
  - Both per-spawn rows are deleted.
  - Ragglesnout's second Shadow Word: Pain, Heal and Dominate Mind (ids 10-12) are deleted. He keeps
    his bolt, Shadow Word: Pain, Heal and Dominate Mind once each.
- **Not changed:** 40 more spawns elsewhere have the same Fel Hands row. 30 of them hide their
  creature's own script: 14 in Kalimdor, 8 in the Eastern Kingdoms, 6 in Gnomeregan, 1 in Blackrock
  Depths.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: the idol room was a pile-up, and Withered Touch hit far too hard

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_03_razorfen_downs_idol_room.sql`.

- **Found** (reported by Four):
  - **Pile-up:** the room by Plaguemaw held 32 mobs, 12 of them Withered Battle Boars. 15 of them were
    the Extinguishing the Idol event's waves saved as static spawns. They sit exactly on the three
    Idol Room Spawners, in the event's pattern of a boar or two, a Geomancer and a Quilguard. The
    Pandaria database has the same rows; the classic (AzerothCore) database has none.
  - **Withered Touch:** the spell (11442) is a damage over time that scales very high here. Every
    Withered Quilguard had it twice: an aura that procs it on melee hits (11441), and a cast every
    17-19 seconds. Plaguemaw had the same pair (aura 12947 plus the cast). Classic Quilguards and
    Plaguemaw had neither.
  - **Double casting:** Death's Head Geomancers and Withered Spearhides had two script versions
    mixed together, so they cast their spells twice as often.
- **Changed:**
  - The 15 leftover wave spawns are deleted. The room keeps its own mobs: 2 standing and 2
    patrolling Battle Boars, 2 Spearhides (one patrolling), 2 Withered Warriors, a Geomancer, a
    Battle Boar Horror, and Plaguemaw. The three spawners stay for the quest event.
  - Withered Touch is removed from every Quilguard and from Plaguemaw, both the aura and the cast.
    Quilguards keep Enrage at 30%, and Plaguemaw keeps Putrid Stench.
  - The duplicate Geomancer and Spearhide rows are deleted.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: Lady Falther'ess only meleed and rarely dropped an item

From Four's first run, 2026-10-31. SQL only: `sql/fixes/world/2026_10_31_02_razorfen_downs_falther_ess.sql`.

- **Found** (reported by Four: melee only, money only):
  - Lady Falther'ess (14686) is set to use SmartAI but had no script rows.
  - Her two items (23177, 23178) each rolled on their own at 20%, so 64% of kills dropped no item.
  - One of the three Idol Room Spawners (guid 325229) was given random wandering by `2026_10_31_01`.
    These are the invisible markers the Extinguishing the Idol event spawns its waves from.
- **Changed:**
  - She gets the classic combat set from the AzerothCore database: Ribbon of Souls (22743, damage
    around her), Banshee Curse (17105) on a random player, and Banshee Shriek (16838, silence and
    damage within 8 yards). Her classic disguise and Scourge Invasion start are left out.
  - Her items share one group with the Pandaria chances (43% / 56%), so one always drops.
  - That spawner no longer wanders.
- **Status:** confirmed in game by Four on 2026-11-03.

### Razorfen Downs: pre-run check

Before Four's first run. New `tools/bfa/razorfen-downs.patch` (build needed) and
`sql/fixes/world/2026_10_31_01_razorfen_downs.sql`.

#### None of the scenario bosses was spawned
- **Found** (Four's `.debug scenario` on entering): scenario 647 has three steps. "Blackthorn's
  Lieutenants" wants kills of Aarux (74412), Mordresh Fire Eye (74347) and Mushlump (74435); then
  "Death Speaker Blackthorn" (74875); then Amnennar the Coldbringer (74434). Achievement 636 is a
  kill of 74434 too. The BFA spawns are the Pandaria 5.4.8 set with the classic bosses (Tuten'kash
  7355, Mordresh 7357, Glutton 8567, Amnennar 7358), so none of these could be killed and the
  scenario was stuck on its first step.
- **Changed:** four classic boss spots now hold the new bosses:
  - Aarux replaces Tuten'kash (guid 325253), moved to 2511, 857, 47.68, the point his own script
    lands him on.
  - Mordresh 74347 replaces Mordresh 7357 on the same spot (325055).
  - Mushlump replaces Glutton (325058).
  - Blackthorn replaces Amnennar on his throne (324995). Blackthorn's script summons Amnennar 74434
    where he dies.
  - The classic bosses' auras and emote on those spots are removed, and the five get scaling rows
    for the dungeon's difficulty (1). Before, they only had rows for difficulty 0.
- **Not changed:** the gong event still works as before and summons the classic Tuten'kash, who gives
  no scenario credit. Plaguemaw the Rotting, Ragglesnout and Lady Falther'ess stay as optional
  classic bosses.

#### Blackthorn's step could never complete
- **Found:** the step's criteria (24957) waits for scenario event 38474. Nothing in this core sends
  it: spells with a send-event effect don't reach the scenario here, and SmartAI has no action for it.
- **Changed:** `razorfen-downs.patch` (`instance_razorfen_downs.cpp`, `razorfen_downs.h`): the
  instance script sends event 38474 when Blackthorn dies.

#### Boss scripts
- **Found:**
  - Aarux was friendly (faction 35). His script started him flying and unattackable until a dummy
    spell from other NPCs hit him, and nothing in this database casts that spell.
  - Mushlump and Blackthorn each had two script versions mixed together.
  - Amnennar's summon despawned after 10 minutes even if he was alive, so a wipe could lose him for
    good.
- **Changed:**
  - Aarux is hostile (faction 14) and keeps only Plagued Bite and Web Strand.
  - Mushlump keeps one set: Smack Down, Tummy Ache and Putrid Funk.
  - Blackthorn's duplicate death row is deleted.
  - Amnennar now despawns 10 minutes after he dies, not 10 minutes after he appears.

#### Dungeon encounters
- **Found:** `instance_encounters` had no rows for map 129.
- **Changed:** added the client's DungeonEncounter rows: 1662 Aarux, 1663 Mordresh, 1664 Mushlump,
  1665 Blackthorn and 1666 Amnennar (last boss of dungeon finder entry 20).

#### Nothing patrolled
- **Found:** no waypoint paths on map 129 apart from Belnistrasz's, and only the roaches wandered.
- **Changed:** 19 paths from the Pandaria database and 4 from the AzerothCore database. AzerothCore's
  wandering is added for 10 spawns, capped at 5 yards. Spawns are matched by entry and position.
  New path ids are 129000002 and up.

#### Left as is
- The idol room around Plaguemaw (32 mobs, 12 of them Withered Battle Boars) matches the Pandaria
  database spawn for spawn; classic had 15 there. Four chose to keep it.

**Status:** confirmed in game by Four on 2026-11-03: all five bosses are spawned, the three
lieutenants and Blackthorn's step (from `razorfen-downs.patch`) completed, Amnennar gave scenario
credit, and achievement 636 "Razorfen Downs" unlocked. Amnennar's summon needed `2026_11_03_01`.

## 2026-11-02 (pet battles, tamers and achievements)

Merged to `main` with PR #31 on 2026-11-02. The two patches go on top of
`battle-pet-level-achievements.patch`, achievements first.

### Pet tamers: display pets stacked on top of each other

- **Found** (reported by Four): Julia Stevens' pets Fangs (64334) and Slither (64335) stand on the
  exact same spot (-9874.57, 98.49, Goldshire).
- **Cause:** most pet tamers have their team spawned next to them as static creatures
  (MovementType 0). For 40 tamers, two or three of those pets share one position (104 spawns).
- **Changed:** new `sql/fixes/world/2026_11_02_51_pet_tamer_display_pets_wander.sql`: the 149 static
  team pet spawns within 30 yards of the 53 pet tamers that have a "win a pet battle against
  <tamer>" quest now wander within 2 yards of their spawn (MovementType 1, spawndist 2). Pets were
  matched by the `battlepet_info` creature of each species in the tamer's
  `battlepet_npc_team_member` rows. Only spawns that are still static are changed; undo line in the
  file header.
- **Status:** confirmed in game by Four on 2026-11-02 (Fangs and Slither spread out at Julia).

### Pet battles: tamers (Julia Stevens and others) cannot be battled

- **Found** (reported by Four): Julia Stevens (64330, Goldshire) offers nothing to start a battle.
  Beating the wild pets near her does not count for her quest.
- **Cause:** the core has the tamers' teams (`battlepet_npc_team_member`, 1,509 NPC entries; Julia
  has species 872 and 873 at level 2) and a trainer battle type (`PVE_BATTLE_PET_TRAINER`), but
  nothing ever starts a battle against a tamer: `GetPetBattleTrainerTeam` is never called, no gossip
  option exists, and the quest credit for winning was commented out in `PetBattle::Finish`. The quest
  objective type that tamer quests use (11, `QUEST_OBJECTIVE_WINPETBATTLEAGAINSTNPC`, 201 objectives
  in the DB, for example quests 31316 and 31693 for Julia) was also missing from
  `Player::IsQuestObjectiveComplete`, so even a credited objective could never complete the quest.
- **Changed:** new `tools/bfa/battle-pet-trainers.patch`:
  - `GossipDef.h`: new gossip option type `GOSSIP_OPTION_PET_BATTLE` (30) and option index 9001.
  - `Player::PrepareGossipMenu`: adds **Let's do battle!** when the player has Battle Pet Training
    (spell 119467), the NPC has a team in `battlepet_npc_team_member`, and an incomplete quest in the
    log has a type 11 objective for this NPC that is not done yet (as on retail, no quest = no
    battle).
  - `Player::OnGossipSelect`: the option closes the dialog and calls the new
    `WorldSession::StartPetBattleWithTrainer` (`BattlePetHandler.cpp`). It builds up to 3 tamer pets
    from the team rows (level `minlevel`..`maxlevel`, quality `minquality`, a breed from
    `breadsMask`, abilities `Ability1..3`, falling back to the species' own ability for an empty
    one) and starts a PvE battle of type `PVE_BATTLE_PET_TRAINER` with the player's slotted pets. The
    player stays in place, the tamer turns to face them, and the pets fight in between. Capturing is
    already blocked for this type.
  - `SendPetBattleInitialUpdate`: for tamer battles the tamer's entry and display are sent and the
    tamer is no longer sent as the "wild pet" GUID.
  - `PetBattle::Finish`: a win against a tamer calls the new `Player::PetBattleTrainerCredit`, which
    sets every matching type 11 objective in the quest log and completes the quest when it can.
  - `Player::IsQuestObjectiveComplete`: type 11 is a flag objective (done when set).
  - `HandleGossipSelectOptionOpcode` (`NPCHandler.cpp`): accepts quest givers too. Julia's template
    has only the quest giver flag (npcflag 2), so picking any gossip option on her was ignored. The
    option is still checked against the menu that was sent.
  - The battle client draws its own copy of the tamer on the opponent's spot, so the real NPC
    stood next to it (two Julias, reported by Four). `StartPetBattleWithTrainer` now hides the
    real tamer (`SetVisible(false)`) and `PetBattle::Finish` shows it again for every ending (win,
    loss, forfeit). The real tamer is hidden for everyone during the fight. The first version looked
    the tamer up with `ObjectAccessor::FindUnit`, which in this core never finds creatures, so Julia
    stayed hidden until a `worldserver` restart (reported by Four); it now uses
    `ObjectAccessor::GetCreature` on the player's map. If you log out in the middle of a tamer
    battle, the tamer stays hidden until the next restart.
  - `BattlePetDataStore`: new `FindPetBattleTrainerTeam` (read only; the old getter inserts into the
    map on a miss).
  - Also fixed in `PetBattle::Finish`: the end-of-battle rewards ran once per pet in the winning team,
    not once per battle. With 2 or 3 pets slotted, a captured pet was added to the journal 2 or 3
    times, and "Learning the Ropes" (credit 65355) counted 2 or 3 times. They now run once, and the
    "Learning the Ropes" credit needs a win.
  - No SQL. 86 tamers have both a team and a type 11 quest. The 23 Legion/BFA tamers got their
    teams with PR #32 (entry below).
- **Status:** confirmed in game by Four on 2026-11-02 (Julia Stevens battle and quest credit; a
  capture with several pets slotted adds 1 copy; the tamer is hidden during the fight and back right
  after it).

### Pet battles: win, capture and journal achievements never progress

- **Found** while fixing the slot unlocks: more pet battle criteria types were listed as "Not
  implemented yet" in `CriteriaHandler::UpdateCriteria`.
- **Cause:** criteria types 96 (`ADD_BATTLE_PET_JOURNAL`, a specific pet in the journal), 157
  (`CAPTURE_PET_IN_BATTLE`), 158 (`BATTLE_PET_WIN`), 161 (`CAPTURE_BATTLE_PET_CREDIT`) and 162
  (`LEVEL_BATTLE_PET_CREDIT`) did nothing, so achievements that count battle wins, captures or
  specific pets never moved. The win call also passed "is PvP" as the counted value, which is 0 for
  every PvE battle.
- **Changed:** new `tools/bfa/battle-pet-achievements.patch`:
  - `CriteriaHandler.cpp`: 157, 158 and 161 add 1 per capture or win and complete at the criteria's
    amount. 162 counts a pet reaching the criteria's level in battle. 96 completes when a pet of the
    criteria's creature is added, and at login if you already own one.
  - `PetBattle.cpp`: a win now counts 1; a capture also sends type 161.
  - No SQL.
  - Fix after Four's test (2026-11-02): the PvP-only win achievements check "is this a PvP battle"
    (criteria modifier 90) against the first criteria value, which the patch had turned into "1 win".
    So every PvE win passed it, and Four got No Time To Heal (6620, win 5 PvP battles in a row) from
    wild battles. Modifier 90 now reads the second value ("is PvP", 1 or 0), so asset 1 = PvP only
    (Pet Brawler 6595-6599, No Time To Heal) and asset 0 = PvE only. New
    `sql/fixes/characters/2026_11_02_00_remove_pve_pvp_pet_achievement.sql` removes 6620 and the
    progress on criteria 21525 and 22225 (worldserver stopped). Cat Fight (6594, criteria 19724) has
    no modifier and counts every win.
  - Fix after Four's test (2026-11-02): wins counted on the server (Cat Fight criteria 19724 at 7 in
    `character_achievement_progress`) but the achievement window never showed progress. Two packet
    bugs, both fixed as in TrinityCore 8.3.7: `SMSG_CRITERIA_UPDATE` (`AchievementPackets.cpp`,
    `CriteriaUpdate::Write`) lacked the final RafAcceptanceID bit, so the packet was a byte short; and
    account-wide achievements (all pet battle ones) need `SMSG_ACCOUNT_CRITERIA_UPDATE` with the
    criteria-progress layout, which the core sent only for "collect battle pets" and with the
    character layout. `PlayerAchievementMgr::SendCriteriaUpdate` now sends the account packet for every
    account-wide criteria, and `SendAllData` also sends `SMSG_ALL_ACCOUNT_CRITERIA` at login (new
    packet classes `AccountCriteriaUpdate` and `AllAccountCriteria`).
- **Note:** wins and captures from before the patch were never recorded, so those counters start at
  0. Journal criteria (96) are rechecked at every login.
- **Status:** confirmed in game by Four on 2026-11-02 (win counter shows and updates live, PvP-only
  achievements no longer earned from PvE).

#### To pick up both patches
Two new patches on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-achievements.patch | git apply && echo "pet achievements patch applied"
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-trainers.patch | git apply && echo "pet tamers patch applied"
grep -c "GOSSIP_OPTION_PET_BATTLE" src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2. Then restart `worldserver`.
## 2026-11-02 (pet battles, tamer teams)

### Pet battles: Legion and BFA pet tamers have no team

Merged to `main` with PR #32 on 2026-11-02. The guide's "Pet battles" section now lists both SQL files.

- **Found:** 23 Legion and BFA tamers that a quest asks you to beat in a pet battle had no rows in
  `battlepet_npc_team_member`, so "Let's do battle!" (from `tools/bfa/battle-pet-trainers.patch`,
  PR #31) had no team to put against you.
- **Changed:** new `sql/fixes/world/2026_11_02_60_legion_bfa_tamer_teams.sql` adds 69 rows (3 pets
  per tamer) for these tamers:
  - BFA, Kul Tiras: Captain Hermes 139489, Eddie Fixit 140315, Dilbert McClint 140461, Fizzie
    Sparkwhistle 140813, Michael Skarn 140880, Ellie Vern 141002, Leana Darkwind 141046, Kwint 141077,
    Delia Hanako 141292, Burly 141479.
  - BFA, Zandalar: Lozu 141529, Grady Prett 141799, Korval Darkbeard 141814, Keeyo 141879, Sizzik
    141945, Kusa 142054, Karaga 142096, Talia Sparkbrow 142114, Zujai 142234.
  - Legion: Crysa 115286, Environeer Bert 124617, Shipwrecked Captive 98489, Algalon the Observer 115307.
  - Species, level (all 25) and quality come from the Rematch addon's target data, which was captured
    from the real fights in game. Quality: BFA tamers rare (3), Crysa, Bert and the Shipwrecked Captive
    epic (4), Algalon legendary (5).
  - Abilities are each species' own abilities from `BattlePetSpeciesXAbility` (these tamer species
    have exactly 3, or 2 for Eddie Fixit's Rocket Chicken, Sizzik's Clubber and Bert's Corporal
    Hammer and M-37; the 3rd ability stays 0 there). Every row's `Comment` names the tamer, pet,
    quality and abilities.
  - `breadsMask` 8 (breed 3), like the existing Legion world quest tamer rows.
  - The pets' own creatures (Chum 141094 etc.) were already in `creature_template` with models.
- **Spawns:** Captain Hermes, Fizzie Sparkwhistle, Kwint, Korval Darkbeard, Crysa, Environeer Bert
  and Algalon had no spawn at all. New `sql/fixes/world/2026_11_02_61_legion_bfa_tamer_spawns.sql`
  adds one spawn each (guids 1157000001-1157000007). X/Y come from each tamer's world quest map
  marker (`quest_poi_points`), Z and facing from Four's `.gps` on the spot:
  - Captain Hermes 139489: map 1643, Drustvar, Crimson Coast (-1276.401, 4082.493, 1.894)
  - Fizzie Sparkwhistle 140813: map 1643, Drustvar, Arom's Crossing (-212.0, 3115.0, 313.669)
  - Kwint 141077: map 1643, Tiragarde Sound, on the sea floor (404.046, -1415.275, -53.367). The first
    mid-water spot (z -12.275) showed the gossip cursor but right-click did nothing; Four moved him
    down in game and the battle gossip appeared
  - Korval Darkbeard 141814: map 1642, Nazmir, The Dreadmire (2164.170, 1178.665, 1.072)
  - Crysa 115286: map 1, Northern Barrens (439.567, -3452.627, 92.388)
  - Environeer Bert 124617: map 0, Dun Morogh, Gnomeregan entrance (-5146.244, 826.715, 287.386)
  - Algalon the Observer 115307: map 571, Storm Peaks, Ulduar (9030.281, -1112.029, 1165.275)
- **Gossip:** Captain Hermes, Kwint, Crysa, Environeer Bert and Algalon had `creature_template.npcflag`
  0, so they couldn't be right-clicked and "Let's do battle!" never showed. Same file sets
  `npcflag` 0 -> 1 (gossip) for 139489, 141077, 115286, 124617, 115307.
- **Not done:** the Shipwrecked Captive 98489 has a team but no spawn (no known position).
- **Status:** Kwint confirmed in game by Four on 2026-11-02 (quest 52430 added with `.quest add`,
  "Let's do battle!" shown, battle started with his team). The other tamers are not tested in game
  yet; both SQL files loaded twice on a copy of the dump tables (MySQL 8.4) without errors. Needs
  `battle-pet-trainers.patch` (PR #31) to start the fights.

#### To pick up the tamer teams
SQL only (run the two mysql blocks one at a time), then restart `worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-0g0n74
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_02_60_legion_bfa_tamer_teams.sql | mysql -u root -p bfa_world
```
```
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_02_61_legion_bfa_tamer_spawns.sql | mysql -u root -p bfa_world
```

## 2026-11-02 (core)

### Startup banner: zrbfacore, no foreign Discord or email

Merged to `main` with PR #33 on 2026-11-02.

- **Asked** (Four): the console header should say zrbfacore in lower case ASCII art, the line
  `https://discord.gg/hTtSYh7WbQ | bfacore.reforged@gmail.com` should become "Based on HavenCore", and
  no other Discord or email contacts that aren't ours should show.
- **Where it lives:** the banner is `Trinity::Banner::Show` in `src/common/Banner.cpp`, which both
  `worldserver` and `bnetserver` print at startup. The worldserver also logs
  `BfaCore Reforged | bfacore.reforged@gmail.com` just before "ready..." (`src/server/worldserver/Main.cpp`,
  `main`). Those are the only Discord or email contacts the servers print. The databases (world dump,
  auth dump) have none.
- **Changed:** new `tools/bfa/core-branding.patch`:
  - `src/common/Banner.cpp`: the "BFA-HavenCore" art is replaced by "zrbfacore" in the same figlet font
    (Big Money-ne). The Discord/email line is replaced by `Based on HavenCore`. The line
    `World of Warcraft Emulator | Battle for Azeroth 8.3.7` stays.
  - `src/server/worldserver/Main.cpp`: `BfaCore Reforged | bfacore.reforged@gmail.com` becomes
    `zrbfacore | Based on HavenCore`.
  - Not changed: the first banner line (`BfaCore rev. <hash> ...`, from `src/common/GitRevision.cpp`),
    the default `Motd` in `worldserver.conf.dist`, and the Discord links in upstream's `README.md` and
    `pull_request_template.md` (never shown by the servers). Author credits in source comments
    (for example `WorldSocketMgr.h`) stay as they are.
- **Status:** confirmed by Four on 2026-11-02: the new banner shows on the server and works.

#### To pick up the new banner
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/core-branding.patch && echo "branding patch applied"
grep -c "Based on HavenCore" src/common/Banner.cpp src/server/worldserver/Main.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1 for each file. Then restart `worldserver` (and `bnetserver`, which prints the same
banner).

## 2026-11-01 (pet battles, slots)

### Pet battles: second and third battle slots never unlock

Merged to `main` with PR #30 on 2026-11-02.

- **Found** (reported by Four): the second battle pet slot stayed locked ("complete Newbie") although
  Four's pets are level 4 and 5.
- **Cause:** slots 2 and 3 open with the achievements Newbie (7433, raise a pet to level 3) and Just a
  Pup (6566, raise a pet to level 5) (`Player::GetUnlockedPetBattleSlot`). Their criteria are type 160
  (`CRITERIA_TYPE_BATTLE_PET_LEVEL_UP`). The core sends that criteria type when a pet levels in a
  battle or from a level item, but `CriteriaHandler::UpdateCriteria` listed it under "Not implemented
  yet" and did nothing, so no pet level achievement could ever complete.
- **Changed:** new `tools/bfa/battle-pet-level-achievements.patch`
  (`src/server/game/Achievements/CriteriaHandler.cpp`): type 160 completes when the level reached is at
  least the criteria's level. At every login the core rechecks all criteria with no level given; then
  it checks the levels of the pets you own, so pets that are already high enough count. Added to
  `IsCompletedCriteria` (done at 1). The existing achievement hook then sends the slot unlock. No SQL.
- **Status:** confirmed in game by Four on 2026-11-02 (Newbie and Just a Pup awarded, slots 2 and 3
  open).

#### To pick up the pet level achievements
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-level-achievements.patch | git apply && echo "pet level patch applied"
grep -c "Newbie (7433, level 3)" src/server/game/Achievements/CriteriaHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in: Newbie and Just a Pup should pop and both
slots open.

## 2026-11-01 (pet battles)

### Pet battles: wild battle pets missing from most zones

Merged to `main` with PR #29 on 2026-11-01.

- **Found** (reported by Four): Pet Tracker shows Forest Spiderling, Tree Python and Lizard
  Hatchling spawns in Northern Stranglethorn, but in game those were plain neutral critters
  (Lizard Hatchling 50479 at level 1, Forest Spiderling 50487 at level 90), not battle pets.
- **Cause:** `battlepet_wild_zone_pool` lists, per zone, which critter becomes which battle pet and
  how many pets the zone should have. The core's runtime swap (`Map::PopulateBattlePet`) is never
  called anywhere, so only battle pets spawned directly in `creature` ever existed. Northern
  Stranglethorn (area 33) had about 60 battle Beetles (61319) and 23 Strand Crabs (61312), but no
  Tree Python (61318), Forest Spiderling (61320) or Lizard Hatchling (61321) battle pets.
- **Changed:** new `sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql`. For each pool row
  whose battle pet template is a wild pet (type 14), it counts the pets already spawned in the zone
  (`creature.zoneId` or `areaId`) and converts random critter spawns of that zone into the battle
  pet until the zone's `Max` is reached or the critters run out. Critters with a per-spawn SmartAI
  script are skipped. On the dump that is about 4,700 or more spawns in 81 zones; Northern Stranglethorn
  gets 62 Tree Pythons, 54 Lizard Hatchlings, about 56 Forest Spiderlings (all its critters), 8 more Beetles, 3 Crimson Moths and a Long-tailed
  Mole. Every converted spawn is recorded in the new table `zr_wild_battlepet_conversion`, so it can
  be undone (the SQL file's header has the two lines). Running it twice converts nothing new.
  No core change.
- **Docs:** guide section 9, "Pet battles".
- **Status:** run on Four's live DB on 2026-11-01: 5,900 spawns converted in 86 zones (more than
  the dump estimate, which could not parse some templates). Confirmed in game by Four.

#### To pick up the wild battle pet spawns
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_50_wild_battle_pet_spawns.sql | mysql -u root -p bfa_world
```
The last line prints the number of converted spawns and zones. Then restart `worldserver`.

## 2026-11-01

### World: quest items from one unique mob now always drop (508 items)

- **Asked** (Four): if a named mob is the only source of a quest item, it should drop on every kill
  while you're on the quest. Items that drop from many common mobs (hides, claws) stay random.
- **How the list was picked** from the world dump (all INSERT blocks parsed):
  - the item is a quest objective (`quest_objectives` Type 1) and the quest needs exactly 1;
  - it only comes from `creature_loot_template` (no gameobject, container, pickpocket, skinning or
    reference loot), with every row `QuestRequired` 1, `GroupId` 0, `Reference` 0;
  - every creature that drops it has at most one spawn point. Creatures with no spawn (summoned by
    events) count only when they are elite or their name is unique, so summoned generic mobs stay
    random; 7 summoned named mobs were added by hand (Anaya Dawnrunner, Captain Halyndor, Saragosa,
    Stalvan Mistmantle, Gardul Venomshiv, Jergosh the Invoker, Torturer Relyn);
  - at most 6 creatures drop it, raids are left alone (13 items, e.g. AQ20 tokens, Nightbane), and
    where several creatures drop it, rows under 10% are left alone (stray low-chance copies).
- **Changed:** `sql/fixes/world/2026_11_01_03_unique_mob_quest_drops.sql` sets
  `creature_loot_template.Chance` = 100 on 517 rows (508 items). Before: 58 rows were under 50%,
  161 between 50% and 90%, 298 at 90% or more. Each row in the file has a comment with the creature,
  its old chance and the quest. `QuestRequired` stays 1, so nothing drops without the quest.
  Examples: Goldtooth 327 (61.86%), Princess 330 (66.87%), Jammal'an the Prophet 5710 (49.89%),
  Gahz'rilla 7273 (56.45%), Dockmaster 6846 (0.44%).
- **Status:** merged 2026-11-01 without a dedicated in-game test (the Esquivel case above is the same
  change on 4 rows and was confirmed). Report any named quest mob that still misses its item.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_03_unique_mob_quest_drops.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### World: Chief Esquivel rarely drops the Whispering Blue Stone

- **Found** (reported by Four): Chief Esquivel (43912, Kurzen compound cave in Northern
  Stranglethorn) often dies without dropping the quest item for The Source of the Madness.
- **Cause:** Whispering Blue Stone (item 60263, 1 needed for quest 26734) is a quest-only drop with
  low chances on the four chiefs the quest sends you to: Chief Anders 43910 26.67%, Chief Gaulus
  43911 13.86%, Chief Esquivel 43912 7.68%, Chief Miranda 43913 18.39%.
- **Changed:** `sql/fixes/world/2026_11_01_02_whispering_blue_stone_kurzen_chiefs.sql` sets
  `creature_loot_template.Chance` = 100 for item 60263 on 43910, 43911, 43912 and 43913 (QuestRequired
  stays 1, so it only drops while you're on the quest). The regular Kurzen troops (939, 941, 942, 978,
  979) keep their 1-5% chance.
- **Status:** confirmed in game by Four (2026-11-01): Chief Esquivel dropped the stone.
- **Pick up:** SQL only, no rebuild:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_02_whispering_blue_stone_kurzen_chiefs.sql | mysql -u root -p bfa_world
```

Then restart worldserver.

### Core: dying never turned you into a proper ghost (battle pet code wiped player flags)

- **Found** (reported by Four): after `.die` or a creature kill and Release Spirit, you arrive at the
  graveyard as a "ghost" in a normal, living world. The Spirit Healer won't talk to you, there is no
  corpse arrow, and the character screen shows you alive. Relogging doesn't fix it. A fall death
  sometimes worked.
- **Cause:** the server did make you a ghost (`.list auras` shows Ghost 8326 and wisp 20584), but three
  battle pet functions *replace* all player flags with `PLAYER_FLAGS_PET_BATTLES_UNLOCKED` (0x400000)
  instead of adding it: `Player::_LoadPetBattles` (login), `WorldSession::SendBattlePetJournal`
  (login, teleports, every journal request) and `WorldSession::SendPetBattleSlotUpdates`. That wipes
  `PLAYER_FLAGS_GHOST` (0x10), which is what the client uses for the grey world, Spirit Healer and
  corpse arrow, and it was saved without the flag. They only run once a battle pet slot is unlocked,
  so this started after the battle pet slot fix (2026-10-25).
- **Changed:** new `tools/bfa/battle-pet-player-flags.patch` (applied after `battle-pet-journal.patch`):
  `SetPlayerFlags(PLAYER_FLAGS_PET_BATTLES_UNLOCKED)` becomes `AddPlayerFlag(...)` in
  `Player.cpp` (`_LoadPetBattles`) and `BattlePetHandler.cpp` (`SendPetBattleSlotUpdates`,
  `SendBattlePetJournal`). This also stops AFK, DND and resting flags being cleared the same way.
- **Status:** confirmed in game by Four (2026-11-01): death and release give a proper ghost again.
- **Pick up:** rebuild with the new patch and restart worldserver:

```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-player-flags.patch | git apply
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```

### World: Astranaar crowded by a siege that only belongs to its quests

- **Found** (reported by Four): Astranaar is packed with soldiers, Horde Hellions and Wind Riders and
  Throwers, while the town itself looks calm (no fires).
- **Cause:** 193 spawns in Astranaar (area 415) belong to the Cataclysm siege quests but have no phase,
  so everyone sees them all the time: Hellscream's Hellion 34163 (15), Watch Wind Rider 34160 (15),
  Astranaar Skirmisher 34419 (23), Astranaar Sentinel 34494 (59), Astranaar Officer 34420 (5),
  Astranaar Thrower 34132 (12) and 34492 (9), Thrower Bunny 34501 (9), fire bunnies 34123 (34),
  Phase Q1 Generic Bunny JSB 34439 (12). The Pandaria DB has the same unphased spawns.
- **Changed:** `sql/fixes/world/2026_11_01_01_astranaar_siege_quest_phase.sql` moves those 193 spawns
  to phase 295 (in Phase.db2, normal phase, unused anywhere else in the DB) and adds `phase_area`
  (415, 295) with `conditions` (source type 26) that turn it on while any siege quest is in progress or
  complete: 13849 Astranaar's Burning!, 13853 Return Fire (Alliance), 13943 Breathing Room,
  13947 Blastranaar! (Horde). The town guards (6087, 51770), vendors and Hellscream's Watch are
  untouched. The revert line is in the file.
- **Status:** confirmed in game by Four (2026-11-01): Astranaar is calm without the quest.

#### To pick up the Astranaar siege phase
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_01_astranaar_siege_quest_phase.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Astranaar flight master Daelyshia lies dead

- **Found** (reported by Four): the Astranaar Hippogryph Master Daelyshia (4267, spawn 239983) lies
  on the ground as a corpse and can't be talked to, so Astranaar has no Alliance flight master.
- **Cause:** her BFA template was taken while she was dead in a war phase: `npcflag` 0, `unit_flags`
  0x20040300 (stunned + feign death), `unit_flags2` 0x801 (feign death), `unit_flags3` 0x2000.
- **Changed:** `sql/fixes/world/2026_11_01_00_astranaar_flight_master_daelyshia.sql` sets entry 4267 to
  `npcflag` 8193 (gossip + flight master, as in the Pandaria DB), `unit_flags` 768, `unit_flags2`
  2048, `unit_flags3` 0. Gossip menu 0 already has the "I want to travel fast" option.
- **Status:** confirmed in game by Four (2026-11-01): Daelyshia is alive and offers flights.

#### To pick up the flight master fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_11_01_00_astranaar_flight_master_daelyshia.sql | mysql -u root -p bfa_world
```
Then restart `worldserver` and delete the client's `Cache` folder (the client caches creature data).

## 2026-10-31

### World: 37 creature spawns ignored their own scripts (junk "Fel Hands" spawn rows)

- **Found** (Dungeon Fixes thread, while fixing Lady Falther'ess in Razorfen Downs): 44 creature
  spawns carry a per-spawn SmartAI row (`entryorguid` = -guid) that casts Fel Hands (207101, a
  Legion dummy aura with no effect) out of combat, comment `OOC - CS`.
- **Cause:** a per-spawn script replaces the creature's own entry script entirely, so these spawns
  only meleed. Examples: Warsong Demolishers (32850) never threw Flaming Balls or exploded,
  Rampaging Owlbeasts (49245) never used Shred, Northwatch Guards (38636) never shot, Gnomeregan's
  Dark Iron Land Mines (8035) never detonated, Dark Keeper Uggel (9439) never cast.
- **Changed:** `sql/fixes/world/2026_10_31_05_fel_hands_spawn_scripts.sql`:
  - Deletes the 207101 rows for 42 guids (the full list by map is in the file). Razorfen Downs
    373574/373575 are left to `2026_10_31_04` (PR #26). 5 of the guids have no spawn; their rows go too.
  - Northwatch Guard 38636 had two script versions mixed together: removes id 0 (event 0, Cast
    Shoot), id 1 (event 2, Shield Block) and id 2 (event 0, Revenge), all with link 0, which duplicate
    ids 4, 16 and 17. The linked ranged chain (ids 0-19) stays.
  - Grishna Raven 20327 and Theldren 16059 have no entry script, so they only lose the dummy row.
- **Status:** confirmed in game by Four (2026-11-01): Rampaging Owlbeasts in Hillsbrad cast Shred again.

#### To pick up the spawn script fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_05_fel_hands_spawn_scripts.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Warsong Demolisher Flamethrower one-shots players

- **Found** (reported by Four, testing the spawn script fix): a Warsong Demolisher (32850, level 23,
  Ashenvale) killed Four with Flamethrower: 764 fire on hit, then 144 fire every second.
- **Cause:** with its own script running again (entry above), row id 3 casts Flamethrower (65388)
  within 20 yards every 14-19 s. 65388 is a vehicle weapon whose damage scales with the caster's level
  by a large coefficient (about 38.6 per hit, 7.7 per tick).
- **Changed:** `sql/fixes/world/2026_10_31_06_warsong_demolisher_flamethrower.sql` deletes that one
  row (entry 32850, id 3, spell 65388). Flaming Ball (61865), the out-of-combat ball at trigger NPCs
  (61864) and the death explosion (65417) stay.
- **Follow-up (2026-11-01):** Four found the demolishers then only meleed and stood still, and Flaming
  Ball never fired. The same file now also deletes ids 0 and 1 (event 4 aggro, action 21 "stop combat
  movement" with 0), so they chase their target instead of standing rooted.
- **Follow-up 2 (2026-11-01):** after killing Four they never reset and kept swinging at the spot.
  Row id 6 (on spawn, action 117 disable evade, linked to id 7 "set aggressive") is now a plain
  "on spawn, set aggressive" (action 8, param 2, link 0) and id 7 is deleted, so they can evade and
  leash again.
- **Status:** confirmed in game by Four (2026-11-01): Demolishers no longer one-shot and leash home.

#### To pick up the Flamethrower fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_06_warsong_demolisher_flamethrower.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Spirit Healers doubled or tripled at 117 graveyards

- **Found** (reported by Four): the Nightsong graveyard near Raynewood Tower in Ashenvale
  (`world_safe_locs` 1427) has two Spirit Healers (6491) on the same spot, and Astranaar has three.
  Four asked to clear the same doubling everywhere.
- **Cause:** a block of added Spirit Healer spawns (mostly guids 371188-371416 and 375076-375097, and
  on the Broken Isles 20549126-20549205) repeats graveyards that already had one. A scan of all 876
  Spirit Healers found 117 graveyards with two or three within 25 yards of each other (height within
  10), same phase and difficulty.
- **Changed:**
  - `sql/fixes/world/2026_10_31_07_nightsong_spirit_healer_duplicate.sql` deletes spawn 371367
    (Nightsong). Spawn 129879 stays.
  - `sql/fixes/world/2026_10_31_08_spirit_healer_duplicates.sql` deletes 132 spawns (Kalimdor 53,
    Eastern Kingdoms 34, Broken Isles 40, Outland 2, Pandaria 2, Northrend 1; 371367 is in the list
    too). Astranaar keeps 40868 (239931 and 371366 go). Each graveyard keeps one healer: the sniffed
    spawn where there is one (452538, 452539, 210117416, 210118234), otherwise the lowest guid. None of
    the removed guids is in a pool, game event, formation or `creature_addon` row. The first version
    of this file (5-yard scan, 85 spawns) is a subset, so running the new one after it is fine.
- **Status:** confirmed in game by Four (2026-11-01): Astranaar and Raynewood Tower each show one Spirit Healer.

#### To pick up the Spirit Healer fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_07_nightsong_spirit_healer_duplicate.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_08_spirit_healer_duplicates.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: Bloodlord Mandokir never leaves the Rebel Camp after his quest

Merged to `main` with PR #25 on 2026-10-31.

- **Found** (reported by Four): after turning in "Bloodlord Mandokir" (quest 26748) in the Rebel
  Camp, a friendly Bloodlord Mandokir (43989, no DB GUID, faction 35) stays there for good and
  stands in front of another NPC.
- **Cause:** the quest's reward spell 82340 summons 43989 (SummonProperties 492, infinite duration).
  The quest giver 42790 itself is despawned by `npc_bloodlord_mandokir`, but the summon has no script
  at all, so nothing ever removes it. The Horde version (quest 26334 at Grom'gol, reward spell 79783)
  summons 42799 the same way and has the same problem.
- **Changed:** `sql/fixes/world/2026_10_31_00_mandokir_reward_summon_despawn.sql` adds one
  `smart_scripts` row each for 43989 and 42799 (there were none): event 54 (just summoned), action 41
  (force despawn) after 5000 ms, target self. `AIName` stays `SmartAI`.
- **Status:** confirmed in game by Four on 2026-10-31 (new character, Mandokir vanished after the turn-in).

#### To pick up the Mandokir fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_31_00_mandokir_reward_summon_despawn.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`. The restart also removes the Mandokir already standing in the camp.

## 2026-10-30

### World: critters and wild battle pets stacked on one spot, and none of them wander

Merged to `main` with PR #24 on 2026-10-31.

- **Found** (reported by Four): in Stranglethorn a Beetle (61319, wild battle pet, guid 10647972),
  a Tree Python (49722, guid 10647911) and a Lizard Hatchling (50479, guid 10648091) stood on the
  same spot (-11459.5, -273.45, 42.9962) without moving.
- **Cause:** the BFA dump has a block of 8,460 critter and wild battle pet spawns added without sniff
  data (VerifiedBuild 0, orientation 0, respawn 120 s, MovementType 0, spawndist 0). 596 of their
  spots carry 2 to 5 creatures on exactly the same coordinates (1,275 spawns), and none of the block
  moves.
- **Changed:** `sql/fixes/world/2026_10_30_02_critter_spawns_stacked_and_still.sql`:
  - Each stacked spot becomes a pool that spawns one of its creatures at a time (`pool_template`
    5100001 to 5100596, `max_limit` 1; `pool_creature` rows for the 1,275 guids, equal chance). The
    Stranglethorn spot above is pool 5100506.
  - The 8,188 spawns of the block that can walk (InhabitType has the ground bit) get `MovementType`
    1 and `spawndist` 3.5 (was 0 and 0), the radius the core already uses for wild battle pets that
    replace critters (`WildBattlePetMgr::ReplaceCreature`). The 272 flying-only or water-only ones stay put.
  - Only critters (type 8) and the wild battle pet entries in `battlepet_spawn_relation` and
    `battlepet_wild_zone_pool` (Max above 1) are touched, so pet vendor and pet tamer displays
    (Darkmoon Faire, Booty Bay, Deepholm) are left alone. Sniffed critters outside the block are
    unchanged. Safe to run twice; the revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-31.

#### To pick up the critter spawn fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_02_critter_spawns_stacked_and_still.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### World: 248 creatures had no creature type (Sap failed on Bloodscalp Warriors)

Merged to `main` with PR #23 on 2026-10-30.

- **Found** (reported by Four): Sap didn't work on a Bloodscalp Warrior (587, guid 183856,
  Stranglethorn), a humanoid.
- **Cause:** in the BFA dump, 248 `creature_template` rows (mostly entries 3 to 660, plus a few later
  ones) have `type` 0 ("None") and the real creature type in the `family` column. 587 has type 0,
  family 7, where 7 is Humanoid. A creature of type 0 is not a Humanoid, Beast or Undead to the core,
  so every spell limited to a creature type fails on it: Sap, Polymorph, Hibernate, Shackle Undead,
  Banish, Turn Evil, Scare Beast and others. The tameable beasts in the list also lost their pet family.
- **Changed:** `sql/fixes/world/2026_10_30_00_creature_type_from_family.sql` sets `type` and
  `family` from the Pandaria 5.4.8 world DB, which agrees with the shifted value for all 248:
  - Humanoid (type 7): 200 creatures, including Bloodscalp Warrior 587, Hogger 448, Kobold Vermin 6,
    Defias Smuggler 95, the Westfall Bridge Workers 649-653. Family 0.
  - Undead (6): 16, including Flesh Eater 3 and Skeletal Warrior 48. Elemental (4): 3, including
    Rock Elemental 92. Mechanical (9): 3. Dragonkin (2): 1. Critter (8): 1. Giant (5): Sea Giant 90.
    Not specified (10): Magma Trap 53086. Family 0 for all.
  - Beast (1) with their family: wolves (1) 118, 213, 521, 565; spiders (3) 442, 471, 505, 539, 569,
    574, 616; boars (5) 113, 119, 330, 345, 454, 524; carrion birds (7) 154, 199, 462; family 0 for
    Kodo Beast 106 and Palomino 306.
  - Left alone: Tall Strider 105 and five Draenor creatures (75533, 75703, 75763, 76120, 77140) that
    also have type 0 with a family, because Pandaria has nothing to check them against.
  - Only rows still at type 0 change, so it is safe to run twice. The revert line is in the file.
- **Status:** confirmed in game by Four on 2026-10-30 (Sap works on Bloodscalp Warriors). The game
  client caches creature types: delete the `Cache` folder in the WoW folder after running the SQL.

### World: Bloodscalp Tusks for Hunt for Yenniku almost never dropped

Merged to `main` with PR #23 on 2026-10-30.

- **Found** while checking Bloodscalp loot for Four: Hunt for Yenniku (26298) needs 6 Bloodscalp
  Tusks (3901) from any Bloodscalp troll. All 11 Bloodscalp types have the tusk as a quest drop, but
  only Warriors 587 (36%) and Axe Throwers 694 (36.81%) drop it often. Shamans 697 have 10%, and
  Scouts 588, Hunters 595, Berserkers 597, Witch Doctors 660, Headhunters 671, Beastmasters 699,
  Mystics 701 and Scavengers 702 between 0.1% and 1.27%. The Pandaria world DB has 50% on all of them.
- **Changed:** `sql/fixes/world/2026_10_30_01_bloodscalp_tusk_drop_rate.sql` sets `Chance` 50 on those
  11 rows (`Item` 3901, `QuestRequired` 1) where it was lower. The old values are in the file.
- **Checked, no change:** the other Bloodscalp quest drops are fine: Shrunken Head 1532 for
  Headhunting (73-74% on 597, 660, 671), Bloodscalp Totem 23679 for Bloodscalp Insight (34.5% on the
  Shaman 697), and the three items for Sacred to the Bloodscalp (60270-60272, about 11% each on the
  Scavenger 702). Their normal loot (cloth, food such as Mutton Chop, potions, greens, greys) is there
  too: 123 to 302 rows per Bloodscalp.
- **Status:** confirmed in game by Four on 2026-10-30.

#### To pick up the creature type and Bloodscalp Tusk fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_00_creature_type_from_family.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_30_01_bloodscalp_tusk_drop_rate.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

### Core: skinning refused after learning Cataclysm Skinning

Merged to `main` with PR #22 on 2026-10-30.

- **Found** (reported by Four): Delotha could no longer skin creatures well within her skill, such as
  a Redridge Fox (43083, level 15-16, needs 50). The DB had Skinning (393) 1/75, Cataclysm Skinning
  (2561) 1/75 and Classic Skinning (2564, the "Skinning 162/300" line) 162/300.
- **Cause:** the skinning cast check (`Spell::CheckCast`, `SPELL_EFFECT_SKINNING`) reads the profession
  skill 393. `Player::SetSkill` (upstream) and `Player::UpdateSkillPro` (our
  `profession-skill-sync.patch`) both copied whichever expansion skill changed last into it, so
  learning Cataclysm Skinning at 1 set Skinning to 1/75. Herbalism (182) and Mining (186) had the same
  flaw: learning a second expansion tier would have turned their nodes orange or refused them again.
- **Changed:** `tools/bfa/profession-skill-sync.patch` (`src/server/game/Entities/Player/Player.cpp`):
  new `SyncParentProfessionSkill` sets the profession skill to the value, max and tier of its highest
  expansion skill. `UpdateSkillPro` and the end of `SetSkill` call it instead of copying the skill
  that changed. No SQL. Compiles with GCC 13 on the full patch chain.
- **Status:** confirmed in game by Four on 2026-10-30: skinning works again.

#### To pick up the skinning fix
`profession-skill-sync.patch` changed, so swap the old version for the new one, then build and
restart. The other patches you applied are unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin main
git -C ../tools-repo show b83c110:tools/bfa/profession-skill-sync.patch | git apply -R && echo "old patch removed"
git -C ../tools-repo show origin/main:tools/bfa/profession-skill-sync.patch | git apply && echo "new patch applied"
grep -c SyncParentProfessionSkill src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Both echo lines print, and the grep prints 3. Then restart `worldserver`.

## 2026-10-26

### Pet battles: summoned pets show as Murkimus, released pets come back

Merged to `main` with PR #21 on 2026-10-31.

- **Found** (reported by Four): summoning Black Lamb, Stormwind Rat or Cat from the Pet Journal
  spawned Murkimus the Gladiator. A Black Lamb released from the journal kept showing up again.
- **Cause, Murkimus:** pets with no summon spell of their own are summoned with spell 118301
  (Summon Battle Pet), whose MiscValue is a placeholder creature, 40721 Murkimus the Gladiator
  (TrinityCore 8.3.7 notes the same). The core used that creature as is. It also never set the
  player's `SummonedBattlePetGUID`, so the summon was not tied to the journal pet at all.
- **Cause, released pets:** on login the core loaded only the first row of each species from
  `account_battlepet` and silently skipped the rest. Extra copies stayed in the DB, hidden, and
  one of them showed up again after a release and relog. Releasing the last copy of a species
  was also silently refused.
- **Changed:** new `tools/bfa/battle-pet-journal.patch`:
  - `Player.cpp` `SummonBattlePet`: sets `SummonedBattlePetGUID` and the last summoned pet before
    casting, and remembers the spawned critter. `UnsummonCurrentBattlePetIfAny` clears it.
  - `SpellEffects.cpp` `EffectSummonType`: for 118301 the creature is the journal pet's species
    `CreatureID` instead of 40721.
  - `SpellEffects.cpp` companion summon, after the creature's level and NPC flags are set from its
    template: when the critter is the journal pet, the wild battle flag is taken off again (first
    version left the Stormwind Rat battleable), the pet's own display model is used, and its health
    is set to the pet's journal max health. Wild pet templates have tiny health modifiers (Black Lamb
    60649 has `HealthModifier` 0.01), which gave 0 health, so the summon showed up dead.
  - `Player.cpp` `_LoadPetBattles`: loads every copy of a species.
  - `BattlePetHandler.cpp`: release no longer checks species flag 0x8. The core calls it
    `NOT_RELEASABLE`, but in 8.3.7 0x8 is Capturable (TrinityCore's `BattlePetSpeciesFlags`), so
    every wild pet such as the Black Lamb was refused and stayed in the DB (second version still
    brought the lamb back on every relog). Release also works on the last copy, dismisses the pet if it is out
    and clears it from a battle slot. Clicking summon on a pet whose critter is gone now summons
    it instead of doing nothing.
  - No SQL.
- **Status:** first version (2cc26f6) summoned the right creature but dead and battleable. Second
  version (bb1835b): summons confirmed in game by Four on 2026-10-26, released Black Lamb still came
  back. Third version (release flag check removed): release confirmed in game by Four on
  2026-10-26. Summons and release both done.

#### To pick up the pet journal fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-cwgt5u
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-journal.patch | git apply
grep -c "is Capturable in 8.3.7" src/server/game/Handlers/BattlePetHandler.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in again.

## 2026-10-25

### World: battle pet slots stayed locked after Battle Pet Training

Merged to `main` with PR #15 on 2026-10-25.

- **Found** (reported by Four): after paying a Battle Pet Trainer for Battle Pet Training (spell
  119467, 10 gold from `npc_trainer`), the first battle slot in the Pet Journal stayed unusable, so no
  pet could be slotted.
- **Cause:** 119467 is a passive spell whose only effect is 201 (`SPELL_EFFECT_ENABLE_BATTLE_PETS`,
  checked in Four's SpellEffect.db2/SpellMisc.db2). The core casts it when it is learned and again at
  every login, and the effect sends `SMSG_PET_BATTLE_SLOT_UPDATES` to tell the client which slots are
  open. The core wrote that packet in the wrong order: the slot list first, then the `NewSlotUnlocked`
  and `AutoSlotted` bits. The 8.3.7 client reads the two bits first (TrinityCore's 8.3.7 code,
  tag TDB837.20101, writes them first), so it misread every slot in the packet. The same packet goes
  out when the Newbie (7433) and Just a Pup (6566) achievements unlock slots 2 and 3.
- **Changed:** new `tools/bfa/battle-pet-slots.patch`
  (`src/server/game/Server/Packets/BattlePetPackets.cpp`, `SlotUpdates::Write`): the two bits and
  the flush now come before the slots. Nothing else in the packet changed. The other battle pet
  packets (journal, pet updates, set slot) already match 8.3.7, as do their opcode numbers. No SQL.
- **Status:** confirmed in game by Four on 2026-10-25.

#### To pick up the battle pet slot fix
A new patch on top of the others, the build and a restart. The patches you already applied are
unchanged.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-tt7jn2
git -C ../tools-repo show FETCH_HEAD:tools/bfa/battle-pet-slots.patch | git apply
grep -c "the two bits before the slots" src/server/game/Server/Packets/BattlePetPackets.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver` and log in again.

## 2026-10-25

### Razorfen Kraul: second run (Bonetusk's Barrage and boars, Groyat's Sonic Charge, Charlga's binding)

From Four's second run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_06_razorfen_kraul_second_run.sql`.

- **Found** (reported by Four):
  - Hunter Bonetusk's Barrage did nothing, and his boars stayed up after he died. They are elites,
    so killing them one by one is slower than racing Bonetusk. Barrage (150881) is a channel whose
    damage comes from a periodic spell (150884) fired from an aura on Bonetusk; this core casts that
    spell at Bonetusk himself, not at his channel target, so it never hits anyone.
  - Groyat's Sonic Charge (151454) only moved him. After the leap it lays 12 damaging area triggers
    (spell 151407, areatriggers 1465-1476), and none of those are in the database.
  - Charlga still cast Elemental Binding too often.
- **Changed:**
  - Bonetusk: Barrage replaced by Aimed Shot (27632) at his target every 12-16 seconds (first after
    6-9), plus Serpent Sting (31975) on a random player every 12-15 seconds (first after 3-5). His
    three boars are now three different Agam'ar, Raging (4514), plain (4511) and Rotting (4512), so
    each can be found again by entry, and all three despawn when he dies.
  - Groyat: right after Sonic Charge he casts its damage spell (151429) on his target.
  - Charlga: Elemental Binding every 25-30 seconds instead of 15-20.
  - Sonic Field: nothing new. `2026_10_25_04` already swapped it for Sonic Burst (8281).
- **Status:** confirmed in game by Four on the third run (2026-10-25): Bonetusk, Groyat and Charlga
  "all perfect".

### Razorfen Kraul: Charlga Razorflank only cast Elemental Binding

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_05_razorfen_kraul_charlga.sql`.

- **Found** (reported by Four: one melee hit, then Elemental Binding for the rest of the fight; credit,
  loot, scenario and achievement fine): her SmartAI recast Elemental Binding (151583, root plus
  damage over time) every 6 seconds after the first 10. Crystalline Command (151534) only has a dummy
  effect this core doesn't script, and two rows both said an aggro line.
- **Changed:** rows 2, 3, 4 and 6 replaced. Elemental Binding on a random player every 15-20 seconds,
  Chain Bolt (8292) at her target every 6-9 seconds, Renew (8362) on herself below 50% health. Her
  speech and the death event that wakes the Spirit of Agamaggan stay. Her classic Purity (8361) is
  left out because it makes her immune to all damage.
- **Status:** confirmed better in game by Four on the second run (2026-10-25), but Binding still came
  too often; slowed to 25-30 seconds in `2026_10_25_06`, confirmed on the third run.

### Razorfen Kraul: Groyat's Sonic Field did nothing

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_04_razorfen_kraul_groyat.sql`.

- **Found** (reported by Four: Sonic Charge, melee and Drain Life work, Sonic Field showed nothing;
  credit and loot fine): Sonic Field (151432) has only a dummy effect, which needs a spell script
  this core doesn't have.
- **Changed:** that row (id 2) casts Sonic Burst (8281) instead, the classic Blind Hunter's attack:
  weapon damage and a short silence within 13 yards, first after 6-8 seconds, then every 12-16.
- **Status:** Groyat's spawn, credit, loot and fight confirmed in game by Four (2026-10-25, second
  run). Sonic Charge damage added in `2026_10_25_06`; Sonic Burst and Sonic Charge confirmed on the
  third run.

### Razorfen Kraul: Agathelos the Raging healed to full mid-fight

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_03_razorfen_kraul_agathelos.sql`.

- **Found** (reported by Four, who had to use `.die`): Agathelos (4422) casts Left for Dead (8555),
  which hits and then forces the target to feign death (8359). Feign death drops the player from his
  threat list, so a solo player leaves him with nobody to fight and he evades back to full health.
  No other creature uses it.
- **Changed:** the Left for Dead row (id 6) is deleted. He keeps Rushing Charge, Frenzy at 60% and
  40%, Rampage and Call for Help.
- **Status:** confirmed in game by Four on the second run (2026-10-25): the fight went well.

### Razorfen Kraul: Warlord Ramtusk only meleed

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_02_razorfen_kraul_ramtusk.sql`.

- **Found** (reported by Four): Ramtusk (74462) meleed and threw a single Spirit Axe. Spirit Axe
  (151312) was his only spell, first after 8-12 seconds and then every 10-20; the rest of his script
  was speech rows with no texts and a door opener aimed at a gameobject that isn't spawned. The axe's
  odd texture is the spell's client-side visual, which the server can't change.
- **Changed:** new SmartAI. Spirit Axe at a random player every 10-14 seconds (first after 6-8), plus
  the kit of the classic Overlord Ramtusk he replaced: Battle Stance (7165) on reset, Battle Shout
  (9128), and Thunderclap (15548) when a player is within 8 yards. His axes come from
  `2026_10_25_01`.
- **Not changed:** how hard he hits; difficulty is tuned through DungeonScale.
- **Status:** confirmed good in game by Four on the second run (2026-10-25).

### Razorfen Kraul: Hunter Bonetusk only shot, and held no weapon

From Four's first run, 2026-10-25. SQL only: `sql/fixes/world/2026_10_25_01_razorfen_kraul_bonetusk.sql`.

- **Found** (reported by Four): Bonetusk (75001) only used Shoot, had no weapon in his hands, and a
  Boar Spirit next to him died at once. His SmartAI fired Shoot (150879) every 1-2 seconds at any
  range up to 20 yards, so it kept him busy whenever his other spells came up. Volley (150904) only
  has dummy effects that need a spell script this core lacks, and Stampede (150917) triggers spell
  132660, which isn't in the client's spell data. His speech rows point at texts that don't exist.
  None of the Warlords bosses had an equipment row. The Boar Spirit (6021, guid 325407) belonged
  to Aggem Thorncurse, the classic boss Bonetusk replaced.
- **Changed:**
  - New SmartAI: he chases and melees, Shoots at 5-30 yards, channels Barrage (150881, interrupting
    his current cast), uses Multi-Shot (21390) on a random player, and at 50% health three Raging
    Agam'ar (4514) charge in around his target, standing in for the broken Stampede.
  - Equipment: Bonetusk gets the Razorfen Beastmaster's dagger and bow (2184, 2551); Warlord Ramtusk
    (74462) gets the classic Overlord Ramtusk's two axes (5286).
  - The Boar Spirit spawn is deleted.
- **Status:** tested by Four on the second run (2026-10-25): Barrage did nothing (replaced in
  `2026_10_25_06`), and the boars came in but outlived him (they despawn with him since
  `2026_10_25_06`). The `2026_10_25_06` changes were confirmed on the third run.

### Razorfen Kraul: pre-run check

Before Four's first run. All SQL, in `sql/fixes/world/2026_10_25_00_razorfen_kraul.sql`; no rebuild.

#### Groyat, the Blind Hunter had no spawn
- **Found:** the scenario (654) needs five kills: Hunter Bonetusk (75001), Roogug (74948), Warlord
  Ramtusk (74462), Groyat (75247) and Charlga Razorflank (4421). The BFA spawns swap three classic
  bosses for their Warlords versions (Aggem Thorncurse, Overlord Ramtusk and a Groundshaker), but
  the classic Blind Hunter (4425) was left in Groyat's room, so the scenario could never finish.
  Groyat also had no scaling row for difficulty 1.
- **Changed:** spawn 52982 is now Groyat (75247), and he gets the scaling row.

#### Two Roogugs
- **Found:** the classic Roogug (6168, guid 325276) was still spawned besides the new one (74948).
- **Changed:** the classic spawn is deleted.

#### Dungeon encounters
- **Found:** `instance_encounters` only had 438 Roogug, pointing at the classic Roogug, so no kill
  completed a dungeon encounter or the dungeon finder entry.
- **Changed:** the client's DungeonEncounter rows for map 47: 438 Roogug (now 74948), 1656 Hunter
  Bonetusk, 1659 Warlord Ramtusk, 1660 Groyat, 1661 Charlga Razorflank (last boss of dungeon finder
  entry 16).

#### Double pets
- **Found:** Razorfen Handler (4530), Beast Trainer (4531) and Beastmaster (4532) had two SmartAI
  scripts mixed together, both summoning the pet on spawn.
- **Changed:** the second summon row (id 12) is deleted, so each brings one pet.

#### Nothing moved
- **Found:** no waypoint paths and no wandering on map 47.
- **Changed:** 5 paths from the Pandaria 5.4.8 database, 4 from the AzerothCore 3.3.5 database
  (including Agathelos the Raging), and AzerothCore's wandering for 46 spawns, capped at 5 yards.
  Matched by entry and position, or, where Cataclysm changed the creature on a spot, by the nearest
  spawn within 5 yards. New path ids 47000001 and up.

#### Not changed (yet)
- Charlga's scenario kill (criteria 34444) has an extra condition, world state expression 5497.
  Read from Four's WorldStateExpression.db2 (2026-10-25), it decodes to "1 == 1", which is always
  true, so it needs no fix. Achievement 635 "Razorfen Kraul" is a plain kill of Charlga.
- Classic leftovers that don't block anything: Death Speaker Jargba next to the new Roogug, Agathelos,
  and two Earthcaller Halmgar spawns 5 yards apart (both also in the Pandaria database).

**Status:** confirmed in game by Four over three runs (2026-10-25): Groyat's spawn, one Roogug,
every boss's credit and loot, scenario 654 at state 3 and achievement 635. Four didn't report on the
pets or the movement separately.

## 2026-10-24

### Maraudon: first test run (Noxxion, Gizlock, Vyletongue)

From Four's first run of the Wicked Grotto, 2026-10-24. All SQL, in
`sql/fixes/world/2026_10_24_07_maraudon_noxxion_gizlock_vyletongue.sql` and
`2026_10_24_08_maraudon_creeping_sludge_combat.sql` `2026_10_24_09_maraudon_celebras_redeemed.sql` `2026_10_24_10_maraudon_movement.sql` and `2026_10_24_11_maraudon_zaetars_spirit.sql`; no rebuild.

#### Noxxion couldn't be targeted
- **Found** (reported by Four): Noxxion (13282) showed as a quest giver with `.gm on`, couldn't be
  targeted, and gave no credit. His template had the "not selectable" unit flag (0x02000000) and the
  quest giver npc flag, and `creature_queststarter` listed him (and Razorlash, 12258) as starters of
  27698 "Servants of Theradras", the quest that asks you to kill them. The Pandaria 5.4.8 database has
  neither the flag nor those rows; its only giver is Zaetar's Spirit (12238).
- **Changed:** Noxxion gets the Pandaria values (npcflag 0, unit_flags 32832, no SmartAI; his fight is
  the core script `boss_noxxion`: Toxic Volley, Uppercut, and every 40 seconds he hides for 15 seconds
  while five Noxxion's Spawn attack). Razorlash loses the quest giver flag. Both bogus starter rows are
  deleted. Noxxion's Spawn (13456) gets the missing scaling row for difficulty 1.
- **Not changed:** the 3 Constrictor Vines and Barbed Lasher standing on Noxxion are spawned exactly
  like that in the Pandaria database too; trim them with `.npc delete` if they're in the way.
- **Status:** confirmed in game by Four (2026-10-24): Noxxion "checked out good".

#### Creeping Sludge left you stuck in combat
- **Found** (reported by Four, `.debug combat` showed a PvE combat ref to Creeping Sludge 324883 after
  walking past it): most Creeping Sludges (12222) carry Poison Shock (22638), which hits everyone
  within 8 yards every 2 seconds. A player it hits is put in combat with the sludge, but the sludge
  never puts the player on its own threat list, so it neither attacks nor evades and the combat never
  ends. No other Maraudon creature has a pulsing damage aura like this.
- **Changed:** `2026_10_24_08_maraudon_creeping_sludge_combat.sql` gives the sludge one SmartAI row:
  when it damages someone, it attacks them. It then fights that player, or, if it can't see them (in
  stealth), evades and drops the combat right away.
- **Status:** confirmed in game by Four (2026-10-24).

#### Celebras the Redeemed stood next to Celebras the Cursed
- **Found** (reported by Four, with a screenshot): the friendly spirit, Celebras the Redeemed (13716),
  was already standing beside the boss before the fight. The core script `celebras_the_cursed`
  summons him on the boss's corpse when it dies, but the world database also spawns him permanently
  (guid 324986; the Pandaria database has the same row).
- **Changed:** `2026_10_24_09_maraudon_celebras_redeemed.sql` deletes the static spawn. He now only
  appears when Celebras the Cursed dies, for 10 minutes.
- **Status:** confirmed in game by Four (2026-10-24).

#### Almost nothing in Maraudon moved
- **Found** (reported by Four: Primordial Behemoths used to patrol, Princess Theradras stood still,
  "much more creatures wandered or had paths"): the BFA world database has no waypoint paths and no
  wandering for any Maraudon mob except a few critters.
- **Changed:** `2026_10_24_10_maraudon_movement.sql`, matched to these spawns by entry and position:
  - 30 waypoint paths from the Pandaria 5.4.8 database (same spawn guids), including a Primordial
    Behemoth, Meshlok's second spawn, Shardlings, Larvae and Snapjaws.
  - 8 paths from the AzerothCore 3.3.5 database: Princess Theradras (a loop around her room),
    Meshlok, Spirit of Veng, a Sister of Celebras pair, a Celebrian Dryad pair, a Stolid Snapjaw, a
    Thessala Hydra and a Corruptor group, with the pairs and the group walking in formation.
  - Random wandering for 218 spawns, with the AzerothCore radius capped at 5 yards (this core's random
    movement doesn't path around walls). Water creatures (Thessala Hydra, Stolid Snapjaw, Rotgrip)
    don't wander.
  - New path ids 349000001 and up.
- **Not changed:** AzerothCore has only one patrolling Behemoth too; the rest stand. Rotgrip's
  classic path is in a different place from his BFA spawn, so he stays put.
- **Status:** confirmed in game by Four (2026-10-24): the new patrols and Rotgrip checked out.

#### Zaetar's Spirit stood beside Princess Theradras
- **Found** (reported by Four, with a screenshot): Zaetar's Spirit (12238) was already standing next to
  Princess Theradras before the fight. Her core script `boss_princess_theradras` summons him where
  she dies, but the world database also spawns him permanently there (guid 324993; the Pandaria
  database has the same row).
- **Changed:** `2026_10_24_11_maraudon_zaetars_spirit.sql` deletes the static spawn. He now appears
  when the Princess dies, for 10 minutes, to give and take the Maraudon quests.
- **Status:** confirmed in game by Four (2026-10-24).

#### Tinkerer Gizlock and Lord Vyletongue stood still and never meleed
- **Found** (reported by Four): Gizlock only used Goblin Dragon Gun, Vyletongue only an occasional
  Smoke Bomb, and neither meleed. Each had two SmartAI scripts mixed in the table: old spell timers plus
  a ranged-hunter template that stops moving and stops melee on aggro and leaves the rest to phase 1
  rows. Nothing sets phase 1, so those rows never ran.
- **Changed:** both scripts replaced with one clean set. They chase and melee, Shoot when the target
  is 5-30 yards away, and use their full kit: Gizlock says his aggro line and uses Bomb (random
  player), Goblin Dragon Gun and Flash Bomb; Vyletongue uses Multi-Shot (random player), Smoke Bomb and
  Blink.
- **Not changed:** Razorlash (Puncture and Cleave) already uses his whole kit; that's all he has.
- **Status:** confirmed in game by Four (2026-10-24): "the boss mechanics" checked out.

### Scarlet Monastery: the "Scarlet Monastery" achievement

- **Found** (reported by Four, after the encounter fix below didn't help): Four sent the client's
  Achievement, Criteria, CriteriaTree, ModifierTree and DungeonEncounter db2 files. "Scarlet Monastery"
  (637, criteria tree 3990) has a single criteria, 533: be the target of spell 132022 (Whitemane's kill
  credit, criteria type 28). Retail Whitemane casts it on everyone when she dies; the spell isn't in the
  client's spell data, so nothing here ever cast it. "Scarlet Halls" (7413) is a plain kill of Koegler
  (59150), which is why that one already worked (confirmed by Four). The encounter rows from
  2026_10_24_06 are still right (DungeonEncounter 1425 is Whitemane on map 1004) but weren't the cause.
- **Changed:** `boss_high_inquisitor_whitemane_mop` gives every player in the instance the type 28
  criteria for 132022 when she dies (`DoUpdateCriteria`), which also covers "Heroic: Scarlet
  Monastery" if it uses the same spell. In `tools/bfa/scarlet-monastery.patch`; no SQL.
- **Status:** confirmed in game by Four (2026-10-24): the achievement unlocked on Whitemane's death.

### Scarlet Monastery: second test run (Fuel Tanks, dungeon and achievement credit)

From Four's second run, 2026-10-24. C++ in `tools/bfa/scarlet-monastery.patch` (new version again),
data in `sql/fixes/world/2026_10_24_06_scarlet_fuel_tank_encounters.sql`.

#### Whitemane gave no dungeon completion and no "Scarlet Monastery" achievement
- **Found** (reported by Four): the scenario counted Whitemane (`.debug scenario` showed progress 1),
  but the achievement stayed locked. `instance_encounters` only had the classic encounters for Scarlet
  Halls and Scarlet Monastery (448 Herod, 450 Whitemane), which belong to the old maps, so killing the
  last boss on the new maps completed no dungeon encounter. The classic rows were also marked as the
  last boss of dungeon finder entries 163 and 164, and the core keeps only one last boss per entry.
- **Changed:** the SQL takes the "last boss" mark off 448 and 450 and adds the Mists encounters, as the
  Pandaria 5.4.8 database has them: 1425 High Inquisitor Whitemane (last boss of 164) and 1420
  Flameweaver Koegler (last boss of Scarlet Halls, 163).
- **Status:** didn't unlock the achievement (Four, second run); the real cause is the kill credit
  spell, see the entry above. The rows are still correct for dungeon encounter credit.

#### Fuel Tanks still couldn't be clicked
- **Found** (reported by Four): clearing the unselectable flag (2026_10_24_04) didn't make the tank
  clickable. Cause not found.
- **Changed:** the tank now also explodes when a player hits it. The SQL gives it the Monster faction
  (14) so it can be attacked, and lets anyone use its spell click (`user_type` 0), since it is no longer
  friendly. `npc_scm_fuel_tank` explodes on a click or on the first hit from a player, and ignores
  damage from creatures.
- **Status:** confirmed in game by Four (hitting the tank sets it off). Clicking it still does nothing.

### Scarlet Monastery: first test run fixes, and the Headless Horseman

From Four's first run, 2026-10-24. The C++ is in `tools/bfa/scarlet-monastery.patch` (same patch,
new version: revert the old one first), the data in
`sql/fixes/world/2026_10_24_04_scarlet_monastery_fuel_tank_burning_man.sql` and
`sql/fixes/world/2026_10_24_05_headless_horseman.sql`.

#### Fuel Tanks couldn't be clicked
- **Found** (reported by Four): the Fuel Tank template (59706) has `UNIT_FLAG_NOT_SELECTABLE`
  (0x02000000) in `unit_flags`, and an unselectable creature can't be clicked, so the spell-click row
  and script never ran.
- **Changed:** the SQL clears that flag on the template, and `npc_scm_fuel_tank` also clears it when
  the tank spawns.
- **Status:** untested in game.

#### Brother Korloff left players burning
- **Found** (reported by Four, with screenshot): after Korloff, the player kept a fire glow with no
  debuff icon until `.unaura all`. Blazing Fists and Firestorm Kick trigger Burning Man (125844, 125852),
  a hidden dummy aura with no duration that is meant for the Training Dummies (achievement). It picks
  its targets by creature entry, and with no `conditions` row the core hit everyone in range.
- **Changed:** `conditions` rows limit both spells to the Training Dummies (64446, 60197).
- **Status:** untested in game. Korloff's fight itself (melee, Flying Kick, Blazing Fists, fire trail,
  loot, dungeon credit) is confirmed by Four.

#### Whitemane never came out after Durand fell
- **Found** (reported by Four): Durand died, Whitemane stayed behind her door, passive and
  unselectable. Not reproduced here, so the exact cause isn't known. Two weak points in the script:
  Whitemane ignored Durand's call if she already counted as "in combat", and if Durand died outright
  (instead of feigning) nothing called her at all.
- **Changed:** Whitemane now only checks her own "intro started" flag. Durand looks her up by the
  instance data or, failing that, the nearest Whitemane within 150 yards, and if he really dies he
  still calls her out (she then fights alone).
- **Status:** untested in game. Thalnos (all abilities, door, scenario credit) is confirmed by Four.

#### The Headless Horseman couldn't be summoned
- **Found:** the classic Horseman script flew him over map 189's coordinates. That map is gone from
  the 8.3.7 client: the Monastery graveyard (map 1004) is the only one left. The Pumpkin Shrine (186267)
  that Hallow's End (game event 12) spawns there had no working summon.
- **Changed:** `boss_headless_horseman.cpp` is replaced by a port of the Pandaria 5.4.8 map-1004
  script:
  - **Pumpkin Shrine** (`go_pumpkin_shrine`): "Call the Headless Horseman." summons him once per
    instance. The caller recites the four rhyme lines, he rises from the soil beside the shrine, circles
    the graveyard and lands, then attacks everyone in range. A wipe despawns him and the shrine works
    again. The shrine's quest turn-ins (11135, 11220) still show.
  - **Phases:** each time his body would die it loses its head (Head of the Horseman, 23775, which
    wanders within 30 yards). While headless the body is immune, confused, regenerates 4% a second and
    whirlwinds. Beat the head to 66% (phase 1), 33% (phase 2) or 0% (phase 3) to end the phase; if the
    body heals to full first, the head comes back and the phase repeats. Cleave (42587) all fight;
    phase 2 adds Conflagration (42380) every 8 to 12 seconds; phase 3 throws pumpkins every 15 seconds
    (52236), which sprout into Pumpkin Fiends unless killed first (`spell_sprouting`, 42281).
  - **Death:** Sir Thomas (23904) appears for 60 seconds, the instance marks the Horseman done, and a
    dungeon finder group queued for "The Headless Horseman" (285) is finished.
  - The SQL binds the scripts, replaces the Horseman texts with the Pandaria set, adds level scaling
    for difficulties 1 and 2 (23682, 23775, 23694, 23904: scaled to you, up to 120), moves the dungeon
    finder arrival for 285 from map 189 coordinates to the Monastery entrance, and adds a reward row for
    levels 86 to 120.
- **Status:** untested in game.

### Scarlet Monastery (map 1004): spawns, scripts and the Blades quest

Found in Four's first run, 2026-10-24. Everything below is in `tools/bfa/scarlet-monastery.patch`
(22nd patch; adds four source files, so run `sudo cmake build` once before building) and
`sql/fixes/world/2026_10_24_03_scarlet_monastery_rework.sql`. The scripts are ported from the
Pandaria 5.4.8 project (alexkulya). None of it has been tested in game yet.

#### The graveyard had the wrong things standing in it
- **Found** (reported by Four): the graveyard had Empowering Spirits, Frenzied Spirits, Piles of
  Corpses, "level ??" Zombified Corpses, Centurions, Flamethrowers and Thalnos together. Compared with
  the Pandaria 5.4.8 database, this one had 18 permanent Empowering Spirits (59893, level 100 to 101).
  Those are Thalnos's summons and should only appear during his fight. It also had 6 Fuel Tanks (59706)
  that should only drop from dead Flamethrowers, and 30 Frenzied Spirits instead of 12. Purifiers were
  20 instead of 40 and Zealots 13 instead of 24. There were two stray Durand copies (60106 and the
  Dashing Strike stalker 60107), and Thalnos and Durand wandered (random movement, 10 yards).
- **Changed:** the SQL replaces every creature on map 1004 with the Pandaria set (167 spawns, guids
  1004000001 and up). Two spawns from this database stay because they belong to its quest chain: the
  entrance Hooded Crusader (64827, quests 31513 and 31514) and the Blade of the Anointed at the pool
  (64854). It also adds Korloff's patrol path and the two drunk Judicators in the graveyard hall.
  Gameobjects were already the same as Pandaria's and are untouched.
- **Status:** untested in game.

#### "Level ??" Zombified Corpses
- **Found:** Zombified Corpse (59771), Fallen Crusader (59884), Empowered Zombie (59930), Evicted Soul
  (59974) and Spirit of Redemption (58592) only had a `creature_template_scaling` row for difficulty 0.
  The dungeon runs as difficulty 1, so they got no scaling and rolled a random level between 31 and 90.
- **Changed:** the SQL copies their difficulty 0 rows to difficulty 1 (level 1 to 100, scaled to you).
- **Status:** untested in game.

#### Fuel Tanks glowed but did nothing
- **Found** (reported by Four): Fuel Tanks have the spell-click flag and `npc_spellclick_spells` row
  (114953), but their SmartAI had nothing to do on a click.
- **Changed:** `npc_scm_fuel_tank`: clicking it blows it up with Barrel Explosion (114952, 10 yards) and
  it despawns. New `conditions` rows make the explosion hit creatures only, never players or other
  tanks. Scarlet Flamethrowers (`npc_scarlet_flamethrower`) now drop a Fuel Tank when they die (it lasts
  5 minutes), and burn the dead with their flamethrower (115506) out of combat.
- **Status:** untested in game.

#### Graveyard trash
- **Changed:**
  - **Pile of Corpses** (`npc_pile_of_corpses`) raises a Zombified Corpse every 10 seconds (114951) until
    it is destroyed. It doesn't move or fight back, and its zombies vanish when it dies.
  - **Zombified Corpses** get faction 1962, which is hostile to players and to the Crusade. When a
    Centurion hits one, it fights back and falls 3 to 5 seconds later.
  - **Scarlet Centurions** (`npc_scarlet_centurion`) cut down zombies within 10 yards while no player is
    fighting them. Against players they Cleave (115519) every 5 to 6 seconds and use Retaliation
    (115511) once, at 20% health.
  - **Frenzied Spirits** (`npc_frenzied_spirit`) stack Frenzied Spirit (115524, more damage and size)
    every 3 to 4 seconds in combat. Pandaria stacks it every 1 to 1.5 seconds; that is slowed here for
    solo play.
  - **The entrance Hooded Crusader** warns "Destroy the Piles of Corpses to stop the Zombified
    Corpses!" (raid warning) the first time a player comes within 30 yards.
- **Status:** untested in game.

#### Scarlet Zealots
- **Changed:** `npc_scarlet_zealot` replaces their SmartAI:
  - Smite (111010) on a random player every 4 to 6 seconds.
  - Heal (111008) on the most hurt Scarlet within 40 yards every 9 to 14 seconds.
  - Resurrection (111670) on a dead Fanatic, Purifier, Zealot, Judicator or Initiate within 30 yards
    every 15 to 25 seconds. The body gets up when the cast finishes.
  - When one dies it leaves a Spirit of Redemption (58592) for 12 seconds. The spirit can't be
    attacked and keeps healing (111024) the most hurt Scarlet.
- **Status:** untested in game.

#### Thalnos the Soulrender had no fight
- **Found:** Thalnos (59789) had no script and no SmartAI rows.
- **Changed:** `boss_thalnos_the_soulrender`:
  - Spirit Gale (115289) on a random player every 7.5 to 13 seconds.
  - Raise Fallen Crusader (115139), a 5-second channel that raises a Fallen Crusader (59884) every
    second. The Crusaders cast Mind Rot (115144) every 3.5 to 4.2 seconds. First at 6.5 seconds, then
    20 seconds after each Empowering Spirits.
  - Evict Soul (115297) every 25 seconds, on someone other than the tank when there is one. The
    Evicted Soul (59974) it spawns copies its player's looks and attacks them.
  - Empowering Spirits (115147) every 40 seconds. Each spirit turns into an Empowered Zombie (59930)
    after 5 seconds unless it is killed first.
  - His yells and the two raid warnings come from the Pandaria database. All his adds despawn when he
    dies or resets.
  - New `spell_areatrigger` / `areatrigger_template` 220 rows: the pool Spirit Gale leaves (3 yards)
    puts its damage-over-time (115291) on players standing in it. The 3-yard size is a guess: neither
    database had this data.
  - The Graveyard Door (211844) opens when he dies.
- **Status:** untested in game.

#### Brother Korloff had no fight
- **Found:** Korloff (59223) had no script and no SmartAI rows.
- **Changed:** `boss_brother_korloff`:
  - Flying Kick every 25 seconds: he leaps at a player more than 5 yards away (or the tank), knocking
    them back (114488). Where he lands, Firestorm Kick (113764) burns everyone around him for 6 seconds.
  - Blazing Fists (114807), a 6-second channel of punches at the tank, every 20 seconds.
  - Rising Flame (114410), +10% damage for every 10% of health he loses.
  - Below 50% health he leaves Scorched Earth (59507, burning ground, 114464) where he walks; each
    patch lasts 30 seconds.
  - He patrols his room (Pandaria path), and the cathedral door (210564) opens when he dies.
- **Status:** untested in game.

#### Commander Durand and High Inquisitor Whitemane
- **Found:** Durand (60040) had no script. Whitemane (3977) still ran the old Cathedral script for the
  Mograine fight (`boss_high_inquisitor_whitemane`), and her lines were the old ones.
- **Changed:** `boss_commander_durand` and `boss_high_inquisitor_whitemane_mop`:
  - Durand uses Flash of Steel (115629) six times in a row on the farthest player, every 21 to 26
    seconds. He also uses Dashing Strike three times, every 24 seconds: line damage (115739) to a
    random player, then he comes out behind them.
  - When Durand "dies" the first time he only feigns it. Whitemane's door (210563) opens and she walks
    out and fights at range: Holy Smite (114848), Heal (36678) on herself, and Mass Resurrection
    (113134) every 20 seconds while dead Scarlet trash lies within 80 yards.
  - At 50% health she casts Deep Sleep (9256) on everyone near and a shield on herself. She then walks
    to Durand and raises him with Scarlet Resurrection (9232; a new `conditions` row lets it target
    Durand). From then on both fight until dead, and she heals Durand when he is lower than her.
  - A wipe resets both. When both are dead, the Hooded Crusader (64842) comes out of her room.
- **Status:** untested in game.

#### "Unto Dust Thou Shalt Return" couldn't be finished
- **Found** (reported by Four): the Blades of the Anointed said "Requires High Inquisitor Whitemane's
  corpse". That is a spell focus (gameobject 214291) Whitemane is meant to leave when she dies, with
  spell 126789, and nothing cast it. Even with it there, the Blades' spells (126787, 126843) only send
  an event (33000 / 33001) that nothing handles, so there was no quest credit.
- **Changed:** Whitemane casts 126789 as she dies. New `spell_scm_blades_of_the_anointed`
  (`spell_script_names` for both spells) gives the quest credit (64835 for quest 31514, 64840 for
  31516) when the Blades are used at her corpse. The Hooded Crusader who appears after the fight
  (64842) now also takes quest 31514 (`creature_questender`), as well as the entrance crusader.
- **Status:** untested in game. Until it is in, `.quest complete 31514` finishes the quest.

#### Instance script
- **Changed:** `instance_scarlet_monastery` was registered for the old map 189, which no longer exists
  in 8.3.7. It is now registered for map 1004. It keeps the Headless Horseman and Pumpkin Shrine data,
  and adds boss states for Thalnos, Korloff, Durand and Whitemane and the three doors.
- **Status:** builds; untested in game. The Headless Horseman script itself is still the old map 189 one
  (its flight path is in old coordinates), so summoning him at the Pumpkin Shrine is not expected to
  work yet.

## 2026-10-23

### Scarlet Halls and Scarlet Monastery: getting in and out

Found in Four's first visit.

#### The Dungeon Finder dropped you outside Scarlet Halls
- **Found** (reported by Four): queueing for Scarlet Halls put you on map 1001 at 1610.83, -323.43,
  18.67, with no ground under you. That is the old Armory entrance (map 189). `lfg_dungeon_template`
  row 163 (now Scarlet Halls, normal) was never moved to the new map. Row 164 (Scarlet Monastery,
  normal) had the right x and y but the old Cathedral height, 18.67 instead of 0.99.
- **Changed:** new `sql/fixes/world/2026_10_23_01_scarlet_entrances_exits.sql` sets 163 and heroic 473
  to 837.23, 615.755, 12.8115 (facing 4.75989). Four picked that spot with `.gps`, a few yards back
  from the Pandaria 5.4.8 value (836.666, 605.141). (Their first `.gps` gave the selected crusader's
  spot instead.) It sets 164 to 1124.64, 512.467, 0.989549
  (facing 1.5708), the Pandaria value. Heroic Scarlet Monastery (474) has no row and uses the door's
  target, which was already right.
- **Status:** the Dungeon Finder put Four inside Scarlet Halls on 2026-10-23 (old spot). The moved spot
  is untested.
- **Changed** (Four's request, 2026-10-24): new `sql/fixes/world/2026_10_24_02_scarlet_halls_arrival.sql`
  moves the arrival spot for 163, 473 and the door's `world_safe_locs` 4077 to Four's new `.gps`:
  821.987, 608.059, 13.5985, facing 0.021594 (into the hall).
- **Status:** untested in game.

#### The Scarlet Halls door outside did nothing
- **Found:** area trigger 614 (the Scarlet Halls door) points at WorldSafeLoc 4077, and that row was
  missing from `world_safe_locs`. The core skips a teleport whose target is missing, at startup.
- **Changed:** the same SQL adds `world_safe_locs` 4077: map 1001, the same spot as the Dungeon Finder
  (837.23, 615.755, 12.8115). This core reads `Facing` as radians (`ObjectMgr::LoadWorldSafeLocs`), so
  it is 4.75989.
- **Status:** loads without errors; walking through the door is untested.

#### No way out of either dungeon
- **Found** (reported by Four): once inside Scarlet Monastery you couldn't walk out. `areatrigger_teleport`
  had no exit row for either new map. The Pandaria database has them as triggers 7801 and 7802.
- **Changed:** the same SQL adds 7801 (Scarlet Halls exit, to WorldSafeLoc 3626, 2869.32, -820.82,
  160.33) and 7802 (Scarlet Monastery exit, to 3623, 2915.34, -801.58, 160.33). Both are the courtyard
  spots the old wings used.
- **Status:** the core loads 614, 7801 and 7802 without errors (Four's `Errors.log`, 2026-10-23).
  Walking through them is untested.

#### Two Hooded Crusaders on top of each other at the Scarlet Halls entrance
- **Found** (reported by Four): two quest givers stood on the same spot. One offered Rank and File
  and Just for Safekeeping, Of Course; the other showed the same quests greyed out. 64738 (guid
  13241581) gives the normal quests 31490 and 31493 (from level 26). 64764 (guid 13241582) gives the
  heroic copies 31495 and 31497 (level 90). Both spawned in normal and heroic (`spawnDifficulties` 1,2).
- **Changed:** new `sql/fixes/world/2026_10_23_02_scarlet_halls_hooded_crusaders.sql`: 64738 spawns
  only in normal (1), 64764 only in heroic (2).
- **Status:** confirmed in game by Four on 2026-10-23 (one crusader in normal).

#### Starving Hounds kept you knocked down
- **Found** (reported by Four): after the first Starving Hound (58876) pack jumped you, you lay on the
  floor and never got up; only `.combatstop` freed you. The hounds cast Hungry Dog (111582) every 12 to
  15 seconds. It is a 30-second channel that stuns its target and ends early only if the hound is
  interrupted. That's a group mechanic (someone else knocks the dog off you), and with four hounds per
  pack a solo player stayed stunned.
- **Changed:** new `sql/fixes/world/2026_10_23_03_scarlet_halls_hounds.sql` replaces the hound's SmartAI.
  Every 20 to 25 seconds in combat it runs actionlist 5887600: cast Hungry Dog on its target, then 4
  seconds later interrupt its own Hungry Dog channel, which removes the stun.
- **Status:** replaced the same day by the C++ hound in `scarlet-halls.patch` (below), which keeps the
  4-second cap. `2026_10_23_05` removes this action list again.

#### Angry Hounds showed as neutral
- **Found** (reported by Four): Angry Hound (58674) was level 1 with faction 7 (neutral creature). It
  is an elite with its own loot table, and the Pandaria 5.4.8 database has it hostile at level 30.
- **Changed:** the same SQL sets faction 14, level 29 to 90, matching the Starving Hounds next to it.
- **Status:** untested in game.

#### Codex of the Crusade almost never dropped
- **Found** (reported by Four): Flameweaver Koegler (59150) didn't drop the Codex of the Crusade for
  "Just for Safekeeping, Of Course". The normal item 87267 (quest 31493) had `Chance` 1 and
  `QuestRequired` 0. The heroic item 87268 (quest 31497) used loot mode 2, which this core never turns on.
- **Changed:** new `sql/fixes/world/2026_10_23_04_scarlet_halls_codex.sql` sets both to `Chance` 100,
  `QuestRequired` 1, `LootMode` 1: they drop every kill, only for players on the quest.
- **Status:** untested in game.

### Scarlet Halls: the events and bosses

Four called Scarlet Halls done on 2026-10-24, after five runs. The per-fix statuses below say which
parts were seen working in game.

Found in Four's first full run (2026-10-23). Most of Scarlet Halls had no working script in this core:
the instance had no instance script, the bosses ran short stubs, and the events had neither scripts nor
the creatures they need. New `tools/bfa/scarlet-halls.patch` ports the Pandaria 5.4.8 scripts
(`src/server/scripts/EasternKingdoms/ScarletHalls/`: `scarlet_halls.cpp` is new, the instance script,
the header and the three boss files are rewritten, and the script loader registers them). New
`sql/fixes/world/2026_10_23_05_scarlet_halls_rework.sql` supplies the spawns, yells and bindings.
Trash that already had working SmartAI (Myrmidons, Evangelists, Evokers, Scholars, Pupils and others)
keeps it.

#### The dungeon had no instance script
- **Found:** `instance_template` for map 1001 had no script, and the core had none to register: no
  boss states, so no doors and nothing to tell the codex crusader that Koegler died.
- **Changed:** the patch's `instance_scarlet_halls` tracks the three bosses and Lindon's gauntlet, and
  opens Lindon's gate (212160) and Braun's fire wall (210097) when they die. Herod's Door (210480)
  closes while Harlan is fought. The SQL sets the instance script.
- **Status:** untested in game.

#### Half the dungeon's creatures were missing
- **Found:** map 1001 had 84 spawns, a partial and slightly shifted set. Braun's six Obedient Hounds,
  the ten Scarlet Guardians and Sergeant Verdone at his exit, the stakes, buckets of dog food, archery
  targets, cannons and all 71 Books were missing, and so were Lindon's gate, Braun's fire wall and the
  heroes' statues in Harlan's room. The only door was the old Armory's Herod's Door (101854).
- **Changed:** the SQL replaces every map 1001 spawn except the two entrance Hooded Crusaders with the
  Pandaria set: 253 creatures (guids 1001000001+, with the 20 patrol paths) and 27 gameobjects. The
  challenge mode door and orb, the herbs and a second portal are left out.
- **Status:** the SQL runs twice without errors on a copy of this database. Untested in game.

#### Commander Lindon's archery hall had no event
- **Found** (reported by Four): Lindon (59191) and his Master Archers (59175) were neutral (faction 7)
  and just stood there to be tanked.
- **Changed:** they are hostile (14). When Lindon sees you, his archers shoot Piercing Arrow down the
  hall and he uses Shield Breaker on anyone within 18 yards. Click a Reinforced Archery Target to carry
  it as a shield: Heroic Defense, 75% less damage taken but slower and no attacking. Stepping into the
  hall (area trigger 7532) sets off a line of Exploding Shots on the floor. Within 10 yards of Lindon
  the volleys stop and the whole crew draws blades; Heroic Defense drops then, and past the hall.
  Simplified: the archery target walks just ahead of you instead of riding on you as a vehicle.
- **Found** (Four's run, 2026-10-23): the archery target trailed behind, didn't cut the arrows' damage,
  and kept following after Lindon died. Heroic Defense was never applied: its first effect makes the
  player a vehicle for the target, and cast on a player that isn't one it never landed.
- **Changed:** the target adds the aura directly, walks 2 yards in front of you (you're slowed by 65%
  while carrying it), and goes back on its stand as soon as the aura is gone. It can't be picked up
  once Lindon is dead.
- **Found** (Four's second run, 2026-10-23): Heroic Defense now works (slowed, arrows hit for less),
  but the target still walked behind you. It used the follow movement, which stops moving whenever it
  is within 3 yards of you, so once behind you it stayed there.
- **Changed:** every quarter second the target runs to the point 2.5 yards in front of you and turns
  to face the way you face.
- **Found** (Four's third run, 2026-10-23): the target now stays in front (seen in Four's video). But
  after Lindon's Shield Breaker knocked Four down, the character was invisible except for the weapons,
  floating and oversized, even back in Stormwind, until `.unaura all`. Shield Breaker (125492) fires
  two shells: 125507 knocks you down and strips Heroic Defense (meant), and 125493 transforms its
  targets into Invisible Man (64188) with no time limit. 125493 picks targets by creature entry, and
  with no conditions row the core falls back to every enemy within 13 yards, so it hit the player.
- **Changed:** new `sql/fixes/world/2026_10_23_06_scarlet_halls_shield_breaker.sql` limits 125493 to
  the Reinforced Archery Target (59163). After the knockdown the target goes back on its stand.
- **Found** (Four's fourth run, 2026-10-23): the target still trailed the player, bullseye towards
  the player. Four's source turned out to still hold the `ea91d85` version of the patch (the two
  updates before this one never reached the build), so the quarter-second positioning above was never
  tried in game.
- **Changed:** the target now moves every 0.1 seconds at 1.5 times your speed, stays in front of you
  (further ahead while you walk), and keeps its facing while it moves.
- **Found** (Four's fifth run, 2026-10-24): it now leads, but too far out and with the bullseye towards
  the player. The bullseye is on the front of the model after all (the old follow movement had turned
  the model to face the player).
- **Changed:** it faces the way you face, bullseye towards the archers, about 1 yard in front of you
  (plus a little while you walk).
- **Status:** Four got past Lindon on 2026-10-23; the volleys, the exploding floor and the melee
  switch weren't reported on. Heroic Defense confirmed by Four on 2026-10-23, leading confirmed on
  2026-10-24. The distance, facing and Shield Breaker fixes are untested. Lindon has no loot table (`lootid` 0 here and in the
  Pandaria 5.4.8 database), so he drops nothing.

#### Starving and Angry Hounds, and the dog food buckets
- **Found:** the buckets of dog food did nothing and the Angry Hounds weren't chained.
- **Changed:** Starving Hounds (58876) are C++ now, Hungry Dog still capped at 4 seconds. Click a Bucket
  of Meaty Dog Food (65379), then throw it (out of combat) next to a Vigilant Watchman: he is pinned
  down and every hound within 20 yards turns on him, then sits down to eat. Angry Hounds (58674) are
  chained to their stakes and only attack when you come within 5 yards, or when attacked.
- **Found** (Four's run, 2026-10-23): an Angry Hound attacked from stealth stayed passive, and one that
  had aggroed ran back to its stake and reset when you stepped back.
- **Changed:** an attack wakes the hound, and when you go past the end of its chain (8 yards from the
  stake) it waits at the stake still in combat instead of resetting, and comes back at you when you're
  in reach.
- **Found** (Four's second run, 2026-10-23): the hounds now fight back, but they still went back to
  the stake when you stepped away. Once a hound is in the fight its chain should be broken.
- **Changed:** when a hound is attacked or attacks you, the Leashed aura comes off and it chases you
  like any other hound. The chain-length limit is gone. A hound that resets is chained again.
- **Found** (Four's third run, 2026-10-23): the hound still showed the Chained debuff ("Chained to a
  post. Always attacks nearest enemy.") after being hit. That is a separate aura, Chained (111641),
  from `creature_template_addon`; only Leashed (103169) was being removed. Also, a hound that pulled
  itself by you walking up to it should stay chained: only an attack breaks the chain.
- **Changed:** the first damage, or a hostile spell such as a stun, removes Chained and Leashed and
  frees the hound to chase you anywhere. Until then it is chained: it attacks anyone within 5 yards
  but waits at its post, still in combat, for anyone past 8 yards. A hound that resets gets Chained
  back.
- **Status:** confirmed by Four on 2026-10-24 ("Angry Hound is fixed").

#### Houndmaster Braun
- **Found** (reported by Four): melee, Death Blossom and Bloody Mess only; an easy fight.
- **Changed:** Piercing Throw every 7 to 9 seconds, Death Blossom as a leap that spins where it lands,
  one Obedient Hound called at 90, 80, 70 and 60%, Bloody Rage at 50%. At 15% his own hounds turn on
  him: he stops fighting, is eaten, and dies 12 to 15 seconds later with the kill credited to you. The
  hounds then run to his exit and kill the guards there.
- **Status:** confirmed by Four on 2026-10-23 (yells, hounds, kill credit, the guards at the exit).

#### Armsmaster Harlan
- **Found** (reported by Four): melee and Dragon's Reach only.
- **Changed:** Call for Help every 20 to 25 seconds (two Scarlet Defenders in Heavy Armor run in along
  the balconies; break the armor and they are Unarmored), Heroic Leap to the middle of the room
  followed by Blades of Light spinning round it (every second, damage to everyone within 8 yards), and
  Berserker Rage at 50%. Simplified: Blades of Light doesn't pick players up.
- **Status:** confirmed by Four on 2026-10-23 (yells, Call for Help, bonus objective).

#### Flameweaver Koegler meleed too much
- **Found** (reported by Four): far too much melee for a caster, and Quickened Mind (113682) didn't make
  his casts instant. Its cast-time cut is a spell modifier, which only reaches player spell families.
- **Changed:** he casts back to back: Pyroblast, Fireball Volley every 13.5 seconds, and Book Burner on
  a book case (it burns and hurts anyone in front of him). Quickened Mind now gives him three instant
  casts. Every 30 seconds he teleports to the middle and channels Greater Dragon's Breath for 10
  seconds, a cone that sweeps round the room.
- **Status:** confirmed by Four on 2026-10-23: "All scripts fired off successfully".

#### The Hooded Crusader never came for the codex
- **Changed:** the crusader outside the library stays hidden until Koegler dies, then walks in and asks
  for the codex.
- **Status:** confirmed by Four on 2026-10-23 (codex dropped, quest turned in, dungeon complete).

#### Smaller things
- **Changed:** 22 yells and emotes for Braun, Harlan, Koegler, Lindon, the archery target and the
  crusader (none existed). Scarlet Treasurers drop a pile of Gold Coins. The Scarlet Cannons get their
  Cannoneers, who fire Cannon Blast at players in the courtyard.
- **Status:** yells and the Treasurer's gold untested in game.

#### The cannons only made smoke
- **Found** (Four's run, 2026-10-23): the Scarlet Cannoneers (59293) stood inside the cannons and
  could only hurt you in melee. They were summoned on the cannon's own spot. Their shell was fired by
  the cannon (58726), which is a level 1 friendly stalker, so its 15-yard Cannon Blast (111569) found
  no enemies to hit.
- **Changed:** the cannoneer fires the shell himself, at a random player within 40 yards every 3 to
  5 seconds, so it hits at his level. The shell only hits within 3 yards of where it lands and takes a
  moment to fly, so he leads a moving target by its speed and the flight time. He stands 2 yards
  behind the gun (Ready Cannon, 113933, put him out at the muzzle).
- **Found** (Four's fifth run, 2026-10-24): the shells now land and hurt ("the cannon shots work"),
  but the cannoneers stood in front of the muzzles. The stalker faces the breech end of its gun, not
  the muzzle.
- **Changed:** each cannoneer stands beside the breech (1.5 yards towards it and 1.3 yards out to the
  side, stopping short of any wall), facing the way the gun fires.
- **Status:** cannon damage confirmed by Four on 2026-10-24; the new standing spot is untested.

#### Trash dropped almost nothing
- **Found** (reported by Four, 2026-10-23/24): "some enemies only drop money", loot "not the same
  density". These are the Mists of Pandaria versions of the Scarlet mobs, and their loot tables were
  built for heroic: most rows are heroic-only (LootMode 2, a mode the core never gives creatures), and
  the normal rows add up to 29-47% for one item per kill, with no world-drop reference tables. The
  Pandaria 5.4.8 database splits them the same way. Deadmines trash, for comparison, has 90-330% plus
  reference drops, and the old Classic Scarlet Monastery mobs still in the database about 55% (not
  counting quest items) plus 25-45% of reference drops.
- **Changed:** new `sql/fixes/world/2026_10_24_01_scarlet_trash_loot.sql` adds the normal-mode loot of
  a Classic Scarlet mob of the same level to each trash mob: Scarlet Augur (4284) for the 11 Scarlet
  Halls humanoids, Scarlet Monk (4540) for the 7 Scarlet Monastery humanoids, Haunting Phantasm
  (6427) for the Frenzied Spirits. Quest-only rows are skipped and rows a mob already had are kept, so
  a Scarlet Myrmidon goes from about 34% to 49% for an item plus 26 reference tables (cloth, greens,
  recipes). Bosses and the hounds are unchanged. 1,868 rows; the file can be run again.
- **Status:** untested in game. The "You don't have permission to loot that corpse" messages are not
  explained yet.

#### Dying sent you to Westfall
- **Found** (Four's run, 2026-10-24): after dying to Braun, the spirit healer was at Sentinel Hill in
  Westfall. Neither Scarlet Halls (zone 6052) nor Scarlet Monastery (zone 6109) had a row in
  `graveyard_zone`, so the core fell back to its default Alliance graveyard.
- **Changed:** new `sql/fixes/world/2026_10_24_00_scarlet_graveyards.sql` links both zones to the
  Scarlet Monastery graveyard in Tirisfal Glades (`world_safe_locs` 1874), as the Pandaria 5.4.8
  database does.
- **Status:** untested in game.

#### To pick up these fixes
New patch on top of the others: apply it and rebuild. It adds a new source file (`scarlet_halls.cpp`),
so CMake has to re-run its configure step once (`cmake build`, which keeps your settings); without it
the link fails with `undefined reference to AddSC_scarlet_halls()`. Then the SQL, and restart
`worldserver`.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/scarlet-halls.patch | git apply
sudo cmake build
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_01_scarlet_entrances_exits.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_02_scarlet_halls_hooded_crusaders.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_03_scarlet_halls_hounds.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_04_scarlet_halls_codex.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_05_scarlet_halls_rework.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_23_06_scarlet_halls_shield_breaker.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_00_scarlet_graveyards.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_01_scarlet_trash_loot.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_24_02_scarlet_halls_arrival.sql | mysql -u root -p bfa_world
```

## 2026-10-19

### World: Sewer Beast (Stormwind canals)

Merged to `main` with PR #15 on 2026-10-25.

#### The Sewer Beast walks the canal pathways
- **Found** (reported by Four): the Sewer Beast (3581, rare crocolisk), guid 308329, walked the canal
  walkways instead of staying under water. It has three spawns, pooled by core update
  `2026_09_09_00_world_sewer_beast.sql` so only one is up at a time; that update also set
  `MovementType` 1 and `spawndist` 25 on all three. Two of the spawn points are at walkway height:
  308329 at (-8583.18, 522.841, 92.7076) (the walkway guards next to it stand at z 92.71) and 10604700
  at (-8781.6, 488.886, 92.6396). Only 52499 (-8560.69, 486.619, 85.8912) is on the canal floor. Random
  movement in this core goes in a straight line to a random point up to `spawndist` away and up to 10
  yards higher, so even from the floor a 25 yard wander reaches the walkways.
- **Changed:** new `sql/fixes/world/2026_10_19_06_stormwind_sewer_beast.sql`, using the
  alexkulya/pandaria_5.4.8 world database as the reference (same three spawns, the two floor ones
  standing still):
  - 10604700 moves to Pandaria's position for it, (-8783.6, 487.416, 85.8914), orientation 0.528863, on
    the canal floor.
  - 308329 is removed (`creature`, `creature_addon`, `pool_creature`): no data checked has a canal floor
    position for it. The pool keeps 52499 and 10604700, one up at a time.
  - Every Sewer Beast: `MovementType` 1 -> 0, `spawndist` 25 -> 0 (standing still, as in the Pandaria
    data).
- **Status:** confirmed in game by Four on 2026-10-19.

### To pick up the Sewer Beast fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_06_stormwind_sewer_beast.sql
```
Then restart worldserver.

### Gnomeregan

Merged to `main` with PR #16 on 2026-10-23. Found in a survey before the first run and in Four's run.

#### Blastmaster Emi Shortfuse couldn't be talked to; Electrocutioner 6000 yelled twice
- **Found:** Emi (7998) starts the trogg event from her gossip option "I am ready to begin." (menu
  1080, `OptionNpcFlag` 1), but her `npcflag` was 2 (questgiver) and she has no quests, so there was
  nothing to click. The Pandaria 5.4.8 world database has `npcflag` 1. Electrocutioner 6000 (6235) had
  two "On Aggro - Say Line 0" SmartAI rows (ids 0 and 3, from two script versions).
- **Changed:** new `sql/fixes/world/2026_10_19_08_gnomeregan_emi_electrocutioner.sql`:
  `creature_template` 7998 `npcflag` 2 -> 1; `smart_scripts` 6235 id 3 deleted.
- **Status:** Emi confirmed in game by Four on 2026-10-19 (her event ran to the end, Grubbis counted
  for his objective). Electrocutioner untested.

#### Way too many troggs in Emi's event
- **Found** (reported by Four): Emi's event summons every trogg wave, her explosive charges (183410),
  Grubbis and Chomper, and three red rockets at the end. The DB also had all of it spawned from the
  start at the same spots (`VerifiedBuild` 0: a sniff of the event saved as spawns), so the two tunnels
  emptied out on top of the waves.
- **Changed:** new `sql/fixes/world/2026_10_19_09_gnomeregan_emi_event_prespawns.sql` deletes creature
  guids 324522 to 324554 (30 Caverndeep Ambushers 6207, 1 Caverndeep Burrower 6206, Grubbis 7361,
  Chomper 6215) and gameobject guids 189336 to 189339 (Explosive Charge 144065) and 189340, 189341
  (red rockets 103820), with their `gameobject_addon` rows. The event still summons its own. The original
  rows are in the world dump.
- **Status:** untested in game.

#### Stuck in combat after killing an Irradiated Pillager
- **Found** (reported by Four): right after killing an Irradiated Pillager (6329), `.debug combat`
  still listed it ("[PvE] Irradiated Pillager (SpawnID 324438)") and Four stayed in combat until
  `.combatstop`. Two SmartAI rows (ids 2 and 5, two script versions) cast Radiation (9798) on death. In
  8.3.7 that puts a permanent aura (duration index 21) on every enemy within 13 yards that triggers
  Radiation (9770) damage every 3 s, cast by the dead Pillager, so each tick put the player back in
  combat with the corpse.
- **Changed:** new `sql/fixes/world/2026_10_19_10_gnomeregan_irradiated_pillager_death.sql` deletes
  `smart_scripts` 6329 ids 2 and 5. The living Pillager's own Radiation auras (9769, and 9798 on 18
  spawns, from `creature_addon` and On Reset) stay.
- **Status:** untested in game.

#### Mekgineer Thermaplugg: bombs from the Gnome Faces, one Knock Away
- **Found** (reported by Four): Thermaplugg (7800) used Knock Away very often. Walking Bombs (7915)
  appeared in the middle of the room and then under him wherever he stood, never from the Gnome Faces
  on the walls. One bomb stood below a face before the fight, and bombs kept meleeing after they had
  detonated. Kill credit and the Gnomeregan achievement worked. His SmartAI mixed two script versions:
  two rows each with ids 3 and 5, Knock Away three times (10101 twice, 11130 once), bombs summoned on
  himself and at one fixed spot, and broken links. The bomb's Detonation row linked to id 3, which
  doesn't exist, so its despawn never ran.
- **Changed:** new `sql/fixes/world/2026_10_19_11_gnomeregan_thermaplugg.sql`:
  - Thermaplugg's `smart_scripts` rewritten: Knock Away (10101) every 12 to 15 s; every 12 to 16 s
    one of six action lists (780000 to 780005, picked at random) summons a Walking Bomb (despawns
    after 60 s) in front of one of the six Gnome Face pedestals: 15 yards from the Gnome Face
    gameobject towards the centre of the six faces (-522.75, 670.10), at z -325.0. The first version
    put them 40% of the way to the faces' buttons, inside the pedestals, and Four saw none. Four's
    `.gps` in front of Gnome Face 06's pedestal (-553.38, 643.70, floor -327.27) is 1.8 yards from
    that face's spot. The yells, Pound (74720), Steam Blast (93655) and Welding Beam (52778) are as before.
  - Walking Bomb: Detonation (4043) now links to the despawn; a summoned bomb joins the fight
    against everyone in the instance (`SET_IN_COMBAT_WITH_ZONE`).
  - The bomb spawned from the start, creature guid 324517, is deleted.
  - The faces' buttons (142214 to 142219) still do nothing.
- **Status:** confirmed in game by Four on 2026-10-19 (bombs walk out in front of the faces).

#### To pick up the Gnomeregan fixes
SQL only, then restart `worldserver` (templates and SmartAI load at startup).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_08_gnomeregan_emi_electrocutioner.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_09_gnomeregan_emi_event_prespawns.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_10_gnomeregan_irradiated_pillager_death.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_11_gnomeregan_thermaplugg.sql | mysql -u root -p bfa_world
```

### The Stockade

Merged to `main` with PR #16 on 2026-10-23.

#### Lord Overheat's Fiery Core didn't always drop
- **Found** (reported by Four): the first kill of Lord Overheat (46264) gave no Lord Overheat's Fiery
  Core (62305) for "By Fire Be Saved!" (27737); after `.respawn`, a second kill dropped it. The loot row
  only drops for players on the quest (`QuestRequired` 1), but its `Chance` was 36.5696, so roughly two
  kills in three dropped nothing for the quest.
- **Changed:** new `sql/fixes/world/2026_10_19_07_stockade_overheat_core.sql`: `creature_loot_template`
  46264 / 62305 `Chance` 36.5696 -> 100.
- **Status:** confirmed in game by Four on 2026-10-23 (the core dropped on the first kill, on an alt).
  The dungeon objectives were fine: `.debug scenario` showed Lord
  Overheat's objective at progress 2 (both kills counted), and the one-step objectives finished
  with the achievement after Hogger. What looked missing was most likely just the core quest.

#### To pick up the core fix
SQL only, then restart `worldserver` (it loads loot tables at startup).
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_07_stockade_overheat_core.sql | mysql -u root -p bfa_world
```

### Crash: picking open a lockbox or junkbox

Merged to `main` with PR #16 on 2026-10-23.

- **Found** (reported by Four): Pick Lock on a Battered Junkbox (16882, looted in The Stockade) crashed
  the worldserver at once, and the client was disconnected. Four's gdb backtrace: `SIGSEGV` in
  `GameObject::GetGOInfo (this=0x0)` called from `Spell::EffectOpenLock` at `SpellEffects.cpp:1936`.
  Upstream commit 9d1bf0d ("Core/CPP: Fix Mining Gain Skill") added a gathering skill-up block at the
  end of `EffectOpenLock` that reads `gameObjTarget->GetGOInfo()` without checking `gameObjTarget`.
  When the lock is on an item, `gameObjTarget` is null, so every item lock opened with a spell (rogue
  Pick Lock, and any key or spell that opens an item lock) crashes the server. Still in upstream HEAD
  (51fad1a) at the time of writing. The junkbox loot tables are fine.
- **Changed:** new `tools/bfa/open-lock-crash.patch` (`src/server/game/Spells/SpellEffects.cpp`): that
  block now runs only when the target is a gameobject (`goInfo` is null for an item). Opening chests and
  gathering nodes is unchanged.
- **Status:** confirmed in game by Four on 2026-10-19 (Battered Junkbox picks open, no crash).

#### To pick up the lockbox crash fix
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/open-lock-crash.patch | git apply
grep -c "Pick Lock on a junkbox" src/server/game/Spells/SpellEffects.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1. Then restart `worldserver`.

### World: Stormwind (Innkeeper Allison, stray spawns, Miss Danna's tour)

Merged to `main` with PR #13 on 2026-10-19.

#### Innkeeper Allison has no inn or vendor options
- **Found** (reported by Four): Innkeeper Allison (6740) in the Trade District only offered "Make this
  inn your home" and "Let me browse your goods" while her Hallow's End quest was available. She is the
  only big-city innkeeper set up differently: `gossip_menu_id` 0 and no `ScriptName`, while Innkeeper
  Farley (295), Brianna (6727), Belm (1247), Firebrew (5111), Norman (6741) and the other city
  innkeepers use `ScriptName` `npc_innkeeper` with a real innkeeper menu. `npc_innkeeper`
  (`src/server/scripts/World/npc_innkeeper.cpp`) builds the inn, vendor and Hallow's End "Trick or
  Treat" options itself. Why the default menu 0 path left her without options wasn't pinned down; the
  fix gives her the same setup as the innkeepers that work.
- **Changed:** new `sql/fixes/world/2026_10_19_03_stormwind_innkeeper_allison.sql`:
  `creature_template` 6740 `gossip_menu_id` 0 -> 342 (the menu her own SmartAI's Trick or Treat rows
  expect, also used by Innkeeper Brianna), `ScriptName` '' -> 'npc_innkeeper'. Her SmartAI
  (/flex credit for Flexing for Nougat) is unchanged.
- **Status:** confirmed in game by Four on 2026-10-19.

#### A Prisoner on the bridge and Gil under it
- **Found** (reported by Four): a Prisoner (53527, guid 300000881) stood alone in the middle of the bridge
  between the Trade District and the Mage Quarter, and Gil (3504, guid 189600) was stuck under the bridge
  next to it.
  - The Prisoner is the only spawn of 53527 on the server, with no waypoints, formation or SmartAI: the
    guard escort it belongs to doesn't exist here.
  - Gil's spawn (`VerifiedBuild` 0, not sniffed) had no path or formation and just stood under the
    bridge. He comes back on his own walking path in the Miss Danna fix below.
- **Changed:** new `sql/fixes/world/2026_10_19_04_stormwind_stray_spawns.sql` deletes both spawns
  (`creature` and `creature_addon` guids 300000881 and 189600). The file has the rows to put back in its
  comments.
- **Status:** confirmed in game by Four on 2026-10-19.

#### Miss Danna, her school group and Gil were missing from Stormwind
- **Found** (asked by Four, who checked Wowhead and Wowpedia: she should still walk her tour): Miss
  Danna (3513) and the children Pat (3505), Andi (3507), Mikey (3508), Geoff (3509), Twain (3510),
  Steven (3511) and Jimmy (3512) had creature templates and SmartAI but no spawns, in the dump or in
  any core update. Their SmartAI here started a `waypoints` path 3513 that doesn't exist, and Miss
  Danna, Steven and Jimmy had no `creature_text`. Gil (3504) only had the stray spawn under the bridge.
- **Source:** the alexkulya/pandaria_5.4.8 world database (`sql/base/world_04_03_2023.zip`, the same
  reference the zrpandaria548 spawncompare tool uses) has the whole group: spawns, Miss Danna's path,
  the formation, her SmartAI and texts, and Gil on his own path. Everything is copied from there and
  converted to this core's columns.
- **Changed:** new `sql/fixes/world/2026_10_19_05_stormwind_miss_danna_orphans.sql`:
  - `creature`: Miss Danna guid 188983 (MovementType 2) and the seven children 188984 to 188990 in the
    Trade District at (-8838.52, 670.28); Gil guid 6183 (MovementType 2) at (-8780, 899.541).
    Respawn 300 s (Pandaria had 43200 for the group).
  - `creature_addon`: path 188983 for Miss Danna, path 6183 for Gil.
  - `waypoint_data`: path 188983, 60 points (Trade District, Cathedral Square, Stormwind Keep, the
    Valley of Heroes and back, with stops of 15 to 22 s at each sight); path 6183, 25 points (Gil's walk
    toward the Mage Quarter and back). Gil's Pandaria path called `waypoint_scripts` 102 to 116; those
    are not copied (`action` 0), his SmartAI already says his lines.
  - `creature_formations`: the seven children follow 188983. `groupAI` 514 instead of Pandaria's 2,
    because this core only moves members with the leader when `FLAG_IDLE_IN_FORMATION` (0x200) is set
    (`CreatureGroup::LeaderMoveTo`).
  - `smart_scripts`: Miss Danna (3513, ids 0 to 6) starts action lists 351300 to 351306 on reaching
    path nodes 20, 34, 35, 37, 51, 52 and 54; they make her talk and emote, make Jimmy and Steven ask
    their questions, and tell the children which way to face (children ids 0 to 2, data set 1/2/3).
    Replaced: her old rows 0 to 8, the children's ids 0 and 1 (follow Miss Danna) and action lists
    351300 to 351302. The children's emote reactions (ids 100 and up) are kept.
  - `creature_text`: Miss Danna groups 0 to 5, 7 and 8, Steven 0, Jimmy 0. Group 5 isn't in the
    Pandaria data; its text is from Wowpedia. The text for group 6 (at the Valley of Heroes) isn't known
    anywhere checked, so that one talk row is left out and she only plays the emote there.
- **Status:** confirmed in game by Four on 2026-10-19.

### To pick up the Stormwind fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_03_stormwind_innkeeper_allison.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_04_stormwind_stray_spawns.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_19_05_stormwind_miss_danna_orphans.sql
```
Then restart worldserver.

### Blackfathom Deeps (redesign): weapons, and the missing breath bar

`sql/fixes/world/2026_10_19_02_blackfathom_redesign_equipment.sql`, and a setting. Both from Four's
redesign runs. On PR #14, not merged yet.

- **Found:**
  - The Twilight's Hammer, the Blindlight murlocs, Thruk, Executioner Gore, Domina, Subjugator Kor'ul,
    Je'neu and Zeya held no weapons. Their spawns name equipment set 1 (Thruk also set 2), but
    `creature_equip_template` had no rows for them: TrinityCore's redesign sniff only added the two
    entrance Sentinels'.
  - No breath bar under water. Not a bug: upstream's `worldserver.conf` has `DisableWaterBreath = 1`, so
    every account with GM level 1 or higher has unlimited breath, everywhere.
- **Changed (SQL):** 33 `creature_equip_template` rows for 32 creatures (every redesign creature that
  has a set: 74351, 74353, 74363, 74380, 74382, 74408, 74409, 74476, 74505 sets 1 and 2, 74518, 74565,
  74720, 74721, 74980, 74983, 74984, 74988, 74989, 75011, 75012, 75058, 75285, 75286, 75640-75643,
  76036-76039, 77232), copied from TrinityCore's
  `sql/old/9.x/world/22012_2022_03_06/2022_02_16_09_world_910.sql` (sniffed on build 40120). Every
  redesign spawn's equipment set now exists. Twilight Lord Bathiel and the Twilight Tormentor have no
  set in that data and stay unarmed.
- **Changed (setting, optional):** `DisableWaterBreath = 4` in `worldserver.conf` gives GM accounts
  normal breath. The guide now mentions it.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19 (weapons shown,
  breath bar with `DisableWaterBreath = 4`).

#### To pick up the weapons and the breath setting
SQL and a config line, then a restart. No rebuild.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_02_blackfathom_redesign_equipment.sql | mysql -u root -p bfa_world
sed -i 's/^DisableWaterBreath *= *[0-9]*/DisableWaterBreath = 4/' ~/bfa/server/etc/worldserver.conf
grep '^DisableWaterBreath' ~/bfa/server/etc/worldserver.conf
```
The grep prints `DisableWaterBreath = 4`.

### Aku'mai's Poison Cloud (Blackfathom Deeps, classic)

New `tools/bfa/spell-corrections.patch`, applied after `dungeon-scale-quest-xp.patch`. Four's classic
run on 2026-10-19 had Aku'mai only meleeing; Four chose to fix this one spell and leave the other
classic bosses' original abilities as they are. On PR #14, not merged yet.

- **Found:** Aku'mai (4829, `boss_aku_mai`) casts Poison Cloud (3815) every 25-50 s. In the 8.3.7 client
  data its only effect applies aura 70, which this core treats as client-side (extra attacks) and
  ignores, although it has a 3 s period and 33 base points: the old cloud's nature damage. So the cloud
  did nothing. Frenzied Rage at 30% health is unaffected.
- **Changed (patch):** `SpellMgr.cpp`, `SpellMgr::LoadSpellInfoCorrections`: spell 3815 effect 0 applies
  `SPELL_AURA_PERIODIC_DAMAGE`, so enemies within 8 yards of Aku'mai take 33 nature damage every 3 s
  while it lasts (before any scaling).
- **Status:** `SpellMgr.cpp` compiles here and the patch applies on the full chain. Confirmed in game by
  Four on 2026-10-19: the cloud now damages.

#### To pick up the Poison Cloud fix
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/spell-corrections.patch | git apply
grep -c "Poison Cloud (Aku'mai" src/server/game/Spells/SpellMgr.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1.

### Blackfathom Deeps (classic): fixes from the first classic run

`sql/fixes/world/2026_10_19_01_blackfathom_classic_fixes.sql`. Four ran the classic layout on 2026-10-19:
all bosses looted, all quests could be completed, and Lady Sarevess, Gelihast and Old Serra'kis
credited Domina, Subjugator Kor'ul and the Guardian of the Deep. On PR #14, not merged yet.

- **Found:**
  - The creatures the Fire of Aku'mai event summons were already standing in the side alcoves before
    any fire was lit: 19 spawns (guids 321248-321266: 4 Barbed Crustaceans, 3 Aku'mai Snapjaws,
    10 Murkshallow Softshells, 2 Aku'mai Servants). The Portal of Aku'mai still opened after all four
    fires and their waves, because only summoned creatures count towards it.
  - Morridune (6729) was spawned at Aku'mai's altar from the start (guid 327435) and the instance script
    summons another one when Aku'mai dies.
  - Two Blackfathom Myrmidons and two Blackfathom Sea Witches stood on one spot (within 2 yards) in the
    corridor at (-607, -31).
  - Not bugs: the Flaming Eradicator (44387), frozen in ice, gives the Horde quest The Enemy of My
    Enemy (26899, Head of Kelris), so an Alliance character sees nothing to do there. Thruk and
    Executioner Gore are credited by Lorgus Jett (12902, guid 321127 at (-456, -40, -32), past Gelihast)
    and Baron Aquanis (12876, guid 321268 at (-780, -79, -44), in the water below Kelris's ledge, by the
    Fathom Stone).
- **Changed (SQL):** deleted the 19 alcove spawns and the spawned Morridune (with their
  `creature_addon` rows); moved Sea Witch 321185 to (-607.3, -35.0, -24.9), Myrmidon 321205 to
  (-610.3, -30.7, -24.3) and Sea Witch 321204 to (-610.0, -27.5, -24.1). Myrmidon 321131 stays.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19 ("classic
  working as desired").

#### To pick up the classic fixes
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_01_blackfathom_classic_fixes.sql | mysql -u root -p bfa_world
```

### DungeonScale XP settings stop only kill XP

New `tools/bfa/dungeon-scale-quest-xp.patch`, applied after `dungeon-spell-fixes.patch`. Asked for by
Four on 2026-10-19. On PR #14, not merged yet.

- **Found:** `DungeonScale.XP.Enable = 0` and `DungeonScale.XP.StopAfterCompletion` took all XP inside
  a scaled instance, quest XP included. Four wants quests to still give XP.
- **Changed (patch):** `solocraft.cpp`, `DungeonScale_PlayerScript::OnGiveXP`: XP is only taken when
  it comes with a victim. In this core that is only kill XP (`KillRewarder`, solo or in a group); quest
  rewards, exploration, XP-granting spells and player choices pass no victim, so they still count.
  `.dungeonscale info` now says "XP: quests only, kills give none ...". The descriptions of both keys in
  `worldserver.conf.dist` say kill XP. Your `worldserver.conf` needs no change.
- **Status:** `solocraft.cpp` compiles here and the patch applies on the full chain. Confirmed in game by
  Four on 2026-10-19: quests in a dungeon give XP while kills give none.

#### To pick up the XP change
A new patch on top of the others, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-scale-quest-xp.patch | git apply
grep -c "amount && victim" src/server/scripts/Custom/solocraft.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 1.

### Blackfathom Deeps (redesign): Coiled Rope shortcut, second try

`sql/fixes/world/2026_10_19_00_blackfathom_coiled_rope.sql`. On PR #14, not merged yet.

- **Found (Four's run, 2026-10-19):** the Rope Ladder Post at the bottom (224747) jumped you up to the
  Coiled Rope before anyone had used the Coiled Rope, and using the Coiled Rope changed nothing you could
  see. In TrinityCore's sniff, the second Rope Ladder Post (224628, beside the Coiled Rope) and the
  Invisible Man next to it (74997) only appear after the Coiled Rope is used;
  `2026_10_17_03` spawned both from the start. The bottom post's flag 0x10 (not selectable) doesn't stop
  the client from using it, and the core doesn't check that flag.
- **Changed (SQL):**
  - Removed the start-of-run spawns of the top post (gameobject guid 4800007) and its Invisible Man
    (creature guid 4800158), with their `spawn_group` rows. Creature guid 4800007 (Ghamoo-Ra) is untouched.
  - Coiled Rope 224627 SmartAI, now once per instance and only on use: summons Invisible Man 74997 at
    (-289.306, 82.339, -52.110) and Rope Ladder Post 224628 at (-289.270, 82.371, -52.264), clears 0x10 on
    the bottom post, removes Coiled Rope Usable (150866) from the Invisible Man 75000, and sets 0x10 on
    itself.
  - Invisible Man 74997 SmartAI: when summoned, casts Rope Ladder (150850). A `conditions` row aims its
    second effect (an aura on a nearby creature) at the Invisible Man 74998 by the bottom post. This is
    likely what draws the rope between the posts; not verified.
  - Rope Ladder Climb (150851) gets a cast condition (source type 17, condition 29): Invisible Man 74997
    within 40 yards of the player, so the bottom post does nothing until the Coiled Rope was used. The
    jump target is still the Invisible Man 75000.
- **Status:** the SQL ran twice against the dump. Confirmed in game by Four on 2026-10-19.

#### To pick up the Coiled Rope fix
SQL only, then a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_19_00_blackfathom_coiled_rope.sql | mysql -u root -p bfa_world
```

## 2026-10-18

### Creature spells that did nothing, and the Coiled Rope shortcut

New `tools/bfa/dungeon-spell-fixes.patch`, applied after `blackfathom-layouts.patch`, and
`sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql`. Found from the client's SpellName,
SpellEffect and SpellMisc.db2, which Four sent on 2026-10-18. On PR #14, not merged yet.

- **Found:**
  - Spells aimed with target 110 (a cone that selects by creature entry) never hit anything. HavenCore
    maps 110 to line selection, and `Spell::SelectImplicitLineTargets` is commented out. 213 client spells
    use it, among them Domina's Maw of Death (149894), the Blindlight Rotmouth's Corpse Spew (150453) and
    Executioner Gore's Executioner's Strike (149943).
  - Other redesign boss spells end in a dummy effect whose base points name the spell that does the work.
    Retail casts those from its own server scripts, and HavenCore has none, so the spell stops at the
    dummy. Examples: Piercing Rain 151814 names 152884, Foul Tempest 149887 names 152799, and Restorative
    Waters 150020 names 150022, which summons the Restorative Waters. 12 such spells are cast by
    Blackfathom Deeps creatures.
  - The Coiled Rope (224627) wasn't selectable (flags 0x10; TrinityCore's sniff has 0), and nothing made
    the Rope Ladder Post (224747) usable. The post casts Rope Ladder Climb (150851), a jump to the
    nearest creature of an entry the spell's conditions name, and there were no conditions.
- **Changed (patch):**
  - `SpellInfo.cpp`: target 110 uses cone selection (`TARGET_UNIT_CONE_ENTRY_110`).
  - `Spell.cpp`: a cone that selects by entry and has no conditions takes the caster's enemies, as the
    enemy cone (104) does. Without that it would hit the caster's allies too.
  - `spell_generic.cpp`: new `spell_gen_dummy_cast_base_points`. On each dummy effect hit, the caster
    casts the spell the effect's base points name at that target (triggered).
- **Changed (SQL, `2026_10_18_01`):**
  - `spell_script_names` for the 12 spells: Foul Tempest 149887, Catch of the Day 149908 and 149910,
    Restorative Waters 150020, Darkness Calls 151159, Tearing the Void 151303 and 151304, Grip of
    Darkness 151313, Static Shock 151683, Piercing Rain 151814, Spore Cloud 152753 and Falling Debris
    152965.
  - Coiled Rope 224627: `flags` 0. Its SmartAI makes the Rope Ladder Post within 40 yards selectable
    when used, then makes itself unselectable. A `conditions` row points Rope Ladder Climb at the
    Invisible Man 75000 beside the Coiled Rope, so the post jumps you back up to it.
- **Status:** the three changed files compile here and the patch applies on the full chain; the SQL ran
  twice against the dump. Not working in game yet: on 2026-10-19 Four's run had Corpse Spew, Maw of
  Death, Foul Tempest, Piercing Rain, Restorative Waters and Tearing the Void still doing nothing.
  That build didn't have the patch (both greps printed 0). Rebuilt with the patch applied (greps 4
  and 1), Four confirmed in game on 2026-10-19 that Domina's Maw of Death (the cone fix) and Foul
  Tempest (the dummy-cast script) now work. Later the same day Four also confirmed Corpse Spew
  (Blindlight Rotmouth), Catch of the Day and Fillet of Flesh (Thruk), Restorative Waters (summons its
  adds) and Piercing Rain (Bathiel), and all of Aku'mai the Devourer's spells. Then: Ghamoo-Ra's Static
  Shock and the rest of her spells, and all of Kor'ul's and the Guardian of the Deep's spells. Every
  spell in this entry is confirmed in game as of 2026-10-19. The Coiled Rope part did not work: the
  bottom post jumped you up before the Coiled Rope was used, and using it showed nothing. See
  "Coiled Rope shortcut, second try" (2026-10-19).

#### To pick up the spell fixes
A new patch on top of the others, the SQL, the build and a restart.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-spell-fixes.patch | git apply
grep -c "spell_gen_dummy_cast_base_points" src/server/scripts/Spells/spell_generic.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_18_01_blackfathom_redesign_spells.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 4.

### Blackfathom Deeps (redesign): fixes from the first full run

`tools/bfa/blackfathom-layouts.patch` (changed) and `sql/fixes/world/2026_10_18_00_blackfathom_redesign_fixes.sql`.
Four ran the redesign from the entrance to Twilight Lord Bathiel on 2026-10-18 and reported 28 findings.
On PR #14, not merged yet.

- **Found:**
  - After Bathiel died, the Portal of Aku'mai stayed shut, so Aku'mai the Devourer couldn't be reached.
    In HavenCore, a new instance's bosses start as TO_BE_DECIDED. `InstanceScript::SetBossState` from that
    state only records the new state and returns false. The redesign bosses have no boss scripts, so
    their first state change is DONE, and the instance script's door and spawn updates never ran. The same
    bug kept Domina and Kor'ul from appearing over Bathiel's altar, and would have kept the quest givers and
    the Spoils chest from appearing after Aku'mai. Their kills weren't saved either.
  - Twilight Disciples (74989, 75012), a Twilight Storm Mender (75011), Subjugator Kor'ul (74565) and three
    murlocs in his room (75641-75643) were friendly and level 1: placeholder templates (faction 35,
    level 1, no loot). Kor'ul couldn't be attacked.
  - A second Guardian of the Deep (75410, spawn 4800176), friendly, stood on the ledge by Thruk.
  - Executioner Gore played his yell but no text appeared. The redesign's lines use text range 1 (area),
    which only reaches players in the speaker's area id, and in Blackfathom Deeps players have no valid
    area id (worldserver logged "Area: 1575977184 (Unknown)").
  - The classic quests had no source in the redesign: no Twilight Pendants (Twilight Falls) and no
    Corrupted Brain Stems (Researching the Corruption). The Head of Kelris and the Strange Water Globe
    had no source either, and the Fathom Stone and the Pitted Iron Chest were classic-only spawns.
- **Changed (patch):** `instance_blackfathom_deeps.cpp` sets a redesign boss to NOT_STARTED before DONE
  when its state is still TO_BE_DECIDED. Its death now saves the run, opens the Portal of Aku'mai (Bathiel)
  and shows the spawns that wait for it.
- **Changed (SQL, `2026_10_18_00`):**
  - The placeholder templates copy the hostile creature of the same name. Twilight Disciples 74989 and
    75012 copy 75286 (faction 14, level 23), Storm Mender 75011 copies 74980 (level 24), Kor'ul copies
    Domina (faction 14, level 25), the Bilefins 75641/75642 copy 74721 and the murloc 75643 copies 74720.
    The copies cover level, gold, loot and pickpocket tables. The murloc 75640 gets 74720's loot table.
  - Guardian of the Deep spawn 4800176 is deleted.
  - `creature_text` range 1 becomes 0 (normal say/yell distance) for Executioner Gore 74988 and 74518,
    Sentinel Aluwyn, Zeya and the Frightened Prisoner 75428.
  - Quest items, all quest-only drops at 100%: Twilight Pendant 5879 from every redesign Twilight's
    Hammer creature (16 loot tables; Twilight Tormentor 75034 gets its own). Corrupted Brain Stem 5952
    from the Blindlight murlocs (74719, 74720, 74721, 74984, 75658). Head of Kelris 5881 from Bathiel.
    Strange Water Globe 16782 from Executioner Gore 74518, which starts Baron Aquanis, so it drops
    without a quest, as it did from Aquanis.
  - The Fathom Stone (188159) and the Pitted Iron Chest (188182) are in new spawn group 442, which shows
    in both layouts.
- **Not done yet:** the Coiled Rope shortcut, the boss spells that do nothing (Piercing Rain, Restorative
  Waters, Spore Cloud, the Rotmouth's vomit), the executions and the Ghamoo-Ra and tentacle events, and
  weapons for the Twilight's Hammer creatures (no equipment data).
- **Status:** confirmed in game by Four on 2026-10-19: the run reached and killed Aku'mai the Devourer
  (the portal opened after Bathiel), every boss counted for the objectives, and the Blackfathom Deeps
  achievement was awarded. The other changes in this entry weren't reported on separately.

#### To pick up the redesign fixes
The patch changed, so the old version comes out first (commit 1c47a4c is the last one with it), then the
new one goes in. Then the SQL, the build, and a restart. Start a new instance afterwards.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show 1c47a4c:tools/bfa/blackfathom-layouts.patch | git apply -R
git -C ../tools-repo show FETCH_HEAD:tools/bfa/blackfathom-layouts.patch | git apply
grep -c "TO_BE_DECIDED" src/server/scripts/Kalimdor/BlackfathomDeeps/instance_blackfathom_deeps.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_18_00_blackfathom_redesign_fixes.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The grep prints 2.

## 2026-10-17

### Blackfathom Deeps (redesign): Executioner Gore at the prisoners can't be fought

`sql/fixes/world/2026_10_17_04_blackfathom_gore_executioner.sql`. On PR #14, not merged yet.

- **Found:** Four fought Executioner Gore in the redesign's first prisoner room. The kill didn't count
  for the "Executioner Gore" objective and he dropped no loot. There are two Executioner Gores. 74988
  stands with the prisoners on the way in (spawns 4800069 and 4800113). His lines are "Intruders?! Move
  the prisoners!", "Come along, heroes! The water is fine." and "The intruders are still alive?! Stop
  them!". The boss the objective asks for is 74518 (spawn 4800174), near Twilight Lord Bathiel ("I was
  hoping you would make it to me."). 74988 was a hostile elite with 20% drop chances. Nothing stopped
  players from fighting him, and his kill gives no credit.
- **Changed:** creature 74988 gets `unit_flags` 0x300 (immune to players and creatures), so he can't
  be attacked. His SmartAI is replaced by one script per spawn. At the first prisoners, he says "Intruders?!
  Move the prisoners!" when a player comes within 40 yards. Six seconds later he says "Come along,
  heroes! The water is fine." and he despawns 4 seconds after that. At the second prisoners, he says
  "The intruders are still alive?! Stop them!" and despawns 5 seconds later. The old entry SmartAI rows
  are deleted.
- **Not done yet:** on retail, Gore executes prisoners in these rooms; that part isn't scripted.
- **Status:** the SQL ran twice against the dump. Not yet tested in game.

#### To pick up the Gore fix
SQL only. Run it, then restart worldserver.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_04_blackfathom_gore_executioner.sql | mysql -u root -p bfa_world
```

### Blackfathom Deeps: the redesigned layout, next to the classic one

New `tools/bfa/blackfathom-layouts.patch`, applied after `dungeon-boss-loot.patch`, and
`sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql`. Asked for by Four on 2026-10-17 after
fighting Lady Sarevess where the Adventure Guide shows Domina: keep both layouts, with an NPC at the entrance
to pick one per run. On PR #14, not merged yet.

- **Found:**
  - HavenCore spawns the classic Blackfathom Deeps: Ghamoo-Ra, Lady Sarevess, Gelihast, Lorgus Jett,
    Baron Aquanis, Twilight Lord Kelris, Old Serra'kis and Aku'mai. Its boss scripts and the quests
    Deep in the Deeps (26892) and Nightmare of the Deeps (26888) are built around them.
  - The 8.3.7 client shows the 6.0.2 redesign. The Adventure Guide lists Ghamoo-Ra, Domina, Subjugator
    Kor'ul, Thruk, Guardian of the Deep, Executioner Gore, Twilight Lord Bathiel and Aku'mai. The dungeon
    objectives come from scenario 333, which `.debug scenario` showed wants Ghamoo-Ra 74446, Thruk,
    Executioner Gore, Twilight Lord Bathiel and Aku'mai the Devourer 75155, with Domina, Kor'ul and the
    Guardian as bonus objectives. None of these was spawned, so the objectives could never complete with
    the classic bosses.
  - The database already had the redesign's creature templates, SmartAI, loot and quests (The Rise of
    Aku'mai 34672/34673), but no spawns. TrinityCore master has the redesign's spawns, sniffed from
    retail (`sql/old/11.x/world/25031_2025_05_31/2025_04_22_00_world.sql`).
- **Changed (SQL, `2026_10_17_03`):**
  - The redesign's spawns are converted from that file to this schema: 280 creatures and 74 gameobjects
    (guids 4800000-4800999), 2 patrol paths (`waypoint_data` 48001110, 48001450), and template addons for
    the redesign-only creatures. All of them are in spawn groups 433-440. 434-437 are the Alliance and
    Horde quest givers at the entrance and at Aku'mai. 438/439 are Domina and Kor'ul over Bathiel's
    altar. 440 is the Spoils of Blackfathom chest.
  - New creature 4800000, the Blackfathom Chronicler <Dungeon Layouts>, just inside the entrance (spawn
    4800999, group 441, shown in both layouts, using Lorekeeper Amberwind's model).
  - `instance_encounters` rows for the redesign bosses, using the DungeonEncounter ids from the client's
    JournalEncounter.db2: 1667 Ghamoo-Ra, 1668 Domina, 1669 Kor'ul, 1675 Thruk, 1676 Guardian of the Deep,
    1670 Executioner Gore, 1671 Bathiel, and 1672 Aku'mai the Devourer (last encounter of dungeon 10).
  - Aku'mai the Devourer had no loot (`lootid` 0) and now uses classic Aku'mai's table (4829). Also:
    weapons for the entrance quest givers, the Frightened Prisoner's gossip menu (16166), Rope Ladder
    Post 224747 not clickable, and the Spoils chest's world effect.
- **Changed (patch):**
  - `instance_blackfathom_deeps.cpp` loads both layouts and hides the one not in use. The hidden spawns go
    to a database phase no player is in, the same way as Shadowfang Keep's faction troops. Spawns in
    other spawn groups (gathering nodes) show in both. Faction quest givers show only for the team in the
    instance. The redesign's Aku'mai quest givers and chest appear after Aku'mai the Devourer dies.
  - The layout is saved with the instance. An instance saved before this patch stays classic.
  - Redesign touches: creatures sniffed as stationary (tentacles, heads, bunnies, channelers) are rooted,
    the ones sniffed in mid-air hover, and the bodies of Lady Sarevess, Gelihast and the Slain Hero
    look dead. The redesign's Portal of Aku'mai opens when Twilight Lord Bathiel dies. The redesign bosses
    run their existing SmartAI, and their deaths save the run's progress.
  - Each classic boss stands where a redesign boss does. In the classic layout, its kill counts for that
    boss's objective: Ghamoo-Ra for Ghamoo-Ra, Lorgus Jett for Thruk, Baron Aquanis for Executioner Gore,
    Kelris for Bathiel and Aku'mai for Aku'mai the Devourer. The bonus objectives map the same way:
    Sarevess for Domina, Gelihast for Kor'ul and Old Serra'kis for the Guardian. In the redesign layout,
    a redesign boss's kill credits the classic boss for the quests that ask for it (Deep in the Deeps,
    Nightmare of the Deeps).
  - Core: new `InstanceScript::GetScenarioKillCredit` (by default the creature's own entry), used for the
    scenario's kill credit in `KillRewarder.cpp` and for the boss loot guarantee in `Unit.cpp`.
  - `blackfathom_deeps.cpp`: `npc_blackfathom_chronicler`. Its gossip tells you which layout the
    instance has and switches to the other one. Switching is refused once any boss of the run is dead,
    or while you are in combat.
  - `worldserver.conf.dist`: `Blackfathom.Layout` (default 1, the redesign; 0 is classic) picks the
    layout of a new instance. A new DUNGEON LAYOUTS block at the end. The install step only updates
    `worldserver.conf.dist`, so until you add `Blackfathom.Layout = 1` to your own `worldserver.conf`, the
    server warns "Missing name Blackfathom.Layout" and uses the default.
- **Not done yet:** the redesign bosses only use the two or three abilities their SmartAI already had,
  which are the ones in the Adventure Guide. Their events aren't scripted yet: Aku'mai's heads and
  tentacles, the Deep Terror vehicles, the Coiled Rope, Gore's executions, the Guardian's eggs and
  Ghamoo-Ra's cultists. The classic quests that need classic drops (Knowledge in the Deeps, Researching
  Corruption, Twilight Falls) aren't mapped to the redesign yet. The Spoils of Blackfathom chest has no
  loot of its own.
- **Status:** compiles here; the SQL ran twice against the dump. Not yet tested in game.

#### To pick up the two Blackfathom layouts
Two patches and one SQL file. The second line applies `dungeon-boss-loot.patch` first, but only if it isn't
in your tree yet.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
grep -q "HasKillCriteria" src/server/game/Entities/Unit/Unit.cpp || git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-boss-loot.patch | git apply
git -C ../tools-repo show FETCH_HEAD:tools/bfa/blackfathom-layouts.patch | git apply
grep -c "GetScenarioKillCredit" src/server/game/Entities/Unit/Unit.cpp
grep -c "npc_blackfathom_chronicler" src/server/scripts/Kalimdor/BlackfathomDeeps/blackfathom_deeps.cpp
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_03_blackfathom_redesign_layout.sql | mysql -u root -p bfa_world
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` lines should print 1 and 3. The build recompiles every script because `InstanceScript.h`
changed. Then restart `worldserver` and reset Blackfathom Deeps (an instance saved before this stays
classic). `Blackfathom.Layout` doesn't have to be in `worldserver.conf`; without it new instances get the
redesign.

### Loot: every dungeon boss gets the boss loot guarantee

New `tools/bfa/dungeon-boss-loot.patch`, applied after `dungeon-scale-xp.patch`. Asked for by Four on
2026-10-17 ("all bosses"). On PR #14, not merged yet.

- **Found:** the "bosses always drop an item" rule from `loot-fixes.patch` only knows a boss through
  `IsDungeonBoss`, which is set from `instance_encounters`. Blackfathom Deeps and Ragefire Chasm have no
  rows there at all, so their bosses never got it. Wailing Caverns, The Deadmines and Shadowfang Keep do
  have theirs listed.
- **Changed:**
  - `Scenario.h` / `Scenario.cpp`: new `Scenario::HasKillCriteria(entry)`: true when a step of the
    scenario has a kill criteria for that creature needed once ("Lady Anacondra defeated"). Kill counts
    above 1 ("Defeat 20 ...") are left out, so trash doesn't qualify.
  - `Unit.cpp`, `Unit::Kill`: on a dungeon or raid map, a creature gets the boss loot guarantee when it is
    an `instance_encounters` credit (as before) or the instance's scenario has such a kill criteria for
    it. Everything else about the guarantee is unchanged.
  - No SQL and no setting. Use `.debug scenario` in a dungeon to see which creatures its objectives name.
- **Status:** compiles here; not yet tested in game.

#### To pick up the boss loot change
A new patch on its own:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-boss-loot.patch | git apply
grep -c "HasKillCriteria" src/server/game/Entities/Unit/Unit.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` line should print 1. Then restart `worldserver`.

### DungeonScale: XP settings

New `tools/bfa/dungeon-scale-xp.patch`, applied after `wailing-caverns-fixes.patch`. Asked for by Four on
2026-10-17: XP inside dungeons was too high, and a dungeon already completed should give none. On PR #14,
not merged yet.

- **Changed:**
  - `DungeonScale.XP.StopAfterCompletion` (default 1): inside a scaled dungeon, no XP at all (kills and
    quest turn-ins) once you have the dungeon's achievement for the mode you are in, even inside its
    level range. "The dungeon's achievement" is any achievement, not a statistic, with a criteria that
    kills a creature and is made for that map (`Achievement.InstanceID`), or that kills the final boss
    (`instance_encounters` row with `lastEncounterDungeon`). An achievement whose criteria has extra
    requirements (Heroic ones require Heroic difficulty) only counts where they hold, so a Heroic
    achievement doesn't stop XP on Normal. Built once per map and difficulty.
  - `DungeonScale.XP.Enable` (default 1): 0 gives no XP inside any scaled instance, for testing.
  - Both only apply where DungeonScale scales the map (`.dungeonscale info` says so). XP outside is
    untouched.
  - `.dungeonscale info` now says whether you get XP there, why not, and which achievements complete the
    map (`*` = only counts when its requirements hold).
  - Files: `solocraft.cpp` (DungeonScale: settings, `GetXPBlock`, `GetCompletionAchievements`, an
    `OnGiveXP` player hook, the info lines), `worldserver.conf.dist` (two keys, in the DUNGEON SCALE
    block), `Player.cpp` (`Player::GiveXP` stops when a script has taken all the XP, so no
    "You gain 0 experience" line is shown).
- **Status:** compiles here; not yet tested in game.

#### To pick up the XP settings
A new patch on its own. Neither key has to be in `worldserver.conf`: completion stopping XP is on, and XP
is on otherwise.
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/dungeon-scale-xp.patch | git apply
grep -c "DungeonScale.XP.StopAfterCompletion" src/server/scripts/Custom/solocraft.cpp
grep -c "a script took all of it" src/server/game/Entities/Player/Player.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
The `grep` lines should print 2 and 1. Then restart `worldserver`. To switch XP off for testing, add
`DungeonScale.XP.Enable = 0` to `~/bfa/server/etc/worldserver.conf` and type `.reload config`.

### Blackfathom Deeps (map 48)

Started by Four on 2026-10-17 on the night elf rogue. On PR #14 with the Wailing Caverns fixes, not merged
yet.

#### Je'neu Sancrea was hostile to the Alliance
- **Found** (in game): Je'neu Sancrea <The Earthen Ring> (12736), at the entrance with the Alliance quest
  givers, showed a red name and attacked when talked to.
- **Cause:** his quests are open to every race (Blackfathom Deeps 26894, Nightmare of the Deeps 26888,
  Amongst the Ruins 26891, The Essence of Aku'Mai 6563), and he takes the Alliance breadcrumb
  "Adventurers Wanted: Blackfathom Deeps" (28010). But `creature_template` gives him faction 126, a
  Horde faction. No `sql/updates` file changes him.
- **Changed:** `2026_10_17_02_blackfathom_jeneu_faction.sql`: faction 126 -> 35 (friendly to everyone,
  as Zeya next to him has). Revert line in the file. Safe to run twice.
- **Status:** run here against the dump; not yet tested in game.

### To pick up the Blackfathom Deeps fixes
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_02_blackfathom_jeneu_faction.sql | mysql -u root -p bfa_world
```
Then restart `worldserver`.

## 2026-10-16

### World: Lazy Peons (Durotar)

#### The Foreman's Blackjack says "Invalid target" on every Lazy Peon
- **Found** (reported by Four): every Lazy Peon (10556) in the Valley of Trials lay asleep, and the
  Foreman's Blackjack said "Invalid target" on all of them, so quest 37446 "Lazy Peons" couldn't be
  done. Lying asleep at spawn is intended (on retail the peons nap by the lumber piles until you wake
  them). The blackjack's spell, Awaken Peon (19938), only accepts a target that has the aura Peon
  Sleeping (17743): `Spell::CheckCast` in `Spell.cpp` checks it, and so does the spell condition
  (`conditions` source 17, entry 19938). Since the core's world update
  `2026_09_20_valley_of_trials_cosmetic_improvements.sql`, the peon's SmartAI adds 17743 once, on reset
  (spawn and after evading), and sets stand state 3 (asleep). The old C++ script `npc_lazy_peon`
  (removed from the peon by update `2026_08_06_00_Quest37446_Lazy_Peons_Fix.sql`) recast 17743 every
  5 minutes, because the aura runs out. After it runs out the peon keeps lying down, since the stand
  state doesn't change, but it can't be targeted. That the aura expiring is the cause is inferred from
  the old script and the error; it wasn't checked in game.
- **Changed:** new `sql/fixes/world/2026_10_16_04_durotar_lazy_peon_sleep_aura.sql`, on
  `smart_scripts` for 10556 (`source_type` 0):
  - id 1 (on reset, add aura 17743): `link` 0 -> 7.
  - id 6 (on wake, start the work action list 1055600): `link` 0 -> 8.
  - new id 7: linked from id 1, set event phase 1 (asleep).
  - new id 8: linked from id 6, set event phase 2 (working).
  - new id 9: out of combat, only in phase 1, every 30 s, add aura 17743 again.
  Waking, quest credit, the walk to the lumber pile, chopping for 60 to 180 s and going back to sleep
  (rows 0 to 6 and action list 1055600 from the core update) are unchanged.
- **Status:** confirmed in game by Four on 2026-10-16: the blackjack wakes the peons again.

### To pick up the Lazy Peon fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_04_durotar_lazy_peon_sleep_aura.sql
```
Then restart worldserver.

### World: Northwatch Scout (Durotar)

#### Northwatch Scout never melees, only casts Fan of Knives
- **Found** (reported by Four): Northwatch Scout (39317) in the Valley of Trials, Durotar, only ever
  cast Fan of Knives and never auto-attacked. The dump has 23 `smart_scripts` rows for 39317 from two
  different script versions mixed together (none of the core's `sql/updates/world` files touch them).
  On aggro, the old link chain (ids 0, 1, 2) cast Shoot once, then ran action 20
  (`SMART_ACTION_AUTO_ATTACK`) with 0, which turns melee off for the rest of the fight. The newer rows
  that turn it back on and switch between Shoot and melee (ids 4 to 15, 18) all have
  `event_phase_mask` 1, and nothing sets phase 1, so they never ran. Shoot (6660) has a minimum range,
  so next to the player only Fan of Knives (id 3) still worked. Id 16 (a talk on combat) did nothing
  either, because 39317 has no `creature_text`.
- **Faction:** unchanged. The scout's faction 190 shows as neutral (yellow). That value is sniffed data
  from build 35662, and every other mob in the Valley of Trials is neutral too (Mottled Boar, Scorpid
  Worker, Vile Familiar and Sarkoth are faction 7), so neutral is expected. It only fights back when
  attacked.
- **Changed:** new `sql/fixes/world/2026_10_16_03_durotar_northwatch_scout.sql` deletes every
  `smart_scripts` row for 39317 (`source_type` 0) and inserts three:
  - id 0: on reset (spawn and after evade), cast Stealth (58506) on itself if it isn't stealthed.
  - id 1: when the target is 5 to 30 yards away, cast Shoot (6660) on it every 2.3 to 3.9 s.
  - id 2: when the target is within 8 yards, cast Fan of Knives (79584) every 15 to 22 s (was within
    10 yards).
  Melee and chasing are left to SmartAI's defaults, so it auto-attacks in melee range.
- **Status:** confirmed in game by Four on 2026-10-16.

### To pick up the Northwatch Scout fix
SQL only, no rebuild:
```
cd ~/bfa/source
git -C ../tools-repo pull
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_03_durotar_northwatch_scout.sql
```
Then restart worldserver.

### Loot: reference loot tables never dropped, and bosses now always drop an item

New `tools/bfa/loot-fixes.patch`, applied after `transmog-collection.patch`. On PR #14, not merged yet.

#### Items from reference loot tables never dropped
- **Found** (in game, Wailing Caverns, on the Alliance rogue): Druids of the Fang, Lady Anacondra, Skum,
  Verdan the Everliving and Lord Pythas dropped money but no items. Trash elsewhere dropped items.
- **Cause:** a loot row with `Reference` set points to a shared table in `reference_loot_template` (world
  drops, most green items, many boss and chest tables). `LootTemplate::Process`
  (`src/server/game/Loot/LootMgr.cpp`) processed that table without passing the looter on, and
  `Loot::AddItem` throws away any item that has no looter. So nothing from a reference ever dropped,
  anywhere. 37,088 rows in 2,740 creature loot tables use a reference, plus 122 gameobject and 106 item
  loot tables. Upstream TrinityCore passes the looter.
- **Changed:** the looter (and the spec filter) are passed on to the referenced table. One line.
- **Status:** confirmed in game by Four on 2026-10-17.

#### Dungeon bosses dropped only gold
- **Found:** the four Wailing Caverns bosses above use plain rows, not references, so the fix above
  doesn't touch them. By their tables each kill drops no item 13 to 27% of the time (Skum 13%, Anacondra
  23%, Pythas 24%, Verdan 27%), so four empty kills in a row is about 1 in 500. Four's loot tables load
  (1,805,426 rows, none of the skipped ones are these bosses') and all `Rate.Drop.*` settings are 1.
  I found nothing in the core that treats a boss's loot differently from trash, so the cause is still
  unknown. Four asked for every boss to always drop loot, as on retail.
- **Changed:**
  - `LootMgr.cpp` / `LootMgr.h`: new `LootTemplate::AddItemIfNoneDropped`. It looks at the boss's own
    plain and grouped rows that the player could be shown (no references, quest items, currencies, rows
    with conditions or of the wrong loot mode). If any of them is uncommon or better, the player must have
    at least one uncommon-or-better item; otherwise any item counts. If the normal rolls gave none, one
    is added, picked by drop chance (`Chance` as the weight, 1 for equal-chanced group rows), so a rare
    item stays rare.
  - `Unit.cpp`, `Unit::Kill`: after the normal loot is filled for each looter, calls it for creatures that
    are dungeon or raid bosses (`IsDungeonBoss`: the kill credit of an `instance_encounters` row) on a
    dungeon or raid map.
  - The normal rolls are unchanged, so a boss can still drop more than one item. Bosses in the open world
    are not affected. The Deadmines boss items grouped by `2026_10_11_04_deadmines_boss_loot.sql` already
    always drop one, so nothing changes there.
  - No SQL and no config setting. To undo it, `git apply -R` the patch.
- **Status:** confirmed in game by Four on 2026-10-17: bosses drop loot.

#### Corpses holding a quest item you can't see could never be skinned
- **Found** (in game, Wailing Caverns, 2026-10-17): Deviate Ravagers (raptors) showed no skinning cursor
  after being looted, at any Skinning level.
- **Cause:** a loot item you aren't shown still sits in the corpse's loot. Every Wailing Caverns beast
  (Deviate Ravager, Guardian, Crocolisk, Python, Viper, Adder, Dreadfang, Moccasin, Venomwing) drops
  Deviate Hide (6443) 100% of the time for the quest Deviate Hides (26872); once you don't have that
  quest, the hide is hidden from you and can't be taken. The corpse only turns skinnable when its loot
  is empty, and `Loot::GetUnlootedCount` (`src/server/game/Loot/Loot.cpp`), asked without a player,
  counted every item, hidden ones included, so the corpse never emptied. The same goes for any mob with
  a quest item, a recipe you can't use or an other-faction item. Before the reference fix above fewer
  corpses held such items, but the quest hide is a plain row, so these were affected before too. The
  fix is in the core loot code, so it applies to every mob and every map, not just Wailing Caverns.
- **Changed:** in `loot-fixes.patch`, `GetUnlootedCount` without a player counts each looter's items
  by what that looter is shown (same rule as with a player: not looted, no conditions,
  `AllowedForPlayer`). If the looter is offline, their items still count, as before. This is also the
  check the Skinning spell uses ("you must loot it first").
- **Status:** Four reported Wailing Caverns good to go in game on 2026-10-17 after this update.

### To pick up the loot fixes
A new patch on its own, so the patches you already applied stay as they are. `LootMgr.h` is not in the
precompiled headers, so this should not be a full rebuild:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:tools/bfa/loot-fixes.patch | git apply
grep -c "item->groupid, player, specOnly" src/server/game/Loot/LootMgr.cpp
grep -c "AddItemIfNoneDropped" src/server/game/Entities/Unit/Unit.cpp
grep -c "FindConnectedPlayer(itemItr.first)" src/server/game/Loot/Loot.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
All three `grep` lines should print 1. Then restart `worldserver`.

If you applied the earlier version of the patch (before the skinning fix), take it out first, then
apply the new one as above:
```
git -C ../tools-repo show b21c5cc:tools/bfa/loot-fixes.patch | git apply -R
``` Once PR #14 is merged, `git -C ../tools-repo pull`
on `main` brings the file in as usual.

### Wailing Caverns (map 43)

Reported by Four on 2026-10-16 after a full run on the Alliance rogue: everything but the loot and the
final event worked. On PR #14, not merged yet.

#### Muyoh's escort never started, and Mutanus could be pulled early
- **Found** (in game): Muyoh (Disciple of Naralex, 3678) offered nothing to start the awakening of
  Naralex, and Mutanus the Devourer (3654) already stood "shadowed" in Naralex's pool, where he could be
  pulled and killed.
- **Cause:** `npc_disciple_of_naralex` (`wailing_caverns.cpp`) only adds "Let the event begin!" once
  instance data 1 to 4 (Lord Cobrahn, Lord Pythas, Lady Anacondra, Lord Serpentis) are DONE. The lords
  run SmartAI, and the world dump has no "on death, set instance data" row for any of them, so the four
  were never counted (TrinityCore has one per lord). The script's ending also waits for data 9 (Mutanus)
  to be DONE, which had no row either. Mutanus is meant to be summoned by Muyoh at the end of the ritual,
  at the same spot, but the dump also spawns him there (guid 326392).
- **Changed:** `2026_10_16_05_wailing_caverns_naralex_event.sql`:
  - `smart_scripts` id 100 for 3669, 3670, 3671, 3673 and 3654: On Just Died, Set Instance Data 1, 2, 3,
    4 and 9 to 3 (DONE).
  - Deletes the static Mutanus spawn (guid 326392), so he only appears when Muyoh summons him.
  - The revert lines, including the full Mutanus row, are at the top of the file. Safe to run twice.
- **Status:** confirmed in game by Four on 2026-10-17 that Mutanus is no longer in the pool. Lords
  killed before the SQL ran aren't counted, so it needs a fresh instance.

#### Muyoh couldn't be clicked, and Naralex had a dead "Lets Go!" dialog
- **Found** (in game, 2026-10-17, after the fix above with all four Fanglords dead): Muyoh still
  couldn't be interacted with. Naralex opened a dialog with "Lets Go!" that did nothing.
- **Cause:** Muyoh starts the event through gossip (`npc_disciple_of_naralex`, gossip menu 201), but
  `creature_template` 3678 has `npcflag` 2 (quest giver) only and she has no quests, so the client offers
  nothing to click. Naralex (3679) has `npcflag` 1 with gossip menu 3679, whose only option ("Lets Go!")
  and SmartAI gossip row ("Orgus - On Gossip - Kill Credit") belong to an unrelated NPC.
- **Changed:** `2026_10_17_00_wailing_caverns_muyoh_gossip.sql`: Muyoh `npcflag` 2 -> 3 (adds gossip),
  Naralex `npcflag` 1 -> 0. Revert lines in the file. Safe to run twice.
- **Status:** confirmed in game by Four on 2026-10-17: Muyoh offered the gossip, and the whole event ran
  through to Naralex waking, once she was moved down to the floor (next entry).

#### Muyoh started halfway down the first chamber, hovering out of reach
- **Found** (in game, 2026-10-17): with the gossip flag added, Muyoh still couldn't be talked to. She
  floated in owl form above the floor halfway down the first chamber; once Four moved her down with
  `.npc move`, she talked and the event ran. She should wait just inside the entrance.
- **Cause:** the dump spawns her (creature guid 326242) at (-84.2, 225.6, -83.8) with aura 8153 (owl form)
  in `creature_addon`. Owl form lifts her off the floor, and the server only lets you talk to an NPC
  within 5 yards (height included), even when the client shows the speech cursor. Her escort
  (`script_waypoint` 3678) starts at point 0 just inside the entrance (-120.864, 132.825, -79.2972), so
  she walked back there first anyway. The script gives her flight form itself at the end of the event.
- **Changed:** `2026_10_17_01_wailing_caverns_muyoh_spawn.sql`: moves guid 326242 to escort point 0,
  facing the entrance (orientation 3.17), and clears its `creature_addon` aura (8153 -> none). It also
  overwrites the spot `.npc move` saved. Revert lines in the file. Safe to run twice.
- **Status:** Four reported Wailing Caverns good to go in game on 2026-10-17 after this update.

#### No credit for "Muyoh escorted"
- **Found** (in game, 2026-10-17): the event finished, but the dungeon's objective "Muyoh escorted" was
  never ticked.
- **Cause:** in BFA, Wailing Caverns runs scenario 515 (`scenarios` table, map 43). Its steps and
  criteria live in the client's db2 files, not the world database, so I added a GM command to read them
  (below). Four's output: step 948 ("Disciples of Naralex", after the four Fanglords) needs criteria
  24776 "Muyoh escorted", type SEND_EVENT_SCENARIO (92) with scenario event 582, and criteria 34405
  "Mutanus the Devourer defeated" (kill 3654). `npc_disciple_of_naralex` never sends event 582, so the
  step can't complete.
- **Changed:**
  - New `tools/bfa/scenario-debug.patch` (applied after `loot-fixes.patch`) adds `.debug scenario`.
    Inside a dungeon, it lists every step of the scenario with its state, and under each step every
    criteria tree and criteria: description, criteria type and asset (creature, event or spell id), and
    the group's progress. It changes nothing in game. Files: `Scenario.h` / `Scenario.cpp` (two
    read-only accessors) and `cs_debug.cpp` (the command).
  - New `tools/bfa/wailing-caverns-fixes.patch` (applied after `scenario-debug.patch`):
    `npc_disciple_of_naralex::WaypointReached` (`wailing_caverns.cpp`) sends scenario event 582 when
    Muyoh reaches Naralex (escort point 24, where the awakening ritual starts). Mutanus is killed during
    the ritual, which then completes the step.
- **Status:** `.debug scenario` confirmed working in game by Four on 2026-10-17. Four reported Wailing
  Caverns good to go after the escort credit fix, the same day.

### To pick up the Wailing Caverns fixes
All three SQL files are safe to run again, so this runs them all. The debug command is a rebuild of
about 30 files. If you already applied `scenario-debug.patch`, skip its line:
```
cd ~/bfa/source
git -C ../tools-repo fetch origin claude/project-thread-g6xhsv
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_16_05_wailing_caverns_naralex_event.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_00_wailing_caverns_muyoh_gossip.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:sql/fixes/world/2026_10_17_01_wailing_caverns_muyoh_spawn.sql | mysql -u root -p bfa_world
git -C ../tools-repo show FETCH_HEAD:tools/bfa/scenario-debug.patch | git apply
git -C ../tools-repo show FETCH_HEAD:tools/bfa/wailing-caverns-fixes.patch | git apply
grep -c "HandleDebugScenarioCommand" src/server/scripts/Commands/cs_debug.cpp
grep -c "SCENARIO_EVENT_MUYOH_ESCORTED" src/server/scripts/Kalimdor/WailingCaverns/wailing_caverns.cpp
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
```
Both `grep` lines should print 2. Then restart `worldserver`. If the Fanglords were killed before the
first file ran, reset the instance (leave it, then Reset All Instances from your portrait menu) and kill
them again.

### Transmog collection

Merged to `main` with PR #12 on 2026-10-16 (reported 2026-10-15). Core changes are in the new
`tools/bfa/transmog-collection.patch`, applied after the other nine patches. It applies to a stock core
on its own too, so the order doesn't matter.

#### Appearances were not learned for items in the bags
- **Found** (reported by Four): picking items up didn't add their appearances to the collection. The
  core's collection code is TrinityCore's 8.3.7 version, unchanged, and it follows the 8.3.7 retail
  rules, which skip most of what lands in the bags while levelling:
  - `CollectionMgr::AddItemAppearance(Item*)` returns unless the item is soulbound. Bind on Equip items
    are only learned when equipped (`Player::VisualizeItem`); Bind on Pickup and quest items are learned
    on pickup.
  - `CollectionMgr::CanAddAppearance` returns false when `Player::CanUseItem` fails, which includes the
    item's required level being above yours, and when the character's class can't wear the armor type
    (`PlayerClassByArmorSubclass`) or doesn't have the weapon skill. A plate drop on a mage, or a
    level 20 blue on a level 18 character, was never learned, even though it was soulbound.
  - Items received by mail, trade, guild bank or buyback go through `Player::MoveItemToInventory`,
    which never calls the collection code, so a soulbound item received that way was never learned
    either (except later, by equipping or at login).
  Nothing was wrong with storage: appearances are saved account wide in `bfa_auth.battlenet_item_appearances`
  and loaded at login.
- **Changed:**
  - `CollectionMgr.cpp`, `AddItemAppearance(Item*)`: the soulbound check is skipped when
    `Transmog.CollectOnPickup` is 1, so any item that reaches the bags or bank is learned. Items already
    in the bags and bank are learned at the next login, because `Player::_LoadInventory` already passes
    every item through this function. Refundable vendor items and Bind on Pickup items that can still
    be traded to group members get the existing temporary appearance until the refund or trade window
    ends, as before.
  - `CollectionMgr.cpp`, `CanAddAppearance`: with `Transmog.CollectAnyClass` 1, the `CanUseItem`, weapon
    skill and armor type checks are skipped (TrinityCore did the same on its current branch in 2025).
    With it 0, `Transmog.CollectIgnoreLevel` 1 still skips the required level check
    (`CanUseItem(itemTemplate, true)`). Unchanged: only armor and weapons count, poor and common quality
    items are still not collectable (as in 8.3.7), and already known appearances are skipped.
  - `Player.cpp`, `MoveItemToInventory`: calls `AddItemAppearance` on the stored item when
    `Transmog.CollectOnPickup` is 1, for mail, trade, guild bank and buyback.
  - `World.h` / `World.cpp`: new settings `CONFIG_TRANSMOG_COLLECT_ON_PICKUP` (`Transmog.CollectOnPickup`),
    `CONFIG_TRANSMOG_COLLECT_ANY_CLASS` (`Transmog.CollectAnyClass`) and
    `CONFIG_TRANSMOG_COLLECT_IGNORE_LEVEL` (`Transmog.CollectIgnoreLevel`), all default 1, so the change
    is on without editing `worldserver.conf`. `.reload config` picks up changes.
  - `worldserver.conf.dist`: new `TRANSMOG COLLECTION` section with the three settings. Set one to 0 for
    the stock 8.3.7 behavior.
  - `CollectionMgr.cpp` / `.h`: `CanAddAppearance` now calls the new public
    `GetAppearanceRejectReason`, which runs the same checks and returns the reason an appearance is
    refused (or none). `AddItemAppearance(ItemModifiedAppearanceEntry const*)` is now public, and
    `GetKnownAppearanceCount` is new.
  - `cs_debug.cpp`: new GM command `.debug transmog <item id or link> [learn]` (debug permission). It prints
    the item's ItemModifiedAppearance, whether the server knows it and whether it was sent to the client,
    the reason it can't be collected, and how many appearances the account knows. With `learn` it adds
    the appearance without the checks, to test whether the client shows it.
  - No SQL.
- **2026-10-16, in game:** with the patch, nothing was collected up to level 23, and Cape of the
  Brotherhood (5193) and the equipped Wolfmaster Cape both still said "You haven't collected this
  appearance". Cloaks pass every class rule, so something else refuses them; the debug command was added
  to find out what.
- **Found** (2026-10-16, with `.debug transmog`): the real reason nothing was collected.
  `CanAddAppearance` refuses any item that has no row in `ItemSearchName.db2`, and every item failed it.
  Cape of the Brotherhood (5193, ItemModifiedAppearance 1985) and Wolfmaster Cape (6314, 2340) both
  answered "item missing from ItemSearchName.db2". After `.debug transmog <id> learn` the client said
  "has been added to your appearance collection" and showed both cloaks in Appearances > Back, so the
  client side and the update field work. The lookup is TrinityCore's, but it finds nothing with the
  client data extracted from this 8.3.7 client, so it blocked every appearance under any rules.
- **Changed:** `CollectionMgr.cpp`, `GetAppearanceRejectReason`: the `sItemSearchNameStore.LookupEntry`
  check is removed. The item still has to have an ItemModifiedAppearance, an item template, a
  collectable source type and pass the rest of the checks.
- **Status:** confirmed in game by Four on 2026-10-16: appearances are collected again. The appearances
  tab for armor only lists your own class's armor type, so a plate piece learned on a mage shows up on a
  plate wearer.

### To pick up the transmog collection change
Everything is on `main` now. If you applied the patch from the PR branch, `tools-repo` only needs to be on
`main`. The patch file there is the same one, so nothing needs rebuilding:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Coming from the Shadowfang Keep update without it, add the new patch. `World.h` is in the precompiled
headers, so this is a near full rebuild. There's no SQL:
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/transmog-collection.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
grep -q '^Transmog.CollectOnPickup' ~/bfa/server/etc/worldserver.conf || sed -n '/^# TRANSMOG COLLECTION$/,/^####/p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
```
Then type `server shutdown 1` in the worldserver console and start it again with
`cd ~/bfa/server/bin && ./worldserver`. Log out and back in to learn what is already in your bags and bank.

## 2026-10-15

### Shadowfang Keep (map 33)

Merged to `main` with PR #11 on 2026-10-16 (work from 2026-10-15 and 2026-10-16). Script changes are in
the new `tools/bfa/shadowfang-fixes.patch`, applied after the other five patches; three core fixes found
along the way have their own patches (below). A full Alliance run was confirmed in game by Four on
2026-10-16; the Horde side has not been played yet.

First version, tested by Four on 2026-10-15: the SQL worked (the Forsaken stood up, and the door room
held exactly the 14 spawns of groups 412 and 413), but nothing was hidden. The script hid creatures with
`PhasingHandler::AddPhase`, which for a creature spawned from the database adds the phase without
clearing its "unphased" flag (`PhaseShift::ModifyPhasesReferences` skips the flag update when
`IsDbPhaseShift` is set), so every player still saw it. The second version replaces the creature's
database phase instead (below); a small test against `PhaseShift.cpp` shows the old way stays visible
and the new way hides and shows again.

#### Both factions' allies were spawned at once
- **Found** (in game, Alliance): at the door stood Packleader Ivar Bloodfang (47006) with 6 Bloodfang
  Berserkers (47027), and next to them Deathstalker Commander Belmont (47293, guid 325993), 8 Veteran
  Forsaken Troopers (47030) and Forsaken Blightspreaders (47031, e.g. guid 325984). The Forsaken lay on
  the floor like corpses, were hostile to Alliance and could be attacked but not looted.

  The keep has an Alliance version of its allies (Ivar's worgen) and a Horde version (Belmont, High
  Warlord Cromush and the Forsaken). Each has one copy per stage of the run (at the door, after
  Ashbury, after Silverlaine, after Springvale, after Walden, outside Godfrey's room), and the Horde
  version adds 162 disease-cloud bunnies (ELM General Purpose Bunny 23837 with aura 88198) that appear
  boss by boss. HavenCore spawns every copy of both versions from the start. The Cataclysm Preservation
  Project (TrinityCore 4.3.4) shows only the right one with spawn groups 412-432 that its instance
  script switches on and off.

  The Forsaken were corpses because the 47030 and 47031 templates carry Permanent Feign Death (29266),
  and 47031 also has the feign death unit flag (`unit_flags2` 33556481). Only the dead troops outside
  Godfrey's room should be corpses, and their spawns have the aura themselves. The 47293 template has
  Stealth (58506) and the 47294 template kneels (`bytes1` 8); in both cases only one spawn should.

  Baron Silverlaine and Commander Springvale were never saved as killed: their scripts used their
  creature entries (3887, 4278) as encounter ids, which are out of range, and Springvale never called
  the engage or death handlers. Also, the team in the instance was read before it was ever set, and
  Lord Godfrey compared it against the wrong constant, so he always used his Alliance line.
- **Changed:**
  - `2026_10_15_01_shadowfang_faction_troops.sql`: 19 new spawn groups, 412-432 (no 423 or 426, see
    below), with flags 0, so they spawn exactly as before and nothing changes without the patch. The
    237 spawns are matched to the CPP groups by entry and position (all within 2.4 yards), except 14
    that CPP places elsewhere, which were placed by their guid order (HavenCore's guids run stage by
    stage) and position:
    - 421, Alliance after Ashbury: 327332-327338.
    - 425, Alliance after Springvale: 327339-327345. CPP splits this stage into 425 and 426 (the
      second spawned by an areatrigger when you go outside); HavenCore has one group of 7.
    - 424, Horde after Silverlaine: Cromush 326104. 429, Horde after Springvale: Belmont 326105.
    - HavenCore has no copy of CPP's Alliance group after Silverlaine (423), so the worgen are not
      seen between Silverlaine and Springvale.
  - The same file sets `auras` to '' on the 47030, 47031 and 47293 template addons, `bytes1` 0 on the
    47294 template addon, and 47031 `unit_flags` 512 to 768 and `unit_flags2` 33556481 to 33556480 (as
    in CPP). Revert lines are in the file.
  - `instance_shadowfang_keep.cpp`: each creature in groups 412-432 is shown only while its group is
    active for the team in the instance (the first player's) and the bosses killed so far, the same
    stages as CPP's script. The others get phase 65535, which no player is in, as their database phase
    (`PhasingHandler::InitDbPhaseShift`), so they are not seen and do not fight or talk; shown again,
    they get their own database phase back. This is checked when a creature spawns, when the first player enters, when a
    boss dies, and once when the Godfrey intro starts. CPP starts the intro with areatrigger 6431; here
    it starts when a player reaches the landing outside Godfrey's room (within 30 yards of -165, 2181,
    above z 145) after Lord Walden, which swaps Ivar or Belmont from Walden's room to Godfrey's door.
  - `instance_shadowfang_keep.cpp`: the team in the instance starts at 0 instead of an unset value.
  - `boss_baron_silverlaine.cpp`, `boss_commander_springvale.cpp`: encounter ids are now
    `DATA_BARON_SILVERLAINE_EVENT` and `DATA_COMMANDER_SPRINGVALE_EVENT`. Springvale now calls
    `_JustEngagedWith()` and `_JustDied()` like the other bosses. Silverlaine's calls to the
    instance's `SetData`, which did nothing, are removed.
  - `boss_lord_godfrey.cpp`: his aggro line checks the team against `HORDE` instead of `TEAM_HORDE`.
  - `shadowfang_keep.cpp`: the Haunted Stable Hand's teleports check the saved boss states (they
    never appeared before), and "Baron Silberlein" is now "Baron Silverlaine".
- **Status:** second version in game since 2026-10-15; Four reported "so far so good" and played on to
  Godfrey with it. Instances already open before the update keep their old boss states, so test in a fresh one.
  Full Alliance run confirmed by Four on 2026-10-16. The Horde side (Belmont and the Forsaken) has not
  been played yet.

#### Lord Walden evaded as soon as he was hit
- **Found** (in game): hitting Lord Walden put him straight into evade mode, and Lord Godfrey did the
  same.
- **Cause:** `boss_lord_walden.cpp` only started the fight if `SelectNearestPlayer(10.0f)` found a player,
  and otherwise evaded. Lord Godfrey had the same check (`boss_lord_godfrey.cpp`). Four pulled with
  Ambush from right behind, so distance wasn't it: HavenCore's `WorldObject::SelectNearestPlayer` and
  `SelectNearestPlayers` (`Object.cpp`) search with `Cell::VisitGridObjects`, which only visits
  creatures and objects, never players (upstream TrinityCore uses `VisitWorldObjects`). So the check
  never found anyone and both bosses always evaded. About 170 other scripts call these two, so Four chose
  to fix them core-wide (next entry).
- **Changed:** both bosses now start the fight on any pull; the 10-yard check is removed.
- **Status:** Lord Walden pulls and dies normally in game (Four, 2026-10-15).

#### Lord Walden never threw Frost Mixture on Normal
- **Found** (in game): Four found Walden's Normal fight "tank and spank".
- **Cause:** on Normal he has three abilities: Conjure Frost Mixture (93505), Conjure Poisonous Mixture
  (93697) and Ice Shards (93527). Conjure Mystery Toxin (Toxic Coagulant / Catalyst) is Heroic only.
  CPP's script, which follows retail, casts Frost Mixture on both difficulties. HavenCore's
  `boss_lord_walden.cpp` only cast it on Heroic, though it kept rescheduling it on Normal.
- **Changed:** Frost Mixture is cast on Normal too, at a random player within 50 yards, every 10 to 20
  seconds (HavenCore's timer, unchanged). Poisonous Mixture and Ice Shards were already used on Normal.
- **Status:** confirmed in game by Four on 2026-10-16, together with `random-target.patch`: he casts
  Conjure Poisonous Mixture, Conjure Frost Mixture and Ice Shards. (Before that core fix he still only
  meleed, because neither mixture ever found a target.)

#### Lord Godfrey only summoned ghouls
- **Found** (in game): Lord Godfrey pulled and fought, but the only ability he used was Summon Bloodthirsty
  Ghouls. On Normal he also has Cursed Bullets and Mortal Wound.
- **Cause** (`boss_lord_godfrey.cpp`):
  - Mortal Wound (93675, Heroic 93771) was cast with `DoCast(spellId)`, which picks the target from the
    spell's range. A melee-range spell has no fixed range, so it was aimed at Godfrey himself and never
    landed. It was also only tried every 25 seconds, for a debuff that stacks up to 10 times.
  - Cursed Bullets (93629, Heroic 93761) went to any random unit on his threat list at any range, cast
    instantly (triggered).
  - Pistol Barrage was scheduled on both difficulties; it is a Heroic-only ability.
- **Changed**, following CPP's script:
  - Mortal Wound is cast on his current target 3 to 4 seconds into the fight, then every 5 seconds.
  - Cursed Bullets goes to a random player within 50 yards, with its normal cast time, every 12 seconds
    (first after 15 seconds, as before).
  - Pistol Barrage is only scheduled on Heroic.
  - Summon Bloodthirsty Ghouls is unchanged.
- **Status:** confirmed in game by Four on 2026-10-16: he melees, casts Cursed Bullets and applies Mortal Wound.

#### Typos in Lord Godfrey's yells
- **Found** (in game): Four spotted typos in Lord Godfrey's (46964) lines and fixed them in the database
  on 2026-10-16.
- **Changed:** `2026_10_16_02_shadowfang_godfrey_text.sql` makes the same fix in `creature_text`:
  - group 0 (aggro): "That bitch Sylvanas sent you too,did she?No matter,your journey ends in agony." is now
    "That bitch Sylvanas sent you too, did she? No matter - your journey ends in agony."
  - group 2 (death): "I thank you for the clearn death.I would not of done the same..." is now
    "I thank you for the clean death. I would not have done the same..."
  Revert lines are in the file.
- **Status:** Four's own fix is live on their server. The file ran cleanly twice here; Four doesn't need to run it.

#### Lesser Gargoyles never attacked
- **Found** (in game): on the wall walk the Lesser Gargoyles (3869) never aggro, in or out of stealth.
- **Cause:** the world dump flags them `CREATURE_FLAG_EXTRA_CIVILIAN` (`flags_extra` 2). A civilian never
  starts a fight (`Creature::CanStartAttack`), although these are hostile (faction 16) and have loot and
  gold like other trash.
- **Changed:** `2026_10_16_01_shadowfang_lesser_gargoyles.sql` clears that one bit. Revert line is in the file.
- **Status:** confirmed in game by Four on 2026-10-16: they aggro once you leave stealth. The Stone
  Sleepers stayed asleep in the same test because `2026_10_15_02_shadowfang_stone_sleepers.sql` had not been
  run on that database yet (the Stone Sleeper still had the old unit flags, 16777215).

### Core: scripts never found the nearest player

New `tools/bfa/player-search.patch`, applied seventh, after `shadowfang-fixes.patch`. Chosen by Four on
2026-10-15 over fixing only Shadowfang Keep.

- **Found:** while looking into Walden and Godfrey (above). `WorldObject::SelectNearestPlayer` and
  `WorldObject::SelectNearestPlayers` (`src/server/game/Entities/Object/Object.cpp`) search with
  `Cell::VisitGridObjects`. That visits the grid container (game objects, creatures that aren't pets,
  area triggers and so on). Players live in the world container, so both always returned nothing.
  `SelectRandomPlayerInRange` uses `SelectNearestPlayers` and was empty too.
- **Changed:** both use `Cell::VisitWorldObjects`, as upstream TrinityCore does. Two lines.
- **Effect:** every script that looks for the nearest player, or picks players in range, now finds
  them. That is about 170 calls across dungeon, raid and world scripts, and SmartAI's closest-player
  target. Content tested before this, such as The Deadmines, may behave differently where it relied on
  this; tell me if anything changes.
- **Status:** confirmed in game by Four on 2026-10-16 through Lord Walden, who now pulls normally. Content tested before it (The Deadmines, Ragefire Chasm) not re-run yet.

### Core: mobs pulled from stealth evaded

New `tools/bfa/stealth-pull.patch`, applied eighth, after `player-search.patch`. It changes the
`CreatureAI::UpdateVictim` code that `deadmines-fixes.patch` added, so it needs that patch applied first.

- **Found** (in game, Shadowfang Keep): Four, a rogue, opened on Baron Ashbury from stealth from right
  behind. He yelled his aggro line ("Tally ho, the hunt begins"), went into evade mode (hits showed Evade), walked home
  and despawned. After he respawned, a pull out of stealth worked normally.
- **Cause:** a mob can't see a stealthed player standing behind it (`WorldObject::CanDetectStealthOf`
  only detects behind within its combat reach). With Subterfuge, stealth lasts 3 more seconds after the
  opener. While a player can't be seen, their threat entry is offline, so the mob has no target. HavenCore
  already evaded in that case while in combat, and `deadmines-fixes.patch` made it evade in every case
  (to fix Release Spirit after a wipe). So the mob evaded the moment it was pulled from stealth, and
  Ashbury despawns on evade. Same cause as Foe Reaper evading on a stealthed rogue in The Deadmines.
- **Changed:** in `src/server/game/AI/CreatureAI.cpp`, a mob with no target no longer evades while it
  is in combat and a living player who has threat on it is only hidden from it. It waits, and attacks as
  soon as it can see that player again. Vanish sets your threat to 0 in dungeons, so vanishing still
  resets the fight. A wipe still resets it too: dead players don't count.
- **Effect:** core-wide, for every mob and boss. A mob a hidden player has hit stands still until they
  show up, instead of resetting.
- **Status:** confirmed in game by Four on 2026-10-16: Baron Ashbury fights normally when pulled from stealth.

### Core: spells cast at a random player never went off

New `tools/bfa/random-target.patch`, applied ninth, after `stealth-pull.patch`.

- **Found** (in game, Shadowfang Keep): Lord Walden only meleed, even after Frost Mixture was turned on
  for Normal.
- **Cause:** `UnitAI::DoCastRandom` (`src/server/game/AI/CoreAI/UnitAI.cpp`) calls
  `SelectTarget(SELECT_TARGET_RANDOM, position, dist, true, aura)`. `SelectTarget`'s fifth parameter is
  `withTank`, not the aura, so the aura filter (almost always 0) turned into `withTank = false`. The player
  a boss is fighting was never a candidate. Solo, that leaves nobody, so the spell was never cast.
- **Changed:** `withTank` is passed as `true` and the aura goes in its own slot. One line.
- **Effect:** 57 calls use it. In content tested before: Lord Walden's Conjure Poisonous Mixture and
  Conjure Frost Mixture, and Gordoth's Ground Rupture in Ragefire Chasm. Baron Ashbury's Pain and
  Suffering skips the top-threat player on purpose, so solo it still isn't cast.
- **Status:** confirmed in game by Four on 2026-10-16 on Lord Walden. Gordoth not re-tested yet.

#### Stone Sleepers never came to life
- **Found** (in game): on the wall walk the Lesser Gargoyles (3869) attack, but the Stone Sleepers (3870)
  sit there inactive.
- **Cause:** Stone Sleepers are gargoyles that sit as stone and wake when someone walks past ("A nearby
  Gargoyle comes to life!", broadcast text 47423). Their SmartAI set every unit flag (16777215, including
  `NOT_SELECTABLE` and `IMMUNE_TO_PC`) on spawn and only cleared them on aggro, which those flags make
  impossible.
- **Changed:** `2026_10_15_02_shadowfang_stone_sleepers.sql` replaces the 3870 SmartAI. While asleep a
  Stone Sleeper is only `NOT_SELECTABLE | IMMUNE_TO_PC` (33554688). A hostile unit within 15 yards in
  line of sight wakes it: it clears those flags, emotes the line above (new `creature_text` row) and
  attacks that unit. After a reset it sleeps again. The Normal and Heroic fear casts are unchanged.
  Revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-16: the Stone Sleepers wake and attack.

#### Overlapping Frantic Geists: checked, left as is
- **Found** (in game): many spawns overlap, for example Frantic Geists standing almost inside each other.
- **Checked:** no two spawns in the keep share a spot (the closest pairs of the same creature are 0.5 to
  1 yard apart: Plagued Rats, Maggots and Geists). Frantic Geists come in tight packs: the Cataclysm sniff
  CPP imported (`2015_09_02_06_world.sql`) has 25 of them in packs of 4 to 5, 1 to 2 yards apart.
  HavenCore has 18 in packs of 2 to 3. Not changed.

### To pick up the Shadowfang Keep changes
Everything is on `main` now. If your `tools-repo` is still on the Shadowfang branch, put it back on `main`.
The patch files there are the same, so nothing needs rebuilding:
```
git -C ~/bfa/tools-repo checkout main
git -C ~/bfa/tools-repo pull
```

Coming from the 2026-10-15 Ragefire update with none of this applied, add the four new patches in order
and run the four SQL files (each is safe to run twice):
```
cd ~/bfa/source
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/shadowfang-fixes.patch
git apply ../tools-repo/tools/bfa/player-search.patch
git apply ../tools-repo/tools/bfa/stealth-pull.patch
git apply ../tools-repo/tools/bfa/random-target.patch
sudo cmake --build build -j"$(nproc)" && sudo cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_01_shadowfang_faction_troops.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_02_shadowfang_stone_sleepers.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_01_shadowfang_lesser_gargoyles.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_16_02_shadowfang_godfrey_text.sql
```
Then restart `worldserver` and use a fresh instance. If any `git apply` line prints an error, stop and
check it before building: a patch that didn't apply leaves that fix out silently.

### Ragefire Chasm (map 389)

Merged to `main` with PR #10 on 2026-10-15. Core changes are in the new
`tools/bfa/ragefire-fixes.patch`, applied after the other four patches.
Tested on Normal by Four on 2026-10-14: all four bosses work, and so do The Dark Shaman and A New
Enemy.

#### No Man Left Behind could not be finished
- **Found** (in game): only two SI:7 Rangers could be rescued, through the Suspicious Rock and the
  Inconspicuous Crate. Another ranger stood by the lava near Slagmaw and could not be clicked. The
  quest (30995, Alliance) needs 5 SI:7 Rangers (61788); the Horde version, No Orc Left Behind (30984),
  needs 5 Kor'kron Scouts (61680) and is set up the same way. Each faction has 8 prisoners in the
  instance (the other faction's are despawned by `instance_ragefire_chasm`):

  | Where (x, y) | SI:7 Ranger guid | Kor'kron Scout guid | Rescued by, before |
  |---|---|---|---|
  | Suspicious Rock (-311, -24) | 10642793 | 10615969 | talking to the rock |
  | Inconspicuous Crate (-89, 69) | 10642792 | 10615895 | talking to the crate |
  | Cages beside Lava Guard Gordoth (-378, 188 / -377, 185 / -376, 182) | 10642794, 10642797, 10642796 | 10615981, 10615985, 10615984 | clicking the cage (cage objects 211883-211885) |
  | By the lava near Slagmaw (-287, 135) | 10642795 | 10615970 | nothing |
  | Lying near Adarogg (-257, -49) | 10642790 | 10615942 | nothing |
  | Lying in the tunnel (-173, 2) | 10642791 | 10615916 | nothing |

  Both prisoner templates have `unit_flags` 33850176, which includes `NOT_SELECTABLE` and `STUNNED`, so
  none of them can be clicked. Their SmartAI only rescued on a spell click, and they have no
  `npc_spellclick_spells` row or spell click flag, so it never ran. The cages are door objects with a
  placeholder name ("Cage de l"); whether they can be clicked in the client isn't confirmed, and
  none were seen there in game.
- **Changed:**
  - `ragefire_chasm.cpp`: new creature script `npc_rfc_prisoner` for both prisoners. One second after
    spawning, a prisoner that is not within 3 yards of the rock or the crate becomes selectable and
    gets a gossip flag. Talking to it while on the quest rescues it; a caged one opens its cage.
  - `ragefire_chasm.cpp`: the credit and escape part of `RescuePrisoner()` is now `FreePrisoner()`,
    shared by the rock, the crate, the cages and talking to a prisoner. A freed prisoner loses its
    gossip flag and `STUNNED`, stands up, says its line, runs off and despawns. A prisoner without
    `STUNNED` can't be rescued again, so a prop or cage clicked twice can't give two credits. The
    5-credit cap moved into `GetNeededCreditEntry()`, used by every rescue.
  - `2026_10_15_00_ragefire_rescue_prisoners.sql`: 61680 and 61788 go from `AIName` 'SmartAI',
    `ScriptName` '' to `AIName` '', `ScriptName` 'npc_rfc_prisoner', and their 3 `smart_scripts` rows
    each are deleted. Revert lines are in the file.
- **Status:** confirmed in game by Four on 2026-10-15: No Man Left Behind completes. That gives 8
  rescuable prisoners for the 5 the quest needs.

### To pick up the 2026-10-15 changes
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo checkout main
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
git apply ../tools-repo/tools/bfa/ragefire-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_15_00_ragefire_rescue_prisoners.sql
```
Then restart `worldserver`.

## 2026-10-12

### NPC Designer, vendor module

`tools/npc-designer/`, all new (PR #9, merged).

- What: a PySide6 desktop app for designing vendor NPCs for BFA 8.3.7, Pandaria 5.4.8 and WotLK 3.3.5: name, title,
  display IDs, levels, faction, vendor type, repair, held items, items for sale with per-vendor prices, stock and
  restock, a drawn merchant-window preview, SQL export, and Apply to database (runs the export on the connected
  world DB after checking it matches the target).
- Writes: `creature_template` (npcflag 128 + repair 4096 / gossip 1 / tracking flags), `creature_template_model`
  (BFA) or `modelid1-4`, optional `creature_equip_template`, `npc_vendor` (BFA `OverrideGoldCost`, -1 = item's own
  price), optional `creature` spawns. Each table's old rows for the entry are deleted first.
- Item names/prices: BFA `dbc/enUS/ItemSparse.db2` (sparse WDC3), Pandaria `Item-sparse.db2` (WDB2), WotLK world DB.
- Status: confirmed working on BFA by Four (117,741 items loaded, export and apply). Pandaria/WotLK schema-tested only.
- To pick up: `cd ~/zrbfacore; git pull; ./tools/npc-designer/npc-designer` (needs `sudo dnf install python3-pyside6 python3-pymysql`).

### DungeonScale: dungeon mobs scale to your group

- **Found:** a pack of one Defias Enforcer and two Defias Shadowguards after Foe Reaper killed a level 17
  rogue in about 20 hits (235 to 508 each). Neither mob is out of line for the dungeon: the Enforcer
  has `DamageModifier` 15, like the ogres, Goblin Overseers and Defias Pirates. The Shadowguard has
  17.9, and the Squallshapers, Blood Wizards and Envokers have 20.8. Three elites built for a group of
  five were all hitting one player. HavenCore's Solocraft only raises the player's stats. It has no way
  to lower the damage you take.
- **Changed:** new `tools/bfa/dungeon-scale.patch`, a port of ZRPandaria's DungeonScale:
  - 5-man dungeon creatures get a share of their health and damage that depends on how many players
    are inside:

    | Rank | Health solo | Damage solo |
    |---|---|---|
    | Normal and elite trash | 30% | 30% |
    | Bosses | 35% | 35% |
    | Final boss | 40% | 35% |

    Both rise in a straight line to 100% at 5 players. For trash: 1 player 30%, 2 players 47.5%,
    3 players 65%, 4 players 82.5%, 5 players 100%.
  - A boss is any creature in `instance_encounters`. The final boss is the one with
    `lastEncounterDungeon` set: "Captain" Cookie on Normal and Vanessa VanCleef on Heroic. Adds a boss
    summons are scaled like the boss.
  - No single hit or DoT tick from a scaled creature takes more than 35% of your max health. The
    combat log still shows the uncapped number.
  - When someone joins or leaves, creatures out of combat are rescaled within a second. Creatures in
    combat keep their values until the fight ends for them.
  - Raids, scenarios and Mythic+ are not scaled unless turned on in the settings.
  - GM commands: `.dungeonscale info` and `.dungeonscale creature`.
  - Left out from the ZRPandaria version: the honor per kill.
- **Files:**
  - `ScriptMgr.h` / `ScriptMgr.cpp`: new `AllCreatureScript` hook type with `OnCreatureAddWorld`,
    `OnCreatureRemoveWorld` and `OnCreatureSelectLevel`.
  - `Creature.cpp`: `AddToWorld()`, `RemoveFromWorld()` and `UpdateLevelDependantStats()` call those
    hooks.
  - `solocraft.cpp`: the DungeonScale script, added at the end of the file so the patch creates no new
    files and `git checkout -- .` still removes it cleanly.
  - `custom_script_loader.cpp`: registers it.
  - `worldserver.conf.dist`: a new `DUNGEON SCALE` block at the end, with every setting explained.
- **Settings to change:** copy the `DungeonScale.*` block into `worldserver.conf` and set
  `Solocraft.Enable = 0`. Solocraft's +400% stats on top of 30% mobs would make dungeons trivial. The
  commands below do both.
- **Watch for:** Helix's `DamageModifier` is still 12 from `2026_10_11_01`. Scaled to 35%, he hits for
  about 21 instead of 60. If he's now too soft, his stock 57.5 scaled to 35% comes out at about 20, the
  value ZRPandaria used. The revert line is in that SQL file.
- **Status:** not tested in game yet.

### The Deadmines (map 36), Normal

Merged to `main` with PR #8 on 2026-10-12, together with the 2026-10-11 Deadmines fixes below.
Four ran the whole dungeon on 2026-10-14 with all of these in and reported it ran great; the
entries below were not checked one by one.
Still open, not fixed: a few old vanilla NPCs in the normal phase (Defias Miner 598 ×1, Defias Pirate
657 ×3 near the ship, Squallshaper 1732 ×1), and heroic Cookie can leave up to three "A Note From
Vanessa".

#### Heroic Vanessa event spawned on Normal
- **Found** (in game): a ghostly human Ripsnarl stood outside the door to the ship, and `.debug combat`
  showed the player stuck in combat with five Vanessa VanCleefs, also inside the Foe Reaper room.
  Vanessa's encounter and her nightmare event are Heroic-only, but 21 of their spawns had
  `spawnDifficulties` '1,2', so they spawned on Normal too. The nightmare Vanessas (49671) pull every
  player nearby into combat with themselves, which blocked logging out.
- **Changed:** `2026_10_12_01_deadmines_heroic_vanessa_event_spawns.sql` sets `spawnDifficulties` from
  '1,2' to '2' (Heroic only) for these spawns, the same as the event's lightning spawns already had:

  | Entry | Creature | Spawns (guid) |
  |---|---|---|
  | 49429 | Vanessa VanCleef (ship intro) | 326855 |
  | 49454 | Vanessa's Trap Bunny | 326857 |
  | 49457 | Steam Valve | 326856, 326858, 326859, 326860 |
  | 49552 | Vanessa's Rope Anchor | 326765, 326766, 326767, 326768, 326769 |
  | 49670 | Glubtok (nightmare) | 326861, 326904 |
  | 49671 | Vanessa VanCleef (nightmare) | 326862, 327028, 327095 |
  | 49674 | Helix Gearbreaker (nightmare) | 326922 |
  | 49681 | Foe Reaper 5000 (nightmare) | 327029, 327093 |
  | 49682 | Ripsnarl (nightmare) | 327094 |
  | 51624 | Vanessa Anchor Bunny JMF | 326763 |

  The two Vanessas without a spawn ID in `.debug combat` were summoned by these and go with them.
- **Status:** the cause is confirmed in game (`.debug combat` listed these Vanessas). The fix itself
  is not tested in game yet. It also probably explains the "stuck in combat" from the Foe Reaper room
  below and from the Mine Bunny.

#### Foe Reaper never woke, Defias Reapers vanished
- **Found** (in game): burnt-out Defias Reapers disappeared, the player stayed in combat, and Foe
  Reaper never powered up, so he couldn't be attacked. The Defias Watchers stayed. A burnt-out
  mech kept 15 health, and `DamageTaken` ignored all damage once it was burnt out, so poisons and
  DoTs already on it kept ticking and killed it. The Reapers are summoned with a 10-second corpse
  despawn, so their corpses vanished. The Watchers are normal spawns, so theirs stayed. A mech that
  died while still casting Energize never reached Foe Reaper. He only checked whether to wake when an
  Energize landed, so he slept for good.
- **Changed** in `boss_foe_reaper_5000.cpp`:
  - `npc_defias_watcher::DamageTaken`: a burnt-out mech now takes no damage at all.
  - `npc_defias_watcher::Energizing`: on burning out, the mech drops every periodic damage aura on it
    (`SPELL_AURA_PERIODIC_DAMAGE`, `_DAMAGE_PERCENT`, `PERIODIC_LEECH`). Energize is now cast as
    triggered, so it lands at once and can't be interrupted.
  - `boss_foe_reaper_5000AI::UpdateAI`: while he is asleep, he checks every second whether any
    hostile Reaper or Watcher is still alive within 60 yards. If none is, he wakes up, even without a
    last Energize.
- **Combat:** the combat that held you came from the heroic Vanessa event spawns (see above), not
  from the mechs.
- **Status:** confirmed in game 2026-10-12. All mechs stayed disabled and Foe Reaper powered up.

#### Foe Reaper reset right after waking on a stealthed player
- **Found** (in game, rogue in stealth): Foe Reaper powered up, said "Target destroyed", summoned four
  new Defias Reapers and went back to sleep a moment later. On waking he called `DoZoneInCombat()`,
  which puts every player in the instance into combat with him. A stealthed player he can't see is
  not a valid target, so he had nobody to attack, evaded and reset. Even without stealth, a solo
  player was pulled the instant the last mech went down, with no time to recover.
- **Changed** in `boss_foe_reaper_5000.cpp`, `boss_foe_reaper_5000AI`:
  - `EVENT_START_2` (powering up) no longer calls `DoZoneInCombat()`. He becomes attackable and
    aggressive and waits to be pulled: attack him, or walk into his aggro range. Once pulled,
    `JustEngagedWith()` still puts the whole group in combat as before.
  - New `_waitingForPull` / `_sleepTimer`, reset in `Reset()`. If nobody pulls him within 5 minutes
    (`FOE_REAPER_WAIT_FOR_PULL`), he emotes "Foe Reaper 5000 powers down." and resets: asleep and
    untouchable again, with four new Defias Reapers. The Defias Watchers stay disabled, as before.
- **Not changed:** dying or vanishing during the fight still resets him as before.
- **Status:** compiles; not tested in game yet.

#### Mine Bunny Drunken Haze
- **Found:** a Mine Bunny (48338, 48351) left you fully drunk after the fight, with no debuff and
  nothing in `.list auras`. Her SmartAI casts Drunken Haze (91032) on her target every 7 to 10
  seconds. Besides its 10-second debuff (50% slower movement, 30% slower attacks and casts), the
  spell has an Inebriate effect that sets your character's drunk level to 100. That level is
  stored on the character, not as an aura, and only drops by 1 every 9 seconds, so it lasted about
  15 minutes. `.modify drunk 0` clears it.
- **Changed:**
  - `boss_vanessa_vancleef.cpp`: new spell script `spell_dm_drunken_haze` skips the Inebriate
    effect and leaves the rest of the spell alone.
  - `2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql` adds one `spell_script_names` row:
    91032 -> `spell_dm_drunken_haze`. Nothing was bound to 91032 before.
- **Not changed:** the being stuck in combat and unable to log out wasn't reproduced. With a live
  Mine Bunny still on you, that is normal combat. If it happens with nothing alive near you,
  `.combatstop` clears it.
- **Status:** not tested in game yet.

### To pick up everything from 2026-10-12
`ScriptMgr.h` changed, so this build recompiles nearly everything.
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
git apply ../tools-repo/tools/bfa/dungeon-scale.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_12_00_deadmines_mine_bunny_drunken_haze.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_12_01_deadmines_heroic_vanessa_event_spawns.sql
grep -q '^DungeonScale.Enable' ~/bfa/server/etc/worldserver.conf || sed -n '/^# DUNGEON SCALE$/,$p' ~/bfa/server/etc/worldserver.conf.dist >> ~/bfa/server/etc/worldserver.conf
sed -i 's/^\(Solocraft\.Enable *= *\)1/\10/' ~/bfa/server/etc/worldserver.conf
```
Then restart `worldserver`. Its log shows `[DungeonScale] Loaded config: ENABLED`.

## 2026-10-11

### The Deadmines (map 36), Normal

All of these were merged to `main` with PR #8 on 2026-10-12. Core changes are in `tools/bfa/deadmines-fixes.patch`, and world data
changes are in `sql/fixes/world/2026_10_11_*.sql`. Each SQL file is safe to run twice and lists its own
revert lines. Tested at level 16-17 on a rogue with SoloCraft on.

#### Trash that never fought back
- **Found:** about 40 spawns of 7 trash types entered combat but never attacked or chased. Goblin
  Overseers also dropped you as soon as you left their room. Their scripts' `UpdateAI` never called
  `UpdateVictim()`, so line-of-sight aggro only added threat and no target was ever picked.
- **Changed** in `boss_vanessa_vancleef.cpp`. Each AI now starts `UpdateAI` with
  `if (!UpdateVictim()) return;`. This covers:

  | Creature | Entry | Spawns |
  |---|---|---|
  | Ogre Henchman | 48230 | 5 |
  | Goblin Overseer | 48279 | 11 |
  | Oaf Lackey | 48445 | 6 |
  | Defias Shadowguard | 48505 | 5 |
  | Defias Enforcer | 48502 | 6 |
  | Defias Envoker | 48418 | 3 |
  | Defias Blood Wizard | 48417 | 4 |
- **Also changed:** the Oaf Lackey's Enrage (`below`) and the Goblin Overseer's Threatening (`threat`)
  "already used" flags now reset to `false`. Both had started out as already used, so neither ability
  ever fired.
- **Status:** confirmed in game.

#### Boss doors closed again behind dead bosses
- **Found:** a door only opened at the moment its boss died. Kills are saved, but the doors are not,
  so after a `worldserver` restart, or once an empty area unloaded (5 minutes), they were shut again.
- **Changed** in `instance_deadmines.cpp`, `OnGameObjectCreate`. When a door is created, it opens if
  its boss is already DONE:

  | Door | Entry | Opens when |
  |---|---|---|
  | Factory Door | 13965 | Glubtok is dead |
  | Mast Room Door | 16400 | Helix is dead |
  | Foundry Door | 16399 | Foe Reaper 5000 is dead |
  | Iron Clad Door | 16397 | Ripsnarl is dead (it gets the "alternative active" state) |
- **Status:** not tested in game. It only shows after a restart or unload.

#### Mine Bunny damage
- **Found:** the two Mine Bunnies (48338, 48351) hit for about 1,700 at level 15. They had
  `DamageModifier` 125, a raid-boss value. Every other elite here sits between 15 and 21.
- **Changed:** `2026_10_11_00_deadmines_mine_bunny_damage.sql` sets `DamageModifier` from 125 to 15,
  the same as the ogres around them.
- **Status:** not confirmed separately in game.

#### Helix Gearbreaker and the Lumbering Oaf
- **Found:** the Oaf Helix rides (47297) ran the trash Oaf Lackey script, so it never grabbed or charged
  anyone. Helix never learned it had died. The real Oaf script was attached to 40906, an unrelated level
  28 Lumbering Oaf in Kalimdor.
- **Changed** in `2026_10_11_01_deadmines_lumbering_oaf_helix.sql`:
  - `creature_template.ScriptName` of 47297 changes from `npc_oaf_lackey` to `npc_lumbering_oaf`.
  - 40906 changes from `npc_lumbering_oaf` to empty, so it runs its own SmartAI again.
- **Found:** Helix swings every 0.5 s with `DamageModifier` 57.5. That was about 15 times the damage per
  second of the other bosses, and he also meleed from the Oaf's back on top of the Oaf's own hits.
- **Changed:**
  - In the same SQL file, Helix (47296) `DamageModifier` goes from 57.5 to 12. ZRPandaria used 20, but
    20 still killed a level 17 rogue here (100 to 200 per hit). 12 is about 60 per hit.
  - `boss_helix_gearbreaker.cpp`: Helix only melees when he is not riding the Oaf.
  - `boss_helix_gearbreaker.cpp`: if the Oaf's charge doesn't happen, it drops the player it grabbed,
    instead of carrying them until the next grab.
  - `boss_helix_gearbreaker.cpp`: the Oaf's `bunny` pointer now starts at `nullptr`.
- **Found:** Helix threw no Sticky Bombs. His Throw Bomb spell (88264) was bound in `spell_script_names`
  to `spell_throw_bomb`, a Winter Veil quest script that cancels the cast unless the caster is on a
  flying mount.
- **Changed:** `2026_10_11_03_deadmines_helix_sticky_bomb.sql` deletes that one row. Nothing else used it.
- **Found:** after a wipe, Helix climbed onto a new Oaf in `Reset()` while still walking home. That cut
  the walk short and could leave him stuck in evade mode.
- **Changed** in `boss_helix_gearbreaker.cpp`: he now mounts in `JustReachedHome()`, once he is home.
- **Status:** the Oaf fight and the Helix fight are confirmed good in game. The bombs were not confirmed
  separately.

#### Foe Reaper 5000
- **Found:** a Defias Reaper that died to one big hit never energized him, so he could stay asleep
  forever. The 10% health check subtracted the hit from the reaper's health as an unsigned number, which
  wrapped around.
- **Changed** in `boss_foe_reaper_5000.cpp`, `npc_defias_watcher::DamageTaken`. A hit at least as big as
  the remaining health now also counts.
- **Found:** he woke on the 4th Energize. The two Defias Watchers (47404) in his room energize him too,
  so killing them first woke him with two Defias Reapers (47403) still attacking.
- **Changed:** he now wakes when no living, hostile Reaper or Watcher is left within 60 yards.
- **Found:** he only picked a target during his abilities and stood still in between.
- **Changed:** `UpdateAI` calls `UpdateVictim()` every update, so he chases his top-threat target the
  whole fight. He only melees when he has a target.
- **Found:** Overdrive never ended. He kept switching to a random target every 1.5 s, at a fixed run
  speed of 4 yards per second.
- **Changed:** Overdrive now lasts 10 seconds. He stops attacking, goes passive and wanders within 15
  yards while it spins, then removes the aura and attacks again. It still comes every 45 seconds.
- **Found:** after Harvest his run speed was set to 2 yards per second for the rest of the fight.
- **Changed:** he now goes back to his normal run speed from `creature_template` and chases again.
- **Found** (in game, after the changes above): Defias Reapers came back mid-pull, and the burning
  mechs kept you in combat. He was attackable, but passive, before waking, so a stray hit or AoE pulled
  him. With the every-update target check above, he reset as soon as that combat ended, and his reset
  despawns the Reapers and summons four fresh ones. A disabled Reaper or Watcher also kept its threat
  and pulled every player in the instance into combat with itself.
- **Changed:**
  - `Reset()` now makes him non-attackable, immune to players and stunned until he wakes. The wake-up
    clears those flags before pulling the room into combat. `InitializeAI()` no longer removes them on
    spawn.
  - `npc_defias_watcher::Energizing()` now clears the mech's threat and stops its combat when it
    burns out, instead of calling `SetInCombatWithZone()`.
- **Not a bug:** the rideable Prototype Reaper (49208) is Heroic-only, as on retail.
- **Left as is:** burnt-out Reapers and Watchers show a vehicle cursor. `npc_spellclick_spells` gives
  47403 and 47404 the click spells 58961 and 90102. Whether riding them does anything on Normal hasn't
  been checked.
- **Status:** not tested in game yet.

#### Admiral Ripsnarl
- **Found:** once the fog rolled in at 75%, he summoned a Vapor every 3.5 seconds for the rest of the
  fight.
- **Changed** in `boss_admiral_ripsnarl.cpp`. Vapors now come every 3.5 seconds while he is hidden, and
  every 12 seconds once he is back. The fog itself still stays for the rest of the fight, as on retail.
- **Found:** he came back out of the fog both after 25 seconds and after 4 Vapor kills. When both
  happened, his Swipe timer was started twice and he swiped twice as often.
- **Changed:** he now comes back once per vanish. Vapors killed while he is visible no longer count
  toward bringing him back early.
- **Status:** not tested in game yet.

#### "Captain" Cookie
- Reviewed his script, the food NPCs and his spell script bindings. Nothing changed.

#### Boss yells
- **Found:** `creature_text` had no rows for the Deadmines bosses, so every `Talk()` was silent.
- **Changed:** `2026_10_11_02_deadmines_boss_texts.sql` adds the retail Cataclysm lines, with their
  sound IDs and BroadcastText IDs, numbered to match HavenCore's script group IDs:
  - Glubtok (47162): 8 lines.
  - Helix (47296): 4 lines.
  - Lumbering Oaf (47297): "OAF SMASH!!".
  - Foe Reaper 5000 (43778): 5 lines.
  - Admiral Ripsnarl (47626): 7 lines.

#### Boss loot
- **Found:** each boss item on Normal rolled on its own at 9 to 19%, so a kill often dropped only gold.
  Glubtok dropped no item about 58% of the time, and Helix about 64%. Today's changes hadn't touched loot.
  The rows matched the original dump.
- **Changed:** `2026_10_11_04_deadmines_boss_loot.sql` moves each boss's usual Normal items into loot
  group 1 with `Chance` 0. Exactly one of them now drops on every kill, picked evenly:

  | Boss | Items (old chance %) |
  |---|---|
  | Glubtok 47162 | 2169 (15), 5195 (16), 5444 (18) |
  | Helix 47296 | 5191 (9), 5199 (11), 5200 (9), 5443 (10) |
  | Foe Reaper 43778 | 1937 (13), 5187 (13), 5201 (14) |
  | Ripsnarl 47626 | 872 (15), 1156 (19), 5196 (14), 21524 (7) |
  | Cookie 47739 | 5192 (9), 5193 (15), 5197 (10), 5198 (12), 5202 (10) |

  Rare extras under 5% still roll on their own. The Cataclysm heroic items use loot mode 2, which this
  core never turns on, so they never drop. They are left as they were.

#### Core-wide: creatures reset after you die
- **Found:** when the last player died next to a boss, the boss stayed "engaged" by the corpse and never
  reset. Its encounter stayed in progress, which greyed out Release Spirit ("A member of your group is in
  combat"). It also kept pulling anyone who came back. HavenCore only reset a creature with no one left
  to fight if it had moved far from its spawn point.
- **Changed** in `src/server/game/AI/CreatureAI.cpp`, `CreatureAI::UpdateVictim()`. A creature with no
  target left now resets whether or not it is still in combat, the same as standard TrinityCore. This
  affects every creature in the game, not just Deadmines.
- **Status:** not confirmed separately in game. It needs a death next to a boss to show.

#### To pick up everything above
```
cd ~/bfa/source
git checkout -- .
git -C ../tools-repo pull
git apply ../tools-repo/tools/bfa/bfa-linux-fixes.patch
git apply ../tools-repo/tools/bfa/profession-skill-sync.patch
git apply ../tools-repo/tools/bfa/deadmines-fixes.patch
cmake --build build -j"$(nproc)" && cmake --build build --target install
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_00_deadmines_mine_bunny_damage.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_01_deadmines_lumbering_oaf_helix.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_02_deadmines_boss_texts.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_03_deadmines_helix_sticky_bomb.sql
mysql -u root -p bfa_world < ../tools-repo/sql/fixes/world/2026_10_11_04_deadmines_boss_loot.sql
```
Then restart `worldserver`. `git checkout -- .` discards any edits in `~/bfa/source` that didn't come
from these patches.
