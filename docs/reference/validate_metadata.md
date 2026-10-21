# Validate Metadata

Validates experimental metadata prior to analysis.

## Usage

``` r
validate_metadata(metadata)
```

## Arguments

- metadata:

  Metadata table.

## Value

The validated metadata table.

## Details

Metadata are required for linking bottles to treatments and biological
replicates during data processing and model fitting.

Required columns:

- `Head`

- `Treatment`

- `Rep`

Validation checks may include:

- Presence of required columns

- Missing values

- Duplicate bottle identifiers

- Invalid treatment assignments

This function is typically used before
[`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)
to ensure metadata are suitable for downstream analyses.

## See also

[`read_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md),
[`validate_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_ankom.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`example_data`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)

## Examples

``` r

files <- example_data()

metadata <- read_metadata(
  files$metadata
)

validate_metadata(
  metadata
)
#> Metadata validation passed.
#> Heads: 25
#> Treatment: 5
#> # A tibble: 25 × 4
#>    Bottle Head    Rep Treatment
#>     <dbl> <chr> <dbl> <chr>    
#>  1      1 1         1 TMR      
#>  2      2 2         1 Blank    
#>  3      3 3         2 TMR      
#>  4      4 4         3 TMR      
#>  5      6 6         4 TMR      
#>  6      7 7         5 TMR      
#>  7      9 9         1 Low      
#>  8     10 10        2 Low      
#>  9     11 11        3 Low      
#> 10     12 12        4 Low      
#> # ℹ 15 more rows

# Typical workflow
raw_data <- read_ankom(
  files$ankom
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
