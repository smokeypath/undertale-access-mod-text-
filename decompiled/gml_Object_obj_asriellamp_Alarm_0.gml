snd_play(snd_noise);

if (background_visible[1] == true)
{
    background_visible[0] = true;
    background_visible[1] = false;
    idealvolume[0] = 0;
    idealvolume[1] = 1;
}
else
{
    background_visible[0] = false;
    background_visible[2] = false;
    background_visible[1] = true;
    idealvolume[0] = 1;
    idealvolume[1] = 0;
}

myinteract = 0;
global.interact = 0;
