if (obj_time.left == 0)
{
    if (obj_time.right == 0)
    {
        if (obj_time.down == 0)
        {
            if (obj_time.up == 0)
                moving = 0;
        }
    }
}

if (global.interact > 0)
{
    moving = 0;
    movement = 0;
}
else
{
    movement = 1;
}

if (xprevious != x || yprevious != y)
    moving = 1;

if (moving == 0)
{
    image_speed = 0;
    image_index = 0;
}

if (cutscene == 0)
{
    if (instance_exists(obj_vsflowey_shaker) == 0)
    {
        view_xview[0] = round((x - (view_wview[0] / 2)) + 10);
        view_yview[0] = round((y - (view_hview[0] / 2)) + 10);
    }
}
