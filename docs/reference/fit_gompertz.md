# Fit Gompertz model

Fits the Zwietering-modified Gompertz model to each bottle in a rumen_gp
dataset.

## Usage

``` r
fit_gompertz(data, start = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- start:

  Optional list of starting values. May contain any of:

  - `A`

  - `mu`

  - `lambda`

## Value

A `gompertz_fit` object containing:

- Parameter estimates

- Model diagnostics

- Predicted values

- Residuals

## Details

### Equation

\$\$ V(t)= A \exp \left\[ - \exp \left( \frac{\mu e}{A} (\lambda-t) + 1
\right) \right\] \$\$

where:

- \\V(t)\\ is cumulative gas production at time \\t\\

- \\A\\ is asymptotic gas production

- \\\mu\\ is the maximum gas production rate

- \\\lambda\\ is lag time

- \\e\\ is Euler's number

### Interpretation

The modified Gompertz model is one of the most commonly used models for
gas production kinetics.

It explicitly estimates:

- Final gas production potential (\\A\\)

- Maximum gas production rate (\\\mu\\)

- Lag time (\\\lambda\\)

making it biologically informative and easy to interpret.

### Advantages

- Explicit lag parameter

- Explicit maximum gas production rate

- Excellent flexibility

- Widely used in gas production studies

- Strong biological interpretation

### Limitations

- More computationally demanding than simple exponential models

- Parameters may exhibit correlation in some datasets

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
fit_default <- fit_gompertz(
  gp
)

summary(fit_default)

# Fit using custom starting values
fit_custom_start <- fit_gompertz(
  gp,
  start = list(
    A = 120,
    mu = 5,
    lambda = 1
  )
)

summary(fit_custom_start)

} # }
```
