const path = require('path');
const fs = require('fs');
const { createCanvas } = require('canvas');
const Chart = require('chart.js/auto');

// Read data from stdin (received from main process)
let inputData = '';

process.stdin.on('data', (chunk) => {
	inputData += chunk;
});

function smoothData(data, windowSize = 10) {
	return data.map((_, index, arr) => {
		const start = Math.max(0, index - Math.floor(windowSize / 2));
		const end = Math.min(arr.length, index + Math.floor(windowSize / 2));
		const window = arr.slice(start, end);
		return window.reduce((sum, val) => sum + val, 0) / window.length;
	});
}

process.stdin.on('end', () => {
	const { plotPath, valData, valDevData, stepsData, stepsDevData, timeStamps, sensorType } = JSON.parse(inputData);

	try {
		const plotDir = path.dirname(plotPath);
		const plotFilename = path.basename(plotPath);
		const oldPlotPattern = /^Unknown_.*\.png$/;

		// Delete old plot files
		const files = fs.readdirSync(plotDir);
		const isOldPattern = oldPlotPattern.test(plotFilename);

		if (!isOldPattern) {
			files.forEach(file => {
				if (oldPlotPattern.test(file)) {
					const oldFilePath = path.join(plotDir, file);
					fs.unlinkSync(oldFilePath);
				}
			});
		}

		const canvas = createCanvas(1600, 3200);
		const ctx = canvas.getContext('2d');
		ctx.fillStyle = 'white';
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		const valColor = sensorType === 'emg' ? 'rgba(255, 108, 131, 1)' : 'rgba(216, 196, 91, 1)';
		const valDevColor = 'rgba(255, 0, 0, 1)';
		const stepsColor = 'rgba(108, 131, 255, 1)';
		const stepsDevColor = 'rgba(109, 215, 255, 1)';

		const labels = sensorType === 'emg' ? ['EMG', 'EMG Deviation'] : ['Goniometer', 'Goniometer Deviation'];

		const smoothedValData = smoothData(valData, 10);
		const smoothedValDevData = smoothData(valDevData, 10);
		const smoothedStepsData = smoothData(stepsData, 10);
		const smoothedStepsDevData = smoothData(stepsDevData, 10);

		[labels[0], labels[1], 'Steps/Min', 'Steps/Min Deviation'].forEach((label, index) => {
			const data = [smoothedValData, smoothedValDevData, smoothedStepsData, smoothedStepsDevData][index];
			const color = [valColor, valDevColor, stepsColor, stepsDevColor][index];

			const tempCanvas = createCanvas(1600, 800);
			const tempCtx = tempCanvas.getContext('2d');

			const yMin = (label.includes('Deviation')) ? (label.includes('Steps') ? Math.min(...data) : -1) : (label.includes('Steps') ? 0 : (sensorType === 'emg' ? 0 : Math.min(...data)));
			const yMax = (label.includes('Deviation')) ? (label.includes('Steps') ? Math.max(...data) : 1) : (label.includes('Steps') ? Math.max(...data) : (sensorType === 'emg' ? 100 : Math.max(...data)));
			
			const maxLabels = 12; // Max number of labels on the X-axis
			const step = Math.ceil(timeStamps.length / maxLabels);

			const spacedTimeStamps = timeStamps
			.map(ts => new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' }))
			.map((label, index) => (index % step === 0 ? label : ''));

			new Chart(tempCtx, {
				type: 'line',
				data: {
					labels: spacedTimeStamps,
					datasets: [{
						label,
						data,
						borderColor: color,
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
								autoSkip: false
							}
						},
						y: {
							min: yMin, 
							max: yMax,
							title: {
								display: true,
								text: label.includes('Deviation') ? 'Deviation' :
								label.includes('Steps') ? 'Steps/Min' :
								(sensorType === 'emg' ? 'Percentage (%)' : 'Angle (°)')
							}
						}
					}
				}
			});

			ctx.drawImage(tempCanvas, 0, index * 800);
		});

		const buffer = canvas.toBuffer('image/png');
		fs.writeFileSync(plotPath, buffer);
		process.exit(0);
	} catch (error) {
		console.error("Plot Worker Error:", error);
		process.exit(1);
	}
});
