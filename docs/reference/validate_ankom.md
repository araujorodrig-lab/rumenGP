# Validate Processed Rumen Gas Production Data

Performs quality-control checks on a `rumen_gp` object.

## Usage

``` r
validate_ankom(data)
```

## Arguments

- data:

  A `rumen_gp` object.

## Value

The validated `rumen_gp` object.

## Details

Supported data sources include datasets created by:

- [`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)

- [`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)

Validation checks may include:

- Required columns

- Missing values

- Duplicate observations

- Time ordering

- Gas production values

- ANKOM-specific pressure checks

ANKOM-specific checks are performed only when `Gas_PSI` is available.

This function is useful for confirming that a dataset is suitable for
downstream modeling, visualization, and model comparison workflows.

## See also

[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`as_rumen_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md),
[`validate_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_metadata.md)

## Examples

``` r

files <- example_data()

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

validate_ankom(
  gp
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5
#> # A tibble: 3,618 × 10
#>    time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>    <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#>  1 10:54:01      0 1           0       0         0      0      1     1 TMR      
#>  2 10:54:01      0 2           0       0         0      0      2     1 Blank    
#>  3 10:54:01      0 3           0       0         0      0      3     2 TMR      
#>  4 10:54:01      0 4           0       0         0      0      4     3 TMR      
#>  5 10:54:01      0 6           0       0         0      0      6     4 TMR      
#>  6 10:54:01      0 7           0       0         0      0      7     5 TMR      
#>  7 10:54:01      0 9           0       0         0      0      9     1 Low      
#>  8 10:54:01      0 10          0       0         0      0     10     2 Low      
#>  9 10:54:01      0 11          0       0         0      0     11     3 Low      
#> 10 10:54:01      0 12          0       0         0      0     12     4 Low      
#> # ℹ 3,608 more rows

# Validation also supports datasets
# created using as_rumen_gp()
```
