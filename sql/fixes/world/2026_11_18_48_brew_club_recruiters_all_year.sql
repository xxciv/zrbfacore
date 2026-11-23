-- World fixes: the Brew of the Month Club can be joined all year (2026-11-18)
-- Four (Ironforge Brew Vendor: "our brews are exclusive to members"): "how do you join the club?"
-- You join with the quest Brew of the Month Club (12420 Alliance / 12421 Horde), turned in to Larkin
-- Thunderbrew 27478 in Ironforge or Ray'ma 27489 in Orgrimmar, who also sell the membership form.
-- In 8.3.7 both stand there all year (TDB 127336 / 310875, no game event). Ours were only up during
-- Brewfest (event 24), so the club couldn't be joined the rest of the year.
-- 1. Larkin 180703 and Ray'ma 194753 (the 8.3.7 spots) no longer wait for Brewfest.
-- 2. Their second Brewfest-only copies are removed (not in 8.3.7): Larkin 92779 stood 4.6 yards from
--    180703, Ray'ma 92780 stood in Durotar outside the Orgrimmar gate, away from her shop.
-- Safe to run twice.
DELETE FROM `game_event_creature` WHERE `guid` IN (180703,194753,92779,92780);
DELETE FROM `creature_addon` WHERE `guid` IN (92779,92780);
DELETE FROM `creature` WHERE `guid` IN (92779,92780);
