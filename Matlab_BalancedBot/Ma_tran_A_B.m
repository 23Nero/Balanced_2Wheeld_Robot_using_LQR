clearvars;
close all; 
clc;
syms m M R Jw n Jm L n a beta fw g W J_psi Jw vl vr J_phi x1 x2 x3 x4 x5 x6
%% Cac phuong trinh trang thai
h1 =... 
(J_psi*a*vl + J_psi*a*vr - 2*J_psi*beta*x2 + 2*J_psi*beta*x4 - 2*J_psi*fw*x2 + L^2*M*a*vl + L^2*M*a*vr - 2*L^2*M*beta*x2 + 2*L^2*M*beta*x4 - 2*L^2*M*fw*x2 - 4*Jm*fw*n^2*x2 - (L^2*M^2*R*g*sin(2*x3))/2 + L^3*M^2*R*x4^2*sin(x3) - L^3*M^2*R*x6^2*(sin(x3) - sin(x3)^3) - 2*L*M*R*beta*x2*cos(x3) + 2*L*M*R*beta*x4*cos(x3) + J_psi*L*M*R*x4^2*sin(x3) + 2*Jm*L*M*g*n^2*sin(x3) + Jm*L^2*M*n^2*x6^2*sin(2*x3) + L*M*R*a*vl*cos(x3) + L*M*R*a*vr*cos(x3) + 2*Jm*L*M*R*n^2*x4^2*sin(x3))/(2*J_psi*Jw + L^2*M^2*R^2 + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 - L^2*M^2*R^2*cos(x3)^2 + 4*Jm*L*M*R*n^2*cos(x3));
h2 =...
-(2*Jw*a*vl + 2*Jw*a*vr - 4*Jw*beta*x2 + 4*Jw*beta*x4 + M*R^2*a*vl + M*R^2*a*vr - 2*M*R^2*beta*x2 + 2*M*R^2*beta*x4 + 2*R^2*a*m*vl + 2*R^2*a*m*vr + 4*Jm*fw*n^2*x2 - 4*R^2*beta*m*x2 + 4*R^2*beta*m*x4 - L*M^2*R^2*g*sin(x3) + (L^2*M^2*R^2*x4^2*sin(2*x3))/2 - (L^2*M^2*R^2*x6^2*sin(2*x3))/2 - 2*Jw*L*M*g*sin(x3) - Jw*L^2*M*x6^2*sin(2*x3) - 2*L*M*R*beta*x2*cos(x3) + 2*L*M*R*beta*x4*cos(x3) - 2*L*M*R*fw*x2*cos(x3) - 2*Jm*L*M*g*n^2*sin(x3) - 2*L*M*R^2*g*m*sin(x3) - Jm*L^2*M*n^2*x6^2*sin(2*x3) - L^2*M*R^2*m*x6^2*sin(2*x3) + L*M*R*a*vl*cos(x3) + L*M*R*a*vr*cos(x3) - 2*Jm*L*M*R*n^2*x4^2*sin(x3))/(2*J_psi*Jw + L^2*M^2*R^2 + 2*Jw*L^2*M + J_psi*M*R^2 + 2*J_psi*Jm*n^2 + 4*Jm*Jw*n^2 + 2*J_psi*R^2*m + 2*Jm*L^2*M*n^2 + 2*Jm*M*R^2*n^2 + 2*L^2*M*R^2*m + 4*Jm*R^2*m*n^2 - L^2*M^2*R^2*cos(x3)^2 + 4*Jm*L*M*R*n^2*cos(x3));
h3 =...
-(W^2*beta*x6 + W^2*fw*x6 + R*W*a*vl - R*W*a*vr + 2*L^2*M*R^2*x4*x6*sin(2*x3))/(2*J_phi*R^2 + Jw*W^2 + Jm*W^2*n^2 + R^2*W^2*m + 2*L^2*M*R^2*sin(x3)^2);
%% Tính ma trận A, theo các tham số
A=[0 1 0 0 0 0;
diff(h1,x1) diff(h1,x2) diff(h1,x3) diff(h1,x4) diff(h1,x5) diff(h1,x6);
0 0 0 1 0 0;
diff(h2,x1) diff(h2,x2) diff(h2,x3) diff(h2,x4) diff(h2,x5) diff(h2,x6);
0 0 0 0 0 1;
diff(h3,x1) diff(h3,x2) diff(h3,x3) diff(h3,x4) diff(h3,x5) diff(h3,x6);];

B=[0 0;
diff(h1,vl) diff(h1,vr);
0 0;
diff(h2,vl) diff(h2,vr);
0 0;
diff(h3,vl) diff(h3,vr);];
%% Hiển thị kết quả
disp('A = ')
disp(A);
disp('B = ')
disp(B);



