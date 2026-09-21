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
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5
#> # A tibble: 1,752 × 11
#>    time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>    <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#>  1 10:29:34      0 1           0       0         0      0      1     1 Plant_A  
#>  2 10:29:34      0 2           0       0         0      0      2     2 Plant_A  
#>  3 10:29:34      0 3           0       0         0      0      3     3 Plant_A  
#>  4 10:29:34      0 4           0       0         0      0      4     4 Plant_A  
#>  5 10:29:34      0 5           0       0         0      0      5     5 Plant_A  
#>  6 10:29:34      0 6           0       0         0      0      6     6 Plant_A  
#>  7 10:29:34      0 7           0       0         0      0      7     1 Plant_B  
#>  8 10:29:34      0 8           0       0         0      0      8     2 Plant_B  
#>  9 10:29:34      0 9           0       0         0      0      9     3 Plant_B  
#> 10 10:29:34      0 10          0       0         0      0     10     4 Plant_B  
#> # ℹ 1,742 more rows
#> # ℹ 1 more variable: pH <dbl>

# Validation also supports datasets
# created using as_rumen_gp()
```
