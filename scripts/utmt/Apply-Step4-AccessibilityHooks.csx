// Step 4 minimal accessibility hooks for Undertale (GameMaker)
// - Writes dialog/menu announcements to accessibility_announce.txt
// - Intended to be run in UndertaleModTool with data.win opened

EnsureDataLoaded();

if (!ScriptQuestion("Apply Step 4 accessibility hooks (dialog + menu announcements)?"))
    return;

UndertaleModLib.Compiler.CodeImportGroup importGroup = new(Data);

void PatchFindReplace(string codeName, string findText, string replaceText)
{
    UndertaleCode code = Data.Code.ByName(codeName);
    if (code is null)
    {
        ScriptError("Missing code entry: " + codeName);
        return;
    }
    importGroup.QueueFindReplace(code, findText, replaceText, true);
}

PatchFindReplace(
    "gml_Object_obj_time_Create_0",
@"global.default_joy_dir = global.joy_dir;",
@"global.default_joy_dir = global.joy_dir;
global.acc_enabled = 1;
global.acc_last_announce = """";
global.acc_last_announce_time = 0;
global.acc_min_interval = 120;
global.acc_file_name = ""accessibility_announce.txt"";"
);

PatchFindReplace(
    "gml_Object_obj_titleimage_Create_0",
@"proceed = 0;",
@"proceed = 0;

if (!variable_global_exists(""acc_enabled""))
    global.acc_enabled = 1;
if (!variable_global_exists(""acc_last_announce""))
    global.acc_last_announce = """";
if (!variable_global_exists(""acc_last_announce_time""))
    global.acc_last_announce_time = 0;
if (!variable_global_exists(""acc_min_interval""))
    global.acc_min_interval = 120;
if (!variable_global_exists(""acc_file_name""))
    global.acc_file_name = ""accessibility_announce.txt"";

if (global.acc_enabled == 1)
{
    var _acc_title_text = """";
    if (global.osflavor == 4)
        _acc_title_text = string(scr_gettext(""title_press_button_console""));
    else
        _acc_title_text = string(scr_gettext(""title_press_button_pc""));

    if (string_length(_acc_title_text) > 0)
    {
        var _acc_out = ""Title: "" + _acc_title_text;
        if (_acc_out != global.acc_last_announce)
        {
            global.acc_last_announce = _acc_out;
            var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
            ossafe_file_text_write_string(_acc_file, _acc_out);
            ossafe_file_text_writeln(_acc_file);
            ossafe_file_text_close(_acc_file);
        }
    }
}"
);

PatchFindReplace(
    "gml_Object_obj_titleimage_Draw_0",
@"    else
    {
        draw_text(120, 180, scr_gettext(""title_press_button_pc""));
    }",
@"    else
    {
        draw_text(120, 180, scr_gettext(""title_press_button_pc""));
    }

    if (global.acc_enabled == 1)
    {
        var _acc_title_text = """";
        if (global.osflavor == 4)
            _acc_title_text = string(scr_gettext(""title_press_button_console""));
        else
            _acc_title_text = string(scr_gettext(""title_press_button_pc""));

        if (string_length(_acc_title_text) > 0)
        {
            var _acc_out = ""Title: "" + _acc_title_text;
            if (_acc_out != global.acc_last_announce)
            {
                global.acc_last_announce = _acc_out;
                var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
                ossafe_file_text_write_string(_acc_file, _acc_out);
                ossafe_file_text_writeln(_acc_file);
                ossafe_file_text_close(_acc_file);
            }
        }
    }"
);

PatchFindReplace(
    "gml_Script_scr_regulartext",
@"global.msc = 0;
instance_create(0, 0, obj_dialoguer);",
@"global.msc = 0;

if (global.acc_enabled == 1)
{
    var _acc_text = string(global.msg[0]);
    if (string_length(_acc_text) > 0 && _acc_text != global.acc_last_announce)
    {
        global.acc_last_announce = _acc_text;
        var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
        ossafe_file_text_write_string(_acc_file, _acc_text);
        ossafe_file_text_writeln(_acc_file);
        ossafe_file_text_close(_acc_file);
    }
}

instance_create(0, 0, obj_dialoguer);"
);

PatchFindReplace(
    "gml_Script_scr_writetext",
@"if (argument1 != ""x"")
    global.msg[0] = argument1;",
@"if (argument1 != ""x"")
    global.msg[0] = argument1;

if (global.acc_enabled == 1)
{
    var _acc_text = string(global.msg[0]);
    if (string_length(_acc_text) > 0 && _acc_text != global.acc_last_announce)
    {
        global.acc_last_announce = _acc_text;
        var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
        ossafe_file_text_write_string(_acc_file, _acc_text);
        ossafe_file_text_writeln(_acc_file);
        ossafe_file_text_close(_acc_file);
    }
}"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"    var old_col = selected_col;",
@"    var old_col = selected_col;
    var old_row = selected_row;"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"    until (selected_col < 0 || selected_row < 0 || string_length(charmap[selected_row, selected_col]) > 0);
    
    bks_f = 0;",
@"    until (selected_col < 0 || selected_row < 0 || string_length(charmap[selected_row, selected_col]) > 0);

    if ((old_col != selected_col || old_row != selected_row) && global.acc_enabled == 1)
    {
        var _acc_name_text = """";
        if (selected_row == -1)
        {
            if (selected_col == 0)
                _acc_name_text = string(scr_gettext(""name_entry_quit""));
            else if (selected_col == 1)
                _acc_name_text = string(scr_gettext(""name_entry_backspace""));
            else if (selected_col == 2)
                _acc_name_text = string(scr_gettext(""name_entry_done""));
        }
        else if (selected_row >= 0 && selected_col >= 0)
        {
            _acc_name_text = string(charmap[selected_row, selected_col]);
        }

        if (string_length(_acc_name_text) > 0)
        {
            var _acc_out = ""Name: "" + _acc_name_text;
            if (_acc_out != global.acc_last_announce)
            {
                global.acc_last_announce = _acc_out;
                var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
                ossafe_file_text_write_string(_acc_file, _acc_out);
                ossafe_file_text_writeln(_acc_file);
                ossafe_file_text_close(_acc_file);
            }
        }
    }
    
    bks_f = 0;"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"if (naming == 3)
{
    iniread = ossafe_ini_open(""undertale.ini"");",
@"if (naming == 3)
{
    var old_selected3 = selected3;
    iniread = ossafe_ini_open(""undertale.ini"");"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"        if (keyboard_check_pressed(vk_up))
        {
            if (selected3 == 2)
                selected3 = 0;
            
            keyboard_clear(vk_down);
        }
        
        var action = -1;",
@"        if (keyboard_check_pressed(vk_up))
        {
            if (selected3 == 2)
                selected3 = 0;
            
            keyboard_clear(vk_down);
        }

        if (selected3 != old_selected3 && global.acc_enabled == 1)
        {
            var _acc_name_menu = """";
            if (selected3 == 0)
                _acc_name_menu = string(scr_gettext(""load_menu_continue""));
            else if (selected3 == 1)
            {
                if (truereset == 0)
                    _acc_name_menu = string(scr_gettext(""load_menu_reset""));
                else
                    _acc_name_menu = string(scr_gettext(""load_menu_truereset""));
            }
            else if (selected3 == 2)
                _acc_name_menu = string(scr_gettext(""settings_name""));

            if (string_length(_acc_name_menu) > 0)
            {
                var _acc_out = ""Title Menu: "" + _acc_name_menu;
                if (_acc_out != global.acc_last_announce)
                {
                    global.acc_last_announce = _acc_out;
                    var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
                    ossafe_file_text_write_string(_acc_file, _acc_out);
                    ossafe_file_text_writeln(_acc_file);
                    ossafe_file_text_close(_acc_file);
                }
            }
        }
        
        var action = -1;"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"        if (keyboard_check_pressed(vk_up))
        {
            if (selected3 == 1)
                selected3 = 0;
        }
        
        var yy2 = yy + 20;",
@"        if (keyboard_check_pressed(vk_up))
        {
            if (selected3 == 1)
                selected3 = 0;
        }

        if (selected3 != old_selected3 && global.acc_enabled == 1)
        {
            var _acc_name_menu = """";
            if (selected3 == 0)
                _acc_name_menu = string(scr_gettext(""instructions_begin""));
            else if (selected3 == 1)
                _acc_name_menu = string(scr_gettext(""settings_name""));

            if (string_length(_acc_name_menu) > 0)
            {
                var _acc_out = ""Title Menu: "" + _acc_name_menu;
                if (_acc_out != global.acc_last_announce)
                {
                    global.acc_last_announce = _acc_out;
                    var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
                    ossafe_file_text_write_string(_acc_file, _acc_out);
                    ossafe_file_text_writeln(_acc_file);
                    ossafe_file_text_close(_acc_file);
                }
            }
        }
        
        var yy2 = yy + 20;"
);

PatchFindReplace(
    "gml_Object_obj_overworldcontroller_Draw_0",
@"if (currentmenu < global.menuno && global.menuno != 9)
    {
        snd_play(snd_select);
    }
    else if (global.menuno >= 0 && global.menuno < 6)
    {
        if (currentspot != global.menucoord[global.menuno])
            snd_play(snd_squeak);
    }",
@"var _acc_menu_changed = 0;
    if (currentmenu < global.menuno && global.menuno != 9)
    {
        snd_play(snd_select);
        _acc_menu_changed = 1;
    }
    else if (global.menuno >= 0 && global.menuno < 6)
    {
        if (currentspot != global.menucoord[global.menuno])
        {
            snd_play(snd_squeak);
            _acc_menu_changed = 1;
        }
    }

    if (_acc_menu_changed == 1 && global.acc_enabled == 1)
    {
        var _acc_menu_text = """";
        
        if (global.menuno == 0)
        {
            if (global.menucoord[0] == 0)
                _acc_menu_text = scr_gettext(""field_menu_item"");
            else if (global.menucoord[0] == 1)
                _acc_menu_text = scr_gettext(""field_menu_stat"") + "": HP "" + string(global.hp) + ""/"" + string(global.maxhp) + "", LV "" + string(global.lv);
            else if (global.menucoord[0] == 2)
                _acc_menu_text = scr_gettext(""field_menu_cell"");
        }
        else if (global.menuno == 1)
        {
            _acc_menu_text = string(global.itemname[global.menucoord[1]]);
        }
        else if (global.menuno == 3)
        {
            _acc_menu_text = string(global.phonename[global.menucoord[3]]);
        }
        else if (global.menuno == 5)
        {
            if (global.menucoord[5] == 0)
                _acc_menu_text = scr_gettext(""item_menu_use"");
            else if (global.menucoord[5] == 1)
                _acc_menu_text = scr_gettext(""item_menu_info"");
            else if (global.menucoord[5] == 2)
                _acc_menu_text = scr_gettext(""item_menu_drop"");
        }
        else
        {
            _acc_menu_text = ""Menu "" + string(global.menuno);
        }

        if (string_length(_acc_menu_text) > 0)
        {
            var _acc_out = ""Menu: "" + _acc_menu_text;
            if (_acc_out != global.acc_last_announce)
            {
                global.acc_last_announce = _acc_out;
                var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
                ossafe_file_text_write_string(_acc_file, _acc_out);
                ossafe_file_text_writeln(_acc_file);
                ossafe_file_text_close(_acc_file);
            }
        }
    }"
);

PatchFindReplace(
    "gml_Object_obj_intromenu_Draw_0",
@"script_execute(scr_namingscreen);",
@"script_execute(scr_namingscreen);

if (global.acc_enabled == 1)
{
    var _acc_intro_text = """";

    if (naming == 1)
    {
        if (selected_row == -1)
        {
            if (selected_col == 0)
                _acc_intro_text = string(scr_gettext(""name_entry_quit""));
            else if (selected_col == 1)
                _acc_intro_text = string(scr_gettext(""name_entry_backspace""));
            else if (selected_col == 2)
                _acc_intro_text = string(scr_gettext(""name_entry_done""));
        }
        else if (selected_row >= 0 && selected_col >= 0)
        {
            _acc_intro_text = string(charmap[selected_row, selected_col]);
        }

        if (string_length(_acc_intro_text) > 0)
            _acc_intro_text = ""Name: "" + _acc_intro_text;
    }
    else if (naming == 3)
    {
        if (selected3 == 0)
            _acc_intro_text = ""Title Menu: "" + string(scr_gettext(""instructions_begin""));
        else if (selected3 == 1)
            _acc_intro_text = ""Title Menu: "" + string(scr_gettext(""settings_name""));
        else if (selected3 == 2)
            _acc_intro_text = ""Title Menu: "" + string(scr_gettext(""load_menu_continue""));
    }

    if (string_length(_acc_intro_text) > 0 && _acc_intro_text != global.acc_last_announce)
    {
        global.acc_last_announce = _acc_intro_text;
        var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
        ossafe_file_text_write_string(_acc_file, _acc_intro_text);
        ossafe_file_text_writeln(_acc_file);
        ossafe_file_text_close(_acc_file);
    }
}"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"    draw_text(name_x, name_y, charname);
    scr_drawtext_centered(160, title_y, scr_gettext(""name_entry_title""));
}",
@"    if (global.acc_enabled == 1)
    {
        var _acc_name_text_fallback = """";
        if (selected_row == -1)
        {
            if (selected_col == 0)
                _acc_name_text_fallback = string(scr_gettext(""name_entry_quit""));
            else if (selected_col == 1)
                _acc_name_text_fallback = string(scr_gettext(""name_entry_backspace""));
            else if (selected_col == 2)
                _acc_name_text_fallback = string(scr_gettext(""name_entry_done""));
        }
        else if (selected_row >= 0 && selected_col >= 0)
        {
            _acc_name_text_fallback = string(charmap[selected_row, selected_col]);
        }

        if (string_length(_acc_name_text_fallback) > 0)
        {
            var _acc_out_fallback = ""Name: "" + _acc_name_text_fallback;
            if (_acc_out_fallback != global.acc_last_announce)
            {
                global.acc_last_announce = _acc_out_fallback;
                var _acc_file_fallback = ossafe_file_text_open_write(global.acc_file_name);
                ossafe_file_text_write_string(_acc_file_fallback, _acc_out_fallback);
                ossafe_file_text_writeln(_acc_file_fallback);
                ossafe_file_text_close(_acc_file_fallback);
            }
        }
    }

    draw_text(name_x, name_y, charname);
    scr_drawtext_centered(160, title_y, scr_gettext(""name_entry_title""));
}"
);

PatchFindReplace(
    "gml_Script_scr_namingscreen",
@"        if (control_check_pressed(0))
            action = selected3;",
@"        if (global.acc_enabled == 1)
        {
            var _acc_menu_text_fallback = """";
            if (selected3 == 0)
                _acc_menu_text_fallback = string(scr_gettext(""instructions_begin""));
            else if (selected3 == 1)
                _acc_menu_text_fallback = string(scr_gettext(""settings_name""));
            else if (selected3 == 2)
                _acc_menu_text_fallback = string(scr_gettext(""load_menu_continue""));

            if (string_length(_acc_menu_text_fallback) > 0)
            {
                var _acc_out_fallback = ""Title Menu: "" + _acc_menu_text_fallback;
                if (_acc_out_fallback != global.acc_last_announce)
                {
                    global.acc_last_announce = _acc_out_fallback;
                    var _acc_file_fallback = ossafe_file_text_open_write(global.acc_file_name);
                    ossafe_file_text_write_string(_acc_file_fallback, _acc_out_fallback);
                    ossafe_file_text_writeln(_acc_file_fallback);
                    ossafe_file_text_close(_acc_file_fallback);
                }
            }
        }

        if (control_check_pressed(0))
            action = selected3;"
);

PatchFindReplace(
    "gml_Object_obj_battlecontroller_Step_0",
@"SCR_BORDERSETUP(0, 0, 0, 0, 0);
currentplace = global.bmenuno;",
@"SCR_BORDERSETUP(0, 0, 0, 0, 0);
currentplace = global.bmenuno;
var _acc_prev_bmenuno = global.bmenuno;
var _acc_prev_b0 = global.bmenucoord[0];
var _acc_prev_b1 = global.bmenucoord[1];
var _acc_prev_b2 = global.bmenucoord[2];
var _acc_prev_b3 = global.bmenucoord[3];
var _acc_prev_b4 = global.bmenucoord[4];
var _acc_prev_hp = global.hp;
var _acc_prev_lv = global.lv;"
);

PatchFindReplace(
    "gml_Object_obj_battlecontroller_Step_0",
@"if (global.debug == 1 && keyboard_check_pressed(vk_space) == 1)
    global.turntimer = 2;",
@"if (global.acc_enabled == 1)
{
    var _acc_out_battle = """";
    var _acc_menu_changed = (global.bmenuno != _acc_prev_bmenuno || global.bmenucoord[0] != _acc_prev_b0 || global.bmenucoord[1] != _acc_prev_b1 || global.bmenucoord[2] != _acc_prev_b2 || global.bmenucoord[3] != _acc_prev_b3 || global.bmenucoord[4] != _acc_prev_b4);

    if (_acc_menu_changed && global.mnfight == 0 && global.myfight == 0)
    {
        if (global.bmenuno == 0)
        {
            if (global.bmenucoord[0] == 0)
                _acc_out_battle = ""Battle: FIGHT"";
            else if (global.bmenucoord[0] == 1)
                _acc_out_battle = ""Battle: ACT"";
            else if (global.bmenucoord[0] == 2)
                _acc_out_battle = ""Battle: ITEM"";
            else if (global.bmenucoord[0] == 3)
                _acc_out_battle = ""Battle: MERCY"";
        }
        else if (global.bmenuno == 1)
        {
            _acc_out_battle = ""Target: "" + string(global.monstername[global.bmenucoord[1]]);
        }
        else if (global.bmenuno == 2)
        {
            _acc_out_battle = ""ACT Target: "" + string(global.monstername[global.bmenucoord[1]]);
        }
        else if (global.bmenuno == 10)
        {
            var _acc_choice = string(global.choice[global.bmenucoord[2]]);
            if (string_length(_acc_choice) > 0)
                _acc_out_battle = ""ACT: "" + _acc_choice;
        }
        else if (global.bmenuno >= 3 && global.bmenuno < 4)
        {
            var _acc_item_index = global.bmenucoord[3] + ((global.bmenuno - 3) * 8);
            _acc_out_battle = ""Item: "" + string(global.itemnameb[_acc_item_index]);
        }
        else if (global.bmenuno == 4)
        {
            if (global.bmenucoord[4] == 0)
                _acc_out_battle = ""MERCY: Spare"";
            else if (global.bmenucoord[4] == 1)
                _acc_out_battle = ""MERCY: Flee"";
        }
    }

    if (global.hp != _acc_prev_hp || global.lv != _acc_prev_lv)
    {
        var _acc_status = ""Status: HP "" + string(global.hp) + ""/"" + string(global.maxhp) + "", LV "" + string(global.lv);
        if (string_length(_acc_out_battle) > 0)
            _acc_out_battle += "" | "" + _acc_status;
        else
            _acc_out_battle = _acc_status;
    }

    if (string_length(_acc_out_battle) > 0)
    {
        var _acc_now = current_time;
        if ((_acc_out_battle != global.acc_last_announce) || ((_acc_now - global.acc_last_announce_time) >= global.acc_min_interval))
        {
            global.acc_last_announce = _acc_out_battle;
            global.acc_last_announce_time = _acc_now;
            var _acc_file = ossafe_file_text_open_write(global.acc_file_name);
            ossafe_file_text_write_string(_acc_file, _acc_out_battle);
            ossafe_file_text_writeln(_acc_file);
            ossafe_file_text_close(_acc_file);
        }
    }
}

if (global.debug == 1 && keyboard_check_pressed(vk_space) == 1)
    global.turntimer = 2;"
);

importGroup.Import();
ScriptMessage("Step 4 hooks applied. Save data.win to keep changes.");
