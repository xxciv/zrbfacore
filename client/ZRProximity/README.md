# ZRProximity (client addon, BFA 8.3.7)

Cuts screen clutter by keeping Blizzard's nameplates hidden until they matter. A plate fades in when:

- the unit is your **target** or under the **mouse**,
- the unit is **fighting you** (you are on its threat list),
- the unit is within the **distance** set for its type: aggressive enemies (default 10 yd), neutral units
  (5 yd) and friendly NPCs and players (4 yd),
- you **look at it**: its plate stays near the centre of the screen for a short delay (default 0.5 s). It
  then stays visible for a while after you look away (default 2 s).

Status: new, not tested in game yet.

## Install

Copy this `ZRProximity` folder into `_retail_/Interface/AddOns/` in the game folder, then restart the game
or `/reload`.

## Settings

`/zrp` opens **Interface > AddOns > ZRProximity**. There you set the three distances, the target, mouseover
and combat toggles, the look delay and area, and the fade time. You can also choose to:

- **Hide the names above heads** (on by default). The game's floating unit names are one global setting, not
  per unit, so the addon switches them off and names come only from the nameplates. Unticking it, or
  `/zrp off`, puts your old settings back.
- **Hide friendly plates in dungeons and raids** (on by default). Blizzard blocks addons from touching
  friendly nameplates inside instances, so there they can only be all on or all off. Enemy plates follow the
  normal rules everywhere.
- **Click-through nameplates** (off by default). Hidden plates can still be clicked. This makes every plate
  click-through, and it only changes outside combat.

Commands: `/zrp on`, `/zrp off`, `/zrp status`, `/zrp range`, `/zrp reset`.

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
