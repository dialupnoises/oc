"Resource/HudLayout.res"
{

	HudHealth
	{
		"fieldName"		"HudHealth"
		"xpos"	"16" //16
		"ypos"	"430" //432
		"wide"	"92" //108 -- 88
		"tall"  "41" // -- 39
		"visible" "1"
		"enabled" "1"
		"BgColor" "0 0 0 0"	

		"PaintBackgroundType"	"2"

		"text_xpos" "8"
		"text_ypos" "20"
		"digit_xpos" "42" //50
		"digit_ypos" "6" //5
	}

	HudSuit
	{
		"fieldName"		"HudSuit"
		"xpos"	"148" //140
		"ypos"	"430" //432
		"wide"	"92" //108 -- 88
		"tall"  "41" // -- 39
		"visible" "1"
		"enabled" "1"

		"PaintBackgroundType"	"2"

		
		"text_xpos" "8"
		"text_ypos" "20"
		"digit_xpos" "42" //50
		"digit_ypos" "6" //5
	}
	
	overview
	{
		"fieldname"				"overview"
		"visible"				"1"
		"enabled"				"1"
		"xpos"					"2"
		"ypos"					"54"
		"wide"					"0"
		"tall"					"0"
	}

	TargetID
	{
		"fieldName" "TargetID"
		"visible" "1"
		"enabled" "1"
		"wide"	 "f0"
		"tall"	 "480"
	}

	TeamDisplay
	{
	    "fieldName" "TeamDisplay"
	    "visible" "0"
	    "enabled" "1"
	    "xpos"    "2" //16
	    "ypos"    "24" //10
	    "wide" "200"
	    "tall" "60"
	    "text_xpos" "8"
	    "text_ypos" "4"
	}
	
	HudVoiceSelfStatus
	{
		"fieldName" "HudVoiceSelfStatus"
		"visible" "1"
		"enabled" "1"
		"xpos" "r43"
		"ypos" "355"
		"wide" "24"
		"tall" "24"
	}

	HudVoiceStatus
	{
		"fieldName" "HudVoiceStatus"
		"visible" "1"
		"enabled" "1"
		"xpos" "r200"
		"ypos" "0"
		"wide" "100"
		"tall" "400"

		"item_tall"	"24"
		"item_wide"	"100"

		"item_spacing" "2"

		"icon_ypos"	"0"
		"icon_xpos"	"0"
		"icon_tall"	"24"
		"icon_wide"	"24"

		"text_xpos"	"26"
	}

	HudAmmo
	{
		"fieldName" "HudAmmo"
		"xpos"	"r150"
		"ypos"	"430" //432
		"wide"	"136"
		"tall"  "41" //36
		"visible" "1"
		"enabled" "1"

		"PaintBackgroundType"	"2"

		"text_xpos" "8"
		"text_ypos" "15"
		"digit_xpos" "44"
		"digit_ypos" "5"
		"digit2_xpos" "98"
		"digit2_ypos" "10"
	}

	HudAmmoSecondary
	{
		"fieldName" "HudAmmoSecondary"
		"xpos"	"r76"
		"ypos"	"431" //432
		"wide"	"60"
		"tall"  "38" //36
		"visible" "1"
		"enabled" "1"

		"PaintBackgroundType"	"2"

		"digit_xpos" "10"
		"digit_ypos" "1"
	}
	
	HudSuitPower
	{
		"fieldName" "HudSuitPower"
		"visible" "1"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"390"
		"wide"	"102"
		"tall"	"26"
		
		"AuxPowerLowColor" "255 0 0 220"
		"AuxPowerHighColor" "255 220 0 220"
		"AuxPowerDisabledAlpha" "70"

		"BarInsetX" "8"
		"BarInsetY" "15"
		"BarWidth" "92"
		"BarHeight" "4"
		"BarChunkWidth" "6"
		"BarChunkGap" "3"

		"text_xpos" "8"
		"text_ypos" "4"
		"text2_xpos" "8"
		"text2_ypos" "22"
		"text2_gap" "10"

		"PaintBackgroundType"	"2"
	}
	
	HudFlashlight
	{
		"fieldName" "HudFlashlight"
		"visible" "1"
		"PaintBackgroundType"	"2"
		"xpos"	"270"		[$WIN32]
		"ypos"	"444"		[$WIN32]
		"xpos_hidef"	"306"		[$X360]		// aligned to left
		"xpos_lodef"	"c-18"		[$X360]		// centered in screen
		"ypos"	"428"		[$X360]				
		"tall"  "24"
		"wide"	"36"
		"font"	"WeaponIconsSmall"
		
		"icon_xpos"	"4"
		"icon_ypos" "-8"
		
		"BarInsetX" "4"
		"BarInsetY" "18"
		"BarWidth" "28"
		"BarHeight" "2"
		"BarChunkWidth" "2"
		"BarChunkGap" "1"
	}

	HudLocator
	{
		"fieldName" "HudLocator"
		"visible" "1"
		"PaintBackgroundType"	"2"
		"xpos"	"c8"	[$WIN32]
		"ypos"	"r36"	[$WIN32]
		"xpos"	"c-32"	[$X360]
		"ypos_hidef"	"r52"	[$X360]
		"ypos_lodef"	"r95"	[$X360]		// 52 is aligned to bottom of HudSuit
		"wide"	"64"
		"tall"  "24"
	}

	HudDamageIndicator
	{
		"fieldName" "HudDamageIndicator"
		"visible" "1"
		"enabled" "1"
		"DmgColorLeft" "255 0 0 0"
		"DmgColorRight" "255 0 0 0"
		
		"dmg_xpos" "30"
		"dmg_ypos" "100"
		"dmg_wide" "36"
		"dmg_tall1" "240"
		"dmg_tall2" "200"
	}

	HudZoom
	{
		"fieldName" "HudZoom"
		"visible" "1"
		"enabled" "1"
		"Circle1Radius" "66"
		"Circle2Radius"	"74"
		"DashGap"	"16"
		"DashHeight" "4"
		"BorderThickness" "88"
	}

	HudWeaponSelection
	{
		"fieldName" "HudWeaponSelection"
		"ypos" 	"16"
		"visible" "1"
		"enabled" "1"
		"SmallBoxSize" "25"
		"LargeBoxWide" "100"
		"LargeBoxTall" "60"
		"BoxGap" "2"
		"SelectionNumberXPos" "4"
		"SelectionNumberYPos" "4"
		"SelectionGrowTime"	"0.4"
		"TextYPos" "4"
	}

	HudCrosshair
	{
		"fieldName" "HudCrosshair"
		"visible" "1"
		"enabled" "1"
		"wide"	 "f0"
		"tall"	 "480"
	}

	HudDeathNotice
	{
		"fieldName" "HudDeathNotice"
		"visible" "1"
		"enabled" "1"
		"xpos"	 "r640"
		"ypos"	 "12"
		"wide"	 "628"
		"tall"	 "468"

		"MaxDeathNotices" "4"
		"LineHeight"	  "22"
		"RightJustify"	  "1"	// If 1, draw notices from the right

		"TextFont"				"Default"
	}

	HudVehicle
	{
		"fieldName" "HudVehicle"
		"visible" "1"
		"enabled" "1"
		"wide"	 "f0"
		"tall"	 "480"
	}

	ScorePanel
	{
		"fieldName" "ScorePanel"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudTrain
	{
		"fieldName" "HudTrain"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudMOTD
	{
		"fieldName" "HudMOTD"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudMessage
	{
		"fieldName" "HudMessage"
		"visible" "1"
		"enabled" "1"
		"wide"	 "f0"
		"tall"	 "480"
	}

	HudMenu
	{
		"fieldName"	"HudMenu"
		"visible"	"1"
		"enabled"	"1"
		"wide"	"640"
		"tall"	"480"
		"zpos"	"1"
		"TextFont"	"Default"
		"ItemFont"	"Default"
		"ItemFontPulsing"	"Default"
	}
	HudRadio
	{
		"fieldName"	"HudRadio"
		"TextFont"	"Default"
		"visible"	"1"
		"xpos"	"10"
		"ypos"	"c"
		"wide"	"Default"
		"tall"	"Default"
		"text_ygap"	"2"
		"TextColor"	"255 255 255 192"
		"PaintBackgroundType"	"0"
	}

	HudCloseCaption
	{
		"fieldName"	"HudCloseCaption"
		"visible"	"1"
		"enabled"	"1"
		"xpos"		"c-250"
		"ypos"		"276"
		"wide"		"500"
		"tall"		"136"

		"BgAlpha"	"128"

		"GrowTime"		"0.25"
		"ItemHiddenTime"	"0.2"  // Nearly same as grow time so that the item doesn't start to show until growth is finished
		"ItemFadeInTime"	"0.15"	// Once ItemHiddenTime is finished, takes this much longer to fade in
		"ItemFadeOutTime"	"0.3"
		"topoffset"		"0"
	}

	HudChat
	{
		"fieldName" "HudChat"
		"visible" "1"
		"enabled" "1"
		"xpos"	"10"
		"ypos"	"245"
		"wide"	 "400"
		"tall"	 "100"
	}

	HudHistoryResource
	{
		"fieldName" "HudHistoryResource"
		"visible" "1"
		"enabled" "1"
		"xpos"	"r252"
		"ypos"	"40"
		"wide"	 "248"
		"tall"	 "320"

		"history_gap"	"56"
		"icon_inset"	"28"
		"text_inset"	"26"
		"NumberFont"	"HudNumbersSmall"
	}

	HudGeiger
	{
		"fieldName" "HudGeiger"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HUDQuickInfo
	{
		"fieldName" "HUDQuickInfo"
		"visible" "1"
		"enabled" "1"
		"wide"	 "f0"
		"tall"	 "480"
	}

	HudWeapon
	{
		"fieldName" "HudWeapon"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}
	HudAnimationInfo
	{
		"fieldName" "HudAnimationInfo"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudPredictionDump
	{
		"fieldName" "HudPredictionDump"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudHintDisplay
	{
		"fieldName"	"HudHintDisplay"
		"visible"	"0"
		"enabled" "1"
		"xpos"		"c-240"
		"ypos"		"c60"
		"wide"		"480"
		"tall"		"100"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"center_x"	"0"	// center text horizontally
		"center_y"	"-1"	// align text on the bottom
	}

	HudHintKeyDisplay
	{
		"fieldName"	"HudHintKeyDisplay"
		"visible"	"0"
		"enabled" 	"1"
		"xpos"		"r120"	[$WIN32]
		"ypos"		"r340"	[$WIN32]
		"xpos"		"r148"	[$X360]
		"ypos"		"r338"	[$X360]
		"wide"		"100"
		"tall"		"200"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"text_xgap"	"8"
		"text_ygap"	"8"
		"TextColor"	"255 170 0 220"

		"PaintBackgroundType"	"2"
	}


	HudSquadStatus
	{
		"fieldName"	"HudSquadStatus"
		"visible"	"1"
		"enabled" "1"
		"xpos"	"r120"
		"ypos"	"380"
		"wide"	"104"
		"tall"	"46"
		"text_xpos"	"8"
		"text_ypos"	"34"
		"SquadIconColor"	"255 220 0 160"
		"IconInsetX"	"8"
		"IconInsetY"	"0"
		"IconGap"		"24"

		"PaintBackgroundType"	"2"
	}

	HudPoisonDamageIndicator
	{
		"fieldName"	"HudPoisonDamageIndicator"
		"visible"	"0"
		"enabled" "1"
		"xpos"	"139" //16
		"ypos"	"350" //346
		"wide"	"100" //136
		"tall"	"38"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"text_ygap" "14"
		"TextColor"	"255 170 0 220"
		"PaintBackgroundType"	"2"
	}
	HudCredits
	{
		"fieldName"	"HudCredits"
		"TextFont"	"Default"
		"visible"	"1"
		"xpos"	"0"
		"ypos"	"0"
		"wide"	"640"
		"tall"	"480"
		"TextColor"	"255 255 255 192"

	}
	
	HUDAutoAim
	{
		"fieldName" "HUDAutoAim"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudCommentary
	{
		"fieldName" "HudCommentary"
		"xpos"	"c-190"
		"ypos"	"350"
		"wide"	"380"
		"tall"  "40"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"
		
		"bar_xpos"		"50"
		"bar_ypos"		"20"
		"bar_height"	"8"
		"bar_width"		"320"
		"speaker_xpos"	"50"
		"speaker_ypos"	"8"
		"count_xpos_from_right"	"10"	// Counts from the right side
		"count_ypos"	"8"
		
		"icon_texture"	"vgui/hud/icon_commentary"
		"icon_xpos"		"0"
		"icon_ypos"		"0"		
		"icon_width"	"40"
		"icon_height"	"40"
	}
	
	HudHDRDemo
	{
		"fieldName" "HudHDRDemo"
		"xpos"	"0"
		"ypos"	"0"
		"wide"	"640"
		"tall"  "480"
		"visible" "1"
		"enabled" "1"
		
		"Alpha"	"255"
		"PaintBackgroundType"	"2"
		
		"BorderColor"	"0 0 0 255"
		"BorderLeft"	"16"
		"BorderRight"	"16"
		"BorderTop"		"16"
		"BorderBottom"	"64"
		"BorderCenter"	"0"
		
		"TextColor"		"255 255 255 255"
		"LeftTitleY"	"422"
		"RightTitleY"	"422"
	}
	"HudChatHistory"
	{
		"ControlName"		"RichText"
		"fieldName"		"HudChatHistory"
		"xpos"			"10"
		"ypos"			"290"
		"wide"	 		"300"
		"tall"			 "75"
		"wrap"			"1"
		"autoResize"		"1"
		"pinCorner"		"1"
		"visible"		"0"
		"enabled"		"1"
		"labelText"		""
		"textAlignment"		"south-west"
		"font"			"Default"
		"maxchars"		"-1"
	}

	AchievementNotificationPanel	
	{
		"fieldName"				"AchievementNotificationPanel"
		"visible"				"1"
		"enabled"				"1"
		"xpos"					"0"
		"ypos"					"180"
		"wide"					"f10"	[$WIN32]
		"wide"					"f60"	[$X360]
		"tall"					"100"
	}

// Obsidian Hud Elements

	HudPowerModule
	{
		"fieldName" "HudPowerModule"
		"visible" "1"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"350"
		"wide"	"102"
		"tall"	"26"
		
		"PowerModuleLowColor" "255 0 0 220"
		"PowerModuleHighColor" "0 102 255 220"
		"PowerModuleDisabledAlpha" "70"

		"BarInsetX" "8"
		"BarInsetY" "15"
		"BarWidth" "92"
		"BarHeight" "4"
		"BarChunkWidth" "6"
		"BarChunkGap" "3"

		"text_xpos" "8"
		"text_ypos" "4"
		"text2_xpos" "8"
		"text2_ypos" "22"
		"text2_gap" "10"

		"PaintBackgroundType"	"2"
	}

	HudHelmetIcon
	{
		"fieldName"	"HudHelmetIcon"
		"visible"	"0"
		"enabled" "1"
		"xpos"	"143"
		"ypos"	"386"
		"wide"	"48"
		"tall"	"48"
	}
	
	HudLivesCounter
	{
		"fieldName" "HudLivesCounter"
		"xpos"	"108"
		"ypos"	"431"
		"wide"	"40"
		"tall"  "39"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"

		"text_xpos"	"11"
		"text_ypos"	"2"
		"digit_xpos" "6"
		"digit_ypos" "8"
	}
	
	HudScore
	{
		"fieldName"		"HudScore"
		"xpos"	"2"
		"ypos"	"2" 
		"wide"	"55" 
		"tall"  "20" 
		"visible" "1"
		"enabled" "1"
		"BgColor" "0 0 0 0"	

		"PaintBackgroundType"	"2"

		"text_xpos" "4"
		"text_ypos" "2"

		"score_xpos" "4"
		"score_ypos" "10"
		"addscore_xpos" "28"
		"addscore_ypos" "2"

	}
	
	HudCountdownTimer
	{
		"fieldName" "HudCountdownTimer"
		"xpos"	"240"
		"ypos"	"2" //384
		"wide"	"192"
		"tall"  "48"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"

		"text_xpos"	"4"
		"text_ypos"	"2"
		"digit_xpos" "4"
		"digit_ypos" "18"
	}
	
	MerchantFoundation
	{
		"fieldName" "MerchantFoundation"
		"xpos"	"128"
		"ypos"	"51" //384
		"wide"	"392"
		"tall"  "369"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"
	}
	MainMerchantMenu
	{
		"fieldName" "MainMerchantMenu"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"
	}
	HudWaypoint
	{
		"fieldName" "HudWaypoint"
	//	"xpos"	"0"
	//	"ypos"	"0"
	//	"wide"	"392"
	//	"tall"  "369"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"

		"text_xpos"	"4"
		"text_ypos"	"2"
		"digit_xpos" "4"
		"digit_ypos" "18"
		"CircleRadius" "200"
		"DrawSize" "8"
		"Text1Pos" "9"
		"Text2Pos" "16"
		"CircleTolerance" "50"
	}
	HudItemSelect
	{
		"fieldName"		"HudItemSelect"
		"visible" "1"
		"enabled" "1"
		"wide"	"80"
		"tall"  "166"

		"PaintBackgroundType"	"2"
	}
}