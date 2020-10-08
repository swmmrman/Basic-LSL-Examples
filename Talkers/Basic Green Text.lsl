//This is a basic script to repeat whatever is fed into the text box, and repeat
//it in green text.

string objectName = "Green Text Talker";
integer chan;
integer listener;
key owner;
string name;
integer mode; //Needed to control shout or talk mode.

init() {
    chan = (integer)llFrand(1000) * -1;
    owner = llGetOwner();
    name = osKey2Name(owner);
    listener = llListen(chan, "" , owner, "");
    mode = 0;
    llTextBox(owner, "Text to say", chan);
}

repeat(string text) {
    llSetObjectName(name);
    if(mode) llShout(0, text); //We want to shout.
    else llSay(0,text);
    llTextBox(owner, "Text to say", chan);
    llSetObjectName(objectName);
}
doCommand(string command) {
    string c = llGetSubString(command, 1,-1); //Extract just the command.
    c = llToLower(c); //Make lowercase so not case sensitive.
    if(c == "shout") mode = 1;
    else if(c == "talk") mode = 0;
    else if(c == "off") {
        mode = -1;
        return;
    }
    else mode = !mode; //No match, just toggle shout.
    llTextBox(owner, "Text to say", chan);
}

default {
    state_entry() {
        init();
    }
    listen(integer chan, string name, key id, string body){
        integer command = ~(llSubStringIndex(body, "!"));
        if(command) {
            doCommand(body);
        }
        else repeat(body);
    }
    attach(key id) {
         init();
    }
    touch_start(integer touched) {
        mode = 0;
        llTextBox(owner, "Text to say", chan);
    }
}
