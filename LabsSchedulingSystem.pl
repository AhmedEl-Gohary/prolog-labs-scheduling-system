% predicate (c):
% max_slots_per_day/2 succeeds if no TA is assigned more than 'Max' labs in 'DaySched'
% [1, 2, 3, 4, 4, 2, 2] --> msort --> [1, 2, 2, 2, 3, 4, 4]
% clumped --> [1-1, 2-3, 4-2] --> extract_numbers --> [1, 3, 2]
% max_list --> 3

max_slots_per_day(DaySched, Max) :-
	flatten(DaySched, FlatSched),
	max_occurence(FlatSched, MaxOccurence),
	MaxOccurence =< Max.

max_occurence(List, Max) :-
	frequency_count(List, Count),
	extract_numbers(Count, Nums),
	max_list(Nums, Max).
	
frequency_count(List, Count) :-
    msort(List, Sorted),
    clumped(Sorted, Count).

extract_numbers([], []).

extract_numbers([_-Num|T], Counts) :-
	extract_numbers(T, PreviousCounts),
	Counts = [Num|PreviousCounts].


% Predicate (d):
% slot_assignment/4 succeeds if Assignment is a possible assignment to a single
% slot with 'LabsNum' labs and 'RemTAs' is the list of modified TAs after the assignment
% Works by generating all possible subsequences of the TAs list

slot_assignment(0, X, X, []).

slot_assignment(LabsNum, TAs, RemTAs, Assignment) :-
	TAs = [ta(Name, Load)|T],
	LabsNum > 0, Load > 0,
	NewLabsNum is LabsNum - 1,
	NewLoad is Load - 1,

	((slot_assignment(NewLabsNum, T, PreviousRemTAs, PreviousAssignment), 
	  RemTAs = [ta(Name, NewLoad)|PreviousRemTAs], 
	  Assignment = [Name|PreviousAssignment]);

	 (slot_assignment(LabsNum, T, PreviousRemTAs, Assignment),
	  RemTAs = [ta(Name, Load)|PreviousRemTAs])).



	
% Predicate (e):
% ta_slot_assignment/3 succeeds if RemTAs is the list of TA structures resulting
% from updating the load of TA Name in TAs.

ta_slot_assignment([], [], _).

ta_slot_assignment(TAs, RemTAs, Name) :-
	TAs = [ta(TAName, Load)|T],
	ta_slot_assignment(T, PreviousRemTAs, Name),
	((TAName = Name, Load > 0, NewLoad is Load - 1);
	(TAName \= Name, NewLoad is Load)),
	RemTAs = [ta(TAName, NewLoad)|PreviousRemTAs].


