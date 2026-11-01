-- Astranaar: the "Astranaar's Burning!" siege stands around the town permanently (Four, 2026-11-01).
--
-- 193 spawns in Astranaar (area 415) belong to the Cataclysm siege quests but have no phase, so they
-- crowd a calm town for everyone: Hellscream's Hellion 34163 (15), Watch Wind Rider 34160 (15),
-- Astranaar Skirmisher 34419 (23), Astranaar Sentinel 34494 (59), Astranaar Officer 34420 (5),
-- Astranaar Thrower 34132 (12) and 34492 (9), Thrower Bunny 34501 (9), fire bunnies 34123 (34) and
-- Phase Q1 Generic Bunny JSB 34439 (12). The town's own guards (6087, 51770), vendors and the Horde
-- outpost (Hellscream's Watch) are not touched.
--
-- Changed: those spawns move to phase 295 (exists in Phase.db2, normal phase, flags 0, used nowhere
-- else in this DB). Phase 295 is active in Astranaar (phase_area 415) while any of the siege quests
-- is in progress or complete (CONDITION_QUESTSTATE 47, state mask 2|8 = 10):
--   13849 Astranaar's Burning! (Alliance, fires 34123), 13853 Return Fire (Alliance, Throwers),
--   13943 Breathing Room (Horde, Skirmishers/Officers), 13947 Blastranaar! (Horde, Sentinels/Throwers).
-- Revert: UPDATE creature SET PhaseId = 0 WHERE PhaseId = 295; and delete the two rows below.
UPDATE `creature` SET `PhaseId` = 295 WHERE `map` = 1 AND `PhaseId` = 0 AND `PhaseGroup` = 0 AND `guid` IN (
239892, 240252, 240494, 240591, 240617, 240629, 240630, 240658, 240887, 240914, 240915, 240922,
240923, 240983, 241018, 241037, 241038, 241039, 241040, 241099, 241330, 241331, 241332, 241333,
241336, 241337, 241338, 241339, 241340, 241341, 241342, 241343, 241344, 241345, 241346, 241347,
241348, 241349, 241350, 241358, 302513, 302514, 302515, 302516, 302517, 302518, 302519, 302520,
302521, 302522, 302523, 302524, 302525, 302526, 302527, 302528, 302529, 302530, 302531, 302532,
302533, 302534, 302535, 302536, 302537, 302538, 302539, 302540, 302541, 302542, 302543, 302544,
302545, 302546, 302547, 302548, 302549, 302550, 302551, 302552, 302553, 302554, 302555, 302556,
302557, 302558, 302559, 302560, 302561, 302562, 302563, 302564, 302565, 302566, 302567, 302568,
302569, 302570, 302571, 302572, 302573, 302574, 302575, 302576, 311037, 311038, 311039, 311040,
311041, 311042, 311044, 311045, 311046, 311047, 311048, 311051, 311052, 311053, 311054, 311062,
311069, 311070, 311071, 311103, 311107, 311108, 311109, 311110, 311111, 311112, 311113, 311114,
311115, 311131, 311132, 311133, 311134, 311135, 311136, 311137, 311138, 311139, 311140, 311141,
311146, 311147, 311148, 311149, 311150, 311151, 311152, 311153, 311154, 311155, 311156, 311157,
311158, 311159, 311160, 311161, 311162, 311163, 311164, 311165, 311166, 311167, 311168, 311169,
311170, 311171, 311172, 311173, 311174, 311175, 311176, 311177, 311203, 311204, 311205, 311206,
311207, 311208, 311209, 311210, 311211, 311212, 311213, 311214, 311215, 311216, 311217, 311218,
311219);

DELETE FROM `phase_area` WHERE `AreaId` = 415 AND `PhaseId` = 295;
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(415, 295, 'Astranaar - siege of Astranaar while a siege quest is active');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` = 295 AND `SourceEntry` = 415;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, 295, 415, 0, 0, 47, 0, 13849, 10, 0, 0, 0, 0, '', 'Astranaar siege phase 295 while Astranaar''s Burning! (13849) in progress or complete'),
(26, 295, 415, 0, 1, 47, 0, 13853, 10, 0, 0, 0, 0, '', 'Astranaar siege phase 295 while Return Fire (13853) in progress or complete'),
(26, 295, 415, 0, 2, 47, 0, 13943, 10, 0, 0, 0, 0, '', 'Astranaar siege phase 295 while Breathing Room (13943) in progress or complete'),
(26, 295, 415, 0, 3, 47, 0, 13947, 10, 0, 0, 0, 0, '', 'Astranaar siege phase 295 while Blastranaar! (13947) in progress or complete');
