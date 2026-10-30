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

gp_clean <- exclude_heads(
  gp,
  heads = c(
    "1",
    "2",
    "4",
    "20"
  ),
  reason = c(
    "Abnormal gas profile",
    "Abnormal gas profile",
    "Abnormal gas profile",
    "Abnormal gas profile"
  )
)

head(
  gp_clean
)
#> # A tibble: 6 × 10
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:54:01      0 3           0       0         0      0      3     2 TMR      
#> 2 10:54:01      0 6           0       0         0      0      6     4 TMR      
#> 3 10:54:01      0 7           0       0         0      0      7     5 TMR      
#> 4 10:54:01      0 9           0       0         0      0      9     1 Low      
#> 5 10:54:01      0 10          0       0         0      0     10     2 Low      
#> 6 10:54:01      0 11          0       0         0      0     11     3 Low      

fit <- fit_groot(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(
  fit
)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 
```
