integer DAY = 86400;
integer INTERVAL = 30; //Days till max red.
integer TIME = 120; //Time between checks in seconds

integer days;
float amount;
key owner;

init() {
    amount = 1/(float)INTERVAL;
    llSetTimerEvent(TIME);
    owner = llGetOwner();
    reset();
    days = INTERVAL;
}

reset() {
    days = 0;   
    setColor(days);
    llResetTime();
}

setColor(integer count) {
    vector col = <1,1,1>;
    if(days < INTERVAL) {
        col.y -= amount * count;
        col.z = col.y;
    }
    else col = <1,0,0>;
    llSetColor(col, -1);
}

default {
    state_entry() {
        init();
    }
    timer() {
        if(llGetTime() > DAY) {
            llResetTime();
            days++;
            setColor(days);
        }
    }
    touch_start(integer touched) {
        if(llDetectedKey(0) == owner) {
            reset();
        }
    }
}
