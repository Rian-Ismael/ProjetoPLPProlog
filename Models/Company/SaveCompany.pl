:- use_module(library(http/json)).

lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

exibirCompaniesAux([], []).
exibirCompaniesAux([H|T], [company(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col)|Rest]) :- 
    exibirCompaniesAux(T, Rest).

listarCompanies(Out) :-
	lerJSON("../../Data/Companies.json", Companies),
	exibirCompaniesAux(Companies , Result),
    Out = Result.

editarCompanyJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarCompanyJSON([H|T], H.ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [_{ident: H.ident, name: Name, age: Age, cnpj: Cnpj, actuation: Actuation, declaration: Declaration, code: Code, price: Price, trendIndicator: TrendIndicator, minPrice: MinPrice, maxPrice: MaxPrice, startPrice: StartPrice, row: Row, col: Col} | T]).
editarCompanyJSON([H|T], Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [H|Out]) :- editarCompanyJSON(T, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out).

editarCompany(Company) :-
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
	lerJSON("../../Data/Companies.json", File),
	editarCompanyJSON(File, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, SaidaParcial),
	companiesToJSON(SaidaParcial, Saida),
	open("../../Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).

companyToJSON(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "age": "%w", "cnpj": "%w", "actuation": "%w", "declaration": "%w", "code": "%w", "price": %w, "trendIndicator": "%w", "minPrice": %w, "maxPrice": %w, "startPrice": %w, "row": %w, "col": %w}', [Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col]).

companiesToJSON([], []).
companiesToJSON([H|T], [X|Out]) :- 
	companyToJSON(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col, X), 
	companiesToJSON(T, Out).

saveCompany(FilePath, Company) :- 
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    lerJSON(FilePath, File),
    companiesToJSON(File, ListaCompaniesJSON),
    listarCompanies(Out), length(Out, Length), NewIdent is Length + 1,
    companyToJSON(NewIdent,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, CompanyJSON),
    append(ListaCompaniesJSON, [CompanyJSON], Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

removerCompanyJSON([], _, []).
removerCompanyJSON([H|T], H.ident, T).
removerCompanyJSON([H|T], Ident, [H|Out]) :- removerCompanyJSON(T, Ident, Out).

removeCompany(Id) :-
    lerJSON("../../Data/Companies.json", File),
    removerCompanyJSON(File, Id, SaidaParcial),
    companiesToJSON(SaidaParcial, Saida),
    open("../../Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).

getCompany(Int, Company) :- 
    listarCompanies(Out), 
    buscarCompanyPorId(Int, Out, Company).

buscarCompanyPorId(_, [], _) :- fail.
buscarCompanyPorId(Ident, [company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)|_], company(Ident,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)).
buscarCompanyPorId(Ident, [_|Resto], CompanyeEncontrado) :-
    buscarCompanyPorId(Ident, Resto, CompanyeEncontrado).