
parrotObj = parrot; % Create a parrot object.

nnet = googlenet;   % Create a GoogLeNet neural network object.

takeoff(parrotObj); % Start the drone flight 

camObj = camera(parrotObj, 'FPV');% Create a connection to the drone's FPV camera

tOuter= tic;
i=0;

% imtool  <-- Bild
% Move the drone forward for 2 seconds along the edges of a square path. Capture the image of an object, and classify it while the drone moves forward.
while(toc(tOuter)<=30 && parrotObj.BatteryLevel>20)
    tInner = tic;
    % Keep moving the drone for 2 seconds along each square path edge
    while(toc(tInner)<=2)
        
        moveforward(parrotObj);                        % Move the drone forward for default time of 0.5 seconds (nonblocking behaviour)
%        flip(parrotObj,'forward');
        moveup(parrotObj,5);
        picture = snapshot(camObj);                    % Capture image from drone's FPV camera
        resizedPicture = imresize(picture,[224,224]);  % Resize the picture
        label = classify(nnet,resizedPicture);         % Classify the picture
        imshow(picture);                               % Show the picture
        title(char(label));                            % Show the label
        drawnow;
        %imwrite (picture, 'FPV_drone.png');
        imwrite(picture,sprintf('%d.jpg',i));
        i = i +1;
        movedown(parrotObj, 8)
        %'C:\myFolder\myImage.ext'
   end
    turn(parrotObj,deg2rad(90));                       % Turn the drone by pi/2 radians
end

land(parrotObj); % Land the drone.


%When finished clear the connection to the Parrot drone, the FPV camera, and GoogLeNet
clear parrotObj;
clear camObj;
clear nnet;


%for i=1:10
%   imwrite(x,sprintf('%d.jpg',i))
%end;