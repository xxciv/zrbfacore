-- World fixes: Ruins of Gilneas, Forsaken Forward Command before and after What Tomorrow Brings (2026-11-18)
-- Four: the ruins showed the Forward Command battle and its later "overrun" version at once.
-- Our dump has two full copies of Forsaken Forward Command standing on the exact same spots (0.0 yards apart):
--   the battle: Forsaken Vanguard 45280, Worgen Rusher 45375, Worgen Rebel 45292, Forsaken Catapult 45282,
--     Forsaken Blightspreader 45374, Forsaken Sharpshooter 45376, Deathstalkers 45313, Forward Commander
--     Onslaught 45315, Provisioner Angelus 45484, Bat Handler Doomair 45479, Korok the Colossus 45301.
--     TDB 8.3.7 has exactly this set, all in phase 274.
--   the overrun camp: Forsaken Vanguard 45532 (14 lying dead), Worgen Rusher 45535, Forsaken Catapult 45533,
--     Forsaken Blightspreader 51192, 7th Legion Submariners 45539 marching in rows, Forward Commander
--     Onslaught 45534 (no quests), Korok the Colossus 46657. TDB 8.3.7 has none of it.
-- The quest text matches the second set: What Tomorrow Brings (27401, turned in to Onslaught) ends with the
-- Alliance fleet landing, and Fall Back! (27405) starts on its own: "the worgen have overrun Forsaken Forward
-- Command"; Onslaught dies fighting and Belmont and Arthura wait at Emberstone Village.
-- So (phase 274 is 8.3.7's; the split and the switch quest are our own reading of the quest text):
--   phase 274: the battle, seen in the Ruins of Gilneas until What Tomorrow Brings is turned in
--   phase 312: the overrun camp, seen after What Tomorrow Brings is turned in
-- Not phased (no data either way): the coast Submariners 45403 (Vengeance for Our Soldiers), Captain Rutsak,
-- the worgen and Forsaken fighting at Tempest's Reach (Resistance is Futile), Abominations 45345, the telescope
-- scene (Halford Wyrmbane), Belmont and Arthura on the shore (The Great Escape). Critters are not touched.
-- Phases 274 and 312 exist in Phase.db2 and are used nowhere else here.
-- Safe to run twice.

-- 1. The battle set, phase 274 (all of it in the ruins, except the 35 Vanguards at Tempest's Reach)
UPDATE `creature` SET `PhaseId`=274 WHERE `map`=0 AND `zoneId`=4706 AND `areaId`<>4706
  AND `id` IN (45280,45375,45292,45282,45374,45376,45313,45315,45479,45484,45301,46598);
-- Belmont and Arthura at the Forward Command (they hand out In Time, All Will Be Revealed)
UPDATE `creature` SET `PhaseId`=274 WHERE `guid` IN (306592,306596);

-- 2. The overrun set, phase 312
UPDATE `creature` SET `PhaseId`=312 WHERE `map`=0 AND `zoneId`=4706
  AND `id` IN (45532,45535,45533,51192,45539,45534,46657);
-- Belmont and Arthura at Emberstone Village (Fall Back! is turned in there), and the Belmont 45474
-- standing at the Forward Command (A Man Named Godfrey, Resistance is Futile, The Great Escape), who
-- stood next to the other Belmont before
UPDATE `creature` SET `PhaseId`=312 WHERE `guid` IN (306639,306640,373716);

-- 3. Commander Lorna Crowley 46027 and Lord Walden 46029 at the Silverpine edge are copies Sylvanas summons
--    for her scene at the Forsaken Front (action list 4612402); the static copies never belonged here
DELETE FROM `creature_addon` WHERE `guid` IN (373753,373754);
DELETE FROM `creature` WHERE `guid` IN (373753,373754);

-- 4. The fight starters from 2026_11_17_46 paired the two sets; each set now fights itself
UPDATE `smart_scripts` SET `target_param1`=45280,`comment`='Worgen Rusher - OOC - Attack closest Forsaken Vanguard within 8 yards'
  WHERE `entryorguid`=45375 AND `source_type`=0 AND `id`=10;
UPDATE `smart_scripts` SET `target_param1`=45282,`comment`='Worgen Rusher - OOC - Attack closest Forsaken Catapult within 8 yards'
  WHERE `entryorguid`=45375 AND `source_type`=0 AND `id`=11;
UPDATE `smart_scripts` SET `target_param1`=45532,`comment`='Worgen Rusher - OOC - Attack closest Forsaken Vanguard within 8 yards'
  WHERE `entryorguid`=45535 AND `source_type`=0 AND `id`=10;

-- 5. Phases for all of the Ruins of Gilneas (zone 4706)
DELETE FROM `phase_area` WHERE `AreaId`=4706 AND `PhaseId` IN (274,312);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(4706,274,'Ruins of Gilneas - Forsaken Forward Command battle (until What Tomorrow Brings is rewarded)'),
(4706,312,'Ruins of Gilneas - Forsaken Forward Command overrun (after What Tomorrow Brings is rewarded)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup` IN (274,312) AND `SourceEntry`=4706;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,274,4706,0,0,8,0,27401,0,0,1,0,0,'','Ruins of Gilneas - phase 274 while What Tomorrow Brings is not rewarded'),
(26,312,4706,0,0,8,0,27401,0,0,0,0,0,'','Ruins of Gilneas - phase 312 once What Tomorrow Brings is rewarded');
