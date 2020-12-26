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
    NewCarriedCount#=CarriedCount+1.
    
drop(EthanPos,CarriedCount,NewCarriedCount):-
    CarriedCount#>0,
    submarine(XS,YS),
    EthanPos=[XS,YS],
    % print(EthanPos),nl,
    NewCarriedCount#=0.
    


mission_impossible(EthanPos,CarriedCount,CurrentGrid,S,S):-
    submarine(XS,YS),
    EthanPos=[XS,YS],
    CarriedCount#=0,
    CurrentGrid=[].

mission_impossible(EthanPos,CarriedCount,CurrentGrid,S,SFinal):-
    % carry
    (carry(EthanPos,CarriedCount,CurrentGrid,NewCarriedCount,NewCurrentGrid),
    mission_impossible(EthanPos,NewCarriedCount,NewCurrentGrid,result(carry,S),SFinal));
    % drop
    (drop(EthanPos,CarriedCount,NewCarriedCount),
    mission_impossible(EthanPos,NewCarriedCount,CurrentGrid,result(drop,S),SFinal));
    % down
    (move_down(EthanPos,NewEthanPos),
    mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,result(down,S),SFinal));
    % up
    (move_up(EthanPos,NewEthanPos),
    mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,result(up,S),SFinal));
    % left
    (move_left(EthanPos,NewEthanPos),
    mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,result(left,S),SFinal));
    % right
    (move_right(EthanPos,NewEthanPos),
    mission_impossible(NewEthanPos,CarriedCount,CurrentGrid,result(right,S),SFinal)).

goal(S):-
    ethan_loc(X,Y),
    EthanPos=[X,Y],
    members_loc(CurrentGrid),
    mission_impossible(EthanPos,0,CurrentGrid,s0,S).