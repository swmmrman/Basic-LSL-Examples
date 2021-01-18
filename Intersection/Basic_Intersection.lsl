//Basic Intersection Script
/*
 * Currently This script just finds the lights and blinks each color.
*/

list greenLights;
list yellowLights;
list redLights;
list NS; // North/south facing
list EW; // East/west facing
integer greenCount;
integer yellowCount;
integer redCount;
float intensity = 0.95; // Float 0.0 to 1
integer greenTime = 120; //In seconds
integer yellowTime = 10;
integer redTime = 15;
integer direction;
integer changing;

blinkLights(list color, integer colorCount) {
    //Diagnostic blinking for startup
    integer index;
    for(index = 0; index < colorCount; index++) {
        integer light = llList2Integer(color, index);
        llSetLinkPrimitiveParamsFast(light, [
            PRIM_GLOW, -1, 1,
            PRIM_FULLBRIGHT, -1, 1
        ]);
    }
    llSleep(1);
    for(index = 0; index < colorCount; index++) {
        integer light = llList2Integer(color, index);
        llSetLinkPrimitiveParamsFast(light, [
            PRIM_GLOW, -1, 0.0,
            PRIM_FULLBRIGHT, -1, 0
        ]);
    }
    llSleep(1);
}

startTest() {
    list allLights = greenLights + yellowLights + redLights;
    list allDirections = NS + EW;
    setDirection(allLights, allDirections, 1);
    llSleep(0.5);
    setDirection(allLights, allDirections, 0);
    llSleep(0.5);
    blinkLights(greenLights, greenCount);
    blinkLights(yellowLights, yellowCount);
    blinkLights(redLights, redCount);
    llSay(0, "Intersection Ready");
}

setDirection(list color, list direction, integer status) {
    //This fuction will toggle a direction on.
    integer light;
    integer lights = llGetListLength(color);
    for(light=0; light<lights; light++) {
        integer linkNum = llList2Integer(color, light); //find link.
        if(~llListFindList(direction, [linkNum])) {
            llSetLinkPrimitiveParamsFast(linkNum, [
                PRIM_GLOW, -1, (status * intensity),
                PRIM_FULLBRIGHT, -1, status
            ]);
        }
    }
}

default {
    state_entry() {
        integer prims = llGetNumberOfPrims() + 1;
        integer i;
        for(i=0; i < prims +1; i++) {
            //Walk over all links and add lights to the correct lists.
            list details = llGetLinkPrimitiveParams(i, [PRIM_NAME, PRIM_DESC]);
            // Fetch the name and description of the lights.  Then description
            // contains the direction it faces.  Name contains the type.
            string name = llList2String(details, 0);
            string direction = llToLower(llList2String(details, 1));
            if(name == "Red Light"){
                redLights += i;
                redCount++;
            }
            else if(name == "Yellow Light") {
                yellowLights += i;
                yellowCount++;
            }
            else if(name == "Green Light") {
                greenLights += i;
                greenCount++;
            }
            if(direction == "w" | direction == "e") EW += i;
            else NS += i;
        }
        startTest();
        llSetTimerEvent(1);
        direction = 1;
        changing = 0;
        setDirection(greenLights, NS, 1);
        setDirection(redLights, EW, 1);
    }
    touch_start(integer touched) {
        //Debugging feature makes any link light up when clicked.
        if(llGetOwner() == llDetectedKey(0)) {
            llSetLinkPrimitiveParamsFast(llDetectedLinkNumber(0), [
                PRIM_GLOW, -1, 0.1,
                PRIM_FULLBRIGHT, -1, 1
            ]);
        }
    }
    touch_end(integer touched){
        //Debugging Feature
        if(llGetOwner() == llDetectedKey(0)) {
            llSetLinkPrimitiveParamsFast(llDetectedLinkNumber(0), [
                PRIM_GLOW, -1, 0.0,
                PRIM_FULLBRIGHT, -1, 0
            ]);
        }
    }
    timer() {
        // Needs reworked, this was to make it cycle.  After typing i saw a
        // better way.
        float time = llGetTime();
        if(changing == 1 && time > yellowTime) {
            //We are yellow
            changing = 2;
            llResetTime();
            if(direction == 1) {
                // Lights are Yellow NS.
                setDirection(yellowLights, NS, 0);
                setDirection(redLights, NS, 1);
            }
            else {
                // Lights are Yellow EW.
                setDirection(yellowLights, EW, 0);
                setDirection(redLights, EW, 1);
            }
        }
        else if(changing == 2 && time > redTime) {
            changing = 0;
            llResetTime();
            if(direction == 1) {
                // Lights are red.
                setDirection(redLights, EW, 0);
                setDirection(greenLights, EW, 1);
                direction = 0;
            }
            else {
                // Lights are red.
                setDirection(redLights, NS, 0);
                setDirection(greenLights, NS, 1);
                direction = 1;
            }

        }
        else if(time > greenTime) {
            changing = 1;
            llResetTime();
            if(direction == 1) {
                // Lights are green NS.
                setDirection(greenLights, NS, 0);
                setDirection(yellowLights, NS, 1);
            }
            else {
                // Lights are green EW.
                setDirection(greenLights, EW, 0);
                setDirection(yellowLights, EW, 1);
            }
        }
    }
}
