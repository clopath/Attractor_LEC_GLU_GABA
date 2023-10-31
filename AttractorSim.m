r1tot = zeros(1,length(r_ini_tot)); % save final results
for r_ini = 1:1:length(r_ini_tot) % loop over initial conditions
    for trails = 1:totalTrails % loop over trails
        r1 = r_ini_tot(r_ini)*ones(1,T);% intiial conditions for r1
        r2= (1-r_ini_tot(r_ini))*ones(1,T);% intiial conditions for r2
        for t = 1:T-1 % loop over time
            r1(t+1) = r1(t) + 1/tau*(-r1(t) + 1./(1+exp(-beta*(-w1*r2(t)+I1+InoiseAmp*2*(rand-0.5)-gamma_offset)))); % run rate-based dynamics for r1
            r2(t+1) = r2(t) + 1/tau*(-r2(t) + 1./(1+exp(-beta*(-w2*r1(t)+I2+ InoiseAmp*2*(rand-0.5)-gamma_offset))));% run rate-based dynamics for r2
        end
        r1tot(r_ini) = r1tot(r_ini)+ (r1(end)> r2(end));  % save whether r1 is bigger than r2
    end
end
r1tot = r1tot/totalTrails; % compute prob