clear all
close all
total_trails = 100;
perf_trails = zeros(5,total_trails);
xvar_trails = zeros(5,total_trails);

% all params
N = 50;
T = 200;
dt = 1;
alpha = 1;
tau = 10;
theta = 0.04;
wmax= 0.3;
xmax = 1;
Imax = 0.4;
assembly_size = 10;
assembly_recall = 7;
Epert_size= 4;
Inhib_pertb = 0.17;
Inoise_ampl = 1;
tau_noise = 10;
Inh_lat_ampl = 8;


% conditions
for cond = 1:5

    if cond==1
        Epertlearning =0;
        Ipertlearning =0;
        Eperttesting =0;
        Iperttesting =0;
    end

    if cond==2
        Epertlearning =0;
        Ipertlearning =0;
        Eperttesting =1;
        Iperttesting =0;
    end

    if cond==3
        Epertlearning =0;
        Ipertlearning =0;
        Eperttesting =0;
        Iperttesting =1;
    end

    if cond==4
        Epertlearning =1;
        Ipertlearning =0;
        Eperttesting =0;
        Iperttesting =0;
    end

    if cond==5
        Epertlearning =0;
        Ipertlearning =1;
        Eperttesting =0;
        Iperttesting =0;
    end
    for trails = 1:total_trails

        % initial conditions
        Inhib = 0;
        Inoise = zeros(N,1);
        w = 0*ones(N,N);
        wsave = zeros(2,T);
        wsavefull = zeros(N*N,T);

        % learning the pattern
        I = zeros(N,1);
        I(1:assembly_size )= Imax;
        x = zeros(N,T);
        for t = 1:T-1
            if Epertlearning ==1
                I = zeros(N,1);
                I(randperm(assembly_size , Epert_size))= Imax;
                I(assembly_size+randperm(N-assembly_size , assembly_size - Epert_size))= Imax;

            end
            if Ipertlearning ==1
                Inhib = Inhib_pertb;
            end
            I_lat_inh = Inh_lat_ampl*mean(x(:,t));
            Inoise = (1-dt/tau_noise)*Inoise+dt/tau_noise*(2*Inoise_ampl*(rand(N,1)-0.5));
            x(:,t+1) = (1-dt/tau)*x(:,t)+dt/tau*(w'*x(:,t)+I-Inhib+Inoise-I_lat_inh);
            x(:,t+1) = x(:,t+1).*(x(:,t+1)>0);
            x(:,t+1)= xmax+(x(:,t+1)<xmax).*(x(:,t+1)-xmax);
            w = w + alpha*(x(:,t+1)*x(:,t+1)'-theta);
            w = w - mean(w)+wmax/assembly_size;
            w = (1-eye(N)).*w;
            w = w.*(w>0);
            w= wmax+(w<wmax).*(w-wmax);
            wsave(1,t)= w(1,2);
            wsave(2,t)= w(49,50);
            wsavefull(:,t)= reshape(w, N*N,1);
        end
        xvar_trails(cond, trails)= mean(std(x'));
        
        % recall dynamics
        I = zeros(N,1);
        I(1:assembly_recall)= Imax;
        Inhib = 0;
        x = zeros(N,T);
        for t = 1:T-1
            if Epertlearning ==1
                I = zeros(N,1);
                I(randperm(assembly_size , Epert_size))= Imax;
                I(assembly_size+randperm(N-assembly_size , assembly_size - Epert_size))= Imax;

            end

            if Ipertlearning ==1
                Inhib = Inhib_pertb;
            end

            if Eperttesting ==1
                I = zeros(N,1);
                I(randperm(assembly_recall , Epert_size))= Imax;
                I(assembly_size+randperm(N-assembly_size , assembly_recall - Epert_size))= Imax;
            end
            if Iperttesting ==1
                Inhib = Inhib_pertb;
            end
            I_lat_inh = Inh_lat_ampl*mean(x(:,t));
            Inoise = (1-dt/tau_noise)*Inoise+dt/tau_noise*(2*Inoise_ampl*(rand(N,1)-0.5));
            x(:,t+1) = (1-dt/tau)*x(:,t)+dt/tau*(w'*x(:,t)+I-Inhib+Inoise-I_lat_inh);
            x(:,t+1) = x(:,t+1).*(x(:,t+1)>0);
            x(:,t+1)= xmax+(x(:,t+1)<xmax).*(x(:,t+1)-xmax);
        end

        recall_perf = mean(mean(x(assembly_recall+1:assembly_size,t-9:t+1)));
        perf_trails(cond, trails)= recall_perf;
    end
end