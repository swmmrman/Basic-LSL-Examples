//This is a basic script to repeat whatever is fed into the text box, and repeat
//it in green text.

integer chan;
integer listener;
key owner;
integer mode; //Needed to control shout or talk mode.

init() {
    chan = llFrand(0, 1000) * -1;
    owner = llGetOwner();
    name = osKey2Name(owner);
    listener = llListen(chan, "" , owner, "");
    llSetObjectName(name);
    mode = 0;
}

repeat(string text) {

}

default {
    state_entry() {
        init();
    }
    listen(integer chan, string name, key id, string body){
        repeat(body);
    }
}
