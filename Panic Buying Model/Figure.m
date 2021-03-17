%绘制平均恐慌情绪随时间变化的图
load 仿真实验结果(t=200).mat *Emotion *N *period
%计算每一步的平均恐慌情绪
AverE=zeros(1,period);
for t=1:period
    AverE(t)=mean(Emotion(:,t));
end
%绘制曲线图
figure(1);
plot(AverE(:,:));
xlabel('Time')
ylabel('Panic')
axis ( [0 200 0 1] );