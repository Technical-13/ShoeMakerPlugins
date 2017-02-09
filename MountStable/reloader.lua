import "Turbine.UI";

Name = "MountStable"

ReloadMountStable = Turbine.UI.Control();
ReloadMountStable:SetWantsUpdates( true );

ReloadMountStable.Update = function( sender, args )
	ReloadMountStable:SetWantsUpdates( false );
	Turbine.PluginManager.UnloadScriptState( Name );
	Turbine.PluginManager.LoadPlugin( Name );
	Turbine.Shell.WriteLine( Name.." has been reloaded." );
end