// ES5‐compatible MovingAverage
function MovingAverage(initialWindowSize) {
	this.windowSize = Math.max(1, Math.floor(initialWindowSize)||1);
	this.buffer = new Array(this.windowSize);
	this.head = 0;
	this.count = 0;
	this.sum = 0;
}

MovingAverage.prototype.setWindow = function(n) {
	n = Math.max(1, Math.floor(n));
	if (n === this.windowSize) return;
	// reinitialize
	this.windowSize = n;
	this.buffer = new Array(n);
	this.head = 0;
	this.count = 0;
	this.sum = 0;
};

MovingAverage.prototype.update = function(v) {
	// subtract old sample if buffer full
	if (this.count === this.windowSize) {
		this.sum -= this.buffer[this.head];
	} else {
		this.count++;
	}
	// write new
	this.buffer[this.head] = v;
	this.sum += v;
	// advance head
	this.head = (this.head + 1) % this.windowSize;
	// return avg
	return this.sum / this.count;
};

var ma = new MovingAverage(10);

function msg_float(v) {
	outlet(0, ma.update(v));
}

function setWindow(n) {
	ma.setWindow(n);
}
