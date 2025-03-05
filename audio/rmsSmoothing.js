// Max/MSP JavaScript RMS Smoother
var windowSize = 10; // Default window size
var buffer = []; // Circular buffer
var index = 0;
var sumSq = 0;
var count = 0; // Warm-up tracking

// Initialize buffer manually (fix for older JavaScript in Max)
for (var i = 0; i < windowSize; i++) {
    buffer[i] = 0;
}

// Function to update RMS with new value
function rms(newValue) {
    var oldValue = buffer[index]; // Retrieve outgoing value
    sumSq += newValue * newValue; // Add new squared value
    sumSq -= oldValue * oldValue; // Remove old squared value

    buffer[index] = newValue; // Store new value in buffer
    index = (index + 1) % windowSize; // Circular buffer update
    if (count < windowSize) count++; // Warm-up phase

    var smoothedRMS = Math.sqrt(sumSq / count); // Compute RMS
    outlet(0, smoothedRMS); // Send output to Max
}

// Max/MSP inlet to receive data
function msg_float(value) {
    rms(value); // Process incoming float
}

// Change window size dynamically
function setWindowSize(size) {
    windowSize = Math.max(1, size); // Ensure at least size = 1
    buffer = []; // Reset buffer manually
    for (var i = 0; i < windowSize; i++) {
        buffer[i] = 0;
    }
    index = 0;
    sumSq = 0;
    count = 0;
}
