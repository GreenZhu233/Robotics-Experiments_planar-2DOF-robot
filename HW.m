% 生成矩形
trace = createRectangle(79, 104, 10, 125, 200, 5);

% 杆长赋值
r1 = 236;
r2 = 100;
r3 = r2;
r4 = r1;

% 逆运动学求解
x = trace(:,1);
y = trace(:,2);
theta_2 = asin((x.^2 + y.^2 + r2^2 - r1^2)./(2*r2*sqrt(x.^2 + y.^2))) - atan2(x,y);
theta_1 = acos((x - r2*cos(theta_2)) ./ r1);
theta_3 = -acos((r4^2 - y.^2 - (x-250).^2)./(2*r3*sqrt((x-250).^2+y.^2))) + atan2(y,x-250);
theta_4 = -acos((250-x-r3*cos(theta_3)) ./ r4);

% 正运动学求各点坐标
size = length(x);      % 数据量
A = zeros(size, 2);
E = repmat([250,0], size, 1);
B = A + [r1*cos(theta_1), r1*sin(theta_1)];
D = E - [r4*cos(theta_4), r4*sin(theta_4)];
C = B + [r2*cos(theta_2), r2*sin(theta_2)];

% 模拟动画
figure;
while(1)
for i = 1:size
    % 清除上一帧
    clf;

    % 绘制点轨迹
    scatter(trace(:,1), trace(:,2), 5, "g", "LineWidth", 1);
    hold on;

    % 绘制四根杆
    plot([A(i,1) B(i,1)], [A(i,2) B(i,2)], 'r', 'LineWidth', 4); % 杆1
    hold on;
    plot([B(i,1) C(i,1)], [B(i,2) C(i,2)], 'b', 'LineWidth', 4); % 杆2
    hold on;
    plot([D(i,1) C(i,1)], [D(i,2) C(i,2)], 'b', 'LineWidth', 4); % 杆3
    hold on;
    plot([D(i,1) E(i,1)], [D(i,2) E(i,2)], 'r', 'LineWidth', 4); % 杆4
    hold on;

    % 设置坐标轴
    xlim([-40,290]);
    ylim([-40,290]);
    daspect([1 1 1]);

    % 暂停以控制动画速度
    pause(0.1);
end
end