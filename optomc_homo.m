%% Initiation
clc;clear;

MC.numPhotons=1e5;             % maximum number of input photon
MC.mus=11.5;                   % 473 nm scattering coefficient [mm^-1]
MC.mua=0.1;                    % 473 nm absorption coefficient [mm^-1] 
MC.g=0.87;                     % 473 nm anisotropy factorMC.n=1.36;                      % Gray matter reflective index
MC.NA=0.39;
MC.nAir=1.0;                   % sample refractive idx, NOTE: Air - 1.0, Water - 1.33, Gray Matter - 1.36
MC.nMedium=1.36;               % sample refractive idx, NOTE: Air - 1.0, Water - 1.33, Gray Matter - 1.36
MC.rFiber=0.1;                 % optical fiber radius [mm], 200 um dia.

fiberTipPower = 8;             % initial light output power at fiber tip [mW]  
zRes = 0.01;
rRes = 0.01;
Irr = zeros(201,201,201);        % r = 2mm, z = 2mm, dimension of a recording cube
area = rRes*rRes;
volume = rRes*rRes*zRes;

wdPlane.pos=[0 0 0];             % location of tissue surface (plane)
wdPlane.normal=[0 0 -1];         % normal direction of surface (plane)

%% doMcRun
tic;
fprintf('This is Monte Carlo simulation\n');
fprintf('# of photon : %d\n', MC.numPhotons);

photon.Dead = 0;
for iPhoton=1:MC.numPhotons
    photon.Dead = 0;

    maxDist = exprnd(1/MC.mua);
    
    if (MC.mua == 0)
        maxDist = 10;
    end
    
    totalDist = 0;    
    
    if mod(iPhoton, 1000) == 0
        disp(num2str(iPhoton));
    end
    
    radius = sqrt(rand()*MC.rFiber^2);     %uniform transverse distribution (top-hat profile)
    theta = rand()*2*pi;
    x = radius*cos(theta);
    y = radius*sin(theta);

    % source position
    photonPos=[x y 0]; 
    photonPrevPos=photonPos;  
    photonDir=launchEffNA(MC.NA,MC.nMedium);    %uniform angular distribution within NA

%% scattering   
    while (photon.Dead ~= 1)   
%         stepInLoop = stepInLoop + 1;
        s=stepSize(MC);	

        totalDist = totalDist + s;
        if totalDist > maxDist
            s = s - (totalDist - maxDist);
            totalDist = maxDist;
            photon.Dead = 1;
        end
 
        photonPrevPos = photonPos;
        photonPos = photonPrevPos + s * photonDir;
        photonDir = spin(MC, photonDir);        
%         Photon{iPhoton}(2+stepInLoop,:)=photonPos;          

        % Find out imaginary plane between each step
        if (sign(photonDir(3))>0)
        	% find closest and furthermost imaginary plane
        	zClosestPlane = ceil(photonPrevPos(3)/zRes)*zRes;
        	zFurtherPlane = floor(photonPos(3)/zRes)*zRes;
        	zPlanePos = zClosestPlane:zRes:zFurtherPlane;                
        else
        	% find closest and furthermost imaginary plane
        	zClosestPlane = floor(photonPrevPos(3)/zRes)*zRes;
        	zFurtherPlane = ceil(photonPos(3)/zRes)*zRes;
        	zPlanePos = zClosestPlane:-zRes:zFurtherPlane;
        end        
        
        % Recording local intensity
        for i=1:numel(zPlanePos)
            % ray/plane intersect for recording
            zPlane.pos = [0 0 zPlanePos(i)];
            zPlane.normal = [0 0 -1];
            t = rayPlaneIntersects(zPlane, photonPrevPos, photonDir);   
            photonPlane = photonPrevPos+t*photonDir;
                    
            xImgId = round(photonPlane(1)/rRes)+101;
            yImgId = round(photonPlane(2)/rRes)+101;
            zImgId = round(zPlanePos(i)/zRes)+1;         
            
            if (xImgId < 1 || yImgId < 1 || zImgId < 1 || xImgId > 200 || yImgId > 200 || zImgId > 200)
                break;  %define boundary
            end
            Irr(xImgId, yImgId, zImgId) = Irr(xImgId, yImgId, zImgId) + 1;
        end
        
        % Photon termination
        if (photonPos(3) >= 2 || photonPos(3) <= 0)         
             break;
        end
    end
end
time=toc;

nIrr = ((Irr./MC.numPhotons)./area)*fiberTipPower;  % volumetric intensity
sIrr = squeeze(nIrr(101,:,:))';                     % define observation plane

%% Visualization
close all;
 
figure(1);
subplot(221)
zz = (1:201)*0.01;
yy = ((1:201)-101)*0.01;
imagesc(yy, zz, log(sIrr));
xlabel('Distance y [mm]', 'FontSize',12,'fontWeight','bold');
ylabel('Depth z [mm]', 'FontSize',12,'fontWeight','bold'); colorbar;
title('Intensity map (semilog scale)', 'FontSize',12,'fontWeight','bold');
set(gca, 'FontSize',12,'fontWeight','bold'); set(gcf,'color','w');
 
subplot(222)
zz = (1:201)*0.01;
yy = ((1:201)-101)*0.01;
imagesc(yy, zz, (sIrr));
xlabel('Distance y [mm]', 'FontSize',12,'fontWeight','bold');
ylabel('Depth z [mm]', 'FontSize',12,'fontWeight','bold'); colorbar;
title('Intensity map (linear scale)', 'FontSize',12,'fontWeight','bold');
set(gca, 'FontSize',12,'fontWeight','bold'); set(gcf,'color','w');
 
subplot(223)
plot(log(sIrr(:,100)));
title('On-Axis Intensity (semilog scale) [A.U]', 'FontSize',12,'fontWeight','bold');
xlabel('Depth z [mm]', 'FontSize',12,'fontWeight','bold');
set(gca, 'FontSize',12,'fontWeight','bold'); set(gcf,'color','w'); 

subplot(224)
plot((sIrr(:,100)));
title('On-Axis Intensity (linear scale) [A.U]', 'FontSize',12,'fontWeight','bold');
xlabel('Depth z [mm]', 'FontSize',12,'fontWeight','bold');
set(gca, 'FontSize',12,'fontWeight','bold'); set(gcf,'color','w'); 

disp(time);