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
  zero_negative_pressure = FALSE
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

## Value

A `rumen_gp` object containing:

- Time points

- Gas production values

- Bottle identifiers

- Treatment assignments

- Additional metadata

## Details

The function:

- Merges ANKOM measurements with metadata

- Removes Head 0 (the ANKOM receiver/base station)

- Converts pressure measurements to gas volumes

- Applies headspace and temperature corrections

- Produces a standardized `rumen_gp` object

Head 0 is reserved by the ANKOM RF system as the receiver/base station
and is automatically removed during processing.

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
