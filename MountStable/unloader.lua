import "Turbine.UI";

Name = "MountStable"

UnloadMountStable = Turbine.UI.Control();
UnloadMountStable:SetWantsUpdates( true );

UnloadMountStable.Update = function( sender, args )
	UnloadMountStable:SetWantsUpdates( false );
	Turbine.PluginManager.UnloadScriptState( Name );
	Turbine.Shell.WriteLine( Name.." has been unloaded." );
end