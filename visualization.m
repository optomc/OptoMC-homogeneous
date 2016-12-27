load '1e6_photons.mat'
% load '1e5_photons.mat'

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