-- Kezan party fixes (Quest Fixes thread, 2026-11-17)

-- Hot Rod: Ace, Gobber and Izzy kept being resummoned into the car for the rest of Kezan
-- (core script npc_hot_rod_rolling_my_homies casts the Resummon spells whenever Rolling with
-- my Homies is rewarded). From Life of the Party on they belong at the pool (35211-35213).
-- Block the three Resummon spells once Life of the Party (14113 male / 14153 female) has been
-- taken: both quests must still be in state "not taken" (mask 1).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry` IN (66644,66645,66646);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,66644,0,0,47,0,14113,1,0,0,0,0,'','Resummon Ace - only before Life of the Party (male) is taken'),
(17,0,66644,0,0,47,0,14153,1,0,0,0,0,'','Resummon Ace - only before Life of the Party (female) is taken'),
(17,0,66645,0,0,47,0,14113,1,0,0,0,0,'','Resummon Gobber - only before Life of the Party (male) is taken'),
(17,0,66645,0,0,47,0,14153,1,0,0,0,0,'','Resummon Gobber - only before Life of the Party (female) is taken'),
(17,0,66646,0,0,47,0,14113,1,0,0,0,0,'','Resummon Izzy - only before Life of the Party (male) is taken'),
(17,0,66646,0,0,47,0,14153,1,0,0,0,0,'','Resummon Izzy - only before Life of the Party (female) is taken');

-- Pirate Party Crashers (14115): the party staff and guests in the pirate phase 380 (faction 1770)
-- are hostile to the pirates 35200 (faction 2102) and killed them before the player could.
-- Make them immune to NPCs (0x200), like the pool-side Ace, Gobber and Izzy already are.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|0x200 WHERE `entry` IN (35202,48805,48806);
