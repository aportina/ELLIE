


testData=[data1',data2',data6',timeInterval'];

dataLabels=["PT1","PT2","FM","Time"];
dataTypes = ["double","double","double","double"];
sz = [size(data1,2),4];


%testDataTable = table('Size',sz,'VariableTypes',dataTypes,'VariableNames',dataLabels);
%testDataTable(:,1)={data1'};
%testDataTable(:,2)=data2;
%testDataTable(:,3)=data6;
%testDataTable(:,4)=timeInterval;


%fileName=datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
%writetable(testDataTable,fileName,"FileType","spreadsheet");



