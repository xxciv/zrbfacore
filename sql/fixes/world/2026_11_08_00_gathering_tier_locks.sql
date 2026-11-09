-- Herb and ore nodes use each expansion's own skill (Four, 2026-11-08). Run against bfa_world. Needs
-- tools/bfa/gathering-tier-locks.patch in the core.
--
-- Points each Outland-to-Legion herb and ore node at Blizzard's own lock for its expansion (from where it
-- spawns), which the client already has: herbs 2856 Outland, 2857 Northrend, 2858 Cataclysm, 2859
-- Pandaria, 2860 Draenor, 2861 Legion; ore 2864 to 2869 in the same order. Each has the expansion's
-- herb or ore lock type (33-38, 41-46) and a plain Herbalism/Mining slot, both with no skill: the node
-- needs only the expansion's gather spell, which comes with the expansion skill (the core patch keeps
-- the plain slot from opening it). Kul Tiran nodes (2862, 2870), Cinderbloom, Rich Elementium and
-- Blackrock already use them.
--
-- The node's difficulty (the number after the arrow) scales its old 1-600 skill over its expansion's
-- old range (Outland and Northrend 300-375 and 350-450, Cataclysm 425-525, Pandaria 500-600) to 1 up to
-- the expansion skill's max minus 25. Gathering nodes (type 50) that carried old-scale trivial skill
-- (Data4/Data5: colour and skill-up chance) get the difficulty and difficulty + 25 instead, like Kul
-- Tiran nodes. Only nodes whose lock has no other way to open it change (quest objects you can open by
-- kneeling keep theirs).
--
-- The first version pointed the nodes at new hotfix locks (IDs 5xxxx); the second value in each
-- Data0 IN (...) is that lock, so this also moves nodes already changed by it.
-- Each UPDATE only applies while the node has its old lock, so it is safe to run more than once.
-- Restart worldserver and delete the client Cache folder.
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181270 AND `Data0` IN (29, 51001); -- Felweed herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181271 AND `Data0` IN (29, 51001); -- Dreaming Glory herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=17, `Data5`=42 WHERE `entry`=181275 AND `Data0` IN (1641, 51017); -- Ragveil herb, Outland old 325 -> 17
UPDATE `gameobject_template` SET `Data0`=2856 WHERE `entry`=181276 AND `Data0` IN (1642, 51023); -- Flame Cap herb, Outland old 335 -> 23
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181277 AND `Data0` IN (29, 51001); -- Terocone herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=27, `Data5`=52 WHERE `entry`=181278 AND `Data0` IN (1643, 51027); -- Ancient Lichen herb, Outland old 340 -> 27
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181279 AND `Data0` IN (29, 51001); -- Netherbloom herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181280 AND `Data0` IN (29, 51001); -- Nightmare Vine herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=181281 AND `Data0` IN (29, 51001); -- Mana Thistle herb, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2864, `Data4`=1, `Data5`=26 WHERE `entry`=181555 AND `Data0` IN (38, 51101); -- Fel Iron Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2864, `Data4`=1, `Data5`=26 WHERE `entry`=181556 AND `Data0` IN (38, 51101); -- Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2864, `Data4`=1, `Data5`=26 WHERE `entry`=181557 AND `Data0` IN (38, 51101); -- Khorium Vein ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2864, `Data4`=1, `Data5`=26 WHERE `entry`=181569 AND `Data0` IN (38, 51101); -- Rich Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2864, `Data4`=1, `Data5`=26 WHERE `entry`=181570 AND `Data0` IN (38, 51101); -- Rich Adamantite Deposit ore, Outland old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=17, `Data5`=42 WHERE `entry`=183043 AND `Data0` IN (1641, 51017); -- Ragveil herb, Outland old 325 -> 17
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=183044 AND `Data0` IN (1124, 51001); -- Felweed herb, Outland old 300 -> 1
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=10, `Data5`=35 WHERE `entry`=183045 AND `Data0` IN (1639, 51010); -- Dreaming Glory herb, Outland old 315 -> 10
UPDATE `gameobject_template` SET `Data0`=2856, `Data4`=1, `Data5`=26 WHERE `entry`=183046 AND `Data0` IN (442, 51001); -- Blindweed herb, Outland old 235 -> 1
UPDATE `gameobject_template` SET `Data0`=2864 WHERE `entry`=185557 AND `Data0` IN (1651, 51150); -- Ancient Gem Vein ore, Outland old 375 -> 50
UPDATE `gameobject_template` SET `Data0`=2864 WHERE `entry`=185877 AND `Data0` IN (1649, 51101); -- Nethercite Deposit ore, Outland old 275 -> 1
UPDATE `gameobject_template` SET `Data0`=2856 WHERE `entry`=185881 AND `Data0` IN (1644, 51033); -- Netherdust Bush herb, Outland old 350 -> 33
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=189973 AND `Data0` IN (1644, 52001); -- Goldclover herb, Northrend old 350 -> 1
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=189978 AND `Data0` IN (1800, 52101); -- Cobalt Deposit ore, Northrend old 350 -> 1
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=189979 AND `Data0` IN (1782, 52113); -- Rich Cobalt Deposit ore, Northrend old 375 -> 13
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=189980 AND `Data0` IN (1783, 52125); -- Saronite Deposit ore, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=189981 AND `Data0` IN (1784, 52137); -- Rich Saronite Deposit ore, Northrend old 425 -> 37
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190169 AND `Data0` IN (1646, 52013); -- Tiger Lily herb, Northrend old 375 -> 13
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190170 AND `Data0` IN (1787, 52018); -- Talandras Rose herb, Northrend old 385 -> 18
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190171 AND `Data0` IN (1789, 52037); -- Lichbloom herb, Northrend old 425 -> 37
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190172 AND `Data0` IN (1790, 52042); -- Icethorn herb, Northrend old 435 -> 42
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190173 AND `Data0` IN (1788, 52025); -- Frozen Herb herb, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190174 AND `Data0` IN (1124, 52001); -- Frozen Herb herb, Northrend old 300 -> 1
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190175 AND `Data0` IN (1793, 52032); -- Frozen Herb herb, Northrend old 415 -> 32
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=190176 AND `Data0` IN (1792, 52050); -- Frost Lotus herb, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=191019 AND `Data0` IN (1788, 52025); -- Adders Tongue herb, Northrend old 400 -> 25
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=191133 AND `Data0` IN (1785, 52150); -- Titanium Vein ore, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=2857 WHERE `entry`=191303 AND `Data0` IN (1786, 52005); -- Firethorn herb, Northrend old 360 -> 5
UPDATE `gameobject_template` SET `Data0`=2865 WHERE `entry`=195036 AND `Data0` IN (1785, 52150); -- Pure Saronite Deposit ore, Northrend old 450 -> 50
UPDATE `gameobject_template` SET `Data0`=2866 WHERE `entry`=202736 AND `Data0` IN (1861, 53101); -- Obsidium Deposit ore, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=2866 WHERE `entry`=202737 AND `Data0` IN (1862, 53150); -- Pyrite Deposit ore, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=2866 WHERE `entry`=202738 AND `Data0` IN (1863, 53125); -- Elementium Vein ore, Cataclysm old 475 -> 25
UPDATE `gameobject_template` SET `Data0`=2866 WHERE `entry`=202739 AND `Data0` IN (1864, 53113); -- Rich Obsidium Deposit ore, Cataclysm old 450 -> 13
UPDATE `gameobject_template` SET `Data0`=2866 WHERE `entry`=202740 AND `Data0` IN (1862, 53150); -- Rich Pyrite Deposit ore, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=2858 WHERE `entry`=202748 AND `Data0` IN (1789, 53001); -- Stormvine herb, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=2858 WHERE `entry`=202749 AND `Data0` IN (1789, 53001); -- Azsharas Veil herb, Cataclysm old 425 -> 1
UPDATE `gameobject_template` SET `Data0`=2858 WHERE `entry`=202750 AND `Data0` IN (1866, 53025); -- Heartblossom herb, Cataclysm old 475 -> 25
UPDATE `gameobject_template` SET `Data0`=2858 WHERE `entry`=202751 AND `Data0` IN (1868, 53050); -- Twilight Jasmine herb, Cataclysm old 525 -> 50
UPDATE `gameobject_template` SET `Data0`=2858 WHERE `entry`=202752 AND `Data0` IN (1867, 53037); -- Whiptail herb, Cataclysm old 500 -> 37
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=209311 AND `Data0` IN (38, 54101); -- Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=209312 AND `Data0` IN (38, 54101); -- Kyparite Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=209313 AND `Data0` IN (38, 54101); -- Trillium Vein ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=209328 AND `Data0` IN (38, 54101); -- Rich Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=209329 AND `Data0` IN (38, 54101); -- Rich Kyparite Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209349 AND `Data0` IN (29, 54001); -- Green Tea Leaf herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209350 AND `Data0` IN (29, 54001); -- Silkweed herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209351 AND `Data0` IN (1972, 54037); -- Snow Lily herb, Pandaria old 575 -> 37
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209353 AND `Data0` IN (29, 54001); -- Rain Poppy herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209354 AND `Data0` IN (1971, 54025); -- Golden Lotus herb, Pandaria old 550 -> 25
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=209355 AND `Data0` IN (29, 54001); -- Fools Cap herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=214510 AND `Data0` IN (29, 54001); -- Sha-Touched Herb herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=215412 AND `Data0` IN (1972, 54037); -- Sha-Touched Herb herb, Pandaria old 575 -> 37
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=221538 AND `Data0` IN (38, 54101); -- Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2867 WHERE `entry`=221539 AND `Data0` IN (38, 54101); -- Rich Ghost Iron Deposit ore, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=221542 AND `Data0` IN (29, 54001); -- Green Tea Leaf herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=221543 AND `Data0` IN (29, 54001); -- Rain Poppy herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=221544 AND `Data0` IN (29, 54001); -- Silkweed herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2859 WHERE `entry`=221547 AND `Data0` IN (29, 54001); -- Fools Cap herb, Pandaria old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2868 WHERE `entry`=228493 AND `Data0` IN (38, 55101); -- True Iron Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2868 WHERE `entry`=228510 AND `Data0` IN (38, 55101); -- Rich True Iron Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2868 WHERE `entry`=228564 AND `Data0` IN (38, 55101); -- Rich Blackrock Deposit ore, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228571 AND `Data0` IN (29, 55001); -- Frostweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228572 AND `Data0` IN (29, 55001); -- Fireweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228573 AND `Data0` IN (29, 55001); -- Gorgrond Flytrap herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228574 AND `Data0` IN (29, 55001); -- Starflower herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228575 AND `Data0` IN (29, 55001); -- Nagrand Arrowbloom herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=228576 AND `Data0` IN (29, 55001); -- Talador Orchid herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2868 WHERE `entry`=230428 AND `Data0` IN (2189, 55101); -- Smoldering True Iron Deposit ore, Draenor old 600 -> 1
UPDATE `gameobject_template` SET `Data0`=2860 WHERE `entry`=233117 AND `Data0` IN (29, 55001); -- Frostweed herb, Draenor old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=241641 AND `Data0` IN (29, 56001); -- Foxflower herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=241726 AND `Data0` IN (38, 56101); -- Leystone Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=241743 AND `Data0` IN (38, 56101); -- Felslate Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=244774 AND `Data0` IN (29, 56001); -- Aethril herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=244775 AND `Data0` IN (29, 56001); -- Dreamleaf herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=244776 AND `Data0` IN (29, 56001); -- Dreamleaf herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=244777 AND `Data0` IN (29, 56001); -- Fjarnskaggl herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=244778 AND `Data0` IN (29, 56001); -- Starlight Rose herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861 WHERE `entry`=244786 AND `Data0` IN (29, 56001); -- Felwort herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=245324 AND `Data0` IN (38, 56101); -- Rich Leystone Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=245325 AND `Data0` IN (38, 56101); -- Rich Felslate Deposit ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=253280 AND `Data0` IN (38, 56101); -- Leystone Seam ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2869, `Data4`=1, `Data5`=26 WHERE `entry`=255344 AND `Data0` IN (38, 56101); -- Felslate Seam ore, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=269278 AND `Data0` IN (29, 56001); -- Fel-Encrusted Herb herb, Legion old 0 -> 1
UPDATE `gameobject_template` SET `Data0`=2861, `Data4`=1, `Data5`=26 WHERE `entry`=269887 AND `Data0` IN (29, 56001); -- Fel-Encrusted Herb Cluster herb, Legion old 0 -> 1
