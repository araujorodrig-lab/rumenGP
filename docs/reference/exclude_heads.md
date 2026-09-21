# Exclude problematic ANKOM heads

Removes specified bottles while recording the exclusion information.

## Usage

``` r
exclude_heads(data, heads, reason = NULL)
```

## Arguments

- data:

  A rumen_gp object.

- heads:

  Character vector of heads to remove.

- reason:

  Character vector of exclusion reasons.

## Value

A filtered rumen_gp object.
