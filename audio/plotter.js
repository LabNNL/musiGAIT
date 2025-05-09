const Max = require('max-api');
const path = require('path');
const fs = require('fs');

const { spawn } = require('child_process');

// Ensure logs directory exists
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);

// Default filename (uses timestamp if not specified)
let plotFileName = `data_plot_${new Date().toISOString().replace(/[:.]/g, '-')}.png`;
let dataLogFile = path.join(logsDir, 'data_log.json');

// Initialize data arrays
let cycleData = [];
let valData = [];
let valDevData = [];
let stepsData = [];
let stepsDevData = [];
let timeStamps = [];
let sensorType = 'emg'; // Default sensor type

function generatePlot() {
	const plotPath = path.join(__dirname, 'logs', plotFileName);

	const child = spawn('node', [path.join(__dirname, 'plotWorker.js'), plotPath], {
		stdio: ['pipe', 'pipe', 'pipe', 'ipc']
	});

	// Send the data as JSON through stdin
	child.stdin.write(JSON.stringify({
		plotPath,
		cycleData,
		valData,
		valDevData,
		stepsData,
		stepsDevData,
		timeStamps,
		sensorType
	}));
	child.stdin.end();

	child.stdout.on('data', (data) => {
		Max.post(`Plot Worker: ${data}`);
	});

	child.stderr.on('data', (data) => {
		Max.post(`Plot Worker Error: ${data}`);
	});

	child.on('exit', (code) => {
		if (code !== 0) {
			Max.post(`Plot Worker exited with code ${code}`);
		}
	});
}

Max.addHandler('filename', (name) => {
	if (typeof name === 'string' && name.trim()) {
		if (!name.endsWith('.png')) name += '.png';
		plotFileName = name;
	}
});

Max.addHandler("values", (cycle, val, valDev, steps, stepsDev) => {
	if ([cycle, val, valDev, steps, stepsDev].every(v => !isNaN(v))) {
		cycleData.push(cycle)
		valData.push(val);
		valDevData.push(valDev);
		stepsData.push(steps);
		stepsDevData.push(stepsDev);
		timeStamps.push(new Date().toISOString());

		if (cycleData.length % 2000 === 0) {
			generatePlot();
		}
	}
});

Max.addHandler("sensor_type", (type) => {
	if (typeof type === 'string') sensorType = type.toLowerCase();
});

Max.addHandler("save", () => {
	try {
		generatePlot();
	} catch (err) {
		Max.post(`Error saving json: ${err}\n`);
	}
});
