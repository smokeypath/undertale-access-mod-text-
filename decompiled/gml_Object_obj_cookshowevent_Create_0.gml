con = 0;
image_yscale = 5;

if (global.plot > 134)
{
    instance_destroy();
}
else
{
    obj_mainchara.cutscene = 1;
    view_yview[0] = 240;
    instance_create(0, 0, obj_musfadeout);
    view_object[0] = -4;
}

yoffset1 = 240;
