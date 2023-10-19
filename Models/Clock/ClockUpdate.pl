:- consult('./GetSetClock').
:- consult('../../Utils/MatrixUtils.pl').


% Atualiza no arquivo .txt o relógio
updateMatrixClock(FilePath) :-
    getClock(Minutes),
    formatHour(Minutes, MinutesFormated),
    writeMatrixValue(FilePath, MinutesFormated, 3, 38).


% Recebe os minutos e formata para horas em uma String (500 minutos -> 08:20)
formatHour(Num, R) :-
    Num div 60 < 10,
    Num mod 60 < 10,
    Hour is Num div 60, Minute is Num mod 60,
    string_concat("0", Hour, Temp1),
    string_concat(Temp1, ":0", Temp2),
    string_concat(Temp2, Minute, R), !.

formatHour(Num, R) :-
    Num div 60 < 10,
    Num mod 60 >= 10,
    Hour is Num div 60, Minute is Num mod 60,
    string_concat("0", Hour, Temp1),
    string_concat(Temp1, ":", Temp2),
    string_concat(Temp2, Minute, R), !.

formatHour(Num, R) :-
    Num div 60 >= 10,
    Num mod 60 < 10,
    Hour is Num div 60, Minute is Num mod 60,
    string_concat(Hour, ":0", Temp1),
    string_concat(Temp1, Minute, R), !.
    
formatHour(Num, R) :-
    Hour is Num div 60, Minute is Num mod 60,
    string_concat(Hour, ":", Temp1),
    string_concat(Temp1, Minute, R), !.