ethan_loc(0,0).
members_loc([[1,1],[1,2]]).
submarine(0,2).
capacity(1).

result(drop,(down,(carry,(s0))))

call_with_depth_limit(goal(result(drop, result(up, result(carry, result(down,
result(drop, result(up, result(right, result(carry,
result(down, result(right, s0))))))))))),10,R).


call_with_depth_limit(goal(S),31,R).                                                  
