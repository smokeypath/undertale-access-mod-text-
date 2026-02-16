event_inherited();
image_speed = 0.25;

if (instance_exists(obj_face_papyrus))
{
    with (obj_face_papyrus)
        instance_destroy();
}

u[0] = 2185;
u[1] = 2186;
u[2] = 2187;
u[3] = 2188;
u[4] = 2189;
u[5] = 2190;
u[6] = 2191;
u[7] = 2192;
u[8] = 2193;
u[9] = 2194;
sprite_index = u[global.faceemotion];
