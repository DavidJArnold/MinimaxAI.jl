# MinimaxAI

[![Build Status](https://travis-ci.com/DavidJArnold/MinimaxAI.jl.svg?branch=master)](https://travis-ci.com/DavidJArnold/MinimaxAI.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/DavidJArnold/MinimaxAI.jl?svg=true)](https://ci.appveyor.com/project/DavidJArnold/MinimaxAI-jl)
[![Coverage](https://codecov.io/gh/DavidJArnold/MinimaxAI.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidJArnold/MinimaxAI.jl)
[![Coverage](https://coveralls.io/repos/github/DavidJArnold/MinimaxAI.jl/badge.svg?branch=master)](https://coveralls.io/github/DavidJArnold/MinimaxAI.jl?branch=master)

Implements a few simple games in Julia and has a generic AI opponent for them.

Games
 * Tic Tac Toe
 * Game of bones (trying to avoid picking up the last bone in piles)

## Structure

Each game is implemented in its own module, with it's own tests.

The AI is implemented in its own module, which takes in a list of candidate moves and a scoring function.

Hopefully.
