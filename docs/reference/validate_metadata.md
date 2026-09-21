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
#> Heads: 24
#> Treatment: 5
#> # A tibble: 24 × 5
#>    Bottle Head    Rep Treatment    pH
#>     <dbl> <chr> <dbl> <chr>     <dbl>
#>  1      1 1         1 Plant_A    6.24
#>  2      2 2         2 Plant_A    6.22
#>  3      3 3         3 Plant_A    6.24
#>  4      4 4         4 Plant_A    6.3 
#>  5      5 5         5 Plant_A    6.15
#>  6      6 6         6 Plant_A    6.16
#>  7      7 7         1 Plant_B    6.13
#>  8      8 8         2 Plant_B    6.12
#>  9      9 9         3 Plant_B    6.12
#> 10     10 10        4 Plant_B    6.26
#> # ℹ 14 more rows

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
