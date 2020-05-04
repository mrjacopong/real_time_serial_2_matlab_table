
ConvertToTable(dati_raccolti,nomi_variabili)


function ConvertToTable(table_data,table_variable_names)
    
    table_variable_names = cellstr(table_variable_names(1,:))
    temp_table= array2table(table_data,'VariableNames',table_variable_names);

    %assegno alla tabella il nome come "Dati01_01_2020__12_30"
    assignin('base',append('Dati',datestr(now,'dd_mm_yyyy__HH_MM')),temp_table)
    
    %mette nella workspace direttamente i dati convertiti un una tabella
    %opportunamente nominata
end