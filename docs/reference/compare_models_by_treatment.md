# Compare Models by Treatment

Calculates model performance separately for each treatment.

## Usage

``` r
compare_models_by_treatment(...)
```

## Arguments

- ...:

  Fitted model objects.

## Value

A data frame containing treatment-level performance metrics for each
fitted model.

## Details

Performance metrics are computed using treatment-level predictions and
observations, allowing direct comparison of competing models within each
treatment.

Typical metrics include:

- R-squared (R²)

- Root Mean Squared Error (RMSE)

- Residual Sum of Squares (RSS)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

This function is useful for determining whether different treatments are
best described by different kinetic models.

## See also

[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`rank_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md),
[`best_model_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md),
[`model_win_frequency`](https://araujorodrig-lab.github.io/rumenGP/reference/model_win_frequency.md)

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

groot_fit <- fit_groot(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

gompertz_fit <- fit_gompertz(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

compare_models_by_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)
#> # A tibble: 10 × 6
#>    Treatment Model    Mean_R2 Mean_RMSE Mean_AIC Mean_BIC
#>    <chr>     <chr>      <dbl>     <dbl>    <dbl>    <dbl>
#>  1 BLANK     Groot      0.969     0.943     201.     210.
#>  2 Plant_A   Groot      0.968     2.40      287.     297.
#>  3 Plant_B   Groot      0.990     2.27      315.     324.
#>  4 Plant_C   Groot      0.974     2.22      320.     329.
#>  5 TMR       Groot      0.988     3.14      377.     386.
#>  6 BLANK     Gompertz   0.942     2.02      294.     303.
#>  7 Plant_A   Gompertz   0.935     5.11      421.     430.
#>  8 Plant_B   Gompertz   0.810     4.35      411.     420.
#>  9 Plant_C   Gompertz   0.959     3.84      392.     401.
#> 10 TMR       Gompertz   0.957     5.83      464.     473.
```
