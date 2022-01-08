## Description
This is a proof-of-concept for a server-sided item degradation system that uses a cron schedule, and run whether players are on or not. This can adjust qualities of items in player inventories, stashes, gloveboxes and trunks. I found adjustements needed to be made to the inventory js, for this to make sense. In this example, I've added a `degrade` value on the shared.lua `QBShared.Items` table. If no amount is set, it will not degrade the item.

## Acknowledgment
Thanks to [mknzz](https://github.com/mknzz/qb-durability) for the locations in the invetory javascript to comment, to display Quality in the inventory. Shoutout to sgtherbz and Griefa for helping test.

![](https://i.imgur.com/zppoJPE.png)
## Usage
Set the hours of the day that you want the decay to occur, this is according to the server's clock. Next, add a `degrade` value with a float amount that an item will be decayed by, to each item you want affected, in your `QBShared.Items`. This decay will take place at each point of the day you set in the config.

`
["degrade"] = 1.0
`

Depending on the inventory system you are using, you might need to comment out all the locations listed in [this](https://github.com/mknzz/qb-inventory/commit/5bc5e2016e2b44d18fb2568d108b874c5e208e47). These locations may be different depending on the inventory you're using. You can start to see the pattern.

This was just personal preference and needed for the v3 qb-inventory script I'm using, but I wanted stacked items to have the lower of the two items' Quality, to prevent exploitation and the following code change does that. Within the following block:

`if (
    (toData != undefined || toData != null) &&
    toData.name == fromData.name &&
    !fromData.unique
) {`

Place the following code at the top:

`if (fromData.info.quality < toData.info.quality) {
    toData.info.quality = fromData.info.quality
}`

I left a `testdecay` command for players with `god` permission, that can manually trigger the degradation event.

To make sense, this would probably require a check in a LOT of places to see if the used item is Broken or not. Implementing it in the core's `CreateUseableItem` function, is pretty straight-forward, but items can be consumed/used/combined/crafted/etc in other ways than that, and would need this check there. This POC is only to provide the decay mechanism and will not include code changes needed elsewhere for that sanity-checking and implementation; that's up to you.

## Dependencies
- [oxmysql](https://github.com/overextended/oxmysql) (Written for ver. 1.8.7, I know they've dont a syntax change since then.)
- [cron](https://github.com/esx-framework/cron)

## TODO
- Lots of oppurtunity for code cleanup. It's currently very repetitive and dirty.
- An export to return whether the item is broken or not.
- Needs checking for if stashes or player inventories are currently opened by a played. This decay code could could be placed in the inventory, and would have direct access to those values.
- Integrating it with Inventory would also technically give it access to `Drops`, and could be applied to those tables too, to prevent players from exploiting, as this is a place where items could exist and not be affected by decay.

## Qbus.xyz Discord:
[Discord](https://discord.gg/Gec9kBKwcB)
