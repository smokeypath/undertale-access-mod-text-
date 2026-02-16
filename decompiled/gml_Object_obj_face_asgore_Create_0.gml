event_inherited();
image_speed = 0.25;

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

if (instance_exists(obj_face_alphys))
{
    with (obj_face_alphys)
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

u[0] = 2178;
u[1] = 2179;
u[2] = 2180;
u[3] = 2181;
u[4] = 2182;
u[5] = 2183;

if (global.faceemotion < 6)
    sprite_index = u[global.faceemotion];
