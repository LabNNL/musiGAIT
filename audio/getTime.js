// Function to pad a number with leading zeros
function padNumber(num, size) {
    var s = "000" + num;
    return s.substr(s.length - size);
}

// Function to get the current time in hh:mm:ss.ms format
function time() {
    var now = new Date();
    var hours = padNumber(now.getHours(), 2);
    var minutes = padNumber(now.getMinutes(), 2);
    var seconds = padNumber(now.getSeconds(), 2);
    var milliseconds = padNumber(now.getMilliseconds(), 3);
    
    // Combine into hh:mm:ss.ms format
    var formattedTime = hours + ":" + minutes + ":" + seconds + "." + milliseconds;
    
    // Output the formatted time
    outlet(0, formattedTime);
}
