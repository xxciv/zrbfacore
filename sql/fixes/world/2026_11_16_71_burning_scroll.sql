-- Quest fixes (Herald), 2026-11-16: The Lesson of the Burning Scroll (29408).
-- The Edict of Temperance (gameobject 210986, goober, consumable) never burned when used.
-- The burn is the model's despawn effect (SMSG_GAMEOBJECT_DESPAWN), confirmed by Four with
-- `.gobject set state 21000000 -1`. The template addon carried GO_FLAG_NODESPAWN (0x20), and with
-- that flag GameObject::Update returns before SendGameObjectDespawn for a used goober.
-- flags 65572 (0x10024) -> 65540 (0x10004): the used scroll now burns away and respawns after its
-- 5 second spawn time.
UPDATE `gameobject_template_addon` SET `flags`=`flags` & ~0x20 WHERE `entry`=210986;
