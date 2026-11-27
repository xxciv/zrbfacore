-- zrbfacore personal-xp-rate.patch: each character's own XP rate (.zrxp rate 0-1).
-- No row = normal rate (1). Run against the characters database (bfa_characters).
CREATE TABLE IF NOT EXISTS `character_xp_rate` (
  `guid` BIGINT UNSIGNED NOT NULL COMMENT 'characters.guid',
  `rate` FLOAT NOT NULL DEFAULT 1 COMMENT '0 = no XP, 1 = normal',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
