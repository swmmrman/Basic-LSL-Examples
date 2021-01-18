//Basic Intersection Script

blinkLights(list color, integer colorCount) {
        integer index;
        for(index = 0; index < colorCount; index++) {
            integer light = llList2Integer(color, index);
            llSetLinkPrimitiveParamsFast(light, [PRIM_GLOW, -1, 1, PRIM_FULLBRIGHT, -1, 1]);
        }
        llSleep(1);
        for(index = 0; index < colorCount; index++) {
            integer light = llList2Integer(color, index);
            llSetLinkPrimitiveParamsFast(light, [PRIM_GLOW, -1, 0.0, PRIM_FULLBRIGHT, -1, 0]);
        }
        llSleep(1);
}

default {
    state_entry() { 
        list greenLights;
        list yellowLights;
        list redLights;
        integer greenCount;
        integer yellowCount;
        integer redCount;
        //lights = green_lights + red_lights + yellow_lights;
        integer prims = llGetNumberOfPrims() + 1;
        integer i;
        for(i=0; i < prims +1; i++) {
            string name = llGetLinkName(i);
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
        }
        blinkLights(greenLights, greenCount);
        blinkLights(yellowLights, yellowCount);
        blinkLights(redLights, redCount);
        llSay(0, "Intersection Ready");
    }
    touch_start(integer touched) {
        //Debugging feature
        if(llGetOwner() == llDetectedKey(0)) {
            llSetLinkPrimitiveParamsFast(llDetectedLinkNumber(0), [PRIM_GLOW, -1, 0.1, PRIM_FULLBRIGHT,-1, 1]);
        }
    }
    touch_end(integer touched){
        //Debuggin Feature
        if(llGetOwner() == llDetectedKey(0)) {
            llSetLinkPrimitiveParamsFast(llDetectedLinkNumber(0), [PRIM_GLOW, -1, 0.0, PRIM_FULLBRIGHT,-1, 0]);
        }
    }
}
