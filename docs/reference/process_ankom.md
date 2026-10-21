# Process ANKOM RF Data

Converts raw ANKOM RF output into a standardized dataset suitable for
rumenGP analyses.

## Usage

``` r
process_ankom(
  raw_data,
  metadata = NULL,
  headspace_ml = 210,
  temperature_c = 39,
  zero_negative_pressure = FALSE,
  blank_correction = c("none", "subtract_mean"),
  truncate_negative_gas = TRUE
)
```

## Arguments

- raw_data:

  Raw ANKOM data table.

- metadata:

  Metadata table.

- headspace_ml:

  Bottle headspace volume (mL).

- temperature_c:

  Incubation temperature (°C).

- zero_negative_pressure:

  Logical. If `TRUE`, negative pressure values are converted to zero
  before gas-volume calculations.

- blank_correction:

  Character. Blank-correction method. One of:

  - `"none"` (default)

  - `"subtract_mean"`

- truncate_negative_gas:

  Logical. If `TRUE`, gas production values below zero after blank
  correction are set to zero.

## Value

A `rumen_gp` object containing:

- Time points

- Gas production values

- Bottle identifiers

- Treatment assignments

- Additional metadata

- Processing settings

## Details

The function:

- Merges ANKOM measurements with metadata

- Removes Head 0 (the ANKOM receiver/base station)

- Converts pressure measurements to gas volumes

- Applies headspace and temperature corrections

- Optionally corrects gas production using blank bottles

- Produces a standardized `rumen_gp` object

Head 0 is reserved by the ANKOM RF system as the receiver/base station
and is automatically removed during processing.

Blank correction is optional and is not applied unless explicitly
requested. When blank correction is enabled, the mean gas production of
bottles labeled `Treatment = "Blank"` is subtracted from all nonblank
bottles at each observation time.

## See also

[`read_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md),
[`read_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/read_metadata.md),
[`as_rumen_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md),
[`plot_gp`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_gp.md)

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

head(gp)
#> # A tibble: 6 × 10
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:54:01      0 1           0       0         0      0      1     1 TMR      
#> 2 10:54:01      0 2           0       0         0      0      2     1 Blank    
#> 3 10:54:01      0 3           0       0         0      0      3     2 TMR      
#> 4 10:54:01      0 4           0       0         0      0      4     3 TMR      
#> 5 10:54:01      0 6           0       0         0      0      6     4 TMR      
#> 6 10:54:01      0 7           0       0         0      0      7     5 TMR      

# Alternative behavior:
# convert negative pressures to zero
gp_zeroed <- process_ankom(
  raw_data,
  metadata,
  headspace_ml = 210,
  temperature_c = 39,
  zero_negative_pressure = TRUE
)

head(gp_zeroed)
#> # A tibble: 6 × 10
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:54:01      0 1           0       0         0      0      1     1 TMR      
#> 2 10:54:01      0 2           0       0         0      0      2     1 Blank    
#> 3 10:54:01      0 3           0       0         0      0      3     2 TMR      
#> 4 10:54:01      0 4           0       0         0      0      4     3 TMR      
#> 5 10:54:01      0 6           0       0         0      0      6     4 TMR      
#> 6 10:54:01      0 7           0       0         0      0      7     5 TMR      

# Blank-corrected gas production
gp_blank_corrected <- process_ankom(
  raw_data,
  metadata,
  headspace_ml = 210,
  temperature_c = 39,
  blank_correction = "subtract_mean"
)

head(gp_blank_corrected)
#> # A tibble: 6 × 11
#>   time_raw Time_h Head  Gas_PSI Gas_kPa Gas_moles Gas_mL Bottle   Rep Treatment
#>   <chr>     <dbl> <chr>   <dbl>   <dbl>     <dbl>  <dbl>  <dbl> <dbl> <chr>    
#> 1 10:54:01      0 1           0       0         0      0      1     1 TMR      
#> 2 10:54:01      0 2           0       0         0      0      2     1 Blank    
#> 3 10:54:01      0 3           0       0         0      0      3     2 TMR      
#> 4 10:54:01      0 4           0       0         0      0      4     3 TMR      
#> 5 10:54:01      0 6           0       0         0      0      6     4 TMR      
#> 6 10:54:01      0 7           0       0         0      0      7     5 TMR      
#> # ℹ 1 more variable: Blank_Gas_mL <dbl>
```
