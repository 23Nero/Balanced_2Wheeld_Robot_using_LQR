clearvars;
close all; 
clearvars; 
clc;
%% Khai báo tham số và biến
syms m M R Jw n Jm L n a beta fw g W J_psi Jw vl vr J_phi x1 x2 x3 x4 x5 x6 h1 h2 h3
%% Các biến trạng thái và phương trình
%x1=theta
%x2=theta_d
%x3=psi
%x4=psi_d
%x5=phi
%x6=phi_d
%h1=theta_2d
%h2=psi_2d
%h3=phi_2d
f1 = ((2*m+M)*R^2+2*Jw+2*n^2*Jm)*h1+(M*R*L*cos(x3)-2*n^2*Jm)*h2-M*L*R*x4^2*sin(x3)-a*(vl+vr)+2*(beta+fw)*x2-2*beta*x4;
f2 = (M*L*R*cos(x3)-2*n^2*Jm)*h1+(M*L^2+J_psi+2*n^2*Jm)*h2-M*g*L*sin(x3)-M*L^2*x6^2*sin(x3)*cos(x3)+a*(vl+vr)-2*beta*x2+2*beta*x4;
f3 = (0.5*m*W^2+J_phi+0.5*W^2/R^2*(Jw+n^2*Jm)+M*L^2*(sin(x3))^2)*h3+2*M*L^2*x4*x6*sin(x3)*cos(x3)-0.5*W/R*a*(vr-vl)+0.5*W^2/R^2*(beta+fw)*x6;
%% Giải phương trình
[h1,h2,h3] = solve(f1,f2,f3,h1,h2,h3);
h1=simplify(h1);
h2=simplify(h2);
h3=simplify(h3);
%% Hiển thị kết quả
disp('h1 = ')
disp(h1);
disp('h2 = ')
disp(h2);
disp('h3 = ')
disp(h3);