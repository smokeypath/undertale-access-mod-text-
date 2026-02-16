image_speed = 0.1;
lit = 0;
active = 1;

if (room == room_truelab_prepower)
    active = 0;

if (global.flag[485] == 1)
{
    active = 0;
    
    if (room == room_truelab_prepower)
        active = 2;
}
