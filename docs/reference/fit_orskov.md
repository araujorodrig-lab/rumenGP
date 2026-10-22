# Fit Orskov and McDonald model

Fits the Orskov and McDonald gas-production model to each bottle in a
rumen_gp dataset.

## Usage

``` r
fit_orskov(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `VF`

  - `b`

  - `k`

## Value

An `orskov_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = VF + b \left( 1-e^{-kt} \right) \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\VF\\ is the intercept (initial gas volume)

- \\b\\ is the fermentable fraction

- \\k\\ is the fractional rate constant

### Interpretation

The Orskov and McDonald model partitions gas production into:

- An intercept term (\\VF\\)

- A fermentable fraction (\\b\\)

The asymptotic gas production is:

\$\$ VF + b \$\$

The parameter \\k\\ controls the rate at which the asymptote is
approached.

### Advantages

- Widely used in ruminant nutrition research

- Parameters have straightforward biological interpretation

- Stable convergence

- Useful benchmark model for comparison

### Limitations

- No explicit lag parameter

- Limited flexibility for highly sigmoidal fermentation profiles

- Less adaptable than Gompertz, Groot, or Dual Logistic models

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
fit_default <- fit_orskov(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Orskov and McDonald model summary
#> ---------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 

# Fit using custom starting values
fit_custom_start <- fit_orskov(
  gp_clean,
  start = list(
    VF = 5,
    b = 120,
    k = 0.05
  )
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Orskov and McDonald model summary
#> ---------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 


```
