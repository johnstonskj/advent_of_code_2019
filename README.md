# Racket package advent_of_code

[![made with Racket](https://img.shields.io/badge/made%20with-Racket-9F1D20)](https://racket-lang.org/)
[![GitHub release](https://img.shields.io/github/release/johnstonskj/advent_of_code_2019.svg?style=flat-square)](https://github.com/johnstonskj/advent_of_code_2019/releases)
[![GitHub stars](https://img.shields.io/github/stars/johnstonskj/advent_of_code_2019.svg)](https://github.com/johnstonskj/advent_of_code_2019/stargazers)
[![mit License](https://img.shields.io/badge/license-mit-118811.svg)](https://johnstonskj.mit-license.org/)

My own solutions to the [2019 Advent of Code](https://adventofcode.com/2019)
problems. All in Racket, none meant to be optimized, code is simply written
just for my fun.

## Layout

I have decided to try and code the solutions as sets of modules in a shared
collection `adventofcode`, so where a solution such as the intcode computer
is refined over different days the same computer module is updated. The 
problems posed are then written as test cases in files `tests/dayX.rkt`.
This allows the regression testing of changes to modules in the future to
ensure they don't break past solutions.

All problem inputs are saved as files in the `data` directory.

For in-progress cases internal tests may be found in the module itself.

[Simon Johnston](mailto:johnstonskj@gmail.com).