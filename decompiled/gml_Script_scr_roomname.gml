if (argument0 == 0)
    return scr_gettext("roomname_0");

var roomid = room_get_name(argument0);

if (substr(roomid, 1, 5) == "room_")
{
    var roomname = scr_gettext("roomname_" + substr(roomid, 6));
    
    if (roomname != "")
        return roomname;
}

return " ";
