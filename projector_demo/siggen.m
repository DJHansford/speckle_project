classdef siggen
    %SIGGEN Connect to Tektronix AFG 3022
    %   This could be adapted to control similar Tektronix generators.
    %   User needs to install National Instruments drivers first
    %   (https://www.ni.com/en-gb/support/downloads/drivers/download.ni-visa.html#329456)
    
    properties
        deviceid
        afg
    end
    
    methods
        function obj = siggen(deviceid)
            %SIGGEN Construct a siggen (Signal Generator) instance
            %   Provide the device id, eg:
            %   a = siggen('USB::0x0699::0x0341::C020167::INSTR')
            %   If deviceid is empty, use default option below
            if nargin == 0
                % Default device ID
                obj.deviceid = 'USB::0x0699::0x0341::C020167::INSTR';
            else
                obj.deviceid = deviceid;
            end
            instrreset
            obj.afg=visa('ni',obj.deviceid);
            fopen(obj.afg);
            fprintf(obj.afg,'*RST');
            fprintf(obj.afg,'OUTP1:STAT OFF'); fprintf(obj.afg,'OUTP2:STAT OFF');
        end
        
        function [] = setup(obj,flags)
            %SETUP Set starting properties
            %   i: infinite impedence
            %   q: square wave
            %   v: voltage concurrent
            %   f: frequency concurrent
            %   p: 180° phase change between sources
            if contains (flags, 'i')
                fprintf(obj.afg,'OUTP1:IMP INF'); fprintf(obj.afg,'OUTP2:IMP INF');
            end
            if contains (flags, 'q')
                fprintf(obj.afg,'SOURCE1:FUNCTION SQUARE'); fprintf(obj.afg,'SOURCE2:FUNCTION SQUARE');
            end
            if contains (flags, 'v')
                fprintf(obj.afg,'SOURce1:VOLTage:CONCurrent:STATe ON');
            end
            if contains (flags, 'f')
                fprintf(obj.afg,'SOURce1:FREQuency:CONCurrent ON');
            end
            if contains (flags, 'p')
                fprintf(obj.afg,'SOURce1:PHASe:INITiate');
                fprintf(obj.afg,'SOURce2:PHASe:ADJust 180 deg');
            end
            disp('Signal Generator initiated succesfully')
        end
        
        function [] = setv1(obj,v1set)
            %SETV1 sets source 1 voltage to v1set
            fprintf(obj.afg,['SOURCE1:VOLTAGE ',num2str(v1set)]);
        end
        
        function [] = setf1(obj,f1set)
            %SETF1 sets source 1 frequency to f1set
            fprintf(obj.afg,['SOURCE1:FREQ:FIXED ',num2str(f1set),'HZ']);
        end
        
        function[] = on(obj)
            %ON switches both sources off
            fprintf(obj.afg,'OUTP1:STAT ON'); fprintf(obj.afg,'OUTP2:STAT ON');
        end
        
        function[] = off(obj)
            %OFF switches both sources off
            fprintf(obj.afg,'OUTP1:STAT OFF'); fprintf(obj.afg,'OUTP2:STAT OFF');
        end
        
        function[] = close(obj)
            %CLOSE switches off the generator and closes the connection.
            %This must be done if you wish to establish a new connection in
            %the future
            obj.off
            fclose(obj.afg);
        end
    end
end

