# Fortran-String-to-Real

When we [discovered](https://fortran-lang.discourse.group/t/a-new-json-library/2197/20) that Fortran is very slow at converting strings to reals using its `read` statement, I had an idea: Fortran isn't that fast with strings but with numbers and especially with number arrays. So I tried to convert a `string` problem into an `int` problem.

## How it works

1. Convert the string (which actually is an `character` array) into an `integer` array using `equivalence` (`transfer` was much slower`).
2. Determine the positions of the period and exponent chars
3. Multiply the coefficient part of the `integer` array with "base-ten"
4. Calculate the sum of the integer array
5. Do the same for the exponent and combine factor with exponent

### Example `"12.34E10"`
1. `character` -> `integer` (1 byte) -> `-48` (`ichar('0')`)

   `['1','2','.','3','4','E','1','0']`

   `[ 1 , 2 ,-2 , 3 , 4 ,21 , 1 , 0 ]`
2. `findloc` for the period (faster than `scan` for one char)

   `scan` for `E` or `e` (faster than 2 times `findloc`)
3. `[1, 2, -2, 3, 4] *`

   `[10., 1., 0., 0.1, 0.01]`
4. `coefficient = sum(10., 2., 0., 0.3, 0.04)`
5. `exponent = sum([1, 0] * [10., 1.])`
   `result = coefficient * 10 ** exponent`
   
## Input

This routine is still experimental! It cannot handle `NaN` or `Inf` values and there is no error checking. The input `string` has to end with the last digit of the number. If the number is negative, the first character has to be the `-` sign. Positive numbers don't have to start with digits: Technically all characters except of `.`, `e`, `E` or digits can be in front of the number, because they will be hidden by a mask.

## Performance

This library comes with a test for correctness and a benchmark for execution time. The benchmark only contains one format, the speedup will be different for shorter/other formats.
All tests are a comparison between formatted `read` and `str2real`

### test correctness:

`fpm test test`

### benchmark execution time:

`fpm test bench --profile release --flag "-flto"`

## Footnote

There is an ongoing discussion on this topic in the [Fortran-Discourse](https://fortran-lang.discourse.group/t/faster-string-to-double/2208)
Parts of the code in this repository are written/edited by [Jacob Williams](https://github.com/jacobwilliams) and [Beliavsky](https://github.com/Beliavsky)
