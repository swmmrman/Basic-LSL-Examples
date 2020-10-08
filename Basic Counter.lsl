/* This script is a basic timer script.  It will turn
 * any object it is placed in red over time.  It is
 * reset with a simple click.  Adjust INTERVAL to set
 * how fast it will change.
*/
integer DAY = 86400;
integer INTERVAL = 30; //Days till max red.
integer TIME = 120; //Time between checks in seconds

//These variables are declared here, but initialized in the init function.
integer days;
float amount;
key owner;

init() {
    // This can be called to effectivly reset the script, rather then using
    // llResetScript().
    amount = 1/(float)INTERVAL; //Caculates the ammount to subtract for color.
    llSetTimerEvent(TIME);
    owner = llGetOwner();  // Get here, since this likely will not be changing.
    reset();
    days = INTERVAL;
}

reset() {
    // Resets the counter to 0 days.  The days value can be chagned to start at
    // any point.
    days = 0;
    setColor(days);
    llResetTime();
}

setColor(integer count) {
    // Sets the color based on count.  Works by decremmeting the Y and Z, or
    // green and blue.
    vector col = <1,1,1>;
    if(days < INTERVAL) {
        col.y -= amount * count;
        col.z = col.y;// We want these the same. This saves processor time.
    }
    else col = <1,0,0>;// More days have passed, skip calculating, and go red.
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
            // You could make this more complex.  But we will just check for the
            // owner of the prim.
            reset();
        }
    }
    changed(integer change) {
        if(change & CHANGED_OWNER) {
            //If owner changes, call init() and reset the script.
            init();
        }
    }
}
