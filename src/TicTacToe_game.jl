
# 0 -> empty space, 1 -> O, 2 -> X
str = [' ', 'O', 'X']

function playTicTacToe(;ai::Int=1,method::String="minimax",abDepth::Int=4)
    # initialise board and display
    M = ttt_initialise()
    ttt_boardDisplay(M)

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
            M = ttt_aiTurn!(M,player,method,abDepth)
        else
            M = ttt_takeTurn!(M,player)
        end

        ttt_boardDisplay(M) # show the board after the turn

        player = 3-player # swap player
        W = ttt_checkWinner(M) # check if someone has won

        if W!=0 # someone has won
            print("$(str[W+1])'s win\n")
            return nothing
        elseif ttt_gameOver(M) # board filled but no winner -> draw
            print("It's a draw\n")
            return nothing
        end
    end
end

function ttt_initialise()
    # empty board
    return zeros(Int8,3,3)
end

function ttt_boardDisplay(M)
    # Displays the board with symbols
    r1 = "         |   |   \n"
    r2(a) = "Row $a  $(str[M[a,1]+1]) | $(str[M[a,2]+1]) | $(str[M[a,3]+1]) \n"
    r3 = "      ___|___|___\n"
    print("Column 1   2   3\n",r1,r2(1),r3,
        r1,r2(2),r3,r1,r2(3),r1)
        print("Board eval: $(ttt_scoreHelper(M,1))\n")
end

function ttt_takeTurn!(M,player)
    # asks for player input and updates the game state
    coords = ttt_getMove(M)
    M[coords[1],coords[2]] = player
    return M
end

function ttt_getMove(M)
    # gets a move from a human player
    # TODO: More input validation

    while true # repeat until valid location selected
        print("Enter the row/column coordinates for your move separated by a space: ")
        # read a space-separated list of integers
        x = readdlm(IOBuffer(readline()),' ',Int64)
        if M[x[1],x[2]]==0 # must be an empty location
            return x
        end
    end
end

function ttt_aiTurn!(M,player,method,abDepth)
    # work out the best move and then plays it
    moves = 1:9
    if isequal(method,"minimaxAB")
        idx = getBestMoveAB(M,player,ttt_score,moves,ttt_movePossible,ttt_makeMove!,ttt_gameOver,abDepth)
    else
        idx = getBestMove(M,player,ttt_score,moves,ttt_movePossible,ttt_makeMove!,ttt_gameOver)
    end
    M[idx] = player
    return M
end

function ttt_score(M,player)
    win = ttt_checkWinner(M)
    if win!=0
        return win==player ? 100 : -100
    elseif ttt_gameOver(M)
        return 0
    else
        return ttt_scoreHelper(M,player)
    end

    # returns 0 if the game isn't over, 1 if the player wins,
    # -1 if the player loses
end

function ttt_scoreHelper(M,player)
    # See who has won the game

    # p1  and p2 are boolean arrays indicating where each player has played
    p = M.==player
    o = M.==3-player

    s = sum(filter(x -> x>=2 || x<=-2,
        [sum(p-o,dims=1) sum(p-o,dims=2)' sum(p[1:4:9]-o[1:4:9]) sum(p[3:2:7]-o[3:2:7])]))

    return s
end

function ttt_checkWinner(M)
    # See who has won the game

    # p1  and p2 are boolean arrays indicating where each player has played
    p1 = M.==1
    p2 = M.==2

    #   column of 3       or   row of 3         or main diagonal  or other diagonal
    if any(all(p1,dims=1)) | any(all(p1,dims=2)) | all(p1[1:4:9]) | all(p1[3:2:7])
        W = 1
    elseif any(all(p2,dims=1)) | any(all(p2,dims=2)) | all(p2[1:4:9]) | all(p2[3:2:7])
        W = 2
    else
        W = 0 # no winner or draw
    end

    return W
end

function ttt_makeMove!(N,i,player)
    N[i] = player
    return N
end

function ttt_movePossible(M,i)
    return M[i]==0
end

function ttt_gameOver(M)
    # if all the squares are taken (filled with 1s/2s) the game ends
    return all(M.>0) || ttt_checkWinner(M)!=0
end
