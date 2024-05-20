%% 生成矩形
lx = 79;    % 矩形的宽度
ly = 104;   % 矩形的高度
R = 10;     % 圆角半径
Mx = 125;   % 矩形中心横坐标
My = 200;   % 矩形中心纵坐标
d = 1;      % 相邻两C点的距离
trace = createRectangle(lx, ly, R, Mx, My, d);

%% 杆长赋值
r1 = 170;
r2 = 150;
r3 = r2;
r4 = r1;

%% 逆运动学求解
x = trace(:,1);
y = trace(:,2);

% 左臂+左臂
theta_2 = asin((x.^2 + y.^2 + r2^2 - r1^2)./(2*r2*sqrt(x.^2 + y.^2))) - atan2(x,y);
theta_1 = acos((x - r2*cos(theta_2)) ./ r1);
theta_3 = acos((r4^2 - r3^2 - y.^2 - (x-250).^2)./(2*r3*sqrt((x-250).^2+y.^2))) + atan2(y,x-250);
theta_4 = asin((-y - r3*sin(theta_3)) ./ r4);

% 左臂+右臂
% theta_2 = asin((x.^2 + y.^2 + r2^2 - r1^2)./(2*r2*sqrt(x.^2 + y.^2))) - atan2(x,y);
% theta_1 = acos((x - r2*cos(theta_2)) ./ r1);
% theta_3 = -acos((r4^2 - r3^2 - y.^2 - (x-250).^2)./(2*r3*sqrt((x-250).^2+y.^2))) + atan2(y,x-250);
% theta_4 = -acos((250 - x - r3*cos(theta_3)) ./ r4);

%% 正运动学求各点坐标
size = length(x);      % 数据量
A = zeros(size, 2);
E = repmat([250,0], size, 1);
B = A + [r1*cos(theta_1), r1*sin(theta_1)];
D = E - [r4*cos(theta_4), r4*sin(theta_4)];
C1 = B + [r2*cos(theta_2), r2*sin(theta_2)];
C2 = D - [r3*cos(theta_3), r3*sin(theta_3)];

%% 导出杆1和杆4角度数据
v = 10;     % C点运动速度
delta_t = d / v;
timeSeries = (0 : delta_t : (size-1)*delta_t)';     % 生成时间序列
initial = [theta_1(1) * 180/pi; theta_4(1) * 180/pi + 180];    % 杆1和杆4的初始角度(将杆4相对D点的角度转化为相对E点的角度)
link1 = [timeSeries, theta_1 * 180/pi - initial(1)];          % 杆1相对转动角度
link4 = [timeSeries, theta_4 * 180/pi + 180 - initial(2)];     % 杆4相对转动角度
fprintf("杆1初始角：%.8f, 杆4初始角：%.8f\n", initial(1), initial(2));
writematrix(link1, "link1.csv");
writematrix(link4, "link4.csv");

%% 模拟动画
createGif(trace, A, B, C1, C2, D, E);

%% 生成动画Gif
function createGif(trace, A, B, C1, C2, D, E)
    filename = 'MatlabAnimation3.gif';
    figure('Position', [100, 100, 800, 800]);
    size = length(trace);
    for i = 1:size
        % 清除上一帧
        clf;
    
        % 绘制点轨迹
        scatter(trace(:,1), trace(:,2), 5, "g", "LineWidth", 1);
        hold on;
    
        % 绘制四根杆
        plot([A(i,1) B(i,1)], [A(i,2) B(i,2)], 'r', 'LineWidth', 4); % 杆1
        hold on;
        plot([B(i,1) C1(i,1)], [B(i,2) C1(i,2)], 'b', 'LineWidth', 4); % 杆2
        hold on;
        plot([C2(i,1) D(i,1)], [C2(i,2) D(i,2)], 'b', 'LineWidth', 4); % 杆3
        hold on;
        plot([D(i,1) E(i,1)], [D(i,2) E(i,2)], 'r', 'LineWidth', 4); % 杆4
        hold on;
        scatter(C1(i,1), C1(i,2), 10, "black", "LineWidth", 2);
        hold on;
    
        % 设置坐标轴
        xlim([-40,290]);
        ylim([-40,290]);
        daspect([1 1 1]);
    
        % 保存动画
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
    
        % 写入GIF文件
        if i == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
        end
    
        % 暂停以控制动画速度
        pause(0.1);
    end
end