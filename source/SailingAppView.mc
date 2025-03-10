import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.FitContributor;
import Toybox.ActivityRecording;
import Toybox.Timer;
import Toybox.Position;
import Toybox.Sensor;

class SailingAppView extends WatchUi.View {

    // Method called when SailingAppApp.mc wants to update the view
    function update() as Void {
        WatchUi.requestUpdate();
    }
    
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view using the global timer variable from SailingAppApp.mc
    function onUpdate(dc as Dc) as Void {
        var hours = Math.floor(timer / 3600);
        var minutes = Math.floor((timer % 3600) / 60);
        var seconds = Math.round(timer % 60);

        var textstring = hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");

        var timeText = View.findDrawableById("time") as WatchUi.Text;

        timeText.setText(textstring);

        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
