function[] = autoswitch(delay, time, field, freq)
% AUTOSWITCH(delay, time, field, freq)
%   delay: time between switching device on and off (seconds)
%   time: total time to run demo (seconds)
%   field: (optional) field strength (V/µm)
%   freq: (optional) square-wave frequency (Hz)
% 
% Connects to a Tektronix AFG3022 Signal Generator to apply the field
% required to demonstrate the LC speckle reducing device. If no field and
% frequency are provided it defaults to the conditions required for the
% cell DJH-151118-01 190329-1 at 55°C. It switches this field on and off
% every 'delay' seconds for a total of 'time' seconds.

a = siggen('USB::0x0699::0x0341::C020167::INSTR');
a.setup('iqvfp');

if nargin == 4
    a.setv1(field);
    a.setf1(freq);
else    
    a.setv1(16.3);
    a.setf1(180);
end

tic
disp(['Signal Generator cycling on and off every ',num2str(delay),'s for ',num2str(time),'s'])
while toc < time
    a.on
    pause(delay)
    a.off
    pause(delay)
end
a.close

end