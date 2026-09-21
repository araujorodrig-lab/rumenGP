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
if (FALSE) { # \dontrun{

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

# Fit using package default starting values
fit_default <- fit_logistic(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_logistic(
  gp,
  start = list(
    A = 120,
    k = 0.05,
    lambda = 1
  )
)

summary(fit_custom_start)

} # }
```
