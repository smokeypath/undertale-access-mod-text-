global.msc += 1;
stringno = 0;
stringpos = 1;
writingx = round(writingx);
writingy = round(writingy);
myx = writingx;
myy = writingy;
script_execute(SCR_TEXT, global.msc);

for (n = 0; global.msg[n] != "%%%"; n += 1)
    mystring[n] = global.msg[n];

originalstring = scr_replace_buttons_pc(mystring[0]);
halt = 0;
alarm[0] = textspeed;
