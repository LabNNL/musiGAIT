const path = require('path');
const fs = require('fs');

const { createCanvas } = require('canvas');
const Chart = require('chart.js/auto');

// Read data from stdin (received from main process)
let inputData = '';

process.stdin.on('data', (chunk) => {
	inputData += chunk;
});

// ---------------------- DEBUG ----------------------
var lastLoggedLength = 0;
// ------------------------------------------------------

function downsampleData(data) {
	const length = data.length;
	const factor = Math.max(1, Math.floor(Math.log10(length) * 2));

	// ------------------------ DEBUG ------------------------
	if (length !== lastLoggedLength) {
		const now = new Date();
		const timestamp = `${now.toTimeString().split(' ')[0]}.${String(now.getMilliseconds()).padStart(3, '0')}`;
		// console.log(`[${timestamp}] Length changed: ${length}`);
		lastLoggedLength = length;
	}
	// ------------------------------------------------------

	const downsampled = [];
	for (let i = 0; i < length; i += factor) {
		downsampled.push(data[i]);
	}

	return downsampled;
}

function deleteOldPlot(plotPath) {
	const plotDir = path.dirname(plotPath);
	const plotFilename = path.basename(plotPath);
	const oldPlotPattern = /^Unknown_.*\.png$/;

	const files = fs.readdirSync(plotDir);
	if (!oldPlotPattern.test(plotFilename)) {
		files.forEach(file => {
			if (oldPlotPattern.test(file)) {
				fs.unlinkSync(path.join(plotDir, file));
			}
		});
	}
}

process.stdin.on('end', () => {
	const { plotPath, cycleData, valData, valDevData, stepsData, stepsDevData, timeStamps, sensorType } = JSON.parse(inputData);

	try {
		deleteOldPlot(plotPath);

		const canvas = createCanvas(1600, 4000);
		const ctx = canvas.getContext('2d', { alpha: false});
		ctx.fillStyle = 'white';
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		const xLabels = sensorType === 'emg' ? 
			['Foot Cycle', 'EMG', 'EMG Deviation', 'Steps/Min', 'Steps/Min Deviation'] : 
			['Foot Cycle', 'Goniometer', 'Goniometer Deviation', 'Steps/Min', 'Steps/Min Deviation'];

		const yLabels = sensorType === 'emg' ? 
			['Percentage (%)', 'Percentage (%)', 'Deviation', 'Steps/Min', 'Steps/Min Deviation'] : 
			['Percentage (%)', 'Angle (°)', 'Deviation', 'Steps/Min', 'Deviation'];

		const yAxisRanges = sensorType === 'emg' ? [
			{ min: 0, max: 100 },  // Foot Cycle
			{ min: 0, max: 100 },  // EMG
			{ min: -1, max: 1 },   // EMG Deviation
			{ min: 0, max: (data) => Math.max(...data) },  // Steps/Min
			{ min: (data) => Math.min(...data), max: (data) => Math.max(...data) }  // Steps/Min Deviation
		] : [
			{ min: 0, max: 100 },  // Foot Cycle
			{ min: -180, max: 180 },  // Goniometer
			{ min: -1, max: 1 },   // Goniometer Deviation
			{ min: 0, max: (data) => Math.max(...data) },  // Steps/Min
			{ min: (data) => Math.min(...data), max: (data) => Math.max(...data) }  // Steps/Min Deviation
		];

		const datasets = [cycleData, valData, valDevData, stepsData, stepsDevData].map(data => downsampleData(data));
		
		const colors = [
			'rgba(108, 131, 255, 1)',
			sensorType === 'emg' ? 'rgba(255, 108, 131, 1)' : 'rgba(216, 196, 91, 1)', 
			'rgba(255, 0, 0, 1)',
			'rgba(108, 131, 255, 1)',
			'rgba(109, 215, 255, 1)'
		];

		const downsampledTimestamps = downsampleData(timeStamps);
		
		const maxLabels = 20; // Max number of labels on the X-axis
		const step = Math.ceil(downsampledTimestamps.length / maxLabels);

		const spacedTimeStamps = downsampledTimestamps.map((ts, index) =>
			index % step === 0 
				? new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
				: ''
		);

		datasets.forEach((data, index) => {
			if (!data || data.length === 0) return;

			const tempCanvas = createCanvas(1600, 800);
			const tempCtx = tempCanvas.getContext('2d');
			
			const xLabel = xLabels[index];
			const yLabel = yLabels[index];
			
			const yMin = typeof yAxisRanges[index].min === "function" ? yAxisRanges[index].min(data) : yAxisRanges[index].min;
			const yMax = typeof yAxisRanges[index].max === "function" ? yAxisRanges[index].max(data) : yAxisRanges[index].max;

			const chart = new Chart(tempCtx, {
				type: 'line',
				data: {
					labels: spacedTimeStamps,
					datasets: [{
						label: xLabel,
						data,
						borderColor: colors[index],
						borderWidth: 2,
						fill: false,
						lineTension: 0.8,
						pointRadius: 0
					}]
				},
				options: {
					responsive: false,
					maintainAspectRatio: false,
					scales: {
						x: {
							ticks: {
								maxTicksLimit: maxLabels,
								autoSkip: true
							}
						},
						y: {
							min: yMin, 
							max: yMax,
							title: {
								display: true,
								text: yLabel,
							}
						}
					}
				}
			});

			ctx.drawImage(tempCanvas, 0, index * 800);
			chart.destroy();
		});

		const buffer = canvas.toBuffer('image/png');
		fs.writeFileSync(plotPath, buffer);
		process.exit(0);
	} catch (error) {
		console.error("Plot Worker Error:", error);
		process.exit(1);
	}
});
