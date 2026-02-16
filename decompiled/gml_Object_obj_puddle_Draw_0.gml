if (instance_exists(obj_mainchara))
{
    draw_set_color(c_black);
    ossafe_fill_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom);
    ndtry = 0;
    
    if (instance_exists(obj_mkid_actor))
    {
        mm = 1117;
        sprito2 = obj_mkid_actor.sprite_index;
        
        if (obj_mkid_actor.sprite_index == mm.rsprite)
            sprito2 = 1468;
        
        if (mm.sprite_index == spr_mkid_rt)
            sprito2 = 1469;
        
        if (mm.sprite_index == mm.dsprite)
            sprito2 = 1466;
        
        if (mm.sprite_index == mm.usprite)
            sprito2 = 1470;
        
        if (mm.sprite_index == mm.lsprite)
            sprito2 = 1467;
        
        if (mm.depth > obj_mainchara.depth)
            draw_custom_ext(bbox_left, bbox_right, bbox_top, bbox_bottom - 1, sprito2, mm.image_index, 1, 1, 0.4, mm.x, mm.y + (mm.sprite_height * 1));
        else
            ndtry = 1;
    }
    
    sprito = obj_mainchara.sprite_index;
    
    if (obj_mainchara.rsprite == spr_maincharar)
    {
        if (obj_mainchara.sprite_index == spr_maincharar)
            sprito = 1092;
        
        if (obj_mainchara.sprite_index == spr_maincharad)
            sprito = 1088;
        
        if (obj_mainchara.sprite_index == spr_maincharau)
            sprito = 1090;
        
        if (obj_mainchara.sprite_index == spr_maincharal)
            sprito = 1091;
    }
    
    if (obj_mainchara.rsprite == spr_maincharar_umbrella)
    {
        if (obj_mainchara.sprite_index == spr_maincharar_umbrella)
            sprito = 1102;
        
        if (obj_mainchara.sprite_index == spr_maincharad_umbrella)
            sprito = 1100;
        
        if (obj_mainchara.sprite_index == spr_maincharau_umbrella)
            sprito = 1101;
        
        if (obj_mainchara.sprite_index == spr_maincharal_umbrella)
            sprito = 1103;
    }
    
    if (death == 1)
    {
        if (obj_mainchara.sprite_index == spr_maincharar)
            sprito = 1111;
        
        if (obj_mainchara.sprite_index == spr_maincharad)
            sprito = 1109;
        
        if (obj_mainchara.sprite_index == spr_maincharau)
            sprito = 1115;
        
        if (obj_mainchara.sprite_index == spr_maincharal)
            sprito = 1113;
    }
    
    simage = obj_mainchara.image_index;
    
    if (global.flag[85] == 0)
        draw_custom_ext(bbox_left, bbox_right, bbox_top, bbox_bottom - 1, sprito, simage, 1, 1, 0.4, obj_mainchara.x, obj_mainchara.y + (obj_mainchara.sprite_height * 1));
    
    if (global.flag[85] == 1)
    {
        if (obj_mainchara.sprite_index == obj_mainchara.dsprite)
            value = 3;
        
        if (obj_mainchara.sprite_index == obj_mainchara.usprite)
            value = 16;
        
        if (obj_mainchara.sprite_index == obj_mainchara.rsprite)
            value = 10;
        
        if (obj_mainchara.sprite_index == obj_mainchara.lsprite)
            value = 9;
        
        draw_custom_ext(bbox_left, bbox_right, bbox_top, bbox_bottom - 1, sprito, simage, 1, 1, 0.4, obj_mainchara.x - value, obj_mainchara.y + 30);
    }
    
    if (ndtry == 1)
        draw_custom_ext(bbox_left, bbox_right, bbox_top, bbox_bottom - 1, sprito2, mm.image_index, 1, 1, 0.4, mm.x, mm.y + (mm.sprite_height * 1));
    
    draw_sprite(sprite_index, image_index, x, y);
    
    if (global.debug == 1)
    {
        if (keyboard_check_pressed(vk_space))
            death = 1;
    }
}
