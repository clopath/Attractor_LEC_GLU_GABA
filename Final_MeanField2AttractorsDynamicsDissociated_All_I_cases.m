clear all;
% Parameters
beta = 10; % slope of grain function
gamma_offset = 0.5;% offseet of grain function
I1 = 1.05; % current to population 1 
I2 = 0.95;% current to population 2 
w1= 1; % weights 
w2 = 1;% weights 
wup = 1.3;% weights under perturbation 
wdown = 0.9;% weights under perturbation
wdown_Ialone = 0.8; % weights under perturbation
InoiseAmp = 0.2; % amplitude of noise
totalTrails = 100; % total number of trails
T = 100; %  total number of time steps
tau = 10; % time constant for dynmics
r_ini_tot = 0:0.001:0.9; % inital conditions
rsave= zeros(5,length(r_ini_tot)); % save results 
rsave(1,:)= r_ini_tot;
%%%%% control%%%%%%%%
AttractorSim
rsave(2,:)= r1tot; 
figure; plot(1-r_ini_tot, 1-r1tot, 'k')
%%%%% \Delta E (place up - non-pl down)%%%%%%%%
w1= 1;
w2 = 1;
w2 = w2*wup;
w1 = w1*wdown;
AttractorSim
rsave(3,:)= r1tot; 
hold on; plot(1-r_ini_tot, 1-r1tot, 'g')
%%%%% \Delta E+I (place up)%%%%%%%%
w1= 1;
w2 = 1;
w2 = w2*wup;
AttractorSim
rsave(4,:)= r1tot; 
hold on; plot(1-r_ini_tot, 1-r1tot, 'm')
%%%%% \Delta I (all down)'%%%%%%%%
w1= 1;
w2 = 1;
w2 = w2*wdown_Ialone;
w1 = w1*wdown;
AttractorSim
rsave(5,:)= r1tot; 
hold on; plot(1-r_ini_tot, 1-r1tot, 'r')
legend('control', '\Delta E (place up - non-pl down)', '\Delta E+I (place up)','\Delta I (all down)')
xlabel('r_B(t=0)')
ylabel('P(r_B>r_A)')
