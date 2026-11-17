-- Westfall, Sentinel Hill: guards outnumbered and a stray Defias
-- 1. The 19 Riverpaw gnolls (54371-54373) that 2026_11_17_37 added at TDB spots. TDB pairs them with guards we do not spawn, so the guards were outnumbered and died at once.
DELETE FROM `creature` WHERE `id` IN (54371,54372,54373) AND `guid` BETWEEN 735400744 AND 735400896;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 735400750 AND 735400768;
-- 2. Six Defias (Knuckleduster 449, Henchman 594, Pillager 589) left over from the Defias attack on Sentinel Hill. TDB keeps the whole attack in quest phase 226;
--    we have no such phase, so these six stood alone all the time.
DELETE FROM `creature` WHERE `guid` IN (308180,308184,308237,308239,308242,308243);
DELETE FROM `creature_addon` WHERE `guid` IN (308180,308184,308237,308239,308242,308243);
