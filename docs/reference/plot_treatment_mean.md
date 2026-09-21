# Plot treatment means across models

Compares observed and predicted treatment means across multiple fitted
models.

## Usage

``` r
plot_treatment_mean(..., treatment, show_se = TRUE)
```

## Arguments

- ...:

  Fitted model objects.

- treatment:

  Treatment name.

- show_se:

  Logical. Show observed +/- SE ribbon.

## Value

A ggplot object.
