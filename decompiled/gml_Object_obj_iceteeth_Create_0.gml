pop = scr_monstersum();

if (instance_exists(obj_jerry))
{
    if (obj_jerry.ditch == 0)
        pop -= 1;
}

y = (y - 120) + random(40);
vspeed = 4.2;
friction = 0.1;
dmg = 0;
toothspeed = -0.1;
toothdist = 265;

if (pop == 2)
{
    y -= 25;
    toothdist += 50;
}

if (pop == 3)
{
    y -= 35;
    toothdist += 70;
}

seed = random(40);

for (i = 0; (global.idealborder[0] + (i * 5)) < global.idealborder[1]; i += 1)
{
    toothxx[i] = global.idealborder[0] + (i * 5);
    maxi = i;
}

factor = (4 * pi) / maxi;

for (i = 0; (global.idealborder[0] + (i * 5)) < global.idealborder[1]; i += 1)
    toothyy[i] = y + (sin(seed + (i * factor)) * 30);
