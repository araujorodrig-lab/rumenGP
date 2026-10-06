# Fit Inverse Paralogistic model

Fits the Inverse Paralogistic gas production model to each bottle in a
rumen_gp dataset.

## Usage

``` r
fit_inverse_paralogistic(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `VF`

  - `r`

  - `a`

## Value

A `inverse_paralogistic_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = VF \left( 1 + (r t)^{-a} \right)^{-a} \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\VF\\ is asymptotic gas production

- \\r\\ is the rate parameter

- \\a\\ is the shape parameter

### Interpretation

The Inverse Paralogistic model is a flexible sigmoidal model capable of
describing a wide range of gas production profiles.

The parameter \\r\\ controls the speed of gas production, while \\a\\
controls curve shape, steepness, and inflection behavior.

### Advantages

- Excellent flexibility

- Biologically interpretable parameters

- Often produces excellent fits

- Identified as one of the top-performing models in a large comparative
  study of in vitro gas production profiles

### Limitations

- Requires positive incubation times

- Shape parameter may be less intuitive than simple exponential models

- Meaningful inflection-point interpretation generally requires \\a \>
  1\\

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
fit_default <- fit_inverse_paralogistic(
  gp
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(fit_default)
#> 
#> Inverse Paralogistic model summary
#> ----------------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 5
#> 

# Fit using custom starting values
fit_custom_start <- fit_inverse_paralogistic(
  gp,
  start = list(
    VF = 120,
    r = 0.10,
    a = 2
  )
)
#> Warning: Large negative pressure values detected. Minimum PSI = -1.274 . Please inspect the affected bottles.
#> rumenGP data validation passed.
#> Observations: 1752
#> Heads: 24
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Inverse Paralogistic model summary
#> ----------------------------------
#> Total bottles: 24
#> Successful fits: 24
#> Failed fits: 0
#> Low R-squared (< 0.90): 6
#> 
```
