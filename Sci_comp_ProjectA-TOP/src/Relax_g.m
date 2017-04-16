function [ u,count,error,lamda ] = Relax_g( max_error,nodes,lamda_Start )
%This will slove the APc2-2 for using Gause approximatio 
%   Relax_g will return the solution

%% Inputs 
% error == the ammount of error that you want
% nodes == how fine you want the mesh for the square we are looking at
% lamda_Start == were you want the relaxation to start at. 

%% Outputs
% u == solution 
% Count == how many cycle the solution took to solve
% lamda == the Final Lamda for the solution 
%% Defining the domain of intrest
% X Boundarys  
ax=pi;
bx=-pi;
% Y Boundarys 
ay=pi;
by=-pi;
%% The boundry 
n=nodes;
m=n;
%Domain 
Do=ones(n,m)*0.00001;
x=pi:-(2*pi/(m-1)):-pi;
y=pi:-(2*pi/(n-1)):-pi;
% TOP 
    g=x.*(x-ax).^2;
    Do(1,:)=g;   
%Bottom
    f=(x-ax).^2.*cos((pi.*x)./ax);
    Do(n,:)=f;
%Right hand vertical
%     g=Do(n,end);
%     f=Do(1,end);
    Do(:,m)=g+(y-ay)/(by-ay).*(f-g);
%left hand verical
   % Neuman boundary Condition
u=Do;

%surf(x,y,u,'EdgeColor','none')
%% the solve
F=zeros(n);
%% The function we have to have at every point 
for i=2:1:n-1
        for j=2:1:m-1
           F(i,j)=sin((pi*(x(i)-ax)/(bx-ax)))*cos((pi/2)*(2*(y(j)-ay)/(by-ay)-1));
        end
end
%% solving the PDE

% These are used to help count the error for each cycle. 
u1=0;
u2=0;
% Where we start counting with Lamda
lamda=lamda_Start;
% The scaling ammount for how lamda is helped 
L_add=1/sqrt(nodes);
count=0;
error=100; % Becasue we have not solved it yet the Error is a baseline of 100%

% It will solve untill the error Max error is below the specified value. 

while error > max_error
    
    %% Flow controll for adjusting Lamda 
    if (count == nodes*0.25) && (lamda < 2) % Makes sure that Lamda is less then 2 perconditions 
        lamda=lamda+L_add;
    elseif count == nodes*0.5
         lamda=lamda+2*L_add;
    elseif count == nodes*0.75 
         lamda=lamda+4*L_add;
    end
    %% Solving for U matrix 
    u1=u; % the value before they run though the system 
    for i=2:1:n-1
        for j=2:1:m-1
           u(i,j)=0.25*(u(i+1,j)+u(i-1,j)+u(i,j+1)+u(i,j+1)+F(i,j));
            % The diagonals on the square around the point 
           u(i,j)=0.25*(u(i+1,j+1)+u(i+1,j-1)+u(i-1,j+1)+u(i-1,j+1))+F(i,j);     
        end
    end
u2=u;   % the values after they are calclated. 

error=max(max(abs((u1-u2)./u2)))*100;

u=u2*lamda+(1-lamda)*u1;

count=count+1;

if count== 3000 | lamda == 2
    break
end
%% The Results 
    
error=max(max(abs((u1-u2)./u2)))*100;
count;
%count=(lamda-1)*1000;
% figure(2)
% surf(x,y,u,'EdgeColor','none')

end

