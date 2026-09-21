# Fit Michaelis-Menten model

Fits the generalized Michaelis-Menten model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_mm(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `K`

  - `c`

## Value

A `mm_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = A \frac{t^{c}} { t^{c}+K^{c} } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\K\\ is the half-time parameter

- \\c\\ is the shape parameter

### Interpretation

The generalized Michaelis-Menten model describes cumulative gas
production using a flexible sigmoidal function.

The parameter \\K\\ represents the time required to reach approximately
half of the asymptotic gas production, while \\c\\ controls curve shape
and steepness.

### Advantages

- Flexible sigmoidal behavior

- Biologically meaningful half-time parameter

- Usually converges reliably

- Well suited for rumen gas production data

### Limitations

- Shape parameter may be difficult to interpret biologically

- More complex than simple exponential models

### Notes

The generalized Michaelis-Menten model is mathematically equivalent to
the Groot model implemented in
[`fit_groot()`](https://araujorodrig-lab.github.io/rumenGP/reference/fit_groot.md).

Parameter correspondence:

- `A = VF`

- `K = b`

- `c = k`

Both formulations produce identical fitted values and model diagnostics
when convergence is achieved.

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
fit_default <- fit_mm(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_mm(
  gp,
  start = list(
    A = 120,
    K = 10,
    c = 2
  )
)

summary(fit_custom_start)

} # }
```
