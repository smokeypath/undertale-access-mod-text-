if (instance_exists(obj_mainchara))
{
    if (obj_mainchara.cutscene == 1)
    {
        o = 1576;
        
        if (obj_mainchara.x >= 450)
            view_object[0] = -4;
        
        if (obj_mainchara.x < 450)
        {
            view_object[0] = obj_mainchara;
            view_xview[0] = round((o.x - (view_wview[0] / 2)) + (o.sprite_width / 2));
            view_yview[0] = round((o.y - (view_hview[0] / 2)) + (o.sprite_height / 2));
        }
    }
}
