// Max/MSP 8 JS script for EMG or goniometer sensors
// Per-sensor calibration ONLY via inputmin_N, inputmax_N, outputmin_N, outputmax_N

inlets = 2;   // inlet 0: raw data or list, inlet 1: control cmds
outlets = 3;  // 0: normalized, 1: measure, 2: normalized deviation
autowatch = 1;

// Toggle console logging
var printEnabled = true;
function log(msg) {
    if (printEnabled) post(msg);
}

// Core parameters
var minVal       = [];     // now always arrays
var maxVal       = [];
var objectiveVal = 0.0;    // scalar or array
var sensorType   = "emg";
var angleRange   = 180;
var toleranceVal = 0.0;

// Per-sensor calibration flags & buffers
var recordingMin  = [];
var recordingMax  = [];
var perMinSamples = [];
var perMaxSamples = [];

// Control functions (inlet 1)
function sensortype(t) {
    sensorType = t;
    log("[sensorHandler] Sensor type → " + sensorType + "\n");
}
function objective() {
    var args = arrayfromargs(arguments);
    objectiveVal = (args.length>1)
        ? args.map(parseFloat)
        : parseFloat(args[0]);
    log("[sensorHandler] Objective → " + objectiveVal + "\n");
}
function setanglerange(v) {
    angleRange = parseFloat(v);
    log("[sensorHandler] Angle range → " + angleRange + "°\n");
}
function tolerance(v) {
    toleranceVal = parseFloat(v);
    log("[sensorHandler] Tolerance → " + toleranceVal + "\n");
}

// --- Per-sensor helpers ---
function _inputminFor(idx, flag) {
    flag = parseInt(flag);
    if (flag) {
        recordingMin[idx]   = true;
        perMinSamples[idx]  = [];
        log("[#" + idx + "] START MIN rec\n");
    } else {
        recordingMin[idx] = false;
        var med = median(perMinSamples[idx]||[]);
        minVal[idx] = med;
        delete perMinSamples[idx];
        log("[#" + idx + "] SET MIN → " + med + "\n");
    }
}
function _inputmaxFor(idx, flag) {
    flag = parseInt(flag);
    if (flag) {
        recordingMax[idx]   = true;
        perMaxSamples[idx]  = [];
        log("[#" + idx + "] START MAX rec\n");
    } else {
        recordingMax[idx] = false;
        var med = median(perMaxSamples[idx]||[]);
        maxVal[idx] = med;
        delete perMaxSamples[idx];
        log("[#" + idx + "] SET MAX → " + med + "\n");
    }
}
function _outputminFor(idx, v) {
    v = parseFloat(v);
    minVal[idx] = v;
    log("[#" + idx + "] MANUAL MIN → " + v + "\n");
}
function _outputmaxFor(idx, v) {
    v = parseFloat(v);
    maxVal[idx] = v;
    log("[#" + idx + "] MANUAL MAX → " + v + "\n");
}

// --- Explicit entry-points for sensor 0 ---
function inputmin_0(f)  { _inputminFor(0,f); }
function inputmax_0(f)  { _inputmaxFor(0,f); }
function outputmin_0(v) { _outputminFor(0,v); }
function outputmax_0(v) { _outputmaxFor(0,v); }

// …and sensor 1 (copy for N=2,3… as needed)…
function inputmin_1(f)  { _inputminFor(1,f); }
function inputmax_1(f)  { _inputmaxFor(1,f); }
function outputmin_1(v) { _outputminFor(1,v); }
function outputmax_1(v) { _outputmaxFor(1,v); }

// Utility
function median(arr) {
    if (!arr || !arr.length) return 0;
    arr.sort(function(a,b){return a-b;});
    var m = Math.floor(arr.length/2);
    return arr.length%2 ? arr[m] : (arr[m-1]+arr[m])/2;
}

// Data inlet processing
function msg_float(v) {
    if (inlet!==0) return;
    // floats always go into compute(…,0)
    var out = compute(v,0);
    outlet(0,out[0]);
    outlet(1,out[1]);
    outlet(2,out[2]);
}

function list() {
    if (inlet!==0) return;
    var args = arrayfromargs(messagename, arguments),
        norms = [], measures = [], normDevs = [];

    for (var i=0; i<args.length; i++) {
        var v = args[i];
        if (recordingMin[i]) { perMinSamples[i].push(v); continue; }
        if (recordingMax[i]) { perMaxSamples[i].push(v); continue; }
        var out = compute(v,i);
        norms.push(out[0]);
        measures.push(out[1]);
        normDevs.push(out[2]);
    }

    var anyMin = recordingMin.some(Boolean),
        anyMax = recordingMax.some(Boolean);
    if (!anyMin && !anyMax) {
        outlet(0,norms);
        outlet(1,measures);
        outlet(2,normDevs);
    }
}

// Core compute
function compute(v,i) {
    var minv = minVal[i]!==undefined?minVal[i]:0,
        maxv = maxVal[i]!==undefined?maxVal[i]:1,
        obj  = Array.isArray(objectiveVal)?(objectiveVal[i]||0):objectiveVal,
        norm, measure;

    if (sensorType==="emg") {
        norm    = maxv!==minv?(v-minv)/(maxv-minv):0;
        measure = norm*100;
    } else {
        norm    = maxv!==minv?((v-minv)/(maxv-minv))*2-1:0;
        measure = ((v-minv)/(maxv-minv))*angleRange;
    }

    var rawDev     = measure - obj,
        absDev     = Math.abs(rawDev),
        outsideTol = Math.max(0, absDev - toleranceVal),
        sign       = rawDev===0?0:rawDev/absDev,
        fullRange  = (sensorType==="emg"?100:angleRange),
        scaled     = Math.max(0, fullRange - toleranceVal),
        normDev    = scaled>0?(outsideTol/scaled)*sign:0;

    return [norm, measure, normDev];
}
