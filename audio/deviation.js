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

	this.euro = {
		minCutoff: 3.0,
		beta: 0.02,
		dCutoff: 2.0,
		fixedDt: 0.0,
		xS: null,
		dxS: null,
		prevX: null,
		tLast: null
	};

	// Prefilter config/states
	this.fs = 0;
	this.enableNotch = false;
	this.enableHP = false;
	this.enableLP = false;

	this.notchFreq = 60;
	this.notchQ = 30;
	this.hpCut = 20; // Hz
	this.lpCut = 150; // Hz

	// biquad states: [b0,b1,b2,a1,a2, z1,z2]
	this._bqNotch = null;
	this._bqHP = null;
	this._bqLP = null;
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
			// EMG: baseline ~ low percentile or trimmed mean of abs()
			this.minVal = (sensorType === "emg")
				? quantile(this.minSamples, 0.10) // 10th percentile
				: median(this.minSamples);

			log("#" + this.idx + " SET MIN → " + this.minVal + "\n");
			this.minSamples.length = 0;
			if (this.maxVal < this.minVal) { var t = this.minVal; this.minVal = this.maxVal; this.maxVal = t; }
			if ((this.maxVal - this.minVal) < 1e-9) this.maxVal = this.minVal + 1e-3;
		}
	},

	// start/stop max-calibration
	inputmax: function(flag) {
		this.recordingMax = !!parseInt(flag);
		if (this.recordingMax) {
			this.maxSamples = [];
			log("#" + this.idx + " START MAX rec\n");
		} else {
			// EMG: contraction ~ high percentile of abs()
			this.maxVal = (sensorType === "emg")
				? quantile(this.maxSamples, 0.90) // 90th percentile
				: median(this.maxSamples);

			log("#" + this.idx + " SET MAX → " + this.maxVal + "\n");
			this.maxSamples.length = 0;
			if (this.maxVal < this.minVal) { var t = this.minVal; this.minVal = this.maxVal; this.maxVal = t; }
			if ((this.maxVal - this.minVal) < 1e-9) this.maxVal = this.minVal + 1e-3;
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
		if (sensorType === "emg") {
			this._estimateFs();
			v = this._prefilter(v);
			v = this._processEMG(v);
			var vAbs = Math.abs(v);
			if (this.recordingMin) this.minSamples.push(vAbs);
			if (this.recordingMax) this.maxSamples.push(vAbs);
		} else {
			if (this.recordingMin) this.minSamples.push(v);
			if (this.recordingMax) this.maxSamples.push(v);
		}
		
		return this.compute(v);
	},

	_processEMG: function(v) {
		// --- OneEuro helpers
		function alpha(dt, cutoffHz) {
			var tau = 1.0 / (2 * Math.PI * cutoffHz);
			return 1.0 / (1.0 + tau / Math.max(1e-6, dt));
		}
		function nowSec() { return Date.now() * 0.001; }

		var E = this.euro;

		// dt
		var dt = (E.fixedDt > 0) ? E.fixedDt :
			(E.tLast == null ? 0.0 : Math.max(1e-3, nowSec() - E.tLast));

		// derivative
		var dx = (E.prevX == null) ? 0.0 : (v - E.prevX) / Math.max(1e-6, dt);
		E.prevX = v;

		// smooth derivative
		var aD = alpha(Math.max(1e-3, dt), E.dCutoff);
		E.dxS = (E.dxS == null) ? dx : (aD * dx + (1 - aD) * E.dxS);

		// adaptive cutoff
		var cutoff = E.minCutoff + E.beta * Math.abs(E.dxS);

		// smooth value
		var aX = alpha(Math.max(1e-3, dt), cutoff);
		E.xS = (E.xS == null) ? v : (aX * v + (1 - aX) * E.xS);

		// time update
		if (E.fixedDt <= 0) E.tLast = nowSec();

		return E.xS;
	},

	_prefilter: function(v) {
		if (this.fs <= 0) return v;

		// create/update coeffs on demand
		if (this.enableNotch && (!this._bqNotch || this._bqNotch[0] === undefined || this._bqNotch.f0 !== this.notchFreq || this._bqNotch.fs !== this.fs || this._bqNotch.Q !== this.notchQ)) {
			var c = _biquadCoeffs(this.fs, "notch", this.notchFreq, this.notchQ);
			this._bqNotch = c; this._bqNotch.fs = this.fs; this._bqNotch.f0 = this.notchFreq; this._bqNotch.Q = this.notchQ;
		}
		if (this.enableHP && (!this._bqHP || this._bqHP.f0 !== this.hpCut || this._bqHP.fs !== this.fs)) {
			var c2 = _biquadCoeffs(this.fs, "hp", this.hpCut, Math.SQRT1_2);
			this._bqHP = c2; this._bqHP.fs = this.fs; this._bqHP.f0 = this.hpCut;
		}
		if (this.enableLP && (!this._bqLP || this._bqLP.f0 !== this.lpCut || this._bqLP.fs !== this.fs)) {
			var c3 = _biquadCoeffs(this.fs, "lp", this.lpCut, Math.SQRT1_2);
			this._bqLP = c3; this._bqLP.fs = this.fs; this._bqLP.f0 = this.lpCut;
		}

		// cascade: notch -> HP -> LP
		var x = v;
		if (this.enableNotch && this._bqNotch) x = _biquadTick(x, this._bqNotch);
		if (this.enableHP    && this._bqHP)    x = _biquadTick(x, this._bqHP);
		if (this.enableLP    && this._bqLP)    x = _biquadTick(x, this._bqLP);

		return x;
	},

	_estimateFs: function() {
		var now = Date.now();
		if (this._lastTime) {
			var dtMs = now - this._lastTime; // ms since last sample
			if (dtMs > 0) {
				var estFs = 1000.0 / dtMs;
				// crude low-pass so it doesn’t jump too much
				if (!this.fs) this.fs = estFs;
				else this.fs = 0.9*this.fs + 0.1*estFs;
			}
		}
		this._lastTime = now;
	},

	// core compute: [ norm, measure, normDev ]
	compute: function(v) {
		var minv = this.minVal;
		var maxv = this.maxVal;

		var val = (sensorType === "emg") ? Math.abs(v) : v;
		var span = (maxv !== minv) ? (val - minv) / (maxv - minv) : 0;
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

function _biquadCoeffs(fs, type, f0, Q) {
	var w0 = 2*Math.PI*f0 / fs;
	var cw = Math.cos(w0), sw = Math.sin(w0);
	var alpha = sw/(2*Math.max(1e-6, Q));

	var b0,b1,b2,a0,a1,a2;

	if (type === "notch") {
		b0 = 1; b1 = -2*cw; b2 = 1;
		a0 = 1 + alpha; a1 = -2*cw; a2 = 1 - alpha;
	}
	else if (type === "hp") {
		var cosw = cw;
		b0 = (1 + cosw)/2;
		b1 = -(1 + cosw);
		b2 = (1 + cosw)/2;
		a0 = 1 + alpha; a1 = -2*cosw; a2 = 1 - alpha;
	}
	else if (type === "lp") {
		var cosw2 = cw;
		b0 = (1 - cosw2)/2;
		b1 = 1 - cosw2;
		b2 = (1 - cosw2)/2;
		a0 = 1 + alpha; a1 = -2*cosw2; a2 = 1 - alpha;
	}
	else {
		return null;
	}
	// normalize
	return [b0/a0, b1/a0, b2/a0, a1/a0, a2/a0, 0, 0];
}

function _biquadTick(v, s) {
	// s = [b0,b1,b2,a1,a2, z1,z2]
	var y = s[0]*v + s[5];
	s[5] = s[1]*v - s[3]*y + s[6];
	s[6] = s[2]*v - s[4]*y;
	return y;
}

function quantile(arr, q) {
	if (!arr.length) return 0;
	var a = arr.slice().sort(function(x,y){return x-y;});
	var pos = (a.length - 1) * q;
	var base = Math.floor(pos), rest = pos - base;
	return (a[base + 1] !== undefined) ? a[base] + rest * (a[base + 1] - a[base]) : a[base];
}

function trimmedMean(arr, trimFrac) {
	if (!arr.length) return 0;
	var a = arr.slice().sort(function(x,y){return x-y;});
	var k = Math.floor(a.length * trimFrac);
	var b = a.slice(k, Math.max(k, a.length - k));
	var s = 0; for (var i=0;i<b.length;i++) s += b[i];
	return s / Math.max(1, b.length);
}
