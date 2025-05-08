// Max/MSP Node Script for Continuous Data Plotting using Max API
const Max = require('max-api');
const fs = require('fs');
const path = require('path');
const { createCanvas } = require('canvas');

// Ensure logs directory exists
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);

// Default filename (uses timestamp if not specified)
let plotFileName = `data_plot_${new Date().toISOString().replace(/[:.]/g, '-')}.png`;

// Initialize an empty data array
let dataArray = [];
let timeStamps = [];

// Function to generate a plot with axes and timestamps
function generatePlot() {
  const canvas = createCanvas(800, 400);
  const ctx = canvas.getContext('2d');

  ctx.fillStyle = 'white';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Draw axes
  ctx.strokeStyle = 'gray';
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(50, 10);
  ctx.lineTo(50, 380); // Y-axis
  ctx.lineTo(780, 380); // X-axis
  ctx.stroke();

  // Plot the data
  ctx.strokeStyle = 'black';
  ctx.beginPath();

  dataArray.forEach((val, index) => {
    const x = 50 + ((index / dataArray.length) * 730);
    const y = 380 - ((val / Math.max(...dataArray)) * 360);
    index === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
  });

  ctx.stroke();

  // Add timestamps on X-axis
  ctx.fillStyle = 'black';
  ctx.font = '12px Arial';
  timeStamps.forEach((time, index) => {
    if (index % Math.ceil(timeStamps.length / 10) === 0) {
      const x = 50 + ((index / timeStamps.length) * 730);
      ctx.fillText(new Date(time).toLocaleTimeString(), x, 395);
    }
  });

  const buffer = canvas.toBuffer('image/png');
  const fullPath = path.join(logsDir, plotFileName);
  fs.writeFileSync(fullPath, buffer);
  Max.post(`Plot saved to ${fullPath}\n`);
}

// Add handlers for incoming messages
Max.addHandler("val", (value) => {
  if (!isNaN(value)) {
    dataArray.push(value);
    timeStamps.push(Date.now());
  }
});

Max.addHandler("filename", (name) => {
  if (typeof name === 'string' && name.trim() !== '') {
    plotFileName = name.endsWith('.png') ? name : `${name}.png`;
    Max.post(`Plot filename set to: ${plotFileName}\n`);
  }
});

Max.addHandler("save", () => {
  generatePlot();
  Max.post('Plot generated with save command.\n');
});

Max.addHandler("clear", () => {
  dataArray = [];
  timeStamps = [];
  Max.post('Data cleared.\n');
});
