% Predicate (e):
% Updates RemTAs list after assining the TA with name 'Name'

ta_slot_assignment([], [], _).

ta_slot_assignment(TAs, RemTAs, Name) :-
	TAs = [ta(TAName, Load)|T],
	ta_slot_assignment(T, PreviousRemTAs, Name),
	((TAName = Name, Load > 0, NewLoad is Load - 1);
	 (TAName \= Name, NewLoad is Load)),
	RemTAs = [ta(TAName, NewLoad)|PreviousRemTAs].

