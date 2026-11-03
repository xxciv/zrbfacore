-- Holiday NPCs that react to a player's /emote cast their spell at nobody (Four, 2026-11-03).
--
-- Both rows are SmartAI "receive emote" events (event_type 22) with a cast action (11), but their
-- target_type is 0 (SMART_TARGET_NONE). SmartScript::GetTargets returns no targets for that, so the
-- cast never happens. Target the player who did the emote instead (7 = SMART_TARGET_ACTION_INVOKER),
-- as in TrinityCore.
--
-- Catrina (34383), Day of the Dead: /dance -> Honor the Dead (65386, skeleton transform). Achievement
--   3456 Dead Man's Party is criteria 10918, type 69 (be spell target) asset 65386, so the cast is
--   what awards it.
-- Winter Reveler (15760), Winter Veil: /kiss -> Mistletoe (26218).
UPDATE `smart_scripts` SET `target_type`=7 WHERE `entryorguid`=34383 AND `source_type`=0 AND `id`=0 AND `link`=0 AND `event_type`=22 AND `action_type`=11 AND `action_param1`=65386;
UPDATE `smart_scripts` SET `target_type`=7 WHERE `entryorguid`=15760 AND `source_type`=0 AND `id`=0 AND `link`=0 AND `event_type`=22 AND `action_type`=11 AND `action_param1`=26218;
