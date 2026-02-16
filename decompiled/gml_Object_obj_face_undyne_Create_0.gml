event_inherited();
image_speed = 0.25;

if (instance_exists(obj_face_sans))
{
    with (obj_face_sans)
        instance_destroy();
}

if (instance_exists(obj_face_papyrus))
{
    with (obj_face_papyrus)
        instance_destroy();
}

if (instance_exists(obj_face_alphys))
{
    with (obj_face_alphys)
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

u[0] = 2128;
u[1] = 2129;
u[2] = 2132;
u[3] = 2134;
u[4] = 2135;
u[5] = 2136;
u[6] = 2137;
u[7] = 2139;
u[8] = 2142;
u[9] = 2143;
sprite_index = u[global.faceemotion];
