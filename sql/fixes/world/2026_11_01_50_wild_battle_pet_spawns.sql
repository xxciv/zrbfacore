-- Wild battle pets: turn critter spawns into their battle pet version, per battlepet_wild_zone_pool.
--
-- battlepet_wild_zone_pool says, per zone, which critter (CreatureEntry) becomes which battle pet
-- (BattlePetEntry) and how many pets the zone should have (Max). The core's code that does this
-- swap at runtime (Map::PopulateBattlePet) is never called, so only battle pets spawned directly in
-- `creature` ever existed. Northern Stranglethorn had battle Beetles and Strand Crabs but no
-- Tree Python, Forest Spiderling or Lizard Hatchling pets, only their critters.
--
-- This does the swap once in the DB: for each pool row it counts the battle pets already spawned in
-- the zone (creature.zoneId or areaId = Zone) and converts random critter spawns of CreatureEntry in
-- that zone until Max is reached or the critters run out. Only rows whose BattlePetEntry template is
-- a wild pet (type 14) are used, and critters with a per-spawn SmartAI script are skipped
-- (that script would replace the pet's own). On the 2026-10 dump that is about 4,700 spawns in 81 zones.
--
-- Every converted spawn is recorded in zr_wild_battlepet_conversion. Running the file again converts
-- nothing new (the pets it made count towards Max). To undo:
--   UPDATE creature c JOIN zr_wild_battlepet_conversion b ON b.guid = c.guid
--      SET c.id = b.old_id, c.modelid = b.old_modelid;
--   DROP TABLE zr_wild_battlepet_conversion;

CREATE TABLE IF NOT EXISTS `zr_wild_battlepet_conversion` (
  `guid` bigint unsigned NOT NULL,
  `old_id` int unsigned NOT NULL,
  `new_id` int unsigned NOT NULL,
  `old_modelid` int unsigned NOT NULL DEFAULT '0',
  `zone` int unsigned NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP PROCEDURE IF EXISTS `zr_convert_wild_battlepets`;

DELIMITER //
CREATE PROCEDURE `zr_convert_wild_battlepets`()
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_zone, v_pet, v_max, v_critter, v_have, v_need INT UNSIGNED;
  DECLARE cur CURSOR FOR
    SELECT p.`Zone`, p.`BattlePetEntry`, p.`Max`, p.`CreatureEntry`
      FROM battlepet_wild_zone_pool p
      JOIN creature_template t ON t.entry = p.`BattlePetEntry` AND t.type = 14
     WHERE p.`CreatureEntry` <> 0 AND p.`CreatureEntry` <> p.`BattlePetEntry`
     ORDER BY p.`Zone`, p.`BattlePetEntry`;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  pool_loop: LOOP
    FETCH cur INTO v_zone, v_pet, v_max, v_critter;
    IF done THEN
      LEAVE pool_loop;
    END IF;

    SELECT COUNT(*) INTO v_have FROM creature
     WHERE id = v_pet AND (zoneId = v_zone OR areaId = v_zone);

    IF v_have < v_max THEN
      SET v_need = v_max - v_have;

      INSERT IGNORE INTO zr_wild_battlepet_conversion (guid, old_id, new_id, old_modelid, zone)
        SELECT guid, id, v_pet, modelid, v_zone FROM creature
         WHERE id = v_critter AND (zoneId = v_zone OR areaId = v_zone)
           AND NOT EXISTS (SELECT 1 FROM smart_scripts s WHERE s.source_type = 0 AND s.entryorguid = -CAST(creature.guid AS SIGNED))
         ORDER BY RAND() LIMIT v_need;

      UPDATE creature c JOIN zr_wild_battlepet_conversion b ON b.guid = c.guid
         SET c.id = b.new_id, c.modelid = 0
       WHERE b.zone = v_zone AND b.new_id = v_pet AND c.id = v_critter;
    END IF;
  END LOOP;
  CLOSE cur;
END//
DELIMITER ;

CALL zr_convert_wild_battlepets();
DROP PROCEDURE `zr_convert_wild_battlepets`;

SELECT COUNT(*) AS converted_spawns, COUNT(DISTINCT zone) AS zones FROM zr_wild_battlepet_conversion;
