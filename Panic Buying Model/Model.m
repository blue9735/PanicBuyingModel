%�ֻ������µ�Ⱥ��������Ϊ�����о�
%���ϵ�����ģ��

%0.��ʼ��
%BA�����µ�ģ�ͣ�online����offline��
load ori-BA.mat *N *A *AA
mat=AA;
%��ʼ����������������:���������
load ori_Person.mat *Person
period=100;  
Type=zeros(N,period);

inip1 = 0.06;
%�ö��ַ���ʼ���ڵ�
for i=1:N
   r = rand(1);
   if r<inip1
       Type(i,1) = 1; %I
   else
      Type(i,1) = 0; %S
   end
end

%��ʼ��Ⱦ
rate1 = zeros(period,1); %��¼��ͬʱ���׸��߱���
rate2 = zeros(period,1); %��¼��ͬʱ�̸�Ⱦ�߱���
rate3 = zeros(period,1); %��¼��ͬʱ�������߱���
NeedM=zeros(N,period);%��¼ÿһ���ĸ�����������
NeedS=zeros(N,period);%��¼ÿһ���ĸ��尲ȫ����
Emotion=zeros(N,period);%��¼ÿһ���ĸ���ֻ�����
Emotion1=zeros(N,period);%��¼ÿһ���ĸ����γɵĿֻ�����
Emotion2=zeros(N,period);%��¼ÿһ���Ŀֻ�����������ĸ�������
Friend=zeros(N,period);%��¼ÿһ���ĸ������ѵ�Ӱ����
T1 = zeros(N,1); %��¼���׸���S����Ⱦ��Iʱ��ʱ��
T11= zeros(N,1); %��¼�Ӹ�Ⱦ��I��������Rʱ��ʱ��

load information.mat *Infor_wuzizheng *Infor_wuzifu *Infor_anquanzheng *Infor_anquanfu

for t=1:period
    for i=1:N
        %��������
        NeedM(i,t)=(1-(Infor_wuzizheng(i,t)-Infor_wuzifu(i,t)))/2;
        NeedS(i,t)=(1-(Infor_anquanzheng(i,t)-Infor_anquanfu(i,t)))/2;
        %�ֻ�����
        neighbor=find(mat(i,:)~=0);
        num_neighbor=length(neighbor);
        tmp=0;
        str=0;
        for j=1:num_neighbor
            if Type(j,t)==1
                tmp=tmp+1;
            end
        end
        neighbor1=tmp/num_neighbor;%��Ⱦ����ռ����
        Friend(i,t)=neighbor1*Person(i,1);
        %�ֻ��������γ�
        a1=0.6;
        a2=0.4;
        Emotion(i,t)=a1*NeedM(i,t)+a2*NeedS(i,t)+Friend(i,t);
        if Emotion(i,t)>1
            Emotion(i,t)=1;
        elseif Emotion(i,t)<0
            Emotion(i,t)=0;
        end
        Emotion1(i,t)=Emotion(i,t);
        
        %�ֻ������Ĵ���
        d1=0.3;%ͬ����ֵ
        d2=0.6;%�ų���ֵ
        mu1=0.2;%ͬ������
        mu2=0.2;%�ų����
        for m=1:num_neighbor
            ne=neighbor(m);%�ھӽڵ�ı��
            dij=Emotion(i,t)-Emotion(ne,t);
            if abs(dij)<d1
                Emotion(i,t)=Emotion(i,t)-mu1*dij;
            elseif abs(dij)>d2
                Emotion(i,t)=Emotion(i,t)+mu1*dij;
            else
                Emotion(i,t)=Emotion(i,t);
            end
            if Emotion(i,t)>1
                Emotion(i,t)=1;
            elseif Emotion(i,t)<0
                Emotion(i,t)=0;
            end    
        end
        Emotion2(i,t)=Emotion(i,t);
        
        %����������Ϊ�Ĵ���
        if Type(i,t)==0 %�����׸нڵ�
            %�����Ⱦ�ʣ��ֻ���������������+��Χ�ھӽڵ�Ӱ�죩
            %��Ⱦ��
            b1=0.3;
            b2=0.7;
            %ganran=b1*(a1*NeedM(i,t)+a2*(1-NeedS(i,t)))+b2*Emotion(i,t);
            ganran=(1-Emotion(i,t))*(a1*NeedM(i,t)+a2*(1-NeedS(i,t)))+Emotion(i,t)*Emotion(i,t);
            r = rand(1); %���ַ�����i�ڵ��Ⱦ״̬
            if r<ganran
                Type(i,t+1) = 1; %ת��Ϊ�׸���
                T1(i)=t; %��¼ת��Ϊ��Ⱦ�ߵ�ʱ��
            else
                Type(i,t+1) = 0;
            end
        elseif Type(i,t)==1 %���ڸ�Ⱦ�ڵ�
            %���������ʣ�ʱ��)
            %���������ʣ�ʱ�䣩
            c1=1; %������������
            c2=0.01; %������������
            r = rand(1);
            T11(i)=t; %��¼�ڵ�ת��Ϊ���߽ڵ��ʱ��
            yiwang=c1-exp(-(T11(i)-T1(i))*c2);
            if r < yiwang
                Type(i,t+1) = 2; %ת��Ϊ������
            else
                Type(i,t+1) = 1;
            end
        elseif Type(i,t)==2 %�������߽ڵ�
            %�������¸�Ⱦ�ʣ��ظ��������¼���
            if NeedM(i,t)>NeedM(i,t-1) || NeedS(i,t)<NeedS(i,t-1) %������ŵ��¸�������������ǿ��ȫ���󽵵ͣ�����������»ص��׸���״̬��
            	chongfu=(NeedM(i,t)+(1-NeedS(i,t)))/2;
                %chongfu=1;
                r = rand(1);
                if r<chongfu
                    Type(i,t+1)=0;%ת��Ϊ�׸���
                else
                    Type(i,t+1)=2;
                end
            else
                Type(i,t+1)=2;
            end
        end
    end
end

for t=1:period
    rate1(t)=length(find(Type(:,t)==0));
    rate2(t)=length(find(Type(:,t)==1));
    rate3(t)=length(find(Type(:,t)==2));
end
plot(rate1);
hold on
plot(rate2);
hold on
plot(rate3);
hold on
legend('S','I','R')
xlabel('Time')
ylabel('Agent')
        