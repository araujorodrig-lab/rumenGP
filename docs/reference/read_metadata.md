# Import Metadata

Reads metadata associated with an ANKOM RF experiment.

## Usage

``` r
read_metadata(file, sheet = "metadata")
```

## Arguments

- file:

  Path to a metadata file.

- sheet:

  Sheet name containing metadata.

## Value

A data frame containing experimental metadata.

## Details

Metadata are used to identify bottles, treatments, replicates, and other
experimental information required for downstream analyses.

This function is typically used together with:

- [`read_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md)

- [`process_ankom()`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md)

as part of the standard ANKOM workflow.

## See also

[`read_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/read_ankom.md),
[`process_ankom`](https://araujorodrig-lab.github.io/rumenGP/reference/process_ankom.md),
[`validate_metadata`](https://araujorodrig-lab.github.io/rumenGP/reference/validate_metadata.md),
[`example_data`](https://araujorodrig-lab.github.io/rumenGP/reference/example_data.md)

## Examples

``` r

files <- example_data()

metadata <- read_metadata(
  files$metadata
)

head(
  metadata
)
#> # A tibble: 6 × 5
#>   Bottle  Head   Rep Treatment    pH
#>    <dbl> <dbl> <dbl> <chr>     <dbl>
#> 1      1     1     1 Plant_A    6.24
#> 2      2     2     2 Plant_A    6.22
#> 3      3     3     3 Plant_A    6.24
#> 4      4     4     4 Plant_A    6.3 
#> 5      5     5     5 Plant_A    6.15
#> 6      6     6     6 Plant_A    6.16

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
