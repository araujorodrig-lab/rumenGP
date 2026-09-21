# Model Win Frequency

Summarizes how often each model is the best-performing model across
treatments.

## Usage

``` r
model_win_frequency(best_models)
```

## Arguments

- best_models:

  Output from
  [`best_model_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md).

## Value

A data frame summarizing the number and proportion of treatment-level
wins for each model.

## Details

Win frequency is calculated from the output of
[`best_model_by_treatment()`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md)
and reports the number of treatments for which each model achieved the
highest overall ranking.

This summary is useful for identifying models that consistently perform
well across multiple treatments.

Models with higher win frequencies generally demonstrate greater
robustness across a dataset, although treatment-specific performance
should also be considered.

## See also

[`compare_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models_by_treatment.md),
[`rank_models_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models_by_treatment.md),
[`best_model_by_treatment`](https://araujorodrig-lab.github.io/rumenGP/reference/best_model_by_treatment.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)

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

comparison <- compare_models_by_treatment(
  Groot = groot_fit,
  Gompertz = gompertz_fit
)

ranking <- rank_models_by_treatment(
  comparison
)

best_models <- best_model_by_treatment(
  ranking
)

model_win_frequency(
  best_models
)
#> # A tibble: 1 × 2
#>   Model Treatments_Won
#>   <chr>          <int>
#> 1 Groot              5
```
