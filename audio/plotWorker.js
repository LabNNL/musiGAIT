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
    if (!Array.isArray(data) || data.length === 0) return [];

    let sum = 0, count = 0;
    for (let i = 0; i < data.length; i++) {
        sum += data[i];
        count++;

        if (i >= windowSize) {
            sum -= data[i - windowSize];
            count = windowSize;
        }

        data[i] = sum / count;
    }

    return data;
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
		const ctx = canvas.getContext('2d');
		ctx.fillStyle = 'white';
		ctx.fillRect(0, 0, canvas.width, canvas.height);

		const labels = sensorType === 'emg' ? 
			['Foot Cycle', 'EMG', 'EMG Deviation', 'Steps/Min', 'Steps/Min Deviation'] : 
			['Foot Cycle', 'Goniometer', 'Goniometer Deviation', 'Steps/Min', 'Steps/Min Deviation'];

		const datasets = [cycleData, valData, valDevData, stepsData, stepsDevData].map(data => smoothData(data));
		const colors = [
			'rgba(108, 131, 255, 1)',
			sensorType === 'emg' ? 'rgba(255, 108, 131, 1)' : 'rgba(216, 196, 91, 1)', 
			'rgba(255, 0, 0, 1)',
			'rgba(108, 131, 255, 1)',
			'rgba(109, 215, 255, 1)'
		];

		datasets.forEach((data, index) => {
            if (!data || data.length === 0) return;

			const tempCanvas = createCanvas(1600, 800);
			const tempCtx = tempCanvas.getContext('2d');
			const label = labels[index];
			
			const yMin = (label.includes('Deviation')) ? 
				(label.includes('Steps') ? Math.min(...data) : -1) : 
				(label.includes('Steps') ? 0 : 
					(sensorType === 'emg' ? 0 : Math.min(...data)));
			
			const yMax = (label.includes('Deviation')) ? 
				(label.includes('Steps') ? Math.max(...data) : 1) : 
				(label.includes('Steps') ? Math.max(...data) : 
					(sensorType === 'emg' ? 100 : Math.max(...data)));
			
			const maxLabels = 12; // Max number of labels on the X-axis
			const step = Math.ceil(timeStamps.length / maxLabels);

			const spacedTimeStamps = timeStamps
				.map(ts => new Date(ts).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' }))
				.map((label, index) => (index % step === 0 ? label : ''));

            ctx.clearRect(0, index * 800, 1600, 800);

			const chart = new Chart(tempCtx, {
				type: 'line',
				data: {
					labels: spacedTimeStamps,
					datasets: [{
						label: ['Foot Cycle', ...labels, 'Steps/Min', 'Steps/Min Deviation'][index],
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
