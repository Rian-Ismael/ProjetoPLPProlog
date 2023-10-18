:- consult('Utils.MatrixUtilspl').
:- consult('Utils.VerificationUtils.pl').
:- consult('Models.Client.RealizarLogin.pl').
:- consult('Models.Client.CadastrarCliente.pl').
:- consult('Models.Client.GetSetAttrsClient.pl').
:- consult('Models.Client.LoginClient.pl').
:- consult('Models.Company.CadastrarCompany.pl').
:- consult('Models.Company.SaveCompany.pl').
:- consult('Menus/Wallet/DepositoSaque/WalletDepSaqLogic.pl').
:- consult('Menus/Wallet/WalletUpdate.pl').
:- consult('Menus/HomeBroker/HomeBrokerUpdate.pl').
:- consult('Menus/HomeBroker/BuySell/HomeBrokerBuySellLogic.pl').
:- consult('Menus/HomeBroker/HomeBrokerLoopLogic.pl').
:- consult('Menus/HomeBroker/CompanyProfile/CompanyProfileUpdate.pl').
:- consult('Menus/HomeBroker/TrendingClose/TrendingCloseUpdate.pl').
:- consult('Menus/HomeBroker/CompanyDown/CompanyDownUpdate.pl').
:- consult('Menus/MainMenu/MainMenuUpdate.pl').
:- consult('Models/Clock/GetSetClock.pl').

startMenu :-
    logoutClient,
    printMatrix("./Menus/StartMenu/startMenu.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(userChoice),
    optionsStartMenu(userChoice).

optionsStartMenu(UserChoice) :-
    (   UserChoice = "L"; UserChoice = "l" ->
        fazerLoginMenu
    ;   UserChoice = "U"; UserChoice = "u" ->
        cadastraUsuarioMenu
    ;   UserChoice = "E"; UserChoice = "e" ->
        cadastraEmpresaMenu
    ;   UserChoice = "S"; UserChoice = "s" ->
        true
    ;   writeln("Opção Inválida!"),
        startMenu
    ).

fazerLoginMenu :-
    printMatrix("./Menus/StartMenu/loginMenu.txt"),
    write("Deseja fazer login? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (   querContinuarAOperacao(UserChoice) ->
        fazerLogin(ResultadoLogin),
        (   ResultadoLogin ->
            getLoggedUserID(IdUser),
            mainMenu(IdUser)
        ;   startMenu
        )
    ;   startMenu
    ).

cadastraUsuarioMenu :-
    printMatrix("./Menus/StartMenu/cadastroUsuario.txt"),
    write("Deseja cadastrar um novo usuário? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (   querContinuarAOperacao(UserChoice) ->
        cadastrarCliente,
        menuCadastroRealizado(true)
    ;   startMenu
    ).

cadastraEmpresaMenu :-
    printMatrix("./Menus/StartMenu/cadastroEmpresa.txt"),
    write("Deseja cadastrar uma nova empresa? (S/N): "),
    flush_output,
    read_line(UserChoice),
    (   querContinuarAOperacao(UserChoice) ->
        getCompanyJSON(CompaniesJson),
        length(CompaniesJson, NumCompanies),
        cadastrarCompany(NumCompanies, Cadastrou),
        menuCadastroRealizado(Cadastrou)
    ;   startMenu
    ).

querContinuarAOperacao(UserChoice) :-
    (   UserChoice = "S"; UserChoice = "s" ->
        true
    ;   false
    ).

menuCadastroRealizado(true) :-
    printMatrix("./Menus/StartMenu/cadastroRealizado.txt"),
    threadDelay(2000000),
    startMenu.

menuCadastroRealizado(false) :-
    writeln("Aviso: limite máximo de empresas cadastradas atingido."),
    startMenu.

mainMenu(IdUser) :-
    updateMainMenu(IdUser),
    printMatrix("./Menus/MainMenu/mainMenu.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsMainMenu(IdUser, UserChoice).

optionsMainMenu(IdUser, UserChoice) :-
    (   UserChoice = "W"; UserChoice = "w" ->
        walletMenu(IdUser)
    ;   between(1, 12, ChoiceInt), atom_number(UserChoice, ChoiceInt),
        homeBrokerMenu(IdUser, ChoiceInt)
    ;   UserChoice = "A"; UserChoice = "a" ->
        homeBrokerMenu(IdUser, 10)
    ;   UserChoice = "B"; UserChoice = "b" ->
        homeBrokerMenu(IdUser, 11)
    ;   UserChoice = "C"; UserChoice = "c" ->
        homeBrokerMenu(IdUser, 12)
    ;   UserChoice = "S"; UserChoice = "s" ->
        startMenu
    ;   writeln("Opção inválida"),
        mainMenu(IdUser)
    ).

homeBrokerMenu(IdUser, IdComp) :-
(   existCompany(IdComp) ->
    updateHomeBroker(IdUser, IdComp),
    atom_concat('./Models/Company/HomeBrokers/homebroker', IdComp, File),
    atom_concat(File, '.txt', FilePath),
    printMatrix(FilePath),
    write("Digite por quantos segundos a ação deve variar: "),
    flush_output,
    read_line(UserChoice),
    optionsHomeBrokerMenu(IdUser, IdComp, UserChoice)
;   mainMenu(IdUser)
).

optionsHomeBrokerMenu(IdUser, IdComp, UserChoice) :-
    (   UserChoice = "B"; UserChoice = "b" ->
        buyMenu(IdUser, IdComp)
    ;   UserChoice = "S"; UserChoice = "s" ->
        sellMenu(IdUser, IdComp)
    ;   UserChoice = "P"; UserChoice = "p" ->
        companyProfileMenu(IdUser, IdComp)
    ;   UserChoice = "V"; UserChoice = "v" ->
        mainMenu(IdUser)
    ;   number_string(ChoiceInt, UserChoice),
        attGraphs(IdUser, IdComp, ChoiceInt)
    ;   writeln("Opção inválida"),
        homeBrokerMenu(IdUser, IdComp)
    ).

attGraphs(IdUser, IdComp, UserChoice) :-
    callLoop(IdComp, UserChoice, IsCurrentCompanyDown),
    menuAfterLoop(IdUser, IdComp, IsCurrentCompanyDown).

menuAfterLoop(IdUser, IdComp, true) :-
    companyDownMenu(IdUser, IdComp).

menuAfterLoop(IdUser, IdComp, false) :-
    getClock("./Data/Clock.json", Clock),
    (   Clock >= 720 ->
        trendingCloseMenu(IdUser)
    ;   homeBrokerMenu(IdUser, IdComp)
    ).
    
companyProfileMenu(IdUser, IdComp) :-
    updateCompanyProfile(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/CompanyProfile/companyProfile.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsCompanyProfileMenu(IdUser, IdComp, UserChoice).

optionsCompanyProfileMenu(IdUser, IdComp, UserChoice) :-
    (   UserChoice = "V"; UserChoice = "v" ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção Inválida!"),
        companyProfileMenu(IdUser, IdComp)
    ).

buyMenu(IdUser, IdComp) :-
    updateHomeBrokerBuy(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/BuySell/homebrokerBuy.txt"),
    write("Digite quantas ações deseja comprar: "),
    flush_output,
    read_line(UserChoice),
    optionsBuyMenu(IdUser, IdComp, UserChoice).

optionsBuyMenu(IdUser, IdComp, UserChoice) :-
    (   number_string(Quantity, UserChoice) ->
        buy(IdUser, IdComp, Quantity),
        buyMenu(IdUser, IdComp)
    ;   member(UserChoice, ["V", "v", "C", "c"]) ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção inválida"),
        buyMenu(IdUser, IdComp)
    ).

sellMenu(IdUser, IdComp) :-
    updateHomeBrokerSell(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/BuySell/homebrokerSell.txt"),
    write("Digite quantas ações deseja vender: "),
    flush_output,
    read_line(UserChoice),
    optionsSellMenu(IdUser, IdComp, UserChoice).

optionsSellMenu(IdUser, IdComp, UserChoice) :-
    (   number_string(Quantity, UserChoice) ->
        sell(IdUser, IdComp, Quantity),
        sellMenu(IdUser, IdComp)
    ;   member(UserChoice, ["V", "v", "C", "c"]) ->
        homeBrokerMenu(IdUser, IdComp)
    ;   writeln("Opção inválida"),
        sellMenu(IdUser, IdComp)
    ).

walletMenu(IdUser) :-
    updateClientWallet(IdUser),
    atom_concat('./Models/Client/Wallets/wallet', IdUser, FilePath),
    atom_concat(FilePath, '.txt', File),
    printMatrix(File),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsWalletMenu(IdUser, UserChoice).

optionsWalletMenu(IdUser, UserChoice) :-
    (   UserChoice = "S"; UserChoice = "s" ->
        saqueMenu(IdUser)
    ;   UserChoice = "D"; UserChoice = "d" ->
        depositoMenu(IdUser)
    ;   UserChoice = "V"; UserChoice = "v" ->
        mainMenu(IdUser)
    ;   writeln("Opção inválida"),
        walletMenu(IdUser)
    ).

saqueMenu(IdUser) :-
    updateWalletSaque(IdUser),
    printMatrix("./Menus/Wallet/DepositoSaque/walletSaque.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsSaqueMenu(IdUser, UserChoice).

optionsSaqueMenu(IdUser, UserChoice) :-
    (   UserChoice = "2" ->
        sacar200(IdUser),
        saqueMenu(IdUser)
    ;   UserChoice = "5" ->
        sacar500(IdUser),
        saqueMenu(IdUser)
    ;   UserChoice = "T"; UserChoice = "t" ->
        sacarTudo(IdUser),
        saqueMenu(IdUser)
    ;   UserChoice = "V"; UserChoice = "v" ->
        walletMenu(IdUser)
    ;   writeln("Opção inválida"),
        saqueMenu(IdUser)
    ).

depositoMenu(IdUser) :-
    updateWalletDeposito(IdUser),
    printMatrix("./Menus/Wallet/DepositoSaque/walletDeposito.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(UserChoice),
    optionsDepositoMenu(IdUser, UserChoice).

optionsDepositoMenu(IdUser, UserChoice) :-
    (   UserChoice = "S"; UserChoice = "s" ->
        depositar(IdUser, CanDeposit),
        depositoMenu(IdUser)
    ;   member(UserChoice, ["V", "v", "N", "n"]) ->
        walletMenu(IdUser)
    ;   writeln("Opção inválida"),
        depositoMenu(IdUser)
    ).


trendingCloseMenu(IdUser) :-
    updateTrendingClose(IdUser),
    setClock(420),
    printMatrix("./Menus/HomeBroker/TrendingClose/trendingClose.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(_),
    mainMenu(IdUser).

companyDownMenu(IdUser, IdComp) :-
    updateCompanyDown(IdUser, IdComp),
    printMatrix("./Menus/HomeBroker/CompanyDown/companyDown.txt"),
    write("Digite uma opção: "),
    flush_output,
    read_line(_),
    mainMenu(IdUser).

formatInputToSeconds(Segundos, FormattedSegundos) :-
    (   number_string(SecondsInt, Segundos),
        SecondsInt > 30 ->
        FormattedSegundos = 30
    ;   number_string(FormattedSegundos, Segundos)
    ).
