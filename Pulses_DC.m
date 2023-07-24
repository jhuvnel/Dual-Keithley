% Author: Celia Fernandez Brillet
% Date: 11/15/22
% Description:script to connect to Keithley 6221 and program it to send out
% pulses or DC (monophasic or biphasic).

%% Initialize Keithley, connect to it
% Delete instrument objects that are still open 
clc
clear
% establish serial port connection - make sure Baud rate and terminator
% match what is selected on the Keithley 6221
s = serialport("COM4",19200,"Timeout",5);
configureTerminator(s, "LF") % set line terminator

% Query the Keithely to identify itself
writeline(s, '*idn?')
response = readline(s) % show Keithley's response

%% 
writeline(s,'sour:wave:abor')
writeline(s, 'sour:curr:rang 200e-6')
writeline(s, 'curr:filt off')

writeline(s, 'output off')
writeline(s, 'sour:wave:arm')
writeline(s, 'sour:wave:init')
   
% The code below will create a waveform that is made up of a pattern of "25
% points" (note: this can be changed depending on your needs). Because I want 
% a pulse frequency of 400 Hz, those two numbers will define the duration
% of each of the points in my waveform pattern. 1/400Hz = 2500 us. So, each
% slot will be 100 us long. I chose the number of points in my waveform
% (25) to get a resolution of 100 us. Now, say I want my phases to be 200
% us long -- I'd need two points per phase. If I wanted an interphase gap
% (IPG) of <100 us, I'd have to make my resolution smaller. For now, the smallest
% IPG I could add would be 100 us. In this example, I won's have an IPG.

% Cathodic first, two data points per phase, 21 for the interpulse gap
writeline(s, 'sour:wave:arb:data -1,-1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% writeline(s, 'sour:wave:arb:data -1, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% Choosing an arbitrary waveform (meaning we can define our string our values like in the line above)
writeline(s, 'sour:wave:func arb0')
% Compliance voltage (V)
writeline(s, 'curr:comp 50')
% Current amplitude (A)
writeline(s, 'sour:wave:ampl 300e-6')
% How many cycles I want
writeline(s, 'sour:wave:dur:cycl 3000')
% Alternative for defining duration: how long do I want it to last (s)
writeline(s, 'sour:wave:dur:time 4') % duration for 4 seconds
% Frequency of the waveform. I think of this as the resolution for the duration of
% my waveform. So if it's 400 Hz, then 1/400 = 2500 us
% Now, since I have 25 slots in my waveform, that means that each one is
% 100 us long.
writeline(s, 'sour:wave:freq 400')

writeline(s, 'output off')
writeline(s, 'sour:wave:arm')
writeline(s, 'sour:wave:init')

            
% writeline(s,"*opc?")
% write(s, '*idn?', 'string')
% pause(1)
% readline(s)


%%
fprintf(s, 'sour:wave:abor')
fprintf(s, 'sour:curr:rang 200e-6')
fprintf(s, 'curr:filt off')

fprintf(s, 'outp:ishield guard')
fprintf(s, 'outp:ltearth on')

% The code below will create a waveform that is made up of a pattern of "25
% points" (note: this can be changed depending on your needs). Because I want 
% a pulse frequency of 400 Hz, those two numbers will define the duration
% of each of the points in my waveform pattern. 1/400Hz = 2500 us. So, each
% slot will be 100 us long. I chose the number of points in my waveform
% (25) to get a resolution of 100 us. Now, say I want my phases to be 200
% us long -- I'd need two points per phase. If I wanted an interphase gap
% (IPG) of <100 us, I'd have to make my resolution smaller. For now, the smallest
% IPG I could add would be 100 us. In this example, I won's have an IPG.

% Cathodic first, two data points per phase, 21 for the interpulse gap
fprintf(s, 'sour:wave:arb:data -1,-1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% fprintf(s, 'sour:wave:arb:data -1, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% Choosing an arbitrary waveform (meaning we can define our string our values like in the line above)
fprintf(s, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(s, 'curr:comp 50')
% Current amplitude (A)
fprintf(s, 'sour:wave:ampl 300e-6')
% How many cycles I want
fprintf(s, 'sour:wave:dur:cycl 3000')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(s, 'sour:wave:dur:time 4') % duration for 4 seconds
% Frequency of the waveform. I think of this as the resolution for the duration of
% my waveform. So if it's 400 Hz, then 1/400 = 2500 us
% Now, since I have 25 slots in my waveform, that means that each one is
% 100 us long.
fprintf(s, 'sour:wave:freq 400')

fprintf(s, 'output off')
fprintf(s, 'sour:wave:arm')
fprintf(s, 'sour:wave:init')

% fprintf(s, 'system:key 8')





% Set size of receiving buffer, if needed.
% set(s, 'InputBufferSize', 30000);


% %% Initialize Keithley, connect to it
% 
% % Delete instrument objects that are still open 
% delete(instrfindall)
% % Create TCP/IP object 's'. Specify server machine and port number.
% s = tcpip('192.168.0.2', 1394)
% % Set size of receiving buffer, if needed.
% set(s, 'InputBufferSize', 30000);
% % Open connection to the server.
% fopen(s)
% % Transmit data to the server (or a request for data from the server).
% fprintf(s, '*idn?');
% pause(1); % Pause for the communication delay, if needed.
% fscanf(s); % Receive lines of data from server

%% Program pulse burst

fprintf(s, 'sour:wave:abor')
fprintf(s, 'sour:curr:rang 200e-6')
fprintf(s, 'curr:filt off')

fprintf(s, 'outp:ishield guard')
fprintf(s, 'outp:ltearth on')

% The code below will create a waveform that is made up of a pattern of "25
% points" (note: this can be changed depending on your needs). Because I want 
% a pulse frequency of 400 Hz, those two numbers will define the duration
% of each of the points in my waveform pattern. 1/400Hz = 2500 us. So, each
% slot will be 100 us long. I chose the number of points in my waveform
% (25) to get a resolution of 100 us. Now, say I want my phases to be 200
% us long -- I'd need two points per phase. If I wanted an interphase gap
% (IPG) of <100 us, I'd have to make my resolution smaller. For now, the smallest
% IPG I could add would be 100 us. In this example, I won's have an IPG.

% Cathodic first, two data points per phase, 21 for the interpulse gap
fprintf(s, 'sour:wave:arb:data -1,-1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% fprintf(s, 'sour:wave:arb:data -1, 0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0')
% Choosing an arbitrary waveform (meaning we can define our string our values like in the line above)
fprintf(s, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(s, 'curr:comp 50')
% Current amplitude (A)
fprintf(s, 'sour:wave:ampl 300e-6')
% How many cycles I want
fprintf(s, 'sour:wave:dur:cycl 3000')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(s, 'sour:wave:dur:time 4') % duration for 4 seconds
% Frequency of the waveform. I think of this as the resolution for the duration of
% my waveform. So if it's 400 Hz, then 1/400 = 2500 us
% Now, since I have 25 slots in my waveform, that means that each one is
% 100 us long.
fprintf(s, 'sour:wave:freq 400')

fprintf(s, 'output off')
fprintf(s, 'sour:wave:arm')
fprintf(s, 'sour:wave:init')

% fprintf(s, 'system:key 8')


%% Program DC 'long pulse'

fprintf(s, 'sour:wave:abor')
fprintf(s, 'sour:curr:rang:auto on')
fprintf(s, 'curr:filt off')
% Cathodic first, one data point per phase
fprintf(s, 'sour:wave:arb:data -1,1')
fprintf(s, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(s, 'curr:comp 15')
% Current amplitude (A)
fprintf(s, 'sour:wave:ampl 100e-6')
% How many cycles I want
fprintf(s, 'sour:wave:dur:cycl 1')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(s, 'sour:wave:dur:time 40')
% Frequency of the waveform. 
fprintf(s, 'sour:wave:freq 0.25') % having each phase for 2 s


fprintf(s, 'output off')
fprintf(s, 'sour:wave:arm')
fprintf(s, 'sour:wave:init')

%% Program DC 

fprintf(s, 'sour:wave:abor')
fprintf(s, 'sour:curr:rang:auto on')
fprintf(s, 'curr:filt off')
% Cathodic phase
fprintf(s, 'sour:wave:arb:data -1')
fprintf(s, 'sour:wave:func arb0')
% Compliance voltage (V)
fprintf(s, 'curr:comp 100')
% Current amplitude (A)
fprintf(s, 'sour:wave:ampl 100e-6')
% How many cycles I want
fprintf(s, 'sour:wave:dur:cycl 1')
% Alternative for defining duration: how long do I want it to last (s)
fprintf(s, 'sour:wave:dur:time 40')
% Frequency of the waveform. 
fprintf(s, 'sour:wave:freq 0.25') % having each phase for 2 s


fprintf(s, 'output off')
fprintf(s, 'sour:wave:arm')
fprintf(s, 'sour:wave:init')

%% Disconnecting

% Disconnect and clean up the server connection.
fclose(s);
delete(s);
clear s