
# 0 -> empty space, 1 -> O, 2 -> X
str = [' ', 'O', 'X']

function playConnect4(;ai::Int=1)
    # initialise board and display
    M = c4_initialise()
    c4_boardDisplay(M)

    # which player(s) are AI?
    if ai == 0
        isAI = [false false]
    elseif ai == 1
        isAI = rand()<0.5 ? [false true] : [true false]
    elseif ai == 2
        isAI = [true true]
    end

    # randomly pick starting player (sets symbols)
    player = rand((1,2))

    while true # take turns until the game ends
        # take a turn, either by human or AI
        if isAI[player]
            M = c4_aiTurn!(M,player)
        else
            M = c4_takeTurn!(M,player)
        end

        c4_boardDisplay(M) # show the board after the turn

        player = 3-player # swap player
        W = c4_checkWinner(M) # check if someone has won

        if W!=0 # someone has won
            print("$(str[W+1])'s win\n")
            return nothing
        elseif c4_gameOver(M) # board filled but no winner -> draw
            print("It's a draw\n")
            return nothing
        end
    end
end

function c4_initialise()
    # empty board
    return zeros(Int8,6,7)
end

function c4_boardDisplay(M)
    # Displays the board with symbols
    print(" 1 2 3 4 5 6 7\n")
    for row in 1:6
        print("|")
        for column in 1:7
            print("$(str[M[row,column]+1])|")
        end
        print("\n")
    end
    # print("_______________\n")
    print("---------------\n")
end

function c4_takeTurn!(M,player)
    # asks for player input and updates the game state
    col = c4_getMove(M)
    ids = count(!iszero,M[:,col])
    M[6-ids,col] = player
    return M
end

function c4_getMove(M)
    # gets a move from a human player
    # TODO: More input validation

    while true # repeat until valid location selected
        print("Enter the column for your move: ")
        x = parse(Int,readline())

        if c4_movePossible(M,x) # must be an empty location
            return x
        end
    end
end

function c4_aiTurn!(M,player)
    # work out the best move and then plays it
    moves = 1:7
    idx = getBestMove(M,player,c4_score,moves,c4_movePossible,c4_makeMove!,c4_gameOver)
    M[idx] = player
    return M
end

function c4_score(M,player)
    win = c4_checkWinner(M)
    return win==0 ? 0 : (win==player ? 1 : -1)

    # returns 0 if the game isn't over, 1 if the player wins,
    # -1 if the player loses
end

function c4_checkWinner(M)
    # See who has won the game

    for player in (1,2)
        # horizontal lines
        rows = 1:6
        cols = 1:4
        for row in rows, col in cols
            if all(M[row,col:col+3]==player)
                return player
            end
        end

        # vertical lines
        rows = 1:3
        cols = 1:7
        for row in rows, col in cols
            if all(M[row:row+3,col]==player)
                return player
            end
        end

        # diagonals /
        rows = 1:3
        cols = 1:4
        for row in rows, col in cols
            temp = M[row:row+3,col:col+3]
            if all(temp[4:3:13]==player)
                return player
            end
            if all(temp[1:5:16]==player)
                return player
            end
        end
    end
    return 0
end

function c4_makeMove!(N,i,player)
    # does not check whether move is legal
    N[6-count(!iszero,N[:,i]),i] = player
    return N
end

function c4_movePossible(M,i)
    return count(!iszero,M[:,i])>=6 ? false : true
end

function c4_gameOver(M)
    # if all the squares are taken (filled with 1s/2s) the game ends
    return all(M.>0) || c4_checkWinner(M)!=0
end
