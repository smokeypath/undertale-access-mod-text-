global.interact = 3;
instance_create(0, 0, obj_unfader);

if (room == room_basement1 || room == room_torhouse1)
{
    if (global.flag[7] == 0)
        instance_create(0, 0, obj_musfadeout);
}

if (touched == 0)
{
    alarm[2] = 14;
    touched = 1;
}
