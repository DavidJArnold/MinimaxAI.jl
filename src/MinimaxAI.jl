module MinimaxAI

using DelimitedFiles

include("AI.jl")
include("TicTacToe_game.jl")
include("Bones_game.jl")
include("Connect4_game.jl")

export playTicTacToe, playBones, playConnect4

end
