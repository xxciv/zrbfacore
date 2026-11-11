-- Carl Goodup's Balloon Cart one foot further from him (Four, 2026-11-06). Run against bfa_hotfixes.
--
-- Carl (55305, vehicle 1769) carries the cart in seat VehicleSeat 10236, which puts it 0.7 yards
-- in front of him; his name sat in the balloons and he had no room to push. This hotfix gives
-- the client (and the server) a seat 10236 that is 1.0 yard in front of him (about a foot more).
-- Every other field is the client's own value. Only this seat changes; no other creature uses
-- vehicle 1769.
--
-- hotfix_data: table hash 0xD4A85CEB (3567803627) is VehicleSeat.db2. Hotfix id 9110236 is new
-- (zrbfacore: 9100000 + seat id), so clients that already cached hotfixes still ask for it.
-- Restart worldserver and delete the client Cache folder. Safe to run more than once.
DELETE FROM `vehicle_seat` WHERE `ID`=10236;
INSERT INTO `vehicle_seat` (`ID`, `AttachmentOffsetX`, `AttachmentOffsetY`, `AttachmentOffsetZ`, `CameraOffsetX`, `CameraOffsetY`, `CameraOffsetZ`, `Flags`, `FlagsB`, `FlagsC`, `AttachmentID`, `EnterPreDelay`, `EnterSpeed`, `EnterGravity`, `EnterMinDuration`, `EnterMaxDuration`, `EnterMinArcHeight`, `EnterMaxArcHeight`, `EnterAnimStart`, `EnterAnimLoop`, `RideAnimStart`, `RideAnimLoop`, `RideUpperAnimStart`, `RideUpperAnimLoop`, `ExitPreDelay`, `ExitSpeed`, `ExitGravity`, `ExitMinDuration`, `ExitMaxDuration`, `ExitMinArcHeight`, `ExitMaxArcHeight`, `ExitAnimStart`, `ExitAnimLoop`, `ExitAnimEnd`, `VehicleEnterAnim`, `VehicleEnterAnimBone`, `VehicleExitAnim`, `VehicleExitAnimBone`, `VehicleRideAnimLoop`, `VehicleRideAnimLoopBone`, `PassengerAttachmentID`, `PassengerYaw`, `PassengerPitch`, `PassengerRoll`, `VehicleEnterAnimDelay`, `VehicleExitAnimDelay`, `VehicleAbilityDisplay`, `EnterUISoundID`, `ExitUISoundID`, `UiSkinFileDataID`, `CameraEnteringDelay`, `CameraEnteringDuration`, `CameraExitingDelay`, `CameraExitingDuration`, `CameraPosChaseRate`, `CameraFacingChaseRate`, `CameraEnteringZoom`, `CameraSeatZoomMin`, `CameraSeatZoomMax`, `EnterAnimKitID`, `RideAnimKitID`, `ExitAnimKitID`, `VehicleEnterAnimKitID`, `VehicleRideAnimKitID`, `VehicleExitAnimKitID`, `CameraModeID`, `VerifiedBuild`) VALUES
(10236, 1, 0, 0, 0, 0, 0, 34635791, 33619968, 0, 13, 0, 7, 19.29, 0, 0, 1, 4, 37, 38, -1, 102, 128, 123, 0, 7, 19.29, 0, 0, 1, 4, 37, 38, 39, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 1, 0, 0, 534043, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35662);
DELETE FROM `hotfix_data` WHERE `TableHash`=3567803627 AND `RecordId`=10236;
INSERT INTO `hotfix_data` (`Id`, `TableHash`, `RecordId`, `Deleted`, `VerifiedBuild`) VALUES (9110236, 3567803627, 10236, 0, 35662);
