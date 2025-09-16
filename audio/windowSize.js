autowatch = 1;

inlets = 2;  // 0: 0/1 toggle, 1: size L T R B
outlets = 1; // -> thispatcher

var PANEL_PX = 313;
var CLOSED_W_BASE = 900;
var MIN_W = 200, slack = 6;

var want = null;   // pending 0/1
var open = 0;      // last logical state
var closed_w = CLOSED_W_BASE;

function loadbang(){ closed_w = Math.max(MIN_W, CLOSED_W_BASE); _ask(); }
function msg_int(v){ want = v ? 1 : 0; _ask(); }
function panelpx(v){ v=~~v; if(v>=0){ PANEL_PX=v; _ask(); } }
function setbaseline(v){ v=~~v; if(v>=MIN_W){ CLOSED_W_BASE=v; closed_w=v; _ask(); } }

function list(){
	if (inlet !== 1 || arguments.length < 4) return;
	var L=+arguments[0], T=+arguments[1], R=+arguments[2], B=+arguments[3];
	if (![L,T,R,B].every(isFinite)) return;

	var W = Math.max(MIN_W, R - L);
	var open_w = closed_w + PANEL_PX;

	// anchor only shrinks; never grows from user widening
	if (open){
		if (W < open_w - slack) { closed_w = Math.max(MIN_W, W - PANEL_PX); open_w = closed_w + PANEL_PX; }
	} else {
		if (W < closed_w - slack) { closed_w = Math.max(MIN_W, W); open_w = closed_w + PANEL_PX; }
	}

	if (want === null) return;

	if (want === 1){
		if (W < open_w - slack) _apply(L, T, L + open_w, B);
		open = 1;
	} else {
		if (Math.abs(W - open_w) <= slack) _apply(L, T, L + closed_w, B);
		open = 0;
	}
	want = null;
}

function _apply(L,T,R,B){
	if ((R - L) < MIN_W) R = L + MIN_W;
	outlet(0, "window", "size", L, T, R, B);
	outlet(0, "window", "exec");
}
function _ask(){ outlet(0, "window", "getsize"); }
