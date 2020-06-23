# using SafeTestsets
using MinimaxAI
using Test
# MinimaxAI.playBones(ai = 2,N=20)


@testset "Seeing if it works" begin
    @test playBones(N = 1, ai =2) == nothing
    @test playBones(N = 25, ai = 2) == nothing
    @test playTicTacToe(ai = 2) == nothing
    @test playConnect4(ai = 2) == nothing
    @test playBones(N = 25, ai = 2, method = "minimaxAB", abDepth = 3) == nothing
    @test playTicTacToe(ai = 2 , method = "minimaxAB", abDepth = 5) == nothing
end

# @safetestset "Generic tests" begin include("minimax_tests.jl") end
