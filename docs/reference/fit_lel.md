# Fit Logistic-Exponential model (LEL)

Fits the Logistic-Exponential model with an explicit lag phase.

## Usage

``` r
fit_lel(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `k`

  - `d`

  - `lambda`

## Value

A `lel_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = \frac{ A \left( 1-e^{-k(t-\lambda)} \right) } { 1+\exp
\left\[ \ln\left(\frac{1}{d}\right) - k(t-\lambda) \right\] } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

- \\d\\ is a shape parameter

- \\\lambda\\ is lag time

### Interpretation

The LEL model combines an exponential fermentation component, a logistic
component, and an explicit lag phase.

This model is more flexible than traditional exponential models and can
describe complex fermentation dynamics with delayed onset of gas
production.

### Advantages

- Explicit lag parameter

- Flexible sigmoidal behavior

- Can represent delayed fermentation

- Often fits complex gas production profiles well

### Limitations

- More parameters than EXP0 or EXPL

- Greater risk of parameter correlation

- May require careful starting values

- Increased computational complexity

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
fit_default <- fit_lel(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Logistic-Exponential (LEL) model summary
#> ----------------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 18
#> Lambda at boundary: 19
#> 

# Fit using custom starting values
fit_custom_start <- fit_lel(
  gp_clean,
  start = list(
    A = 120,
    k = 0.05,
    d = 0.50,
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
#> Logistic-Exponential (LEL) model summary
#> ----------------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 15
#> Lambda at boundary: 19
#> 


```
