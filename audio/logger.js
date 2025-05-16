const Max = require('max-api');
const path = require('path');
const fs = require('fs');

let savedDict = null; // Global dictionary variable
let savedDateTime = new Date(); // Default date time set at startup

let realtimeCsvFilePath = null;
let isRealtimeFileInitialized = false;

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

	// Create and write header if file not initialized
	if (!isRealtimeFileInitialized) {
		const { name, dateTime } = generateFilename();
		const logsDir = path.join(__dirname, '..', 'logs');
		if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir, { recursive: true });

		// Remove old file with same dateTime but different ID
		const oldRealtimeFile = path.join(logsDir, `Unknown_${dateTime}_Sensors.csv`);
		if (fs.existsSync(oldRealtimeFile) && name.split('_')[0] !== "Unknown") {
			fs.unlinkSync(oldRealtimeFile);
		}

		realtimeCsvFilePath = path.join(logsDir, name + '_Sensors.csv');

		// Read sensor type from savedDict
		let sensorType = "unknown";
		try {
			const logs = savedDict?.Logs;
			if (logs && typeof logs === 'object') {
				for (const key in logs) {
					const entry = logs[key];
					if (entry?.["Sensor Type"]) {
						sensorType = String(entry["Sensor Type"]).toLowerCase();
					}
				}
			}
		} catch (err) {
			Max.post("[WARN] Could not determine sensor type from savedDict.Logs.");
		}

		let header;
		if (sensorType === 'emg') {
			header = ["Timestamp", "Foot Cycle", "Force", "Force Deviation", "Steps/Min", "Steps/Min Deviation"];
		} else if (sensorType === 'goniometer') {
			header = ["Timestamp", "Foot Cycle", "Angle", "Angle Deviation", "Steps/Min", "Steps/Min Deviation"];
		} else {
			header = ["Timestamp", "Foot Cycle", "Value", "Deviation", "Steps/Min", "Steps/Min Deviation"];
		}

		const headerLine = header.map(escapeCSV).join(delimiter) + '\n';
		fs.writeFileSync(realtimeCsvFilePath, "\uFEFFsep=;\n" + headerLine, 'utf8');
		isRealtimeFileInitialized = true;
	}

	try {
		const formatNumber = (n) => typeof n === 'number' ? n.toFixed(3) : n;
		const row = [
			timestamp,
			formatNumber(cycle),
			formatNumber(val),
			formatNumber(valDev),
			formatNumber(steps),
			formatNumber(stepsDev)
		].map(escapeCSV).join(delimiter) + '\n';

		fs.appendFileSync(realtimeCsvFilePath, row, 'utf8');
	} catch (err) {
		Max.post(`[ERROR] Failed to save CSV: ${err.message}`);
	}
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
	const csvData = generateCSV(savedDict);

	try {
		fs.writeFileSync(filePath, csvData, 'utf8');
	} catch (err) {
		Max.post(`[ERROR] Failed to save CSV: ${err.message}`);
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
	}
});