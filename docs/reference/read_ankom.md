# Import ANKOM RF Output

Reads a raw ANKOM RF export file and returns the contents as a data
frame.

## Usage

``` r
read_ankom(file)
```

## Arguments

- file:

  Path to an ANKOM Excel file.

## Value

A data frame containing raw ANKOM RF data.

## Details

This function is typically the first step in the ANKOM workflow:

- Import ANKOM data

- Import metadata

- Process data

- Fit kinetic models

The imported data can subsequently be processed using
[`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md).

## See also

[`read_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`example_data`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)

## Examples

``` r

files <- example_data()

raw_data <- read_ankom(
  files$ankom
)

head(
  raw_data
)
#> # A tibble: 6 × 52
#>   time_raw   `0`   `1`    `2`   `3`   `4` `5`     `6`   `7`   `8`   `9`  `10`
#>   <chr>    <dbl> <dbl>  <dbl> <dbl> <dbl> <lgl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 10:54:01  14.1 0     0      0     0     NA    0     0         0 0     0    
#> 2 11:04:01  14.1 0.109 0      0.291 0.364 NA    0.255 0.218     0 0.291 0.291
#> 3 11:14:01  14.1 0.146 0.0364 0.546 0.655 NA    0.509 0.437     0 0.509 0.546
#> 4 11:24:01  14.1 0.109 0.0364 0.764 0.983 NA    0.728 0.655     0 0.728 0.837
#> 5 11:34:01  14.1 0.109 0.0364 0.946 1.24  NA    0.983 0.801     0 0.910 1.02 
#> 6 11:44:01  14.1 0.109 0.0364 1.09  1.46  NA    1.16  0.983     0 1.06  1.20 
#> # ℹ 40 more variables: `11` <dbl>, `12` <dbl>, `13` <dbl>, `14` <dbl>,
#> #   `15` <dbl>, `16` <dbl>, `17` <dbl>, `18` <dbl>, `19` <dbl>, `20` <dbl>,
#> #   `21` <dbl>, `22` <dbl>, `23` <dbl>, `24` <dbl>, `25` <lgl>, `26` <dbl>,
#> #   `27` <dbl>, `28` <dbl>, `29` <dbl>, `30` <lgl>, `31` <lgl>, `32` <lgl>,
#> #   `33` <lgl>, `34` <lgl>, `35` <lgl>, `36` <lgl>, `37` <lgl>, `38` <lgl>,
#> #   `39` <lgl>, `40` <lgl>, `41` <lgl>, `42` <lgl>, `43` <lgl>, `44` <lgl>,
#> #   `45` <lgl>, `46` <lgl>, `47` <lgl>, `48` <lgl>, `49` <lgl>, `50` <lgl>

# Typical workflow
metadata <- read_metadata(
  files$metadata
)

gp <- process_ankom(
  raw_data,
  metadata,
  headspace_ml = 210,
  temperature_c = 39
)

head(
  gp
)
#> # A tibble: 6 × 10
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:54:01      0 1           0       0         0      0      1     1 TMR      
#> 2 10:54:01      0 2           0       0         0      0      2     1 Blank    
#> 3 10:54:01      0 3           0       0         0      0      3     2 TMR      
#> 4 10:54:01      0 4           0       0         0      0      4     3 TMR      
#> 5 10:54:01      0 6           0       0         0      0      6     4 TMR      
#> 6 10:54:01      0 7           0       0         0      0      7     5 TMR      
```
