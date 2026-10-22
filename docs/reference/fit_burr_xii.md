# Fit Burr XII model

Fits the Burr XII gas production model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_burr_xii(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `VF`

  - `r`

  - `a`

  - `p`

## Value

A `burr_xii_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = VF \left\[ 1 - (1 + (r t)^a)^{-p} \right\] \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\VF\\ is asymptotic gas production

- \\r\\ is the rate parameter

- \\a\\ is the first shape parameter

- \\p\\ is the second shape parameter

### Interpretation

The Burr XII model is a highly flexible sigmoidal model capable of
describing a wide range of gas production profiles.

The parameter \\r\\ controls the speed of gas production, while \\a\\
and \\p\\ jointly control curve shape, asymmetry, and inflection
behavior.

### Advantages

- Excellent flexibility

- Accommodates diverse curve shapes

- Often produces excellent fits

- Identified as one of the top-performing models in a large comparative
  study of in vitro gas production profiles

### Limitations

- Requires positive incubation times

- Additional parameters increase model complexity

- Greater risk of overfitting than simpler models

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
fit_default <- fit_burr_xii(
  gp_clean
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_default)
#> 
#> Burr XII model summary
#> ----------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 0
#> 

# Fit using custom starting values
fit_custom_start <- fit_burr_xii(
  gp_clean,
  start = list(
    VF = 120,
    r = 0.10,
    a = 2,
    p = 1
  )
)
#> Minor negative pressure values detected. Minimum PSI = -0.255 . These may reflect normal sensor variation.
#> rumenGP data validation passed.
#> Observations: 3038
#> Heads: 21
#> Treatments: 5

summary(fit_custom_start)
#> 
#> Burr XII model summary
#> ----------------------
#> Total bottles: 21
#> Successful fits: 21
#> Failed fits: 0
#> Low R-squared (< 0.90): 4
#> 
```
