if (global.debug == 1)
{
    if (control_check_pressed(2))
        rating -= 1;
}

if (global.turntimer < 1)
    instance_destroy();
