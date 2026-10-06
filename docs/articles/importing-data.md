# Importing Non-ANKOM Data

## Introduction

Not all rumen gas production experiments are conducted using the ANKOM
RF Gas Production System.

rumenGP provides the function
[`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)
for importing manually collected gas-volume datasets and pressure-based
datasets into the standard `rumen_gp` format.

Once imported, the data can be analyzed using the same:

- Modeling tools
- Visualization tools
- Diagnostic workflows
- Model-comparison procedures

available for ANKOM experiments.

``` r

library(rumenGP)
```

## Importing Gas-Volume Data

The simplest workflow is to import cumulative gas-production
measurements directly.

``` r

manual_volume <- data.frame(

  Bottle = c(
    1, 1, 1,
    2, 2, 2
  ),

  Treatment = c(
    "Control",
    "Control",
    "Control",
    "Corn",
    "Corn",
    "Corn"
  ),

  Time = c(
    0, 4, 8,
    0, 4, 8
  ),

  Gas = c(
    0, 20, 40,
    0, 35, 60
  )

)
```

Convert the dataset into a `rumen_gp` object:

``` r

gp <- as_rumen_gp(
  data = manual_volume,
  head_col = "Bottle",
  treatment_col = "Treatment",
  time_col = "Time",
  gas_col = "Gas"
)
```

Inspect the resulting object:

``` r

gp
#>   Head Bottle Rep Treatment Time_h Gas_mL
#> 1    1      1   1   Control      0      0
#> 2    1      1   1   Control      4     20
#> 3    1      1   1   Control      8     40
#> 4    2      2   1      Corn      0      0
#> 5    2      2   1      Corn      4     35
#> 6    2      2   1      Corn      8     60
```

Verify the class:

``` r

class(gp)
#> [1] "rumen_gp"   "data.frame"
```

## Required Columns

At minimum, gas-volume datasets must contain:

``` text
Bottle identifier
Incubation time
Gas production
```

Column names may vary and are specified through function arguments.

For example:

``` r

head_col = "Bottle"
time_col = "Time"
gas_col = "Gas"
```

## Importing Pressure Data

rumenGP can also import pressure measurements and convert them to gas
volume automatically.

``` r

manual_pressure <- data.frame(

  Bottle = rep(
    1,
    10
  ),

  Time = c(
    0,
    2,
    4,
    6,
    8,
    12,
    16,
    24,
    36,
    48
  ),

  PSI = c(
    0,
    0.2,
    0.5,
    0.8,
    1.2,
    1.8,
    2.5,
    3.2,
    4.0,
    4.5
  )

)
```

Convert pressure measurements:

``` r

gp_pressure <- as_rumen_gp(

  data = manual_pressure,

  head_col = "Bottle",

  time_col = "Time",

  pressure_col = "PSI",

  pressure_unit = "psi",

  headspace_volume = 60

)
```

Inspect the resulting gas volumes:

``` r

head(gp_pressure)
#>   Head Bottle Rep Treatment Time_h    Gas_mL
#> 1    1      1   1   Unknown      0 0.0000000
#> 2    1      1   1   Unknown      2 0.7140855
#> 3    1      1   1   Unknown      4 1.7852138
#> 4    1      1   1   Unknown      6 2.8563421
#> 5    1      1   1   Unknown      8 4.2845132
#> 6    1      1   1   Unknown     12 6.4267698
```

## Pressure Units

Currently supported pressure units are:

``` text
psi
kPa
```

Examples:

``` r

pressure_unit = "psi"
```

or

``` r

pressure_unit = "kPa"
```

## Headspace Volume

Pressure measurements require information about headspace volume.

Headspace volume represents the gas space inside the bottle and is not
necessarily the same as the total bottle volume.

Example:

``` text
Bottle volume = 125 mL

Liquid volume = 75 mL

Headspace volume = 50 mL
```

When pressure data are imported:

``` r

headspace_volume = 50
```

should represent the headspace volume and not the total bottle capacity.

## Headspace Units

Supported headspace units:

``` text
mL
L
```

Examples:

``` r

headspace_unit = "mL"
```

``` r

headspace_unit = "L"
```

## Negative Pressure Values

Pressure datasets occasionally contain slightly negative readings caused
by sensor noise or instrument variability.

These values can be automatically corrected.

``` r

negative_pressure <- data.frame(

  Bottle = c(
    1, 1, 1
  ),

  Time = c(
    0, 4, 8
  ),

  PSI = c(
    -0.5,
    0.2,
    1.0
  )

)
```

``` r

gp_negative <- as_rumen_gp(

  data = negative_pressure,

  head_col = "Bottle",

  time_col = "Time",

  pressure_col = "PSI",

  pressure_unit = "psi",

  headspace_volume = 60,

  zero_negative_pressure = TRUE

)
```

## Validation

Imported datasets should be validated before model fitting.

``` r

validate_ankom(
  gp
)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#>   Head Bottle Rep Treatment Time_h Gas_mL
#> 1    1      1   1   Control      0      0
#> 2    1      1   1   Control      4     20
#> 3    1      1   1   Control      8     40
#> 4    2      2   1      Corn      0      0
#> 5    2      2   1      Corn      4     35
#> 6    2      2   1      Corn      8     60
```

The validation procedure checks:

- Required columns
- Missing values
- Duplicate observations
- Time ordering
- Dataset consistency

## Fitting Models

Once imported, manually collected datasets can be analyzed exactly like
ANKOM datasets.

``` r

groot_fit <- fit_groot(gp)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.

mm_fit <- fit_mm(gp)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2

burr_fit <- fit_burr_xii(gp)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.

inverse_paralogistic_fit <-
  fit_inverse_paralogistic(gp)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
```

Inspect one fitted model:

``` r

summary(groot_fit)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 2
#> Successful fits: 2
#> Failed fits: 0
#> Low R-squared (< 0.90): 2
```

## Comparing Models

Model performance can be compared using several goodness-of-fit
statistics.

``` r

comparison <- compare_models(

  Groot = fit_groot(gp),

  MichaelisMenten = fit_mm(gp),

  BurrXII = fit_burr_xii(gp),

  InverseParalogistic =
    fit_inverse_paralogistic(gp),

  Gompertz = fit_gompertz(gp)

)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2

comparison
#>                 Model Bottles Successful_Fits Failed_Fits    Mean_R2 Mean_RMSE
#> 1               Groot       2               2           0 -0.8504581  15.39026
#> 2     MichaelisMenten       2               0           2        NaN       NaN
#> 3             BurrXII       2               2           0 -4.0124301  25.34022
#> 4 InverseParalogistic       2               2           0 -8.6379664  35.14058
#> 5            Gompertz       2               0           2        NaN       NaN
#>    Mean_RSS Mean_AIC Mean_BIC Lambda_Boundary
#> 1  503.3062 24.48171 19.25430               0
#> 2       NaN      NaN      NaN               0
#> 3 1352.8435 28.49555 21.96129               0
#> 4 2590.5823 27.81283 22.58542               0
#> 5       NaN      NaN      NaN               0
```

The comparison table includes:

- Mean R-squared
- Mean RMSE
- Mean RSS
- Mean AIC
- Mean BIC
- Number of successful fits

## Model Ranking

``` r

rank_models(
  comparison
)
#>                 Model Bottles Successful_Fits Failed_Fits    Mean_R2 Mean_RMSE
#> 1               Groot       2               2           0 -0.8504581  15.39026
#> 2     MichaelisMenten       2               0           2        NaN       NaN
#> 3             BurrXII       2               2           0 -4.0124301  25.34022
#> 4 InverseParalogistic       2               2           0 -8.6379664  35.14058
#> 5            Gompertz       2               0           2        NaN       NaN
#>    Mean_RSS Mean_AIC Mean_BIC Lambda_Boundary Rank_R2 Rank_RMSE Rank_AIC
#> 1  503.3062 24.48171 19.25430               0       1         1        1
#> 2       NaN      NaN      NaN               0       4         4        4
#> 3 1352.8435 28.49555 21.96129               0       2         2        3
#> 4 2590.5823 27.81283 22.58542               0       3         3        2
#> 5       NaN      NaN      NaN               0       5         5        5
#>   Rank_BIC
#> 1        1
#> 2        4
#> 3        2
#> 4        3
#> 5        5
```

## Available Models

Current built-in models include:

- Brody
- Dual Logistic
- EXP0
- EXPL
- Gompertz
- Groot
- LE0
- LEL
- Logistic
- Mitscherlich
- Generalized Michaelis-Menten
- Ørskov and McDonald
- Burr XII
- Inverse Paralogistic

## Model Equivalence

### Groot and Generalized Michaelis-Menten

The Groot and generalized Michaelis-Menten models are mathematically
equivalent.

Parameter correspondence:

- VF = A
- b = K
- k = c

Both formulations produce identical:

- Fitted values
- Residuals
- RMSE
- RSS
- AIC
- BIC
- R-squared

when convergence is achieved.

### Groot, Generalized Michaelis-Menten, and Log-logistic

The Log-logistic formulation:

``` math
V(t)
=
VF
\frac{(rt)^a}
{
1+(rt)^a
}
```

can be rewritten as:

``` math
V(t)
=
VF
\frac{t^a}
{
t^a+(1/r)^a
}
```

which is mathematically identical to both the Groot and generalized
Michaelis-Menten models.

Parameter correspondence:

| Groot | Generalized Michaelis-Menten | Log-logistic |
|-------|------------------------------|--------------|
| VF    | A                            | VF           |
| b     | K                            | 1/r          |
| k     | c                            | a            |

Therefore:

``` text
Groot
=
Generalized Michaelis-Menten
=
Log-logistic
```

These parameterizations describe the same underlying curve.

For this reason, rumenGP does not implement a separate Log-logistic
fitting routine because the curve is already represented through the
existing Groot and generalized Michaelis-Menten implementations.

## Recommended Model Selection Workflow

A practical workflow is:

``` text
1. Import and validate data

2. Fit several biologically plausible models

3. Verify convergence

4. Inspect fitted curves

5. Examine residuals

6. Compare RMSE

7. Compare AIC and BIC

8. Evaluate parameter plausibility

9. Select the most appropriate model
```

No single model should be considered universally superior.

Model performance depends on:

- Feed type
- Experimental design
- Data quality
- Fermentation profile characteristics
- Model-selection criteria

## Common Errors

### No Gas or Pressure Supplied

``` r

as_rumen_gp(
  data = my_data,
  head_col = "Bottle",
  time_col = "Time"
)
```

Produces:

``` text
Provide either gas_col or pressure_col.
```

### Both Gas and Pressure Supplied

``` r

as_rumen_gp(
  data = my_data,
  gas_col = "Gas",
  pressure_col = "PSI"
)
```

Produces:

``` text
Provide only one of gas_col or pressure_col.
```

### Missing Headspace Volume

``` r

as_rumen_gp(
  pressure_col = "PSI"
)
```

Produces:

``` text
headspace_volume must be supplied when pressure_col is used.
```

## Summary

The
[`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)
function allows rumenGP to be used with:

- Manual gas-volume datasets
- Pressure-based datasets
- Non-ANKOM experiments

Once imported, all datasets become standard `rumen_gp` objects and can
be analyzed using the complete rumenGP workflow, including:

- Fourteen built-in kinetic models
- User-defined models
- Model comparison
- Treatment-level evaluation
- Diagnostic workflows
- Visualization tools

The same modeling workflow can therefore be applied consistently across
ANKOM and non-ANKOM gas-production experiments.

## Next Steps

Additional capabilities include custom model development.

See:

``` r

?fit_custom
```

for information about fitting user-defined kinetic models.
