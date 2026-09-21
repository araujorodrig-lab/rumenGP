# Fit Custom Nonlinear Model

Fits a user-defined nonlinear model to each bottle in a rumen_gp
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

  A rumen_gp object.

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

- Compare custom models against built-in models

- Evaluate both fit quality and parameter interpretability

## See also

[`fit_groot`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md),
[`fit_mm`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md),
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

# Hyperbolic model
custom_fit <- fit_custom(

  data = gp,

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
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
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
#> Total bottles: 24
#> Successful fits: 23
#> Failed fits: 1
#> Mean R-squared: 0.8911
#> Mean RMSE: 3.6575
#> Mean AIC: 393.3084
#> Mean BIC: 400.1798
#> 

plot_fit(
  custom_fit,
  head = 1
)


plot_residuals(
  custom_fit,
  head = 1
)
#> `geom_smooth()` using formula = 'y ~ x'


# Compare with built-in models
compare_models(
  Groot = fit_groot(gp),
  Hyperbolic = custom_fit
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5
#>        Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1      Groot      24              23           1 0.9768621  2.230506  518.1984
#> 2 Hyperbolic      24              23           1 0.8911079  3.657539 1108.4600
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 302.3719 311.4785               0
#> 2 393.3084 400.1798               0


```
