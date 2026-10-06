# Summary of Burr XII Fits

Summarizes parameter estimates and goodness-of-fit statistics for a
fitted Burr XII model.

## Usage

``` r
# S3 method for class 'burr_xii_fit'
summary(object, ...)
```

## Arguments

- object:

  A `burr_xii_fit` object.

- ...:

  Additional arguments passed to methods.

## Value

A data frame containing parameter estimates and model diagnostics for
each fitted bottle.

## Details

The summary typically includes:

- Asymptotic gas production (`VF`)

- Rate parameter (`r`)

- Shape parameter (`a`)

- Shape parameter (`p`)

- Residual Sum of Squares (RSS)

- Root Mean Squared Error (RMSE)

- R-squared (R²)

- Akaike Information Criterion (AIC)

- Bayesian Information Criterion (BIC)

The Burr XII model is a highly flexible sigmoidal model capable of
describing diverse gas production profiles.

The parameter `r` controls the speed of gas production, while `a` and
`p` jointly control curve shape, asymmetry, and inflection behavior.

## See also

[`fit_burr_xii`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_burr_xii.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md),
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

fit <- fit_burr_xii(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(
  fit
)
#> 
#> Burr XII model summary
#> ----------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 8
#> 
```
