# Building Custom Kinetic Models

## Introduction

Most rumen gas production studies rely on a predefined set of kinetic
models.

However, researchers often wish to:

- Test novel equations
- Compare alternative model structures
- Develop new biological interpretations
- Reproduce models from the literature

rumenGP provides
[`fit_custom()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_custom.md)
for fitting user-defined nonlinear kinetic models.

Custom models integrate directly with:

- [`summary()`](https://rdrr.io/r/base/summary.html)
- [`plot_fit()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_fit.md)
- [`plot_residuals()`](https://araujorodrig-lab.github.io/rumenGP/reference/plot_residuals.md)
- [`compare_models()`](https://araujorodrig-lab.github.io/rumenGP/reference/compare_models.md)

This vignette demonstrates how to build, fit, and evaluate custom
models.

``` r

library(rumenGP)
```

## Example Dataset

Create a simple gas-production dataset.

``` r

manual_volume <- data.frame(

  Bottle = c(
    rep(1, 10),
    rep(2, 10)
  ),

  Treatment = c(
    rep("Control", 10),
    rep("Corn", 10)
  ),

  Time = rep(
    c(
      0, 2, 4, 6, 8,
      12, 16, 24, 36, 48
    ),
    2
  ),

  Gas = c(

    0, 5, 12, 20, 28,
    40, 55, 75, 90, 100,

    0, 8, 18, 30, 42,
    58, 72, 95, 110, 120

  )

)
```

Convert to a `rumen_gp` object.

``` r

gp <- as_rumen_gp(
  data = manual_volume,
  head_col = "Bottle",
  treatment_col = "Treatment",
  time_col = "Time",
  gas_col = "Gas"
)
```

## Example 1: Simple Exponential Model

Consider the equation:

``` math
Gas(t) =
A
\left(
1 -
e^{-kt}
\right)
```

where:

- A = asymptotic gas production
- k = fractional rate constant

Fit the model:

``` r

exp_fit <- fit_custom(

  data = gp,

  formula =
    Gas_mL ~
      A *
      (
        1 -
          exp(
            -k * Time_h
          )
      ),

  start = list(
    A = 120,
    k = 0.05
  ),

  lower = c(
    A = 0,
    k = 0
  ),

  model_name =
    "Simple Exponential"

)
#> rumenGP data validation passed.
#> Observations: 20
#> Heads: 2
#> Treatments: 2
```

Inspect results:

``` r

summary(exp_fit)
#> 
#> Custom model summary
#> --------------------
#> Model name: Simple Exponential
#> 
#> Formula:
#> Gas_mL ~ A * (1 - exp(-k * Time_h))
#> 
#> Total bottles: 2
#> Successful fits: 2
#> Failed fits: 0
#> Mean R-squared: 0.9948
#> Mean RMSE: 2.6455
#> Mean AIC: 53.8257
#> Mean BIC: 54.7335
```

Estimated parameters:

``` r

exp_fit$parameters
#>   Head Bottle Rep Treatment        A          k
#> 1    1      1   1   Control 129.5045 0.03253995
#> 2    2      2   1      Corn 137.3987 0.04521177
```

## Example 2: Hyperbolic Model

Consider:

``` math
Gas(t)
=
A
\left(
\frac{t}
{
t + K
}
\right)
```

where:

- A = asymptotic gas production
- K = half-time parameter

Fit the model:

``` r

hyperbolic_fit <- fit_custom(

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

  model_name =
    "Hyperbolic"

)
#> rumenGP data validation passed.
#> Observations: 20
#> Heads: 2
#> Treatments: 2
```

Inspect results:

``` r

summary(hyperbolic_fit)
#> 
#> Custom model summary
#> --------------------
#> Model name: Hyperbolic
#> 
#> Formula:
#> Gas_mL ~ A * (Time_h/(Time_h + K))
#> 
#> Total bottles: 2
#> Successful fits: 2
#> Failed fits: 0
#> Mean R-squared: 0.9922
#> Mean RMSE: 3.2766
#> Mean AIC: 58.101
#> Mean BIC: 59.0087
```

``` r

hyperbolic_fit$parameters
#>   Head Bottle Rep Treatment        A        K
#> 1    1      1   1   Control 204.2057 46.74889
#> 2    2      2   1      Corn 201.8404 30.30936
```

## Example 3: Richards Model

The Richards model is a flexible four-parameter sigmoidal equation.

``` math
Gas(t)
=
VF
\left(
1 -
b
e^{-kt}
\right)^m
```

where:

- VF = maximum gas production
- b = interaction constant
- k = fractional rate constant
- m = shape parameter

Fit the model:

``` r

richards_fit <- fit_custom(

  data = gp,

  formula =
    Gas_mL ~
      VF *
      (
        1 -
          b *
          exp(
            -k * Time_h
          )
      )^m,

  start = list(
    VF = max(gp$Gas_mL) * 1.1,
    b = 0.9,
    k = 0.05,
    m = 1
  ),

  lower = c(
    VF = 0,
    b = 0,
    k = 0,
    m = 0
  ),

  upper = c(
    VF = Inf,
    b = 1,
    k = Inf,
    m = 10
  ),

  model_name =
    "Richards"

)
#> rumenGP data validation passed.
#> Observations: 20
#> Heads: 2
#> Treatments: 2
```

Review diagnostics:

``` r

richards_fit$diagnostics
#>   Head Bottle Rep Treatment Converged     Status      RSS        R2      RMSE
#> 1    1      1   1   Control      TRUE         OK 6.803655 0.9994155 0.8248427
#> 2    2      2   1      Corn     FALSE FIT_FAILED       NA        NA        NA
#>        AIC      BIC
#> 1 34.52752 36.04044
#> 2       NA       NA
```

Review parameter estimates:

``` r

richards_fit$parameters
#>   Head Bottle Rep Treatment       VF         b         k        m
#> 1    1      1   1   Control 107.5372 0.9842168 0.0622272 1.502899
#> 2    2      2   1      Corn       NA        NA        NA       NA
```

## Comparing Custom and Built-in Models

Custom models can be compared directly with built-in models.

Fit built-in models:

``` r

groot_fit <- fit_groot(gp)
#> rumenGP data validation passed.
#> Observations: 20
#> Heads: 2
#> Treatments: 2

brody_fit <- fit_brody(gp)
#> rumenGP data validation passed.
#> Observations: 20
#> Heads: 2
#> Treatments: 2
```

Compare models:

``` r

compare_models(

  Groot = groot_fit,

  Brody = brody_fit,

  Hyperbolic = hyperbolic_fit

)
#>        Model Bottles Successful_Fits Failed_Fits   Mean_R2 Mean_RMSE  Mean_RSS
#> 1      Groot       2               2           0 0.9992273  0.973563   8.53448
#> 2      Brody       2               2           0 0.9948169  2.645485  70.05663
#> 3 Hyperbolic       2               2           0 0.9922344  3.276562 107.50559
#>   Mean_AIC Mean_BIC Lambda_Boundary
#> 1 33.05435 33.84324               0
#> 2 55.82574 57.03609               0
#> 3 58.10096 59.00872               0
```

## Visualizing Custom Models

Custom models support the standard visualization workflow.

Plot observed and predicted values:

``` r

plot_fit(
  hyperbolic_fit,
  head = 1
)
```

Plot residuals:

``` r

plot_residuals(
  hyperbolic_fit,
  head = 1
)
```

## Choosing Starting Values

Good starting values improve convergence.

Recommendations:

- Set asymptotes slightly above observed maxima
- Use biologically reasonable rate constants
- Start simple before adding parameters

Example:

``` r

start = list(
  A = 120,
  k = 0.05
)
```

## Using Bounds

Bounds can prevent unrealistic estimates.

Example:

``` r

lower = c(
  A = 0,
  k = 0
)

upper = c(
  A = Inf,
  k = Inf
)
```

## Best Practices

When proposing a new kinetic model:

1.  Use biologically meaningful parameters.
2.  Choose reasonable starting values.
3.  Apply parameter bounds when appropriate.
4.  Compare against established models.
5.  Evaluate both fit quality and parameter interpretability.

## Summary

The
[`fit_custom()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_custom.md)
framework allows researchers to evaluate new kinetic models without
modifying package source code.

Custom models can be:

- fitted,
- visualized,
- compared,
- ranked,

using exactly the same workflow as built-in models.

This makes rumenGP a flexible platform for developing and evaluating
novel rumen gas production equations.
