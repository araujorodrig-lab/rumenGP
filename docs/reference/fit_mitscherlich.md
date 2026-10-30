# Fit Mitscherlich model

Fits the Mitscherlich gas-production model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_mitscherlich(data, start = NULL)
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

A `mitscherlich_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = A \left\[ 1 - \exp \left( -k(t-\lambda) - d \left(
\sqrt{t+0.001} - \sqrt{\lambda+0.001} \right) \right) \right\] \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

- \\d\\ is a diffusion or shape parameter

- \\\lambda\\ is lag time

### Interpretation

The Mitscherlich model combines an exponential fermentation component
with a diffusion-like term.

The parameter \\k\\ describes the primary fermentation rate, while \\d\\
provides additional flexibility for representing changes in fermentation
dynamics over time.

### Advantages

- Explicit lag parameter

- Flexible curve shape

- Can describe complex fermentation dynamics

- Often performs well when simple exponential models are inadequate

### Limitations

- More complex than EXP0 or EXPL

- Increased parameter correlation

- Diffusion parameter may be less intuitive biologically

- May require careful starting values

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
fit_default <- fit_mitscherlich(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Mitscherlich model summary
#> ---------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> Lambda at boundary: 9
#> 

# Fit using custom starting values
fit_custom_start <- fit_mitscherlich(
  gp_clean,
  start = list(
    A = 120,
    k = 0.05,
    d = 0.05,
    lambda = 0.50
  )
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Mitscherlich model summary
#> ---------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> Lambda at boundary: 9
#> 


```
