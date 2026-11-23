-- Blackrock Depths (map 230): L70ETC concert controllers, 2026-11-23.
--
-- 2026_11_22_02 moved the Grim Guzzler concert (band, FX controller 321727, drums 321726) to Brewfest
-- (event 24), but six invisible controllers next to the stage stayed spawned all year:
--   321721 [DND] L70ETC Concert Controller (23850)        321725 Mai'Kyl Controller (23852)
--   321722 Bergrisst Controller (23845)                    321724 Samuro Controller (23853)
--   321723 Sig Controller (23854)                          321728 Chief Thunder-Skins Controller (23855)
-- They only exist for the show, so they move to Brewfest with it. Test for the steady purple haze
-- that is left over the dungeon floors (thread "Remove purple fog in Blackrock Depths").
-- Undo: DELETE FROM `game_event_creature` WHERE `eventEntry` = 24 AND `guid` IN (321721, 321722, 321723, 321724, 321725, 321728);

DELETE FROM `game_event_creature` WHERE `guid` IN (321721, 321722, 321723, 321724, 321725, 321728);
INSERT INTO `game_event_creature` (`eventEntry`, `guid`)
SELECT 24, `guid` FROM `creature`
WHERE `map` = 230 AND `guid` IN (321721, 321722, 321723, 321724, 321725, 321728)
  AND `id` IN (23845, 23850, 23852, 23853, 23854, 23855);

-- Check: expect 6
SELECT CONCAT('Concert controllers on Brewfest: ', COUNT(*)) AS `check`
FROM `game_event_creature` WHERE `eventEntry` = 24 AND `guid` IN (321721, 321722, 321723, 321724, 321725, 321728);
