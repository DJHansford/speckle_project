function[fig] = make_figure()
global param
global vidobj

% Camera feed
fig.live = figure('Visible', 'on',...
    'Position',[400,50,900,900],'Name','Speckle Contrast Measurement','NumberTitle','off');
axes('Position',[0.2,0.4,0.6,0.6]);
fig.cameraimg = imshow(zeros(param.imageRes),[0 param.maxPixel]);

% Camera image histogram
axes('Position',[0.1,0.32,0.59,0.065]);
fig.histogram=histogram(rand(param.searchsize*param.searchsize,1)*param.maxPixel,128);
fig.histogram.Parent.XLim=[0 param.maxPixel];
% fig.histogram.Parent.XTickLabel=[];
fig.histogram.Parent.YLim=[0 500];
ylabel 'Histogram'

% Speckle Contrast graph
axes('Position',[0.1,0.2,0.59,0.085]);
fig.plotsc=animatedline;
fig.plotsc.Parent.XTickLabel=[];
ylabel 'Speckle'

% Intensity graph
axes('Position',[0.1,0.10,0.59,0.085]);
fig.plotint=animatedline;
ylabel 'Intensity'
% Reset graphs
fig.btn_clear = uicontrol('Style', 'pushbutton',...
    'String', 'Clear',...
    'Units', 'normalized',...
    'Position', [0.64 0.1 0.05 0.03],...
    'callback', {@btn_clear});

% Current Speckle and Intensity text
fig.textdisp = uicontrol('Units','normalized',...
    'Position', [0.05,0.0,0.65,0.075],...
    'FontSize',18,...
    'Style','text',...
    'String','');

ll=0.8; tt=0.1; hh=0.03; lt=0.7;

% Change searchbox size button
fig.btn_searchchange = uicontrol('Style', 'pushbutton',...
    'String', 'Change search size',...
    'Units', 'normalized',...
    'Position', [lt 0.1+9*hh tt*2 hh],...
    'callback', {@btn_searchch});

% Searchbox size input
fig.searchsize = uicontrol('Style', 'edit',...
    'String', num2str(param.searchsize),...
    'Units', 'normalized',...
    'Position', [0.9 0.1+9*hh tt hh]);

% Change searchbox position button
fig.btn_xychange = uicontrol('Style', 'pushbutton',...
    'String', 'Find manually',...
    'Units', 'normalized',...
    'Position', [0.9 0.1+8*hh tt hh],...
    'callback', {@btn_xych});

% Automatically find searchbox position button
fig.btn_xyauto = uicontrol('Style', 'pushbutton',...
    'String', 'Find spot automatically',...
    'Units', 'normalized',...
    'Position', [lt 0.1+8*hh tt*2 hh],...
    'callback', {@btn_xyau});

% He-Ne only button
fig.btn_heneonly = uicontrol('Style', 'pushbutton',...
    'String', 'He-Ne only',...
    'Units', 'normalized',...
    'Position', [0.9 0.1+7*hh tt hh],...
    'callback', {@btn_heneonly});

% Cell Thickness label
uicontrol('Style', 'text',...
    'String', {'Cell thickness (µm)'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+7*hh tt hh]);

% Cell Thickness input
fig.cellt = uicontrol('Style', 'edit',...
    'String', num2str(param.cellt),...
    'Units', 'normalized',...
    'Position', [ll 0.1+7*hh tt hh]);

% Nematic label
uicontrol('Style', 'text',...
    'String', {'Nematic %wt.'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+6*hh tt hh]);

% Nematic input
fig.nematic = uicontrol('Style', 'edit',...
    'String', param.nematic,...
    'Units', 'normalized',...
    'Position', [ll 0.1+6*hh tt hh]);

% CTAB label
uicontrol('Style', 'text',...
    'String', {'CTAB  %wt.'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+5*hh tt hh]);

% CTAB input
fig.CTAB = uicontrol('Style', 'edit',...
    'String', param.ctab,...
    'Units', 'normalized',...
    'Position', [ll 0.1+5*hh tt hh]);

% Chiral label
uicontrol('Style', 'text',...
    'String', {'Chiral %wt.'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+4*hh tt hh]);

% Chiral input
fig.chiral = uicontrol('Style', 'edit',...
    'String', param.chiral,...
    'Units', 'normalized',...
    'Position', [ll 0.1+4*hh tt hh]);

% Voltage label
uicontrol('Style', 'text',...
    'String', {'Amplitude (V/µm)'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+3*hh tt hh]);

% Voltage input
fig.Volt = uicontrol('Style', 'edit',...
    'String', num2str(param.siggenvec(1,1)),...
    'Units', 'normalized',...
    'Position', [ll 0.1+3*hh tt hh]);

% Frequency label
uicontrol('Style', 'text',...
    'String', {'Frequency (Hz)'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+2*hh tt hh]);

% Frequency input
fig.Freq = uicontrol('Style', 'edit',...
    'String', num2str(param.siggenvec(2,1)),...
    'Units', 'normalized',...
    'Position', [ll 0.1+2*hh tt hh]);

% NDF label
uicontrol('Style', 'text',...
    'String', {'NDF (OD)'},...
    'Units', 'normalized',...
    'Position', [lt 0.1+hh tt hh]);

% NDF input
fig.NDF = uicontrol('Style', 'edit',...
    'String', num2str(param.ndf),...
    'Units', 'normalized',...
    'Position', [ll 0.1+hh tt hh]);

% HeNe calibration
fig.hene = uicontrol('Style', 'pushbutton',...
    'String', 'Test He-Ne',...
    'Units', 'normalized',...
    'Position', [lt 0.1 tt hh],...
    'callback', {@btn_hene});

% HeNe SC input
fig.hene_text = uicontrol('Style', 'edit',...
    'String', num2str(round(param.HeNesc,3)),...
    'Units', 'normalized',...
    'Position', [ll 0.1 tt hh]);

% HeNe SC status
fig.hene_status = uicontrol('Style', 'text',...
    'String', 'NDF must be 2.0',...
    'Units', 'normalized',...
    'Position', [ll+tt 0.1 tt hh]);

% Capture button
fig.btn_cap = uicontrol('Style', 'pushbutton',...
    'String', 'Start capture',...
    'Units', 'normalized',...
    'Position', [lt 0.1-hh tt*3 hh],...
    'callback', {@btn_capture});

% Text to display estimated time remaining
fig.time = uicontrol('Units','normalized',...
    'Position', [lt 0.1-(2*hh) tt*3 hh],...
    'Style','text',...
    'String', ['Time remaining = ',param.time.remaining,'. Estimated finish: ',datestr(param.time.finish)]);

% Save button
fig.btn_save = uicontrol('Style', 'pushbutton',...
    'String', 'End and Analyse',...
    'Units', 'normalized',...
    'Position', [lt 0 tt*3 hh],...
    'callback', {@btn_end});

    function [] = btn_capture(object_handle, event)
%         Stop the live feed
        param.isrunning=false;
        param.time.start=datetime('now');
        
        % File and image locations
        param.location=[param.pwd,'\',param.filldate,' ',num2str(param.cellt),'µm',param.lot,'\',datestr(now,'yymmdd HHMM'),' ',param.testname,'\'];
        param.imglocation=['C:\Experimental Data\Speckle Reduction\',param.location(72:length(param.location))];
        if ~exist(param.imglocation, 'dir')
            mkdir(param.imglocation); mkdir([param.imglocation,'Square\']); mkdir([param.imglocation,'Full\']);
        end
        if ~exist(param.location, 'dir')
            mkdir(param.location);
        end

        param.ndf=str2num(fig.NDF.String);
        param.time.finish=datetime('now') + param.time.totalsec;
        tic
        param.toc = toc;
        
        switch param.scan
            case {1,2}
                for n=1:length(param.siggenvec(1,:))
                    run(n)
                    remaining = seconds((toc/n)*(length(param.siggenvec(1,:))-n));
                    finish = datetime('now') + remaining;
                    fig.time.String = ['Time remaining = ',datestr(remaining,'HH:MM:SS'),'. Estimated finish: ',datestr(finish)];
                end
            case 3
                param.n = 1;
                while seconds(param.toc) < param.time.totalsec
                    run(param.n)
                    param.n = param.n+1;
                end
        end
        
        delete(vidobj)
        clear vidobj
        close(fig.live)
        [param, fig] = save_data(param, fig);
    end

    function [] = run(n)
        param.n=n;
        param.v.now=param.siggenvec(1,n); param.f.now=param.siggenvec(2,n);
        fprintf(param.afg,['SOURCE1:FREQ:FIXED ',num2str(param.f.now),'HZ']);
        fprintf(param.afg,['SOURCE1:VOLTAGE ',num2str(param.v.now*param.cellt/20)]);
        if param.onoff || n==1
            fprintf(param.afg,'OUTP1:STAT ON'); fprintf(param.afg,'OUTP2:STAT ON');
            siggen='SigGen on: ';
            pause(param.pause)
        end
        fig.Volt.String=num2str(param.v.now); fig.Freq.String=num2str(param.f.now);
        if param.test
            toc
            disp([siggen,'V = ',num2str(param.v.now),' F = ',num2str(param.f.now),' n = ',num2str(param.n)])
        end
        pause(param.time.pre_read)
        
        %             Repeat readings
        for m=1:param.reps
            param.sn=getsnapshot(vidobj);
            param = analyseImage(param);
            fig.cameraimg.CData=param.snmarked; % Give image data to figure
            fig.histogram.Data=param.sn3;
            mmean(m)=param.m; smean(m)=param.s; scmean(m)=param.sc; rmmean(m)=param.rm; tranmean(m)=param.tran; spremean(m)=param.spre; tocmean(m)=toc-param.pause;
            if param.test
                toc
                disp(['Repeat ',num2str(m),': V = ',num2str(param.v.now),' F = ',num2str(param.f.now)])
            end
            switch param.scan
                case {1,2}
                    pause(param.time.between_reps-(param.exp/1000))
            end
        end
        
        param.m=mean(mmean); param.s=mean(smean); param.sc=mean(scmean); param.scrange=range(scmean); param.rm=mean(rmmean); param.tran=mean(tranmean); param.spre=mean(spremean); param.nonz=param.HeNesc; param.toc=mean(tocmean);
        if param.maxcount<=10; param.nonz=param.sc; end
        [param, fig] = add_data(param, fig);
        siggen='SigGen remains on ';
        if param.onoff || n == length(param.siggenvec(1,:))
            fprintf(param.afg,'OUTPUT1:STAT OFF'); fprintf(param.afg,'OUTPUT2:STAT OFF');
            siggen='SigGen off ';
        end
        if param.test
            toc
            disp([siggen])
        end
        %             pause(param.time.post_read-0.65-param.exp)
        pause(param.time.post_read)
    end

    function [] = btn_xych(object_handle, event)
        try
            x1 = param.x; y1 = param.y;
            [param.x,param.y]=ginput(1);
            param.x=round(param.x); param.y=round(param.y);
            if param.y + param.searchsize/2 > size(param.sn,1) || param.y - param.searchsize/2 < 1 || param.x + param.searchsize/2 > size(param.sn,2) || param.x - param.searchsize/2 < 1
                a
            end
        catch
            disp('WARNING: Chosen location is out of range, check search size.')
            param.x = x1; param.y = y1;
        end
    end

    function [] = btn_xyau(object_handle, event)
        try
            x1 = param.x;
            y1 = param.y;
            s1 = param.searchsize;
            disp(['x1 = ',num2str(x1),' y1 = ',num2str(y1),' s1 = ',num2str(s1)])
            
            meanx = mean(param.sn,1)';
            meany = mean(param.sn,2);
            fx = fit([1:length(meanx)]',meanx,'gauss1');
            fy = fit([1:length(meany)]',meany,'gauss1');
            
            param.x = round(fx.b1);
            param.y = round(fy.b1);
            param.fwhmx = round(fx.c1);
            param.searchsize = 2*round(param.fwhmx/4);
            disp(['x = ',num2str(param.x),' y = ',num2str(param.y),' s = ',num2str(param.searchsize)])
            
            if param.y + param.searchsize/2 > size(param.sn,1) || param.y - param.searchsize/2 < 1 || param.x + param.searchsize/2 > size(param.sn,2) || param.x - param.searchsize/2 < 1
                disp('WARNING: Outside of screen')
                a
            end
            
            fig.searchsize.String = num2str(param.searchsize);
        catch
            disp('WARNING: Cannot find automatically, please adjust camera or find manually.')
            param.x = x1; param.y = y1; param.searchsize = s1;
        end
    end

    function [] = btn_heneonly(object_handle, event)
        fig.nematic.String='He-Ne only';
        fig.CTAB.String='';
        fig.chiral.String='';
        fig.Volt.String='';
        fig.Freq.String='';
        
        param.nematic='He-Ne only';
        param.CTAB='';
        param.chiral='';
        param.Volt='';
        param.Freq='';
        
        switch param.scan
            case {1 2}
                param.testname=[param.scantype,' ',num2str(param.v.range(1)),'-',num2str(param.v.range(length(param.v.range))),'Vµm ',num2str(param.f.range(1)),'-',num2str(param.f.range(length(param.f.range))),'Hz ',num2str(param.temp),'°C'];
            case 3
                param.testname=[num2str(param.cam_pos),'mm ',param.nematic];
        end
    end

    function [] = btn_hene(object_handle, event)
        disp(['He-Ne test initiated.'])
        param.isrunning = false;
        storendf=param.ndf;
        param.ndf=2.0;
        meansc=zeros(1,100); meanrm=zeros(1,100);
        for n = 1:100
            param.sn=getsnapshot(vidobj);
            param = analyseImage(param);
            fig.cameraimg.CData=param.snmarked; % Give image data to figure
            fig.histogram.Data=param.sn3;
            fig.textdisp.String=['SC = ',num2str(round(param.sc,2)),' | Int = ',num2str(round(param.m,0)),];
            addpoints(fig.plotint,n,param.m);
            addpoints(fig.plotsc,n,param.sc);
            meansc(n)=param.sc; meanrm(n)=param.rm;
            fig.hene_status.String=[num2str(n),'% Complete'];
        end
        param.HeNesc=mean(meansc); param.HeNerm=mean(meanrm);
        fig.hene_text.String=num2str(round(param.HeNesc,3));
        disp(['Measured He-Ne SC = ',num2str(round(param.HeNesc,3))])
        disp(['Measured He-Ne RM = ',num2str(round(param.HeNerm,0))])
        param.ndf=storendf;
        pause(1)
        param.isrunning = true;
    end

    function [] = btn_end(object_handle, event)
        fprintf(param.afg,'OUTPUT1:STAT OFF'); fprintf(param.afg,'OUTPUT2:STAT OFF');
        delete(vidobj)
        clear vidobj
        [param, fig] = save_data(param, fig);
        close(fig.live)
        closepreview
    end

    function [] = btn_clear(object_handle, event)
        clearpoints(fig.plotsc)
        clearpoints(fig.plotint)
    end

    function [] = btn_searchch(object_handle, event)
        param.searchsize = str2num(fig.searchsize.String);
    end
end