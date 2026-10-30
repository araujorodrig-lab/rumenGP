# Fit Custom Nonlinear Model

Fits a user-defined nonlinear model to each bottle in a `rumen_gp`
dataset.

## Usage

``` r
fit_custom(
  data,
  formula,
  start,
  lower = NULL,
  upper = NULL,
  model_name = "Custom"
)
```

## Arguments

- data:

  A `rumen_gp` object.

- formula:

  A nonlinear model formula.

- start:

  Named list of starting values.

- lower:

  Optional named numeric vector of lower parameter bounds.

- upper:

  Optional named numeric vector of upper parameter bounds.

- model_name:

  Character string used to label the fitted model.

## Value

A `custom_fit` object containing:

- Model name

- Formula

- Starting values

- Parameter bounds

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Overview

This function allows researchers to fit custom nonlinear kinetic
equations using
[`minpack.lm::nlsLM()`](https://rdrr.io/pkg/minpack.lm/man/nlsLM.html).

Custom models integrate directly with:

- [`summary()`](https://rdrr.io/r/base/summary.html)

- [`plot_fit()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md)

- [`plot_residuals()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md)

- [`compare_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)

- [`rank_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/rank_models.md)

making them fully compatible with the rumenGP modeling framework.

### Formula Requirements

The model formula must:

- Use `Gas_mL` as the response variable

- Use `Time_h` as the time variable

- Include all parameters listed in `start`

Example:

    Gas_mL ~
      A *
      (
        Time_h /
        (
          Time_h + K
        )
      )

### Starting Values

Starting values are supplied through `start`.

Example:

    start = list(
      A = 150,
      K = 10
    )

Good starting values often improve convergence and reduce fitting
failures.

### Parameter Bounds

Optional lower and upper bounds may be supplied.

Example:

    lower = c(
      A = 0,
      K = 0
    )

    upper = c(
      A = 500,
      K = 100
    )

Bounds can improve stability and prevent biologically unrealistic
parameter estimates.

### Best Practices

- Start with biologically meaningful equations

- Use reasonable starting values

- Apply parameter bounds when appropriate

- Inspect convergence diagnostics

- Compare custom models against built-in models

- Evaluate both fit quality and parameter interpretability

## See also

[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md),
[`fit_mm`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md),
[`fit_burr_xii`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_burr_xii.md),
[`compare_models`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md),
[`plot_fit`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md),
[`plot_residuals`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md)

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

# Hyperbolic model
custom_fit <- fit_custom(

  data = gp_clean,

  formula =
    Gas_mL ~
      A *
      (
        Time_h /
        (
          Time_h + K
        )
      ),

  start = list(
    A = 150,
    K = 10
  ),

  lower = c(
    A = 0,
    K = 0
  ),

  model_name = "Hyperbolic"

)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(custom_fit)
#> 
#> Custom model summary
#> --------------------
#> Model name: Hyperbolic
#> 
#> Formula:
#> Gas_mL ~ A * (Time_h/(Time_h + K))
#> 
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Mean R-squared: 0.9951
#> Mean RMSE: 1.2719
#> Mean AIC: 468.4219
#> Mean BIC: 477.345
#> 

# Find a bottle with a successful fit
successful_head <-
  custom_fit$diagnostics |>
  dplyr::filter(
    Converged
  ) |>
  dplyr::slice(1) |>
  dplyr::pull(
    Head
  )

plot_fit(
  custom_fit,
  head = successful_head
)


plot_residuals(
  custom_fit,
  head = successful_head
)
#> `geom_smooth()` using formula = 'y ~ x'


# Compare against built-in models
compare_models(
  Groot = fit_groot(gp_clean),
  BurrXII = fit_burr_xii(gp_clean),
  Hyperbolic = custom_fit
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5
#>        Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE Mean_RSS
#> 1      Groot      21              21           0 0.9967168 1.0031864 152.2996
#> 2    BurrXII      21              21           0 0.9977206 0.8545103 116.2486
#> 3 Hyperbolic      21              21           0 0.9950576 1.2718832 264.6107
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 409.1374 421.0085               0
#> 2 360.5435 375.4154               0
#> 3 468.4219 477.3450               0
```
