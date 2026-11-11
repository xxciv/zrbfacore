-- Scholomance (map 1007): gates, bottles and the potion had French names in this database ("Porte de
-- fer", cut off at the first accented letter). English names from the Pandaria 5.4.8 world DB.
-- The client caches object names: delete the client's Cache folder to see the change. Safe to run again.
UPDATE `gameobject_template` SET `name`='Iron Gate' WHERE `entry` IN (211256, 211257, 211259, 211260, 211261, 211262);
UPDATE `gameobject_template` SET `name`='Vault of Souls' WHERE `entry`=210781;
UPDATE `gameobject_template` SET `name`='Reinforced Wooden Door' WHERE `entry`=210771;
UPDATE `gameobject_template` SET `name`='Grandmaster Architect Holmberg' WHERE `entry`=214178;
UPDATE `gameobject_template` SET `name`='Alchemy Bottle White' WHERE `entry`=211647;
UPDATE `gameobject_template` SET `name`='Alchemy Bottle Green' WHERE `entry`=211648;
UPDATE `gameobject_template` SET `name`='Alchemy Bottle Blue' WHERE `entry`=211649;
UPDATE `gameobject_template` SET `name`='Polyformic Acid Potion' WHERE `entry`=211669;
UPDATE `gameobject_template` SET `name`='Polyformic Acid Potion Highlight' WHERE `entry`=211670;
