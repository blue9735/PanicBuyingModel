%����ƽ���ֻ�������ʱ��仯��ͼ
load ����ʵ����(t=200).mat *Emotion *N *period
%����ÿһ����ƽ���ֻ�����
AverE=zeros(1,period);
for t=1:period
    AverE(t)=mean(Emotion(:,t));
end
%��������ͼ
figure(1);
plot(AverE(:,:));
xlabel('Time')
ylabel('Panic')
axis ( [0 200 0 1] );