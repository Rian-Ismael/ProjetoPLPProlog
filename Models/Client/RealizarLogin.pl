:- consult('GetInfoForMakeLogin.pl').
:- consult('SaveClient.pl').
:- consult('LoginClient.pl').
:- use_module(library(http/json)).

fazerLogin(Result) :-
    getEmail(Email),
    getPassword(PasswordClient),
    getClientJSON(List),
    searchClientEmail(Email, List, Client),
    verificarSenha(PasswordClient, Client, Result).

searchClientEmail(_, [], R) :- R = client(0, '', '', '', '', '', 0.0, 0.0, false, 0, 0, []), !.
searchClientEmail(EmailV, [H|_], Result) :- 
    H = client(_, _, _, _, Email, _, _, _, _, _, _, _),
    string_lower(EmailV, LowerEmail),
    string_lower(Email, LowerClientEmail),
    LowerEmail = LowerClientEmail,
    Result = H, !.

searchClientEmail(EmailV, [_|T], Result) :- 
    searchClientEmail(EmailV, T, Result).

verificarSenha(PasswordClient, Client, Result) :-
    Client = client(_, _, _, _, _, Password, _, _, _, _, _, _),
    string_lower(PasswordClient, LowerPasswordClient),
    string_lower(Password, LowerPassword),
    LowerPasswordClient = LowerPassword,
    clientesToJSON(Client, Saida),
    saveLogin(Saida),
    Result = true.
        
clientesToJSON(Client, Saida) :-
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    swritef(Saida, '{"ident": %w, "name":"%w", "age": "%w", "cpf": "%w", "email": "%w", "password": "%w", "cash": %w,"patrimony": %w,"canDeposit": %w, "row": %w,"col": %w,"allAssets": %w}', [Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets]).
