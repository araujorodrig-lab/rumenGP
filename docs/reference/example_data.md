# Example ANKOM Data

Returns paths to example files included with the package.

## Usage

``` r
example_data()
```

## Value

A named list containing file paths to package example data.

## Details

The example dataset can be used to explore package functionality,
reproduce examples, and learn rumenGP workflows without requiring
external files.

The returned object includes:

- Example ANKOM RF data

- Example metadata

These files are used throughout the package documentation, examples, and
vignettes.

## See also

[`read_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md),
[`read_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md)

## Examples

``` r

files <- example_data()

files
#> $ankom
#> [1] "C:/Users/Arlan/AppData/Local/R/win-library/4.5/rumenGP/extdata/example_ankom.xlsx"
#> 
#> $metadata
#> [1] "C:/Users/Arlan/AppData/Local/R/win-library/4.5/rumenGP/extdata/example_metadata.xlsx"
#> 

raw_data <- read_ankom(
  files$ankom
)

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

fit <- fit_groot(
  gp
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

summary(
  fit
)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 25
#> Successful fits: 24
#> Failed fits: 1
#> Low R-squared (< 0.90): 3
#> 
```
