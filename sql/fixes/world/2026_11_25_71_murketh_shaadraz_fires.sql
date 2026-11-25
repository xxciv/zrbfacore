-- Mission: The Murketh and Shaadraz Gateways (Alliance 10146) / Mission: Gateways Murketh and Shaadraz (Horde 10129).
-- The bombs (Dropping The Nether Modulator 33655) only gave credit. Gateway Shaadraz's two Hellfire Fire
-- objects burned all the time, and Gateway Murketh's four fire objects never visibly reacted.
-- Now both gateways start without fire and catch fire when bombed: the six fire objects are kept but start
-- hidden and are shown for 3 minutes by the bomb hit, and each transporter also casts Create Hellfire Fire 34386
-- on itself (a 60 second fire at the gateway).

-- Fire objects start hidden (kept, shown by the bomb hit below).
UPDATE `gameobject` SET `spawntimesecs`=-180 WHERE `guid` IN (66690,66691,66692,66693) AND `id`=182090; -- Vector Coil Fire (L), Gateway Murketh
UPDATE `gameobject` SET `spawntimesecs`=-180 WHERE `guid` IN (68035,68036) AND `id`=183816;              -- Hellfire Fire, Gateway Shaadraz

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19291,19292) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19291,0,0,0,8,0,100,0,33655,0,0,0,0,'',33,19291,0,0,0,0,0,7,0,0,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Quest Credit'),
(19291,0,1,0,8,0,100,0,33655,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Cast Create Hellfire Fire'),
(19291,0,2,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,66690,182090,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Show Vector Coil Fire'),
(19291,0,3,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,66691,182090,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Show Vector Coil Fire'),
(19291,0,4,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,66692,182090,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Show Vector Coil Fire'),
(19291,0,5,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,66693,182090,0,0,0,0,0,'Legion Transporter: Alpha - On Spellhit Dropping The Nether Modulator - Show Vector Coil Fire'),
(19292,0,0,0,8,0,100,0,33655,0,0,0,0,'',33,19292,0,0,0,0,0,7,0,0,0,0,0,0,0,'Legion Transporter: Beta - On Spellhit Dropping The Nether Modulator - Quest Credit'),
(19292,0,1,0,8,0,100,0,33655,0,0,0,0,'',11,34386,2,0,0,0,0,1,0,0,0,0,0,0,0,'Legion Transporter: Beta - On Spellhit Dropping The Nether Modulator - Cast Create Hellfire Fire'),
(19292,0,2,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,68035,183816,0,0,0,0,0,'Legion Transporter: Beta - On Spellhit Dropping The Nether Modulator - Show Hellfire Fire'),
(19292,0,3,0,8,0,100,0,33655,0,0,0,0,'',70,180,0,0,0,0,0,14,68036,183816,0,0,0,0,0,'Legion Transporter: Beta - On Spellhit Dropping The Nether Modulator - Show Hellfire Fire');
