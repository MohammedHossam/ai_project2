% ---------------- Import KB and CLPFD

:-include('KB.pl').
:-use_module(library(clpfd)).

% -------------------- Actions Conditions
move_right([X,Y],[X,YNew]):-
    Y#<3,
    YNew #= Y+1.

move_left([X,Y],[X,YNew]):-
    Y#>0,
    YNew #= Y-1.

move_down([X,Y],[XNew,Y]):-
    X#<3,
    XNew #= X+1.

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
    NewCarriedCount#=0.

% ---------------------------------------------------------------------------------------------------
% ------------------------------------------ Validation ------------------------------------------
% ---------------------------------------------------------------------------------------------------

% ------------------ Base Cases------------------
mission_impossible_nonVar(EthanPos,0,CurrentGrid,result(up,s0),_):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_up(InitialEthanPos,EthanPos).

mission_impossible_nonVar(EthanPos,0,CurrentGrid,result(down,s0),_):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_down(InitialEthanPos,EthanPos).

mission_impossible_nonVar(EthanPos,0,CurrentGrid,result(left,s0),_):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_left(InitialEthanPos,EthanPos).

mission_impossible_nonVar(EthanPos,0,CurrentGrid,result(right,s0),_):-
    ethan_loc(X,Y),
    InitialEthanPos=[X,Y],
    members_loc(CurrentGrid),
    move_right(InitialEthanPos,EthanPos).

% ------------------ Recursive Calls ------------------


% -- UP action
mission_impossible_nonVar(EthanPos,CarriedCount,CurrentGrid,result(up,State),S):-
    mission_impossible_nonVar(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_up(PreviousEthanPos,EthanPos).    

% -- Down action
mission_impossible_nonVar(EthanPos,CarriedCount,CurrentGrid,result(down,State),S):-
    mission_impossible_nonVar(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_down(PreviousEthanPos,EthanPos).

% -- Left action
mission_impossible_nonVar(EthanPos,CarriedCount,CurrentGrid,result(left,State),S):-
    mission_impossible_nonVar(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_left(PreviousEthanPos,EthanPos).

% -- Right action
mission_impossible_nonVar(EthanPos,CarriedCount,CurrentGrid,result(right,State),S):-
    mission_impossible_nonVar(PreviousEthanPos,CarriedCount,CurrentGrid,State,S),
    move_right(PreviousEthanPos,EthanPos).

% -- Carry action
mission_impossible_nonVar(EthanPos,CarriedCount,CurrentGrid,result(carry,State),S):-
    mission_impossible_nonVar(EthanPos,OldCarriedCount,OldCurrentGrid,State,S),
    carry(EthanPos,OldCarriedCount,OldCurrentGrid,CarriedCount,CurrentGrid).

% -- Drop action
mission_impossible_nonVar(EthanPos,0,CurrentGrid,result(drop,State),S):-
    mission_impossible_nonVar(EthanPos,OldCarriedCount,CurrentGrid,State,S),
    drop(EthanPos,OldCarriedCount,0).

% ---------------------------------------------------------------------------------------------------
% ------------------------------------------ Find solution ------------------------------------------
% ---------------------------------------------------------------------------------------------------

% ------------------ Base Cases------------------
mission_impossible_Var(EthanPos,CarriedCount,CurrentGrid,S,S):-
    submarine(XS,YS),
    EthanPos=[XS,YS],
    CarriedCount#=0,
    CurrentGrid=[].


mission_impossible_Var(EthanPos,CarriedCount,CurrentGrid,S,SFinal):-
    % carry
    (carry(EthanPos,CarriedCount,CurrentGrid,NewCarriedCount,NewCurrentGrid),
    mission_impossible_Var(EthanPos,NewCarriedCount,NewCurrentGrid,result(carry,S),SFinal));
    
    
    % drop
    (drop(EthanPos,CarriedCount,NewCarriedCount),
    mission_impossible_Var(EthanPos,NewCarriedCount,CurrentGrid,result(drop,S),SFinal));
    
    % down
    (move_down(EthanPos,NewEthanPos),
    mission_impossible_Var(NewEthanPos,CarriedCount,CurrentGrid,result(down,S),SFinal));
    
    % up
    (move_up(EthanPos,NewEthanPos),
    mission_impossible_Var(NewEthanPos,CarriedCount,CurrentGrid,result(up,S),SFinal));
    
    % left
    (move_left(EthanPos,NewEthanPos),
    mission_impossible_Var(NewEthanPos,CarriedCount,CurrentGrid,result(left,S),SFinal));
    
    % right
    (move_right(EthanPos,NewEthanPos),
    mission_impossible_Var(NewEthanPos,CarriedCount,CurrentGrid,result(right,S),SFinal)).


% -------------------------------- Find Solution ---------------------------


ids(S, Level):-
    ethan_loc(X,Y),
    EthanPos=[X,Y],
    members_loc(CurrentGrid),
    call_with_depth_limit(mission_impossible_Var(EthanPos,0,CurrentGrid,s0,S), Level,R),
    R \= depth_limit_exceeded.

ids(S, Level):-
    NextLevel #= Level+1,
    ids(S, NextLevel).

goal(S):-
    var(S),    
    ids(S, 15).

goal(S):-
    nonvar(S),
    mission_impossible_nonVar(_,0,[],S,_),!.

