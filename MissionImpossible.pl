:-use_module(library(clpfd)).


ethan_loc(0,0).
members_loc([[1,1],[1,2]]).
submarine(0,2).
capacity(1).

% move_down([X,3],[X,3]).
move_right([X,Y],[X,YNew]):-
    Y#<3,
    YNew #= Y+1.

% move_up([X,0],[X,0]).
move_left([X,Y],[X,YNew]):-
    Y#>0,
    YNew #= Y-1.


% move_right([3,Y],[3,Y]).
move_down([X,Y],[XNew,Y]):-
    X#<3,
    XNew #= X+1.

% move_left([0,Y],[0,Y]).
move_up([X,Y],[XNew,Y]):-
    X#>0,
    XNew #= X-1.

carry(EthanPos,CarriedCount,CurrentGrid,NewCarriedCount,NewCurrentGrid):-
    capacity(Cap),
    CarriedCount#<Cap,
    member(EthanPos, CurrentGrid),
    delete(CurrentGrid,EthanPos, NewCurrentGrid),
    % print(NewCarriedCount+" ASDSAFDSAF"),nl,
    NewCarriedCount#=CarriedCount+1.

drop(EthanPos,CarriedCount,NewCarriedCount):-
    CarriedCount#>0,
    submarine(XS,YS),
    EthanPos=[XS,YS],
    % print(EthanPos),nl,
    NewCarriedCount#=0.
    
% up
mission_impossible(EthanPos,0,CurrentGrid,result(up,s0),S):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_up(InitialEthanPos,EthanPos),
    print("UP"),nl.

% down
mission_impossible(EthanPos,0,CurrentGrid,result(down,s0),S):-
    
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_down(InitialEthanPos,EthanPos),
print("DOWN"),nl.

mission_impossible(EthanPos,0,CurrentGrid,result(left,s0),S):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_left(InitialEthanPos,EthanPos),
print("LEFT"),nl.

mission_impossible(EthanPos,0,CurrentGrid,result(right,s0),S):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    print("RIGHT"),nl,
    members_loc(CurrentGrid),
    move_right(InitialEthanPos,EthanPos).

% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(carry,s0),S):-
%     members_loc(CurrentGrid),
%     carry(EthanPos,CarriedCount,CurrentGrid,_,_).



% up
mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(up,State),S):-
    print("up"),nl,
    % State\=s0,
    % print(PreviousEthanPos),
    % EthanPos=[X,Y],
    % PreviousX #= X-1,
    mission_impossible(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_up(PreviousEthanPos,EthanPos),
    nl.


% down
mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(down,State),S):-
    print("down"),nl,
    % State\=s0,
    mission_impossible(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_down(PreviousEthanPos,EthanPos),
    nl.

    % print(PreviousEthanPos),
    % EthanPos=[X,Y],
    % PreviousX #= X-1,
mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(left,State),S):-
    % State\=s0,
    print("left"),nl,   
    mission_impossible(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_left(PreviousEthanPos,EthanPos),
    nl.

    % print(PreviousEthanPos),
    % EthanPos=[X,Y],
    % PreviousX #= X-1,

mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(right,State),S):-
    print("right"),nl,
    % State\=s0,
    mission_impossible(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_right(PreviousEthanPos,EthanPos),
nl.

    % print(PreviousEthanPos),
    % EthanPos=[X,Y],
    % PreviousX #= X-1,


mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(carry,State),S):-
    print("carry"),nl,
    % State\=s0,
    mission_impossible(EthanPos,OldCarriedCount,OldCurrentGrid,State,S),
    carry(EthanPos,OldCarriedCount,OldCurrentGrid,CarriedCount,CurrentGrid),
        %   EthanPos,CarriedCount,CurrentGrid,NewCarriedCount,NewCurrentGrid
nl.

% mission_impossible(EthanPos,0,[],result(drop,State),S):-
%     % print(State),
%     print(OldCurrentGrid),nl,
%     State\=s0,
%     mission_impossible(EthanPos,OldCarriedCount,OldCurrentGrid,State,S),
%     drop(EthanPos,OldCarriedCount,0),
% print("start"),nl,
% nl.

mission_impossible(EthanPos,0,CurrentGrid,result(drop,State),S):-
    % print(State),
    % print(OldCurrentGrid),nl,
    print("drop"),nl,
    % CurrentGrid\=[],
    mission_impossible(EthanPos,OldCarriedCount,CurrentGrid,State,S),
    drop(EthanPos,OldCarriedCount,0),
nl.

    
    % print("here"),









% mission_impossible(EthanPos,CarriedCount,CurrentGrid,S,S):-
%     submarine(XS,YS),
%     EthanPos=[XS,YS],
%     CarriedCount#=0,
%     CurrentGrid=[].

% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(carry,S),SFinal):-
%     % carry
%     (carry(EthanPos,CarriedCount,CurrentGrid,NewCarriedCount,NewCurrentGrid),
%     mission_impossible(EthanPos,NewCarriedCount,NewCurrentGrid,S,SFinal)).
%     % drop
% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(drop,S),SFinal):-
%     (drop(EthanPos,CarriedCount,NewCarriedCount),
%     mission_impossible(EthanPos,NewCarriedCount,CurrentGrid,S,SFinal)).
%     % down
% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(down,S),SFinal):-
%     (move_down(EthanPos,NewEthanPos),
%     mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,S,SFinal)).

% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(up,S),SFinal):-
%     % up
%     (move_up(EthanPos,NewEthanPos),
%     mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,S,SFinal)).
%     % left
% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(left,S),SFinal):-
%     (move_left(EthanPos,NewEthanPos),
%     mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,S,SFinal)).
%     % right
% mission_impossible(EthanPos,CarriedCount,CurrentGrid,result(right,S),SFinal):-
%     (move_right(EthanPos,NewEthanPos),
%     mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,S,SFinal)).

goal(S):-
    % ethan_loc(X,Y),
    % EthanPos=[X,Y],
    members_loc(CurrentGrid),
    S=result(drop,State),
    mission_impossible(EthanPos,0,[],S,_).