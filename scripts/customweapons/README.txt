Scripted Weapons Keyvalues Reference

All script filenames should be prefixed with 'custom_' for them to be loaded correctly.
If this is not done, the weapon will use its default properties instead.

Also note that all custom weapon scripts should only be placed in this folder (i.e. 'scripts/customweapons')

Only the 'weapon_scripted' entity is capable of using the "Advanced" configurations.
All others will only use the "basic" configurations.

This file is best viewed in Notepad++ with 'C' syntax highlighting.

To test out your changes on-the-fly while in game (preferably while running in windowed
mode), simply drop the weapon and give yourself a new one - it will have the new settings
applied.

// LIST OF USABLE ADVANCED SECTION VALUES \\

///////////////////////////////////
// Primary Attack Settings Begin //
///////////////////////////////////
// Note the '1' at the end of each key name in this block
// (which means that the setting only applies to the primary attack)

// The following keyvalue defines the weapon's primary attack type
// 0 = none, 1 = basic bullet, 2 = burst, 3 = shotgun, 4 = autoshotgun, 5 = laser, 6 = warp, 9 = hand grenade (TODO: Check if implemented)
// -
// Applies to: N/A
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 'basic bullet' if unspecified
"FireType1"	"1"

// Defines the weapon's primary rate of fire
// -
// Applies to: All fire types EXCEPT 'laser' and 'warp'
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.5 if unspecified
"FireRate1"	"0.1"

// Defines if the weapon should permit a refire as fast as the player can click
// (i.e. semi-automatic mode)
// -
// Applies to: ONLY 'basic bullet' fire type
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FastFire1"	"0"

// The following keyvalue should be self-explanatory
// -
// Applies to: All fire types
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FireUnderwater1"	"0"

// Defines the number of bullets in each burst
// -
// Applies to: ONLY 'burst' fire type
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"BurstAmount1"	"0"

// Defines the delay in seconds between each consecutive shot in each burst
// -
// Applies to: ONLY 'burst' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.0 if unspecified
"BetweenBurstTime1"	"0.05"

// Defines the initial accuracy of the primary attack (when unscoped)
// Values 0-10 each have their own presets (with 0 being the most accurate), values 11-15 will
// default to a cone of 15 degrees, and values 16-20 will use a cone of 20 degrees (the most
// inaccurate)
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"FireCone1"		"2"

// Defines the whether the accuracy of the primary attack should be lerped (i.e. linearly
// interpolated) over time when firing (when unscoped)
// Accuracy lerps are always cancelled out while scoped
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FireConeLerp1"		"1"

// Defines the worst possible accuracy of the primary attack if lerped (when unscoped)
// Refer to 'FireCone1' for the applicable values
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 1 if unspecified
"FireConeLerpTo1"	"6"
/////////////////////////////////
// Primary Attack Settings End //
/////////////////////////////////

/////////////////////////////////////
// Secondary Attack Settings Begin //
/////////////////////////////////////
// Note the '2' at the end of each key name in this block
// (which means that the setting only applies to the secondary attack)

// The following keyvalue defines the weapon's secondary attack type
// 0 = none, 1 = basic bullet, 2 = burst, 3 = shotgun, 4 = autoshotgun, 5 = laser, 6 = warp, 7 = scope, 8 = contact grenade, 9 = hand grenade
// -
// Applies to: N/A
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 'none' if unspecified
"FireType2"	"2"

// Defines the weapon's secondary rate of fire
// -
// Applies to: All fire types EXCEPT 'laser' and 'warp'
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.5 if unspecified
"FireRate2"	"0.7"

// Defines if the weapon should permit a refire as fast as the player can click
// (i.e. semi-automatic mode)
// -
// Applies to: ONLY 'basic bullet' fire type
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FastFire2"	"0"

// The following keyvalue should be self-explanatory
// NOTE: When using the 'scope' fire type, always set this to 1 to prevent the empty chamber
// 'click' sound from being played while underwater
// -
// Applies to: All fire types
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FireUnderwater2"	"0"

// Defines the number of bullets in each burst
// -
// Applies to: ONLY 'burst' fire type
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"BurstAmount2"	"4"

// Defines the delay in seconds between each consecutive shot in each burst
// -
// Applies to: ONLY 'burst' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.0 if unspecified
"BetweenBurstTime2"	"0.05"

// Defines whether the secondary attack uses the same ammunition as the primary attack
// If 0, will use primary ammunition. Secondary attack ammunition is defined by the keyvalue
// "secondary_ammo", outside and above the "Advanced" section in the weapon script
// FIXME: NOT YET FUNCTIONAL
// -
// Applies to: All fire types
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"SecondaryAmmoUsed"	"0"

// Defines the initial accuracy of the secondary attack (when unscoped)
// Values 0-10 each have their own presets (with 0 being the most accurate), values 11-15 will
// default to a cone of 15 degrees, and values 16-20 will use a cone of 20 degrees (the most
// inaccurate)
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"FireCone2"		"2"

// Defines the whether the accuracy of the secondary attack should be lerped (i.e. linearly
// interpolated) over time when firing (when unscoped)
// Accuracy lerps are always cancelled out while scoped
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"FireConeLerp2"		"1"

// Defines the worst possible accuracy of the secondary attack if lerped (when unscoped)
// Refer to 'FireCone2' for the applicable values
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 1 if unspecified
"FireConeLerpTo2"	"6"
///////////////////////////////////
// Secondary Attack Settings End //
///////////////////////////////////

//////////////////////////////////
// Global Weapon Settings Begin //
//////////////////////////////////
// Settings here will apply to both attacks, unless otherwise specified

// Defines the number of recoil animation sets (ACT_VM_RECOIL) the viewmodel is expected to
// have (only applicable if the viewmodel has multiple recoil animation sets)
// NOTE: At the time of writing, the Source Engine only supports a maximum of three sets by
//		 default
// -
// Applies to: ONLY 'basic bullet' and 'burst' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"NumberOfRecoilAnims"	"0"

// Defines the number of shots fired before the next recoil animation set is triggered
// (only applicable if the viewmodel has multiple recoil animation sets)
// -
// Applies to: ONLY 'basic bullet' and 'burst' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 1 if unspecified
"RecoilIncrementSpeed"	"1"

// Defines the player animation set that will be used on players seen in-game that are
// holding this weapon
// 0 = unarmed, 1 = pistol, 2 = AR2, 3 = crossbow, 4 = Gravity Gun, 5 = shotgun, 6 = SMG1, 7 = fragmentation grenade
// -
// Applies to: All fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 'pistol' if unspecified
"PlayerAnimationSet"	"2"

// Defines the damage dealt by contact grenade explosions
// -
// Applies to: ONLY 'contact grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 100.0 if unspecified
"GrenadeDamage"	"100.0"

// Defines the radius of contact grenade explosions
// -
// Applies to: ONLY 'contact grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 250.0 if unspecified
"GrenadeRadius"	"250.0"

// Defines the types of tracers to be drawn when firing
// 0 = none, 1 = SMG1, 2 = strider, 3 = AR2, 4 = helicopter, 5 = gunship, 6 = Gauss, 7 = airboat
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 'SMG1' if unspecified
"TracerType"	"1"

// Defines the numer of shots that must be fired before the next tracer is drawn
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 2 if unspecified
"TracerFrequency"	"2"

// Defines the bullet impact effect type to be drawn
// 0 = none, 1 = normal decal, 2 = AR2, 3 = jeep, 4 = Gauss, 5 = airboat, 6 = helicopter
// -
// Applies to: ONLY 'basic bullet', 'burst', 'shotgun' and 'autoshotgun' fire types
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 'normal decal' if unspecified
"ImpactEffect"	"1"

// Defines the lower limit of view recoil deviation on the pitch axis when unscoped and when
// ironsights are inactive. A value is chosen at random between this value and the value of
// 'MaxViewRecoilPitch'. Negative values will push the view upward, positive values will
// push the view downward
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to -0.5 if unspecified
"MinViewRecoilPitch"	"-0.5"

// Defines the upper limit of view recoil deviation on the pitch axis when unscoped and when
// ironsights are inactive. A value is chosen at random between this value and the value of
// 'MinViewRecoilPitch'. Negative values will push the view upward, positive values will
// push the view downward
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.25 if unspecified
"MaxViewRecoilPitch"	"0.25"

// Defines the lower limit of view recoil deviation on the yaw axis when unscoped and when
// ironsights are inactive. A value is chosen at random between this value and the value of
// 'MaxViewRecoilYaw'. Negative values will push the view to the right, positive values will
// push the view to the left
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to -0.6 if unspecified
"MinViewRecoilYaw"	"-0.6"

// Defines the upper limit of view recoil deviation on the yaw axis when unscoped and when
// ironsights are inactive. A value is chosen at random between this value and the value of
// 'MinViewRecoilYaw'. Negative values will push the view to the right, positive values will
// push the view to the left
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.6 if unspecified
"MaxViewRecoilYaw"	"0.6"
////////////////////////////////
// Global Weapon Settings End //
////////////////////////////////

/////////////////////////////////
// Sniper Scope Settings Begin //
/////////////////////////////////
// The following keyvalue should be self-explanatory
// Accuracy lerps are always cancelled out while scoped
// -
// Applies to: ONLY 'scope' fire type
// Interpreted as type: Boolean (i.e. 0 = no, 1 = yes)
// Defaults to 0 if unspecified
"UseScopedFireCone"	"1"

// Defines the size of the firing cone when scoped
// Values 0-10 each have their own presets (with 0 being the most accurate), values 11-15 will
// default to a cone of 15 degrees, and values 16-20 will use a cone of 20 degrees (the most
// inaccurate)
// -
// Applies to: ONLY 'scope' fire type
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 0 if unspecified
"ScopedFireCone"	"0"

// The following three keyvalues define the color of the overlay that appears when scoped, set
// all three to zero to disable the color overlay
// -
// Applies to: ONLY 'scope' fire type
// Interpreted as type: Integer (i.e. whole number)
// Default to 255 if unspecified
"ScopedColorR"		"255"
"ScopedColorG"		"255"
"ScopedColorB"		"255"

// Defines the lower limit of view recoil deviation on the pitch axis when scoped. A value is
// chosen at random between this value and the value of 'ScopedMaxViewRecoilPitch'. Negative
// values will push the view upward, positive values will push the view downward
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to the value of 'MinViewRecoilPitch' if unspecified
"ScopedMinViewRecoilPitch"	"-1.5"

// Defines the upper limit of view recoil deviation on the pitch axis when scoped. A value is
// chosen at random between this value and the value of 'ScopedMinViewRecoilPitch'. Negative
// values will push the view upward, positive values will push the view downward
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to the value of 'MaxViewRecoilPitch' if unspecified
"ScopedMaxViewRecoilPitch"	"0.1"

// Defines the lower limit of view recoil deviation on the yaw axis when scoped. A value is
// chosen at random between this value and the value of 'ScopedMaxViewRecoilYaw'. Negative
// values will push the view to the right, positive values will push the view to the left
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to the value of 'MinViewRecoilYaw' if unspecified
"ScopedMinViewRecoilYaw"	"-0.5"

// Defines the upper limit of view recoil deviation on the yaw axis when scoped. A value is
// chosen at random between this value and the value of 'ScopedMinViewRecoilYaw'. Negative
// values will push the view to the right, positive values will push the view to the left
// -
// Applies to: All fire types
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to the value of 'MaxViewRecoilYaw' if unspecified
"ScopedMaxViewRecoilYaw"	"0.5"
///////////////////////////////
// Sniper Scope Settings End //
///////////////////////////////

/////////////////////////////////
// Hand Grenade Settings Begin //
/////////////////////////////////
// Defines the type of grenade that will be thrown
// 1 = fragmentation grenade, 2 = hopwire (not implemented yet)
// -
// Applies to: ONLY 'hand grenade' fire type
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 1 if unspecified
"HandNadeType"		"1"

// Defines the delay in seconds before the hand grenade detonates
// -
// Applies to: ONLY 'hand grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 2.5 if unspecified
"HandNadeTimer"		"2.5"

// Defines the radius of the hand grenade model (not the damage radius)
// -
// Applies to: ONLY 'hand grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 4.0 if unspecified
"HandNadeRadius"	"4.0"

// Defines the radius of hand grenade explosions
// -
// Applies to: ONLY 'hand grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 250.0 if unspecified
"HandNadeDmgRadius"	"250.0"

// Defines the damage dealt by hand grenade explosions
// -
// Applies to: ONLY 'hand grenade' fire type
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 150.0 if unspecified
"HandNadeDmg"	"150.0"
///////////////////////////////
// Hand Grenade Settings End //
///////////////////////////////

///////////////////////////////
// NPC Weapon Settings Begin //
///////////////////////////////
// NPCs use a CAI_ShotRegulator() in code, the following five keyvalues correspond with its settings
// NOTE: In order for NPCs to use the weapon, its world model must be compiled with the
// ACT_RANGE_ATTACK_* animations

// Defines the NPC's rate of fire when using this weapon
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.5 if unspecified
"NPCRateofFire"		"0.1"

// Defines the minimum number of shots in each burst
// -
// Applies to: N/A
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 1 if unspecified
"NPCMinBursts"		"1"

// Defines the maximum number of shots in each burst
// -
// Applies to: N/A
// Interpreted as type: Integer (i.e. whole number)
// Defaults to 3 if unspecified
"NPCMaxBursts"		"3"

// Defines the minimum delay in seconds between consecutive bursts
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.3 if unspecified
"NPCMinRest"		"0.3"

// Defines the maximum delay in seconds between consecutive bursts
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 0.6 if unspecified
"NPCMaxRest"		"0.6"

// Defines the minimum distance the NPC is able to use the primary attack of this weapon. If
// an enemy is closer than this distance, the NPC is unable to attack and will attempt to get
// a better vantage point instead
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 24.0 if unspecified
"NPCMinRange1"		"24.0"

// Defines the maximum distance the NPC is able to use the primary attack of this weapon
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 1500.0 if unspecified
"NPCMaxRange1"		"1500.0"

// Defines the minimum distance the NPC is able to use the secondary attack of this weapon. If
// an enemy is closer than this distance, the NPC is unable to attack and will attempt to get
// a better vantage point instead
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 24.0 if unspecified
"NPCMinRange2"		"24.0"

// Defines the maximum distance the NPC is able to use the secondary attack of this weapon
// -
// Applies to: N/A
// Interpreted as type: Float (i.e. decimal fraction)
// Defaults to 200.0 if unspecified
"NPCMaxRange2"		"200.0"
/////////////////////////////
// NPC Weapon Settings End //
/////////////////////////////
