// Max/MSP 8 JS script for EMG or goniometer sensors with calibration toggles, list support, and deviation tolerance

inlets = 2;   // inlet 0: raw sensor data or list, inlet 1: control commands
outlets = 3;  // outlet 0: normalized value(s); outlet 1: measure (EMG: percent; Goniometer: degrees); outlet 2: deviation from objective (normalized)
autowatch = 1;

// Control functions available via inlet 1:
//   sensortype "emg"|"goniometer"
//   objective <value>
//   inputmin 1|0
//   inputmax 1|0
//   outputmin <value>
//   outputmax <value>
//   setanglerange <degrees>
//   tolerance <value>

var minVal = 0.0;
var maxVal = 1.0;
var objectiveVal = 0.0;    // EMG: percent, Goniometer: degrees
var sensorType = "emg";
var angleRange = 180;       // full scale angle (degrees) for goniometer
var toleranceVal = 0.0;     // acceptable deviation in percent or degrees

var recordingMin = false;
var recordingMax = false;
var minArray = [];
var maxArray = [];
var minArrays = [];
var maxArrays = [];

function sensortype(t) {
    if (["emg","goniometer"].indexOf(t) !== -1) {
        sensorType = t;
        post("[sensorHandler] Sensor type set to " + sensorType + "\n");
    } else post("[sensorHandler] Unknown sensor type: " + t + "\n");
}

function objective(v) {
    objectiveVal = parseFloat(v);
    post("[sensorHandler] Objective set to " + objectiveVal + "\n");
}

function setanglerange(v) {
    angleRange = parseFloat(v);
    post("[sensorHandler] Angle range set to " + angleRange + " degrees\n");
}

function tolerance(v) {
    toleranceVal = parseFloat(v);
    post("[sensorHandler] Tolerance set to " + toleranceVal + "\n");
}

function inputmin(v) {
    v = parseInt(v);
    if (v === 1) {
        recordingMin = true;
        minArray = [];
        minArrays = [];
        post("[sensorHandler] Started recording MIN samples\n");
    } else if (v === 0) {
        recordingMin = false;
        if (minArrays.length > 0) {
            var medians = minArrays.map(median);
            minVal = medians;
            minArrays = [];
            post("[sensorHandler] Calibrated MIN per sensor = " + medians + "\n");
        } else {
            minVal = median(minArray);
            minArray = [];
            post("[sensorHandler] Calibrated MIN = " + minVal + "\n");
        }
    }
}

function inputmax(v) {
    v = parseInt(v);
    if (v === 1) {
        recordingMax = true;
        maxArray = [];
        maxArrays = [];
        post("[sensorHandler] Started recording MAX samples\n");
    } else if (v === 0) {
        recordingMax = false;
        if (maxArrays.length > 0) {
            var medians = maxArrays.map(median);
            maxVal = medians;
            maxArrays = [];
            post("[sensorHandler] Calibrated MAX per sensor = " + medians + "\n");
        } else {
            maxVal = median(maxArray);
            maxArray = [];
            post("[sensorHandler] Calibrated MAX = " + maxVal + "\n");
        }
    }
}

function outputmin(v) {
    minVal = parseFloat(v);
    post("[sensorHandler] MIN manually set to " + minVal + "\n");
}

function outputmax(v) {
    maxVal = parseFloat(v);
    post("[sensorHandler] MAX manually set to " + maxVal + "\n");
}

function median(arr) {
    if (arr.length === 0) return 0;
    arr.sort(function(a,b){return a-b;});
    var mid = Math.floor(arr.length / 2);
    return (arr.length % 2) ? arr[mid] : (arr[mid-1] + arr[mid]) / 2;
}

function absVal(x) {
    return x < 0 ? -x : x;
}

function signVal(x) {
    return x > 0 ? 1 : (x < 0 ? -1 : 0);
}

function msg_float(v) {
    if (inlet !== 0) return;
    if (recordingMin) {
        minArray.push(v);
    } else if (recordingMax) {
        maxArray.push(v);
    } else {
        var out = compute(v, 0);
        outlet(0, out[0]);
        outlet(1, out[1]);
        outlet(2, out[2]);
    }
}

function list() {
    if (inlet !== 0) return;
    var args = arrayfromargs(messagename, arguments);
    var norms = [];
    var measures = [];
    var deviations = [];

    if (recordingMin && minArrays.length === 0) {
        for (var i = 0; i < args.length; i++) minArrays.push([]);
    }
    if (recordingMax && maxArrays.length === 0) {
        for (var i = 0; i < args.length; i++) maxArrays.push([]);
    }

    for (var i = 0; i < args.length; i++) {
        var v = args[i];
        if (recordingMin) {
            minArrays[i].push(v);
        } else if (recordingMax) {
            maxArrays[i].push(v);
        } else {
            var out = compute(v, i);
            norms.push(out[0]);
            measures.push(out[1]);
            deviations.push(out[2]);
        }
    }

    if (!recordingMin && !recordingMax) {
        outlet(0, norms);
        outlet(1, measures);
        outlet(2, deviations);
    }
}

function compute(v, i) {
    var minv = Array.isArray(minVal) ? minVal[i] : minVal;
    var maxv = Array.isArray(maxVal) ? maxVal[i] : maxVal;
    var norm, measure, rawDev, devNorm;
    if (sensorType === "emg") {
        norm = (maxv !== minv) ? (v - minv) / (maxv - minv) : 0;
        measure = norm * 100;
        rawDev = measure - objectiveVal;
        var maxDevRange = 100 - toleranceVal;
        devNorm = (maxDevRange > 0) ? rawDev / maxDevRange : 0;
    } else {
        norm = (maxv !== minv) ? ((v - minv) / (maxv - minv)) * 2 - 1 : 0;
        measure = ((v - minv) / (maxv - minv)) * angleRange;
        rawDev = measure - objectiveVal;
        var maxDevRange = angleRange - toleranceVal;
        devNorm = (maxDevRange > 0) ? rawDev / maxDevRange : 0;
    }
    return [norm, measure, devNorm];
}
