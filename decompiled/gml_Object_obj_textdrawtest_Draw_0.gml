if (active == 1)
{
    draw_set_color(c_white);
    draw_set_alpha(1);
    scr_setfont(fnt_maintext);
    draw_text(x, y, obj_songwriter.newstring);
}
