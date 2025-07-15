autowatch = 1;

inlets = 2; // 0: raw data or list, 1: control cmds
outlets = 3; // 0: normalized, 1: measure, 2: normalized deviation

// ——— Logging ———
var printEnabled = false;
function log(msg) {
	if (printEnabled) post(msg);
}

// ——— Global settings ———
var sensorType = "emg";
var angleRange = 180;

function sensortype(t) {
	sensorType = t;
	log("[Global] sensorType → " + t + "\n");
}

function setanglerange(v) {
	angleRange = parseFloat(v);
	log("[Global] angleRange → " + angleRange + "°\n");
}

// ——— Sensor class ———
var sensors = [];

function ensureSensor(idx) {
	if (!sensors[idx]) sensors[idx] = new Sensor(idx);
	return sensors[idx];
}

function Sensor(idx) {
	this.idx = idx;
	this.minVal = 0; // calibrated input min
	this.maxVal = 1; // calibrated input max
	this.outMin = null; // desired output at minVal
	this.outMax = null; // desired output at maxVal
	this.objectiveVal = 0;
	this.toleranceVal = 0;
	this.recordingMin = false;
	this.recordingMax = false;
	this.minSamples = [];
	this.maxSamples = [];
}

Sensor.prototype = {
	// per-sensor objective
	objective: function() {
		var args = arrayfromargs(arguments).map(parseFloat);
		this.objectiveVal = (args.length > 1) ? args : args[0];
		log("#" + this.idx + " objective → " + this.objectiveVal + "\n");
	},

	// per-sensor tolerance
	tolerance: function(v) {
		this.toleranceVal = parseFloat(v);
		log("#" + this.idx + " tolerance → " + this.toleranceVal + "\n");
	},

	// start/stop min-calibration
	inputmin: function(flag) {
		this.recordingMin = !!parseInt(flag);
		if (this.recordingMin) {
			this.minSamples = [];
			log("#" + this.idx + " START MIN rec\n");
		} else {
			this.minVal = median(this.minSamples);
			log("#" + this.idx + " SET MIN → " + this.minVal + "\n");
			this.minSamples.length = 0;
		}
	},

	// start/stop max-calibration
	inputmax: function(flag) {
		this.recordingMax = !!parseInt(flag);
		if (this.recordingMax) {
			this.maxSamples = [];
			log("#" + this.idx + " START MAX rec\n");
		} else {
			this.maxVal = median(this.maxSamples);
			log("#" + this.idx + " SET MAX → " + this.maxVal + "\n");
			this.maxSamples.length = 0;
		}
	},

	// per-sensor output range mapping
	outputmin: function(v) {
		this.outMin = parseFloat(v);
		log("#" + this.idx + " SET OUT_MIN → " + this.outMin + "\n");
	},

	outputmax: function(v) {
		this.outMax = parseFloat(v);
		log("#" + this.idx + " SET OUT_MAX → " + this.outMax + "\n");
	},

	// process incoming raw data
	handleData: function(v) {
		if (this.recordingMin) this.minSamples.push(v);
		if (this.recordingMax) this.maxSamples.push(v);
		if (sensorType === "emg") v = Math.abs(v); // EMG values always positive
		return this.compute(v);
	},

	// core compute: [ norm, measure, normDev ]
	compute: function(v) {
		var minv = this.minVal;
		var maxv = this.maxVal;
		var span = (maxv !== minv) ? (v - minv) / (maxv - minv) : 0;
		var norm = (sensorType === "emg") ? span : span * 2 - 1;

		var useOutMap = this.outMin !== null && this.outMax !== null;
		var fullRange = useOutMap ? (this.outMax - this.outMin) : (sensorType === "emg" ? 100 : angleRange);
		var measure = useOutMap
			? this.outMin + span * fullRange
			: (sensorType === "emg" ? norm * 100 : span * angleRange);

		var rawDev = measure - this.objectiveVal;
		var absDev = Math.abs(rawDev);
		var outsideTol = Math.max(0, absDev - this.toleranceVal);
		var sign = (absDev === 0) ? 0 : rawDev / absDev;
		var scaled = Math.max(0, fullRange - this.toleranceVal);
		var normDev = (scaled > 0) ? (outsideTol / scaled) * sign : 0;

		return [norm, measure, normDev];
	}
};

// ——— Control dispatch ———
// e.g. “objective_1 50”, “inputmin_0 1”
function anything() {
	if (inlet !== 1) return;

	var parts = messagename.split("_");
	var cmd = parts[0];
	var idx = (parts.length > 1) ? parseInt(parts[1]) : null;
	var args = arrayfromargs(arguments);

	if (idx !== null) {
		var sensor = ensureSensor(idx);
		if (typeof sensor[cmd] === "function") {
			sensor[cmd].apply(sensor, args);
		} else {
			log("[Error] Sensor#" + idx + " has no method “" + cmd + "”\n");
		}
	}
}

// ——— Data inlet handlers ———
function msg_float(v) {
	if (inlet !== 0) return;
	var out = ensureSensor(0).handleData(v);
	if (out) {
		outlet(0, out[0]);
		outlet(1, out[1]);
		outlet(2, out[2]);
	}
}

function list() {
	if (inlet !== 0) return;
	var args = arrayfromargs(arguments);
	var norms = [], measures = [], normDevs = [];

	for (var i = 0; i < args.length; i++) {
		var out = ensureSensor(i).handleData(parseFloat(args[i]));
		if (out) {
			norms.push(out[0]);
			measures.push(out[1]);
			normDevs.push(out[2]);
		}
	}

	outlet(0, norms);
	outlet(1, measures);
	outlet(2, normDevs);
}

// ——— Utility ———
function median(arr) {
	if (!arr.length) return 0;
	arr.sort(function(a, b) { return a - b; });
	var m = Math.floor(arr.length / 2);
	return (arr.length % 2) ? arr[m] : (arr[m - 1] + arr[m]) / 2;
}