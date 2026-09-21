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
#> [1] "C:/Users/Arlan/AppData/Local/Temp/RtmpAtUG72/temp_libpath59dc554d1ec4/rumenGP/extdata/example_ankom.xlsx"
#> 
#> $metadata
#> [1] "C:/Users/Arlan/AppData/Local/Temp/RtmpAtUG72/temp_libpath59dc554d1ec4/rumenGP/extdata/example_metadata.xlsx"
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

fit <- fit_groot(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(
  fit
)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Low R-squared (< 0.90): 2
#> 
```
