:- consult('LoginClient.pl').
:- consult('SaveClient.pl').

getLoggedUserID(ID) :- 
    getLoggedClient(Client),
    Client = client(ID, _, _, _, _, _, _, _, _, _, _, _).

getName(JSONPath, ID, Name) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, Name, _, _, _, _, _, _, _, _, _, _).

getCPF(JSONPath, ID, CPF) :-
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, CPF, _, _, _, _, _, _, _, _).

getCash(JSONPath, ID, Cash) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, Cash, _, _, _, _, _).

getPatrimony(JSONPath, ID, Patrimony) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, Patrimony, _, _, _, _).

getCanDeposit(JSONPath, ID, CanDeposit) :-
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, _, CanDeposit, _, _, _).

getRow(JSONPath, ID, Row) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, Row, _, _).

getCol(JSONPath, ID, Col) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, Col, _).

getAllAssets(JSONPath, ID, AllAssets) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets).

getQtdAssetsInCompany(JSONPath, ID, IDCompany, Acoes) :- 
    getClient(JSONPath, ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets),
    searchAcoes(AllAssets, IDCompany,  Acoes).
    
setCash(JSONPath, ID, NewCash) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).

setPatrimony(JSONPath, ID, NewPatrimony) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, NewPatrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).

setCanDeposit(JSONPath, ID, NewCanDeposit) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, NewCanDeposit, Row, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).

setAllAssets(JSONPath, ID, NewAllAssets) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, NewAllAssets),
    editClientJSON(JSONPath, NewClient).

setRow(JSONPath, ID, NewRow) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).
    
setCol(JSONPath, ID, NewCol) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(JSONPath, NewClient).

addCash(JSONPath, ID, AddCash) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCash is (Cash + AddCash),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).

addRow(JSONPath, ID, AddRow) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewRow is (Row + AddRow),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(JSONPath, NewClient).

addCol(JSONPath, ID, AddCol) :- 
    getClient(JSONPath, ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCol is (Col + AddCol),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(JSONPath, NewClient).

searchAcoes(AllAssets, IDCompany, Acoes) :-
    buscarAcoes(AllAssets, IDCompany, Acoes).
buscarAcoes([], _, 0).
buscarAcoes([[IDCompany, Acoes]|_], IDCompany, Acoes).
buscarAcoes([_|Rest], IDCompany, Acoes) :-
    buscarAcoes(Rest, IDCompany, Acoes).
