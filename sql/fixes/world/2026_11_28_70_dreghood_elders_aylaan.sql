-- The Dreghood Elders (10368, Hellfire Peninsula): free Morod 20677, Akoru 20678 and Aylaan 20679 by gossip.
-- Aylaan used gossip menu 20679, which is an innkeeper's menu ("Do you know where I can find Levia Laurence?",
-- inn and vendor lines), so the "free to go" line never showed and his credit row (gossip select on menu 20679,
-- option 0) never matched. Give him TDB 8.3.7's menu 8161 ("Walk free, elder...", shown only on 10368) and point his
-- credit row at it. His close-gossip row already listens on 8161.
UPDATE `creature_template` SET `gossip_menu_id`=8161 WHERE `entry`=20679;
UPDATE `smart_scripts` SET `event_param1`=8161, `comment`='Aylaan the Waterwaker - On Gossip 8161 Option 0 - Quest Credit'
  WHERE `entryorguid`=20679 AND `source_type`=0 AND `id`=0 AND `event_type`=62 AND `event_param1`=20679;
