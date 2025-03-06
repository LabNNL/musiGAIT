// RMS Smoother
var windowSize = 10; // Default window size
var buffer = []; // Circular buffer
var index = 0;
var sumSq = 0;
var count = 0; // Warm-up tracking

for (var i = 0; i < windowSize; i++) {
    buffer[i] = 0;
}

function rms(newValue) {
    var oldValue = buffer[index]; // Retrieve outgoing value
    sumSq += newValue * newValue; // Add new squared value
    sumSq -= oldValue * oldValue; // Remove old squared value

    buffer[index] = newValue; // Store new value in buffer
    index = (index + 1) % windowSize; // Circular buffer update
    if (count < windowSize) count++; // Warm-up phase

    var smoothedRMS = Math.sqrt(sumSq / Math.max(count, 1)); // Compute RMS
    outlet(0, isNaN(smoothedRMS) ? 0 : smoothedRMS);
}

function msg_float(value) {
    rms(value);
}

function setWindowSize(size) {
    windowSize = Math.max(1, size);
    buffer = [];
    
    for (var i = 0; i < windowSize; i++) {
        buffer[i] = 0;
    }

    index = 0;
    sumSq = 0;
    count = 0;
}
