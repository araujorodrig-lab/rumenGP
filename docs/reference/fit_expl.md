# Fit exponential model with lag (EXPL)

Fits the exponential gas production model with an explicit lag phase.

## Usage

``` r
fit_expl(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `Vf`

  - `k`

  - `lambda`

## Value

An `expl_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t) = Vf \left(1 - e^{-k(t-\lambda)}\right) \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\Vf\\ is asymptotic gas production

- \\k\\ is the fractional rate constant

- \\\lambda\\ is lag time

### Interpretation

The EXPL model assumes that gas production follows an exponential
pattern after a lag phase. The lag parameter represents the delay before
substantial fermentation begins.

### Advantages

- Explicit lag parameter

- Simple biological interpretation

- Stable convergence

### Limitations

- Less flexible than sigmoidal models

- May not adequately represent multiple fermentation phases

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
fit_default <- fit_expl(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_expl(
  gp,
  start = list(
    Vf = 120,
    k = 0.05,
    lambda = 1
  )
)

summary(fit_custom_start)

} # }
```
