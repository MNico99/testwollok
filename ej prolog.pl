continente(americaDelSur).
continente(americaDelNorte).
continente(asia).
continente(oceania).

estaEn(americaDelSur, argentina).
estaEn(americaDelSur, brasil).
estaEn(americaDelSur, chile).
estaEn(americaDelSur, uruguay).
estaEn(americaDelNorte, alaska).
estaEn(americaDelNorte, yukon).
estaEn(americaDelNorte, canada).
estaEn(americaDelNorte, oregon).
estaEn(asia, kamtchatka).
estaEn(asia, china).
estaEn(asia, siberia).
estaEn(asia, japon).
estaEn(oceania,australia).
estaEn(oceania,sumatra).
estaEn(oceania,java).
estaEn(oceania,borneo).

jugador(amarillo).
jugador(magenta).
jugador(negro).
jugador(blanco).

aliados(X,Y):- alianza(X,Y).
aliados(X,Y):- alianza(Y,X).

alianza(amarillo,magenta).

% el numero son los ejercitos
ocupa(argentina, magenta, 5).
ocupa(chile, negro, 3).
ocupa(brasil, amarillo, 8).
ocupa(uruguay, magenta, 5).
ocupa(alaska, amarillo, 7).
ocupa(yukon, amarillo, 1).
ocupa(canada, amarillo, 10).
ocupa(oregon, amarillo, 5).
ocupa(kamtchatka, negro, 6).
ocupa(china, amarillo, 2).
ocupa(siberia, amarillo, 5).
ocupa(japon, amarillo, 7).
ocupa(australia, negro, 8).
ocupa(sumatra, negro, 3).
ocupa(java, negro, 4).
ocupa(borneo, negro, 1).

% Usar este para saber si son limitrofes ya que es una relacion simetrica
sonLimitrofes(X, Y) :- limitrofes(X, Y).
sonLimitrofes(X, Y) :- limitrofes(Y, X).

limitrofes(argentina,brasil).
limitrofes(argentina,chile).
limitrofes(argentina,uruguay).
limitrofes(uruguay,brasil).
limitrofes(alaska,kamtchatka).
limitrofes(alaska,yukon).
limitrofes(canada,yukon).
limitrofes(alaska,oregon).
limitrofes(canada,oregon).
limitrofes(siberia,kamtchatka).
limitrofes(siberia,china).
limitrofes(china,kamtchatka).
limitrofes(japon,china).
limitrofes(japon,kamtchatka).
limitrofes(australia,sumatra).
limitrofes(australia,java).
limitrofes(australia,borneo).
limitrofes(australia,chile).

% 1
puedenAtacarse(Jugador1, Jugador2) :- ocupa(P1,Jugador1, _) , ocupa(P2,Jugador2,_) , sonLimitrofes(P1,P2).

% 2
estaTodoBien(Jugador1,Jugador2) :- aliados(Jugador1, Jugador2).
estaTodoBien(Jugador1,Jugador2) :- jugador(Jugador1),jugador(Jugador2),Jugador1 \= Jugador2,not(puedenAtacarse(Jugador1, Jugador2)).

% 3
loLiquidaron(Jugador) :- jugador(Jugador), not(ocupa(_, Jugador, _)).

% 4
ocupaContinente(Jugador,Continente) :- jugador(Jugador), continente(Continente), forall(estaEn(Continente,Pais), ocupa(Pais, Jugador, _) ).

% 5
estaPeleado(Continente):-ocupa(_,Jugador,_),forall(ocupa(Pais,Persona,_),estaEn(Continente,Pais)).

% 6
seAtrinchero(Jugador) :- ocupa(_,Jugador,_), continente(Continente), forall(ocupa(Pais,Jugador,_), estaEn(Continente,Pais)).

% 7
%puedeConquistar(Jugador,Continente) :- 
	jugador(Jugador), 
	continente(Continente), 
	not(ocupaContinente(Jugador,Continente))
	forall(paisDelContinenteQueNoTiene(Jugador,Continente,Pais), puedeConsquistarPais(Jugador,Pais)).

paisDelContinenteQueNoTiene(Jugador,Continente,Pais):-estaEn(Continente,Pais), not(ocupa(Pais,Jugador,_)).
puedeConquistarPais(Jugador,Pais):-ocupa(Pais,Jugador2,_),ocupa(Pais2,Jugador,_),not(aliados(Jugador,Jugador2)),sonLimitrofes(Pais,Pais2).

% 8
elQueTieneMasEjercitos(Jugador,Pais):- ocupa(Pais,Jugador,E), forall(ocupa(_,_,Ej), E >= Ej).

% 9
juntan(P1,P2,C):- ocupa(P1,_,E1), ocupa(P2,_,E2), C is E1+E2.

%10 
seguroGanaContra(P1,P2):- sonLimitrofes(P1,P2),
						  ocupa(P1,J1,E1),
						  ocupa(P2,J2,E2),
						  J1 \= J2,
						  E1 > (2*E2).

						 
%11
seguroGanaContra(Pais1,Pais2):-sonLimitrofes(Pais1,Pais2),
ocupa(Pais1,Jugador1,Ejercito1),ocupa(Pais2,Jugador2,Ejercito2),Jugador1 \= Jugador2,
Ejercito1>2*Ejercito2.