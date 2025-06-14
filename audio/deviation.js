// Max/MSP 8 JS script for EMG or goniometer sensors with calibration toggles, list support, and dual-objective deviations

inlets = 2;   // inlet 0: raw sensor data or list, inlet 1: control commands
outlets = 3;  // outlet 0: normalized value(s); outlet 1: measure (EMG: percent; Goniometer: degrees); outlet 2: normalized deviation(s)
autowatch = 1;

// Toggle console logging
var printEnabled = false;
function log(msg) {
	if (printEnabled) post(msg);
}

// Control functions (inlet 1):
//   sensortype "emg"|"goniometer"
//   objective <v1> [<v2>]
//   inputmin 1|0
//   inputmax 1|0
//   outputmin <value>
//   outputmax <value>
//   setanglerange <degrees>
//   tolerance <value>

var minVal = 0.0;
var maxVal = 1.0;
var objectiveVal = 0.0;    // Scalar or array for multiple objectives
var sensorType = "emg";
var angleRange = 180;
var toleranceVal = 0.0;

var recordingMin = false;
var recordingMax = false;
var minArray = [];
var maxArray = [];
var minArrays = [];
var maxArrays = [];

function sensortype(t) {
	sensorType = t;
	log("[sensorHandler] Sensor type set to " + sensorType + "\n");
}

function objective() {
	var args = arrayfromargs(arguments);
	if (args.length > 1) {
		objectiveVal = args.map(function(x){ return parseFloat(x); });
		log("[sensorHandler] Objectives set to " + objectiveVal + "\n");
	} else {
		objectiveVal = parseFloat(args[0]);
		log("[sensorHandler] Objective set to " + objectiveVal + "\n");
	}
}

function setanglerange(v) {
	angleRange = parseFloat(v);
	log("[sensorHandler] Angle range set to " + angleRange + " degrees\n");
}

function tolerance(v) {
	toleranceVal = parseFloat(v);
	log("[sensorHandler] Tolerance set to " + toleranceVal + "\n");
}

function inputmin(v) {
	v = parseInt(v);
	if (v === 1) {
		recordingMin = true; minArray = []; minArrays = [];
		log("[sensorHandler] Started recording MIN samples\n");
	} else {
		recordingMin = false;
		if (minArrays.length) {
			minVal = minArrays.map(median);
			minArrays = [];
			log("[sensorHandler] Calibrated MIN per sensor = " + minVal + "\n");
		} else {
			minVal = median(minArray);
			minArray = [];
			log("[sensorHandler] Calibrated MIN = " + minVal + "\n");
		}
	}
}

function inputmax(v) {
	v = parseInt(v);
	if (v === 1) {
		recordingMax = true; maxArray = []; maxArrays = [];
		log("[sensorHandler] Started recording MAX samples\n");
	} else {
		recordingMax = false;
		if (maxArrays.length) {
			maxVal = maxArrays.map(median);
			maxArrays = [];
			log("[sensorHandler] Calibrated MAX per sensor = " + maxVal + "\n");
		} else {
			maxVal = median(maxArray);
			maxArray = [];
			log("[sensorHandler] Calibrated MAX = " + maxVal + "\n");
		}
	}
}

function outputmin(v) {
	minVal = parseFloat(v);
	log("[sensorHandler] MIN manually set to " + minVal + "\n");
}

function outputmax(v) {
	maxVal = parseFloat(v);
	log("[sensorHandler] MAX manually set to " + maxVal + "\n");
}

function median(arr) {
	if (!arr.length) return 0;
	arr.sort(function(a,b){ return a - b; });
	var m = Math.floor(arr.length / 2);
	return (arr.length % 2) ? arr[m] : (arr[m-1] + arr[m]) / 2;
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
	var norms = [], measures = [], normDevs = [];

	if (recordingMin && !minArrays.length) for (var i = 0; i < args.length; i++) minArrays.push([]);
	if (recordingMax && !maxArrays.length) for (var i = 0; i < args.length; i++) maxArrays.push([]);

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
			normDevs.push(out[2]);
		}
	}

	if (!recordingMin && !recordingMax) {
		outlet(0, norms);
		outlet(1, measures);
		outlet(2, normDevs);
	}
}

function compute(v, i) {
	var minv = Array.isArray(minVal) ? minVal[i] : minVal;
	var maxv = Array.isArray(maxVal) ? maxVal[i] : maxVal;
	var obj = Array.isArray(objectiveVal) ? objectiveVal[i] : objectiveVal;
	
	var norm, measure;

	if (sensorType === "emg") {
		norm = (maxv !== minv) ? (v - minv) / (maxv - minv) : 0;
		measure = norm * 100; // EMG → [0..100]%
	} else {
		norm = (maxv !== minv) ? ((v - minv) / (maxv - minv)) * 2 - 1 : 0;
		measure = ((v - minv) / (maxv - minv)) * angleRange; // Gonio → [0..angleRange]°
	}

	var rawDev = measure - obj;

	var absDev = Math.abs(rawDev);
	var devOutsideTol = Math.max(0, absDev - toleranceVal);
	var sign = (rawDev === 0 ? 0 : rawDev / absDev);

	var fullRange = (sensorType === "emg" ? 100 : angleRange);
	var scaledRange = Math.max(0, fullRange - toleranceVal);

	var normDev = (scaledRange > 0) ? (devOutsideTol / scaledRange) * sign : 0;

	return [norm, measure, normDev];
}
