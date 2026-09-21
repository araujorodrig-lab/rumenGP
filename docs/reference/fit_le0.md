# Fit Logistic-Exponential model (LE0)

Fits the Logistic-Exponential model without an explicit lag phase.

## Usage

``` r
fit_le0(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `k`

  - `d`

## Value

A `le0_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = \frac{ A \left( 1-e^{-kt} \right) } { 1+\exp \left\[
\ln\left(\frac{1}{d}\right)-kt \right\] } \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

- \\d\\ is a shape parameter

### Interpretation

The LE0 model combines an exponential fermentation component with a
logistic component.

Compared with simple exponential models, LE0 provides additional
flexibility in curve shape without requiring an explicit lag parameter.

### Advantages

- Flexible sigmoidal behavior

- More adaptable than simple exponential models

- No lag parameter required

- Can accommodate gradual changes in fermentation rate

### Limitations

- More complex than EXP0

- Shape parameter may be less intuitive biologically

- Additional parameter may increase parameter correlation

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
fit_default <- fit_le0(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_le0(
  gp,
  start = list(
    A = 120,
    k = 0.05,
    d = 0.50
  )
)

summary(fit_custom_start)

} # }
```
