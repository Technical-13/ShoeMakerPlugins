import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";

Name = "MountStable";
Version = Plugins[Name]:GetVersion(); --> ** MountStable current version **
Author = Plugins[Name]:GetAuthor(); --> ** MountStable author **

edgePadding = 50;

function write(passthrough)
	Turbine.Shell.WriteLine(passthrough);
end

function LoadSettings()

settings = Turbine.PluginData.Load( Turbine.DataScope.Character, "MountStableSettings" );

	if ( type( settings ) ~= "table" ) then
		settings = { };
	end
	
	if ( not settings.welcome ) then
		settings.welcome = false;
	end

	if ( not settings.positionX ) then		
		settings.positionX = ( Turbine.UI.Display.GetWidth() - mainWindow:GetWidth() - edgePadding);		
	end
	
	if ( not settings.positionY ) then	
		settings.positionY = ( Turbine.UI.Display.GetHeight() - mainWindow:GetHeight() - edgePadding * 1.5 );
	end
	
	if ( not settings.alwayshide ) then
		settings.alwayshide = false;
	end
	
	if ( not settings.goat ) then
		settings.goat = false;
	end
	
	if ( not settings.qs1 ) then
		settings.qs1 = 0;
	end
	
	if ( not settings.qs2 ) then
		settings.qs2 = 1;
	end
	
	if ( not settings.qs3 ) then
		settings.qs3 = 2;
	end

	if ( not settings.cqs1 ) then
		settings.cqs1 = 0;
	end
	
	if ( not settings.cqs2 ) then
		settings.cqs2 = 1;
	end
	
	if ( not settings.cqs3 ) then
		settings.cqs3 = 2;
	end

end

function SaveSettings()

Turbine.PluginData.Save( Turbine.DataScope.Character, "MountStableSettings", settings );

end

function playerRace()
	Player = Turbine.Gameplay.LocalPlayer.GetInstance();
	
	PlayerRaceIs = Player:GetRace();
	
	--Free people races
	if PlayerRaceIs == 0 then PlayerRaceIs = ""; -- Undefined
	elseif PlayerRaceIs == 65 then PlayerRaceIs = "Elf";
	elseif PlayerRaceIs == 23 then PlayerRaceIs = "Man";
	elseif PlayerRaceIs == 73 then PlayerRaceIs = "Dwarf";
	elseif PlayerRaceIs == 81 then PlayerRaceIs = "Hobbit";
	elseif PlayerRaceIs == 114 then PlayerRaceIs = "Beorning";

	--Monster play race
	elseif PlayerRaceIs == 7 then PlayerRaceIs = "Monster"; end
	
	return PlayerRaceIs;
end

--mainWindow = Turbine.UI.Lotro.Window();
mainWindow = Turbine.UI.Extensions.Window();
mainWindow:SetSize( 200 , 35 );
mainWindow:SetText("Mounts");
mainWindow:SetOpacity( 0 );
mainWindow:SetFadeSpeed( 0.5 );
mainWindow:SetVisible( true );

LoadSettings();

mainWindow:SetPosition(settings.positionX, settings.positionY);

--local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
--local windowWidth,windowHeight = mainWindow:GetSize();

--mainWindow:SetPosition((displayWidth-windowWidth)/2,(displayHeight - windowHeight)/2);

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

if playerRace() == "Beorning" or playerRace() == "Elf" or playerRace() == "Man" then
		write(playerRace().." detected, loading horse data.")-- Debug
	steeddata = horsedata;
	goatdata = hebGoatData;
elseif playerRace() == "Dwarf" or playerRace() == "Hobbit" then
		write(playerRace().." detected, loading pony data.")-- Debug
	steeddata = ponydata;
	goatdata = hdGoatData;
elseif playerRace() == "Monster" then
	write("Monsters don't ride mounts!")
else
	write("Unknown race type!")
end

horsedata = { };
horsedata[0] = "0x7001BFFE"; -- Bree-Starter Horse
horsedata[1] = "0x7001B4B7"; -- Bay Horse
horsedata[2] = "0x7001B4C9"; -- Blonde Sorrel Horse
horsedata[3] = "0x7001B4B0"; -- Bloodbay Horse
horsedata[4] = "0x7001B4C5"; -- Chestnut Horse
horsedata[5] = "0x7001B4A8"; -- Springfest Horse
horsedata[6] = "0x70020550"; -- Blue Roan Horse
horsedata[7] = "0x7001B4C7"; -- Lithe Festival Horse
horsedata[8] = "0x700216F9"; -- Pale Golden Summer Horse
horsedata[9] = "0x7001B4C0"; -- Harvestmath Horse
horsedata[10] = "0x7001B4CD"; -- Yule Festival Horse
horsedata[11] = "0x7001E8EE"; -- Yule Festival Snow Horse
horsedata[12] = "0x7001CF5D"; -- Liver Chestnut Horse
horsedata[13] = "0x7001B4AC"; -- Dark Chestnut Horse
horsedata[14] = "0x7001B4D3"; -- Tundra-Horse
horsedata[15] = "0x7001B4C4"; -- Ashen Horse
horsedata[16] = "0x7001B4D9"; -- Grey Horse
horsedata[17] = "0x7001B4D0"; -- Galadhrim Horse
horsedata[18] = "0x7002054D"; -- Smoky Black Horse
horsedata[19] = "0x70022C61"; -- Horse of the Grey Company
horsedata[20] = "0x7001E97D"; -- Dunedain War-Horse
horsedata[21] = "0x7001B4B1"; -- Mahogany Bay Horse
horsedata[22] = "0x7001E980"; -- Galadhrim War-Horse
horsedata[23] = "0x7001E8ED"; -- Sable Harvestmath Horse
horsedata[24] = "0x7001B4C1"; -- Bree Horse

ponydata = { };
ponydata[0] = "0x7001BFFD"; -- Bree Starter Pony
ponydata[1] = "0x7001B4B9"; -- Bay Pony
ponydata[2] = "0x7001B4BE"; -- Blonde Sorrel Pony
ponydata[3] = "0x7001B4B2"; -- Bloodbay Pony
ponydata[4] = "0x7001B4BD"; -- Chestnut Pony
ponydata[5] = "0x7001B4C8"; -- Springfest Pony
ponydata[6] = "0x70020551"; -- Blue Roan Pony
ponydata[7] = "0x7001B4D2"; -- Lithe Festival Pony
ponydata[8] = "0x700216FA"; -- Pale Golden Summer Pony
ponydata[9] = "0x7001B4D7"; -- Harvestmath Pony
ponydata[10] = "0x7001B4BF"; -- Yule Festival Pony
ponydata[11] = "0x7001CF5E"; -- Liver Chestnut Pony
ponydata[12] = "0x7001B4D4"; -- Dark Chestnut Pony
ponydata[13] = "0x7001B4C8"; -- Tundra-Pony
ponydata[14] = "0x7001B4CF"; -- Ashen Pony
ponydata[15] = "0x7001B4DA"; -- Grey Pony
ponydata[16] = "0x7002054F"; -- Smoky Black Pony
ponydata[17] = "0x70022C6C"; -- Pony of the Grey Company
ponydata[18] = "0x7001E97B"; -- Dunedain War-Pony
ponydata[19] = "0x7001B4AA"; -- Mahogany Bay Pony
ponydata[20] = "0x7001E97F"; -- Galadhrim War-Pony
ponydata[21] = "0x7001E8EF"; -- Sable Harvestmath Pony
ponydata[22] = "0x7001B4D8"; -- Bree Pony
ponydata[23] = "0x70022C66"; -- Algraig Pony

steedqs = { };
for i,v in ipairs(steeddata) do
	steedqs[i] = Turbine.UI.Lotro.Quickslot();
	steedqs[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( 6.0, steeddata[i] ) );
end

-- Humans, Elves, & Beorning
hebGoatData = { };
hebGoatData[0] = "0x7001CEAA"; -- Dusky Nimblefoot Goat
hebGoatData[1] = "0x7001B4B4"; -- Tame Redhorn Goat 
hebGoatData[2] = "0x7001B4B8"; -- Nimble Redhorn-Goat
hebGoatData[3] = "0x7001E981"; -- Nimble Black Goat
hebGoatData[4] = "0x7001E97A"; -- Wild Mountain Goat

-- Hobbits & Dwarves
hdGoatData = { };
hdGoatData[0] = "0x7001CEA9"; -- Dusky Nimblefoot Goat
hdGoatData[1] = "0x7001B4B3"; -- Tame Redhorn Goat 
hdGoatData[2] = "0x7001B4C6"; -- Nimble Redhorn-Goat
hdGoatData[3] = "0x7001E97C"; -- Nimble Black Goat
hdGoatData[4] = "0x7001E97E"; -- Wild Mountain Goat

goatqs = { };
for i,v in ipairs(goatdata) do
	goatqs[i] = Turbine.UI.Lotro.Quickslot();
	goatqs[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( 6.0, goatdata[i] ) );
end

leftqs = Turbine.UI.Lotro.Quickslot();
leftqs:SetParent( leftWindow );
leftqs:SetPosition( 0, 0 );
leftqs:SetSize( 35, 35 );
leftqs:SetAllowDrop(false);

centerqs = Turbine.UI.Lotro.Quickslot();
centerqs:SetParent( centerWindow );
centerqs:SetPosition( 0, 0 );
centerqs:SetSize( 35, 35 );
centerqs:SetAllowDrop(false);

rightqs = Turbine.UI.Lotro.Quickslot();
rightqs:SetParent( rightWindow );
rightqs:SetPosition( 0, 0 );
rightqs:SetSize( 35, 35 );
rightqs:SetAllowDrop(false);

qs1 = settings.qs1;
qs2 = settings.qs2;
qs3 = settings.qs3;
cqs1 = settings.cqs1;
cqs2 = settings.cqs2;
cqs3 = settings.cqs3;

goat = settings.goat;

if (goat == false) then
	leftqs:SetShortcut(steedqs[qs1]:GetShortcut());
	centerqs:SetShortcut(steedqs[qs2]:GetShortcut());
	rightqs:SetShortcut(steedqs[qs3]:GetShortcut());
else
	leftqs:SetShortcut(goatqs[cqs1]:GetShortcut());
	centerqs:SetShortcut(goatqs[cqs2]:GetShortcut());
	rightqs:SetShortcut(goatqs[cqs3]:GetShortcut());
end

if ( settings.welcome == false ) then
	Turbine.Shell.WriteLine(" *** Welcome to Mount Stable! ***\n - To show help type /ms help");
end

MountStableCommand = Turbine.ShellCommand();

function MountStableCommand:Execute( command, arguments )
	if ( arguments == "help" ) then
		Turbine.Shell.WriteLine(" *** Mount Stable Help ***\n\n - Use the Mouse Wheel over the middle Shortcut to move the Stable\n - Right click the middle Shortcut to change between Steed and Goat Stables\n - Right click anywhere in the window to hide it. \n -Use the command '/ms' or '/mountstable' to hide or show the Plugin.\n - Use the command '/ms restore' to move the window to its default position.\n - Use the command '/ms welcomeoff' to turn off the welcome message.\n - Use the command '/ms welcomeon' to turn on the welcome message.");
	elseif ( arguments == "welcomeoff" ) then
		settings.welcome = true;
		SaveSettings();
		Turbine.Shell.WriteLine("Welcome message has been disabled");
	elseif (arguments == "welcomeon" ) then
		settings.welcome = false;
		SaveSettings();
		Turbine.Shell.WriteLine("Welcome message has been enabled");
	elseif ( arguments == "restore" ) then
		settings.positionX = ( Turbine.UI.Display.GetWidth() - mainWindow:GetWidth() - edgePadding);		
		settings.positionY = ( Turbine.UI.Display.GetHeight() - mainWindow:GetHeight() - edgePadding * 1.5 );
		mainWindow:SetPosition(settings.positionX, settings.positionY);
		SaveSettings();
		Turbine.Shell.WriteLine("Window restored to its default position");
	elseif ( arguments ~= nil ) then
		mainWindow:SetVisible( not mainWindow:IsVisible() );
	end
end

Turbine.Shell.AddCommand( "ms;mountstable", MountStableCommand );

mainWindow.MouseEnter = function( sender, args )
	if (alwayshide == false) then
		mainWindow:SetOpacity( 0.75 );
	end

	rightWindow:SetOpacity( 0.75 );
	leftWindow:SetOpacity( 0.75 );
end

mainWindow.MouseLeave = function( sender, args )
	X, Y = mainWindow:GetPosition();

	if (alwayshide == false) then
		mainWindow:SetOpacity( 0 );
	end

	rightWindow:SetOpacity( 0.25 );
	leftWindow:SetOpacity( 0.25 );

	if ( X ~= settings.positionX or Y ~= settings.positionY ) then
			
		settings.positionX = X;
		settings.positionY = Y;
		SaveSettings();
			
	end
end

alwayshide = settings.alwayshide;

mainWindow.MouseClick = function (sender, args)
	if ( args.Button == Turbine.UI.MouseButton.Right ) then
		if (alwayshide == false ) then
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
	if ( args.Button == Turbine.UI.MouseButton.Right ) then
		if (goat == false) then
			leftqs:SetShortcut(goatqs[cqs1]:GetShortcut());
			centerqs:SetShortcut(goatqs[cqs2]:GetShortcut());
			rightqs:SetShortcut(goatqs[cqs3]:GetShortcut());
			goat = true;
		else
			leftqs:SetShortcut(steedqs[qs1]:GetShortcut());
			centerqs:SetShortcut(steedqs[qs2]:GetShortcut());
			rightqs:SetShortcut(steedqs[qs3]:GetShortcut());
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
	if ( settings.qs1 ~= qs1 or settings.cqs1 ~= cqs1 ) then
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
	if (goat == false) then
		qs1 = qs1 + 1;
		qs2 = qs2 + 1;
		qs3 = qs3 + 1;

		if (qs1 == 25) then
			qs1 = 0;
		elseif (qs2 == 25) then
			qs2 = 0;
		elseif (qs3 == 25) then
			qs3 = 0;
		end

		leftqs:SetShortcut(steedqs[qs1]:GetShortcut());
		centerqs:SetShortcut(steedqs[qs2]:GetShortcut());
		rightqs:SetShortcut(steedqs[qs3]:GetShortcut());
	else
		cqs1 = cqs1 +1;
		cqs2 = cqs2 +1;
		cqs3 = cqs3 +1;

		if (cqs1 == 5) then
			cqs1 = 0;
		elseif (cqs2 == 5) then
			cqs2 = 0;
		elseif (cqs3 == 5) then
			cqs3 = 0;
		end

		leftqs:SetShortcut(goatqs[cqs1]:GetShortcut());
		centerqs:SetShortcut(goatqs[cqs2]:GetShortcut());
		rightqs:SetShortcut(goatqs[cqs3]:GetShortcut());
	end
end

write("MountStable v"..Version.." loaded!");