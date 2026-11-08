-- Herb and ore nodes use each expansion's own skill (Four, 2026-11-08). Run against bfa_world, after
-- the hotfix fix sql/fixes/hotfixes/2026_11_08_00_gathering_tier_locks.sql.
--
-- Points each Outland-to-Legion herb and ore node at the new lock for its expansion (from where it
-- spawns) and requirement. The requirement scales the node's old 1-600 skill over its expansion's old
-- range (Outland and Northrend 300-375 and 350-450, Cataclysm 425-525, Pandaria 500-600) to 1 up to the
-- expansion skill's max minus 25; nodes that asked for nothing need 1, so the expansion's skill must be
-- learned. Only nodes whose lock has no other way to open it change (quest objects you can open by
-- kneeling keep theirs). Gathering nodes (type 50) that carried old-scale trivial skill (Data4/Data5,
-- used for skill-up chance) get the requirement and requirement + 25 instead, like Kul Tiran nodes.
-- Each UPDATE only applies while the node still has its old lock, so it is safe to run more than once.
-- Restart worldserver and delete the client Cache folder.
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181270 AND `Data0`=29; -- Felweed herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181271 AND `Data0`=29; -- Dreaming Glory herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51017, `Data4`=17, `Data5`=42 WHERE `entry`=181275 AND `Data0`=1641; -- Ragveil herb, Outland old 325 -> 17
UPDATE `gameobject_template` SET `Data0`=51023 WHERE `entry`=181276 AND `Data0`=1642; -- Flame Cap herb, Outland old 335 -> 23
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181277 AND `Data0`=29; -- Terocone herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51027, `Data4`=27, `Data5`=52 WHERE `entry`=181278 AND `Data0`=1643; -- Ancient Lichen herb, Outland old 340 -> 27
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181279 AND `Data0`=29; -- Netherbloom herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181280 AND `Data0`=29; -- Nightmare Vine herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=181281 AND `Data0`=29; -- Mana Thistle herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51101, `Data4`=1, `Data5`=26 WHERE `entry`=181555 AND `Data0`=38; -- Fel Iron Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51101, `Data4`=1, `Data5`=26 WHERE `entry`=181556 AND `Data0`=38; -- Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51101, `Data4`=1, `Data5`=26 WHERE `entry`=181557 AND `Data0`=38; -- Khorium Vein ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51101, `Data4`=1, `Data5`=26 WHERE `entry`=181569 AND `Data0`=38; -- Rich Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51101, `Data4`=1, `Data5`=26 WHERE `entry`=181570 AND `Data0`=38; -- Rich Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=51017, `Data4`=17, `Data5`=42 WHERE `entry`=183043 AND `Data0`=1641; -- Ragveil herb, Outland old 325 -> 17
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=183044 AND `Data0`=1124; -- Felweed herb, Outland old 300 -> 1
UPDATE `gameobject_template` SET `Data0`=51010, `Data4`=10, `Data5`=35 WHERE `entry`=183045 AND `Data0`=1639; -- Dreaming Glory herb, Outland old 315 -> 10
UPDATE `gameobject_template` SET `Data0`=51001, `Data4`=1, `Data5`=26 WHERE `entry`=183046 AND `Data0`=442; -- Blindweed herb, Outland old 235 -> 1
UPDATE `gameobject_template` SET `Data0`=51150 WHERE `entry`=185557 AND `Data0`=1651; -- Ancient Gem Vein ore, Outland old 375 -> 50
UPDATE `gameobject_template` SET `Data0`=51101 WHERE `entry`=185877 AND `Data0`=1649; -- Nethercite Deposit ore, Outland old 275 -> 1
UPDATE `gameobject_template` SET `Data0`=51033 WHERE `entry`=185881 AND `Data0`=1644; -- Netherdust Bush herb, Outland old 350 -> 33
UPDATE `gameobject_template` SET `Data0`=52001 WHERE `entry`=189973 AND `Data0`=1644; -- Goldclover herb, Northrend old 350 -> 1
UPDATE `gameobject_template` SET `Data0`=52101 WHERE `entry`=189978 AND `Data0`=1800; -- Cobalt Deposit ore, Northrend old 350 -> 1
UPDATE `gameobject_template` SET `Data0`=52113 WHERE `entry`=189979 AND `Data0`=1782; -- Rich Cobalt Deposit ore, Northrend old 375 -> 13
UPDATE `gameobject_template` SET `Data0`=52125 WHERE `entry`=189980 AND `Data0`=1783; -- Saronite Deposit ore, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=52137 WHERE `entry`=189981 AND `Data0`=1784; -- Rich Saronite Deposit ore, Northrend old 425 -> 37
UPDATE `gameobject_template` SET `Data0`=52013 WHERE `entry`=190169 AND `Data0`=1646; -- Tiger Lily herb, Northrend old 375 -> 13
UPDATE `gameobject_template` SET `Data0`=52018 WHERE `entry`=190170 AND `Data0`=1787; -- Talandras Rose herb, Northrend old 385 -> 18
UPDATE `gameobject_template` SET `Data0`=52037 WHERE `entry`=190171 AND `Data0`=1789; -- Lichbloom herb, Northrend old 425 -> 37
UPDATE `gameobject_template` SET `Data0`=52042 WHERE `entry`=190172 AND `Data0`=1790; -- Icethorn herb, Northrend old 435 -> 42
UPDATE `gameobject_template` SET `Data0`=52025 WHERE `entry`=190173 AND `Data0`=1788; -- Frozen Herb herb, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=52001 WHERE `entry`=190174 AND `Data0`=1124; -- Frozen Herb herb, Northrend old 300 -> 1
UPDATE `gameobject_template` SET `Data0`=52032 WHERE `entry`=190175 AND `Data0`=1793; -- Frozen Herb herb, Northrend old 415 -> 32
UPDATE `gameobject_template` SET `Data0`=52050 WHERE `entry`=190176 AND `Data0`=1792; -- Frost Lotus herb, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=52025 WHERE `entry`=191019 AND `Data0`=1788; -- Adders Tongue herb, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=52150 WHERE `entry`=191133 AND `Data0`=1785; -- Titanium Vein ore, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=52005 WHERE `entry`=191303 AND `Data0`=1786; -- Firethorn herb, Northrend old 360 -> 5
UPDATE `gameobject_template` SET `Data0`=52150 WHERE `entry`=195036 AND `Data0`=1785; -- Pure Saronite Deposit ore, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=53101 WHERE `entry`=202736 AND `Data0`=1861; -- Obsidium Deposit ore, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=53150 WHERE `entry`=202737 AND `Data0`=1862; -- Pyrite Deposit ore, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=53125 WHERE `entry`=202738 AND `Data0`=1863; -- Elementium Vein ore, Cataclysm old 475 -> 25
UPDATE `gameobject_template` SET `Data0`=53113 WHERE `entry`=202739 AND `Data0`=1864; -- Rich Obsidium Deposit ore, Cataclysm old 450 -> 13
UPDATE `gameobject_template` SET `Data0`=53150 WHERE `entry`=202740 AND `Data0`=1862; -- Rich Pyrite Deposit ore, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=53001 WHERE `entry`=202748 AND `Data0`=1789; -- Stormvine herb, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=53001 WHERE `entry`=202749 AND `Data0`=1789; -- Azsharas Veil herb, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=53025 WHERE `entry`=202750 AND `Data0`=1866; -- Heartblossom herb, Cataclysm old 475 -> 25
UPDATE `gameobject_template` SET `Data0`=53050 WHERE `entry`=202751 AND `Data0`=1868; -- Twilight Jasmine herb, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=53037 WHERE `entry`=202752 AND `Data0`=1867; -- Whiptail herb, Cataclysm old 500 -> 37
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=209311 AND `Data0`=38; -- Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=209312 AND `Data0`=38; -- Kyparite Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=209313 AND `Data0`=38; -- Trillium Vein ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=209328 AND `Data0`=38; -- Rich Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=209329 AND `Data0`=38; -- Rich Kyparite Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=209349 AND `Data0`=29; -- Green Tea Leaf herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=209350 AND `Data0`=29; -- Silkweed herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54037 WHERE `entry`=209351 AND `Data0`=1972; -- Snow Lily herb, Pandaria old 575 -> 37
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=209353 AND `Data0`=29; -- Rain Poppy herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54025 WHERE `entry`=209354 AND `Data0`=1971; -- Golden Lotus herb, Pandaria old 550 -> 25
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=209355 AND `Data0`=29; -- Fools Cap herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=214510 AND `Data0`=29; -- Sha-Touched Herb herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54037 WHERE `entry`=215412 AND `Data0`=1972; -- Sha-Touched Herb herb, Pandaria old 575 -> 37
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=221538 AND `Data0`=38; -- Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54101 WHERE `entry`=221539 AND `Data0`=38; -- Rich Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=221542 AND `Data0`=29; -- Green Tea Leaf herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=221543 AND `Data0`=29; -- Rain Poppy herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=221544 AND `Data0`=29; -- Silkweed herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=54001 WHERE `entry`=221547 AND `Data0`=29; -- Fools Cap herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55101 WHERE `entry`=228493 AND `Data0`=38; -- True Iron Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55101 WHERE `entry`=228510 AND `Data0`=38; -- Rich True Iron Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55101 WHERE `entry`=228564 AND `Data0`=38; -- Rich Blackrock Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228571 AND `Data0`=29; -- Frostweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228572 AND `Data0`=29; -- Fireweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228573 AND `Data0`=29; -- Gorgrond Flytrap herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228574 AND `Data0`=29; -- Starflower herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228575 AND `Data0`=29; -- Nagrand Arrowbloom herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=228576 AND `Data0`=29; -- Talador Orchid herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=55101 WHERE `entry`=230428 AND `Data0`=2189; -- Smoldering True Iron Deposit ore, Draenor old 600 -> 1
UPDATE `gameobject_template` SET `Data0`=55001 WHERE `entry`=233117 AND `Data0`=29; -- Frostweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=241641 AND `Data0`=29; -- Foxflower herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=241726 AND `Data0`=38; -- Leystone Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=241743 AND `Data0`=38; -- Felslate Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=244774 AND `Data0`=29; -- Aethril herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=244775 AND `Data0`=29; -- Dreamleaf herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=244776 AND `Data0`=29; -- Dreamleaf herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=244777 AND `Data0`=29; -- Fjarnskaggl herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=244778 AND `Data0`=29; -- Starlight Rose herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001 WHERE `entry`=244786 AND `Data0`=29; -- Felwort herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=245324 AND `Data0`=38; -- Rich Leystone Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=245325 AND `Data0`=38; -- Rich Felslate Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=253280 AND `Data0`=38; -- Leystone Seam ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56101, `Data4`=1, `Data5`=26 WHERE `entry`=255344 AND `Data0`=38; -- Felslate Seam ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=269278 AND `Data0`=29; -- Fel-Encrusted Herb herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=56001, `Data4`=1, `Data5`=26 WHERE `entry`=269887 AND `Data0`=29; -- Fel-Encrusted Herb Cluster herb, Legion old 0 -> 1
