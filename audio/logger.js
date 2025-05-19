const Max = require('max-api');
const path = require('path');
const fs = require('fs');

let savedDict = null;
let savedDateTime = new Date();

let realtimeCsvFilePath = null;
let isRealtimeFileInitialized = false;
let lastLoggedSensorConfig = null;

let currentSensorType = null;
let enabledSensors = [1, 1, 1, 1, 1];

let stats = {
	valDev: { count: 0, mean: 0, M2: 0 },
	stepsDev: { count: 0, mean: 0, M2: 0 }
};

// Escape CSV values
function escapeCSV(value) {
	return `"${String(value).replace(/"/g, '""')}"`;
}

// Format date values only for specific keys
function formatDate(key, value) {
	if ((key === 'Birthday' || key === 'Date') && Array.isArray(value) && value.length === 3 && value.every(v => typeof v === 'number')) {
		return `${value[0]}-${String(value[1]).padStart(2, '0')}-${String(value[2]).padStart(2, '0')}`;
	}
	return value;
}

// Format subKey names
function formatSubKeyName(subKey) {
	return subKey.replace(/_/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
}

// Capitalize first letter of each value
function capitalizeValue(value, key = "") {
	const targetKeys = ["diagnostic", "id", "audiofile", "audio_player_type"];

	// Directly return value for target keys
	if (targetKeys.includes(key.toLowerCase())) return value;

	// Handle string values
	if (typeof value === 'string') {
		return value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
	}

	// Handle arrays
	if (Array.isArray(value)) {
		return value.map(v => typeof v === 'number' ? parseFloat(v.toFixed(3)) : capitalizeValue(v)).join(" | ");
	}

	// Handle numbers (including floats)
	if (typeof value === 'number') {
		return parseFloat(value.toFixed(3));
	}

	// Return value as-is for other types
	return value;
}

// Sanitize filename
function sanitizeFilename(filename) {
	const sanitized = filename.replace(/[\\/:*?"<>|]/g, "_");
	return sanitized === "_" ? "Unknown" : sanitized;
}

// Generate filename
function generateFilename() {
	let id = savedDict?.Infos?.ID || "Unknown";
	id = sanitizeFilename(id);
	const dateTime = `${savedDateTime.getFullYear()}-${String(savedDateTime.getMonth() + 1).padStart(2, '0')}-${String(savedDateTime.getDate()).padStart(2, '0')}_${String(savedDateTime.getHours()).padStart(2, '0')}-${String(savedDateTime.getMinutes()).padStart(2, '0')}-${String(savedDateTime.getSeconds()).padStart(2, '0')}`;
	return { name: `${id}_${dateTime}`, dateTime };
}

// Generate CSV data from dictionary
function generateCSV(dict) {
	let csvData = "\uFEFFsep=;\n"; // BOM + Excel delimiter hint
	const delimiter = ";";
	
	for (const section in dict) {
		const subDict = dict[section];
		for (const key in subDict) {
			let value = subDict[key];
			if (typeof value === 'object' && !Array.isArray(value) && value !== null) {
				for (const subKey in value) {
					csvData += `${escapeCSV(section)}${delimiter}${escapeCSV(key)}${delimiter}${escapeCSV(formatSubKeyName(subKey))}${delimiter}${escapeCSV(capitalizeValue(formatDate(subKey, value[subKey]), subKey))}\n`;
				}
			} else {
				csvData += `${escapeCSV(section)}${delimiter}${escapeCSV(key)}${delimiter}${escapeCSV(capitalizeValue(formatDate(key, value), key))}\n`;
			}
		}
		csvData += "\n"; // Separate sections
	}
	return csvData;
}

// Realtime CSV Logging
function logRealtimeData(timestamp, cycle, val, valDev, steps, stepsDev) {
	const delimiter = ";";

	const { name, dateTime } = generateFilename();
	const logsDir = path.join(__dirname, '..', 'logs');
	const newFilePath = path.join(logsDir, name + '_Sensors.csv');

	if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir, { recursive: true });

	// If filename changed, delete old file and update path
	if (realtimeCsvFilePath && realtimeCsvFilePath !== newFilePath) {
		// Try to extract the old datetime from the old file
		const oldRealtimeFile = path.join(logsDir, `Unknown_${dateTime}_Sensors.csv`);
		if (fs.existsSync(oldRealtimeFile) && name.split('_')[0] !== "Unknown") {
			fs.unlinkSync(oldRealtimeFile);
		}
		realtimeCsvFilePath = newFilePath;
	} else if (!realtimeCsvFilePath) {
		// First-time assignment
		realtimeCsvFilePath = newFilePath;
	}

	// If the sensor type has changed, insert a new header section
	if (!isRealtimeFileInitialized) {
		isRealtimeFileInitialized = true;
	}

	const labels = [
		"Foot Cycle",
		currentSensorType === "emg" ? "Force" : currentSensorType === "goniometer" ? "Angle" : "Value",
		currentSensorType === "emg" ? "Force Deviation" : currentSensorType === "goniometer" ? "Angle Deviation" : "Deviation",
		"Steps/Min",
		"Steps/Min Deviation"
	];

	const header = ["Timestamp"];
	for (let i = 0; i < 5; i++) {
		if (enabledSensors[i]) {
			header.push(labels[i]);
		}
	}
	const headerLine = header.map(escapeCSV).join(delimiter) + '\n';

	const shouldWriteHeader =
		!fs.existsSync(realtimeCsvFilePath) ||
		fs.readFileSync(realtimeCsvFilePath, 'utf8').indexOf(labels[1]) === -1 ||
		!lastLoggedSensorConfig || enabledSensors.join('') !== lastLoggedSensorConfig.join('');

	if (shouldWriteHeader) {
		const fullHeader = !fs.existsSync(realtimeCsvFilePath)
			? "\uFEFFsep=;\n" + headerLine
			: '\n' + headerLine;

		const writeMethod = !fs.existsSync(realtimeCsvFilePath) ? fs.writeFileSync : fs.appendFileSync;
		writeMethod(realtimeCsvFilePath, fullHeader, 'utf8');

		lastLoggedSensorConfig = [...enabledSensors]; // Save current config
	}

	try {
		const formatNumber = (n) => typeof n === 'number' ? n.toFixed(6) : n;
		
		const row = [timestamp];
		const values = [cycle, val, valDev, steps, stepsDev];

		for (let i = 0; i < 5; i++) {
			if (enabledSensors[i]) {
				row.push(formatNumber(values[i]));
			}
		}

		const rowLine = row.map(escapeCSV).join(delimiter) + '\n';
		fs.appendFileSync(realtimeCsvFilePath, rowLine, 'utf8');
	} catch (err) {
		Max.post(`[ERROR] Failed to save sensor data as CSV. ${err.message}`);
	}
}

// Update the current stats
function updateStats(stat, newValue) {
	stat.count += 1;
	const delta = newValue - stat.mean;
	stat.mean += delta / stat.count;
	stat.M2 += delta * (newValue - stat.mean);
}

// Get the final stats
function getFinalStats(stat) {
	const variance = stat.count > 1 ? stat.M2 / (stat.count - 1) : 0;
	return {
		mean: stat.mean,
		stdDev: Math.sqrt(variance)
	};
}

// Calculate session score
function calculateSessionScore(std, baseline = 1) {
	const maxScore = 100;
	const penalty = (std / baseline) * 50;
	return Math.max(0, parseFloat((maxScore - penalty).toFixed(2)));
}

// Handler to set the current time
Max.addHandler("time", () => {
	savedDateTime = new Date();
});

// Handler to save dictionary as CSV
Max.addHandler("save", () => {
	if (!savedDict) return Max.post("[ERROR] No dictionary data available to save.");

	const { name, dateTime } = generateFilename();
	const logsDir = path.join(__dirname, '..', 'logs');

	if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir, { recursive: true });

	// Remove old file with same dateTime but different ID
	const oldFile = path.join(logsDir, `Unknown_${dateTime}.csv`);
	if (fs.existsSync(oldFile) && name.split('_')[0] !== "Unknown") fs.unlinkSync(oldFile);

	const filePath = path.join(logsDir, name + '.csv');
	let csvData = generateCSV(savedDict);

	// Insert Score section between Infos and Logs
	let lines = csvData.trim().split('\n');
	const insertIndex = 7;
	
	const valStd = Math.sqrt(stats.valDev.count > 1 ? stats.valDev.M2 / (stats.valDev.count - 1) : 0);
	const stepsStd = Math.sqrt(stats.stepsDev.count > 1 ? stats.stepsDev.M2 / (stats.stepsDev.count - 1) : 0);

	const valScore = calculateSessionScore(valStd, 0.75);     // baseline: 0.05 for valDev
	const stepsScore = calculateSessionScore(stepsStd, 5);    // baseline: 5 for stepsDev

	// Create score section
	const scoreSection = [
		[escapeCSV("Score"), escapeCSV("Deviation (0-100)"), escapeCSV(valScore)].join(';'),
		[escapeCSV("Score"), escapeCSV("Steps/Min (0-100)"), escapeCSV(stepsScore)].join(';'),
		''
	];

	// Remove existing Score section if present
	const scoreStart = lines.findIndex(line => /^"Score";/i.test(line));
	if (scoreStart !== -1) {
		let scoreEnd = scoreStart;
		while (scoreEnd < lines.length && lines[scoreEnd].trim() !== '') {
			scoreEnd++;
		}
		lines.splice(scoreStart, scoreEnd - scoreStart + 1); // +1 to remove blank line
	}

	// Insert score section
	lines.splice(insertIndex, 0, ...scoreSection);
	
	// Rebuild CSV
	csvData = lines.join('\n');

	try {
		fs.writeFileSync(filePath, csvData, 'utf8');
	} catch (err) {
		Max.post(`[ERROR] Failed to save parameters as CSV. ${err.message}`);
	}
});

// Handler to set dictionary data
Max.addHandler("set", (dict) => {
	savedDict = dict;
	const { name, dateTime } = generateFilename();
	Max.outlet('filename', name);
});

// Handler to set realtime values
Max.addHandler("values", (cycle, val, valDev, steps, stepsDev) => {
	if ([cycle, val, valDev, steps, stepsDev].every(v => !isNaN(v))) {
		const now = new Date();
		const ms = String(now.getMilliseconds()).padStart(3, '0');
		const timestamp = now.toLocaleTimeString('en-US', { hour12: false }) + '.' + ms;
		
		logRealtimeData(timestamp, cycle, val, valDev, steps, stepsDev);

		// Update running stats
		updateStats(stats.valDev, Math.abs(valDev));
		updateStats(stats.stepsDev, Math.abs(stepsDev));
	}
});

// Handler to set current sensor type
Max.addHandler("sensor_type", (sensorType) => {
	if (typeof sensorType !== 'string') {
		return Max.post("[ERROR] 'sensor_type' must be a string.");
	}
	currentSensorType = sensorType.toLowerCase();
});

// Handler to set which sensors are enabled for logging
Max.addHandler("log_sensors", (...sensorFlags) => {
	if (sensorFlags.length !== 5 || !sensorFlags.every(v => v === 0 || v === 1)) {
		return Max.post("[ERROR] 'log_sensors' requires a list of 5 integers (0 or 1).");
	}
	enabledSensors = sensorFlags;
});