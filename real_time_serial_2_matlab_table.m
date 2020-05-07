%{
    poltta in real time i valori acquisiti dalla porta seriale e salva
    automaticamente i dati acquisiti un una tabella.
    ESEMPIO:

    1- dati seriali acquisiti:
    tempo;dato1;dato2; ... datoN
    1;10;5; ... 30
    2;12;6; ... 40
    .
    .
    .

    2- tabella salvata:
    _______________________________
    |tempo|dato1|dato2| ... |datoN|
    |  1  |  10 |  5  | ... |  30 |
    |  2  |  12 |  6  | ... |  40 |
%}



%controlla le seriali aperte
serialportlist("available");

%apre COM3 e crea un ogetto arduino dal quale poi si leggono le cose
arduinoObj = serialport("COM3",9600);

%setta il terminatore per la callback function come il carattere accapo
configureTerminator(arduinoObj,"CR/LF");

%elimina i vecchi dati dell'arduino se ce ne fossero
flush(arduinoObj);

%{ 
    dentro un oggetto creato con serial port, matlab crea anche userdata che   
    serve a storare i dati. nell'esempio i dati sono una struttura:
    
    struct UserData{
        double Data []
        int    Count
        string VariableNames
    }
%}
arduinoObj.UserData = struct("Data",[],"Count",1,"VariableNames","");

%pushbutton per fermare il collegamento e staccare la porta seriale
c = uicontrol('Style','pushbutton','String','stop');
c.Callback = @stoppa;
c.UserData = 0;
uicontrol(c);

%semplicemente quando da seriale leggo la stringa di terminator (accapo)
%allora chiamo la funzione readSineWaveData
configureCallback(arduinoObj,"terminator",@readSineWaveData);

%{
--------------------------------------------------------------------------
          sezione da eseguire una volta finita l'acquisizione
--------------------------------------------------------------------------
%}
%alla fine della raccolta dei dati, mi copio i dati ricevuti dall'arduino
%in dati_raccolti
dati_raccolti=arduinoObj.UserData.Data;
nomi_variabili=arduinoObj.UserData.VariableNames;

%ConvertToTable(dati_raccolti,nomi_variabili)


%{
--------------------------------------------------------------------------
                               funzioni
--------------------------------------------------------------------------
%}

function stoppa(src,event)
        evalin('base','dati_raccolti=arduinoObj.UserData.Data;')
        evalin('base','nomi_variabili=arduinoObj.UserData.VariableNames;')
        evalin('base','ConvertToTable(dati_raccolti,nomi_variabili)')
        evalin('base','clear arduinoObj dati_raccolti nomi_variabili c ans ')
        
    end

function readSineWaveData(src, ~)

% Read the ASCII data from the serialport object.
data = readline(src);
disp(data);
data = strsplit((data),";"); %dall'acquisizione "1;2" -> ["1","2"]

% Convert the string data to numeric type and save it in the UserData
% property of the serialport object.

% src.UserData.Data(end+1) = str2double(data);
 
 if src.UserData.Count == 1
    src.UserData.VariableNames = data;               %salvo la prima stringa come titolo per la tabella          
 else
    src.UserData.Data(end+1,:) = str2double(data);    %leggo la stringa e la salvo come String
 end



% Update the Count value of the serialport object.
src.UserData.Count = src.UserData.Count + 1;

%plot in real time delle acquisizioni
plot(src.UserData.Data(2:end,1),src.UserData.Data(2:end,2:end))

% If 1001 data points have been collected from the Arduino, switch off the
% callbacks and plot the data.
if src.UserData.Count > 1000
    configureCallback(src, "off");
    stoppa;
    
end
end


function ConvertToTable(table_data,table_variable_names)
    
    table_variable_names = cellstr(table_variable_names(1,:))
    temp_table= array2table(table_data,'VariableNames',table_variable_names);

    %assegno alla tabella il nome come "Dati01_01_2020__12_30"
    assignin('base',append('Data',datestr(now,'dd_mm_yyyy__HH_MM')),temp_table)
    
    %mette nella workspace direttamente i dati convertiti un una tabella
    %opportunamente nominata
end
