-- zrbfacore: Darkmoon Island strider races (needs tools/bfa/darkmoon-race.patch)
--
-- 1. Bring the race course back. 2026_11_05_03 put it in spawn group 450 with
-- SPAWNGROUP_FLAG_MANUAL_SPAWN so nobody saw it while the race had no script.
DELETE FROM `spawn_group` WHERE `groupId`=450;
DELETE FROM `spawn_group_template` WHERE `groupId`=450;

-- 2. Show the course to racers only, as on retail: every visible course bunny
-- gets Event - AO - Invis to Non-Racers (179303, invisibility type 23). The
-- race script gives racers On a Trial (149669), which sees type 23. GMs see
-- everything anyway. The second aura is the bunny's own powerup visual.
INSERT INTO `creature_template_addon` (`entry`, `path_id`, `mount`, `bytes1`, `bytes2`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(75718, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 152506'), -- Powerup Bunny Checkpoint: Powerup Visual - Checkpoint
(75044, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303'),        -- Tripwire stake
(74153, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 149414'), -- Dash: Powerup Visual - Dash
(74157, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 149415'), -- Jump: Powerup Visual - Jump
(74678, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 150104'), -- Rocket: Powerup Visual - Rocket
(74800, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 150430'), -- Blink: Powerup Visual - Blink
(74872, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 150578'), -- Loot: Powerup Visual - Loot
(75063, 0, 0, 0, 1, 0, 0, 0, 0, 0, '179303 151031')  -- Rotating: Powerup Rotating Effect - BlinkRocketJump
ON DUPLICATE KEY UPDATE `auras`=VALUES(`auras`);
