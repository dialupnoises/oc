# GM OC

Here's the repository for the Garry's Mod Obsidian Conflict gamemode I'm working on. I would like to include at this point that I have no association with the Obsidian Conflict team and any content they made themselves is their own property. I don't think there's any copyright infringing content in this repository at the moment.

I haven't touched this lately and I don't know when I'll get back to it. Hopefully soon. To that point I'm not providing any support for this gamemode, nor do I claim that it will work in any sort of meaningful capacity. It works with the maps I've tested it on, albeit with a few bugs. It's up to you to set it up. I forget half the steps myself anyways.

There's quite a few dirty hacks in this gamemode, a few of which don't even work and were just wishful thinking on my part. There's also a few workarounds for not having the custom content from Obsidian Conflict. The most notable of these is `custom_replacements.lua`, which defines a mapping from Obsidian Conflict scripted weapons to Garry's Mod SWEPs from the workshop. If you don't have these installed, nothing will happen, but the weapons might not work. The workshop weapons it uses is listed in the file. I hope at some point to either replace those with completely custom weapons or get the permission of the authors to produce a pack of just the weapons this gamemode uses so you don't need to download the entirety of M9K for two guns.

As for getting maps working, you're going to need to find all of the content the map uses. This is rather difficult, and I recommend if you're running a server just for this gamemode that you just copy the content straight from the mod to the game. Any copyright infringement is on you.

I made a program that can find the dependencies of an Obsidian Conflict map. I'll see if I can package that up next so people can use that. 

Remember to copy the proper files from scripts/merchants and maps/cfg. If you don't, strange things might happen.