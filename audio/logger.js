// Node.js Script for MaxMSP - Convert Dictionary to Clean CSV (Fully Robust)

const path = require('path');
const fs = require('fs');
const Max = require('max-api');

let savedDict = null; // Global dictionary variable

// Function to flatten nested dictionaries
function flattenDict(dict, prefix = "") {
    let flat = {};

    for (const key in dict) {
        const value = dict[key];

        if (typeof value === 'object' && !Array.isArray(value) && value !== null) {
            const nestedFlat = flattenDict(value, prefix + key + ".");
            Object.assign(flat, nestedFlat);
        } else if (Array.isArray(value)) {
            flat[prefix + key] = value.join(";"); // Clean array
        } else {
            flat[prefix + key] = value.toString().replace(/[\[\]\{\}]/g, "").replace(/,/g, ";"); // Clean value
        }
    }

    return flat;
}

// Function to save dictionary as CSV (only when save is called)
Max.addHandler("save", (name) => {
    if (!savedDict) {
        Max.post("[ERROR] No dictionary data available to save.");
        return;
    }

    if (!name) {
        Max.post("[ERROR] No filename specified.");
        return;
    }

    // Automatically add .csv extension if missing
    if (!name.endsWith(".csv")) {
        name += ".csv";
    }

    const logsDir = path.join(__dirname, 'logs');

    // Ensure logs folder exists
    if (!fs.existsSync(logsDir)) {
        fs.mkdirSync(logsDir, { recursive: true });
        Max.post(`[INFO] Logs folder created at: ${logsDir}`);
    }

    const filePath = path.join(logsDir, name);

    const flatDict = flattenDict(savedDict);
    let csvData = "Key,Value\n";

    for (const key in flatDict) {
        const value = flatDict[key];
        csvData += `"${key}","${value}"
`;
    }

    try {
        fs.writeFileSync(filePath, csvData, 'utf8');
        Max.post(`[SUCCESS] CSV file saved at: ${filePath}`);
        Max.outlet("CSV Saved at: " + filePath);
    } catch (err) {
        Max.post(`[ERROR] Failed to save CSV: ${err.message}`);
        Max.outlet("Error: " + err.message);
    }
});

// Max Handler: Set Dictionary (this does not save immediately)
Max.addHandler("set", (dict) => {
    savedDict = dict;
    Max.post("[INFO] Dictionary data set for saving.");
});