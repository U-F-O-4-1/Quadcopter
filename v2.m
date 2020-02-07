%Drohne macht bei jedem Step ein Foto und schickt es an Basisstation
%Drohne zeigt wie viele Steps sie gefolgen ist -> Daraus kann man berechnen
%nach wie vielen Metern der Unfall kommt
%aber man kann die Drohne nicht über land(parrot) im command window zum
%landen bringen
%funktioniert

p = parrot('Mambo');

nnet = googlenet;   % Create a GoogLeNet neural network object.

takeoff(p);

[height,time] = readHeight(p);

camObj = camera(p, 'FPV');% Create a connection to the drone's FPV camera

tOuter= tic;
i=0;        % Beschriftung für die Bilder
y = 0;      % Anzahl der Steps Forward

while (height > 0.1 && height < 1.0 && toc(tOuter)<=30 && p.BatteryLevel > 10 && y < 4)
    tInner = tic;
    moveup(p, 1);
  
    while (height > 0.1 && height < 1.0 && y < 4)
        moveforward(p, 1);
        y = y + 1;
        picture = snapshot(camObj);                    % Capture image from drone's FPV camera
        resizedPicture = imresize(picture,[224,224]);  % Resize the picture
        label = classify(nnet,resizedPicture);         % Classify the picture
        imshow(picture);                               % Show the picture
        title(char(label));                            % Show the label
        drawnow;
        %imwrite (picture, 'FPV_drone.png');
        imwrite(picture,sprintf('%d.jpg',i));
        i = i +1;
        %return
        %if return = c continue, if return = b; break; if b = back
    end
    
    while (height > 1.0)
        movedown(p, 1);
    end
    
%     while (height < 0.1)
%         moveup(p, 1);
%     end
end

land(p);
disp(y);

clear p;