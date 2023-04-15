% Predicate(d):
% Generates all the possible TA assignments for labs running during the same slot 
% TODO: check if it is possible to use ta_slot_assignment instead of repeating code
% TODO: handling non-positive Load
% TODO: check if there is a better way than generating all perumtations

slot_assignment(LabsNum, TAs, RemTAs, Assignment) :-
	permutation(TAs, NewPermutation),
	helper_slot_assignment(LabsNum, NewPermutation, RemTAs, Assignment).

helper_slot_assignment(0, TAs, TAs, []). 

helper_slot_assignment(LabsNum, TAs, RemTAs, Assignment) :-
	TAs = [ta(Name, Load)|T],
	NewLabsNum is LabsNum - 1, 
	helper_slot_assignment(NewLabsNum, T, PreviousRemTAs, PreviousAssignment),
	NewLoad is Load - 1,
	RemTAs = [ta(Name, NewLoad)|PreviousRemTAs],
	Assignment = [Name|PreviousAssignment].
	
% Predicate (e):
% Updates TAs list into RemTAs after assigning the TA with name 'Name' a new slot
% The load of the chosen TA is decremented

ta_slot_assignment([], [], _).

ta_slot_assignment(TAs, RemTAs, Name) :-
	TAs = [ta(TAName, Load)|T],
	ta_slot_assignment(T, PreviousRemTAs, Name),
	((TAName = Name, Load > 0, NewLoad is Load - 1);
	(TAName \= Name, NewLoad is Load)),
	RemTAs = [ta(TAName, NewLoad)|PreviousRemTAs].

