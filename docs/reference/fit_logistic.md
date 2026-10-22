# Fit Logistic model

Fits a Logistic gas-production model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_logistic(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `k`

  - `lambda`

## Value

A `logistic_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = \frac{A} { 1+\exp \left\[ 2+ 4k(\lambda-t) \right\] } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

- \\\lambda\\ is lag time

### Interpretation

The Logistic model describes gas production using a sigmoidal curve with
an initial lag phase, a period of rapid fermentation, and a plateau
approaching the asymptotic gas production.

The parameter \\k\\ controls the steepness of the curve, while
\\\lambda\\ determines the position of the sigmoid along the time axis.

### Advantages

- Explicit lag parameter

- Smooth sigmoidal behavior

- Stable convergence

- Widely used in biological growth and fermentation studies

### Limitations

- Assumes a symmetric sigmoidal curve

- May not adequately fit highly asymmetric fermentation profiles

- Less flexible than Gompertz or Dual Logistic models

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

# Fit using package default starting values
fit_default <- fit_logistic(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Logistic model summary
#> ----------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> Lambda at boundary: 21
#> 

# Fit using custom starting values
fit_custom_start <- fit_logistic(
  gp_clean,
  start = list(
    A = 120,
    k = 0.05,
    lambda = 1
  )
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Logistic model summary
#> ----------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 20
#> Lambda at boundary: 21
#> 


```
