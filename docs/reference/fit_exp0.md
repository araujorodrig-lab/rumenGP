# Fit exponential model without lag (EXP0)

Fits the exponential gas production model without an explicit lag phase.

## Usage

``` r
fit_exp0(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `Vf`

  - `k`

## Value

An `exp0_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = Vf \left( 1 - e^{-kt} \right) \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\Vf\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

### Interpretation

The EXP0 model assumes that gas production increases exponentially
toward an asymptotic value without an explicit lag phase.

### Advantages

- Simple and computationally efficient

- Stable convergence

- Easy biological interpretation

### Limitations

- Does not model lag time

- Limited flexibility for sigmoidal fermentation profiles

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

# Fit using package defaults
fit_default <- fit_exp0(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Exponential model (EXP0) summary
#> --------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 

# Fit using user-defined starting values
fit_custom_start <- fit_exp0(
  gp_clean,
  start = list(
    Vf = 120,
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
#> Exponential model (EXP0) summary
#> --------------------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 


```
