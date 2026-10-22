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

gp_clean
#> # A tibble: 3,038 × 10
#>    time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>    <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#>  1 10:54:01      0 3           0       0         0      0      3     2 TMR      
#>  2 10:54:01      0 6           0       0         0      0      6     4 TMR      
#>  3 10:54:01      0 7           0       0         0      0      7     5 TMR      
#>  4 10:54:01      0 9           0       0         0      0      9     1 Low      
#>  5 10:54:01      0 10          0       0         0      0     10     2 Low      
#>  6 10:54:01      0 11          0       0         0      0     11     3 Low      
#>  7 10:54:01      0 12          0       0         0      0     12     4 Low      
#>  8 10:54:01      0 13          0       0         0      0     13     1 Medium   
#>  9 10:54:01      0 14          0       0         0      0     14     2 Medium   
#> 10 10:54:01      0 15          0       0         0      0     15     3 Medium   
#> # ℹ 3,028 more rows
```
