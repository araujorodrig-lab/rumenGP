# Fit dual-pool logistic model

Fits a dual-pool logistic model representing rapidly and slowly
degradable fractions.

## Usage

``` r
fit_dual_logistic(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `V1F`

  - `V2F`

  - `k1`

  - `k2`

  - `lambda`

## Value

A `dual_logistic_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

- Rapid and slow pool estimates

## Details

### Equation

\$\$ V(t)= \frac{V1F} { 1+\exp\left\[2-4k1(t-\lambda)\right\] } +
\frac{V2F} { 1+\exp\left\[2-4k2(t-\lambda)\right\] } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\V1F\\ is the final gas volume from the rapidly fermentable fraction

- \\V2F\\ is the final gas volume from the slowly fermentable fraction

- \\k1\\ is the fractional rate constant of the rapid fraction

- \\k2\\ is the fractional rate constant of the slow fraction

- \\\lambda\\ is lag time

### Interpretation

The Dual Logistic model assumes that gas production originates from two
independent fermentation pools:

- A rapidly degradable fraction (\\V1F\\)

- A slowly degradable fraction (\\V2F\\)

Each fraction follows a logistic fermentation pattern with its own rate
constant.

### Advantages

- Represents complex fermentation dynamics

- Separates rapid and slow fermentation pools

- Biologically meaningful parameterization

- Useful for heterogeneous substrates

### Limitations

- Requires estimation of five parameters

- More computationally demanding

- Greater risk of parameter correlation

- May require careful starting values

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
fit_default <- fit_dual_logistic(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_dual_logistic(
  gp,
  start = list(
    V1F = 30,
    V2F = 70,
    k1 = 0.20,
    k2 = 0.05,
    lambda = 0.50
  )
)

summary(fit_custom_start)

} # }
```
