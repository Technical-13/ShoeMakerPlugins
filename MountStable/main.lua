import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";

import "ShoeMakerPlugins.MountStable";

Name = "MountStable";
Version = Plugins[Name]:GetVersion(); --> ** MountStable current version **
Author = Plugins[Name]:GetAuthor(); --> ** MountStable author **

edgePadding = 50;

chat = Turbine.Shell.WriteLine;-- Writes to "standard" chat channel

-- Check if MountStable Reloader & Unloader are loaded
Turbine.PluginManager.RefreshAvailablePlugins();
loaded_plugins = Turbine.PluginManager.GetLoadedPlugins();

MSRChecker = Turbine.UI.Control();
MSRChecker:SetWantsUpdates( true );

MSRChecker.Update = function( sender, args )
	for k,v in pairs( loaded_plugins ) do
		if v.Name == "MountStable Unloader" then
			Turbine.PluginManager.UnloadScriptState( 'MountStableUnloader' );
		end
		if v.Name == "MountStable Reloader" then
			Turbine.PluginManager.UnloadScriptState( 'MountStableReloader' );
		end
	end
	MSRChecker:SetWantsUpdates( false );
end

function UnloadMountStable()
	Turbine.PluginManager.LoadPlugin( 'MountStable Unloader' );
end

function ReloadMountStable()
	SaveSettings( false );
	Turbine.PluginManager.LoadPlugin( 'MountStable Reloader' );
end

-- Load settings
function LoadSettings()
	settings = Turbine.PluginData.Load( Turbine.DataScope.Character, "MountStableSettings" );
	
	if type( settings ) ~= "table" then
		settings = { };
	end
	
	if not settings.race then
	settings.race = 0;
	end
	
	if not settings.numSteeds then
	settings.numSteeds = 0;
	end
	
	if not settings.numGoats then
	settings.numGoats = 0;
	end
	
	if not settings.welcome then
		settings.welcome = false;
	end

	if not settings.positionX then		
		settings.positionX = ( Turbine.UI.Display.GetWidth() - mainWindow:GetWidth() - edgePadding);		
	end
	
	if not settings.positionY then	
		settings.positionY = ( Turbine.UI.Display.GetHeight() - mainWindow:GetHeight() - edgePadding * 1.5 );
	end
	
	if not settings.alwayshide then
		settings.alwayshide = false;
	end
	
	if not settings.goat then
		settings.goat = false;
	end
	
	if not settings.qs1 then
		settings.qs1 = 1;
	end
	
	if not settings.qs2 then
		settings.qs2 = settings.qs1 + 1;
	end
	
	if not settings.qs3 then
		settings.qs3 = settings.qs1 + 2;
	end

	if not settings.cqs1 then
		settings.cqs1 = 1;
	end
	
	if not settings.cqs2 then
		settings.cqs2 = settings.cqs1 + 1;
	end
	
	if not settings.cqs3 then
		settings.cqs3 = settings.cqs1 + 2;
	end
end

-- Save settings
function SaveSettings()
	Turbine.PluginData.Save( Turbine.DataScope.Character, "MountStableSettings", settings );
end

-- Determine player race
function playerRace()
	if settings.race == 0 then
		Player = Turbine.Gameplay.LocalPlayer.GetInstance();
		
		PlayerRaceIs = Player:GetRace();
--		PlayerRaceIs = 187;-- Debug
	
		settings.race = PlayerRaceIs;
	else
		PlayerRaceIs = settings.race;
	end
		
	--Free people races
	if PlayerRaceIs == 0 then PlayerRaceIs = ""; -- Undefined
	elseif PlayerRaceIs == 23 then PlayerRaceIs = "Man";
	elseif PlayerRaceIs == 65 then PlayerRaceIs = "Elf";
	elseif PlayerRaceIs == 73 then PlayerRaceIs = "Dwarf";
	elseif PlayerRaceIs == 81 then PlayerRaceIs = "Hobbit";
	elseif PlayerRaceIs == 114 then PlayerRaceIs = "Beorning";

	--Monster play race
	elseif PlayerRaceIs == 7 then PlayerRaceIs = "Monster";
	
	--New race
	else
		PlayerRaceIs = tostring( PlayerRaceIs );
	end
	
	return PlayerRaceIs;
end

--mainWindow = Turbine.UI.Lotro.Window();
mainWindow = Turbine.UI.Extensions.Window();
mainWindow:SetSize( 240 , 35 );
mainWindow:SetText( "Mounts" );
mainWindow:SetOpacity( 0 );
mainWindow:SetFadeSpeed( 0.5 );
mainWindow:SetVisible( true );

LoadSettings();

mainWindow:SetPosition( settings.positionX, settings.positionY );

--local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
--local windowWidth, windowHeight = mainWindow:GetSize();

--mainWindow:SetPosition( ( displayWidth-windowWidth ) /2,( displayHeight - windowHeight ) /2 );

leftWindow = Turbine.UI.Extensions.SimpleWindow();
leftWindow:SetSize( 35 , 35 );
leftWindow:SetParent( mainWindow );
leftWindow:SetPosition( 47.5, 50 );
leftWindow:SetOpacity( 0.25 );
leftWindow:SetFadeSpeed( 0.5 );

centerWindow = Turbine.UI.Extensions.SimpleWindow();
centerWindow:SetSize( 35 , 35 );
centerWindow:SetParent( mainWindow );
centerWindow:SetPosition( 82.5, 40 );

rightWindow = Turbine.UI.Extensions.SimpleWindow();
rightWindow:SetSize( 35 , 35 );
rightWindow:SetParent( mainWindow );
rightWindow:SetPosition( 117.5, 50 );
rightWindow:SetOpacity( 0.25 );
rightWindow:SetFadeSpeed( 0.5 );

steeddata = { };
	horsedata = { };-- Human, Elf, & Beorning horses
		horsedata[1] = "0x7001BFFE"; -- Bree-Starter Horse
		horsedata[2] = "0x7001B4B7"; -- Bay Horse
		horsedata[3] = "0x7001B4C9"; -- Blonde Sorrel Horse
		horsedata[4] = "0x7001B4B0"; -- Bloodbay Horse
		horsedata[5] = "0x7001B4C5"; -- Chestnut Horse
		horsedata[6] = "0x7001B4A8"; -- Springfest Horse
		horsedata[7] = "0x70020550"; -- Blue Roan Horse
		horsedata[8] = "0x7001B4C7"; -- Lithe Festival Horse
		horsedata[9] = "0x700216F9"; -- Pale Golden Summer Horse
		horsedata[10] = "0x7001B4C0"; -- Harvestmath Horse
		horsedata[11] = "0x7001B4CD"; -- Yule Festival Horse
		horsedata[12] = "0x7001E8EE"; -- Yule Festival Snow Horse
		horsedata[13] = "0x7001CF5D"; -- Liver Chestnut Horse
		horsedata[14] = "0x7001B4AC"; -- Dark Chestnut Horse
		horsedata[15] = "0x7001B4D3"; -- Tundra-Horse
		horsedata[16] = "0x7001B4C4"; -- Ashen Horse
		horsedata[17] = "0x7001B4D9"; -- Grey Horse
		horsedata[18] = "0x7001B4D0"; -- Galadhrim Horse
		horsedata[19] = "0x7002054D"; -- Smoky Black Horse
		horsedata[20] = "0x70022C61"; -- Horse of the Grey Company
		horsedata[21] = "0x7001E97D"; -- Dunedain War-Horse
		horsedata[22] = "0x7001B4B1"; -- Mahogany Bay Horse
		horsedata[23] = "0x7001E980"; -- Galadhrim War-Horse
		horsedata[24] = "0x7001E8ED"; -- Sable Harvestmath Horse
		horsedata[25] = "0x7001B4C1"; -- Bree Horse
	ponydata = { };-- Hobbit & Dwarf ponies
		ponydata[1] = "0x7001BFFD"; -- Bree Starter Pony
		ponydata[2] = "0x7001B4B9"; -- Bay Pony
		ponydata[3] = "0x7001B4BE"; -- Blonde Sorrel Pony
		ponydata[4] = "0x7001B4B2"; -- Bloodbay Pony
		ponydata[5] = "0x7001B4BD"; -- Chestnut Pony
		ponydata[6] = "0x7001B4C8"; -- Springfest Pony
		ponydata[7] = "0x70020551"; -- Blue Roan Pony
		ponydata[8] = "0x7001B4D2"; -- Lithe Festival Pony
		ponydata[9] = "0x700216FA"; -- Pale Golden Summer Pony
		ponydata[10] = "0x7001B4D7"; -- Harvestmath Pony
		ponydata[11] = "0x7001B4BF"; -- Yule Festival Pony
		ponydata[12] = "0x7001CF5E"; -- Liver Chestnut Pony
		ponydata[13] = "0x7001B4D4"; -- Dark Chestnut Pony
		ponydata[14] = "0x7001B4C8"; -- Tundra-Pony
		ponydata[15] = "0x7001B4CF"; -- Ashen Pony
		ponydata[16] = "0x7001B4DA"; -- Grey Pony
		ponydata[17] = "0x7002054F"; -- Smoky Black Pony
		ponydata[18] = "0x70022C6C"; -- Pony of the Grey Company
		ponydata[19] = "0x7001E97B"; -- Dunedain War-Pony
		ponydata[20] = "0x7001B4AA"; -- Mahogany Bay Pony
		ponydata[21] = "0x7001E97F"; -- Galadhrim War-Pony
		ponydata[22] = "0x7001E8EF"; -- Sable Harvestmath Pony
		ponydata[23] = "0x7001B4D8"; -- Bree Pony
		ponydata[24] = "0x70022C66"; -- Algraig Pony

goatdata = { };
	hebGoatData = { };-- Human, Elf, & Beorning goats
		hebGoatData[1] = "0x7001CEAA"; -- Dusky Nimblefoot Goat
		hebGoatData[2] = "0x7001B4B4"; -- Tame Redhorn Goat 
		hebGoatData[3] = "0x7001B4B8"; -- Nimble Redhorn-Goat
		hebGoatData[4] = "0x7001E981"; -- Nimble Black Goat
		hebGoatData[5] = "0x7001E97A"; -- Wild Mountain Goat
	hdGoatData = { };-- Hobbit & Dwarf goats
		hdGoatData[1] = "0x7001CEA9"; -- Dusky Nimblefoot Goat
		hdGoatData[2] = "0x7001B4B3"; -- Tame Redhorn Goat 
		hdGoatData[3] = "0x7001B4C6"; -- Nimble Redhorn-Goat
		hdGoatData[4] = "0x7001E97C"; -- Nimble Black Goat
		hdGoatData[5] = "0x7001E97E"; -- Wild Mountain Goat

thisPlayerRaceIs = playerRace();
if thisPlayerRaceIs == "Beorning" or thisPlayerRaceIs == "Elf" or thisPlayerRaceIs == "Man" then
		chat( thisPlayerRaceIs.." detected, loading horse data." )-- Debug
	for i,v in ipairs( horsedata ) do
		steeddata[i] = v;
		settings.numSteeds = i + 1;
	end
	for i,v in ipairs( hebGoatData ) do
		goatdata[i] = v;
		settings.numGoats = i + 1;
	end
elseif thisPlayerRaceIs == "Dwarf" or thisPlayerRaceIs == "Hobbit" then
		chat( thisPlayerRaceIs.." detected, loading pony data." )-- Debug
	for i,v in ipairs( ponydata ) do
		steeddata[i] = v;
		settings.numSteeds = i + 1;
	end
	for i,v in ipairs( hdGoatData ) do
		goatdata[i] = v;
		settings.numGoats = i + 1;
	end
elseif thisPlayerRaceIs == "Monster" then
	chat( "Monsters don't ride mounts!" )
else
	chat( "You are playing a new race unknown to this plugin!  Please submit a bug report to https://github.com/Technical-13/ShoeMakerPlugins/issues/new -\nTitle:  Please add "..PlayerRaceIs.." as <race you are playing>\nComment:  <tell me what race you are playing, the index of the race ("..PlayerRaceIs.."), if it can ride horses or ponies, and any other relevant information you can offer." );
end

steedqs = { };
for i,v in ipairs( steeddata ) do
	steedqs[i] = Turbine.UI.Lotro.Quickslot();
	steedqs[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( 6, v ) );
end

goatqs = { };
for i,v in ipairs( goatdata ) do
	goatqs[i] = Turbine.UI.Lotro.Quickslot();
	goatqs[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( 6, v ) );
end

leftqs = Turbine.UI.Lotro.Quickslot();
leftqs:SetParent( leftWindow );
leftqs:SetPosition( 0, 0 );
leftqs:SetSize( 35, 35 );
leftqs:SetAllowDrop( false );

centerqs = Turbine.UI.Lotro.Quickslot();
centerqs:SetParent( centerWindow );
centerqs:SetPosition( 0, 0 );
centerqs:SetSize( 35, 35 );
centerqs:SetAllowDrop( false );

rightqs = Turbine.UI.Lotro.Quickslot();
rightqs:SetParent( rightWindow );
rightqs:SetPosition( 0, 0 );
rightqs:SetSize( 35, 35 );
rightqs:SetAllowDrop( false );

qs1 = settings.qs1;
qs2 = settings.qs2;
qs3 = settings.qs3;
cqs1 = settings.cqs1;
cqs2 = settings.cqs2;
cqs3 = settings.cqs3;

goat = settings.goat;
if not goat then
	leftqs:SetShortcut( steedqs[qs1]:GetShortcut() );
	centerqs:SetShortcut( steedqs[qs2]:GetShortcut() );
	rightqs:SetShortcut( steedqs[qs3]:GetShortcut() );
else
	leftqs:SetShortcut( goatqs[cqs1]:GetShortcut() );
	centerqs:SetShortcut( goatqs[cqs2]:GetShortcut() );
	rightqs:SetShortcut( goatqs[cqs3]:GetShortcut() );
end

if settings.welcome then
	chat(" *** Welcome to Mount Stable! ***\n - To show help type /ms help");
end

MountStableCommand = Turbine.ShellCommand();

function MountStableCommand:Execute( command, arguments )
	if arguments == "help" then
		chat(" *** Mount Stable Help ***\n\n - Use the Mouse Wheel over the middle Shortcut to move the Stable\n - Right click the middle Shortcut to change between Steed and Goat Stables\n - Right click anywhere in the window to hide it. \n -Use the command '/ms' or '/mountstable' to hide or show the Plugin.\n - Use the command '/ms restore' to move the window to its default position.\n - Use the command '/ms welcomeoff' to turn off the welcome message.\n - Use the command '/ms welcomeon' to turn on the welcome message.\n - Use the command '/ms reload' to reload Mount Stable.\n - Use the command '/ms unload' to unload Mount Stable.");
	elseif arguments == "welcomeoff" or arguments == "woff" then
		settings.welcome = true;
		SaveSettings();
		chat( "Welcome message has been disabled" );
	elseif rguments == "welcomeon" or arguments == "won" then
		settings.welcome = false;
		SaveSettings();
		chat( "Welcome message has been enabled" );
	elseif arguments == "restore" or arguments == "r" then
		settings.positionX = ( Turbine.UI.Display.GetWidth() - mainWindow:GetWidth() - edgePadding);		
		settings.positionY = ( Turbine.UI.Display.GetHeight() - mainWindow:GetHeight() - edgePadding * 1.5 );
		mainWindow:SetPosition(settings.positionX, settings.positionY);
		SaveSettings();
		chat( "Window restored to its default position" );
	elseif arguments == "unload" or arguments == "un" then
		SaveSettings();
		UnloadMountStable();
	elseif arguments == "reload" or arguments == "re" then
		SaveSettings();
		ReloadMountStable();
	elseif arguments ~= nil then
		mainWindow:SetVisible( not mainWindow:IsVisible() );
	end
end

Turbine.Shell.AddCommand( "ms;mountstable", MountStableCommand );

mainWindow.MouseEnter = function( sender, args )
	if not alwayshide then
		mainWindow:SetOpacity( 0.75 );
	end

	rightWindow:SetOpacity( 0.75 );
	leftWindow:SetOpacity( 0.75 );
end

mainWindow.MouseLeave = function( sender, args )
	X, Y = mainWindow:GetPosition();

	if not alwayshide then
		mainWindow:SetOpacity( 0 );
	end

	rightWindow:SetOpacity( 0.25 );
	leftWindow:SetOpacity( 0.25 );

	if X ~= settings.positionX or Y ~= settings.positionY then
		settings.positionX = X;
		settings.positionY = Y;
		SaveSettings();
	end
end

alwayshide = settings.alwayshide;

mainWindow.MouseClick = function (sender, args)
	if args.Button == Turbine.UI.MouseButton.Right then
		if not alwayshide then
			mainWindow:SetOpacity ( 0 );
			alwayshide = true;
		else
			mainWindow:SetOpacity( 0.75 );
			alwayshide = false;
		end
		
		settings.alwayshide = alwayshide;
		SaveSettings();
	end
end

centerqs.MouseClick = function (sender, args)
	if args.Button == Turbine.UI.MouseButton.Right then
		if not goat then
			leftqs:SetShortcut( goatqs[cqs1]:GetShortcut() );
			centerqs:SetShortcut( goatqs[cqs2]:GetShortcut() );
			rightqs:SetShortcut( goatqs[cqs3]:GetShortcut() );
			goat = true;
		else
			leftqs:SetShortcut( steedqs[qs1]:GetShortcut() );
			centerqs:SetShortcut( steedqs[qs2]:GetShortcut() );
			rightqs:SetShortcut( steedqs[qs3]:GetShortcut() );
			goat = false;
		end
		
		settings.goat = goat;
		SaveSettings();
	end
end

centerqs.MouseWheel = function( sender, args )
	Stable();
end

centerqs.MouseLeave = function( sender, args)
	if settings.qs1 ~= qs1 or settings.cqs1 ~= cqs1 then
		settings.qs1 = qs1;
		settings.qs2 = qs2;
		settings.qs3 = qs3;

		settings.cqs1 = cqs1;
		settings.cqs2 = cqs2;
		settings.cqs3 = cqs3;

		SaveSettings();
	end
end

function Stable()
	if not goat then
		qs1 = qs1 + 1;
		qs2 = qs2 + 1;
		qs3 = qs3 + 1;

		if qs1 == settings.numSteeds then
			qs1 = 1;
		elseif qs2 == settings.numSteeds then
			qs2 = 1;
		elseif qs3 == settings.numSteeds then
			qs3 = 1;
		end

		leftqs:SetShortcut( steedqs[qs1]:GetShortcut() );
		centerqs:SetShortcut( steedqs[qs2]:GetShortcut() );
		rightqs:SetShortcut( steedqs[qs3]:GetShortcut() );
	else
		cqs1 = cqs1 + 1;
		cqs2 = cqs2 + 1;
		cqs3 = cqs3 + 1;

		if cqs1 == settings.numGoats then
			cqs1 = 1;
		elseif cqs2 == settings.numGoats then
			cqs2 = 1;
		elseif cqs3 == settings.numGoats then
			cqs3 = 1;
		end

		leftqs:SetShortcut( goatqs[cqs1]:GetShortcut() );
		centerqs:SetShortcut( goatqs[cqs2]:GetShortcut() );
		rightqs:SetShortcut( goatqs[cqs3]:GetShortcut() );
	end
end

chat("MountStable v"..Version.." loaded!");