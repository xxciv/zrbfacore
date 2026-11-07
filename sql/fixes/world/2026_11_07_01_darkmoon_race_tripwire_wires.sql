-- Darkmoon races: visible tripwires (zrbfacore)
--
-- From Four, 2026-11-07: "you can't tell which way the trap is set because you can't see a wire".
-- The tripwire stakes (75044, 95 spawns) get the new script npc_darkmoon_race_tripwire_stake from
-- tools/bfa/darkmoon-race.patch: each stake wires itself to its nearest stake within 14 yards when
-- that stake picks it too (30 pairs), shows the wire as a lightning beam, and only those pairs zap
-- racers. The template had SmartAI with no script rows.
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_darkmoon_race_tripwire_stake' WHERE `entry`=75044;
