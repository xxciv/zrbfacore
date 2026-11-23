-- World fixes: Redridge Mountains, Lakeshire Inn fight club, a real fight both ways (Four, 2026-11-20)
-- Four (after 2026_11_20_32): "Dumpy vs. Big Earl. Big Earl is just taking it. Never throwing back a punch."
-- Then (after the first version of this file): "now no one is fighting", both showing UNIT_FLAG_IN_COMBAT.
-- Cause: the fighters run core C++ scripts (ScriptName wins over SmartAI, so the dump SmartAI never ran).
--   npc_dumpy_and_keeshan makes Dumpy/Keeshan start a fight with the Big Earl that has the same stage aura, but
--   npc_big_earl never picks a target (its UpdateAI has no UpdateVictim), so Big Earl never swings, and neither script
--   recovers once the attacker loses its target: both stay flagged in combat and stand still.
-- Changed (our own tuning; TDB 8.3.7 uses the same C++ scripts):
--   ScriptName cleared on John J. Keeshan 43184, Big Earl 43248 and Dumpy 43249, so they run SmartAI.
--   Dumpy (735401337) and the stage-two Keeshan (735401290) get their own script: out of combat, every second, attack
--     the Big Earl of their own stage (735401340 / 735401291), and keep the unarmed fighting stance.
--   Big Earl answers with normal SmartAI melee. All three take no damage from other creatures below 85% health
--     (flags_extra 0x400 from staged-npc-battles.patch), so the fight never ends.
--   The last stage stays calm: the knocked-out Big Earl (735401314) is passive and lies down; Keeshan with his crew
--     (735401313) is passive.
--   The rows the first version of this file added to Big Earl (ids 4-7) and Keeshan (id 6) are removed again.
-- The crowd keeps its C++ script (npc_redridge_citizen cheers, roars and points every 10-25 s once it has a stage aura).
-- Run after 2026_11_20_32. Safe to run twice.
UPDATE `creature_template` SET `ScriptName`='',`flags_extra`=`flags_extra`|0x400 WHERE `entry` IN (43184,43248,43249);
DELETE FROM `smart_scripts` WHERE `entryorguid`=43248 AND `source_type`=0 AND `id` BETWEEN 4 AND 7;
DELETE FROM `smart_scripts` WHERE `entryorguid`=43184 AND `source_type`=0 AND `id`=6;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-735401290,-735401313,-735401314,-735401337) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-735401337,0,0,0,11,0,100,0,0,0,0,0,0,'',17,27,0,0,0,0,0,1,0,0,0,0,0,0,0,'Dumpy - On Spawn - Emote State Unarmed Ready'),
(-735401337,0,1,0,1,0,100,0,1000,1000,1000,1000,0,'',49,0,0,0,0,0,0,10,735401340,43248,0,0,0,0,0,'Dumpy - OOC - Attack Big Earl (same stage)'),
(-735401290,0,0,0,11,0,100,0,0,0,0,0,0,'',17,27,0,0,0,0,0,1,0,0,0,0,0,0,0,'John J. Keeshan - On Spawn - Emote State Unarmed Ready'),
(-735401290,0,1,0,1,0,100,0,1000,1000,1000,1000,0,'',49,0,0,0,0,0,0,10,735401291,43248,0,0,0,0,0,'John J. Keeshan - OOC - Attack Big Earl (same stage)'),
(-735401313,0,0,0,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'John J. Keeshan (with his crew) - On Spawn - Set Passive'),
(-735401314,0,0,1,11,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Big Earl (knocked out) - On Spawn - Set Passive'),
(-735401314,0,1,0,61,0,100,0,0,0,0,0,0,'',90,7,0,0,0,0,0,1,0,0,0,0,0,0,0,'Big Earl (knocked out) - On Spawn - Lie down');
