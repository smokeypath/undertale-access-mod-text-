with (OBJ_WRITER)
    instance_destroy();

with (obj_insanesq)
    instance_destroy();

with (blcon)
    instance_destroy();

talked = 0;

if (coherent == 0)
    caster_stop(dnoise);

global.mnfight = 2;

with (mypart1)
    event_user(0);
