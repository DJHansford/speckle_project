function[] = autoswitch(delay, time)
% AUTOSWITCH connects to a Tektronix AFG3022 Signal Generator to apply the
%   square wave for peak performance of the cell DJH-151118-01 190329-1 at
%   55°C. It switches this field on and off every 'delay' seconds for a
%   total of 'time' seconds.
%
%   AUTOSWITCH(1,6)
%
%   Delay is set to 1 second, total time is 6 seconds

a = siggen('USB::0x0699::0x0341::C020167::INSTR');
a.setup('iqvfp');
a.setv1(16.3);
a.setf1(180);

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