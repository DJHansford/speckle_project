function[p, loop] = prop_lc_to_camera(p)
% PROP_LC_TO_CAMERA simulates light propagation from LC device (random
%   scattering) through lens onto scattering screen (not in focus). This is
%   imaged by eye/CCD in focus. It returns The input parameters are:
% 
%   [p, loop] = PROP_LC_TO_CAMERA(p)

lc.type = 3; % 1: random number generator 2: E-field from optical simulation code 3: Statistically generated E-Field (x100)

switch lc.type
    case 1
        lc.A = 5; % Control phase amplitude of LC perturbation on laser beam
        p.m_total = 10; % Number of loops to run
    case 2
%         filename = {'E_out.dat','E_out_1.dat','E_out_2.dat','E_out_3.dat','E_out_4.dat','E_out_5.dat'};
        filename = {'E_out_100umwide.dat'};
        p.m_total = length(filename);
    case 3
        e_out = load([p.folder_now,'\stat_sim_1mm_x100.mat'],'sim_x');
%         p.m_total = length(e_out.sim_x(1,:)); % This selects all (100 usually) fields
        p.m_total = 3; % Only use the first p.m_total fields
end

%% Flags to activate parts of the code
autocorrelation = 0;
plot_all_I = 0; % Plot all the intensity fields (usually used for testing)
plot_I_mean = 0; % Plot the mean intensity (over p.m_total runs)
save_test_data = 0; % Save all arrays to file (makes a big file, only use when testing)
cumulativeSC = 1; % Work out SC for an increasing number of combined fields from 1 to p.m_total

%% Set up experimental constants
laser.k = (2*pi)/p.lambda; % Wavenumber
laser.d = 1e-3; % Diameter of laser beam
lc.E.out_uniform = exp(1i*laser.k*zeros(1,p.n)); % Unperturbed wavefront from LC device (eg no scatterer)

lens.f = 10e-3; % Focal length of lens 1
lens.r = 5e-3; % Radius of lens 1
lens.z.in = 10e-3; % Distance from lc device to entrance to lens
lens.z.out = 0.1; % Distance from lens to screen

eye.f = 1e-2; % Focal length of final imaging lens / eye - CURRENTLY NOT USED
eye.z.in = 0.5; % Distance from paper to eye
eye.z.out = 0.015; % Distance from eye lens to retina
eye.r = 1.6e-3; % Radius of eye pupil (as used in physical setup)

%% Set up constant vectors that don't change in the loop
laser.x_sub = linspace(-laser.d/2,laser.d/2,p.n/8); % Sub sampled position across wavefront (1024 points)
laser.x = linspace(-laser.d/2,laser.d/2,p.n); % Represents position across laser beam (8192 points)
x = linspace(-4*laser.d,4*laser.d,8*p.n); % Represents position across any 65536 vector used in this code
x_sub = linspace(-4*laser.d,4*laser.d,p.n/8);
retina.x = x*(-eye.z.out/eye.z.in); % Generates laser.x vector for position on retina/camera CCD detector

h.lc_lens = exp(0.5*1i*laser.k*(x.*x)/lens.z.in); % Represents propagation from lc device to entrance of lens
h.lens_screen = exp(0.5*1i*laser.k*(x.*x)/lens.z.out); % Represents propogation from lens1 to screen
h_psf = sinc(retina.x*2*pi*eye.r/(eye.z.out*p.lambda)); % point spread function (simplificaiton because imaged in focus from screen to retina)

loop.I.all=zeros(p.m_total,8*p.n); % Initiate matrix to hold all I vectors from loop
sc=zeros(p.m_total,1); % Initiate vector to hold all SC values from loop

%% Loop for creating multiple speckle patterns
for m=1:p.m_total
    switch lc.type
        case 1
            lc.phase.scatter = rand(1,p.n/8)*lc.A*p.lambda; % Perturbation on wavefront at lengthscale 8d/n from LC device
            lc.phase.interp = interp1(laser.x_sub,lc.phase.scatter,laser.x); % Interpolation to generate perturbation on wavefront at lengthscale of laser beam
            lc.E.out_scatter = exp(1i*laser.k*lc.phase.interp); % Represents influence of lc.phase.interp - the scattering from device (Light field at exit of LC device)
            lc.E.out = 0*lc.E.out_scatter + 1*lc.E.out_uniform;
        case 2
            lc.E.out = importfield(filename{1},5);
            lc.E.out = circshift(lc.E.out,37,2);
            lc.E.out_all(m,:) = lc.E.out;
        case 3
            lc.E.outfull = e_out.sim_x(:,m);
            lc.E.out2 = reshape(lc.E.outfull,5,p.n);
            lc.E.out = lc.E.out2(1,:);
            % lc.E.out = sum(lc.E.out2); % This sums over the 5 high-res values instead of simply taking one every 5
            lc.E.out_all(m,:) = lc.E.out;
    end
    
    lens.E.in = conv(lc.E.out,h.lc_lens); % Propogates light from LC device to entrance of lens1 (field of wavefront at lens1 in)
    lens.E.in = lens.E.in(1+(p.n/2):17*p.n/2); % Chop off excess padding from convolution
    lens.E.out = lens.E.in.*exp(-1i*laser.k*sqrt(lens.f*lens.f + (x.*x))); % Adding phase funciton of lens1 to light field
    
    screen.E.in = conv(lens.E.out,h.lens_screen); % Propogates light from lens1 to screen (field of wavefront at screen)
    screen.E.in = screen.E.in(1+(4*p.n):12*p.n); % Chop off excess padding from convolution
%     screen.E.out = screen.E.in.*exp(1i*laser.k*p.screen_phase); % Light field after reflection on screen
    screen.E.out = screen.E.in.*exp(1i*p.screen_phase); % USED FOR 0-2PI RANDOM SCREEN
    %     screen.E.out = abs(screen.E.in); % Used for a test
    
    retina.E.in = conv(screen.E.out,h_psf); % Light field on retina / camera CCD detector
    retina.E.in = retina.E.in(1+(4*p.n):12*p.n); % Chop off excess padding from convolution
    retina.I = abs(retina.E.in).*abs(retina.E.in); % Intensity is square of abs(field)
    
    sc(m) = std(retina.I(p.mid-p.search:p.mid+p.search))/mean(retina.I(p.mid-p.search:p.mid+p.search));
    loop.I.all(m,:) = retina.I; % Stacks each retina.I vector into a matrix loop.I.all for averaging later
    
    if plot_all_I
        figure('Name',['Intensity at retina: Run ',sprintf(['%0',num2str(length(p.m_total)),'d'], m)],'NumberTitle','off')
        plot(retina.x,retina.I);
        %         title(['Intensity at retina: Run
        %         ',sprintf(['%0',num2str(length(p.m_total)),'d'], m),'. ',test,'. SC
        %         = ',num2str(round(sc(m),2))])
        title(['Intensity at retina. ',test,'. SC = ',num2str(round(sc(m),2))])
        xlabel('Distance from center of beam (m)')
        xlim([min(retina.x),max(retina.x)])
        ylabel('Intensity (au)')
        line([retina.x(p.mid-p.search),retina.x(p.mid-p.search)],[1,max(retina.I)],'Color','r');
        line([retina.x(p.mid+p.search),retina.x(p.mid+p.search)],[1,max(retina.I)],'Color','r');
    end
%     disp([num2str(round(100*m/p.m_total,0)),'% complete'])
end

if p.m_total > 1
    loop.I.mean = mean(loop.I.all);
    
    loop.sc = std(loop.I.mean(p.mid-p.search:p.mid+p.search))/mean(loop.I.mean(p.mid-p.search:p.mid+p.search));
    
    if plot_I_mean
        figure('Name',['Average intensity at retina after ',num2str(p.m_total),' runs'],'NumberTitle','off')
        plot(retina.x,loop.I.mean);
        title(['Average intensity at retina after ',num2str(p.m_total),' runs. SC = ',num2str(round(loop.sc,2))])
        xlabel('Distance from center of beam (m)')
        xlim([min(retina.x),max(retina.x)])
        ylabel('Intensity (au)')
        line([retina.x(p.mid-p.search),retina.x(p.mid-p.search)],[1,max(retina.I)],'Color','r');
        line([retina.x(p.mid+p.search),retina.x(p.mid+p.search)],[1,max(retina.I)],'Color','r');
    end
end

% sc = std(I_mean(3324:4872))/mean(I_mean(3324:4872)) % Manually choosing
% part of field which light from the lens will reach

% p.mid = length(I_mean)/2; p.search = round(0.0945*length(I_mean),0); sc =
% std(I_mean(p.mid-p.search:p.mid+p.search))/mean(I_mean(p.mid-p.search:p.mid+p.search))
%
% allstd = std(loop.I.all(1,p.mid-p.search:p.mid+p.search,:)); allmeans =
% mean(loop.I.all(1,p.mid-p.search:p.mid+p.search,:)); allsc =
% allstd(1,1,:)./allmeans(1,1,:); totalmean = mean(allsc)

if cumulativeSC
    [p] = cumulative_sc(loop, p);
end

if autocorrelation
    lag=1000;
    autos=zeros(10,lag+1);
    for k=1:10
        autos(k,:) = autocorr(loop.I.all(k,:),lag);
    end
    automean = mean(autos);
end

if save_test_data
    save([p.folder_now,'\speckle ',p.screen_name,' ALL data.mat'])
end
save([p.folder_now,'\speckle ',p.screen_name,' data.mat'], 'p', 'loop')
end