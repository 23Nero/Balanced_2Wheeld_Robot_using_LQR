close all; 
clearvars; 
clc;
%% Thông số hệ thống xe 2 bánh tự cân bằng dùng LQR
m = 0.042; %Khoi luong banh xe
M = 1.08; %Khoi luong robot
R = 0.0325; %ban kinh ban xe
W = 0.170; %Chieu rong robot
D = 0.100; %Chieu ngang robot
H = 0.1415; %Chieu cao robot
L = H/2; %khoang cach tu trong tam den truc banh xe
fw = 0.18; %He so ma sat giua banh xe voi mat phang
fm = 0.002; %he so ma sat giua dong co va robot
Jm = 0.01; %moment quan tinh cua dong co
Jw = m*R^2/2;
J_psi = 2*M*L^2/3;
J_phi = M*(W^2+D^2)/12;
Rm = 50; %Dien tro dong co DC
Kb = 0.468; %he so emf cua dong co
Kt = 0.317; %Momen xoan cua dong co DC
n = 30; %Ty so giam toc
g = 9.81; %Gia toc trong truong
alpha = n*Kt/Rm; beta=n*Kt*Kb/Rm+fm; a =alpha;
%T=0.01;
% Trạng thái ban đầu
x1_init=0.001; x2_init=0.001;x3_init=0.002; 
x4_init=0.002; x5_init=0.002; x6_init=0.003;
%% Thiet ke bo dieu khien LQR
% Tai vi tri can bang x=0, u=0
x1=0;x2=0;x3=0;x4=0;x5=0;x6=0;vl=0;vr=0;
A =...
[0,                                                                                                                                                                                                                                                                1,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                    0, 0,                                                                    0;
0, -(2*J_psi*beta + 2*J_psi*fw + 2*L^2*M*beta + 2*L^2*M*fw + 4*Jm*fw*n^2 + 2*L*M*R*beta)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),                             -(R*g*L^2*M^2 - 2*Jm*g*L*M*n^2)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),              (2*M*beta*L^2 + 2*M*R*beta*L + 2*J_psi*beta)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), 0,                                                                    0;
0,                                                                                                                                                                                                                                                                0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                    1, 0,                                                                    0;
0,   (4*Jw*beta + 2*M*R^2*beta - 4*Jm*fw*n^2 + 4*R^2*beta*m + 2*L*M*R*beta + 2*L*M*R*fw)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), (L*g*M^2*R^2 + 2*L*g*m*M*R^2 + 2*Jm*L*g*M*n^2 + 2*Jw*L*g*M)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), -(4*Jw*beta + 2*M*R^2*beta + 4*R^2*beta*m + 2*L*M*R*beta)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), 0,                                                                    0;
0,                                                                                                                                                                                                                                                                0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                    0, 0,                                                                    1;
0,                                                                                                                                                                                                                                                                0,                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                    0, 0, -(W^2*beta + W^2*fw)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2)];
 
B =...
[                                                                                                                                                                                                                   0,                                                                                                                                                                                                                    0;
            (M*a*L^2 + M*R*a*L + J_psi*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2),             (M*a*L^2 + M*R*a*L + J_psi*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2);
                                                                                                                                                                                                                   0,                                                                                                                                                                                                                    0;
-(2*Jw*a + M*R^2*a + 2*R^2*a*m + L*M*R*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2), -(2*Jw*a + M*R^2*a + 2*R^2*a*m + L*M*R*a)/(2*J_psi*Jw + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 + 4*Jm*L*M*R*n^2);
                                                                                                                                                                                                                   0,                                                                                                                                                                                                                    0;
                                                                                                                                                            -(R*W*a)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2),                                                                                                                                                              (R*W*a)/(m*R^2*W^2 + 2*J_phi*R^2 + Jm*W^2*n^2 + Jw*W^2)];
 
Q=[0.1,0,0,0,0,0;%theta
   0,1,0,0,0,0;
   0,0,10000,0,0,0;%psi
   0,0,0,100,0,0;
   0,0,0,0,0.1,0;%phi
   0,0,0,0,0,0.1;];
R=[7.5 0;0 7.5];
P=care(A,B,Q,R);
K=lqr(A,B,Q,R);
disp('A =');
disp(A);
disp('B =');
disp(B);
disp('Nghiệm của phương trình Ricatti và độ lợi trong LQR:');
disp('P = ')
disp(P);
disp('K =');
disp(K);


  
