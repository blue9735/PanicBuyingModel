%恐慌情绪下的群体抢购行为机制研究
%线上的网络模型

%0.初始化
%BA网络下的模型（online或者offline）
load ori-BA.mat *N *A *AA
mat=AA;
%初始化个体异质性特征:个体从众性
load ori_Person.mat *Person
period=100;  
Type=zeros(N,period);

inip1 = 0.06;
%用赌轮法初始化节点
for i=1:N
   r = rand(1);
   if r<inip1
       Type(i,1) = 1; %I
   else
      Type(i,1) = 0; %S
   end
end

%开始感染
rate1 = zeros(period,1); %记录不同时刻易感者比例
rate2 = zeros(period,1); %记录不同时刻感染者比例
rate3 = zeros(period,1); %记录不同时刻免疫者比例
NeedM=zeros(N,period);%记录每一步的个体物资需求
NeedS=zeros(N,period);%记录每一步的个体安全需求
Emotion=zeros(N,period);%记录每一步的个体恐慌情绪
Emotion1=zeros(N,period);%记录每一步的个体形成的恐慌情绪
Emotion2=zeros(N,period);%记录每一步的恐慌情绪传播后的个体情绪
Friend=zeros(N,period);%记录每一步的个体朋友的影响力
T1 = zeros(N,1); %记录从易感者S到感染者I时的时间
T11= zeros(N,1); %记录从感染者I到免疫者R时的时间

load information.mat *Infor_wuzizheng *Infor_wuzifu *Infor_anquanzheng *Infor_anquanfu

for t=1:period
    for i=1:N
        %个体需求
        NeedM(i,t)=(1-(Infor_wuzizheng(i,t)-Infor_wuzifu(i,t)))/2;
        NeedS(i,t)=(1-(Infor_anquanzheng(i,t)-Infor_anquanfu(i,t)))/2;
        %恐慌情绪
        neighbor=find(mat(i,:)~=0);
        num_neighbor=length(neighbor);
        tmp=0;
        str=0;
        for j=1:num_neighbor
            if Type(j,t)==1
                tmp=tmp+1;
            end
        end
        neighbor1=tmp/num_neighbor;%感染者所占比例
        Friend(i,t)=neighbor1*Person(i,1);
        %恐慌情绪的形成
        a1=0.6;
        a2=0.4;
        Emotion(i,t)=a1*NeedM(i,t)+a2*NeedS(i,t)+Friend(i,t);
        if Emotion(i,t)>1
            Emotion(i,t)=1;
        elseif Emotion(i,t)<0
            Emotion(i,t)=0;
        end
        Emotion1(i,t)=Emotion(i,t);
        
        %恐慌情绪的传播
        d1=0.3;%同化阈值
        d2=0.6;%排斥阈值
        mu1=0.2;%同化参数
        mu2=0.2;%排斥参数
        for m=1:num_neighbor
            ne=neighbor(m);%邻居节点的编号
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
        
        %线下抢购行为的传递
        if Type(i,t)==0 %对于易感节点
            %计算感染率（恐慌情绪（个体需求+周围邻居节点影响）
            %感染率
            b1=0.3;
            b2=0.7;
            %ganran=b1*(a1*NeedM(i,t)+a2*(1-NeedS(i,t)))+b2*Emotion(i,t);
            ganran=(1-Emotion(i,t))*(a1*NeedM(i,t)+a2*(1-NeedS(i,t)))+Emotion(i,t)*Emotion(i,t);
            r = rand(1); %赌轮法设置i节点感染状态
            if r<ganran
                Type(i,t+1) = 1; %转化为易感者
                T1(i)=t; %记录转化为感染者的时刻
            else
                Type(i,t+1) = 0;
            end
        elseif Type(i,t)==1 %对于感染节点
            %计算免疫率（时间)
            %计算免疫率（时间）
            c1=1; %遗忘函数参数
            c2=0.01; %遗忘函数参数
            r = rand(1);
            T11(i)=t; %记录节点转化为免疫节点的时刻
            yiwang=c1-exp(-(T11(i)-T1(i))*c2);
            if r < yiwang
                Type(i,t+1) = 2; %转化为免疫者
            else
                Type(i,t+1) = 1;
            end
        elseif Type(i,t)==2 %对于免疫节点
            %计算重新感染率（重复的新闻事件）
            if NeedM(i,t)>NeedM(i,t-1) || NeedS(i,t)<NeedS(i,t-1) %如果新闻导致个体物资需求增强或安全需求降低，个体可能重新回到易感者状态。
            	chongfu=(NeedM(i,t)+(1-NeedS(i,t)))/2;
                %chongfu=1;
                r = rand(1);
                if r<chongfu
                    Type(i,t+1)=0;%转化为易感者
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
        