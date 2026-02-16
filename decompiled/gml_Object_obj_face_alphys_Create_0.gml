event_inherited();

if (instance_exists(obj_face_sans))
{
    with (obj_face_sans)
        instance_destroy();
}

if (instance_exists(obj_face_undyne))
{
    with (obj_face_undyne)
        instance_destroy();
}

if (instance_exists(obj_face_papyrus))
{
    with (obj_face_papyrus)
        instance_destroy();
}

if (instance_exists(obj_face_asgore))
{
    with (obj_face_asgore)
        instance_destroy();
}

if (instance_exists(obj_face_torieltalk))
{
    with (obj_face_torieltalk)
        instance_destroy();
}

if (instance_exists(obj_face_torielblink))
{
    with (obj_face_torielblink)
        instance_destroy();
}

if (instance_exists(obj_torbody))
{
    with (obj_torbody)
        instance_destroy();
}

image_speed = 0.25;
u[0] = 2149;
u[1] = 2152;
u[2] = 2153;
u[3] = 2154;
u[4] = 2155;
u[5] = 2156;
u[6] = 2157;
u[7] = 2158;
u[8] = 2159;
u[9] = 2160;
u[10] = 2161;
u[11] = 2162;
u[12] = 2163;
u[13] = 2164;
u[14] = 2165;
u[15] = 2166;
u[16] = 2167;
u[17] = 2168;
u[18] = 2169;
u[19] = 2170;
u[20] = 2171;
u[21] = 2172;
u[22] = 2173;
u[23] = 2174;
u[24] = 2175;
u[25] = 2176;
sprite_index = u[global.faceemotion];

if (global.flag[430] == 1)
    sprite_index = u[global.faceemotion + 10];

if (global.flag[430] == 2)
    sprite_index = u[global.faceemotion + 15];

if (global.flag[430] == 4)
{
    image_index = global.faceemotion;
    sprite_index = spr_alphysface_new;
}
