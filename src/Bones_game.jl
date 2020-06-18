using DelimitedFiles

include("AI.jl")

function playBones(;ai::Int=1)
    # initialise board and display
    M = initialise()
    boardDisplay(M)

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
            M = aiTurn!(M,player)
        else
            M = takeTurn!(M,player)
        end

        boardDisplay(M) # show the board after the turn

        player = 3-player # swap player

        if checkWinner(M)==-1 # someone has won
            print("Player $(player) wins\n")
            return nothing
        elseif gameOver(M) # board filled but no winner -> draw
            print("It's a draw\n")
            return nothing
        end
    end
end

function initialise(;N=rand(5:10))
    # stack of bones
    return N
end

function boardDisplay(M)
    # Displays the board with symbols
    print("There are $M bones in the stack\n")
end

function takeTurn!(M,player)
    # asks for player input and updates the game state
    return M-getMove(M)
end

function getMove(M)
    # gets a move from a human player
    # TODO: More input validation

    while true # repeat until valid location selected
        print("How many bones do you want to take? ")
        # read a space-separated list of integers
        x = parse(Int,readline())
        if movePossible(M,x) # must be an empty location
            return x
        end
    end
end

function aiTurn!(M,player)
    # work out the best move and then plays it
    moves = [1:3;]
    x = getBestMove(M,player,score,moves)
    return makeMove!(M,x,player)
end

function makeMove!(N,i,player)
    return N-i
end

function score(M,player)
    win = checkWinner(M)
    return -win

    # returns 0 if the game isn't over, 1 if the player wins,
    # -1 if the player loses
end

function checkWinner(M)
    return M==0 ? -1 : 0 # lose if M is 0
end

function movePossible(M,i)
    return M-i>=0
end

function gameOver(M)
    # if all the squares are taken (filled with 1s/2s) the game ends
    return M==0
end
