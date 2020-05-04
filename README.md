# real time serial 2 matlab table

    plot in real time values avquired from a generic serial port 
    (COM3 -> arduino_uno in my case).
    automatically saves data in a table named as the current_date.
    the first line of the serial acquisition gives the information about the variable names in the table 
    
    EXAMPLE:

    1- ACQUIRED DATA:
    time;data1;data2; ... dataN
    1;10;5; ... 30
    2;12;6; ... 40
    .
    .
    .

    2- OUTPUT TABLE:
    _______________________________
    |time |data1|data2| ... |dataN|
    |  1  |  10 |  5  | ... |  30 |
    |  2  |  12 |  6  | ... |  40 |
