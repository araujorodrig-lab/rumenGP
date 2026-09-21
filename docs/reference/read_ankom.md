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
#>   time_raw   `0`   `1`     `2`    `3`    `4`   `5`   `6`    `7`   `8`    `9`
#>   <chr>    <dbl> <dbl>   <dbl>  <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl>  <dbl>
#> 1 10:29:34  14.2 0      0      0      0      0     0      0     0     0     
#> 2 10:39:34  14.2 0.873 -0.0728 0.0364 0.0364 0.910 0.218 -0.146 0.873 0.0364
#> 3 10:49:34  14.2 1.42  -0.109  0      0.0364 1.53  0.218  0.764 1.53  0.0364
#> 4 10:59:34  14.2 1.82  -0.109  0      0.0364 2.04  0.218  0.764 2.07  0     
#> 5 11:09:34  14.2 2.11  -0.146  0      0.0364 2.47  0.218  0.764 2.58  0     
#> 6 11:19:34  14.2 2.40  -0.146  0      0.0364 2.84  0.218  0.764 2.98  0     
#> # ℹ 41 more variables: `10` <dbl>, `11` <dbl>, `12` <dbl>, `13` <dbl>,
#> #   `14` <dbl>, `15` <dbl>, `16` <dbl>, `17` <dbl>, `18` <dbl>, `19` <dbl>,
#> #   `20` <lgl>, `21` <dbl>, `22` <dbl>, `23` <dbl>, `24` <dbl>, `25` <lgl>,
#> #   `26` <dbl>, `27` <lgl>, `28` <lgl>, `29` <lgl>, `30` <lgl>, `31` <lgl>,
#> #   `32` <lgl>, `33` <lgl>, `34` <lgl>, `35` <lgl>, `36` <lgl>, `37` <lgl>,
#> #   `38` <lgl>, `39` <lgl>, `40` <lgl>, `41` <lgl>, `42` <lgl>, `43` <lgl>,
#> #   `44` <lgl>, `45` <lgl>, `46` <lgl>, `47` <lgl>, `48` <lgl>, `49` <lgl>, …

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
#> # A tibble: 6 × 11
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:29:34      0 1           0       0         0      0      1     1 Plant_A  
#> 2 10:29:34      0 2           0       0         0      0      2     2 Plant_A  
#> 3 10:29:34      0 3           0       0         0      0      3     3 Plant_A  
#> 4 10:29:34      0 4           0       0         0      0      4     4 Plant_A  
#> 5 10:29:34      0 5           0       0         0      0      5     5 Plant_A  
#> 6 10:29:34      0 6           0       0         0      0      6     6 Plant_A  
#> # ℹ 1 more variable: pH <dbl>
```
