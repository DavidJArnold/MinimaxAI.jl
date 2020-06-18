module MinimaxAI

using DelimitedFiles

export play

gameIdx = Dict(
    "TicTacToe" => ["TicTacToe_game.jl", "playTicTacToe"],
    "Bones" => ["Bones_game.jl", "playBones"]
    )

function play(;game = "Bones",ai = 2)

    include("$(gameIdx[game][1])")
    play_Bones()
    

end

end
