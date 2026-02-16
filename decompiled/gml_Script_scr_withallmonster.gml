if (argument0 == 0)
{
    for (i = 0; i < 3; i += 1)
    {
        if (global.monster[i] == 1)
        {
            with (global.monsterinstance[i])
                whatiheard = argument1;
        }
    }
}
