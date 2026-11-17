-- The Wandering Isle: Jaomin Ro 54611 vanishes and resets after Hawk Diving to Earth (Four, 2026-11-16)
-- His special cast 108955, which summons a hawk vehicle (57750) and seats Jaomin in it. As a passenger he turned
-- invisible and lost his target, so he evaded and the fight reset.
-- Cast the dive itself instead: 108935 "Hawk Diving to Earth" (instant, 75% weapon damage plus a short stun around him),
-- the same spell the hawk would have triggered. No vehicle, so he stays in the fight.
UPDATE `smart_scripts` SET `action_param1`=108935,`comment`='Jaomin Ro - Cast Hawk Diving to Earth (dive, no hawk vehicle)'
WHERE `entryorguid`=5461102 AND `source_type`=9 AND `id`=0 AND `action_type`=11;
