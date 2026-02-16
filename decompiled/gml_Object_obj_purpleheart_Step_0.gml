if (global.invc > 0 || obj_battlecontroller.runaway == 1)
{
    image_speed = 0.5;
}
else
{
    image_index = 0;
    image_speed = 0;
}

if (type == 0)
{
    if (obj_time.left)
    {
        if (x > (xmid - xlen))
            x -= 4;
    }
    
    if (obj_time.right)
    {
        if (x < (xmid + xlen))
            x += 4;
    }
    
    if (keyboard_check_pressed(vk_up))
    {
        if (moving == 0 && yno > 1)
            moving = 1;
    }
    
    if (moving == 1)
    {
        space += (yspace / 3);
        y = ((yzero + ((yno - 1) * yspace)) - space) + yoff;
        
        if (space >= yspace)
        {
            yno -= 1;
            space = 0;
            moving = 0;
        }
    }
    
    if (keyboard_check_pressed(vk_down))
    {
        if (moving == 0 && yno < yamt)
            moving = 2;
    }
    
    if (moving == 2)
    {
        space += (yspace / 3);
        y = yzero + ((yno - 1) * yspace) + space + yoff;
        
        if (space >= yspace)
        {
            yno += 1;
            space = 0;
            moving = 0;
        }
    }
}

if (ttype == 1)
{
    yoff += yadd;
    y += yadd;
    
    if (yoff > yspace)
    {
        yno += 1;
        
        if (yno > yamt)
        {
            yno = yamt;
            dmg = 6;
            scr_damagestandard_x();
        }
        
        yoff = 0;
        
        if (moving == 0)
            y = yzero + ((yno - 1) * yspace) + space + yoff;
    }
}

if (ttype == 3)
{
    if (instance_exists(obj_hideouscupcake) == 0)
        instance_create(xmid - xlen, 460, obj_hideouscupcake);
    
    if (instance_exists(obj_hideouscupcake))
    {
        if (obj_hideouscupcake.y > 320)
            obj_hideouscupcake.y -= 4;
    }
    
    if (yzero > 100)
        yzero -= 4;
    
    y -= 4;
    yz2 += 4;
    
    if (yz2 > yspace)
    {
        yz2 -= yspace;
        yamt += 1;
    }
    
    if (yzero <= 100)
    {
        yzero = 100;
        ttype = 1;
        yadd = yadd2;
    }
}

if (global.mnfight == 2)
{
    if (instance_exists(obj_heart))
        obj_heart.x = -200;
}
