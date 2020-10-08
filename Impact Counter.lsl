//This script will count the number of times the object has been collided with.
//The counter is displaed above the prim.

vector TEXT_COLOR = <1,1,1>;

integer collisions;

init() {
    collisions = 0;
}

default {
    state_entry() {
        init();
    }
    collision_start(integer index) {
        collisions++;
        llSetText("Collisions: "(string) + collisions, TEXT_COLOR, 1);
    }
    touch_start(integer count) {
        init();  //Just call init() to reset.
    }
}
