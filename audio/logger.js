const Max = require('max-api');
const path = require('path');
const fs = require('fs');

let savedDict = null; // Global dictionary variable
let savedDateTime = new Date(); // Default date time set at startup

// Utility function to escape CSV values
function escapeCSV(value) {
	return `"${String(value).replace(/"/g, '""')}"`;
}

// Utility function to detect and format date values only for specific keys
function formatDate(key, value) {
	if ((key === 'Birthday' || key === 'Date') && Array.isArray(value) && value.length === 3 && value.every(v => typeof v === 'number')) {
		return `${value[0]}-${String(value[1]).padStart(2, '0')}-${String(value[2]).padStart(2, '0')}`;
	}
	return value;
}

// Utility function to format subKey names
function formatSubKeyName(subKey) {
	return subKey.replace(/_/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
}

// Utility function to capitalize first letter of each value
function capitalizeValue(value, key = "") {
	const targetKeys = ["audiofile", "audio_player_type"];
	if (targetKeys.includes(key.toLowerCase())) return value;

	if (typeof value === 'string') {
		return value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
	} else if (Array.isArray(value)) {
		return `${value.map(v => capitalizeValue(v)).join(" | " )}`;
	}
	return value;
}

// Function to sanitize filename
function sanitizeFilename(filename) {
	const sanitized = filename.replace(/[\\/:*?"<>|]/g, "_");
	return sanitized === "_" ? "Unknown" : sanitized;
}

function generateFilename() {
	let id = savedDict?.Infos?.ID || "Unknown";
	id = sanitizeFilename(id);

	const dateTime = `${savedDateTime.getFullYear()}-${String(savedDateTime.getMonth() + 1).padStart(2, '0')}-${String(savedDateTime.getDate()).padStart(2, '0')}_${String(savedDateTime.getHours()).padStart(2, '0')}-${String(savedDateTime.getMinutes()).padStart(2, '0')}-${String(savedDateTime.getSeconds()).padStart(2, '0')}`;

	return { name: `${id}_${dateTime}`, dateTime };
}

// Function to generate CSV data from dictionary
function generateCSV(dict) {
	let csvData = "";
	for (const section in dict) {
		const subDict = dict[section];
		for (const key in subDict) {
			let value = subDict[key];
			if (typeof value === 'object' && !Array.isArray(value) && value !== null) {
				for (const subKey in value) {
					csvData += `${escapeCSV(section)},${escapeCSV(key)},${escapeCSV(formatSubKeyName(subKey))},${escapeCSV(capitalizeValue(formatDate(subKey, value[subKey]), subKey))}\n`;
				}
			} else {
				csvData += `${escapeCSV(section)},${escapeCSV(key)},${escapeCSV(capitalizeValue(formatDate(key, value), key))}\n`;
			}
		}
        csvData += "\n"; // Separate sections
    }
    return csvData;
}

// Handler to set the time
Max.addHandler("time", () => {
	savedDateTime = new Date();
});

// Handler to save dictionary as CSV
Max.addHandler("save", () => {
	if (!savedDict) return Max.post("[ERROR] No dictionary data available to save.");

	const { name, dateTime } = generateFilename();
	const logsDir = path.join(__dirname, 'logs');

	if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir, { recursive: true });

	// Remove old file with same dateTime but different ID
	const oldFile = path.join(logsDir, `Unknown_${dateTime}.csv`);
	if (fs.existsSync(oldFile) && name.split('_')[0] !== "Unknown") fs.unlinkSync(oldFile);

	const filePath = path.join(logsDir, name + '.csv');
	const csvData = generateCSV(savedDict);

	Max.outlet('filename', name);

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