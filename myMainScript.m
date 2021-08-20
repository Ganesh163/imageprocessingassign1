%% MyMainScript

tic;
%% Your code here

im1 = imread('../images/goi1.jpg');
im2 = imread('../images/goi2_downsampled.jpg');

%%%%%%%%%%%%%%%%% A - Reading Image %%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:12
    figure(1); imshow(im1); [x1(i), y1(i)] = ginput(1);
    figure(2); imshow(im2); [x2(i), y2(i)] = ginput(1);
end

%%%%%%%%%%%%%%%%%%% B - Affine Transformation %%%%%%%%%%%%%%%%%%
I1 = [x1;y1;ones(1,12)];
I2 = [x2;y2;ones(1,12)];

T = I2*pinv(I1); 
%%%%%%%%%%%%%%%%%%%%%%% Finding Coordinates %%%%%%%%%%%%%%%%%%
B = []; % Taking all coordinates in the form of (x,y,1)'
for i = 1:361
    A = [];
    for j = 1:641
        A = [A,[i-1,j-1,1]'];
    end
    B = [B,A];
end
C = T*B; % Applying transform to coordinates
%%%%%%%%%%%%%%% C - Nearest Neighbour Interpolation %%%%%%%%%%%%%%%
D = round(C); % Finding nearest neighbour

im3 = zeros(360,640);
[r,s] = size(D);
for i = 1:s
    if(D(1,i) < 360 && D(2,i) < 640 && D(1,i)>=0 && D(2,i)>=0)
        im3(B(1,i)+1,B(2,i)+1) = im1(D(1,i)+1,D(2,i)+1); % Select and update intensity values
    end
end
figure(3);
imshow(mat2gray(im3));
%%%%%%%%%%%%%%%%% D - Bilinear Interpolation %%%%%%%%%%%%%%%%%%%% 
E = floor(C); % (x1,y1)
F = ceil(C); % (x2,y2)
im4 = zeros(360,640); % Creating new image
for i = 1:s
    if(E(1,i) < 360 && F(1,i) < 360 && E(2,i) < 640 && F(2,i) < 640 && E(1,i) >= 0 && F(1,i) >= 0 && E(2,i) >= 0 && F(2,i) >= 0)
        xx2 = ((F(1,i) - C(1,i))/(F(1,i) - E(1,i)));
        xx1 = ((C(1,i) - E(1,i))/(F(1,i) - E(1,i)));
        x11 =  xx2*(im1(E(1,i)+1,E(2,i)+1)) + xx1*(im1(F(1,i)+1,E(2,i)+1)); % Selecting corresponding intensities
        x22 =  xx2*(im1(E(1,i)+1,F(2,i)+1)) + xx1*(im1(F(1,i)+1,F(2,i)+1)); % Selecting corresponding intensities
        yy2 = ((F(2,i) - C(2,i))/(F(2,i) - E(2,i)));
        yy1 = ((C(2,i) - E(2,i))/(F(2,i) - E(2,i)));
        im4(B(1,i)+1,B(2,i)+1) = yy2*(x11)+ yy1*(x22); % Updating intensity values
    end
end
figure(4);
imshow(mat2gray(im4))
figure(5);
imshow(im2);
figure(6);
imshow(im1);
toc;