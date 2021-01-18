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
    blinkLights(greenLights, greenCount);
    blinkLights(yellowLights, yellowCount);
    blinkLights(redLights, redCount);
    llSay(0, "Intersection Ready");
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
            name = llList2String(details, 0);
            direction = ll2Lower(llList2String(details, 1));
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
}
