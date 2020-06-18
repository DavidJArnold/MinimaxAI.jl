function getBestMove(M,player,score,moves)
    # uses minimax algorithm to find best move

    # initialise algorithm values
    bestVal = -1000
    bestMove = -1
    bestDepth = 1000
    moveVal = 0

    for i in moves # search over all candidate moves
        if movePossible(M,i)
            N = deepcopy(M)
            N = makeMove!(N,i,player) # play the move
            moveVal, depth = minimax(N,0,false,3-player,moves,score) # evaluate it

            print("$i: $moveVal $depth\n")
            # if the move is better than the current best, keep it
            # if it's equal, sometimes keep it
            if (moveVal > bestVal) || (moveVal==bestVal && depth<=bestDepth && rand()<0.75)
                # or if it's equivalent, sometimes keep it
                bestVal = moveVal
                bestMove = i
                bestDepth = depth
            end
        end
    end
    print("Choosing $bestMove\n")
    return bestMove # we are left with one of the optimal moves
end

function minimax(M,depth,isMax,player,moves,score)
    # minimax step
    depthOut = depth
    if gameOver(M)
        return isMax ? score(M,player) : -score(M,player), depthOut
    else
        best = isMax ? -1000 : 1000
        for i in moves # serach over candidate moves
            if movePossible(M,i)
                N = deepcopy(M)
                N = makeMove!(N,i,player) # play the move

                # pass on to the minimiser
                value, depthOut = minimax(N,depth+1,!isMax,3-player,moves,score)

                # did this move do better?
                best = isMax ? max(best, value) : min(best, value)
            end
        end
        return best, depthOut
    end
end
