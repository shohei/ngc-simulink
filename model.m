clear; close all; clc;
format short;

A = [-1.064 1.000;290.26 0.00];
B = [-0.25; -331.40];
C = [-123.34 0.00; 0.00 1.00];
D = [-13.51; 0];

states = {'AoA','q'};
inputs = {'\delta_c'};
outputs = {'Az','q'};

sys = ss(A,B,C,D,...
    'statename',states,...
    'inputname',inputs,...
    'outputname',outputs);

TFs = tf(sys);
TF = TFs(2,1);
disp(pole(TF));

Q = [0.1 0;0 0.1];
R = 0.5;

[K,S,e] = lqr(A,B,Q,R);
fprintf('eigenvalues of A-B*K\n');
disp(eig(A-B*K));
fprintf('Feedback gain K');
disp(K);
Acl = A-B*K;
Bcl = B;

syscl = ss(Acl,Bcl,C,D,...
    'statename',states,...
    'inputname',inputs,...
    'outputname',outputs);

G = eye(2);
H = 0*eye(2);

Qbar = diag(0.00015*ones(1,2));
Rbar = diag(0.55*ones(1,2));

sys_n = ss(A,[B G],C,[D H]);
[kest,L,P] = kalman(sys_n,Qbar,Rbar,0);

Aob = A-L*C;
fprintf('Observer eigenvalues\n');
disp(eig(Aob));

dT1 = 0.75;
dT2 = 0.25;

R = 6371e3;
Vel = 1021.08; %m/s
m2f = 3.2811;

LAT_TARGET=35.375527;
LON_TARGET=139.525105;
ELEV_TARGET=21;
% LAT_TARGET = 34.6588;
% LON_TARGET = -118.769745;
% ELEV_TARGET = 795; %m; MSL

%kumagaya
LAT_INIT=36.161748;
LON_INIT=139.2982418;
ELEV_INIT = 10000;%m

% LAT_INIT = 34.2329;
% LON_INIT = -119.4573;
% ELEV_INIT = 10000;%m

% tokyo sky tree
LAT_OBS = 35.423623;
LON_OBS = 139.48858;
% LAT_OBS = 34.61916;
% LON_OBS = -118.8429;

d2r = pi/180;

l1 = LAT_INIT*d2r;
u1 = LON_INIT*d2r;
l2 = LAT_TARGET*d2r;
u2 = LON_TARGET*d2r;

dl = l2-l1;
du = u2-u1;

a = sin(dl/2)^2 + cos(l1)*cos(l2)*sin(du/2)^2;
c = 2*atan2(sqrt(a),sqrt(1-a));
d = R*c;

r = sqrt(d^2+(ELEV_TARGET-ELEV_INIT)^2);
yaw_init = azimuth(LAT_INIT,LON_INIT,LAT_TARGET,LON_TARGET);
yaw = yaw_init*d2r;

dh = abs(ELEV_TARGET-ELEV_INIT);
FPA_INIT = atan(dh/d);



































