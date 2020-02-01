p = parrot('Mambo');

takeoff(p);

[height,time] = readHeight(p);

while (height > 0.1 && height < 1.5 && p.BatteryLevel > 10)
    moveup(p, 1);
    
    while (height > 0.1 && height < 1.0)
        moveforward(p, 1);
    end
    
    while (height > 1.0)
        movedown(p, 1);
    end
end

land(p);
clear p;