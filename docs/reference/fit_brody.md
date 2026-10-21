# Fit Brody model

Fits the Brody gas production model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_brody(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `b`

  - `k`

## Value

A `brody_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = A \left(1 - b e^{-kt}\right) \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\b\\ is an integration constant

- \\k\\ is the fractional rate constant

### Interpretation

The Brody model describes gas production as a monotonic increase toward
an asymptotic value. The parameter \\k\\ controls the speed of
fermentation, while \\b\\ controls the initial position of the curve.

### Advantages

- Simple and robust

- Stable convergence

- Easy biological interpretation

- Useful as a baseline model

### Limitations

- No explicit lag parameter

- Less flexible than sigmoidal models

- May not adequately represent strongly sigmoidal fermentation profiles

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

# Fit using package default starting values
fit_default <- fit_brody(
  gp
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

summary(fit_default)
#> 
#> Brody model summary
#> -------------------
#> Total bottles: 25
#> Successful fits: 23
#> Failed fits: 2
#> Low R-squared (< 0.90): 2
#> 

# Fit using custom starting values
fit_custom_start <- fit_brody(
  gp,
  start = list(
    A = 120,
    b = 0.9,
    k = 0.05
  )
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3618
#> Heads: 25
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Brody model summary
#> -------------------
#> Total bottles: 25
#> Successful fits: 23
#> Failed fits: 2
#> Low R-squared (< 0.90): 2
#> 


```
