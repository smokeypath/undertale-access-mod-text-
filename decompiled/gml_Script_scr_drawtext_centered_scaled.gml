var xx = argument0;
var yy = argument1;
var text = argument2;
var xscale = argument3;
var yscale = argument4;
var display_scale = surface_get_width(application_surface) / view_wview[view_current];
var lineheight = round(string_height(" ") * yscale);
var eol = string_pos("#", text);
yy = round(yy * display_scale) / display_scale;

while (eol != 0)
{
    var line = substr(text, 1, eol);
    text = substr(text, eol + 1);
    width = string_width(line) * xscale;
    var line_x = round((xx - (width / 2)) * display_scale) / display_scale;
    draw_text_transformed(line_x, yy, line, xscale, yscale, 0);
    yy += lineheight;
    eol = string_pos("#", text);
}

var width = string_width(text) * xscale;
draw_text_transformed(round(xx - (width / 2)), yy, text, xscale, yscale, 0);
