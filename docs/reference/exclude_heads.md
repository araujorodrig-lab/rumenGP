# Exclude Problematic ANKOM Heads

Removes one or more bottles from a `rumen_gp` object while recording
exclusion information.

## Usage

``` r
exclude_heads(data, heads, reason = NULL)
```

## Arguments

- data:

  A `rumen_gp` object.

- heads:

  Character vector of bottle identifiers to remove.

- reason:

  Character vector containing the reason for each exclusion.

## Value

A filtered `rumen_gp` object.

## Details

This function is useful for excluding:

- Leaking bottles

- Sensor failures

- Damaged bottles

- Biologically implausible observations

- Other quality-control issues

Exclusion information is retained to support transparent reporting and
reproducible analyses.

## See also

[`validate_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_ankom.md),
[`flag_model`](https://araujorodrig-lab.github.io/rumenGP/reference/flag_model.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)

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

gp_filtered <- exclude_heads(
  data = gp,
  heads = c(
    "12",
    "18"
  ),
  reason = c(
    "Bottle leak",
    "Sensor malfunction"
  )
)

gp_filtered
#> # A tibble: 3,473 × 10
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
#> 10 10:54:01      0 13          0       0         0      0     13     1 Medium   
#> # ℹ 3,463 more rows
```
