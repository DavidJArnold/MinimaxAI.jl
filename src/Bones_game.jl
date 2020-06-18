function playBones(;ai::Int=1,N=rand(5:10))
    # initialise board and display
    M = bones_initialise(N)
    bones_boardDisplay(M)

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
        print("Player $player turn\n")

        # take a turn, either by human or AI
        if isAI[player]
            M = bones_aiTurn!(M,player)
        else
            M = bones_takeTurn!(M,player)
        end

        bones_boardDisplay(M) # show the board after the turn

        player = 3-player # swap player

        if bones_checkWinner(M)==1 # someone has won
            print("Player $(player) wins\n")
            return nothing
        elseif bones_gameOver(M) # board filled but no winner -> draw
            print("It's a draw\n")
            return nothing
        end
    end
end

function bones_initialise(N)
    # stack of bones
    return N
end

function bones_boardDisplay(M)
    # Displays the board with symbols
    print("There are $M bones in the stack\n")
end

function bones_takeTurn!(M,player)
    # asks for player input and updates the game state
    return M-bones_getMove(M)
end

function bones_getMove(M)
    # gets a move from a human player
    # TODO: More input validation

    while true # repeat until valid location selected
        print("How many bones do you want to take? ")
        # read a space-separated list of integers
        x = parse(Int,readline())
        if bones_movePossible(M,x) # must be an empty location
            return x
        end
    end
end

function bones_aiTurn!(M,player)
    # work out the best move and then plays it
    moves = [1:3;]
    x = getBestMove(M,player,bones_score,moves,bones_movePossible,bones_makeMove!,bones_gameOver)
    return bones_makeMove!(M,x,player)
end

function bones_makeMove!(N,i,player)
    return N-i
end

function bones_score(M,player)
    return bones_checkWinner(M)

    # returns 0 if the game isn't over, 1 if the player wins,
    # -1 if the player loses
end

function bones_checkWinner(M)
    return M==0 ? 1 : 0 # lose if M is 0
end

function bones_movePossible(M,i)
    return M-i>=0
end

function bones_gameOver(M)
    # if all the squares are taken (filled with 1s/2s) the game ends
    return M==0
end
