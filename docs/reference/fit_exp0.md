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

# Fit using package defaults
fit_default <- fit_exp0(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(fit_default)
#> 
#> Exponential model (EXP0) summary
#> --------------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 4
#> 

# Fit using user-defined starting values
fit_custom_start <- fit_exp0(
  gp,
  start = list(
    Vf = 120,
    k = 0.05
  )
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Exponential model (EXP0) summary
#> --------------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 4
#> 


```
