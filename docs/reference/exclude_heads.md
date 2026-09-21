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
#> # A tibble: 1,606 × 11
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
#> # ℹ 1,596 more rows
#> # ℹ 1 more variable: pH <dbl>
```
