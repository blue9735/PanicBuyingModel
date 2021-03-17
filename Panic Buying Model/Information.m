%构建外部新闻强度矩阵
N=1000;
%第一阶段，物资正面信息强度0.34负面0.67，安全负面新闻0.13
i11=0.34;
i21=0.67;
i31=0;
i41=0.13;
Infor_wzz=normrnd(i11,0.15,[N,1]); %关于物资的正面新闻强度为i1的正态分布
Infor_wzz(Infor_wzz>1)=1;
Infor_wzz(Infor_wzz<0)=0;
Infor_wzf=normrnd(i21,0.15,[N,1]); %关于物资的负面新闻强度为i2的正态分布
Infor_wzf(Infor_wzf>1)=1;
Infor_wzf(Infor_wzf<0)=0;
Infor_aqz=normrnd(i31,0.15,[N,1]); %关于安全的正面新闻强度为i1的正态分布
Infor_aqz(Infor_aqz>1)=1;
Infor_aqz(Infor_aqz<0)=0;
Infor_aqf=normrnd(i41,0.15,[N,1]); %关于安全的负面新闻强度为i1的正态分布
Infor_aqf(Infor_aqf>1)=1;
Infor_aqf(Infor_aqf<0)=0;

%第二阶段，物资正面新闻0.36，负面新闻1，安全负面新闻0.19
i12=0.36;
i22=1;
i32=0;
i42=0.19;
Infor_wzz2=normrnd(i12,0.15,[N,1]); %关于物资的正面新闻强度为i1的正态分布
Infor_wzz2(Infor_wzz2>1)=1;
Infor_wzz2(Infor_wzz2<0)=0;
Infor_wzf2=normrnd(i22,0.15,[N,1]); %关于物资的负面新闻强度为i2的正态分布
Infor_wzf2(Infor_wzf2>1)=1;
Infor_wzf2(Infor_wzf2<0)=0;
Infor_aqz2=normrnd(i32,0.15,[N,1]); %关于安全的正面新闻强度为i1的正态分布
Infor_aqz2(Infor_aqz2>1)=1;
Infor_aqz2(Infor_aqz2<0)=0;
Infor_aqf2=normrnd(i42,0.15,[N,1]); %关于安全的负面新闻强度为i1的正态分布
Infor_aqf2(Infor_aqf2>1)=1;
Infor_aqf2(Infor_aqf2<0)=0;


I1=Infor_wzz;
I2=Infor_wzf;
I3=Infor_aqz;
I4=Infor_aqf;
I12=Infor_wzz2;
I22=Infor_wzf2;
I32=Infor_aqz2;
I42=Infor_aqf2;
I13=zeros(N,1);
I23=zeros(N,1);
I33=zeros(N,1);
I43=zeros(N,1);
Infor_wuzizheng=zeros(1000,100);
Infor_wuzifu=zeros(1000,100);
Infor_anquanzheng=zeros(1000,100);
Infor_anquanfu=zeros(1000,100);
for t=1:100
    Infor_wuzizheng(:,t)=I1;
    Infor_wuzifu(:,t)=I2;
    Infor_anquanzheng(:,t)=I3;
    Infor_anquanfu(:,t)=I4;
end
%{
for t=21:79
    Infor_wuzizheng(:,t)=I13;
    Infor_wuzifu(:,t)=I23;
    Infor_anquanzheng(:,t)=I33;
    Infor_anquanfu(:,t)=I43;
end
%}
for t=101:200
    Infor_wuzizheng(:,t)=I12;
    Infor_wuzifu(:,t)=I22;
    Infor_anquanzheng(:,t)=I32;
    Infor_anquanfu(:,t)=I42;
end