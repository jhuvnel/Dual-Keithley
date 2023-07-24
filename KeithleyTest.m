clear all

v = visadev("ASRL9::INSTR");
v.BaudRate = 57600;
configureTerminator(v,"LF")
pause(10)

%% EDIT TO CUSTOMIZE 

amp = 0.75e-3;
maxstep = 1e-6*(amp/abs(amp));

beforetime = 1; % 1
risetime = 20; %
waitONtime = 5; % 3 / 1
ONtime = 5; % 4 / 2
falltime = 10; % 5 / 3
aftertime = 5;% 6 / 4
pausetime = 5;% 7 / 5
lasttime = 5;% 8 / 6

loadpausetime = 0.25;

%% CREATE DATA POINTS AND DELAYS
% Before
swepts = 0; 
del = beforetime;

% Rise
dtrise = risetime/(amp/maxstep);
risepts = maxstep:maxstep:(amp-maxstep);
swepts = [swepts risepts];
del = [del repmat(dtrise, [1, length(risepts)])];

% ON
swepts = [swepts amp];
del = [del waitONtime+ONtime];

% Fall
dtfall = falltime/(amp/maxstep);
fallpts = (amp-maxstep):-maxstep:maxstep;
swepts = [swepts fallpts];
del = [del repmat(dtfall, [1, length(fallpts)])];

% OFF
swepts = [swepts 0];
del = [del aftertime+pausetime+lasttime];

%% WRITE DATA TO KEITHLEY

writeline(v, "SOUR:CURR:COMP 100.0")
writeline(v, "SOUR:SWE:SPAC LIST")
writeline(v, "SOUR:SWE:RANG BEST") % Select source range.
writeline(v, "SOUR:SWE:CAB OFF")

Npts = length(swepts);
ptsperload = 100;
Nloads = ceil(Npts/ptsperload);

currString = sprintf('%.6f,' , swepts(1:ptsperload));
currString = currString(1:end-1);% strip final comma

delString = sprintf('%.6f,' , del(1:ptsperload));
delString = delString(1:end-1);% strip final comma

writeline(v, append("SOUR:LIST:CURR ", currString))
pause(loadpausetime)
writeline(v, append("SOUR:LIST:DEL ", delString))
pause(loadpausetime)

for n = 2:Nloads
    if n < Nloads
        currString = sprintf('%.6f,' , swepts((ptsperload*(n-1)+1):ptsperload*n));
        currString = currString(1:end-1); % strip final comma

        delString = sprintf('%.6f,' , del((ptsperload*(n-1)+1):ptsperload*n));
        delString = delString(1:end-1); % strip final comma
    else
        currString = sprintf('%.6f,' , swepts((ptsperload*(n-1)+1):end));
        currString = currString(1:end-1); % strip final comma

        delString = sprintf('%.6f,' , del((ptsperload*(n-1)+1):end));
        delString = delString(1:end-1); % strip final comma
    end

    writeline(v, append("SOUR:LIST:CURR:APP ", currString))
    pause(loadpausetime)
    writeline(v, append("SOUR:LIST:DEL:APP ", delString))
    pause(loadpausetime)
end

writeline(v, "SOUR:SWE:ARM") %Arm sweep, turn on output.
disp("Loaded.")

u = 0;
while ~u
    u = input(['Enter "1" to run.' newline]);
    if u
        writeline(v, "INIT")
        disp('Running.')
    end
end
