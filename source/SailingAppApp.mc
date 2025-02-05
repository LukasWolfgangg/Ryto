import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.FitContributor;
import Toybox.ActivityRecording;
import Toybox.Timer;
import Toybox.Position;
import Toybox.Sensor;

public var timer = 0;

class SailingAppApp extends Application.AppBase {
    var session;
    var view;
    var datatimer = new Timer.Timer();
    var datatimerrunning = false;
    var callbackcounter = 0;
    var sensorInfo;

    var COGField0;
    var COGField1;
    var COGField2;
    var COGField3;
    var SOGField0;
    var SOGField1;
    var SOGField2;
    var SOGField3;
    var PitchField;
    var RollField0;
    var RollField1;
    var RollField2;
    var RollField3;
    var LatField;
    var LonField;

    var COGData0 = -1;
    var COGData1 = -1;
    var COGData2 = -1;
    var COGData3 = -1;
    var SOGData0 = -1;
    var SOGData1 = -1;
    var SOGData2 = -1;
    var SOGData3 = -1;
    var PitchData = -1;
    var RollData0 = -1;
    var RollData1 = -1;
    var RollData2 = -1;
    var RollData3 = -1;
    var DegData = [-1, -1];

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        view = new SailingAppView();
        
        session = ActivityRecording.createSession({:name=>"Sailing ", :sport=>Activity.SPORT_SAILING});
        session.start();
        createfields();
    
        var Sensoroptions = {
            :period => 1,               
            :accelerometer => {
                :enabled => true,
                :sampleRate => 4,
                :includePitch => true,
                :includeRoll => true      
            }
        };

        var Posoptions = {
            :acquisitionType => Position.LOCATION_CONTINUOUS
        };
       
        Sensor.registerSensorDataListener(method(:collecttimer), Sensoroptions);
        Position.enableLocationEvents(Posoptions, method(:location_data));
    }

    function collecttimer(data as $.Toybox.Sensor.SensorData) as Void {
        timer += 1;
        view.update();
        collect_data(data);
        if (datatimerrunning == false) {
            datatimer.start(method(:collect_2data), 250, true);
            datatimerrunning = true;
        }
        set_data(DegData);
    }

    function location_data(data as $.Toybox.Position.Info) as Void{
        DegData = data.position.toDegrees();
    }

    function collect_data(data as $.Toybox.Sensor.SensorData) as Void {
        PitchData = data.accelerometerData.pitch[0];
        RollData0 = data.accelerometerData.roll[0];
        RollData1 = data.accelerometerData.roll[1];
        RollData2 = data.accelerometerData.roll[2];
        RollData3 = data.accelerometerData.roll[3];
    }

    function collect_2data() as Void {
        sensorInfo = Sensor.getInfo() as $.Toybox.Sensor.Info;

        if (callbackcounter==0) {
            COGData0 = sensorInfo.heading;
            SOGData0 = sensorInfo.speed;
        }
        if (callbackcounter==1) {
            COGData1 = sensorInfo.heading;
            SOGData1 = sensorInfo.speed;
        }
        if (callbackcounter==2) {
            COGData2 = sensorInfo.heading;
            SOGData2 = sensorInfo.speed;
        }
        if (callbackcounter==3) {
            COGData3 = sensorInfo.heading;
            SOGData3 = sensorInfo.speed;
            callbackcounter = -1;
        }
        callbackcounter = callbackcounter + 1;
        sensorInfo = null;
    }

    function set_data(tmp as Array<Float>) as Void {
        var degdata = tmp;
        if (COGData0 != null and COGData1 != null and COGData2 != null and COGData3 != null) {
            COGField0.setData(COGData0);
            COGField1.setData(COGData1);
            COGField2.setData(COGData2);
            COGField3.setData(COGData3);
        }
        else{
            COGField0.setData(-1);
            COGField1.setData(-1);
            COGField2.setData(-1);
            COGField3.setData(-1);  
        }

        if (SOGData0 != null and SOGData1 != null and SOGData2 != null and SOGData3 != null) {
            SOGField0.setData(SOGData0);
            SOGField1.setData(SOGData1);
            SOGField2.setData(SOGData2);
            SOGField3.setData(SOGData3);
        }
        else{
            SOGField0.setData(-1);
            SOGField1.setData(-1);
            SOGField2.setData(-1);
            SOGField3.setData(-1);
        }

        if (PitchData != null) {
            PitchField.setData(PitchData);
        }
        else {
            PitchField.setData(-1);
        }

        if (RollData0 != null and RollData1 != null and RollData2 != null and RollData3 != null) {
            RollField0.setData(RollData0);
            RollField1.setData(RollData1);
            RollField2.setData(RollData2);
            RollField3.setData(RollData3);
        }
        else {
            RollField0.setData(-1);
            RollField1.setData(-1);
            RollField2.setData(-1);
            RollField3.setData(-1);
        }

        if (degdata != [-1,-1] and degdata != [null, null] and degdata != null) {
            LatField.setData(degdata[0]);
            LonField.setData(degdata[1]);
        } else {
            LatField.setData(-1);
            LonField.setData(-1);
        }
    }

    function createfields() as Void {
        COGField0 = session.createField("COG0", 2, FitContributor.DATA_TYPE_FLOAT, {});
        COGField1 = session.createField("COG1", 3, FitContributor.DATA_TYPE_FLOAT, {});
        COGField2 = session.createField("COG2", 4, FitContributor.DATA_TYPE_FLOAT, {});
        COGField3 = session.createField("COG3", 5, FitContributor.DATA_TYPE_FLOAT, {});

        SOGField0 = session.createField("SOG0", 7, FitContributor.DATA_TYPE_FLOAT, {});
        SOGField1 = session.createField("SOG1", 8, FitContributor.DATA_TYPE_FLOAT, {});
        SOGField2 = session.createField("SOG2", 9, FitContributor.DATA_TYPE_FLOAT, {});
        SOGField3 = session.createField("SOG3", 10, FitContributor.DATA_TYPE_FLOAT, {});

        PitchField = session.createField("Pitch", 11, FitContributor.DATA_TYPE_FLOAT, {});

        RollField0 = session.createField("Roll0", 12, FitContributor.DATA_TYPE_FLOAT, {});
        RollField1 = session.createField("Roll1", 13, FitContributor.DATA_TYPE_FLOAT, {});
        RollField2 = session.createField("Roll2", 14, FitContributor.DATA_TYPE_FLOAT, {});
        RollField3 = session.createField("Roll3", 15, FitContributor.DATA_TYPE_FLOAT, {});

        LatField = session.createField("Lat", 16, FitContributor.DATA_TYPE_FLOAT, {});
        LonField = session.createField("Lon", 17, FitContributor.DATA_TYPE_FLOAT, {});

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        datatimer.stop();
        session.stop();
        session.save();
        Sensor.unregisterSensorDataListener(); 
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new SailingAppView(), new SailingAppDelegate() ];
    }
}

function getApp() as SailingAppApp {
    return Application.getApp() as SailingAppApp;
}