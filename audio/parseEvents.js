autowatch = 1;
outlets = 2;

var SIDE_RE = /(left|right)/i;
var EMG_KEY = "DelsysEmgDevice";

function anything() {
	var inJSON = arrayfromargs(messagename, arguments).join(" ");
	var data;
	try {
		data = JSON.parse(inJSON);
	} catch (e) {
		outlet(1, "[FATAL] JSON parse error in analyzerParse.js: " + e.message);
		return;
	}


	/* -------------------------- Recording -------------------------- */
	var devs = data.connected_devices || {};
	var rec = 0;

	// Prefer explicit EMG device key
	if (devs[EMG_KEY] && typeof devs[EMG_KEY].is_recording !== "undefined") {
		rec = devs[EMG_KEY].is_recording ? 1 : 0;
	} else {
		// Fallback: any device reporting is_recording = true
		for (var k in devs) {
			if (!devs.hasOwnProperty(k)) continue;
			var d = devs[k];
			if (d && d.is_recording) { rec = 1; break; }
		}
	}
	outlet(0, "record_state", rec); // 1 = recording, 0 = not recording


	/* -------------------------- Analyzers -------------------------- */
	var analyzers = data.connected_analyzers || {};
	var sides = { left: null, right: null };
	var fallback = [];

	// single pass: categorize by explicit side or fallback
	Object.keys(analyzers).forEach(function(name) {
		var m = SIDE_RE.exec(name);
		if (m) {
			sides[m[1].toLowerCase()] = name;
		} else {
			fallback.push(name);
		}
	});

	// assign any missing side from fallback
	["left", "right"].forEach(function(side) {
		if (!sides[side] && fallback.length) {
			sides[side] = fallback.shift();
		}
	});

	// log explicit vs unmatched
	var explicit = Object.keys(sides).filter(function(side) { return sides[side] && SIDE_RE.test(sides[side]); });
	if (explicit.length) outlet(1, "[INFO] Explicit analyzers found: " + explicit.join(", "));
	if (fallback.length) outlet(1, "[WARNING] Unmatched analyzers: " + fallback.join(", "));

	// process each side or emit "None"
	Object.keys(sides).forEach(function(side) {
		var name = sides[side];
		if (name) {
			outlet(1, "[INFO] Assigning analyzer '" + name + "' to side '" + side + "'");
			var cfg = (analyzers[name] || {}).configuration;
			if (!cfg || !Array.isArray(cfg.events)) {
				outlet(1, "[WARNING] No configuration/events for analyzer '" + name + "'");
				return;
			}
			// flatten all start_when entries
			var starts = cfg.events.reduce(function(acc, evt) {
				return acc.concat(evt.start_when || []);
			}, []);
			starts.forEach(function(sw) {
				outlet(0, side, sw.channel + 1, sw.value, cfg.learning_rate);
			});
		} else {
			outlet(1, "[WARNING] No " + side + " analyzer found");
			outlet(0, side, "None");
		}
	});
}
