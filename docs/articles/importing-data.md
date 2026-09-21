# Importing Non-ANKOM Data

## Introduction

Not all rumen gas production experiments are conducted using the ANKOM
RF Gas Production System.

rumenGP provides the function
[`as_rumen_gp()`](https://araujorodrig-lab.github.io/rumenGP/reference/as_rumen_gp.md)
for importing manually collected gas-volume data and pressure-based
datasets into the standard `rumen_gp` format.

Once imported, the data can be analyzed using the same modeling,
visualization, and model-comparison tools available for ANKOM
experiments.

``` r

library(rumenGP)
```

## Importing Gas Volume Data

The simplest workflow is to import cumulative gas production
measurements directly.

``` r

manual_volume <- data.frame(

  Bottle = c(
    1,1,1,
    2,2,2
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
    0,4,8,
    0,4,8
  ),

  Gas = c(
    0,20,40,
    0,35,60
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

These columns can have any names as long as they are specified through
the function arguments.

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
kpa
```

Examples:

``` r

pressure_unit = "psi"
```

or

``` r

pressure_unit = "kpa"
```

## Headspace Volume

Pressure measurements require information about headspace volume.

Headspace volume is the gas volume available inside the bottle and is
not necessarily the same as the total bottle volume.

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

should represent the headspace volume, not the total bottle capacity.

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
by sensor variation.

These values can be automatically corrected.

``` r

negative_pressure <- data.frame(

  Bottle = c(
    1,1,1
  ),

  Time = c(
    0,4,8
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

Imported datasets can be validated using:

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

The function checks:

- Required columns
- Missing values
- Duplicate observations
- Time ordering
- Dataset consistency

## Fitting a Model

Once imported, manually collected datasets can be analyzed exactly like
ANKOM datasets.

``` r

fit <- fit_groot(
  gp
)
#> rumenGP data validation passed.
#> Observations: 6
#> Heads: 2
#> Treatments: 2
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
#> Warning in nls.lm(par = start, fn = FCT, jac = jac, control = control, lower = lower, : lmdif: info = 0. Improper input parameters.
```

Inspect results:

``` r

summary(fit)
#> 
#> Groot model summary
#> -------------------
#> Total bottles: 2
#> Successful fits: 2
#> Failed fits: 0
#> Low R-squared (< 0.90): 2
```

## Compare Models

``` r

comparison <- compare_models(

  Groot = fit_groot(gp),

  Brody = fit_brody(gp),

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

comparison
#>      Model Bottles Successful_Fits Failed_Fits    Mean_R2   Mean_RMSE
#> 1    Groot       2               2           0 -0.8504581 15.39025685
#> 2    Brody       2               2           0  0.9999943  0.02766102
#> 3 Gompertz       2               0           2        NaN         NaN
#>       Mean_RSS  Mean_AIC  Mean_BIC Lambda_Boundary
#> 1 5.033062e+02  24.48171  19.25430               0
#> 2 4.590791e-03 -91.55179 -95.15734               0
#> 3          NaN       NaN       NaN               0
```

## Common Errors

### No gas or pressure supplied

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

### Both gas and pressure supplied

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

### Missing headspace volume

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
function makes it possible to use rumenGP with:

- Manual gas-volume datasets
- Pressure-based datasets
- Non-ANKOM experiments

Once imported, all datasets become standard `rumen_gp` objects and can
be analyzed using the full modeling framework.

## Next Steps

See:

``` r

?fit_custom
```

for information about fitting custom kinetic models.
