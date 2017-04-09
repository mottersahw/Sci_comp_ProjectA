%% Created by Grant Mottershaw
% 3/19/2017
clear
clc
%% Defining the domain of intrest
% X Boundarys  
ax=pi;
bx=-pi;
% Y Boundarys 
ay=pi;
by=-pi;
%% The boundry 
n=40;
m=n;
Do=ones(n,m)*0.00001;
%Top
    x=pi:-(2*pi/(m-1)):-pi;
    Do(1,:)=x.*(x-ax).^2;   
%Bottom
    Do(n,:)=(x-ax).^2.*cos((pi.*x)./ax);
%Left hand vertical
     y=pi:-(2*pi/(n-1)):-pi;
%left hand verical
    g=Do(n,end);
    f=Do(1,end);
    Do(:,m)=g+(y-ay)/(by-ay)*(f-g);
u=Do;
figure(1)
surf(x,y,u,'EdgeColor','none')
%% the solve
F=zeros(n);
%% The function we have to have at every point 
for i=2:1:n-1
        for j=2:1:m-1
           F(i,j)=sin((pi*(x(i)-ax)/(bx-ax)))*cos((pi/2)*(2*(y(j)-ay)/(by-ay)-1));
        end
end
%% solving the PDE
lamda=0; % to stop the while loop

% These are used to help count the error for each cycle. 
u1=0;
u2=0;

lamda=1;

error=100; % Becasue we have not solved it yet the Error is a baseline of 100%
while error > 0.1 
    lamda=lamda+0.01;
    if lamda == 2 % Makes sure that the Program doesn't run too long 
        break;
    end 
    u1=u; % the value before they run though the system 
    for i=2:1:n-1
        for j=2:1:m-1
            u(i,j)=1/4*(u(i+1,j)+u(i-1,j)+u(i,j+1)+u(i,j+1))+F(i,j);
            % The diagonals on the square around the point 
            u(i,j)=1/4*(u(i+1,j+1)+u(i+1,j-1)+u(i-1,j+1)+u(i-1,j+1))+F(i,j);     
        end
    end
u2=u;   % the values after they are calclated. 
error=max(max(abs((u1-u2)./u2)))*100;

u=u2*lamda+(1-lamda)*u1;
end
%% The Results 
    
error=max(max(abs((u1-u2)./u2)))*100
count=(lamda-1)*1000
figure(2)
surf(x,y,u,'EdgeColor','none')

