# Fit Groot model

Fits the Groot gas production model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_groot(data, start = NULL)
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

A `groot_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = \frac{VF} { 1+\left(\frac{b}{t}\right)^k } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\VF\\ is asymptotic gas production

- \\b\\ is the half-time parameter

- \\k\\ is the shape parameter

### Interpretation

The Groot model is a flexible sigmoidal model widely used in rumen gas
production studies.

The parameter \\b\\ represents the time required to reach approximately
half of the asymptotic gas production, while \\k\\ controls curve shape
and steepness.

### Advantages

- Excellent flexibility

- Biologically interpretable parameters

- Often produces excellent fits

- Widely used in rumen fermentation studies

### Limitations

- Requires positive incubation times

- Shape parameter may be less intuitive than simple exponential models

### Notes

The Groot model is mathematically equivalent to the generalized
Michaelis-Menten model implemented in
[`fit_mm()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_mm.md).

Parameter correspondence:

- `VF = A`

- `b = K`

- `k = c`

Both formulations produce identical fitted values, residuals,
diagnostics, AIC, BIC, RMSE, and R-squared when convergence is achieved.

Researchers may choose either formulation according to the terminology
commonly used in their field.

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
fit_default <- fit_groot(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_groot(
  gp,
  start = list(
    VF = 120,
    b = 10,
    k = 2
  )
)

summary(fit_custom_start)

} # }
```
