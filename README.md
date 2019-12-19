# Racket package advent_of_code

My own solutions to the [2019 Advent of Code](https://adventofcode.com/2019)
problems. All in Racket, none meant to bve optimized, just for fun.

## Layout

I have decided to try and code the solutions as sets of modules in a shared
collection `adventofcode`, so where a solution such as the intcode computer
is refined over different days the same computer module is updated. The 
problems posed are then written as test cases in files `tests/dayX.rkt`.
This allows the regression testing of changes to modules in the future to
ensure they don't break past solutions.

All problem inputs are saved as files in the `data` directory.

For in-progress cases internal tests may be found in the module itself.
