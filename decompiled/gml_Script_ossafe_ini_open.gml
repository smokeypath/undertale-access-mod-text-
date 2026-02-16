if (global.osflavor <= 2)
{
    ini_open(argument0);
}
else
{
    var name = string_lower(argument0);
    global.current_ini = name;
    var file = ds_map_find_value(global.savedata, name);
    var data;
    
    if (is_undefined(file))
        data = "";
    else
        data = file;
    
    ini_open_from_string(data);
}
