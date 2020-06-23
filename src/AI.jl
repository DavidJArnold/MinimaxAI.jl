function getBestMove(M,player,score,moves,movePossible,makeMove!,gameOver)
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
            moveVal, depth = minimax(N,0,false,3-player,moves,score,movePossible,makeMove!,gameOver) # evaluate it

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

function minimax(M,depth,isMax,player,moves,score,movePossible,makeMove!,gameOver)
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
                value, depthOut = minimax(N,depth+1,!isMax,3-player,moves,score,movePossible,makeMove!,gameOver)

                # did this move do better?
                best = isMax ? max(best, value) : min(best, value)
            end
        end
        return best, depthOut
    end
end

function getBestMoveAB(M,player,score,moves,movePossible,makeMove!,gameOver,maxDepth)
    # uses minimax algorithm to find best move

    # initialise algorithm values
    alpha = -1000
    beta = 1000
    bestVal = -1000
    bestMove = [-1]
    bestDepth = [1000]
    moveVal = 0

    for i in moves # search over all candidate moves
        if movePossible(M,i)
            N = deepcopy(M)
            N = makeMove!(N,i,player) # play the move
            moveVal, depth = minimaxAB(alpha,beta,N,0,false,3-player,
                moves,score,movePossible,makeMove!,gameOver,maxDepth) # evaluate it

            print("$i: $moveVal $depth ($bestVal)\n")
            # if the move is better than the current best, keep it
            # if it's equal, sometimes keep it

            if moveVal > bestVal
                bestVal = moveVal
                bestMove = [i]
                bestDepth = [depth]
            elseif moveVal==bestVal
                push!(bestMove,i)
                push!(bestDepth,depth)
            end
        end
    end
    if bestVal<0
        goodIdxs = bestDepth.==maximum(bestDepth)
    else
        goodIdxs = bestDepth.==minimum(bestDepth)
    end
    bestMoveOptions = bestMove[goodIdxs]
    bestMove = length(bestMoveOptions)>1 ? rand(bestMoveOptions) : bestMoveOptions[1]
    print("From $bestMoveOptions, choosing $bestMove\n")
    return bestMove # we are left with one of the optimal moves
end

function minimaxAB(alpha,beta,M,depth,isMax,player,moves,score,
        movePossible,makeMove!,gameOver,maxDepth)
    # minimax step
    depthOut = depth
    if depth>maxDepth
        return score(M,player), depth
    elseif gameOver(M)
        return isMax ? score(M,player) : -score(M,player), depth
    else
        bestValue = isMax ? -1000 : 1000
        for i in moves # serach over candidate moves
            if movePossible(M,i)
                N = deepcopy(M)
                N = makeMove!(N,i,player) # play the move
                valueTemp, depthOut = minimaxAB(alpha,beta,N,depth+1,!isMax,
                    3-player,moves,score,movePossible,makeMove!,gameOver,maxDepth)

                if isMax
                    bestValue = max(bestValue,valueTemp)
                    alpha = max(alpha,bestValue)
                else
                    bestValue = min(bestValue,valueTemp)
                    beta = min(beta,bestValue)
                end
                if alpha>=beta
                    return bestValue, depthOut
                end
            end
        end

        return bestValue, depthOut
    end
end
