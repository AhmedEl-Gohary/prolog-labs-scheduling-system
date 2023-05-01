week_schedule([], _, _,[]).
week_schedule([H|T],TAs,DayMax,[H1|T1]):-
	day_schedule(H,TAs,RemTAs,H1),
	max_slots_per_day(H1,DayMax),
	week_schedule(T,RemTAs,DayMax,T1).

day_schedule([],X,X,[]).
day_schedule([H|T],TAs,RemTAs,[H1|T1]):-
	slot_assignment(H,TAs,TAs1,H1),
	day_schedule(T,TAs1,RemTAs,T1).

max_slots_per_day(DaySched,Max):-
	flatten(DaySched,L),
	\+ setof(X,(member(Y,L),count(Y,L,X),X > Max),_).
	
count(Name,L,S):-
	count(Name,L,0,S).
count(_,[] ,S,S):-!.
count(L,[L|T],Acc,S):-
	Acc1 is Acc +1 ,
	count(L,T,Acc1 ,S).
count(L ,[H|T],Acc ,S):-
	L \= H ,
	count(L,T,Acc,S).

slot_assignment_helper(0,X,X,[]).
slot_assignment_helper(X,[ta(N,L)|T],R,A):-
	X > 0 ,
	L > 0 ,
	X1 is X -1 ,
	L1 is L -1 ,
	((slot_assignment_helper(X1,T,T1,T2),A=[N|T2],R=[ta(N,L1)|T1] )
	; slot_assignment_helper(X,T,T1,A) , R=[ta(N,L)|T1]).
	
slot_assignment_helper(X,[ta(N,L)|T],[ta(N,L)|T1],A):-
	X > 0 ,
	L =< 0 ,
	slot_assignment_helper(X,T,T1,A).
	
slot_assignment(LabsNum,TAs,RemTAs,A):-
	permutation(TAs,TAS) ,
	setof((L1,L2),slot_assignment_helper(LabsNum,TAS,L1,L2),List) ,
	member((RemTAs,A),List).

ta_slot_assignment([], [], _).

ta_slot_assignment(TAs, RemTAs, Name) :-
	TAs = [ta(TAName, Load)|T],
	ta_slot_assignment(T, PreviousRemTAs, Name),
	((TAName = Name, Load > 0, NewLoad is Load - 1);
	(TAName \= Name, NewLoad is Load)),
	RemTAs = [ta(TAName, NewLoad)|PreviousRemTAs].
