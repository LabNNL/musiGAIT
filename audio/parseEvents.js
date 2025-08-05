autowatch = 1;

// outlet 0 = connected flag, outlet 1 = analyzer data
outlets = 2;

function anything() {
	var inJSON = arrayfromargs(messagename, arguments).join(" ");
	var data;

	try {
		data = JSON.parse(inJSON);
	} catch (e) {
		post("JSON parse error in analyzerParse.js:", e.message, "\n");
		return;
	}

	// 1) output connected_devices flag on outlet 0
	var devices = data.connected_devices || {};
	var hasConnected = 0;
	for (var devName in devices) {
		if (devices[devName].is_connected) {
			hasConnected = 1;
			break;
		}
	}
	outlet(0, hasConnected);

	// 2) iterate analyzers and output data on outlet 1
	var analyzers = data.connected_analyzers || {};
	for (var name in analyzers) {
		var cfg = analyzers[name].configuration;
		var lr  = cfg.learning_rate;
		var events = cfg.events || [];
		
		// derive "left" or "right" from analyzer name
		var side = name.split("_").pop();
		for (var i = 0; i < events.length; i++) {
			var startArr = events[i].start_when || [];
			
			for (var j = 0; j < startArr.length; j++) {
				var sw = startArr[j];
				outlet(1, side, sw.channel + 1, sw.value, lr);
			}
		}
	}
}
