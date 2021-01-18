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
float intensity = 0.75; // Float 0.0 to 1
integer GreenTime = 120; //In seconds

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
        setDirection(greenLights, EW, 1);
        setDirection(redLights, NS, 1);
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
