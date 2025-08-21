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
		if (sensorType === "emg") v = this._processEMG(v, sampleRate); // EMG processing

		if (this.recordingMin) this.minSamples.push(v);
		if (this.recordingMax) this.maxSamples.push(v);
		
		return this.compute(v);
	},

	_processEMG: function(x, fs) {
			var dt = 1 / fs;

			// — 1) High‑pass @20Hz for DC‑removal —
			if (this._prevRaw === undefined) this._prevRaw  = x;
			if (this._hpPrev === undefined) this._hpPrev   = 0;
			var rc_hp = 1 / (2 * Math.PI * 20);
			var α_hp = rc_hp / (rc_hp + dt);
			var hp = α_hp * (this._hpPrev + x - this._prevRaw);
			this._prevRaw = x;
			this._hpPrev = hp;

			// — 2) Low‑pass @450Hz for band‑pass completion —
			if (this._bpPrev === undefined) this._bpPrev = hp;
			var rc_lp450 = 1 / (2 * Math.PI * 450);
			var α_lp450 = dt / (rc_lp450 + dt);
			var bp = α_lp450 * hp + (1 - α_lp450) * this._bpPrev;
			this._bpPrev = bp;

			// — 3) Rectify + envelope‑smooth @40Hz —
			if (this._envPrev === undefined) this._envPrev = 0;
			var rc_lp40 = 1 / (2 * Math.PI * 40);
			var α_lp40 = dt / (rc_lp40 + dt);
			var env = α_lp40 * Math.abs(bp) + (1 - α_lp40) * this._envPrev;
			this._envPrev = env;

			// — 4) Return the envelope —
			return env;
	},

	// core compute: [ norm, measure, normDev ]
	compute: function(v) {
		var minv = this.minVal;
		var maxv = this.maxVal;

		var span = (maxv !== minv) ? (v - minv) / (maxv - minv) : 0;
		if (sensorType === "emg") span = Math.max(0, Math.min(1, span));

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
	},
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
	updateSampleRate();

	var out = ensureSensor(0).handleData(v);
	if (out) {
		if (sensorType === "emg") {
			outlet(0, Math.abs(out[0])); // norm always positive
			outlet(1, Math.abs(out[1])); // measure always positive
			outlet(2, out[2]);           // deviation can be negative
		} else {
			outlet(0, out[0]);
			outlet(1, out[1]);
			outlet(2, out[2]);
		}
	}
}

function list() {
	if (inlet !== 0) return;
	updateSampleRate();

	var args = arrayfromargs(arguments);
	var norms = [], measures = [], normDevs = [];

	for (var i = 0; i < args.length; i++) {
		var out = ensureSensor(i).handleData(parseFloat(args[i]));
		if (out) {
			if (sensorType === "emg") {
				norms.push(Math.abs(out[0]));
				measures.push(Math.abs(out[1]));
				normDevs.push(out[2]); // keep sign
			} else {
				norms.push(out[0]);
				measures.push(out[1]);
				normDevs.push(out[2]);
			}
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


// ——— Sample Rate ———
var sampleRate = 1000;

var lastTime = null;
var dtBuffer = [];
var bufferSize = 50;

function updateSampleRate() {
		var now = Date.now();
		if (lastTime) {
				var dt = now - lastTime;
				dtBuffer.push(dt);
				if (dtBuffer.length > bufferSize) dtBuffer.shift();

				if (dtBuffer.length > 0) {
						var sumDt = dtBuffer.reduce(function(a, b) {
								return a + b;
						}, 0);
						var avgDt = sumDt / dtBuffer.length;
						sampleRate = 1000 / avgDt;
				}
		}
		lastTime = now;
}