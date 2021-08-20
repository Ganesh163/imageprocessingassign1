%% MyMainScript

tic;
%% Your code here
J1 = imread("../images/T1.jpg");
J2 = imread("../images/T2.jpg");
J3 = imrotate(J2,28.5,'crop');
imshow(J3);
%%%%%%%%%%%% NCC %%%%%%%%%%%%%%%%%%%%%%%%%
x = mean(mean(J1));
J11 = double(J1)-x;
J1e = sum(sum(J11.^2));
ncc = [];
t2 = -45:1:45;
for t = -45:1:45 
    J4 = imrotate(J3,t,'crop');
    J42 = double(J4) - mean(J4(:));
    J14 = sum(sum((J11.*J42)));
    J4e = sum(sum(J42.^2));
    ncc(end+1) = abs(J14/((J1e*J4e)^0.5)); %Calculating cross correlation for each image
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%Joint Entropy%%%%%%%%%%%%%%%%%%%%
[r,c] = size(J1);
Je = zeros(1,91);
for t = -45:1:45
    J4 = imrotate(J3,t,'crop');
    J14p = zeros(256,256);
    for i=1:r
        for j=1:c
            z=J1(i,j);
            z1 = J4(i,j);
            J14p(z+1,z1+1) = J14p(z+1,z1+1)+1; 
        end
    end
    if (t == -28)
        J14po = J14p;
    end
    J14p = J14p./(r*c);
    for i=1:256
     for j=1:256
         if(J14p(i,j) ~=0)
             Je(45+t+1) = Je(45+t+1)-J14p(i,j)*log(J14p(i,j)); %Calculating Joint Entropy for each image
         end
     end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%QMI%%%%%%%%%%%%%%%%%%%%%%%%%%
qmi = [];
for t = -45:1:45
    J4 = imrotate(J3,t,'crop');
    J14p = zeros(26,26);
    for i=1:r
        for j=1:c
            z=idivide(J1(i,j),10);
            z1=idivide(J4(i,j),10);
            J14p(z+1,z1+1) = J14p(z+1,z1+1)+1; 
        end
    end
    J14p = J14p./(r*c);
    J4p = sum(J14p)/sum(sum(J14p));
    J1p = sum(J14p')/sum(sum(J14p));
    qm = 0;
    for a=1:26
     for b=1:26
             qm = qm+(J14p(a,b)-J1p(a)*J4p(b))^2;
     end
    end
    qmi(end+1) = qm; % Calculating QMI for each image
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Part C%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
plot(t2,ncc);
figure(3);
plot(t2,Je);
figure(4)
plot(t2,qmi);
%%%%%%%%%%%%%Part E%%%%%%%%%%%%%%%%%%%%%%
figure(5);
J14poprime = uint8(J14po);
imagesc(J14poprime);
colorbar;
toc;