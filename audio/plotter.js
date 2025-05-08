const Max = require('max-api');
const path = require('path');
const fs = require('fs');

const { createCanvas } = require('canvas');
const Chart = require('chart.js/auto');

// Ensure logs directory exists
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);

// Default filename (uses timestamp if not specified)
let plotFileName = `data_plot_${new Date().toISOString().replace(/[:.]/g, '-')}.png`;
let dataLogFile = path.join(logsDir, 'data_log.json');

// Initialize data arrays
let valData = [];
let valDevData = [];
let stepsData = [];
let stepsDevData = [];
let timeStamps = [];
let sensorType = 'emg'; // Default sensor type

// Function to save data to disk
function saveDataToDisk() {
	const data = { valData, valDevData, stepsData, stepsDevData, timeStamps, sensorType };
	fs.writeFileSync(dataLogFile, JSON.stringify(data, null, 2));
}

// Function to generate the plot
function generatePlot() {
	const plotPath = path.join(logsDir, plotFileName);

	// Remove old file with same dateTime but different ID
	const baseName = plotFileName.match(/\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}/)?.[0];
	const files = fs.readdirSync(logsDir);
	files.forEach(file => {
		if (baseName && file === `Unknown_${baseName}.png`) {
			fs.unlinkSync(path.join(logsDir, file));
		}
	});

	const canvas = createCanvas(1600, 3200);
	const ctx = canvas.getContext('2d');

	ctx.fillStyle = 'white';
	ctx.fillRect(0, 0, canvas.width, canvas.height);

	const valColor = sensorType === 'emg' ? 'rgba(255, 108, 131, 1)' : 'rgba(216, 196, 91, 1)';
	const valDevColor = 'rgba(255, 0, 0, 1)';
	const stepsColor = 'rgba(108, 131, 255, 1)';
	const stepsDevColor = 'rgba(109, 215, 255, 1)';

	[sensorType === 'emg' ? 'EMG' : 'Goniometer', sensorType === 'emg' ? 'EMG Deviation' : 'Goniometer Deviation', 'Steps/Min', 'Steps/Min Deviation'].forEach((label, index) => {
		const data = [valData, valDevData, stepsData, stepsDevData][index];
		const color = [valColor, valDevColor, stepsColor, stepsDevColor][index];

		const tempCanvas = createCanvas(1600, 800);
		const tempCtx = tempCanvas.getContext('2d');

		let yMin = undefined;
		let yMax = undefined;

		if (label === 'Steps/Min Deviation') {
			yMin = Math.min(...data);
			yMax = Math.max(...data);
		} else if (label === (sensorType === 'emg' ? 'EMG Deviation' : 'Goniometer Deviation')) {
			if (sensorType === 'emg') {
				yMin = -100;
				yMax = 100;
			} else {
				yMin = -180;
				yMax = 180;
			}
		} else if (label.includes('Steps')) {
			yMin = 0;
			yMax = Math.max(...data);
		} else {
			if (sensorType === 'emg') {
				yMin = 0;
				yMax = 100;
			} else {
				yMin = -180;
				yMax = 180;
			}
		}

		new Chart(tempCtx, {
			type: 'line',
			data: {
				labels: timeStamps.map(ts => new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })),
				datasets: [{
					label: label,
					data: data,
					borderColor: color,
					backgroundColor: color.replace('1)', '0.2)'),
					borderWidth: 2,
					tension: 0.1
				}]
			},
			options: {
				responsive: false,
				maintainAspectRatio: false,
				scales: {
					x: { title: { display: true, text: 'Time' }, ticks: { maxTicksLimit: 10, autoSkip: true } },
					y: {
						title: {
							display: true,
							text: label.includes('Deviation') ? 'Deviation' : (label.includes('Steps') ? 'Steps/Min' : (sensorType === 'emg' ? 'Percentage (%)' : 'Angle (°)'))
						},
						min: yMin,
						max: yMax
					}
				}
			}
		});

		ctx.drawImage(tempCanvas, 0, index * 800);
	});

	const buffer = canvas.toBuffer('image/png');
	fs.writeFileSync(plotPath, buffer);
}

// Handler for setting filename
Max.addHandler('filename', (name) => {
	if (typeof name === 'string' && name.trim()) {
		if (!name.endsWith('.png')) name += '.png';
		plotFileName = name;
	}
});

// Handler for synchronized values
Max.addHandler("values", (val, valDev, steps, stepsDev) => {
	if ([val, valDev, steps, stepsDev].every(v => !isNaN(v))) {
		valData.push(val);
		valDevData.push(valDev);
		stepsData.push(steps);
		stepsDevData.push(stepsDev);
		timeStamps.push(new Date().toISOString());

		if (valData.length % 1000 === 0) saveDataToDisk();
	}
});

Max.addHandler("sensor_type", (type) => {
	if (typeof type === 'string') sensorType = type.toLowerCase();
	Max.post(`Sensor type set to: ${sensorType}\n`);
});

Max.addHandler("save", () => {
	try {
		saveDataToDisk();
		generatePlot();
	} catch (err) {
		Max.post(`Error generating plot: ${err}\n`);
	}
});
