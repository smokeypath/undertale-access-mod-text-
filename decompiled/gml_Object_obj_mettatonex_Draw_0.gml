if (global.debug == 1)
{
    if (keyboard_check_pressed(ord("A")))
        turns -= 1;
    
    if (keyboard_check_pressed(ord("S")))
        turns += 1;
}
