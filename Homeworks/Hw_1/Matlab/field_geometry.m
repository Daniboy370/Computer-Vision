function Pts3d_valid = field_geometry
% ----------------------- Description ------------------------ %
%                                                              %
%                Plot soccer field real-Geometry               %
%                                                              %
% ------------------------- Content -------------------------- %

% the soccer goal is 7.32m wide and 2.44m high:
x = 7.32/2;
z = 2.44;
goalframe = [-x x x -x;0 0 0 0;0 0 z z;1 1 1 1];

% the target area is 11 + 7.32m wide and 5.5m deep
xx = 18.32/2;
yy = 5.5;
innerframe = [-xx -xx xx xx;0 yy yy 0;0 0 0 0;1 1 1 1];

% the penalty area is 40.32 m wide and 16.5 m deep
xxx = 40.32/2;
yyy = 16.5;
outerframe = [-xxx -xxx xxx xxx;0 yyy yyy 0;0 0 0 0;1 1 1 1];

Pts3d = [goalframe, innerframe, outerframe];

% Fig();
plot3( Pts3d(1,:), Pts3d(2,:), Pts3d(3,:), '*');
hold on; axis equal; rotate3d on;

% draw frames
for ii=1:3
    for jj=1:4
        jjp=mod(jj,4)+1;
        index=[jj,jjp]+(ii-1)*4;
        plot3(Pts3d(1,index),Pts3d(2,index),Pts3d(3,index),'-', 'linewidth', 4);
    end
end

arrow_lin = 0:.25:1.5; O_lin = zeros(1, length(arrow_lin));
plot3( arrow_lin, O_lin, O_lin, 'r.', 'linewidth', 2);
plot3( O_lin, arrow_lin, O_lin, 'b.', 'linewidth', 2);
plot3( O_lin, O_lin, arrow_lin, 'g.', 'linewidth', 2);

view([-105 10]); grid on;
title('Soccer field geometry', 'fontsize', 16);
Pts3d_valid = Pts3d( :, [1:8 12] );