# ZRProximity (client addon, BFA 8.3.7)

Cuts screen clutter by keeping Blizzard's nameplates hidden until they matter. A plate fades in when:

- the unit is your **target** or under the **mouse**,
- the unit is **fighting you** (you are on its threat list),
- the unit is within the **distance** set for its type: aggressive enemies (default 10 yd), neutral units
  (5 yd) and friendly NPCs and players (4 yd),
- you **look at it**: you face it with the camera so its plate stays in the middle of the screen for a short
  delay (default 0.5 s). It then stays visible for a while after you look away (default 2 s). Only one unit
  at a time, and only within 20 yards ("Look works up to").

Status: new, not tested in game yet.

## Install

Copy this `ZRProximity` folder into `_retail_/Interface/AddOns/` in the game folder, then restart the game
or `/reload`.

## Settings

`/zrp` opens **Interface > AddOns > ZRProximity**. There you set the three distances, the target, mouseover
and combat toggles, the look delay, width and distance, and the fade time. You can also choose to:

- **Hide the names above heads** (on by default). The game's floating unit names are one global setting, not
  per unit, so the addon switches them off and names come only from the nameplates. On 8.3.7 the plates'
  own names follow the same setting (with "NPC Names: None" a plate is only a health bar), so the addon puts
  the name back on every plate itself. Leave Interface > Names > NPC Names as the addon sets it: with
  "All NPCs" the game draws a floating name over every unit too far away to have a plate. Unticking it, or
  `/zrp off`, puts your old settings back.
- **Hide friendly plates in dungeons and raids** (on by default). Blizzard blocks addons from touching
  friendly nameplates inside instances, so there they can only be all on or all off. Enemy plates follow the
  normal rules everywhere.
- **Click-through nameplates** (off by default). Hidden plates can still be clicked. This makes every plate
  click-through, and it only changes outside combat.

Commands: `/zrp on`, `/zrp off`, `/zrp status`, `/zrp range`, `/zrp look`, `/zrp names`, `/zrp reset`.

## How "look at" works

Your own character stands in the middle of the screen, so a unit you face has its plate a bit above the
centre, and higher (toward the horizon) the farther away it is. The look area is therefore a column up the
middle of the screen, "Look width" UI units to each side. The plate nearest the middle of that column, of a
unit within "Look works up to" yards, is the one you are looking at. `/zrp look` shows the column for 10
seconds and prints where the nearby plates sit, which helps if the width needs changing.

## How distance works

The 8.3.7 client only gives exact positions for you and your group, not for NPCs. Like range-check addons,
ZRProximity asks the game whether items with a known use range would reach the unit (`IsItemInRange`), so
distance comes in steps: 3 (hostile only), 4 (friendly only), 5, 6, 8, 10, 15, 20, 25, 30, 35 and 40 yards.
A setting between steps checks the next step up, and the options panel shows which one (for example "7 yd
(checks 8 yd)"). `/zrp range` prints which steps the game answers for your current target; `?` means the
item's data isn't loaded yet or the check doesn't apply to that unit.

Nameplates also only exist out to the game's nameplate distance, so nothing shows beyond that anyway.

## Files

- `Ranges.lua`: the range items and `IsWithin(unit, yards)`.
- `ZRProximity.lua`: nameplate tracking, the show rules, fading, CVars and `/zrp`.
- `Options.lua`: the options panel.
