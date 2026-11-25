-- Gryphoneer Windbellow 20235 (Shatter Point, menu 8096): "Send me to the Abyssal Shelf!" did nothing for
-- Mission: The Abyssal Shelf (10163) / Return to the Abyssal Shelf (10346).
-- Option 0 is the real one (conditions on 10163/10346, SAI casts Aerial Assault Flight (Alliance) 33899) but was
-- hidden (OptionType 0, OptionNpcFlag 0) with the Honor Point text. The visible Abyssal Shelf line was option 2,
-- a copy with no script. TDB 8.3.7 shows option 0 and hides option 2. Option 1 (Honor Point, taxi 35065) unchanged.
UPDATE `gossip_menu_option` SET `OptionText`='Send me to the Abyssal Shelf!', `OptionBroadcastTextId`=16615, `OptionType`=1, `OptionNpcFlag`=1
  WHERE `MenuId`=8096 AND `OptionIndex`=0;
UPDATE `gossip_menu_option` SET `OptionType`=0, `OptionNpcFlag`=0 WHERE `MenuId`=8096 AND `OptionIndex`=2;
