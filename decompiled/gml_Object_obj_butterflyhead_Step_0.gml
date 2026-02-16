if (shake > 0)
{
    x = (nowx + random(shake)) - random(shake);
    y = (nowy + random(shake)) - random(shake);
}

if (walking == 1)
    nowx -= 1;

factor += 0.04;
