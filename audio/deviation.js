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
		this.objectiveVal = args.length>1 ? args : args[0];
		log("#" + this.idx + " objective → " + this.objectiveVal + "\n");
	},

	// per-sensor tolerance
	tolerance: function(v) {
		this.toleranceVal = parseFloat(v);
		log("#" + this.idx + " tolerance → " + this.toleranceVal + "\n");
	},

	// start/stop min-calibration
	inputmin: function(flag) {
		flag = parseInt(flag);
		this.recordingMin = !!flag;
		if (flag) {
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
		flag = parseInt(flag);
		this.recordingMax = !!flag;
		if (flag) {
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
		if (this.recordingMin) { this.minSamples.push(v); return null; }
		if (this.recordingMax) { this.maxSamples.push(v); return null; }
		return this.compute(v);
	},

	// core compute: [ norm, measure, normDev ]
	compute: function(v) {
		var minv = this.minVal,
			maxv = this.maxVal,
			obj = this.objectiveVal,
			tol = this.toleranceVal,
			span = (maxv!==minv) ? (v - minv) / (maxv - minv) : 0,
			norm = (sensorType==="emg") ? span : span*2 - 1;

		// decide output-measure & fullRange
		var measure, fullRange;
		if (this.outMin!==null && this.outMax!==null) {
			fullRange = this.outMax - this.outMin;
			// map 0–1 span → outMin–outMax
			measure   = this.outMin + span * fullRange;
		} else {
			fullRange = (sensorType==="emg" ? 100 : angleRange);
			measure   = (sensorType==="emg")
					  ? norm * 100
					  : span * angleRange;
		}

		// deviation outside tolerance
		var rawDev     = measure - obj,
			absDev     = Math.abs(rawDev),
			outsideTol = Math.max(0, absDev - tol),
			sign       = absDev===0 ? 0 : rawDev/absDev,
			scaled     = Math.max(0, fullRange - tol),
			normDev    = (scaled>0 ? (outsideTol/scaled)*sign : 0);

		return [ norm, measure, normDev ];
	}
};

// ——— Control dispatch ———
// e.g. “objective_1 50”, “inputmin_0 1”
function anything() {
	if (inlet!==1) return;
	var parts = messagename.split("_"),
		cmd = parts[0],
		idx = parts.length>1 ? parseInt(parts[1]) : null,
		args = arrayfromargs(arguments);

	if (idx!==null) {
		var s = ensureSensor(idx);
		if (typeof s[cmd]==="function") {
			s[cmd].apply(s, args);
		} else {
			log("[Error] Sensor#" + idx + " has no method “" + cmd + "”\n");
		}
	}
}

// ——— Data inlet handlers ———
function msg_float(v) {
	if (inlet!==0) return;
	var out0 = ensureSensor(0).handleData(v);
	if (out0) {
		outlet(0, out0[0]);
		outlet(1, out0[1]); 
		outlet(2, out0[2]);
	}
}

function list() {
	if (inlet !== 0) return;
	var args = arrayfromargs(messagename, arguments),
		norms = [], measures = [], normDevs = [];

	for (var i = 0; i < args.length; i++) {
		var out = ensureSensor(i).handleData(parseFloat(args[i]));
		if (!out) continue;
		norms.push(out[0]);
		measures.push(out[1]);
		normDevs.push(out[2]);
	}

	// only output once no sensor is still calibrating
	var busy = sensors.some(function(s){
		return s.recordingMin || s.recordingMax;
	});
	if (!busy) {
		outlet(0, norms);
		outlet(1, measures);
		outlet(2, normDevs);
	}
}

// ——— Utility ———
function median(arr) {
	if (!arr.length) return 0;
	arr.sort(function(a,b){ return a - b });
	var m = Math.floor(arr.length/2);
	return (arr.length % 2) ? arr[m] : (arr[m-1] + arr[m]) / 2;
}