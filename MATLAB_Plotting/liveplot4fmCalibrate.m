function liveplot4fmCalibrate
% Clear everything
close all; clear all;
% reset all ports; otherwise might be unable to connect to port
instrreset;

% create our clean up object for interrupt
cleanupObj = onCleanup(@cleanMeUp);

% NAME THE TEST FIRST (only change the second part)
fileName = [datestr(now,'yyyy-mm-dd_HHMMSS'),'_fm_test1'];

% set up data monitoring frequency
pauseTime = 0.05;
% set up plotting frequency
% plotTime = 0.2;

% frequency
% fetchFrequency = 1/pauseTime;

% observation time window
% observationInterval = 5;

% time conversion factor
% timeFactor = 24 * 60 * 60;

% set up table to collect data
dataTypes = ["double","double","double","double"];
dataLabels = ["FM_pin_change_time","PT1","PT2","time"];
sz = [1,4];
testDataTable = table('Size',sz,'VariableTypes',dataTypes,'VariableNames',dataLabels);


% set up serial object
serialPortName = '/dev/cu.SLAB_USBtoUART'
% serialPortName = 'COM6'; % on Windows would be COMx
%s = serialport(serialPortName,115200);
s = serial(serialPortName,'BaudRate',230400);

% open serial port
fopen(s);
% remember to fclose(s) in the command windows after ctrl+C exit the
% infinite while loop so that other programs can use the port

% set up plot
% f = figure;
% f.Position = [300 -100 800 650];
% t = tiledlayout(6,1);
% 
% % First tile
% ax1 = nexttile;
% ax1.XColor = [1 0 0];
% ax1.YColor = [1 0 0];
% 
% 
% % Second tile
% ax2 = nexttile;
% ax2.XColor = [1 0 0];
% ax2.YColor = [1 0 0];
% 
% 
% % Third tile
% ax3 = nexttile;
% ax3.XColor = [1 0 0];
% ax3.YColor = [1 0 0];
% 
% % Fourth Tile
% ax4 = nexttile;
% ax4.XColor = [1 0 0];
% ax4.YColor = [1 0 0];
% 
% % Fifth Tile
% ax5 = nexttile;
% ax5.XColor = [1 0 0];
% ax5.YColor = [1 0 0];
% 
% % Sixth Tile
% ax6 = nexttile;
% ax6.XColor = [1 0 0];
% ax6.YColor = [1 0 0];


% timeControl = now();

% for storing data sequentially in data1 and data2
i = 1;

% read data
flushinput(s);
fscanf(s);

% accounts for any time delay from reading
timeZeroer = 0;
cyclePerTime = 0;
while(1)
    startTime=datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    startTime=startTime(21:23);
    str = split(fscanf(s));

if size(str,1)==2
    timeInterval(i) = str2double(str{1});

        testDataTable(i,:) = {timeInterval(i),0,0,0};

else 
    % each data line represents one sensor data
    timeInterval(i) = (str2double(str{4})-timeZeroer)/1000;
    if i == 1
        timeZeroer = str2double(str{4});
        timeInterval(i) = (str2double(str{4})-timeZeroer)/1000;
    end


    % data1 receives flowrate in L/min
    % data1(i) = str2double(str{2})/10000;

    % data1 receives PT1
    data1(i) = str2double(str{2})*1.0533*10^(-4)+20.8469;
    % data2 receives PT2
    data2(i) = str2double(str{3})*1.0323*10^(-4)+17.9758;
    % data3 receives FM_pin_change_time
    data3(i) = str2double(str{4});

%    if (data3(i)~=1)
 %       if i == 1
  %          cyclePerTime(i) = 1/(data3(i)-0); % convert pin change time difference into frequencies
 %       else 
%            cyclePerTime(i) = 1/(data3(i)-data3(i-1));
%        end
%    else
%        if i == 1
%            cyclePerTime(i) = 1/(data3(i)-0);
%        else
%            cyclePerTime(i) = cyclePerTime(i-1);
%        end
%    end
        



    testDataTable(i,:) = {data3(i),data1(i),data2(i),timeInterval(i)};

end

    % data7 receives LC1
    % data7(i) = str2double(str{7});
    % data8 receives LC2
    % data8(i) = str2double(str{8});
    % data9 receives LC3
    % data9(i) = str2double(str{9});




%     if (now() - timeControl) * 24 * 60 * 60 >= plotTime % plot every x seconds
%         if timeInterval(end)-timeInterval(1) <= observationInterval
% 
% 
%             axes(ax1);
%             plot(timeInterval,data1);
%             title('Pressure Transducer 1')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax2);
%             plot(timeInterval,data2);
%             title('Pressure Transducer 2')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
%             % ylim([-500000 100000]);
% 
%             axes(ax3);
%             plot(timeInterval,data3);
%             title('Pressure Transducer 3')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax4);
%             plot(timeInterval,data4);
%             title('Pressure Transducer 4')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax5);
%             plot(timeInterval,data5);
%             title('Pressure Transducer 5')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax6);
%             plot(timeInterval,data6);
%             title('Flow Meter')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%         else % plot only the latest 5 seconds of data
%             axes(ax1);
%             plot(timeInterval(end-observationInterval/pauseTime:end),data1(end-observationInterval/pauseTime:end));
%             % set the x limits so that only the last 5 seconds of data is
%             % plotted
%             title('Pressure Transducer 1')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax2);
%             % change the number e.g "-6" according to trials.
%             plot(timeInterval(end-observationInterval/pauseTime:end),data2(end-observationInterval/pauseTime:end));
%             title('Pressure Transducer 2')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
%             % ylim([-500000 100000]);
% 
%             axes(ax3);
%             % change the number e.g "-6" according to trials.
%             plot(timeInterval(end-observationInterval/pauseTime:end),data3(end-observationInterval/pauseTime:end));
%             title('Pressure Transducer 3')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
%             % ylim([-500000 100000]);
% 
%             axes(ax4);
%             % change the number e.g "-6" according to trials.
%             plot(timeInterval(end-observationInterval/pauseTime:end),data4(end-observationInterval/pauseTime:end));
%             title('Pressure Transducer 4')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax5);
%             % change the number e.g "-6" according to trials.
%             plot(timeInterval(end-observationInterval/pauseTime:end),data5(end-observationInterval/pauseTime:end));
%             title('Pressure Transducer 5')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
% 
%             axes(ax6);
%             plot(timeInterval(end-observationInterval/pauseTime:end),data6(end-observationInterval/pauseTime:end));
%             % set the x limits so that only the last 5 seconds of data is
%             % plotted
%             title('Flow Meter')
% 
%             xlim([timeInterval(i)-observationInterval, timeInterval(i)]);
%         end
%         timeControl = now();
%     end
    endTime=datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
    endTime=endTime(21:23);

    timeDifference=str2double(endTime)-str2double(startTime);
    if timeDifference<pauseTime
        pause(timeDifference);
    end
    i = i+1;
end
    function cleanMeUp()
        % saves data to file (or could save to workspace)
        fprintf('saving test data as %s.xls\n',fileName);
        setUpTest(['Test_Data_',datestr(now,'yyyy-mm-dd')],fileName,testDataTable,timeInterval,cyclePerTime);
%         data3 = data3(data3~=1);
        fclose(s);
        instrreset;
%         testDataTable = {timeInterval(i),data1(i),data2(i),data3(i)};
        %         writetable(testDataTable,fileName,"FileType","spreadsheet");
    end



end

function setUpTest(folderName,fileName,testDataTable,timeInterval,cyclePerTime)
if ~exist(folderName, 'dir')
    mkdir(folderName);
    fprintf("test data folder created\n");
else
    fprintf("folder already exists\n")
end
%totalCycle = timeInterval * cyclePerTime'
writetable(testDataTable,fileName,"FileType","spreadsheet");
fileString = fileName + ".xls";
% writecell(fileString,"Total_cycle",'Sheet1','E1')
% writecell(fileString,totalCycle,'Sheet1','E2')
movefile(fileString,folderName);
plot(timeInterval,cyclePerTime);

end

