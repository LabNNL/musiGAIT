var windowSize = 10;
var buffer = [];
var sum    = 0;

// handle new data samples
function msg_float(v) {
    var x2 = v * v;
    buffer.push(x2);
    sum += x2;

    // if we have more than windowSize entries, drop the oldest
    if (buffer.length > windowSize) {
        sum -= buffer.shift();
    }

    // compute RMS: note zeros are implicit if buffer.length < windowSize
    var rms = Math.sqrt(sum / windowSize);
    outlet(0, rms);
}

function setWindow(n) {
    n = Math.max(1, Math.floor(n));
    if (n === windowSize) return;

    // if shrinking, drop the oldest extra elements
    if (n < windowSize) {
        var drop = buffer.length - n;
        while (drop-- > 0 && buffer.length > 0) {
            sum -= buffer.shift();
        }
    }

    // if growing, we just increase windowSize; existing buffer stays in place
    windowSize = n;
}
