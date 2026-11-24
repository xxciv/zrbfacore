-- Holiday quests still offered outside their holiday: reported by Four, 2026-11-24 (Troll Commoner in
-- Orgrimmar offering Masked Orphan Matron and The Spinner of Summer Tales during Pilgrim's Bounty).
-- 2026_11_23_31 (Wayfarer) removed the always-on rows of holiday quests that ALSO had an event link. These 28
-- have no event link at all, so they were missed. Their NPCs stand all year (the commoners are spawned for
-- every holiday, the others never despawn), so the quest showed in every season. Holiday quest givers that
-- only spawn during their holiday (Festival Loremaster/Talespinner, flame keepers, Lunar Festival Harbinger,
-- Miles Standish, Brewfest vendors...) were checked and left alone.
-- Each quest is moved, not dropped: the always-on row goes, a game_event_creature_quest row on its holiday
-- (TDB 8.3.7's event where TDB has the quest, else the holiday of its quest sort) takes its place.
--   Blood Elf Commoner 19169: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Orc Commoner 19175: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Tauren Commoner 19176: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Troll Commoner 19177: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Forsaken Commoner 19178: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Goblin Commoner 20102: Masked Orphan Matron 11357 -> Hallow's End (12)
--   Sagorne Creststrider 13417: The Reason for the Season 6964 -> Winter Veil (2)
--   Baine Bloodhoof 36648: The Feast of Winter Veil 7061 -> Winter Veil (2)
--   Historian Karnik 2916: The Reason for the Season 7062 -> Winter Veil (2)
--   Blood Elf Commoner 19169: The Spinner of Summer Tales 11971 -> Midsummer (1)
--   Tauren Commoner 19176: The Spinner of Summer Tales 11971 -> Midsummer (1)
--   Troll Commoner 19177: The Spinner of Summer Tales 11971 -> Midsummer (1)
--   Forsaken Commoner 19178: The Spinner of Summer Tales 11971 -> Midsummer (1)
--   Goblin Commoner 20102: The Spinner of Summer Tales 11971 -> Midsummer (1)
--   Earthen Ring Guide 25324: Inform the Elder 12012 -> Midsummer (1)
--   Earthen Ring Guide 25324: Inform the Elder 29092 -> Midsummer (1)
--   Dwarf Commoner 19148: Pilgrim's Bounty 14022 -> Pilgrim's Bounty (26)
--   Draenei Commoner 19171: Pilgrim's Bounty 14022 -> Pilgrim's Bounty (26)
--   Gnome Commoner 19172: Pilgrim's Bounty 14022 -> Pilgrim's Bounty (26)
--   Night Elf Commoner 19173: Pilgrim's Bounty 14022 -> Pilgrim's Bounty (26)
--   Tauren Commoner 19176: Pilgrim's Bounty 14036 -> Pilgrim's Bounty (26)
--   Troll Commoner 19177: Pilgrim's Bounty 14036 -> Pilgrim's Bounty (26)
--   Forsaken Commoner 19178: Pilgrim's Bounty 14036 -> Pilgrim's Bounty (26)
--   Lady Sylvanas Windrunner 10181: A Gift for the Banshee Queen 24613 -> Love is in the Air (8)
--   Lor'themar Theron 16802: A Gift for the Regent Lord of Quel'Thalas 24615 -> Love is in the Air (8)
--   Hch'uu 22823: Hch'uu and the Mushroom People 10945 -> Children's Week (10)
--   Elementalist Sharvak 18072: Visit the Throne of the Elements 10953 -> Children's Week (10)
--   Caretaker Padae 131346: Children's Week 53965 -> Children's Week (10)
-- Safe to run twice.
DELETE FROM `creature_queststarter` WHERE (`id`,`quest`) IN ((19169,11357),(19175,11357),(19176,11357),(19177,11357),(19178,11357),(20102,11357),(13417,6964),(36648,7061),(2916,7062),(19169,11971),(19176,11971),(19177,11971),(19178,11971),(20102,11971),(25324,12012),(25324,29092),(19148,14022),(19171,14022),(19172,14022),(19173,14022),(19176,14036),(19177,14036),(19178,14036),(10181,24613),(16802,24615),(22823,10945),(18072,10953),(131346,53965));
DELETE FROM `game_event_creature_quest` WHERE (`id`,`quest`) IN ((19169,11357),(19175,11357),(19176,11357),(19177,11357),(19178,11357),(20102,11357),(13417,6964),(36648,7061),(2916,7062),(19169,11971),(19176,11971),(19177,11971),(19178,11971),(20102,11971),(25324,12012),(25324,29092),(19148,14022),(19171,14022),(19172,14022),(19173,14022),(19176,14036),(19177,14036),(19178,14036),(10181,24613),(16802,24615),(22823,10945),(18072,10953),(131346,53965));
INSERT INTO `game_event_creature_quest` (`eventEntry`,`id`,`quest`) VALUES
(12,19169,11357),
(12,19175,11357),
(12,19176,11357),
(12,19177,11357),
(12,19178,11357),
(12,20102,11357),
(2,13417,6964),
(2,36648,7061),
(2,2916,7062),
(1,19169,11971),
(1,19176,11971),
(1,19177,11971),
(1,19178,11971),
(1,20102,11971),
(1,25324,12012),
(1,25324,29092),
(26,19148,14022),
(26,19171,14022),
(26,19172,14022),
(26,19173,14022),
(26,19176,14036),
(26,19177,14036),
(26,19178,14036),
(8,10181,24613),
(8,16802,24615),
(10,22823,10945),
(10,18072,10953),
(10,131346,53965);

-- Same check for objects: two Brewfest quest objects stand all year and offered "This One Time, When I Was
-- Drunk..." (12020 from 189989, 12192 from 189990) in every season, from both gameobject_queststarter and
-- their Brewfest (24) link. TDB 8.3.7 only has the Brewfest link, which stays.
DELETE FROM `gameobject_queststarter` WHERE (`id`,`quest`) IN ((189989,12020),(189990,12192));
