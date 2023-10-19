:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Client/PostClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').


buy(_, _, Num) :- Num =< 0, !.
buy(IdUser, IdComp, Num) :- 
    getCash(IdUser, Cash),
    getPrice(IdComp, Price),
    TotalPrice is Price * Num,
    (TotalPrice > Cash -> ! ; buyDeposit(IdUser, IdComp, TotalPrice, Num)).

buyDeposit(IdUser, IdComp, TotalPrice, Num) :-
    addCash(IdUser, -TotalPrice),
    addAsset(IdUser, IdComp, Num).


sell(_, _, Num) :- Num =< 0, !.
sell(IdUser, IdComp, Num) :-
    getCash(IdUser, Cash),
    getPrice(IdComp, Price),
    getQtdAssetsInCompany(IdUser, IdComp, Assets),
    TotalPrice is Price * Num,
    (Num > Assets -> ! ; sellDeposit(IdUser, IdComp, TotalPrice, Num)).

sellDeposit(IdUser, IdComp, TotalPrice, Num) :-
    addCash(IdUser, TotalPrice),
    addAsset(IdUser, IdComp, -Num).