function points = createRectangle(lx,ly,R,Mx,My,d)
%CREATERECTANGLE 此处显示有关此函数的摘要
%   lx为矩形的宽，ly为矩形的高，R为圆角半径，Mx和My为矩形中心坐标，d为相邻两点的距离
    % 下边
    startP = [Mx-lx/2+R; My-ly/2];
    [points_1, ~, remain] = straightLine(startP, lx-2*R, d, [1;0]);

    % 右下弧
    startA = (d - remain) / R - pi/2;
    cx = Mx + lx/2 - R;
    cy = My - ly/2 + R;
    [points_2, ~, remain] = arc(cx, cy, R, startA, 0, d, 1);

    % 右边
    startP = [Mx + lx/2; My - ly/2 + R + d - remain];
    [points_3, ~, remain] = straightLine(startP, ly-2*R-d+remain, d, [0;1]);

    % 右上弧
    startA = (d - remain) / R;
    cx = Mx + lx/2 - R;
    cy = My + ly/2 - R;
    [points_4, ~, remain] = arc(cx, cy, R, startA, pi/2, d, 1);

    % 上边
    startP = [Mx + lx/2 - R - d + remain; My + ly/2];
    [points_5, ~, remain] = straightLine(startP, lx-2*R-d+remain, d, [-1;0]);

    % 左上弧
    startA = (d - remain) / R + pi/2;
    cx = Mx - lx/2 + R;
    cy = My + ly/2 - R;
    [points_6, ~, remain] = arc(cx, cy, R, startA, pi, d, 1);

    % 左边
    startP = [Mx - lx/2; My + ly/2 - R - d + remain];
    [points_7, ~, remain] = straightLine(startP, ly-2*R-d+remain, d, [0;-1]);

    % 左下弧
    startA = (d - remain) / R + pi;
    cx = Mx - lx/2 + R;
    cy = My - ly/2 + R;
    [points_8, ~, ~] = arc(cx, cy, R, startA, 3*pi/2, d, 1);

    % 总和
    points = [points_1;points_2;points_3;points_4;points_5;points_6;points_7;points_8];
end

%% 在直边上生成点
function [points, size, remain] = straightLine(startP, len, d, direction)
% start:起始位置 len:线段长度 d:点的距离 direction:点生成方向([;]) remain:剩余的长度
    size = floor(len / d);
    remain = mod(len, d);
    points = zeros(size, 2);
    pos = startP;
    for i = 1:size
        points(i,:) = pos;
        pos = pos + d * direction;
    end
end

%% 在圆弧上生成点
function [points, size, remain] = arc(cx, cy, R, startA, endA, d, direction)
% cx:圆心横坐标 cy:圆心纵坐标 R:半径 startA:起始角度 endA:重点角度 d:点的距离 direction:方向(1 or -1)
    len = R * (endA - startA);
    size = floor(len / d);
    remain = mod(len, d);
    points = zeros(size, 2);
    theta = startA;
    for i = 1:size
        points(i,:) = [cx + R*cos(theta); cy + R*sin(theta)];
        theta = theta + direction * d / R;
    end
end